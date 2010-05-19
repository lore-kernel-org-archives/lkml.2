Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544Ab0ESVm3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 17:42:29 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:47052 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab0ESVlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 17:41:06 -0400
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMab9bhzz1202hzzz32i87h2a8h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L2OS87-02-UVA-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 7/7] perf, x86: implement the ibs interrupt handler
Date: Wed, 19 May 2010 23:20:24 +0200
Message-ID: <1274304024-6551-8-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1274304024-6551-1-git-send-email-robert.richter@amd.com>
References: <1274304024-6551-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
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
 arch/x86/include/asm/msr-index.h     |    3 +
 arch/x86/kernel/cpu/perf_event_amd.c |   70 +++++++++++++++++++++++++++++++++-
 2 files changed, 72 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index bc473ac..8b9929f 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -113,6 +113,7 @@
 #define MSR_AMD64_IBSFETCHCTL		0xc0011030
 #define MSR_AMD64_IBSFETCHLINAD		0xc0011031
 #define MSR_AMD64_IBSFETCHPHYSAD	0xc0011032
+#define MSR_AMD64_IBSFETCH_REG_COUNT	3
 #define MSR_AMD64_IBSOPCTL		0xc0011033
 #define MSR_AMD64_IBSOPRIP		0xc0011034
 #define MSR_AMD64_IBSOPDATA		0xc0011035
@@ -120,7 +121,9 @@
 #define MSR_AMD64_IBSOPDATA3		0xc0011037
 #define MSR_AMD64_IBSDCLINAD		0xc0011038
 #define MSR_AMD64_IBSDCPHYSAD		0xc0011039
+#define MSR_AMD64_IBSOP_REG_COUNT	7
 #define MSR_AMD64_IBSCTL		0xc001103a
+#define MSR_AMD64_IBS_REG_COUNT_MAX	MSR_AMD64_IBSOP_REG_COUNT
 
 /* Fam 10h MSRs */
 #define MSR_FAM10H_MMIO_CONF_BASE	0xc0010058
diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index 5161745..a083174 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -11,22 +11,31 @@
 struct ibs_map {
 	int idx;
 	u64 cnt_mask;
+	u64 sample_valid;
+	u64 enable;
 	u64 valid_mask;
 	unsigned int msr;
+	int reg_count;
 };
 
 static struct ibs_map ibs_map[] = {
 	[IBS_FETCH_MAP_IDX] = {
 		.idx		= X86_PMC_IDX_SPECIAL_IBS_FETCH,
 		.cnt_mask	= IBS_FETCH_MAX_CNT,
+		.sample_valid	= IBS_FETCH_VAL,
+		.enable		= IBS_FETCH_ENABLE,
 		.valid_mask	= IBS_FETCH_CONFIG_MASK,
 		.msr		= MSR_AMD64_IBSFETCHCTL,
+		.reg_count	= MSR_AMD64_IBSFETCH_REG_COUNT,
 	},
 	[IBS_OP_MAP_IDX] = {
 		.idx		= X86_PMC_IDX_SPECIAL_IBS_OP,
 		.cnt_mask	= IBS_OP_MAX_CNT,
+		.sample_valid	= IBS_OP_VAL,
+		.enable		= IBS_OP_ENABLE,
 		.valid_mask	= IBS_OP_CONFIG_MASK,
 		.msr		= MSR_AMD64_IBSOPCTL,
+		.reg_count	= MSR_AMD64_IBSOP_REG_COUNT,
 	},
 };
 
@@ -312,6 +321,65 @@ static inline void __amd_pmu_enable_ibs_event(struct hw_perf_event *hwc)
 		__x86_pmu_enable_event(hwc, IBS_OP_ENABLE);
 }
 
+static int amd_pmu_check_ibs(struct pt_regs *iregs, int map_idx)
+{
+	struct ibs_map *map = &ibs_map[map_idx];
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct perf_event *event = cpuc->events[map->idx];
+	struct perf_sample_data data;
+	struct perf_raw_record raw;
+	struct pt_regs regs;
+	u64 buffer[MSR_AMD64_IBS_REG_COUNT_MAX];
+	int i;
+	unsigned int msr;
+	u64 *buf;
+
+	if (!test_bit(map->idx, cpuc->active_mask))
+		return 0;
+
+	msr = map->msr;
+	buf = buffer;
+	rdmsrl(msr++, *buf);
+	if (!(*buf++ & map->sample_valid))
+		return 0;
+
+	perf_sample_data_init(&data, 0);
+	if (event->attr.sample_type & PERF_SAMPLE_RAW) {
+		for (i = 1; i < map->reg_count; i++)
+			rdmsrl(msr++, *buf++);
+		raw.size = sizeof(u32) + sizeof(u64) * map->reg_count;
+		raw.data = buffer;
+		data.raw = &raw;
+	}
+
+	regs = *iregs; /* later: update ip from ibs sample */
+
+	if (perf_event_overflow(event, 1, &data, &regs))
+		x86_pmu_stop(event);
+	else
+		__x86_pmu_enable_event(&event->hw, map->enable);
+
+	return 1;
+}
+
+static int amd_pmu_handle_irq(struct pt_regs *regs)
+{
+	int handled, handled2;
+
+	handled = x86_pmu_handle_irq(regs);
+
+	if (!x86_pmu.ibs)
+		return handled;
+
+	handled2 = 0;
+	handled2 += amd_pmu_check_ibs(regs, IBS_FETCH_MAP_IDX);
+	handled2 += amd_pmu_check_ibs(regs, IBS_OP_MAP_IDX);
+	if (!handled && handled2)
+		inc_irq_stat(apic_perf_irqs);
+
+	return (handled || handled2);
+}
+
 static void amd_pmu_disable_all(void)
 {
 	x86_pmu_disable_all();
@@ -642,7 +710,7 @@ static void amd_pmu_cpu_dead(int cpu)
 
 static __initconst const struct x86_pmu amd_pmu = {
 	.name			= "AMD",
-	.handle_irq		= x86_pmu_handle_irq,
+	.handle_irq		= amd_pmu_handle_irq,
 	.disable_all		= amd_pmu_disable_all,
 	.enable_all		= amd_pmu_enable_all,
 	.enable			= amd_pmu_enable_event,
-- 
1.7.1


