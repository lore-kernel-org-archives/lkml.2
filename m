Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758195Ab2JXKho (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 06:37:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55565 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754417Ab2JXKhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 06:37:42 -0400
Date: Wed, 24 Oct 2012 03:36:22 -0700
From: tip-bot for Vince Weaver <vincent.weaver@maine.edu>
Message-ID: <tip-e4074b3049f99c6ad6e1a33e6d93d8ec0652e2c1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@kernel.org, lawrence.f.meadows@intel.com, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, vincent.weaver@maine.edu, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, lawrence.f.meadows@intel.com,
        a.p.zijlstra@chello.nl, acme@ghostprotocols.net,
        vincent.weaver@maine.edu, tglx@linutronix.de
In-Reply-To: <alpine.DEB.2.02.1210171304410.23243@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.02.1210171304410.23243@vincent-weaver-1.um.maine.edu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/x86:
  Enable overflow on Intel KNC with a custom knc_pmu_handle_irq()
Git-Commit-ID: e4074b3049f99c6ad6e1a33e6d93d8ec0652e2c1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 24 Oct 2012 03:36:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e4074b3049f99c6ad6e1a33e6d93d8ec0652e2c1
Gitweb:     http://git.kernel.org/tip/e4074b3049f99c6ad6e1a33e6d93d8ec0652e2c1
Author:     Vince Weaver <vincent.weaver@maine.edu>
AuthorDate: Wed, 17 Oct 2012 13:05:45 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Oct 2012 12:00:49 +0200

perf/x86: Enable overflow on Intel KNC with a custom knc_pmu_handle_irq()

Although based on the Intel P6 design, the interrupt mechnanism
for KNC more closely resembles the Intel architectural
perfmon one.

We can't just re-use that code though, because KNC has different
MSR numbers for the status and ack registers.

In this case we just cut-and paste from perf_event_intel.c
with some minor changes, as it looks like it would not be
worth the trouble to change that code to be MSR-configurable.

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: eranian@gmail.com
Cc: Meadows Lawrence F <lawrence.f.meadows@intel.com>
Link: http://lkml.kernel.org/r/alpine.DEB.2.02.1210171304410.23243@vincent-weaver-1.um.maine.edu
[ Small stylistic edits. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_knc.c |   78 +++++++++++++++++++++++++++++++++-
 1 files changed, 77 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_knc.c b/arch/x86/kernel/cpu/perf_event_knc.c
index f3a2af4..4b7731b 100644
--- a/arch/x86/kernel/cpu/perf_event_knc.c
+++ b/arch/x86/kernel/cpu/perf_event_knc.c
@@ -3,6 +3,8 @@
 #include <linux/perf_event.h>
 #include <linux/types.h>
 
+#include <asm/hardirq.h>
+
 #include "perf_event.h"
 
 static const u64 knc_perfmon_event_map[] =
@@ -193,6 +195,80 @@ static void knc_pmu_enable_event(struct perf_event *event)
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
+	int handled = 0;
+	int bit, loops;
+	u64 status;
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
+		WARN_ONCE(1, "perf: irq loop stuck!\n");
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
@@ -210,7 +286,7 @@ static struct attribute *intel_knc_formats_attr[] = {
 
 static __initconst struct x86_pmu knc_pmu = {
 	.name			= "knc",
-	.handle_irq		= x86_pmu_handle_irq,
+	.handle_irq		= knc_pmu_handle_irq,
 	.disable_all		= knc_pmu_disable_all,
 	.enable_all		= knc_pmu_enable_all,
 	.enable			= knc_pmu_enable_event,
