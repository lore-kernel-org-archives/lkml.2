Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534Ab1IRRln (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 13:41:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50584 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754586Ab1IRRlm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 13:41:42 -0400
Date: Sun, 18 Sep 2011 19:37:23 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <htejun@gmail.com>
Cc: rjw@sisk.pl, paul@paulmenage.org, lizf@cn.fujitsu.com,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, fweisbec@gmail.com,
        matthltc@us.ibm.com, akpm@linux-foundation.org,
        Tejun Heo <tj@kernel.org>, Paul Menage <menage@google.com>,
        Ben Blum <bblum@andrew.cmu.edu>
Subject: Re: [PATCH 3/4] threadgroup: extend threadgroup_lock() to cover
	exit and exec
Message-ID: <20110918173723.GA2384@redhat.com>
References: <1315159280-25032-1-git-send-email-htejun@gmail.com> <1315159280-25032-4-git-send-email-htejun@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315159280-25032-4-git-send-email-htejun@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Sorry for the late reply.

Of course I am in no position to ack the changes in this code, I do not
fell I understand it enough. But afaics this series is fine.

A couple of questions.

On 09/05, Tejun Heo wrote:
>
> For exec, threadgroup_[un]lock() are updated to also grab and release
> cred_guard_mutex.

OK, this means that we do not need

	cgroups-more-safe-tasklist-locking-in-cgroup_attach_proc.patch
	http://marc.info/?l=linux-mm-commits&m=131491135428326&w=2

Ben, what do you think?

> With this change, threadgroup_lock() guarantees that the target
> threadgroup will remain stable - no new task will be added, no new
> PF_EXITING will be set and exec won't happen.

To me, this is the only "contradictory" change,

> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -936,6 +936,12 @@ NORET_TYPE void do_exit(long code)
>  		schedule();
>  	}
>
> +	/*
> +	 * @tsk's threadgroup is going through changes - lock out users
> +	 * which expect stable threadgroup.
> +	 */
> +	threadgroup_change_begin(tsk);
> +
>  	exit_irq_thread();
>
>  	exit_signals(tsk);  /* sets PF_EXITING */
> @@ -1018,10 +1024,6 @@ NORET_TYPE void do_exit(long code)
>  		kfree(current->pi_state_cache);
>  #endif
>  	/*
> -	 * Make sure we are holding no locks:
> -	 */
> -	debug_check_no_locks_held(tsk);
> -	/*
>  	 * We can do this unlocked here. The futex code uses this flag
>  	 * just to verify whether the pi state cleanup has been done
>  	 * or not. In the worst case it loops once more.
> @@ -1039,6 +1041,12 @@ NORET_TYPE void do_exit(long code)
>  	preempt_disable();
>  	exit_rcu();
>
> +	/*
> +	 * Release threadgroup and make sure we are holding no locks.
> +	 */
> +	threadgroup_change_done(tsk);

I am wondering, can't we narrow the scope of threadgroup_change_begin/done
in do_exit() path?

The code after 4/4 still has to check PF_EXITING, this is correct. And yes,
with this patch PF_EXITING becomes stable under ->group_rwsem. But, it seems,
we do not really need this?

I mean, can't we change cgroup_exit() to do threadgroup_change_begin/done
instead? We do not really care about PF_EXITING, we only need to ensure that
we can't race with cgroup_exit(), right?

Say, cgroup_attach_proc() does

	do {
		if (tsk->flags & PF_EXITING)
			continue;

		flex_array_put_ptr(group, tsk);
	} while_each_thread();

Yes, this tsk can call do_exit() and set PF_EXITING right after the check
but this is fine. The only guarantee we need is: if it has already called
cgroup_exit() we can not miss PF_EXITING, and if cgroup_exit() takes the
same sem this should be true. And, otoh, if we do not see PF_EXITING then
we can not race with cgroup_exit(), it should block on ->group_rwsem hold
by us.

If I am right, afaics the only change 4/4 needs is that it should not add
WARN_ON_ONCE(tsk->flags & PF_EXITING) into cgroup_task_migrate().

What do you think?

Oleg.

