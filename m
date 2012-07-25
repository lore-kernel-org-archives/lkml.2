Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab2GYJzo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 05:55:44 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:50550 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752704Ab2GYJzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 05:55:41 -0400
Message-Id: <20120725095024.842540518@openvz.org>
User-Agent: quilt/0.48-1
Date: Wed, 25 Jul 2012 13:47:21 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [patch 3/7] procfs: Add ability to plug in auxiliary fdinfo providers
References: <20120725094718.089879534@openvz.org>
Content-Disposition: inline; filename=seq-fdinfo-seq-ops-helpers-6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch brings ability to plug in auxiliary fdinfo providers.
For example in further patches eventfd, evenpoll and fsnotify
will print out information associated with files.

This feature is CONFIG_CHECKPOINT_RESTORE guarded to eliminate
overhead for those who don't need it at all (this
unfortunately makes patch bigger than I wanted).

The basic usage rule is the following

 - fdinfo provider should register own "show" method
   via proc_register_fdinfo_driver call, where "show"
   methods are rather well known seq-file operations

 - once the kernel opens /proc/$pid/fdinfo/$fd file
   it calls for ->probe() method in registered fdinfo
   drivers, and if probe success, then seq-file "show"
   operations will be called to provide out additional
   infomation

Initially we considered to inject some "show" metod to
file_operations but since there really a number of
file_operations declared inside kernel (and in real the
further patches cover onle eventfd/epoll/inotify) the
waste of memory space will be inacceptable I think.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Al Viro <viro@ZenIV.linux.org.uk>
CC: Alexey Dobriyan <adobriyan@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Pavel Emelyanov <xemul@parallels.com>
CC: James Bottomley <jbottomley@parallels.com>
---
 fs/proc/fd.c            |  200 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/proc_fs.h |   26 ++++++
 2 files changed, 226 insertions(+)

Index: linux-2.6.git/fs/proc/fd.c
===================================================================
--- linux-2.6.git.orig/fs/proc/fd.c
+++ linux-2.6.git/fs/proc/fd.c
@@ -8,12 +8,210 @@
 #include <linux/security.h>
 #include <linux/file.h>
 #include <linux/seq_file.h>
+#include <linux/spinlock.h>
 
 #include <linux/proc_fs.h>
 
 #include "internal.h"
 #include "fd.h"
 
