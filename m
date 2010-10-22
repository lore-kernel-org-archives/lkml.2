Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234Ab0JVL6W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 07:58:22 -0400
Received: from mgw-sa02.nokia.com ([147.243.1.48]:30365 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab0JVL6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 07:58:18 -0400
From: Samu Onkalo <samu.p.onkalo@nokia.com>
To: eric.piel@tremplin-utc.net, khali@linux-fr.org, guenter.roeck@ericsson.com,
        jic23@cam.ac.uk
Cc: lm-sensors@lm-sensors.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 05/12] hwmon: lis3: Power on corrections
Date: Fri, 22 Oct 2010 14:57:27 +0300
Message-Id: <1287748654-2626-6-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1287748654-2626-1-git-send-email-samu.p.onkalo@nokia.com>
References: <1287748654-2626-1-git-send-email-samu.p.onkalo@nokia.com>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes lis3 chip seems to fail to setup factory tuning at boot up.
This probably happens if there is some odd power ramp down ramp up sequence
for example in device restart. Set boot bit in control2 register to
trig boot sequence manually and wait until it is finished.

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
---
 drivers/hwmon/lis3lv02d.c |   19 +++++++++++--------
 drivers/hwmon/lis3lv02d.h |    1 +
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/hwmon/lis3lv02d.c b/drivers/hwmon/lis3lv02d.c
index e2e0bb4..b44d4c5 100644
--- a/drivers/hwmon/lis3lv02d.c
+++ b/drivers/hwmon/lis3lv02d.c
@@ -273,19 +273,22 @@ void lis3lv02d_poweron(struct lis3lv02d *lis3)
 
 	lis3->init(lis3);
 
-	/* LIS3 power on delay is quite long */
-	msleep(lis3->pwron_delay / lis3lv02d_get_odr());
-
 	/*
 	 * Common configuration
 	 * BDU: (12 bits sensors only) LSB and MSB values are not updated until
 	 *      both have been read. So the value read will always be correct.
+	 * Set BOOT bit to refresh factory tuning values.
 	 */
-	if (lis3->whoami ==  WAI_12B) {
-		lis3->read(lis3, CTRL_REG2, &reg);
-		reg |= CTRL2_BDU;
-		lis3->write(lis3, CTRL_REG2, reg);
-	}
+	lis3->read(lis3, CTRL_REG2, &reg);
+	if (lis3->whoami ==  WAI_12B)
+		reg |= CTRL2_BDU | CTRL2_BOOT;
+	else
+		reg |= CTRL2_BOOT_8B;
+	lis3->write(lis3, CTRL_REG2, reg);
+
+	/* LIS3 power on delay is quite long */
+	msleep(lis3->pwron_delay / lis3lv02d_get_odr());
+
 	if (lis3->reg_ctrl)
 		lis3_context_restore(lis3);
 }
diff --git a/drivers/hwmon/lis3lv02d.h b/drivers/hwmon/lis3lv02d.h
index 66e37b1..2ac27b9 100644
--- a/drivers/hwmon/lis3lv02d.h
+++ b/drivers/hwmon/lis3lv02d.h
@@ -133,6 +133,7 @@ enum lis3lv02d_ctrl2 {
 enum lis302d_ctrl2 {
 	HP_FF_WU2	= 0x08,
 	HP_FF_WU1	= 0x04,
+	CTRL2_BOOT_8B   = 0x40,
 };
 
 enum lis3lv02d_ctrl3 {
-- 
1.6.0.4

