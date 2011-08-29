Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743Ab1H2VJT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 17:09:19 -0400
Received: from mga11.intel.com ([192.55.52.93]:10207 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754495Ab1H2VJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 17:09:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,298,1312182000"; 
   d="scan'208";a="46211183"
From: Andi Kleen <andi@firstfloor.org>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/3] broadcast-tick: Move oneshot broadcast mask to per cpu variables v2
Date: Mon, 29 Aug 2011 14:08:55 -0700
Message-Id: <1314652136-11350-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1314652136-11350-1-git-send-email-andi@firstfloor.org>
References: <1314652136-11350-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Avoid a global cache line hotspot in the oneshot cpu mask. Maintain
this information in per cpu variables instead.

v2: use DEFINE_PER_CPU_ALIGNED (Eric Dumazet)

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 include/linux/tick.h         |    2 +-
 kernel/time/tick-broadcast.c |   40 ++++++++++++++++++++++++----------------
 kernel/time/timer_list.c     |   11 +++++++++--
 3 files changed, 34 insertions(+), 19 deletions(-)

diff --git a/include/linux/tick.h b/include/linux/tick.h
index b232ccc..3df6e2e 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -90,7 +90,7 @@ extern struct tick_device *tick_get_broadcast_device(void);
 extern struct cpumask *tick_get_broadcast_mask(void);
 
 #  ifdef CONFIG_TICK_ONESHOT
-extern struct cpumask *tick_get_broadcast_oneshot_mask(void);
+extern void tick_get_broadcast_oneshot_mask(struct cpumask *);
 #  endif
 
 # endif /* BROADCAST */
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index c7218d1..54a5977 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -358,15 +358,22 @@ int tick_resume_broadcast(void)
 
 #ifdef CONFIG_TICK_ONESHOT
 
-/* FIXME: use cpumask_var_t. */
-static DECLARE_BITMAP(tick_broadcast_oneshot_mask, NR_CPUS);
+struct broadcast_cpu_state {
+	int need_oneshot;
+};
+static DEFINE_PER_CPU_ALIGNED(struct broadcast_cpu_state, state);
 
 /*
  * Exposed for debugging: see timer_list.c
  */
-struct cpumask *tick_get_broadcast_oneshot_mask(void)
+void tick_get_broadcast_oneshot_mask(struct cpumask *mask)
 {
-	return to_cpumask(tick_broadcast_oneshot_mask);
+	int i;
+
+	for_each_online_cpu (i) {
+		if (per_cpu(state, i).need_oneshot)
+			cpumask_set_cpu(i, mask);
+	}
 }
 
 static int tick_broadcast_set_event(ktime_t expires, int force)
