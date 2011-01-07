Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498Ab1AGCfj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 21:35:39 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:13404 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755482Ab1AGCff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 21:35:35 -0500
From: David Daney <ddaney@caviumnetworks.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
        linux-kernel@vger.kernel.org
Cc: David Daney <ddaney@caviumnetworks.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
Subject: [PATCH 6/6] MIPS: perf: Add Octeon support for hardware perf.
Date: Thu,  6 Jan 2011 18:35:07 -0800
Message-Id: <1294367707-2593-7-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1294367707-2593-1-git-send-email-ddaney@caviumnetworks.com>
References: <1294367707-2593-1-git-send-email-ddaney@caviumnetworks.com>
X-OriginalArrivalTime: 07 Jan 2011 02:35:35.0188 (UTC) FILETIME=[8FE3E540:01CBAE13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable hardware counters for Octeon, and add the corresponding event
mappings.

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
---
 arch/mips/Kconfig                    |    2 +-
 arch/mips/kernel/perf_event_mipsxx.c |  147 ++++++++++++++++++++++++++++++++++
 2 files changed, 148 insertions(+), 1 deletions(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 88aaec2..6694f23 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -2016,7 +2016,7 @@ config NODES_SHIFT
 
 config HW_PERF_EVENTS
 	bool "Enable hardware performance counter support for perf events"
-	depends on PERF_EVENTS && !MIPS_MT_SMTC && OPROFILE=n && (CPU_MIPS32 || CPU_MIPS64 || CPU_R10000 || CPU_SB1)
+	depends on PERF_EVENTS && !MIPS_MT_SMTC && OPROFILE=n && (CPU_MIPS32 || CPU_MIPS64 || CPU_R10000 || CPU_SB1 || CPU_CAVIUM_OCTEON)
 	default y
 	help
 	  Enable hardware performance counter support for perf events. If
diff --git a/arch/mips/kernel/perf_event_mipsxx.c b/arch/mips/kernel/perf_event_mipsxx.c
index 9bdac86..527b1b9 100644
--- a/arch/mips/kernel/perf_event_mipsxx.c
+++ b/arch/mips/kernel/perf_event_mipsxx.c
@@ -850,6 +850,16 @@ static const struct mips_perf_event mipsxx74Kcore_event_map
 	[PERF_COUNT_HW_BUS_CYCLES] = { UNSUPPORTED_PERF_EVENT_ID },
 };
 
+static const struct mips_perf_event octeon_event_map[PERF_COUNT_HW_MAX] = {
+	[PERF_COUNT_HW_CPU_CYCLES] = { 0x01, CNTR_ALL },
+	[PERF_COUNT_HW_INSTRUCTIONS] = { 0x03, CNTR_ALL },
+	[PERF_COUNT_HW_CACHE_REFERENCES] = { 0x2b, CNTR_ALL },
+	[PERF_COUNT_HW_CACHE_MISSES] = { 0x2e, CNTR_ALL  },
+	[PERF_COUNT_HW_BRANCH_INSTRUCTIONS] = { 0x08, CNTR_ALL },
+	[PERF_COUNT_HW_BRANCH_MISSES] = { 0x09, CNTR_ALL },
+	[PERF_COUNT_HW_BUS_CYCLES] = { 0x25, CNTR_ALL },
+};
+
 /* 24K/34K/1004K cores can share the same cache event map. */
 static const struct mips_perf_event mipsxxcore_cache_map
 				[PERF_COUNT_HW_CACHE_MAX]
@@ -1055,6 +1065,102 @@ static const struct mips_perf_event mipsxx74Kcore_cache_map
 },
 };
 
