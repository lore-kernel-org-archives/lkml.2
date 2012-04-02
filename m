Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422Ab2DBSUO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 14:20:14 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:46870
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754294Ab2DBSUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 14:20:07 -0400
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M1V6XB-01-AHO-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 10/12] perf/x86-ibs: Implement workaround for IBS erratum #420
Date: Mon, 2 Apr 2012 20:19:16 +0200
Message-ID: <1333390758-10893-11-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1333390758-10893-1-git-send-email-robert.richter@amd.com>
References: <1333390758-10893-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When disabling ibs there might be the case where hardware continuously
generates interrupts. This is described in erratum #420 (Instruction-
Based Sampling Engine May Generate Interrupt that Cannot Be Cleared).
To avoid this we must clear the counter mask first and then clear the
enable bit. This patch implements this.

See Revision Guide for AMD Family 10h Processors, Publication #41322.

Note: We now keep track of the last read ibs config value which is
then used to disable ibs. To update the config value we pass now a
pointer to the functions reading it.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_event_amd_ibs.c |   62 +++++++++++++++++++-----------
 1 files changed, 39 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd_ibs.c b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
index f0271dd..35a35be 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_ibs.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
@@ -293,20 +293,36 @@ static u64 get_ibs_op_count(u64 config)
 
 static void
 perf_ibs_event_update(struct perf_ibs *perf_ibs, struct perf_event *event,
-		      u64 config)
+		      u64 *config)
 {
-	u64 count = perf_ibs->get_count(config);
+	u64 count = perf_ibs->get_count(*config);
 
 	while (!perf_event_try_update(event, count, 20)) {
-		rdmsrl(event->hw.config_base, config);
-		count = perf_ibs->get_count(config);
+		rdmsrl(event->hw.config_base, *config);
+		count = perf_ibs->get_count(*config);
 	}
 }
 
