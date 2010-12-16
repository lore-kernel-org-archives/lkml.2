Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab0LPMcN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 07:32:13 -0500
Received: from hera.kernel.org ([140.211.167.34]:36332 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752667Ab0LPMcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 07:32:10 -0500
Date: Thu, 16 Dec 2010 12:31:35 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, mikpe@it.uu.se, tglx@linutronix.de,
        venki@google.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, mikpe@it.uu.se, tglx@linutronix.de,
        venki@google.com, mingo@elte.hu
In-Reply-To: <1292242434.6803.200.camel@twins>
References: <1292242434.6803.200.camel@twins>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Fix the irqtime code for 32bit
Message-ID: <tip-8e92c20183ed0579d94501311b81c42b65cb2129@git.kernel.org>
Git-Commit-ID: 8e92c20183ed0579d94501311b81c42b65cb2129
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 16 Dec 2010 12:31:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8e92c20183ed0579d94501311b81c42b65cb2129
Gitweb:     http://git.kernel.org/tip/8e92c20183ed0579d94501311b81c42b65cb2129
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 9 Dec 2010 14:15:34 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 16 Dec 2010 11:17:47 +0100

sched: Fix the irqtime code for 32bit

Since the irqtime accounting is using non-atomic u64 and can be read
from remote cpus (writes are strictly cpu local, reads are not) we
have to deal with observing partial updates.

When we do observe partial updates the clock movement (in particular,
->clock_task movement) will go funny (in either direction), a
subsequent clock update (observing the full update) will make it go
funny in the oposite direction.

Since we rely on these clocks to be strictly monotonic we cannot
suffer backwards motion. One possible solution would be to simply
ignore all backwards deltas, but that will lead to accounting
artefacts, most notable: clock_task + irq_time != clock, this
inaccuracy would end up in user visible stats.

Therefore serialize the reads using a seqcount.

Reviewed-by: Venkatesh Pallipadi <venki@google.com>
Reported-by: Mikael Pettersson <mikpe@it.uu.se>
Tested-by: Mikael Pettersson <mikpe@it.uu.se>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1292242434.6803.200.camel@twins>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   51 +++++++++++++++++++++++++++++++++++++++++++++------
 1 files changed, 45 insertions(+), 6 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 79b557c..456c990 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1920,10 +1920,9 @@ static void deactivate_task(struct rq *rq, struct task_struct *p, int flags)
  * They are read and saved off onto struct rq in update_rq_clock().
  * This may result in other CPU reading this CPU's irq time and can
  * race with irq/account_system_vtime on this CPU. We would either get old
- * or new value (or semi updated value on 32 bit) with a side effect of
- * accounting a slice of irq time to wrong task when irq is in progress
- * while we read rq->clock. That is a worthy compromise in place of having
- * locks on each irq in account_system_time.
+ * or new value with a side effect of accounting a slice of irq time to wrong
+ * task when irq is in progress while we read rq->clock. That is a worthy
+ * compromise in place of having locks on each irq in account_system_time.
  */
 static DEFINE_PER_CPU(u64, cpu_hardirq_time);
 static DEFINE_PER_CPU(u64, cpu_softirq_time);
@@ -1941,10 +1940,48 @@ void disable_sched_clock_irqtime(void)
 	sched_clock_irqtime = 0;
 }
 
-static inline u64 irq_time_cpu(int cpu)
+#ifndef CONFIG_64BIT
+static DEFINE_PER_CPU(seqcount_t, irq_time_seq);
+
+static inline void irq_time_write_begin(void)
+{
+	__this_cpu_inc(irq_time_seq.sequence);
+	smp_wmb();
+}
+
+static inline void irq_time_write_end(void)
+{
+	smp_wmb();
+	__this_cpu_inc(irq_time_seq.sequence);
+}
+
+static inline u64 irq_time_read(int cpu)
+{
+	u64 irq_time;
+	unsigned seq;
+
+	do {
+		seq = read_seqcount_begin(&per_cpu(irq_time_seq, cpu));
+		irq_time = per_cpu(cpu_softirq_time, cpu) +
+			   per_cpu(cpu_hardirq_time, cpu);
+	} while (read_seqcount_retry(&per_cpu(irq_time_seq, cpu), seq));
+
+	return irq_time;
+}
+#else /* CONFIG_64BIT */
+static inline void irq_time_write_begin(void)
+{
+}
+
+static inline void irq_time_write_end(void)
+{
+}
+
+static inline u64 irq_time_read(int cpu)
 {
 	return per_cpu(cpu_softirq_time, cpu) + per_cpu(cpu_hardirq_time, cpu);
 }
+#endif /* CONFIG_64BIT */
 
 /*
  * Called before incrementing preempt_count on {soft,}irq_enter
@@ -1965,6 +2002,7 @@ void account_system_vtime(struct task_struct *curr)
 	delta = sched_clock_cpu(cpu) - __this_cpu_read(irq_start_time);
 	__this_cpu_add(irq_start_time, delta);
 
+	irq_time_write_begin();
 	/*
 	 * We do not account for softirq time from ksoftirqd here.
 	 * We want to continue accounting softirq time to ksoftirqd thread
@@ -1976,6 +2014,7 @@ void account_system_vtime(struct task_struct *curr)
 	else if (in_serving_softirq() && !(curr->flags & PF_KSOFTIRQD))
 		__this_cpu_add(cpu_softirq_time, delta);
 
+	irq_time_write_end();
 	local_irq_restore(flags);
 }
 EXPORT_SYMBOL_GPL(account_system_vtime);
@@ -1984,7 +2023,7 @@ static void update_rq_clock_task(struct rq *rq, s64 delta)
 {
 	s64 irq_delta;
 
-	irq_delta = irq_time_cpu(cpu_of(rq)) - rq->prev_irq_time;
+	irq_delta = irq_time_read(cpu_of(rq)) - rq->prev_irq_time;
 
 	/*
 	 * Since irq_time is only updated on {soft,}irq_exit, we might run into
