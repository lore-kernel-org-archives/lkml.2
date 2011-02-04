Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857Ab1BDO52 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 09:57:28 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56246 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751812Ab1BDO51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 09:57:27 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2.6.38] mfd: Don't suspend WM8994 if the CODEC is not suspended
Date: Fri,  4 Feb 2011 14:57:43 +0000
Message-Id: <1296831463-19643-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ASoC supports keeping the audio subsysetm active over suspend in order
to support use cases such as audio passthrough from a cellular modem
with the main CPU suspended. Ensure that we don't power down the CODEC
when this is happening by checking to see if VMID is up and skipping
suspend and resume when it is. If the CODEC has suspended then it'll
turn VMID off before the core suspend() gets called.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---

This is a bug fix for interaction with the ASoC suspend feature.
Ideally it'd get CCed to stable as well but it's slightly invasive for
that.

 drivers/mfd/wm8994-core.c       |   18 ++++++++++++++++++
 include/linux/mfd/wm8994/core.h |    1 +
 2 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
index 41233c7..f4016a0 100644
--- a/drivers/mfd/wm8994-core.c
+++ b/drivers/mfd/wm8994-core.c
@@ -246,6 +246,16 @@ static int wm8994_suspend(struct device *dev)
 	struct wm8994 *wm8994 = dev_get_drvdata(dev);
 	int ret;
 
+	/* Don't actually go through with the suspend if the CODEC is
+	 * still active (eg, for audio passthrough from CP. */
+	ret = wm8994_reg_read(wm8994, WM8994_POWER_MANAGEMENT_1);
+	if (ret < 0) {
+		dev_err(dev, "Failed to read power status: %d\n", ret);
+	} else if (ret & WM8994_VMID_SEL_MASK) {
+		dev_dbg(dev, "CODEC still active, ignoring suspend\n");
+		return 0;
+	}
+
 	/* GPIO configuration state is saved here since we may be configuring
 	 * the GPIO alternate functions even if we're not using the gpiolib
 	 * driver for them.
@@ -261,6 +271,8 @@ static int wm8994_suspend(struct device *dev)
 	if (ret < 0)
 		dev_err(dev, "Failed to save LDO registers: %d\n", ret);
 
+	wm8994->suspended = true;
+
 	ret = regulator_bulk_disable(wm8994->num_supplies,
 				     wm8994->supplies);
 	if (ret != 0) {
@@ -276,6 +288,10 @@ static int wm8994_resume(struct device *dev)
 	struct wm8994 *wm8994 = dev_get_drvdata(dev);
 	int ret;
 
+	/* We may have lied to the PM core about suspending */
+	if (!wm8994->suspended)
+		return 0;
+
 	ret = regulator_bulk_enable(wm8994->num_supplies,
 				    wm8994->supplies);
 	if (ret != 0) {
@@ -298,6 +314,8 @@ static int wm8994_resume(struct device *dev)
 	if (ret < 0)
 		dev_err(dev, "Failed to restore GPIO registers: %d\n", ret);
 
+	wm8994->suspended = false;
+
 	return 0;
 }
 #endif
diff --git a/include/linux/mfd/wm8994/core.h b/include/linux/mfd/wm8994/core.h
index 3fd3684..ef4f0b6 100644
--- a/include/linux/mfd/wm8994/core.h
+++ b/include/linux/mfd/wm8994/core.h
@@ -71,6 +71,7 @@ struct wm8994 {
 	u16 irq_masks_cache[WM8994_NUM_IRQ_REGS];
 
 	/* Used over suspend/resume */
+	bool suspended;
 	u16 ldo_regs[WM8994_NUM_LDO_REGS];
 	u16 gpio_regs[WM8994_NUM_GPIO_REGS];
 
-- 
1.7.2.3

