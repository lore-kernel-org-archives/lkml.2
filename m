Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757944Ab0FUXDi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 19:03:38 -0400
Received: from smtp.outflux.net ([198.145.64.163]:44219 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756824Ab0FUXDh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 19:03:37 -0400
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Jun 2010 19:03:36 EDT
Date: Mon, 21 Jun 2010 14:34:24 -0700
From: Kees Cook <kees.cook@canonical.com>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH] security: Yama LSM
Message-ID: <20100621213424.GG24749@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This creates the Yama Linux Security Module to collect several
security features that have existed in various forms over the years
and have been carried by other distros outside the mainline kernel.

It includes symlink and hardlink protections, as well as PTRACE scope
limitations.

Signed-off-by: Kees Cook <kees.cook@canonical.com>
---
 security/Kconfig         |    6 +
 security/Makefile        |    2 +
 security/yama/Kconfig    |   72 ++++++++++++++
 security/yama/Makefile   |    3 +
 security/yama/yama_lsm.c |  238 ++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 321 insertions(+), 0 deletions(-)
 create mode 100644 security/yama/Kconfig
 create mode 100644 security/yama/Makefile
 create mode 100644 security/yama/yama_lsm.c

diff --git a/security/Kconfig b/security/Kconfig
index 226b955..0e3a5ac 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -140,6 +140,7 @@ config LSM_MMAP_MIN_ADDR
 source security/selinux/Kconfig
 source security/smack/Kconfig
 source security/tomoyo/Kconfig
+source security/yama/Kconfig
 
 source security/integrity/ima/Kconfig
 
@@ -148,6 +149,7 @@ choice
 	default DEFAULT_SECURITY_SELINUX if SECURITY_SELINUX
 	default DEFAULT_SECURITY_SMACK if SECURITY_SMACK
 	default DEFAULT_SECURITY_TOMOYO if SECURITY_TOMOYO
+	default DEFAULT_SECURITY_YAMA if SECURITY_YAMA
 	default DEFAULT_SECURITY_DAC
 
 	help
@@ -163,6 +165,9 @@ choice
 	config DEFAULT_SECURITY_TOMOYO
 		bool "TOMOYO" if SECURITY_TOMOYO=y
 
+	config DEFAULT_SECURITY_YAMA
+		bool "Yama" if SECURITY_YAMA=y
+
 	config DEFAULT_SECURITY_DAC
 		bool "Unix Discretionary Access Controls"
 
@@ -173,6 +178,7 @@ config DEFAULT_SECURITY
 	default "selinux" if DEFAULT_SECURITY_SELINUX
 	default "smack" if DEFAULT_SECURITY_SMACK
 	default "tomoyo" if DEFAULT_SECURITY_TOMOYO
+	default "yama" if DEFAULT_SECURITY_YAMA
 	default "" if DEFAULT_SECURITY_DAC
 
 endmenu
diff --git a/security/Makefile b/security/Makefile
index da20a19..04354d1 100644
--- a/security/Makefile
+++ b/security/Makefile
@@ -6,6 +6,7 @@ obj-$(CONFIG_KEYS)			+= keys/
 subdir-$(CONFIG_SECURITY_SELINUX)	+= selinux
 subdir-$(CONFIG_SECURITY_SMACK)		+= smack
 subdir-$(CONFIG_SECURITY_TOMOYO)        += tomoyo
+subdir-$(CONFIG_SECURITY_YAMA)		+= yama
 
 # always enable default capabilities
 obj-y					+= commoncap.o
@@ -19,6 +20,7 @@ obj-$(CONFIG_SECURITY_SELINUX)		+= selinux/built-in.o
 obj-$(CONFIG_SECURITY_SMACK)		+= smack/built-in.o
 obj-$(CONFIG_AUDIT)			+= lsm_audit.o
 obj-$(CONFIG_SECURITY_TOMOYO)		+= tomoyo/built-in.o
