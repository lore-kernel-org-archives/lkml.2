Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943Ab2HMLpw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 07:45:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:58061 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448Ab2HMLpu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 07:45:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,759,1336374000"; 
   d="scan'208";a="185664604"
Date: Mon, 13 Aug 2012 14:45:30 +0300
From: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH] Smack: remove task_wait() hook.
Message-ID: <20120813114530.GA4474@jsakkine-mobl1>
References: <1324452052-5793-1-git-send-email-jarkko.sakkinen@intel.com>
 <502459EE.10906@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <502459EE.10906@schaufler-ca.com>
Organization: Intel Finland Oy - BIC 0357606-4 - PL 281, 00181 Helsinki
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2012 at 05:46:38PM -0700, Casey Schaufler wrote:
> On 12/20/2011 11:20 PM, Jarkko Sakkinen wrote:
> > Allow SIGCHLD to be passed to child process without
> > explicit policy. This will help to keep the access
> > control policy simple and easily maintainable with
> > complex applications that require use of multiple
> > security contexts. It will also help to keep them
> > as isolated as possible.
> >
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
> 
> I have a slightly different version that applies to the
> current smack-next tree.
> 
> Allow SIGCHLD to be passed to child process without
> explicit policy. This will help to keep the access
> control policy simple and easily maintainable with
> complex applications that require use of multiple
> security contexts. It will also help to keep them
> as isolated as possible.
> 
> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>

Acked-by: Jarkko Sakkinen <jarkko.sakkinen@intel.com>

> 
>  security/smack/smack_lsm.c |   37 ++++++++-----------------------------
>  1 files changed, 8 insertions(+), 29 deletions(-)
> 
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index 8221514..ce9273a 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -1691,40 +1691,19 @@ static int smack_task_kill(struct task_struct *p, struct siginfo *info,
>   * smack_task_wait - Smack access check for waiting
>   * @p: task to wait for
>   *
> - * Returns 0 if current can wait for p, error code otherwise
> + * Returns 0
>   */
>  static int smack_task_wait(struct task_struct *p)
>  {
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
>  	/*
> -	 * Allow the operation to succeed if either task
> -	 * has privilege to perform operations that might
> -	 * account for the smack labels having gotten to
> -	 * be different in the first place.
> -	 *
> -	 * This breaks the strict subject/object access
> -	 * control ideal, taking the object's privilege
> -	 * state into account in the decision as well as
> -	 * the smack value.
> +	 * Allow the operation to succeed.
> +	 * Zombies are bad.
> +	 * In userless environments (e.g. phones) programs
> +	 * get marked with SMACK64EXEC and even if the parent
> +	 * and child shouldn't be talking the parent still
> +	 * may expect to know when the child exits.
>  	 */
> -	if (smack_privileged(CAP_MAC_OVERRIDE) ||
> -	    has_capability(p, CAP_MAC_OVERRIDE))
> -		rc = 0;
> -	/* we log only if we didn't get overriden */
> - out_log:
> -	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_TASK);
> -	smk_ad_setfield_u_tsk(&ad, p);
> -	smack_log(tsp, sp, MAY_WRITE, rc, &ad);
> -	return rc;
> +	return 0;
>  }
>  
>  /**
> 
> > ---
> >  security/smack/smack_lsm.c |   40 ----------------------------------------
> >  1 files changed, 0 insertions(+), 40 deletions(-)
> >
> > diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> > index 7db62b4..cc788f5 100644
> > --- a/security/smack/smack_lsm.c
> > +++ b/security/smack/smack_lsm.c
> > @@ -1685,45 +1685,6 @@ static int smack_task_kill(struct task_struct *p, struct siginfo *info,
> >  }
> >  
> >  /**
> > - * smack_task_wait - Smack access check for waiting
> > - * @p: task to wait for
> > - *
> > - * Returns 0 if current can wait for p, error code otherwise
> > - */
> > -static int smack_task_wait(struct task_struct *p)
> > -{
> > -	struct smk_audit_info ad;
> > -	char *sp = smk_of_current();
> > -	char *tsp = smk_of_forked(task_security(p));
> > -	int rc;
> > -
> > -	/* we don't log here, we can be overriden */
> > -	rc = smk_access(tsp, sp, MAY_WRITE, NULL);
> > -	if (rc == 0)
> > -		goto out_log;
> > -
> > -	/*
> > -	 * Allow the operation to succeed if either task
> > -	 * has privilege to perform operations that might
> > -	 * account for the smack labels having gotten to
> > -	 * be different in the first place.
> > -	 *
> > -	 * This breaks the strict subject/object access
> > -	 * control ideal, taking the object's privilege
> > -	 * state into account in the decision as well as
> > -	 * the smack value.
> > -	 */
> > -	if (capable(CAP_MAC_OVERRIDE) || has_capability(p, CAP_MAC_OVERRIDE))
> > -		rc = 0;
> > -	/* we log only if we didn't get overriden */
> > - out_log:
> > -	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_TASK);
> > -	smk_ad_setfield_u_tsk(&ad, p);
> > -	smack_log(tsp, sp, MAY_WRITE, rc, &ad);
> > -	return rc;
> > -}
> > -
> > -/**
> >   * smack_task_to_inode - copy task smack into the inode blob
> >   * @p: task to copy from
> >   * @inode: inode to copy to
> > @@ -3549,7 +3510,6 @@ struct security_operations smack_ops = {
> >  	.task_getscheduler = 		smack_task_getscheduler,
> >  	.task_movememory = 		smack_task_movememory,
> >  	.task_kill = 			smack_task_kill,
> > -	.task_wait = 			smack_task_wait,
> >  	.task_to_inode = 		smack_task_to_inode,
> >  
> >  	.ipc_permission = 		smack_ipc_permission,
> 

/Jarkko
