Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933830Ab1KBSlw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 14:41:52 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18132 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933338Ab1KBShD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 14:37:03 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6518"; a="133706990"
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: Matt Wagantall <mattw@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: [RFC PATCH 18/34] msm: clock-local: Add support for 8x60 clock types
Date: Wed,  2 Nov 2011 11:36:15 -0700
Message-Id: <1320258991-22325-19-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1320258991-22325-1-git-send-email-davidb@codeaurora.org>
References: <1320258991-22325-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Wagantall <mattw@codeaurora.org>

Signed-off-by: Matt Wagantall <mattw@codeaurora.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: David Brown <davidb@codeaurora.org>
---
 arch/arm/mach-msm/clock-local.c |  290 ++++++++++++++++++++++++++++++++++++---
 arch/arm/mach-msm/clock-local.h |   47 ++++++-
 2 files changed, 318 insertions(+), 19 deletions(-)

diff --git a/arch/arm/mach-msm/clock-local.c b/arch/arm/mach-msm/clock-local.c
index 7a6dc5d..3ee318d 100644
--- a/arch/arm/mach-msm/clock-local.c
+++ b/arch/arm/mach-msm/clock-local.c
@@ -81,11 +81,185 @@ void set_rate_nop(struct rcg_clk *clk, struct clk_freq_tbl *nf)
 	 */
 }
 
