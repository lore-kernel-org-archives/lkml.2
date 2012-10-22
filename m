Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974Ab2JVGCe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 02:02:34 -0400
Received: from mga14.intel.com ([143.182.124.37]:49420 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752753Ab2JVGCd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 02:02:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,628,1344236400"; 
   d="scan'208";a="207328916"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.n
Cc: eranian@google.com, ak@linux.intel.com,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH] perf/x86: fix SNB-EP CBO and PCU uncore PMU filter management
Date: Mon, 22 Oct 2012 14:02:28 +0800
Message-Id: <1350885748-5981-1-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yan, Zheng" <zheng.z.yan@intel.com>

The existing code assumes all Cbox and PCU events are using
filter, but actually the filter is event specific. Furthermore
the filter is sub-divided into multiple fields which are used
by different events.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
Reported-by: Stephane Eranian <eranian@google.com>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 319 +++++++++++++++++++++-----
 arch/x86/kernel/cpu/perf_event_intel_uncore.h |  13 +-
 2 files changed, 273 insertions(+), 59 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index d4afbeb..1f6a440 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -17,6 +17,9 @@ static struct event_constraint constraint_fixed =
 static struct event_constraint constraint_empty =
 	EVENT_CONSTRAINT(0, 0, 0);
 
+#define __BITS_VALUE(x, i, n)  ((typeof(x))(((x) >> ((i) * (n))) & \
+				((1ULL << (n)) - 1)))
+
 DEFINE_UNCORE_FORMAT_ATTR(event, event, "config:0-7");
 DEFINE_UNCORE_FORMAT_ATTR(event_ext, event, "config:0-7,21");
 DEFINE_UNCORE_FORMAT_ATTR(umask, umask, "config:8-15");
@@ -110,6 +113,21 @@ static void uncore_put_constraint(struct intel_uncore_box *box, struct perf_even
 	reg1->alloc = 0;
 }
 
+static u64 uncore_shared_reg_config(struct intel_uncore_box *box, int idx)
+{
+	struct intel_uncore_extra_reg *er;
+	unsigned long flags;
+	u64 config;
+
+	er = &box->shared_regs[idx];
+
+	raw_spin_lock_irqsave(&er->lock, flags);
+	config = er->config;
+	raw_spin_unlock_irqrestore(&er->lock, flags);
+
+	return config;
+}
+
 /* Sandy Bridge-EP uncore support */
 static struct intel_uncore_type snbep_uncore_cbox;
 static struct intel_uncore_type snbep_uncore_pcu;
@@ -203,7 +221,7 @@ static void snbep_uncore_msr_enable_event(struct intel_uncore_box *box, struct p
 	struct hw_perf_event_extra *reg1 = &hwc->extra_reg;
 
 	if (reg1->idx != EXTRA_REG_NONE)
-		wrmsrl(reg1->reg, reg1->config);
+		wrmsrl(reg1->reg, uncore_shared_reg_config(box, 0));
 
 	wrmsrl(hwc->config_base, hwc->config | SNBEP_PMON_CTL_EN);
 }
@@ -224,29 +242,6 @@ static void snbep_uncore_msr_init_box(struct intel_uncore_box *box)
 		wrmsrl(msr, SNBEP_PMON_BOX_CTL_INT);
 }
 
