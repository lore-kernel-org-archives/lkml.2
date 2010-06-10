Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892Ab0FJFWk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 01:22:40 -0400
Received: from mail-pz0-f176.google.com ([209.85.222.176]:56081 "EHLO
	mail-pz0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753593Ab0FJFWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 01:22:37 -0400
Subject: [PATCH 1/2] of/i2c: Generalize OF support
From: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, jeremy.kerr@canonical.com,
       devicetree-discuss@lists.ozlabs.org, ben-linux@fluff.org,
       linux-i2c@vger.kernel.org
Date: Wed, 09 Jun 2010 23:22:32 -0600
Message-ID: <20100610052232.16222.942.stgit@angua>
In-Reply-To: <20100610052102.16222.86662.stgit@angua>
References: <20100610052102.16222.86662.stgit@angua>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch cleans up the i2c OF support code to make it selectable by
all architectures and allow for automatic registration of i2c devices.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 drivers/i2c/busses/i2c-cpm.c     |    3 ++-
 drivers/i2c/busses/i2c-ibm_iic.c |    3 ++-
 drivers/i2c/busses/i2c-mpc.c     |    3 ++-
 drivers/of/Kconfig               |    2 +-
 drivers/of/of_i2c.c              |   44 ++++++++++++++++++++++++--------------
 include/linux/of_i2c.h           |   13 +++++++++--
 6 files changed, 45 insertions(+), 23 deletions(-)

diff --git a/drivers/i2c/busses/i2c-cpm.c b/drivers/i2c/busses/i2c-cpm.c
index b02b453..03ae62e 100644
--- a/drivers/i2c/busses/i2c-cpm.c
+++ b/drivers/i2c/busses/i2c-cpm.c
@@ -652,6 +652,7 @@ static int __devinit cpm_i2c_probe(struct of_device *ofdev,
 	cpm->adap = cpm_ops;
 	i2c_set_adapdata(&cpm->adap, cpm);
 	cpm->adap.dev.parent = &ofdev->dev;
+	cpm->adap.dev.of_node = of_node_get(ofdev->dev.of_node);
 
 	result = cpm_i2c_setup(cpm);
 	if (result) {
@@ -679,7 +680,7 @@ static int __devinit cpm_i2c_probe(struct of_device *ofdev,
 	/*
 	 * register OF I2C devices
 	 */
-	of_register_i2c_devices(&cpm->adap, ofdev->dev.of_node);
+	of_i2c_register_devices(&cpm->adap);
 
 	return 0;
 out_shut:
diff --git a/drivers/i2c/busses/i2c-ibm_iic.c b/drivers/i2c/busses/i2c-ibm_iic.c
index bf34413..d964121 100644
--- a/drivers/i2c/busses/i2c-ibm_iic.c
+++ b/drivers/i2c/busses/i2c-ibm_iic.c
@@ -745,6 +745,7 @@ static int __devinit iic_probe(struct of_device *ofdev,
 	/* Register it with i2c layer */
 	adap = &dev->adap;
 	adap->dev.parent = &ofdev->dev;
+	adap->dev.of_node = of_node_get(np);
 	strlcpy(adap->name, "IBM IIC", sizeof(adap->name));
 	i2c_set_adapdata(adap, dev);
 	adap->class = I2C_CLASS_HWMON | I2C_CLASS_SPD;
@@ -761,7 +762,7 @@ static int __devinit iic_probe(struct of_device *ofdev,
 		 dev->fast_mode ? "fast (400 kHz)" : "standard (100 kHz)");
 
 	/* Now register all the child nodes */
-	of_register_i2c_devices(adap, np);
+	of_i2c_register_devices(adap);
 
 	return 0;
 
diff --git a/drivers/i2c/busses/i2c-mpc.c b/drivers/i2c/busses/i2c-mpc.c
index df00eb1..d2e26d2 100644
--- a/drivers/i2c/busses/i2c-mpc.c
+++ b/drivers/i2c/busses/i2c-mpc.c
@@ -600,13 +600,14 @@ static int __devinit fsl_i2c_probe(struct of_device *op,
 	i2c->adap = mpc_ops;
 	i2c_set_adapdata(&i2c->adap, i2c);
 	i2c->adap.dev.parent = &op->dev;
+	i2c->adap.dev.of_node = of_node_get(op->dev.of_node);
 
 	result = i2c_add_adapter(&i2c->adap);
 	if (result < 0) {
 		dev_err(i2c->dev, "failed to add adapter\n");
 		goto fail_add;
 	}
-	of_register_i2c_devices(&i2c->adap, op->dev.of_node);
+	of_i2c_register_devices(&i2c->adap);
 
 	return result;
 
diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
index 097f42a..80dd631 100644
--- a/drivers/of/Kconfig
+++ b/drivers/of/Kconfig
@@ -26,7 +26,7 @@ config OF_GPIO
 
 config OF_I2C
 	def_tristate I2C
-	depends on (PPC_OF || MICROBLAZE) && I2C
+	depends on OF && !SPARC && I2C
 	help
 	  OpenFirmware I2C accessors
 
diff --git a/drivers/of/of_i2c.c b/drivers/of/of_i2c.c
index ab6522c..e05f9a1 100644
--- a/drivers/of/of_i2c.c
+++ b/drivers/of/of_i2c.c
@@ -14,34 +14,49 @@
 #include <linux/i2c.h>
 #include <linux/of.h>
 #include <linux/of_i2c.h>
+#include <linux/of_irq.h>
 #include <linux/module.h>
 
-void of_register_i2c_devices(struct i2c_adapter *adap,
-			     struct device_node *adap_node)
+void of_i2c_register_devices(struct i2c_adapter *adap)
 {
 	void *result;
 	struct device_node *node;
 
-	for_each_child_of_node(adap_node, node) {
+	/* Only register child devices if the adapter has a node pointer set */
+	if (!adap->dev.of_node)
+		return;
+
+	dev_dbg(&adap->dev, "of_i2c: walking child nodes\n");
+
+	for_each_child_of_node(adap->dev.of_node, node) {
 		struct i2c_board_info info = {};
 		struct dev_archdata dev_ad = {};
 		const __be32 *addr;
 		int len;
 
-		if (of_modalias_node(node, info.type, sizeof(info.type)) < 0)
+		dev_dbg(&adap->dev, "of_i2c: register %s\n", node->full_name);
+
+		if (of_modalias_node(node, info.type, sizeof(info.type)) < 0) {
+			dev_err(&adap->dev, "of_i2c: modalias failure on %s\n",
+				node->full_name);
 			continue;
+		}
 
 		addr = of_get_property(node, "reg", &len);
-		if (!addr || len < sizeof(int) || *addr > (1 << 10) - 1) {
-			printk(KERN_ERR
-			       "of-i2c: invalid i2c device entry\n");
+		if (!addr || (len < sizeof(int))) {
+			dev_err(&adap->dev, "of_i2c: invalid reg on %s\n",
+				node->full_name);
 			continue;
 		}
 
-		info.irq = irq_of_parse_and_map(node, 0);
-
 		info.addr = be32_to_cpup(addr);
+		if (info.addr > (1 << 10) - 1) {
+			dev_err(&adap->dev, "of_i2c: invalid addr=%x on %s\n",
+				info.addr, node->full_name);
+			continue;
+		}
 
+		info.irq = irq_of_parse_and_map(node, 0);
 		info.of_node = node;
 		info.archdata = &dev_ad;
 
@@ -49,10 +64,8 @@ void of_register_i2c_devices(struct i2c_adapter *adap,
 
 		result = i2c_new_device(adap, &info);
 		if (result == NULL) {
-			printk(KERN_ERR
-			       "of-i2c: Failed to load driver for %s\n",
-			       info.type);
-			irq_dispose_mapping(info.irq);
+			dev_err(&adap->dev, "of_i2c: Failure registering %s\n",
+			        node->full_name);
 			continue;
 		}
 
@@ -64,7 +77,7 @@ void of_register_i2c_devices(struct i2c_adapter *adap,
 		of_node_get(node);
 	}
 }
-EXPORT_SYMBOL(of_register_i2c_devices);
+EXPORT_SYMBOL(of_i2c_register_devices);
 
 static int of_dev_node_match(struct device *dev, void *data)
 {
@@ -76,8 +89,7 @@ struct i2c_client *of_find_i2c_device_by_node(struct device_node *node)
 {
 	struct device *dev;
 
-	dev = bus_find_device(&i2c_bus_type, NULL, node,
-					 of_dev_node_match);
+	dev = bus_find_device(&i2c_bus_type, NULL, node, of_dev_node_match);
 	if (!dev)
 		return NULL;
 
diff --git a/include/linux/of_i2c.h b/include/linux/of_i2c.h
index 34974b5..0efe8d4 100644
--- a/include/linux/of_i2c.h
+++ b/include/linux/of_i2c.h
@@ -12,12 +12,19 @@
 #ifndef __LINUX_OF_I2C_H
 #define __LINUX_OF_I2C_H
 
+#if defined(CONFIG_OF_I2C) || defined(CONFIG_OF_I2C_MODULE)
 #include <linux/i2c.h>
 
-void of_register_i2c_devices(struct i2c_adapter *adap,
-			     struct device_node *adap_node);
+extern void of_i2c_register_devices(struct i2c_adapter *adap);
 
 /* must call put_device() when done with returned i2c_client device */
-struct i2c_client *of_find_i2c_device_by_node(struct device_node *node);
+extern struct i2c_client *of_find_i2c_device_by_node(struct device_node *node);
+
+#else
+static inline void of_i2c_register_devices(struct i2c_adapter *adap)
+{
+	return;
+}
+#endif /* CONFIG_OF_I2C */
 
 #endif /* __LINUX_OF_I2C_H */

