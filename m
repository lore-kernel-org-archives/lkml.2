Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787Ab1EFVln (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 17:41:43 -0400
Received: from mga01.intel.com ([192.55.52.88]:43903 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932917Ab1EFVlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 17:41:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,328,1301900400"; 
   d="scan'208";a="689286856"
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Chris Mason <chris.mason@oracle.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 3/4] Avoid tick broadcast switch-overs for thread siblings
Date: Fri,  6 May 2011 14:40:55 -0700
Message-Id: <1304718056-20206-4-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1304718056-20206-1-git-send-email-andi@firstfloor.org>
References: <1304718056-20206-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

On SMT systems the thread siblings will keep the timer alive
in any power state. Teach the oneshot broadcast logic about this.

As long as any thread sibling is alive keep using the local timer
device. When we actually switch over to broadcast we need
to use the nearest timer expire of all the siblings.

This adds a new "slave" state: a slave is tied to another CPU.
When the other CPU goes idle too switch over all slaves
to broadcast timing.

This lowers locking contention on the broadcast lock and
general overhead.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 kernel/time/tick-broadcast.c |   97 +++++++++++++++++++++++++++++++++++++++---
 1 files changed, 90 insertions(+), 7 deletions(-)

diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 92aba0b..c1587cb 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -358,10 +358,16 @@ int tick_resume_broadcast(void)
 
 #ifdef CONFIG_TICK_ONESHOT
 
+/* Lock on the first thread on a core coordinates state */
 struct broadcast_cpu_state {
+	int slave;
 	int need_oneshot;
+	raw_spinlock_t lock;
 } ____cacheline_aligned;
-static DEFINE_PER_CPU(struct broadcast_cpu_state, state);
+
+static DEFINE_PER_CPU(struct broadcast_cpu_state, state) = {
+	.lock = __RAW_SPIN_LOCK_UNLOCKED(lock)
+};
 
 /*
  * Exposed for debugging: see timer_list.c
@@ -454,6 +460,70 @@ again:
 	raw_spin_unlock(&tick_broadcast_lock);
 }
 
+#define for_each_sibling(i, cpu) for_each_cpu(i, topology_thread_cpumask(cpu))
+
+/* 
+ * When another thread sibling is alive our timer keeps ticking.
+ * Check for this here because it's much less expensive.
+ * When this happens the current CPU turns into a slave, tied
+ * to the still running CPU. When that also goes idle both
+ * become serviced by the broadcaster.
+ */
+static int tick_sibling_active(int cpu, ktime_t *timeout, int enter)
+{
+	int i, leader;
+	int running;
+	ktime_t n;
+
+	/* 
+ 	 * Exit can be done lockless because unidling 
+ 	 * does not affect others.
+ 	 */
+	if (!enter) {
+		int was_slave = __get_cpu_var(state).slave;
+		__get_cpu_var(state).slave = 0;
+		return was_slave;
+	}
+
+	leader = cpumask_first(topology_thread_cpumask(cpu));
+	running = 1;
+	raw_spin_lock(&per_cpu(state, leader).lock);
+	for_each_sibling(i, cpu) {
+		struct broadcast_cpu_state *s = &per_cpu(state, i);
+
+		n = per_cpu(tick_cpu_device, i).evtdev->next_event;
+		if (n.tv64 < timeout->tv64 && (s->slave || s->need_oneshot))
+			*timeout = n;
+		if (!s->slave && !s->need_oneshot)
+			running++;
+	}
+	__get_cpu_var(state).slave = running > 1;
+	raw_spin_unlock(&per_cpu(state, leader).lock);
+	return running > 1;
+}
+
+/* 
+ * Sync oneshot state with siblings.
+ */
+static void set_broadcast_sibling_state(int cpu, int enter)
+{
+	int i;
+
+	for_each_sibling(i, cpu) {
+		struct broadcast_cpu_state *s = &per_cpu(state, i);
+
+		if (enter && s->slave) {
+			s->need_oneshot = 1;
+			wmb();
+			s->slave = 0;
+		} else if (!enter && s->need_oneshot) {
+			s->slave = 1;
+			wmb();
+			s->need_oneshot = 0;
+		}
+	}
+}
+
 /*
  * Powerstate information: The system enters/leaves a state, where
  * affected devices might stop
@@ -464,7 +534,8 @@ void tick_broadcast_oneshot_control(unsigned long reason)
 	struct tick_device *td;
 	unsigned long flags;
 	int cpu;
-
+	ktime_t timeout;
+	
 	/*
 	 * Periodic mode does not care about the enter/exit of power
 	 * states
@@ -476,21 +547,28 @@ void tick_broadcast_oneshot_control(unsigned long reason)
 	bc = tick_broadcast_device.evtdev;
 	td = &per_cpu(tick_cpu_device, cpu);
 	dev = td->evtdev;
+	timeout = td->evtdev->next_event;
 
 	if (!(dev->features & CLOCK_EVT_FEAT_C3STOP))
 		return;
 
+	if (tick_sibling_active(cpu, &timeout,
+				reason == CLOCK_EVT_NOTIFY_BROADCAST_ENTER))
+		return;
+
 	raw_spin_lock_irqsave(&tick_broadcast_lock, flags);
 	if (reason == CLOCK_EVT_NOTIFY_BROADCAST_ENTER) {
 		if (!__get_cpu_var(state).need_oneshot) {
-			__get_cpu_var(state).need_oneshot = 1;
+			/* Turn all slaves into oneshots */
+			set_broadcast_sibling_state(cpu, 1);
 			clockevents_set_mode(dev, CLOCK_EVT_MODE_SHUTDOWN);
-			if (dev->next_event.tv64 < bc->next_event.tv64)
-				tick_broadcast_set_event(dev->next_event, 1);
+			if (timeout.tv64 < bc->next_event.tv64)
+				tick_broadcast_set_event(timeout, 1);
 		}
 	} else {
 		if (__get_cpu_var(state).need_oneshot) {
-			__get_cpu_var(state).need_oneshot = 0;
+			/* Turn all oneshots into slaves */
+			set_broadcast_sibling_state(cpu, 0);
 			clockevents_set_mode(dev, CLOCK_EVT_MODE_ONESHOT);
 			if (dev->next_event.tv64 != KTIME_MAX)
 				tick_program_event(dev->next_event, 1);
@@ -506,7 +584,12 @@ void tick_broadcast_oneshot_control(unsigned long reason)
  */
 static void tick_broadcast_clear_oneshot(int cpu)
 {
-	per_cpu(state, cpu).need_oneshot = 0;
+	int i;
+
+	for_each_sibling (i, cpu) {
+		per_cpu(state, i).need_oneshot = 0;
+		per_cpu(state, i).slave = 0;
+	}
 }
 
 static void tick_broadcast_init_next_event(struct cpumask *mask,
-- 
1.7.4.4

