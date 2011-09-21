Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753066Ab1IUK6D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 06:58:03 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:23021 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708Ab1IUK6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 06:58:01 -0400
X-SpamScore: 4
X-BigFish: VPS4(zz853kzz1202hzz8275bhz32i668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-FB-SS: 0,
X-WSS-ID: 0LRVD2N-01-0V9-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [V3][PATCH 4/7] perf, x86: Implement IBS interrupt handler
Date: Wed, 21 Sep 2011 11:30:20 +0200
Message-ID: <1316597423-25723-5-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1316597423-25723-1-git-send-email-robert.richter@amd.com>
References: <1316597423-25723-1-git-send-email-robert.richter@amd.com>
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

V2:
* Added bit mask for msr offsets.
* Added caps field to raw sample format.
* Rebase on Don's NMI patches that introduce register_nmi_handler().

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/include/asm/msr-index.h         |    5 ++
 arch/x86/kernel/cpu/perf_event_amd_ibs.c |   84 ++++++++++++++++++++++++++++++
 2 files changed, 89 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index d52609a..eca3363 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -127,6 +127,8 @@
 #define MSR_AMD64_IBSFETCHCTL		0xc0011030
 #define MSR_AMD64_IBSFETCHLINAD		0xc0011031
 #define MSR_AMD64_IBSFETCHPHYSAD	0xc0011032
+#define MSR_AMD64_IBSFETCH_REG_COUNT	3
+#define MSR_AMD64_IBSFETCH_REG_MASK	((1UL<<MSR_AMD64_IBSFETCH_REG_COUNT)-1)
 #define MSR_AMD64_IBSOPCTL		0xc0011033
 #define MSR_AMD64_IBSOPRIP		0xc0011034
 #define MSR_AMD64_IBSOPDATA		0xc0011035
@@ -134,8 +136,11 @@
 #define MSR_AMD64_IBSOPDATA3		0xc0011037
 #define MSR_AMD64_IBSDCLINAD		0xc0011038
 #define MSR_AMD64_IBSDCPHYSAD		0xc0011039
+#define MSR_AMD64_IBSOP_REG_COUNT	7
+#define MSR_AMD64_IBSOP_REG_MASK	((1UL<<MSR_AMD64_IBSOP_REG_COUNT)-1)
 #define MSR_AMD64_IBSCTL		0xc001103a
 #define MSR_AMD64_IBSBRTARGET		0xc001103b
+#define MSR_AMD64_IBS_REG_COUNT_MAX	8 /* includes MSR_AMD64_IBSBRTARGET */
 
 /* Fam 15h MSRs */
 #define MSR_F15H_PERF_CTL		0xc0010200
diff --git a/arch/x86/kernel/cpu/perf_event_amd_ibs.c b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
index 911aeec..57b38d5 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_ibs.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
@@ -14,6 +14,11 @@ static u32 ibs_caps;
 
 #if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_CPU_SUP_AMD)
 
+#include <linux/kprobes.h>
+#include <linux/hardirq.h>
+
+#include <asm/nmi.h>
+
 #define IBS_FETCH_CONFIG_MASK	(IBS_FETCH_RAND_EN | IBS_FETCH_MAX_CNT)
 #define IBS_OP_CONFIG_MASK	IBS_OP_MAX_CNT
 
@@ -23,6 +28,18 @@ struct perf_ibs {
 	u64		config_mask;
 	u64		cnt_mask;
 	u64		enable_mask;
+	u64		valid_mask;
+	unsigned long	offset_mask[1];
+	int		offset_max;
+};
+
+struct perf_ibs_data {
+	u32		size;
+	union {
+		u32	data[0];	/* data buffer starts here */
+		u32	caps;
+	};
+	u64		regs[MSR_AMD64_IBS_REG_COUNT_MAX];
 };
 
 static struct perf_ibs perf_ibs_fetch;
@@ -99,6 +116,9 @@ static struct perf_ibs perf_ibs_fetch = {
 	.config_mask		= IBS_FETCH_CONFIG_MASK,
 	.cnt_mask		= IBS_FETCH_MAX_CNT,
 	.enable_mask		= IBS_FETCH_ENABLE,
+	.valid_mask		= IBS_FETCH_VAL,
+	.offset_mask		= { MSR_AMD64_IBSFETCH_REG_MASK },
+	.offset_max		= MSR_AMD64_IBSFETCH_REG_COUNT,
 };
 
 static struct perf_ibs perf_ibs_op = {
@@ -113,8 +133,71 @@ static struct perf_ibs perf_ibs_op = {
 	.config_mask		= IBS_OP_CONFIG_MASK,
 	.cnt_mask		= IBS_OP_MAX_CNT,
 	.enable_mask		= IBS_OP_ENABLE,
+	.valid_mask		= IBS_OP_VAL,
+	.offset_mask		= { MSR_AMD64_IBSOP_REG_MASK },
+	.offset_max		= MSR_AMD64_IBSOP_REG_COUNT,
 };
 
+static int perf_ibs_handle_irq(struct perf_ibs *perf_ibs, struct pt_regs *iregs)
+{
+	struct perf_event *event = NULL;
+	struct hw_perf_event *hwc = &event->hw;
+	struct perf_sample_data data;
+	struct perf_raw_record raw;
+	struct pt_regs regs;
+	struct perf_ibs_data ibs_data;
+	int offset, size;
+	unsigned int msr;
+	u64 *buf;
+
+	msr = hwc->config_base;
+	buf = ibs_data.regs;
+	rdmsrl(msr, *buf);
+	if (!(*buf++ & perf_ibs->valid_mask))
+		return 0;
+
+	perf_sample_data_init(&data, 0);
+	if (event->attr.sample_type & PERF_SAMPLE_RAW) {
+		ibs_data.caps = ibs_caps;
+		size = 1;
+		offset = 1;
+		do {
+		    rdmsrl(msr + offset, *buf++);
+		    size++;
+		    offset = find_next_bit(perf_ibs->offset_mask,
+					   perf_ibs->offset_max,
+					   offset + 1);
+		} while (offset < perf_ibs->offset_max);
+		raw.size = sizeof(u32) + sizeof(u64) * size;
+		raw.data = ibs_data.data;
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
+perf_ibs_nmi_handler(unsigned int cmd, struct pt_regs *regs)
+{
+	int handled = 0;
+
+	handled += perf_ibs_handle_irq(&perf_ibs_fetch, regs);
+	handled += perf_ibs_handle_irq(&perf_ibs_op, regs);
+
+	if (handled)
+		inc_irq_stat(apic_perf_irqs);
+
+	return handled;
+}
+
 static __init int perf_event_ibs_init(void)
 {
 	if (!ibs_caps)
@@ -122,6 +205,7 @@ static __init int perf_event_ibs_init(void)
 
 	perf_pmu_register(&perf_ibs_fetch.pmu, "ibs_fetch", -1);
 	perf_pmu_register(&perf_ibs_op.pmu, "ibs_op", -1);
+	register_nmi_handler(NMI_LOCAL, &perf_ibs_nmi_handler, 0, "perf_ibs");
 	printk(KERN_INFO "perf: AMD IBS detected (0x%08x)\n", ibs_caps);
 
 	return 0;
-- 
1.7.6.1


