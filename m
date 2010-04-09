Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804Ab0DITgQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 15:36:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48742 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755591Ab0DITgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 15:36:12 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH -v2] security: remove dead hook acct
To: linux-security-module@vger.kernel.org
Cc: jmorris@namei.org, linux-kernel@vger.kernel.org
Date: Fri, 09 Apr 2010 15:36:10 -0400
Message-ID: <20100409193324.23535.36578.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unused hook.  Remove.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

This is a resend of the broken patch I sent earlier.  It was the last patch in
the series and I had uncommitted changes in my repo which fixed the borkeness.
James you should apply all of the patches I originally sent except the last
one.  Use this one instead.

 include/linux/security.h |   14 --------------
 kernel/acct.c            |   20 +++++---------------
 security/capability.c    |    6 ------
 security/security.c      |    5 -----
 4 files changed, 5 insertions(+), 40 deletions(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index e698f3e..09cec5f 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1255,13 +1255,6 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  *	@cap contains the capability <include/linux/capability.h>.
  *	@audit: Whether to write an audit message or not
  *	Return 0 if the capability is granted for @tsk.
- * @acct:
- *	Check permission before enabling or disabling process accounting.  If
- *	accounting is being enabled, then @file refers to the open file used to
- *	store accounting records.  If accounting is being disabled, then @file
- *	is NULL.
- *	@file contains the file structure for the accounting file (may be NULL).
- *	Return 0 if permission is granted.
  * @sysctl:
  *	Check permission before accessing the @table sysctl variable in the
  *	manner specified by @op.
@@ -1384,7 +1377,6 @@ struct security_operations {
 		       const kernel_cap_t *permitted);
 	int (*capable) (struct task_struct *tsk, const struct cred *cred,
 			int cap, int audit);
-	int (*acct) (struct file *file);
 	int (*sysctl) (struct ctl_table *table, int op);
 	int (*quotactl) (int cmds, int type, int id, struct super_block *sb);
 	int (*quota_on) (struct dentry *dentry);
@@ -1667,7 +1659,6 @@ int security_capset(struct cred *new, const struct cred *old,
 int security_capable(int cap);
 int security_real_capable(struct task_struct *tsk, int cap);
 int security_real_capable_noaudit(struct task_struct *tsk, int cap);
-int security_acct(struct file *file);
 int security_sysctl(struct ctl_table *table, int op);
 int security_quotactl(int cmds, int type, int id, struct super_block *sb);
 int security_quota_on(struct dentry *dentry);
@@ -1886,11 +1877,6 @@ int security_real_capable_noaudit(struct task_struct *tsk, int cap)
 	return ret;
 }
 
-static inline int security_acct(struct file *file)
-{
-	return 0;
-}
-
 static inline int security_sysctl(struct ctl_table *table, int op)
 {
 	return 0;
diff --git a/kernel/acct.c b/kernel/acct.c
index 24f8c81..9e53bb2 100644
--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -216,7 +216,6 @@ static int acct_on(char *name)
 {
 	struct file *file;
 	struct vfsmount *mnt;
-	int error;
 	struct pid_namespace *ns;
 	struct bsd_acct_struct *acct = NULL;
 
@@ -244,13 +243,6 @@ static int acct_on(char *name)
 		}
 	}
 
-	error = security_acct(file);
-	if (error) {
-		kfree(acct);
-		filp_close(file, NULL);
-		return error;
-	}
-
 	spin_lock(&acct_lock);
 	if (ns->bacct == NULL) {
 		ns->bacct = acct;
@@ -281,7 +273,7 @@ static int acct_on(char *name)
  */
 SYSCALL_DEFINE1(acct, const char __user *, name)
 {
-	int error;
+	int error = 0;
 
 	if (!capable(CAP_SYS_PACCT))
 		return -EPERM;
@@ -299,13 +291,11 @@ SYSCALL_DEFINE1(acct, const char __user *, name)
 		if (acct == NULL)
 			return 0;
 
-		error = security_acct(NULL);
-		if (!error) {
-			spin_lock(&acct_lock);
-			acct_file_reopen(acct, NULL, NULL);
-			spin_unlock(&acct_lock);
-		}
+		spin_lock(&acct_lock);
+		acct_file_reopen(acct, NULL, NULL);
+		spin_unlock(&acct_lock);
 	}
+
 	return error;
 }
 
diff --git a/security/capability.c b/security/capability.c
index 9e8331b..dd8fc16 100644
--- a/security/capability.c
+++ b/security/capability.c
@@ -12,11 +12,6 @@
 
 #include <linux/security.h>
 
-static int cap_acct(struct file *file)
-{
-	return 0;
-}
-
 static int cap_sysctl(ctl_table *table, int op)
 {
 	return 0;
@@ -866,7 +861,6 @@ void security_fixup_ops(struct security_operations *ops)
 	set_to_cap_if_null(ops, ptrace_traceme);
 	set_to_cap_if_null(ops, capget);
 	set_to_cap_if_null(ops, capset);
-	set_to_cap_if_null(ops, acct);
 	set_to_cap_if_null(ops, capable);
 	set_to_cap_if_null(ops, quotactl);
 	set_to_cap_if_null(ops, quota_on);
diff --git a/security/security.c b/security/security.c
index 67d58f1..8da7cf2 100644
--- a/security/security.c
+++ b/security/security.c
@@ -190,11 +190,6 @@ int security_real_capable_noaudit(struct task_struct *tsk, int cap)
 	return ret;
 }
 
-int security_acct(struct file *file)
-{
-	return security_ops->acct(file);
-}
-
 int security_sysctl(struct ctl_table *table, int op)
 {
 	return security_ops->sysctl(table, op);

