Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750879Ab1GHEAz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 00:00:55 -0400
Received: from gate.crashing.org ([63.228.1.57]:37902 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717Ab1GHEAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 00:00:53 -0400
From: Kumar Gala <galak@kernel.crashing.org>
To: Greg KH <greg@kroah.com>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 1/3] driver core: Add ability for arch code to setup pdev_archdata
Date: Thu,  7 Jul 2011 23:00:41 -0500
Message-Id: <1310097643-8414-1-git-send-email-galak@kernel.crashing.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some architectures we need to setup pdev_archdata before we add the
device.  Waiting til a bus_notifier is too late since we might need the
pdev_archdata in the bus notifier.  One example is setting up of dma_mask
pointers such that it can be used in a bus_notifier.

We add weak noop version of arch_setup_pdev_archdata() and allow the arch
code to override with access the full definitions of struct device,
struct platform_device, and struct pdev_archdata.

Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
---
v4:
* Move to use a weak function based on comments from Greg
v3:
* Add more comments and add missing call to arch_setup_pdev_archdata in
  platform_device_register
v2:
* Added license, and comments about arch_setup_pdev_archdata()
  per Mike's comments

 drivers/base/platform.c         |   22 ++++++++++++++++++++++
 include/linux/platform_device.h |    1 +
 2 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 1c291af..060686d 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -32,6 +32,26 @@ struct device platform_bus = {
 EXPORT_SYMBOL_GPL(platform_bus);
 
 /**
+ * arch_setup_pdev_archdata - Allow manipulation of archdata before its used
+ * @dev: platform device
+ *
+ * This is called before platform_device_add() such that any pdev_archdata may
+ * be setup before the platform_notifier is called.  So if a user needs to
+ * manipulate any relevant information in the pdev_archdata they can do:
+ *
+ * 	platform_devic_alloc()
+ * 	... manipulate ...
+ * 	platform_device_add()
+ *
+ * And if they don't care they can just call platform_device_register() and
+ * everything will just work out.
+ */
+void __weak arch_setup_pdev_archdata(struct platform_device *pdev)
+{
+	return ;
+}
+
+/**
  * platform_get_resource - get a resource for a device
  * @dev: platform device
  * @type: resource type
@@ -173,6 +193,7 @@ struct platform_device *platform_device_alloc(const char *name, int id)
 		pa->pdev.id = id;
 		device_initialize(&pa->pdev.dev);
 		pa->pdev.dev.release = platform_device_release;
+		arch_setup_pdev_archdata(&pa->pdev);
 	}
 
 	return pa ? &pa->pdev : NULL;
@@ -334,6 +355,7 @@ EXPORT_SYMBOL_GPL(platform_device_del);
 int platform_device_register(struct platform_device *pdev)
 {
 	device_initialize(&pdev->dev);
+	arch_setup_pdev_archdata(pdev);
 	return platform_device_add(pdev);
 }
 EXPORT_SYMBOL_GPL(platform_device_register);
diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
index ede1a80..27bb05a 100644
--- a/include/linux/platform_device.h
+++ b/include/linux/platform_device.h
@@ -42,6 +42,7 @@ extern void platform_device_unregister(struct platform_device *);
 extern struct bus_type platform_bus_type;
 extern struct device platform_bus;
 
+extern void arch_setup_pdev_archdata(struct platform_device *);
 extern struct resource *platform_get_resource(struct platform_device *, unsigned int, unsigned int);
 extern int platform_get_irq(struct platform_device *, unsigned int);
 extern struct resource *platform_get_resource_byname(struct platform_device *, unsigned int, const char *);
-- 
1.7.3.4

