Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903Ab2HTJI3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 05:08:29 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:36563 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754700Ab2HTJI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 05:08:26 -0400
Date: Mon, 20 Aug 2012 11:08:19 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20120820090819.GA8047@gmail.com>
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

   HEAD: 26a4f3c08de49c1437a7b7f97693cf22d8c31656 perf/x86: disable PEBS on a guest entry.

 Thanks,

	Ingo

------------------>
Borislav Petkov (1):
      perf, x86: Fix uncore_types_exit section mismatch

Gleb Natapov (1):
      perf/x86: disable PEBS on a guest entry.

Yan, Zheng (2):
      perf/x86: Fixes for Nehalem-EX uncore driver
      perf/x86: Add Intel Westmere-EX uncore support


 arch/x86/kernel/cpu/perf_event_intel.c        |  10 +-
 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 253 ++++++++++++++------------
 arch/x86/kernel/cpu/perf_event_intel_uncore.h |  46 +++--
 3 files changed, 165 insertions(+), 144 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 3823669..7f2739e 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1522,8 +1522,16 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr)
 	arr[0].msr = MSR_CORE_PERF_GLOBAL_CTRL;
 	arr[0].host = x86_pmu.intel_ctrl & ~cpuc->intel_ctrl_guest_mask;
 	arr[0].guest = x86_pmu.intel_ctrl & ~cpuc->intel_ctrl_host_mask;
+	/*
+	 * If PMU counter has PEBS enabled it is not enough to disable counter
+	 * on a guest entry since PEBS memory write can overshoot guest entry
+	 * and corrupt guest memory. Disabling PEBS solves the problem.
+	 */
+	arr[1].msr = MSR_IA32_PEBS_ENABLE;
+	arr[1].host = cpuc->pebs_enabled;
+	arr[1].guest = 0;
 
