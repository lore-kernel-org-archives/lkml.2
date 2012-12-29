Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749Ab2L2Qo3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2012 11:44:29 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:62142 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573Ab2L2QoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2012 11:44:18 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 27/27] timer: Don't run non-pinned timer to full dynticks CPUs
Date: Sat, 29 Dec 2012 17:43:06 +0100
Message-Id: <1356799386-4212-28-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1356799386-4212-1-git-send-email-fweisbec@gmail.com>
References: <1356799386-4212-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While trying to find a target for a non-pinned timer, use
the following logic:

- Use the closest (from a sched domain POV) busy CPU that
is not full dynticks

- If none, use the closest idle CPU that is not full dynticks.

So this is biased toward isolation over powersaving. This is
a quick hack until we provide a way for the user to tune that
policy. A CPU mask affinity for non pinned timers could be such
a solution.

Original-patch-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Alessio Igor Bogani <abogani@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Gilad Ben Yossef <gilad@benyossef.com>
Cc: Hakan Akkan <hakanakkan@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/hrtimer.c    |    3 ++-
 kernel/sched/core.c |   26 +++++++++++++++++++++++---
 kernel/timer.c      |    3 ++-
 3 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 6db7a5e..f5da6fb 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -159,7 +159,8 @@ struct hrtimer_clock_base *lock_hrtimer_base(const struct hrtimer *timer,
 static int hrtimer_get_target(int this_cpu, int pinned)
 {
 #ifdef CONFIG_NO_HZ
-	if (!pinned && get_sysctl_timer_migration() && idle_cpu(this_cpu))
+	if (!pinned && get_sysctl_timer_migration() &&
+	    (idle_cpu(this_cpu) || tick_nohz_full_cpu(this_cpu)))
 		return get_nohz_timer_target();
 #endif
 	return this_cpu;
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 7b6156a..e2884c5 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -560,22 +560,42 @@ void resched_cpu(int cpu)
  */
 int get_nohz_timer_target(void)
 {
-	int cpu = smp_processor_id();
 	int i;
 	struct sched_domain *sd;
+	int cpu = smp_processor_id();
+	int target = -1;
 
 	rcu_read_lock();
 	for_each_domain(cpu, sd) {
 		for_each_cpu(i, sched_domain_span(sd)) {
+			/*
+			 * This is biased toward CPU isolation usecase:
+			 * try to migrate the timer to a busy non-full-nohz
+			 * CPU. If there is none, then prefer an idle CPU
+			 * than a full nohz one.
+			 * We shouldn't do policy here (isolation VS powersaving)
+			 * so this is a temporary hack. Being able to affine
+			 * non-pinned timers would be a better thing.
+			 */
+			if (tick_nohz_full_cpu(i))
+				continue;
+
 			if (!idle_cpu(i)) {
-				cpu = i;
+				target = i;
 				goto unlock;
 			}
+
+			if (target == -1)
+				target = i;
 		}
 	}
+	/* Fallback in case of NULL domain */
+	if (target == -1)
+		target = cpu;
 unlock:
 	rcu_read_unlock();
-	return cpu;
+
+	return target;
 }
 /*
  * When add_timer_on() enqueues a timer into the timer wheel of an
diff --git a/kernel/timer.c b/kernel/timer.c
index 970b57d..51dd02b 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -738,7 +738,8 @@ __mod_timer(struct timer_list *timer, unsigned long expires,
 	cpu = smp_processor_id();
 
 #if defined(CONFIG_NO_HZ) && defined(CONFIG_SMP)
-	if (!pinned && get_sysctl_timer_migration() && idle_cpu(cpu))
+	if (!pinned && get_sysctl_timer_migration() &&
+	    (idle_cpu(cpu) || tick_nohz_full_cpu(cpu)))
 		cpu = get_nohz_timer_target();
 #endif
 	new_base = per_cpu(tvec_bases, cpu);
-- 
1.7.5.4

