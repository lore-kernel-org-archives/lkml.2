Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470Ab1HaMlh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 08:41:37 -0400
Received: from smtp-out.google.com ([74.125.121.67]:39134 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755370Ab1HaMlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 08:41:32 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:to:cc:subject:message-id:
	mime-version:content-type:content-disposition:user-agent:x-system-of-record;
	b=BI2AIVf62K4RTxNWg6itLAMWaj0/ebMVk8eOINihx0K+jSWwXUVFpspJZdEf7+gAU
	9mVbobzw7nsQ2w4tYLQTw==
Date: Wed, 31 Aug 2011 14:41:25 +0200
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: ming.m.lin@intel.com, peterz@infradead.org, mingo@elte.hu,
        andi@firstfloor.org, acme@ghostprotocols.net
Subject: [PATCH] perf_event: fix Ming's Intel NHM/WSM/SNB uncore PMU patch
Message-ID: <20110831124125.GA10443@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following patch sits on top of Lin Ming's patch
which adds support for Intel uncore PMU on NHM/WSM/SNB.
The patch series was posted on LKML in July 2011.

The patches fixes:
  - nhm_uncore_pmu_enable_all() to also enabled the fixed uncore counters
  - uncore_pmu_add() to schedule for the actual max number of generic counters
  - fixed the NHM/WSM vs. SNB MSRs for the fixed counter, they are swapped 

The patch adds the following improvement:
  - add an event group validation function, to check if a group can ever be
    schedule. This way, the behavior is consistent with core PMU event groups.

Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index e250977..283f292 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -426,8 +426,11 @@
 
 /* Intel Nehalem/Westmere/SandyBridge uncore performance counters */
 #define MSR_UNCORE_PERF_GLOBAL_CTRL	0x00000391
-#define MSR_UNCORE_FIXED_CTR_CTRL	0x00000394
-#define MSR_UNCORE_FIXED_CTR0		0x00000395
+#define MSR_NHM_UNCORE_FIXED_CTR0	0x00000394
+#define MSR_NHM_UNCORE_FIXED_CTR_CTRL	0x00000395
+
+#define MSR_SNB_UNCORE_FIXED_CTR0	0x00000395
+#define MSR_SNB_UNCORE_FIXED_CTR_CTRL	0x00000394
 
 #define MSR_NHM_UNCORE_PMC0		0x000003b0
 #define MSR_NHM_UNCORE_PERFEVTSEL0	0x000003c0
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 1100589..70bd28c 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -23,8 +23,8 @@ static void uncore_fixed_hw_config(struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
 
-	hwc->config_base = MSR_UNCORE_FIXED_CTR_CTRL;
-	hwc->event_base = MSR_UNCORE_FIXED_CTR0;
+	hwc->config_base = intel_uncore_pmu.fixed_config_base;
+	hwc->event_base = intel_uncore_pmu.fixed_event_base;
 }
 
 static void uncore_fixed_disable_event(struct perf_event *event)
@@ -63,7 +63,14 @@ static void uncore_pmu_disable_event(struct perf_event *event)
 
 static void nhm_uncore_pmu_enable_all(void)
 {
-	u64 ctrl = (1 << UNCORE_NUM_COUNTERS) - 1;
+	u64 ctrl, fmask;
+
+	/* generic counters */
+	ctrl = (1 << UNCORE_NUM_GENERIC_COUNTERS) - 1;
+
+	/* fixed counters */
+	fmask = (1 << UNCORE_NUM_FIXED_COUNTERS) - 1;
+	ctrl |= fmask << X86_PMC_IDX_FIXED;
 
 	wrmsrl(MSR_UNCORE_PERF_GLOBAL_CTRL, ctrl);
 }
@@ -96,6 +103,8 @@ static __initconst const struct intel_uncore_pmu nhm_uncore_pmu = {
 	.hw_config		= nhm_uncore_pmu_hw_config,
 	.cntval_bits		= 48,
 	.cntval_bits_fixed	= 48,
+	.fixed_config_base	= MSR_NHM_UNCORE_FIXED_CTR_CTRL,
+	.fixed_event_base	= MSR_NHM_UNCORE_FIXED_CTR0,
 };
 
 /* SandyBridge uncore pmu */
@@ -149,6 +158,8 @@ static __initconst const struct intel_uncore_pmu snb_uncore_pmu = {
 	.hw_config		= snb_uncore_pmu_hw_config,
 	.cntval_bits		= 44,
 	.cntval_bits_fixed	= 48,
+	.fixed_config_base	= MSR_SNB_UNCORE_FIXED_CTR_CTRL,
+	.fixed_event_base	= MSR_SNB_UNCORE_FIXED_CTR0,
 };
 
 static u64 uncore_perf_event_update(struct perf_event *event)
@@ -234,9 +245,43 @@ static void uncore_pmu_init_hrtimer(struct intel_uncore *uncore)
 
 static struct pmu uncore_pmu;
 
+static int uncore_validate_group(struct perf_event *event)
+{
+	struct perf_event *leader = event->group_leader;
+	struct perf_event *e = event->group_leader;
+	int gen = 0, fixed = 0;
+	int ret = 0;
+
+	if (leader->attr.config == UNCORE_FIXED_EVENT)
+		fixed++;
+	else
+		gen++;
+
+	if (event->attr.config == UNCORE_FIXED_EVENT)
+		fixed++;
+	else
+		gen++;
+
+	list_for_each_entry(e, &leader->sibling_list, group_entry) {
+		if (e->attr.config == UNCORE_FIXED_EVENT)
+			fixed++;
+		else
+			gen++;
+	}
+
+	if (fixed > UNCORE_NUM_FIXED_COUNTERS)
+		ret = -ENOSPC;
+
+	if (gen > UNCORE_NUM_GENERIC_COUNTERS)
+		ret = -ENOSPC;
+
+	return ret;
+}
+
 static int uncore_pmu_event_init(struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
+	int ret = 0;
 
 	if (!uncore_pmu_initialized)
 		return -ENOENT;
@@ -256,7 +301,10 @@ static int uncore_pmu_event_init(struct perf_event *event)
 	if (hwc->sample_period)
 		return -EINVAL;
 
-	return 0;
+	if (event->group_leader != event)
+		ret = uncore_validate_group(event);
+
+	return ret;
 }
 
 static void uncore_pmu_start(struct perf_event *event, int flags)
@@ -290,7 +338,7 @@ static int uncore_pmu_add(struct perf_event *event, int flags)
 		goto fixed_event;
 	}
 
-	for (i = 0; i < X86_PMC_IDX_FIXED; i++) {
+	for (i = 0; i < UNCORE_NUM_GENERIC_COUNTERS; i++) {
 fixed_event:
 		if (!uncore->events[i]) {
 			uncore->events[i] = event;
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.h b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
index c7392aa..79f3d19 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.h
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
@@ -61,4 +61,6 @@ struct intel_uncore_pmu {
 	void		(*hw_config)(struct perf_event *event);
 	int		cntval_bits;
 	int		cntval_bits_fixed;
+	int		fixed_config_base;
+	int		fixed_event_base;
 };
