Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795Ab2LCIOt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 03:14:49 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:41458 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008Ab2LCIOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 03:14:48 -0500
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: mturquette@ti.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
Subject: [PATCH] clk: factor: calculate rate by do_div
Date: Mon,  3 Dec 2012 16:14:37 +0800
Message-Id: <1354522477-11991-1-git-send-email-haojian.zhuang@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clk->rate = parent->rate / div * mult

The formula is OK. But it may overflow while we do operate with
unsigned long. So use do_div instead.

Signed-off-by: Haojian Zhuang <haojian.zhuang@gmail.com>
---
 drivers/clk/clk-fixed-factor.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/clk-fixed-factor.c b/drivers/clk/clk-fixed-factor.c
index a489985..1ef271e 100644
--- a/drivers/clk/clk-fixed-factor.c
+++ b/drivers/clk/clk-fixed-factor.c
@@ -28,8 +28,11 @@ static unsigned long clk_factor_recalc_rate(struct clk_hw *hw,
 		unsigned long parent_rate)
 {
 	struct clk_fixed_factor *fix = to_clk_fixed_factor(hw);
+	unsigned long long int rate;
 
-	return parent_rate * fix->mult / fix->div;
+	rate = (unsigned long long int)parent_rate * fix->mult;
+	do_div(rate, fix->div);
+	return (unsigned long)rate;
 }
 
 static long clk_factor_round_rate(struct clk_hw *hw, unsigned long rate,
-- 
1.7.10.4

