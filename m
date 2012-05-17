Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966497Ab2EQOJO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 10:09:14 -0400
Received: from mga11.intel.com ([192.55.52.93]:50485 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966342Ab2EQOJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 10:09:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="167611446"
From: Andi Kleen <andi@firstfloor.org>
To: linux-acpi@vger.kernel.org
Cc: lenb@kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] Add ACPI and power trace points for laptop overheating
Date: Thu, 17 May 2012 07:08:57 -0700
Message-Id: <1337263737-3541-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add trace points for ACPI power events which are important for a laptop's
thermal: acpi throttling/pstate, ec communication, GPU overheating. Useful
for understanding the thermal behaviour of laptops on the thermal edge.

The generic power events have gpu_limit, overtemp_pstate and overtemp_throttling
I added ACPI specific new events for EC desynchronization (which
seems to be a common problem, but is entirely uninstrumented currently),
and can lead to lost throttling events.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 Documentation/trace/events-acpi.txt  |   13 ++++++++
 Documentation/trace/events-power.txt |   20 +++++++++++++
 drivers/acpi/Makefile                |    1 +
 drivers/acpi/acpi-trace.c            |    7 ++++
 drivers/acpi/ec.c                    |    4 ++
 drivers/acpi/processor_thermal.c     |    4 ++
 drivers/platform/x86/intel_ips.c     |    4 ++
 include/trace/events/power.h         |   51 ++++++++++++++++++++++++++++++++++
 kernel/trace/power-traces.c          |    3 ++
 9 files changed, 107 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/trace/events-acpi.txt
 create mode 100644 drivers/acpi/acpi-trace.c

diff --git a/Documentation/trace/events-acpi.txt b/Documentation/trace/events-acpi.txt
new file mode 100644
index 0000000..c6638d5
--- /dev/null
+++ b/Documentation/trace/events-acpi.txt
@@ -0,0 +1,13 @@
+ACPI specific trace points
+
+acpi_ec_unsynchronized "status=%x wlen=%u rlen=%u wi=%u ri=%u"
+
+Communication with the embedded controller became unsynchronized
+(and some information may get lost)
+status is the EC status word, w/rlen and wi/ri is the state
+of the FIFO to the controller mailbox.
+
+acpi_ec_good "status=%x"
+
+Successfull communication with the EC controller. 
+status is the status word.
diff --git a/Documentation/trace/events-power.txt b/Documentation/trace/events-power.txt
index cf794af..796ef6a 100644
--- a/Documentation/trace/events-power.txt
+++ b/Documentation/trace/events-power.txt
@@ -8,6 +8,7 @@ within the kernel. Broadly speaking there are three major subheadings:
      cpuidle (C-states) and cpufreq (P-states)
   o System clock related changes
   o Power domains related changes and transitions
+  o Overheat events
 
 This document describes what each of the tracepoints is and why they
 might be useful.
@@ -88,3 +89,22 @@ power_domain_target	"%s state=%lu cpu_id=%lu"
 The first parameter gives the power domain name (e.g. "mpu_pwrdm").
 The second parameter is the power domain target state.
 
+4. Overheat events
+==================
+
+gpu_limit "avg=%u limit=%u"
+
+GPU specific thermal management. When the GPU gets to hot and throttles
+its frequency this event is invoked. avg and limit are GPU specific 
+measures of temperature. Currently only used by the Intel graphics IPS 
+"graphics turbo" driver.
+
+overtemp_pstate "cpu=%u pstate=%u throttling=%u"
+
+An overheating event forces the lowest p-state and may enable throttling
+later.
+
+overtemp_throttling "cpu=%u state=%u throttling=%u ret=%d"
+
+An overheating event enables throttling. ret=0 && throttling==1 means 
+throttling worked, otherwise it failed.
diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
index 47199e2..cac35a8 100644
--- a/drivers/acpi/Makefile
+++ b/drivers/acpi/Makefile
@@ -73,3 +73,4 @@ obj-$(CONFIG_ACPI_PROCESSOR_AGGREGATOR) += acpi_pad.o
 obj-$(CONFIG_ACPI_IPMI)		+= acpi_ipmi.o
 
 obj-$(CONFIG_ACPI_APEI)		+= apei/
+obj-$(CONFIG_TRACEPOINTS)	+= acpi-trace.o
\ No newline at end of file
diff --git a/drivers/acpi/acpi-trace.c b/drivers/acpi/acpi-trace.c
new file mode 100644
index 0000000..3b1c3ae
--- /dev/null
+++ b/drivers/acpi/acpi-trace.c
@@ -0,0 +1,7 @@
+/* Tracepoints for ACPI */
+#include <linux/export.h>
+#define CREATE_TRACE_POINTS
+#include <trace/events/acpi.h>
+
+EXPORT_TRACEPOINT_SYMBOL(acpi_ec_unsynchronized);
+EXPORT_TRACEPOINT_SYMBOL(acpi_ec_good);
diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 7edaccc..e520310 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -42,6 +42,7 @@
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
 #include <linux/dmi.h>
+#include <trace/events/acpi.h>
 
 #include "internal.h"
 
@@ -188,8 +189,11 @@ static void advance_transaction(struct acpi_ec *ec, u8 status)
 	} else if (ec->curr->wlen == ec->curr->wi &&
 		   (status & ACPI_EC_FLAG_IBF) == 0)
 		ec->curr->done = true;
