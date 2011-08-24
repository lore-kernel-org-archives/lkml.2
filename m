Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756342Ab1HXBfu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 21:35:50 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:49051 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755878Ab1HXBfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 21:35:05 -0400
From: Nitin Gupta <ngupta@vflare.org>
To: Greg KH <greg@kroah.com>
Cc: Jerome Marchand <jmarchan@redhat.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Noah Watkins <noahwatkins@gmail.com>
Subject: [PATCH 2/4] Make gobal variables use unique names
Date: Wed, 24 Aug 2011 08:34:48 +0700
Message-Id: <1314149690-3177-3-git-send-email-ngupta@vflare.org>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1314149690-3177-1-git-send-email-ngupta@vflare.org>
References: <1314149690-3177-1-git-send-email-ngupta@vflare.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Global variables 'num_devices' and 'devices' are too
general to be global. This patch switches the name to
be "zram_devices".

Signed-off-by: Noah Watkins <noahwatkins@gmail.com>
Signed-off-by: Nitin Gupta <ngupta@vflare.org>
---
 drivers/staging/zram/zram_drv.c   |   36 ++++++++++++++++++------------------
 drivers/staging/zram/zram_drv.h   |    4 ++--
 drivers/staging/zram/zram_sysfs.c |    4 ++--
 3 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 207234e..81d6c43 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -37,10 +37,10 @@
 
 /* Globals */
 static int zram_major;
-struct zram *devices;
+struct zram *zram_devices;
 
 /* Module params (documentation at end) */
-unsigned int num_devices;
+unsigned int zram_num_devices;
 
 static void zram_stat_inc(u32 *v)
 {
@@ -784,13 +784,12 @@ static int __init zram_init(void)
 	 * Module parameter not specified by user. Use default
 	 * value as defined during kernel config.
 	 */
-	if (num_devices == 0) {
-		num_devices = CONFIG_ZRAM_NUM_DEVICES;
-	}
+	if (zram_num_devices == 0)
+		zram_num_devices = CONFIG_ZRAM_NUM_DEVICES;
 
-	if (num_devices > max_num_devices) {
+	if (zram_num_devices > max_num_devices) {
 		pr_warning("Invalid value for num_devices: %u\n",
-				num_devices);
+				zram_num_devices);
 		ret = -EINVAL;
 		goto out;
 	}
@@ -803,15 +802,16 @@ static int __init zram_init(void)
 	}
 
 	/* Allocate the device array and initialize each one */
-	pr_info("Creating %u devices ...\n", num_devices);
-	devices = kzalloc(num_devices * sizeof(struct zram), GFP_KERNEL);
-	if (!devices) {
+	pr_info("Creating %u devices ...\n", zram_num_devices);
+	zram_devices = kzalloc(zram_num_devices * sizeof(struct zram),
+				GFP_KERNEL);
+	if (!zram_devices) {
 		ret = -ENOMEM;
 		goto unregister;
 	}
 
-	for (dev_id = 0; dev_id < num_devices; dev_id++) {
-		ret = create_device(&devices[dev_id], dev_id);
+	for (dev_id = 0; dev_id < zram_num_devices; dev_id++) {
+		ret = create_device(&zram_devices[dev_id], dev_id);
 		if (ret)
 			goto free_devices;
 	}
@@ -820,8 +820,8 @@ static int __init zram_init(void)
 
 free_devices:
 	while (dev_id)
-		destroy_device(&devices[--dev_id]);
-	kfree(devices);
+		destroy_device(&zram_devices[--dev_id]);
+	kfree(zram_devices);
 unregister:
 	unregister_blkdev(zram_major, "zram");
 out:
@@ -833,8 +833,8 @@ static void __exit zram_exit(void)
 	int i;
 	struct zram *zram;
 
-	for (i = 0; i < num_devices; i++) {
-		zram = &devices[i];
+	for (i = 0; i < zram_num_devices; i++) {
+		zram = &zram_devices[i];
 
 		destroy_device(zram);
 		if (zram->init_done)
@@ -843,11 +843,11 @@ static void __exit zram_exit(void)
 
 	unregister_blkdev(zram_major, "zram");
 
-	kfree(devices);
+	kfree(zram_devices);
 	pr_debug("Cleanup done!\n");
 }
 
-module_param(num_devices, uint, 0);
+module_param_named(num_devices, zram_num_devices, uint, 0);
 MODULE_PARM_DESC(num_devices, "Number of zram devices");
 
 module_init(zram_init);
diff --git a/drivers/staging/zram/zram_drv.h b/drivers/staging/zram/zram_drv.h
index abe5221..59b01d6 100644
--- a/drivers/staging/zram/zram_drv.h
+++ b/drivers/staging/zram/zram_drv.h
@@ -123,8 +123,8 @@ struct zram {
 	struct zram_stats stats;
 };
 
-extern struct zram *devices;
-extern unsigned int num_devices;
+extern struct zram *zram_devices;
+extern unsigned int zram_num_devices;
 #ifdef CONFIG_SYSFS
 extern struct attribute_group zram_disk_attr_group;
 #endif
diff --git a/drivers/staging/zram/zram_sysfs.c b/drivers/staging/zram/zram_sysfs.c
index a70cc01..df1f9dc 100644
--- a/drivers/staging/zram/zram_sysfs.c
+++ b/drivers/staging/zram/zram_sysfs.c
@@ -34,8 +34,8 @@ static struct zram *dev_to_zram(struct device *dev)
 	int i;
 	struct zram *zram = NULL;
 
-	for (i = 0; i < num_devices; i++) {
-		zram = &devices[i];
+	for (i = 0; i < zram_num_devices; i++) {
+		zram = &zram_devices[i];
 		if (disk_to_dev(zram->disk) == dev)
 			break;
 	}
-- 
1.7.6

