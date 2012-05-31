Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757962Ab2EaIAP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 04:00:15 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:62487 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881Ab2EaIAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 04:00:13 -0400
From: kosaki.motohiro@gmail.com
To: linux-kernel@vger.kernel.org
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Chris Wright <chrisw@sous-sol.org>,
        James Morris <james.l.morris@oracle.com>,
        linux-security-module@vger.kernel.org
Subject: [PATCH] security: kill security_task_fix_setuid()
Date: Thu, 31 May 2012 03:59:59 -0400
Message-Id: <1338451199-15396-1-git-send-email-kosaki.motohiro@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

commit 72fa5997 (move RLIMIT_NPROC check from set_user() to do_execve_common())
pointed out set*uid() failure can cause a security problem.
Thus, security_task_fix_setuid() potentially has the same issue. Any security
module shouldn't use it. This patch kills it completely.

Luckily, any security module don't use it. then, this patch doesn't make any
userland visible change.

Cc: Vasiliy Kulikov <segoon@openwall.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: James Morris <james.l.morris@oracle.com>
Cc: linux-security-module@vger.kernel.org
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 include/linux/security.h |    4 ----
 kernel/sys.c             |   15 +--------------
 security/capability.c    |    1 -
 security/security.c      |    6 ------
 4 files changed, 1 insertions(+), 25 deletions(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index ab0e091..67a7bb2 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1507,8 +1507,6 @@ struct security_operations {
 	int (*kernel_act_as)(struct cred *new, u32 secid);
 	int (*kernel_create_files_as)(struct cred *new, struct inode *inode);
 	int (*kernel_module_request)(char *kmod_name);
-	int (*task_fix_setuid) (struct cred *new, const struct cred *old,
-				int flags);
 	int (*task_setpgid) (struct task_struct *p, pid_t pgid);
 	int (*task_getpgid) (struct task_struct *p);
 	int (*task_getsid) (struct task_struct *p);
@@ -1764,8 +1762,6 @@ void security_transfer_creds(struct cred *new, const struct cred *old);
 int security_kernel_act_as(struct cred *new, u32 secid);
 int security_kernel_create_files_as(struct cred *new, struct inode *inode);
 int security_kernel_module_request(char *kmod_name);
-int security_task_fix_setuid(struct cred *new, const struct cred *old,
-			     int flags);
 int security_task_setpgid(struct task_struct *p, pid_t pgid);
 int security_task_getpgid(struct task_struct *p);
 int security_task_getsid(struct task_struct *p);
diff --git a/kernel/sys.c b/kernel/sys.c
index 6df4262..391bfb2 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -734,10 +734,6 @@ SYSCALL_DEFINE2(setreuid, uid_t, ruid, uid_t, euid)
 		new->suid = new->euid;
 	new->fsuid = new->euid;
 
-	retval = security_task_fix_setuid(new, old, LSM_SETID_RE);
-	if (retval < 0)
-		goto error;
-
 	return commit_creds(new);
 
 error:
@@ -787,10 +783,6 @@ SYSCALL_DEFINE1(setuid, uid_t, uid)
 
 	new->fsuid = new->euid = kuid;
 
-	retval = security_task_fix_setuid(new, old, LSM_SETID_ID);
-	if (retval < 0)
-		goto error;
-
 	return commit_creds(new);
 
 error:
@@ -857,10 +849,6 @@ SYSCALL_DEFINE3(setresuid, uid_t, ruid, uid_t, euid, uid_t, suid)
 		new->suid = ksuid;
 	new->fsuid = new->euid;
 
-	retval = security_task_fix_setuid(new, old, LSM_SETID_RES);
-	if (retval < 0)
-		goto error;
-
 	return commit_creds(new);
 
 error:
@@ -987,8 +975,7 @@ SYSCALL_DEFINE1(setfsuid, uid_t, uid)
 	    nsown_capable(CAP_SETUID)) {
 		if (!uid_eq(kuid, old->fsuid)) {
 			new->fsuid = kuid;
-			if (security_task_fix_setuid(new, old, LSM_SETID_FS) == 0)
-				goto change_okay;
+			goto change_okay;
 		}
 	}
 
diff --git a/security/capability.c b/security/capability.c
index fca8896..a65e733 100644
--- a/security/capability.c
+++ b/security/capability.c
@@ -966,7 +966,6 @@ void __init security_fixup_ops(struct security_operations *ops)
 	set_to_cap_if_null(ops, kernel_act_as);
 	set_to_cap_if_null(ops, kernel_create_files_as);
 	set_to_cap_if_null(ops, kernel_module_request);
-	set_to_cap_if_null(ops, task_fix_setuid);
 	set_to_cap_if_null(ops, task_setpgid);
 	set_to_cap_if_null(ops, task_getpgid);
 	set_to_cap_if_null(ops, task_getsid);
diff --git a/security/security.c b/security/security.c
index 5497a57..9814ced 100644
--- a/security/security.c
+++ b/security/security.c
@@ -757,12 +757,6 @@ int security_kernel_module_request(char *kmod_name)
 	return security_ops->kernel_module_request(kmod_name);
 }
 
-int security_task_fix_setuid(struct cred *new, const struct cred *old,
-			     int flags)
-{
-	return security_ops->task_fix_setuid(new, old, flags);
-}
-
 int security_task_setpgid(struct task_struct *p, pid_t pgid)
 {
 	return security_ops->task_setpgid(p, pgid);
-- 
1.7.1

