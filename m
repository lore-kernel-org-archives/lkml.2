Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751811Ab1CXETL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 00:19:11 -0400
Received: from srv04.jarevo.de ([88.198.54.146]:65028 "EHLO srv04.jarevo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750871Ab1CXETJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 00:19:09 -0400
X-Greylist: delayed 560 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Mar 2011 00:19:09 EDT
Message-ID: <4D8AC408.9000503@nachtgeist.net>
Date: Thu, 24 Mar 2011 05:09:44 +0100
From: Daniel Reichelt <debian@nachtgeist.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110307 Icedove/3.0.11
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: procfs: boot- and runtime configurable access mode for /proc/<pid>
 dirs
Content-Type: multipart/mixed;
 boundary="------------050506050003080307060404"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050506050003080307060404
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi all,

the attached patch enhances the procfs code to allow for modification of
/proc/<pid> dir access modes. It does so
- by hard-wiring (.config) a boot-time default mode (555, 550 or 500)
- which can be overriden by a boot parameter piddir_mode
- and also introduces an inode /proc/piddirs (644) which enables
runtime-configuration (already existing pid-dirs will be updated on next
access)


I started this quite a while back [1] and it worked fine ever since on
my servers. Now I finally enhanced that code by run-time configurability.


Let me know what you think and please CC me on replying.

Thanks,

Daniel


[1] http://lkml.org/lkml/2007/11/20/136

--------------050506050003080307060404
Content-Type: text/x-patch;
 name="configurable-piddir-modes-2.6.38.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="configurable-piddir-modes-2.6.38.patch"

Index: linux-2.6.38/fs/proc/piddirs.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.38/fs/proc/piddirs.c	2011-03-24 04:53:33.596331008 +0100
@@ -0,0 +1,87 @@
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/pid_namespace.h>
+#include <linux/proc_fs.h>
+#include <linux/sched.h>
+#include <linux/seq_file.h>
+#include <linux/seqlock.h>
+#include <linux/time.h>
+#include "internal.h"
+
+/* prototypes */
+static int	__init param_piddir_mode(char *buf);
+static int	__init proc_piddirs_init(void);
+static int	piddirs_proc_open(struct inode *inode, struct file *file);
+static int	piddirs_proc_show(struct seq_file *m, void *v);
+static ssize_t	piddirs_proc_write(struct file *file, const char __user *buf,
+			size_t count, loff_t *ppos);
+
+/* variables */
+static const struct file_operations piddirs_proc_fops = {
+	.open		= piddirs_proc_open,
+	.read		= seq_read,
+	.write		= piddirs_proc_write,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+/* This char only stores the module parameter.
+   The actual piddir_creation_mode is stored in base.c */
+static char *piddir_mode;
+
+/* module config */
+module_param(piddir_mode, charp, 0);
+MODULE_PARM_DESC(piddir_mode, "Default creation mode");
+module_init(proc_piddirs_init);
+__setup("piddir_mode=", param_piddir_mode);
+
+
+
+
+static int __init param_piddir_mode(char *buf)
+{
+	if (strlen(buf))
+		set_piddir_creation_mode(buf[0]);
+	return 1;
+}
+
+static int __init proc_piddirs_init(void)
+{
+	proc_create(
+		"piddirs",
+		S_IRUSR|S_IWUSR|S_IRGRP|S_IROTH,
+		NULL,
+		&piddirs_proc_fops
+	);
+	return 0;
+}
+
+static int piddirs_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, piddirs_proc_show, NULL);
+}
+
+static int piddirs_proc_show(struct seq_file *m, void *v)
+{
+	seq_printf(m, "%c\n", get_piddir_creation_mode());
+	return 0;
+}
+
+static ssize_t piddirs_proc_write(struct file *file,
+		const char __user *buf,
+		size_t count, loff_t *ppos)
+{
+	char tmp;
+
+	if (
+		(count == 2) &&
+		!copy_from_user(&tmp, buf, 1) &&
+		(set_piddir_creation_mode(tmp) == 0)
+	) {
+		return count;
+	} else {
+		return -EFAULT;
+	}
+}
Index: linux-2.6.38/fs/proc/internal.h
===================================================================
--- linux-2.6.38.orig/fs/proc/internal.h	2011-03-22 10:00:09.717152492 +0100
+++ linux-2.6.38/fs/proc/internal.h	2011-03-22 11:28:42.205497133 +0100
@@ -94,6 +94,10 @@
 extern spinlock_t proc_subdir_lock;
 
 struct dentry *proc_pid_lookup(struct inode *dir, struct dentry * dentry, struct nameidata *);
