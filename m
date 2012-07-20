Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425Ab2GTQHj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 12:07:39 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51031 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751297Ab2GTQHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 12:07:38 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] extcon: arizona: Implement button detection support
Date: Fri, 20 Jul 2012 17:07:29 +0100
Message-Id: <1342800449-10328-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As well as identifying accessories the accessory detection hardware on
Arizona class devices can also detect a number of buttons which we should
report via the input API.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/extcon/extcon-arizona.c |   72 +++++++++++++++++++++++++++++++++++----
 1 file changed, 65 insertions(+), 7 deletions(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index 427a289..fa2114f 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -21,6 +21,7 @@
 #include <linux/interrupt.h>
 #include <linux/err.h>
 #include <linux/gpio.h>
+#include <linux/input.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/regulator/consumer.h>
@@ -30,11 +31,14 @@
 #include <linux/mfd/arizona/pdata.h>
 #include <linux/mfd/arizona/registers.h>
 
+#define ARIZONA_NUM_BUTTONS 6
+
 struct arizona_extcon_info {
 	struct device *dev;
 	struct arizona *arizona;
 	struct mutex lock;
 	struct regulator *micvdd;
+	struct input_dev *input;
 
 	int micd_mode;
 	const struct arizona_micd_config *micd_modes;
@@ -54,6 +58,18 @@ static const struct arizona_micd_config micd_default_modes[] = {
 	{ 0,                  2 << ARIZONA_MICD_BIAS_SRC_SHIFT, 1 },
 };
 
+static struct {
+	u16 status;
+	int report;
+} arizona_lvl_to_key[ARIZONA_NUM_BUTTONS] = {
+	{  0x1, BTN_0 },
+	{  0x2, BTN_1 },
+	{  0x4, BTN_2 },
+	{  0x8, BTN_3 },
+	{ 0x10, BTN_4 },
+	{ 0x20, BTN_5 },
+};
+
 #define ARIZONA_CABLE_MECHANICAL 0
 #define ARIZONA_CABLE_MICROPHONE 1
 #define ARIZONA_CABLE_HEADPHONE  2
@@ -133,6 +149,7 @@ static void arizona_stop_mic(struct arizona_extcon_info *info)
 
 	if (change) {
 		regulator_disable(info->micvdd);
+		pm_runtime_mark_last_busy(info->dev);
 		pm_runtime_put_autosuspend(info->dev);
 	}
 }
@@ -141,8 +158,8 @@ static irqreturn_t arizona_micdet(int irq, void *data)
 {
 	struct arizona_extcon_info *info = data;
 	struct arizona *arizona = info->arizona;
-	unsigned int val;
-	int ret;
+	unsigned int val, lvl;
+	int ret, i;
 
 	mutex_lock(&info->lock);
 
@@ -219,13 +236,22 @@ static irqreturn_t arizona_micdet(int irq, void *data)
 
 	/*
 	 * If we're still detecting and we detect a short then we've
-	 * got a headphone.  Otherwise it's a button press, the
-	 * button reporting is stubbed out for now.
+	 * got a headphone.  Otherwise it's a button press.
 	 */
 	if (val & 0x3fc) {
 		if (info->mic) {
 			dev_dbg(arizona->dev, "Mic button detected\n");
 
+			lvl = val & ARIZONA_MICD_LVL_MASK;
+			lvl >>= ARIZONA_MICD_LVL_SHIFT;
+
+			for (i = 0; i < ARIZONA_NUM_BUTTONS; i++)
+				if (lvl & arizona_lvl_to_key[i].status)
+					input_report_key(info->input,
+							 arizona_lvl_to_key[i].report,
+							 1);
+			input_sync(info->input);
+
 		} else if (info->detecting) {
 			dev_dbg(arizona->dev, "Headphone detected\n");
 			info->detecting = false;
@@ -244,6 +270,10 @@ static irqreturn_t arizona_micdet(int irq, void *data)
 		}
 	} else {
 		dev_dbg(arizona->dev, "Mic button released\n");
+		for (i = 0; i < ARIZONA_NUM_BUTTONS; i++)
+			input_report_key(info->input,
+					 arizona_lvl_to_key[i].report, 0);
+		input_sync(info->input);
 	}
 
 handled:
@@ -258,7 +288,7 @@ static irqreturn_t arizona_jackdet(int irq, void *data)
 	struct arizona_extcon_info *info = data;
 	struct arizona *arizona = info->arizona;
 	unsigned int val;
-	int ret;
+	int ret, i;
 
 	pm_runtime_get_sync(info->dev);
 
@@ -288,6 +318,11 @@ static irqreturn_t arizona_jackdet(int irq, void *data)
 
 		arizona_stop_mic(info);
 
+		for (i = 0; i < ARIZONA_NUM_BUTTONS; i++)
+			input_report_key(info->input,
+					 arizona_lvl_to_key[i].report, 0);
+		input_sync(info->input);
+
 		ret = extcon_update_state(&info->edev, 0xffffffff, 0);
 		if (ret != 0)
 			dev_err(arizona->dev, "Removal report failed: %d\n",
@@ -307,7 +342,7 @@ static int __devinit arizona_extcon_probe(struct platform_device *pdev)
 	struct arizona *arizona = dev_get_drvdata(pdev->dev.parent);
 	struct arizona_pdata *pdata;
 	struct arizona_extcon_info *info;
-	int ret, mode;
+	int ret, mode, i;
 
 	pdata = dev_get_platdata(arizona->dev);
 
@@ -382,6 +417,20 @@ static int __devinit arizona_extcon_probe(struct platform_device *pdev)
 
 	arizona_extcon_set_mode(info, 0);
 
+	info->input = input_allocate_device();
+	if (!info->input) {
+		dev_err(arizona->dev, "Can't allocate input dev\n");
+		ret = -ENOMEM;
+		goto err_register;
+	}
+
+	for (i = 0; i < ARIZONA_NUM_BUTTONS; i++)
+		input_set_capability(info->input, EV_KEY,
+				     arizona_lvl_to_key[i].report);
+	info->input->name = "Headset";
+	info->input->phys = "arizona/extcon";
+	info->input->dev.parent = &pdev->dev;
+
 	pm_runtime_enable(&pdev->dev);
 	pm_runtime_idle(&pdev->dev);
 	pm_runtime_get_sync(&pdev->dev);
@@ -391,7 +440,7 @@ static int __devinit arizona_extcon_probe(struct platform_device *pdev)
 	if (ret != 0) {
 		dev_err(&pdev->dev, "Failed to get JACKDET rise IRQ: %d\n",
 			ret);
-		goto err_register;
+		goto err_input;
 	}
 
 	ret = arizona_set_irq_wake(arizona, ARIZONA_IRQ_JD_RISE, 1);
@@ -436,6 +485,12 @@ static int __devinit arizona_extcon_probe(struct platform_device *pdev)
 
 	pm_runtime_put(&pdev->dev);
 
+	ret = input_register_device(info->input);
+	if (ret) {
+		dev_err(&pdev->dev, "Can't register input device: %d\n", ret);
+		goto err_fall_wake;
+	}
+
 	return 0;
 
 err_fall_wake:
@@ -446,6 +501,8 @@ err_rise_wake:
 	arizona_set_irq_wake(arizona, ARIZONA_IRQ_JD_RISE, 0);
 err_rise:
 	arizona_free_irq(arizona, ARIZONA_IRQ_JD_RISE, info);
+err_input:
+	input_free_device(info->input);
 err_register:
 	pm_runtime_disable(&pdev->dev);
 	extcon_dev_unregister(&info->edev);
@@ -468,6 +525,7 @@ static int __devexit arizona_extcon_remove(struct platform_device *pdev)
 	regmap_update_bits(arizona->regmap, ARIZONA_JACK_DETECT_ANALOGUE,
 			   ARIZONA_JD1_ENA, 0);
 	arizona_clk32k_disable(arizona);
+	input_unregister_device(info->input);
 	extcon_dev_unregister(&info->edev);
 
 	return 0;
-- 
1.7.10.4

