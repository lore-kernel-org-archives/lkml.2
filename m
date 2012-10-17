Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757516Ab2JQRFB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 13:05:01 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:61118 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150Ab2JQRE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 13:04:59 -0400
Date: Wed, 17 Oct 2012 13:05:45 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: linux-kernel@vger.kernel.org
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, eranian@gmail.com,
        "Meadows, Lawrence F" <lawrence.f.meadows@intel.com>
Subject: [PATCH 3/3] perf_event: Enable overflow on KNC with a custom
 knc_pmu_handle_irq()
In-Reply-To: <alpine.DEB.2.02.1210171256550.23243@vincent-weaver-1.um.maine.edu>
Message-ID: <alpine.DEB.2.02.1210171304410.23243@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.02.1210171256550.23243@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Although based on the P6 design, the interrupt mechnanism
for KNC more closely resembles the intel architectural perfmon one.

We can't just re-use that code though, because KNC has different
MSR numbers for the status and ack registers.

In this case we just cut-and paste from perf_event_intel.c
with some minor changes, as it looks like it would not be
worth the trouble to change that code to be MSR-configurable.

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>

diff -ur linux-3.7-rc1.orig/arch/x86/kernel/cpu/perf_event_knc.c linux-3.7-rc1/arch/x86/kernel/cpu/perf_event_knc.c
--- linux-3.7-rc1.orig/arch/x86/kernel/cpu/perf_event_knc.c	2012-10-14 17:41:04.000000000 -0400
+++ linux-3.7-rc1/arch/x86/kernel/cpu/perf_event_knc.c	2012-10-17 12:11:48.604393067 -0400
@@ -3,6 +3,8 @@
 #include <linux/perf_event.h>
 #include <linux/types.h>
 
+#include <asm/hardirq.h>
+
 #include "perf_event.h"
 
 static const u64 knc_perfmon_event_map[] =
@@ -197,6 +199,80 @@
 	(void)wrmsrl_safe(hwc->config_base + hwc->idx, val);
 }
 
+static inline u64 knc_pmu_get_status(void)
+{
+	u64 status;
+
+	rdmsrl(MSR_KNC_IA32_PERF_GLOBAL_STATUS, status);
+
+	return status;
+}
+
+static inline void knc_pmu_ack_status(u64 ack)
+{
+	wrmsrl(MSR_KNC_IA32_PERF_GLOBAL_OVF_CONTROL, ack);
+}
+
+static int knc_pmu_handle_irq(struct pt_regs *regs)
+{
+	struct perf_sample_data data;
+	struct cpu_hw_events *cpuc;
+	int bit, loops;
+	u64 status;
+	int handled=0;
+
+	cpuc = &__get_cpu_var(cpu_hw_events);
+
+	knc_pmu_disable_all();
+
+	status = knc_pmu_get_status();
+	if (!status) {
+		knc_pmu_enable_all(0);
+		return handled;
+	}
+
+	loops = 0;
+again:
+	knc_pmu_ack_status(status);
+	if (++loops > 100) {
+		WARN_ONCE(1, "perfevents: irq loop stuck!\n");
+		perf_event_print_debug();
+		goto done;
+	}
+
+	inc_irq_stat(apic_perf_irqs);
+
+	for_each_set_bit(bit, (unsigned long *)&status, X86_PMC_IDX_MAX) {
+		struct perf_event *event = cpuc->events[bit];
+
+		handled++;
+
+		if (!test_bit(bit, cpuc->active_mask))
+			continue;
+
+		if (!intel_pmu_save_and_restart(event))
+			continue;
+
+		perf_sample_data_init(&data, 0, event->hw.last_period);
+
+		if (perf_event_overflow(event, &data, regs))
+			x86_pmu_stop(event, 0);
+	}
+
+	/*
+	 * Repeat if there is more work to be done:
+	 */
+	status = knc_pmu_get_status();
+	if (status)
+		goto again;
+
+done:
+	knc_pmu_enable_all(0);
+
+	return handled;
+}
+
+
 PMU_FORMAT_ATTR(event,	"config:0-7"	);
 PMU_FORMAT_ATTR(umask,	"config:8-15"	);
 PMU_FORMAT_ATTR(edge,	"config:18"	);
@@ -214,7 +290,7 @@
 
 static __initconst struct x86_pmu knc_pmu = {
 	.name			= "knc",
-	.handle_irq		= x86_pmu_handle_irq,
+	.handle_irq		= knc_pmu_handle_irq,
 	.disable_all		= knc_pmu_disable_all,
 	.enable_all		= knc_pmu_enable_all,
 	.enable			= knc_pmu_enable_event,