+#ifdef CONFIG_CHECKPOINT_RESTORE
+
+static LIST_HEAD(fdinfo_drivers);
+static DECLARE_RWSEM(fdinfo_drivers_sem);
+
+int proc_register_fdinfo_driver(struct proc_fdinfo_driver *s)
+{
+	struct proc_fdinfo_driver *i;
+	int ret = 0;
+
+	if (!s->ops || !s->probe)
+		return -EINVAL;
+
+	down_write(&fdinfo_drivers_sem);
+	list_for_each_entry(i, &fdinfo_drivers, list) {
+		if (i == s) {
+			WARN_ONCE("Trying reassign fdinfo driver `%s'\n",
+				  i->name);
+			ret = -EINVAL;
+			break;
+		}
+	}
+	if (!ret)
+		list_add(&s->list, &fdinfo_drivers);
+	up_write(&fdinfo_drivers_sem);
+
+	return ret;
+}
+
+void proc_unregister_fdinfo_driver(struct proc_fdinfo_driver *s)
+{
+	struct proc_fdinfo_driver *i, *tmp;
+
+	down_write(&fdinfo_drivers_sem);
+	list_for_each_entry_safe(i, tmp, &fdinfo_drivers, list) {
+		if (i == s) {
+			list_del(&i->list);
+			break;
+		}
+	}
+	up_write(&fdinfo_drivers_sem);
+}
+
+static int prep_fdinfo_driver(struct proc_fdinfo_extra *extra)
+{
+	struct proc_fdinfo_driver *s;
+
+	down_read(&fdinfo_drivers_sem);
+	list_for_each_entry(s, &fdinfo_drivers, list) {
+		if (s->probe(extra->f_file)) {
+			extra->driver = s;
+			break;
+		}
+	}
+	up_read(&fdinfo_drivers_sem);
+
+	return 0;
+}
+
+static void *seq_start(struct seq_file *m, loff_t *pos)
+{
+	struct proc_fdinfo_extra *extra = m->private;
+
+	down_read(&fdinfo_drivers_sem);
+	extra->pos = *pos;
+
+	return *pos == 0 ? extra :
+		(extra->driver ? extra->driver->ops->start(m, pos) : NULL);
+}
+
+static void seq_stop(struct seq_file *m, void *v)
+{
+	struct proc_fdinfo_extra *extra = m->private;
+
+	if (extra->driver && extra->pos > 0)
+		extra->driver->ops->stop(m, v);
+	up_read(&fdinfo_drivers_sem);
+}
+
+static void *seq_next(struct seq_file *m, void *p, loff_t *pos)
+{
+	struct proc_fdinfo_extra *extra = m->private;
+	void *v = NULL;
+
+	if (extra->driver) {
+		int ret = 0;
+
+		if (*pos == 0) {
+			v = extra->driver->ops->start(m, pos);
+			if (v) {
+				ret = extra->driver->ops->show(m, v);
+				p = v;
+			} else
+				ret = -1;
+		}
+
+		if (!ret)
+			v = extra->driver->ops->next(m, p, pos);
+	} else
+		++*pos;
+
+	extra->pos = *pos;
+	return v;
+}
+
+static int seq_show(struct seq_file *m, void *v)
+{
+	struct proc_fdinfo_extra *extra = m->private;
+
+	if (extra->driver && extra->pos > 0)
+		return extra->driver->ops->show(m, v);
+
+	seq_printf(m, "pos:\t%lli\nflags:\t0%o\n",
+		   (long long)extra->f_file->f_pos,
+		   extra->f_flags);
+	return 0;
+}
+
+static const struct seq_operations fdinfo_seq_ops = {
+	.start	= seq_start,
+	.next	= seq_next,
+	.stop	= seq_stop,
+	.show	= seq_show,
+};
+
+static int seq_fdinfo_open(struct inode *inode, struct file *file)
+{
+	struct files_struct *files = NULL;
+	struct proc_fdinfo_extra *extra;
+	struct task_struct *task;
+	struct seq_file *m;
+	int ret;
+
+	extra = kzalloc(sizeof(*extra), GFP_KERNEL);
+	if (!extra)
+		return -ENOMEM;
+
+	ret = seq_open(file, &fdinfo_seq_ops);
+	if (!ret) {
+		ret = -ENOENT;
+		m = file->private_data;
+		m->private = extra;
+
+		task = get_proc_task(inode);
+		if (task) {
+			files = get_files_struct(task);
+			put_task_struct(task);
+		}
+
+		if (files) {
+			int fd = proc_fd(inode);
+
+			spin_lock(&files->file_lock);
+			extra->f_file = fcheck_files(files, fd);
+			if (extra->f_file) {
+				struct fdtable *fdt = files_fdtable(files);
+
+				extra->f_flags = extra->f_file->f_flags & ~O_CLOEXEC;
+				if (close_on_exec(fd, fdt))
+					extra->f_flags |= O_CLOEXEC;
+				get_file(extra->f_file);
+			}
+			spin_unlock(&files->file_lock);
+			put_files_struct(files);
+
+			ret = prep_fdinfo_driver(extra);
+		}
+	}
+
+	if (ret) {
+		if (extra->f_file)
+			put_filp(extra->f_file);
+		kfree(extra);
+	}
+	return ret;
+}
+
+static int seq_fdinfo_release(struct inode *inode, struct file *file)
+{
+	struct seq_file *m = file->private_data;
+	struct proc_fdinfo_extra *extra = m->private;
+
+	put_filp(extra->f_file);
+	kfree(m->private);
+
+	return seq_release(inode, file);
+}
+
+static const struct file_operations proc_fdinfo_file_operations = {
+	.open		= seq_fdinfo_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_fdinfo_release,
+};
+
+#else /* CONFIG_CHECKPOINT_RESTORE */
+
 struct proc_fdinfo {
 	loff_t	f_pos;
 	int	f_flags;
@@ -90,6 +288,8 @@ static const struct file_operations proc
 	.release	= seq_fdinfo_release,
 };
 
+#endif /* CONFIG_CHECKPOINT_RESTORE */
+
 static int tid_fd_revalidate(struct dentry *dentry, struct nameidata *nd)
 {
 	struct files_struct *files;
Index: linux-2.6.git/include/linux/proc_fs.h
===================================================================
--- linux-2.6.git.orig/include/linux/proc_fs.h
+++ linux-2.6.git/include/linux/proc_fs.h
@@ -100,6 +100,24 @@ struct vmcore {
 	loff_t offset;
 };
 
+struct seq_operations;
+
+/* fdinfo auxiliary information drivers */
+struct proc_fdinfo_driver {
+	struct list_head		list;
+	const char			*name;
+	const struct seq_operations	*ops;
+	int				(*probe)(struct file *file);
+};
+
+/* auxiliary data allocated per fdinfo reader */
+struct proc_fdinfo_extra {
+	struct proc_fdinfo_driver	*driver;
+	loff_t				pos;
+	struct file			*f_file;
+	unsigned int			f_flags;
+};
+
 #ifdef CONFIG_PROC_FS
 
 extern void proc_root_init(void);
@@ -175,6 +193,11 @@ extern struct proc_dir_entry *proc_net_m
 
 extern struct file *proc_ns_fget(int fd);
 
+#ifdef CONFIG_CHECKPOINT_RESTORE
+extern int proc_register_fdinfo_driver(struct proc_fdinfo_driver *s);
+extern void proc_unregister_fdinfo_driver(struct proc_fdinfo_driver *s);
+#endif /* CONFIG_CHECKPOINT_RESTORE */
+
 #else
 
 #define proc_net_fops_create(net, name, mode, fops)  ({ (void)(mode), NULL; })
@@ -229,6 +252,9 @@ static inline struct file *proc_ns_fget(
 	return ERR_PTR(-EINVAL);
 }
 
+static inline int proc_register_fdinfo_driver(struct proc_fdinfo_driver *s) { return -EINVAL; }
+static inline void proc_unregister_fdinfo_driver(struct proc_fdinfo_driver *s) { }
+
 #endif /* CONFIG_PROC_FS */
 
 #if !defined(CONFIG_PROC_KCORE)

