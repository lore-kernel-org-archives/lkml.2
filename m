Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848Ab2L0AOy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 19:14:54 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:57701 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab2L0AOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 19:14:42 -0500
From: Tony Prisk <linux@prisktech.co.nz>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCH 3/3] clk: vt8500: Fix division-by-0 when requested rate=0
Date: Thu, 27 Dec 2012 13:14:31 +1300
Message-Id: <1356567272-3420-4-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1356567272-3420-1-git-send-email-linux@prisktech.co.nz>
References: <1356567272-3420-1-git-send-email-linux@prisktech.co.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A request to vt8500_dclk_(round_rate/set_rate) with rate=0 results
in a division-by-0 in the kernel.

Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
---
 drivers/clk/clk-vt8500.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/clk-vt8500.c b/drivers/clk/clk-vt8500.c
index 3306c2b..db7d41f 100644
--- a/drivers/clk/clk-vt8500.c
+++ b/drivers/clk/clk-vt8500.c
@@ -121,7 +121,12 @@ static long vt8500_dclk_round_rate(struct clk_hw *hw, unsigned long rate,
 				unsigned long *prate)
 {
 	struct clk_device *cdev = to_clk_device(hw);
-	u32 divisor = *prate / rate;
+	u32 divisor;
+
+	if (rate == 0)
+		return 0;
+
+	divisor = *prate / rate;
 
 	/* If prate / rate would be decimal, incr the divisor */
 	if (rate * divisor < *prate)
@@ -142,9 +147,14 @@ static int vt8500_dclk_set_rate(struct clk_hw *hw, unsigned long rate,
 				unsigned long parent_rate)
 {
 	struct clk_device *cdev = to_clk_device(hw);
-	u32 divisor = parent_rate / rate;
+	u32 divisor;
 	unsigned long flags = 0;
 
+	if (rate == 0)
+		return 0;
+
+	divisor =  parent_rate / rate;
+
 	/* If prate / rate would be decimal, incr the divisor */
 	if (rate * divisor < *prate)
 		divisor++;
-- 
1.7.9.5

