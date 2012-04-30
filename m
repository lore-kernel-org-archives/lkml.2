Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720Ab2D3UKB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 16:10:01 -0400
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:39265 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756729Ab2D3UJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 16:09:22 -0400
From: Colin Cross <ccross@android.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-pm@lists.linux-foundation.org,
        Kevin Hilman <khilman@ti.com>, Len Brown <len.brown@intel.com>,
        Trinabh Gupta <g.trinabh@gmail.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Colin Cross <ccross@android.com>
Subject: [PATCHv3 5/5] cpuidle: coupled: add trace events
Date: Mon, 30 Apr 2012 13:09:11 -0700
Message-Id: <1335816551-27756-6-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1335816551-27756-1-git-send-email-ccross@android.com>
References: <1335816551-27756-1-git-send-email-ccross@android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds trace events to allow debugging of coupled cpuidle.
Can be used to verify cpuidle performance, including time spent
spinning and time spent in safe states.

Reviewed-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Tested-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Reviewed-by: Kevin Hilman <khilman@ti.com>
Tested-by: Kevin Hilman <khilman@ti.com>
Signed-off-by: Colin Cross <ccross@android.com>
---
 drivers/cpuidle/coupled.c      |   29 +++++-
 include/trace/events/cpuidle.h |  243 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 270 insertions(+), 2 deletions(-)
 create mode 100644 include/trace/events/cpuidle.h

v3:
   * removed debugging code from cpuidle_coupled_parallel_barrier
     so this patch can be merged to help with debugging new
     coupled cpuidle drivers
   * made tracing _rcuidle

diff --git a/drivers/cpuidle/coupled.c b/drivers/cpuidle/coupled.c
index 242dc7c..6b63d67 100644
--- a/drivers/cpuidle/coupled.c
+++ b/drivers/cpuidle/coupled.c
@@ -26,6 +26,11 @@
 
 #include "cpuidle.h"
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/cpuidle.h>
+
+atomic_t cpuidle_trace_seq;
+
 /**
  * DOC: Coupled cpuidle states
  *
@@ -232,6 +237,7 @@ static inline int cpuidle_coupled_get_state(struct cpuidle_device *dev,
 static void cpuidle_coupled_poked(void *info)
 {
 	int cpu = (unsigned long)info;
+	trace_coupled_poked_rcuidle(cpu);
 	cpumask_clear_cpu(cpu, &cpuidle_coupled_poked_mask);
 }
 
@@ -251,8 +257,10 @@ static void cpuidle_coupled_poke(int cpu)
 {
 	struct call_single_data *csd = &per_cpu(cpuidle_coupled_poke_cb, cpu);
 
-	if (!cpumask_test_and_set_cpu(cpu, &cpuidle_coupled_poked_mask))
+	if (!cpumask_test_and_set_cpu(cpu, &cpuidle_coupled_poked_mask)) {
+		trace_coupled_poke_rcuidle(cpu);
 		__smp_call_function_single(cpu, csd, 0);
+	}
 }
 
 /**
@@ -361,28 +369,37 @@ int cpuidle_enter_state_coupled(struct cpuidle_device *dev,
 	BUG_ON(atomic_read(&coupled->ready_count));
 	cpuidle_coupled_set_waiting(dev, coupled, next_state);
 
+	trace_coupled_enter_rcuidle(dev->cpu);
+
 retry:
 	/*
 	 * Wait for all coupled cpus to be idle, using the deepest state
 	 * allowed for a single cpu.
 	 */
 	while (!need_resched() && !cpuidle_coupled_cpus_waiting(coupled)) {
+		trace_coupled_safe_enter_rcuidle(dev->cpu);
 		entered_state = cpuidle_enter_state(dev, drv,
 			dev->safe_state_index);
+		trace_coupled_safe_exit_rcuidle(dev->cpu);
 
+		trace_coupled_spin_rcuidle(dev->cpu);
 		local_irq_enable();
 		while (cpumask_test_cpu(dev->cpu, &cpuidle_coupled_poked_mask))
 			cpu_relax();
 		local_irq_disable();
+		trace_coupled_unspin_rcuidle(dev->cpu);
 	}
 
 	/* give a chance to process any remaining pokes */
+	trace_coupled_spin_rcuidle(dev->cpu);
 	local_irq_enable();
 	while (cpumask_test_cpu(dev->cpu, &cpuidle_coupled_poked_mask))
 		cpu_relax();
 	local_irq_disable();
+	trace_coupled_unspin_rcuidle(dev->cpu);
 
 	if (need_resched()) {
+		trace_coupled_abort_rcuidle(dev->cpu);
 		cpuidle_coupled_set_not_waiting(dev, coupled);
 		goto out;
 	}