-int (*soc_update_sys_vdd)(enum sys_vdd_level level);
+void set_rate_mnd_8(struct rcg_clk *clk, struct clk_freq_tbl *nf)
+{
+	u32 ctl_reg_val;
+
+	/* Assert MND reset. */
+	ctl_reg_val = readl_relaxed(clk->b.ctl_reg);
+	ctl_reg_val |= BIT(8);
+	writel_relaxed(ctl_reg_val, clk->b.ctl_reg);
+
+	/* Program M and D values. */
+	writel_relaxed(nf->md_val, clk->md_reg);
+
+	/* Program MN counter Enable and Mode. */
+	ctl_reg_val &= ~(clk->ctl_mask);
+	ctl_reg_val |= nf->ctl_val;
+	writel_relaxed(ctl_reg_val, clk->b.ctl_reg);
+
+	/* Deassert MND reset. */
+	ctl_reg_val &= ~BIT(8);
+	writel_relaxed(ctl_reg_val, clk->b.ctl_reg);
+}
+
+void set_rate_mnd_banked(struct rcg_clk *clk, struct clk_freq_tbl *nf)
+{
+	struct bank_masks *banks = clk->bank_masks;
+	const struct bank_mask_info *new_bank_masks;
+	const struct bank_mask_info *old_bank_masks;
+	u32 ns_reg_val, ctl_reg_val;
+	u32 bank_sel;
+
+	/*
+	 * Determine active bank and program the other one. If the clock is
+	 * off, program the active bank since bank switching won't work if
+	 * both banks aren't running.
+	 */
+	ctl_reg_val = readl_relaxed(clk->b.ctl_reg);
+	bank_sel = !!(ctl_reg_val & banks->bank_sel_mask);
+	 /* If clock isn't running, don't switch banks. */
+	bank_sel ^= (!clk->enabled || clk->current_freq->freq_hz == 0);
+	if (bank_sel == 0) {
+		new_bank_masks = &banks->bank1_mask;
+		old_bank_masks = &banks->bank0_mask;
+	} else {
+		new_bank_masks = &banks->bank0_mask;
+		old_bank_masks = &banks->bank1_mask;
+	}
+
+	ns_reg_val = readl_relaxed(clk->ns_reg);
+
+	/* Assert bank MND reset. */
+	ns_reg_val |= new_bank_masks->rst_mask;
+	writel_relaxed(ns_reg_val, clk->ns_reg);
+
+	/*
+	 * Program NS only if the clock is enabled, since the NS will be set
+	 * as part of the enable procedure and should remain with a low-power
+	 * MUX input selected until then.
+	 */
+	if (clk->enabled) {
+		ns_reg_val &= ~(new_bank_masks->ns_mask);
+		ns_reg_val |= (nf->ns_val & new_bank_masks->ns_mask);
+		writel_relaxed(ns_reg_val, clk->ns_reg);
+	}
+
+	writel_relaxed(nf->md_val, new_bank_masks->md_reg);
+
+	/* Enable counter only if clock is enabled. */
+	if (clk->enabled)
+		ctl_reg_val |= new_bank_masks->mnd_en_mask;
+	else
+		ctl_reg_val &= ~(new_bank_masks->mnd_en_mask);
+
+	ctl_reg_val &= ~(new_bank_masks->mode_mask);
+	ctl_reg_val |= (nf->ctl_val & new_bank_masks->mode_mask);
+	writel_relaxed(ctl_reg_val, clk->b.ctl_reg);
+
+	/* Deassert bank MND reset. */
+	ns_reg_val &= ~(new_bank_masks->rst_mask);
+	writel_relaxed(ns_reg_val, clk->ns_reg);
+
+	/*
+	 * Switch to the new bank if clock is running.  If it isn't, then
+	 * no switch is necessary since we programmed the active bank.
+	 */
+	if (clk->enabled && clk->current_freq->freq_hz) {
+		ctl_reg_val ^= banks->bank_sel_mask;
+		writel_relaxed(ctl_reg_val, clk->b.ctl_reg);
+		/*
+		 * Wait at least 6 cycles of slowest bank's clock
+		 * for the glitch-free MUX to fully switch sources.
+		 */
+		mb();
+		udelay(1);
+
+		/* Disable old bank's MN counter. */
+		ctl_reg_val &= ~(old_bank_masks->mnd_en_mask);
+		writel_relaxed(ctl_reg_val, clk->b.ctl_reg);
+
+		/* Program old bank to a low-power source and divider. */
+		ns_reg_val &= ~(old_bank_masks->ns_mask);
+		ns_reg_val |= (clk->freq_tbl->ns_val & old_bank_masks->ns_mask);
+		writel_relaxed(ns_reg_val, clk->ns_reg);
+	}
+
+	/*
+	 * If this freq requires the MN counter to be enabled,
+	 * update the enable mask to match the current bank.
+	 */
+	if (nf->mnd_en_mask)
+		nf->mnd_en_mask = new_bank_masks->mnd_en_mask;
+	/* Update the NS mask to match the current bank. */
+	clk->ns_mask = new_bank_masks->ns_mask;
+}
+
+void set_rate_div_banked(struct rcg_clk *clk, struct clk_freq_tbl *nf)
+{
+	struct bank_masks *banks = clk->bank_masks;
+	const struct bank_mask_info *new_bank_masks;
+	const struct bank_mask_info *old_bank_masks;
+	u32 ns_reg_val, bank_sel;
+
+	/*
+	 * Determine active bank and program the other one. If the clock is
+	 * off, program the active bank since bank switching won't work if
+	 * both banks aren't running.
+	 */
+	ns_reg_val = readl_relaxed(clk->ns_reg);
+	bank_sel = !!(ns_reg_val & banks->bank_sel_mask);
+	 /* If clock isn't running, don't switch banks. */
+	bank_sel ^= (!clk->enabled || clk->current_freq->freq_hz == 0);
+	if (bank_sel == 0) {
+		new_bank_masks = &banks->bank1_mask;
+		old_bank_masks = &banks->bank0_mask;
+	} else {
+		new_bank_masks = &banks->bank0_mask;
+		old_bank_masks = &banks->bank1_mask;
+	}
+
+	/*
+	 * Program NS only if the clock is enabled, since the NS will be set
+	 * as part of the enable procedure and should remain with a low-power
+	 * MUX input selected until then.
+	 */
+	if (clk->enabled) {
+		ns_reg_val &= ~(new_bank_masks->ns_mask);
+		ns_reg_val |= (nf->ns_val & new_bank_masks->ns_mask);
+		writel_relaxed(ns_reg_val, clk->ns_reg);
+	}
+
+	/*
+	 * Switch to the new bank if clock is running.  If it isn't, then
+	 * no switch is necessary since we programmed the active bank.
+	 */
+	if (clk->enabled && clk->current_freq->freq_hz) {
+		ns_reg_val ^= banks->bank_sel_mask;
+		writel_relaxed(ns_reg_val, clk->ns_reg);
+		/*
+		 * Wait at least 6 cycles of slowest bank's clock
+		 * for the glitch-free MUX to fully switch sources.
+		 */
+		mb();
+		udelay(1);
+
+		/* Program old bank to a low-power source and divider. */
+		ns_reg_val &= ~(old_bank_masks->ns_mask);
+		ns_reg_val |= (clk->freq_tbl->ns_val & old_bank_masks->ns_mask);
+		writel_relaxed(ns_reg_val, clk->ns_reg);
+	}
+
+	/* Update the NS mask to match the current bank. */
+	clk->ns_mask = new_bank_masks->ns_mask;
+}
+
 /*
  * SYS_VDD voting functions
  */
 
