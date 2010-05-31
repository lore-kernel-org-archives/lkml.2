Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755Ab0EaDFM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 23:05:12 -0400
Received: from smtp.outflux.net ([198.145.64.163]:43599 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755661Ab0EaDFK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 23:05:10 -0400
Date: Sun, 30 May 2010 20:04:02 -0700
From: Kees Cook <kees.cook@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-doc@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>, Dave Young <hidave.darkstar@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       James Morris <jmorris@namei.org>, Eric Paris <eparis@redhat.com>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Tim Gardner <tim.gardner@canonical.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>
Subject: [PATCH v2] fs: block cross-uid sticky symlinks
Message-ID: <20100531030402.GQ6056@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A long-standing class of security issues is the symlink-based
time-of-check-time-of-use race, most commonly seen in world-writable
directories like /tmp. The common method of exploitation of this flaw
is to cross privilege boundaries when following a given symlink (i.e. a
root process follows a symlink belonging to another user).  For a likely
incomplete list of hundreds of examples across the years, please see:
http://cve.mitre.org/cgi-bin/cvekey.cgi?keyword=/tmp

The solution is to permit symlinks to only be followed when outside a sticky
world-writable directory, or when the uid of the symlink and follower match,
or when the directory owner matches the symlink's owner.

Some pointers to the history of earlier discussion that I could find:

 1996 Aug, Zygo Blaxell
  http://marc.info/?l=bugtraq&m=87602167419830&w=2
 1996 Oct, Andrew Tridgell
  http://lkml.indiana.edu/hypermail/linux/kernel/9610.2/0086.html
 1997 Dec, Albert D Cahalan
  http://lkml.org/lkml/1997/12/16/4
 2005 Feb, Lorenzo Hernández García-Hierro
  http://lkml.indiana.edu/hypermail/linux/kernel/0502.0/1896.html

Past objections and rebuttals could be summarized as:

 - Violates POSIX.
   - POSIX didn't consider this situation and it's not useful to follow
     a broken specification at the cost of security.
 - Might break unknown applications that use this feature.
   - Applications that break because of the change are easy to spot and
     fix. Applications that are vulnerable to symlink ToCToU by not having
     the change aren't.
 - Applications should just use mkstemp() or O_CREATE|O_EXCL.
   - True, but applications are not perfect, and new software is written
     all the time that makes these mistakes; blocking this flaw at the
     kernel is a single solution to the entire class of vulnerability.

This patch is based on the patch in Openwall and grsecurity.  I have
added a sysctl to toggle the behavior back to the old logic via
/proc/sys/fs/weak-sticky-symlinks, documentation, and a ratelimited
warning.

v2:
 - dropped redundant S_ISLNK check.
 - moved sysctl extern into security.h.
 - asked to include CC to linux-fsdevel.

Signed-off-by: Kees Cook <kees.cook@canonical.com>
---
 Documentation/sysctl/kernel.txt |   16 ++++++++++++++++
 include/linux/security.h        |    3 +++
 kernel/sysctl.c                 |    9 +++++++++
 security/capability.c           |    6 ------
 security/commoncap.c            |   24 ++++++++++++++++++++++++
 5 files changed, 52 insertions(+), 6 deletions(-)

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index 3894eaa..6b059f6 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -66,6 +66,7 @@ show up in /proc/sys/kernel:
 - threads-max
 - unknown_nmi_panic
 - version
+- weak-sticky-symlinks
 
 ==============================================================
 
@@ -526,3 +527,18 @@ A small number of systems do generate NMI's for bizarre random reasons such as
 power management so the default is off. That sysctl works like the existing
 panic controls already in that directory.
 
+==============================================================
+
+weak-sticky-symlinks:
+
+Following symlinks in world-writable sticky directories (like /tmp) can
+be dangerous due to time-of-check-time-of-use races that frequently result
+in security vulnerabilities.  By default, symlinks can only be followed in
+sticky world-writable directories if the symlink and the follower's uid
+match (or if the symlink is owned by the owner of the world-writable directory
+itself).
+
+The default value is "0".  To disable this protection, setting a value of "1"
+will allow symlinks in sticky world-writable directories to be followed by
+anyone.
+
diff --git a/include/linux/security.h b/include/linux/security.h
index 0c88191..ee31647 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -43,6 +43,8 @@
 #define SECURITY_CAP_NOAUDIT 0
 #define SECURITY_CAP_AUDIT 1
 
+extern int weak_sticky_symlinks;
+
 struct ctl_table;
 struct audit_krule;
 
@@ -67,6 +69,7 @@ extern int cap_inode_setxattr(struct dentry *dentry, const char *name,
 extern int cap_inode_removexattr(struct dentry *dentry, const char *name);
 extern int cap_inode_need_killpriv(struct dentry *dentry);
 extern int cap_inode_killpriv(struct dentry *dentry);
+extern int cap_inode_follow_link(struct dentry *dentry, struct nameidata *nd);
 extern int cap_file_mmap(struct file *file, unsigned long reqprot,
 			 unsigned long prot, unsigned long flags,
 			 unsigned long addr, unsigned long addr_only);
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 997080f..cd7fee4 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1463,6 +1463,15 @@ static struct ctl_table fs_table[] = {
 		.extra1		= &zero,
 		.extra2		= &two,
 	},
+	{
+		.procname	= "weak-sticky-symlinks",
+		.data		= &weak_sticky_symlinks,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &zero,
+		.extra2		= &one,
+	},
 #if defined(CONFIG_BINFMT_MISC) || defined(CONFIG_BINFMT_MISC_MODULE)
 	{
 		.procname	= "binfmt_misc",
diff --git a/security/capability.c b/security/capability.c
index 8168e3e..ff34291 100644
--- a/security/capability.c
+++ b/security/capability.c
@@ -169,12 +169,6 @@ static int cap_inode_readlink(struct dentry *dentry)
 	return 0;
 }
 
-static int cap_inode_follow_link(struct dentry *dentry,
-				 struct nameidata *nameidata)
-{
-	return 0;
-}
-
 static int cap_inode_permission(struct inode *inode, int mask)
 {
 	return 0;
diff --git a/security/commoncap.c b/security/commoncap.c
index 4e01599..0ff07a6 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -29,6 +29,9 @@
 #include <linux/securebits.h>
 #include <linux/syslog.h>
 
+/* sysctl for symlink permissions checking */
+int weak_sticky_symlinks;
+
 /*
  * If a non-root user executes a setuid-root binary in
  * !secure(SECURE_NOROOT) mode, then we raise capabilities.
@@ -281,6 +284,27 @@ int cap_inode_killpriv(struct dentry *dentry)
 	return inode->i_op->removexattr(dentry, XATTR_NAME_CAPS);
 }
 
+int cap_inode_follow_link(struct dentry *dentry,
+			  struct nameidata *nameidata)
+{
+	const struct inode *parent = dentry->d_parent->d_inode;
+	const struct inode *inode = dentry->d_inode;
+	const struct cred *cred = current_cred();
+
+	if (weak_sticky_symlinks)
+		return 0;
+
+	if ((parent->i_mode & (S_ISVTX|S_IWOTH)) == (S_ISVTX|S_IWOTH) &&
+	    parent->i_uid != inode->i_uid &&
+	    cred->fsuid != inode->i_uid) {
+		printk_ratelimited(KERN_NOTICE "non-matching-uid symlink "
+			"following attempted in sticky-directory by "
+			"%s (fsuid %d)\n", current->comm, cred->fsuid);
+		return -EACCES;
+	}
+	return 0;
+}
+
 /*
  * Calculate the new process capability sets from the capability sets attached
  * to a file.
-- 
1.7.0.4


-- 
Kees Cook
Ubuntu Security Team
