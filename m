Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751082Ab2JDEVm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 00:21:42 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54519 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab2JDEVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 00:21:41 -0400
From: Fabio Estevam <festevam@gmail.com>
To: sameo@linux.intel.com
Cc: broonie@opensource.wolfsonmicro.com, ashish.jangam@kpitcummins.com,
        dchen@diasemi.com, arnd@arndb.de, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        <linux-input@vger.kernel.org>
Subject: [PATCH v2 3/6] Input: da9052_tsi.c: Fix interrupt handling
Date: Thu,  4 Oct 2012 01:21:30 -0300
Message-Id: <1349324490-738-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

Currently da9062_tsi does not probe and it fails as follows:

da9052 1-0048: Unable to determine device interrupts

Use the new da9052 irq functions and allow the driver to probe and operate 
correctly.

Tested on mx53qsb board using 'evtest' tool.

Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: <linux-input@vger.kernel.org>
Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
Changes since v2:
- Sent the correct patch now. v1 was the incorrect version.

 drivers/input/touchscreen/da9052_tsi.c |   59 +++++++++++---------------------
 1 file changed, 20 insertions(+), 39 deletions(-)

diff --git a/drivers/input/touchscreen/da9052_tsi.c b/drivers/input/touchscreen/da9052_tsi.c
index e8df341..33fd3fa 100644
--- a/drivers/input/touchscreen/da9052_tsi.c
+++ b/drivers/input/touchscreen/da9052_tsi.c
@@ -27,8 +27,6 @@ struct da9052_tsi {
 	struct input_dev *dev;
 	struct delayed_work ts_pen_work;
 	struct mutex mutex;
-	unsigned int irq_pendwn;
-	unsigned int irq_datardy;
 	bool stopped;
 	bool adc_on;
 };
@@ -45,8 +43,8 @@ static irqreturn_t da9052_ts_pendwn_irq(int irq, void *data)
 
 	if (!tsi->stopped) {
 		/* Mask PEN_DOWN event and unmask TSI_READY event */
-		disable_irq_nosync(tsi->irq_pendwn);
-		enable_irq(tsi->irq_datardy);
+		da9052_disable_irq_nosync(tsi->da9052, DA9052_IRQ_PENDOWN);
+		da9052_enable_irq(tsi->da9052, DA9052_IRQ_TSIREADY);
 
 		da9052_ts_adc_toggle(tsi, true);
 
@@ -137,8 +135,8 @@ static void da9052_ts_pen_work(struct work_struct *work)
 				return;
 
 			/* Mask TSI_READY event and unmask PEN_DOWN event */
-			disable_irq(tsi->irq_datardy);
-			enable_irq(tsi->irq_pendwn);
+			da9052_disable_irq(tsi->da9052, DA9052_IRQ_TSIREADY);
+			da9052_enable_irq(tsi->da9052, DA9052_IRQ_PENDOWN);
 		}
 	}
 }
@@ -197,7 +195,7 @@ static int da9052_ts_input_open(struct input_dev *input_dev)
 	mb();
 
 	/* Unmask PEN_DOWN event */
