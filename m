Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758055Ab1FJUgU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 16:36:20 -0400
Received: from smtp-out.google.com ([216.239.44.51]:61932 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754736Ab1FJUgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 16:36:17 -0400
From: Bryan Freed <bfreed@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: jic23@cam.ac.uk, jbrenner@taosinc.com, gregkh@suse.de, arnd@arndb.de,
        Bryan Freed <bfreed@chromium.org>
Subject: [PATCH 2/2] light sensor: Preserve granularity of amplified tsl2583 light sensor values.
Date: Fri, 10 Jun 2011 13:26:20 -0700
Message-Id: <1307737580-14131-2-git-send-email-bfreed@chromium.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1307737580-14131-1-git-send-email-bfreed@chromium.org>
References: <1307737580-14131-1-git-send-email-bfreed@chromium.org>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use 64bit lux64 to amplify lux values while preserving granularity.
Normalize illuminance_calibbias amplification value at 1024 instead of 1000
so we can avoid 64bit division (div_u64).

Signed-off-by: Bryan Freed <bfreed@chromium.org>
---
 drivers/staging/iio/light/tsl2583.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/iio/light/tsl2583.c b/drivers/staging/iio/light/tsl2583.c
index 5694610..0324ac1 100644
--- a/drivers/staging/iio/light/tsl2583.c
+++ b/drivers/staging/iio/light/tsl2583.c
@@ -146,7 +146,7 @@ static void taos_defaults(struct tsl2583_chip *chip)
 	chip->taos_settings.als_gain = 0;
 	/* this is actually an index into the gain table */
 	/* assume clear glass as default */
-	chip->taos_settings.als_gain_trim = 1000;
+	chip->taos_settings.als_gain_trim = 1024;
 	/* default gain trim to account for aperture effects */
 	chip->taos_settings.als_cal_target = 130;
 	/* Known external ALS reading used for calibration */
@@ -195,6 +195,7 @@ static int taos_get_lux(struct i2c_client *client)
 {
 	u16 ch0, ch1; /* separated ch0/ch1 data from device */
 	u32 lux; /* raw lux calculated from device data */
+	u64 lux64;
 	u32 ratio;
 	u8 buf[5];
 	struct taos_lux *p;
@@ -298,8 +299,10 @@ static int taos_get_lux(struct i2c_client *client)
 			chip->als_time_scale;
 
 	/* adjust for active gain scale */
-	lux >>= 13; /* tables have factor of 8192 builtin for accuracy */
-	lux = (lux * chip->taos_settings.als_gain_trim + 500) / 1000;
+	lux64 = lux;
+	lux64 = (lux64 * chip->taos_settings.als_gain_trim + 512) >> 10;
+	lux64 >>= 13; /* tables have factor of 8192 builtin for accuracy */
+	lux = lux64;
 	if (lux > TSL258X_LUX_CALC_OVER_FLOW) { /* check for overflow */
 return_max:
 		lux = TSL258X_LUX_CALC_OVER_FLOW;
-- 
1.7.3.1

