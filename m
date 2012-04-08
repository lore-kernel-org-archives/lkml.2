Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521Ab2DHFNK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 01:13:10 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:51537 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070Ab2DHFM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 01:12:27 -0400
From: "\"Eric W. Beiderman" <ebiederm@xmission.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-fsdevel@vger.kernel.org>, <linux-security-module@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Sat,  7 Apr 2012 22:15:23 -0700
Message-Id: <1333862139-31737-27-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <m11unyn70b.fsf@fess.ebiederm.org>
References: <m11unyn70b.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX188g3Jci5h2LZjgJJQKGAXEwHov6g3Lees=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.1 FH_FROMEML_NOTLD E-mail address doesn't have TLD (.com, etc.)
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.0538]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;<linux-kernel@vger.kernel.org>
X-Spam-Relay-Country: **
Subject: [PATCH 27/43] userns: Use uid_eq gid_eq helpers when comparing kuids and kgids in the vfs
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/attr.c                |    8 ++++----
 fs/exec.c                |   10 +++++-----
 fs/fcntl.c               |    6 +++---
 fs/ioprio.c              |    4 ++--
 fs/locks.c               |    2 +-
 fs/namei.c               |    8 ++++----
 include/linux/quotaops.h |    4 ++--
 7 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/fs/attr.c b/fs/attr.c
index 73f69a6..2f094c6 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -47,14 +47,14 @@ int inode_change_ok(const struct inode *inode, struct iattr *attr)
 
 	/* Make sure a caller can chown. */
 	if ((ia_valid & ATTR_UID) &&
-	    (current_fsuid() != inode->i_uid ||
-	     attr->ia_uid != inode->i_uid) && !capable(CAP_CHOWN))
+	    (!uid_eq(current_fsuid(), inode->i_uid) ||
+	     !uid_eq(attr->ia_uid, inode->i_uid)) && !capable(CAP_CHOWN))
 		return -EPERM;
 
 	/* Make sure caller can chgrp. */
 	if ((ia_valid & ATTR_GID) &&
-	    (current_fsuid() != inode->i_uid ||
-	    (!in_group_p(attr->ia_gid) && attr->ia_gid != inode->i_gid)) &&
+	    (!uid_eq(current_fsuid(), inode->i_uid) ||
+	    (!in_group_p(attr->ia_gid) && gid_eq(attr->ia_gid, inode->i_gid))) &&
 	    !capable(CAP_CHOWN))
 		return -EPERM;
 
diff --git a/fs/exec.c b/fs/exec.c
index 9a1d9f0..00ae2ef 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1139,7 +1139,7 @@ void setup_new_exec(struct linux_binprm * bprm)
 	/* This is the point of no return */
 	current->sas_ss_sp = current->sas_ss_size = 0;
 
-	if (current_euid() == current_uid() && current_egid() == current_gid())
+	if (uid_eq(current_euid(), current_uid()) && gid_eq(current_egid(), current_gid()))
 		set_dumpable(current->mm, 1);
 	else
 		set_dumpable(current->mm, suid_dumpable);
@@ -1153,8 +1153,8 @@ void setup_new_exec(struct linux_binprm * bprm)
 	current->mm->task_size = TASK_SIZE;
 
 	/* install the new credentials */
