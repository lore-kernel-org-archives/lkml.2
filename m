Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757351Ab1FUSpK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 14:45:10 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42562 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756768Ab1FUSpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 14:45:06 -0400
Subject: [PATCH 3/5] drivers/amba: create devices from device tree
To: Nicolas Pitre <nicolas.pitre@linaro.org>,
        devicetree-discuss@lists.ozlabs.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
From: Grant Likely <grant.likely@secretlab.ca>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>
Date: Tue, 21 Jun 2011 12:45:03 -0600
Message-ID: <20110621184503.18176.88260.stgit@ponder>
In-Reply-To: <20110621181127.18176.1384.stgit@ponder>
References: <20110621181127.18176.1384.stgit@ponder>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a function to create amba_devices (i.e. primecell peripherals)
from device tree nodes. The device tree scanning is done by the
of_platform_populate() function which can call of_amba_device_create
based on a match table entry.

Nodes with a "arm,primecell-periphid" property can override the h/w
peripheral id value.

Based on the original work by Jeremy Kerr.

Signed-off-by: Jeremy Kerr <jeremy.kerr@canonical.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
[grant.likely: add Jeremy's original s-o-b line, changes from review
               comments, and moved all code to drivers/of/platform.c]
Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 .../devicetree/bindings/arm/primecell.txt          |   21 ++++++
 drivers/of/platform.c                              |   71 ++++++++++++++++++++
 2 files changed, 92 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/primecell.txt

diff --git a/Documentation/devicetree/bindings/arm/primecell.txt b/Documentation/devicetree/bindings/arm/primecell.txt
new file mode 100644
index 0000000..1d5d7a8
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/primecell.txt
@@ -0,0 +1,21 @@
+* ARM Primecell Peripherals
+
+ARM, Ltd. Primecell peripherals have a standard id register that can be used to
+identify the peripheral type, vendor, and revision. This value can be used for
+driver matching.
+
+Required properties:
+
+- compatible : should be a specific value for peripheral and "arm,primecell"
+
+Optional properties:
+
+- arm,primecell-periphid : Value to override the h/w value with
+
+Example:
+
+serial@fff36000 {
+	compatible = "arm,pl011", "arm,primecell";
+	arm,primecell-periphid = <0x00341011>;
+};
+
diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index 1f4a5d3..4192ddc 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -13,6 +13,7 @@
  */
 #include <linux/errno.h>
 #include <linux/module.h>
+#include <linux/amba/bus.h>
 #include <linux/device.h>
 #include <linux/dma-mapping.h>
 #include <linux/slab.h>
@@ -217,6 +218,71 @@ struct platform_device *of_platform_device_create(struct device_node *np,
 }
 EXPORT_SYMBOL(of_platform_device_create);
 
+#ifdef CONFIG_ARM_AMBA
+static struct amba_device *of_amba_device_create(struct device_node *node,
+						 const char *bus_id,
+						 void *platform_data,
+						 struct device *parent)
+{
+	struct amba_device *dev;
+	const void *prop;
+	int i, ret;
+
+	pr_debug("Creating amba device %s\n", node->full_name);
+
+	if (!of_device_is_available(node))
+		return NULL;
+
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (!dev)
+		return NULL;
+
+	/* setup generic device info */
+	dev->dev.coherent_dma_mask = ~0;
+	dev->dev.of_node = of_node_get(node);
+	dev->dev.parent = parent;
+	dev->dev.platform_data = platform_data;
+	if (bus_id)
+		dev_set_name(&dev->dev, "%s", bus_id);
+	else
+		of_device_make_bus_id(&dev->dev);
+
+	/* setup amba-specific device info */
+	dev->dma_mask = ~0;
+
+	/* Allow the HW Peripheral ID to be overridden */
+	prop = of_get_property(node, "arm,primecell-periphid", NULL);
+	if (prop)
+		dev->periphid = of_read_ulong(prop, 1);
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
+	return dev;
+
+err_free:
+	kfree(dev);
+	return NULL;
+}
+#else /* CONFIG_ARM_AMBA */
+static struct amba_device *of_amba_device_create(struct device_node *node,
+						 const char *bus_id,
+						 void *platform_data,
+						 struct device *parent)
+{
+	return NULL;
+}
+#endif /* CONFIG_ARM_AMBA */
+
 /**
  * of_platform_bus_create() - Create a device for a node and its children.
  * @bus: device node of the bus to instantiate
@@ -242,6 +308,11 @@ static int of_platform_bus_create(struct device_node *bus,
 		return 0;
 	}
 
+	if (of_device_is_compatible(bus, "arm,primecell")) {
+		of_amba_device_create(bus, NULL, NULL, parent);
+		return 0;
+	}
+
 	dev = of_platform_device_create(bus, NULL, parent);
 	if (!dev || !of_match_node(matches, bus))
 		return 0;