+int (*soc_update_sys_vdd)(enum sys_vdd_level level);
+
 /* Update system voltage level given the current votes. */
 static int local_update_sys_vdd(void)
 {
@@ -392,17 +566,22 @@ static int _rcg_clk_set_rate(struct rcg_clk *clk, struct clk_freq_tbl *nf)
 
 	spin_lock(&local_clock_reg_lock);
 
-	/* Disable all branches to prevent glitches. */
-	list_for_each_entry(chld, &clk->c.children, siblings) {
-		struct branch_clk *x = to_branch_clk(chld);
-		/* Don't bother turning off if it is already off.
-		 * Checking ch->enabled is cheaper (cache) than reading
-		 * and writing to a register (uncached/unbuffered). */
-		if (x->enabled)
-			__branch_clk_disable_reg(&x->b, x->c.dbg_name);
+	/* Disable branch if clock isn't dual-banked with a glitch-free MUX. */
+	if (clk->bank_masks == NULL) {
+		/* Disable all branches to prevent glitches. */
+		list_for_each_entry(chld, &clk->c.children, siblings) {
+			struct branch_clk *x = to_branch_clk(chld);
+			/*
+			 * We don't need to grab the child's lock because
+			 * we hold the local_clock_reg_lock and 'enabled' is
+			 * only modified within lock.
+			 */
+			if (x->enabled)
+				__branch_clk_disable_reg(&x->b, x->c.dbg_name);
+		}
+		if (clk->enabled)
+			__rcg_clk_disable_reg(clk);
 	}
-	if (clk->enabled)
-		__rcg_clk_disable_reg(clk);
 
 	/* Perform clock-specific frequency switch operations. */
 	BUG_ON(!clk->set_rate);
@@ -414,13 +593,16 @@ static int _rcg_clk_set_rate(struct rcg_clk *clk, struct clk_freq_tbl *nf)
 	 */
 	clk->current_freq = nf;
 
-	if (clk->enabled)
-		__rcg_clk_enable_reg(clk);
-	/* Enable only branches that were ON before. */
-	list_for_each_entry(chld, &clk->c.children, siblings) {
-		struct branch_clk *x = to_branch_clk(chld);
-		if (x->enabled)
-			__branch_clk_enable_reg(&x->b, x->c.dbg_name);
+	/* Enable any clocks that were disabled. */
+	if (clk->bank_masks == NULL) {
+		if (clk->enabled)
+			__rcg_clk_enable_reg(clk);
+		/* Enable only branches that were ON before. */
+		list_for_each_entry(chld, &clk->c.children, siblings) {
+			struct branch_clk *x = to_branch_clk(chld);
+			if (x->enabled)
+				__branch_clk_enable_reg(&x->b, x->c.dbg_name);
+		}
 	}
 
 	spin_unlock(&local_clock_reg_lock);
@@ -583,6 +765,78 @@ struct clk_ops clk_ops_pll_vote = {
 	.is_local = local_clk_is_local,
 };
 
+static int pll_clk_enable(struct clk *clk)
+{
+	u32 mode;
+	unsigned long flags;
+	struct pll_clk *pll = to_pll_clk(clk);
+
+	spin_lock_irqsave(&local_clock_reg_lock, flags);
+	mode = readl_relaxed(pll->mode_reg);
+	/* Disable PLL bypass mode. */
+	mode |= BIT(1);
+	writel_relaxed(mode, pll->mode_reg);
+
+	/*
+	 * H/W requires a 5us delay between disabling the bypass and
+	 * de-asserting the reset. Delay 10us just to be safe.
+	 */
+	mb();
+	udelay(10);
+
+	/* De-assert active-low PLL reset. */
+	mode |= BIT(2);
+	writel_relaxed(mode, pll->mode_reg);
+
+	/* Wait until PLL is locked. */
+	mb();
+	udelay(50);
+
+	/* Enable PLL output. */
+	mode |= BIT(0);
+	writel_relaxed(mode, pll->mode_reg);
+
+	spin_unlock_irqrestore(&local_clock_reg_lock, flags);
+	return 0;
+}
+
+static void pll_clk_disable(struct clk *clk)
+{
+	u32 mode;
+	unsigned long flags;
+	struct pll_clk *pll = to_pll_clk(clk);
+
+	/*
+	 * Disable the PLL output, disable test mode, enable
+	 * the bypass mode, and assert the reset.
+	 */
+	spin_lock_irqsave(&local_clock_reg_lock, flags);
+	mode = readl_relaxed(pll->mode_reg);
+	mode &= ~BM(3, 0);
+	writel_relaxed(mode, pll->mode_reg);
+	spin_unlock_irqrestore(&local_clock_reg_lock, flags);
+}
+
+static unsigned pll_clk_get_rate(struct clk *clk)
+{
+	struct pll_clk *pll = to_pll_clk(clk);
+	return pll->rate;
+}
+
+static struct clk *pll_clk_get_parent(struct clk *clk)
+{
+	struct pll_clk *pll = to_pll_clk(clk);
+	return pll->parent;
+}
+
+struct clk_ops clk_ops_pll = {
+	.enable = pll_clk_enable,
+	.disable = pll_clk_disable,
+	.get_rate = pll_clk_get_rate,
+	.get_parent = pll_clk_get_parent,
+	.is_local = local_clk_is_local,
+};
+
 struct clk_ops clk_ops_gnd = {
 	.get_rate = fixed_clk_get_rate,
 	.is_local = local_clk_is_local,
diff --git a/arch/arm/mach-msm/clock-local.h b/arch/arm/mach-msm/clock-local.h
index a7c9001..e004490 100644
--- a/arch/arm/mach-msm/clock-local.h
+++ b/arch/arm/mach-msm/clock-local.h
@@ -46,6 +46,23 @@ struct clk_freq_tbl {
 	void		*const extra_freq_data;
 };
 
+/* Some clocks have two banks to avoid glitches when switching frequencies.
+ * The unused bank is programmed while running on the other bank, and
+ * switched to afterwards. The following two structs describe the banks. */
+struct bank_mask_info {
+	void *const md_reg;
+	const uint32_t	ns_mask;
+	const uint32_t	rst_mask;
+	const uint32_t	mnd_en_mask;
+	const uint32_t	mode_mask;
+};
+
+struct bank_masks {
+	const uint32_t			bank_sel_mask;
+	const struct bank_mask_info	bank0_mask;
+	const struct bank_mask_info	bank1_mask;
+};
+
 #define F_RAW(f, sc, m_v, n_v, c_v, m_m, v, e) { \
 	.freq_hz = f, \
 	.src_clk = sc, \
@@ -98,8 +115,9 @@ struct rcg_clk {
 	const uint32_t	root_en_mask;
 	uint32_t	ns_mask;
 	const uint32_t	ctl_mask;
+	struct bank_masks *const bank_masks;
 	struct clk *depends;
-	void		(*set_rate)(struct clk_local *, struct clk_freq_tbl *);
+	void   (*set_rate)(struct rcg_clk *, struct clk_freq_tbl *);
 	struct clk_freq_tbl *const freq_tbl;
 	struct clk_freq_tbl *current_freq;
 
@@ -118,6 +136,7 @@ int rcg_clk_set_rate(struct clk *clk, unsigned rate);
 int rcg_clk_set_min_rate(struct clk *clk, unsigned rate);
 int rcg_clk_set_max_rate(struct clk *clk, unsigned rate);
 unsigned rcg_clk_get_rate(struct clk *clk);
+int rcg_clk_list_rate(struct clk *clk, unsigned n);
 unsigned rcg_clk_is_enabled(struct clk *clk);
 long rcg_clk_round_rate(struct clk *clk, unsigned rate);
 struct clk *rcg_clk_get_parent(struct clk *c);
@@ -184,6 +203,29 @@ static inline struct pll_vote_clk *to_pll_vote_clk(struct clk *clk)
 }
 
 /**
+ * struct pll_clk - phase locked loop
+ * @rate: output rate
+ * @mode_reg: enable register
+ * @parent: clock source
+ * @c: clk
+ */
+struct pll_clk {
+	unsigned long rate;
+
+	void __iomem *const mode_reg;
+
+	struct clk *parent;
+	struct clk c;
+};
+
+extern struct clk_ops clk_ops_pll;
+
+static inline struct pll_clk *to_pll_clk(struct clk *clk)
+{
+	return container_of(clk, struct pll_clk, c);
+}
+
+/**
  * struct branch_clk - branch
  * @enabled: true if clock is on, false otherwise
  * @b: branch
@@ -237,6 +279,9 @@ extern int (*soc_update_sys_vdd)(enum sys_vdd_level level);
  */
 void set_rate_mnd(struct rcg_clk *clk, struct clk_freq_tbl *nf);
 void set_rate_nop(struct rcg_clk *clk, struct clk_freq_tbl *nf);
+void set_rate_mnd_8(struct rcg_clk *clk, struct clk_freq_tbl *nf);
+void set_rate_mnd_banked(struct rcg_clk *clk, struct clk_freq_tbl *nf);
+void set_rate_div_banked(struct rcg_clk *clk, struct clk_freq_tbl *nf);
 
 #endif /* __ARCH_ARM_MACH_MSM_CLOCK_LOCAL_H */
 
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