@@ -401,29 +418,35 @@ int cpuidle_enter_state_coupled(struct cpuidle_device *dev,
 	smp_mb__after_atomic_inc();
 	/* alive_count can't change while ready_count > 0 */
 	alive = atomic_read(&coupled->alive_count);
+	trace_coupled_spin_rcuidle(dev->cpu);
 	while (atomic_read(&coupled->ready_count) != alive) {
 		/* Check if any other cpus bailed out of idle. */
 		if (!cpuidle_coupled_cpus_waiting(coupled)) {
 			atomic_dec(&coupled->ready_count);
 			smp_mb__after_atomic_dec();
+			trace_coupled_detected_abort_rcuidle(dev->cpu);
 			goto retry;
 		}
 
 		cpu_relax();
 	}
+	trace_coupled_unspin_rcuidle(dev->cpu);
 
 	/* all cpus have acked the coupled state */
 	smp_rmb();
 
 	next_state = cpuidle_coupled_get_state(dev, coupled);
-
+	trace_coupled_idle_enter_rcuidle(dev->cpu);
 	entered_state = cpuidle_enter_state(dev, drv, next_state);
+	trace_coupled_idle_exit_rcuidle(dev->cpu);
 
 	cpuidle_coupled_set_not_waiting(dev, coupled);
 	atomic_dec(&coupled->ready_count);
 	smp_mb__after_atomic_dec();
 
 out:
+	trace_coupled_exit_rcuidle(dev->cpu);
+
 	/*
 	 * Normal cpuidle states are expected to return with irqs enabled.
 	 * That leads to an inefficiency where a cpu receiving an interrupt
@@ -445,8 +468,10 @@ int cpuidle_enter_state_coupled(struct cpuidle_device *dev,
 	 * a cpu exits and re-enters the ready state because this cpu has
 	 * already decremented its waiting_count.
 	 */
+	trace_coupled_spin_rcuidle(dev->cpu);
 	while (atomic_read(&coupled->ready_count) != 0)
 		cpu_relax();
+	trace_coupled_unspin_rcuidle(dev->cpu);
 
 	smp_rmb();
 
diff --git a/include/trace/events/cpuidle.h b/include/trace/events/cpuidle.h
new file mode 100644
index 0000000..9b2cbbb
--- /dev/null
+++ b/include/trace/events/cpuidle.h
@@ -0,0 +1,243 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM cpuidle
+
+#if !defined(_TRACE_CPUIDLE_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_CPUIDLE_H
+
+#include <linux/atomic.h>
+#include <linux/tracepoint.h>
+
+extern atomic_t cpuidle_trace_seq;
+
+TRACE_EVENT(coupled_enter,
+
+	TP_PROTO(unsigned int cpu),
+
+	TP_ARGS(cpu),
+
+	TP_STRUCT__entry(
+		__field(unsigned int, cpu)
+		__field(unsigned int, seq)
+	),
+
+	TP_fast_assign(
+		__entry->cpu = cpu;
+		__entry->seq = atomic_inc_return(&cpuidle_trace_seq);
+	),
+
+	TP_printk("%u %u", __entry->seq, __entry->cpu)
+);
+
+TRACE_EVENT(coupled_exit,
+
+	TP_PROTO(unsigned int cpu),
+
+	TP_ARGS(cpu),
+
+	TP_STRUCT__entry(
+		__field(unsigned int, cpu)
+		__field(unsigned int, seq)
+	),
+
+	TP_fast_assign(
+		__entry->cpu = cpu;
+		__entry->seq = atomic_inc_return(&cpuidle_trace_seq);
+	),
+
+	TP_printk("%u %u", __entry->seq, __entry->cpu)
+);
+
+TRACE_EVENT(coupled_spin,
+
+	TP_PROTO(unsigned int cpu),
+
+	TP_ARGS(cpu),
+
+	TP_STRUCT__entry(
+		__field(unsigned int, cpu)
+		__field(unsigned int, seq)
+	),
+
+	TP_fast_assign(
+		__entry->cpu = cpu;
+		__entry->seq = atomic_inc_return(&cpuidle_trace_seq);
+	),
+
+	TP_printk("%u %u", __entry->seq, __entry->cpu)
+);
+
+TRACE_EVENT(coupled_unspin,
+
+	TP_PROTO(unsigned int cpu),
+
+	TP_ARGS(cpu),
+
+	TP_STRUCT__entry(
+		__field(unsigned int, cpu)
+		__field(unsigned int, seq)
+	),
+
+	TP_fast_assign(
+		__entry->cpu = cpu;
+		__entry->seq = atomic_inc_return(&cpuidle_trace_seq);
+	),
+
+	TP_printk("%u %u", __entry->seq, __entry->cpu)
+);
+
+TRACE_EVENT(coupled_safe_enter,
+
+	TP_PROTO(unsigned int cpu),
+
+	TP_ARGS(cpu),
+
+	TP_STRUCT__entry(
+		__field(unsigned int, cpu)
+		__field(unsigned int, seq)
+	),
+
+	TP_fast_assign(
+		__entry->cpu = cpu;
+		__entry->seq = atomic_inc_return(&cpuidle_trace_seq);
+	),
+
+	TP_printk("%u %u", __entry->seq, __entry->cpu)
+);
+
+TRACE_EVENT(coupled_safe_exit,
+
+	TP_PROTO(unsigned int cpu),
+
+	TP_ARGS(cpu),
+
+	TP_STRUCT__entry(
+		__field(unsigned int, cpu)
+		__field(unsigned int, seq)
+	),
+
+	TP_fast_assign(
+		__entry->cpu = cpu;
+		__entry->seq = atomic_inc_return(&cpuidle_trace_seq);
+	),
+
+	TP_printk("%u %u", __entry->seq, __entry->cpu)
+);
+
+TRACE_EVENT(coupled_idle_enter,
+
+	TP_PROTO(unsigned int cpu),
+
+	TP_ARGS(cpu),
+
+	TP_STRUCT__entry(
+		__field(unsigned int, cpu)
+		__field(unsigned int, seq)
+	),
+
+	TP_fast_assign(
+		__entry->cpu = cpu;
+		__entry->seq = atomic_inc_return(&cpuidle_trace_seq);
+	),
+
+	TP_printk("%u %u", __entry->seq, __entry->cpu)
+);
+
+TRACE_EVENT(coupled_idle_exit,
+
+	TP_PROTO(unsigned int cpu),
+
+	TP_ARGS(cpu),
+
+	TP_STRUCT__entry(
+		__field(unsigned int, cpu)
+		__field(unsigned int, seq)
+	),
+
+	TP_fast_assign(
+		__entry->cpu = cpu;
+		__entry->seq = atomic_inc_return(&cpuidle_trace_seq);
+	),
+
+	TP_printk("%u %u", __entry->seq, __entry->cpu)
+);
+
+TRACE_EVENT(coupled_abort,
+
+	TP_PROTO(unsigned int cpu),
+
+	TP_ARGS(cpu),
+
+	TP_STRUCT__entry(
+		__field(unsigned int, cpu)
+		__field(unsigned int, seq)
+	),
+
+	TP_fast_assign(
+		__entry->cpu = cpu;
+		__entry->seq = atomic_inc_return(&cpuidle_trace_seq);
+	),
+
+	TP_printk("%u %u", __entry->seq, __entry->cpu)
+);
+
+TRACE_EVENT(coupled_detected_abort,
+
+	TP_PROTO(unsigned int cpu),
+
+	TP_ARGS(cpu),
+
+	TP_STRUCT__entry(
+		__field(unsigned int, cpu)
+		__field(unsigned int, seq)
+	),
+
+	TP_fast_assign(
+		__entry->cpu = cpu;
+		__entry->seq = atomic_inc_return(&cpuidle_trace_seq);
+	),
+
+	TP_printk("%u %u", __entry->seq, __entry->cpu)
+);
+
+TRACE_EVENT(coupled_poke,
+
+	TP_PROTO(unsigned int cpu),
+
+	TP_ARGS(cpu),
+
+	TP_STRUCT__entry(
+		__field(unsigned int, cpu)
+		__field(unsigned int, seq)
+	),
+
+	TP_fast_assign(
+		__entry->cpu = cpu;
+		__entry->seq = atomic_inc_return(&cpuidle_trace_seq);
+	),
+
+	TP_printk("%u %u", __entry->seq, __entry->cpu)
+);
+
+TRACE_EVENT(coupled_poked,
+
+	TP_PROTO(unsigned int cpu),
+
+	TP_ARGS(cpu),
+
+	TP_STRUCT__entry(
+		__field(unsigned int, cpu)
+		__field(unsigned int, seq)
+	),
+
+	TP_fast_assign(
+		__entry->cpu = cpu;
+		__entry->seq = atomic_inc_return(&cpuidle_trace_seq);
+	),
+
+	TP_printk("%u %u", __entry->seq, __entry->cpu)
+);
+
+#endif /* if !defined(_TRACE_CPUIDLE_H) || defined(TRACE_HEADER_MULTI_READ) */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
-- 
1.7.7.3

