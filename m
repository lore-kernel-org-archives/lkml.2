Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109Ab2AIPMn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 10:12:43 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:5470 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932087Ab2AIPMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 10:12:40 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 09 Jan 2012 07:12:32 -0800
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: "open list:TEGRA SUPPORT" <linux-tegra@vger.kernel.org>,
        "open list:ARM PORT" <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 1/3] arm/tegra: add support for new clock framework features
Date: Mon, 9 Jan 2012 17:12:11 +0200
Message-ID: <1326121937-32054-2-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1326121937-32054-1-git-send-email-pdeschrijver@nvidia.com>
References: <1326121937-32054-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for new clock framework features implemented in tegra30.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 arch/arm/mach-tegra/clock.c            |   22 ++++++++++++++++++++++
 arch/arm/mach-tegra/clock.h            |   14 ++++++++++++++
 arch/arm/mach-tegra/include/mach/clk.h |   10 ++++++++++
 3 files changed, 46 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-tegra/clock.c b/arch/arm/mach-tegra/clock.c
index 8337068..8dad8d1 100644
--- a/arch/arm/mach-tegra/clock.c
+++ b/arch/arm/mach-tegra/clock.c
@@ -399,6 +399,28 @@ void tegra_periph_reset_assert(struct clk *c)
 }
 EXPORT_SYMBOL(tegra_periph_reset_assert);
 
+/* Several extended clock configuration bits (e.g., clock routing, clock
+ * phase control) are included in PLL and peripheral clock source
+ * registers. */
+int tegra_clk_cfg_ex(struct clk *c, enum tegra_clk_ex_param p, u32 setting)
+{
+	int ret = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&c->spinlock, flags);
+
+	if (!c->ops || !c->ops->clk_cfg_ex) {
+		ret = -ENOSYS;
+		goto out;
+	}
+	ret = c->ops->clk_cfg_ex(c, p, setting);
+
+out:
+	spin_unlock_irqrestore(&c->spinlock, flags);
+
+	return ret;
+}
+
 #ifdef CONFIG_DEBUG_FS
 
 static int __clk_lock_all_spinlocks(void)
diff --git a/arch/arm/mach-tegra/clock.h b/arch/arm/mach-tegra/clock.h
index 5c44106..18f8b85 100644
--- a/arch/arm/mach-tegra/clock.h
+++ b/arch/arm/mach-tegra/clock.h
@@ -24,6 +24,8 @@
 #include <linux/list.h>
 #include <linux/spinlock.h>
 
+#include <mach/clk.h>
+
 #define DIV_BUS			(1 << 0)
 #define DIV_U71			(1 << 1)
 #define DIV_U71_FIXED		(1 << 2)
@@ -39,7 +41,16 @@
 #define PERIPH_MANUAL_RESET	(1 << 12)
 #define PLL_ALT_MISC_REG	(1 << 13)
 #define PLLU			(1 << 14)
+#define PLLX                    (1 << 15)
+#define MUX_PWM                 (1 << 16)
+#define MUX8                    (1 << 17)
+#define DIV_U71_UART            (1 << 18)
+#define MUX_CLK_OUT             (1 << 19)
+#define PLLM                    (1 << 20)
+#define DIV_U71_INT             (1 << 21)
+#define DIV_U71_IDLE            (1 << 22)
 #define ENABLE_ON_INIT		(1 << 28)
+#define PERIPH_ON_APB           (1 << 29)
 
 struct clk;
 
@@ -65,6 +76,8 @@ struct clk_ops {
 	int		(*set_rate)(struct clk *, unsigned long);
 	long		(*round_rate)(struct clk *, unsigned long);
 	void		(*reset)(struct clk *, bool);
+	int		(*clk_cfg_ex)(struct clk *,
+				enum tegra_clk_ex_param, u32);
 };
 
 enum clk_state {
@@ -114,6 +127,7 @@ struct clk {
 			unsigned long			vco_max;
 			const struct clk_pll_freq_table	*freq_table;
 			int				lock_delay;
+			unsigned long			fixed_rate;
 		} pll;
 		struct {
 			u32				sel;
diff --git a/arch/arm/mach-tegra/include/mach/clk.h b/arch/arm/mach-tegra/include/mach/clk.h
index fc3ecb6..d97e403 100644
--- a/arch/arm/mach-tegra/include/mach/clk.h
+++ b/arch/arm/mach-tegra/include/mach/clk.h
@@ -22,10 +22,20 @@
 
 struct clk;
 
+enum tegra_clk_ex_param {
+	TEGRA_CLK_VI_INP_SEL,
+	TEGRA_CLK_DTV_INVERT,
+	TEGRA_CLK_NAND_PAD_DIV2_ENB,
+	TEGRA_CLK_PLLD_CSI_OUT_ENB,
+	TEGRA_CLK_PLLD_DSI_OUT_ENB,
+	TEGRA_CLK_PLLD_MIPI_MUX_SEL,
+};
+
 void tegra_periph_reset_deassert(struct clk *c);
 void tegra_periph_reset_assert(struct clk *c);
 
 unsigned long clk_get_rate_all_locked(struct clk *c);
 void tegra2_sdmmc_tap_delay(struct clk *c, int delay);
+int tegra_clk_cfg_ex(struct clk *c, enum tegra_clk_ex_param p, u32 setting);
 
 #endif
-- 
1.7.7.rc0.72.g4b5ea.dirty

