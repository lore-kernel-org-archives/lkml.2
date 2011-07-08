Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654Ab1GHIya (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 04:54:30 -0400
Received: from service87.mimecast.com ([94.185.240.25]:50075 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754521Ab1GHIyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 04:54:24 -0400
From: Marc Zyngier <marc.zyngier@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>
Subject: [RFC PATCH v2 1/4] dt: expose device resource allocator
Date: Fri,  8 Jul 2011 09:54:07 +0100
Message-Id: <1310115250-3859-2-git-send-email-marc.zyngier@arm.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1310115250-3859-1-git-send-email-marc.zyngier@arm.com>
References: <1310115250-3859-1-git-send-email-marc.zyngier@arm.com>
X-OriginalArrivalTime: 08 Jul 2011 08:54:15.0912 (UTC) FILETIME=[9DADBE80:01CC3D4C]
X-MC-Unique: 111070809542104701
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id p688txNs032463

of_device_alloc() takes care of allocating both a platform
device and its associated resource, as part of the runtime
device-tree to platform_device conversion.

The resource allocation itself is useful on its own, and
would be used by the core driver subsystem.  Create the
of_device_alloc_resources() function, and let of_device_alloc()
use it.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/of/platform.c       |   60 +++++++++++++++++++++++++++++-------------
 include/linux/of_platform.h |    2 +
 2 files changed, 43 insertions(+), 19 deletions(-)

diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index e75af39..f839f79 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -122,22 +122,16 @@ void of_device_make_bus_id(struct device *dev)
 }
 
 /**
- * of_device_alloc - Allocate and initialize an of_device
- * @np: device node to assign to device
- * @bus_id: Name to assign to the device.  May be null to use default name.
- * @parent: Parent device.
+ * of_device_alloc_resources - Allocate and initialize resources for an
+ *			       of_device
+ * @np: device node to fetch resources from
+ * @num_res: number of allocated resources
  */
-struct platform_device *of_device_alloc(struct device_node *np,
-				  const char *bus_id,
-				  struct device *parent)
+struct resource *of_device_alloc_resources(struct device_node *np,
+					   int *num_res)
 {
-	struct platform_device *dev;
 	int rc, i, num_reg = 0, num_irq;
-	struct resource *res, temp_res;
-
-	dev = platform_device_alloc("", -1);
-	if (!dev)
-		return NULL;
+	struct resource *res = NULL, temp_res;
 
 	/* count the io and irq resources */
 	while (of_address_to_resource(np, num_reg, &temp_res) == 0)
@@ -148,19 +142,47 @@ struct platform_device *of_device_alloc(struct device_node *np,
 	if (num_irq || num_reg) {
 		res = kzalloc(sizeof(*res) * (num_irq + num_reg), GFP_KERNEL);
 		if (!res) {
-			platform_device_put(dev);
+			*num_res = -1;
 			return NULL;
 		}
 
-		dev->num_resources = num_reg + num_irq;
-		dev->resource = res;
-		for (i = 0; i < num_reg; i++, res++) {
-			rc = of_address_to_resource(np, i, res);
+		for (i = 0; i < num_reg; i++) {
+			rc = of_address_to_resource(np, i, &res[i]);
 			WARN_ON(rc);
 		}
-		WARN_ON(of_irq_to_resource_table(np, res, num_irq) != num_irq);
+		WARN_ON(of_irq_to_resource_table(np, &res[i], num_irq) != num_irq);
+	}
+
+	*num_res = num_irq + num_reg;
+	return res;
+}
+
+/**
+ * of_device_alloc - Allocate and initialize an of_device
+ * @np: device node to assign to device
+ * @bus_id: Name to assign to the device.  May be null to use default name.
+ * @parent: Parent device.
+ */
+struct platform_device *of_device_alloc(struct device_node *np,
+				  const char *bus_id,
+				  struct device *parent)
+{
+	struct platform_device *dev;
+	int num_res;
+	struct resource *res;
+
+	dev = platform_device_alloc("", -1);
+	if (!dev)
+		return NULL;
+
+	res = of_device_alloc_resources(np, &num_res);
+	if (num_res == -1) {
+		platform_device_put(dev);
+		return NULL;
 	}
 
+	dev->num_resources = num_res;
+	dev->resource = res;
 	dev->dev.of_node = of_node_get(np);
 #if defined(CONFIG_PPC) || defined(CONFIG_MICROBLAZE)
 	dev->dev.dma_mask = &dev->archdata.dma_mask;
diff --git a/include/linux/of_platform.h b/include/linux/of_platform.h
index 5a6f458..773a880 100644
--- a/include/linux/of_platform.h
+++ b/include/linux/of_platform.h
@@ -77,6 +77,8 @@ struct of_platform_driver
 extern const struct of_device_id of_default_bus_match_table[];
 
 /* Platform drivers register/unregister */
+extern struct resource *of_device_alloc_resources(struct device_node *np,
+						  int *num_res);
 extern struct platform_device *of_device_alloc(struct device_node *np,
 					 const char *bus_id,
 					 struct device *parent);
-- 
1.7.0.4


