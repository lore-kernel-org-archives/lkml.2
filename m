Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594Ab2IHX0i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 19:26:38 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59021 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947Ab2IHXZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 19:25:56 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Takashi Iwai <tiwai@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, Ming Lei <ming.lei@canonical.com>
Subject: [RFC PATCH 3/5] driver core: platform: apply driver_register_sync for platform_driver_probe
Date: Sun,  9 Sep 2012 07:25:18 +0800
Message-Id: <1347146720-28596-4-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347146720-28596-1-git-send-email-ming.lei@canonical.com>
References: <1347146720-28596-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

platform_driver_probe supposes that the driver's probe is always called
inside platform_driver_probe, so apply driver_register_sync for it.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/base/platform.c         |   11 +++++++----
 include/linux/platform_device.h |   12 +++++++++++-
 2 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 42ca90c..f1d3507 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -500,7 +500,7 @@ static void platform_drv_shutdown(struct device *_dev)
  * platform_driver_register - register a driver for platform-level devices
  * @drv: platform driver structure
  */
-int platform_driver_register(struct platform_driver *drv)
+int __platform_driver_register(struct platform_driver *drv, int sync)
 {
 	drv->driver.bus = &platform_bus_type;
 	if (drv->probe)
@@ -510,9 +510,12 @@ int platform_driver_register(struct platform_driver *drv)
 	if (drv->shutdown)
 		drv->driver.shutdown = platform_drv_shutdown;
 
-	return driver_register(&drv->driver);
+	if (sync)
+		return driver_register_sync(&drv->driver);
+	else
+		return driver_register(&drv->driver);
 }
-EXPORT_SYMBOL_GPL(platform_driver_register);
+EXPORT_SYMBOL_GPL(__platform_driver_register);
 
 /**
  * platform_driver_unregister - unregister a driver for platform-level devices
@@ -551,7 +554,7 @@ int __init_or_module platform_driver_probe(struct platform_driver *drv,
 
 	/* temporary section violation during probe() */
 	drv->probe = probe;
-	retval = code = platform_driver_register(drv);
+	retval = code = platform_driver_register_sync(drv);
 
 	/*
 	 * Fixup that section violation, being paranoid about code scanning
diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
index 5711e95..f791a59 100644
--- a/include/linux/platform_device.h
+++ b/include/linux/platform_device.h
@@ -175,9 +175,19 @@ struct platform_driver {
 	const struct platform_device_id *id_table;
 };
 
-extern int platform_driver_register(struct platform_driver *);
+extern int __platform_driver_register(struct platform_driver *, int sync);
 extern void platform_driver_unregister(struct platform_driver *);
 
+static inline int platform_driver_register(struct platform_driver *drv)
+{
+	return __platform_driver_register(drv, 0);
+}
+
+static inline int platform_driver_register_sync(struct platform_driver *drv)
+{
+	return __platform_driver_register(drv, 1);
+}
+
 /* non-hotpluggable platform devices may use this so that probe() and
  * its support may live in __init sections, conserving runtime memory.
  */
-- 
1.7.9.5

