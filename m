Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757550Ab2CHMX7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 07:23:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51662 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823Ab2CHMX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 07:23:56 -0500
Date: Thu, 8 Mar 2012 04:23:07 -0800
From: tip-bot for Robert Richter <robert.richter@amd.com>
Message-ID: <tip-b7074f1fbd6149eac1ec25063e4a364c39a85473@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, robert.richter@amd.com, peterz@infradead.org,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, robert.richter@amd.com,
        peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1323968199-9326-3-git-send-email-robert.richter@amd.com>
References: <1323968199-9326-3-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/x86-ibs] perf/x86: Implement IBS interrupt handler
Git-Commit-ID: b7074f1fbd6149eac1ec25063e4a364c39a85473
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 08 Mar 2012 04:23:35 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b7074f1fbd6149eac1ec25063e4a364c39a85473
Gitweb:     http://git.kernel.org/tip/b7074f1fbd6149eac1ec25063e4a364c39a85473
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Thu, 15 Dec 2011 17:56:37 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 8 Mar 2012 11:35:21 +0100

perf/x86: Implement IBS interrupt handler

This patch implements code to handle ibs interrupts. If ibs data
is available a raw perf_event data sample is created and sent
back to the userland. This patch only implements the storage of
ibs data in the raw sample, but this could be extended in a
later patch by generating generic event data such as the rip
from the ibs sampling data.

Signed-off-by: Robert Richter <robert.richter@amd.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1323968199-9326-3-git-send-email-robert.richter@amd.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/msr-index.h         |    5 ++
 arch/x86/kernel/cpu/perf_event_amd_ibs.c |   84 ++++++++++++++++++++++++++++++
 2 files changed, 89 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index a6962d9..4e3cd38 100644
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
index 36684eb..a7ec6bd 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_ibs.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
@@ -16,6 +16,11 @@ static u32 ibs_caps;
 
 #if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_CPU_SUP_AMD)
 
+#include <linux/kprobes.h>
+#include <linux/hardirq.h>
+
+#include <asm/nmi.h>
+
 #define IBS_FETCH_CONFIG_MASK	(IBS_FETCH_RAND_EN | IBS_FETCH_MAX_CNT)
 #define IBS_OP_CONFIG_MASK	IBS_OP_MAX_CNT
 
@@ -25,6 +30,18 @@ struct perf_ibs {
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
@@ -101,6 +118,9 @@ static struct perf_ibs perf_ibs_fetch = {
 	.config_mask		= IBS_FETCH_CONFIG_MASK,
 	.cnt_mask		= IBS_FETCH_MAX_CNT,
 	.enable_mask		= IBS_FETCH_ENABLE,
+	.valid_mask		= IBS_FETCH_VAL,
+	.offset_mask		= { MSR_AMD64_IBSFETCH_REG_MASK },
+	.offset_max		= MSR_AMD64_IBSFETCH_REG_COUNT,
 };
 
 static struct perf_ibs perf_ibs_op = {
@@ -115,8 +135,71 @@ static struct perf_ibs perf_ibs_op = {
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
@@ -124,6 +207,7 @@ static __init int perf_event_ibs_init(void)
 
 	perf_pmu_register(&perf_ibs_fetch.pmu, "ibs_fetch", -1);
 	perf_pmu_register(&perf_ibs_op.pmu, "ibs_op", -1);
+	register_nmi_handler(NMI_LOCAL, &perf_ibs_nmi_handler, 0, "perf_ibs");
 	printk(KERN_INFO "perf: AMD IBS detected (0x%08x)\n", ibs_caps);
 
 	return 0;
