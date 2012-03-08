Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757558Ab2CHMYs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 07:24:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51674 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756918Ab2CHMYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 07:24:45 -0500
Date: Thu, 8 Mar 2012 04:23:56 -0800
From: tip-bot for Robert Richter <robert.richter@amd.com>
Message-ID: <tip-4db2e8e6500d9ba6406f2714fa3968b39a325274@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, robert.richter@amd.com, peterz@infradead.org,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, robert.richter@amd.com,
        peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1323968199-9326-4-git-send-email-robert.richter@amd.com>
References: <1323968199-9326-4-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/x86-ibs] perf/x86: Implement IBS pmu control ops
Git-Commit-ID: 4db2e8e6500d9ba6406f2714fa3968b39a325274
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 08 Mar 2012 04:24:23 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4db2e8e6500d9ba6406f2714fa3968b39a325274
Gitweb:     http://git.kernel.org/tip/4db2e8e6500d9ba6406f2714fa3968b39a325274
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Thu, 15 Dec 2011 17:56:38 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 8 Mar 2012 11:35:22 +0100

perf/x86: Implement IBS pmu control ops

Add code to control the IBS pmu. We need to maintain per-cpu
states. Since some states are used and changed by the nmi
handler, access to these states must be atomic.

Signed-off-by: Robert Richter <robert.richter@amd.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1323968199-9326-4-git-send-email-robert.richter@amd.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
 
