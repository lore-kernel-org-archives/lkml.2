Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790Ab0EXKAb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 06:00:31 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:42983 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753715Ab0EXKA3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 06:00:29 -0400
Date: Mon, 24 May 2010 15:29:51 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: tj@kernel.org, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>, Darren Hart <dvhltc@us.ibm.com>,
       Brian King <brking@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make sure timers have migrated before killing
	migration_thread
Message-ID: <20100524095951.GA17680@amitarora.in.ibm.com>
References: <20100519090557.GA15237@amitarora.in.ibm.com> <1274261515.5605.10423.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274261515.5605.10423.camel@twins>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19, 2010 at 11:31:55AM +0200, Peter Zijlstra wrote:
> On Wed, 2010-05-19 at 14:35 +0530, Amit K. Arora wrote:
> > +		cpuset_lock();
> > +		rq = cpu_rq(cpu);
> > +		kthread_stop(rq->migration_thread);
> > +		put_task_struct(rq->migration_thread);
> > +		rq->migration_thread = NULL;
> > +		cpuset_unlock();
> > +		break;
> > +
> 
> The other problem is more urgent though, CPU_POST_DEAD runs outside of
> the hotplug lock and thus the above becomes a race where we could
> possible kill off the migration thread of a newly brought up cpu:
> 
>  cpu0 - down 2
>  cpu1 - up 2 (allocs a new migration thread, and leaks the old one)
>  cpu0 - post_down 2 - frees the migration thread -- oops!

<Adding Tejun Heo to CC list .. >

Hi Peter,

In an offline discussion with Tejun, he suggested that the above race
can not happen, since _cpu_up() and _cpu_down() can never run in
parallel, because of cpu_add_remove_lock. Looking at the code we can see
that cpu_up() and cpu_down() call "_" variants with cpu_add_remove_lock
mutex held (using cpu_maps_update_begin()).

Here is exactly what he had to say:

"I don't think that's possible.  There are two locks involved here. 
cpu_add_remove_lock and cpu_hotplug.lock.  The former wraps around the
second and already provides full exclusion between all cpu hotplug/unplug
operations. 
The latter is there for reader/writer type exclusion via
get/put_online_cpus().

CPU_POST_DEAD is outside of cpu_hotplug.lock allowing get_online_cpus()
to proceed in parallel but it's still inside cpu_add_remove_lock so other
cpu up/down operations cannot begin before it finishes. "


Thus, since above race can never happen, is there any other issue with
this patch ?

Thanks!
--
Regards,
Amit Arora


Signed-off-by: Amit Arora <aarora@in.ibm.com>
Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
---
diff -Nuarp linux-2.6.34.org/kernel/sched.c linux-2.6.34/kernel/sched.c
--- linux-2.6.34.org/kernel/sched.c	2010-05-18 22:56:21.000000000 -0700
+++ linux-2.6.34/kernel/sched.c	2010-05-18 22:58:31.000000000 -0700
@@ -5942,14 +5942,26 @@ migration_call(struct notifier_block *nf
 		cpu_rq(cpu)->migration_thread = NULL;
 		break;
 
+	case CPU_POST_DEAD:
+		/*
+		 * Bring the migration thread down in CPU_POST_DEAD event,
+		 * since the timers should have got migrated by now and thus
+		 * we should not see a deadlock between trying to kill the
+		 * migration thread and the sched_rt_period_timer.
+		 */
+		cpuset_lock();
+		rq = cpu_rq(cpu);
+		kthread_stop(rq->migration_thread);
+		put_task_struct(rq->migration_thread);
+		rq->migration_thread = NULL;
+		cpuset_unlock();
+		break;
+
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
 		cpuset_lock(); /* around calls to cpuset_cpus_allowed_lock() */
 		migrate_live_tasks(cpu);
 		rq = cpu_rq(cpu);
-		kthread_stop(rq->migration_thread);
-		put_task_struct(rq->migration_thread);
-		rq->migration_thread = NULL;
 		/* Idle task back to normal (off runqueue, low prio) */
 		raw_spin_lock_irq(&rq->lock);
 		update_rq_clock(rq);
