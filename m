Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab1BVClj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 21:41:39 -0500
Received: from smtp-out.google.com ([74.125.121.67]:22586 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318Ab1BVClg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 21:41:36 -0500
From: Colin Cross <ccross@android.com>
To: linux-tegra@vger.kernel.org
Cc: konkers@android.com, olof@lixom.net, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, mike@compulab.co.il,
        Colin Cross <ccross@android.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 3/7] ARM: tegra: clock: Check for clk_num == 0
Date: Mon, 21 Feb 2011 18:39:48 -0800
Message-Id: <1298342392-21236-4-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1298342392-21236-1-git-send-email-ccross@android.com>
References: <1298342392-21236-1-git-send-email-ccross@android.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peripheral clocks that have no clock enable bit in the
enable registers have their clk_num set to 0.  Bit 0
in the clock enable registers is the CPU clock.
Prevent disables on these peripheral clocks from
accidentally disabling the CPU clock.

Signed-off-by: Colin Cross <ccross@android.com>
---
 arch/arm/mach-tegra/tegra2_clocks.c |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-tegra/tegra2_clocks.c b/arch/arm/mach-tegra/tegra2_clocks.c
index 73e112f..3015a2c 100644
--- a/arch/arm/mach-tegra/tegra2_clocks.c
+++ b/arch/arm/mach-tegra/tegra2_clocks.c
@@ -946,9 +946,14 @@ static void tegra2_periph_clk_init(struct clk *c)
 	}
 
 	c->state = ON;
+
+	if (!c->u.periph.clk_num)
+		return;
+
 	if (!(clk_readl(CLK_OUT_ENB + PERIPH_CLK_TO_ENB_REG(c)) &
 			PERIPH_CLK_TO_ENB_BIT(c)))
 		c->state = OFF;
+
 	if (!(c->flags & PERIPH_NO_RESET))
 		if (clk_readl(RST_DEVICES + PERIPH_CLK_TO_ENB_REG(c)) &
 				PERIPH_CLK_TO_ENB_BIT(c))
@@ -962,6 +967,9 @@ static int tegra2_periph_clk_enable(struct clk *c)
 	int refcount;
 	pr_debug("%s on clock %s\n", __func__, c->name);
 
+	if (!c->u.periph.clk_num)
+		return 0;
+
 	spin_lock_irqsave(&clock_register_lock, flags);
 
 	refcount = tegra_periph_clk_enable_refcount[c->u.periph.clk_num]++;
@@ -994,6 +1002,9 @@ static void tegra2_periph_clk_disable(struct clk *c)
 
 	pr_debug("%s on clock %s\n", __func__, c->name);
 
+	if (!c->u.periph.clk_num)
+		return;
+
 	spin_lock_irqsave(&clock_register_lock, flags);
 
 	if (c->refcnt)
@@ -1012,6 +1023,9 @@ static void tegra2_periph_clk_reset(struct clk *c, bool assert)
 
 	pr_debug("%s %s on clock %s\n", __func__,
 		 assert ? "assert" : "deassert", c->name);
+
+	BUG_ON(!c->u.periph.clk_num);
+
 	if (!(c->flags & PERIPH_NO_RESET))
 		clk_writel(PERIPH_CLK_TO_ENB_BIT(c),
 			   base + PERIPH_CLK_TO_ENB_SET_REG(c));
@@ -1182,6 +1196,10 @@ static void tegra2_clk_double_init(struct clk *c)
 	c->mul = 2;
 	c->div = 1;
 	c->state = ON;
+
+	if (!c->u.periph.clk_num)
+		return;
+
 	if (!(clk_readl(CLK_OUT_ENB + PERIPH_CLK_TO_ENB_REG(c)) &
 			PERIPH_CLK_TO_ENB_BIT(c)))
 		c->state = OFF;
@@ -1269,6 +1287,9 @@ static void tegra2_cdev_clk_init(struct clk *c)
 	/* We could un-tristate the cdev1 or cdev2 pingroup here; this is
 	 * currently done in the pinmux code. */
 	c->state = ON;
+
+	BUG_ON(!c->u.periph.clk_num);
+
 	if (!(clk_readl(CLK_OUT_ENB + PERIPH_CLK_TO_ENB_REG(c)) &
 			PERIPH_CLK_TO_ENB_BIT(c)))
 		c->state = OFF;
@@ -1276,6 +1297,8 @@ static void tegra2_cdev_clk_init(struct clk *c)
 
 static int tegra2_cdev_clk_enable(struct clk *c)
 {
+	BUG_ON(!c->u.periph.clk_num);
+
 	clk_writel(PERIPH_CLK_TO_ENB_BIT(c),
 		CLK_OUT_ENB_SET + PERIPH_CLK_TO_ENB_SET_REG(c));
 	return 0;
@@ -1283,6 +1306,8 @@ static int tegra2_cdev_clk_enable(struct clk *c)
 
 static void tegra2_cdev_clk_disable(struct clk *c)
 {
+	BUG_ON(!c->u.periph.clk_num);
+
 	clk_writel(PERIPH_CLK_TO_ENB_BIT(c),
 		CLK_OUT_ENB_CLR + PERIPH_CLK_TO_ENB_SET_REG(c));
 }
-- 
1.7.3.1

