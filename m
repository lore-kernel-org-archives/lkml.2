Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715Ab1HYJQP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 05:16:15 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46825 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691Ab1HYJQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 05:16:13 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-arm-kernel@lists.infradead.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
Date: Thu, 25 Aug 2011 11:16:00 +0200
Message-Id: <1314263761-20213-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ukl@pengutronix.de
Subject: [PATCH 1/2] new helper to create platform devices with dma mask
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on metis.ext.pengutronix.de)
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

compared to the most powerful and already existing helper (namely
platform_device_register_resndata) this allows to specify a dma_mask.
To make eventual extensions later more easy, a struct holding the used
information is created instead of passing the information by function
parameters.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
Hello,

as this changes how the parameters are passed, this patch has an impact
on code size for the calling sites. On ARCH=arm/mx27_defconfig it
results in bloat-o-meter reporting:

	add/remove: 3/3 grow/shrink: 4/0 up/down: 354/-170 (184)
	function                                     old     new   delta
	platform_device_register_full                  -     216    +216
	imx_add_imx_dma                               56      88     +32
	__kstrtab_platform_device_register_full        -      30     +30
	imx_add_imx_sdma                             132     160     +28
	alarmtimer_init                              312     336     +24
	mxc_register_gpio                            156     172     +16
	__ksymtab_platform_device_register_full        -       8      +8
	__ksymtab_platform_device_register_resndata       8       -      -8
	__kstrtab_platform_device_register_resndata      34       -     -34
	platform_device_register_resndata            128       -    -128

So calling the already existing functions is a bit more expensive.
With the second patch applied the maximal increase for a call site is
+36.

Still I think using the struct is better than a function with 8
parameters.

Best regards
Uwe

 drivers/base/platform.c         |   52 ++++++++++++++++++++++++---------------
 include/linux/platform_device.h |   48 ++++++++++++++++++++++++++++++++++-
 2 files changed, 78 insertions(+), 22 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 0cad9c7..691a1a0 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -375,52 +375,64 @@ void platform_device_unregister(struct platform_device *pdev)
 EXPORT_SYMBOL_GPL(platform_device_unregister);
 
 /**
- * platform_device_register_resndata - add a platform-level device with
+ * platform_device_register_full - add a platform-level device with
  * resources and platform-specific data
  *
- * @parent: parent device for the device we're adding
- * @name: base name of the device we're adding
- * @id: instance id
- * @res: set of resources that needs to be allocated for the device
- * @num: number of resources
- * @data: platform specific data for this platform device
- * @size: size of platform specific data
+ * @pdevinfo: data used to create device
  *
  * Returns &struct platform_device pointer on success, or ERR_PTR() on error.
  */
-struct platform_device *platform_device_register_resndata(
-		struct device *parent,
-		const char *name, int id,
-		const struct resource *res, unsigned int num,
-		const void *data, size_t size)
+struct platform_device *platform_device_register_full(
+		struct platform_device_info *pdevinfo)
 {
 	int ret = -ENOMEM;
 	struct platform_device *pdev;
 
-	pdev = platform_device_alloc(name, id);
+	pdev = platform_device_alloc(pdevinfo->name, pdevinfo->id);
 	if (!pdev)
-		goto err;
-
-	pdev->dev.parent = parent;
+		goto err_alloc;
+
+	pdev->dev.parent = pdevinfo->parent;
+
+	if (pdevinfo->dma_mask) {
+		/*
+		 * This memory isn't freed when the device is put,
+		 * I don't have a nice idea for that though.  Conceptually
+		 * dma_mask in struct device should not be a pointer.
+		 * See http://thread.gmane.org/gmane.linux.kernel.pci/9081
+		 */
+		pdev->dev.dma_mask =
+			kmalloc(sizeof(*pdev->dev.dma_mask), GFP_KERNEL);
+		if (!pdev->dev.dma_mask)
+			goto err;
+
+		*pdev->dev.dma_mask = pdevinfo->dma_mask;
+		pdev->dev.coherent_dma_mask = pdevinfo->dma_mask;
+	}
 
-	ret = platform_device_add_resources(pdev, res, num);
+	ret = platform_device_add_resources(pdev,
+			pdevinfo->res, pdevinfo->num_res);
 	if (ret)
 		goto err;
 
-	ret = platform_device_add_data(pdev, data, size);
+	ret = platform_device_add_data(pdev,
+			pdevinfo->data, pdevinfo->size_data);
 	if (ret)
 		goto err;
 
 	ret = platform_device_add(pdev);
 	if (ret) {
 err:
+		kfree(pdev->dev.dma_mask);
+
+err_alloc:
 		platform_device_put(pdev);
 		return ERR_PTR(ret);
 	}
 
 	return pdev;
 }
-EXPORT_SYMBOL_GPL(platform_device_register_resndata);
+EXPORT_SYMBOL_GPL(platform_device_register_full);
 
 static int platform_drv_probe(struct device *_dev)
 {
diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
index 27bb05a..651a066 100644
--- a/include/linux/platform_device.h
+++ b/include/linux/platform_device.h
@@ -49,10 +49,54 @@ extern struct resource *platform_get_resource_byname(struct platform_device *, u
 extern int platform_get_irq_byname(struct platform_device *, const char *);
 extern int platform_add_devices(struct platform_device **, int);
 
-extern struct platform_device *platform_device_register_resndata(
+struct platform_device_info {
+		struct device *parent;
+
+		const char *name;
+		int id;
+
+		const struct resource *res;
+		unsigned int num_res;
+
+		const void *data;
+		size_t size_data;
+		u64 dma_mask;
+};
+extern struct platform_device *platform_device_register_full(
+		struct platform_device_info *pdevinfo);
+
+/**
+ * platform_device_register_resndata - add a platform-level device with
+ * resources and platform-specific data
+ *
+ * @parent: parent device for the device we're adding
+ * @name: base name of the device we're adding
+ * @id: instance id
+ * @res: set of resources that needs to be allocated for the device
+ * @num: number of resources
+ * @data: platform specific data for this platform device
+ * @size: size of platform specific data
+ *
+ * Returns &struct platform_device pointer on success, or ERR_PTR() on error.
+ */
+static inline struct platform_device *platform_device_register_resndata(
 		struct device *parent, const char *name, int id,
 		const struct resource *res, unsigned int num,
-		const void *data, size_t size);
+		const void *data, size_t size) {
+
+	struct platform_device_info pdevinfo = {
+		.parent = parent,
+		.name = name,
+		.id = id,
+		.res = res,
+		.num_res = num,
+		.data = data,
+		.size_data = size,
+		.dma_mask = 0,
+	};
+
+	return platform_device_register_full(&pdevinfo);
+}
 
 /**
  * platform_device_register_simple - add a platform-level device and its resources
-- 
1.7.5.4