+#ifndef CONFIG_PROC_PIDDIRS_UNRESTRICTED
+char get_piddir_creation_mode(void);
+int set_piddir_creation_mode(char mode);
+#endif
 int proc_pid_readdir(struct file * filp, void * dirent, filldir_t filldir);
 unsigned long task_vsize(struct mm_struct *);
 unsigned long task_statm(struct mm_struct *,
Index: linux-2.6.38/fs/proc/base.c
===================================================================
--- linux-2.6.38.orig/fs/proc/base.c	2011-03-22 10:00:09.797214588 +0100
+++ linux-2.6.38/fs/proc/base.c	2011-03-24 04:54:51.292565614 +0100
@@ -104,6 +104,14 @@
 	union proc_op op;
 };
 
+#if defined CONFIG_PROC_PIDDIRS_MODE_U
+	char piddir_creation_mode = 'u';
+#elif defined CONFIG_PROC_PIDDIRS_MODE_UG
+	char piddir_creation_mode = 'g';
+#elif defined CONFIG_PROC_PIDDIRS_MODE_UGO
+	char piddir_creation_mode = 'o';
+#endif
+
 #define NOD(NAME, MODE, IOP, FOP, OP) {			\
 	.name = (NAME),					\
 	.len  = sizeof(NAME) - 1,			\
