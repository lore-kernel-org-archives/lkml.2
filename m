Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330Ab1BSW1f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 17:27:35 -0500
Received: from smtp-out.google.com ([216.239.44.51]:26170 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754950Ab1BSW0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 17:26:43 -0500
From: Colin Cross <ccross@android.com>
To: linux-tegra@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, konkers@android.com, olof@lixom.net,
        Dima Zavin <dima@android.com>, Colin Cross <ccross@android.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 01/21] ARM: tegra: clock: enable clk reset for non-peripheral clocks
Date: Sat, 19 Feb 2011 14:25:50 -0800
Message-Id: <1298154371-5641-3-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1298154371-5641-1-git-send-email-ccross@android.com>
References: <1298154371-5641-1-git-send-email-ccross@android.com>
To: linux-tegra@vger.kernel.org
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dima Zavin <dima@android.com>

Add a new 'reset' clk op. This can be provided for any clock,
not just peripherals.

Signed-off-by: Dima Zavin <dima@android.com>
Signed-off-by: Colin Cross <ccross@android.com>
---
 arch/arm/mach-tegra/clock.h         |    1 +
 arch/arm/mach-tegra/tegra2_clocks.c |   29 ++++++++++++++++++-----------
 2 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/arch/arm/mach-tegra/clock.h b/arch/arm/mach-tegra/clock.h
index 083a4cf..42f00c0 100644
--- a/arch/arm/mach-tegra/clock.h
+++ b/arch/arm/mach-tegra/clock.h
@@ -86,6 +86,7 @@ struct clk_ops {
 	int		(*set_parent)(struct clk *, struct clk *);
 	int		(*set_rate)(struct clk *, unsigned long);
 	long		(*round_rate)(struct clk *, unsigned long);
+	void		(*reset)(struct clk *, bool);
 };
 
 enum clk_state {
diff --git a/arch/arm/mach-tegra/tegra2_clocks.c b/arch/arm/mach-tegra/tegra2_clocks.c
index 7a2926a..240f921 100644
--- a/arch/arm/mach-tegra/tegra2_clocks.c
+++ b/arch/arm/mach-tegra/tegra2_clocks.c
@@ -263,6 +263,18 @@ static struct clk_ops tegra_clk_m_ops = {
 	.disable	= tegra2_clk_m_disable,
 };
 
+void tegra2_periph_reset_assert(struct clk *c)
+{
+	BUG_ON(!c->ops->reset);
+	c->ops->reset(c, true);
+}
+
+void tegra2_periph_reset_deassert(struct clk *c)
+{
+	BUG_ON(!c->ops->reset);
+	c->ops->reset(c, false);
+}
+
 /* super clock functions */
 /* "super clocks" on tegra have two-stage muxes and a clock skipping
  * super divider.  We will ignore the clock skipping divider, since we
@@ -895,23 +907,17 @@ static void tegra2_periph_clk_disable(struct clk *c)
 		CLK_OUT_ENB_CLR + PERIPH_CLK_TO_ENB_SET_REG(c));
 }
 
-void tegra2_periph_reset_deassert(struct clk *c)
+static void tegra2_periph_clk_reset(struct clk *c, bool assert)
 {
-	pr_debug("%s on clock %s\n", __func__, c->name);
-	if (!(c->flags & PERIPH_NO_RESET))
-		clk_writel(PERIPH_CLK_TO_ENB_BIT(c),
-			RST_DEVICES_CLR + PERIPH_CLK_TO_ENB_SET_REG(c));
-}
+	unsigned long base = assert ? RST_DEVICES_SET : RST_DEVICES_CLR;
 
-void tegra2_periph_reset_assert(struct clk *c)
-{
-	pr_debug("%s on clock %s\n", __func__, c->name);
+	pr_debug("%s %s on clock %s\n", __func__,
+		 assert ? "assert" : "deassert", c->name);
 	if (!(c->flags & PERIPH_NO_RESET))
 		clk_writel(PERIPH_CLK_TO_ENB_BIT(c),
-			RST_DEVICES_SET + PERIPH_CLK_TO_ENB_SET_REG(c));
+			   base + PERIPH_CLK_TO_ENB_SET_REG(c));
 }
 
-
 static int tegra2_periph_clk_set_parent(struct clk *c, struct clk *p)
 {
 	u32 val;
@@ -1002,6 +1008,7 @@ static struct clk_ops tegra_periph_clk_ops = {
 	.set_parent		= &tegra2_periph_clk_set_parent,
 	.set_rate		= &tegra2_periph_clk_set_rate,
 	.round_rate		= &tegra2_periph_clk_round_rate,
+	.reset			= &tegra2_periph_clk_reset,
 };
 
 /* Clock doubler ops */
-- 
1.7.3.1

