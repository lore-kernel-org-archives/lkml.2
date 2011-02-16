Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932762Ab1BPAri (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:47:38 -0500
Received: from kroah.org ([198.145.64.141]:45158 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932729Ab1BPAr2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:47:28 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:21:00 2011
Message-Id: <20110216002100.051402117@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:19:38 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Henrik Rydberg <rydberg@euromail.se>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [patch 010/176] hwmon: (applesmc) Relax the severity of device init failure
In-Reply-To: <20110216002212.GA9246@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Henrik Rydberg <rydberg@euromail.se>

commit 2344cd0c2e9ea8f3037be11fb997ddbeda0237ca upstream.

The device init is used to reset the accelerometer. Failure to reset
is not severe enough to stop loading the module or to resume from
hibernation.  This patch relaxes failure to a warning and drops
output in case of success.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/applesmc.c |   38 +++++++-------------------------------
 1 file changed, 7 insertions(+), 31 deletions(-)

--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -448,38 +448,22 @@ static int applesmc_read_motion_sensor(i
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
-
-	ret = applesmc_device_init();
-	if (ret)
-		return ret;
+	applesmc_device_init();
 
-	printk(KERN_INFO "applesmc: device successfully initialized.\n");
 	return 0;
 }
 
@@ -539,9 +517,7 @@ static int applesmc_pm_resume(struct dev
 /* Reinitialize device on resume from hibernation */
 static int applesmc_pm_restore(struct device *dev)
 {
-	int ret = applesmc_device_init();
-	if (ret)
-		return ret;
+	applesmc_device_init();
 	return applesmc_pm_resume(dev);
 }
 