-static int snbep_uncore_hw_config(struct intel_uncore_box *box, struct perf_event *event)
-{
-	struct hw_perf_event *hwc = &event->hw;
-	struct hw_perf_event_extra *reg1 = &hwc->extra_reg;
-
-	if (box->pmu->type == &snbep_uncore_cbox) {
-		reg1->reg = SNBEP_C0_MSR_PMON_BOX_FILTER +
-			SNBEP_CBO_MSR_OFFSET * box->pmu->pmu_idx;
-		reg1->config = event->attr.config1 &
-			SNBEP_CB0_MSR_PMON_BOX_FILTER_MASK;
-	} else {
-		if (box->pmu->type == &snbep_uncore_pcu) {
-			reg1->reg = SNBEP_PCU_MSR_PMON_BOX_FILTER;
-			reg1->config = event->attr.config1 & SNBEP_PCU_MSR_PMON_BOX_FILTER_MASK;
-		} else {
-			return 0;
-		}
-	}
-	reg1->idx = 0;
-
-	return 0;
-}
-
 static struct attribute *snbep_uncore_formats_attr[] = {
 	&format_attr_event.attr,
 	&format_attr_umask.attr,
@@ -343,16 +338,16 @@ static struct attribute_group snbep_uncore_qpi_format_group = {
 	.attrs = snbep_uncore_qpi_formats_attr,
 };
 
+#define SNBEP_UNCORE_MSR_OPS_COMMON_INIT()			\
+	.init_box	= snbep_uncore_msr_init_box,		\
+	.disable_box	= snbep_uncore_msr_disable_box,		\
+	.enable_box	= snbep_uncore_msr_enable_box,		\
+	.disable_event	= snbep_uncore_msr_disable_event,	\
+	.enable_event	= snbep_uncore_msr_enable_event,	\
+	.read_counter	= uncore_msr_read_counter
+
 static struct intel_uncore_ops snbep_uncore_msr_ops = {
-	.init_box	= snbep_uncore_msr_init_box,
-	.disable_box	= snbep_uncore_msr_disable_box,
-	.enable_box	= snbep_uncore_msr_enable_box,
-	.disable_event	= snbep_uncore_msr_disable_event,
-	.enable_event	= snbep_uncore_msr_enable_event,
-	.read_counter	= uncore_msr_read_counter,
-	.get_constraint = uncore_get_constraint,
-	.put_constraint = uncore_put_constraint,
-	.hw_config	= snbep_uncore_hw_config,
+	SNBEP_UNCORE_MSR_OPS_COMMON_INIT(),
 };
 
 static struct intel_uncore_ops snbep_uncore_pci_ops = {
@@ -444,6 +439,138 @@ static struct intel_uncore_type snbep_uncore_ubox = {
 	.format_group	= &snbep_uncore_ubox_format_group,
 };
 
+static struct extra_reg snbep_uncore_cbox_extra_regs[] = {
+	CBO_EVENT_EXTRA_REG(SNBEP_CBO_PMON_CTL_TID_EN,
+			    SNBEP_CBO_PMON_CTL_TID_EN, 0x1),
+	CBO_EVENT_EXTRA_REG(0x0334, 0xffff, 0x4),
+	CBO_EVENT_EXTRA_REG(0x0534, 0xffff, 0x4),
+	CBO_EVENT_EXTRA_REG(0x0934, 0xffff, 0x4),
+	CBO_EVENT_EXTRA_REG(0x4134, 0xffff, 0x6),
+	CBO_EVENT_EXTRA_REG(0x0135, 0xffff, 0x8),
+	CBO_EVENT_EXTRA_REG(0x0335, 0xffff, 0x8),
+	CBO_EVENT_EXTRA_REG(0x4135, 0xffff, 0xc),
+	CBO_EVENT_EXTRA_REG(0x4335, 0xffff, 0xc),
+	CBO_EVENT_EXTRA_REG(0x4435, 0xffff, 0x2),
+	CBO_EVENT_EXTRA_REG(0x4835, 0xffff, 0x2),
+	CBO_EVENT_EXTRA_REG(0x4a35, 0xffff, 0x2),
+	CBO_EVENT_EXTRA_REG(0x5035, 0xffff, 0x2),
+	CBO_EVENT_EXTRA_REG(0x0136, 0xffff, 0x8),
+	CBO_EVENT_EXTRA_REG(0x0336, 0xffff, 0x8),
+	CBO_EVENT_EXTRA_REG(0x4136, 0xffff, 0xc),
+	CBO_EVENT_EXTRA_REG(0x4336, 0xffff, 0xc),
+	CBO_EVENT_EXTRA_REG(0x4435, 0xffff, 0x2),
+	CBO_EVENT_EXTRA_REG(0x4835, 0xffff, 0x2),
+	CBO_EVENT_EXTRA_REG(0x4a35, 0xffff, 0x2),
+	CBO_EVENT_EXTRA_REG(0x4037, 0x40ff, 0x2),
+	EVENT_EXTRA_END
+};
+
+static u64 snbep_cbox_filter_mask(int fields)
+{
+	u64 mask = 0;
+
+	if (fields & 0x1)
+		mask |= SNBEP_CB0_MSR_PMON_BOX_FILTER_TID;
+	if (fields & 0x2)
+		mask |= SNBEP_CB0_MSR_PMON_BOX_FILTER_NID;
+	if (fields & 0x4)
+		mask |= SNBEP_CB0_MSR_PMON_BOX_FILTER_STATE;
+	if (fields & 0x8)
+		mask |= SNBEP_CB0_MSR_PMON_BOX_FILTER_OPC;
+
+	return mask;
+}
+
+static struct event_constraint *
+snbep_cbox_get_constraint(struct intel_uncore_box *box, struct perf_event *event)
+{
+	struct hw_perf_event_extra *reg1 = &event->hw.extra_reg;
+	struct intel_uncore_extra_reg *er = &box->shared_regs[0];
+	int i, alloc = 0;
+	unsigned long flags;
+	u64 mask;
+
+	if (reg1->idx == EXTRA_REG_NONE)
+		return NULL;
+
+	raw_spin_lock_irqsave(&er->lock, flags);
+	for (i = 0; i < 4; i++) {
+		if (!(reg1->idx & (0x1 << i)))
+			continue;
+		if (!uncore_box_is_fake(box) && (reg1->alloc & (0x1 << i)))
+			continue;
+
+		mask = snbep_cbox_filter_mask(0x1 << i);
+		if (!__BITS_VALUE(atomic_read(&er->ref), i, 8) ||
+		    !((reg1->config ^ er->config) & mask)) {
+			atomic_add(1 << (i * 8), &er->ref);
+			er->config &= ~mask;
+			er->config |= reg1->config & mask;
+			alloc |= (0x1 << i);
+		} else {
+			break;
+		}
+	}
+	raw_spin_unlock_irqrestore(&er->lock, flags);
+	if (i < 4)
+		goto fail;
+
+	if (!uncore_box_is_fake(box))
+		reg1->alloc |= alloc;
+
+	return 0;
+fail:
+	for (; i >= 0; i--) {
+		if (alloc & (0x1 << i))
+			atomic_sub(1 << (i * 8), &er->ref);
+	}
+	return &constraint_empty;
+}
+
+static void snbep_cbox_put_constraint(struct intel_uncore_box *box, struct perf_event *event)
+{
+	struct hw_perf_event_extra *reg1 = &event->hw.extra_reg;
+	struct intel_uncore_extra_reg *er = &box->shared_regs[0];
+	int i;
+
+	if (uncore_box_is_fake(box))
+		return;
+
+	for (i = 0; i < 4; i++) {
+		if (reg1->alloc & (0x1 << i))
+			atomic_sub(1 << (i * 8), &er->ref);
+	}
+	reg1->alloc = 0;
+}
+
+static int snbep_cbox_hw_config(struct intel_uncore_box *box, struct perf_event *event)
+{
+	struct hw_perf_event_extra *reg1 = &event->hw.extra_reg;
+	struct extra_reg *er;
+	int idx = 0;
+
+	for (er = snbep_uncore_cbox_extra_regs; er->msr; er++) {
+		if (er->event != (event->hw.config & er->config_mask))
+			continue;
+		idx |= er->idx;
+	}
+
+	if (idx) {
+		reg1->reg = SNBEP_C0_MSR_PMON_BOX_FILTER +
+			SNBEP_CBO_MSR_OFFSET * box->pmu->pmu_idx;
+		reg1->config = event->attr.config1 & snbep_cbox_filter_mask(idx);
+		reg1->idx = idx;
+	}
+	return 0;
+}
+
+static struct intel_uncore_ops snbep_uncore_cbox_ops = {
+	SNBEP_UNCORE_MSR_OPS_COMMON_INIT(),
+	.hw_config		= snbep_cbox_hw_config,
+	.get_constraint		= snbep_cbox_get_constraint,
+	.put_constraint		= snbep_cbox_put_constraint,
+};
+
 static struct intel_uncore_type snbep_uncore_cbox = {
 	.name			= "cbox",
 	.num_counters		= 4,
@@ -456,10 +583,104 @@ static struct intel_uncore_type snbep_uncore_cbox = {
 	.msr_offset		= SNBEP_CBO_MSR_OFFSET,
 	.num_shared_regs	= 1,
 	.constraints		= snbep_uncore_cbox_constraints,
-	.ops			= &snbep_uncore_msr_ops,
+	.ops			= &snbep_uncore_cbox_ops,
 	.format_group		= &snbep_uncore_cbox_format_group,
 };
 
+static u64 snbep_pcu_alter_er(struct perf_event *event, int new_idx, bool modify)
+{
+	struct hw_perf_event *hwc = &event->hw;
+	struct hw_perf_event_extra *reg1 = &hwc->extra_reg;
+	u64 config = reg1->config;
+
+	if (new_idx > reg1->idx)
+		config <<= 8 * (new_idx - reg1->idx);
+	else
+		config >>= 8 * (reg1->idx - new_idx);
+
+	if (modify) {
+		hwc->config += new_idx - reg1->idx;
+		reg1->config = config;
+		reg1->idx = new_idx;
+	}
+	return config;
+}
+
+static struct event_constraint *
+snbep_pcu_get_constraint(struct intel_uncore_box *box, struct perf_event *event)
+{
+	struct hw_perf_event_extra *reg1 = &event->hw.extra_reg;
+	struct intel_uncore_extra_reg *er = &box->shared_regs[0];
+	unsigned long flags;
+	int idx = reg1->idx;
+	u64 mask, config1 = reg1->config;
+	bool ok = false;
+
+	if (reg1->idx == EXTRA_REG_NONE ||
+	    (!uncore_box_is_fake(box) && reg1->alloc))
+		return NULL;
+again:
+	mask = 0xff << (idx * 8);
+	raw_spin_lock_irqsave(&er->lock, flags);
+	if (!__BITS_VALUE(atomic_read(&er->ref), idx, 8) ||
+	    !((config1 ^ er->config) & mask)) {
+		atomic_add(1 << (idx * 8), &er->ref);
+		er->config &= ~mask;
+		er->config |= config1 & mask;
+		ok = true;
+	}
+	raw_spin_unlock_irqrestore(&er->lock, flags);
+
+	if (!ok) {
+		idx = (idx + 1) % 4;
+		if (idx != reg1->idx) {
+			config1 = snbep_pcu_alter_er(event, idx, false);
+			goto again;
+		}
+		return &constraint_empty;
+	}
+
+	if (!uncore_box_is_fake(box)) {
+		if (idx != reg1->idx)
+			snbep_pcu_alter_er(event, idx, true);
+		reg1->alloc = 1;
+	}
+	return NULL;
+}
+
+static void snbep_pcu_put_constraint(struct intel_uncore_box *box, struct perf_event *event)
+{
+	struct hw_perf_event_extra *reg1 = &event->hw.extra_reg;
+	struct intel_uncore_extra_reg *er = &box->shared_regs[0];
+
+	if (uncore_box_is_fake(box) || !reg1->alloc)
+		return;
+
+	atomic_sub(1 << (reg1->idx * 8), &er->ref);
+	reg1->alloc = 0;
+}
+
+static int snbep_pcu_hw_config(struct intel_uncore_box *box, struct perf_event *event)
+{
+	struct hw_perf_event *hwc = &event->hw;
+	struct hw_perf_event_extra *reg1 = &hwc->extra_reg;
+	int ev_sel = hwc->config & SNBEP_PMON_CTL_EV_SEL_MASK;
+
+	if (ev_sel >= 0xb && ev_sel <= 0xe) {
+		reg1->reg = SNBEP_PCU_MSR_PMON_BOX_FILTER;
+		reg1->idx = ev_sel - 0xb;
+		reg1->config = event->attr.config1 & (0xff << reg1->idx);
+	}
+	return 0;
+}
+
+static struct intel_uncore_ops snbep_uncore_pcu_ops = {
+	SNBEP_UNCORE_MSR_OPS_COMMON_INIT(),
+	.hw_config		= snbep_pcu_hw_config,
+	.get_constraint		= snbep_pcu_get_constraint,
+	.put_constraint		= snbep_pcu_put_constraint,
+};
+
 static struct intel_uncore_type snbep_uncore_pcu = {
 	.name			= "pcu",
 	.num_counters		= 4,
@@ -470,7 +691,7 @@ static struct intel_uncore_type snbep_uncore_pcu = {
 	.event_mask		= SNBEP_PCU_MSR_PMON_RAW_EVENT_MASK,
 	.box_ctl		= SNBEP_PCU_MSR_PMON_BOX_CTL,
 	.num_shared_regs	= 1,
-	.ops			= &snbep_uncore_msr_ops,
+	.ops			= &snbep_uncore_pcu_ops,
 	.format_group		= &snbep_uncore_pcu_format_group,
 };
 
@@ -797,9 +1018,6 @@ static struct intel_uncore_type *nhm_msr_uncores[] = {
 /* end of Nehalem uncore support */
 
 /* Nehalem-EX uncore support */
-#define __BITS_VALUE(x, i, n)  ((typeof(x))(((x) >> ((i) * (n))) & \
-				((1ULL << (n)) - 1)))
-
 DEFINE_UNCORE_FORMAT_ATTR(event5, event, "config:1-5");
 DEFINE_UNCORE_FORMAT_ATTR(counter, counter, "config:6-7");
 DEFINE_UNCORE_FORMAT_ATTR(match, match, "config1:0-63");
@@ -1150,7 +1368,7 @@ static struct extra_reg nhmex_uncore_mbox_extra_regs[] = {
 };
 
 /* Nehalem-EX or Westmere-EX ? */
-bool uncore_nhmex;
+static bool uncore_nhmex;
 
 static bool nhmex_mbox_get_shared_reg(struct intel_uncore_box *box, int idx, u64 config)
 {
@@ -1228,7 +1446,7 @@ static void nhmex_mbox_put_shared_reg(struct intel_uncore_box *box, int idx)
 	atomic_sub(1 << (idx * 8), &er->ref);
 }
 
-u64 nhmex_mbox_alter_er(struct perf_event *event, int new_idx, bool modify)
+static u64 nhmex_mbox_alter_er(struct perf_event *event, int new_idx, bool modify)
 {
 	struct hw_perf_event *hwc = &event->hw;
 	struct hw_perf_event_extra *reg1 = &hwc->extra_reg;
@@ -1543,7 +1761,7 @@ static struct intel_uncore_type nhmex_uncore_mbox = {
 	.format_group		= &nhmex_uncore_mbox_format_group,
 };
 
-void nhmex_rbox_alter_er(struct intel_uncore_box *box, struct perf_event *event)
+static void nhmex_rbox_alter_er(struct intel_uncore_box *box, struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
 	struct hw_perf_event_extra *reg1 = &hwc->extra_reg;
@@ -1715,21 +1933,6 @@ static int nhmex_rbox_hw_config(struct intel_uncore_box *box, struct perf_event
 	return 0;
 }
 
-static u64 nhmex_rbox_shared_reg_config(struct intel_uncore_box *box, int idx)
-{
-	struct intel_uncore_extra_reg *er;
-	unsigned long flags;
-	u64 config;
-
-	er = &box->shared_regs[idx];
-
-	raw_spin_lock_irqsave(&er->lock, flags);
-	config = er->config;
-	raw_spin_unlock_irqrestore(&er->lock, flags);
-
-	return config;
-}
-
 static void nhmex_rbox_msr_enable_event(struct intel_uncore_box *box, struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
@@ -1750,7 +1953,7 @@ static void nhmex_rbox_msr_enable_event(struct intel_uncore_box *box, struct per
 	case 2:
 	case 3:
 		wrmsrl(NHMEX_R_MSR_PORTN_QLX_CFG(port),
-			nhmex_rbox_shared_reg_config(box, 2 + (idx / 6) * 5));
+			uncore_shared_reg_config(box, 2 + (idx / 6) * 5));
 		break;
 	case 4:
 		wrmsrl(NHMEX_R_MSR_PORTN_XBR_SET1_MM_CFG(port),
@@ -2276,7 +2479,7 @@ out:
 	return ret;
 }
 
-int uncore_pmu_event_init(struct perf_event *event)
+static int uncore_pmu_event_init(struct perf_event *event)
 {
 	struct intel_uncore_pmu *pmu;
 	struct intel_uncore_box *box;
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.h b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
index e68a455..3e382f1 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.h
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
@@ -148,9 +148,20 @@
 #define SNBEP_C0_MSR_PMON_CTL0			0xd10
 #define SNBEP_C0_MSR_PMON_BOX_CTL		0xd04
 #define SNBEP_C0_MSR_PMON_BOX_FILTER		0xd14
-#define SNBEP_CB0_MSR_PMON_BOX_FILTER_MASK	0xfffffc1f
 #define SNBEP_CBO_MSR_OFFSET			0x20
 
+#define SNBEP_CB0_MSR_PMON_BOX_FILTER_TID	0x1f
+#define SNBEP_CB0_MSR_PMON_BOX_FILTER_NID	0x3fc00
+#define SNBEP_CB0_MSR_PMON_BOX_FILTER_STATE	0x7c0000
+#define SNBEP_CB0_MSR_PMON_BOX_FILTER_OPC	0xff800000
+
+#define CBO_EVENT_EXTRA_REG(e, m, f) {	\
+	.event = (e),				\
+	.msr = SNBEP_C0_MSR_PMON_BOX_FILTER,	\
+	.config_mask = (m),			\
+	.idx = f				\
+}
+
 /* SNB-EP PCU register */
 #define SNBEP_PCU_MSR_PMON_CTR0			0xc36
 #define SNBEP_PCU_MSR_PMON_CTL0			0xc30
-- 
1.7.11.7

