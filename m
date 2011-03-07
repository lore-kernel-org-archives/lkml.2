Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894Ab1CGPzi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 10:55:38 -0500
Received: from dakia2.marvell.com ([65.219.4.35]:33391 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754162Ab1CGPzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 10:55:20 -0500
X-ASG-Debug-ID: 1299512694-082c75250001-xx1T2L
X-Barracuda-Envelope-From: haojian.zhuang@marvell.com
From: Haojian Zhuang <haojian.zhuang@marvell.com>
To: johnpol@2ka.mipt.ru, sameo@linux.intel.com, a.zummo@towertech.it,
        lrg@slimlogic.co.uk, broonie@opensource.wolfsonmicro.com,
        dmitry.torokhov@gmail.com, dtor@mail.ru, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>
X-ASG-Orig-Subj: [PATCH] input: touchscreen: move initialization in 88pm860x
Subject: [PATCH] input: touchscreen: move initialization in 88pm860x
Date: Mon,  7 Mar 2011 23:43:15 +0800
X-ASG-Orig-Subj: [PATCH] input: touchscreen: move initialization in 88pm860x
Message-Id: <1299512600-29047-7-git-send-email-haojian.zhuang@marvell.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1299512600-29047-6-git-send-email-haojian.zhuang@marvell.com>
References: <1299512600-29047-1-git-send-email-haojian.zhuang@marvell.com>
 <1299512600-29047-2-git-send-email-haojian.zhuang@marvell.com>
 <1299512600-29047-3-git-send-email-haojian.zhuang@marvell.com>
 <1299512600-29047-4-git-send-email-haojian.zhuang@marvell.com>
 <1299512600-29047-5-git-send-email-haojian.zhuang@marvell.com>
 <1299512600-29047-6-git-send-email-haojian.zhuang@marvell.com>
X-Barracuda-Connect: maili.marvell.com[10.68.76.51]
X-Barracuda-Start-Time: 1299512694
X-Barracuda-URL: http://10.68.76.222:80/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: -1002.00
X-Barracuda-Spam-Status: No, SCORE=-1002.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=1000.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the GPADC initialization code from mfd driver to touch driver.

Signed-off-by: Haojian Zhuang <haojian.zhuang@marvell.com>
---
 drivers/input/touchscreen/88pm860x-ts.c |   50 ++++++++++++++++++++++++------
 drivers/mfd/88pm860x-core.c             |   51 -------------------------------
 2 files changed, 40 insertions(+), 61 deletions(-)

diff --git a/drivers/input/touchscreen/88pm860x-ts.c b/drivers/input/touchscreen/88pm860x-ts.c
index 7d481cc..aa8fe1a 100644
--- a/drivers/input/touchscreen/88pm860x-ts.c
+++ b/drivers/input/touchscreen/88pm860x-ts.c
@@ -11,10 +11,11 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
+#include <linux/slab.h>
 #include <linux/i2c.h>
 #include <linux/input.h>
+#include <linux/mfd/core.h>
 #include <linux/mfd/88pm860x.h>
-#include <linux/slab.h>
 
 #define MEAS_LEN		(8)
 #define ACCURATE_BIT		(12)
@@ -152,13 +153,43 @@ static void pm860x_touch_close(struct input_dev *dev)
 	pm860x_set_bits(touch->i2c, MEAS_EN3, data, 0);
 }
 
