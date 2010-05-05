Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760057Ab0EENtn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 09:49:43 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:44502 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758456Ab0EENti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 09:49:38 -0400
From: Nitin Gupta <ngupta@vflare.org>
To: Greg KH <greg@kroah.com>
Cc: Minchan Kim <minchan.kim@gmail.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Cyp <cyp561@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       driverdev <devel@driverdev.osuosl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] ramzswap: Register for swap event notifiers and callback
Date: Wed,  5 May 2010 19:15:56 +0530
Message-Id: <1273067156-2574-4-git-send-email-ngupta@vflare.org>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1273067156-2574-1-git-send-email-ngupta@vflare.org>
References: <1273067156-2574-1-git-send-email-ngupta@vflare.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SWAPON handler sets callback which frees memory associated
with given swap slot, eliminating any stale data in corresponding
ramzswap device.

Without this callback, ramzswap device does not get any notification
when a swap slot is freed. Thus, stale data can quickly accumulate in
(compressed) memory which can defeat the whole purpose of such a device.
With this callback, the device can free memory as soon as corresponding
swap slot is freed.

Signed-off-by: Nitin Gupta <ngupta@vflare.org>
---
 drivers/staging/ramzswap/TODO           |    5 --
 drivers/staging/ramzswap/ramzswap_drv.c |   79 ++++++++++++++++++++++++++++++-
 2 files changed, 78 insertions(+), 6 deletions(-)
 delete mode 100644 drivers/staging/ramzswap/TODO

diff --git a/drivers/staging/ramzswap/TODO b/drivers/staging/ramzswap/TODO
deleted file mode 100644
index 8d64e28..0000000
--- a/drivers/staging/ramzswap/TODO
+++ /dev/null
@@ -1,5 +0,0 @@
-TODO:
-	- Add support for swap notifiers
-
-Please send patches to Greg Kroah-Hartman <greg@kroah.com> and
-Nitin Gupta <ngupta@vflare.org>
diff --git a/drivers/staging/ramzswap/ramzswap_drv.c b/drivers/staging/ramzswap/ramzswap_drv.c
index ee5eb12..4be5bf7 100644
--- a/drivers/staging/ramzswap/ramzswap_drv.c
+++ b/drivers/staging/ramzswap/ramzswap_drv.c
@@ -1300,6 +1300,76 @@ static struct block_device_operations ramzswap_devops = {
 	.owner = THIS_MODULE,
 };
 
+/*
+ * Returns ramzswap device for the given swap file. Also caches
+ * struct ramzswap in file->private_data.
+ *
+ * Returns NULL if the given file is not a ramzswap device.
+ */
+static struct ramzswap *ramzswap_find_device(struct file *swap_file)
+{
+	int i;
+	struct inode *inode;
+	struct ramzswap *rzs;
+	struct block_device *bdev;
+
+	inode =	swap_file->f_mapping->host;
+	bdev = I_BDEV(inode);
+	rzs = bdev->bd_disk->private_data;
+
+	for (i = 0; i < num_devices; i++) {
+		if (rzs == &devices[i])
+			break;
+	}
+
+	if (i == num_devices) {
+		rzs = NULL;
+		goto out;
+	}
+
+out:
+	return rzs;
+}
+
+void ramzswap_slot_free_notify(struct block_device *bdev, unsigned long index)
+{
+	struct ramzswap *rzs = bdev->bd_disk->private_data;
+	ramzswap_free_page(rzs, index);
+	rzs_stat64_inc(rzs, &rzs->stats.notify_free);
+}
+
+int ramzswap_swapon_notify(struct notifier_block *nb, unsigned long type,
+							void *swap_file)
+{
+	int ret = -EINVAL;
+
+	if (ramzswap_find_device(swap_file)) {
+		set_ramzswap_slot_free_notify(type, ramzswap_slot_free_notify);
+		ret = 0;
+	}
+	return ret;
+}
+
+int ramzswap_swapoff_notify(struct notifier_block *nb, unsigned long type,
+							void *swap_file)
+{
+	int ret = -EINVAL;
+
+	if (ramzswap_find_device(swap_file)) {
+		set_ramzswap_slot_free_notify(type, NULL);
+		ret = 0;
+	}
+	return ret;
+}
+
+static struct notifier_block ramzswap_swapon_nb = {
+	.notifier_call = ramzswap_swapon_notify,
+};
+
+static struct notifier_block ramzswap_swapoff_nb = {
+	.notifier_call = ramzswap_swapoff_notify,
+};
+
 static int create_device(struct ramzswap *rzs, int device_id)
 {
 	int ret = 0;
@@ -1401,8 +1471,11 @@ static int __init ramzswap_init(void)
 			goto free_devices;
 	}
 
-	return 0;
+	register_swap_event_notifier(&ramzswap_swapon_nb, SWAP_EVENT_SWAPON);
+	register_swap_event_notifier(&ramzswap_swapoff_nb,
+							SWAP_EVENT_SWAPOFF);
 
+	return 0;
 free_devices:
 	while (dev_id)
 		destroy_device(&devices[--dev_id]);
@@ -1417,6 +1490,10 @@ static void __exit ramzswap_exit(void)
 	int i;
 	struct ramzswap *rzs;
 
+	unregister_swap_event_notifier(&ramzswap_swapon_nb, SWAP_EVENT_SWAPON);
+	unregister_swap_event_notifier(&ramzswap_swapoff_nb,
+							SWAP_EVENT_SWAPOFF);
+
 	for (i = 0; i < num_devices; i++) {
 		rzs = &devices[i];
 
-- 
1.6.6.1

