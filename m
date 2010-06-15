Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796Ab0FOItH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 04:49:07 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40239 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160Ab0FOItD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 04:49:03 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Magnus Damm <damm@opensource.se>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Paul Mundt <lethal@linux-sh.org>,
       Dmitry Torokhov <dtor@mail.ru>,
       =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Eric Miao <eric.y.miao@gmail.com>, netdev@vger.kernel.org
Subject: [PATCH 2/2] Driver core: reduce duplicated code
Date: Tue, 15 Jun 2010 10:47:56 +0200
Message-Id: <1276591677-4678-2-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1276591677-4678-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1276591677-4678-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes the two similar functions platform_device_register_simple
and platform_device_register_data one line inline functions using a new
generic function platform_device_register_resndata.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/base/platform.c         |  102 ++++++++++-----------------------------
 include/linux/platform_device.h |   62 ++++++++++++++++++++++--
 2 files changed, 83 insertions(+), 81 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 26eb69d..23a5853 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -344,108 +344,56 @@ void platform_device_unregister(struct platform_device *pdev)
 EXPORT_SYMBOL_GPL(platform_device_unregister);
 
 /**
- * platform_device_register_simple - add a platform-level device and its resources
- * @name: base name of the device we're adding
- * @id: instance id
- * @res: set of resources that needs to be allocated for the device
- * @num: number of resources
- *
- * This function creates a simple platform device that requires minimal
- * resource and memory management. Canned release function freeing memory
- * allocated for the device allows drivers using such devices to be
- * unloaded without waiting for the last reference to the device to be
- * dropped.
+ * platform_device_register_resndata - add a platform-level device with
+ * resources and platform-specific data
  *
- * This interface is primarily intended for use with legacy drivers which
- * probe hardware directly.  Because such drivers create sysfs device nodes
- * themselves, rather than letting system infrastructure handle such device
- * enumeration tasks, they don't fully conform to the Linux driver model.
- * In particular, when such drivers are built as modules, they can't be
- * "hotplugged".
- *
- * Returns &struct platform_device pointer on success, or ERR_PTR() on error.
- */
-struct platform_device *platform_device_register_simple(const char *name,
-							int id,
-							const struct resource *res,
-							unsigned int num)
-{
-	struct platform_device *pdev;
-	int retval;
-
-	pdev = platform_device_alloc(name, id);
-	if (!pdev) {
-		retval = -ENOMEM;
-		goto error;
-	}
-
-	if (num) {
-		retval = platform_device_add_resources(pdev, res, num);
-		if (retval)
-			goto error;
-	}
-
-	retval = platform_device_add(pdev);
-	if (retval)
-		goto error;
-
-	return pdev;
-
-error:
-	platform_device_put(pdev);
-	return ERR_PTR(retval);
-}
-EXPORT_SYMBOL_GPL(platform_device_register_simple);
-
-/**
- * platform_device_register_data - add a platform-level device with platform-specific data
  * @parent: parent device for the device we're adding
  * @name: base name of the device we're adding
  * @id: instance id
+ * @res: set of resources that needs to be allocated for the device
+ * @num: number of resources
  * @data: platform specific data for this platform device
  * @size: size of platform specific data
  *
- * This function creates a simple platform device that requires minimal
- * resource and memory management. Canned release function freeing memory
- * allocated for the device allows drivers using such devices to be
- * unloaded without waiting for the last reference to the device to be
- * dropped.
- *
  * Returns &struct platform_device pointer on success, or ERR_PTR() on error.
  */
