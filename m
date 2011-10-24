Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941Ab1JXImX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 04:42:23 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57398 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753751Ab1JXImU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 04:42:20 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Greg KH <gregkh@suse.de>,
        Grant Likely <grant.likely@secretlab.ca>, Tejun Heo <tj@kernel.org>,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: [RFC 3/4] lib: devres: add convenience function to remap a resource
Date: Mon, 24 Oct 2011 10:42:08 +0200
Message-Id: <1319445729-14841-4-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.6.3
In-Reply-To: <1319445729-14841-1-git-send-email-w.sang@pengutronix.de>
References: <1319445729-14841-1-git-send-email-w.sang@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Almost every platform_driver does the three steps get_resource,
request_mem_region, ioremap. This does not only lead to a lot of code
duplication, but also a number of similar error strings and inconsistent
error codes on failure. So, introduce a helper function which simplifies
remapping a resource and make it hard to do something wrong.

A few notes on design choices:

* not 100% sure on ENOENT when the resource is invalid. Seems to be frequently
  used currently and fits "somehow"

* the remapped pointer is a function argument and not a return value. This is to
  save users from forgetting to use IS_ERR/PTR_ERR.

* the usage of IORESOURCE_CACHEABLE enforces calling the correct ioremap-variant.
  A number of drivers miss to call the _nocache-version, although they should do.

* the new function is not named 'devm_ioremap_resource' because it does more than
  just ioremap, namely request_mem_region. I didn't want to create implicit
  knowledge here.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
---
 Documentation/driver-model/devres.txt |    1 +
 include/linux/device.h                |    3 ++
 lib/devres.c                          |   52 +++++++++++++++++++++++++++++++++
 3 files changed, 56 insertions(+), 0 deletions(-)

diff --git a/Documentation/driver-model/devres.txt b/Documentation/driver-model/devres.txt
index badd964..3aeb4f4 100644
--- a/Documentation/driver-model/devres.txt
+++ b/Documentation/driver-model/devres.txt
@@ -266,6 +266,7 @@ IOMAP
   devm_ioremap()
   devm_ioremap_nocache()
   devm_iounmap()
+  devm_resource_to_mapped_ptr() : checks resource, requests region, ioremaps
   pcim_iomap()
   pcim_iounmap()
   pcim_iomap_table()	: array of mapped addresses indexed by BAR
diff --git a/include/linux/device.h b/include/linux/device.h
index c20dfbf..82a621c 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -481,6 +481,9 @@ extern int devres_release_group(struct device *dev, void *id);
 extern void *devm_kzalloc(struct device *dev, size_t size, gfp_t gfp);
 extern void devm_kfree(struct device *dev, void *p);
 
+int __must_check devm_resource_to_mapped_ptr(struct device *dev,
+			struct resource *res, void __iomem **dest);
+
 struct device_dma_parameters {
 	/*
 	 * a low level driver may set these to teach IOMMU code about
diff --git a/lib/devres.c b/lib/devres.c
index 78777ae..970588b 100644
--- a/lib/devres.c
+++ b/lib/devres.c
@@ -85,6 +85,58 @@ void devm_iounmap(struct device *dev, void __iomem *addr)
 }
 EXPORT_SYMBOL(devm_iounmap);
 
+/**
+ * devm_resource_to_mapped_ptr - Check, request region, and ioremap resource
+ * @dev: Generic device to handle the resource for
+ * @res: resource to be handled
+ * @dest: Pointer to pointer which carries the remapped address
+ *
+ * Takes all necessary steps to ioremap a mem resource. Uses managed device, so
+ * everything is undone on driver detach. Checks arguments, so you can feed
+ * it the result from e.g. platform_get_resource() directly:
+ *
+ *	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+ *	err = devm_resource_to_mapped_ptr(&pdev->dev, res, &priv->regs);
+ *	if (err)
+ *		return err;
+ */
+int __must_check devm_resource_to_mapped_ptr(struct device *dev,
+			struct resource *res, void __iomem **dest)
+{
+	resource_size_t size;
+	const char *name;
+
+	BUG_ON(!dev || !dest);
+
+	*dest = NULL;
+
+	if (!res || resource_type(res) != IORESOURCE_MEM) {
+		dev_err(dev, "invalid resource\n");
+		return -ENOENT;
+	}
+
+	size = resource_size(res);
+	name = res->name ?: dev_name(dev);
+
+	if (!devm_request_mem_region(dev, res->start, size, name)) {
+		dev_err(dev, "can't request region for resource %pR\n", res);
+		return -EBUSY;
+	}
+
+	if (res->flags & IORESOURCE_CACHEABLE)
+		*dest = devm_ioremap(dev, res->start, size);
+	else
+		*dest = devm_ioremap_nocache(dev, res->start, size);
+
+	if (!*dest) {
+		dev_err(dev, "ioremap failed for resource %pR\n", res);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(devm_resource_to_mapped_ptr);
+
 #ifdef CONFIG_HAS_IOPORT
 /*
  * Generic iomap devres
-- 
1.7.6.3

