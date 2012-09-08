Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566Ab2IHX0f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 19:26:35 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63717 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753943Ab2IHXZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 19:25:48 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Takashi Iwai <tiwai@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, Ming Lei <ming.lei@canonical.com>
Subject: [RFC PATCH 2/5] driver core: introduce driver_register_sync helper
Date: Sun,  9 Sep 2012 07:25:17 +0800
Message-Id: <1347146720-28596-3-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347146720-28596-1-git-send-email-ming.lei@canonical.com>
References: <1347146720-28596-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces driver_register_sync helper to make
driver's probe called synchronously inside driver_register
path.

platform_driver_probe should use driver_register_sync.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/base/driver.c  |    5 +++--
 include/linux/device.h |   13 ++++++++++++-
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/base/driver.c b/drivers/base/driver.c
index 27f4c85..9365076 100644
--- a/drivers/base/driver.c
+++ b/drivers/base/driver.c
@@ -156,12 +156,13 @@ static void driver_remove_groups(struct device_driver *drv,
 /**
  * driver_register - register driver with bus
  * @drv: driver to register
+ * @sync: if the .probe() is called synchronously
  *
  * We pass off most of the work to the bus_add_driver() call,
  * since most of the things we have to do deal with the bus
  * structures.
  */
-int driver_register(struct device_driver *drv)
+int __driver_register(struct device_driver *drv, int sync)
 {
 	int ret;
 	struct device_driver *other;
@@ -197,7 +198,7 @@ int driver_register(struct device_driver *drv)
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(driver_register);
+EXPORT_SYMBOL_GPL(__driver_register);
 
 /**
  * driver_unregister - remove driver from system.
diff --git a/include/linux/device.h b/include/linux/device.h
index dd0d684..7222c0b 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -237,9 +237,20 @@ struct device_driver {
 };
 
 
-extern int __must_check driver_register(struct device_driver *drv);
+extern int __must_check __driver_register(struct device_driver *drv,
+					  int sync);
 extern void driver_unregister(struct device_driver *drv);
 
+static inline int __must_check driver_register(struct device_driver *drv)
+{
+	return __driver_register(drv, 0);
+}
+
+static inline int __must_check driver_register_sync(struct device_driver *drv)
+{
+	return __driver_register(drv, 1);
+}
+
 extern struct device_driver *driver_find(const char *name,
 					 struct bus_type *bus);
 extern int driver_probe_done(void);
-- 
1.7.9.5

