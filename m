Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135Ab1HEM1y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 08:27:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:41624 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374Ab1HEM1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 08:27:52 -0400
X-Authority-Analysis: v=1.1 cv=sbbt6Wn8j+VvNVI1Ftt/uHhinWyuFt+R57MN9Ty2Tys= c=1 sm=0 a=Q2PlAdpUTSkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=EKdFGQPU1zHt2kv6tVQA:9 a=ZJvSqr2hBYXZgfGgHX0A:7 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: [PATCH v2] cpupri: Fix memory barriers for vec updates to always
 be in order
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <mgalbraith@suse.de>,
        "Luis Claudio R." =?ISO-8859-1?Q?Gon=E7alves?= 
	<lgoncalv@redhat.com>,
        Matthew Hank Sabins <msabins@linux.vnet.ibm.com>,
        Gregory Haskins <gregory.haskins@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1312489943.18583.190.camel@gandalf.stny.rr.com>
References: <1312317372.18583.101.camel@gandalf.stny.rr.com>
	 <1312489943.18583.190.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 05 Aug 2011 08:27:49 -0400
Message-ID: <1312547269.18583.194.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ This patch actually compiles. Thanks to Mike Galbraith for pointing
that out. I compiled and booted this patch with no issues. ]

Re-examining the cpupri patch, I see there's a possible race because the
update of the two priorities vec->counts are not protected by a memory
barrier.

When a RT runqueue is overloaded and wants to push an RT task to another
runqueue, it scans the RT priority vectors in a loop from lowest
priority to highest.

When we queue or dequeue an RT task that changes a runqueue's highest
priority task, we update the vectors to show that a runqueue is rated at
a different priority. To do this, we first set the new priority mask,
and increment the vec->count, and then set the old priority mask by
decrementing the vec->count.

If we are lowering the runqueue's RT priority rating, it will trigger a
RT pull, and we do not care if we miss pushing to this runqueue or not. 

But if we raise the priority, but the priority is still lower than an RT
task that is looking to be pushed, we must make sure that this runqueue
is still seen by the push algorithm (the loop).

Because the loop reads from lowest to highest, and the new priority is
set before the old one is cleared, we will either see the new or old
priority set and the vector will be checked.

But! Since there's no memory barrier between the updates of the two, the
old count may be decremented first before the new count is incremented.
This means the loop may see the old count of zero and skip it, and also
the new count of zero before it was updated. A possible runqueue that
the RT task could move to could be missed.

A conditional memory barrier is placed between the vec->count updates
and is only called when both updates are done.

The smp_wmb() has also been changed to smp_mb__before_atomic_inc/dec(),
as they are not needed by archs that already synchronize
atomic_inc/dec().

The smp_rmb() has been moved to be called at every iteration of the loop
so that the race between seeing the two updates is visible by each
iteration of the loop, as an arch is free to optimize the reading of
memory of the counters in the loop.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-rt.git/kernel/sched_cpupri.c
===================================================================
--- linux-rt.git.orig/kernel/sched_cpupri.c
+++ linux-rt.git/kernel/sched_cpupri.c
@@ -73,9 +73,10 @@ int cpupri_find(struct cpupri *cp, struc
 
 	for (idx = 0; idx < task_pri; idx++) {
 		struct cpupri_vec *vec  = &cp->pri_to_cpu[idx];
+		int skip = 0;
 
 		if (!atomic_read(&(vec)->count))
-			continue;
+			skip = 1;
 		/*
 		 * When looking at the vector, we need to read the counter,
 		 * do a memory barrier, then read the mask.
@@ -96,6 +97,10 @@ int cpupri_find(struct cpupri *cp, struc
 		 */
 		smp_rmb();
 
+		/* Need to do the rmb for every iteration */
+		if (skip)
+			continue;
+
 		if (cpumask_any_and(&p->cpus_allowed, vec->mask) >= nr_cpu_ids)
 			continue;
 
@@ -134,6 +139,7 @@ void cpupri_set(struct cpupri *cp, int c
 {
 	int                 *currpri = &cp->cpu_to_pri[cpu];
 	int                  oldpri  = *currpri;
+	int                  do_mb = 0;
 
 	newpri = convert_prio(newpri);
 
@@ -158,18 +164,34 @@ void cpupri_set(struct cpupri *cp, int c
 		 * do a write memory barrier, and then update the count, to
 		 * make sure the vector is visible when count is set.
 		 */
-		smp_wmb();
+		smp_mb__before_atomic_inc();
 		atomic_inc(&(vec)->count);
+		do_mb = 1;
 	}
 	if (likely(oldpri != CPUPRI_INVALID)) {
 		struct cpupri_vec *vec  = &cp->pri_to_cpu[oldpri];
 
 		/*
+		 * Because the order of modification of the vec->count
+		 * is important, we must make sure that the update
+		 * of the new prio is seen before we decrement the
+		 * old prio. This makes sure that the loop sees
+		 * one or the other when we raise the priority of
+		 * the run queue. We don't care about when we lower the
+		 * priority, as that will trigger an rt pull anyway.
+		 *
+		 * We only need to do a memory barrier if we updated
+		 * the new priority vec.
+		 */
+		if (do_mb)
+			smp_mb__after_atomic_inc();
+
+		/*
 		 * When removing from the vector, we decrement the counter first
 		 * do a memory barrier and then clear the mask.
 		 */
 		atomic_dec(&(vec)->count);
-		smp_wmb();
+		smp_mb__after_atomic_inc();
 		cpumask_clear_cpu(cpu, vec->mask);
 	}
 


