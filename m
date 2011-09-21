Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209Ab1IUK7o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 06:59:44 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:10474 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764Ab1IUK7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 06:59:42 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LRVD2P-01-0VA-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [V3][PATCH 1/7] perf, x86: share IBS macros between perf and oprofile
Date: Wed, 21 Sep 2011 11:30:17 +0200
Message-ID: <1316597423-25723-2-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1316597423-25723-1-git-send-email-robert.richter@amd.com>
References: <1316597423-25723-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moving IBS macros from oprofile to <asm/perf_event.h> to make it
available to perf. No additional changes.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/include/asm/perf_event.h    |   38 +++++++++++++++++++++++++++++++--
 arch/x86/kernel/cpu/perf_event_amd.c |    4 +-
 arch/x86/oprofile/op_model_amd.c     |   37 ++------------------------------
 3 files changed, 40 insertions(+), 39 deletions(-)

diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 094fb30..bc801ac 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -43,14 +43,17 @@
 #define AMD64_RAW_EVENT_MASK		\
 	(X86_RAW_EVENT_MASK          |  \
 	 AMD64_EVENTSEL_EVENT)
+#define AMD64_NUM_COUNTERS				4
+#define AMD64_NUM_COUNTERS_F15H				6
+#define AMD64_NUM_COUNTERS_MAX				AMD64_NUM_COUNTERS_F15H
 
-#define ARCH_PERFMON_UNHALTED_CORE_CYCLES_SEL		      0x3c
+#define ARCH_PERFMON_UNHALTED_CORE_CYCLES_SEL		0x3c
 #define ARCH_PERFMON_UNHALTED_CORE_CYCLES_UMASK		(0x00 << 8)
-#define ARCH_PERFMON_UNHALTED_CORE_CYCLES_INDEX			 0
+#define ARCH_PERFMON_UNHALTED_CORE_CYCLES_INDEX		0
 #define ARCH_PERFMON_UNHALTED_CORE_CYCLES_PRESENT \
 		(1 << (ARCH_PERFMON_UNHALTED_CORE_CYCLES_INDEX))
 
-#define ARCH_PERFMON_BRANCH_MISSES_RETIRED			 6
+#define ARCH_PERFMON_BRANCH_MISSES_RETIRED		6
 
 /*
  * Intel "Architectural Performance Monitoring" CPUID
@@ -110,6 +113,35 @@ union cpuid10_edx {
  */
 #define X86_PMC_IDX_FIXED_BTS				(X86_PMC_IDX_FIXED + 16)
 
+/*
+ * IBS cpuid feature detection
+ */
+
+#define IBS_CPUID_FEATURES		0x8000001b
+
+/*
+ * Same bit mask as for IBS cpuid feature flags (Fn8000_001B_EAX), but
+ * bit 0 is used to indicate the existence of IBS.
+ */
+#define IBS_CAPS_AVAIL			(1U<<0)
+#define IBS_CAPS_FETCHSAM		(1U<<1)
+#define IBS_CAPS_OPSAM			(1U<<2)
+#define IBS_CAPS_RDWROPCNT		(1U<<3)
+#define IBS_CAPS_OPCNT			(1U<<4)
+#define IBS_CAPS_BRNTRGT		(1U<<5)
+#define IBS_CAPS_OPCNTEXT		(1U<<6)
+
+#define IBS_CAPS_DEFAULT		(IBS_CAPS_AVAIL		\
+					 | IBS_CAPS_FETCHSAM	\
+					 | IBS_CAPS_OPSAM)
+
+/*
+ * IBS APIC setup
+ */
+#define IBSCTL				0x1cc
+#define IBSCTL_LVT_OFFSET_VALID		(1ULL<<8)
+#define IBSCTL_LVT_OFFSET_MASK		0x0F
+
 /* IbsFetchCtl bits/masks */
 #define IBS_FETCH_RAND_EN	(1ULL<<57)
 #define IBS_FETCH_VAL		(1ULL<<49)
diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index ee9436c..21c7028 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -392,7 +392,7 @@ static __initconst const struct x86_pmu amd_pmu = {
 	.perfctr		= MSR_K7_PERFCTR0,
 	.event_map		= amd_pmu_event_map,
 	.max_events		= ARRAY_SIZE(amd_perfmon_event_map),
-	.num_counters		= 4,
+	.num_counters		= AMD64_NUM_COUNTERS,
 	.cntval_bits		= 48,
 	.cntval_mask		= (1ULL << 48) - 1,
 	.apic			= 1,
@@ -556,7 +556,7 @@ static __initconst const struct x86_pmu amd_pmu_f15h = {
 	.perfctr		= MSR_F15H_PERF_CTR,
 	.event_map		= amd_pmu_event_map,
 	.max_events		= ARRAY_SIZE(amd_perfmon_event_map),
-	.num_counters		= 6,
+	.num_counters		= AMD64_NUM_COUNTERS_F15H,
 	.cntval_bits		= 48,
 	.cntval_mask		= (1ULL << 48) - 1,
 	.apic			= 1,
diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index 9cbb710..e947e5c 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -29,8 +29,6 @@
 #include "op_x86_model.h"
 #include "op_counter.h"
 
-#define NUM_COUNTERS		4
-#define NUM_COUNTERS_F15H	6
 #ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
 #define NUM_VIRT_COUNTERS	32
 #else
@@ -70,35 +68,6 @@ static struct ibs_config ibs_config;
 static struct ibs_state ibs_state;
 
 /*
- * IBS cpuid feature detection
- */
-
-#define IBS_CPUID_FEATURES		0x8000001b
-
-/*
- * Same bit mask as for IBS cpuid feature flags (Fn8000_001B_EAX), but
- * bit 0 is used to indicate the existence of IBS.
- */
-#define IBS_CAPS_AVAIL			(1U<<0)
-#define IBS_CAPS_FETCHSAM		(1U<<1)
-#define IBS_CAPS_OPSAM			(1U<<2)
-#define IBS_CAPS_RDWROPCNT		(1U<<3)
-#define IBS_CAPS_OPCNT			(1U<<4)
-#define IBS_CAPS_BRNTRGT		(1U<<5)
-#define IBS_CAPS_OPCNTEXT		(1U<<6)
-
-#define IBS_CAPS_DEFAULT		(IBS_CAPS_AVAIL		\
-					 | IBS_CAPS_FETCHSAM	\
-					 | IBS_CAPS_OPSAM)
-
-/*
- * IBS APIC setup
- */
-#define IBSCTL				0x1cc
-#define IBSCTL_LVT_OFFSET_VALID		(1ULL<<8)
-#define IBSCTL_LVT_OFFSET_MASK		0x0F
-
-/*
  * IBS randomization macros
  */
 #define IBS_RANDOM_BITS			12
@@ -439,7 +408,7 @@ static int op_amd_fill_in_addresses(struct op_msrs * const msrs)
 			goto fail;
 		}
 		/* both registers must be reserved */
-		if (num_counters == NUM_COUNTERS_F15H) {
+		if (num_counters == AMD64_NUM_COUNTERS_F15H) {
 			msrs->counters[i].addr = MSR_F15H_PERF_CTR + (i << 1);
 			msrs->controls[i].addr = MSR_F15H_PERF_CTL + (i << 1);
 		} else {
@@ -741,9 +710,9 @@ static int op_amd_init(struct oprofile_operations *ops)
 	ops->create_files = setup_ibs_files;
 
 	if (boot_cpu_data.x86 == 0x15) {
-		num_counters = NUM_COUNTERS_F15H;
+		num_counters = AMD64_NUM_COUNTERS_F15H;
 	} else {
-		num_counters = NUM_COUNTERS;
+		num_counters = AMD64_NUM_COUNTERS;
 	}
 
 	op_amd_spec.num_counters = num_counters;
-- 
1.7.6.1