-struct platform_device *platform_device_register_data(
+struct platform_device *platform_device_register_resndata(
 		struct device *parent,
 		const char *name, int id,
+		const struct resource *res, unsigned int num,
 		const void *data, size_t size)
 {
+	int ret = -ENOMEM;
 	struct platform_device *pdev;
-	int retval;
 
 	pdev = platform_device_alloc(name, id);
-	if (!pdev) {
-		retval = -ENOMEM;
-		goto error;
-	}
+	if (!pdev)
+		goto err;
 
 	pdev->dev.parent = parent;
 
+	if (num) {
+		ret = platform_device_add_resources(pdev, res, num);
+		if (ret)
+			goto err;
+	}
+
 	if (size) {
-		retval = platform_device_add_data(pdev, data, size);
-		if (retval)
-			goto error;
+		ret = platform_device_add_data(pdev, data, size);
+		if (ret)
+			goto err;
 	}
 
-	retval = platform_device_add(pdev);
-	if (retval)
-		goto error;
+	ret = platform_device_add(pdev);
+	if (ret) {
+err:
+		platform_device_put(pdev);
+		return ERR_PTR(ret);
+	}
 
 	return pdev;
-
-error:
-	platform_device_put(pdev);
-	return ERR_PTR(retval);
 }
-EXPORT_SYMBOL_GPL(platform_device_register_data);
+EXPORT_SYMBOL_GPL(platform_device_register_resndata);
 
 static int platform_drv_probe(struct device *_dev)
 {
diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
index 5417944..d7ecad0 100644
--- a/include/linux/platform_device.h
+++ b/include/linux/platform_device.h
@@ -43,10 +43,64 @@ extern struct resource *platform_get_resource_byname(struct platform_device *, u
 extern int platform_get_irq_byname(struct platform_device *, const char *);
 extern int platform_add_devices(struct platform_device **, int);
 
-extern struct platform_device *platform_device_register_simple(const char *, int id,
-					const struct resource *, unsigned int);
-extern struct platform_device *platform_device_register_data(struct device *,
-		const char *, int, const void *, size_t);
+extern struct platform_device *platform_device_register_resndata(
+		struct device *parent, const char *name, int id,
+		const struct resource *res, unsigned int num,
+		const void *data, size_t size);
+
+/**
+ * platform_device_register_simple - add a platform-level device and its resources
+ * @name: base name of the device we're adding
+ * @id: instance id
+ * @res: set of resources that needs to be allocated for the device
+ * @num: number of resources
+ *
+ * This function creates a simple platform device that requires minimal
+ * resource and memory management. Canned release function freeing memory
+ * allocated for the device allows drivers using such devices to be
+ * unloaded without waiting for the last reference to the device to be
+ * dropped.
+ *
+ * This interface is primarily intended for use with legacy drivers which
+ * probe hardware directly.  Because such drivers create sysfs device nodes
+ * themselves, rather than letting system infrastructure handle such device
+ * enumeration tasks, they don't fully conform to the Linux driver model.
+ * In particular, when such drivers are built as modules, they can't be
+ * "hotplugged".
+ *
+ * Returns &struct platform_device pointer on success, or ERR_PTR() on error.
+ */
+static inline struct platform_device *platform_device_register_simple(
+		const char *name, int id,
+		const struct resource *res, unsigned int num)
+{
+	return platform_device_register_resndata(NULL, name, id,
+			res, num, NULL, 0);
+}
+
+/**
+ * platform_device_register_data - add a platform-level device with platform-specific data
+ * @parent: parent device for the device we're adding
+ * @name: base name of the device we're adding
+ * @id: instance id
+ * @data: platform specific data for this platform device
+ * @size: size of platform specific data
+ *
+ * This function creates a simple platform device that requires minimal
+ * resource and memory management. Canned release function freeing memory
+ * allocated for the device allows drivers using such devices to be
+ * unloaded without waiting for the last reference to the device to be
+ * dropped.
+ *
+ * Returns &struct platform_device pointer on success, or ERR_PTR() on error.
+ */
+static inline struct platform_device *platform_device_register_data(
+		struct device *parent, const char *name, int id,
+		const void *data, size_t size)
+{
+	return platform_device_register_resndata(parent, name, id,
+			NULL, 0, data, size);
+}
 
 extern struct platform_device *platform_device_alloc(const char *name, int id);
 extern int platform_device_add_resources(struct platform_device *pdev,
-- 
1.7.1

