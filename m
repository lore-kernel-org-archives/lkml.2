Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016Ab0KBQFV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 12:05:21 -0400
Received: from www.tglx.de ([62.245.132.106]:40862 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752701Ab0KBQFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 12:05:13 -0400
Date: Tue, 2 Nov 2010 17:04:33 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] posix-cpu-timers: rcu_read_lock/unlock protect
 find_task_by_vpid call
In-Reply-To: <20101102160223.GC5964@swordfish.minsk.epam.com>
Message-ID: <alpine.LFD.2.00.1011021704110.9357@localhost6.localdomain6>
References: <20101102135821.GA5964@swordfish.minsk.epam.com> <alpine.LFD.2.00.1011021630150.9357@localhost6.localdomain6> <20101102160223.GC5964@swordfish.minsk.epam.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just added Oleg to the cc-list

On Tue, 2 Nov 2010, Sergey Senozhatsky wrote:

> On (11/02/10 16:31), Thomas Gleixner wrote:
> > On Tue, 2 Nov 2010, Sergey Senozhatsky wrote:
> > 
> > > Commit 4221a9918e38b7494cee341dda7b7b4bb8c04bde "Add RCU check for
> > > find_task_by_vpid()" introduced rcu_lockdep_assert to find_task_by_pid_ns.
> > > Add rcu_read_lock/rcu_read_unlock to call find_task_by_vpid.
> > > 
> > > Tetsuo Handa wrote:
> > > 
> > > Quoting from one of posts in that thead
> > > http://kerneltrap.org/mailarchive/linux-kernel/2010/2/8/4536388
> > > 
> > > | Usually tasklist gives enough protection, but if copy_process() fails
> > > | it calls free_pid() lockless and does call_rcu(delayed_put_pid().   
> > > | This means, without rcu lock find_pid_ns() can't scan the hash table
> > > | safely.
> > 
> > We can remove the tasklist_lock while at it. rcu_read_lock is enough.
> > 
> 
> Please kindly review.
> 
> ---
> 
> diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
> index 6842eeb..96fe2a3 100644
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
>  		   same_thread_group(p, current) : thread_group_leader(p))) {
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
> 
