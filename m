Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934256Ab0HEWem (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:34:42 -0400
Received: from kroah.org ([198.145.64.141]:37742 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933208Ab0HEWYh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:24:37 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 10/28] Driver core: reduce duplicated code for platform_device creation
Date: Thu,  5 Aug 2010 15:24:00 -0700
Message-Id: <1281047058-23716-10-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <20100805213314.GB13744@kroah.com>
References: <20100805213314.GB13744@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

This makes the two similar functions platform_device_register_simple
and platform_device_register_data one line inline functions using a new
generic function platform_device_register_resndata.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/DocBook/device-drivers.tmpl |    1 +
 drivers/base/platform.c                   |  104 +++++++---------------------
 include/linux/platform_device.h           |   62 ++++++++++++++++-
 3 files changed, 85 insertions(+), 82 deletions(-)

diff --git a/Documentation/DocBook/device-drivers.tmpl b/Documentation/DocBook/device-drivers.tmpl
index 1b2dd4f..ecd35e9 100644
--- a/Documentation/DocBook/device-drivers.tmpl
+++ b/Documentation/DocBook/device-drivers.tmpl
@@ -111,6 +111,7 @@ X!Edrivers/base/attribute_container.c
 <!--
 X!Edrivers/base/interface.c
 -->
+!Iinclude/linux/platform_device.h
 !Edrivers/base/platform.c
 !Edrivers/base/bus.c
      </sect1>
diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 26eb69d..ffcfd73 100644
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
 
-	if (size) {
-		retval = platform_device_add_data(pdev, data, size);
-		if (retval)
-			goto error;
+	if (res) {
+		ret = platform_device_add_resources(pdev, res, num);
+		if (ret)
+			goto err;
 	}
 
-	retval = platform_device_add(pdev);
-	if (retval)
-		goto error;
+	if (data) {
+		ret = platform_device_add_data(pdev, data, size);
+		if (ret)
+			goto err;
+	}
 
-	return pdev;
+	ret = platform_device_add(pdev);
+	if (ret) {
+err:
+		platform_device_put(pdev);
+		return ERR_PTR(ret);
+	}
 
-error:
-	platform_device_put(pdev);
-	return ERR_PTR(retval);
+	return pdev;
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
1.7.2

