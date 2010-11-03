Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077Ab0KCMzK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 08:55:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4804 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753006Ab0KCMzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 08:55:07 -0400
Date: Wed, 3 Nov 2010 13:48:35 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: [PATCH] posix-cpu-timers: rcu_read_lock/unlock protect
	find_task_by_vpid call
Message-ID: <20101103124835.GA604@redhat.com>
References: <20101102135821.GA5964@swordfish.minsk.epam.com> <alpine.LFD.2.00.1011021630150.9357@localhost6.localdomain6> <20101102160223.GC5964@swordfish.minsk.epam.com> <alpine.LFD.2.00.1011021704110.9357@localhost6.localdomain6> <20101102183308.GA17720@redhat.com> <20101103105832.GA30053@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101103105832.GA30053@swordfish.minsk.epam.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Damn.

Sergey, Thomas, please wait a bit.

Yes, I believe this patch is fine by itself. But looking into
posix-cpu-timers.c again, I suspect that those "other problems
with de_thread" I already mentioned are much more serious and
need the urgent fix.

I'll try to verify this a bit later today.

In any case, I believe someone should find the time to audit/
rewrite posix-cpu-timers.c ;)

On 11/03, Sergey Senozhatsky wrote:
>
> On (11/02/10 19:33), Oleg Nesterov wrote:
> > > On Tue, 2 Nov 2010, Sergey Senozhatsky wrote:
> > >
> > > > > We can remove the tasklist_lock while at it. rcu_read_lock is enough.
> > > > >
> >
> > Yes, I believe posix-cpu-timers.c shouldn't use tasklist at all,
> > but it is not trivial to change this code.
> >
> >[..]
> >
> > I think this change is fine, but please note that thread_group_leader()
> > check is not relaible without tasklist. If we race with de_thread()
> > find_task_by_vpid() can find the new leader before it updates its
> > ->group_leader. IOW, posix_cpu_timer_create() can fail when it shouldn't.
> >
> > Not that I think this really matters, posix_cpu_timer_create() has
> > other problems with de_thread(). But perhaps it makes sense to
> > change posix_cpu_timer_create() to use has_group_leader_pid() instead,
> > just to make this code not look racy and avoid adding new problems.
> >
> > The real fix, I think, should change cpu_timer_list to use
> > struct pid* instead of task_struct.
> >
>
> Hello,
> Using has_group_leader_pid instead of thread_group_leader, when tasklist_lock
> is not aquired (check_clock and posix_cpu_timer_create).
>
> ---
>
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
>