-/* Note: The enable mask must be encoded in the config argument. */
-static inline void perf_ibs_enable_event(struct hw_perf_event *hwc, u64 config)
+static inline void perf_ibs_enable_event(struct perf_ibs *perf_ibs,
+					 struct hw_perf_event *hwc, u64 config)
 {
-	wrmsrl(hwc->config_base, hwc->config | config);
+	wrmsrl(hwc->config_base, hwc->config | config | perf_ibs->enable_mask);
+}
+
+/*
+ * Erratum #420 Instruction-Based Sampling Engine May Generate
+ * Interrupt that Cannot Be Cleared:
+ *
+ * Must clear counter mask first, then clear the enable bit. See
+ * Revision Guide for AMD Family 10h Processors, Publication #41322.
+ */
+static inline void perf_ibs_disable_event(struct perf_ibs *perf_ibs,
+					  struct hw_perf_event *hwc, u64 config)
+{
+	config &= ~perf_ibs->cnt_mask;
+	wrmsrl(hwc->config_base, config);
+	config &= ~perf_ibs->enable_mask;
+	wrmsrl(hwc->config_base, config);
 }
 
 /*
@@ -320,7 +336,7 @@ static void perf_ibs_start(struct perf_event *event, int flags)
 	struct hw_perf_event *hwc = &event->hw;
 	struct perf_ibs *perf_ibs = container_of(event->pmu, struct perf_ibs, pmu);
 	struct cpu_perf_ibs *pcpu = this_cpu_ptr(perf_ibs->pcpu);
-	u64 config;
+	u64 period;
 
 	if (WARN_ON_ONCE(!(hwc->state & PERF_HES_STOPPED)))
 		return;
@@ -328,10 +344,9 @@ static void perf_ibs_start(struct perf_event *event, int flags)
 	WARN_ON_ONCE(!(hwc->state & PERF_HES_UPTODATE));
 	hwc->state = 0;
 
-	perf_ibs_set_period(perf_ibs, hwc, &config);
-	config = (config >> 4) | perf_ibs->enable_mask;
+	perf_ibs_set_period(perf_ibs, hwc, &period);
 	set_bit(IBS_STARTED, pcpu->state);
-	perf_ibs_enable_event(hwc, config);
+	perf_ibs_enable_event(perf_ibs, hwc, period >> 4);
 
 	perf_event_update_userpage(event);
 }
@@ -341,7 +356,7 @@ static void perf_ibs_stop(struct perf_event *event, int flags)
 	struct hw_perf_event *hwc = &event->hw;
 	struct perf_ibs *perf_ibs = container_of(event->pmu, struct perf_ibs, pmu);
 	struct cpu_perf_ibs *pcpu = this_cpu_ptr(perf_ibs->pcpu);
-	u64 val;
+	u64 config;
 	int stopping;
 
 	stopping = test_and_clear_bit(IBS_STARTED, pcpu->state);
@@ -349,12 +364,11 @@ static void perf_ibs_stop(struct perf_event *event, int flags)
 	if (!stopping && (hwc->state & PERF_HES_UPTODATE))
 		return;
 
-	rdmsrl(hwc->config_base, val);
+	rdmsrl(hwc->config_base, config);
 
 	if (stopping) {
 		set_bit(IBS_STOPPING, pcpu->state);
-		val &= ~perf_ibs->enable_mask;
-		wrmsrl(hwc->config_base, val);
+		perf_ibs_disable_event(perf_ibs, hwc, config);
 		WARN_ON_ONCE(hwc->state & PERF_HES_STOPPED);
 		hwc->state |= PERF_HES_STOPPED;
 	}
@@ -362,7 +376,7 @@ static void perf_ibs_stop(struct perf_event *event, int flags)
 	if (hwc->state & PERF_HES_UPTODATE)
 		return;
 
-	perf_ibs_event_update(perf_ibs, event, val);
+	perf_ibs_event_update(perf_ibs, event, &config);
 	hwc->state |= PERF_HES_UPTODATE;
 }
 
@@ -458,7 +472,7 @@ static int perf_ibs_handle_irq(struct perf_ibs *perf_ibs, struct pt_regs *iregs)
 	struct perf_ibs_data ibs_data;
 	int offset, size, check_rip, offset_max, throttle = 0;
 	unsigned int msr;
-	u64 *buf, config;
+	u64 *buf, *config, period;
 
 	if (!test_bit(IBS_STARTED, pcpu->state)) {
 		/* Catch spurious interrupts after stopping IBS: */
@@ -479,15 +493,15 @@ static int perf_ibs_handle_irq(struct perf_ibs *perf_ibs, struct pt_regs *iregs)
 	 * supported in all cpus. As this triggered an interrupt, we
 	 * set the current count to the max count.
 	 */
-	config = ibs_data.regs[0];
+	config = &ibs_data.regs[0];
 	if (perf_ibs == &perf_ibs_op && !(ibs_caps & IBS_CAPS_RDWROPCNT)) {
-		config &= ~IBS_OP_CUR_CNT;
-		config |= (config & IBS_OP_MAX_CNT) << 36;
+		*config &= ~IBS_OP_CUR_CNT;
+		*config |= (*config & IBS_OP_MAX_CNT) << 36;
 	}
 
 	perf_ibs_event_update(perf_ibs, event, config);
 	perf_sample_data_init(&data, 0, hwc->last_period);
-	if (!perf_ibs_set_period(perf_ibs, hwc, &config))
+	if (!perf_ibs_set_period(perf_ibs, hwc, &period))
 		goto out;	/* no sw counter overflow */
 
 	ibs_data.caps = ibs_caps;
@@ -523,8 +537,10 @@ static int perf_ibs_handle_irq(struct perf_ibs *perf_ibs, struct pt_regs *iregs)
 
 	throttle = perf_event_overflow(event, &data, &regs);
 out:
-	config = (config >> 4) | (throttle ? 0 : perf_ibs->enable_mask);
-	perf_ibs_enable_event(hwc, config);
+	if (throttle)
+		perf_ibs_disable_event(perf_ibs, hwc, *config);
+	else
+		perf_ibs_enable_event(perf_ibs, hwc, period >> 4);
 
 	perf_event_update_userpage(event);
 
-- 
1.7.8.4


