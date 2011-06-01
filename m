Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758883Ab1FAMOj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 08:14:39 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:33083 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657Ab1FAMOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 08:14:38 -0400
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
To: linux-kernel@vger.kernel.org
Cc: kay.sievers@vrfy.org, Lucas De Marchi <lucas.demarchi@profusion.mobi>
Subject: [PATCH] sysctl: add support for poll()
Date: Wed,  1 Jun 2011 09:14:36 -0300
Message-Id: <1306930476-1899-1-git-send-email-lucas.demarchi@profusion.mobi>
X-Mailer: git-send-email 1.7.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding support for poll() in sysctl fs allows userspace to receive
notifications when an entry in sysctl changes. This way it's possible to
know when hostname/domainname is changed due to the respective syscall
has been called or its file under /proc/sys has been written to.

Signed-off-by: Lucas De Marchi <lucas.demarchi@profusion.mobi>
---
 fs/proc/proc_sysctl.c   |   40 ++++++++++++++++++++++++++++++++++++++++
 include/linux/sysctl.h  |    8 ++++++++
 include/linux/utsname.h |   16 ++++++++++++++++
 kernel/sys.c            |    2 ++
 kernel/utsname_sysctl.c |   36 ++++++++++++++++++++++++++++++++++++
 5 files changed, 102 insertions(+), 0 deletions(-)

diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index f50133c..2e5d3ec 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -3,6 +3,7 @@
  */
 #include <linux/init.h>
 #include <linux/sysctl.h>
+#include <linux/poll.h>
 #include <linux/proc_fs.h>
 #include <linux/security.h>
 #include <linux/namei.h>
@@ -176,6 +177,43 @@ static ssize_t proc_sys_write(struct file *filp, const char __user *buf,
 	return proc_sys_call_handler(filp, (void __user *)buf, count, ppos, 1);
 }
 
