Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895Ab2GDGAm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 02:00:42 -0400
Received: from mga14.intel.com ([143.182.124.37]:18951 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933286Ab2GDGAa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 02:00:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="163860420"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: a.p.zijlstra@chello.nl, eranian@google.com, mingo@elte.hu,
        andi@firstfloor.org, linux-kernel@vger.kernel.org
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH 5/5] perf/x86: Add Intel Nehalem-EX uncore support
Date: Wed,  4 Jul 2012 14:00:16 +0800
Message-Id: <1341381616-12229-6-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1341381616-12229-1-git-send-email-zheng.z.yan@intel.com>
References: <1341381616-12229-1-git-send-email-zheng.z.yan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yan, Zheng" <zheng.z.yan@intel.com>

The uncore subsystem in Nehalem-EX consists of 7 components
(U-Box, C-Box, B-Box, S-Box, R-Box, M-Box and W-Box). This
patch is large because the way to program these boxes is
diverse.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 1178 +++++++++++++++++++++++--
 arch/x86/kernel/cpu/perf_event_intel_uncore.h |  195 +++-
 2 files changed, 1301 insertions(+), 72 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index c0a80ff..ff4f40f 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -38,6 +38,63 @@ DEFINE_UNCORE_FORMAT_ATTR(filter_brand1, filter_brand1, "config1:8-15");
 DEFINE_UNCORE_FORMAT_ATTR(filter_brand2, filter_brand2, "config1:16-23");
 DEFINE_UNCORE_FORMAT_ATTR(filter_brand3, filter_brand3, "config1:24-31");
 
+static u64 uncore_msr_read_counter(struct intel_uncore_box *box,
+				   struct perf_event *event)
+{
+	u64 count;
+	rdmsrl(event->hw.event_base, count);
+	return count;
+}
+
+/*
+ * generic get constraint function for shared match/mask registers.
+ */
+static struct event_constraint *
+uncore_get_constraint(struct intel_uncore_box *box, struct perf_event *event)
+{
+	struct intel_uncore_extra_reg *er;
+	struct hw_perf_event_extra *reg1 = &event->hw.extra_reg;
+	struct hw_perf_event_extra *reg2 = &event->hw.branch_reg;
+	unsigned long flags;
+	bool ok = false;
+
+	if (reg1->idx == EXTRA_REG_NONE || (box->phys_id >= 0 && reg1->alloc))
+		return NULL;
+
+	er = &box->shared_regs[reg1->idx];
+	raw_spin_lock_irqsave(&er->lock, flags);
+	if (!atomic_read(&er->ref) ||
+	    (er->config1 == reg1->config && er->config2 == reg2->config)) {
+		atomic_inc(&er->ref);
+		er->config1 = reg1->config;
+		er->config2 = reg2->config;
+		ok = true;
+	}
+	raw_spin_unlock_irqrestore(&er->lock, flags);
+
+	if (ok) {
+		if (box->phys_id >= 0)
+			reg1->alloc = 1;
+		return NULL;
+	}
+
+	return &constraint_empty;
+}
+
+static void uncore_put_constraint(struct intel_uncore_box *box,
+					struct perf_event *event)
+{
+	struct intel_uncore_extra_reg *er;
+	struct hw_perf_event_extra *reg1 = &event->hw.extra_reg;
+
+	if (box->phys_id < 0 || !reg1->alloc)
+		return;
+
+	er = &box->shared_regs[reg1->idx];
+	atomic_dec(&er->ref);
+	reg1->alloc = 0;
+}
+
 /* Sandy Bridge-EP uncore support */
 static struct intel_uncore_type snbep_uncore_cbox;
 static struct intel_uncore_type snbep_uncore_pcu;
@@ -150,16 +207,6 @@ static void snbep_uncore_msr_disable_event(struct intel_uncore_box *box,
 	wrmsrl(hwc->config_base, hwc->config);
 }
 
-static u64 snbep_uncore_msr_read_counter(struct intel_uncore_box *box,
-					struct perf_event *event)
-{
-	struct hw_perf_event *hwc = &event->hw;
-	u64 count;
-
-	rdmsrl(hwc->event_base, count);
-	return count;
-}
-
 static void snbep_uncore_msr_init_box(struct intel_uncore_box *box)
 {
 	unsigned msr = uncore_msr_box_ctl(box);
@@ -167,49 +214,6 @@ static void snbep_uncore_msr_init_box(struct intel_uncore_box *box)
 		wrmsrl(msr, SNBEP_PMON_BOX_CTL_INT);
 }
 
-static struct event_constraint *
-snbep_uncore_get_constraint(struct intel_uncore_box *box,
-			    struct perf_event *event)
-{
-	struct intel_uncore_extra_reg *er;
-	struct hw_perf_event_extra *reg1 = &event->hw.extra_reg;
-	unsigned long flags;
-	bool ok = false;
-
-	if (reg1->idx == EXTRA_REG_NONE || (box->phys_id >= 0 && reg1->alloc))
-		return NULL;
-
-	er = &box->shared_regs[reg1->idx];
-	raw_spin_lock_irqsave(&er->lock, flags);
-	if (!atomic_read(&er->ref) || er->config1 == reg1->config) {
-		atomic_inc(&er->ref);
-		er->config1 = reg1->config;
-		ok = true;
-	}
-	raw_spin_unlock_irqrestore(&er->lock, flags);
-
-	if (ok) {
-		if (box->phys_id >= 0)
-			reg1->alloc = 1;
-		return NULL;
-	}
-	return &constraint_empty;
-}
-
-static void snbep_uncore_put_constraint(struct intel_uncore_box *box,
-					struct perf_event *event)
-{
-	struct intel_uncore_extra_reg *er;
-	struct hw_perf_event_extra *reg1 = &event->hw.extra_reg;
-
-	if (box->phys_id < 0 || !reg1->alloc)
-		return;
-
-	er = &box->shared_regs[reg1->idx];
-	atomic_dec(&er->ref);
-	reg1->alloc = 0;
-}
-
 static int snbep_uncore_hw_config(struct intel_uncore_box *box,
 				  struct perf_event *event)
 {
@@ -320,9 +324,9 @@ static struct intel_uncore_ops snbep_uncore_msr_ops = {
 	.enable_box	= snbep_uncore_msr_enable_box,
 	.disable_event	= snbep_uncore_msr_disable_event,
 	.enable_event	= snbep_uncore_msr_enable_event,
-	.read_counter	= snbep_uncore_msr_read_counter,
-	.get_constraint = snbep_uncore_get_constraint,
-	.put_constraint = snbep_uncore_put_constraint,
+	.read_counter	= uncore_msr_read_counter,
+	.get_constraint = uncore_get_constraint,
+	.put_constraint = uncore_put_constraint,
 	.hw_config	= snbep_uncore_hw_config,
 };
 
@@ -603,7 +607,6 @@ static void snbep_pci2phy_map_init(void)
 }
 /* end of Sandy Bridge-EP uncore support */
 
-
 /* Sandy Bridge uncore support */
 static void snb_uncore_msr_enable_event(struct intel_uncore_box *box,
 					struct perf_event *event)
@@ -622,14 +625,6 @@ static void snb_uncore_msr_disable_event(struct intel_uncore_box *box,
 	wrmsrl(event->hw.config_base, 0);
 }
 