@@ -1779,8 +1787,15 @@
 	task = get_proc_task(inode);
 
 	if (task) {
-		if ((inode->i_mode == (S_IFDIR|S_IRUGO|S_IXUGO)) ||
-		    task_dumpable(task)) {
+		if (
+			#ifndef CONFIG_PROC_PIDDIRS_UNRESTRICTED
+			(inode->i_mode == (S_IFDIR|S_IRUSR|S_IXUSR)) ||
+			(inode->i_mode ==
+				(S_IFDIR|S_IRUSR|S_IRGRP|S_IXUSR|S_IXGRP)) ||
+			#endif
+			(inode->i_mode == (S_IFDIR|S_IRUGO|S_IXUGO)) ||
+			task_dumpable(task)
+		) {
 			rcu_read_lock();
 			cred = __task_cred(task);
 			inode->i_uid = cred->euid;
@@ -1791,6 +1806,21 @@
 			inode->i_gid = 0;
 		}
 		inode->i_mode &= ~(S_ISUID | S_ISGID);
+		#ifndef CONFIG_PROC_PIDDIRS_UNRESTRICTED
+		switch (piddir_creation_mode) {
+		case 'u':
+			inode->i_mode &= ~(S_IRGRP|S_IXGRP|S_IROTH|S_IXOTH);
+			break;
+		case 'g':
+			inode->i_mode |= S_IRUSR|S_IXUSR|S_IRGRP|S_IXGRP;
+			inode->i_mode &= ~(S_IROTH|S_IXOTH);
+			break;
+		case 'o':
+			inode->i_mode |= S_IRUGO|S_IXUGO;
+			break;
+		}
+		#endif
+
 		security_task_to_inode(task, inode);
 		put_task_struct(task);
 		return 1;
@@ -2950,6 +2980,35 @@
 		pid_ns_release_proc(upid->ns);
 }
 
+#ifndef CONFIG_PROC_PIDDIRS_UNRESTRICTED
+char get_piddir_creation_mode(void)
+{
+	return piddir_creation_mode;
+}
+
+int set_piddir_creation_mode(char mode)
+{
+	switch (mode) {
+	case 'u':
+		printk(KERN_INFO "procfs: Setting /proc/<pid>-dir creation"
+			" mode to 500\n");
+		break;
+	case 'g':
+		printk(KERN_INFO "procfs: Setting /proc/<pid>-dir creation"
+			" mode to 550\n");
+		break;
+	case 'o':
+		printk(KERN_INFO "procfs: Setting /proc/<pid>-dir creation"
+			" mode to 555\n");
+		break;
+	default:
+		return -EINVAL;
+	}
+	piddir_creation_mode = mode;
+	return 0;
+}
+#endif
+
 static struct dentry *proc_pid_instantiate(struct inode *dir,
 					   struct dentry * dentry,
 					   struct task_struct *task, const void *ptr)
@@ -2961,7 +3020,22 @@
 	if (!inode)
 		goto out;
 
+	#ifndef CONFIG_PROC_PIDDIRS_UNRESTRICTED
+	switch (piddir_creation_mode) {
+	case 'u':
+		inode->i_mode = S_IFDIR|S_IRUSR|S_IXUSR;
+		break;
+	case 'g':
+		inode->i_mode = S_IFDIR|S_IRUSR|S_IRGRP|S_IXUSR|S_IXGRP;
+		break;
+	case 'o':
+		inode->i_mode = S_IFDIR|S_IRUGO|S_IXUGO;
+		break;
+	}
+	#else
 	inode->i_mode = S_IFDIR|S_IRUGO|S_IXUGO;
+	#endif
+
 	inode->i_op = &proc_tgid_base_inode_operations;
 	inode->i_fop = &proc_tgid_base_operations;
 	inode->i_flags|=S_IMMUTABLE;
Index: linux-2.6.38/fs/proc/Makefile
===================================================================
--- linux-2.6.38.orig/fs/proc/Makefile	2011-03-22 10:00:09.853177027 +0100
+++ linux-2.6.38/fs/proc/Makefile	2011-03-24 03:48:01.520964812 +0100
@@ -27,3 +27,6 @@
 proc-$(CONFIG_PROC_DEVICETREE)	+= proc_devtree.o
 proc-$(CONFIG_PRINTK)	+= kmsg.o
 proc-$(CONFIG_PROC_PAGE_MONITOR)	+= page.o
+proc-$(CONFIG_PROC_PIDDIRS_MODE_UGO)	+= piddirs.o
+proc-$(CONFIG_PROC_PIDDIRS_MODE_UG)	+= piddirs.o
+proc-$(CONFIG_PROC_PIDDIRS_MODE_U)	+= piddirs.o
Index: linux-2.6.38/fs/proc/Kconfig
===================================================================
--- linux-2.6.38.orig/fs/proc/Kconfig	2011-03-22 10:00:09.757199278 +0100
+++ linux-2.6.38/fs/proc/Kconfig	2011-03-24 03:46:28.488680884 +0100
@@ -67,3 +67,73 @@
 	  /proc/pid/smaps, /proc/pid/clear_refs, /proc/pid/pagemap,
 	  /proc/kpagecount, and /proc/kpageflags. Disabling these
           interfaces will reduce the size of the kernel by approximately 4kb.
+
+choice PROC_PIDDIRS
+	prompt "Restrict access to /proc/<pid>-dirs"
+	default PROC_PIDDIRS_MODE_UGO
+	help
+	  When set to "no restriction", the access mode for /proc/<pid>-dirs is
+	  555 (r-xr-xr-x) which is the traditional behaviour.
+
+
+	  Enabling one of the other options has three impacts:
+
+	  1) set the default access mode to the respective value
+
+	  2) enable a boot parameter called piddir_mode; possible values are
+	     - 'u': limit to user
+	     - 'g': limit to user and group
+	     - 'o': no limits (other may read)
+
+	     e.g. piddir_mode=u
+
+	  3) enable runtime-configuration of the access modes by issuing e.g.
+	  	echo g > /proc/piddirs
+	     Again, the possible values are 'u', 'g', 'o'.
+
+config PROC_PIDDIRS_UNRESTRICTED
+	bool "no restriction"
+	depends on PROC_FS
+	help
+	  Don't restrict access to /proc/<pid>-dirs, i.e. leave mode at 555
+	  respectively r-xr-xr-x . Runtime manipulation of access mode is
+	  disabled. This is the traditional mode of operation.
+
+	  If unsure, say Y.
+
+config PROC_PIDDIRS_MODE_UGO
+	bool "unrestricted by default"
+	depends on PROC_FS
+	help
+	  Don't restrict access to /proc/<pid>-dirs, i.e. leave mode at 555
+	  (r-xr-xr-x). The default access mode can be changed to 555 during
+	  runtime e.g. by issuing
+
+	  	echo o > /proc/piddirs
+
+	  If unsure, say N.
+
+config PROC_PIDDIRS_MODE_UG
+	bool "restrict to user and group by default"
+	depends on PROC_FS
+	help
+	  Restrict access to /proc/<pid>-dirs to user and group, i.e. set mode
+	  to 550 (r-xr-x---). The default access mode can be changed to 550
+	  during runtime e.g. by issuing
+
+	  	echo g > /proc/piddirs
+
+	  If unsure, say N.
+
+config PROC_PIDDIRS_MODE_U
+	bool "restrict to user by default"
+	depends on PROC_FS
+	help
+	  Restrict access to /proc/<pid>-dirs to user only, i.e. set mode to
+	  500 (r-x------). The default access mode can be changed to 500 during
+	  runtime e.g. by issuing
+
+	  	echo u > /proc/piddirs
+
+	  If unsure, say N.
+endchoice

--------------050506050003080307060404--
