Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901Ab1AZEoT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 23:44:19 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47061 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830Ab1AZEoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 23:44:16 -0500
Subject: [RFC PATCH 2/5] drivers/amba: probe via device tree
To: devicetree-discuss@lists.ozlabs.org, jeremy.kerr@canonical.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
From: Grant Likely <grant.likely@secretlab.ca>
Cc: nicolas.pitre@linaro.org
Date: Tue, 25 Jan 2011 21:44:11 -0700
Message-ID: <20110126044411.16410.12.stgit@localhost6.localdomain6>
In-Reply-To: <20110126043338.16410.75019.stgit@localhost6.localdomain6>
References: <20110126043338.16410.75019.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Kerr <jeremy.kerr@canonical.com>

Add functions to parse the AMBA bus through the device tree.

Signed-off-by: Jeremy Kerr <jeremy.kerr@canonical.com>
Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 drivers/amba/bus.c       |   67 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/amba/bus.h |    5 +++
 2 files changed, 72 insertions(+), 0 deletions(-)

diff --git a/drivers/amba/bus.c b/drivers/amba/bus.c
index e7df019..e753fa9 100644
--- a/drivers/amba/bus.c
+++ b/drivers/amba/bus.c
@@ -13,6 +13,10 @@
 #include <linux/string.h>
 #include <linux/slab.h>
 #include <linux/io.h>
+#include <linux/of.h>
+#include <linux/of_irq.h>
+#include <linux/of_address.h>
+#include <linux/of_device.h>
 #include <linux/amba/bus.h>
 
 #include <asm/irq.h>
@@ -486,3 +490,66 @@ EXPORT_SYMBOL(amba_device_unregister);
 EXPORT_SYMBOL(amba_find_device);
 EXPORT_SYMBOL(amba_request_regions);
 EXPORT_SYMBOL(amba_release_regions);
+
+#ifdef CONFIG_OF
+static int of_amba_device_create(struct device_node *node,struct device *parent)
+{
+	struct amba_device *dev;
+	const void *prop;
+	int i, ret;
+
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (!dev)
+		return -ENOMEM;
+
+	/* setup generic device info */
+	dev->dev.coherent_dma_mask = ~0;
+	dev->dev.of_node = node;
+	dev->dev.parent = parent;
+	of_device_make_bus_id(&dev->dev);
+
+	/* setup amba-specific device info */
+	dev->dma_mask = ~0;
+
+	/* Decode the IRQs and address ranges */
+	for (i = 0; i < AMBA_NR_IRQS; i++)
+		dev->irq[i] = irq_of_parse_and_map(node, i);
+
+	ret = of_address_to_resource(node, 0, &dev->res);
+	if (ret)
+		goto err_free;
+
+	ret = amba_device_register(dev, &iomem_resource);
+	if (ret)
+		goto err_free;
+
+	/* Sanity check the arm,amba-deviceid value */
+	prop = of_get_property(node, "arm,amba-deviceid", NULL);
+	if (!prop)
+		dev_warn(&dev->dev, "arm,amba-deviceid property missing; "
+				    "probe gives 0x%08x.\n", dev->periphid);
+
+	if (prop && (dev->periphid != of_read_ulong(prop, 1)))
+		dev_warn(&dev->dev, "arm,amba-deviceid value (0x%08lx) and "
+				    "probed value (0x%08x) don't agree.",
+				    of_read_ulong(prop, 1), dev->periphid);
+
+	return 0;
+
+err_free:
+	kfree(dev);
+	return ret;
+}
+
+void of_amba_bus_populate(struct device_node *node, struct device *parent)
+{
+	struct device_node *child;
+
+	for_each_child_of_node(node, child) {
+		if (of_device_is_compatible(child, "arm,amba-device"))
+			of_amba_device_create(child, parent);
+	}
+}
+EXPORT_SYMBOL(of_amba_bus_populate);
+
+#endif /* CONFIG_OF */
diff --git a/include/linux/amba/bus.h b/include/linux/amba/bus.h
index 9e7f259..4baa4cf 100644
--- a/include/linux/amba/bus.h
+++ b/include/linux/amba/bus.h
@@ -90,4 +90,9 @@ void amba_release_regions(struct amba_device *);
 #define amba_manf(d)	AMBA_MANF_BITS((d)->periphid)
 #define amba_part(d)	AMBA_PART_BITS((d)->periphid)
 
+#ifdef CONFIG_OF
+struct device_node;
+void of_amba_bus_populate(struct device_node *node, struct device *parent);
+#endif
+
 #endif

