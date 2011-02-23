Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932462Ab1BWTXE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 14:23:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43546 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932298Ab1BWTXC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 14:23:02 -0500
Date: Wed, 23 Feb 2011 20:14:42 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Stas Sergeev <stsp@aknet.ru>
Cc: Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [path][rfc] add PR_DETACH prctl command
Message-ID: <20110223191442.GA717@redhat.com>
References: <4D6510A3.90905@aknet.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6510A3.90905@aknet.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23, Stas Sergeev wrote:
>
> Hi.
>
> The attched patch adds the PR_DETACH prctl command.

Hi. The patch doesn't look right at first glance, but to me
this is not the main problem.

> It is needed for those rare but unfortunate cases, where
> you can't daemonize your process before creating a thread.
> The effect of this command is similar to the fork() and then
> exit() on parent, except that:
> 1. PID does not change
> 2. Threads are not destroyed
>
> It would be nice to know what people think about such an
> approach.

Well. You should somehow convince people we need this ;) This is
the main problem.

I am not going to discuss this, I never know when it comes to the
new feautures. And you need the authoritative ack, probably you
can ask Linus + Roland directly.

As for the patch itself,

> +static int wait_task_detached(struct wait_opts *wo, struct task_struct *p)
> +{
> +	int retval = 0;
> +	pid_t pid = task_pid_vnr(p);
> +	uid_t uid = __task_cred(p)->uid;
> +
> +	get_task_struct(p);
> +	if (unlikely(wo->wo_flags & WNOWAIT)) {
> +		read_unlock(&tasklist_lock);
> +		return wait_noreap_copyout(wo, p, pid, uid, CLD_DETACHED,
> +			p->exit_code >> 8);
> +	}
> +
> +	p->flags &= ~PF_DETACH;

Only current can change its ->flags, this is racy

> +	if (!ptrace_reparented(p))
> +		p->parent = init_pid_ns.child_reaper;
> +	p->real_parent = init_pid_ns.child_reaper;
> +	p->exit_signal = SIGCHLD;
> +	list_move_tail(&p->sibling, &p->real_parent->children);

No, we can't do this under read_lock(tasklist). And you forgot about
threads, they also have ->real_parent == old_parent.

The usage of ->exit_code doesn't look right, espeicaily if it is traced.

And other problems afaics....

> @@ -1549,6 +1581,9 @@ static int wait_consider_task(struct wait_opts *wo, int ptrace,
>  	if (p->exit_state == EXIT_DEAD)
>  		return 0;
>
> +	if (p->flags & PF_DETACH)
> +		return wait_task_detached(wo, p);

What if it is already dead? We are goint to reparent it, but init
won't notice the new zombie.

And what if do_wait() was called without WEXITED? say, the old parent
does waitpid(WSTOPPED).

> @@ -1450,10 +1450,10 @@ int do_notify_parent(struct task_struct *tsk, int sig)
>  
>  	BUG_ON(sig == -1);
>  
> - 	/* do_notify_parent_cldstop should have been called instead.  */
> - 	BUG_ON(task_is_stopped_or_traced(tsk));
> +	/* do_notify_parent_cldstop should have been called instead.  */
> +	BUG_ON(task_is_stopped_or_traced(tsk));
>  
> -	BUG_ON(!task_ptrace(tsk) &&
> +	BUG_ON(!task_ptrace(tsk) && (tsk->flags & PF_EXITING) &&
>  	       (tsk->group_leader != tsk || !thread_group_empty(tsk)));

Afaics, you are trying to hide the problem.... The code below can make
tsk detached if real_parent ignores SIGCHLD.

> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -1736,6 +1736,22 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
>  			else
>  				error = PR_MCE_KILL_DEFAULT;
>  			break;
> +		case PR_DETACH:
> +			error = -EPERM;
> +			/* if parent is init, or not a group leader - bail */
> +			if (me->real_parent == init_pid_ns.child_reaper)

This is not exactly right. What if the child of init's sub-thread
does PR_DETACH?

Oleg.

