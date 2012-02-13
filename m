Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109Ab2BMEEy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 23:04:54 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:50434 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540Ab2BMEEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 23:04:53 -0500
MIME-Version: 1.0
From: Nitin Gupta <ngupta@vflare.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Jerome Marchand <jmarchan@redhat.com>,
        Noah Watkins <noahwatkins@gmail.com>,
        Renich Bon Ciric <renich@woralelandia.com>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] [staging-next] zram: Rename module parameter
Date: Sun, 12 Feb 2012 23:04:45 -0500
Message-Id: <1329105885-4038-1-git-send-email-ngupta@vflare.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

zram accepts number of devices to be created
as a module parameter. This was renamed from
num_devices to zram_num_devices (without updating
the documentation!) since num_devices was declared
as a non-static global variable, polluting the global
namespace. Now, we declare it as a static variable
and revert back the name change.

The documentation (zram.txt) already mentions
num_devices as the module parameter name.

Signed-off-by: Nitin Gupta <ngupta@vflare.org>
---
 drivers/staging/zram/zram_drv.c   |   27 ++++++++++++++++-----------
 drivers/staging/zram/zram_drv.h   |    2 +-
 drivers/staging/zram/zram_sysfs.c |    2 +-
 3 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 5833156..7f13819 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -40,7 +40,7 @@ static int zram_major;
 struct zram *zram_devices;
 
 /* Module params (documentation at end) */
-unsigned int zram_num_devices;
+static unsigned int num_devices;
 
 static void zram_stat_inc(u32 *v)
 {
@@ -779,13 +779,18 @@ static void destroy_device(struct zram *zram)
 		blk_cleanup_queue(zram->queue);
 }
 
+unsigned int zram_get_num_devices(void)
+{
+	return num_devices;
+}
+
 static int __init zram_init(void)
 {
 	int ret, dev_id;
 
-	if (zram_num_devices > max_num_devices) {
+	if (num_devices > max_num_devices) {
 		pr_warning("Invalid value for num_devices: %u\n",
-				zram_num_devices);
+				num_devices);
 		ret = -EINVAL;
 		goto out;
 	}
@@ -797,20 +802,20 @@ static int __init zram_init(void)
 		goto out;
 	}
 
-	if (!zram_num_devices) {
+	if (!num_devices) {
 		pr_info("num_devices not specified. Using default: 1\n");
-		zram_num_devices = 1;
+		num_devices = 1;
 	}
 
 	/* Allocate the device array and initialize each one */
-	pr_info("Creating %u devices ...\n", zram_num_devices);
-	zram_devices = kzalloc(zram_num_devices * sizeof(struct zram), GFP_KERNEL);
+	pr_info("Creating %u devices ...\n", num_devices);
+	zram_devices = kzalloc(num_devices * sizeof(struct zram), GFP_KERNEL);
 	if (!zram_devices) {
 		ret = -ENOMEM;
 		goto unregister;
 	}
 
-	for (dev_id = 0; dev_id < zram_num_devices; dev_id++) {
+	for (dev_id = 0; dev_id < num_devices; dev_id++) {
 		ret = create_device(&zram_devices[dev_id], dev_id);
 		if (ret)
 			goto free_devices;
@@ -833,7 +838,7 @@ static void __exit zram_exit(void)
 	int i;
 	struct zram *zram;
 
-	for (i = 0; i < zram_num_devices; i++) {
+	for (i = 0; i < num_devices; i++) {
 		zram = &zram_devices[i];
 
 		destroy_device(zram);
@@ -847,8 +852,8 @@ static void __exit zram_exit(void)
 	pr_debug("Cleanup done!\n");
 }
 
-module_param(zram_num_devices, uint, 0);
-MODULE_PARM_DESC(zram_num_devices, "Number of zram devices");
+module_param(num_devices, uint, 0);
+MODULE_PARM_DESC(num_devices, "Number of zram devices");
 
 module_init(zram_init);
 module_exit(zram_exit);
diff --git a/drivers/staging/zram/zram_drv.h b/drivers/staging/zram/zram_drv.h
index 572faa8..fbe8ac9 100644
--- a/drivers/staging/zram/zram_drv.h
+++ b/drivers/staging/zram/zram_drv.h
@@ -124,7 +124,7 @@ struct zram {
 };
 
 extern struct zram *zram_devices;
-extern unsigned int zram_num_devices;
+unsigned int zram_get_num_devices(void);
 #ifdef CONFIG_SYSFS
 extern struct attribute_group zram_disk_attr_group;
 #endif
diff --git a/drivers/staging/zram/zram_sysfs.c b/drivers/staging/zram/zram_sysfs.c
index d2875c5..a7f3771 100644
--- a/drivers/staging/zram/zram_sysfs.c
+++ b/drivers/staging/zram/zram_sysfs.c
@@ -34,7 +34,7 @@ static struct zram *dev_to_zram(struct device *dev)
 	int i;
 	struct zram *zram = NULL;
 
-	for (i = 0; i < zram_num_devices; i++) {
+	for (i = 0; i < zram_get_num_devices(); i++) {
 		zram = &zram_devices[i];
 		if (disk_to_dev(zram->disk) == dev)
 			break;
-- 
1.7.7.6

