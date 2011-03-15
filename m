Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758201Ab1CORos (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 13:44:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5521 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758160Ab1CORoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 13:44:46 -0400
Subject: Re: PATCH [1/1]: audit: acquire creds selectively to reduce atomic
 op overhead
From: Eric Paris <eparis@redhat.com>
To: Tony Jones <tonyj@suse.de>
Cc: David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
        linux-audit@redhat.com, Al Viro <viro@zeniv.linux.org.uk>
Date: Tue, 15 Mar 2011 13:44:36 -0400
In-Reply-To: <20110315173810.GA12775@suse.de>
References: <20110310202516.GA16122@suse.de> <20110307210656.GA1750@suse.de>
	 <18893.1299607373@redhat.com> <29980.1299861232@redhat.com>
	 <20110315173810.GA12775@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1300211077.3748.2.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-15 at 10:38 -0700, Tony Jones wrote:
> On Fri, Mar 11, 2011 at 04:33:52PM +0000, David Howells wrote:
> > get_task_cred() and task_cred_xxxx() call __task_cred() which uses
> 
> Sorry, I thought you were referring to the remainder of auditsc.c
> 
> > It's possible that the credentials being used in audit_filter_rules() are
> > incorrect under most circumstances and should be task->cred, not
> > task->real_cred.
> 
> Agree. Also I believe it is safe to use tsk->cred directly as tsk == current 
> or tsk is being created by copy_process.

Is there any way we can enforce this condition in the code?
WARN_ON(cred != current->cred && cred->refcnt != 1) or something like
that (I just made that conditional up off the top of my head, but it
explains what I'm talking about)?  Who knows what somebody else might do
with this code someday.....

> Eric, can you ACK/NACK?
> 
> The following patch corresponds to the above.
> 
> Tony
> ---
> 
> 
> Commit c69e8d9c01db added calls to get_task_cred and put_cred in
> audit_filter_rules.  Profiling with a large number of audit rules active on the
> exit chain shows that we are spending upto 48% in this routine for syscall 
> intensive tests, most of which is in the atomic ops.
> 
> The code should be accessing tsk->cred rather than tsk->real_cred.  Also, since
> tsk is current (or tsk is being created by copy_process) direct access to 
> tsk->cred is possible.
> 
> Signed-off-by: Tony Jones <tonyj@suse.de>

Acked-by: Eric Paris <eparis@redhat.com>

> ---
> 
>  kernel/auditsc.c |   18 ++++++++++--------
>  1 files changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> index f49a031..750c08ef 100644
> --- a/kernel/auditsc.c
> +++ b/kernel/auditsc.c
> @@ -441,16 +441,21 @@ static int match_tree_refs(struct audit_context *ctx, struct audit_tree *tree)
>  	return 0;
>  }
>  
> -/* Determine if any context name data matches a rule's watch data */
> -/* Compare a task_struct with an audit_rule.  Return 1 on match, 0
> - * otherwise. */
> +/*
> + * Determine if any context name data matches a rule's watch data
> + * Compare a task_struct with an audit_rule.  Return 1 on match, 0
> + * otherwise.
> + *
> + * Note: tsk==current or we are being indirectly called from copy_process()
> + * so direct access to tsk->cred is allowed.
> + */
>  static int audit_filter_rules(struct task_struct *tsk,
>  			      struct audit_krule *rule,
>  			      struct audit_context *ctx,
>  			      struct audit_names *name,
>  			      enum audit_state *state)
>  {
> -	const struct cred *cred = get_task_cred(tsk);
> +	const struct cred *cred = tsk->cred;
>  	int i, j, need_sid = 1;
>  	u32 sid;
>  
> @@ -637,10 +642,8 @@ static int audit_filter_rules(struct task_struct *tsk,
>  			break;
>  		}
>  
> -		if (!result) {
> -			put_cred(cred);
> +		if (!result)
>  			return 0;
> -		}
>  	}
>  
>  	if (ctx) {
> @@ -656,7 +659,6 @@ static int audit_filter_rules(struct task_struct *tsk,
>  	case AUDIT_NEVER:    *state = AUDIT_DISABLED;	    break;
>  	case AUDIT_ALWAYS:   *state = AUDIT_RECORD_CONTEXT; break;
>  	}
> -	put_cred(cred);
>  	return 1;
>  }
>  


