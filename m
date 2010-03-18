Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723Ab0CRKuU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 06:50:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:28254 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752443Ab0CRKuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 06:50:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,265,1267430400"; 
   d="scan'208";a="501629002"
Subject: [RFC][PATCH 2/2] x86,perf: add cache events in p4 PMU
From: Lin Ming <ming.m.lin@intel.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 18 Mar 2010 18:33:12 +0800
Message-Id: <1268908392.13901.128.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add cache events in p4 PMU.

Move the HT bit setting code from p4_pmu_event_map to p4_hw_config.
So the cache events can get HT bit set correctly.

Tested on my P4 desktop, below 6 cache events work.
L1-dcache-load-misses
LLC-load-misses
dTLB-load-misses
dTLB-store-misses
iTLB-loads
iTLB-load-misses

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 arch/x86/include/asm/msr-index.h     |    2 +
 arch/x86/include/asm/perf_event_p4.h |   10 ++
 arch/x86/kernel/cpu/perf_event_p4.c  |  153 ++++++++++++++++++++++++++++++++--
 3 files changed, 159 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 1cd58cd..aef562c 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -357,6 +357,8 @@
 #define MSR_P4_U2L_ESCR0		0x000003b0
 #define MSR_P4_U2L_ESCR1		0x000003b1
 
+#define MSR_P4_PEBS_MATRIX_VERT		0x000003f2
+
 /* Intel Core-based CPU performance counters */
 #define MSR_CORE_PERF_FIXED_CTR0	0x00000309
 #define MSR_CORE_PERF_FIXED_CTR1	0x0000030a
diff --git a/arch/x86/include/asm/perf_event_p4.h b/arch/x86/include/asm/perf_event_p4.h
index 7d3406a..871249c 100644
--- a/arch/x86/include/asm/perf_event_p4.h
+++ b/arch/x86/include/asm/perf_event_p4.h
@@ -708,4 +708,14 @@ enum P4_EVENTS_ATTR {
 	P4_MAKE_EVENT_ATTR(P4_INSTR_COMPLETED, BOGUS, 1),
 };
 
+enum {
+	KEY_P4_L1D_OP_READ_RESULT_MISS,
+	KEY_P4_LL_OP_READ_RESULT_MISS,
+	KEY_P4_DTLB_OP_READ_RESULT_MISS,
+	KEY_P4_DTLB_OP_WRITE_RESULT_MISS,
+	KEY_P4_ITLB_OP_READ_RESULT_ACCESS,
+	KEY_P4_ITLB_OP_READ_RESULT_MISS,
+	KEY_P4_UOP_TYPE,
+};
+
 #endif /* PERF_EVENT_P4_H */
diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index e088010..4513d2b 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -19,6 +19,11 @@ struct p4_event_template {
 	u64 config;			/* packed predefined bits */
 	int dep;			/* upstream dependency event index */
 	int key;			/* index into p4_templates */
+	u64 msr;			/*
+					 * the high 32 bits set into MSR_IA32_PEBS_ENABLE and
+					 * the low 32 bits set into MSR_P4_PEBS_MATRIX_VERT
+					 * for cache events
+					 */
 	unsigned int emask;		/* ESCR EventMask */
 	unsigned int escr_msr[2];	/* ESCR MSR for this event */
 	unsigned int cntr[2];		/* counter index (offset) */
@@ -31,6 +36,67 @@ struct p4_pmu_res {
 
 static DEFINE_PER_CPU(struct p4_pmu_res, p4_pmu_config);
 
+#define P4_CACHE_EVENT_CONFIG(event, bit) \
+	p4_config_pack_escr(P4_EVENT_UNPACK_EVENT(event) << P4_EVNTSEL_EVENT_SHIFT) | \
+	p4_config_pack_escr((event##_##bit) << P4_EVNTSEL_EVENTMASK_SHIFT) | \
+	p4_config_pack_cccr(P4_EVENT_UNPACK_SELECTOR(event) << P4_CCCR_ESCR_SELECT_SHIFT)
+
+static __initconst u64 p4_hw_cache_event_ids
+				[PERF_COUNT_HW_CACHE_MAX]
+				[PERF_COUNT_HW_CACHE_OP_MAX]
+				[PERF_COUNT_HW_CACHE_RESULT_MAX] =
+{
+ [ C(L1D ) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0x0,
+					/* 1stL_cache_load_miss_retired */
+		[ C(RESULT_MISS)   ] = P4_CACHE_EVENT_CONFIG(P4_REPLAY_EVENT, NBOGUS)
+					| KEY_P4_L1D_OP_READ_RESULT_MISS,
+	},
+ },
+ [ C(LL  ) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0x0,
+					/* 2ndL_cache_load_miss_retired */
+		[ C(RESULT_MISS)   ] = P4_CACHE_EVENT_CONFIG(P4_REPLAY_EVENT, NBOGUS)
+					| KEY_P4_LL_OP_READ_RESULT_MISS,
+	},
+ },
+ [ C(DTLB) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0x0,
+					/* DTLB_load_miss_retired */
+		[ C(RESULT_MISS)   ] = P4_CACHE_EVENT_CONFIG(P4_REPLAY_EVENT, NBOGUS)
+					| KEY_P4_DTLB_OP_READ_RESULT_MISS,
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = 0x0,
+					/* DTLB_store_miss_retired */
+		[ C(RESULT_MISS)   ] = P4_CACHE_EVENT_CONFIG(P4_REPLAY_EVENT, NBOGUS)
+					| KEY_P4_DTLB_OP_WRITE_RESULT_MISS,
+	},
+ },
+ [ C(ITLB) ] = {
+	[ C(OP_READ) ] = {
+					/* ITLB_reference.HIT */
+		[ C(RESULT_ACCESS) ] = P4_CACHE_EVENT_CONFIG(P4_ITLB_REFERENCE, HIT)
+					| KEY_P4_ITLB_OP_READ_RESULT_ACCESS,
+
+					/* ITLB_reference.MISS */
+		[ C(RESULT_MISS)   ] = P4_CACHE_EVENT_CONFIG(P4_ITLB_REFERENCE, MISS)
+					| KEY_P4_ITLB_OP_READ_RESULT_MISS,
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = -1,
+		[ C(RESULT_MISS)   ] = -1,
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = -1,
+		[ C(RESULT_MISS)   ] = -1,
+	},
+ },
+};
+
 /*
  * WARN: CCCR1 doesn't have a working enable bit so try to not
  * use it if possible
@@ -121,11 +187,77 @@ struct p4_event_template p4_templates[] = {
 		.escr_msr	= { MSR_P4_FSB_ESCR0, MSR_P4_FSB_ESCR1 },
 		.cntr		= { 0, 2 },
 	},
-	[7] = {
+	[KEY_P4_L1D_OP_READ_RESULT_MISS] = {
+		.opcode	= P4_REPLAY_EVENT,
+		.config	= 0,
+		.dep	= -1,
+		.msr	= (u64)(1 << 0 | 1 << 24) << 32 | (1 << 0),
+		.key	= KEY_P4_L1D_OP_READ_RESULT_MISS,
+		.emask	=
+			P4_EVENT_ATTR(P4_REPLAY_EVENT, NBOGUS),
+		.escr_msr	= { MSR_P4_CRU_ESCR2, MSR_P4_CRU_ESCR2 },
+		.cntr		= { 16, 17 },
+	},
+	[KEY_P4_LL_OP_READ_RESULT_MISS] = {
+		.opcode	= P4_REPLAY_EVENT,
+		.config	= 0,
+		.dep	= -1,
+		.msr	= (u64)(1 << 1 | 1 << 24) << 32 | (1 << 0),
+		.key	= KEY_P4_LL_OP_READ_RESULT_MISS,
+		.emask	=
+			P4_EVENT_ATTR(P4_REPLAY_EVENT, NBOGUS),
+		.escr_msr	= { MSR_P4_CRU_ESCR2, MSR_P4_CRU_ESCR2 },
+		.cntr		= { 16, 17 },
+	},
+	[KEY_P4_DTLB_OP_READ_RESULT_MISS] = {
+		.opcode	= P4_REPLAY_EVENT,
+		.config	= 0,
+		.dep	= -1,
+		.msr	= (u64)(1 << 2 | 1 << 24) << 32 | (1 << 0),
+		.key	= KEY_P4_DTLB_OP_READ_RESULT_MISS,
+		.emask	=
+			P4_EVENT_ATTR(P4_REPLAY_EVENT, NBOGUS),
+		.escr_msr	= { MSR_P4_CRU_ESCR2, MSR_P4_CRU_ESCR2 },
+		.cntr		= { 16, 17 },
+	},
+	[KEY_P4_DTLB_OP_WRITE_RESULT_MISS] = {
+		.opcode	= P4_REPLAY_EVENT,
+		.config	= 0,
+		.dep	= -1,
+		.msr	= (u64)(1 << 2 | 1 << 24) << 32 | (1 << 1),
+		.key	= KEY_P4_DTLB_OP_WRITE_RESULT_MISS,
+		.emask	=
+			P4_EVENT_ATTR(P4_REPLAY_EVENT, NBOGUS),
+		.escr_msr	= { MSR_P4_CRU_ESCR2, MSR_P4_CRU_ESCR2 },
+		.cntr		= { 16, 17 },
+	},
+	[KEY_P4_ITLB_OP_READ_RESULT_ACCESS] = {
+		.opcode	= P4_ITLB_REFERENCE,
+		.config	= 0,
+		.dep	= -1,
+		.msr	= 0,
+		.key	= KEY_P4_ITLB_OP_READ_RESULT_ACCESS,
+		.emask	=
+			P4_EVENT_ATTR(P4_ITLB_REFERENCE, HIT),
+		.escr_msr	= { MSR_P4_ITLB_ESCR0, MSR_P4_ITLB_ESCR1 },
+		.cntr		= { 0, 2 },
+	},
+	[KEY_P4_ITLB_OP_READ_RESULT_MISS] = {
+		.opcode	= P4_ITLB_REFERENCE,
+		.config	= 0,
+		.dep	= -1,
+		.msr	= 0,
+		.key	= KEY_P4_ITLB_OP_READ_RESULT_MISS,
+		.emask	=
+			P4_EVENT_ATTR(P4_ITLB_REFERENCE, MISS),
+		.escr_msr	= { MSR_P4_ITLB_ESCR0, MSR_P4_ITLB_ESCR1 },
+		.cntr		= { 0, 2 },
+	},
+	[KEY_P4_UOP_TYPE] = {
 		.opcode	= P4_UOP_TYPE,
 		.config	= 0,
 		.dep	= -1,
-		.key	= 7,
+		.key	= KEY_P4_UOP_TYPE,
 		.emask	=
 			P4_EVENT_ATTR(P4_UOP_TYPE, TAGLOADS)	|
 			P4_EVENT_ATTR(P4_UOP_TYPE, TAGSTORES),
@@ -155,10 +287,6 @@ static u64 p4_pmu_event_map(int hw_event)
 	config |= p4_config_pack_cccr(P4_EVENT_UNPACK_SELECTOR(tpl->opcode) << P4_CCCR_ESCR_SELECT_SHIFT);
 	config |= p4_config_pack_cccr(hw_event & P4_CCCR_RESERVED);
 
-	/* on HT machine we need a special bit */
-	if (p4_ht_active() && p4_ht_thread(raw_smp_processor_id()))
-		config = p4_set_ht_bit(config);
-
 	return config;
 }
 
