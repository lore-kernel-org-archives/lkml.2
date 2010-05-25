Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757773Ab0EYLbs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 07:31:48 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40090 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835Ab0EYLbr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 07:31:47 -0400
Subject: Re: [PATCH] Make sure timers have migrated before killing
 migration_thread
From: Peter Zijlstra <peterz@infradead.org>
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Cc: tj@kernel.org, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>, Darren Hart <dvhltc@us.ibm.com>,
       Brian King <brking@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20100524095951.GA17680@amitarora.in.ibm.com>
References: <20100519090557.GA15237@amitarora.in.ibm.com>
	 <1274261515.5605.10423.camel@twins>
	 <20100524095951.GA17680@amitarora.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 25 May 2010 13:31:35 +0200
Message-ID: <1274787095.5882.949.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-24 at 15:29 +0530, Amit K. Arora wrote:
> 
> Thus, since above race can never happen, is there any other issue with
> this patch ?

It doesn't seem to apply nicely...

> 
> Signed-off-by: Amit Arora <aarora@in.ibm.com>
> Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
> ---
> diff -Nuarp linux-2.6.34.org/kernel/sched.c linux-2.6.34/kernel/sched.c
> --- linux-2.6.34.org/kernel/sched.c     2010-05-18 22:56:21.000000000 -0700
> +++ linux-2.6.34/kernel/sched.c 2010-05-18 22:58:31.000000000 -0700
> @@ -5942,14 +5942,26 @@ migration_call(struct notifier_block *nf
>                 cpu_rq(cpu)->migration_thread = NULL;
>                 break;
>  
> +       case CPU_POST_DEAD:
> +               /*
> +                * Bring the migration thread down in CPU_POST_DEAD event,
> +                * since the timers should have got migrated by now and thus
> +                * we should not see a deadlock between trying to kill the
> +                * migration thread and the sched_rt_period_timer.
> +                */
> +               cpuset_lock();
> +               rq = cpu_rq(cpu);
> +               kthread_stop(rq->migration_thread);
> +               put_task_struct(rq->migration_thread);
> +               rq->migration_thread = NULL;
> +               cpuset_unlock();
> +               break;
> +
>         case CPU_DEAD:
>         case CPU_DEAD_FROZEN:
>                 cpuset_lock(); /* around calls to cpuset_cpus_allowed_lock() */
>                 migrate_live_tasks(cpu);
>                 rq = cpu_rq(cpu);
> -               kthread_stop(rq->migration_thread);
> -               put_task_struct(rq->migration_thread);
> -               rq->migration_thread = NULL;
>                 /* Idle task back to normal (off runqueue, low prio) */
>                 raw_spin_lock_irq(&rq->lock);
>                 update_rq_clock(rq);
> 
> 
