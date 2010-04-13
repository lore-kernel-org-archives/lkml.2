Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554Ab0DMU1E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 16:27:04 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:27484 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495Ab0DMU05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 16:26:57 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzab9bhzz1202hzzz32i87h467h6bh2a8h61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L0U0SG-02-H0M-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 12/12] perf, x86: implement the ibs interrupt handler
Date: Tue, 13 Apr 2010 22:23:21 +0200
Message-ID: <1271190201-25705-13-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <1271190201-25705-1-git-send-email-robert.richter@amd.com>
References: <1271190201-25705-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 13 Apr 2010 20:26:35.0808 (UTC) FILETIME=[9D159A00:01CADB47]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements code to handle ibs interrupts. If ibs data is
available a raw perf_event data sample is created and sent back to the
userland. Currently only the data is stored only in the raw data, but
this could be extended in a later patch by generating generic event
data such as the rip from the ibs sampling data.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/include/asm/msr-index.h     |    3 ++
 arch/x86/kernel/cpu/perf_event_amd.c |   65 +++++++++++++++++++++++++++++++++-
 2 files changed, 67 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index bc473ac..a7e4aa5 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -113,6 +113,7 @@
 #define MSR_AMD64_IBSFETCHCTL		0xc0011030
 #define MSR_AMD64_IBSFETCHLINAD		0xc0011031
 #define MSR_AMD64_IBSFETCHPHYSAD	0xc0011032
+#define MSR_AMD64_IBSFETCH_SIZE		3
 #define MSR_AMD64_IBSOPCTL		0xc0011033
 #define MSR_AMD64_IBSOPRIP		0xc0011034
 #define MSR_AMD64_IBSOPDATA		0xc0011035
@@ -120,7 +121,9 @@
 #define MSR_AMD64_IBSOPDATA3		0xc0011037
 #define MSR_AMD64_IBSDCLINAD		0xc0011038
 #define MSR_AMD64_IBSDCPHYSAD		0xc0011039
+#define MSR_AMD64_IBSOP_SIZE		7
 #define MSR_AMD64_IBSCTL		0xc001103a
+#define MSR_AMD64_IBS_SIZE_MAX		MSR_AMD64_IBSOP_SIZE
 
 /* Fam 10h MSRs */
 #define MSR_FAM10H_MMIO_CONF_BASE	0xc0010058
diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index 3dc327c..78b0b34 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -283,6 +283,69 @@ static inline void __amd_pmu_enable_ibs_event(struct hw_perf_event *hwc)
 		__x86_pmu_enable_event(hwc, IBS_OP_ENABLE);
 }
 
+static int amd_pmu_check_ibs(int idx, unsigned int msr, u64 valid,
+			     u64 reenable, int size, struct pt_regs *iregs)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct perf_event *event = cpuc->events[idx];
+	struct perf_sample_data data;
+	struct perf_raw_record raw;
+	struct pt_regs regs;
+	u64 buffer[MSR_AMD64_IBS_SIZE_MAX];
+	u64 *buf = buffer;
+	int i;
+
+	if (!test_bit(idx, cpuc->active_mask))
+		return 0;
+
+	rdmsrl(msr++, *buf);
+	if (!(*buf++ & valid))
+		return 0;
+
+	perf_sample_data_init(&data, 0);
+	if (event->attr.sample_type & PERF_SAMPLE_RAW) {
+		for (i = 1; i < size; i++)
+			rdmsrl(msr++, *buf++);
+		raw.size = sizeof(u64) * size;
+		raw.data = buffer;
+		data.raw = &raw;
+	}
+
+	regs = *iregs; /* later: update ip from ibs sample */
+
+	if (perf_event_overflow(event, 1, &data, &regs))
+		x86_pmu_stop(event);
+	else
+		__x86_pmu_enable_event(&event->hw, reenable);
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
+	handled2 += amd_pmu_check_ibs(X86_PMC_IDX_SPECIAL_IBS_FETCH,
+				      MSR_AMD64_IBSFETCHCTL, IBS_FETCH_VAL,
+				      IBS_FETCH_ENABLE, MSR_AMD64_IBSFETCH_SIZE,
+				      regs);
+	handled2 += amd_pmu_check_ibs(X86_PMC_IDX_SPECIAL_IBS_OP,
+				      MSR_AMD64_IBSOPCTL, IBS_OP_VAL,
+				      IBS_OP_ENABLE, MSR_AMD64_IBSOP_SIZE,
+				      regs);
+
+	if (handled2)
+		inc_irq_stat(apic_perf_irqs);
+
+	return (handled || handled2);
+}
+
 static void amd_pmu_disable_all(void)
 {
 	x86_pmu_disable_all();
@@ -608,7 +671,7 @@ static void amd_pmu_cpu_dead(int cpu)
 
 static __initconst const struct x86_pmu amd_pmu = {
 	.name			= "AMD",
-	.handle_irq		= x86_pmu_handle_irq,
+	.handle_irq		= amd_pmu_handle_irq,
 	.disable_all		= amd_pmu_disable_all,
 	.enable_all		= amd_pmu_enable_all,
 	.enable			= amd_pmu_enable_event,
-- 
1.7.0.3


