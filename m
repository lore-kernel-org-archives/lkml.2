Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226Ab0IAJT3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 05:19:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:42703 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751870Ab0IAJT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 05:19:27 -0400
Date: Wed, 1 Sep 2010 09:18:48 GMT
From: tip-bot for Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        gorcunov@openvz.org, peterz@infradead.org, fweisbec@gmail.com,
        ming.m.lin@intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, gorcunov@openvz.org, peterz@infradead.org,
        ming.m.lin@intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100825182334.GB14874@lenovo>
References: <20100825182334.GB14874@lenovo>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf, x86, Pentium4: Add RAW events verification
Message-ID: <tip-c9cf4a019cff198ee5638323e3b0ee18886467e8@git.kernel.org>
Git-Commit-ID: c9cf4a019cff198ee5638323e3b0ee18886467e8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 01 Sep 2010 09:18:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c9cf4a019cff198ee5638323e3b0ee18886467e8
Gitweb:     http://git.kernel.org/tip/c9cf4a019cff198ee5638323e3b0ee18886467e8
Author:     Cyrill Gorcunov <gorcunov@openvz.org>
AuthorDate: Wed, 25 Aug 2010 22:23:34 +0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 1 Sep 2010 08:26:56 +0200

perf, x86, Pentium4: Add RAW events verification

Implements verification of

- Bits of ESCR EventMask field (meaningful bits in field are hardware
  predefined and others bits should be set to zero)

- INSTR_COMPLETED event (it is available on predefined cpu model only)

- Thread shared events (they should be guarded by "perf_event_paranoid"
  sysctl due to security reason). The side effect of this action is
  that PERF_COUNT_HW_BUS_CYCLES become a "paranoid" general event.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Tested-by: Lin Ming <ming.m.lin@intel.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20100825182334.GB14874@lenovo>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/perf_event_p4.h |   52 +++----
 arch/x86/kernel/cpu/perf_event_p4.c  |  292 +++++++++++++++++++++++++++++++---
 2 files changed, 290 insertions(+), 54 deletions(-)

diff --git a/arch/x86/include/asm/perf_event_p4.h b/arch/x86/include/asm/perf_event_p4.h
index def5007..a70cd21 100644
--- a/arch/x86/include/asm/perf_event_p4.h
+++ b/arch/x86/include/asm/perf_event_p4.h
@@ -36,19 +36,6 @@
 #define P4_ESCR_EMASK(v)	((v) << P4_ESCR_EVENTMASK_SHIFT)
 #define P4_ESCR_TAG(v)		((v) << P4_ESCR_TAG_SHIFT)
 
-/* Non HT mask */
-#define P4_ESCR_MASK			\
-	(P4_ESCR_EVENT_MASK	|	\
-	P4_ESCR_EVENTMASK_MASK	|	\
-	P4_ESCR_TAG_MASK	|	\
-	P4_ESCR_TAG_ENABLE	|	\
-	P4_ESCR_T0_OS		|	\
-	P4_ESCR_T0_USR)
-
-/* HT mask */
-#define P4_ESCR_MASK_HT			\
-	(P4_ESCR_MASK |	P4_ESCR_T1_OS | P4_ESCR_T1_USR)
-
 #define P4_CCCR_OVF			0x80000000U
 #define P4_CCCR_CASCADE			0x40000000U
 #define P4_CCCR_OVF_PMI_T0		0x04000000U
@@ -70,23 +57,6 @@
 #define P4_CCCR_THRESHOLD(v)		((v) << P4_CCCR_THRESHOLD_SHIFT)
 #define P4_CCCR_ESEL(v)			((v) << P4_CCCR_ESCR_SELECT_SHIFT)
 
-/* Non HT mask */
-#define P4_CCCR_MASK				\
-	(P4_CCCR_OVF			|	\
-	P4_CCCR_CASCADE			|	\
-	P4_CCCR_OVF_PMI_T0		|	\
-	P4_CCCR_FORCE_OVF		|	\
-	P4_CCCR_EDGE			|	\
-	P4_CCCR_THRESHOLD_MASK		|	\
-	P4_CCCR_COMPLEMENT		|	\
-	P4_CCCR_COMPARE			|	\
-	P4_CCCR_ESCR_SELECT_MASK	|	\
-	P4_CCCR_ENABLE)
-
-/* HT mask */
-#define P4_CCCR_MASK_HT				\
-	(P4_CCCR_MASK | P4_CCCR_OVF_PMI_T1 | P4_CCCR_THREAD_ANY)
-
 #define P4_GEN_ESCR_EMASK(class, name, bit)	\
 	class##__##name = ((1 << bit) << P4_ESCR_EVENTMASK_SHIFT)
 #define P4_ESCR_EMASK_BIT(class, name)		class##__##name
@@ -127,6 +97,28 @@
 #define P4_CONFIG_HT_SHIFT		63
 #define P4_CONFIG_HT			(1ULL << P4_CONFIG_HT_SHIFT)
 