-	if (bprm->cred->uid != current_euid() ||
-	    bprm->cred->gid != current_egid()) {
+	if (!uid_eq(bprm->cred->uid, current_euid()) ||
+	    !gid_eq(bprm->cred->gid, current_egid())) {
 		current->pdeath_signal = 0;
 	} else {
 		would_dump(bprm, bprm->file);
@@ -2120,7 +2120,7 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 	if (__get_dumpable(cprm.mm_flags) == 2) {
 		/* Setuid core dump mode */
 		flag = O_EXCL;		/* Stop rewrite attacks */
-		cred->fsuid = 0;	/* Dump root private */
+		cred->fsuid = GLOBAL_ROOT_UID;	/* Dump root private */
 	}
 
 	retval = coredump_wait(exit_code, &core_state);
@@ -2221,7 +2221,7 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 		 * Dont allow local users get cute and trick others to coredump
 		 * into their pre-created files.
 		 */
-		if (inode->i_uid != current_fsuid())
+		if (!uid_eq(inode->i_uid, current_fsuid()))
 			goto close_fail;
 		if (!cprm.file->f_op || !cprm.file->f_op->write)
 			goto close_fail;
diff --git a/fs/fcntl.c b/fs/fcntl.c
index 75e7c1f..d078b75 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -532,9 +532,9 @@ static inline int sigio_perm(struct task_struct *p,
 
 	rcu_read_lock();
 	cred = __task_cred(p);
-	ret = ((fown->euid == 0 ||
-		fown->euid == cred->suid || fown->euid == cred->uid ||
-		fown->uid  == cred->suid || fown->uid  == cred->uid) &&
+	ret = ((uid_eq(fown->euid, GLOBAL_ROOT_UID) ||
+		uid_eq(fown->euid, cred->suid) || uid_eq(fown->euid, cred->uid) ||
+		uid_eq(fown->uid,  cred->suid) || uid_eq(fown->uid,  cred->uid)) &&
 	       !security_file_send_sigiotask(p, fown, sig));
 	rcu_read_unlock();
 	return ret;
diff --git a/fs/ioprio.c b/fs/ioprio.c
index 2072e41..5e6dbe89 100644
--- a/fs/ioprio.c
+++ b/fs/ioprio.c
@@ -37,8 +37,8 @@ int set_task_ioprio(struct task_struct *task, int ioprio)
 
 	rcu_read_lock();
 	tcred = __task_cred(task);
-	if (tcred->uid != cred->euid &&
-	    tcred->uid != cred->uid && !capable(CAP_SYS_NICE)) {
+	if (!uid_eq(tcred->uid, cred->euid) &&
+	    !uid_eq(tcred->uid, cred->uid) && !capable(CAP_SYS_NICE)) {
 		rcu_read_unlock();
 		return -EPERM;
 	}
diff --git a/fs/locks.c b/fs/locks.c
index 637694b..3e946cd 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -1445,7 +1445,7 @@ int generic_setlease(struct file *filp, long arg, struct file_lock **flp)
 	struct inode *inode = dentry->d_inode;
 	int error;
 
-	if ((current_fsuid() != inode->i_uid) && !capable(CAP_LEASE))
+	if ((!uid_eq(current_fsuid(), inode->i_uid)) && !capable(CAP_LEASE))
 		return -EACCES;
 	if (!S_ISREG(inode->i_mode))
 		return -EINVAL;
diff --git a/fs/namei.c b/fs/namei.c
index 941c436..86512b4 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -228,7 +228,7 @@ static int acl_permission_check(struct inode *inode, int mask)
 {
 	unsigned int mode = inode->i_mode;
 
-	if (likely(current_fsuid() == inode->i_uid))
+	if (likely(uid_eq(current_fsuid(), inode->i_uid)))
 		mode >>= 6;
 	else {
 		if (IS_POSIXACL(inode) && (mode & S_IRWXG)) {
@@ -1956,13 +1956,13 @@ static int user_path_parent(int dfd, const char __user *path,
  */
 static inline int check_sticky(struct inode *dir, struct inode *inode)
 {
-	uid_t fsuid = current_fsuid();
+	kuid_t fsuid = current_fsuid();
 
 	if (!(dir->i_mode & S_ISVTX))
 		return 0;
-	if (inode->i_uid == fsuid)
+	if (uid_eq(inode->i_uid, fsuid))
 		return 0;
-	if (dir->i_uid == fsuid)
+	if (uid_eq(dir->i_uid, fsuid))
 		return 0;
 	return !inode_capable(inode, CAP_FOWNER);
 }
diff --git a/include/linux/quotaops.h b/include/linux/quotaops.h
index d93f95e..17b9773 100644
--- a/include/linux/quotaops.h
+++ b/include/linux/quotaops.h
@@ -22,8 +22,8 @@ static inline struct quota_info *sb_dqopt(struct super_block *sb)
 static inline bool is_quota_modification(struct inode *inode, struct iattr *ia)
 {
 	return (ia->ia_valid & ATTR_SIZE && ia->ia_size != inode->i_size) ||
-		(ia->ia_valid & ATTR_UID && ia->ia_uid != inode->i_uid) ||
-		(ia->ia_valid & ATTR_GID && ia->ia_gid != inode->i_gid);
+		(ia->ia_valid & ATTR_UID && !uid_eq(ia->ia_uid, inode->i_uid)) ||
+		(ia->ia_valid & ATTR_GID && !gid_eq(ia->ia_gid, inode->i_gid));
 }
 
 #if defined(CONFIG_QUOTA)
-- 
1.7.2.5

