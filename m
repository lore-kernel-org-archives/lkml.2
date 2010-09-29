Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217Ab0I2QX5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 12:23:57 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41366 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753775Ab0I2QX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 12:23:56 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Richard Purdie <rpurdie@linux.intel.com>,
        Alberto Panizzo <maramaopercheseimorto@gmail.com>,
        Valentin Longchamp <valentin.longchamp@epfl.ch>
Subject: [PATCH 1/4] mfd/mc13783: remove obsolete private data
Date: Wed, 29 Sep 2010 18:23:44 +0200
Message-Id: <1285777427-2887-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <20100929162315.GG29811@pengutronix.de>
References: <20100929162315.GG29811@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regulator driver was converted to get the needed data directly from
platform_data by

	a10099b (regulator/mc13783: various cleanups)

so regulators and num_regulators can go away.  Then apart from the flag
indicating that the adc does a conversion, flags is only a copy of the
flags member of platform_data.  This flag isn't needed to be returned by
mc13783_get_flags, so mc13783_get_flags now gets the flags from
platform_data, too and the driver private member is renamed for clearity.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/mfd/mc13783-core.c |   27 +++++++++------------------
 1 files changed, 9 insertions(+), 18 deletions(-)

diff --git a/drivers/mfd/mc13783-core.c b/drivers/mfd/mc13783-core.c
index 6df3498..2506e68 100644
--- a/drivers/mfd/mc13783-core.c
+++ b/drivers/mfd/mc13783-core.c
@@ -22,14 +22,10 @@ struct mc13783 {
 	struct spi_device *spidev;
 	struct mutex lock;
 	int irq;
-	int flags;
+	int adcflags;
 
 	irq_handler_t irqhandler[MC13783_NUM_IRQ];
 	void *irqdata[MC13783_NUM_IRQ];
-
-	/* XXX these should go as platformdata to the regulator subdevice */
-	struct mc13783_regulator_init_data *regulators;
-	int num_regulators;
 };
 
 #define MC13783_REG_REVISION			 7
@@ -250,7 +246,10 @@ EXPORT_SYMBOL(mc13783_reg_rmw);
 
 int mc13783_get_flags(struct mc13783 *mc13783)
 {
-	return mc13783->flags;
+	struct mc13783_platform_data *pdata =
+		dev_get_platdata(&mc13783->spidev->dev);
+
+	return pdata->flags;
 }
 EXPORT_SYMBOL(mc13783_get_flags);
 
@@ -493,7 +492,7 @@ static irqreturn_t mc13783_handler_adcdone(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
-#define MC13783_ADC_WORKING (1 << 16)
+#define MC13783_ADC_WORKING (1 << 0)
 
 int mc13783_adc_do_conversion(struct mc13783 *mc13783, unsigned int mode,
 		unsigned int channel, unsigned int *sample)
@@ -509,12 +508,12 @@ int mc13783_adc_do_conversion(struct mc13783 *mc13783, unsigned int mode,
 
 	mc13783_lock(mc13783);
 
-	if (mc13783->flags & MC13783_ADC_WORKING) {
+	if (mc13783->adcflags & MC13783_ADC_WORKING) {
 		ret = -EBUSY;
 		goto out;
 	}
 
-	mc13783->flags |= MC13783_ADC_WORKING;
+	mc13783->adcflags |= MC13783_ADC_WORKING;
 
 	mc13783_reg_read(mc13783, MC13783_ADC0, &old_adc0);
 
@@ -578,7 +577,7 @@ int mc13783_adc_do_conversion(struct mc13783 *mc13783, unsigned int mode,
 		/* restore TSMOD */
 		mc13783_reg_write(mc13783, MC13783_REG_ADC_0, old_adc0);
 
-	mc13783->flags &= ~MC13783_ADC_WORKING;
+	mc13783->adcflags &= ~MC13783_ADC_WORKING;
 out:
 	mc13783_unlock(mc13783);
 
@@ -675,14 +674,6 @@ err_revision:
 		return ret;
 	}
 
-	/* This should go away (BEGIN) */
-	if (pdata) {
-		mc13783->flags = pdata->flags;
-		mc13783->regulators = pdata->regulators;
-		mc13783->num_regulators = pdata->num_regulators;
-	}
-	/* This should go away (END) */
-
 	mc13783_unlock(mc13783);
 
 	if (pdata->flags & MC13783_USE_ADC)
-- 
1.7.2.3

