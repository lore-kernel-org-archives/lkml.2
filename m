Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752295Ab2ELFAJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 01:00:09 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:31714 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601Ab2ELFAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 01:00:06 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6708"; a="190322615"
From: Saravana Kannan <skannan@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>,
        Arnd Bergman <arnd.bergmann@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>, Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Walmsley <paul@pwsan.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Jamie Iles <jamie@jamieiles.com>,
        Richard Zhao <richard.zhao@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Deepak Saxena <dsaxena@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH] clk: Fix race conditions between clk_set_parent() and clk_enable()
Date: Fri, 11 May 2012 21:59:56 -0700
Message-Id: <1336798797-8724-1-git-send-email-skannan@codeaurora.org>
X-Mailer: git-send-email 1.7.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without this patch, the following race conditions are possible.

Race condition 1:
* clk-A has two parents - clk-X and clk-Y.
* All three are disabled and clk-X is current parent.
* Thread A: clk_set_parent(clk-A, clk-Y).
* Thread A: <snip execution flow>
* Thread A: Grabs enable lock.
* Thread A: Sees enable count of clk-A is 0, so doesn't enable clk-Y.
* Thread A: Releases enable lock.
* Thread B: Calls clk_enable(clk-A), which in turn enables clk-X.
* Thread A: Switches clk-A's parent to clk-Y in hardware.

clk-A is now enabled in software, but not clocking in hardware.

Race condition 2:
* clk-A has two parents - clk-X and clk-Y.
* All three are disabled and clk-X is current parent.
* Thread A: clk_set_parent(clk-A, clk-Y).
* Thread A: <snip execution flow>
* Thread A: Switches parent in hardware to clk-Y.
* Thread A: Grabs enable lock.
* Thread A: Sees enable count of clk-A is 0, so doesn't disable clk-X.
* Thread A: Releases enable lock.
* Thread B: Calls clk_enable(clk-A)
* Thread B: Software state still says parent is clk-X.
* Thread B: So, enables clk-X and then itself.
* Thread A: Updates parent in software state to clk-Y.

clk-A is now enabled in software, but not clocking in hardware. clk-X will
never be disabled since it's enable count is 1 when no one needs it. clk-Y
will throw a warning when clk-A is disabled again (assuming clk-A being
disabled in hardware hasn't wedged the system).

To fix these race conditions, hold the enable lock while switching the clock
parent in hardware. But this would force the set_parent() ops to be atomic,
which might not be possible if the clock hardware is external to the SoC.

Since clocks with CLK_SET_PARENT_GATE flag only allow clk_set_parent() on
unprepared clocks and calling clk_enable() on an unprepared clock would be
violating the clock API usage model, allow set_parent() ops to be sleepable
for clocks which have the CLK_SET_PARENT_GATE flag. Putting it another way,
if a clock's parent can't be switched without sleeping, then by definition
the parent can't be switched while it's prepared (CLK_SET_PARENT_GATE).

Signed-off-by: Saravana Kannan <skannan@codeaurora.org>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Arnd Bergman <arnd.bergmann@linaro.org>
Cc: Paul Walmsley <paul@pwsan.com>
Cc: Shawn Guo <shawn.guo@freescale.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Jamie Iles <jamie@jamieiles.com>
Cc: Richard Zhao <richard.zhao@linaro.org>
Cc: Saravana Kannan <skannan@codeaurora.org>
Cc: Magnus Damm <magnus.damm@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: Amit Kucheria <amit.kucheria@linaro.org>
Cc: Deepak Saxena <dsaxena@linaro.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
---
Additional comments that I'm not sure are fit for the commit text:

Reason for repeating the call to set_parent() ops and updating clk->parent
for the CLK_SET_PARENT_GATE case:
* It looks weird to wrap the migration code and the lock/unlock in separate
  if's.
* Once we add proper error checking for the return value of set_parent()
  ops, the code will look even more convoluted if we try to share the code
  for CLK_SET_PARENT_GATE case and non-CLK_SET_PARENT_GATE case.

I realize that clk->parent = parent is repeated in __clk_reparent(). But I
left that as is for now in case anyone is using that in one of for-next
branches. If no one is using it, we can remove it.

For a similar reason, clocks that need to do reparenting during
clk_set_rate() and don't have CLK_SET_RATE_GATE set can't do it correctly
with the current clk-provider APIs provided by the common clock framework.

__clk_set_parent() should really be split into two APIs for this to work:
__clk_pre_reparent() - enable lock grabbed here.
__clk_post_reparent() - enable lock released here.

 drivers/clk/clk.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index e5d5dc1..09b9112 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1059,7 +1059,7 @@ static int __clk_set_parent(struct clk *clk, struct clk *parent)
 {
 	struct clk *old_parent;
 	unsigned long flags;
-	int ret = -EINVAL;
+	int ret;
 	u8 i;
 
 	old_parent = clk->parent;
@@ -1083,7 +1083,13 @@ static int __clk_set_parent(struct clk *clk, struct clk *parent)
 	if (i == clk->num_parents) {
 		pr_debug("%s: clock %s is not a possible parent of clock %s\n",
 				__func__, parent->name, clk->name);
-		goto out;
+		return -EINVAL;
+	}
+
+	if (clk->flags & CLK_SET_PARENT_GATE) {
+		ret = clk->ops->set_parent(clk->hw, i);
+		clk->parent = parent;
+		return ret;
 	}
 
 	/* migrate prepare and enable */
@@ -1092,23 +1098,23 @@ static int __clk_set_parent(struct clk *clk, struct clk *parent)
 
 	/* FIXME replace with clk_is_enabled(clk) someday */
 	spin_lock_irqsave(&enable_lock, flags);
+
 	if (clk->enable_count)
 		__clk_enable(parent);
-	spin_unlock_irqrestore(&enable_lock, flags);
 
 	/* change clock input source */
 	ret = clk->ops->set_parent(clk->hw, i);
+	clk->parent = parent;
 
 	/* clean up old prepare and enable */
-	spin_lock_irqsave(&enable_lock, flags);
 	if (clk->enable_count)
 		__clk_disable(old_parent);
+
 	spin_unlock_irqrestore(&enable_lock, flags);
 
 	if (clk->prepare_count)
 		__clk_unprepare(old_parent);
 
-out:
 	return ret;
 }
 
-- 
1.7.8.3
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
