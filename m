Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933103Ab2IUTIT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 15:08:19 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:50178 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756780Ab2IUTIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 15:08:17 -0400
Date: Fri, 21 Sep 2012 21:08:09 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20120921190809.GA22634@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

   HEAD: 85f2a2ef1d0ab99523e0b947a2b723f5650ed6aa tracing: Don't call page_to_pfn() if page is NULL

Small perf fixlets.

 Thanks,

	Ingo

------------------>
Robert Richter (1):
      perf/x86/ibs: Check syscall attribute flags

Stephane Eranian (2):
      perf/x86: Export Sandy Bridge uncore clockticks event in sysfs
      perf/x86: Fix Intel Ivy Bridge support

Wen Congyang (1):
      tracing: Don't call page_to_pfn() if page is NULL


 arch/x86/kernel/cpu/perf_event.h              |  2 ++
 arch/x86/kernel/cpu/perf_event_amd_ibs.c      | 12 ++++++++++++
 arch/x86/kernel/cpu/perf_event_intel.c        | 24 +++++++++++++++++++++++-
 arch/x86/kernel/cpu/perf_event_intel_ds.c     | 14 ++++++++++++++
 arch/x86/kernel/cpu/perf_event_intel_uncore.c |  6 ++++++
 include/linux/perf_event.h                    |  2 ++
 include/trace/events/kmem.h                   |  4 ++--
 7 files changed, 61 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 6605a81..8b6defe 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -586,6 +586,8 @@ extern struct event_constraint intel_westmere_pebs_event_constraints[];
 
 extern struct event_constraint intel_snb_pebs_event_constraints[];
 
+extern struct event_constraint intel_ivb_pebs_event_constraints[];
+
 struct event_constraint *intel_pebs_constraints(struct perf_event *event);
 
 void intel_pmu_pebs_enable(struct perf_event *event);
diff --git a/arch/x86/kernel/cpu/perf_event_amd_ibs.c b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
index 7bfb5be..eebd5ff 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_ibs.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
@@ -209,6 +209,15 @@ static int perf_ibs_precise_event(struct perf_event *event, u64 *config)
 	return -EOPNOTSUPP;
 }
 
