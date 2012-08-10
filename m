Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484Ab2HJAqe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 20:46:34 -0400
Received: from nm30-vm0.access.bullet.mail.mud.yahoo.com ([66.94.237.86]:47247
	"HELO nm30-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752588Ab2HJAqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 20:46:32 -0400
X-Yahoo-Newman-Id: 247941.29015.bm@smtp110.biz.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: tuECYMYVM1mubWlVpy5vo3eoijUftU0q3Oo9bKTP26Ew5MU
 Zv9TWAO1uQB0OCAgSkm0O9VHEAKj87ZvviDGK9L6R5kQ5UC7oDpxrW7nU3zG
 QeJx80eArTg1n6bOM6F_ZwqqoxIt9K4MPEoAJLB5IKvpUXwIMnT1CwalCeN9
 3uAh9ctSKkIqsabQ_06Tl0UaIiMh3BnF2ZQ.0_mJqBvyUgBFAB_2_6GGANBJ
 dPZ1U1_c7eR6xXPwicMiWGNZSnOIpusHEfe1wbeGmraBsHqtcLHZKNOWrTu9
 BdqnxGtFoMeOp66g4rm5LK5LfPywJv9IJgQFwCJg3iSUZ7su_3Pbh3s_ThLT
 2Vk0iOsH.Azeq_GHggjp2i50M4hw5GPfUNWSNNlY36lUHJnf22KQB33oqXtG
 99BsmqcG0P9zYl9HnieC3mzk17D9OK45h79QIpTR8EElxGEPhHvIYZPPg5Q0
 MlSg-
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <502459EE.10906@schaufler-ca.com>
Date: Thu, 09 Aug 2012 17:46:38 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
CC: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH] Smack: remove task_wait() hook.
References: <1324452052-5793-1-git-send-email-jarkko.sakkinen@intel.com>
In-Reply-To: <1324452052-5793-1-git-send-email-jarkko.sakkinen@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2011 11:20 PM, Jarkko Sakkinen wrote:
> Allow SIGCHLD to be passed to child process without
> explicit policy. This will help to keep the access
> control policy simple and easily maintainable with
> complex applications that require use of multiple
> security contexts. It will also help to keep them
> as isolated as possible.
>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@intel.com>

I have a slightly different version that applies to the
current smack-next tree.

Allow SIGCHLD to be passed to child process without
explicit policy. This will help to keep the access
control policy simple and easily maintainable with
complex applications that require use of multiple
security contexts. It will also help to keep them
as isolated as possible.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>

 security/smack/smack_lsm.c |   37 ++++++++-----------------------------
 1 files changed, 8 insertions(+), 29 deletions(-)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 8221514..ce9273a 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -1691,40 +1691,19 @@ static int smack_task_kill(struct task_struct *p, struct siginfo *info,
  * smack_task_wait - Smack access check for waiting
  * @p: task to wait for
  *
- * Returns 0 if current can wait for p, error code otherwise
+ * Returns 0
  */
 static int smack_task_wait(struct task_struct *p)
 {
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
 	/*
-	 * Allow the operation to succeed if either task
-	 * has privilege to perform operations that might
-	 * account for the smack labels having gotten to
-	 * be different in the first place.
-	 *
-	 * This breaks the strict subject/object access
-	 * control ideal, taking the object's privilege
-	 * state into account in the decision as well as
-	 * the smack value.
+	 * Allow the operation to succeed.
+	 * Zombies are bad.
+	 * In userless environments (e.g. phones) programs
+	 * get marked with SMACK64EXEC and even if the parent
+	 * and child shouldn't be talking the parent still
+	 * may expect to know when the child exits.
 	 */
-	if (smack_privileged(CAP_MAC_OVERRIDE) ||
-	    has_capability(p, CAP_MAC_OVERRIDE))
-		rc = 0;
-	/* we log only if we didn't get overriden */
- out_log:
-	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_TASK);
-	smk_ad_setfield_u_tsk(&ad, p);
-	smack_log(tsp, sp, MAY_WRITE, rc, &ad);
-	return rc;
+	return 0;
 }
 
 /**

> ---
>  security/smack/smack_lsm.c |   40 ----------------------------------------
>  1 files changed, 0 insertions(+), 40 deletions(-)
>
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index 7db62b4..cc788f5 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -1685,45 +1685,6 @@ static int smack_task_kill(struct task_struct *p, struct siginfo *info,
>  }
>  
>  /**
> - * smack_task_wait - Smack access check for waiting
> - * @p: task to wait for
> - *
> - * Returns 0 if current can wait for p, error code otherwise
> - */
> -static int smack_task_wait(struct task_struct *p)
> -{
> -	struct smk_audit_info ad;
> -	char *sp = smk_of_current();
> -	char *tsp = smk_of_forked(task_security(p));
> -	int rc;
> -
> -	/* we don't log here, we can be overriden */
> -	rc = smk_access(tsp, sp, MAY_WRITE, NULL);
> -	if (rc == 0)
> -		goto out_log;
> -
> -	/*
> -	 * Allow the operation to succeed if either task
> -	 * has privilege to perform operations that might
> -	 * account for the smack labels having gotten to
> -	 * be different in the first place.
> -	 *
> -	 * This breaks the strict subject/object access
> -	 * control ideal, taking the object's privilege
> -	 * state into account in the decision as well as
> -	 * the smack value.
> -	 */
> -	if (capable(CAP_MAC_OVERRIDE) || has_capability(p, CAP_MAC_OVERRIDE))
> -		rc = 0;
> -	/* we log only if we didn't get overriden */
> - out_log:
> -	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_TASK);
> -	smk_ad_setfield_u_tsk(&ad, p);
> -	smack_log(tsp, sp, MAY_WRITE, rc, &ad);
> -	return rc;
> -}
> -
> -/**
>   * smack_task_to_inode - copy task smack into the inode blob
>   * @p: task to copy from
>   * @inode: inode to copy to
> @@ -3549,7 +3510,6 @@ struct security_operations smack_ops = {
>  	.task_getscheduler = 		smack_task_getscheduler,
>  	.task_movememory = 		smack_task_movememory,
>  	.task_kill = 			smack_task_kill,
> -	.task_wait = 			smack_task_wait,
>  	.task_to_inode = 		smack_task_to_inode,
>  
>  	.ipc_permission = 		smack_ipc_permission,

