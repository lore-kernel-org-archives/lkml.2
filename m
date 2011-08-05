Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589Ab1HEVYt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 17:24:49 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:34852 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755651Ab1HEVYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 17:24:38 -0400
From: Rob Herring <robherring2@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>
Subject: [PATCH 2/3] i2c: move OF i2c related functions into i2c core
Date: Fri,  5 Aug 2011 16:24:27 -0500
Message-Id: <1312579468-19365-3-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1312579468-19365-1-git-send-email-robherring2@gmail.com>
References: <1312579468-19365-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

This simplifies i2c drivers by removing calls to of_i2c_register_devices
and resolves a module circular dependency between i2c-core and of_i2c.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: linux-i2c@vger.kernel.org
---
 arch/powerpc/platforms/44x/warp.c |    1 -
 drivers/i2c/i2c-core.c            |   85 +++++++++++++++++++++++++++++++-
 drivers/of/Makefile               |    1 -
 drivers/of/of_i2c.c               |   97 -------------------------------------
 include/linux/i2c.h               |    4 ++
 include/linux/of_i2c.h            |   30 -----------
 6 files changed, 87 insertions(+), 131 deletions(-)
 delete mode 100644 drivers/of/of_i2c.c
 delete mode 100644 include/linux/of_i2c.h

diff --git a/arch/powerpc/platforms/44x/warp.c b/arch/powerpc/platforms/44x/warp.c
index 8f77139..9327ccf 100644
--- a/arch/powerpc/platforms/44x/warp.c
+++ b/arch/powerpc/platforms/44x/warp.c
@@ -16,7 +16,6 @@
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/of_gpio.h>
-#include <linux/of_i2c.h>
 #include <linux/slab.h>
 
 #include <asm/machdep.h>
diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index 011e195..478c7f2 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -22,7 +22,10 @@
    SMBus 2.0 support by Mark Studebaker <mdsxyz123@yahoo.com> and
    Jean Delvare <khali@linux-fr.org>
    Mux support by Rodolfo Giometti <giometti@enneenne.com> and
-   Michael Lawnick <michael.lawnick.ext@nsn.com> */
+   Michael Lawnick <michael.lawnick.ext@nsn.com>
+   OF support by Jochen Friedrich <jochen@scram.de> and
+   Jon Smirl <jonsmirl@gmail.com>
+   */
 
 #include <linux/module.h>
 #include <linux/kernel.h>
@@ -32,7 +35,6 @@
 #include <linux/init.h>
 #include <linux/idr.h>
 #include <linux/mutex.h>
-#include <linux/of_i2c.h>
 #include <linux/of_device.h>
 #include <linux/completion.h>
 #include <linux/hardirq.h>
@@ -790,6 +792,85 @@ static void i2c_scan_static_board_info(struct i2c_adapter *adapter)
 	up_read(&__i2c_board_lock);
 }
 