+	trace_acpi_ec_good(status);
 	goto unlock;
 err:
+	trace_acpi_ec_unsynchronized(status, ec->curr->wlen, ec->curr->rlen, 
+				     ec->curr->wi, ec->curr->ri);
 	/* false interrupt, state didn't change */
 	if (in_interrupt())
 		++ec->curr->irq_count;
diff --git a/drivers/acpi/processor_thermal.c b/drivers/acpi/processor_thermal.c
index 641b545..e2da52f 100644
--- a/drivers/acpi/processor_thermal.c
+++ b/drivers/acpi/processor_thermal.c
@@ -30,6 +30,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/cpufreq.h>
+#include <trace/events/power.h>
 
 #include <asm/uaccess.h>
 
@@ -264,10 +265,13 @@ processor_set_cur_state(struct thermal_cooling_device *cdev,
 		if (pr->flags.throttling && pr->throttling.state)
 			result = acpi_processor_set_throttling(pr, 0, false);
 		cpufreq_set_cur_state(pr->id, state);
+		trace_overtemp_pstate(pr->id, state, pr->flags.throttling);
 	} else {
 		cpufreq_set_cur_state(pr->id, max_pstate);
 		result = acpi_processor_set_throttling(pr,
 				state - max_pstate, false);
+		trace_overtemp_throttling(pr->id, state - max_pstate, 
+					  pr->flags.throttling, result);
 	}
 	return result;
 }
diff --git a/drivers/platform/x86/intel_ips.c b/drivers/platform/x86/intel_ips.c
index 0ffdb3c..a32d422 100644
--- a/drivers/platform/x86/intel_ips.c
+++ b/drivers/platform/x86/intel_ips.c
@@ -72,6 +72,7 @@
 #include <linux/string.h>
 #include <linux/tick.h>
 #include <linux/timer.h>
+#include <trace/events/power.h>
 #include <drm/i915_drm.h>
 #include <asm/msr.h>
 #include <asm/processor.h>
@@ -622,6 +623,9 @@ static bool mcp_exceeded(struct ips_driver *ips)
 
 	spin_unlock_irqrestore(&ips->turbo_status_lock, flags);
 
+	if (ret)
+		trace_gpu_limit(avg_power, ips->mcp_power_limit);
+
 	return ret;
 }
 
diff --git a/include/trace/events/power.h b/include/trace/events/power.h
index cae9a94..2e9b2ae 100644
--- a/include/trace/events/power.h
+++ b/include/trace/events/power.h
@@ -65,6 +65,57 @@ TRACE_EVENT(machine_suspend,
 	TP_printk("state=%lu", (unsigned long)__entry->state)
 );
 
+TRACE_EVENT(gpu_limit,
+	TP_PROTO(unsigned avg, unsigned limit),
+	TP_ARGS(avg, limit),
+	TP_STRUCT__entry(
+		__field(	unsigned,	avg		)
+		__field(	unsigned,	limit		)
+	),
+	TP_fast_assign(
+		__entry->avg = avg;
+		__entry->limit = limit;
+	),
+	TP_printk("avg=%u limit=%u", __entry->avg, __entry->limit)
+);
+
+TRACE_EVENT(overtemp_pstate,
+	TP_PROTO(unsigned cpu, unsigned pstate, unsigned throttling),
+	TP_ARGS(cpu, pstate, throttling),
+	TP_STRUCT__entry(
+		__field(	unsigned,	cpu		)
+		__field(	unsigned,	pstate		)
+		__field(	unsigned,	throttling 	)
+	),
+	TP_fast_assign(
+		__entry->cpu = cpu;
+		__entry->pstate = pstate;
+		__entry->throttling = throttling;
+	),
+	TP_printk("cpu=%u pstate=%u throttling=%u", 
+		  __entry->cpu, __entry->pstate, __entry->throttling)
+);
+
+TRACE_EVENT(overtemp_throttling,
+	TP_PROTO(unsigned cpu, unsigned state, unsigned throttling, int ret),
+	TP_ARGS(cpu, state, throttling, ret),
+	TP_STRUCT__entry(
+		__field(	unsigned,	cpu		)
+		__field(	unsigned,	state		)
+		__field(	unsigned,	throttling 	)
+		__field(	int,		ret		)
+	),
+	TP_fast_assign(
+		__entry->cpu = cpu;
+		__entry->state = state;
+		__entry->throttling = throttling;
+		__entry->ret = ret;
+	),
+	TP_printk("cpu=%u state=%u throttling=%u ret=%d", 
+		  __entry->cpu, __entry->state, __entry->throttling,
+		  __entry->ret)
+);
+
 #ifdef CONFIG_EVENT_POWER_TRACING_DEPRECATED
 
 /*
diff --git a/kernel/trace/power-traces.c b/kernel/trace/power-traces.c
index f55fcf6..ce2ab6d 100644
--- a/kernel/trace/power-traces.c
+++ b/kernel/trace/power-traces.c
@@ -18,3 +18,6 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(power_start);
 #endif
 EXPORT_TRACEPOINT_SYMBOL_GPL(cpu_idle);
 
+EXPORT_TRACEPOINT_SYMBOL(gpu_limit);
+EXPORT_TRACEPOINT_SYMBOL(overtemp_pstate);
+EXPORT_TRACEPOINT_SYMBOL(overtemp_throttling);
-- 
1.7.7.6

