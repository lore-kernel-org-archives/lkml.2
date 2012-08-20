Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901Ab2HTLEo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 07:04:44 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40851 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742Ab2HTLEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 07:04:40 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Ming Lei <ming.lei@canonical.com>
Subject: [PATCH 2/3] firmware loader: let caching firmware piggyback on loading firmware
Date: Mon, 20 Aug 2012 19:04:16 +0800
Message-Id: <1345460657-24093-2-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1345460657-24093-1-git-send-email-ming.lei@canonical.com>
References: <1345460657-24093-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After starting caching firmware, there is still some time left
before devices are suspended, during the period, request_firmware
or its nowait version may still be triggered by the below situations
to load firmware images which can't be cached during suspend/resume
cycle.

	- new devices added
	- driver bind
	- or device open kind of things

This patch utilizes the piggyback trick to cache firmware for
this kind of situation: just increase the firmware buf's reference
count and add the fw name entry into cache entry list after starting
caching firmware and before syscore_suspend() is called.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/base/firmware_class.c |   83 ++++++++++++++++++++++++++++++++++++-----
 1 file changed, 74 insertions(+), 9 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index edc88bc..95f6851 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -25,6 +25,7 @@
 #include <linux/async.h>
 #include <linux/pm.h>
 #include <linux/suspend.h>
+#include <linux/syscore_ops.h>
 
 #include "base.h"
 
