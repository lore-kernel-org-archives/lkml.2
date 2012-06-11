Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253Ab2FKQn7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 12:43:59 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52122 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972Ab2FKQn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 12:43:58 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Chris Rattray <crattray@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Tue, 12 Jun 2012 00:43:35 +0800
Message-Id: <1339433017-7150-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
X-SA-Exim-Connect-IP: 116.228.53.169
X-SA-Exim-Mail-From: broonie@opensource.wolfsonmicro.com
Subject: [PATCH] mfd: wm8994: Restore pin configuration after reset during suspend
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Rattray <crattray@opensource.wolfsonmicro.com>

Ensure that we leave the device with the pins in the expected
configuration if we leave it in reset over suspend, avoiding any
interoperation problems with other devices in the system.

Signed-off-by: Chris Rattray <crattray@opensource.wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8994-core.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
index 1e321d3..f75cdcc 100644
--- a/drivers/mfd/wm8994-core.c
+++ b/drivers/mfd/wm8994-core.c
@@ -196,6 +196,7 @@ static int wm8994_suspend(struct device *dev)
 {
 	struct wm8994 *wm8994 = dev_get_drvdata(dev);
 	int ret;
+	int gpio_regs[WM8994_NUM_GPIO_REGS];
 
 	/* Don't actually go through with the suspend if the CODEC is
 	 * still active (eg, for audio passthrough from CP. */
@@ -277,12 +278,24 @@ static int wm8994_suspend(struct device *dev)
 				WM8994_LDO1ENA_PD | WM8994_LDO2ENA_PD,
 				WM8994_LDO1ENA_PD | WM8994_LDO2ENA_PD);
 
+	/* Save GPIO registers before reset */
+	regmap_bulk_read(wm8994->regmap, WM8994_GPIO_1, gpio_regs,
+			 WM8994_NUM_GPIO_REGS);
+
 	/* Explicitly put the device into reset in case regulators
 	 * don't get disabled in order to ensure consistent restart.
 	 */
 	wm8994_reg_write(wm8994, WM8994_SOFTWARE_RESET,
 			 wm8994_reg_read(wm8994, WM8994_SOFTWARE_RESET));
 
+	/* Restore GPIO registers to prevent problems with mismatched
+	 * pin configurations.
+	 */
+	ret = regmap_bulk_write(wm8994->regmap, WM8994_GPIO_1, gpio_regs,
+				WM8994_NUM_GPIO_REGS);
+	if (ret != 0)
+		dev_err(dev, "Failed to restore GPIO registers: %d\n", ret);
+
 	regcache_cache_only(wm8994->regmap, true);
 	regcache_mark_dirty(wm8994->regmap);
 
-- 
1.7.10

