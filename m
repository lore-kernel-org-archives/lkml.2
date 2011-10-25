Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593Ab1JYNRD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 09:17:03 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39161 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756361Ab1JYNRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 09:17:00 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Wolfram Sang <w.sang@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>, Tejun Heo <tj@kernel.org>,
        Greg KH <gregkh@suse.de>
Subject: [PATCH] lib: devres: add convenience function to remap a resource
Date: Tue, 25 Oct 2011 15:16:47 +0200
Message-Id: <1319548607-28427-1-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.6.3
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Almost every platform_driver does the three steps get_resource,
request_mem_region, ioremap. This does not only lead to a lot of code
duplication, but also a huge number of similar error strings and
inconsistent error codes on failure. So, introduce a helper function
which simplifies remapping a resource and make it hard to do something
wrong and add documentation for it.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Tejun Heo <tj@kernel.org>
Cc: Greg KH <gregkh@suse.de>
---

Changes since RFC:

* change the return type of the function. Now the pointer is returned
  (or NULL) instead of errno.

* rename the function to 'devm_request_and_ioremap'

* release mem_region when ioremap fails

* update the documentation

Based on 3.1. Tested on a custom ARM-board with the watchdog driver.

 Documentation/driver-model/devres.txt |    1 +
 include/linux/device.h                |    3 ++
 lib/devres.c                          |   51 +++++++++++++++++++++++++++++++++
 3 files changed, 55 insertions(+), 0 deletions(-)

diff --git a/Documentation/driver-model/devres.txt b/Documentation/driver-model/devres.txt
index badd964..41c0c5d 100644
--- a/Documentation/driver-model/devres.txt
+++ b/Documentation/driver-model/devres.txt
@@ -266,6 +266,7 @@ IOMAP
   devm_ioremap()
   devm_ioremap_nocache()
   devm_iounmap()
+  devm_request_and_ioremap() : checks resource, requests region, ioremaps
   pcim_iomap()
   pcim_iounmap()
   pcim_iomap_table()	: array of mapped addresses indexed by BAR
diff --git a/include/linux/device.h b/include/linux/device.h
index c20dfbf..7edc6b0 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -481,6 +481,9 @@ extern int devres_release_group(struct device *dev, void *id);
 extern void *devm_kzalloc(struct device *dev, size_t size, gfp_t gfp);
 extern void devm_kfree(struct device *dev, void *p);
 
+void __iomem *devm_request_and_ioremap(struct device *dev,
+			struct resource *res);
+
 struct device_dma_parameters {
 	/*
 	 * a low level driver may set these to teach IOMMU code about
diff --git a/lib/devres.c b/lib/devres.c
index 78777ae..4fbc09e 100644
--- a/lib/devres.c
+++ b/lib/devres.c
@@ -85,6 +85,57 @@ void devm_iounmap(struct device *dev, void __iomem *addr)
 }
 EXPORT_SYMBOL(devm_iounmap);
 
+/**
+ * devm_request_and_ioremap() - Check, request region, and ioremap resource
+ * @dev: Generic device to handle the resource for
+ * @res: resource to be handled
+ *
+ * Takes all necessary steps to ioremap a mem resource. Uses managed device, so
+ * everything is undone on driver detach. Checks arguments, so you can feed
+ * it the result from e.g. platform_get_resource() directly. Returns the
+ * remapped pointer or NULL on error. Usage example:
+ *
+ *	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+ *	base = devm_request_and_ioremap(&pdev->dev, res);
+ *	if (!base)
+ *		return -EADDRNOTAVAIL;
+ */
+void __iomem *devm_request_and_ioremap(struct device *dev,
+			struct resource *res)
+{
+	resource_size_t size;
+	const char *name;
+	void __iomem *dest_ptr;
+
+	BUG_ON(!dev);
+
+	if (!res || resource_type(res) != IORESOURCE_MEM) {
+		dev_err(dev, "invalid resource\n");
+		return NULL;
+	}
+
+	size = resource_size(res);
+	name = res->name ?: dev_name(dev);
+
+	if (!devm_request_mem_region(dev, res->start, size, name)) {
+		dev_err(dev, "can't request region for resource %pR\n", res);
+		return NULL;
+	}
+
+	if (res->flags & IORESOURCE_CACHEABLE)
+		dest_ptr = devm_ioremap(dev, res->start, size);
+	else
+		dest_ptr = devm_ioremap_nocache(dev, res->start, size);
+
+	if (!dest_ptr) {
+		dev_err(dev, "ioremap failed for resource %pR\n", res);
+		devm_release_mem_region(dev, res->start, size);
+	}
+
+	return dest_ptr;
+}
+EXPORT_SYMBOL(devm_request_and_ioremap);
+
 #ifdef CONFIG_HAS_IOPORT
 /*
  * Generic iomap devres
-- 
1.7.6.3

