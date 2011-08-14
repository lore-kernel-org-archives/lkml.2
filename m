Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab1HNQMm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:12:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:42702 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754765Ab1HNQMh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:12:37 -0400
Date: Sun, 14 Aug 2011 16:12:04 GMT
From: tip-bot for Steven Rostedt <rostedt@goodmis.org>
Message-ID: <tip-d473750b4073f16f23f46f30dc1bd3de45c35754@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        npiggin@kernel.dk, rostedt@goodmis.org, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        npiggin@kernel.dk, rostedt@goodmis.org, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1312547269.18583.194.camel@gandalf.stny.rr.com>
References: <1312547269.18583.194.camel@gandalf.stny.rr.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/cpupri: Fix memory barriers for vec updates to always be in order
Git-Commit-ID: d473750b4073f16f23f46f30dc1bd3de45c35754
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 14 Aug 2011 16:12:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d473750b4073f16f23f46f30dc1bd3de45c35754
Gitweb:     http://git.kernel.org/tip/d473750b4073f16f23f46f30dc1bd3de45c35754
Author:     Steven Rostedt <rostedt@goodmis.org>
AuthorDate: Fri, 5 Aug 2011 08:27:49 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 14 Aug 2011 12:01:07 +0200

sched/cpupri: Fix memory barriers for vec updates to always be in order

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
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1312547269.18583.194.camel@gandalf.stny.rr.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_cpupri.c |   28 +++++++++++++++++++++++++---
 1 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/kernel/sched_cpupri.c b/kernel/sched_cpupri.c
index 7761a26..90faffd 100644
--- a/kernel/sched_cpupri.c
+++ b/kernel/sched_cpupri.c
@@ -73,9 +73,10 @@ int cpupri_find(struct cpupri *cp, struct task_struct *p,
 
 	for (idx = 0; idx < task_pri; idx++) {
 		struct cpupri_vec *vec  = &cp->pri_to_cpu[idx];
+		int skip = 0;
 
 		if (!atomic_read(&(vec)->count))
-			continue;
+			skip = 1;
 		/*
 		 * When looking at the vector, we need to read the counter,
 		 * do a memory barrier, then read the mask.
@@ -96,6 +97,10 @@ int cpupri_find(struct cpupri *cp, struct task_struct *p,
 		 */
 		smp_rmb();
 
+		/* Need to do the rmb for every iteration */
+		if (skip)
+			continue;
+
 		if (cpumask_any_and(&p->cpus_allowed, vec->mask) >= nr_cpu_ids)
 			continue;
 
@@ -134,6 +139,7 @@ void cpupri_set(struct cpupri *cp, int cpu, int newpri)
 {
 	int                 *currpri = &cp->cpu_to_pri[cpu];
 	int                  oldpri  = *currpri;
+	int                  do_mb = 0;
 
 	newpri = convert_prio(newpri);
 
@@ -158,18 +164,34 @@ void cpupri_set(struct cpupri *cp, int cpu, int newpri)
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
 