+static const struct perf_event_attr ibs_notsupp = {
+	.exclude_user	= 1,
+	.exclude_kernel	= 1,
+	.exclude_hv	= 1,
+	.exclude_idle	= 1,
+	.exclude_host	= 1,
+	.exclude_guest	= 1,
+};
+
 static int perf_ibs_init(struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
@@ -229,6 +238,9 @@ static int perf_ibs_init(struct perf_event *event)
 	if (event->pmu != &perf_ibs->pmu)
 		return -ENOENT;
 
+	if (perf_flags(&event->attr) & perf_flags(&ibs_notsupp))
+		return -EINVAL;
+
 	if (config & ~perf_ibs->config_mask)
 		return -EINVAL;
 
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 0d3d63a..6bca492 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -2048,7 +2048,6 @@ __init int intel_pmu_init(void)
 	case 42: /* SandyBridge */
 	case 45: /* SandyBridge, "Romely-EP" */
 		x86_add_quirk(intel_sandybridge_quirk);
-	case 58: /* IvyBridge */
 		memcpy(hw_cache_event_ids, snb_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
 		memcpy(hw_cache_extra_regs, snb_hw_cache_extra_regs,
@@ -2073,6 +2072,29 @@ __init int intel_pmu_init(void)
 
 		pr_cont("SandyBridge events, ");
 		break;
+	case 58: /* IvyBridge */
+		memcpy(hw_cache_event_ids, snb_hw_cache_event_ids,
+		       sizeof(hw_cache_event_ids));
+		memcpy(hw_cache_extra_regs, snb_hw_cache_extra_regs,
+		       sizeof(hw_cache_extra_regs));
+
+		intel_pmu_lbr_init_snb();
+
+		x86_pmu.event_constraints = intel_snb_event_constraints;
+		x86_pmu.pebs_constraints = intel_ivb_pebs_event_constraints;
+		x86_pmu.pebs_aliases = intel_pebs_aliases_snb;
+		x86_pmu.extra_regs = intel_snb_extra_regs;
+		/* all extra regs are per-cpu when HT is on */
+		x86_pmu.er_flags |= ERF_HAS_RSP_1;
+		x86_pmu.er_flags |= ERF_NO_HT_SHARING;
+
+		/* UOPS_ISSUED.ANY,c=1,i=1 to count stall cycles */
+		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND] =
+			X86_CONFIG(.event=0x0e, .umask=0x01, .inv=1, .cmask=1);
+
+		pr_cont("IvyBridge events, ");
+		break;
+
 
 	default:
 		switch (x86_pmu.version) {
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index e38d97b..826054a 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -407,6 +407,20 @@ struct event_constraint intel_snb_pebs_event_constraints[] = {
 	EVENT_CONSTRAINT_END
 };
 
+struct event_constraint intel_ivb_pebs_event_constraints[] = {
+        INTEL_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PRECDIST */
+        INTEL_UEVENT_CONSTRAINT(0x01c2, 0xf), /* UOPS_RETIRED.ALL */
+        INTEL_UEVENT_CONSTRAINT(0x02c2, 0xf), /* UOPS_RETIRED.RETIRE_SLOTS */
+        INTEL_EVENT_CONSTRAINT(0xc4, 0xf),    /* BR_INST_RETIRED.* */
+        INTEL_EVENT_CONSTRAINT(0xc5, 0xf),    /* BR_MISP_RETIRED.* */
+        INTEL_EVENT_CONSTRAINT(0xcd, 0x8),    /* MEM_TRANS_RETIRED.* */
+        INTEL_EVENT_CONSTRAINT(0xd0, 0xf),    /* MEM_UOP_RETIRED.* */
+        INTEL_EVENT_CONSTRAINT(0xd1, 0xf),    /* MEM_LOAD_UOPS_RETIRED.* */
+        INTEL_EVENT_CONSTRAINT(0xd2, 0xf),    /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.* */
+        INTEL_EVENT_CONSTRAINT(0xd3, 0xf),    /* MEM_LOAD_UOPS_LLC_MISS_RETIRED.* */
+        EVENT_CONSTRAINT_END
+};
+
 struct event_constraint *intel_pebs_constraints(struct perf_event *event)
 {
 	struct event_constraint *c;
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 0a55710..38e4894 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -661,6 +661,11 @@ static void snb_uncore_msr_init_box(struct intel_uncore_box *box)
 	}
 }
 
+static struct uncore_event_desc snb_uncore_events[] = {
+	INTEL_UNCORE_EVENT_DESC(clockticks, "event=0xff,umask=0x00"),
+	{ /* end: all zeroes */ },
+};
+
 static struct attribute *snb_uncore_formats_attr[] = {
 	&format_attr_event.attr,
 	&format_attr_umask.attr,
@@ -704,6 +709,7 @@ static struct intel_uncore_type snb_uncore_cbox = {
 	.constraints	= snb_uncore_cbox_constraints,
 	.ops		= &snb_uncore_msr_ops,
 	.format_group	= &snb_uncore_format_group,
+	.event_descs	= snb_uncore_events,
 };
 
 static struct intel_uncore_type *snb_msr_uncores[] = {
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 33ed9d6..bdb4161 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -274,6 +274,8 @@ struct perf_event_attr {
 	__u64	branch_sample_type; /* enum branch_sample_type */
 };
 
+#define perf_flags(attr)	(*(&(attr)->read_format + 1))
+
 /*
  * Ioctls that can be done on a perf event fd:
  */
diff --git a/include/trace/events/kmem.h b/include/trace/events/kmem.h
index 5f889f1..08fa272 100644
--- a/include/trace/events/kmem.h
+++ b/include/trace/events/kmem.h
@@ -214,7 +214,7 @@ TRACE_EVENT(mm_page_alloc,
 
 	TP_printk("page=%p pfn=%lu order=%d migratetype=%d gfp_flags=%s",
 		__entry->page,
-		page_to_pfn(__entry->page),
+		__entry->page ? page_to_pfn(__entry->page) : 0,
 		__entry->order,
 		__entry->migratetype,
 		show_gfp_flags(__entry->gfp_flags))
@@ -240,7 +240,7 @@ DECLARE_EVENT_CLASS(mm_page,
 
 	TP_printk("page=%p pfn=%lu order=%u migratetype=%d percpu_refill=%d",
 		__entry->page,
-		page_to_pfn(__entry->page),
+		__entry->page ? page_to_pfn(__entry->page) : 0,
 		__entry->order,
 		__entry->migratetype,
 		__entry->order == 0)
