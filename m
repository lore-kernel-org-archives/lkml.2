Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508Ab1IAEl2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 00:41:28 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:40260 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792Ab1IAElZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 00:41:25 -0400
From: WANG Cong <xiyou.wangcong@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, WANG Cong <xiyou.wangcong@gmail.com>,
        Jean Delvare <khali@linux-fr.org>, Randy Dunlap <rdunlap@xenotime.net>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        linux-doc@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: [PATCH] i2c: remove deprecated callbacks
Date: Thu,  1 Sep 2011 12:40:27 +0800
Message-Id: <1314852027-9523-1-git-send-email-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i2c_driver.attach_adapter and i2c_driver.detach_adapter are deprecated
and scheduled to be removed in Sep 2011.

Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---
diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index c4a6e14..89a9695 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -486,15 +486,6 @@ Files:	include/linux/netfilter_ipv4/ipt_addrtype.h
 
 ----------------------------
 
-What:	i2c_driver.attach_adapter
-	i2c_driver.detach_adapter
-When:	September 2011
-Why:	These legacy callbacks should no longer be used as i2c-core offers
-	a variety of preferable alternative ways to instantiate I2C devices.
-Who:	Jean Delvare <khali@linux-fr.org>
-
-----------------------------
-
 What:	Support for UVCIOC_CTRL_ADD in the uvcvideo driver
 When:	3.2
 Why:	The information passed to the driver by this ioctl is now queried
diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index 131079a..c833c53 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -44,8 +44,8 @@
 
 
 /* core_lock protects i2c_adapter_idr, and guarantees
-   that device detection, deletion of detected devices, and attach_adapter
-   and detach_adapter calls are serialized */
+   that device detection, deletion of detected devices
+   calls are serialized */
 static DEFINE_MUTEX(core_lock);
 static DEFINE_IDR(i2c_adapter_idr);
 
@@ -795,15 +795,6 @@ static int i2c_do_add_adapter(struct i2c_driver *driver,
 	/* Detect supported devices on that bus, and instantiate them */
 	i2c_detect(adap, driver);
 
-	/* Let legacy drivers scan this bus for matching devices */
-	if (driver->attach_adapter) {
-		dev_warn(&adap->dev, "%s: attach_adapter method is deprecated\n",
-			 driver->driver.name);
-		dev_warn(&adap->dev, "Please use another way to instantiate "
-			 "your i2c_client\n");
-		/* We ignore the return code; if it fails, too bad */
-		driver->attach_adapter(adap);
-	}
 	return 0;
 }
 
@@ -975,7 +966,6 @@ static int i2c_do_del_adapter(struct i2c_driver *driver,
 			      struct i2c_adapter *adapter)
 {
 	struct i2c_client *client, *_n;
-	int res;
 
 	/* Remove the devices we created ourselves as the result of hardware
 	 * probing (using a driver's detect method) */
@@ -988,15 +978,7 @@ static int i2c_do_del_adapter(struct i2c_driver *driver,
 		}
 	}
 
-	if (!driver->detach_adapter)
-		return 0;
-	dev_warn(&adapter->dev, "%s: detach_adapter method is deprecated\n",
-		 driver->driver.name);
-	res = driver->detach_adapter(adapter);
-	if (res)
-		dev_err(&adapter->dev, "detach_adapter failed (%d) "
-			"for driver [%s]\n", res, driver->driver.name);
-	return res;
+	return 0;
 }
 
 static int __unregister_client(struct device *dev, void *dummy)
diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index a6c652e..25c2c87 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -142,13 +142,6 @@ extern s32 i2c_smbus_write_i2c_block_data(const struct i2c_client *client,
 struct i2c_driver {
 	unsigned int class;
 
-	/* Notifies the driver that a new bus has appeared or is about to be
-	 * removed. You should avoid using this, it will be removed in a
-	 * near future.
-	 */
-	int (*attach_adapter)(struct i2c_adapter *) __deprecated;
-	int (*detach_adapter)(struct i2c_adapter *) __deprecated;
-
 	/* Standard driver model interfaces */
 	int (*probe)(struct i2c_client *, const struct i2c_device_id *);
 	int (*remove)(struct i2c_client *);
