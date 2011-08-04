Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607Ab1HDS6E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 14:58:04 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:59967 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754623Ab1HDS55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 14:57:57 -0400
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
To: Greg KH <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        Nick Piggin <npiggin@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@lst.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        David Howells <dhowells@redhat.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        Daniel Lezcano <daniel.lezcano@free.fr>, Jiri Slaby <jslaby@suse.cz>,
        James Morris <jmorris@namei.org>, neilb@suse.de
Cc: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Subject: [PATCH] sysctl: add support for poll()
Date: Thu,  4 Aug 2011 15:57:18 -0300
Message-Id: <1312484238-1645-1-git-send-email-lucas.demarchi@profusion.mobi>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <CAMOw1v6uCMhgErrfPLQ5CSa0v_OoHhJ=M3OCL+YH9H1Zg5fEXQ@mail.gmail.com>
References: <CAMOw1v6uCMhgErrfPLQ5CSa0v_OoHhJ=M3OCL+YH9H1Zg5fEXQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding support for poll() in sysctl fs allows userspace to receive
notifications of changes in sysctl entries. This adds a infrastructure
to allow files in sysctl fs to be pollable and implements it for
hostname and domainname.

Signed-off-by: Lucas De Marchi <lucas.demarchi@profusion.mobi>
---
 fs/proc/proc_sysctl.c   |   45 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/sysctl.h  |   22 ++++++++++++++++++++++
 include/linux/utsname.h |   16 ++++++++++++++++
 kernel/sys.c            |    2 ++
 kernel/utsname_sysctl.c |   23 +++++++++++++++++++++++
 5 files changed, 108 insertions(+), 0 deletions(-)

diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index 1a77dbe..ae8bcd3 100644
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
@@ -14,6 +15,15 @@ static const struct inode_operations proc_sys_inode_operations;
 static const struct file_operations proc_sys_dir_file_operations;
 static const struct inode_operations proc_sys_dir_operations;
 
+void proc_sys_poll_notify(struct ctl_table_poll *poll)
+{
+	if (!poll)
+		return;
+
+	atomic_inc(&poll->event);
+	wake_up_interruptible(&poll->wait);
+}
+
 static struct inode *proc_sys_make_inode(struct super_block *sb,
 		struct ctl_table_header *head, struct ctl_table *table)
 {
@@ -176,6 +186,39 @@ static ssize_t proc_sys_write(struct file *filp, const char __user *buf,
 	return proc_sys_call_handler(filp, (void __user *)buf, count, ppos, 1);
 }
 
+static int proc_sys_open(struct inode *inode, struct file *filp)
+{
+	struct ctl_table *table = PROC_I(inode)->sysctl_entry;
+
+	if (table->poll)
+		filp->private_data = proc_sys_poll_event(table->poll);
+
+	return 0;
+}
+
+static unsigned int proc_sys_poll(struct file *filp, poll_table *wait)
+{
+	struct inode *inode = filp->f_path.dentry->d_inode;
+	struct ctl_table *table = PROC_I(inode)->sysctl_entry;
+	unsigned long event = (unsigned long)filp->private_data;
+	unsigned int ret = DEFAULT_POLLMASK;
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
+		filp->private_data = proc_sys_poll_event(table->poll);
+		ret = POLLIN | POLLRDNORM | POLLERR | POLLPRI;
+	}
+
+out:
+	return ret;
+}
 
 static int proc_sys_fill_cache(struct file *filp, void *dirent,
 				filldir_t filldir,
@@ -364,6 +407,8 @@ static int proc_sys_getattr(struct vfsmount *mnt, struct dentry *dentry, struct
 }
 
 static const struct file_operations proc_sys_file_operations = {
+	.open		= proc_sys_open,
+	.poll		= proc_sys_poll,
 	.read		= proc_sys_read,
 	.write		= proc_sys_write,
 	.llseek		= default_llseek,
diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index 11684d9..b6820cc 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -931,6 +931,7 @@ enum
 #ifdef __KERNEL__
 #include <linux/list.h>
 #include <linux/rcupdate.h>
+#include <linux/wait.h>
 
 /* For the /proc/sys support */
 struct ctl_table;
@@ -1011,6 +1012,26 @@ extern int proc_do_large_bitmap(struct ctl_table *, int,
  * cover common cases.
  */
 
+/* Support for userspace poll() to watch for changes */
+struct ctl_table_poll {
+	atomic_t event;
+	wait_queue_head_t wait;
+};
+
+static inline void *proc_sys_poll_event(struct ctl_table_poll *poll)
+{
+	return (void *)(unsigned long)atomic_read(&poll->event);
+}
+
+void proc_sys_poll_notify(struct ctl_table_poll *poll);
+
+#define __CTL_TABLE_POLL_INITIALIZER(name) {				\
+	.event = ATOMIC_INIT(0),					\
+	.wait = __WAIT_QUEUE_HEAD_INITIALIZER(name.wait) }
+
+#define DECLARE_CTL_TABLE_POLL(name)					\
+	struct ctl_table_poll name = __CTL_TABLE_POLL_INITIALIZER(name)
+
 /* A sysctl table is an array of struct ctl_table: */
 struct ctl_table 
 {
@@ -1021,6 +1042,7 @@ struct ctl_table
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
index a101ba3..2347043 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1241,6 +1241,7 @@ SYSCALL_DEFINE2(sethostname, char __user *, name, int, len)
 		memset(u->nodename + len, 0, sizeof(u->nodename) - len);
 		errno = 0;
 	}
+	uts_proc_notify(UTS_PROC_HOSTNAME);
 	up_write(&uts_sem);
 	return errno;
 }
@@ -1291,6 +1292,7 @@ SYSCALL_DEFINE2(setdomainname, char __user *, name, int, len)
 		memset(u->domainname + len, 0, sizeof(u->domainname) - len);
 		errno = 0;
 	}