+/*
+ * The bits we allow to pass for RAW events
+ */
+#define P4_CONFIG_MASK_ESCR		\
+	P4_ESCR_EVENT_MASK	|	\
+	P4_ESCR_EVENTMASK_MASK	|	\
+	P4_ESCR_TAG_MASK	|	\
+	P4_ESCR_TAG_ENABLE
+
+#define P4_CONFIG_MASK_CCCR		\
+	P4_CCCR_EDGE		|	\
+	P4_CCCR_THRESHOLD_MASK	|	\
+	P4_CCCR_COMPLEMENT	|	\
+	P4_CCCR_COMPARE		|	\
+	P4_CCCR_THREAD_ANY	|	\
+	P4_CCCR_RESERVED
+
+/* some dangerous bits are reserved for kernel internals */
+#define P4_CONFIG_MASK				  	  \
+	(p4_config_pack_escr(P4_CONFIG_MASK_ESCR))	| \
+	(p4_config_pack_cccr(P4_CONFIG_MASK_CCCR))
+
 static inline bool p4_is_event_cascaded(u64 config)
 {
 	u32 cccr = p4_config_unpack_cccr(config);
diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index 7e578e9..4fe62c7 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -18,6 +18,8 @@
 struct p4_event_bind {
 	unsigned int opcode;			/* Event code and ESCR selector */
 	unsigned int escr_msr[2];		/* ESCR MSR for this event */
+	unsigned int escr_emask;		/* valid ESCR EventMask bits */
+	unsigned int shared;			/* event is shared across threads */
 	char cntr[2][P4_CNTR_LIMIT];		/* counter index (offset), -1 on abscence */
 };
 
@@ -66,231 +68,435 @@ static struct p4_event_bind p4_event_bind_map[] = {
 	[P4_EVENT_TC_DELIVER_MODE] = {
 		.opcode		= P4_OPCODE(P4_EVENT_TC_DELIVER_MODE),
 		.escr_msr	= { MSR_P4_TC_ESCR0, MSR_P4_TC_ESCR1 },
+		.escr_emask	=
+			P4_ESCR_EMASK_BIT(P4_EVENT_TC_DELIVER_MODE, DD)			|
+			P4_ESCR_EMASK_BIT(P4_EVENT_TC_DELIVER_MODE, DB)			|
+			P4_ESCR_EMASK_BIT(P4_EVENT_TC_DELIVER_MODE, DI)			|
+			P4_ESCR_EMASK_BIT(P4_EVENT_TC_DELIVER_MODE, BD)			|
+			P4_ESCR_EMASK_BIT(P4_EVENT_TC_DELIVER_MODE, BB)			|
+			P4_ESCR_EMASK_BIT(P4_EVENT_TC_DELIVER_MODE, BI)			|
+			P4_ESCR_EMASK_BIT(P4_EVENT_TC_DELIVER_MODE, ID),
+		.shared		= 1,
 		.cntr		= { {4, 5, -1}, {6, 7, -1} },
 	},
 	[P4_EVENT_BPU_FETCH_REQUEST] = {
 		.opcode		= P4_OPCODE(P4_EVENT_BPU_FETCH_REQUEST),
 		.escr_msr	= { MSR_P4_BPU_ESCR0, MSR_P4_BPU_ESCR1 },
+		.escr_emask	=
+			P4_ESCR_EMASK_BIT(P4_EVENT_BPU_FETCH_REQUEST, TCMISS),
 		.cntr		= { {0, -1, -1}, {2, -1, -1} },
 	},
 	[P4_EVENT_ITLB_REFERENCE] = {
 		.opcode		= P4_OPCODE(P4_EVENT_ITLB_REFERENCE),
 		.escr_msr	= { MSR_P4_ITLB_ESCR0, MSR_P4_ITLB_ESCR1 },
+		.escr_emask	=
+			P4_ESCR_EMASK_BIT(P4_EVENT_ITLB_REFERENCE, HIT)			|
+			P4_ESCR_EMASK_BIT(P4_EVENT_ITLB_REFERENCE, MISS)		|
+			P4_ESCR_EMASK_BIT(P4_EVENT_ITLB_REFERENCE, HIT_UK),
 		.cntr		= { {0, -1, -1}, {2, -1, -1} },
 	},
 	[P4_EVENT_MEMORY_CANCEL] = {
 		.opcode		= P4_OPCODE(P4_EVENT_MEMORY_CANCEL),
 		.escr_msr	= { MSR_P4_DAC_ESCR0, MSR_P4_DAC_ESCR1 },
+		.escr_emask	=
+			P4_ESCR_EMASK_BIT(P4_EVENT_MEMORY_CANCEL, ST_RB_FULL)		|
+			P4_ESCR_EMASK_BIT(P4_EVENT_MEMORY_CANCEL, 64K_CONF),
 		.cntr		= { {8, 9, -1}, {10, 11, -1} },
 	},
 	[P4_EVENT_MEMORY_COMPLETE] = {
 		.opcode		= P4_OPCODE(P4_EVENT_MEMORY_COMPLETE),
 		.escr_msr	= { MSR_P4_SAAT_ESCR0 , MSR_P4_SAAT_ESCR1 },
+		.escr_emask	=
+			P4_ESCR_EMASK_BIT(P4_EVENT_MEMORY_COMPLETE, LSC)		|
+			P4_ESCR_EMASK_BIT(P4_EVENT_MEMORY_COMPLETE, SSC),
 		.cntr		= { {8, 9, -1}, {10, 11, -1} },
 	},
 	[P4_EVENT_LOAD_PORT_REPLAY] = {
 		.opcode		= P4_OPCODE(P4_EVENT_LOAD_PORT_REPLAY),
 		.escr_msr	= { MSR_P4_SAAT_ESCR0, MSR_P4_SAAT_ESCR1 },
+		.escr_emask	=
+			P4_ESCR_EMASK_BIT(P4_EVENT_LOAD_PORT_REPLAY, SPLIT_LD),
 		.cntr		= { {8, 9, -1}, {10, 11, -1} },
 	},
 	[P4_EVENT_STORE_PORT_REPLAY] = {
 		.opcode		= P4_OPCODE(P4_EVENT_STORE_PORT_REPLAY),
 		.escr_msr	= { MSR_P4_SAAT_ESCR0 ,  MSR_P4_SAAT_ESCR1 },
+		.escr_emask	=
+			P4_ESCR_EMASK_BIT(P4_EVENT_STORE_PORT_REPLAY, SPLIT_ST),
 		.cntr		= { {8, 9, -1}, {10, 11, -1} },
 	},
 	[P4_EVENT_MOB_LOAD_REPLAY] = {
 		.opcode		= P4_OPCODE(P4_EVENT_MOB_LOAD_REPLAY),
 		.escr_msr	= { MSR_P4_MOB_ESCR0, MSR_P4_MOB_ESCR1 },
+		.escr_emask	=
+			P4_ESCR_EMASK_BIT(P4_EVENT_MOB_LOAD_REPLAY, NO_STA)		|
+			P4_ESCR_EMASK_BIT(P4_EVENT_MOB_LOAD_REPLAY, NO_STD)		|
+			P4_ESCR_EMASK_BIT(P4_EVENT_MOB_LOAD_REPLAY, PARTIAL_DATA)	|
+			P4_ESCR_EMASK_BIT(P4_EVENT_MOB_LOAD_REPLAY, UNALGN_ADDR),
 		.cntr		= { {0, -1, -1}, {2, -1, -1} },
 	},
 	[P4_EVENT_PAGE_WALK_TYPE] = {
 		.opcode		= P4_OPCODE(P4_EVENT_PAGE_WALK_TYPE),
 		.escr_msr	= { MSR_P4_PMH_ESCR0, MSR_P4_PMH_ESCR1 },
+		.escr_emask	=
+			P4_ESCR_EMASK_BIT(P4_EVENT_PAGE_WALK_TYPE, DTMISS)		|
+			P4_ESCR_EMASK_BIT(P4_EVENT_PAGE_WALK_TYPE, ITMISS),
+		.shared		= 1,
 		.cntr		= { {0, -1, -1}, {2, -1, -1} },
 	},
 	[P4_EVENT_BSQ_CACHE_REFERENCE] = {
 		.opcode		= P4_OPCODE(P4_EVENT_BSQ_CACHE_REFERENCE),
 		.escr_msr	= { MSR_P4_BSU_ESCR0, MSR_P4_BSU_ESCR1 },
+		.escr_emask	=
+			P4_ESCR_EMASK_BIT(P4_EVENT_BSQ_CACHE_REFERENCE, RD_2ndL_HITS)	|
+			P4_ESCR_EMASK_BIT(P4_EVENT_BSQ_CACHE_REFERENCE, RD_2ndL_HITE)	|
+			P4_ESCR_EMASK_BIT(P4_EVENT_BSQ_CACHE_REFERENCE, RD_2ndL_HITM)	|
+			P4_ESCR_EMASK_BIT(P4_EVENT_BSQ_CACHE_REFERENCE, RD_3rdL_HITS)	|
+			P4_ESCR_EMASK_BIT(P4_EVENT_BSQ_CACHE_REFERENCE, RD_3rdL_HITE)	|
+			P4_ESCR_EMASK_BIT(P4_EVENT_BSQ_CACHE_REFERENCE, RD_3rdL_HITM)	|
+			P4_ESCR_EMASK_BIT(P4_EVENT_BSQ_CACHE_REFERENCE, RD_2ndL_MISS)	|
+			P4_ESCR_EMASK_BIT(P4_EVENT_BSQ_CACHE_REFERENCE, RD_3rdL_MISS)	|
+			P4_ESCR_EMASK_BIT(P4_EVENT_BSQ_CACHE_REFERENCE, WR_2ndL_MISS),
 		.cntr		= { {0, -1, -1}, {2, -1, -1} },
 	},
 	[P4_EVENT_IOQ_ALLOCATION] = {
 		.opcode		= P4_OPCODE(P4_EVENT_IOQ_ALLOCATION),
 		.escr_msr	= { MSR_P4_FSB_ESCR0, MSR_P4_FSB_ESCR1 },
+		.escr_emask	=
+			P4_ESCR_EMASK_BIT(P4_EVENT_IOQ_ALLOCATION, DEFAULT)		|
+			P4_ESCR_EMASK_BIT(P4_EVENT_IOQ_ALLOCATION, ALL_READ)		|
+			P4_ESCR_EMASK_BIT(P4_EVENT_IOQ_ALLOCATION, ALL_WRITE)		|
+			P4_ESCR_EMASK_BIT(P4_EVENT_IOQ_ALLOCATION, MEM_UC)		|
+			P4_ESCR_EMASK_BIT(P4_EVENT_IOQ_ALLOCATION, MEM_WC)		|
+			P4_ESCR_EMASK_BIT(P4_EVENT_IOQ_ALLOCATION, MEM_WT)		|
+			P4_ESCR_EMASK_BIT(P4_EVENT_IOQ_ALLOCATION, MEM_WP)		|
+			P4_ESCR_EMASK_BIT(P4_EVENT_IOQ_ALLOCATION, MEM_WB)		|
+			P4_ESCR_EMASK_BIT(P4_EVENT_IOQ_ALLOCATION, OWN)			|
+			P4_ESCR_EMASK_BIT(P4_EVENT_IOQ_ALLOCATION, OTHER)		|
+			P4_ESCR_EMASK_BIT(P4_EVENT_IOQ_ALLOCATION, PREFETCH),
 		.cntr		= { {0, -1, -1}, {2, -1, -1} },
 	},
 	[P4_EVENT_IOQ_ACTIVE_ENTRIES] = {	/* shared ESCR */
 		.opcode		= P4_OPCODE(P4_EVENT_IOQ_ACTIVE_ENTRIES),
 		.escr_msr	= { MSR_P4_FSB_ESCR1,  MSR_P4_FSB_ESCR1 },
+		.escr_emask	=
+			P4_ESCR_EMASK_BIT(P4_EVENT_IOQ_ACTIVE_ENTRIES, DEFAULT)		|
+			P4_ESCR_EMASK_BIT(P4_EVENT_IOQ_ACTIVE_ENTRIES, ALL_READ)	|
+			P4_ESCR_EMASK_BIT(P4_EVENT_IOQ_ACTIVE_ENTRIES, ALL_WRITE)	|
+			P4_ESCR_EMASK_BIT(P4_EVENT_IOQ_ACTIVE_ENTRIES, MEM_UC)		|
+			P4_ESCR_EMASK_BIT(P4_EVENT_IOQ_ACTIVE_ENTRIES, MEM_WC)		|
+			P4_ESCR_EMASK_BIT(P4_EVENT_IOQ_ACTIVE_ENTRIES, MEM_WT)		|
+			P4_ESCR_EMASK_BIT(P4_EVENT_IOQ_ACTIVE_ENTRIES, MEM_WP)		|
+			P4_ESCR_EMASK_BIT(P4_EVENT_IOQ_ACTIVE_ENTRIES, MEM_WB)		|
+			P4_ESCR_EMASK_BIT(P4_EVENT_IOQ_ACTIVE_ENTRIES, OWN)		|
+			P4_ESCR_EMASK_BIT(P4_EVENT_IOQ_ACTIVE_ENTRIES, OTHER)		|
+			P4_ESCR_EMASK_BIT(P4_EVENT_IOQ_ACTIVE_ENTRIES, PREFETCH),
 		.cntr		= { {2, -1, -1}, {3, -1, -1} },
 	},
 	[P4_EVENT_FSB_DATA_ACTIVITY] = {
 		.opcode		= P4_OPCODE(P4_EVENT_FSB_DATA_ACTIVITY),
 		.escr_msr	= { MSR_P4_FSB_ESCR0, MSR_P4_FSB_ESCR1 },
+		.escr_emask	=
+			P4_ESCR_EMASK_BIT(P4_EVENT_FSB_DATA_ACTIVITY, DRDY_DRV)		|
+			P4_ESCR_EMASK_BIT(P4_EVENT_FSB_DATA_ACTIVITY, DRDY_OWN)		|
+			P4_ESCR_EMASK_BIT(P4_EVENT_FSB_DATA_ACTIVITY, DRDY_OTHER)	|
+			P4_ESCR_EMASK_BIT(P4_EVENT_FSB_DATA_ACTIVITY, DBSY_DRV)		|
+			P4_ESCR_EMASK_BIT(P4_EVENT_FSB_DATA_ACTIVITY, DBSY_OWN)		|
+			P4_ESCR_EMASK_BIT(P4_EVENT_FSB_DATA_ACTIVITY, DBSY_OTHER),
+		.shared		= 1,
 		.cntr		= { {0, -1, -1}, {2, -1, -1} },
 	},
 	[P4_EVENT_BSQ_ALLOCATION] = {		/* shared ESCR, broken CCCR1 */
 		.opcode		= P4_OPCODE(P4_EVENT_BSQ_ALLOCATION),
 		.escr_msr	= { MSR_P4_BSU_ESCR0, MSR_P4_BSU_ESCR0 },
+		.escr_emask	=
+			P4_ESCR_EMASK_BIT(P4_EVENT_BSQ_ALLOCATION, REQ_TYPE0)		|
+			P4_ESCR_EMASK_BIT(P4_EVENT_BSQ_ALLOCATION, REQ_TYPE1)		|
+			P4_ESCR_EMASK_BIT(P4_EVENT_BSQ_ALLOCATION, REQ_LEN0)		|
+			P4_ESCR_EMASK_BIT(P4_EVENT_BSQ_ALLOCATION, REQ_LEN1)		|
+			P4_ESCR_EMASK_BIT(P4_EVENT_BSQ_ALLOCATION, REQ_IO_TYPE)		|
+			P4_ESCR_EMASK_BIT(P4_EVENT_BSQ_ALLOCATION, REQ_LOCK_TYPE)	|
+			P4_ESCR_EMASK_BIT(P4_EVENT_BSQ_ALLOCATION, REQ_CACHE_TYPE)	|
+			P4_ESCR_EMASK_BIT(P4_EVENT_BSQ_ALLOCATION, REQ_SPLIT_TYPE)	|
+			P4_ESCR_EMASK_BIT(P4_EVENT_BSQ_ALLOCATION, REQ_DEM_TYPE)	|
+			P4_ESCR_EMASK_BIT(P4_EVENT_BSQ_ALLOCATION, REQ_ORD_TYPE)	|
+			P4_ESCR_EMASK_BIT(P4_EVENT_BSQ_ALLOCATION, MEM_TYPE0)		|
+			P4_ESCR_EMASK_BIT(P4_EVENT_BSQ_ALLOCATION, MEM_TYPE1)		|
+			P4_ESCR_EMASK_BIT(P4_EVENT_BSQ_ALLOCATION, MEM_TYPE2),
 		.cntr		= { {0, -1, -1}, {1, -1, -1} },
 	},
 	[P4_EVENT_BSQ_ACTIVE_ENTRIES] = {	/* shared ESCR */
 		.opcode		= P4_OPCODE(P4_EVENT_BSQ_ACTIVE_ENTRIES),
 		.escr_msr	= { MSR_P4_BSU_ESCR1 , MSR_P4_BSU_ESCR1 },
+		.escr_emask	=
+			P4_ESCR_EMASK_BIT(P4_EVENT_BSQ_ACTIVE_ENTRIES, REQ_TYPE0)	|
+			P4_ESCR_EMASK_BIT(P4_EVENT_BSQ_ACTIVE_ENTRIES, REQ_TYPE1)	|
+			P4_ESCR_EMASK_BIT(P4_EVENT_BSQ_ACTIVE_ENTRIES, REQ_LEN0)	|
+			P4_ESCR_EMASK_BIT(P4_EVENT_BSQ_ACTIVE_ENTRIES, REQ_LEN1)	|
+			P4_ESCR_EMASK_BIT(P4_EVENT_BSQ_ACTIVE_ENTRIES, REQ_IO_TYPE)	|
+			P4_ESCR_EMASK_BIT(P4_EVENT_BSQ_ACTIVE_ENTRIES, REQ_LOCK_TYPE)	|
+			P4_ESCR_EMASK_BIT(P4_EVENT_BSQ_ACTIVE_ENTRIES, REQ_CACHE_TYPE)	|
+			P4_ESCR_EMASK_BIT(P4_EVENT_BSQ_ACTIVE_ENTRIES, REQ_SPLIT_TYPE)	|
+			P4_ESCR_EMASK_BIT(P4_EVENT_BSQ_ACTIVE_ENTRIES, REQ_DEM_TYPE)	|
+			P4_ESCR_EMASK_BIT(P4_EVENT_BSQ_ACTIVE_ENTRIES, REQ_ORD_TYPE)	|
+			P4_ESCR_EMASK_BIT(P4_EVENT_BSQ_ACTIVE_ENTRIES, MEM_TYPE0)	|
+			P4_ESCR_EMASK_BIT(P4_EVENT_BSQ_ACTIVE_ENTRIES, MEM_TYPE1)	|
+			P4_ESCR_EMASK_BIT(P4_EVENT_BSQ_ACTIVE_ENTRIES, MEM_TYPE2),
 		.cntr		= { {2, -1, -1}, {3, -1, -1} },
 	},
 	[P4_EVENT_SSE_INPUT_ASSIST] = {
 		.opcode		= P4_OPCODE(P4_EVENT_SSE_INPUT_ASSIST),
 		.escr_msr	= { MSR_P4_FIRM_ESCR0, MSR_P4_FIRM_ESCR1 },
+		.escr_emask	=
+			P4_ESCR_EMASK_BIT(P4_EVENT_SSE_INPUT_ASSIST, ALL),
+		.shared		= 1,
 		.cntr		= { {8, 9, -1}, {10, 11, -1} },
 	},
 	[P4_EVENT_PACKED_SP_UOP] = {
 		.opcode		= P4_OPCODE(P4_EVENT_PACKED_SP_UOP),
 		.escr_msr	= { MSR_P4_FIRM_ESCR0, MSR_P4_FIRM_ESCR1 },
+		.escr_emask	=
+			P4_ESCR_EMASK_BIT(P4_EVENT_PACKED_SP_UOP, ALL),
+		.shared		= 1,
 		.cntr		= { {8, 9, -1}, {10, 11, -1} },
 	},
 	[P4_EVENT_PACKED_DP_UOP] = {
 		.opcode		= P4_OPCODE(P4_EVENT_PACKED_DP_UOP),
 		.escr_msr	= { MSR_P4_FIRM_ESCR0, MSR_P4_FIRM_ESCR1 },
+		.escr_emask	=
+			P4_ESCR_EMASK_BIT(P4_EVENT_PACKED_DP_UOP, ALL),
+		.shared		= 1,
 		.cntr		= { {8, 9, -1}, {10, 11, -1} },
 	},
 	[P4_EVENT_SCALAR_SP_UOP] = {
 		.opcode		= P4_OPCODE(P4_EVENT_SCALAR_SP_UOP),
 		.escr_msr	= { MSR_P4_FIRM_ESCR0, MSR_P4_FIRM_ESCR1 },
+		.escr_emask	=
+			P4_ESCR_EMASK_BIT(P4_EVENT_SCALAR_SP_UOP, ALL),
+		.shared		= 1,
 		.cntr		= { {8, 9, -1}, {10, 11, -1} },
 	},
 	[P4_EVENT_SCALAR_DP_UOP] = {
 		.opcode		= P4_OPCODE(P4_EVENT_SCALAR_DP_UOP),
 		.escr_msr	= { MSR_P4_FIRM_ESCR0, MSR_P4_FIRM_ESCR1 },
+		.escr_emask	=
+			P4_ESCR_EMASK_BIT(P4_EVENT_SCALAR_DP_UOP, ALL),
+		.shared		= 1,
 		.cntr		= { {8, 9, -1}, {10, 11, -1} },
 	},
 	[P4_EVENT_64BIT_MMX_UOP] = {
 		.opcode		= P4_OPCODE(P4_EVENT_64BIT_MMX_UOP),
 		.escr_msr	= { MSR_P4_FIRM_ESCR0, MSR_P4_FIRM_ESCR1 },
+		.escr_emask	=
+			P4_ESCR_EMASK_BIT(P4_EVENT_64BIT_MMX_UOP, ALL),
+		.shared		= 1,
 		.cntr		= { {8, 9, -1}, {10, 11, -1} },
 	},
 	[P4_EVENT_128BIT_MMX_UOP] = {
 		.opcode		= P4_OPCODE(P4_EVENT_128BIT_MMX_UOP),
 		.escr_msr	= { MSR_P4_FIRM_ESCR0, MSR_P4_FIRM_ESCR1 },
+		.escr_emask	=
+			P4_ESCR_EMASK_BIT(P4_EVENT_128BIT_MMX_UOP, ALL),
+		.shared		= 1,
 		.cntr		= { {8, 9, -1}, {10, 11, -1} },
 	},
 	[P4_EVENT_X87_FP_UOP] = {
 		.opcode		= P4_OPCODE(P4_EVENT_X87_FP_UOP),
 		.escr_msr	= { MSR_P4_FIRM_ESCR0, MSR_P4_FIRM_ESCR1 },
+		.escr_emask	=
+			P4_ESCR_EMASK_BIT(P4_EVENT_X87_FP_UOP, ALL),
+		.shared		= 1,
 		.cntr		= { {8, 9, -1}, {10, 11, -1} },
 	},
 	[P4_EVENT_TC_MISC] = {
 		.opcode		= P4_OPCODE(P4_EVENT_TC_MISC),
 		.escr_msr	= { MSR_P4_TC_ESCR0, MSR_P4_TC_ESCR1 },
+		.escr_emask	=
+			P4_ESCR_EMASK_BIT(P4_EVENT_TC_MISC, FLUSH),
 		.cntr		= { {4, 5, -1}, {6, 7, -1} },
 	},
 	[P4_EVENT_GLOBAL_POWER_EVENTS] = {
 		.opcode		= P4_OPCODE(P4_EVENT_GLOBAL_POWER_EVENTS),
 		.escr_msr	= { MSR_P4_FSB_ESCR0, MSR_P4_FSB_ESCR1 },
+		.escr_emask	=
+			P4_ESCR_EMASK_BIT(P4_EVENT_GLOBAL_POWER_EVENTS, RUNNING),
 		.cntr		= { {0, -1, -1}, {2, -1, -1} },
 	},
 	[P4_EVENT_TC_MS_XFER] = {
 		.opcode		= P4_OPCODE(P4_EVENT_TC_MS_XFER),
 		.escr_msr	= { MSR_P4_MS_ESCR0, MSR_P4_MS_ESCR1 },
+		.escr_emask	=
+			P4_ESCR_EMASK_BIT(P4_EVENT_TC_MS_XFER, CISC),
 		.cntr		= { {4, 5, -1}, {6, 7, -1} },
 	},
 	[P4_EVENT_UOP_QUEUE_WRITES] = {
 		.opcode		= P4_OPCODE(P4_EVENT_UOP_QUEUE_WRITES),
 		.escr_msr	= { MSR_P4_MS_ESCR0, MSR_P4_MS_ESCR1 },
+		.escr_emask	=
+			P4_ESCR_EMASK_BIT(P4_EVENT_UOP_QUEUE_WRITES, FROM_TC_BUILD)	|
+			P4_ESCR_EMASK_BIT(P4_EVENT_UOP_QUEUE_WRITES, FROM_TC_DELIVER)	|
+			P4_ESCR_EMASK_BIT(P4_EVENT_UOP_QUEUE_WRITES, FROM_ROM),
 		.cntr		= { {4, 5, -1}, {6, 7, -1} },
 	},
 	[P4_EVENT_RETIRED_MISPRED_BRANCH_TYPE] = {
 		.opcode		= P4_OPCODE(P4_EVENT_RETIRED_MISPRED_BRANCH_TYPE),
 		.escr_msr	= { MSR_P4_TBPU_ESCR0 , MSR_P4_TBPU_ESCR0 },
+		.escr_emask	=
+			P4_ESCR_EMASK_BIT(P4_EVENT_RETIRED_MISPRED_BRANCH_TYPE, CONDITIONAL)	|
+			P4_ESCR_EMASK_BIT(P4_EVENT_RETIRED_MISPRED_BRANCH_TYPE, CALL)		|
+			P4_ESCR_EMASK_BIT(P4_EVENT_RETIRED_MISPRED_BRANCH_TYPE, RETURN)		|
+			P4_ESCR_EMASK_BIT(P4_EVENT_RETIRED_MISPRED_BRANCH_TYPE, INDIRECT),
 		.cntr		= { {4, 5, -1}, {6, 7, -1} },
 	},
 	[P4_EVENT_RETIRED_BRANCH_TYPE] = {
 		.opcode		= P4_OPCODE(P4_EVENT_RETIRED_BRANCH_TYPE),
 		.escr_msr	= { MSR_P4_TBPU_ESCR0 , MSR_P4_TBPU_ESCR1 },
+		.escr_emask	=
+			P4_ESCR_EMASK_BIT(P4_EVENT_RETIRED_BRANCH_TYPE, CONDITIONAL)	|
+			P4_ESCR_EMASK_BIT(P4_EVENT_RETIRED_BRANCH_TYPE, CALL)		|
+			P4_ESCR_EMASK_BIT(P4_EVENT_RETIRED_BRANCH_TYPE, RETURN)		|
+			P4_ESCR_EMASK_BIT(P4_EVENT_RETIRED_BRANCH_TYPE, INDIRECT),
 		.cntr		= { {4, 5, -1}, {6, 7, -1} },
 	},
 	[P4_EVENT_RESOURCE_STALL] = {
 		.opcode		= P4_OPCODE(P4_EVENT_RESOURCE_STALL),
 		.escr_msr	= { MSR_P4_ALF_ESCR0, MSR_P4_ALF_ESCR1 },
+		.escr_emask	=
+			P4_ESCR_EMASK_BIT(P4_EVENT_RESOURCE_STALL, SBFULL),
 		.cntr		= { {12, 13, 16}, {14, 15, 17} },
 	},
 	[P4_EVENT_WC_BUFFER] = {
 		.opcode		= P4_OPCODE(P4_EVENT_WC_BUFFER),
 		.escr_msr	= { MSR_P4_DAC_ESCR0, MSR_P4_DAC_ESCR1 },
+		.escr_emask	=
+			P4_ESCR_EMASK_BIT(P4_EVENT_WC_BUFFER, WCB_EVICTS)		|
+			P4_ESCR_EMASK_BIT(P4_EVENT_WC_BUFFER, WCB_FULL_EVICTS),
+		.shared		= 1,
 		.cntr		= { {8, 9, -1}, {10, 11, -1} },
 	},
 	[P4_EVENT_B2B_CYCLES] = {
 		.opcode		= P4_OPCODE(P4_EVENT_B2B_CYCLES),
 		.escr_msr	= { MSR_P4_FSB_ESCR0, MSR_P4_FSB_ESCR1 },
+		.escr_emask	= 0,
 		.cntr		= { {0, -1, -1}, {2, -1, -1} },
 	},
 	[P4_EVENT_BNR] = {
 		.opcode		= P4_OPCODE(P4_EVENT_BNR),
 		.escr_msr	= { MSR_P4_FSB_ESCR0, MSR_P4_FSB_ESCR1 },
+		.escr_emask	= 0,
 		.cntr		= { {0, -1, -1}, {2, -1, -1} },
 	},
 	[P4_EVENT_SNOOP] = {
 		.opcode		= P4_OPCODE(P4_EVENT_SNOOP),
 		.escr_msr	= { MSR_P4_FSB_ESCR0, MSR_P4_FSB_ESCR1 },
+		.escr_emask	= 0,
 		.cntr		= { {0, -1, -1}, {2, -1, -1} },
 	},
 	[P4_EVENT_RESPONSE] = {
 		.opcode		= P4_OPCODE(P4_EVENT_RESPONSE),
 		.escr_msr	= { MSR_P4_FSB_ESCR0, MSR_P4_FSB_ESCR1 },
+		.escr_emask	= 0,
 		.cntr		= { {0, -1, -1}, {2, -1, -1} },
 	},
 	[P4_EVENT_FRONT_END_EVENT] = {
 		.opcode		= P4_OPCODE(P4_EVENT_FRONT_END_EVENT),
 		.escr_msr	= { MSR_P4_CRU_ESCR2, MSR_P4_CRU_ESCR3 },
+		.escr_emask	=
+			P4_ESCR_EMASK_BIT(P4_EVENT_FRONT_END_EVENT, NBOGUS)		|
+			P4_ESCR_EMASK_BIT(P4_EVENT_FRONT_END_EVENT, BOGUS),
 		.cntr		= { {12, 13, 16}, {14, 15, 17} },
 	},
 	[P4_EVENT_EXECUTION_EVENT] = {
 		.opcode		= P4_OPCODE(P4_EVENT_EXECUTION_EVENT),
 		.escr_msr	= { MSR_P4_CRU_ESCR2, MSR_P4_CRU_ESCR3 },
+		.escr_emask	=
+			P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, NBOGUS0)		|
+			P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, NBOGUS1)		|
+			P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, NBOGUS2)		|
+			P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, NBOGUS3)		|
+			P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, BOGUS0)		|
+			P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, BOGUS1)		|
+			P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, BOGUS2)		|
+			P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, BOGUS3),
 		.cntr		= { {12, 13, 16}, {14, 15, 17} },
 	},
 	[P4_EVENT_REPLAY_EVENT] = {
 		.opcode		= P4_OPCODE(P4_EVENT_REPLAY_EVENT),
 		.escr_msr	= { MSR_P4_CRU_ESCR2, MSR_P4_CRU_ESCR3 },
+		.escr_emask	=
+			P4_ESCR_EMASK_BIT(P4_EVENT_REPLAY_EVENT, NBOGUS)		|
+			P4_ESCR_EMASK_BIT(P4_EVENT_REPLAY_EVENT, BOGUS),
 		.cntr		= { {12, 13, 16}, {14, 15, 17} },
 	},
 	[P4_EVENT_INSTR_RETIRED] = {
 		.opcode		= P4_OPCODE(P4_EVENT_INSTR_RETIRED),
 		.escr_msr	= { MSR_P4_CRU_ESCR0, MSR_P4_CRU_ESCR1 },
+		.escr_emask	=
+			P4_ESCR_EMASK_BIT(P4_EVENT_INSTR_RETIRED, NBOGUSNTAG)		|
+			P4_ESCR_EMASK_BIT(P4_EVENT_INSTR_RETIRED, NBOGUSTAG)		|
+			P4_ESCR_EMASK_BIT(P4_EVENT_INSTR_RETIRED, BOGUSNTAG)		|
+			P4_ESCR_EMASK_BIT(P4_EVENT_INSTR_RETIRED, BOGUSTAG),
 		.cntr		= { {12, 13, 16}, {14, 15, 17} },
 	},
 	[P4_EVENT_UOPS_RETIRED] = {
 		.opcode		= P4_OPCODE(P4_EVENT_UOPS_RETIRED),
 		.escr_msr	= { MSR_P4_CRU_ESCR0, MSR_P4_CRU_ESCR1 },
+		.escr_emask	=
+			P4_ESCR_EMASK_BIT(P4_EVENT_UOPS_RETIRED, NBOGUS)		|
+			P4_ESCR_EMASK_BIT(P4_EVENT_UOPS_RETIRED, BOGUS),
 		.cntr		= { {12, 13, 16}, {14, 15, 17} },
 	},
 	[P4_EVENT_UOP_TYPE] = {
 		.opcode		= P4_OPCODE(P4_EVENT_UOP_TYPE),
 		.escr_msr	= { MSR_P4_RAT_ESCR0, MSR_P4_RAT_ESCR1 },
+		.escr_emask	=
+			P4_ESCR_EMASK_BIT(P4_EVENT_UOP_TYPE, TAGLOADS)			|
+			P4_ESCR_EMASK_BIT(P4_EVENT_UOP_TYPE, TAGSTORES),
 		.cntr		= { {12, 13, 16}, {14, 15, 17} },
 	},
 	[P4_EVENT_BRANCH_RETIRED] = {
 		.opcode		= P4_OPCODE(P4_EVENT_BRANCH_RETIRED),
 		.escr_msr	= { MSR_P4_CRU_ESCR2, MSR_P4_CRU_ESCR3 },
+		.escr_emask	=
+			P4_ESCR_EMASK_BIT(P4_EVENT_BRANCH_RETIRED, MMNP)		|
+			P4_ESCR_EMASK_BIT(P4_EVENT_BRANCH_RETIRED, MMNM)		|
+			P4_ESCR_EMASK_BIT(P4_EVENT_BRANCH_RETIRED, MMTP)		|
+			P4_ESCR_EMASK_BIT(P4_EVENT_BRANCH_RETIRED, MMTM),
 		.cntr		= { {12, 13, 16}, {14, 15, 17} },
 	},
 	[P4_EVENT_MISPRED_BRANCH_RETIRED] = {
 		.opcode		= P4_OPCODE(P4_EVENT_MISPRED_BRANCH_RETIRED),
 		.escr_msr	= { MSR_P4_CRU_ESCR0, MSR_P4_CRU_ESCR1 },
+		.escr_emask	=
+		P4_ESCR_EMASK_BIT(P4_EVENT_MISPRED_BRANCH_RETIRED, NBOGUS),
 		.cntr		= { {12, 13, 16}, {14, 15, 17} },
 	},
 	[P4_EVENT_X87_ASSIST] = {
 		.opcode		= P4_OPCODE(P4_EVENT_X87_ASSIST),
 		.escr_msr	= { MSR_P4_CRU_ESCR2, MSR_P4_CRU_ESCR3 },
+		.escr_emask	=
+			P4_ESCR_EMASK_BIT(P4_EVENT_X87_ASSIST, FPSU)			|
+			P4_ESCR_EMASK_BIT(P4_EVENT_X87_ASSIST, FPSO)			|
+			P4_ESCR_EMASK_BIT(P4_EVENT_X87_ASSIST, POAO)			|
+			P4_ESCR_EMASK_BIT(P4_EVENT_X87_ASSIST, POAU)			|
+			P4_ESCR_EMASK_BIT(P4_EVENT_X87_ASSIST, PREA),
 		.cntr		= { {12, 13, 16}, {14, 15, 17} },
 	},
 	[P4_EVENT_MACHINE_CLEAR] = {
 		.opcode		= P4_OPCODE(P4_EVENT_MACHINE_CLEAR),
 		.escr_msr	= { MSR_P4_CRU_ESCR2, MSR_P4_CRU_ESCR3 },
+		.escr_emask	=
+			P4_ESCR_EMASK_BIT(P4_EVENT_MACHINE_CLEAR, CLEAR)		|
+			P4_ESCR_EMASK_BIT(P4_EVENT_MACHINE_CLEAR, MOCLEAR)		|
+			P4_ESCR_EMASK_BIT(P4_EVENT_MACHINE_CLEAR, SMCLEAR),
 		.cntr		= { {12, 13, 16}, {14, 15, 17} },
 	},
 	[P4_EVENT_INSTR_COMPLETED] = {
 		.opcode		= P4_OPCODE(P4_EVENT_INSTR_COMPLETED),
 		.escr_msr	= { MSR_P4_CRU_ESCR0, MSR_P4_CRU_ESCR1 },
+		.escr_emask	=
+			P4_ESCR_EMASK_BIT(P4_EVENT_INSTR_COMPLETED, NBOGUS)		|
+			P4_ESCR_EMASK_BIT(P4_EVENT_INSTR_COMPLETED, BOGUS),
 		.cntr		= { {12, 13, 16}, {14, 15, 17} },
 	},
 };
