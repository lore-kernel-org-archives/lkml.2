Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812Ab2L0AOw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 19:14:52 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:62478 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697Ab2L0AOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 19:14:42 -0500
From: Tony Prisk <linux@prisktech.co.nz>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCH 2/3] clk: vt8500: Fix device clock divisor calculations
Date: Thu, 27 Dec 2012 13:14:30 +1300
Message-Id: <1356567272-3420-3-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1356567272-3420-1-git-send-email-linux@prisktech.co.nz>
References: <1356567272-3420-1-git-send-email-linux@prisktech.co.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When calculating device clock divisor values in set_rate and
round_rate, we do a simple integer divide. If parent_rate / rate
has a fraction, this is dropped which results in the device clock
being set too high.

This patch corrects the problem by adding 1 to the calculated
divisor if the division would have had a decimal result.

Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
---
 drivers/clk/clk-vt8500.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/clk/clk-vt8500.c b/drivers/clk/clk-vt8500.c
index 0cb26be..3306c2b 100644
--- a/drivers/clk/clk-vt8500.c
+++ b/drivers/clk/clk-vt8500.c
@@ -123,6 +123,10 @@ static long vt8500_dclk_round_rate(struct clk_hw *hw, unsigned long rate,
 	struct clk_device *cdev = to_clk_device(hw);
 	u32 divisor = *prate / rate;
 
+	/* If prate / rate would be decimal, incr the divisor */
+	if (rate * divisor < *prate)
+		divisor++;
+
 	/*
 	 * If this is a request for SDMMC we have to adjust the divisor
 	 * when >31 to use the fixed predivisor
@@ -141,6 +145,10 @@ static int vt8500_dclk_set_rate(struct clk_hw *hw, unsigned long rate,
 	u32 divisor = parent_rate / rate;
 	unsigned long flags = 0;
 
+	/* If prate / rate would be decimal, incr the divisor */
+	if (rate * divisor < *prate)
+		divisor++;
+
 	if (divisor == cdev->div_mask + 1)
 		divisor = 0;
 
-- 
1.7.9.5