-	enable_irq(tsi->irq_pendwn);
+	da9052_enable_irq(tsi->da9052, DA9052_IRQ_PENDOWN);
 
 	/* Enable Pen Detect Circuit */
 	return da9052_reg_update(tsi->da9052, DA9052_TSI_CONT_A_REG,
@@ -210,11 +208,11 @@ static void da9052_ts_input_close(struct input_dev *input_dev)
 
 	tsi->stopped = true;
 	mb();
-	disable_irq(tsi->irq_pendwn);
+	da9052_disable_irq(tsi->da9052, DA9052_IRQ_PENDOWN);
 	cancel_delayed_work_sync(&tsi->ts_pen_work);
 
 	if (tsi->adc_on) {
-		disable_irq(tsi->irq_datardy);
+		da9052_disable_irq(tsi->da9052, DA9052_IRQ_TSIREADY);
 		da9052_ts_adc_toggle(tsi, false);
 
 		/*
@@ -222,7 +220,7 @@ static void da9052_ts_input_close(struct input_dev *input_dev)
 		 * twice and we need to enable it to keep enable/disable
 		 * counter balanced. IRQ is still off though.
 		 */
-		enable_irq(tsi->irq_pendwn);
+		da9052_enable_irq(tsi->da9052, DA9052_IRQ_PENDOWN);
 	}
 
 	/* Disable Pen Detect Circuit */
@@ -234,21 +232,12 @@ static int __devinit da9052_ts_probe(struct platform_device *pdev)
 	struct da9052 *da9052;
 	struct da9052_tsi *tsi;
 	struct input_dev *input_dev;
-	int irq_pendwn;
-	int irq_datardy;
 	int error;
 
 	da9052 = dev_get_drvdata(pdev->dev.parent);
 	if (!da9052)
 		return -EINVAL;
 
-	irq_pendwn = platform_get_irq_byname(pdev, "PENDWN");
-	irq_datardy = platform_get_irq_byname(pdev, "TSIRDY");
-	if (irq_pendwn < 0 || irq_datardy < 0) {
-		dev_err(da9052->dev, "Unable to determine device interrupts\n");
-		return -ENXIO;
-	}
-
 	tsi = kzalloc(sizeof(struct da9052_tsi), GFP_KERNEL);
 	input_dev = input_allocate_device();
 	if (!tsi || !input_dev) {
@@ -258,8 +247,6 @@ static int __devinit da9052_ts_probe(struct platform_device *pdev)
 
 	tsi->da9052 = da9052;
 	tsi->dev = input_dev;
-	tsi->irq_pendwn = da9052->irq_base + irq_pendwn;
-	tsi->irq_datardy = da9052->irq_base + irq_datardy;
 	tsi->stopped = true;
 	INIT_DELAYED_WORK(&tsi->ts_pen_work, da9052_ts_pen_work);
 
@@ -287,31 +274,25 @@ static int __devinit da9052_ts_probe(struct platform_device *pdev)
 	/* Disable ADC */
 	da9052_ts_adc_toggle(tsi, false);
 
-	error = request_threaded_irq(tsi->irq_pendwn,
-				     NULL, da9052_ts_pendwn_irq,
-				     IRQF_TRIGGER_LOW | IRQF_ONESHOT,
-				     "PENDWN", tsi);
+	error = da9052_request_irq(tsi->da9052, DA9052_IRQ_PENDOWN, 
+				"pendown-irq", da9052_ts_pendwn_irq, tsi);
 	if (error) {
 		dev_err(tsi->da9052->dev,
-			"Failed to register PENDWN IRQ %d, error = %d\n",
-			tsi->irq_pendwn, error);
+			"Failed to register PENDWN IRQ: %d\n", error);
 		goto err_free_mem;
 	}
 
-	error = request_threaded_irq(tsi->irq_datardy,
-				     NULL, da9052_ts_datardy_irq,
-				     IRQF_TRIGGER_LOW | IRQF_ONESHOT,
-				     "TSIRDY", tsi);
+	error = da9052_request_irq(tsi->da9052, DA9052_IRQ_TSIREADY, 
+				"tsiready-irq", da9052_ts_datardy_irq, tsi);
 	if (error) {
 		dev_err(tsi->da9052->dev,
-			"Failed to register TSIRDY IRQ %d, error = %d\n",
-			tsi->irq_datardy, error);
+			"Failed to register TSIRDY IRQ :%d\n", error);
 		goto err_free_pendwn_irq;
 	}
 
 	/* Mask PEN_DOWN and TSI_READY events */
-	disable_irq(tsi->irq_pendwn);
-	disable_irq(tsi->irq_datardy);
+	da9052_disable_irq(tsi->da9052, DA9052_IRQ_PENDOWN);
+	da9052_disable_irq(tsi->da9052, DA9052_IRQ_TSIREADY);
 
 	error = da9052_configure_tsi(tsi);
 	if (error)
@@ -326,9 +307,9 @@ static int __devinit da9052_ts_probe(struct platform_device *pdev)
 	return 0;
 
 err_free_datardy_irq:
-	free_irq(tsi->irq_datardy, tsi);
+	da9052_free_irq(tsi->da9052, DA9052_IRQ_TSIREADY, tsi);
 err_free_pendwn_irq:
-	free_irq(tsi->irq_pendwn, tsi);
+	da9052_free_irq(tsi->da9052, DA9052_IRQ_PENDOWN, tsi);
 err_free_mem:
 	kfree(tsi);
 	input_free_device(input_dev);
@@ -342,8 +323,8 @@ static int  __devexit da9052_ts_remove(struct platform_device *pdev)
 
 	da9052_reg_write(tsi->da9052, DA9052_LDO9_REG, 0x19);
 
-	free_irq(tsi->irq_pendwn, tsi);
-	free_irq(tsi->irq_datardy, tsi);
+	da9052_free_irq(tsi->da9052, DA9052_IRQ_TSIREADY, tsi);
+	da9052_free_irq(tsi->da9052, DA9052_IRQ_PENDOWN, tsi);
 
 	input_unregister_device(tsi->dev);
 	kfree(tsi);
-- 
1.7.9.5