+static int proc_sys_open(struct inode *inode, struct file *filp)
+{
+	struct ctl_table *table = PROC_I(inode)->sysctl_entry;
+
+	if (table->poll) {
+		unsigned long event = atomic_read(&table->poll->event);
+
+		filp->private_data = (void *)event;
+	}
+
+	return 0;
+}
+
+static unsigned int proc_sys_poll(struct file *filp, poll_table *wait)
+{
+	struct inode *inode = filp->f_path.dentry->d_inode;
+	struct ctl_table *table = PROC_I(inode)->sysctl_entry;
+	unsigned long event = (unsigned long)filp->private_data;
+	unsigned int ret = POLLIN | POLLRDNORM;
+
+	if (!table->proc_handler)
+		goto out;
+
+	if (!table->poll)
+		goto out;
+
+	poll_wait(filp, &table->poll->wait, wait);
+
+	if (event != atomic_read(&table->poll->event)) {
+		filp->private_data = (void *)(unsigned long)atomic_read(
+						&table->poll->event);
+		ret = POLLIN | POLLRDNORM | POLLERR | POLLPRI;
+	}
+
+out:
+	return ret;
+}
 
 static int proc_sys_fill_cache(struct file *filp, void *dirent,
 				filldir_t filldir,
@@ -367,6 +405,8 @@ static int proc_sys_getattr(struct vfsmount *mnt, struct dentry *dentry, struct
 }
 
 static const struct file_operations proc_sys_file_operations = {
+	.open		= proc_sys_open,
+	.poll		= proc_sys_poll,
 	.read		= proc_sys_read,
 	.write		= proc_sys_write,
 	.llseek		= default_llseek,
diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index 11684d9..96c89ba 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -25,6 +25,7 @@
 #include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/compiler.h>
+#include <linux/wait.h>
 
 struct completion;
 
@@ -1011,6 +1012,12 @@ extern int proc_do_large_bitmap(struct ctl_table *, int,
  * cover common cases.
  */
 
+/* Support for userspace poll() to watch for changes */
+struct ctl_table_poll {
+	atomic_t event;
+	wait_queue_head_t wait;
+};
+
 /* A sysctl table is an array of struct ctl_table: */
 struct ctl_table 
 {
@@ -1021,6 +1028,7 @@ struct ctl_table
 	struct ctl_table *child;
 	struct ctl_table *parent;	/* Automatically set */
 	proc_handler *proc_handler;	/* Callback for text formatting */
+	struct ctl_table_poll *poll;
 	void *extra1;
 	void *extra2;
 };
diff --git a/include/linux/utsname.h b/include/linux/utsname.h
index 4e5b021..c714ed7 100644
--- a/include/linux/utsname.h
+++ b/include/linux/utsname.h
@@ -37,6 +37,14 @@ struct new_utsname {
 #include <linux/nsproxy.h>
 #include <linux/err.h>
 
+enum uts_proc {
+	UTS_PROC_OSTYPE,
+	UTS_PROC_OSRELEASE,
+	UTS_PROC_VERSION,
+	UTS_PROC_HOSTNAME,
+	UTS_PROC_DOMAINNAME,
+};
+
 struct user_namespace;
 extern struct user_namespace init_user_ns;
 
@@ -80,6 +88,14 @@ static inline struct uts_namespace *copy_utsname(unsigned long flags,
 }
 #endif
 
+#ifdef CONFIG_PROC_SYSCTL
+extern void uts_proc_notify(enum uts_proc proc);
+#else
+static inline void uts_proc_notify(enum uts_proc proc)
+{
+}
+#endif
+
 static inline struct new_utsname *utsname(void)
 {
 	return &current->nsproxy->uts_ns->name;
diff --git a/kernel/sys.c b/kernel/sys.c
index e4128b2..ada9cd7 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1211,6 +1211,7 @@ SYSCALL_DEFINE2(sethostname, char __user *, name, int, len)
 		memset(u->nodename + len, 0, sizeof(u->nodename) - len);
 		errno = 0;
 	}
+	uts_proc_notify(UTS_PROC_HOSTNAME);
 	up_write(&uts_sem);
 	return errno;
 }
@@ -1261,6 +1262,7 @@ SYSCALL_DEFINE2(setdomainname, char __user *, name, int, len)
 		memset(u->domainname + len, 0, sizeof(u->domainname) - len);
 		errno = 0;
 	}
+	uts_proc_notify(UTS_PROC_DOMAINNAME);
 	up_write(&uts_sem);
 	return errno;
 }
diff --git a/kernel/utsname_sysctl.c b/kernel/utsname_sysctl.c
index a2cd77e..e96b766 100644
--- a/kernel/utsname_sysctl.c
+++ b/kernel/utsname_sysctl.c
@@ -13,6 +13,7 @@
 #include <linux/uts.h>
 #include <linux/utsname.h>
 #include <linux/sysctl.h>
+#include <linux/wait.h>
 
 static void *get_uts(ctl_table *table, int write)
 {
@@ -51,12 +52,28 @@ static int proc_do_uts_string(ctl_table *table, int write,
 	uts_table.data = get_uts(table, write);
 	r = proc_dostring(&uts_table,write,buffer,lenp, ppos);
 	put_uts(table, write, uts_table.data);
+
+	if (write) {
+		atomic_inc(&table->poll->event);
+		wake_up_interruptible(&table->poll->wait);
+	}
+
 	return r;
 }
 #else
 #define proc_do_uts_string NULL
 #endif
 
+static struct ctl_table_poll hostname_poll = {
+	.event		= ATOMIC_INIT(0),
+	.wait		= __WAIT_QUEUE_HEAD_INITIALIZER(hostname_poll.wait),
+};
+
+static struct ctl_table_poll domainname_poll = {
+	.event		= ATOMIC_INIT(0),
+	.wait		= __WAIT_QUEUE_HEAD_INITIALIZER(domainname_poll.wait),
+};
+
 static struct ctl_table uts_kern_table[] = {
 	{
 		.procname	= "ostype",
@@ -85,6 +102,7 @@ static struct ctl_table uts_kern_table[] = {
 		.maxlen		= sizeof(init_uts_ns.name.nodename),
 		.mode		= 0644,
 		.proc_handler	= proc_do_uts_string,
+		.poll		= &hostname_poll,
 	},
 	{
 		.procname	= "domainname",
@@ -92,6 +110,7 @@ static struct ctl_table uts_kern_table[] = {
 		.maxlen		= sizeof(init_uts_ns.name.domainname),
 		.mode		= 0644,
 		.proc_handler	= proc_do_uts_string,
+		.poll		= &domainname_poll,
 	},
 	{}
 };
@@ -105,6 +124,23 @@ static struct ctl_table uts_root_table[] = {
 	{}
 };
 
+#ifdef CONFIG_PROC_SYSCTL
+/*
+ * Notify userspace about a change in a certain entry of uts_kern_table,
+ * identified by the parameter proc.
+ */
+void uts_proc_notify(enum uts_proc proc)
+{
+	struct ctl_table *table = &uts_kern_table[proc];
+
+	if (!table->poll)
+		return;
+
+	atomic_inc(&table->poll->event);
+	wake_up_interruptible(&table->poll->wait);
+}
+#endif
+
 static int __init utsname_sysctl_init(void)
 {
 	register_sysctl_table(uts_root_table);
-- 
1.7.5.2

