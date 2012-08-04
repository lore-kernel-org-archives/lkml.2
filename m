Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095Ab2HDED2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 00:03:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45263 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000Ab2HDEDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 00:03:21 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel@vger.kernel.org, Ming Lei <ming.lei@canonical.com>
Subject: [RFC PATCH v1 14/15] firmware loader: cache devices firmware during suspend/resume cycle
Date: Sat,  4 Aug 2012 12:01:29 +0800
Message-Id: <1344052890-31935-15-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344052890-31935-1-git-send-email-ming.lei@canonical.com>
References: <1344052890-31935-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements caching devices' firmware automatically
during system syspend/resume cycle, so any device drivers can
call request_firmware or request_firmware_nowait inside resume
path to get the cached firmware if they have loaded firmwares
successfully at least once before entering suspend.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/base/firmware_class.c |   32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 8ca0052..5bd2100 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -24,6 +24,7 @@
 #include <linux/list.h>
 #include <linux/async.h>
 #include <linux/pm.h>
+#include <linux/suspend.h>
 
 #include "base.h"
 #include "power/power.h"
@@ -108,6 +109,8 @@ struct firmware_cache {
 	wait_queue_head_t wait_queue;
 	int cnt;
 	struct delayed_work work;
+
+	struct notifier_block   pm_notify;
 };
 
 struct firmware_buf {
@@ -1217,6 +1220,31 @@ static void device_uncache_fw_images_delay(unsigned long delay)
 			msecs_to_jiffies(delay));
 }
 
+#ifdef CONFIG_PM
+static int fw_pm_notify(struct notifier_block *notify_block,
+			unsigned long mode, void *unused)
+{
+	switch (mode) {
+	case PM_HIBERNATION_PREPARE:
+	case PM_SUSPEND_PREPARE:
+		device_cache_fw_images();
+		break;
+
+	case PM_POST_SUSPEND:
+	case PM_POST_HIBERNATION:
+	case PM_POST_RESTORE:
+		device_uncache_fw_images_delay(10 * MSEC_PER_SEC);
+		break;
+	}
+
+	return 0;
+}
+#else
+static int fw_pm_notify(struct notifier_block *notify_block,
+			unsigned long mode, void *unused)
+{}
+#endif
+
 static void __init fw_cache_init(void)
 {
 	spin_lock_init(&fw_cache.lock);
@@ -1229,6 +1257,9 @@ static void __init fw_cache_init(void)
 	init_waitqueue_head(&fw_cache.wait_queue);
 	INIT_DELAYED_WORK(&fw_cache.work,
 			  device_uncache_fw_images_work);
+
+	fw_cache.pm_notify.notifier_call = fw_pm_notify;
+	register_pm_notifier(&fw_cache.pm_notify);
 }
 
 static int __init firmware_class_init(void)
@@ -1239,6 +1270,7 @@ static int __init firmware_class_init(void)
 
 static void __exit firmware_class_exit(void)
 {
+	unregister_pm_notifier(&fw_cache.pm_notify);
 	class_unregister(&firmware_class);
 }
 
-- 
1.7.9.5

