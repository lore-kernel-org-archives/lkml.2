Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921Ab2F2Nzq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 09:55:46 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55998 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750806Ab2F2Nzn (ORCPT
	<rfc822;linux-kernel@Vger.kernel.org>);
	Fri, 29 Jun 2012 09:55:43 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/2] mfd: wm8994: Use regcache_sync_region() to sync GPIO registers on suspend
Date: Fri, 29 Jun 2012 14:55:39 +0100
Message-Id: <1340978140-11572-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we have regcache sync region we can use it to do a more efficient
sync of the pin configuration after we reset the device during suspend.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8994-core.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
index f75cdcc..53293c7 100644
--- a/drivers/mfd/wm8994-core.c
+++ b/drivers/mfd/wm8994-core.c
@@ -196,7 +196,6 @@ static int wm8994_suspend(struct device *dev)
 {
 	struct wm8994 *wm8994 = dev_get_drvdata(dev);
 	int ret;
-	int gpio_regs[WM8994_NUM_GPIO_REGS];
 
 	/* Don't actually go through with the suspend if the CODEC is
 	 * still active (eg, for audio passthrough from CP. */
@@ -278,27 +277,23 @@ static int wm8994_suspend(struct device *dev)
 				WM8994_LDO1ENA_PD | WM8994_LDO2ENA_PD,
 				WM8994_LDO1ENA_PD | WM8994_LDO2ENA_PD);
 
-	/* Save GPIO registers before reset */
-	regmap_bulk_read(wm8994->regmap, WM8994_GPIO_1, gpio_regs,
-			 WM8994_NUM_GPIO_REGS);
-
 	/* Explicitly put the device into reset in case regulators
 	 * don't get disabled in order to ensure consistent restart.
 	 */
 	wm8994_reg_write(wm8994, WM8994_SOFTWARE_RESET,
 			 wm8994_reg_read(wm8994, WM8994_SOFTWARE_RESET));
 
+	regcache_mark_dirty(wm8994->regmap);
+
 	/* Restore GPIO registers to prevent problems with mismatched
 	 * pin configurations.
 	 */
-	ret = regmap_bulk_write(wm8994->regmap, WM8994_GPIO_1, gpio_regs,
-				WM8994_NUM_GPIO_REGS);
+	ret = regcache_sync_region(wm8994->regmap, WM8994_GPIO_1,
+				   WM8994_GPIO_11);
 	if (ret != 0)
 		dev_err(dev, "Failed to restore GPIO registers: %d\n", ret);
 
 	regcache_cache_only(wm8994->regmap, true);
-	regcache_mark_dirty(wm8994->regmap);
-
 	wm8994->suspended = true;
 
 	ret = regulator_bulk_disable(wm8994->num_supplies,
-- 
1.7.10