-	*nr = 1;
+	*nr = 2;
 	return arr;
 }
 
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 7563fda..0a55710 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -796,7 +796,6 @@ static struct intel_uncore_type *nhm_msr_uncores[] = {
 
 DEFINE_UNCORE_FORMAT_ATTR(event5, event, "config:1-5");
 DEFINE_UNCORE_FORMAT_ATTR(counter, counter, "config:6-7");
-DEFINE_UNCORE_FORMAT_ATTR(mm_cfg, mm_cfg, "config:63");
 DEFINE_UNCORE_FORMAT_ATTR(match, match, "config1:0-63");
 DEFINE_UNCORE_FORMAT_ATTR(mask, mask, "config2:0-63");
 
@@ -902,16 +901,21 @@ static struct attribute_group nhmex_uncore_cbox_format_group = {
 	.attrs = nhmex_uncore_cbox_formats_attr,
 };
 
+/* msr offset for each instance of cbox */
+static unsigned nhmex_cbox_msr_offsets[] = {
+	0x0, 0x80, 0x40, 0xc0, 0x20, 0xa0, 0x60, 0xe0, 0x240, 0x2c0,
+};
+
 static struct intel_uncore_type nhmex_uncore_cbox = {
 	.name			= "cbox",
 	.num_counters		= 6,
-	.num_boxes		= 8,
+	.num_boxes		= 10,
 	.perf_ctr_bits		= 48,
 	.event_ctl		= NHMEX_C0_MSR_PMON_EV_SEL0,
 	.perf_ctr		= NHMEX_C0_MSR_PMON_CTR0,
 	.event_mask		= NHMEX_PMON_RAW_EVENT_MASK,
 	.box_ctl		= NHMEX_C0_MSR_PMON_GLOBAL_CTL,
-	.msr_offset		= NHMEX_C_MSR_OFFSET,
+	.msr_offsets		= nhmex_cbox_msr_offsets,
 	.pair_ctr_ctl		= 1,
 	.ops			= &nhmex_uncore_ops,
 	.format_group		= &nhmex_uncore_cbox_format_group
@@ -1032,24 +1036,22 @@ static struct intel_uncore_type nhmex_uncore_bbox = {
 
 static int nhmex_sbox_hw_config(struct intel_uncore_box *box, struct perf_event *event)
 {
-	struct hw_perf_event_extra *reg1 = &event->hw.extra_reg;
-	struct hw_perf_event_extra *reg2 = &event->hw.branch_reg;
+	struct hw_perf_event *hwc = &event->hw;
+	struct hw_perf_event_extra *reg1 = &hwc->extra_reg;
+	struct hw_perf_event_extra *reg2 = &hwc->branch_reg;
 
-	if (event->attr.config & NHMEX_S_PMON_MM_CFG_EN) {
-		reg1->config = event->attr.config1;
-		reg2->config = event->attr.config2;
-	} else {
-		reg1->config = ~0ULL;
-		reg2->config = ~0ULL;
-	}
+	/* only TO_R_PROG_EV event uses the match/mask register */
+	if ((hwc->config & NHMEX_PMON_CTL_EV_SEL_MASK) !=
+	    NHMEX_S_EVENT_TO_R_PROG_EV)
+		return 0;
 
 	if (box->pmu->pmu_idx == 0)
 		reg1->reg = NHMEX_S0_MSR_MM_CFG;
 	else
 		reg1->reg = NHMEX_S1_MSR_MM_CFG;
-
 	reg1->idx = 0;
-
+	reg1->config = event->attr.config1;
+	reg2->config = event->attr.config2;
 	return 0;
 }
 
@@ -1059,8 +1061,8 @@ static void nhmex_sbox_msr_enable_event(struct intel_uncore_box *box, struct per
 	struct hw_perf_event_extra *reg1 = &hwc->extra_reg;
 	struct hw_perf_event_extra *reg2 = &hwc->branch_reg;
 
-	wrmsrl(reg1->reg, 0);
-	if (reg1->config != ~0ULL || reg2->config != ~0ULL) {
+	if (reg1->idx != EXTRA_REG_NONE) {
+		wrmsrl(reg1->reg, 0);
 		wrmsrl(reg1->reg + 1, reg1->config);
 		wrmsrl(reg1->reg + 2, reg2->config);
 		wrmsrl(reg1->reg, NHMEX_S_PMON_MM_CFG_EN);
@@ -1074,7 +1076,6 @@ static struct attribute *nhmex_uncore_sbox_formats_attr[] = {
 	&format_attr_edge.attr,
 	&format_attr_inv.attr,
 	&format_attr_thresh8.attr,
-	&format_attr_mm_cfg.attr,
 	&format_attr_match.attr,
 	&format_attr_mask.attr,
 	NULL,
@@ -1142,6 +1143,9 @@ static struct extra_reg nhmex_uncore_mbox_extra_regs[] = {
 	EVENT_EXTRA_END
 };
 
+/* Nehalem-EX or Westmere-EX ? */
+bool uncore_nhmex;
+
 static bool nhmex_mbox_get_shared_reg(struct intel_uncore_box *box, int idx, u64 config)
 {
 	struct intel_uncore_extra_reg *er;
@@ -1171,18 +1175,29 @@ static bool nhmex_mbox_get_shared_reg(struct intel_uncore_box *box, int idx, u64
 		return false;
 
 	/* mask of the shared fields */
-	mask = NHMEX_M_PMON_ZDP_CTL_FVC_MASK;
+	if (uncore_nhmex)
+		mask = NHMEX_M_PMON_ZDP_CTL_FVC_MASK;
+	else
+		mask = WSMEX_M_PMON_ZDP_CTL_FVC_MASK;
 	er = &box->shared_regs[EXTRA_REG_NHMEX_M_ZDP_CTL_FVC];
 
 	raw_spin_lock_irqsave(&er->lock, flags);
 	/* add mask of the non-shared field if it's in use */
-	if (__BITS_VALUE(atomic_read(&er->ref), idx, 8))
-		mask |= NHMEX_M_PMON_ZDP_CTL_FVC_EVENT_MASK(idx);
+	if (__BITS_VALUE(atomic_read(&er->ref), idx, 8)) {
+		if (uncore_nhmex)
+			mask |= NHMEX_M_PMON_ZDP_CTL_FVC_EVENT_MASK(idx);
+		else
+			mask |= WSMEX_M_PMON_ZDP_CTL_FVC_EVENT_MASK(idx);
+	}
 
 	if (!atomic_read(&er->ref) || !((er->config ^ config) & mask)) {
 		atomic_add(1 << (idx * 8), &er->ref);
-		mask = NHMEX_M_PMON_ZDP_CTL_FVC_MASK |
-			NHMEX_M_PMON_ZDP_CTL_FVC_EVENT_MASK(idx);
+		if (uncore_nhmex)
+			mask = NHMEX_M_PMON_ZDP_CTL_FVC_MASK |
+				NHMEX_M_PMON_ZDP_CTL_FVC_EVENT_MASK(idx);
+		else
+			mask = WSMEX_M_PMON_ZDP_CTL_FVC_MASK |
+				WSMEX_M_PMON_ZDP_CTL_FVC_EVENT_MASK(idx);
 		er->config &= ~mask;
 		er->config |= (config & mask);
 		ret = true;
@@ -1216,7 +1231,10 @@ u64 nhmex_mbox_alter_er(struct perf_event *event, int new_idx, bool modify)
 
 	/* get the non-shared control bits and shift them */
 	idx = orig_idx - EXTRA_REG_NHMEX_M_ZDP_CTL_FVC;
-	config &= NHMEX_M_PMON_ZDP_CTL_FVC_EVENT_MASK(idx);
+	if (uncore_nhmex)
+		config &= NHMEX_M_PMON_ZDP_CTL_FVC_EVENT_MASK(idx);
+	else
+		config &= WSMEX_M_PMON_ZDP_CTL_FVC_EVENT_MASK(idx);
 	if (new_idx > orig_idx) {
 		idx = new_idx - orig_idx;
 		config <<= 3 * idx;
@@ -1226,6 +1244,10 @@ u64 nhmex_mbox_alter_er(struct perf_event *event, int new_idx, bool modify)
 	}
 
 	/* add the shared control bits back */
+	if (uncore_nhmex)
+		config |= NHMEX_M_PMON_ZDP_CTL_FVC_MASK & reg1->config;
+	else
+		config |= WSMEX_M_PMON_ZDP_CTL_FVC_MASK & reg1->config;
 	config |= NHMEX_M_PMON_ZDP_CTL_FVC_MASK & reg1->config;
 	if (modify) {
 		/* adjust the main event selector */
@@ -1264,7 +1286,8 @@ again:
 	}
 
 	/* for the match/mask registers */
-	if ((uncore_box_is_fake(box) || !reg2->alloc) &&
+	if (reg2->idx != EXTRA_REG_NONE &&
+	    (uncore_box_is_fake(box) || !reg2->alloc) &&
 	    !nhmex_mbox_get_shared_reg(box, reg2->idx, reg2->config))
 		goto fail;
 
@@ -1278,7 +1301,8 @@ again:
 		if (idx[0] != 0xff && idx[0] != __BITS_VALUE(reg1->idx, 0, 8))
 			nhmex_mbox_alter_er(event, idx[0], true);
 		reg1->alloc |= alloc;
-		reg2->alloc = 1;
+		if (reg2->idx != EXTRA_REG_NONE)
+			reg2->alloc = 1;
 	}
 	return NULL;
 fail:
@@ -1342,9 +1366,6 @@ static int nhmex_mbox_hw_config(struct intel_uncore_box *box, struct perf_event
 	struct extra_reg *er;
 	unsigned msr;
 	int reg_idx = 0;
-
-	if (WARN_ON_ONCE(reg1->idx != -1))
-		return -EINVAL;
 	/*
 	 * The mbox events may require 2 extra MSRs at the most. But only
 	 * the lower 32 bits in these MSRs are significant, so we can use
@@ -1355,11 +1376,6 @@ static int nhmex_mbox_hw_config(struct intel_uncore_box *box, struct perf_event
 			continue;
 		if (event->attr.config1 & ~er->valid_mask)
 			return -EINVAL;
-		if (er->idx == __BITS_VALUE(reg1->idx, 0, 8) ||
-		    er->idx == __BITS_VALUE(reg1->idx, 1, 8))
-			continue;
-		if (WARN_ON_ONCE(reg_idx >= 2))
-			return -EINVAL;
 
 		msr = er->msr + type->msr_offset * box->pmu->pmu_idx;
 		if (WARN_ON_ONCE(msr >= 0xffff || er->idx >= 0xff))
@@ -1368,6 +1384,8 @@ static int nhmex_mbox_hw_config(struct intel_uncore_box *box, struct perf_event
 		/* always use the 32~63 bits to pass the PLD config */
 		if (er->idx == EXTRA_REG_NHMEX_M_PLD)
 			reg_idx = 1;
+		else if (WARN_ON_ONCE(reg_idx > 0))
+			return -EINVAL;
 
 		reg1->idx &= ~(0xff << (reg_idx * 8));
 		reg1->reg &= ~(0xffff << (reg_idx * 16));
@@ -1376,17 +1394,21 @@ static int nhmex_mbox_hw_config(struct intel_uncore_box *box, struct perf_event
 		reg1->config = event->attr.config1;
 		reg_idx++;
 	}
-	/* use config2 to pass the filter config */
-	reg2->idx = EXTRA_REG_NHMEX_M_FILTER;
-	if (event->attr.config2 & NHMEX_M_PMON_MM_CFG_EN)
-		reg2->config = event->attr.config2;
-	else
-		reg2->config = ~0ULL;
-	if (box->pmu->pmu_idx == 0)
-		reg2->reg = NHMEX_M0_MSR_PMU_MM_CFG;
-	else
-		reg2->reg = NHMEX_M1_MSR_PMU_MM_CFG;
-
+	/*
+	 * The mbox only provides ability to perform address matching
+	 * for the PLD events.
+	 */
+	if (reg_idx == 2) {
+		reg2->idx = EXTRA_REG_NHMEX_M_FILTER;
+		if (event->attr.config2 & NHMEX_M_PMON_MM_CFG_EN)
+			reg2->config = event->attr.config2;
+		else
+			reg2->config = ~0ULL;
+		if (box->pmu->pmu_idx == 0)
+			reg2->reg = NHMEX_M0_MSR_PMU_MM_CFG;
+		else
+			reg2->reg = NHMEX_M1_MSR_PMU_MM_CFG;
+	}
 	return 0;
 }
 
@@ -1422,34 +1444,36 @@ static void nhmex_mbox_msr_enable_event(struct intel_uncore_box *box, struct per
 		wrmsrl(__BITS_VALUE(reg1->reg, 1, 16),
 			nhmex_mbox_shared_reg_config(box, idx));
 
-	wrmsrl(reg2->reg, 0);
-	if (reg2->config != ~0ULL) {
-		wrmsrl(reg2->reg + 1,
-			reg2->config & NHMEX_M_PMON_ADDR_MATCH_MASK);
-		wrmsrl(reg2->reg + 2, NHMEX_M_PMON_ADDR_MASK_MASK &
-			(reg2->config >> NHMEX_M_PMON_ADDR_MASK_SHIFT));
-		wrmsrl(reg2->reg, NHMEX_M_PMON_MM_CFG_EN);
+	if (reg2->idx != EXTRA_REG_NONE) {
+		wrmsrl(reg2->reg, 0);
+		if (reg2->config != ~0ULL) {
+			wrmsrl(reg2->reg + 1,
+				reg2->config & NHMEX_M_PMON_ADDR_MATCH_MASK);
+			wrmsrl(reg2->reg + 2, NHMEX_M_PMON_ADDR_MASK_MASK &
+				(reg2->config >> NHMEX_M_PMON_ADDR_MASK_SHIFT));
+			wrmsrl(reg2->reg, NHMEX_M_PMON_MM_CFG_EN);
+		}
 	}
 
 	wrmsrl(hwc->config_base, hwc->config | NHMEX_PMON_CTL_EN_BIT0);
 }
 
-DEFINE_UNCORE_FORMAT_ATTR(count_mode,	count_mode,	"config:2-3");
-DEFINE_UNCORE_FORMAT_ATTR(storage_mode, storage_mode,	"config:4-5");
-DEFINE_UNCORE_FORMAT_ATTR(wrap_mode,	wrap_mode,	"config:6");
-DEFINE_UNCORE_FORMAT_ATTR(flag_mode,	flag_mode,	"config:7");
-DEFINE_UNCORE_FORMAT_ATTR(inc_sel,	inc_sel,	"config:9-13");
-DEFINE_UNCORE_FORMAT_ATTR(set_flag_sel,	set_flag_sel,	"config:19-21");
-DEFINE_UNCORE_FORMAT_ATTR(filter_cfg,	filter_cfg,	"config2:63");
-DEFINE_UNCORE_FORMAT_ATTR(filter_match,	filter_match,	"config2:0-33");
-DEFINE_UNCORE_FORMAT_ATTR(filter_mask,	filter_mask,	"config2:34-61");
-DEFINE_UNCORE_FORMAT_ATTR(dsp,		dsp,		"config1:0-31");
-DEFINE_UNCORE_FORMAT_ATTR(thr,		thr,		"config1:0-31");
-DEFINE_UNCORE_FORMAT_ATTR(fvc,		fvc,		"config1:0-31");
-DEFINE_UNCORE_FORMAT_ATTR(pgt,		pgt,		"config1:0-31");
-DEFINE_UNCORE_FORMAT_ATTR(map,		map,		"config1:0-31");
-DEFINE_UNCORE_FORMAT_ATTR(iss,		iss,		"config1:0-31");
-DEFINE_UNCORE_FORMAT_ATTR(pld,		pld,		"config1:32-63");
+DEFINE_UNCORE_FORMAT_ATTR(count_mode,		count_mode,	"config:2-3");
+DEFINE_UNCORE_FORMAT_ATTR(storage_mode,		storage_mode,	"config:4-5");
+DEFINE_UNCORE_FORMAT_ATTR(wrap_mode,		wrap_mode,	"config:6");
+DEFINE_UNCORE_FORMAT_ATTR(flag_mode,		flag_mode,	"config:7");
+DEFINE_UNCORE_FORMAT_ATTR(inc_sel,		inc_sel,	"config:9-13");
+DEFINE_UNCORE_FORMAT_ATTR(set_flag_sel,		set_flag_sel,	"config:19-21");
+DEFINE_UNCORE_FORMAT_ATTR(filter_cfg_en,	filter_cfg_en,	"config2:63");
+DEFINE_UNCORE_FORMAT_ATTR(filter_match,		filter_match,	"config2:0-33");
+DEFINE_UNCORE_FORMAT_ATTR(filter_mask,		filter_mask,	"config2:34-61");
+DEFINE_UNCORE_FORMAT_ATTR(dsp,			dsp,		"config1:0-31");
+DEFINE_UNCORE_FORMAT_ATTR(thr,			thr,		"config1:0-31");
+DEFINE_UNCORE_FORMAT_ATTR(fvc,			fvc,		"config1:0-31");
+DEFINE_UNCORE_FORMAT_ATTR(pgt,			pgt,		"config1:0-31");
+DEFINE_UNCORE_FORMAT_ATTR(map,			map,		"config1:0-31");
+DEFINE_UNCORE_FORMAT_ATTR(iss,			iss,		"config1:0-31");
+DEFINE_UNCORE_FORMAT_ATTR(pld,			pld,		"config1:32-63");
 
 static struct attribute *nhmex_uncore_mbox_formats_attr[] = {
 	&format_attr_count_mode.attr,
@@ -1458,7 +1482,7 @@ static struct attribute *nhmex_uncore_mbox_formats_attr[] = {
 	&format_attr_flag_mode.attr,
 	&format_attr_inc_sel.attr,
 	&format_attr_set_flag_sel.attr,
-	&format_attr_filter_cfg.attr,
+	&format_attr_filter_cfg_en.attr,
 	&format_attr_filter_match.attr,
 	&format_attr_filter_mask.attr,
 	&format_attr_dsp.attr,
@@ -1482,6 +1506,12 @@ static struct uncore_event_desc nhmex_uncore_mbox_events[] = {
 	{ /* end: all zeroes */ },
 };
 
+static struct uncore_event_desc wsmex_uncore_mbox_events[] = {
+	INTEL_UNCORE_EVENT_DESC(bbox_cmds_read, "inc_sel=0xd,fvc=0x5000"),
+	INTEL_UNCORE_EVENT_DESC(bbox_cmds_write, "inc_sel=0xd,fvc=0x5040"),
+	{ /* end: all zeroes */ },
+};
+
 static struct intel_uncore_ops nhmex_uncore_mbox_ops = {
 	NHMEX_UNCORE_OPS_COMMON_INIT(),
 	.enable_event	= nhmex_mbox_msr_enable_event,
@@ -1513,7 +1543,7 @@ void nhmex_rbox_alter_er(struct intel_uncore_box *box, struct perf_event *event)
 	struct hw_perf_event_extra *reg1 = &hwc->extra_reg;
 	int port;
 
-	/* adjust the main event selector */
+	/* adjust the main event selector and extra register index */
 	if (reg1->idx % 2) {
 		reg1->idx--;
 		hwc->config -= 1 << NHMEX_R_PMON_CTL_EV_SEL_SHIFT;
@@ -1522,29 +1552,17 @@ void nhmex_rbox_alter_er(struct intel_uncore_box *box, struct perf_event *event)
 		hwc->config += 1 << NHMEX_R_PMON_CTL_EV_SEL_SHIFT;
 	}
 
-	/* adjust address or config of extra register */
+	/* adjust extra register config */
 	port = reg1->idx / 6 + box->pmu->pmu_idx * 4;
 	switch (reg1->idx % 6) {
-	case 0:
-		reg1->reg = NHMEX_R_MSR_PORTN_IPERF_CFG0(port);
-		break;
-	case 1:
-		reg1->reg = NHMEX_R_MSR_PORTN_IPERF_CFG1(port);
-		break;
 	case 2:
-		/* the 8~15 bits to the 0~7 bits */
+		/* shift the 8~15 bits to the 0~7 bits */
 		reg1->config >>= 8;
 		break;
 	case 3:
-		/* the 0~7 bits to the 8~15 bits */
+		/* shift the 0~7 bits to the 8~15 bits */
 		reg1->config <<= 8;
 		break;
-	case 4:
-		reg1->reg = NHMEX_R_MSR_PORTN_XBR_SET1_MM_CFG(port);
-		break;
-	case 5:
-		reg1->reg = NHMEX_R_MSR_PORTN_XBR_SET2_MM_CFG(port);
-		break;
 	};
 }
 
@@ -1671,7 +1689,7 @@ static int nhmex_rbox_hw_config(struct intel_uncore_box *box, struct perf_event
 	struct hw_perf_event *hwc = &event->hw;
 	struct hw_perf_event_extra *reg1 = &event->hw.extra_reg;
 	struct hw_perf_event_extra *reg2 = &event->hw.branch_reg;
-	int port, idx;
+	int idx;
 
 	idx = (event->hw.config & NHMEX_R_PMON_CTL_EV_SEL_MASK) >>
 		NHMEX_R_PMON_CTL_EV_SEL_SHIFT;
@@ -1681,27 +1699,11 @@ static int nhmex_rbox_hw_config(struct intel_uncore_box *box, struct perf_event
 	reg1->idx = idx;
 	reg1->config = event->attr.config1;
 
-	port = idx / 6 + box->pmu->pmu_idx * 4;
-	idx %= 6;
-	switch (idx) {
-	case 0:
-		reg1->reg = NHMEX_R_MSR_PORTN_IPERF_CFG0(port);
-		break;
-	case 1:
-		reg1->reg = NHMEX_R_MSR_PORTN_IPERF_CFG1(port);
-		break;
-	case 2:
-	case 3:
-		reg1->reg = NHMEX_R_MSR_PORTN_QLX_CFG(port);
-		break;
+	switch (idx % 6) {
 	case 4:
 	case 5:
-		if (idx == 4)
-			reg1->reg = NHMEX_R_MSR_PORTN_XBR_SET1_MM_CFG(port);
-		else
-			reg1->reg = NHMEX_R_MSR_PORTN_XBR_SET2_MM_CFG(port);
-		reg2->config = event->attr.config2;
 		hwc->config |= event->attr.config & (~0ULL << 32);
+		reg2->config = event->attr.config2;
 		break;
 	};
 	return 0;
@@ -1727,28 +1729,34 @@ static void nhmex_rbox_msr_enable_event(struct intel_uncore_box *box, struct per
 	struct hw_perf_event *hwc = &event->hw;
 	struct hw_perf_event_extra *reg1 = &hwc->extra_reg;
 	struct hw_perf_event_extra *reg2 = &hwc->branch_reg;
-	int idx, er_idx;
+	int idx, port;
 
-	idx = reg1->idx % 6;
-	er_idx = idx;
-	if (er_idx > 2)
-		er_idx--;
-	er_idx += (reg1->idx / 6) * 5;
+	idx = reg1->idx;
+	port = idx / 6 + box->pmu->pmu_idx * 4;
 
-	switch (idx) {
+	switch (idx % 6) {
 	case 0:
+		wrmsrl(NHMEX_R_MSR_PORTN_IPERF_CFG0(port), reg1->config);
+		break;
 	case 1:
-		wrmsrl(reg1->reg, reg1->config);
+		wrmsrl(NHMEX_R_MSR_PORTN_IPERF_CFG1(port), reg1->config);
 		break;
 	case 2:
 	case 3:
-		wrmsrl(reg1->reg, nhmex_rbox_shared_reg_config(box, er_idx));
+		wrmsrl(NHMEX_R_MSR_PORTN_QLX_CFG(port),
+			nhmex_rbox_shared_reg_config(box, 2 + (idx / 6) * 5));
 		break;
 	case 4:
+		wrmsrl(NHMEX_R_MSR_PORTN_XBR_SET1_MM_CFG(port),
+			hwc->config >> 32);
+		wrmsrl(NHMEX_R_MSR_PORTN_XBR_SET1_MATCH(port), reg1->config);
+		wrmsrl(NHMEX_R_MSR_PORTN_XBR_SET1_MASK(port), reg2->config);
+		break;
 	case 5:
-		wrmsrl(reg1->reg, reg1->config);
-		wrmsrl(reg1->reg + 1, hwc->config >> 32);
-		wrmsrl(reg1->reg + 2, reg2->config);
+		wrmsrl(NHMEX_R_MSR_PORTN_XBR_SET2_MM_CFG(port),
+			hwc->config >> 32);
+		wrmsrl(NHMEX_R_MSR_PORTN_XBR_SET2_MATCH(port), reg1->config);
+		wrmsrl(NHMEX_R_MSR_PORTN_XBR_SET2_MASK(port), reg2->config);
 		break;
 	};
 
@@ -1756,8 +1764,8 @@ static void nhmex_rbox_msr_enable_event(struct intel_uncore_box *box, struct per
 		(hwc->config & NHMEX_R_PMON_CTL_EV_SEL_MASK));
 }
 
-DEFINE_UNCORE_FORMAT_ATTR(xbr_match, xbr_match, "config:32-63");
-DEFINE_UNCORE_FORMAT_ATTR(xbr_mm_cfg, xbr_mm_cfg, "config1:0-63");
+DEFINE_UNCORE_FORMAT_ATTR(xbr_mm_cfg, xbr_mm_cfg, "config:32-63");
+DEFINE_UNCORE_FORMAT_ATTR(xbr_match, xbr_match, "config1:0-63");
 DEFINE_UNCORE_FORMAT_ATTR(xbr_mask, xbr_mask, "config2:0-63");
 DEFINE_UNCORE_FORMAT_ATTR(qlx_cfg, qlx_cfg, "config1:0-15");
 DEFINE_UNCORE_FORMAT_ATTR(iperf_cfg, iperf_cfg, "config1:0-31");
@@ -2303,6 +2311,7 @@ int uncore_pmu_event_init(struct perf_event *event)
 	event->hw.idx = -1;
 	event->hw.last_tag = ~0ULL;
 	event->hw.extra_reg.idx = EXTRA_REG_NONE;
+	event->hw.branch_reg.idx = EXTRA_REG_NONE;
 
 	if (event->attr.config == UNCORE_FIXED_EVENT) {
 		/* no fixed counter */
@@ -2373,7 +2382,7 @@ static void __init uncore_type_exit(struct intel_uncore_type *type)
 	type->attr_groups[1] = NULL;
 }
 
-static void uncore_types_exit(struct intel_uncore_type **types)
+static void __init uncore_types_exit(struct intel_uncore_type **types)
 {
 	int i;
 	for (i = 0; types[i]; i++)
@@ -2814,7 +2823,13 @@ static int __init uncore_cpu_init(void)
 			snbep_uncore_cbox.num_boxes = max_cores;
 		msr_uncores = snbep_msr_uncores;
 		break;
-	case 46:
+	case 46: /* Nehalem-EX */
+		uncore_nhmex = true;
+	case 47: /* Westmere-EX aka. Xeon E7 */
+		if (!uncore_nhmex)
+			nhmex_uncore_mbox.event_descs = wsmex_uncore_mbox_events;
+		if (nhmex_uncore_cbox.num_boxes > max_cores)
+			nhmex_uncore_cbox.num_boxes = max_cores;
 		msr_uncores = nhmex_msr_uncores;
 		break;
 	default:
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.h b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
index c9e5dc5..5b81c18 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.h
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
@@ -230,6 +230,7 @@
 #define NHMEX_S1_MSR_MASK			0xe5a
 
 #define NHMEX_S_PMON_MM_CFG_EN			(0x1ULL << 63)
+#define NHMEX_S_EVENT_TO_R_PROG_EV		0
 
 /* NHM-EX Mbox */
 #define NHMEX_M0_MSR_GLOBAL_CTL			0xca0
@@ -275,18 +276,12 @@
 		 NHMEX_M_PMON_CTL_INC_SEL_MASK |	\
 		 NHMEX_M_PMON_CTL_SET_FLAG_SEL_MASK)
 
-
-#define NHMEX_M_PMON_ZDP_CTL_FVC_FVID_MASK	0x1f
-#define NHMEX_M_PMON_ZDP_CTL_FVC_BCMD_MASK	(0x7 << 5)
-#define NHMEX_M_PMON_ZDP_CTL_FVC_RSP_MASK	(0x7 << 8)
-#define NHMEX_M_PMON_ZDP_CTL_FVC_PBOX_INIT_ERR	(1 << 23)
-#define NHMEX_M_PMON_ZDP_CTL_FVC_MASK			\
-		(NHMEX_M_PMON_ZDP_CTL_FVC_FVID_MASK |	\
-		 NHMEX_M_PMON_ZDP_CTL_FVC_BCMD_MASK |	\
-		 NHMEX_M_PMON_ZDP_CTL_FVC_RSP_MASK  |	\
-		 NHMEX_M_PMON_ZDP_CTL_FVC_PBOX_INIT_ERR)
+#define NHMEX_M_PMON_ZDP_CTL_FVC_MASK		(((1 << 11) - 1) | (1 << 23))
 #define NHMEX_M_PMON_ZDP_CTL_FVC_EVENT_MASK(n)	(0x7 << (11 + 3 * (n)))
 
+#define WSMEX_M_PMON_ZDP_CTL_FVC_MASK		(((1 << 12) - 1) | (1 << 24))
+#define WSMEX_M_PMON_ZDP_CTL_FVC_EVENT_MASK(n)	(0x7 << (12 + 3 * (n)))
+
 /*
  * use the 9~13 bits to select event If the 7th bit is not set,
  * otherwise use the 19~21 bits to select event.
@@ -368,6 +363,7 @@ struct intel_uncore_type {
 	unsigned num_shared_regs:8;
 	unsigned single_fixed:1;
 	unsigned pair_ctr_ctl:1;
+	unsigned *msr_offsets;
 	struct event_constraint unconstrainted;
 	struct event_constraint *constraints;
 	struct intel_uncore_pmu *pmus;
@@ -485,29 +481,31 @@ unsigned uncore_pci_perf_ctr(struct intel_uncore_box *box, int idx)
 	return idx * 8 + box->pmu->type->perf_ctr;
 }
 
-static inline
-unsigned uncore_msr_box_ctl(struct intel_uncore_box *box)
+static inline unsigned uncore_msr_box_offset(struct intel_uncore_box *box)
+{
+	struct intel_uncore_pmu *pmu = box->pmu;
+	return pmu->type->msr_offsets ?
+		pmu->type->msr_offsets[pmu->pmu_idx] :
+		pmu->type->msr_offset * pmu->pmu_idx;
+}
+
+static inline unsigned uncore_msr_box_ctl(struct intel_uncore_box *box)
 {
 	if (!box->pmu->type->box_ctl)
 		return 0;
-	return box->pmu->type->box_ctl +
-		box->pmu->type->msr_offset * box->pmu->pmu_idx;
+	return box->pmu->type->box_ctl + uncore_msr_box_offset(box);
 }
 
-static inline
-unsigned uncore_msr_fixed_ctl(struct intel_uncore_box *box)
+static inline unsigned uncore_msr_fixed_ctl(struct intel_uncore_box *box)
 {
 	if (!box->pmu->type->fixed_ctl)
 		return 0;
-	return box->pmu->type->fixed_ctl +
-		box->pmu->type->msr_offset * box->pmu->pmu_idx;
+	return box->pmu->type->fixed_ctl + uncore_msr_box_offset(box);
 }
 
-static inline
-unsigned uncore_msr_fixed_ctr(struct intel_uncore_box *box)
+static inline unsigned uncore_msr_fixed_ctr(struct intel_uncore_box *box)
 {
-	return box->pmu->type->fixed_ctr +
-		box->pmu->type->msr_offset * box->pmu->pmu_idx;
+	return box->pmu->type->fixed_ctr + uncore_msr_box_offset(box);
 }
 
 static inline
@@ -515,7 +513,7 @@ unsigned uncore_msr_event_ctl(struct intel_uncore_box *box, int idx)
 {
 	return box->pmu->type->event_ctl +
 		(box->pmu->type->pair_ctr_ctl ? 2 * idx : idx) +
-		box->pmu->type->msr_offset * box->pmu->pmu_idx;
+		uncore_msr_box_offset(box);
 }
 
 static inline
@@ -523,7 +521,7 @@ unsigned uncore_msr_perf_ctr(struct intel_uncore_box *box, int idx)
 {
 	return box->pmu->type->perf_ctr +
 		(box->pmu->type->pair_ctr_ctl ? 2 * idx : idx) +
-		box->pmu->type->msr_offset * box->pmu->pmu_idx;
+		uncore_msr_box_offset(box);
 }
 
 static inline
