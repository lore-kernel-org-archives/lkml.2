Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578Ab1DKHRF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 03:17:05 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:59494 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028Ab1DKHRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 03:17:03 -0400
From: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
Subject: [RFC PATCH V2 1/4] Move dev->last_residency update to driver enter
	routine; remove dev->last_state
To: linux-pm@lists.linux-foundation.org, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, rnayak@ti.com, karthik-dp@ti.com,
        magnus.damm@gmail.com
Date: Mon, 11 Apr 2011 12:46:52 +0530
Message-ID: <20110411071632.6348.74321.stgit@tringupt.in.ibm.com>
In-Reply-To: <20110411071508.6348.67918.stgit@tringupt.in.ibm.com>
References: <20110411071508.6348.67918.stgit@tringupt.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cpuidle subsystem only suggests the state to enter and does not
guarantee if the suggested state is entered. The actual entered state
may be different because of software or hardware demotion. Current
cpuidle code uses last_state field to capture the actual state entered
and based on that updates the statistics for the state entered.

Ideally the driver enter routine should update the counters,
and it should return the state actually entered rather than the time
spent there. The generic cpuidle code should simply handle where
the counters live in the sysfs namespace, not updating the counters.

Reference:
https://lkml.org/lkml/2011/3/25/52

Signed-off-by: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
---

 drivers/acpi/processor_idle.c    |   81 ++++++++++++++++++++++++++------------
 drivers/cpuidle/cpuidle.c        |   27 +++++--------
 drivers/cpuidle/governors/menu.c |    7 ++-
 include/linux/cpuidle.h          |    7 +--
 4 files changed, 73 insertions(+), 49 deletions(-)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index d615b7d..00712a7 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -741,22 +741,24 @@ static inline void acpi_idle_do_entry(struct acpi_processor_cx *cx)
 /**
  * acpi_idle_enter_c1 - enters an ACPI C1 state-type
  * @dev: the target CPU
- * @state: the state data
+ * @index: index of target state
  *
  * This is equivalent to the HALT instruction.
  */
 static int acpi_idle_enter_c1(struct cpuidle_device *dev,
-			      struct cpuidle_state *state)
+				int index)
 {
 	ktime_t  kt1, kt2;
 	s64 idle_time;
 	struct acpi_processor *pr;
+	struct cpuidle_state *state = &dev->states[index];
 	struct acpi_processor_cx *cx = cpuidle_get_statedata(state);
 
 	pr = __this_cpu_read(processors);
+	dev->last_residency = 0;
 
 	if (unlikely(!pr))
-		return 0;
+		return -EINVAL;
 
 	local_irq_disable();
 
@@ -764,7 +766,7 @@ static int acpi_idle_enter_c1(struct cpuidle_device *dev,
 	if (acpi_idle_suspend) {
 		local_irq_enable();
 		cpu_relax();
-		return 0;
+		return -EINVAL;
 	}
 
 	lapic_timer_state_broadcast(pr, cx, 1);
@@ -773,37 +775,48 @@ static int acpi_idle_enter_c1(struct cpuidle_device *dev,
 	kt2 = ktime_get_real();
 	idle_time =  ktime_to_us(ktime_sub(kt2, kt1));
 
+	/* Update device last_residency and state counters*/
+	dev->last_residency = (int)idle_time;
+	dev->states[index].time += (unsigned long long)dev->last_residency;
+	dev->states[index].usage++;
+
 	local_irq_enable();
 	cx->usage++;
 	lapic_timer_state_broadcast(pr, cx, 0);
 
-	return idle_time;
+	return index;
 }
 
 /**
  * acpi_idle_enter_simple - enters an ACPI state without BM handling
  * @dev: the target CPU
- * @state: the state data
+ * @index: the index of suggested state
  */
 static int acpi_idle_enter_simple(struct cpuidle_device *dev,
-				  struct cpuidle_state *state)
+				int index)
 {
 	struct acpi_processor *pr;
+	struct cpuidle_state *state = &dev->states[index];
 	struct acpi_processor_cx *cx = cpuidle_get_statedata(state);
 	ktime_t  kt1, kt2;
 	s64 idle_time_ns;
 	s64 idle_time;
 
 	pr = __this_cpu_read(processors);
+	dev->last_residency = 0;
 
 	if (unlikely(!pr))
-		return 0;
-
-	if (acpi_idle_suspend)
-		return(acpi_idle_enter_c1(dev, state));
+		return -EINVAL;
 
 	local_irq_disable();
 
+	if (acpi_idle_suspend) {
+		local_irq_enable();
+		cpu_relax();
+		return -EINVAL;
+	}
+
+
 	if (cx->entry_method != ACPI_CSTATE_FFH) {
 		current_thread_info()->status &= ~TS_POLLING;
 		/*
@@ -815,7 +828,7 @@ static int acpi_idle_enter_simple(struct cpuidle_device *dev,
 		if (unlikely(need_resched())) {
 			current_thread_info()->status |= TS_POLLING;
 			local_irq_enable();
-			return 0;
+			return -EINVAL;
 		}
 	}
 
@@ -837,6 +850,11 @@ static int acpi_idle_enter_simple(struct cpuidle_device *dev,
 	idle_time = idle_time_ns;
 	do_div(idle_time, NSEC_PER_USEC);
 
+	/* Update device last_residency and state counters*/
+	dev->last_residency = (int)idle_time;
+	dev->states[index].time += (unsigned long long)dev->last_residency;
+	dev->states[index].usage++;
+
 	/* Tell the scheduler how much we idled: */
 	sched_clock_idle_wakeup_event(idle_time_ns);
 
@@ -848,7 +866,7 @@ static int acpi_idle_enter_simple(struct cpuidle_device *dev,
 
 	lapic_timer_state_broadcast(pr, cx, 0);
 	cx->time += idle_time;
-	return idle_time;
+	return index;
 }
 
 static int c3_cpu_count;
@@ -857,14 +875,15 @@ static DEFINE_SPINLOCK(c3_lock);
 /**
  * acpi_idle_enter_bm - enters C3 with proper BM handling
  * @dev: the target CPU
- * @state: the state data
+ * @index: the index of suggested state
  *
  * If BM is detected, the deepest non-C3 idle state is entered instead.
  */
 static int acpi_idle_enter_bm(struct cpuidle_device *dev,
-			      struct cpuidle_state *state)
+				int index)
 {
 	struct acpi_processor *pr;
+	struct cpuidle_state *state = &dev->states[index];
 	struct acpi_processor_cx *cx = cpuidle_get_statedata(state);
 	ktime_t  kt1, kt2;
 	s64 idle_time_ns;
@@ -872,22 +891,26 @@ static int acpi_idle_enter_bm(struct cpuidle_device *dev,
 
 
 	pr = __this_cpu_read(processors);
+	dev->last_residency = 0;
 
 	if (unlikely(!pr))
-		return 0;
+		return -EINVAL;
 
-	if (acpi_idle_suspend)
-		return(acpi_idle_enter_c1(dev, state));
+
+	if (acpi_idle_suspend) {
+		cpu_relax();
+		return -EINVAL;
+	}
 
 	if (!cx->bm_sts_skip && acpi_idle_bm_check()) {
-		if (dev->safe_state) {
-			dev->last_state = dev->safe_state;
-			return dev->safe_state->enter(dev, dev->safe_state);
+		if (dev->safe_state_index >= 0) {
+			return dev->states[dev->safe_state_index].enter(dev,
+						dev->safe_state_index);
 		} else {
 			local_irq_disable();
 			acpi_safe_halt();
 			local_irq_enable();
-			return 0;
+			return -EINVAL;
 		}
 	}
 
@@ -904,7 +927,7 @@ static int acpi_idle_enter_bm(struct cpuidle_device *dev,
 		if (unlikely(need_resched())) {
 			current_thread_info()->status |= TS_POLLING;
 			local_irq_enable();
-			return 0;
+			return -EINVAL;
 		}
 	}
 
@@ -954,6 +977,11 @@ static int acpi_idle_enter_bm(struct cpuidle_device *dev,
 	idle_time = idle_time_ns;
 	do_div(idle_time, NSEC_PER_USEC);
 
+	/* Update device last_residency and state counters*/
+	dev->last_residency = (int)idle_time;
+	dev->states[index].time += (unsigned long long)dev->last_residency;
+	dev->states[index].usage++;
+
 	/* Tell the scheduler how much we idled: */
 	sched_clock_idle_wakeup_event(idle_time_ns);
 
@@ -965,7 +993,7 @@ static int acpi_idle_enter_bm(struct cpuidle_device *dev,
 
 	lapic_timer_state_broadcast(pr, cx, 0);
 	cx->time += idle_time;
-	return idle_time;
+	return index;
 }
 
 struct cpuidle_driver acpi_idle_driver = {
@@ -992,6 +1020,7 @@ static int acpi_processor_setup_cpuidle(struct acpi_processor *pr)
 	}
 
 	dev->cpu = pr->id;
+	dev->safe_state_index = -1;
 	for (i = 0; i < CPUIDLE_STATE_MAX; i++) {
 		dev->states[i].name[0] = '\0';
 		dev->states[i].desc[0] = '\0';
@@ -1027,13 +1056,13 @@ static int acpi_processor_setup_cpuidle(struct acpi_processor *pr)
 				state->flags |= CPUIDLE_FLAG_TIME_VALID;
 
 			state->enter = acpi_idle_enter_c1;
-			dev->safe_state = state;
+			dev->safe_state_index = count;
 			break;
 
 			case ACPI_STATE_C2:
 			state->flags |= CPUIDLE_FLAG_TIME_VALID;
 			state->enter = acpi_idle_enter_simple;
-			dev->safe_state = state;
+			dev->safe_state_index = count;
 			break;
 
 			case ACPI_STATE_C3:
diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index bf50924..355b078 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -51,7 +51,7 @@ static void cpuidle_idle_call(void)
 {
 	struct cpuidle_device *dev = __this_cpu_read(cpuidle_devices);
 	struct cpuidle_state *target_state;
-	int next_state;
+	int next_state, entered_state;
 
 	/* check if the device is ready */
 	if (!dev || !dev->enabled) {
@@ -94,26 +94,18 @@ static void cpuidle_idle_call(void)
 
 	target_state = &dev->states[next_state];
 
-	/* enter the state and update stats */
-	dev->last_state = target_state;
-
+	/* Is using next_state here correct?? */
 	trace_power_start(POWER_CSTATE, next_state, dev->cpu);
 	trace_cpu_idle(next_state, dev->cpu);
 
-	dev->last_residency = target_state->enter(dev, target_state);
+	entered_state = target_state->enter(dev, next_state);
 
 	trace_power_end(dev->cpu);
 	trace_cpu_idle(PWR_EVENT_EXIT, dev->cpu);
 
-	if (dev->last_state)
-		target_state = dev->last_state;
-
-	target_state->time += (unsigned long long)dev->last_residency;
-	target_state->usage++;
-
 	/* give the governor an opportunity to reflect on the outcome */
 	if (cpuidle_curr_governor->reflect)
-		cpuidle_curr_governor->reflect(dev);
+		cpuidle_curr_governor->reflect(dev, entered_state);
 }
 
 /**
@@ -162,11 +154,10 @@ void cpuidle_resume_and_unlock(void)
 EXPORT_SYMBOL_GPL(cpuidle_resume_and_unlock);
 
 #ifdef CONFIG_ARCH_HAS_CPU_RELAX
-static int poll_idle(struct cpuidle_device *dev, struct cpuidle_state *st)
+static int poll_idle(struct cpuidle_device *dev, int index)
 {
 	ktime_t	t1, t2;
 	s64 diff;
-	int ret;
 
 	t1 = ktime_get();
 	local_irq_enable();
@@ -178,8 +169,11 @@ static int poll_idle(struct cpuidle_device *dev, struct cpuidle_state *st)
 	if (diff > INT_MAX)
 		diff = INT_MAX;
 
-	ret = (int) diff;
-	return ret;
+	dev->last_residency = (int) diff;
+	dev->states[index].time += (unsigned long long)dev->last_residency;
+	dev->states[index].usage++;
+
+	return index;
 }
 
 static void poll_idle_init(struct cpuidle_device *dev)
@@ -238,7 +232,6 @@ int cpuidle_enable_device(struct cpuidle_device *dev)
 		dev->states[i].time = 0;
 	}
 	dev->last_residency = 0;
-	dev->last_state = NULL;
 
 	smp_wmb();
 
diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index f508690..70d9982 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -308,14 +308,17 @@ static int menu_select(struct cpuidle_device *dev)
 /**
  * menu_reflect - records that data structures need update
  * @dev: the CPU
+ * @index: the index of actual entered state
  *
  * NOTE: it's important to be fast here because this operation will add to
  *       the overall exit latency.
  */
-static void menu_reflect(struct cpuidle_device *dev)
+static void menu_reflect(struct cpuidle_device *dev, int index)
 {
 	struct menu_device *data = &__get_cpu_var(menu_devices);
-	data->needs_update = 1;
+	data->last_state_idx = index;
+	if (index >= 0)
+		data->needs_update = 1;
 }
 
 /**
diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
index 36719ea..45eef60 100644
--- a/include/linux/cpuidle.h
+++ b/include/linux/cpuidle.h
@@ -42,7 +42,7 @@ struct cpuidle_state {
 	unsigned long long	time; /* in US */
 
 	int (*enter)	(struct cpuidle_device *dev,
-			 struct cpuidle_state *state);
+			int index);
 };
 
 /* Idle State Flags */
@@ -87,13 +87,12 @@ struct cpuidle_device {
 	int			state_count;
 	struct cpuidle_state	states[CPUIDLE_STATE_MAX];
 	struct cpuidle_state_kobj *kobjs[CPUIDLE_STATE_MAX];
-	struct cpuidle_state	*last_state;
 
 	struct list_head 	device_list;
 	struct kobject		kobj;
 	struct completion	kobj_unregister;
 	void			*governor_data;
-	struct cpuidle_state	*safe_state;
+	int			safe_state_index;
 
 	int (*prepare)		(struct cpuidle_device *dev);
 };
@@ -165,7 +164,7 @@ struct cpuidle_governor {
 	void (*disable)		(struct cpuidle_device *dev);
 
 	int  (*select)		(struct cpuidle_device *dev);
-	void (*reflect)		(struct cpuidle_device *dev);
+	void (*reflect)		(struct cpuidle_device *dev, int index);
 
 	struct module 		*owner;
 };

