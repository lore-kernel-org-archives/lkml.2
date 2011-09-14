Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594Ab1INNCZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 09:02:25 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:34954 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756345Ab1INNCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 09:02:24 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/eT0kD1XXe0/Bdl/lpXlR2AT5/RONOlCYK6ifiHC
	BMb37gl2QvVb6D
Subject: Re: [PATCH -rt] ipc/sem: Rework semaphore wakeups
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Manfred Spraul <manfred@colorfullife.com>
In-Reply-To: <1315994224.5040.1.camel@twins>
References: <alpine.LFD.2.02.1109101052340.2723@ionos>
	 <1315737307.6544.1.camel@marge.simson.net>
	 <1315817948.26517.16.camel@twins>
	 <1315835562.6758.3.camel@marge.simson.net>
	 <1315839187.6758.8.camel@marge.simson.net> <1315926499.5977.19.camel@twins>
	 <1315927699.6445.6.camel@marge.simson.net>  <1315994224.5040.1.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Sep 2011 15:02:19 +0200
Message-ID: <1316005339.6497.0.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All better.

On Wed, 2011-09-14 at 11:57 +0200, Peter Zijlstra wrote:
> Subject: ipc/sem: Rework semaphore wakeups
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Tue Sep 13 15:09:40 CEST 2011
> 
> Current sysv sems have a weird ass wakeup scheme that involves keeping
> preemption disabled over a potential O(n^2) loop and busy waiting on
> that on other CPUs.
> 
> Kill this and simply wake the task directly from under the sem_lock.
> 
> This was discovered by a migrate_disable() debug feature that
> disallows:
> 
>   spin_lock();
>   preempt_disable();
>   spin_unlock()
>   preempt_enable();
> 
> Cc: Manfred Spraul <manfred@colorfullife.com>
> Suggested-by: Thomas Gleixner <tglx@linutronix.de>
> Reported-by: Mike Galbraith <efault@gmx.de>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  ipc/sem.c |   10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> Index: linux-rt/ipc/sem.c
> ===================================================================
> --- linux-rt.orig/ipc/sem.c
> +++ linux-rt/ipc/sem.c
> @@ -415,6 +415,13 @@ static int try_atomic_semop (struct sem_
>  static void wake_up_sem_queue_prepare(struct list_head *pt,
>  				struct sem_queue *q, int error)
>  {
> +#ifdef CONFIG_PREEMPT_RT_BASE
> +	struct task_struct *p = q->sleeper;
> +	get_task_struct(p);
> +	q->status = error;
> +	wake_up_process(p);
> +	put_task_struct(p);
> +#else
>  	if (list_empty(pt)) {
>  		/*
>  		 * Hold preempt off so that we don't get preempted and have the
> @@ -426,6 +433,7 @@ static void wake_up_sem_queue_prepare(st
>  	q->pid = error;
>  
>  	list_add_tail(&q->simple_list, pt);
> +#endif
>  }
>  
>  /**
> @@ -439,6 +447,7 @@ static void wake_up_sem_queue_prepare(st
>   */
>  static void wake_up_sem_queue_do(struct list_head *pt)
>  {
> +#ifndef CONFIG_PREEMPT_RT_BASE
>  	struct sem_queue *q, *t;
>  	int did_something;
>  
> @@ -451,6 +460,7 @@ static void wake_up_sem_queue_do(struct
>  	}
>  	if (did_something)
>  		preempt_enable();
> +#endif
>  }
>  
>  static void unlink_queue(struct sem_array *sma, struct sem_queue *q)
> 