+
+static const struct mips_perf_event octeon_cache_map
+				[PERF_COUNT_HW_CACHE_MAX]
+				[PERF_COUNT_HW_CACHE_OP_MAX]
+				[PERF_COUNT_HW_CACHE_RESULT_MAX] = {
+[C(L1D)] = {
+	[C(OP_READ)] = {
+		[C(RESULT_ACCESS)]	= { 0x2b, CNTR_ALL },
+		[C(RESULT_MISS)]	= { 0x2e, CNTR_ALL },
+	},
+	[C(OP_WRITE)] = {
+		[C(RESULT_ACCESS)]	= { 0x30, CNTR_ALL },
+		[C(RESULT_MISS)]	= { UNSUPPORTED_PERF_EVENT_ID },
+	},
+	[C(OP_PREFETCH)] = {
+		[C(RESULT_ACCESS)]	= { UNSUPPORTED_PERF_EVENT_ID },
+		[C(RESULT_MISS)]	= { UNSUPPORTED_PERF_EVENT_ID },
+	},
+},
+[C(L1I)] = {
+	[C(OP_READ)] = {
+		[C(RESULT_ACCESS)]	= { 0x18, CNTR_ALL },
+		[C(RESULT_MISS)]	= { UNSUPPORTED_PERF_EVENT_ID },
+	},
+	[C(OP_WRITE)] = {
+		[C(RESULT_ACCESS)]	= { UNSUPPORTED_PERF_EVENT_ID },
+		[C(RESULT_MISS)]	= { UNSUPPORTED_PERF_EVENT_ID },
+	},
+	[C(OP_PREFETCH)] = {
+		[C(RESULT_ACCESS)]	= { 0x19, CNTR_ALL },
+		[C(RESULT_MISS)]	= { UNSUPPORTED_PERF_EVENT_ID },
+	},
+},
+[C(LL)] = {
+	[C(OP_READ)] = {
+		[C(RESULT_ACCESS)]	= { UNSUPPORTED_PERF_EVENT_ID },
+		[C(RESULT_MISS)]	= { UNSUPPORTED_PERF_EVENT_ID },
+	},
+	[C(OP_WRITE)] = {
+		[C(RESULT_ACCESS)]	= { UNSUPPORTED_PERF_EVENT_ID },
+		[C(RESULT_MISS)]	= { UNSUPPORTED_PERF_EVENT_ID },
+	},
+	[C(OP_PREFETCH)] = {
+		[C(RESULT_ACCESS)]	= { UNSUPPORTED_PERF_EVENT_ID },
+		[C(RESULT_MISS)]	= { UNSUPPORTED_PERF_EVENT_ID },
+	},
+},
+[C(DTLB)] = {
+	/*
+	 * Only general DTLB misses are counted use the same event for
+	 * read and write.
+	 */
+	[C(OP_READ)] = {
+		[C(RESULT_ACCESS)]	= { UNSUPPORTED_PERF_EVENT_ID },
+		[C(RESULT_MISS)]	= { 0x35, CNTR_ALL },
+	},
+	[C(OP_WRITE)] = {
+		[C(RESULT_ACCESS)]	= { UNSUPPORTED_PERF_EVENT_ID },
+		[C(RESULT_MISS)]	= { 0x35, CNTR_ALL },
+	},
+	[C(OP_PREFETCH)] = {
+		[C(RESULT_ACCESS)]	= { UNSUPPORTED_PERF_EVENT_ID },
+		[C(RESULT_MISS)]	= { UNSUPPORTED_PERF_EVENT_ID },
+	},
+},
+[C(ITLB)] = {
+	[C(OP_READ)] = {
+		[C(RESULT_ACCESS)]	= { UNSUPPORTED_PERF_EVENT_ID },
+		[C(RESULT_MISS)]	= { 0x37, CNTR_ALL },
+	},
+	[C(OP_WRITE)] = {
+		[C(RESULT_ACCESS)]	= { UNSUPPORTED_PERF_EVENT_ID },
+		[C(RESULT_MISS)]	= { UNSUPPORTED_PERF_EVENT_ID },
+	},
+	[C(OP_PREFETCH)] = {
+		[C(RESULT_ACCESS)]	= { UNSUPPORTED_PERF_EVENT_ID },
+		[C(RESULT_MISS)]	= { UNSUPPORTED_PERF_EVENT_ID },
+	},
+},
+[C(BPU)] = {
+	/* Using the same code for *HW_BRANCH* */
+	[C(OP_READ)] = {
+		[C(RESULT_ACCESS)]	= { UNSUPPORTED_PERF_EVENT_ID },
+		[C(RESULT_MISS)]	= { UNSUPPORTED_PERF_EVENT_ID },
+	},
+	[C(OP_WRITE)] = {
+		[C(RESULT_ACCESS)]	= { UNSUPPORTED_PERF_EVENT_ID },
+		[C(RESULT_MISS)]	= { UNSUPPORTED_PERF_EVENT_ID },
+	},
+	[C(OP_PREFETCH)] = {
+		[C(RESULT_ACCESS)]	= { UNSUPPORTED_PERF_EVENT_ID },
+		[C(RESULT_MISS)]	= { UNSUPPORTED_PERF_EVENT_ID },
+	},
+},
+};
+
 #ifdef CONFIG_MIPS_MT_SMP
 static void check_and_calc_range(struct perf_event *event,
 				 const struct mips_perf_event *pev)
@@ -1397,6 +1503,39 @@ static const struct mips_perf_event *mipsxx_pmu_map_raw_event(u64 config)
 	return &raw_event;
 }
 
+static const struct mips_perf_event *octeon_pmu_map_raw_event(u64 config)
+{
+	unsigned int raw_id = config & 0xff;
+	unsigned int base_id = raw_id & 0x7f;
+
+
+	raw_event.cntr_mask = CNTR_ALL;
+	raw_event.event_id = base_id;
+
+	if (current_cpu_type() == CPU_CAVIUM_OCTEON2) {
+		if (base_id > 0x42)
+			return ERR_PTR(-EOPNOTSUPP);
+	} else {
+		if (base_id > 0x3a)
+			return ERR_PTR(-EOPNOTSUPP);
+	}
+
+	switch (base_id) {
+	case 0x00:
+	case 0x0f:
+	case 0x1e:
+	case 0x1f:
+	case 0x2f:
+	case 0x34:
+	case 0x3b ... 0x3f:
+		return ERR_PTR(-EOPNOTSUPP);
+	default:
+		break;
+	}
+
+	return &raw_event;
+}
+
 static int __init
 init_hw_perf_events(void)
 {
@@ -1456,6 +1595,14 @@ init_hw_perf_events(void)
 		mipspmu.general_event_map = &mipsxxcore_event_map;
 		mipspmu.cache_event_map = &mipsxxcore_cache_map;
 		break;
+	case CPU_CAVIUM_OCTEON:
+	case CPU_CAVIUM_OCTEON_PLUS:
+	case CPU_CAVIUM_OCTEON2:
+		mipspmu.name = "octeon";
+		mipspmu.general_event_map = &octeon_event_map;
+		mipspmu.cache_event_map = &octeon_cache_map;
+		mipspmu.map_raw_event = octeon_pmu_map_raw_event;
+		break;
 	default:
 		pr_cont("Either hardware does not support performance "
 			"counters, or not yet implemented.\n");
-- 
1.7.2.3

