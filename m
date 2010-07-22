Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760044Ab0GVWaW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 18:30:22 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:35085 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758734Ab0GVWaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 18:30:12 -0400
Subject: [PATCH 1/4] of/device: Replace of_device with platform_device in
	includes and core code
To: sfr@canb.auug.org.au, monstr@monstr.eu, microblaze-uclinux@itee.uq.edu.au,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, benh@kernel.crashing.org,
        sparclinux@vger.kernel.org, davem@davemloft.net
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 22 Jul 2010 16:30:06 -0600
Message-ID: <20100722223006.21557.84275.stgit@angua>
In-Reply-To: <20100722222600.21557.34167.stgit@angua>
References: <20100722222600.21557.34167.stgit@angua>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_device is currently just an #define alias to platform_device until it
gets removed entirely.  This patch removes references to it from the
include directories and the core drivers/of code.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 arch/powerpc/include/asm/macio.h   |    2 +-
 arch/sparc/include/asm/floppy_64.h |    6 +++---
 arch/sparc/include/asm/parport.h   |    4 ++--
 drivers/of/device.c                |   22 +++++++++++-----------
 drivers/of/platform.c              |   24 ++++++++++++------------
 include/linux/of_device.h          |   10 +++++-----
 include/linux/of_platform.h        |   16 ++++++++--------
 7 files changed, 42 insertions(+), 42 deletions(-)