+#ifdef CONFIG_OF_I2C
+static void of_i2c_register_devices(struct i2c_adapter *adap)
+{
+	void *result;
+	struct device_node *node;
+
+	/* Only register child devices if the adapter has a node pointer set */
+	if (!adap->dev.of_node)
+		return;
+
+	dev_dbg(&adap->dev, "of_i2c: walking child nodes\n");
+
+	for_each_child_of_node(adap->dev.of_node, node) {
+		struct i2c_board_info info = {};
+		struct dev_archdata dev_ad = {};
+		const __be32 *addr;
+		int len;
+
+		dev_dbg(&adap->dev, "of_i2c: register %s\n", node->full_name);
+
+		if (of_modalias_node(node, info.type, sizeof(info.type)) < 0) {
+			dev_err(&adap->dev, "of_i2c: modalias failure on %s\n",
+				node->full_name);
+			continue;
+		}
+
+		addr = of_get_property(node, "reg", &len);
+		if (!addr || (len < sizeof(int))) {
+			dev_err(&adap->dev, "of_i2c: invalid reg on %s\n",
+				node->full_name);
+			continue;
+		}
+
+		info.addr = be32_to_cpup(addr);
+		if (info.addr > (1 << 10) - 1) {
+			dev_err(&adap->dev, "of_i2c: invalid addr=%x on %s\n",
+				info.addr, node->full_name);
+			continue;
+		}
+
+		info.irq = irq_of_parse_and_map(node, 0);
+		info.of_node = of_node_get(node);
+		info.archdata = &dev_ad;
+
+		request_module("%s%s", I2C_MODULE_PREFIX, info.type);
+
+		result = i2c_new_device(adap, &info);
+		if (result == NULL) {
+			dev_err(&adap->dev, "of_i2c: Failure registering %s\n",
+			        node->full_name);
+			of_node_put(node);
+			irq_dispose_mapping(info.irq);
+			continue;
+		}
+	}
+}
+
+static int of_dev_node_match(struct device *dev, void *data)
+{
+        return dev->of_node == data;
+}
+
+/* must call put_device() when done with returned i2c_client device */
+struct i2c_client *of_find_i2c_device_by_node(struct device_node *node)
+{
+	struct device *dev;
+
+	dev = bus_find_device(&i2c_bus_type, NULL, node,
+					 of_dev_node_match);
+	if (!dev)
+		return NULL;
+
+	return to_i2c_client(dev);
+}
+EXPORT_SYMBOL(of_find_i2c_device_by_node);
+#else
+static void of_i2c_register_devices(struct i2c_adapter *adap) {}
+#endif
+
 static int i2c_do_add_adapter(struct i2c_driver *driver,
 			      struct i2c_adapter *adap)
 {
diff --git a/drivers/of/Makefile b/drivers/of/Makefile
index dccb117..faa007c 100644
--- a/drivers/of/Makefile
+++ b/drivers/of/Makefile
@@ -5,7 +5,6 @@ obj-$(CONFIG_OF_ADDRESS)  += address.o
 obj-$(CONFIG_OF_IRQ)    += irq.o
 obj-$(CONFIG_OF_DEVICE) += device.o platform.o
 obj-$(CONFIG_OF_GPIO)   += gpio.o
-obj-$(CONFIG_OF_I2C)	+= of_i2c.o
 obj-$(CONFIG_OF_NET)	+= of_net.o
 obj-$(CONFIG_OF_SPI)	+= of_spi.o
 obj-$(CONFIG_OF_MDIO)	+= of_mdio.o
diff --git a/drivers/of/of_i2c.c b/drivers/of/of_i2c.c
deleted file mode 100644
index f37fbeb..0000000
--- a/drivers/of/of_i2c.c
+++ /dev/null
@@ -1,97 +0,0 @@
-/*
- * OF helpers for the I2C API
- *
- * Copyright (c) 2008 Jochen Friedrich <jochen@scram.de>
- *
- * Based on a previous patch from Jon Smirl <jonsmirl@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#include <linux/i2c.h>
-#include <linux/irq.h>
-#include <linux/of.h>
-#include <linux/of_i2c.h>
-#include <linux/of_irq.h>
-#include <linux/module.h>
-
-void of_i2c_register_devices(struct i2c_adapter *adap)
-{
-	void *result;
-	struct device_node *node;
-
-	/* Only register child devices if the adapter has a node pointer set */
-	if (!adap->dev.of_node)
-		return;
-
-	dev_dbg(&adap->dev, "of_i2c: walking child nodes\n");
-
-	for_each_child_of_node(adap->dev.of_node, node) {
-		struct i2c_board_info info = {};
-		struct dev_archdata dev_ad = {};
-		const __be32 *addr;
-		int len;
-
-		dev_dbg(&adap->dev, "of_i2c: register %s\n", node->full_name);
-
-		if (of_modalias_node(node, info.type, sizeof(info.type)) < 0) {
-			dev_err(&adap->dev, "of_i2c: modalias failure on %s\n",
-				node->full_name);
-			continue;
-		}
-
-		addr = of_get_property(node, "reg", &len);
-		if (!addr || (len < sizeof(int))) {
-			dev_err(&adap->dev, "of_i2c: invalid reg on %s\n",
-				node->full_name);
-			continue;
-		}
-
-		info.addr = be32_to_cpup(addr);
-		if (info.addr > (1 << 10) - 1) {
-			dev_err(&adap->dev, "of_i2c: invalid addr=%x on %s\n",
-				info.addr, node->full_name);
-			continue;
-		}
-
-		info.irq = irq_of_parse_and_map(node, 0);
-		info.of_node = of_node_get(node);
-		info.archdata = &dev_ad;
-
-		request_module("%s%s", I2C_MODULE_PREFIX, info.type);
-
-		result = i2c_new_device(adap, &info);
-		if (result == NULL) {
-			dev_err(&adap->dev, "of_i2c: Failure registering %s\n",
-			        node->full_name);
-			of_node_put(node);
-			irq_dispose_mapping(info.irq);
-			continue;
-		}
-	}
-}
-EXPORT_SYMBOL(of_i2c_register_devices);
-
-static int of_dev_node_match(struct device *dev, void *data)
-{
-        return dev->of_node == data;
-}
-
-/* must call put_device() when done with returned i2c_client device */
-struct i2c_client *of_find_i2c_device_by_node(struct device_node *node)
-{
-	struct device *dev;
-
-	dev = bus_find_device(&i2c_bus_type, NULL, node,
-					 of_dev_node_match);
-	if (!dev)
-		return NULL;
-
-	return to_i2c_client(dev);
-}
-EXPORT_SYMBOL(of_find_i2c_device_by_node);
-
-MODULE_LICENSE("GPL");
diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index a6c652e..830397b 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -468,6 +468,10 @@ static inline int i2c_adapter_id(struct i2c_adapter *adap)
 {
 	return adap->nr;
 }
+
+/* must call put_device() when done with returned i2c_client device */
+extern struct i2c_client *of_find_i2c_device_by_node(struct device_node *node);
+
 #endif /* I2C */
 #endif /* __KERNEL__ */
 
diff --git a/include/linux/of_i2c.h b/include/linux/of_i2c.h
deleted file mode 100644
index 0efe8d4..0000000
--- a/include/linux/of_i2c.h
+++ /dev/null
@@ -1,30 +0,0 @@
-/*
- * Generic I2C API implementation for PowerPC.
- *
- * Copyright (c) 2008 Jochen Friedrich <jochen@scram.de>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#ifndef __LINUX_OF_I2C_H
-#define __LINUX_OF_I2C_H
-
-#if defined(CONFIG_OF_I2C) || defined(CONFIG_OF_I2C_MODULE)
-#include <linux/i2c.h>
-
-extern void of_i2c_register_devices(struct i2c_adapter *adap);
-
-/* must call put_device() when done with returned i2c_client device */
-extern struct i2c_client *of_find_i2c_device_by_node(struct device_node *node);
-
-#else
-static inline void of_i2c_register_devices(struct i2c_adapter *adap)
-{
-	return;
-}
-#endif /* CONFIG_OF_I2C */
-
-#endif /* __LINUX_OF_I2C_H */
-- 
1.7.4.1

