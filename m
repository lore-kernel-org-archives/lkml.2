Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312Ab2ALJ1f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 04:27:35 -0500
Received: from mx19.lb01.inode.at ([62.99.145.21]:28853 "EHLO mx.inode.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753197Ab2ALJ1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 04:27:30 -0500
From: Michael Thalmeier <michael.thalmeier@hale.at>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Michael Thalmeier <michael.thalmeier@hale.at>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        michael@thalmeier.at
Subject: [PATCH v3] input/mc13783-ts: add pdata to set conversion delay
Date: Thu, 12 Jan 2012 10:29:27 +0100
Message-Id: <1326360567-2757-1-git-send-email-michael.thalmeier@hale.at>
X-Mailer: git-send-email 1.7.7.5
MIME-Version: 1.0
X-HALE-MailScanner-Information: Please contact the ISP for more information
X-MailScanner-ID: q0C9RVq0029427
X-HALE-MailScanner: Found to be clean
X-HALE-MailScanner-From: michael.thalmeier@hale.at
MailScanner-NULL-Check: 1326965252.62595@fy5SauAe2VAJ9w/0qo3vWw
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MC13783 can be programmed to wait some clock cycles between the touch screen
polarization and the resistance conversion. This is needed to adjust for
touchscreens with high capacitance between plates.

Signed-off-by: Michael Thalmeier <michael.thalmeier@hale.at>
---
 drivers/hwmon/mc13783-adc.c            |    2 +-
 drivers/input/touchscreen/mc13783_ts.c |   11 ++++++++++-
 drivers/mfd/mc13xxx-core.c             |   11 +++++++++--
 include/linux/mfd/mc13xxx.h            |   16 +++++++++++++++-
 4 files changed, 35 insertions(+), 5 deletions(-)

diff --git a/drivers/hwmon/mc13783-adc.c b/drivers/hwmon/mc13783-adc.c
index ef65ab5..6acd044 100644
--- a/drivers/hwmon/mc13783-adc.c
+++ b/drivers/hwmon/mc13783-adc.c
@@ -53,7 +53,7 @@ static int mc13783_adc_read(struct device *dev,
 
 	ret = mc13xxx_adc_do_conversion(priv->mc13xxx,
 			MC13XXX_ADC_MODE_MULT_CHAN,
-			channel, sample);
+			channel, 0, 0, sample);
 	if (ret)
 		return ret;
 
diff --git a/drivers/input/touchscreen/mc13783_ts.c b/drivers/input/touchscreen/mc13783_ts.c
index 68f86f7..e3bd398 100644
--- a/drivers/input/touchscreen/mc13783_ts.c
+++ b/drivers/input/touchscreen/mc13783_ts.c
@@ -39,6 +39,7 @@ struct mc13783_ts_priv {
 	struct delayed_work work;
 	struct workqueue_struct *workq;
 	unsigned int sample[4];
+	struct mc13xxx_ts_platform_data *touch;
 };
 
 static irqreturn_t mc13783_ts_handler(int irq, void *data)
@@ -125,7 +126,9 @@ static void mc13783_ts_work(struct work_struct *work)
 	unsigned int channel = 12;
 
 	if (mc13xxx_adc_do_conversion(priv->mc13xxx,
-				mode, channel, priv->sample) == 0)
+				mode, channel,
+				priv->touch->ato, priv->touch->atox,
+				priv->sample) == 0)
 		mc13783_ts_report_sample(priv);
 }
 
@@ -179,6 +182,12 @@ static int __init mc13783_ts_probe(struct platform_device *pdev)
 	INIT_DELAYED_WORK(&priv->work, mc13783_ts_work);
 	priv->mc13xxx = dev_get_drvdata(pdev->dev.parent);
 	priv->idev = idev;
