Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575Ab0JaHwY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 03:52:24 -0400
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:47739 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752554Ab0JaHwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 03:52:22 -0400
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Jean Delvare <khali@linux-fr.org>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 1/8] hwmon: applesmc: Relax the severity of device init failure
Date: Sun, 31 Oct 2010 08:50:27 +0100
Message-Id: <1288511434-5662-2-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1288511434-5662-1-git-send-email-rydberg@euromail.se>
References: <1288511434-5662-1-git-send-email-rydberg@euromail.se>
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1PCSi3-0002gy-9j.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1PCSi3-0002gy-9j 325fdac9f2349ace8f38db6a85445b30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The device init is used to reset the accelerometer. Failure to reset
is not severe enough to stop loading the module or to resume from
hibernation.  This patch relaxes failure to a warning and drops
output in case of success.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/hwmon/applesmc.c |   24 ++----------------------
 1 files changed, 2 insertions(+), 22 deletions(-)

diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index d7a5b75..375e464 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -458,21 +458,8 @@ static int applesmc_device_init(void)
 	mutex_lock(&applesmc_lock);
 
 	for (total = INIT_TIMEOUT_MSECS; total > 0; total -= INIT_WAIT_MSECS) {
-		if (debug)
-			printk(KERN_DEBUG "applesmc try %d\n", total);
 		if (!applesmc_read_key(MOTION_SENSOR_KEY, buffer, 2) &&
 				(buffer[0] != 0x00 || buffer[1] != 0x00)) {
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
 			ret = 0;
 			goto out;
 		}
@@ -512,13 +499,8 @@ static int applesmc_get_fan_count(void)
 /* Device model stuff */
 static int applesmc_probe(struct platform_device *dev)
 {
-	int ret;
+	applesmc_device_init();
 
-	ret = applesmc_device_init();
-	if (ret)
-		return ret;
-
-	pr_info("device successfully initialized\n");
 	return 0;
 }
 
@@ -535,9 +517,7 @@ static int applesmc_pm_resume(struct device *dev)
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

