Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090Ab1IPJCy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 05:02:54 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56844 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755054Ab1IPJCx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 05:02:53 -0400
Subject: [PATCH] ftrace:  use a global counter for the global clock
From: Peter Zijlstra <peterz@infradead.org>
To: rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, mingo <mingo@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Fri, 16 Sep 2011 11:02:45 +0200
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316163765.10174.8.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

no reason to muck about, just use a counter already.

Requested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/trace/trace_clock.c |   44 +++-----------------------------------------
 1 files changed, 3 insertions(+), 41 deletions(-)

diff --git a/kernel/trace/trace_clock.c b/kernel/trace/trace_clock.c
index 6302747..1b79441 100644
--- a/kernel/trace/trace_clock.c
+++ b/kernel/trace/trace_clock.c
@@ -68,48 +68,10 @@ u64 notrace trace_clock(void)
  * Used by plugins that need globally coherent timestamps.
  */
 
-/* keep prev_time and lock in the same cacheline. */
-static struct {
-	u64 prev_time;
-	arch_spinlock_t lock;
-} trace_clock_struct ____cacheline_aligned_in_smp =
-	{
-		.lock = (arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED,
-	};
+
+static atomic64_t trace_counter;
 
 u64 notrace trace_clock_global(void)
 {
-	unsigned long flags;
-	int this_cpu;
-	u64 now;
-
-	local_irq_save(flags);
-
-	this_cpu = raw_smp_processor_id();
-	now = cpu_clock(this_cpu);
-	/*
-	 * If in an NMI context then dont risk lockups and return the
-	 * cpu_clock() time:
-	 */
-	if (unlikely(in_nmi()))
-		goto out;
-
-	arch_spin_lock(&trace_clock_struct.lock);
-
-	/*
-	 * TODO: if this happens often then maybe we should reset
-	 * my_scd->clock to prev_time+1, to make sure
-	 * we start ticking with the local clock from now on?
-	 */
-	if ((s64)(now - trace_clock_struct.prev_time) < 0)
-		now = trace_clock_struct.prev_time + 1;
-
-	trace_clock_struct.prev_time = now;
-
-	arch_spin_unlock(&trace_clock_struct.lock);
-
- out:
-	local_irq_restore(flags);
-
-	return now;
+	return atomic64_add_return(1, &trace_counter);
 }

