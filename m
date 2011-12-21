Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223Ab1LUHVZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 02:21:25 -0500
Received: from mga09.intel.com ([134.134.136.24]:56978 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733Ab1LUHVV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 02:21:21 -0500
From: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Subject: [PATCH] Smack: remove task_wait() hook.
Date: Wed, 21 Dec 2011 09:20:52 +0200
Message-Id: <1324452052-5793-1-git-send-email-jarkko.sakkinen@intel.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow SIGCHLD to be passed to child process without
explicit policy. This will help to keep the access
control policy simple and easily maintainable with
complex applications that require use of multiple
security contexts. It will also help to keep them
as isolated as possible.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
---
 security/smack/smack_lsm.c |   40 ----------------------------------------
 1 files changed, 0 insertions(+), 40 deletions(-)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 7db62b4..cc788f5 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -1685,45 +1685,6 @@ static int smack_task_kill(struct task_struct *p, struct siginfo *info,
 }
 
 /**
- * smack_task_wait - Smack access check for waiting
- * @p: task to wait for
- *
- * Returns 0 if current can wait for p, error code otherwise
- */
-static int smack_task_wait(struct task_struct *p)
-{
-	struct smk_audit_info ad;
-	char *sp = smk_of_current();
-	char *tsp = smk_of_forked(task_security(p));
-	int rc;
-
-	/* we don't log here, we can be overriden */
-	rc = smk_access(tsp, sp, MAY_WRITE, NULL);
-	if (rc == 0)
-		goto out_log;
-
-	/*
-	 * Allow the operation to succeed if either task
-	 * has privilege to perform operations that might
-	 * account for the smack labels having gotten to
-	 * be different in the first place.
-	 *
-	 * This breaks the strict subject/object access
-	 * control ideal, taking the object's privilege
-	 * state into account in the decision as well as
-	 * the smack value.
-	 */
-	if (capable(CAP_MAC_OVERRIDE) || has_capability(p, CAP_MAC_OVERRIDE))
-		rc = 0;
-	/* we log only if we didn't get overriden */
- out_log:
-	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_TASK);
-	smk_ad_setfield_u_tsk(&ad, p);
-	smack_log(tsp, sp, MAY_WRITE, rc, &ad);
-	return rc;
-}
-
-/**
  * smack_task_to_inode - copy task smack into the inode blob
  * @p: task to copy from
  * @inode: inode to copy to
@@ -3549,7 +3510,6 @@ struct security_operations smack_ops = {
 	.task_getscheduler = 		smack_task_getscheduler,
 	.task_movememory = 		smack_task_movememory,
 	.task_kill = 			smack_task_kill,
-	.task_wait = 			smack_task_wait,
 	.task_to_inode = 		smack_task_to_inode,
 
 	.ipc_permission = 		smack_ipc_permission,
-- 
1.7.5.4

