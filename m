Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751852Ab2KJBCV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 20:02:21 -0500
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:14449
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751376Ab2KJBCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 20:02:05 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1de0h1202h1d1ah1d2ahzz8275bhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14ddh1504h1537h1155h)
X-WSS-ID: 0MD8YV5-01-03O-02
X-M-MSG: 
From: Jacob Shin <jacob.shin@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Stephane Eranian <eranian@google.com>,
        Robert Richter <rric@kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, Jacob Shin <jacob.shin@amd.com>
Subject: [PATCH 3/4] perf, x86: Move MSR address offset calculation to architecture specific files
Date: Fri, 9 Nov 2012 19:01:37 -0600
Message-ID: <1352509298-7319-4-git-send-email-jacob.shin@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352509298-7319-1-git-send-email-jacob.shin@amd.com>
References: <1352509298-7319-1-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move counter index to MSR address offset calculation to architecture
specific files. This prepares the way for perf_event_amd to enable
counter addresses that are not contiguous -- for example AMD Family
15h processors have 6 core performance counters starting at 0xc0010200
and 4 northbridge performance counters starting at 0xc0010240.

Signed-off-by: Jacob Shin <jacob.shin@amd.com>
---
 arch/x86/kernel/cpu/perf_event.h     |   21 +++++---------------
 arch/x86/kernel/cpu/perf_event_amd.c |   36 ++++++++++++++++++++++++++++++++++
 2 files changed, 41 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 271d257..aacf025 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -325,6 +325,7 @@ struct x86_pmu {
 	int		(*schedule_events)(struct cpu_hw_events *cpuc, int n, int *assign);
 	unsigned	eventsel;
 	unsigned	perfctr;
+	int             (*addr_offset)(int index);
 	u64		(*event_map)(int);
 	int		max_events;
 	int		num_counters;
@@ -444,28 +445,16 @@ extern u64 __read_mostly hw_cache_extra_regs
 
 u64 x86_perf_event_update(struct perf_event *event);
 
-static inline int x86_pmu_addr_offset(int index)
-{
-	int offset;
-
-	/* offset = X86_FEATURE_PERFCTR_CORE ? index << 1 : index */
-	alternative_io(ASM_NOP2,
-		       "shll $1, %%eax",
-		       X86_FEATURE_PERFCTR_CORE,
-		       "=a" (offset),
-		       "a"  (index));
-
-	return offset;
-}
-
 static inline unsigned int x86_pmu_config_addr(int index)
 {
-	return x86_pmu.eventsel + x86_pmu_addr_offset(index);
+	return x86_pmu.eventsel +
+		(x86_pmu.addr_offset ? x86_pmu.addr_offset(index) : index);
 }
 
 static inline unsigned int x86_pmu_event_addr(int index)
 {
-	return x86_pmu.perfctr + x86_pmu_addr_offset(index);
+	return x86_pmu.perfctr +
+		(x86_pmu.addr_offset ? x86_pmu.addr_offset(index) : index);
 }
 
 int x86_setup_perfctr(struct perf_event *event);
diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index d17debd..078beb5 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -132,6 +132,41 @@ static u64 amd_pmu_event_map(int hw_event)
 	return amd_perfmon_event_map[hw_event];
 }
 
+/*
+ * Previously calculated offsets
+ */
+static unsigned int addr_offsets[X86_PMC_IDX_MAX] __read_mostly;
+
+/*
+ * Legacy CPUs:
+ *   4 counters starting at 0xc0010000 each offset by 1
+ *
+ * CPUs with core performance counter extensions:
+ *   6 counters starting at 0xc0010200 each offset by 2
+ */
+static inline int amd_pmu_addr_offset(int index)
+{
+	int offset;
+
+	if (!index)
+		return index;
+
+	offset = addr_offsets[index];
+
+	if (offset)
+		return offset;
+
+	if (!cpu_has_perfctr_core) {
+		offset = index;
+	} else {
+		offset = index << 1;
+	}
+
+	addr_offsets[index] = offset;
+
+	return offset;
+}
+
 static int amd_pmu_hw_config(struct perf_event *event)
 {
 	int ret;
@@ -570,6 +605,7 @@ static __initconst const struct x86_pmu amd_pmu = {
 	.schedule_events	= x86_schedule_events,
 	.eventsel		= MSR_K7_EVNTSEL0,
 	.perfctr		= MSR_K7_PERFCTR0,
+	.addr_offset            = amd_pmu_addr_offset,
 	.event_map		= amd_pmu_event_map,
 	.max_events		= ARRAY_SIZE(amd_perfmon_event_map),
 	.num_counters		= AMD64_NUM_COUNTERS,
-- 
1.7.9.5


