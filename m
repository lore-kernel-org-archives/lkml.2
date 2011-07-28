Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782Ab1G1NvC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 09:51:02 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:54859
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755469Ab1G1Nul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 09:50:41 -0400
X-SpamScore: 4
X-BigFish: VPS4(zz853kzz1202hzz8275bhz32i668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LP1QGC-01-3U0-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 4/7] perf, x86: Implement IBS interrupt handler
Date: Thu, 28 Jul 2011 15:46:49 +0200
Message-ID: <1311860812-28748-5-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.5.3
In-Reply-To: <1311860812-28748-1-git-send-email-robert.richter@amd.com>
References: <1311860812-28748-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements code to handle ibs interrupts. If ibs data is
available a raw perf_event data sample is created and sent back to the
userland. This patch only implements the storage of ibs data in the
raw sample, but this could be extended in a later patch by generating
generic event data such as the rip from the ibs sampling data.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/include/asm/msr-index.h         |    3 +
 arch/x86/kernel/cpu/perf_event_amd_ibs.c |   80 ++++++++++++++++++++++++++++++
 2 files changed, 83 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 485b4f1..75f131e 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -127,6 +127,7 @@
 #define MSR_AMD64_IBSFETCHCTL		0xc0011030
 #define MSR_AMD64_IBSFETCHLINAD		0xc0011031
 #define MSR_AMD64_IBSFETCHPHYSAD	0xc0011032
+#define MSR_AMD64_IBSFETCH_REG_COUNT	3
 #define MSR_AMD64_IBSOPCTL		0xc0011033
 #define MSR_AMD64_IBSOPRIP		0xc0011034
 #define MSR_AMD64_IBSOPDATA		0xc0011035
@@ -134,6 +135,8 @@
 #define MSR_AMD64_IBSOPDATA3		0xc0011037
 #define MSR_AMD64_IBSDCLINAD		0xc0011038
 #define MSR_AMD64_IBSDCPHYSAD		0xc0011039
+#define MSR_AMD64_IBSOP_REG_COUNT	7
+#define MSR_AMD64_IBS_REG_COUNT_MAX	MSR_AMD64_IBSOP_REG_COUNT
 #define MSR_AMD64_IBSCTL		0xc001103a
 #define MSR_AMD64_IBSBRTARGET		0xc001103b
 
diff --git a/arch/x86/kernel/cpu/perf_event_amd_ibs.c b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
index bd77209..09311e3 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_ibs.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
@@ -12,6 +12,11 @@
 
 #if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_CPU_SUP_AMD)
 
+#include <linux/kprobes.h>
+#include <linux/hardirq.h>
+
+#include <asm/nmi.h>
+
 #define IBS_FETCH_CONFIG_MASK	(IBS_FETCH_RAND_EN | IBS_FETCH_MAX_CNT)
 #define IBS_OP_CONFIG_MASK	IBS_OP_MAX_CNT
 
@@ -21,6 +26,8 @@ struct perf_ibs {
 	u64		config_mask;
 	u64		cnt_mask;
 	u64		enable_mask;
+	u64		valid_mask;
+	int		reg_count;
 };
 
 static struct perf_ibs perf_ibs_fetch;
@@ -102,6 +109,8 @@ static struct perf_ibs perf_ibs_fetch = {
 	.config_mask		= IBS_FETCH_CONFIG_MASK,
 	.cnt_mask		= IBS_FETCH_MAX_CNT,
 	.enable_mask		= IBS_FETCH_ENABLE,
+	.valid_mask		= IBS_FETCH_VAL,
+	.reg_count		= MSR_AMD64_IBSFETCH_REG_COUNT,
 };
 
 static struct perf_ibs perf_ibs_op = {
@@ -114,6 +123,76 @@ static struct perf_ibs perf_ibs_op = {
 	.config_mask		= IBS_OP_CONFIG_MASK,
 	.cnt_mask		= IBS_OP_MAX_CNT,
 	.enable_mask		= IBS_OP_ENABLE,
+	.valid_mask		= IBS_OP_VAL,
+	.reg_count		= MSR_AMD64_IBSOP_REG_COUNT,
+};
+
+static int perf_ibs_handle_irq(struct perf_ibs *perf_ibs, struct pt_regs *iregs)
+{
+	struct perf_event *event = NULL;
+	struct hw_perf_event *hwc = &event->hw;
+	struct perf_sample_data data;
+	struct perf_raw_record raw;
+	struct pt_regs regs;
+	u64 buffer[MSR_AMD64_IBS_REG_COUNT_MAX];
+	int i;
+	unsigned int msr;
+	u64 *buf;
+
+	msr = hwc->config_base;
+	buf = buffer;
+	rdmsrl(msr++, *buf);
+	if (!(*buf++ & perf_ibs->valid_mask))
+		return 0;
+
+	perf_sample_data_init(&data, 0);
+	if (event->attr.sample_type & PERF_SAMPLE_RAW) {
+		for (i = 1; i < perf_ibs->reg_count; i++)
+			rdmsrl(msr++, *buf++);
+		raw.size = sizeof(u32) + sizeof(u64) * perf_ibs->reg_count;
+		raw.data = buffer;
+		data.raw = &raw;
+	}
+
+	regs = *iregs; /* XXX: update ip from ibs sample */
+
+	if (perf_event_overflow(event, &data, &regs))
+		; /* stop */
+	else
+		/* reenable */
+		wrmsrl(hwc->config_base, hwc->config | perf_ibs->enable_mask);
+
+	return 1;
+}
+
+static int __kprobes
+perf_ibs_nmi_handler(struct notifier_block *self,
+		     unsigned long cmd, void *__args)
+{
+	struct die_args *args = __args;
+	int handled = 0;
+
+	switch (cmd) {
+	case DIE_NMI:
+		break;
+	default:
+		return NOTIFY_DONE;
+	}
+
+	handled += perf_ibs_handle_irq(&perf_ibs_fetch, args->regs);
+	handled += perf_ibs_handle_irq(&perf_ibs_op, args->regs);
+
+	if (!handled)
+		return NOTIFY_DONE;
+
+	inc_irq_stat(apic_perf_irqs);
+
+	return NOTIFY_STOP;
+}
+
+static __read_mostly struct notifier_block perf_ibs_nmi_notifier = {
+	.notifier_call		= perf_ibs_nmi_handler,
+	.priority		= NMI_LOCAL_LOW_PRIOR,
 };
 
 static __init int perf_event_ibs_init(void)
@@ -126,6 +205,7 @@ static __init int perf_event_ibs_init(void)
 
 	perf_pmu_register(&perf_ibs_fetch.pmu, "ibs_fetch", -1);
 	perf_pmu_register(&perf_ibs_op.pmu, "ibs_op", -1);
+	register_die_notifier(&perf_ibs_nmi_notifier);
 	printk(KERN_INFO "perf: AMD IBS detected (0x%08x)\n", caps);
 
 	return 0;
-- 
1.7.5.3