@@ -105,6 +106,8 @@ struct firmware_cache {
 	spinlock_t name_lock;
 	struct list_head fw_names;
 
+	int state;
+
 	wait_queue_head_t wait_queue;
 	int cnt;
 	struct delayed_work work;
@@ -146,6 +149,11 @@ struct fw_name_devm {
 
 #define to_fwbuf(d) container_of(d, struct firmware_buf, ref)
 
+#define	FW_LOADER_NO_CACHE	0
+#define	FW_LOADER_START_CACHE	1
+
+static int fw_cache_piggyback_on_request(const char *name);
+
 /* fw_lock could be moved to 'struct firmware_priv' but since it is just
  * guarding for corner cases a global lock should be OK */
 static DEFINE_MUTEX(fw_lock);
@@ -741,6 +749,7 @@ static int _request_firmware_load(struct firmware_priv *fw_priv, bool uevent,
 	int retval = 0;
 	struct device *f_dev = &fw_priv->dev;
 	struct firmware_buf *buf = fw_priv->buf;
+	struct firmware_cache *fwc = &fw_cache;
 
 	dev_set_uevent_suppress(f_dev, true);
 
@@ -796,6 +805,15 @@ static int _request_firmware_load(struct firmware_priv *fw_priv, bool uevent,
 	if (!retval)
 		retval = fw_map_pages_buf(buf);
 
+	/*
+	 * After caching firmware image is started, let it piggyback
+	 * on request firmware.
+	 */
+	if (!retval && fwc->state == FW_LOADER_START_CACHE) {
+		if (fw_cache_piggyback_on_request(buf->fw_id))
+			kref_get(&buf->ref);
+	}
+
 	/* pass the pages buffer to driver at the last minute */
 	fw_set_page_data(buf, fw_priv->fw);
 
@@ -1041,6 +1059,29 @@ exit:
 	return fce;
 }
 
+static int fw_cache_piggyback_on_request(const char *name)
+{
+	struct firmware_cache *fwc = &fw_cache;
+	struct fw_cache_entry *fce;
+	int ret = 0;
+
+	spin_lock(&fwc->name_lock);
+	list_for_each_entry(fce, &fwc->fw_names, list) {
+		if (!strcmp(fce->name, name))
+			goto found;
+	}
+
+	fce = alloc_fw_cache_entry(name);
+	if (fce) {
+		ret = 1;
+		list_add(&fce->list, &fwc->fw_names);
+		pr_debug("%s: fw: %s\n", __func__, name);
+	}
+found:
+	spin_unlock(&fwc->name_lock);
+	return ret;
+}
+
 static void free_fw_cache_entry(struct fw_cache_entry *fce)
 {
 	kfree(fce);
@@ -1054,17 +1095,14 @@ static void __async_dev_cache_fw_image(void *fw_entry,
 	int ret;
 
 	ret = cache_firmware(fce->name);
-	if (ret)
-		goto free;
+	if (ret) {
+		spin_lock(&fwc->name_lock);
+		list_del(&fce->list);
+		spin_unlock(&fwc->name_lock);
 
-	spin_lock(&fwc->name_lock);
-	list_add(&fce->list, &fwc->fw_names);
-	spin_unlock(&fwc->name_lock);
-	goto drop_ref;
+		free_fw_cache_entry(fce);
+	}
 
-free:
-	free_fw_cache_entry(fce);
-drop_ref:
 	spin_lock(&fwc->name_lock);
 	fwc->cnt--;
 	spin_unlock(&fwc->name_lock);
@@ -1109,6 +1147,7 @@ static void dev_cache_fw_image(struct device *dev, void *data)
 
 		spin_lock(&fwc->name_lock);
 		fwc->cnt++;
+		list_add(&fce->list, &fwc->fw_names);
 		spin_unlock(&fwc->name_lock);
 
 		async_schedule(__async_dev_cache_fw_image, (void *)fce);
@@ -1164,7 +1203,10 @@ static void device_cache_fw_images(void)
 	old_timeout = loading_timeout;
 	loading_timeout = 10;
 
+	mutex_lock(&fw_lock);
+	fwc->state = FW_LOADER_START_CACHE;
 	dpm_for_each_dev(NULL, dev_cache_fw_image);
+	mutex_unlock(&fw_lock);
 
 	/* wait for completion of caching firmware for all devices */
 	spin_lock(&fwc->name_lock);
@@ -1229,6 +1271,14 @@ static int fw_pm_notify(struct notifier_block *notify_block,
 	case PM_POST_SUSPEND:
 	case PM_POST_HIBERNATION:
 	case PM_POST_RESTORE:
+		/*
+		 * In case that system sleep failed and syscore_suspend is
+		 * not called.
+		 */
+		mutex_lock(&fw_lock);
+		fw_cache.state = FW_LOADER_NO_CACHE;
+		mutex_unlock(&fw_lock);
+
 		device_uncache_fw_images_delay(10 * MSEC_PER_SEC);
 		break;
 	}
@@ -1243,6 +1293,17 @@ static int fw_pm_notify(struct notifier_block *notify_block,
 }
 #endif
 
+/* stop caching firmware once syscore_suspend is reached */
+static int fw_suspend(void)
+{
+	fw_cache.state = FW_LOADER_NO_CACHE;
+	return 0;
+}
+
+static struct syscore_ops fw_syscore_ops = {
+	.suspend = fw_suspend,
+};
+
 static void __init fw_cache_init(void)
 {
 	spin_lock_init(&fw_cache.lock);
@@ -1251,6 +1312,7 @@ static void __init fw_cache_init(void)
 	spin_lock_init(&fw_cache.name_lock);
 	INIT_LIST_HEAD(&fw_cache.fw_names);
 	fw_cache.cnt = 0;
+	fw_cache.state = FW_LOADER_NO_CACHE;
 
 	init_waitqueue_head(&fw_cache.wait_queue);
 	INIT_DELAYED_WORK(&fw_cache.work,
@@ -1258,6 +1320,8 @@ static void __init fw_cache_init(void)
 
 	fw_cache.pm_notify.notifier_call = fw_pm_notify;
 	register_pm_notifier(&fw_cache.pm_notify);
+
+	register_syscore_ops(&fw_syscore_ops);
 }
 
 static int __init firmware_class_init(void)
@@ -1268,6 +1332,7 @@ static int __init firmware_class_init(void)
 
 static void __exit firmware_class_exit(void)
 {
+	unregister_syscore_ops(&fw_syscore_ops);
 	unregister_pm_notifier(&fw_cache.pm_notify);
 	class_unregister(&firmware_class);
 }
-- 
1.7.9.5