+static void __devinit pm860x_gpadc_init(struct i2c_client *i2c,
+					struct pm860x_touch_pdata *pdata)
+{
+	int data;
+
+	/* set GPADC MISC1 register */
+	data = 0;
+	data |= (pdata->gpadc_prebias << 1) & PM8607_GPADC_PREBIAS_MASK;
+	data |= (pdata->slot_cycle << 3) & PM8607_GPADC_SLOT_CYCLE_MASK;
+	data |= (pdata->off_scale << 5) & PM8607_GPADC_OFF_SCALE_MASK;
+	data |= (pdata->sw_cal << 7) & PM8607_GPADC_SW_CAL_MASK;
+	if (data)
+		pm860x_reg_write(i2c, PM8607_GPADC_MISC1, data);
+
+	/* set tsi prebias time */
+	if (pdata->tsi_prebias) {
+		data = pdata->tsi_prebias;
+		pm860x_reg_write(i2c, PM8607_TSI_PREBIAS, data);
+	}
+
+	/* set prebias & prechg time of pen detect */
+	data = 0;
+	data |= pdata->pen_prebias & PM8607_PD_PREBIAS_MASK;
+	data |= (pdata->pen_prechg << 5) & PM8607_PD_PRECHG_MASK;
+	if (data)
+		pm860x_reg_write(i2c, PM8607_PD_PREBIAS, data);
+
+	pm860x_set_bits(i2c, PM8607_GPADC_MISC1,
+			PM8607_GPADC_EN, PM8607_GPADC_EN);
+}
+
 static int __devinit pm860x_touch_probe(struct platform_device *pdev)
 {
 	struct pm860x_chip *chip = dev_get_drvdata(pdev->dev.parent);
-	struct pm860x_platform_data *pm860x_pdata =		\
-				pdev->dev.parent->platform_data;
 	struct pm860x_touch_pdata *pdata = NULL;
 	struct pm860x_touch *touch;
+	struct mfd_cell *cell;
 	int irq, ret;
 
 	irq = platform_get_irq(pdev, 0);
@@ -167,13 +198,11 @@ static int __devinit pm860x_touch_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	if (!pm860x_pdata) {
-		dev_err(&pdev->dev, "platform data is missing\n");
-		return -EINVAL;
-	}
-
-	pdata = pm860x_pdata->touch;
-	if (!pdata) {
+	cell = pdev->dev.platform_data;
+	if (cell == NULL)
+		return -ENODEV;
+	pdata = cell->mfd_data;
+	if (pdata == NULL) {
 		dev_err(&pdev->dev, "touchscreen data is missing\n");
 		return -EINVAL;
 	}
@@ -226,6 +255,7 @@ static int __devinit pm860x_touch_probe(struct platform_device *pdev)
 		goto out_rg;
 	}
 
+	pm860x_gpadc_init(touch->i2c, pdata);
 	platform_set_drvdata(pdev, touch);
 	INIT_DELAYED_WORK(&touch->poll_work, pm860x_poll_work);
 	return 0;
diff --git a/drivers/mfd/88pm860x-core.c b/drivers/mfd/88pm860x-core.c
index 42c4fa2..7879569 100644
--- a/drivers/mfd/88pm860x-core.c
+++ b/drivers/mfd/88pm860x-core.c
@@ -362,53 +362,6 @@ static struct irq_chip pm860x_irq_chip = {
 	.irq_disable	= pm860x_irq_disable,
 };
 
-static int __devinit device_gpadc_init(struct pm860x_chip *chip,
-				       struct pm860x_platform_data *pdata)
-{
-	struct i2c_client *i2c = (chip->id == CHIP_PM8607) ? chip->client \
-				: chip->companion;
-	int data;
-	int ret;
-
-	/* initialize GPADC without activating it */
-
-	if (!pdata || !pdata->touch)
-		return -EINVAL;
-
-	/* set GPADC MISC1 register */
-	data = 0;
-	data |= (pdata->touch->gpadc_prebias << 1) & PM8607_GPADC_PREBIAS_MASK;
-	data |= (pdata->touch->slot_cycle << 3) & PM8607_GPADC_SLOT_CYCLE_MASK;
-	data |= (pdata->touch->off_scale << 5) & PM8607_GPADC_OFF_SCALE_MASK;
-	data |= (pdata->touch->sw_cal << 7) & PM8607_GPADC_SW_CAL_MASK;
-	if (data) {
-		ret = pm860x_reg_write(i2c, PM8607_GPADC_MISC1, data);
-		if (ret < 0)
-			goto out;
-	}
-	/* set tsi prebias time */
-	if (pdata->touch->tsi_prebias) {
-		data = pdata->touch->tsi_prebias;
-		ret = pm860x_reg_write(i2c, PM8607_TSI_PREBIAS, data);
-		if (ret < 0)
-			goto out;
-	}
-	/* set prebias & prechg time of pen detect */
-	data = 0;
-	data |= pdata->touch->pen_prebias & PM8607_PD_PREBIAS_MASK;
-	data |= (pdata->touch->pen_prechg << 5) & PM8607_PD_PRECHG_MASK;
-	if (data) {
-		ret = pm860x_reg_write(i2c, PM8607_PD_PREBIAS, data);
-		if (ret < 0)
-			goto out;
-	}
-
-	ret = pm860x_set_bits(i2c, PM8607_GPADC_MISC1,
-			      PM8607_GPADC_EN, PM8607_GPADC_EN);
-out:
-	return ret;
-}
-
 static int __devinit device_irq_init(struct pm860x_chip *chip,
 				     struct pm860x_platform_data *pdata)
 {
@@ -758,10 +711,6 @@ static void __devinit device_8607_init(struct pm860x_chip *chip,
 		goto out;
 	}
 
-	ret = device_gpadc_init(chip, pdata);
-	if (ret < 0)
-		goto out;
-
 	ret = device_irq_init(chip, pdata);
 	if (ret < 0)
 		goto out;
-- 
1.5.6.5

