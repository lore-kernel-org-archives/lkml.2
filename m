Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935066Ab1JEQvQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 12:51:16 -0400
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:60228 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935004Ab1JEQvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 12:51:15 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 2/2] mfd/dbx500-prcmu: refactor request_clock() functions
Date: Wed, 5 Oct 2011 18:50:58 +0200
Message-ID: <1317833458-747-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This refactors the mfd/dbx500-prcmu drivers to use a switch()
statement rather than nested if/else-construction.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
Patch created in response to Samuel Ortiz' review comment
on the patch named "mfd/db8500-prcmu: add accessors for PLL
and SGA clock"
---
 drivers/mfd/db5500-prcmu.c |   21 ++++++++++++---------
 drivers/mfd/db8500-prcmu.c |   19 +++++++++++--------
 2 files changed, 23 insertions(+), 17 deletions(-)

diff --git a/drivers/mfd/db5500-prcmu.c b/drivers/mfd/db5500-prcmu.c
index 47fd0e9..f2c79b2 100644
--- a/drivers/mfd/db5500-prcmu.c
+++ b/drivers/mfd/db5500-prcmu.c
@@ -588,20 +588,23 @@ unlock_and_return:
  */
 int db5500_prcmu_request_clock(u8 clock, bool enable)
 {
-	if (clock < PRCMU_NUM_REG_CLOCKS)
-		return request_reg_clock(clock, enable);
-	else if (clock == PRCMU_TIMCLK)
+	switch(clock) {
+	case PRCMU_TIMCLK:
 		return request_timclk(enable);
-	else if (clock == PRCMU_PLLSOC0)
+	case PRCMU_PLLSOC0:
 		return request_pll(DB5500_PLL_SOC0, enable);
-	else if (clock == PRCMU_PLLSOC1)
+	case PRCMU_PLLSOC1:
 		return request_pll(DB5500_PLL_SOC1, enable);
-	else if (clock == PRCMU_PLLDDR)
+	case PRCMU_PLLDDR:
 		return request_pll(DB5500_PLL_DDR, enable);
-	else if (clock == PRCMU_SYSCLK)
+	case PRCMU_SYSCLK:
 		return request_sysclk(enable);
-	else
-		return -EINVAL;
+	default:
+		break;
+	}
+	if (clock < PRCMU_NUM_REG_CLOCKS)
+		return request_reg_clock(clock, enable);
+	return -EINVAL;
 }
 
 /* This function should only be called while mb0_transfer.lock is held. */
diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
index 98da431..e996d11 100644
--- a/drivers/mfd/db8500-prcmu.c
+++ b/drivers/mfd/db8500-prcmu.c
@@ -1433,18 +1433,21 @@ static int request_sga_clock(u8 clock, bool enable)
  */
 int db8500_prcmu_request_clock(u8 clock, bool enable)
 {
-	if (clock == PRCMU_SGACLK)
+	switch(clock) {
+	case PRCMU_SGACLK:
 		return request_sga_clock(clock, enable);
-	else if (clock < PRCMU_NUM_REG_CLOCKS)
-		return request_reg_clock(clock, enable);
-	else if (clock == PRCMU_TIMCLK)
+	case PRCMU_TIMCLK:
 		return request_timclk(enable);
-	else if (clock == PRCMU_SYSCLK)
+	case PRCMU_SYSCLK:
 		return request_sysclk(enable);
-	else if (clock == PRCMU_PLLSOC1)
+	case PRCMU_PLLSOC1:
 		return request_pll(clock, enable);
-	else
-		return -EINVAL;
+	default:
+		break;
+	}
+	if (clock < PRCMU_NUM_REG_CLOCKS)
+		return request_reg_clock(clock, enable);
+	return -EINVAL;
 }
 
 int db8500_prcmu_config_esram0_deep_sleep(u8 state)
-- 
1.7.3.2

