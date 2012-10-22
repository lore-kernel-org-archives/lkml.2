Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932662Ab2JVATP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 20:19:15 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:38965 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753708Ab2JVATO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 20:19:14 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "cbou@mail.ru" <cbou@mail.ru>
CC: Anton Vorontsov <anton.vorontsov@linaro.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Jonathan Cameron <jic23@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 2/3] lp8788-charger: fix ADC channel names
Thread-Topic: [PATCH v2 2/3] lp8788-charger: fix ADC channel names
Thread-Index: Ac2v6tGCqiVhg5CJQ/6RPtthKFrIQA==
Date: Mon, 22 Oct 2012 00:18:54 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F64179302@DQHE02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Patch v2.
 The name of ADC channel is configurable in the platform side.
 This name is referenced in the IIO consumer driver.
 To get the IIO channel, specific name in the platform data is used
 as an parameter of the iio_channel_get().
 Thus, lp8788_adc_id platform data are replaced with specific names.

 Patch v1.
 LP8788 IIO ADC driver and platform data have specific naming convention
 for ADC channels. That is using prefix 'lp8788_'.
 To keep this rule, ADC channel names are changed.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/power/lp8788-charger.c |   44 ++++++----------------------------------
 include/linux/mfd/lp8788.h     |    8 ++++----
 2 files changed, 10 insertions(+), 42 deletions(-)

diff --git a/drivers/power/lp8788-charger.c b/drivers/power/lp8788-charger.c
index 614e6aa..f08ed44 100644
--- a/drivers/power/lp8788-charger.c
+++ b/drivers/power/lp8788-charger.c
@@ -596,50 +596,18 @@ static void lp8788_setup_adc_channel(const char *consumer_name,
 				struct lp8788_charger *pchg)
 {
 	struct lp8788_charger_platform_data *pdata = pchg->pdata;
-	struct device *dev = pchg->lp->dev;
 	struct iio_channel *chan;
-	enum lp8788_adc_id id;
-	const char *chan_name[LPADC_MAX] = {
-		[LPADC_VBATT_5P5] = "vbatt-5p5",
-		[LPADC_VBATT_6P0] = "vbatt-6p0",
-		[LPADC_VBATT_5P0] = "vbatt-5p0",
-		[LPADC_ADC1]      = "adc1",
-		[LPADC_ADC2]      = "adc2",
-		[LPADC_ADC3]      = "adc3",
-		[LPADC_ADC4]      = "adc4",
-	};
 
 	if (!pdata)
 		return;
 
-	id = pdata->vbatt_adc;
-	switch (id) {
-	case LPADC_VBATT_5P5:
-	case LPADC_VBATT_6P0:
-	case LPADC_VBATT_5P0:
-		chan = iio_channel_get(consumer_name, chan_name[id]);
-		pchg->chan[LP8788_VBATT] = IS_ERR(chan) ? NULL : chan;
-		break;
-	default:
-		dev_err(dev, "invalid ADC id for VBATT: %d\n", id);
-		pchg->chan[LP8788_VBATT] = NULL;
-		break;
-	}
+	/* ADC channel for battery voltage */
+	chan = iio_channel_get(consumer_name, pdata->adc_vbatt);
+	pchg->chan[LP8788_VBATT] = IS_ERR(chan) ? NULL : chan;
 
-	id = pdata->batt_temp_adc;
-	switch (id) {
-	case LPADC_ADC1:
-	case LPADC_ADC2:
-	case LPADC_ADC3:
-	case LPADC_ADC4:
-		chan = iio_channel_get(consumer_name, chan_name[id]);
-		pchg->chan[LP8788_BATT_TEMP] = IS_ERR(chan) ? NULL : chan;
-		break;
-	default:
-		dev_err(dev, "invalid ADC id for BATT_TEMP : %d\n", id);
-		pchg->chan[LP8788_BATT_TEMP] = NULL;
-		break;
-	}
+	/* ADC channel for battery temperature */
+	chan = iio_channel_get(consumer_name, pdata->adc_batt_temp);
+	pchg->chan[LP8788_BATT_TEMP] = IS_ERR(chan) ? NULL : chan;
 }
 
 static void lp8788_release_adc_channel(struct lp8788_charger *pchg)
diff --git a/include/linux/mfd/lp8788.h b/include/linux/mfd/lp8788.h
index cec364b..2a32b16 100644
--- a/include/linux/mfd/lp8788.h
+++ b/include/linux/mfd/lp8788.h
@@ -211,16 +211,16 @@ struct lp8788_chg_param {
 
 /*
  * struct lp8788_charger_platform_data
- * @vbatt_adc         : adc selection id for battery voltage
- * @batt_temp_adc     : adc selection id for battery temperature
+ * @adc_vbatt         : adc channel name for battery voltage
+ * @adc_batt_temp     : adc channel name for battery temperature
  * @max_vbatt_mv      : used for calculating battery capacity
  * @chg_params        : initial charging parameters
  * @num_chg_params    : numbers of charging parameters
  * @charger_event     : the charger event can be reported to the platform side
  */
 struct lp8788_charger_platform_data {
-	enum lp8788_adc_id vbatt_adc;
-	enum lp8788_adc_id batt_temp_adc;
+	const char *adc_vbatt;
+	const char *adc_batt_temp;
 	unsigned int max_vbatt_mv;
 	struct lp8788_chg_param *chg_params;
 	int num_chg_params;
-- 
1.7.9.5


Best Regards,
Milo

