Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224Ab1BMJno (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 04:43:44 -0500
Received: from smtp-out.google.com ([216.239.44.51]:9926 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994Ab1BMJnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 04:43:10 -0500
From: Colin Cross <ccross@android.com>
To: linux-tegra@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, konkers@android.com, olof@lixom.net,
        Colin Cross <ccross@android.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH 15/21] ARM: tegra: clock: Round rate before setting rate
Date: Sun, 13 Feb 2011 01:40:27 -0800
Message-Id: <1297590033-15035-16-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1297590033-15035-1-git-send-email-ccross@android.com>
References: <1297590033-15035-1-git-send-email-ccross@android.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call the clock's round_rate op, if it exists, before calling
the set_rate op.  This will help later when dvfs is added,
dvfs needs to know what the final rate will be before the
frequency changes.

Also requires fixes to the round rate functions to ensure
calling round rate and then set rate will not cause the
frequency to be rounded down twice.  When picking clock
divider values, the clock framework picks the closest
frequency that is lower than the requested frequency.  If
the new frequency calculated from the divider value is
rounded down, and then passed to set_rate, it will get
rounded down again, possibly resulting in a frequency two
steps lower than the original requested frequency.

Fix the problem by rounding up when calculating the frequency
coming out of a clock divider, so if that frequency is
requested again, the same divider value will be picked.

Signed-off-by: Colin Cross <ccross@android.com>
---
 arch/arm/mach-tegra/clock.c         |   13 +++++++++++++
 arch/arm/mach-tegra/tegra2_clocks.c |    8 ++++----
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-tegra/clock.c b/arch/arm/mach-tegra/clock.c
index 2d9ddfd..4865bb4 100644
--- a/arch/arm/mach-tegra/clock.c
+++ b/arch/arm/mach-tegra/clock.c
@@ -85,6 +85,7 @@ static unsigned long clk_predict_rate_from_parent(struct clk *c, struct clk *p)
 
 	if (c->mul != 0 && c->div != 0) {
 		rate *= c->mul;
+		rate += c->div / 2; /* round up */
 		do_div(rate, c->div);
 	}
 
@@ -242,6 +243,7 @@ int clk_set_rate(struct clk *c, unsigned long rate)
 	int ret = 0;
 	unsigned long flags;
 	unsigned long old_rate;
+	long new_rate;
 
 	spin_lock_irqsave(&c->spinlock, flags);
 
@@ -255,6 +257,17 @@ int clk_set_rate(struct clk *c, unsigned long rate)
 	if (rate > c->max_rate)
 		rate = c->max_rate;
 
+	if (c->ops && c->ops->round_rate) {
+		new_rate = c->ops->round_rate(c, rate);
+
+		if (new_rate < 0) {
+			ret = new_rate;
+			goto out;
+		}
+
+		rate = new_rate;
+	}
+
 	ret = c->ops->set_rate(c, rate);
 	if (ret)
 		goto out;
diff --git a/arch/arm/mach-tegra/tegra2_clocks.c b/arch/arm/mach-tegra/tegra2_clocks.c
index 2f79128..96b2490 100644
--- a/arch/arm/mach-tegra/tegra2_clocks.c
+++ b/arch/arm/mach-tegra/tegra2_clocks.c
@@ -866,9 +866,9 @@ static long tegra2_pll_div_clk_round_rate(struct clk *c, unsigned long rate)
 		divider = clk_div71_get_divider(parent_rate, rate);
 		if (divider < 0)
 			return divider;
-		return parent_rate * 2 / (divider + 2);
+		return DIV_ROUND_UP(parent_rate * 2, divider + 2);
 	} else if (c->flags & DIV_2) {
-		return parent_rate / 2;
+		return DIV_ROUND_UP(parent_rate, 2);
 	}
 	return -EINVAL;
 }
@@ -1058,12 +1058,12 @@ static long tegra2_periph_clk_round_rate(struct clk *c,
 		if (divider < 0)
 			return divider;
 
-		return parent_rate * 2 / (divider + 2);
+		return DIV_ROUND_UP(parent_rate * 2, divider + 2);
 	} else if (c->flags & DIV_U16) {
 		divider = clk_div16_get_divider(parent_rate, rate);
 		if (divider < 0)
 			return divider;
-		return parent_rate / (divider + 1);
+		return DIV_ROUND_UP(parent_rate, divider + 1);
 	}
 	return -EINVAL;
 }
-- 
1.7.3.1

