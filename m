Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab2JSAMp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 20:12:45 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:38236 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282Ab2JSAMo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 20:12:44 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "cbou@mail.ru" <cbou@mail.ru>
CC: Anton Vorontsov <anton.vorontsov@linaro.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Jonathan Cameron <jic23@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 3/3] lp8788-charger: fix wrong ADC conversion
Thread-Topic: [PATCH v2 3/3] lp8788-charger: fix wrong ADC conversion
Thread-Index: Ac2tjmggvbdbOZ/ASn+h6Cy7gUKb1g==
Date: Fri, 19 Oct 2012 00:12:21 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F64179109@DQHE02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.87.185.123]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 To get the battery voltage and temperature, IIO ADC functions are used.
 LP8788 ADC driver provides RAW and SCALE channel information.
 This patch fixes wrong ADC result.

 Patch v2.
 Use simple iio_read_channel_processed() function rather than
 iio_read_channel_raw() and _scale().

 Fix the result type of ADC function as a signed integer.
 Because power_supply_propval.intval and the return value of
 iio_read_channel_processed() are a signed integer,
 'unsigned int' are replaced with 'int'.

 Patch v1.
 Fix wrong ADC results using iio_read_channel_raw() and _scale().

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/power/lp8788-charger.c |   26 +++++++-------------------
 1 file changed, 7 insertions(+), 19 deletions(-)

diff --git a/drivers/power/lp8788-charger.c b/drivers/power/lp8788-charger.c
index 02fc9ab..f18ec8f 100644
--- a/drivers/power/lp8788-charger.c
+++ b/drivers/power/lp8788-charger.c
@@ -235,25 +235,14 @@ static int lp8788_get_battery_present(struct lp8788_charger *pchg,
 	return 0;
 }
 
-static int lp8788_get_vbatt_adc(struct lp8788_charger *pchg,
-				unsigned int *result)
+static int lp8788_get_vbatt_adc(struct lp8788_charger *pchg, int *result)
 {
 	struct iio_channel *channel = pchg->chan[LP8788_VBATT];
-	int scaleint;
-	int scalepart;
-	int ret;
 
 	if (!channel)
 		return -EINVAL;
 
-	ret = iio_read_channel_scale(channel, &scaleint, &scalepart);
-	if (ret != IIO_VAL_INT_PLUS_MICRO)
-		return -EINVAL;
-
-	/* unit: mV */
-	*result = (scaleint + scalepart * 1000000) / 1000;
-
-	return 0;
+	return iio_read_channel_processed(channel, result);
 }
 
 static int lp8788_get_battery_voltage(struct lp8788_charger *pchg,
@@ -268,7 +257,7 @@ static int lp8788_get_battery_capacity(struct lp8788_charger *pchg,
 	struct lp8788 *lp = pchg->lp;
 	struct lp8788_charger_platform_data *pdata = pchg->pdata;
 	unsigned int max_vbatt;
-	unsigned int vbatt;
+	int vbatt;
 	enum lp8788_charging_state state;
 	u8 data;
 	int ret;
@@ -304,19 +293,18 @@ static int lp8788_get_battery_temperature(struct lp8788_charger *pchg,
 				union power_supply_propval *val)
 {
 	struct iio_channel *channel = pchg->chan[LP8788_BATT_TEMP];
-	int scaleint;
-	int scalepart;
+	int result;
 	int ret;
 
 	if (!channel)
 		return -EINVAL;
 
-	ret = iio_read_channel_scale(channel, &scaleint, &scalepart);
-	if (ret != IIO_VAL_INT_PLUS_MICRO)
+	ret = iio_read_channel_processed(channel, &result);
+	if (ret < 0)
 		return -EINVAL;
 
 	/* unit: 0.1 'C */
-	val->intval = (scaleint + scalepart * 1000000) / 100;
+	val->intval = result * 10;
 
 	return 0;
 }
-- 
1.7.9.5


Best Regards,
Milo