-static u64 snb_uncore_msr_read_counter(struct intel_uncore_box *box,
-					struct perf_event *event)
-{
-	u64 count;
-	rdmsrl(event->hw.event_base, count);
-	return count;
-}
-
 static void snb_uncore_msr_init_box(struct intel_uncore_box *box)
 {
 	if (box->pmu->pmu_idx == 0) {
@@ -656,7 +651,7 @@ static struct intel_uncore_ops snb_uncore_msr_ops = {
 	.init_box	= snb_uncore_msr_init_box,
 	.disable_event	= snb_uncore_msr_disable_event,
 	.enable_event	= snb_uncore_msr_enable_event,
-	.read_counter	= snb_uncore_msr_read_counter,
+	.read_counter	= uncore_msr_read_counter,
 };
 
 static struct event_constraint snb_uncore_cbox_constraints[] = {
@@ -744,7 +739,7 @@ static struct intel_uncore_ops nhm_uncore_msr_ops = {
 	.enable_box	= nhm_uncore_msr_enable_box,
 	.disable_event	= snb_uncore_msr_disable_event,
 	.enable_event	= nhm_uncore_msr_enable_event,
-	.read_counter	= snb_uncore_msr_read_counter,
+	.read_counter	= uncore_msr_read_counter,
 };
 
 static struct intel_uncore_type nhm_uncore = {
@@ -769,6 +764,1047 @@ static struct intel_uncore_type *nhm_msr_uncores[] = {
 };
 /* end of Nehalem uncore support */
 
+/* Nehalem-EX uncore support */
+static struct intel_uncore_ops nhmex_uncore_ops;
+
+#define __BITS_VALUE(x, i, n)  ((typeof(x))(((x) >> ((i) * (n))) & \
+				((1ULL << (n)) - 1)))
+
+DEFINE_UNCORE_FORMAT_ATTR(event5, event, "config:1-5");
+DEFINE_UNCORE_FORMAT_ATTR(counter, counter, "config:6-7");
+DEFINE_UNCORE_FORMAT_ATTR(mm_cfg, mm_cfg, "config:63");
+DEFINE_UNCORE_FORMAT_ATTR(match, match, "config1:0-63");
+DEFINE_UNCORE_FORMAT_ATTR(mask, mask, "config2:0-63");
+
+static struct attribute *nhmex_uncore_ubox_formats_attr[] = {
+	&format_attr_event.attr,
+	&format_attr_edge.attr,
+	NULL,
+};
+
+static struct attribute_group nhmex_uncore_ubox_format_group = {
+	.name = "format",
+	.attrs = nhmex_uncore_ubox_formats_attr,
+};
+
+static struct intel_uncore_type nhmex_uncore_ubox = {
+	.name			= "ubox",
+	.num_counters		= 1,
+	.num_boxes		= 1,
+	.perf_ctr_bits		= 48,
+	.event_ctl		= NHMEX_U_MSR_PMON_EV_SEL,
+	.perf_ctr		= NHMEX_U_MSR_PMON_CTR,
+	.event_mask		= NHMEX_U_PMON_RAW_EVENT_MASK,
+	.box_ctl		= NHMEX_U_MSR_PMON_GLOBAL_CTL,
+	.ops			= &nhmex_uncore_ops,
+	.format_group		= &nhmex_uncore_ubox_format_group
+};
+
+static struct attribute *nhmex_uncore_cbox_formats_attr[] = {
+	&format_attr_event.attr,
+	&format_attr_umask.attr,
+	&format_attr_edge.attr,
+	&format_attr_inv.attr,
+	&format_attr_thresh8.attr,
+	NULL,
+};
+
+static struct attribute_group nhmex_uncore_cbox_format_group = {
+	.name = "format",
+	.attrs = nhmex_uncore_cbox_formats_attr,
+};
+
+static struct intel_uncore_type nhmex_uncore_cbox = {
+	.name			= "cbox",
+	.num_counters		= 6,
+	.num_boxes		= 8,
+	.perf_ctr_bits		= 48,
+	.event_ctl		= NHMEX_C0_MSR_PMON_EV_SEL0,
+	.perf_ctr		= NHMEX_C0_MSR_PMON_CTR0,
+	.event_mask		= NHMEX_PMON_RAW_EVENT_MASK,
+	.box_ctl		= NHMEX_C0_MSR_PMON_GLOBAL_CTL,
+	.msr_offset		= NHMEX_C_MSR_OFFSET,
+	.pair_ctr_ctl		= 1,
+	.ops			= &nhmex_uncore_ops,
+	.format_group		= &nhmex_uncore_cbox_format_group
+};
+
+static struct uncore_event_desc nhmex_uncore_wbox_events[] = {
+	INTEL_UNCORE_EVENT_DESC(clockticks, "event=0xff,umask=0"),
+	{ /* end: all zeroes */ },
+};
+
+static struct intel_uncore_type nhmex_uncore_wbox = {
+	.name			= "wbox",
+	.num_counters		= 4,
+	.num_boxes		= 1,
+	.perf_ctr_bits		= 48,
+	.event_ctl		= NHMEX_W_MSR_PMON_CNT0,
+	.perf_ctr		= NHMEX_W_MSR_PMON_EVT_SEL0,
+	.fixed_ctr		= NHMEX_W_MSR_PMON_FIXED_CTR,
+	.fixed_ctl		= NHMEX_W_MSR_PMON_FIXED_CTL,
+	.event_mask		= NHMEX_PMON_RAW_EVENT_MASK,
+	.box_ctl		= NHMEX_W_MSR_GLOBAL_CTL,
+	.pair_ctr_ctl		= 1,
+	.event_descs		= nhmex_uncore_wbox_events,
+	.ops			= &nhmex_uncore_ops,
+	.format_group		= &nhmex_uncore_cbox_format_group
+};
+
+static int nhmex_bbox_hw_config(struct intel_uncore_box *box,
+				  struct perf_event *event)
+{
+	struct hw_perf_event *hwc = &event->hw;
+	struct hw_perf_event_extra *reg1 = &hwc->extra_reg;
+	struct hw_perf_event_extra *reg2 = &hwc->branch_reg;
+	int ctr, ev_sel;
+
+	ctr = (hwc->config & NHMEX_B_PMON_CTR_MASK) >>
+		NHMEX_B_PMON_CTR_SHIFT;
+	ev_sel = (hwc->config & NHMEX_B_PMON_CTL_EV_SEL_MASK) >>
+		  NHMEX_B_PMON_CTL_EV_SEL_SHIFT;
+
+	/* events that do not use the match/mask registers */
+	if ((ctr == 0 && ev_sel > 0x3) || (ctr == 1 && ev_sel > 0x6) ||
+	    (ctr == 2 && ev_sel != 0x4) || ctr == 3)
+		return 0;
+
+	if (box->pmu->pmu_idx == 0)
+		reg1->reg = NHMEX_B0_MSR_MATCH;
+	else
+		reg1->reg = NHMEX_B1_MSR_MATCH;
+	reg1->idx = 0;
+	reg1->config = event->attr.config1;
+	reg2->config = event->attr.config2;
+	return 0;
+}
+
+static void nhmex_bbox_msr_enable_event(struct intel_uncore_box *box,
+					struct perf_event *event)
+{
+	struct hw_perf_event *hwc = &event->hw;
+	struct hw_perf_event_extra *reg1 = &hwc->extra_reg;
+	struct hw_perf_event_extra *reg2 = &hwc->branch_reg;
+
+	if (reg1->idx != EXTRA_REG_NONE) {
+		wrmsrl(reg1->reg, reg1->config);
+		wrmsrl(reg1->reg + 1, reg2->config);
+	}
+	wrmsrl(hwc->config_base, NHMEX_PMON_CTL_EN_BIT0 |
+		(hwc->config & NHMEX_B_PMON_CTL_EV_SEL_MASK));
+}
+
+/*
+ * The Bbox has 4 counters, but each counter monitors different events.
+ * Use bits 6-7 in event config to select counter.
+ */
+static struct event_constraint nhmex_uncore_bbox_constraints[] = {
+	EVENT_CONSTRAINT(0 , 1, 0xc0),
+	EVENT_CONSTRAINT(0x40, 2, 0xc0),
+	EVENT_CONSTRAINT(0x80, 4, 0xc0),
+	EVENT_CONSTRAINT(0xc0, 8, 0xc0),
+	EVENT_CONSTRAINT_END,
+};
+
+static struct attribute *nhmex_uncore_bbox_formats_attr[] = {
+	&format_attr_event5.attr,
+	&format_attr_counter.attr,
+	&format_attr_match.attr,
+	&format_attr_mask.attr,
+	NULL,
+};
+
+static struct attribute_group nhmex_uncore_bbox_format_group = {
+	.name = "format",
+	.attrs = nhmex_uncore_bbox_formats_attr,
+};
+
+static struct intel_uncore_type nhmex_uncore_bbox = {
+	.name			= "bbox",
+	.num_counters		= 4,
+	.num_boxes		= 2,
+	.perf_ctr_bits		= 48,
+	.event_ctl		= NHMEX_B0_MSR_PMON_CTL0,
+	.perf_ctr		= NHMEX_B0_MSR_PMON_CTR0,
+	.event_mask		= NHMEX_B_PMON_RAW_EVENT_MASK,
+	.box_ctl		= NHMEX_B0_MSR_PMON_GLOBAL_CTL,
+	.msr_offset		= NHMEX_B_MSR_OFFSET,
+	.pair_ctr_ctl		= 1,
+	.num_shared_regs	= 1,
+	.constraints		= nhmex_uncore_bbox_constraints,
+	.ops			= &nhmex_uncore_ops,
+	.format_group		= &nhmex_uncore_bbox_format_group
+};
+
+static int nhmex_sbox_hw_config(struct intel_uncore_box *box,
+				  struct perf_event *event)
+{
+	struct hw_perf_event_extra *reg1 = &event->hw.extra_reg;
+	struct hw_perf_event_extra *reg2 = &event->hw.branch_reg;
+
+	if (event->attr.config & NHMEX_S_PMON_MM_CFG_EN) {
+		reg1->config = event->attr.config1;
+		reg2->config = event->attr.config2;
+	} else {
+		reg1->config = ~0ULL;
+		reg2->config = ~0ULL;
+	}
+	if (box->pmu->pmu_idx == 0)
+		reg1->reg = NHMEX_S0_MSR_MM_CFG;
+	else
+		reg1->reg = NHMEX_S1_MSR_MM_CFG;
+	reg1->idx = 0;
+	return 0;
+}
+
+static void nhmex_sbox_msr_enable_event(struct intel_uncore_box *box,
+					struct perf_event *event)
+{
+	struct hw_perf_event *hwc = &event->hw;
+	struct hw_perf_event_extra *reg1 = &hwc->extra_reg;
+	struct hw_perf_event_extra *reg2 = &hwc->branch_reg;
+
+	wrmsrl(reg1->reg, 0);
+	if (reg1->config != ~0ULL || reg2->config != ~0ULL) {
+		wrmsrl(reg1->reg + 1, reg1->config);
+		wrmsrl(reg1->reg + 2, reg2->config);
+		wrmsrl(reg1->reg, NHMEX_S_PMON_MM_CFG_EN);
+	}
+	wrmsrl(hwc->config_base, hwc->config | NHMEX_PMON_CTL_EN_BIT22);
+}
+
+static struct attribute *nhmex_uncore_sbox_formats_attr[] = {
+	&format_attr_event.attr,
+	&format_attr_umask.attr,
+	&format_attr_edge.attr,
+	&format_attr_inv.attr,
+	&format_attr_thresh8.attr,
+	&format_attr_mm_cfg.attr,
+	&format_attr_match.attr,
+	&format_attr_mask.attr,
+	NULL,
+};
+
+static struct attribute_group nhmex_uncore_sbox_format_group = {
+	.name = "format",
+	.attrs = nhmex_uncore_sbox_formats_attr,
+};
+
+static struct intel_uncore_type nhmex_uncore_sbox = {
+	.name			= "sbox",
+	.num_counters		= 4,
+	.num_boxes		= 2,
+	.perf_ctr_bits		= 48,
+	.event_ctl		= NHMEX_S0_MSR_PMON_CTL0,
+	.perf_ctr		= NHMEX_S0_MSR_PMON_CTR0,
+	.event_mask		= NHMEX_PMON_RAW_EVENT_MASK,
+	.box_ctl		= NHMEX_S0_MSR_PMON_GLOBAL_CTL,
+	.msr_offset		= NHMEX_S_MSR_OFFSET,
+	.pair_ctr_ctl		= 1,
+	.num_shared_regs	= 1,
+	.ops			= &nhmex_uncore_ops,
+	.format_group		= &nhmex_uncore_sbox_format_group
+};
+
+enum {
+	EXTRA_REG_NHMEX_M_FILTER,
+	EXTRA_REG_NHMEX_M_DSP,
+	EXTRA_REG_NHMEX_M_ISS,
+	EXTRA_REG_NHMEX_M_MAP,
+	EXTRA_REG_NHMEX_M_MSC_THR,
+	EXTRA_REG_NHMEX_M_PGT,
+	EXTRA_REG_NHMEX_M_PLD,
+	EXTRA_REG_NHMEX_M_ZDP_CTL_FVC,
+};
+
+static struct extra_reg nhmex_uncore_mbox_extra_regs[] = {
+	MBOX_INC_SEL_EXTAR_REG(0x0, DSP),
+	MBOX_INC_SEL_EXTAR_REG(0x4, MSC_THR),
+	MBOX_INC_SEL_EXTAR_REG(0x5, MSC_THR),
+	MBOX_INC_SEL_EXTAR_REG(0x9, ISS),
+	/* event 0xa uses two extra registers */
+	MBOX_INC_SEL_EXTAR_REG(0xa, ISS),
+	MBOX_INC_SEL_EXTAR_REG(0xa, PLD),
+	MBOX_INC_SEL_EXTAR_REG(0xb, PLD),
+	MBOX_INC_SEL_EXTAR_REG(0xd, ZDP_CTL_FVC),
+	MBOX_INC_SEL_EXTAR_REG(0xe, ZDP_CTL_FVC),
+	MBOX_INC_SEL_EXTAR_REG(0xf, ZDP_CTL_FVC),
+	MBOX_INC_SEL_EXTAR_REG(0x10, ZDP_CTL_FVC),
+	MBOX_INC_SEL_EXTAR_REG(0x16, PGT),
+	MBOX_SET_FLAG_SEL_EXTRA_REG(0x0, DSP),
+	MBOX_SET_FLAG_SEL_EXTRA_REG(0x1, ISS),
+	MBOX_SET_FLAG_SEL_EXTRA_REG(0x5, PGT),
+	MBOX_SET_FLAG_SEL_EXTRA_REG(0x6, MAP),
+	EVENT_EXTRA_END
+};
+
+static bool nhmex_mbox_get_shared_reg(struct intel_uncore_box *box,
+				      int idx, u64 config)
+{
+	struct intel_uncore_extra_reg *er;
+	unsigned long flags;
+	bool ret = false;
+	u64 mask;
+
+	if (idx < EXTRA_REG_NHMEX_M_ZDP_CTL_FVC) {
+		er = &box->shared_regs[idx];
+		raw_spin_lock_irqsave(&er->lock, flags);
+		if (!atomic_read(&er->ref) || er->config == config) {
+			atomic_inc(&er->ref);
+			er->config = config;
+			ret = true;
+		}
+		raw_spin_unlock_irqrestore(&er->lock, flags);
+		return ret;
+	}
+	/*
+	 * The ZDP_CTL_FVC MSR has 4 sub-fields which are used by
+	 * event FVC0 ~ FVC4 respectively.
+	 */
+	idx -= EXTRA_REG_NHMEX_M_ZDP_CTL_FVC;
+	if (WARN_ON_ONCE(idx >= 4))
+		return false;
+
+	mask = NHMEX_M_PMON_ZDP_CTL_FVC_MASK;
+	er = &box->shared_regs[EXTRA_REG_NHMEX_M_ZDP_CTL_FVC];
+	raw_spin_lock_irqsave(&er->lock, flags);
+	if (__BITS_VALUE(atomic_read(&er->ref), idx, 8))
+		mask |= NHMEX_M_PMON_ZDP_CTL_FVC_EVENT_MASK(idx);
+
+	if (!atomic_read(&er->ref) || !((er->config ^ config) & mask)) {
+		atomic_add(1 << (idx * 8), &er->ref);
+		mask = NHMEX_M_PMON_ZDP_CTL_FVC_MASK |
+			NHMEX_M_PMON_ZDP_CTL_FVC_EVENT_MASK(idx);
+		er->config &= ~mask;
+		er->config |= (config & mask);
+		ret = true;
+	}
+	raw_spin_unlock_irqrestore(&er->lock, flags);
+	return ret;
+}
+
+static void nhmex_mbox_put_shared_reg(struct intel_uncore_box *box, int idx)
+{
+	struct intel_uncore_extra_reg *er;
+
+	if (idx < EXTRA_REG_NHMEX_M_ZDP_CTL_FVC) {
+		er = &box->shared_regs[idx];
+		atomic_dec(&er->ref);
+		return;
+	}
+
+	idx -= EXTRA_REG_NHMEX_M_ZDP_CTL_FVC;
+	er = &box->shared_regs[EXTRA_REG_NHMEX_M_ZDP_CTL_FVC];
+	atomic_sub(1 << (idx * 8), &er->ref);
+}
+
+u64 nhmex_mbox_alter_er(struct perf_event *event, int new_idx, bool modify)
+{
+	struct hw_perf_event *hwc = &event->hw;
+	struct hw_perf_event_extra *reg1 = &hwc->extra_reg;
+	int idx, orig_idx = __BITS_VALUE(reg1->idx, 0, 8);
+	u64 config = reg1->config;
+
+	idx = orig_idx - EXTRA_REG_NHMEX_M_ZDP_CTL_FVC;
+	config &= NHMEX_M_PMON_ZDP_CTL_FVC_EVENT_MASK(idx);
+	if (new_idx > orig_idx) {
+		idx = new_idx - orig_idx;
+		config <<= 3 * idx;
+	} else {
+		idx = orig_idx - new_idx;
+		config >>= 3 * idx;
+	}
+	config |= NHMEX_M_PMON_ZDP_CTL_FVC_MASK & reg1->config;
+	if (modify) {
+		if (new_idx > orig_idx)
+			hwc->config += idx << NHMEX_M_PMON_CTL_INC_SEL_SHIFT;
+		else
+			hwc->config -= idx << NHMEX_M_PMON_CTL_INC_SEL_SHIFT;
+		reg1->config = config;
+		reg1->idx = ~0xff | new_idx;
+	}
+	return config;
+}
+
+static struct event_constraint *
+nhmex_mbox_get_constraint(struct intel_uncore_box *box,
+			  struct perf_event *event)
+{
+	struct hw_perf_event_extra *reg1 = &event->hw.extra_reg;
+	struct hw_perf_event_extra *reg2 = &event->hw.branch_reg;
+	int i, idx[2], alloc = 0;
+	u64 config1 = reg1->config;
+
+	idx[0] = __BITS_VALUE(reg1->idx, 0, 8);
+	idx[1] = __BITS_VALUE(reg1->idx, 1, 8);
+again:
+	for (i = 0; i < 2; i++) {
+		if (box->phys_id >= 0 && (reg1->alloc & (0x1 << i)))
+			idx[i] = 0xff;
+
+		if (idx[i] == 0xff)
+			continue;
+
+		if (!nhmex_mbox_get_shared_reg(box, idx[i],
+				__BITS_VALUE(config1, i, 32)))
+			goto fail;
+		alloc |= (0x1 << i);
+	}
+
+	if (!(box->phys_id >= 0 && reg2->alloc) &&
+	    !nhmex_mbox_get_shared_reg(box, reg2->idx, reg2->config))
+		goto fail;
+
+	if (box->phys_id >= 0) {
+		if (idx[0] != 0xff &&
+		    idx[0] != __BITS_VALUE(reg1->idx, 0, 8))
+			nhmex_mbox_alter_er(event, idx[0], true);
+		reg1->alloc |= alloc;
+		reg2->alloc = 1;
+	}
+	return NULL;
+fail:
+	if (idx[0] != 0xff && !(alloc & 0x1) &&
+	    idx[0] >= EXTRA_REG_NHMEX_M_ZDP_CTL_FVC) {
+		/*
+		 * There are four event selection fields in the ZDP_CTL_FVC
+		 * register, they are for events 0xd ~ 0x10 respectively.
+		 * Try the rest fields if we failed to get the current field.
+		 */
+		BUG_ON(__BITS_VALUE(reg1->idx, 1, 8) != 0xff);
+		idx[0] -= EXTRA_REG_NHMEX_M_ZDP_CTL_FVC;
+		idx[0] = (idx[0] + 1) % 4;
+		idx[0] += EXTRA_REG_NHMEX_M_ZDP_CTL_FVC;
+		if (idx[0] != __BITS_VALUE(reg1->idx, 0, 8)) {
+			config1 = nhmex_mbox_alter_er(event, idx[0], false);
+			goto again;
+		}
+	}
+
+	if (alloc & 0x1)
+		nhmex_mbox_put_shared_reg(box, idx[0]);
+	if (alloc & 0x2)
+		nhmex_mbox_put_shared_reg(box, idx[1]);
+	return &constraint_empty;
+}
+
+static void nhmex_mbox_put_constraint(struct intel_uncore_box *box,
+				struct perf_event *event)
+{
+	struct hw_perf_event_extra *reg1 = &event->hw.extra_reg;
+	struct hw_perf_event_extra *reg2 = &event->hw.branch_reg;
+
+	if (box->phys_id < 0)
+		return;
+
+	if (reg1->alloc & 0x1)
+		nhmex_mbox_put_shared_reg(box, __BITS_VALUE(reg1->idx, 0, 8));
+	if (reg1->alloc & 0x2)
+		nhmex_mbox_put_shared_reg(box, __BITS_VALUE(reg1->idx, 1, 8));
+	reg1->alloc = 0;
+
+	if (reg2->alloc) {
+		nhmex_mbox_put_shared_reg(box, reg2->idx);
+		reg2->alloc = 0;
+	}
+}
+
+static int nhmex_mbox_extra_reg_idx(struct extra_reg *er)
+{
+
+	if (er->idx < EXTRA_REG_NHMEX_M_ZDP_CTL_FVC)
+		return er->idx;
+	return er->idx + (er->event >> NHMEX_M_PMON_CTL_INC_SEL_SHIFT) - 0xd;
+}
+
+static int nhmex_mbox_hw_config(struct intel_uncore_box *box,
+				struct perf_event *event)
+{
+	struct intel_uncore_type *type = box->pmu->type;
+	struct hw_perf_event_extra *reg1 = &event->hw.extra_reg;
+	struct hw_perf_event_extra *reg2 = &event->hw.branch_reg;
+	struct extra_reg *er;
+	unsigned msr;
+	int reg_idx = 0;
+
+	if (WARN_ON_ONCE(reg1->idx != -1))
+		return -EINVAL;
+	/*
+	 * The mbox events may require 2 extra MSRs at the most. But only
+	 * the lower 32 bits in these MSRs are significant, so we can use
+	 * config1 to pass two MSRs' config.
+	 */
+	for (er = nhmex_uncore_mbox_extra_regs; er->msr; er++) {
+		if (er->event != (event->hw.config & er->config_mask))
+			continue;
+		if (event->attr.config1 & ~er->valid_mask)
+			return -EINVAL;
+		if (er->idx == __BITS_VALUE(reg1->idx, 0, 8) ||
+		    er->idx == __BITS_VALUE(reg1->idx, 1, 8))
+			continue;
+		if (WARN_ON_ONCE(reg_idx >= 2))
+			return -EINVAL;
+
+		msr = er->msr + type->msr_offset * box->pmu->pmu_idx;
+		if (WARN_ON_ONCE(msr >= 0xffff || er->idx >= 0xff))
+			return -EINVAL;
+
+		/* always use the 32~63 bits to pass the PLD config */
+		if (er->idx == EXTRA_REG_NHMEX_M_PLD)
+			reg_idx = 1;
+
+		reg1->idx &= ~(0xff << (reg_idx * 8));
+		reg1->reg &= ~(0xffff << (reg_idx * 16));
+		reg1->idx |= nhmex_mbox_extra_reg_idx(er) << (reg_idx * 8);
+		reg1->reg |= msr << (reg_idx * 16);
+		reg1->config = event->attr.config1;
+		reg_idx++;
+	}
+
+	reg2->idx = EXTRA_REG_NHMEX_M_FILTER;
+	if (event->attr.config2 & NHMEX_M_PMON_MM_CFG_EN)
+		reg2->config = event->attr.config2;
+	else
+		reg2->config = ~0ULL;
+	if (box->pmu->pmu_idx == 0)
+		reg2->reg = NHMEX_M0_MSR_PMU_MM_CFG;
+	else
+		reg2->reg = NHMEX_M1_MSR_PMU_MM_CFG;
+	return 0;
+}
+
+static u64 nhmex_mbox_shared_reg_config(struct intel_uncore_box *box, int idx)
+{
+	struct intel_uncore_extra_reg *er;
+	unsigned long flags;
+	u64 config;
+
+	if (idx < EXTRA_REG_NHMEX_M_ZDP_CTL_FVC)
+		er = &box->shared_regs[idx];
+	else
+		er = &box->shared_regs[EXTRA_REG_NHMEX_M_ZDP_CTL_FVC];
+
+	raw_spin_lock_irqsave(&er->lock, flags);
+	config = er->config;
+	raw_spin_unlock_irqrestore(&er->lock, flags);
+
+	return config;
+}
+
+static void nhmex_mbox_msr_enable_event(struct intel_uncore_box *box,
+					  struct perf_event *event)
+{
+	struct hw_perf_event *hwc = &event->hw;
+	struct hw_perf_event_extra *reg1 = &hwc->extra_reg;
+	struct hw_perf_event_extra *reg2 = &hwc->branch_reg;
+	int idx;
+
+	idx = __BITS_VALUE(reg1->idx, 0, 8);
+	if (idx != 0xff)
+		wrmsrl(__BITS_VALUE(reg1->reg, 0, 16),
+			nhmex_mbox_shared_reg_config(box, idx));
+	idx = __BITS_VALUE(reg1->idx, 1, 8);
+	if (idx != 0xff)
+		wrmsrl(__BITS_VALUE(reg1->reg, 1, 16),
+			nhmex_mbox_shared_reg_config(box, idx));
+
+	wrmsrl(reg2->reg, 0);
+	if (reg2->config != ~0ULL) {
+		wrmsrl(reg2->reg + 1,
+			reg2->config & NHMEX_M_PMON_ADDR_MATCH_MASK);
+		wrmsrl(reg2->reg + 2, NHMEX_M_PMON_ADDR_MASK_MASK &
+			(reg2->config >> NHMEX_M_PMON_ADDR_MASK_SHIFT));
+		wrmsrl(reg2->reg, NHMEX_M_PMON_MM_CFG_EN);
+	}
+
+	wrmsrl(hwc->config_base, hwc->config | NHMEX_PMON_CTL_EN_BIT0);
+}
+
+DEFINE_UNCORE_FORMAT_ATTR(count_mode, count_mode, "config:2-3");
+DEFINE_UNCORE_FORMAT_ATTR(storage_mode, storage_mode, "config:4-5");
+DEFINE_UNCORE_FORMAT_ATTR(wrap_mode, wrap_mode, "config:6");
+DEFINE_UNCORE_FORMAT_ATTR(flag_mode, flag_mode, "config:7");
+DEFINE_UNCORE_FORMAT_ATTR(inc_sel, inc_sel, "config:9-13");
+DEFINE_UNCORE_FORMAT_ATTR(set_flag_sel, set_flag_sel, "config:19-21");
+DEFINE_UNCORE_FORMAT_ATTR(filter_cfg, filter_cfg, "config2:63");
+DEFINE_UNCORE_FORMAT_ATTR(filter_match, filter_match, "config2:0-33");
+DEFINE_UNCORE_FORMAT_ATTR(filter_mask, filter_mask, "config2:34-61");
+DEFINE_UNCORE_FORMAT_ATTR(dsp, dsp, "config1:0-31");
+DEFINE_UNCORE_FORMAT_ATTR(thr, thr, "config1:0-31");
+DEFINE_UNCORE_FORMAT_ATTR(fvc, fvc, "config1:0-31");
+DEFINE_UNCORE_FORMAT_ATTR(pgt, pgt, "config1:0-31");
+DEFINE_UNCORE_FORMAT_ATTR(map, map, "config1:0-31");
+DEFINE_UNCORE_FORMAT_ATTR(iss, iss, "config1:0-31");
+DEFINE_UNCORE_FORMAT_ATTR(pld, pld, "config1:32-63");
+
+static struct attribute *nhmex_uncore_mbox_formats_attr[] = {
+	&format_attr_count_mode.attr,
+	&format_attr_storage_mode.attr,
+	&format_attr_wrap_mode.attr,
+	&format_attr_flag_mode.attr,
+	&format_attr_inc_sel.attr,
+	&format_attr_set_flag_sel.attr,
+	&format_attr_filter_cfg.attr,
+	&format_attr_filter_match.attr,
+	&format_attr_filter_mask.attr,
+	&format_attr_dsp.attr,
+	&format_attr_thr.attr,
+	&format_attr_fvc.attr,
+	&format_attr_pgt.attr,
+	&format_attr_map.attr,
+	&format_attr_iss.attr,
+	&format_attr_pld.attr,
+	NULL,
+};
+
+static struct attribute_group nhmex_uncore_mbox_format_group = {
+	.name = "format",
+	.attrs = nhmex_uncore_mbox_formats_attr,
+};
+
+static struct uncore_event_desc nhmex_uncore_mbox_events[] = {
+	INTEL_UNCORE_EVENT_DESC(bbox_cmds_read, "inc_sel=0xd,fvc=0x2800"),
+	INTEL_UNCORE_EVENT_DESC(bbox_cmds_write, "inc_sel=0xd,fvc=0x2820"),
+	{ /* end: all zeroes */ },
+};
+
+static struct intel_uncore_type nhmex_uncore_mbox = {
+	.name			= "mbox",
+	.num_counters		= 6,
+	.num_boxes		= 2,
+	.perf_ctr_bits		= 48,
+	.event_ctl		= NHMEX_M0_MSR_PMU_CTL0,
+	.perf_ctr		= NHMEX_M0_MSR_PMU_CNT0,
+	.event_mask		= NHMEX_M_PMON_RAW_EVENT_MASK,
+	.box_ctl		= NHMEX_M0_MSR_GLOBAL_CTL,
+	.msr_offset		= NHMEX_M_MSR_OFFSET,
+	.pair_ctr_ctl		= 1,
+	.num_shared_regs	= 8,
+	.event_descs		= nhmex_uncore_mbox_events,
+	.ops			= &nhmex_uncore_ops,
+	.format_group		= &nhmex_uncore_mbox_format_group,
+};
+
+void nhmex_rbox_alter_er(struct intel_uncore_box *box,
+			struct perf_event *event)
+{
+	struct hw_perf_event *hwc = &event->hw;
+	struct hw_perf_event_extra *reg1 = &hwc->extra_reg;
+	int port;
+
+	if (reg1->idx % 2) {
+		reg1->idx--;
+		hwc->config -= 1 << NHMEX_R_PMON_CTL_EV_SEL_SHIFT;
+	} else {
+		reg1->idx++;
+		hwc->config += 1 << NHMEX_R_PMON_CTL_EV_SEL_SHIFT;
+	}
+
+	port = reg1->idx / 6 + box->pmu->pmu_idx * 4;
+	switch (reg1->idx % 6) {
+	case 0:
+		reg1->reg = NHMEX_R_MSR_PORTN_IPERF_CFG0(port);
+		break;
+	case 1:
+		reg1->reg = NHMEX_R_MSR_PORTN_IPERF_CFG1(port);
+		break;
+	case 2:
+		reg1->config >>= 8;
+		break;
+	case 3:
+		reg1->config <<= 8;
+		break;
+	case 4:
+		reg1->reg = NHMEX_R_MSR_PORTN_XBR_SET1_MM_CFG(port);
+		break;
+	case 5:
+		reg1->reg = NHMEX_R_MSR_PORTN_XBR_SET2_MM_CFG(port);
+		break;
+	};
+}
+
+/*
+ * Each rbox has 4 event set which monitor PQI port 0~3 or 4~7.
+ * An event set consists of 6 events, the third and fourth events
+ * in an event set use the same extra register.
+ */
+static struct event_constraint *
+nhmex_rbox_get_constraint(struct intel_uncore_box *box,
+			  struct perf_event *event)
+{
+	struct hw_perf_event *hwc = &event->hw;
+	struct hw_perf_event_extra *reg1 = &hwc->extra_reg;
+	struct hw_perf_event_extra *reg2 = &hwc->branch_reg;
+	struct intel_uncore_extra_reg *er;
+	unsigned long flags;
+	int idx, er_idx;
+	u64 config1;
+	bool ok = false;
+
+	if (box->phys_id >= 0 && reg1->alloc)
+		return NULL;
+
+	idx = reg1->idx % 6;
+	config1 = reg1->config;
+again:
+	er_idx = idx;
+	if (er_idx > 2)
+		er_idx--;
+	er_idx += (reg1->idx / 6) * 5;
+
+	er = &box->shared_regs[er_idx];
+	raw_spin_lock_irqsave(&er->lock, flags);
+	if (idx < 2) {
+		if (!atomic_read(&er->ref) || er->config == reg1->config) {
+			atomic_inc(&er->ref);
+			er->config = reg1->config;
+			ok = true;
+		}
+	} else if (idx == 2 || idx == 3) {
+		/* use the same extra register, but different fields */
+		u64 mask = 0xff << ((idx - 2) * 8);
+		if (!__BITS_VALUE(atomic_read(&er->ref), idx - 2, 8) ||
+				!((er->config ^ config1) & mask)) {
+			atomic_add(1 << ((idx - 2) * 8), &er->ref);
+			er->config &= ~mask;
+			er->config |= config1 & mask;
+			ok = true;
+		}
+	} else {
+		if (!atomic_read(&er->ref) ||
+				(er->config == (hwc->config >> 32) &&
+				 er->config1 == reg1->config &&
+				 er->config2 == reg2->config)) {
+			atomic_inc(&er->ref);
+			er->config = (hwc->config >> 32);
+			er->config1 = reg1->config;
+			er->config2 = reg2->config;
+			ok = true;
+		}
+	}
+	raw_spin_unlock_irqrestore(&er->lock, flags);
+
+	if (!ok) {
+		/*
+		 * The Rbox events and shared registers are always in pairs.
+		 * Check the other register if we failed to get the current
+		 * one.
+		 */
+		if (idx % 2)
+			idx--;
+		else
+			idx++;
+		if (idx != reg1->idx % 6) {
+			if (idx == 2)
+				config1 >>= 8;
+			else if (idx == 3)
+				config1 <<= 8;
+			goto again;
+		}
+	} else {
+		if (box->phys_id >= 0) {
+			if (idx != reg1->idx % 6)
+				nhmex_rbox_alter_er(box, event);
+			reg1->alloc = 1;
+		}
+		return NULL;
+	}
+	return &constraint_empty;
+}
+
+static void nhmex_rbox_put_constraint(struct intel_uncore_box *box,
+				      struct perf_event *event)
+{
+	struct intel_uncore_extra_reg *er;
+	struct hw_perf_event_extra *reg1 = &event->hw.extra_reg;
+	int idx, er_idx;
+
+	if (box->phys_id < 0 || !reg1->alloc)
+		return;
+
+	idx = reg1->idx % 6;
+	er_idx = idx;
+	if (er_idx > 2)
+		er_idx--;
+	er_idx += (reg1->idx / 6) * 5;
+
+	er = &box->shared_regs[er_idx];
+	if (idx == 2 || idx == 3)
+		atomic_sub(1 << ((idx - 2) * 8), &er->ref);
+	else
+		atomic_dec(&er->ref);
+
+	reg1->alloc = 0;
+}
+
+static int nhmex_rbox_hw_config(struct intel_uncore_box *box,
+				struct perf_event *event)
+{
+	struct hw_perf_event *hwc = &event->hw;
+	struct hw_perf_event_extra *reg1 = &event->hw.extra_reg;
+	struct hw_perf_event_extra *reg2 = &event->hw.branch_reg;
+	int port, idx;
+
+	idx = (event->hw.config & NHMEX_R_PMON_CTL_EV_SEL_MASK) >>
+		NHMEX_R_PMON_CTL_EV_SEL_SHIFT;
+	if (idx >= 0x18)
+		return -EINVAL;
+
+	reg1->idx = idx;
+	reg1->config = event->attr.config1;
+
+	port = idx / 6 + box->pmu->pmu_idx * 4;
+	idx %= 6;
+	switch (idx) {
+	case 0:
+		reg1->reg = NHMEX_R_MSR_PORTN_IPERF_CFG0(port);
+		break;
+	case 1:
+		reg1->reg = NHMEX_R_MSR_PORTN_IPERF_CFG1(port);
+		break;
+	case 2:
+	case 3:
+		reg1->reg = NHMEX_R_MSR_PORTN_QLX_CFG(port);
+		break;
+	case 4:
+	case 5:
+		if (idx == 4)
+			reg1->reg = NHMEX_R_MSR_PORTN_XBR_SET1_MM_CFG(port);
+		else
+			reg1->reg = NHMEX_R_MSR_PORTN_XBR_SET2_MM_CFG(port);
+		reg2->config = event->attr.config2;
+		hwc->config |= event->attr.config & (~0ULL << 32);
+		break;
+	};
+	return 0;
+}
+
+static u64 nhmex_rbox_shared_reg_config(struct intel_uncore_box *box, int idx)
+{
+	struct intel_uncore_extra_reg *er;
+	unsigned long flags;
+	u64 config;
+
+	er = &box->shared_regs[idx];
+	raw_spin_lock_irqsave(&er->lock, flags);
+	config = er->config;
+	raw_spin_unlock_irqrestore(&er->lock, flags);
+	return config;
+}
+
+static void nhmex_rbox_msr_enable_event(struct intel_uncore_box *box,
+					  struct perf_event *event)
+{
+	struct hw_perf_event *hwc = &event->hw;
+	struct hw_perf_event_extra *reg1 = &hwc->extra_reg;
+	struct hw_perf_event_extra *reg2 = &hwc->branch_reg;
+	int idx, er_idx;
+
+	idx = reg1->idx % 6;
+	er_idx = idx;
+	if (er_idx > 2)
+		er_idx--;
+	er_idx += (reg1->idx / 6) * 5;
+
+	switch (idx) {
+	case 0:
+	case 1:
+		wrmsrl(reg1->reg, reg1->config);
+		break;
+	case 2:
+	case 3:
+		wrmsrl(reg1->reg, nhmex_rbox_shared_reg_config(box, er_idx));
+		break;
+	case 4:
+	case 5:
+		wrmsrl(reg1->reg, reg1->config);
+		wrmsrl(reg1->reg + 1, hwc->config >> 32);
+		wrmsrl(reg1->reg + 2, reg2->config);
+		break;
+	};
+
+	wrmsrl(hwc->config_base, NHMEX_PMON_CTL_EN_BIT0 |
+		(hwc->config & NHMEX_R_PMON_CTL_EV_SEL_MASK));
+}
+
+DEFINE_UNCORE_FORMAT_ATTR(xbr_match, xbr_match, "config:32-63");
+DEFINE_UNCORE_FORMAT_ATTR(xbr_mm_cfg, xbr_mm_cfg, "config1:0-63");
+DEFINE_UNCORE_FORMAT_ATTR(xbr_mask, xbr_mask, "config2:0-63");
+DEFINE_UNCORE_FORMAT_ATTR(qlx_cfg, qlx_cfg, "config1:0-15");
+DEFINE_UNCORE_FORMAT_ATTR(iperf_cfg, iperf_cfg, "config1:0-31");
+
+static struct attribute *nhmex_uncore_rbox_formats_attr[] = {
+	&format_attr_event5.attr,
+	&format_attr_xbr_mm_cfg.attr,
+	&format_attr_xbr_match.attr,
+	&format_attr_xbr_mask.attr,
+	&format_attr_qlx_cfg.attr,
+	&format_attr_iperf_cfg.attr,
+	NULL,
+};
+
+static struct attribute_group nhmex_uncore_rbox_format_group = {
+	.name = "format",
+	.attrs = nhmex_uncore_rbox_formats_attr,
+};
+
+static struct uncore_event_desc nhmex_uncore_rbox_events[] = {
+	INTEL_UNCORE_EVENT_DESC(qpi0_flit_send,
+				"event=0x0,iperf_cfg=0x80000000"),
+	INTEL_UNCORE_EVENT_DESC(qpi1_filt_send,
+				"event=0x6,iperf_cfg=0x80000000"),
+	INTEL_UNCORE_EVENT_DESC(qpi0_idle_filt,
+				"event=0x0,iperf_cfg=0x40000000"),
+	INTEL_UNCORE_EVENT_DESC(qpi1_idle_filt,
+				"event=0x6,iperf_cfg=0x40000000"),
+	INTEL_UNCORE_EVENT_DESC(qpi0_date_response,
+				"event=0x0,iperf_cfg=0xc4"),
+	INTEL_UNCORE_EVENT_DESC(qpi1_date_response,
+				"event=0x6,iperf_cfg=0xc4"),
+	{ /* end: all zeroes */ },
+};
+
+static struct intel_uncore_type nhmex_uncore_rbox = {
+	.name			= "rbox",
+	.num_counters		= 8,
+	.num_boxes		= 2,
+	.perf_ctr_bits		= 48,
+	.event_ctl		= NHMEX_R_MSR_PMON_CTL0,
+	.perf_ctr		= NHMEX_R_MSR_PMON_CNT0,
+	.event_mask		= NHMEX_R_PMON_RAW_EVENT_MASK,
+	.box_ctl		= NHMEX_R_MSR_GLOBAL_CTL,
+	.msr_offset		= NHMEX_R_MSR_OFFSET,
+	.pair_ctr_ctl		= 1,
+	.num_shared_regs	= 20,
+	.event_descs		= nhmex_uncore_rbox_events,
+	.ops			= &nhmex_uncore_ops,
+	.format_group		= &nhmex_uncore_rbox_format_group
+};
+
+static void nhmex_uncore_msr_init_box(struct intel_uncore_box *box)
+{
+	wrmsrl(NHMEX_U_MSR_PMON_GLOBAL_CTL, NHMEX_U_PMON_GLOBAL_EN_ALL);
+}
+
+static void nhmex_uncore_msr_disable_box(struct intel_uncore_box *box)
+{
+	unsigned msr = uncore_msr_box_ctl(box);
+	u64 config;
+	if (msr) {
+		rdmsrl(msr, config);
+		config &= ~((1ULL << uncore_num_counters(box)) - 1);
+		/* WBox has a fixed counter */
+		if (uncore_msr_fixed_ctl(box))
+			config &= ~NHMEX_W_PMON_GLOBAL_FIXED_EN;
+		wrmsrl(msr, config);
+	}
+}
+
+static void nhmex_uncore_msr_enable_box(struct intel_uncore_box *box)
+{
+	unsigned msr = uncore_msr_box_ctl(box);
+	u64 config;
+	if (msr) {
+		rdmsrl(msr, config);
+		config |= (1ULL << uncore_num_counters(box)) - 1;
+		/* WBox has a fixed counter */
+		if (uncore_msr_fixed_ctl(box))
+			config |= NHMEX_W_PMON_GLOBAL_FIXED_EN;
+		wrmsrl(msr, config);
+	}
+}
+
+static void nhmex_uncore_msr_disable_event(struct intel_uncore_box *box,
+					struct perf_event *event)
+{
+	wrmsrl(event->hw.config_base, 0);
+}
+
+static void nhmex_uncore_msr_enable_event(struct intel_uncore_box *box,
+					  struct perf_event *event)
+{
+	struct hw_perf_event *hwc = &event->hw;
+
+	if (box->pmu->type == &nhmex_uncore_bbox)
+		nhmex_bbox_msr_enable_event(box, event);
+	else if (box->pmu->type == &nhmex_uncore_sbox)
+		nhmex_sbox_msr_enable_event(box, event);
+	else if (box->pmu->type == &nhmex_uncore_mbox)
+		nhmex_mbox_msr_enable_event(box, event);
+	else if (box->pmu->type == &nhmex_uncore_rbox)
+		nhmex_rbox_msr_enable_event(box, event);
+	else if (hwc->idx >= UNCORE_PMC_IDX_FIXED)
+		wrmsrl(hwc->config_base, NHMEX_PMON_CTL_EN_BIT0);
+	else if (box->pmu->type->event_mask & NHMEX_PMON_CTL_EN_BIT0)
+		wrmsrl(hwc->config_base, hwc->config | NHMEX_PMON_CTL_EN_BIT22);
+	else
+		wrmsrl(hwc->config_base, hwc->config | NHMEX_PMON_CTL_EN_BIT0);
+}
+
+static struct event_constraint *
+nhmex_uncore_get_constraint(struct intel_uncore_box *box,
+			    struct perf_event *event)
+{
+	if (box->pmu->type == &nhmex_uncore_bbox ||
+	    box->pmu->type == &nhmex_uncore_sbox)
+		return uncore_get_constraint(box, event);
+	if (box->pmu->type == &nhmex_uncore_mbox)
+		return nhmex_mbox_get_constraint(box, event);
+	if (box->pmu->type == &nhmex_uncore_rbox)
+		return nhmex_rbox_get_constraint(box, event);
+	return NULL;
+}
+
+static void nhmex_uncore_put_constraint(struct intel_uncore_box *box,
+					struct perf_event *event)
+{
+	if (box->pmu->type == &nhmex_uncore_bbox ||
+	    box->pmu->type == &nhmex_uncore_sbox)
+		uncore_put_constraint(box, event);
+	else if (box->pmu->type == &nhmex_uncore_mbox)
+		nhmex_mbox_put_constraint(box, event);
+	else if (box->pmu->type == &nhmex_uncore_rbox)
+		nhmex_rbox_put_constraint(box, event);
+}
+
+static int nhmex_uncore_hw_config(struct intel_uncore_box *box,
+				  struct perf_event *event)
+{
+	if (box->pmu->type == &nhmex_uncore_bbox)
+		return nhmex_bbox_hw_config(box, event);
+	if (box->pmu->type == &nhmex_uncore_sbox)
+		return nhmex_sbox_hw_config(box, event);
+	if (box->pmu->type == &nhmex_uncore_mbox)
+		return nhmex_mbox_hw_config(box, event);
+	if (box->pmu->type == &nhmex_uncore_rbox)
+		return nhmex_rbox_hw_config(box, event);
+	return 0;
+}
+
+static struct intel_uncore_ops nhmex_uncore_ops = {
+	.init_box	= nhmex_uncore_msr_init_box,
+	.disable_box	= nhmex_uncore_msr_disable_box,
+	.enable_box	= nhmex_uncore_msr_enable_box,
+	.disable_event	= nhmex_uncore_msr_disable_event,
+	.enable_event	= nhmex_uncore_msr_enable_event,
+	.read_counter	= uncore_msr_read_counter,
+	.hw_config	= nhmex_uncore_hw_config,
+	.get_constraint = nhmex_uncore_get_constraint,
+	.put_constraint = nhmex_uncore_put_constraint,
+};
+
+static struct intel_uncore_type *nhmex_msr_uncores[] = {
+	&nhmex_uncore_ubox,
+	&nhmex_uncore_cbox,
+	&nhmex_uncore_bbox,
+	&nhmex_uncore_sbox,
+	&nhmex_uncore_mbox,
+	&nhmex_uncore_rbox,
+	&nhmex_uncore_wbox,
+	NULL,
+};
+/* end of Nehalem-EX uncore support */
+
 static void uncore_assign_hw_event(struct intel_uncore_box *box,
 				struct perf_event *event, int idx)
 {
@@ -1257,6 +2293,11 @@ int uncore_pmu_event_init(struct perf_event *event)
 	event->hw.last_tag = ~0ULL;
 	event->hw.extra_reg.idx = EXTRA_REG_NONE;
 
+	event->hw.idx = -1;
+	event->hw.last_tag = ~0ULL;
+	event->hw.extra_reg.idx = -1;
+	BUG_ON(event->hw.extra_reg.alloc);
+
 	if (event->attr.config == UNCORE_FIXED_EVENT) {
 		/* no fixed counter */
 		if (!pmu->type->fixed_ctl)
@@ -1767,6 +2808,9 @@ static int __init uncore_cpu_init(void)
 			snbep_uncore_cbox.num_boxes = max_cores;
 		msr_uncores = snbep_msr_uncores;
 		break;
+	case 46:
+		msr_uncores = nhmex_msr_uncores;
+		break;
 	default:
 		return 0;
 	}
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.h b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
index b13e9ea..5757f56 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.h
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
@@ -5,8 +5,6 @@
 #include "perf_event.h"
 
 #define UNCORE_PMU_NAME_LEN		32
-#define UNCORE_BOX_HASH_SIZE		8
-
 #define UNCORE_PMU_HRTIMER_INTERVAL	(60 * NSEC_PER_SEC)
 
 #define UNCORE_FIXED_EVENT		0xff
@@ -158,6 +156,190 @@
 #define SNBEP_PCU_MSR_CORE_C3_CTR		0x3fc
 #define SNBEP_PCU_MSR_CORE_C6_CTR		0x3fd
 
+/* NHM-EX event control */
+#define NHMEX_PMON_CTL_EV_SEL_MASK	0x000000ff
+#define NHMEX_PMON_CTL_UMASK_MASK	0x0000ff00
+#define NHMEX_PMON_CTL_EN_BIT0		(1 << 0)
+#define NHMEX_PMON_CTL_EDGE_DET		(1 << 18)
+#define NHMEX_PMON_CTL_PMI_EN		(1 << 20)
+#define NHMEX_PMON_CTL_EN_BIT22		(1 << 22)
+#define NHMEX_PMON_CTL_INVERT		(1 << 23)
+#define NHMEX_PMON_CTL_TRESH_MASK	0xff000000
+#define NHMEX_PMON_RAW_EVENT_MASK	(NHMEX_PMON_CTL_EV_SEL_MASK | \
+					 NHMEX_PMON_CTL_UMASK_MASK | \
+					 NHMEX_PMON_CTL_EDGE_DET | \
+					 NHMEX_PMON_CTL_INVERT | \
+					 NHMEX_PMON_CTL_TRESH_MASK)
+
+/* NHM-EX Ubox */
+#define NHMEX_U_MSR_PMON_GLOBAL_CTL		0xc00
+#define NHMEX_U_MSR_PMON_CTR			0xc11
+#define NHMEX_U_MSR_PMON_EV_SEL			0xc10
+
+#define NHMEX_U_PMON_GLOBAL_EN			(1 << 0)
+#define NHMEX_U_PMON_GLOBAL_PMI_CORE_SEL	0x0000001e
+#define NHMEX_U_PMON_GLOBAL_EN_ALL		(1 << 28)
+#define NHMEX_U_PMON_GLOBAL_RST_ALL		(1 << 29)
+#define NHMEX_U_PMON_GLOBAL_FRZ_ALL		(1 << 31)
+
+#define NHMEX_U_PMON_RAW_EVENT_MASK		\
+		(NHMEX_PMON_CTL_EV_SEL_MASK |	\
+		 NHMEX_PMON_CTL_EDGE_DET)
+
+/* NHM-EX Cbox */
+#define NHMEX_C0_MSR_PMON_GLOBAL_CTL		0xd00
+#define NHMEX_C0_MSR_PMON_CTR0			0xd11
+#define NHMEX_C0_MSR_PMON_EV_SEL0		0xd10
+#define NHMEX_C_MSR_OFFSET			0x20
+
+/* NHM-EX Bbox */
+#define NHMEX_B0_MSR_PMON_GLOBAL_CTL		0xc20
+#define NHMEX_B0_MSR_PMON_CTR0			0xc31
+#define NHMEX_B0_MSR_PMON_CTL0			0xc30
+#define NHMEX_B_MSR_OFFSET			0x40
+#define NHMEX_B0_MSR_MATCH			0xe45
+#define NHMEX_B0_MSR_MASK			0xe46
+#define NHMEX_B1_MSR_MATCH			0xe4d
+#define NHMEX_B1_MSR_MASK			0xe4e
+
+#define NHMEX_B_PMON_CTL_EN			(1 << 0)
+#define NHMEX_B_PMON_CTL_EV_SEL_SHIFT		1
+#define NHMEX_B_PMON_CTL_EV_SEL_MASK		\
+		(0x1f << NHMEX_B_PMON_CTL_EV_SEL_SHIFT)
+#define NHMEX_B_PMON_CTR_SHIFT		6
+#define NHMEX_B_PMON_CTR_MASK		\
+		(0x3 << NHMEX_B_PMON_CTR_SHIFT)
+#define NHMEX_B_PMON_RAW_EVENT_MASK		\
+		(NHMEX_B_PMON_CTL_EV_SEL_MASK | \
+		 NHMEX_B_PMON_CTR_MASK)
+
+/* NHM-EX Sbox */
+#define NHMEX_S0_MSR_PMON_GLOBAL_CTL		0xc40
+#define NHMEX_S0_MSR_PMON_CTR0			0xc51
+#define NHMEX_S0_MSR_PMON_CTL0			0xc50
+#define NHMEX_S_MSR_OFFSET			0x80
+#define NHMEX_S0_MSR_MM_CFG			0xe48
+#define NHMEX_S0_MSR_MATCH			0xe49
+#define NHMEX_S0_MSR_MASK			0xe4a
+#define NHMEX_S1_MSR_MM_CFG			0xe58
+#define NHMEX_S1_MSR_MATCH			0xe59
+#define NHMEX_S1_MSR_MASK			0xe5a
+
+#define NHMEX_S_PMON_MM_CFG_EN			(0x1ULL << 63)
+
+/* NHM-EX Mbox */
+#define NHMEX_M0_MSR_GLOBAL_CTL			0xca0
+#define NHMEX_M0_MSR_PMU_DSP			0xca5
+#define NHMEX_M0_MSR_PMU_ISS			0xca6
+#define NHMEX_M0_MSR_PMU_MAP			0xca7
+#define NHMEX_M0_MSR_PMU_MSC_THR		0xca8
+#define NHMEX_M0_MSR_PMU_PGT			0xca9
+#define NHMEX_M0_MSR_PMU_PLD			0xcaa
+#define NHMEX_M0_MSR_PMU_ZDP_CTL_FVC		0xcab
+#define NHMEX_M0_MSR_PMU_CTL0			0xcb0
+#define NHMEX_M0_MSR_PMU_CNT0			0xcb1
+#define NHMEX_M_MSR_OFFSET			0x40
+#define NHMEX_M0_MSR_PMU_MM_CFG			0xe54
+#define NHMEX_M1_MSR_PMU_MM_CFG			0xe5c
+
+#define NHMEX_M_PMON_MM_CFG_EN			(1ULL << 63)
+#define NHMEX_M_PMON_ADDR_MATCH_MASK		0x3ffffffffULL
+#define NHMEX_M_PMON_ADDR_MASK_MASK		0x7ffffffULL
+#define NHMEX_M_PMON_ADDR_MASK_SHIFT		34
+
+#define NHMEX_M_PMON_CTL_EN			(1 << 0)
+#define NHMEX_M_PMON_CTL_PMI_EN			(1 << 1)
+#define NHMEX_M_PMON_CTL_COUNT_MODE_SHIFT	2
+#define NHMEX_M_PMON_CTL_COUNT_MODE_MASK	\
+	(0x3 << NHMEX_M_PMON_CTL_COUNT_MODE_SHIFT)
+#define NHMEX_M_PMON_CTL_STORAGE_MODE_SHIFT	4
+#define NHMEX_M_PMON_CTL_STORAGE_MODE_MASK	\
+	(0x3 << NHMEX_M_PMON_CTL_STORAGE_MODE_SHIFT)
+#define NHMEX_M_PMON_CTL_WRAP_MODE		(1 << 6)
+#define NHMEX_M_PMON_CTL_FLAG_MODE		(1 << 7)
+#define NHMEX_M_PMON_CTL_INC_SEL_SHIFT		9
+#define NHMEX_M_PMON_CTL_INC_SEL_MASK		\
+	(0x1f << NHMEX_M_PMON_CTL_INC_SEL_SHIFT)
+#define NHMEX_M_PMON_CTL_SET_FLAG_SEL_SHIFT	19
+#define NHMEX_M_PMON_CTL_SET_FLAG_SEL_MASK	\
+	(0x7 << NHMEX_M_PMON_CTL_SET_FLAG_SEL_SHIFT)
+#define NHMEX_M_PMON_RAW_EVENT_MASK			\
+		(NHMEX_M_PMON_CTL_COUNT_MODE_MASK |	\
+		 NHMEX_M_PMON_CTL_STORAGE_MODE_MASK |	\
+		 NHMEX_M_PMON_CTL_WRAP_MODE |		\
+		 NHMEX_M_PMON_CTL_FLAG_MODE |		\
+		 NHMEX_M_PMON_CTL_INC_SEL_MASK |	\
+		 NHMEX_M_PMON_CTL_SET_FLAG_SEL_MASK)
+
+
+#define NHMEX_M_PMON_ZDP_CTL_FVC_FVID_MASK	0x1f
+#define NHMEX_M_PMON_ZDP_CTL_FVC_BCMD_MASK	(0x7 << 5)
+#define NHMEX_M_PMON_ZDP_CTL_FVC_RSP_MASK	(0x7 << 8)
+#define NHMEX_M_PMON_ZDP_CTL_FVC_PBOX_INIT_ERR	(1 << 23)
+#define NHMEX_M_PMON_ZDP_CTL_FVC_MASK			\
+		(NHMEX_M_PMON_ZDP_CTL_FVC_FVID_MASK |	\
+		 NHMEX_M_PMON_ZDP_CTL_FVC_BCMD_MASK |	\
+		 NHMEX_M_PMON_ZDP_CTL_FVC_RSP_MASK  |	\
+		 NHMEX_M_PMON_ZDP_CTL_FVC_PBOX_INIT_ERR)
+#define NHMEX_M_PMON_ZDP_CTL_FVC_EVENT_MASK(n)	(0x7 << (11 + 3 * (n)))
+
+
+#define MBOX_INC_SEL(x) ((x) << NHMEX_M_PMON_CTL_INC_SEL_SHIFT)
+#define MBOX_SET_FLAG_SEL(x) (((x) << NHMEX_M_PMON_CTL_SET_FLAG_SEL_SHIFT) | \
+				NHMEX_M_PMON_CTL_FLAG_MODE)
+#define MBOX_INC_SEL_MASK (NHMEX_M_PMON_CTL_INC_SEL_MASK | \
+			   NHMEX_M_PMON_CTL_FLAG_MODE)
+#define MBOX_SET_FLAG_SEL_MASK (NHMEX_M_PMON_CTL_SET_FLAG_SEL_MASK | \
+				NHMEX_M_PMON_CTL_FLAG_MODE)
+#define MBOX_INC_SEL_EXTAR_REG(c, r) \
+		EVENT_EXTRA_REG(MBOX_INC_SEL(c), NHMEX_M0_MSR_PMU_##r, \
+				MBOX_INC_SEL_MASK, (u64)-1, NHMEX_M_##r)
+#define MBOX_SET_FLAG_SEL_EXTRA_REG(c, r) \
+		EVENT_EXTRA_REG(MBOX_SET_FLAG_SEL(c), NHMEX_M0_MSR_PMU_##r, \
+				MBOX_SET_FLAG_SEL_MASK, \
+				(u64)-1, NHMEX_M_##r)
+
+/* NHM-EX Rbox */
+#define NHMEX_R_MSR_GLOBAL_CTL			0xe00
+#define NHMEX_R_MSR_PMON_CTL0			0xe10
+#define NHMEX_R_MSR_PMON_CNT0			0xe11
+#define NHMEX_R_MSR_OFFSET			0x20
+
+#define NHMEX_R_MSR_PORTN_QLX_CFG(n)		\
+		((n) < 4 ? (0xe0c + (n)) : (0xe2c + (n) - 4))
+#define NHMEX_R_MSR_PORTN_IPERF_CFG0(n)		(0xe04 + (n))
+#define NHMEX_R_MSR_PORTN_IPERF_CFG1(n)		(0xe24 + (n))
+#define NHMEX_R_MSR_PORTN_XBR_OFFSET(n)		\
+		(((n) < 4 ? 0 : 0x10) + (n) * 4)
+#define NHMEX_R_MSR_PORTN_XBR_SET1_MM_CFG(n)	\
+		(0xe60 + NHMEX_R_MSR_PORTN_XBR_OFFSET(n))
+#define NHMEX_R_MSR_PORTN_XBR_SET1_MATCH(n)	\
+		(NHMEX_R_MSR_PORTN_XBR_SET1_MM_CFG(n) + 1)
+#define NHMEX_R_MSR_PORTN_XBR_SET1_MASK(n)	\
+		(NHMEX_R_MSR_PORTN_XBR_SET1_MM_CFG(n) + 2)
+#define NHMEX_R_MSR_PORTN_XBR_SET2_MM_CFG(n)	\
+		(0xe70 + NHMEX_R_MSR_PORTN_XBR_OFFSET(n))
+#define NHMEX_R_MSR_PORTN_XBR_SET2_MATCH(n)	\
+		(NHMEX_R_MSR_PORTN_XBR_SET2_MM_CFG(n) + 1)
+#define NHMEX_R_MSR_PORTN_XBR_SET2_MASK(n)	\
+		(NHMEX_R_MSR_PORTN_XBR_SET2_MM_CFG(n) + 2)
+
+#define NHMEX_R_PMON_CTL_EN			(1 << 0)
+#define NHMEX_R_PMON_CTL_EV_SEL_SHIFT		1
+#define NHMEX_R_PMON_CTL_EV_SEL_MASK		\
+		(0x1f << NHMEX_R_PMON_CTL_EV_SEL_SHIFT)
+#define NHMEX_R_PMON_CTL_PMI_EN			(1 << 6)
+#define NHMEX_R_PMON_RAW_EVENT_MASK		NHMEX_R_PMON_CTL_EV_SEL_MASK
+
+/* NHM-EX Wbox */
+#define NHMEX_W_MSR_GLOBAL_CTL			0xc80
+#define NHMEX_W_MSR_PMON_CNT0			0xc90
+#define NHMEX_W_MSR_PMON_EVT_SEL0		0xc91
+#define NHMEX_W_MSR_PMON_FIXED_CTR		0x394
+#define NHMEX_W_MSR_PMON_FIXED_CTL		0x395
+
+#define NHMEX_W_PMON_GLOBAL_FIXED_EN		(1ULL << 31)
+
 struct intel_uncore_ops;
 struct intel_uncore_pmu;
 struct intel_uncore_box;
@@ -178,6 +360,7 @@ struct intel_uncore_type {
 	unsigned msr_offset;
 	unsigned num_shared_regs:8;
 	unsigned single_fixed:1;
+	unsigned pair_ctr_ctl:1;
 	struct event_constraint unconstrainted;
 	struct event_constraint *constraints;
 	struct intel_uncore_pmu *pmus;
@@ -213,7 +396,7 @@ struct intel_uncore_pmu {
 
 struct intel_uncore_extra_reg {
 	raw_spinlock_t lock;
-	u64 config1;
+	u64 config, config1, config2;
 	atomic_t ref;
 };
 
@@ -323,14 +506,16 @@ unsigned uncore_msr_fixed_ctr(struct intel_uncore_box *box)
 static inline
 unsigned uncore_msr_event_ctl(struct intel_uncore_box *box, int idx)
 {
-	return idx + box->pmu->type->event_ctl +
+	return box->pmu->type->event_ctl +
+		(box->pmu->type->pair_ctr_ctl ? 2 * idx : idx) +
 		box->pmu->type->msr_offset * box->pmu->pmu_idx;
 }
 
 static inline
 unsigned uncore_msr_perf_ctr(struct intel_uncore_box *box, int idx)
 {
-	return idx + box->pmu->type->perf_ctr +
+	return box->pmu->type->perf_ctr +
+		(box->pmu->type->pair_ctr_ctl ? 2 * idx : idx) +
 		box->pmu->type->msr_offset * box->pmu->pmu_idx;
 }
 
-- 
1.7.10.4

