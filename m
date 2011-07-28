Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755680Ab1G1Nus (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 09:50:48 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:41565
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755605Ab1G1Num (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 09:50:42 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LP1QGB-01-3TX-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 5/7] perf, x86: Implement IBS pmu control ops
Date: Thu, 28 Jul 2011 15:46:50 +0200
Message-ID: <1311860812-28748-6-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.5.3
In-Reply-To: <1311860812-28748-1-git-send-email-robert.richter@amd.com>
References: <1311860812-28748-1-git-send-email-robert.richter@amd.com>
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
 arch/x86/kernel/cpu/perf_event_amd_ibs.c |  113 +++++++++++++++++++++++++++---
 1 files changed, 103 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd_ibs.c b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
index 09311e3..ea9f360 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_ibs.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
@@ -20,6 +20,19 @@
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
@@ -28,6 +41,7 @@ struct perf_ibs {
 	u64		enable_mask;
 	u64		valid_mask;
 	int		reg_count;
+	struct cpu_perf_ibs __percpu *pcpu;
 };
 
 static struct perf_ibs perf_ibs_fetch;
@@ -80,30 +94,77 @@ static int perf_ibs_init(struct perf_event *event)
 	hwc->config_base = perf_ibs->msr;
 	hwc->config = config;
 
-	pr_info("Found event %p (config=%016llx) for pmu %s (type=%d) on cpu %d\n",
-		event, event->attr.config, event->pmu->name, event->attr.type, event->oncpu);
-
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
-	pr_info("Adding event %p (config=%016llx) for pmu %p (name='%s', type=%d) on cpu %d\n",
-		event, event->attr.config, event->pmu, event->pmu->name, event->attr.type, event->oncpu);
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
-	pr_info("Removing event %p (config=%016llx) for pmu %p (name='%s', type=%d) on cpu %d\n",
-		event, event->attr.config, event->pmu, event->pmu->name, event->attr.type, event->oncpu);
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
 		.event_init	= perf_ibs_init,
 		.add		= perf_ibs_add,
 		.del		= perf_ibs_del,
+		.start		= perf_ibs_start,
+		.stop		= perf_ibs_stop,
+		.read		= perf_ibs_read,
 	},
 	.msr			= MSR_AMD64_IBSFETCHCTL,
 	.config_mask		= IBS_FETCH_CONFIG_MASK,
@@ -118,6 +179,9 @@ static struct perf_ibs perf_ibs_op = {
 		.event_init	= perf_ibs_init,
 		.add		= perf_ibs_add,
 		.del		= perf_ibs_del,
+		.start		= perf_ibs_start,
+		.stop		= perf_ibs_stop,
+		.read		= perf_ibs_read,
 	},
 	.msr			= MSR_AMD64_IBSOPCTL,
 	.config_mask		= IBS_OP_CONFIG_MASK,
@@ -129,7 +193,8 @@ static struct perf_ibs perf_ibs_op = {
 
 static int perf_ibs_handle_irq(struct perf_ibs *perf_ibs, struct pt_regs *iregs)
 {
-	struct perf_event *event = NULL;
+	struct cpu_perf_ibs *pcpu = this_cpu_ptr(perf_ibs->pcpu);
+	struct perf_event *event = pcpu->event;
 	struct hw_perf_event *hwc = &event->hw;
 	struct perf_sample_data data;
 	struct perf_raw_record raw;
@@ -139,6 +204,14 @@ static int perf_ibs_handle_irq(struct perf_ibs *perf_ibs, struct pt_regs *iregs)
 	unsigned int msr;
 	u64 *buf;
 
+	if (!test_bit(IBS_STARTED, pcpu->state)) {
+		/* Catch spurious interrupts after stopping IBS: */
+		if (!test_and_clear_bit(IBS_STOPPING, pcpu->state))
+			return 0;
+		rdmsrl(perf_ibs->msr, *buffer);
+		return (*buffer & perf_ibs->valid_mask);
+	}
+
 	msr = hwc->config_base;
 	buf = buffer;
 	rdmsrl(msr++, *buf);
@@ -195,6 +268,26 @@ static __read_mostly struct notifier_block perf_ibs_nmi_notifier = {
 	.priority		= NMI_LOCAL_LOW_PRIOR,
 };
 
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
 	u32 caps;
@@ -203,8 +296,8 @@ static __init int perf_event_ibs_init(void)
 	if (!caps)
 		return -ENODEV;	/* ibs not supported by the cpu */
 
-	perf_pmu_register(&perf_ibs_fetch.pmu, "ibs_fetch", -1);
-	perf_pmu_register(&perf_ibs_op.pmu, "ibs_op", -1);
+	perf_ibs_pmu_init(&perf_ibs_fetch, "ibs_fetch");
+	perf_ibs_pmu_init(&perf_ibs_op, "ibs_op");
 	register_die_notifier(&perf_ibs_nmi_notifier);
 	printk(KERN_INFO "perf: AMD IBS detected (0x%08x)\n", caps);
 
-- 
1.7.5.3