+obj-$(CONFIG_SECURITY_YAMA)		+= yama/built-in.o
 obj-$(CONFIG_CGROUP_DEVICE)		+= device_cgroup.o
 
 # Object integrity file lists
diff --git a/security/yama/Kconfig b/security/yama/Kconfig
new file mode 100644
index 0000000..22cf2ed
--- /dev/null
+++ b/security/yama/Kconfig
@@ -0,0 +1,72 @@
+config SECURITY_YAMA
+	bool "Yama NAC Support"
+	depends on SECURITY
+	select SECURITYFS
+	select SECURITY_PATH
+	default n
+	help
+	  This selects Yama, the NAKed Access Control system which
+	  provides additional global security settings above regular
+	  Linux discretionary access controls.
+	  If you are unsure how to answer this question, answer N.
+
+config SECURITY_YAMA_SYMLINKS
+	bool "Yama: protect symlink following in sticky world-writable dirs"
+	depends on SECURITY_YAMA
+	default y
+	help
+	  A long-standing class of security issues is the symlink-based
+	  time-of-check-time-of-use race, most commonly seen in
+	  world-writable directories like /tmp. The common method of
+	  exploitation of this flaw is to cross privilege boundaries
+	  when following a given symlink (i.e. a root process follows
+	  a malicious symlink belonging to another user).
+
+	  Enabling this solves the problem by permitting symlinks to only
+	  be followed when outside a sticky world-writable directory,
+	  or when the uid of the symlink and follower match, or when
+	  the directory and symlink owners match.
+
+	  If you are unsure how to answer this question, answer Y.
+
+config SECURITY_YAMA_HARDLINKS
+	bool "Yama: protect hardlink creation to non-accessible files"
+	depends on SECURITY_YAMA
+	default y
+	help
+	  Normally, hardlinks can be created to files that a given user
+	  does not have access to.  This can create security problems
+	  where privileged processes act on files that only they have
+	  access to, but have been put places unexpectedly by an attacker.
+
+	  This option limits the creation of hardlinks to files that a
+	  given user would be unable to read and write originally, or are
+	  not otherwise sensitive.
+
+	  If you are unsure how to answer this question, answer Y.
+
+config SECURITY_YAMA_PTRACE
+	int "Yama: PTRACE_ATTACH default scope"
+	depends on SECURITY_YAMA
+	range 0 1
+	default 1
+	help
+	  This option sets the default scope for PTRACEing of processes.
+
+	  One particularly troubling weakness of the Linux process
+	  interfaces is that a single user is able to examine the memory and
+	  running state of any of their processes. For example, if one
+	  application (e.g. Pidgin) was compromised, it would be possible for
+	  an attacker to attach to other running processes (e.g. Firefox, SSH
+	  sessions, GPG agent, etc) to extract additional credentials and
+	  continue to expand the scope of their attack without resorting to
+	  user-assisted phishing.
+
+	  This scope is designed to disallow such PTRACE attachment when
+	  the scope is set to non-zero.
+
+	  Scopes are:
+ 	    0 - classic: CAP_SYS_PTRACE and same uid can ptrace non-setuid.
+	    1 - restricted: as above, but only children of ptracing process.
+
+	  If you are unsure how to answer this question, answer 1.
diff --git a/security/yama/Makefile b/security/yama/Makefile
new file mode 100644
index 0000000..8b5e065
--- /dev/null
+++ b/security/yama/Makefile
@@ -0,0 +1,3 @@
+obj-$(CONFIG_SECURITY_YAMA) := yama.o
+
+yama-y := yama_lsm.o
diff --git a/security/yama/yama_lsm.c b/security/yama/yama_lsm.c
new file mode 100644
index 0000000..c42ad72
--- /dev/null
+++ b/security/yama/yama_lsm.c
@@ -0,0 +1,238 @@
+/*
+ * Yama Linux Security Module
+ *
+ * Author: Kees Cook <kees.cook@canonical.com>
+ *
+ * Copyright (C) 2010 Canonical, Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/security.h>
+#include <linux/sysctl.h>
+#include <linux/ptrace.h>
+#include <linux/ratelimit.h>
+
+static int ptrace_scope = CONFIG_SECURITY_YAMA_PTRACE;
+static int protected_sticky_symlinks = CONFIG_SECURITY_YAMA_SYMLINKS;
+static int protected_nonaccess_hardlinks = CONFIG_SECURITY_YAMA_HARDLINKS;
+
+/**
+ * yama_ptrace_access_check - validate PTRACE_ATTACH calls
+ * @child: child task pointer
+ * @mode: ptrace attach mode
+ *
+ * Returns 0 if following the ptrace is allowed, -ve on error.
+ */
+static int yama_ptrace_access_check(struct task_struct *child,
+				    unsigned int mode)
+{
+	int rc;
+
+	rc = cap_ptrace_access_check(child, mode);
+	if (rc != 0)
+		return rc;
+
+	/* require ptrace target be a child of ptracer on attach */
+	if (mode == PTRACE_MODE_ATTACH && ptrace_scope &&
+	    !capable(CAP_SYS_PTRACE)) {
+		struct task_struct *walker = child;
+
+		read_lock(&tasklist_lock);
+		while (walker->pid > 0) {
+			if (walker == current)
+				break;
+			walker = walker->real_parent;
+		}
+		if (walker->pid == 0)
+			rc = -EPERM;
+		read_unlock(&tasklist_lock);
+	}
+
+	if (rc) {
+		printk_ratelimited(KERN_INFO "ptrace of non-child"
+			" pid %d was attempted by: %s (pid %d)\n",
+			child->pid, get_task_comm(name, current),
+			current->pid);
+	}
+
+	return rc;
+}
+
+/**
+ * yama_inode_follow_link - check for symlinks in sticky world-writeable dirs
+ * @dentry: The inode/dentry of the symlink
+ * @nameidata: The path data of the symlink
+ *
+ * In the case of the protected_sticky_symlinks sysctl being enabled,
+ * CAP_DAC_OVERRIDE needs to be specifically ignored if the symlink is
+ * in a sticky world-writable directory.  This is to protect privileged
+ * processes from failing races against path names that may change out
+ * from under them by way of other users creating malicious symlinks.
+ * It will permit symlinks to only be followed when outside a sticky
+ * world-writable directory, or when the uid of the symlink and follower
+ * match, or when the directory owner matches the symlink's owner.
+ *
+ * Returns 0 if following the symlink is allowed, -ve on error.
+ */
+static int yama_inode_follow_link(struct dentry *dentry,
+				  struct nameidata *nameidata)
+{
+	int rc;
+	const struct inode *parent;
+	const struct inode *inode;
+	const struct cred *cred;
+
+	rc = cap_inode_follow_link(dentry, nameidata);
+	if (rc != 0)
+		return rc;
+
+	if (!protected_sticky_symlinks)
+		return 0;
+
+	/* owner and follower match? */
+	cred = current_cred();
+	inode = dentry->d_inode;
+	if (cred->fsuid == inode->i_uid)
+		return 0;
+
+	/* check parent directory mode and owner */
+	spin_lock(&dentry->d_lock);
+	parent = dentry->d_parent->d_inode;
+	if ((parent->i_mode & (S_ISVTX|S_IWOTH)) == (S_ISVTX|S_IWOTH) &&
+	    parent->i_uid != inode->i_uid) {
+		rc = -EACCES;
+	}
+	spin_unlock(&dentry->d_lock);
+
+	if (rc) {
+		char name[sizeof(current->comm)];
+		printk_ratelimited(KERN_NOTICE "non-matching-uid symlink "
+			"following attempted in sticky world-writable "
+			"directory by %s (fsuid %d != %d)\n",
+			get_task_comm(name, current),
+			cred->fsuid, inode->i_uid);
+	}
+
+	return rc;
+}
+
+/**
+ * yama_path_link - verify that hardlinking is allowed
+ * @old_dentry: the source inode/dentry to hardlink from
+ * @new_dir: target directory
+ * @new_dentry: the target inode/dentry to hardlink to
+ *
+ * Block hardlink when all of:
+ *  - fsuid does not match inode
+ *  - not CAP_FOWNER
+ *  - and at least one of:
+ *    - inode is not a regular file
+ *    - inode is setuid
+ *    - inode is setgid and group-exec
+ *    - access failure for read and write
+ *
+ * Returns 0 if successful, -ve on error.
+ */
+static int yama_path_link(struct dentry *old_dentry, struct path *new_dir,
+			  struct dentry *new_dentry)
+{
+	int rc;
+	struct inode *inode = old_dentry->d_inode;
+	const int mode = inode->i_mode;
+	const struct cred *cred = current_cred();
+
+	rc = cap_path_link(old_dentry, new_dir, new_dentry);
+	if (rc != 0)
+		return rc;
+
+	if (!protected_nonaccess_hardlinks)
+		return 0;
+
+	if (cred->fsuid != inode->i_uid &&
+	    (!S_ISREG(mode) || (mode & S_ISUID) ||
+	     ((mode & (S_ISGID | S_IXGRP)) == (S_ISGID | S_IXGRP)) ||
+	     (generic_permission(inode, MAY_READ | MAY_WRITE, NULL))) &&
+	    !capable(CAP_FOWNER)) {
+		char name[sizeof(current->comm)];
+		printk_ratelimited(KERN_INFO "non-accessible hardlink"
+			" creation was attempted by: %s (fsuid %d)\n",
+			get_task_comm(name, current), cred->fsuid);
+		rc = -EPERM;
+	}
+
+	return rc;
+}
+
+static struct security_operations yama_ops = {
+	.name =			"yama",
+
+	.ptrace_access_check =	yama_ptrace_access_check,
+	.inode_follow_link =	yama_inode_follow_link,
+	.path_link =		yama_path_link,
+};
+
+#ifdef CONFIG_SYSCTL
+static int zero;
+static int one = 1;
+
+struct ctl_path yama_sysctl_path[] = {
+	{ .procname = "kernel", },
+	{ .procname = "yama", },
+	{ }
+};
+
+static struct ctl_table yama_sysctl_table[] = {
+	{
+		.procname       = "protected_sticky_symlinks",
+		.data           = &protected_sticky_symlinks,
+		.maxlen         = sizeof(int),
+		.mode           = 0644,
+		.proc_handler   = proc_dointvec_minmax,
+		.extra1         = &zero,
+		.extra2         = &one,
+	},
+	{
+		.procname       = "protected_nonaccess_hardlinks",
+		.data           = &protected_nonaccess_hardlinks,
+		.maxlen         = sizeof(int),
+		.mode           = 0644,
+		.proc_handler   = proc_dointvec_minmax,
+		.extra1         = &zero,
+		.extra2         = &one,
+	},
+	{
+		.procname       = "ptrace_scope",
+		.data           = &ptrace_scope,
+		.maxlen         = sizeof(int),
+		.mode           = 0644,
+		.proc_handler   = proc_dointvec_minmax,
+		.extra1         = &zero,
+		.extra2         = &one,
+	},
+	{ }
+};
+#endif /* CONFIG_SYSCTL */
+
+static __init int yama_init(void)
+{
+	if (!security_module_enable(&yama_ops))
+		return 0;
+
+	printk(KERN_INFO "Yama: becoming mindful.\n");
+
+	if (register_security(&yama_ops))
+		panic("Yama: kernel registration failed.\n");
+
+#ifdef CONFIG_SYSCTL
+	if (!register_sysctl_paths(yama_sysctl_path, yama_sysctl_table))
+		panic("Yama: sysctl registration failed.\n");
+#endif
+
+	return 0;
+}
+
+security_initcall(yama_init);
-- 
1.7.1


-- 
Kees Cook
Ubuntu Security Team
