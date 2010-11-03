Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090Ab0KCRYS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 13:24:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48736 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753115Ab0KCRYR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 13:24:17 -0400
Date: Wed, 3 Nov 2010 18:17:18 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: [PATCH] posix-cpu-timers: rcu_read_lock/unlock protect
	find_task_by_vpid call
Message-ID: <20101103171718.GA17338@redhat.com>
References: <20101102135821.GA5964@swordfish.minsk.epam.com> <alpine.LFD.2.00.1011021630150.9357@localhost6.localdomain6> <20101102160223.GC5964@swordfish.minsk.epam.com> <alpine.LFD.2.00.1011021704110.9357@localhost6.localdomain6> <20101102183308.GA17720@redhat.com> <20101103105832.GA30053@swordfish.minsk.epam.com> <20101103124835.GA604@redhat.com> <20101103161059.GA13530@redhat.com> <20101103165256.GD30053@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101103165256.GD30053@swordfish.minsk.epam.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03, Sergey Senozhatsky wrote:
>
> Commit 4221a9918e38b7494cee341dda7b7b4bb8c04bde "Add RCU check for
> find_task_by_vpid()" introduced rcu_lockdep_assert to find_task_by_pid_ns.
> Add rcu_read_lock/rcu_read_unlock to call find_task_by_vpid.
>
> Tetsuo Handa wrote:
> | Quoting from one of posts in that thead
> | http://kerneltrap.org/mailarchive/linux-kernel/2010/2/8/4536388
> |
> || Usually tasklist gives enough protection, but if copy_process() fails
> || it calls free_pid() lockless and does call_rcu(delayed_put_pid().
> || This means, without rcu lock find_pid_ns() can't scan the hash table
> || safely.
>
> Thomas Gleixner wrote:
> | We can remove the tasklist_lock while at it. rcu_read_lock is enough.
>
> Patch also replaces thread_group_leader with has_group_leader_pid
> in accordance to comment by Oleg Nesterov:
>
> | ... thread_group_leader() check is not relaible without
> | tasklist. If we race with de_thread() find_task_by_vpid() can find
> | the new leader before it updates its ->group_leader.
> |
> | perhaps it makes sense to change posix_cpu_timer_create() to use
> | has_group_leader_pid() instead, just to make this code not look racy
> | and avoid adding new problems.
>
>
> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

Reviewed-by: Oleg Nesterov <oleg@redhat.com>


> diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
> index 6842eeb..05bb717 100644
> --- a/kernel/posix-cpu-timers.c
> +++ b/kernel/posix-cpu-timers.c
> @@ -37,13 +37,13 @@ static int check_clock(const clockid_t which_clock)
>  	if (pid == 0)
>  		return 0;
>
> -	read_lock(&tasklist_lock);
> +	rcu_read_lock();
>  	p = find_task_by_vpid(pid);
>  	if (!p || !(CPUCLOCK_PERTHREAD(which_clock) ?
> -		   same_thread_group(p, current) : thread_group_leader(p))) {
> +		   same_thread_group(p, current) : has_group_leader_pid(p))) {
>  		error = -EINVAL;
>  	}
> -	read_unlock(&tasklist_lock);
> +	rcu_read_unlock();
>
>  	return error;
>  }
> @@ -390,7 +390,7 @@ int posix_cpu_timer_create(struct k_itimer *new_timer)
>
>  	INIT_LIST_HEAD(&new_timer->it.cpu.entry);
>
> -	read_lock(&tasklist_lock);
> +	rcu_read_lock();
>  	if (CPUCLOCK_PERTHREAD(new_timer->it_clock)) {
>  		if (pid == 0) {
>  			p = current;
> @@ -404,7 +404,7 @@ int posix_cpu_timer_create(struct k_itimer *new_timer)
>  			p = current->group_leader;
>  		} else {
>  			p = find_task_by_vpid(pid);
> -			if (p && !thread_group_leader(p))
> +			if (p && !has_group_leader_pid(p))
>  				p = NULL;
>  		}
>  	}
> @@ -414,7 +414,7 @@ int posix_cpu_timer_create(struct k_itimer *new_timer)
>  	} else {
>  		ret = -EINVAL;
>  	}
> -	read_unlock(&tasklist_lock);
> +	rcu_read_unlock();
>
>  	return ret;
>  }
>

