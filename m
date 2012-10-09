Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826Ab2JIECJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 00:02:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49523 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab2JIECG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 00:02:06 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Ming Lei <ming.lei@canonical.com>
Subject: [PATCH 4/4] firmware loader: sync firmware cache by async_synchronize_full_domain
Date: Tue,  9 Oct 2012 12:01:04 +0800
Message-Id: <1349755264-23876-5-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349755264-23876-1-git-send-email-ming.lei@canonical.com>
References: <1349755264-23876-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

async.c has provided synchronization mechanism on async_schedule_*,
so use async_synchronize_full_domain to sync caching firmware instead
of reinventing the wheel.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/base/firmware_class.c |   34 ++++++----------------------------
 1 file changed, 6 insertions(+), 28 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index a095d84..8945f4e 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -116,8 +116,6 @@ struct firmware_cache {
 	spinlock_t name_lock;
 	struct list_head fw_names;
 
-	wait_queue_head_t wait_queue;
-	int cnt;
 	struct delayed_work work;
 
 	struct notifier_block   pm_notify;
@@ -1166,6 +1164,8 @@ int uncache_firmware(const char *fw_name)
 }
 
 #ifdef CONFIG_PM_SLEEP
+static ASYNC_DOMAIN_EXCLUSIVE(fw_cache_domain);
+
 static struct fw_cache_entry *alloc_fw_cache_entry(const char *name)
 {
 	struct fw_cache_entry *fce;
@@ -1232,12 +1232,6 @@ static void __async_dev_cache_fw_image(void *fw_entry,
 
 		free_fw_cache_entry(fce);
 	}
-
-	spin_lock(&fwc->name_lock);
-	fwc->cnt--;
-	spin_unlock(&fwc->name_lock);
-
-	wake_up(&fwc->wait_queue);
 }
 
 /* called with dev->devres_lock held */
@@ -1278,7 +1272,6 @@ static void dev_cache_fw_image(struct device *dev, void *data)
 		spin_lock(&fwc->name_lock);
 		/* only one cache entry for one firmware */
 		if (!__fw_entry_found(fce->name)) {
-			fwc->cnt++;
 			list_add(&fce->list, &fwc->fw_names);
 		} else {
 			free_fw_cache_entry(fce);
@@ -1287,8 +1280,9 @@ static void dev_cache_fw_image(struct device *dev, void *data)
 		spin_unlock(&fwc->name_lock);
 
 		if (fce)
-			async_schedule(__async_dev_cache_fw_image,
-				       (void *)fce);
+			async_schedule_domain(__async_dev_cache_fw_image,
+					      (void *)fce,
+					      &fw_cache_domain);
 	}
 }
 
@@ -1350,21 +1344,7 @@ static void device_cache_fw_images(void)
 	mutex_unlock(&fw_lock);
 
 	/* wait for completion of caching firmware for all devices */
-	spin_lock(&fwc->name_lock);
-	for (;;) {
-		prepare_to_wait(&fwc->wait_queue, &wait,
-				TASK_UNINTERRUPTIBLE);
-		if (!fwc->cnt)
-			break;
-
-		spin_unlock(&fwc->name_lock);
-
-		schedule();
-
-		spin_lock(&fwc->name_lock);
-	}
-	spin_unlock(&fwc->name_lock);
-	finish_wait(&fwc->wait_queue, &wait);
+	async_synchronize_full_domain(&fw_cache_domain);
 
 	loading_timeout = old_timeout;
 }
@@ -1452,9 +1432,7 @@ static void __init fw_cache_init(void)
 #ifdef CONFIG_PM_SLEEP
 	spin_lock_init(&fw_cache.name_lock);
 	INIT_LIST_HEAD(&fw_cache.fw_names);
-	fw_cache.cnt = 0;
 
-	init_waitqueue_head(&fw_cache.wait_queue);
 	INIT_DELAYED_WORK(&fw_cache.work,
 			  device_uncache_fw_images_work);
 
-- 
1.7.9.5

