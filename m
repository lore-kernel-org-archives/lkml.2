Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751833Ab1HXN3c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 09:29:32 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41313 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab1HXN3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 09:29:30 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Samuel Ortiz <sameo@linux.intel.com>, Jean Delvare <khali@linux-fr.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        lm-sensors@lm-sensors.org, linux-input@vger.kernel.org
Date: Wed, 24 Aug 2011 15:28:21 +0200
Message-Id: <1314192505-23499-2-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1314192505-23499-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <20110824132740.GA28197@pengutronix.de>
 <1314192505-23499-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ukl@pengutronix.de
Subject: [PATCH 2/6] mfd/mc13xxx: provide a generic version of adc_do_conversion
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on metis.ext.pengutronix.de)
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is needed to convert the touch driver away from using struct mc13783.

Note this patch drops MC13783_ADC0_ADREFMODE. This is unused and doesn't
exist on mc13892.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/mfd/mc13xxx-core.c  |   89 +++++++++++++++++++++----------------------
 include/linux/mfd/mc13783.h |   35 +++++++++--------
 include/linux/mfd/mc13xxx.h |   19 +++++++++
 3 files changed, 81 insertions(+), 62 deletions(-)

diff --git a/drivers/mfd/mc13xxx-core.c b/drivers/mfd/mc13xxx-core.c
index 7e4d44b..5ee5e64 100644
--- a/drivers/mfd/mc13xxx-core.c
+++ b/drivers/mfd/mc13xxx-core.c
@@ -26,12 +26,12 @@ struct mc13xxx {
 
 	irq_handler_t irqhandler[MC13XXX_NUM_IRQ];
 	void *irqdata[MC13XXX_NUM_IRQ];
+
+	int adcflags;
 };
 
 struct mc13783 {
 	struct mc13xxx mc13xxx;
-
-	int adcflags;
 };
 
 struct mc13xxx *mc13783_to_mc13xxx(struct mc13783 *mc13783)
@@ -136,14 +136,14 @@ EXPORT_SYMBOL(mc13783_to_mc13xxx);
 #define MC13XXX_REVISION_FAB		(0x03 << 11)
 #define MC13XXX_REVISION_ICIDCODE	(0x3f << 13)
 
-#define MC13783_ADC1		44
-#define MC13783_ADC1_ADEN		(1 << 0)
-#define MC13783_ADC1_RAND		(1 << 1)
-#define MC13783_ADC1_ADSEL		(1 << 3)
-#define MC13783_ADC1_ASC		(1 << 20)
-#define MC13783_ADC1_ADTRIGIGN		(1 << 21)
+#define MC13XXX_ADC1		44
+#define MC13XXX_ADC1_ADEN		(1 << 0)
+#define MC13XXX_ADC1_RAND		(1 << 1)
+#define MC13XXX_ADC1_ADSEL		(1 << 3)
+#define MC13XXX_ADC1_ASC		(1 << 20)
+#define MC13XXX_ADC1_ADTRIGIGN		(1 << 21)
 
-#define MC13783_ADC2		45
+#define MC13XXX_ADC2		45
 
 #define MC13XXX_NUMREGS 0x3f
 
@@ -569,15 +569,15 @@ int mc13xxx_get_flags(struct mc13xxx *mc13xxx)
 }
 EXPORT_SYMBOL(mc13xxx_get_flags);
 
-#define MC13783_ADC1_CHAN0_SHIFT	5
-#define MC13783_ADC1_CHAN1_SHIFT	8
+#define MC13XXX_ADC1_CHAN0_SHIFT	5
+#define MC13XXX_ADC1_CHAN1_SHIFT	8
 
 struct mc13xxx_adcdone_data {
 	struct mc13xxx *mc13xxx;
 	struct completion done;
 };
 
