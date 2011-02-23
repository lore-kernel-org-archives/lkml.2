Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201Ab1BWEkO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 23:40:14 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:52815 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102Ab1BWEkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 23:40:11 -0500
Subject: [RFC PATCH 07/15] dt: uartlite: merge platform and of_platform driver
	bindings
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        devicetree-discuss@lists.ozlabs.org, sfr@canb.auug.org.au,
        linux-kernel@vger.kernel.org, davem@davemloft.net
From: Grant Likely <grant.likely@secretlab.ca>
Cc: sparclinux@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Date: Tue, 22 Feb 2011 21:34:11 -0700
Message-ID: <20110223043411.20795.57850.stgit@localhost6.localdomain6>
In-Reply-To: <20110223043015.20795.37090.stgit@localhost6.localdomain6>
References: <20110223043015.20795.37090.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_platform_driver is getting removed, and a single platform_driver
can now support both devicetree and non-devicetree use cases.  This
patch merges the two driver registrations.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 drivers/tty/serial/uartlite.c |  103 ++++++++++-------------------------------
 1 files changed, 24 insertions(+), 79 deletions(-)

diff --git a/drivers/tty/serial/uartlite.c b/drivers/tty/serial/uartlite.c
index d2fce86..457ac34 100644
--- a/drivers/tty/serial/uartlite.c
+++ b/drivers/tty/serial/uartlite.c
@@ -19,22 +19,11 @@
 #include <linux/interrupt.h>
 #include <linux/init.h>
 #include <asm/io.h>
-#if defined(CONFIG_OF) && (defined(CONFIG_PPC32) || defined(CONFIG_MICROBLAZE))
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/of_device.h>
 #include <linux/of_platform.h>
 
-/* Match table for of_platform binding */
-static struct of_device_id ulite_of_match[] __devinitdata = {
-	{ .compatible = "xlnx,opb-uartlite-1.00.b", },
-	{ .compatible = "xlnx,xps-uartlite-1.00.a", },
-	{}
-};
-MODULE_DEVICE_TABLE(of, ulite_of_match);
-
-#endif
-
 #define ULITE_NAME		"ttyUL"
 #define ULITE_MAJOR		204
 #define ULITE_MINOR		187
@@ -571,9 +560,23 @@ static int __devexit ulite_release(struct device *dev)
  * Platform bus binding
  */
 
+#if defined(CONFIG_OF)
+/* Match table for of_platform binding */
+static struct of_device_id ulite_of_match[] __devinitdata = {
+	{ .compatible = "xlnx,opb-uartlite-1.00.b", },
+	{ .compatible = "xlnx,xps-uartlite-1.00.a", },
+	{}
+};
+MODULE_DEVICE_TABLE(of, ulite_of_match);
+#else /* CONFIG_OF */
+#define ulite_of_match NULL
+#endif /* CONFIG_OF */
+
 static int __devinit ulite_probe(struct platform_device *pdev)
 {
 	struct resource *res, *res2;
+	const __be32 *prop;
+	int id = pdev->id;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res)
@@ -583,7 +586,13 @@ static int __devinit ulite_probe(struct platform_device *pdev)
 	if (!res2)
 		return -ENODEV;
 
-	return ulite_assign(&pdev->dev, pdev->id, res->start, res2->start);
+#ifdef CONFIG_OF
+	prop = of_get_property(pdev->dev.of_node, "port-number", NULL);
+	if (prop)
+		id = be32_to_cpup(prop);
+#endif
+
+	return ulite_assign(&pdev->dev, id, res->start, res2->start);
 }
 
 static int __devexit ulite_remove(struct platform_device *pdev)
@@ -595,72 +604,15 @@ static int __devexit ulite_remove(struct platform_device *pdev)
 MODULE_ALIAS("platform:uartlite");
 
 static struct platform_driver ulite_platform_driver = {
-	.probe	= ulite_probe,
-	.remove	= __devexit_p(ulite_remove),
-	.driver	= {
-		   .owner = THIS_MODULE,
-		   .name  = "uartlite",
-		   },
-};
-
-/* ---------------------------------------------------------------------
- * OF bus bindings
- */
-#if defined(CONFIG_OF) && (defined(CONFIG_PPC32) || defined(CONFIG_MICROBLAZE))
-static int __devinit
-ulite_of_probe(struct platform_device *op, const struct of_device_id *match)
-{
-	struct resource res;
-	const unsigned int *id;
-	int irq, rc;
-
-	dev_dbg(&op->dev, "%s(%p, %p)\n", __func__, op, match);
-
-	rc = of_address_to_resource(op->dev.of_node, 0, &res);
-	if (rc) {
-		dev_err(&op->dev, "invalid address\n");
-		return rc;
-	}
-
-	irq = irq_of_parse_and_map(op->dev.of_node, 0);
-
-	id = of_get_property(op->dev.of_node, "port-number", NULL);
-
-	return ulite_assign(&op->dev, id ? *id : -1, res.start, irq);
-}
-
-static int __devexit ulite_of_remove(struct platform_device *op)
-{
-	return ulite_release(&op->dev);
-}
-
-static struct of_platform_driver ulite_of_driver = {
-	.probe = ulite_of_probe,
-	.remove = __devexit_p(ulite_of_remove),
+	.probe = ulite_probe,
+	.remove = __devexit_p(ulite_remove),
 	.driver = {
-		.name = "uartlite",
 		.owner = THIS_MODULE,
+		.name  = "uartlite",
 		.of_match_table = ulite_of_match,
 	},
 };
 
-/* Registration helpers to keep the number of #ifdefs to a minimum */
-static inline int __init ulite_of_register(void)
-{
-	pr_debug("uartlite: calling of_register_platform_driver()\n");
-	return of_register_platform_driver(&ulite_of_driver);
-}
-
-static inline void __exit ulite_of_unregister(void)
-{
-	of_unregister_platform_driver(&ulite_of_driver);
-}
-#else /* CONFIG_OF && (CONFIG_PPC32 || CONFIG_MICROBLAZE) */
-/* Appropriate config not enabled; do nothing helpers */
-static inline int __init ulite_of_register(void) { return 0; }
-static inline void __exit ulite_of_unregister(void) { }
-#endif /* CONFIG_OF && (CONFIG_PPC32 || CONFIG_MICROBLAZE) */
-
 /* ---------------------------------------------------------------------
  * Module setup/teardown
  */
@@ -674,10 +626,6 @@ int __init ulite_init(void)
 	if (ret)
 		goto err_uart;
 
-	ret = ulite_of_register();
-	if (ret)
-		goto err_of;
-
 	pr_debug("uartlite: calling platform_driver_register()\n");
 	ret = platform_driver_register(&ulite_platform_driver);
 	if (ret)
@@ -686,8 +634,6 @@ int __init ulite_init(void)
 	return 0;
 
 err_plat:
-	ulite_of_unregister();
-err_of:
 	uart_unregister_driver(&ulite_uart_driver);
 err_uart:
 	printk(KERN_ERR "registering uartlite driver failed: err=%i", ret);
@@ -697,7 +643,6 @@ err_uart:
 void __exit ulite_exit(void)
 {
 	platform_driver_unregister(&ulite_platform_driver);
-	ulite_of_unregister();
 	uart_unregister_driver(&ulite_uart_driver);
 }
 

