Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756408Ab1LBWZM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 17:25:12 -0500
Received: from mail-yx0-f202.google.com ([209.85.213.202]:51787 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755550Ab1LBWZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 17:25:11 -0500
X-Greylist: delayed 336 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Dec 2011 17:25:11 EST
From: Bryan Freed <bfreed@chromium.org>
To: jbrenner@taosinc.com
Cc: linux-iio@vger.kernel.org, jic23@cam.ac.uk, gregkh@suse.de,
        linux-kernel@vger.kernel.org, Bryan Freed <bfreed@chromium.org>
Subject: [PATCH v2] iio: light sensor: Improve granularity of tsl2583 lux values.
Date: Fri,  2 Dec 2011 14:19:30 -0800
Message-Id: <1322864370-15126-1-git-send-email-bfreed@chromium.org>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When illuminance0_calibbias gets 4000 (for a 4x multiplier), we see lux
granularity of 4.  Reversing the order of the right shift and multiplication
retains the precision of the unadjusted lux value.

Signed-off-by: Bryan Freed <bfreed@chromium.org>
---
 drivers/staging/iio/light/tsl2583.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/iio/light/tsl2583.c b/drivers/staging/iio/light/tsl2583.c
index 80f77cf..25f4c1d 100644
--- a/drivers/staging/iio/light/tsl2583.c
+++ b/drivers/staging/iio/light/tsl2583.c
@@ -194,6 +194,7 @@ static int taos_get_lux(struct iio_dev *indio_dev)
 {
 	u16 ch0, ch1; /* separated ch0/ch1 data from device */
 	u32 lux; /* raw lux calculated from device data */
+	u64 lux64;
 	u32 ratio;
 	u8 buf[5];
 	struct taos_lux *p;
@@ -297,9 +298,19 @@ static int taos_get_lux(struct iio_dev *indio_dev)
 		lux = (lux + (chip->als_time_scale >> 1)) /
 			chip->als_time_scale;
 
-	/* adjust for active gain scale */
-	lux >>= 13; /* tables have factor of 8192 builtin for accuracy */
-	lux = (lux * chip->taos_settings.als_gain_trim + 500) / 1000;
+	/* Adjust for active gain scale.
+	 * The taos_device_lux tables above have a factor of 8192 built in,
+	 * so we need to shift right.
+	 * User-specified gain provides a multiplier.
+	 * Apply user-specified gain before shifting right to retain precision.
+	 * Use 64 bits to avoid overflow on multiplication.
+	 * Then go back to 32 bits before division to avoid using div_u64().
+	 */
+	lux64 = lux;
+	lux64 = lux64 * chip->taos_settings.als_gain_trim;
+	lux64 >>= 13;
+	lux = lux64;
+	lux = (lux + 500) / 1000;
 	if (lux > TSL258X_LUX_CALC_OVER_FLOW) { /* check for overflow */
 return_max:
 		lux = TSL258X_LUX_CALC_OVER_FLOW;
-- 
1.7.3.1

