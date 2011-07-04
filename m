Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656Ab1GDH5O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 03:57:14 -0400
Received: from mga01.intel.com ([192.55.52.88]:47700 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755508Ab1GDH4s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 03:56:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,471,1304319600"; 
   d="scan'208";a="23490049"
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/4] perf, x86: Add Intel SandyBridge pricise store support
Date: Mon,  4 Jul 2011 08:02:04 +0000
Message-Id: <1309766525-14089-4-git-send-email-ming.m.lin@intel.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <1309766525-14089-1-git-send-email-ming.m.lin@intel.com>
References: <1309766525-14089-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implements Intel memory store event for SandyBridge.

$ perf mem -t store record make -j8

<building kernel ..., monitoring memory store opeartion>

$ perf mem -t store report

Memory store operation statistics
=================================
                data-cache hit:     8138
               data-cache miss:        0
                      STLB hit:     8138
                     STLB miss:        0
                 Locked access:        0
               Unlocked access:     8138

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c    |    3 +-
 arch/x86/kernel/cpu/perf_event_intel_ds.c |   30 +++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index dde9041..eede1f3 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1523,8 +1523,9 @@ static __init int intel_pmu_init(void)
 		/* UOPS_DISPATCHED.THREAD,c=1,i=1 to count stall cycles*/
 		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_BACKEND] = 0x18001b1;
 
-		/* Memory load latency */
+		/* Memory load latency and precise store*/
 		intel_perfmon_event_map[PERF_COUNT_HW_MEM_LOAD] = 0x01cd;
+		intel_perfmon_event_map[PERF_COUNT_HW_MEM_STORE] = 0x02cd;
 
 		pr_cont("SandyBridge events, ");
 		break;
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index d2d3155..bd7289b 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -23,6 +23,26 @@ static u64 load_latency_data_source[] = {
 
 #define LOAD_LATENCY_DATA_SOURCE_MASK	0x0FULL
 
+#define PRECISE_STORE_DCU_HIT		(1ULL << 0)
+#define PRECISE_STORE_STLB_MISS		(1ULL << 4)
+#define PRECISE_STORE_LOCKED_ACCESS	(1ULL << 5)
+
+static u64 precise_store_data(u64 status)
+{
+	u64 extra = 0;
+
+	if (status & PRECISE_STORE_DCU_HIT)
+		extra |= MEM_STORE_DCU_HIT;
+
+	if (!(status & PRECISE_STORE_STLB_MISS))
+		extra |= MEM_STORE_STLB_HIT;
+
+	if (status & PRECISE_STORE_LOCKED_ACCESS)
+		extra |= MEM_STORE_LOCKED_ACCESS;
+
+	return extra;
+}
+
 /* The maximal number of PEBS events: */
 #define MAX_PEBS_EVENTS		4
 
@@ -637,6 +657,16 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 					LOAD_LATENCY_DATA_SOURCE_MASK];
 	}
 
+	if (event->attr.config == PERF_COUNT_HW_MEM_STORE) {
+		sample_type = event->attr.sample_type;
+
+		if (sample_type & PERF_SAMPLE_ADDR)
+			data.addr = pebs->dla;
+
+		if (sample_type & PERF_SAMPLE_EXTRA)
+			data.extra = precise_store_data(pebs->dse);
+	}
+
 	/*
 	 * We use the interrupt regs as a base because the PEBS record
 	 * does not contain a full regs set, specifically it seems to
-- 
1.7.5.1

