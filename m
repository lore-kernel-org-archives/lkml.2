Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965248Ab2JCRHa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 13:07:30 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:63045 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965185Ab2JCRH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 13:07:26 -0400
From: Fabio Estevam <festevam@gmail.com>
To: sameo@linux.intel.com
Cc: broonie@opensource.wolfsonmicro.com, ashish.jangam@kpitcummins.com,
        dchen@diasemi.com, arnd@arndb.de, kernel@pengutronix.de,
        dmitry.torokhov@gmail.com, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [RFC 3/3] Input: da9052_tsi.c: Use the new da9052 irq functions
Date: Wed,  3 Oct 2012 14:06:59 -0300
Message-Id: <1349284019-31571-3-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349284019-31571-1-git-send-email-festevam@gmail.com>
References: <1349284019-31571-1-git-send-email-festevam@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

Currently da9062_tsi does not probe and it fails as follows:

da9052 1-0048: Unable to determine device interrupts

Use the new da9052 irq functions and allow the driver to probe successfully.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
Hi,

Even though I can get the da9052_tsi driver to probe succesffully on a mx53qsb,
I still do not get any interrupts when touching the LCD when using "evtest".

This is why I marked the series as RFC.

Ashish,

I never used this driver before, so I do not know if it has ever worked.

Please let me know if you have suggestions to make this drive functional.

 drivers/input/touchscreen/da9052_tsi.c |   60 +++++++++++---------------------
 drivers/mfd/da9052-irq.c               |   38 +++++++++++++++++++-
 include/linux/mfd/da9052/da9052.h      |    4 +++
 3 files changed, 62 insertions(+), 40 deletions(-)

diff --git a/drivers/input/touchscreen/da9052_tsi.c b/drivers/input/touchscreen/da9052_tsi.c
index e8df341..5bf1026 100644
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
+	error = da9052_request_irq(tsi->da9052, DA9052_IRQ_PENDOWN, "pendown-irq",
+			    da9052_ts_pendwn_irq, da9052);
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
+	error = da9052_request_irq(tsi->da9052, DA9052_IRQ_TSIREADY, "tsiready-irq",
+			    da9052_ts_datardy_irq, da9052);
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
+	da9052_free_irq(da9052, DA9052_IRQ_TSIREADY, da9052);
 err_free_pendwn_irq:
-	free_irq(tsi->irq_pendwn, tsi);
+	da9052_free_irq(da9052, DA9052_IRQ_PENDOWN, da9052);
 err_free_mem:
 	kfree(tsi);
 	input_free_device(input_dev);
@@ -339,11 +320,12 @@ err_free_mem:
 static int  __devexit da9052_ts_remove(struct platform_device *pdev)
 {
 	struct da9052_tsi *tsi = platform_get_drvdata(pdev);
+	struct da9052 *da9052 = dev_get_drvdata(pdev->dev.parent);
 
 	da9052_reg_write(tsi->da9052, DA9052_LDO9_REG, 0x19);
 
-	free_irq(tsi->irq_pendwn, tsi);
-	free_irq(tsi->irq_datardy, tsi);
+	da9052_free_irq(da9052, DA9052_IRQ_TSIREADY, da9052);
+	da9052_free_irq(da9052, DA9052_IRQ_PENDOWN, da9052);
 
 	input_unregister_device(tsi->dev);
 	kfree(tsi);
diff --git a/drivers/mfd/da9052-irq.c b/drivers/mfd/da9052-irq.c
index e5a14cf..c47b92f 100644
--- a/drivers/mfd/da9052-irq.c
+++ b/drivers/mfd/da9052-irq.c
@@ -196,7 +196,7 @@ static int da9052_irq_map(struct irq_domain *h, unsigned int virq,
 	struct regmap_irq_chip_data *data = h->host_data;
 
 	irq_set_chip_data(virq, data);
-	irq_set_chip_and_handler(virq, &da9052_irq_chip, handle_edge_irq);
+	irq_set_chip_and_handler(virq, &da9052_irq_chip, handle_level_irq);
 	irq_set_nested_thread(virq, 1);
 
 	/* 
@@ -222,6 +222,42 @@ static int da9052_map_irq(struct da9052 *da9052, int irq)
 	return regmap_irq_get_virq(da9052->irq_data, irq);
 }
 
+int da9052_enable_irq(struct da9052 *da9052, int irq)
+{
+	irq = da9052_map_irq(da9052, irq);
+	if (irq < 0)
+		return irq;
+
+	enable_irq(irq);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(da9052_enable_irq);
+
+int da9052_disable_irq(struct da9052 *da9052, int irq)
+{
+	irq = da9052_map_irq(da9052, irq);
+	if (irq < 0)
+		return irq;
+
+	disable_irq(irq);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(da9052_disable_irq);
+
+int da9052_disable_irq_nosync(struct da9052 *da9052, int irq)
+{
+	irq = da9052_map_irq(da9052, irq);
+	if (irq < 0)
+		return irq;
+
+	disable_irq_nosync(irq);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(da9052_disable_irq_nosync);
+
 int da9052_request_irq(struct da9052 *da9052, int irq, char *name,
 			   irq_handler_t handler, void *data)
 {
diff --git a/include/linux/mfd/da9052/da9052.h b/include/linux/mfd/da9052/da9052.h
index 5deb64c..484301a 100644
--- a/include/linux/mfd/da9052/da9052.h
+++ b/include/linux/mfd/da9052/da9052.h
@@ -153,4 +153,8 @@ int da9052_request_irq(struct da9052 *da9052, int irq, char *name,
 			   irq_handler_t handler, void *data);
 void da9052_free_irq(struct da9052 *da9052, int irq, void *data);
 
+int da9052_enable_irq(struct da9052 *da9052, int irq);
+int da9052_disable_irq(struct da9052 *da9052, int irq);
+int da9052_disable_irq_nosync(struct da9052 *da9052, int irq);
+
 #endif /* __MFD_DA9052_DA9052_H */
-- 
1.7.9.5