-static irqreturn_t mc13783_handler_adcdone(int irq, void *data)
+static irqreturn_t mc13xxx_handler_adcdone(int irq, void *data)
 {
 	struct mc13xxx_adcdone_data *adcdone_data = data;
 
@@ -588,12 +588,11 @@ static irqreturn_t mc13783_handler_adcdone(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
-#define MC13783_ADC_WORKING (1 << 0)
+#define MC13XXX_ADC_WORKING (1 << 0)
 
-int mc13783_adc_do_conversion(struct mc13783 *mc13783, unsigned int mode,
+int mc13xxx_adc_do_conversion(struct mc13xxx *mc13xxx, unsigned int mode,
 		unsigned int channel, unsigned int *sample)
 {
-	struct mc13xxx *mc13xxx = &mc13783->mc13xxx;
 	u32 adc0, adc1, old_adc0;
 	int i, ret;
 	struct mc13xxx_adcdone_data adcdone_data = {
@@ -605,51 +604,51 @@ int mc13783_adc_do_conversion(struct mc13783 *mc13783, unsigned int mode,
 
 	mc13xxx_lock(mc13xxx);
 
-	if (mc13783->adcflags & MC13783_ADC_WORKING) {
+	if (mc13xxx->adcflags & MC13XXX_ADC_WORKING) {
 		ret = -EBUSY;
 		goto out;
 	}
 
-	mc13783->adcflags |= MC13783_ADC_WORKING;
+	mc13xxx->adcflags |= MC13XXX_ADC_WORKING;
 
-	mc13xxx_reg_read(mc13xxx, MC13783_ADC0, &old_adc0);
+	mc13xxx_reg_read(mc13xxx, MC13XXX_ADC0, &old_adc0);
 
-	adc0 = MC13783_ADC0_ADINC1 | MC13783_ADC0_ADINC2;
-	adc1 = MC13783_ADC1_ADEN | MC13783_ADC1_ADTRIGIGN | MC13783_ADC1_ASC;
+	adc0 = MC13XXX_ADC0_ADINC1 | MC13XXX_ADC0_ADINC2;
+	adc1 = MC13XXX_ADC1_ADEN | MC13XXX_ADC1_ADTRIGIGN | MC13XXX_ADC1_ASC;
 
 	if (channel > 7)
-		adc1 |= MC13783_ADC1_ADSEL;
+		adc1 |= MC13XXX_ADC1_ADSEL;
 
 	switch (mode) {
-	case MC13783_ADC_MODE_TS:
-		adc0 |= MC13783_ADC0_ADREFEN | MC13783_ADC0_TSMOD0 |
-			MC13783_ADC0_TSMOD1;
-		adc1 |= 4 << MC13783_ADC1_CHAN1_SHIFT;
+	case MC13XXX_ADC_MODE_TS:
+		adc0 |= MC13XXX_ADC0_ADREFEN | MC13XXX_ADC0_TSMOD0 |
+			MC13XXX_ADC0_TSMOD1;
+		adc1 |= 4 << MC13XXX_ADC1_CHAN1_SHIFT;
 		break;
 
-	case MC13783_ADC_MODE_SINGLE_CHAN:
-		adc0 |= old_adc0 & MC13783_ADC0_TSMOD_MASK;
-		adc1 |= (channel & 0x7) << MC13783_ADC1_CHAN0_SHIFT;
-		adc1 |= MC13783_ADC1_RAND;
+	case MC13XXX_ADC_MODE_SINGLE_CHAN:
+		adc0 |= old_adc0 & MC13XXX_ADC0_TSMOD_MASK;
+		adc1 |= (channel & 0x7) << MC13XXX_ADC1_CHAN0_SHIFT;
+		adc1 |= MC13XXX_ADC1_RAND;
 		break;
 
-	case MC13783_ADC_MODE_MULT_CHAN:
-		adc0 |= old_adc0 & MC13783_ADC0_TSMOD_MASK;
-		adc1 |= 4 << MC13783_ADC1_CHAN1_SHIFT;
+	case MC13XXX_ADC_MODE_MULT_CHAN:
+		adc0 |= old_adc0 & MC13XXX_ADC0_TSMOD_MASK;
+		adc1 |= 4 << MC13XXX_ADC1_CHAN1_SHIFT;
 		break;
 
 	default:
-		mc13783_unlock(mc13783);
+		mc13xxx_unlock(mc13xxx);
 		return -EINVAL;
 	}
 
-	dev_dbg(&mc13783->mc13xxx.spidev->dev, "%s: request irq\n", __func__);
-	mc13xxx_irq_request(mc13xxx, MC13783_IRQ_ADCDONE,
-			mc13783_handler_adcdone, __func__, &adcdone_data);
-	mc13xxx_irq_ack(mc13xxx, MC13783_IRQ_ADCDONE);
+	dev_dbg(&mc13xxx->spidev->dev, "%s: request irq\n", __func__);
+	mc13xxx_irq_request(mc13xxx, MC13XXX_IRQ_ADCDONE,
+			mc13xxx_handler_adcdone, __func__, &adcdone_data);
+	mc13xxx_irq_ack(mc13xxx, MC13XXX_IRQ_ADCDONE);
 
-	mc13xxx_reg_write(mc13xxx, MC13783_ADC0, adc0);
-	mc13xxx_reg_write(mc13xxx, MC13783_ADC1, adc1);
+	mc13xxx_reg_write(mc13xxx, MC13XXX_ADC0, adc0);
+	mc13xxx_reg_write(mc13xxx, MC13XXX_ADC1, adc1);
 
 	mc13xxx_unlock(mc13xxx);
 
@@ -660,27 +659,27 @@ int mc13783_adc_do_conversion(struct mc13783 *mc13783, unsigned int mode,
 
 	mc13xxx_lock(mc13xxx);
 
-	mc13xxx_irq_free(mc13xxx, MC13783_IRQ_ADCDONE, &adcdone_data);
+	mc13xxx_irq_free(mc13xxx, MC13XXX_IRQ_ADCDONE, &adcdone_data);
 
 	if (ret > 0)
 		for (i = 0; i < 4; ++i) {
 			ret = mc13xxx_reg_read(mc13xxx,
-					MC13783_ADC2, &sample[i]);
+					MC13XXX_ADC2, &sample[i]);
 			if (ret)
 				break;
 		}
 
-	if (mode == MC13783_ADC_MODE_TS)
+	if (mode == MC13XXX_ADC_MODE_TS)
 		/* restore TSMOD */
-		mc13xxx_reg_write(mc13xxx, MC13783_ADC0, old_adc0);
+		mc13xxx_reg_write(mc13xxx, MC13XXX_ADC0, old_adc0);
 
-	mc13783->adcflags &= ~MC13783_ADC_WORKING;
+	mc13xxx->adcflags &= ~MC13XXX_ADC_WORKING;
 out:
 	mc13xxx_unlock(mc13xxx);
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(mc13783_adc_do_conversion);
+EXPORT_SYMBOL_GPL(mc13xxx_adc_do_conversion);
 
 static int mc13xxx_add_subdevice_pdata(struct mc13xxx *mc13xxx,
 		const char *format, void *pdata, size_t pdata_size)
diff --git a/include/linux/mfd/mc13783.h b/include/linux/mfd/mc13783.h
index 7d0f3d6..e7a3c01 100644
--- a/include/linux/mfd/mc13783.h
+++ b/include/linux/mfd/mc13783.h
@@ -89,18 +89,15 @@ static inline int mc13783_irq_ack(struct mc13783 *mc13783, int irq)
 	return mc13xxx_irq_ack(mc13783_to_mc13xxx(mc13783), irq);
 }
 
-#define MC13783_ADC0		43
-#define MC13783_ADC0_ADREFEN		(1 << 10)
-#define MC13783_ADC0_ADREFMODE		(1 << 11)
-#define MC13783_ADC0_TSMOD0		(1 << 12)
-#define MC13783_ADC0_TSMOD1		(1 << 13)
-#define MC13783_ADC0_TSMOD2		(1 << 14)
-#define MC13783_ADC0_ADINC1		(1 << 16)
-#define MC13783_ADC0_ADINC2		(1 << 17)
-
-#define MC13783_ADC0_TSMOD_MASK		(MC13783_ADC0_TSMOD0 | \
-					MC13783_ADC0_TSMOD1 | \
-					MC13783_ADC0_TSMOD2)
+#define MC13783_ADC0		MC13XXX_ADC0
+#define MC13783_ADC0_ADREFEN		MC13XXX_ADC0_ADREFEN
+#define MC13783_ADC0_TSMOD0		MC13XXX_ADC0_TSMOD0
+#define MC13783_ADC0_TSMOD1		MC13XXX_ADC0_TSMOD1
+#define MC13783_ADC0_TSMOD2		MC13XXX_ADC0_TSMOD2
+#define MC13783_ADC0_ADINC1		MC13XXX_ADC0_ADINC1
+#define MC13783_ADC0_ADINC2		MC13XXX_ADC0_ADINC2
+
+#define MC13783_ADC0_TSMOD_MASK		MC13XXX_ADC0_TSMOD_MASK
 
 #define mc13783_regulator_init_data mc13xxx_regulator_init_data
 #define mc13783_regulator_platform_data mc13xxx_regulator_platform_data
@@ -115,12 +112,16 @@ static inline int mc13783_irq_ack(struct mc13783 *mc13783, int irq)
 #define MC13783_USE_REGULATOR	MC13XXX_USE_REGULATOR
 #define MC13783_USE_LED		MC13XXX_USE_LED
 
-#define MC13783_ADC_MODE_TS		1
-#define MC13783_ADC_MODE_SINGLE_CHAN	2
-#define MC13783_ADC_MODE_MULT_CHAN	3
+#define MC13783_ADC_MODE_TS		MC13XXX_ADC_MODE_TS
+#define MC13783_ADC_MODE_SINGLE_CHAN	MC13XXX_ADC_MODE_SINGLE_CHAN
+#define MC13783_ADC_MODE_MULT_CHAN	MC13XXX_ADC_MODE_MULT_CHAN
 
-int mc13783_adc_do_conversion(struct mc13783 *mc13783, unsigned int mode,
-		unsigned int channel, unsigned int *sample);
+static inline int mc13783_adc_do_conversion(struct mc13783 *mc13783,
+		unsigned int mode, unsigned int channel, unsigned int *sample)
+{
+	return mc13xxx_adc_do_conversion(mc13783_to_mc13xxx(mc13783), mode,
+			channel, sample);
+}
 
 
 #define	MC13783_REG_SW1A		0
diff --git a/include/linux/mfd/mc13xxx.h b/include/linux/mfd/mc13xxx.h
index c064bea..6e7c0ac 100644
--- a/include/linux/mfd/mc13xxx.h
+++ b/include/linux/mfd/mc13xxx.h
@@ -37,6 +37,9 @@ int mc13xxx_irq_ack(struct mc13xxx *mc13xxx, int irq);
 
 int mc13xxx_get_flags(struct mc13xxx *mc13xxx);
 
+int mc13xxx_adc_do_conversion(struct mc13xxx *mc13xxx,
+		unsigned int mode, unsigned int channel, unsigned int *sample);
+
 #define MC13XXX_IRQ_ADCDONE	0
 #define MC13XXX_IRQ_ADCBISDONE	1
 #define MC13XXX_IRQ_TS		2
@@ -150,4 +153,20 @@ struct mc13xxx_platform_data {
 	struct mc13xxx_leds_platform_data *leds;
 };
 
+#define MC13XXX_ADC_MODE_TS		1
+#define MC13XXX_ADC_MODE_SINGLE_CHAN	2
+#define MC13XXX_ADC_MODE_MULT_CHAN	3
+
+#define MC13XXX_ADC0		43
+#define MC13XXX_ADC0_ADREFEN		(1 << 10)
+#define MC13XXX_ADC0_TSMOD0		(1 << 12)
+#define MC13XXX_ADC0_TSMOD1		(1 << 13)
+#define MC13XXX_ADC0_TSMOD2		(1 << 14)
+#define MC13XXX_ADC0_ADINC1		(1 << 16)
+#define MC13XXX_ADC0_ADINC2		(1 << 17)
+
+#define MC13XXX_ADC0_TSMOD_MASK		(MC13XXX_ADC0_TSMOD0 | \
+					MC13XXX_ADC0_TSMOD1 | \
+					MC13XXX_ADC0_TSMOD2)
+
 #endif /* ifndef __LINUX_MFD_MC13XXX_H */
-- 
1.7.5.4

