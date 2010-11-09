Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756Ab0KIPQu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 10:16:50 -0500
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:53751 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752559Ab0KIPQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 10:16:48 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Guenter Roeck <guenter.roeck@ericsson.com>,
        Jean Delvare <khali@linux-fr.org>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>, stable@kernel.org
Subject: [PATCH 02/11] hwmon: applesmc: Relax the severity of device init failure (rev2)
Date: Tue,  9 Nov 2010 16:15:02 +0100
Message-Id: <1289315711-3011-3-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1289315711-3011-1-git-send-email-rydberg@euromail.se>
References: <1289315711-3011-1-git-send-email-rydberg@euromail.se>
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1PFpvp-00017t-5i.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1PFpvp-00017t-5i 330390b0f5b1306da2aa3d563bd1d097
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The device init is used to reset the accelerometer. Failure to reset
is not severe enough to stop loading the module or to resume from
hibernation.  This patch relaxes failure to a warning and drops
output in case of success.

Cc: stable@kernel.org
Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/hwmon/applesmc.c |   38 +++++++-------------------------------
 1 files changed, 7 insertions(+), 31 deletions(-)

diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index d616174..87a5fd5 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -448,38 +448,22 @@ static int applesmc_read_motion_sensor(int index, s16* value)
 }
 
 /*
- * applesmc_device_init - initialize the accelerometer.  Returns zero on success
- * and negative error code on failure.  Can sleep.
+ * applesmc_device_init - initialize the accelerometer.  Can sleep.
  */
-static int applesmc_device_init(void)
+static void applesmc_device_init(void)
 {
-	int total, ret = -ENXIO;
+	int total;
 	u8 buffer[2];
 
 	if (!applesmc_accelerometer)
-		return 0;
+		return;
 
 	mutex_lock(&applesmc_lock);
 
 	for (total = INIT_TIMEOUT_MSECS; total > 0; total -= INIT_WAIT_MSECS) {
-		if (debug)
-			printk(KERN_DEBUG "applesmc try %d\n", total);
 		if (!applesmc_read_key(MOTION_SENSOR_KEY, buffer, 2) &&
-				(buffer[0] != 0x00 || buffer[1] != 0x00)) {
-			if (total == INIT_TIMEOUT_MSECS) {
-				printk(KERN_DEBUG "applesmc: device has"
-						" already been initialized"
-						" (0x%02x, 0x%02x).\n",
-						buffer[0], buffer[1]);
-			} else {
-				printk(KERN_DEBUG "applesmc: device"
-						" successfully initialized"
-						" (0x%02x, 0x%02x).\n",
-						buffer[0], buffer[1]);
-			}
-			ret = 0;
+				(buffer[0] != 0x00 || buffer[1] != 0x00))
 			goto out;
-		}
 		buffer[0] = 0xe0;
 		buffer[1] = 0x00;
 		applesmc_write_key(MOTION_SENSOR_KEY, buffer, 2);
@@ -490,7 +474,6 @@ static int applesmc_device_init(void)
 
 out:
 	mutex_unlock(&applesmc_lock);
-	return ret;
 }
 
 /*
@@ -516,13 +499,8 @@ static int applesmc_get_fan_count(void)
 /* Device model stuff */
 static int applesmc_probe(struct platform_device *dev)
 {
-	int ret;
+	applesmc_device_init();
 
-	ret = applesmc_device_init();
-	if (ret)
-		return ret;
-
-	printk(KERN_INFO "applesmc: device successfully initialized.\n");
 	return 0;
 }
 
@@ -539,9 +517,7 @@ static int applesmc_pm_resume(struct device *dev)
 /* Reinitialize device on resume from hibernation */
 static int applesmc_pm_restore(struct device *dev)
 {
-	int ret = applesmc_device_init();
-	if (ret)
-		return ret;
+	applesmc_device_init();
 	return applesmc_pm_resume(dev);
 }
 
-- 
1.7.1