@@ -211,6 +339,10 @@ static int p4_hw_config(struct perf_event_attr *attr, struct hw_perf_event *hwc)
 	/* Count user and OS events unless not requested to */
 	hwc->config |= p4_config_pack_escr(p4_default_escr_conf(cpu, attr->exclude_kernel,
 								attr->exclude_user));
+	/* on HT machine we need a special bit */
+	if (p4_ht_active() && p4_ht_thread(cpu))
+		hwc->config = p4_set_ht_bit(hwc->config);
+
 	return 0;
 }
 
@@ -271,6 +403,12 @@ static void p4_pmu_enable_event(struct perf_event *event)
 		pr_crit("%s: Wrong index: %d\n", __func__, hwc->idx);
 		return;
 	}
+
+	if (tpl->msr) {
+		(void)checking_wrmsrl(MSR_IA32_PEBS_ENABLE, tpl->msr >> 32);
+		(void)checking_wrmsrl(MSR_P4_PEBS_MATRIX_VERT, tpl->msr & 0xffffffff);
+	}
+
 	escr_base = (u64)tpl->escr_msr[thread];
 
 	/*
@@ -579,6 +717,9 @@ static __init int p4_pmu_init(void)
 		return -ENODEV;
 	}
 
+	memcpy(hw_cache_event_ids, p4_hw_cache_event_ids,
+	       sizeof(hw_cache_event_ids));
+
 	pr_cont("Netburst events, ");
 
 	x86_pmu = p4_pmu;


