Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932434Ab2GDWJl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 18:09:41 -0400
Received: from mail.df.lth.se ([194.47.250.12]:25601 "EHLO mail.df.lth.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755782Ab2GDWJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 18:09:40 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: Mike Turquette <mturquette@ti.com>, Mike Turquette <mturquette@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>, stable@kernel.org,
        Mike Turquette <mturquette@linaro.org>,
        Ulf Hansson <ulf.hansson@stericsson.com>
Subject: [PATCH] clk: allow clocks without parents to change rate
Date: Thu,  5 Jul 2012 00:09:32 +0200
Message-Id: <1341439772-649-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The clk_change_rate() code would dereference clk->parent
to get clk->parent->rate without first checking that clk->parent
was valid. This doesn't work if the clock is (A) a root clock
and (B) can change rate. Such is the case with a VCO clock
like the ICST which consequently crash like this without
this patch:

Unable to handle kernel NULL pointer dereference at virtual address 0000001c
pgd = c0004000
[0000001c] *pgd=00000000
Internal error: Oops: 5 [#1] PREEMPT ARM
Modules linked in:
CPU: 0    Not tainted  (3.5.0-rc3-00003-g8156866-dirty #193)
PC is at clk_change_rate+0x34/0xd8
LR is at clk_change_rate+0x18/0xd8

Cc: stable@kernel.org
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Ulf Hansson <ulf.hansson@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/clk/clk.c |   22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 687b00d..032d79c 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -854,14 +854,22 @@ static void clk_change_rate(struct clk *clk)
 
 	old_rate = clk->rate;
 
-	if (clk->ops->set_rate)
-		clk->ops->set_rate(clk->hw, clk->new_rate, clk->parent->rate);
+	if (clk->ops->set_rate) {
+		if (clk->parent)
+			clk->ops->set_rate(clk->hw, clk->new_rate,
+					clk->parent->rate);
+		else
+			clk->ops->set_rate(clk->hw, clk->new_rate, 0);
+	}
 
-	if (clk->ops->recalc_rate)
-		clk->rate = clk->ops->recalc_rate(clk->hw,
-				clk->parent->rate);
-	else
-		clk->rate = clk->parent->rate;
+	if (clk->ops->recalc_rate) {
+		if (clk->parent)
+			clk->rate = clk->ops->recalc_rate(clk->hw,
+							clk->parent->rate);
+		else
+			clk->rate = clk->ops->recalc_rate(clk->hw, 0);
+	} else
+		clk->rate = clk->parent ? clk->parent->rate : 0;
 
 	if (clk->notifier_count && old_rate != clk->rate)
 		__clk_notify(clk, POST_RATE_CHANGE, old_rate, clk->rate);
-- 
1.7.10.4

