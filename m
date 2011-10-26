Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545Ab1JZX7Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 19:59:16 -0400
Received: from smtp.outflux.net ([198.145.64.163]:33059 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753525Ab1JZX7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 19:59:07 -0400
X-Greylist: delayed 571 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Oct 2011 19:59:03 EDT
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org
Subject: [PATCH 1/3] security: Yama LSM
Date: Wed, 26 Oct 2011 16:49:14 -0700
Message-Id: <1319672956-17114-2-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1319672956-17114-1-git-send-email-keescook@chromium.org>
References: <1319672956-17114-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the Yama Linux Security Module to collect several DAC security
improvements (symlink, hardlink, and ptrace restrictions) that have existed
in various forms over the years and have been carried outside the mainline
kernel by other Linux distributions like Openwall and grsecurity.

As discussed at the Linux Security Summit, I'm resending this patchset
since it has value to a few distros. It was observed that while Yama is
not a MAC, this isn't required for an LSM. It has a distinct policy,
one that enhances DAC security, and that will continue to be its role
as an LSM.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
v6:
 - Fix interaction with overlayfs, thanks to Andy Whitcroft and Leann
   Ogasawara.
 - Clarify rationale for LSM.
 - Move documentation under security subdirectory.
v5:
 - resend, with ptrace relationship interface
v4:
 - drop accidentally included fs/exec.c chunk.
v3:
 - drop needless cap_ callbacks.
 - fix usage of get_task_comm.
 - drop CONFIG_ of sysctl defaults, as recommended by Andi Kleen.
 - require SYSCTL.
v2:
 - add rcu locking, thanks to Tetsuo Handa.
 - add Documentation/Yama.txt for summary of features.
---
 Documentation/security/Yama.txt |   91 ++++++++++++++
 security/Kconfig                |    6 +
 security/Makefile               |    2 +
 security/yama/Kconfig           |   14 ++
 security/yama/Makefile          |    3 +
 security/yama/yama_lsm.c        |  250 +++++++++++++++++++++++++++++++++++++++
 6 files changed, 366 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/security/Yama.txt
 create mode 100644 security/yama/Kconfig
 create mode 100644 security/yama/Makefile
 create mode 100644 security/yama/yama_lsm.c

diff --git a/Documentation/security/Yama.txt b/Documentation/security/Yama.txt
new file mode 100644
index 0000000..1916742
--- /dev/null
+++ b/Documentation/security/Yama.txt
@@ -0,0 +1,91 @@
+Yama is a Linux Security Module that collects a number of system-wide DAC
+security protections that are not handled by the core kernel itself. To
+select it at boot time, specify "security=yama" (though this will disable
+any other LSM).
+
+Yama is controlled through sysctl in /proc/sys/kernel/yama:
+
+- protected_sticky_symlinks
+- protected_nonaccess_hardlinks
+- ptrace_scope
+
+==============================================================
+
+protected_sticky_symlinks:
+
+A long-standing class of security issues is the symlink-based
+time-of-check-time-of-use race, most commonly seen in world-writable
+directories like /tmp. The common method of exploitation of this flaw
+is to cross privilege boundaries when following a given symlink (i.e. a
+root process follows a symlink belonging to another user). For a likely
+incomplete list of hundreds of examples across the years, please see:
+http://cve.mitre.org/cgi-bin/cvekey.cgi?keyword=/tmp
+
+When set to "0", symlink following behavior is unrestricted.
+
+When set to "1" symlinks are permitted to be followed only when outside
+a sticky world-writable directory, or when the uid of the symlink and
+follower match, or when the directory owner matches the symlink's owner.
+
+This protection is based on the restrictions in Openwall and grsecurity.
+
+==============================================================
+
+protected_nonaccess_hardlinks:
+
+Hardlinks can be abused in a similar fashion to symlinks in sticky
+world-writable directories, but their weakness is not limited to
+just that scenario. For example, if /etc and /home are on the same
+partition, a regular user can create a hardlink to /etc/shadow in their
+home directory. While it retains the original owner and permissions,
+it is possible for privileged programs that are otherwise symlink-safe
+to mistakenly access the file through its hardlink. Additionally, a very
+minor untraceable quota-bypassing local denial of service is possible by
+an attacker exhausting disk space by filling a world-writable directory
+with hardlinks.
+
+When set to "0", hardlink creation behavior is unrestricted.
+
+When set to "1", hardlinks cannot be created to files that a given user
+would be unable to read and write originally, or are otherwise sensitive.
+
+This protection is based on the restrictions in Openwall and grsecurity.
+
+==============================================================
+
+ptrace_scope:
+
+As Linux grows in popularity, it will become a larger target for
+malware. One particularly troubling weakness of the Linux process
+interfaces is that a single user is able to examine the memory and
+running state of any of their processes. For example, if one application
+(e.g. Pidgin) was compromised, it would be possible for an attacker to
+attach to other running processes (e.g. Firefox, SSH sessions, GPG agent,
+etc) to extract additional credentials and continue to expand the scope
+of their attack without resorting to user-assisted phishing.
+
+This is not a theoretical problem. SSH session hijacking
+(http://www.storm.net.nz/projects/7) and arbitrary code injection
+(http://c-skills.blogspot.com/2007/05/injectso.html) attacks already
+exist and remain possible if ptrace is allowed to operate as before.
+Since ptrace is not commonly used by non-developers and non-admins, system
+builders should be allowed the option to disable this debugging system.
+
+For a solution, some applications use prctl(PR_SET_DUMPABLE, ...) to
+specifically disallow such ptrace attachment (e.g. ssh-agent), but many
+do not. A more general solution is to only allow ptrace directly from a
+parent to a child process (i.e. direct "gdb EXE" and "strace EXE" still
+work), or with CAP_SYS_PTRACE (i.e. "gdb --pid=PID", and "strace -p PID"
+still work as root).
+
+0 - classic ptrace permissions: a process can PTRACE_ATTACH to any other
+    process running under the same uid, as long as it is dumpable (i.e.
+    did not transition uids, start privileged, or have called
+    prctl(PR_SET_DUMPABLE...) already).
+
+1 - restricted ptrace: a process can only call PTRACE_ATTACH on its
+    descendants when the above classic criteria is also met.
+
+This protection is based on the restrictions in grsecurity.
+
+==============================================================
diff --git a/security/Kconfig b/security/Kconfig
index 51bd5a0..ccc61f8 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -187,6 +187,7 @@ source security/selinux/Kconfig
 source security/smack/Kconfig
 source security/tomoyo/Kconfig
 source security/apparmor/Kconfig
+source security/yama/Kconfig
 
 source security/integrity/Kconfig
 
@@ -196,6 +197,7 @@ choice
 	default DEFAULT_SECURITY_SMACK if SECURITY_SMACK
 	default DEFAULT_SECURITY_TOMOYO if SECURITY_TOMOYO
 	default DEFAULT_SECURITY_APPARMOR if SECURITY_APPARMOR
+	default DEFAULT_SECURITY_YAMA if SECURITY_YAMA
 	default DEFAULT_SECURITY_DAC
 
 	help
@@ -214,6 +216,9 @@ choice
 	config DEFAULT_SECURITY_APPARMOR
 		bool "AppArmor" if SECURITY_APPARMOR=y
 
+	config DEFAULT_SECURITY_YAMA
+		bool "Yama" if SECURITY_YAMA=y
+
 	config DEFAULT_SECURITY_DAC
 		bool "Unix Discretionary Access Controls"
 
@@ -225,6 +230,7 @@ config DEFAULT_SECURITY
 	default "smack" if DEFAULT_SECURITY_SMACK
 	default "tomoyo" if DEFAULT_SECURITY_TOMOYO
 	default "apparmor" if DEFAULT_SECURITY_APPARMOR
+	default "yama" if DEFAULT_SECURITY_YAMA
 	default "" if DEFAULT_SECURITY_DAC
 
 endmenu
diff --git a/security/Makefile b/security/Makefile
index a5e502f..c26c81e 100644
--- a/security/Makefile
+++ b/security/Makefile
@@ -7,6 +7,7 @@ subdir-$(CONFIG_SECURITY_SELINUX)	+= selinux
 subdir-$(CONFIG_SECURITY_SMACK)		+= smack
 subdir-$(CONFIG_SECURITY_TOMOYO)        += tomoyo
 subdir-$(CONFIG_SECURITY_APPARMOR)	+= apparmor
+subdir-$(CONFIG_SECURITY_YAMA)		+= yama
 
 # always enable default capabilities
 obj-y					+= commoncap.o
@@ -21,6 +22,7 @@ obj-$(CONFIG_SECURITY_SMACK)		+= smack/built-in.o
 obj-$(CONFIG_AUDIT)			+= lsm_audit.o
 obj-$(CONFIG_SECURITY_TOMOYO)		+= tomoyo/built-in.o
 obj-$(CONFIG_SECURITY_APPARMOR)		+= apparmor/built-in.o
+obj-$(CONFIG_SECURITY_YAMA)		+= yama/built-in.o
 obj-$(CONFIG_CGROUP_DEVICE)		+= device_cgroup.o
 
 # Object integrity file lists
diff --git a/security/yama/Kconfig b/security/yama/Kconfig
new file mode 100644
index 0000000..1a5d1c1
--- /dev/null
+++ b/security/yama/Kconfig
@@ -0,0 +1,14 @@
+config SECURITY_YAMA
+	bool "Yama support"
+	depends on SECURITY
+	select SECURITYFS
+	select SECURITY_PATH
+	default n
+	help
+	  This selects Yama, which extends DAC support with additional
+	  system-wide security settings beyond regular Linux discretionary
+	  access controls. Currently available are symlink, hardlink, and
+	  ptrace scope restrictions. Further information can be found in
+	  Documentation/security/Yama.txt.
+
+	  If you are unsure how to answer this question, answer N.
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
index 0000000..955e401
--- /dev/null
+++ b/security/yama/yama_lsm.c
@@ -0,0 +1,250 @@
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
+static int ptrace_scope = 1;
+static int protected_sticky_symlinks = 1;
+static int protected_nonaccess_hardlinks = 1;
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
+		rcu_read_lock();
+		read_lock(&tasklist_lock);
+		while (walker->pid > 0) {
+			if (walker == current)
+				break;
+			walker = walker->real_parent;
+		}
+		if (walker->pid == 0)
+			rc = -EPERM;
+		read_unlock(&tasklist_lock);
+		rcu_read_unlock();
+	}
+
+	if (rc) {
+		char name[sizeof(current->comm)];
+		printk_ratelimited(KERN_INFO "ptrace of non-child"
+			" pid %d was attempted by: %s (pid %d)\n",
+			child->pid,
+			get_task_comm(name, current),
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
+	int rc = 0;
+	const struct inode *parent;
+	const struct inode *inode;
+	const struct cred *cred;
+
+	if (!protected_sticky_symlinks)
+		return 0;
+
+	/* if inode isn't a symlink, don't try to evaluate blocking it */
+	inode = dentry->d_inode;
+	if (!S_ISLNK(inode->i_mode))
+		return 0;
+
+	/* owner and follower match? */
+	cred = current_cred();
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
+static int yama_generic_permission(struct inode *inode, int mask)
+{
+	int retval;
+
+	if (inode->i_op->permission)
+		retval = inode->i_op->permission(inode, mask);
+	else
+		retval = generic_permission(inode, mask);
+	return retval;
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
+	int rc = 0;
+	struct inode *inode = old_dentry->d_inode;
+	const int mode = inode->i_mode;
+	const struct cred *cred = current_cred();
+
+	if (!protected_nonaccess_hardlinks)
+		return 0;
+
+	if (cred->fsuid != inode->i_uid &&
+	    (!S_ISREG(mode) || (mode & S_ISUID) ||
+	     ((mode & (S_ISGID | S_IXGRP)) == (S_ISGID | S_IXGRP)) ||
+	     (yama_generic_permission(inode, MAY_READ | MAY_WRITE))) &&
+	    !capable(CAP_FOWNER)) {
+		char name[sizeof(current->comm)];
+		printk_ratelimited(KERN_INFO "non-accessible hardlink"
+			" creation was attempted by: %s (fsuid %d)\n",
+			get_task_comm(name, current),
+			cred->fsuid);
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
1.7.5.4