@@ -388,7 +395,7 @@ int tick_resume_broadcast_oneshot(struct clock_event_device *bc)
  */
 void tick_check_oneshot_broadcast(int cpu)
 {
-	if (cpumask_test_cpu(cpu, to_cpumask(tick_broadcast_oneshot_mask))) {
+	if (per_cpu(state, cpu).need_oneshot) {
 		struct tick_device *td = &per_cpu(tick_cpu_device, cpu);
 
 		clockevents_set_mode(td->evtdev, CLOCK_EVT_MODE_ONESHOT);
@@ -411,7 +418,9 @@ again:
 	cpumask_clear(to_cpumask(tmpmask));
 	now = ktime_get();
 	/* Find all expired events */
-	for_each_cpu(cpu, tick_get_broadcast_oneshot_mask()) {
+	for_each_online_cpu(cpu) {
+		if (!per_cpu(state, cpu).need_oneshot)
+			continue;
 		td = &per_cpu(tick_cpu_device, cpu);
 		if (td->evtdev->next_event.tv64 <= now.tv64)
 			cpumask_set_cpu(cpu, to_cpumask(tmpmask));
@@ -478,16 +487,15 @@ void tick_broadcast_oneshot_control(unsigned long reason)
 
 	raw_spin_lock_irqsave(&tick_broadcast_lock, flags);
 	if (reason == CLOCK_EVT_NOTIFY_BROADCAST_ENTER) {
-		if (!cpumask_test_cpu(cpu, tick_get_broadcast_oneshot_mask())) {
-			cpumask_set_cpu(cpu, tick_get_broadcast_oneshot_mask());
+		if (!__get_cpu_var(state).need_oneshot) {
+			__get_cpu_var(state).need_oneshot = 1;
 			clockevents_set_mode(dev, CLOCK_EVT_MODE_SHUTDOWN);
 			if (dev->next_event.tv64 < bc->next_event.tv64)
 				tick_broadcast_set_event(dev->next_event, 1);
 		}
 	} else {
-		if (cpumask_test_cpu(cpu, tick_get_broadcast_oneshot_mask())) {
-			cpumask_clear_cpu(cpu,
-					  tick_get_broadcast_oneshot_mask());
+		if (__get_cpu_var(state).need_oneshot) {
+			__get_cpu_var(state).need_oneshot = 0;
 			clockevents_set_mode(dev, CLOCK_EVT_MODE_ONESHOT);
 			if (dev->next_event.tv64 != KTIME_MAX)
 				tick_program_event(dev->next_event, 1);
@@ -503,7 +511,7 @@ void tick_broadcast_oneshot_control(unsigned long reason)
  */
 static void tick_broadcast_clear_oneshot(int cpu)
 {
-	cpumask_clear_cpu(cpu, tick_get_broadcast_oneshot_mask());
+	per_cpu(state, cpu).need_oneshot = 0;
 }
 
 static void tick_broadcast_init_next_event(struct cpumask *mask,
@@ -529,6 +537,7 @@ void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
 	/* Set it up only once ! */
 	if (bc->event_handler != tick_handle_oneshot_broadcast) {
 		int was_periodic = bc->mode == CLOCK_EVT_MODE_PERIODIC;
+		int i;
 
 		bc->event_handler = tick_handle_oneshot_broadcast;
 		clockevents_set_mode(bc, CLOCK_EVT_MODE_ONESHOT);
@@ -544,9 +553,8 @@ void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
 		 */
 		cpumask_copy(to_cpumask(tmpmask), tick_get_broadcast_mask());
 		cpumask_clear_cpu(cpu, to_cpumask(tmpmask));
-		cpumask_or(tick_get_broadcast_oneshot_mask(),
-			   tick_get_broadcast_oneshot_mask(),
-			   to_cpumask(tmpmask));
+		for_each_cpu (i, to_cpumask(tmpmask))
+			per_cpu(state, i).need_oneshot = 1;
 
 		if (was_periodic && !cpumask_empty(to_cpumask(tmpmask))) {
 			tick_broadcast_init_next_event(to_cpumask(tmpmask),
@@ -598,7 +606,7 @@ void tick_shutdown_broadcast_oneshot(unsigned int *cpup)
 	 * Clear the broadcast mask flag for the dead cpu, but do not
 	 * stop the broadcast device!
 	 */
-	cpumask_clear_cpu(cpu, tick_get_broadcast_oneshot_mask());
+	per_cpu(state, cpu).need_oneshot = 0;
 
 	raw_spin_unlock_irqrestore(&tick_broadcast_lock, flags);
 }
diff --git a/kernel/time/timer_list.c b/kernel/time/timer_list.c
index 3258455..28964ed 100644
--- a/kernel/time/timer_list.c
+++ b/kernel/time/timer_list.c
@@ -235,14 +235,21 @@ print_tickdevice(struct seq_file *m, struct tick_device *td, int cpu)
 static void timer_list_show_tickdevices(struct seq_file *m)
 {
 	int cpu;
+#ifdef CONFIG_TICK_ONESHOT
+	cpumask_var_t mask;
+#endif
 
 #ifdef CONFIG_GENERIC_CLOCKEVENTS_BROADCAST
 	print_tickdevice(m, tick_get_broadcast_device(), -1);
 	SEQ_printf(m, "tick_broadcast_mask: %08lx\n",
 		   cpumask_bits(tick_get_broadcast_mask())[0]);
 #ifdef CONFIG_TICK_ONESHOT
-	SEQ_printf(m, "tick_broadcast_oneshot_mask: %08lx\n",
-		   cpumask_bits(tick_get_broadcast_oneshot_mask())[0]);
+	if (zalloc_cpumask_var(&mask, GFP_KERNEL) == 0) {
+		tick_get_broadcast_oneshot_mask(mask);
+		SEQ_printf(m, "tick_broadcast_oneshot_mask: %08lx\n",
+			   cpumask_bits(mask)[0]);
+		free_cpumask_var(mask);
+	}
 #endif
 	SEQ_printf(m, "\n");
 #endif
-- 
1.7.4.4