+	uts_proc_notify(UTS_PROC_DOMAINNAME);
 	up_write(&uts_sem);
 	return errno;
 }
diff --git a/kernel/utsname_sysctl.c b/kernel/utsname_sysctl.c
index a2cd77e..21d4b79 100644
--- a/kernel/utsname_sysctl.c
+++ b/kernel/utsname_sysctl.c
@@ -13,6 +13,7 @@
 #include <linux/uts.h>
 #include <linux/utsname.h>
 #include <linux/sysctl.h>
+#include <linux/wait.h>
 
 static void *get_uts(ctl_table *table, int write)
 {
@@ -51,12 +52,19 @@ static int proc_do_uts_string(ctl_table *table, int write,
 	uts_table.data = get_uts(table, write);
 	r = proc_dostring(&uts_table,write,buffer,lenp, ppos);
 	put_uts(table, write, uts_table.data);
+
+	if (write)
+		proc_sys_poll_notify(table->poll);
+
 	return r;
 }
 #else
 #define proc_do_uts_string NULL
 #endif
 
+static DECLARE_CTL_TABLE_POLL(hostname_poll);
+static DECLARE_CTL_TABLE_POLL(domainname_poll);
+
 static struct ctl_table uts_kern_table[] = {
 	{
 		.procname	= "ostype",
@@ -85,6 +93,7 @@ static struct ctl_table uts_kern_table[] = {
 		.maxlen		= sizeof(init_uts_ns.name.nodename),
 		.mode		= 0644,
 		.proc_handler	= proc_do_uts_string,
+		.poll		= &hostname_poll,
 	},
 	{
 		.procname	= "domainname",
@@ -92,6 +101,7 @@ static struct ctl_table uts_kern_table[] = {
 		.maxlen		= sizeof(init_uts_ns.name.domainname),
 		.mode		= 0644,
 		.proc_handler	= proc_do_uts_string,
+		.poll		= &domainname_poll,
 	},
 	{}
 };
@@ -105,6 +115,19 @@ static struct ctl_table uts_root_table[] = {
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
+	proc_sys_poll_notify(table->poll);
+}
+#endif
+
 static int __init utsname_sysctl_init(void)
 {
 	register_sysctl_table(uts_root_table);
-- 
1.7.6

