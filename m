Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935960Ab2JYRST (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 13:18:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58672 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757204Ab2JYRSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 13:18:17 -0400
Date: Thu, 25 Oct 2012 10:18:12 -0700
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/1] freezer: change ptrace_stop/do_signal_stop to use
 freezable_schedule()
Message-ID: <20121025171812.GE11442@htj.dyndns.org>
References: <1350426526-14254-1-git-send-email-tj@kernel.org>
 <1350426526-14254-3-git-send-email-tj@kernel.org>
 <20121022174404.GA21553@redhat.com>
 <20121022211317.GD5951@atj.dyndns.org>
 <20121023153919.GA16201@redhat.com>
 <20121024185710.GA12182@atj.dyndns.org>
 <20121025163941.GA3801@redhat.com>
 <20121025163959.GB3801@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121025163959.GB3801@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Oleg.

On Thu, Oct 25, 2012 at 06:39:59PM +0200, Oleg Nesterov wrote:
> Change ptrace_stop() and do_signal_stop() to use freezable_schedule()
> rather than rely on subsequent try_to_freeze().
> 
> This allows to remove the task_is_stopped_or_traced() checks from
> try_to_freeze_tasks() and update_if_frozen(), and this fixes the
> unlikely race with ptrace_stop(). If the tracee does not schedule()
> it can miss a freezing condition.

I think it would be great if the description is more detailed.  This
code path always makes my head spin and I think we can definitely use
some more guiding in understanding this dang thing. :)

> @@ -48,18 +48,7 @@ static int try_to_freeze_tasks(bool user_only)
>  			if (p == current || !freeze_task(p))
>  				continue;
>  
> -			/*
> -			 * Now that we've done set_freeze_flag, don't
> -			 * perturb a task in TASK_STOPPED or TASK_TRACED.
> -			 * It is "frozen enough".  If the task does wake
> -			 * up, it will immediately call try_to_freeze.
> -			 *
> -			 * Because freeze_task() goes through p's scheduler lock, it's
> -			 * guaranteed that TASK_STOPPED/TRACED -> TASK_RUNNING
> -			 * transition can't race with task state testing here.
> -			 */
> -			if (!task_is_stopped_or_traced(p) &&
> -			    !freezer_should_skip(p))
> +			if (!freezer_should_skip(p))
>  				todo++;
>  		} while_each_thread(g, p);
>  		read_unlock(&tasklist_lock);

This looks really good.

> diff --git a/kernel/signal.c b/kernel/signal.c
> index 0af8868..1660d7d 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -1908,7 +1908,7 @@ static void ptrace_stop(int exit_code, int why, int clear_code, siginfo_t *info)
>  		preempt_disable();
>  		read_unlock(&tasklist_lock);
>  		preempt_enable_no_resched();
> -		schedule();
> +		freezable_schedule();
>  	} else {
>  		/*
>  		 * By the time we got the lock, our tracer went away.
> @@ -1930,13 +1930,6 @@ static void ptrace_stop(int exit_code, int why, int clear_code, siginfo_t *info)
>  	}
>  
>  	/*
> -	 * While in TASK_TRACED, we were considered "frozen enough".
> -	 * Now that we woke up, it's crucial if we're supposed to be
> -	 * frozen that we freeze now before running anything substantial.
> -	 */
> -	try_to_freeze();
> -
> -	/*
>  	 * We are back.  Now reacquire the siglock before touching
>  	 * last_siginfo, so that we are sure to have synchronized with
>  	 * any signal-sending on another CPU that wants to examine it.
> @@ -2092,7 +2085,7 @@ static bool do_signal_stop(int signr)
>  		}
>  
>  		/* Now we don't run again until woken by SIGCONT or SIGKILL */
> -		schedule();
> +		freezable_schedule();

This makes me wonder whether we still need try_to_freeze() in
get_signal_to_deliver() right after the relock: label.  Freezer no
longer treats STOPPED/TRACED special and both sleeping sites in signal
deliver path are marked freezable_schedule().  We shouldn't need the
explicit try_to_freeze(), right?

Thanks.

-- 
tejun