@@ -428,29 +634,73 @@ static u64 p4_pmu_event_map(int hw_event)
 	return config;
 }
 
+/* check cpu model specifics */
+static bool p4_event_match_cpu_model(unsigned int event_idx)
+{
+	/* INSTR_COMPLETED event only exist for model 3, 4, 6 (Prescott) */
+	if (event_idx == P4_EVENT_INSTR_COMPLETED) {
+		if (boot_cpu_data.x86_model != 3 &&
+			boot_cpu_data.x86_model != 4 &&
+			boot_cpu_data.x86_model != 6)
+			return false;
+	}
+
+	/*
+	 * For info
+	 * - IQ_ESCR0, IQ_ESCR1 only for models 1 and 2
+	 */
+
+	return true;
+}
+
 static int p4_validate_raw_event(struct perf_event *event)
 {
-	unsigned int v;
+	unsigned int v, emask;
 
-	/* user data may have out-of-bound event index */
+	/* User data may have out-of-bound event index */
 	v = p4_config_unpack_event(event->attr.config);
-	if (v >= ARRAY_SIZE(p4_event_bind_map)) {
-		pr_warning("P4 PMU: Unknown event code: %d\n", v);
+	if (v >= ARRAY_SIZE(p4_event_bind_map))
+		return -EINVAL;
+
+	/* It may be unsupported: */
+	if (!p4_event_match_cpu_model(v))
 		return -EINVAL;
+
+	/*
+	 * NOTE: P4_CCCR_THREAD_ANY has not the same meaning as
+	 * in Architectural Performance Monitoring, it means not
+	 * on _which_ logical cpu to count but rather _when_, ie it
+	 * depends on logical cpu state -- count event if one cpu active,
+	 * none, both or any, so we just allow user to pass any value
+	 * desired.
+	 *
+	 * In turn we always set Tx_OS/Tx_USR bits bound to logical
+	 * cpu without their propagation to another cpu
+	 */
+
+	/*
+	 * if an event is shared accross the logical threads
+	 * the user needs special permissions to be able to use it
+	 */
+	if (p4_event_bind_map[v].shared) {
+		if (perf_paranoid_cpu() && !capable(CAP_SYS_ADMIN))
+			return -EACCES;
 	}
 
+	/* ESCR EventMask bits may be invalid */
+	emask = p4_config_unpack_escr(event->attr.config) & P4_ESCR_EVENTMASK_MASK;
+	if (emask & ~p4_event_bind_map[v].escr_emask)
+		return -EINVAL;
+
 	/*
-	 * it may have some screwed PEBS bits
+	 * it may have some invalid PEBS bits
 	 */
-	if (p4_config_pebs_has(event->attr.config, P4_PEBS_CONFIG_ENABLE)) {
-		pr_warning("P4 PMU: PEBS are not supported yet\n");
+	if (p4_config_pebs_has(event->attr.config, P4_PEBS_CONFIG_ENABLE))
 		return -EINVAL;
-	}
+
 	v = p4_config_unpack_metric(event->attr.config);
-	if (v >= ARRAY_SIZE(p4_pebs_bind_map)) {
-		pr_warning("P4 PMU: Unknown metric code: %d\n", v);
+	if (v >= ARRAY_SIZE(p4_pebs_bind_map))
 		return -EINVAL;
-	}
 
 	return 0;
 }
@@ -478,27 +728,21 @@ static int p4_hw_config(struct perf_event *event)
 
 	if (event->attr.type == PERF_TYPE_RAW) {
 
+		/*
+		 * Clear bits we reserve to be managed by kernel itself
+		 * and never allowed from a user space
+		 */
+		 event->attr.config &= P4_CONFIG_MASK;
+
 		rc = p4_validate_raw_event(event);
 		if (rc)
 			goto out;
 
 		/*
-		 * We don't control raw events so it's up to the caller
-		 * to pass sane values (and we don't count the thread number
-		 * on HT machine but allow HT-compatible specifics to be
-		 * passed on)
-		 *
 		 * Note that for RAW events we allow user to use P4_CCCR_RESERVED
 		 * bits since we keep additional info here (for cache events and etc)
-		 *
-		 * XXX: HT wide things should check perf_paranoid_cpu() &&
-		 *      CAP_SYS_ADMIN
 		 */
-		event->hw.config |= event->attr.config &
-			(p4_config_pack_escr(P4_ESCR_MASK_HT) |
-			 p4_config_pack_cccr(P4_CCCR_MASK_HT | P4_CCCR_RESERVED));
-
-		event->hw.config &= ~P4_CCCR_FORCE_OVF;
+		event->hw.config |= event->attr.config;
 	}
 
 	rc = x86_setup_perfctr(event);
