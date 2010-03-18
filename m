Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813Ab0CRRiq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 13:38:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:55049 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753569Ab0CRRin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 13:38:43 -0400
Date: Thu, 18 Mar 2010 17:38:18 GMT
From: tip-bot for Lin Ming <ming.m.lin@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       gorcunov@openvz.org, peterz@infradead.org, ming.m.lin@intel.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       gorcunov@openvz.org, peterz@infradead.org, ming.m.lin@intel.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1268908387.13901.127.camel@minggr.sh.intel.com>
References: <1268908387.13901.127.camel@minggr.sh.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf, x86: Add a key to simplify template lookup in Pentium-4 PMU
Message-ID: <tip-f34edbc1cdb0f8f83d94e1d668dd6e41abf0defb@git.kernel.org>
Git-Commit-ID: f34edbc1cdb0f8f83d94e1d668dd6e41abf0defb
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 18 Mar 2010 17:38:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f34edbc1cdb0f8f83d94e1d668dd6e41abf0defb
Gitweb:     http://git.kernel.org/tip/f34edbc1cdb0f8f83d94e1d668dd6e41abf0defb
Author:     Lin Ming <ming.m.lin@intel.com>
AuthorDate: Thu, 18 Mar 2010 18:33:07 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 18 Mar 2010 17:03:51 +0100

perf, x86: Add a key to simplify template lookup in Pentium-4 PMU

Currently, we use opcode(Event and Event-Selector) + emask to
look up template in p4_templates.

But cache events (L1-dcache-load-misses, LLC-load-misses, etc)
use the same event(P4_REPLAY_EVENT) to do the counting, ie, they
have the same opcode and emask. So we can not use current lookup
mechanism to find the template for cache events.

This patch introduces a "key", which is the index into
p4_templates. The low 12 bits of CCCR are reserved, so we can
hide the "key" in the low 12 bits of hwc->config.

We extract the key from hwc->config and then quickly find the
template.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Reviewed-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <1268908387.13901.127.camel@minggr.sh.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/perf_event_p4.h |    5 ++-
 arch/x86/kernel/cpu/perf_event_p4.c  |   86 +++++++++++++--------------------
 2 files changed, 38 insertions(+), 53 deletions(-)

diff --git a/arch/x86/include/asm/perf_event_p4.h b/arch/x86/include/asm/perf_event_p4.h
index b842b32..7d3406a 100644
--- a/arch/x86/include/asm/perf_event_p4.h
+++ b/arch/x86/include/asm/perf_event_p4.h
@@ -65,6 +65,7 @@
 #define P4_CCCR_THREAD_SINGLE		0x00010000U
 #define P4_CCCR_THREAD_BOTH		0x00020000U
 #define P4_CCCR_THREAD_ANY		0x00030000U
+#define P4_CCCR_RESERVED		0x00000fffU
 
 /* Non HT mask */
 #define P4_CCCR_MASK				\
@@ -116,7 +117,7 @@
 #define p4_config_pack_escr(v)		(((u64)(v)) << 32)
 #define p4_config_pack_cccr(v)		(((u64)(v)) & 0xffffffffULL)
 #define p4_config_unpack_escr(v)	(((u64)(v)) >> 32)
-#define p4_config_unpack_cccr(v)	(((u64)(v)) & 0xffffffffULL)
+#define p4_config_unpack_cccr(v)	(((u64)(v)) & 0xfffff000ULL)
 
 #define p4_config_unpack_emask(v)			\
 	({						\
@@ -126,6 +127,8 @@
 		t;					\
 	})
 
+#define p4_config_unpack_key(v)		(((u64)(v)) & P4_CCCR_RESERVED)
+
 #define P4_CONFIG_HT_SHIFT		63
 #define P4_CONFIG_HT			(1ULL << P4_CONFIG_HT_SHIFT)
 
diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index 0367889..3e97ed3 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -18,6 +18,7 @@ struct p4_event_template {
 	u32 opcode;			/* ESCR event + CCCR selector */
 	u64 config;			/* packed predefined bits */
 	int dep;			/* upstream dependency event index */
+	int key;			/* index into p4_templates */
 	unsigned int emask;		/* ESCR EventMask */
 	unsigned int escr_msr[2];	/* ESCR MSR for this event */
 	unsigned int cntr[2];		/* counter index (offset) */
@@ -39,38 +40,31 @@ static DEFINE_PER_CPU(struct p4_pmu_res, p4_pmu_config);
  */
 struct p4_event_template p4_templates[] = {
 	[0] = {
-		.opcode	= P4_UOP_TYPE,
-		.config	= 0,
-		.dep	= -1,
-		.emask	=
-			P4_EVENT_ATTR(P4_UOP_TYPE, TAGLOADS)	|
-			P4_EVENT_ATTR(P4_UOP_TYPE, TAGSTORES),
-		.escr_msr	= { MSR_P4_RAT_ESCR0, MSR_P4_RAT_ESCR1 },
-		.cntr		= { 16, 17 },
-	},
-	[1] = {
 		.opcode	= P4_GLOBAL_POWER_EVENTS,
 		.config	= 0,
 		.dep	= -1,
+		.key	= 0,
 		.emask	=
 			P4_EVENT_ATTR(P4_GLOBAL_POWER_EVENTS, RUNNING),
 		.escr_msr	= { MSR_P4_FSB_ESCR0, MSR_P4_FSB_ESCR1 },
 		.cntr		= { 0, 2 },
 	},
-	[2] = {
+	[1] = {
 		.opcode	= P4_INSTR_RETIRED,
 		.config	= 0,
 		.dep	= -1, /* needs front-end tagging */
+		.key	= 1,
 		.emask	=
 			P4_EVENT_ATTR(P4_INSTR_RETIRED, NBOGUSNTAG)	|
 			P4_EVENT_ATTR(P4_INSTR_RETIRED, BOGUSNTAG),
 		.escr_msr	= { MSR_P4_CRU_ESCR0, MSR_P4_CRU_ESCR1 },
 		.cntr		= { 12, 14 },
 	},
-	[3] = {
+	[2] = {
 		.opcode	= P4_BSQ_CACHE_REFERENCE,
 		.config	= 0,
 		.dep	= -1,
+		.key	= 2,
 		.emask	=
 			P4_EVENT_ATTR(P4_BSQ_CACHE_REFERENCE, RD_2ndL_HITS)	|
 			P4_EVENT_ATTR(P4_BSQ_CACHE_REFERENCE, RD_2ndL_HITE)	|
@@ -81,10 +75,11 @@ struct p4_event_template p4_templates[] = {
 		.escr_msr	= { MSR_P4_BSU_ESCR0, MSR_P4_BSU_ESCR1 },
 		.cntr		= { 0, 2 },
 	},
-	[4] = {
+	[3] = {
 		.opcode	= P4_BSQ_CACHE_REFERENCE,
 		.config	= 0,
 		.dep	= -1,
+		.key	= 3,
 		.emask	=
 			P4_EVENT_ATTR(P4_BSQ_CACHE_REFERENCE, RD_2ndL_MISS)	|
 			P4_EVENT_ATTR(P4_BSQ_CACHE_REFERENCE, RD_3rdL_MISS)	|
@@ -92,10 +87,11 @@ struct p4_event_template p4_templates[] = {
 		.escr_msr	= { MSR_P4_BSU_ESCR0, MSR_P4_BSU_ESCR1 },
 		.cntr		= { 0, 3 },
 	},
-	[5] = {
+	[4] = {
 		.opcode	= P4_RETIRED_BRANCH_TYPE,
 		.config	= 0,
 		.dep	= -1,
+		.key	= 4,
 		.emask	=
 			P4_EVENT_ATTR(P4_RETIRED_BRANCH_TYPE, CONDITIONAL)	|
 			P4_EVENT_ATTR(P4_RETIRED_BRANCH_TYPE, CALL)		|
@@ -104,48 +100,38 @@ struct p4_event_template p4_templates[] = {
 		.escr_msr	= { MSR_P4_TBPU_ESCR0, MSR_P4_TBPU_ESCR1 },
 		.cntr		= { 4, 6 },
 	},
-	[6] = {
+	[5] = {
 		.opcode	= P4_MISPRED_BRANCH_RETIRED,
 		.config	= 0,
 		.dep	= -1,
+		.key	= 5,
 		.emask	=
 			P4_EVENT_ATTR(P4_MISPRED_BRANCH_RETIRED, NBOGUS),
 		.escr_msr	= { MSR_P4_CRU_ESCR0, MSR_P4_CRU_ESCR1 },
 		.cntr		= { 12, 14 },
 	},
-	[7] = {
+	[6] = {
 		.opcode	= P4_FSB_DATA_ACTIVITY,
 		.config	= p4_config_pack_cccr(P4_CCCR_EDGE | P4_CCCR_COMPARE),
 		.dep	= -1,
+		.key	= 6,
 		.emask	=
 			P4_EVENT_ATTR(P4_FSB_DATA_ACTIVITY, DRDY_DRV)	|
 			P4_EVENT_ATTR(P4_FSB_DATA_ACTIVITY, DRDY_OWN),
 		.escr_msr	= { MSR_P4_FSB_ESCR0, MSR_P4_FSB_ESCR1 },
 		.cntr		= { 0, 2 },
 	},
-};
-
-static struct p4_event_template *p4_event_map[PERF_COUNT_HW_MAX] = {
-	/* non-halted CPU clocks */
-	[PERF_COUNT_HW_CPU_CYCLES]		= &p4_templates[1],
-
-	/* retired instructions: dep on tagging the FSB */
-	[PERF_COUNT_HW_INSTRUCTIONS]		= &p4_templates[2],
-
-	/* cache hits */
-	[PERF_COUNT_HW_CACHE_REFERENCES]	= &p4_templates[3],
-
-	/* cache misses */
-	[PERF_COUNT_HW_CACHE_MISSES]		= &p4_templates[4],
-
-	/* branch instructions retired */
-	[PERF_COUNT_HW_BRANCH_INSTRUCTIONS]	= &p4_templates[5],
-
-	/* mispredicted branches retired */
-	[PERF_COUNT_HW_BRANCH_MISSES]		= &p4_templates[6],
-
-	/* bus ready clocks (cpu is driving #DRDY_DRV\#DRDY_OWN):  */
-	[PERF_COUNT_HW_BUS_CYCLES]		= &p4_templates[7],
+	[7] = {
+		.opcode	= P4_UOP_TYPE,
+		.config	= 0,
+		.dep	= -1,
+		.key	= 7,
+		.emask	=
+			P4_EVENT_ATTR(P4_UOP_TYPE, TAGLOADS)	|
+			P4_EVENT_ATTR(P4_UOP_TYPE, TAGSTORES),
+		.escr_msr	= { MSR_P4_RAT_ESCR0, MSR_P4_RAT_ESCR1 },
+		.cntr		= { 16, 17 },
+	},
 };
 
 static u64 p4_pmu_event_map(int hw_event)
@@ -153,11 +139,11 @@ static u64 p4_pmu_event_map(int hw_event)
 	struct p4_event_template *tpl;
 	u64 config;
 
-	if (hw_event > ARRAY_SIZE(p4_event_map)) {
+	if (hw_event > ARRAY_SIZE(p4_templates)) {
 		printk_once(KERN_ERR "PMU: Incorrect event index\n");
 		return 0;
 	}
-	tpl = p4_event_map[hw_event];
+	tpl = &p4_templates[hw_event];
 
 	/*
 	 * fill config up according to
@@ -167,6 +153,7 @@ static u64 p4_pmu_event_map(int hw_event)
 	config |= p4_config_pack_escr(P4_EVENT_UNPACK_EVENT(tpl->opcode) << P4_EVNTSEL_EVENT_SHIFT);
 	config |= p4_config_pack_escr(tpl->emask << P4_EVNTSEL_EVENTMASK_SHIFT);
 	config |= p4_config_pack_cccr(P4_EVENT_UNPACK_SELECTOR(tpl->opcode) << P4_CCCR_ESCR_SELECT_SHIFT);
+	config |= p4_config_pack_cccr(hw_event & P4_CCCR_RESERVED);
 
 	/* on HT machine we need a special bit */
 	if (p4_ht_active() && p4_ht_thread(raw_smp_processor_id()))
@@ -187,17 +174,12 @@ static inline int p4_pmu_emask_match(unsigned int dst, unsigned int src)
 
 static struct p4_event_template *p4_pmu_template_lookup(u64 config)
 {
-	u32 opcode = p4_config_unpack_opcode(config);
-	unsigned int emask = p4_config_unpack_emask(config);
-	unsigned int i;
-
-	for (i = 0; i < ARRAY_SIZE(p4_templates); i++) {
-		if (opcode == p4_templates[i].opcode &&
-			p4_pmu_emask_match(emask, p4_templates[i].emask))
-			return &p4_templates[i];
-	}
+	int key = p4_config_unpack_key(config);
 
-	return NULL;
+	if (key < ARRAY_SIZE(p4_templates))
+		return &p4_templates[key];
+	else
+		return NULL;
 }
 
 /*
@@ -564,7 +546,7 @@ static __initconst struct x86_pmu p4_pmu = {
 	.perfctr		= MSR_P4_BPU_PERFCTR0,
 	.event_map		= p4_pmu_event_map,
 	.raw_event		= p4_pmu_raw_event,
-	.max_events		= ARRAY_SIZE(p4_event_map),
+	.max_events		= ARRAY_SIZE(p4_templates),
 	.get_event_constraints	= x86_get_event_constraints,
 	/*
 	 * IF HT disabled we may need to use all
