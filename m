Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574Ab0DMU1d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 16:27:33 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:27484 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477Ab0DMU05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 16:26:57 -0400
X-SpamScore: 7
X-BigFish: VPS7(zzab9bh905fnzz1202hzzz32i2a8h87h6bh467h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L0U0SH-02-H0P-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 07/12] perf, x86: introduce bit range for special pmu events
Date: Tue, 13 Apr 2010 22:23:16 +0200
Message-ID: <1271190201-25705-8-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <1271190201-25705-1-git-send-email-robert.richter@amd.com>
References: <1271190201-25705-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 13 Apr 2010 20:26:35.0589 (UTC) FILETIME=[9CF42F50:01CADB47]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are some pmu events such as Intel BTS or AMD IBS that do not fit
in the generic or fixed performance counter scheme. The upper bits
starting at bit 48 of the 64 bit counter mask are reserved for such
events and can be used to handle them. The events can be identified by
its index in the bit mask.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/include/asm/perf_event.h         |    3 ++-
 arch/x86/kernel/cpu/perf_event.c          |    6 +++---
 arch/x86/kernel/cpu/perf_event_intel.c    |   10 +++++-----
 arch/x86/kernel/cpu/perf_event_intel_ds.c |    4 ++--
 4 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index f6d43db..9f10215 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -10,6 +10,7 @@
 
 #define X86_PMC_IDX_GENERIC				        0
 #define X86_PMC_IDX_FIXED				       32
+#define X86_PMC_IDX_SPECIAL				       48
 #define X86_PMC_IDX_MAX					       64
 
 #define MSR_ARCH_PERFMON_PERFCTR0			      0xc1
@@ -107,7 +108,7 @@ union cpuid10_edx {
  * values are used by actual fixed events and higher values are used
  * to indicate other overflow conditions in the PERF_GLOBAL_STATUS msr.
  */
-#define X86_PMC_IDX_FIXED_BTS				(X86_PMC_IDX_FIXED + 16)
+#define X86_PMC_IDX_SPECIAL_BTS				(X86_PMC_IDX_SPECIAL + 0)
 
 /* IbsFetchCtl bits/masks */
 #define IBS_FETCH_RAND_EN		(1ULL<<57)
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index feda380..2a7c2fc 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -281,7 +281,7 @@ x86_perf_event_update(struct perf_event *event)
 	int idx = hwc->idx;
 	s64 delta;
 
-	if (idx == X86_PMC_IDX_FIXED_BTS)
+	if (idx == X86_PMC_IDX_SPECIAL_BTS)
 		return 0;
 
 	/*
@@ -758,7 +758,7 @@ static inline void x86_assign_hw_event(struct perf_event *event,
 	hwc->last_cpu = smp_processor_id();
 	hwc->last_tag = ++cpuc->tags[i];
 
-	if (hwc->idx == X86_PMC_IDX_FIXED_BTS) {
+	if (hwc->idx == X86_PMC_IDX_SPECIAL_BTS) {
 		hwc->config_base = 0;
 		hwc->event_base	= 0;
 	} else if (hwc->idx >= X86_PMC_IDX_FIXED) {
@@ -874,7 +874,7 @@ x86_perf_event_set_period(struct perf_event *event)
 	s64 period = hwc->sample_period;
 	int ret = 0, idx = hwc->idx;
 
-	if (idx == X86_PMC_IDX_FIXED_BTS)
+	if (idx == X86_PMC_IDX_SPECIAL_BTS)
 		return 0;
 
 	/*
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index a4b56ac..c7e6145 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -458,7 +458,7 @@ static void intel_pmu_disable_all(void)
 
 	wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0);
 
-	if (test_bit(X86_PMC_IDX_FIXED_BTS, cpuc->active_mask))
+	if (test_bit(X86_PMC_IDX_SPECIAL_BTS, cpuc->active_mask))
 		intel_pmu_disable_bts();
 
 	intel_pmu_pebs_disable_all();
@@ -473,9 +473,9 @@ static void intel_pmu_enable_all(int added)
 	intel_pmu_lbr_enable_all();
 	wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, x86_pmu.intel_ctrl);
 
-	if (test_bit(X86_PMC_IDX_FIXED_BTS, cpuc->active_mask)) {
+	if (test_bit(X86_PMC_IDX_SPECIAL_BTS, cpuc->active_mask)) {
 		struct perf_event *event =
-			cpuc->events[X86_PMC_IDX_FIXED_BTS];
+			cpuc->events[X86_PMC_IDX_SPECIAL_BTS];
 
 		if (WARN_ON_ONCE(!event))
 			return;
@@ -550,7 +550,7 @@ static void intel_pmu_disable_event(struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
 
-	if (unlikely(hwc->idx == X86_PMC_IDX_FIXED_BTS)) {
+	if (unlikely(hwc->idx == X86_PMC_IDX_SPECIAL_BTS)) {
 		intel_pmu_disable_bts();
 		intel_pmu_drain_bts_buffer();
 		return;
@@ -602,7 +602,7 @@ static void intel_pmu_enable_event(struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
 
-	if (unlikely(hwc->idx == X86_PMC_IDX_FIXED_BTS)) {
+	if (unlikely(hwc->idx == X86_PMC_IDX_SPECIAL_BTS)) {
 		if (!__get_cpu_var(cpu_hw_events).enabled)
 			return;
 
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index ec8b2e1..e49a68a 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -176,7 +176,7 @@ static int reserve_ds_buffers(void)
  */
 
 static struct event_constraint bts_constraint =
-	EVENT_CONSTRAINT(0, 1ULL << X86_PMC_IDX_FIXED_BTS, 0);
+	EVENT_CONSTRAINT(0, 1ULL << X86_PMC_IDX_SPECIAL_BTS, 0);
 
 static void intel_pmu_enable_bts(u64 config)
 {
@@ -223,7 +223,7 @@ static void intel_pmu_drain_bts_buffer(void)
 		u64	to;
 		u64	flags;
 	};
-	struct perf_event *event = cpuc->events[X86_PMC_IDX_FIXED_BTS];
+	struct perf_event *event = cpuc->events[X86_PMC_IDX_SPECIAL_BTS];
 	struct bts_record *at, *top;
 	struct perf_output_handle handle;
 	struct perf_event_header header;
-- 
1.7.0.3


