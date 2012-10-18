Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498Ab2JRGMJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 02:12:09 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:34178 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754457Ab2JRGMG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 02:12:06 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "cbou@mail.ru" <cbou@mail.ru>
CC: Anton Vorontsov <anton.vorontsov@linaro.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Jonathan Cameron <jic23@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] lp8788-charger: fix wrong ADC conversion
Thread-Topic: [PATCH 3/3] lp8788-charger: fix wrong ADC conversion
Thread-Index: Ac2s93gDQSeJyP+TRoq5NeyBztAjJQ==
Date: Thu, 18 Oct 2012 06:11:53 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F64178FA7@DQHE02.ent.ti.com>
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

 To get the battery voltage and temperature, IIO ADC functions are used.
 LP8788 ADC driver provides RAW and SCALE channel information.
 Both RAW with SCALE values are used for the ADC calculation.
 The scale is micro unit, additional conversions are required in each case.
 This patch fixes wrong ADC result.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/power/lp8788-charger.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/power/lp8788-charger.c b/drivers/power/lp8788-charger.c
index 02fc9ab..3c739e6 100644
--- a/drivers/power/lp8788-charger.c
+++ b/drivers/power/lp8788-charger.c
@@ -239,19 +239,26 @@ static int lp8788_get_vbatt_adc(struct lp8788_charger *pchg,
 				unsigned int *result)
 {
 	struct iio_channel *channel = pchg->chan[LP8788_VBATT];
+	int raw;
 	int scaleint;
 	int scalepart;
 	int ret;
+	unsigned long tmp;
 
 	if (!channel)
 		return -EINVAL;
 
+	ret = iio_read_channel_raw(channel, &raw);
+	if (ret != IIO_VAL_INT)
+		return -EINVAL;
+
 	ret = iio_read_channel_scale(channel, &scaleint, &scalepart);
 	if (ret != IIO_VAL_INT_PLUS_MICRO)
 		return -EINVAL;
 
 	/* unit: mV */
-	*result = (scaleint + scalepart * 1000000) / 1000;
+	tmp = raw * scaleint + div_u64(raw * scalepart, 1000000L);
+	*result = (unsigned int)tmp;
 
 	return 0;
 }
@@ -304,19 +311,26 @@ static int lp8788_get_battery_temperature(struct lp8788_charger *pchg,
 				union power_supply_propval *val)
 {
 	struct iio_channel *channel = pchg->chan[LP8788_BATT_TEMP];
+	int raw;
 	int scaleint;
 	int scalepart;
 	int ret;
+	unsigned long tmp;
 
 	if (!channel)
 		return -EINVAL;
 
+	ret = iio_read_channel_raw(channel, &raw);
+	if (ret != IIO_VAL_INT)
+		return -EINVAL;
+
 	ret = iio_read_channel_scale(channel, &scaleint, &scalepart);
 	if (ret != IIO_VAL_INT_PLUS_MICRO)
 		return -EINVAL;
 
 	/* unit: 0.1 'C */
-	val->intval = (scaleint + scalepart * 1000000) / 100;
+	tmp = raw * scaleint + div_u64(raw * scalepart, 1000000L);
+	val->intval = (unsigned int)tmp * 10;
 
 	return 0;
 }
-- 
1.7.9.5


Best Regards,
Milo