+	priv->touch = dev_get_platdata(&pdev->dev);
+	if (!priv->touch) {
+		dev_err(&pdev->dev, "missing platform data\n");
+		ret = -ENODEV;
+		goto err_free_mem;
+	}
 
 	/*
 	 * We need separate workqueue because mc13783_adc_do_conversion
diff --git a/drivers/mfd/mc13xxx-core.c b/drivers/mfd/mc13xxx-core.c
index e9619ac..2bd01ae 100644
--- a/drivers/mfd/mc13xxx-core.c
+++ b/drivers/mfd/mc13xxx-core.c
@@ -559,6 +559,8 @@ EXPORT_SYMBOL(mc13xxx_get_flags);
 
 #define MC13XXX_ADC1_CHAN0_SHIFT	5
 #define MC13XXX_ADC1_CHAN1_SHIFT	8
+#define MC13783_ADC1_ATO_SHIFT		11
+#define MC13783_ADC1_ATOX		(1 << 19)
 
 struct mc13xxx_adcdone_data {
 	struct mc13xxx *mc13xxx;
@@ -579,7 +581,8 @@ static irqreturn_t mc13xxx_handler_adcdone(int irq, void *data)
 #define MC13XXX_ADC_WORKING (1 << 0)
 
 int mc13xxx_adc_do_conversion(struct mc13xxx *mc13xxx, unsigned int mode,
-		unsigned int channel, unsigned int *sample)
+		unsigned int channel, u8 ato, bool atox,
+		unsigned int *sample)
 {
 	u32 adc0, adc1, old_adc0;
 	int i, ret;
@@ -630,6 +633,9 @@ int mc13xxx_adc_do_conversion(struct mc13xxx *mc13xxx, unsigned int mode,
 		return -EINVAL;
 	}
 
+	adc1 |= ato << MC13783_ADC1_ATO_SHIFT;
+	if (atox)
+		adc1 |= MC13783_ADC1_ATOX;
 	dev_dbg(&mc13xxx->spidev->dev, "%s: request irq\n", __func__);
 	mc13xxx_irq_request(mc13xxx, MC13XXX_IRQ_ADCDONE,
 			mc13xxx_handler_adcdone, __func__, &adcdone_data);
@@ -762,7 +768,8 @@ err_revision:
 		mc13xxx_add_subdevice(mc13xxx, "%s-rtc");
 
 	if (pdata->flags & MC13XXX_USE_TOUCHSCREEN)
-		mc13xxx_add_subdevice(mc13xxx, "%s-ts");
+		mc13xxx_add_subdevice_pdata(mc13xxx, "%s-ts",
+				&pdata->touch, sizeof(pdata->touch));
 
 	if (pdata->leds)
 		mc13xxx_add_subdevice_pdata(mc13xxx, "%s-led",
diff --git a/include/linux/mfd/mc13xxx.h b/include/linux/mfd/mc13xxx.h
index a98e2a3..aefa384 100644
--- a/include/linux/mfd/mc13xxx.h
+++ b/include/linux/mfd/mc13xxx.h
@@ -38,7 +38,8 @@ int mc13xxx_irq_ack(struct mc13xxx *mc13xxx, int irq);
 int mc13xxx_get_flags(struct mc13xxx *mc13xxx);
 
 int mc13xxx_adc_do_conversion(struct mc13xxx *mc13xxx,
-		unsigned int mode, unsigned int channel, unsigned int *sample);
+		unsigned int mode, unsigned int channel,
+		u8 ato, bool atox, unsigned int *sample);
 
 #define MC13XXX_IRQ_ADCDONE	0
 #define MC13XXX_IRQ_ADCBISDONE	1
@@ -157,6 +158,18 @@ struct mc13xxx_buttons_platform_data {
 	unsigned short b3on_key;
 };
 
+struct mc13xxx_ts_platform_data {
+	/* Delay between Touchscreen polarization and ADC Conversion.
+	 * Given in clock ticks of a 32 kHz clock which gives a granularity of
+	 * about 30.5ms */
+	u8 ato;
+
+#define MC13783_TS_ATO_FIRST false
+#define MC13783_TS_ATO_EACH  true
+	/* Use the ATO delay only for the first conversion or for each one */
+	bool atox;
+};
+
 struct mc13xxx_platform_data {
 #define MC13XXX_USE_TOUCHSCREEN (1 << 0)
 #define MC13XXX_USE_CODEC	(1 << 1)
@@ -167,6 +180,7 @@ struct mc13xxx_platform_data {
 	struct mc13xxx_regulator_platform_data regulators;
 	struct mc13xxx_leds_platform_data *leds;
 	struct mc13xxx_buttons_platform_data *buttons;
+	struct mc13xxx_ts_platform_data touch;
 };
 
 #define MC13XXX_ADC_MODE_TS		1
-- 
1.7.7.5



--
Scanned by MailScanner.

