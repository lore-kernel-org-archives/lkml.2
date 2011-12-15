Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759206Ab1LOROM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 12:14:12 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:37300 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759032Ab1LOROK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 12:14:10 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LW98EJ-02-BPH-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH v4 3/4] perf, x86: Implement IBS pmu control ops
Date: Thu, 15 Dec 2011 17:56:38 +0100
Message-ID: <1323968199-9326-4-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1323968199-9326-1-git-send-email-robert.richter@amd.com>
References: <1323968199-9326-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add code to control the IBS pmu. We need to maintain per-cpu
states. Since some states are used and changed by the nmi handler,
access to these states must be atomic.

V4:
* fix returned number of handled nmis in perf_ibs_handle_irq()

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_event_amd_ibs.c |  106 +++++++++++++++++++++++++++++-
 1 files changed, 103 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd_ibs.c b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
index a7ec6bd..40a6d9d 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_ibs.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
@@ -24,6 +24,19 @@ static u32 ibs_caps;
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
@@ -33,6 +46,7 @@ struct perf_ibs {
 	u64		valid_mask;
 	unsigned long	offset_mask[1];
 	int		offset_max;
+	struct cpu_perf_ibs __percpu *pcpu;
 };
 
 struct perf_ibs_data {
@@ -97,15 +111,66 @@ static int perf_ibs_init(struct perf_event *event)
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
@@ -113,6 +178,9 @@ static struct perf_ibs perf_ibs_fetch = {
 		.event_init	= perf_ibs_init,
 		.add		= perf_ibs_add,
 		.del		= perf_ibs_del,
+		.start		= perf_ibs_start,
+		.stop		= perf_ibs_stop,
+		.read		= perf_ibs_read,
 	},
 	.msr			= MSR_AMD64_IBSFETCHCTL,
 	.config_mask		= IBS_FETCH_CONFIG_MASK,
@@ -130,6 +198,9 @@ static struct perf_ibs perf_ibs_op = {
 		.event_init	= perf_ibs_init,
 		.add		= perf_ibs_add,
 		.del		= perf_ibs_del,
+		.start		= perf_ibs_start,
+		.stop		= perf_ibs_stop,
+		.read		= perf_ibs_read,
 	},
 	.msr			= MSR_AMD64_IBSOPCTL,
 	.config_mask		= IBS_OP_CONFIG_MASK,
@@ -142,7 +213,8 @@ static struct perf_ibs perf_ibs_op = {
 
 static int perf_ibs_handle_irq(struct perf_ibs *perf_ibs, struct pt_regs *iregs)
 {
-	struct perf_event *event = NULL;
+	struct cpu_perf_ibs *pcpu = this_cpu_ptr(perf_ibs->pcpu);
+	struct perf_event *event = pcpu->event;
 	struct hw_perf_event *hwc = &event->hw;
 	struct perf_sample_data data;
 	struct perf_raw_record raw;
@@ -152,6 +224,14 @@ static int perf_ibs_handle_irq(struct perf_ibs *perf_ibs, struct pt_regs *iregs)
 	unsigned int msr;
 	u64 *buf;
 
+	if (!test_bit(IBS_STARTED, pcpu->state)) {
+		/* Catch spurious interrupts after stopping IBS: */
+		if (!test_and_clear_bit(IBS_STOPPING, pcpu->state))
+			return 0;
+		rdmsrl(perf_ibs->msr, *ibs_data.regs);
+		return (*ibs_data.regs & perf_ibs->valid_mask) ? 1 : 0;
+	}
+
 	msr = hwc->config_base;
 	buf = ibs_data.regs;
 	rdmsrl(msr, *buf);
@@ -200,13 +280,33 @@ perf_ibs_nmi_handler(unsigned int cmd, struct pt_regs *regs)
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
1.7.7


