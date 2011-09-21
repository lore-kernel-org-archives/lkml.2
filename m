Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264Ab1IUK61 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 06:58:27 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:35798 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879Ab1IUK6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 06:58:25 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h839h65h)
X-Spam-TCS-SCL: 4:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LRVD2G-01-0V6-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [V3][PATCH 5/7] perf, x86: Implement IBS pmu control ops
Date: Wed, 21 Sep 2011 11:30:21 +0200
Message-ID: <1316597423-25723-6-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1316597423-25723-1-git-send-email-robert.richter@amd.com>
References: <1316597423-25723-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add code to control the IBS pmu. We need to maintain per-cpu
states. Since some states are used and changed by the nmi handler,
access to these states must be atomic.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_event_amd_ibs.c |  106 +++++++++++++++++++++++++++++-
 1 files changed, 103 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd_ibs.c b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
index 57b38d5..9713d31 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_ibs.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
@@ -22,6 +22,19 @@ static u32 ibs_caps;
 #define IBS_FETCH_CONFIG_MASK	(IBS_FETCH_RAND_EN | IBS_FETCH_MAX_CNT)
 #define IBS_OP_CONFIG_MASK	IBS_OP_MAX_CNT
 
+enum ibs_states {
+	IBS_ENABLED	= 0,
+	IBS_STARTED	= 1,
+	IBS_STOPPING	= 2,
+
+	IBS_MAX_STATES,
+};
+
+struct cpu_perf_ibs {
+	struct perf_event	*event;
+	unsigned long		state[BITS_TO_LONGS(IBS_MAX_STATES)];
+};
+
 struct perf_ibs {
 	struct pmu	pmu;
 	unsigned int	msr;
@@ -31,6 +44,7 @@ struct perf_ibs {
 	u64		valid_mask;
 	unsigned long	offset_mask[1];
 	int		offset_max;
+	struct cpu_perf_ibs __percpu *pcpu;
 };
 
 struct perf_ibs_data {
@@ -95,15 +109,66 @@ static int perf_ibs_init(struct perf_event *event)
 	return 0;
 }
 
+static void perf_ibs_start(struct perf_event *event, int flags)
+{
+	struct hw_perf_event *hwc = &event->hw;
+	struct perf_ibs *perf_ibs = container_of(event->pmu, struct perf_ibs, pmu);
+	struct cpu_perf_ibs *pcpu = this_cpu_ptr(perf_ibs->pcpu);
+
+	if (test_and_set_bit(IBS_STARTED, pcpu->state))
+		return;
+
+	wrmsrl(hwc->config_base, hwc->config | perf_ibs->enable_mask);
+}
+
+static void perf_ibs_stop(struct perf_event *event, int flags)
+{
+	struct hw_perf_event *hwc = &event->hw;
+	struct perf_ibs *perf_ibs = container_of(event->pmu, struct perf_ibs, pmu);
+	struct cpu_perf_ibs *pcpu = this_cpu_ptr(perf_ibs->pcpu);
+	u64 val;
+
+	if (!test_and_clear_bit(IBS_STARTED, pcpu->state))
+		return;
+
+	set_bit(IBS_STOPPING, pcpu->state);
+
+	rdmsrl(hwc->config_base, val);
+	val &= ~perf_ibs->enable_mask;
+	wrmsrl(hwc->config_base, val);
+}
+
 static int perf_ibs_add(struct perf_event *event, int flags)
 {
+	struct perf_ibs *perf_ibs = container_of(event->pmu, struct perf_ibs, pmu);
+	struct cpu_perf_ibs *pcpu = this_cpu_ptr(perf_ibs->pcpu);
+
+	if (test_and_set_bit(IBS_ENABLED, pcpu->state))
+		return -ENOSPC;
+
+	pcpu->event = event;
+
+	if (flags & PERF_EF_START)
+		perf_ibs_start(event, PERF_EF_RELOAD);
+
 	return 0;
 }
 
 static void perf_ibs_del(struct perf_event *event, int flags)
 {
+	struct perf_ibs *perf_ibs = container_of(event->pmu, struct perf_ibs, pmu);
+	struct cpu_perf_ibs *pcpu = this_cpu_ptr(perf_ibs->pcpu);
+
+	if (!test_and_clear_bit(IBS_ENABLED, pcpu->state))
+		return;
+
+	perf_ibs_stop(event, 0);
+
+	pcpu->event = NULL;
 }
 
+static void perf_ibs_read(struct perf_event *event) { }
+
 static struct perf_ibs perf_ibs_fetch = {
 	.pmu = {
 		.task_ctx_nr	= perf_invalid_context,
@@ -111,6 +176,9 @@ static struct perf_ibs perf_ibs_fetch = {
 		.event_init	= perf_ibs_init,
 		.add		= perf_ibs_add,
 		.del		= perf_ibs_del,
+		.start		= perf_ibs_start,
+		.stop		= perf_ibs_stop,
+		.read		= perf_ibs_read,
 	},
 	.msr			= MSR_AMD64_IBSFETCHCTL,
 	.config_mask		= IBS_FETCH_CONFIG_MASK,
@@ -128,6 +196,9 @@ static struct perf_ibs perf_ibs_op = {
 		.event_init	= perf_ibs_init,
 		.add		= perf_ibs_add,
 		.del		= perf_ibs_del,
+		.start		= perf_ibs_start,
+		.stop		= perf_ibs_stop,
+		.read		= perf_ibs_read,
 	},
 	.msr			= MSR_AMD64_IBSOPCTL,
 	.config_mask		= IBS_OP_CONFIG_MASK,
@@ -140,7 +211,8 @@ static struct perf_ibs perf_ibs_op = {
 
 static int perf_ibs_handle_irq(struct perf_ibs *perf_ibs, struct pt_regs *iregs)
 {
-	struct perf_event *event = NULL;
+	struct cpu_perf_ibs *pcpu = this_cpu_ptr(perf_ibs->pcpu);
+	struct perf_event *event = pcpu->event;
 	struct hw_perf_event *hwc = &event->hw;
 	struct perf_sample_data data;
 	struct perf_raw_record raw;
@@ -150,6 +222,14 @@ static int perf_ibs_handle_irq(struct perf_ibs *perf_ibs, struct pt_regs *iregs)
 	unsigned int msr;
 	u64 *buf;
 
+	if (!test_bit(IBS_STARTED, pcpu->state)) {
+		/* Catch spurious interrupts after stopping IBS: */
+		if (!test_and_clear_bit(IBS_STOPPING, pcpu->state))
+			return 0;
+		rdmsrl(perf_ibs->msr, *ibs_data.regs);
+		return (*ibs_data.regs & perf_ibs->valid_mask);
+	}
+
 	msr = hwc->config_base;
 	buf = ibs_data.regs;
 	rdmsrl(msr, *buf);
@@ -198,13 +278,33 @@ perf_ibs_nmi_handler(unsigned int cmd, struct pt_regs *regs)
 	return handled;
 }
 
+static __init int perf_ibs_pmu_init(struct perf_ibs *perf_ibs, char *name)
+{
+	struct cpu_perf_ibs __percpu *pcpu;
+	int ret;
+
+	pcpu = alloc_percpu(struct cpu_perf_ibs);
+	if (!pcpu)
+		return -ENOMEM;
+
+	perf_ibs->pcpu = pcpu;
+
+	ret = perf_pmu_register(&perf_ibs->pmu, name, -1);
+	if (ret) {
+		perf_ibs->pcpu = NULL;
+		free_percpu(pcpu);
+	}
+
+	return ret;
+}
+
 static __init int perf_event_ibs_init(void)
 {
 	if (!ibs_caps)
 		return -ENODEV;	/* ibs not supported by the cpu */
 
-	perf_pmu_register(&perf_ibs_fetch.pmu, "ibs_fetch", -1);
-	perf_pmu_register(&perf_ibs_op.pmu, "ibs_op", -1);
+	perf_ibs_pmu_init(&perf_ibs_fetch, "ibs_fetch");
+	perf_ibs_pmu_init(&perf_ibs_op, "ibs_op");
 	register_nmi_handler(NMI_LOCAL, &perf_ibs_nmi_handler, 0, "perf_ibs");
 	printk(KERN_INFO "perf: AMD IBS detected (0x%08x)\n", ibs_caps);
 
-- 
1.7.6.1