diff --git a/arch/powerpc/include/asm/macio.h b/arch/powerpc/include/asm/macio.h
index 675e159..7ab82c8 100644
--- a/arch/powerpc/include/asm/macio.h
+++ b/arch/powerpc/include/asm/macio.h
@@ -38,7 +38,7 @@ struct macio_dev
 {
 	struct macio_bus	*bus;		/* macio bus this device is on */
 	struct macio_dev	*media_bay;	/* Device is part of a media bay */
-	struct of_device	ofdev;
+	struct platform_device	ofdev;
 	struct device_dma_parameters dma_parms; /* ide needs that */
 	int			n_resources;
 	struct resource		resource[MACIO_DEV_COUNT_RESOURCES];
diff --git a/arch/sparc/include/asm/floppy_64.h b/arch/sparc/include/asm/floppy_64.h
index 4f5bde6..6597ce8 100644
--- a/arch/sparc/include/asm/floppy_64.h
+++ b/arch/sparc/include/asm/floppy_64.h
@@ -43,7 +43,7 @@ struct sun_flpy_controller {
 /* You'll only ever find one controller on an Ultra anyways. */
 static struct sun_flpy_controller *sun_fdc = (struct sun_flpy_controller *)-1;
 unsigned long fdc_status;
-static struct of_device *floppy_op = NULL;
+static struct platform_device *floppy_op = NULL;
 
 struct sun_floppy_ops {
 	unsigned char	(*fd_inb) (unsigned long port);
@@ -548,7 +548,7 @@ static unsigned long __init sun_floppy_init(void)
 {
 	static int initialized = 0;
 	struct device_node *dp;
-	struct of_device *op;
+	struct platform_device *op;
 	const char *prop;
 	char state[128];
 
@@ -661,7 +661,7 @@ static unsigned long __init sun_floppy_init(void)
 		config = 0;
 		for (dp = ebus_dp->child; dp; dp = dp->sibling) {
 			if (!strcmp(dp->name, "ecpp")) {
-				struct of_device *ecpp_op;
+				struct platform_device *ecpp_op;
 
 				ecpp_op = of_find_device_by_node(dp);
 				if (ecpp_op)
diff --git a/arch/sparc/include/asm/parport.h b/arch/sparc/include/asm/parport.h
index 4891fbc..4f7afa0 100644
--- a/arch/sparc/include/asm/parport.h
+++ b/arch/sparc/include/asm/parport.h
@@ -103,7 +103,7 @@ static inline unsigned int get_dma_residue(unsigned int dmanr)
 	return ebus_dma_residue(&sparc_ebus_dmas[dmanr].info);
 }
 
-static int __devinit ecpp_probe(struct of_device *op, const struct of_device_id *match)
+static int __devinit ecpp_probe(struct platform_device *op, const struct of_device_id *match)
 {
 	unsigned long base = op->resource[0].start;
 	unsigned long config = op->resource[1].start;
@@ -192,7 +192,7 @@ out_err:
 	return err;
 }
 
-static int __devexit ecpp_remove(struct of_device *op)
+static int __devexit ecpp_remove(struct platform_device *op)
 {
 	struct parport *p = dev_get_drvdata(&op->dev);
 	int slot = p->dma;
diff --git a/drivers/of/device.c b/drivers/of/device.c
index 12a44b4..0d8a064 100644
--- a/drivers/of/device.c
+++ b/drivers/of/device.c
@@ -26,7 +26,7 @@ const struct of_device_id *of_match_device(const struct of_device_id *matches,
 }
 EXPORT_SYMBOL(of_match_device);
 
-struct of_device *of_dev_get(struct of_device *dev)
+struct platform_device *of_dev_get(struct platform_device *dev)
 {
 	struct device *tmp;
 
@@ -34,13 +34,13 @@ struct of_device *of_dev_get(struct of_device *dev)
 		return NULL;
 	tmp = get_device(&dev->dev);
 	if (tmp)
-		return to_of_device(tmp);
+		return to_platform_device(tmp);
 	else
 		return NULL;
 }
 EXPORT_SYMBOL(of_dev_get);
 
-void of_dev_put(struct of_device *dev)
+void of_dev_put(struct platform_device *dev)
 {
 	if (dev)
 		put_device(&dev->dev);
@@ -50,18 +50,18 @@ EXPORT_SYMBOL(of_dev_put);
 static ssize_t devspec_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
-	struct of_device *ofdev;
+	struct platform_device *ofdev;
 
-	ofdev = to_of_device(dev);
+	ofdev = to_platform_device(dev);
 	return sprintf(buf, "%s\n", ofdev->dev.of_node->full_name);
 }
 
 static ssize_t name_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
-	struct of_device *ofdev;
+	struct platform_device *ofdev;
 
-	ofdev = to_of_device(dev);
+	ofdev = to_platform_device(dev);
 	return sprintf(buf, "%s\n", ofdev->dev.of_node->name);
 }
 
@@ -90,15 +90,15 @@ struct device_attribute of_platform_device_attrs[] = {
  */
 void of_release_dev(struct device *dev)
 {
-	struct of_device *ofdev;
+	struct platform_device *ofdev;
 
-	ofdev = to_of_device(dev);
+	ofdev = to_platform_device(dev);
 	of_node_put(ofdev->dev.of_node);
 	kfree(ofdev);
 }
 EXPORT_SYMBOL(of_release_dev);
 
-int of_device_register(struct of_device *ofdev)
+int of_device_register(struct platform_device *ofdev)
 {
 	BUG_ON(ofdev->dev.of_node == NULL);
 
@@ -119,7 +119,7 @@ int of_device_register(struct of_device *ofdev)
 }
 EXPORT_SYMBOL(of_device_register);
 
-void of_device_unregister(struct of_device *ofdev)
+void of_device_unregister(struct platform_device *ofdev)
 {
 	device_unregister(&ofdev->dev);
 }
diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index f355ad7..9b2d5b1 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -94,11 +94,11 @@ static int of_platform_device_probe(struct device *dev)
 {
 	int error = -ENODEV;
 	struct of_platform_driver *drv;
-	struct of_device *of_dev;
+	struct platform_device *of_dev;
 	const struct of_device_id *match;
 
 	drv = to_of_platform_driver(dev->driver);
-	of_dev = to_of_device(dev);
+	of_dev = to_platform_device(dev);
 
 	if (!drv->probe)
 		return error;
@@ -116,7 +116,7 @@ static int of_platform_device_probe(struct device *dev)
 
 static int of_platform_device_remove(struct device *dev)
 {
-	struct of_device *of_dev = to_of_device(dev);
+	struct platform_device *of_dev = to_platform_device(dev);
 	struct of_platform_driver *drv = to_of_platform_driver(dev->driver);
 
 	if (dev->driver && drv->remove)
@@ -126,7 +126,7 @@ static int of_platform_device_remove(struct device *dev)
 
 static void of_platform_device_shutdown(struct device *dev)
 {
-	struct of_device *of_dev = to_of_device(dev);
+	struct platform_device *of_dev = to_platform_device(dev);
 	struct of_platform_driver *drv = to_of_platform_driver(dev->driver);
 
 	if (dev->driver && drv->shutdown)
@@ -137,7 +137,7 @@ static void of_platform_device_shutdown(struct device *dev)
 
 static int of_platform_legacy_suspend(struct device *dev, pm_message_t mesg)
 {
-	struct of_device *of_dev = to_of_device(dev);
+	struct platform_device *of_dev = to_platform_device(dev);
 	struct of_platform_driver *drv = to_of_platform_driver(dev->driver);
 	int ret = 0;
 
@@ -148,7 +148,7 @@ static int of_platform_legacy_suspend(struct device *dev, pm_message_t mesg)
 
 static int of_platform_legacy_resume(struct device *dev)
 {
-	struct of_device *of_dev = to_of_device(dev);
+	struct platform_device *of_dev = to_platform_device(dev);
 	struct of_platform_driver *drv = to_of_platform_driver(dev->driver);
 	int ret = 0;
 
@@ -543,11 +543,11 @@ static void of_device_make_bus_id(struct device *dev)
  * @bus_id: Name to assign to the device.  May be null to use default name.
  * @parent: Parent device.
  */
-struct of_device *of_device_alloc(struct device_node *np,
+struct platform_device *of_device_alloc(struct device_node *np,
 				  const char *bus_id,
 				  struct device *parent)
 {
-	struct of_device *dev;
+	struct platform_device *dev;
 	int rc, i, num_reg = 0, num_irq = 0;
 	struct resource *res, temp_res;
 
@@ -600,11 +600,11 @@ EXPORT_SYMBOL(of_device_alloc);
  * @bus_id: name to assign device
  * @parent: Linux device model parent device.
  */
-struct of_device *of_platform_device_create(struct device_node *np,
+struct platform_device *of_platform_device_create(struct device_node *np,
 					    const char *bus_id,
 					    struct device *parent)
 {
-	struct of_device *dev;
+	struct platform_device *dev;
 
 	dev = of_device_alloc(np, bus_id, parent);
 	if (!dev)
@@ -642,7 +642,7 @@ static int of_platform_bus_create(const struct device_node *bus,
 				  struct device *parent)
 {
 	struct device_node *child;
-	struct of_device *dev;
+	struct platform_device *dev;
 	int rc = 0;
 
 	for_each_child_of_node(bus, child) {
@@ -678,7 +678,7 @@ int of_platform_bus_probe(struct device_node *root,
 			  struct device *parent)
 {
 	struct device_node *child;
-	struct of_device *dev;
+	struct platform_device *dev;
 	int rc = 0;
 
 	if (matches == NULL)
diff --git a/include/linux/of_device.h b/include/linux/of_device.h
index 0f19119..e11a0be 100644
--- a/include/linux/of_device.h
+++ b/include/linux/of_device.h
@@ -39,14 +39,14 @@ static inline int of_driver_match_device(const struct device *dev,
 	return of_match_device(drv->of_match_table, dev) != NULL;
 }
 
-extern struct of_device *of_dev_get(struct of_device *dev);
-extern void of_dev_put(struct of_device *dev);
+extern struct platform_device *of_dev_get(struct platform_device *dev);
+extern void of_dev_put(struct platform_device *dev);
 
-extern int of_device_register(struct of_device *ofdev);
-extern void of_device_unregister(struct of_device *ofdev);
+extern int of_device_register(struct platform_device *ofdev);
+extern void of_device_unregister(struct platform_device *ofdev);
 extern void of_release_dev(struct device *dev);
 
-static inline void of_device_free(struct of_device *dev)
+static inline void of_device_free(struct platform_device *dev)
 {
 	of_release_dev(&dev->dev);
 }
diff --git a/include/linux/of_platform.h b/include/linux/of_platform.h
index a79f59b..b24c5a5 100644
--- a/include/linux/of_platform.h
+++ b/include/linux/of_platform.h
@@ -27,13 +27,13 @@ extern const struct of_device_id of_default_bus_ids[];
  */
 struct of_platform_driver
 {
-	int	(*probe)(struct of_device* dev,
+	int	(*probe)(struct platform_device* dev,
 			 const struct of_device_id *match);
-	int	(*remove)(struct of_device* dev);
+	int	(*remove)(struct platform_device* dev);
 
-	int	(*suspend)(struct of_device* dev, pm_message_t state);
-	int	(*resume)(struct of_device* dev);
-	int	(*shutdown)(struct of_device* dev);
+	int	(*suspend)(struct platform_device* dev, pm_message_t state);
+	int	(*resume)(struct platform_device* dev);
+	int	(*shutdown)(struct platform_device* dev);
 
 	struct device_driver	driver;
 	struct platform_driver	platform_driver;
@@ -49,16 +49,16 @@ extern void of_unregister_driver(struct of_platform_driver *drv);
 extern int of_register_platform_driver(struct of_platform_driver *drv);
 extern void of_unregister_platform_driver(struct of_platform_driver *drv);
 
-extern struct of_device *of_device_alloc(struct device_node *np,
+extern struct platform_device *of_device_alloc(struct device_node *np,
 					 const char *bus_id,
 					 struct device *parent);
-extern struct of_device *of_find_device_by_node(struct device_node *np);
+extern struct platform_device *of_find_device_by_node(struct device_node *np);
 
 extern int of_bus_type_init(struct bus_type *bus, const char *name);
 
 #if !defined(CONFIG_SPARC) /* SPARC has its own device registration method */
 /* Platform devices and busses creation */
-extern struct of_device *of_platform_device_create(struct device_node *np,
+extern struct platform_device *of_platform_device_create(struct device_node *np,
 						   const char *bus_id,
 						   struct device *parent);
 

