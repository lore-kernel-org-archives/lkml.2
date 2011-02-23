Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab1BWEmk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 23:42:40 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:32935 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395Ab1BWEmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 23:42:39 -0500
Subject: [RFC PATCH 15/15] dt: eliminate of_platform_driver shim code
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        devicetree-discuss@lists.ozlabs.org, sfr@canb.auug.org.au,
        linux-kernel@vger.kernel.org, davem@davemloft.net
From: Grant Likely <grant.likely@secretlab.ca>
Cc: sparclinux@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Date: Tue, 22 Feb 2011 21:34:52 -0700
Message-ID: <20110223043452.20795.70146.stgit@localhost6.localdomain6>
In-Reply-To: <20110223043015.20795.37090.stgit@localhost6.localdomain6>
References: <20110223043015.20795.37090.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit eca393016, "of: Merge of_platform_bus_type with
platform_bus_type" added a shim to allow of_platform_drivers to get
registers onto the platform bus so that there was time to migrate the
existing drivers to the platform_bus_type.

This patch removes the shim since there are no more users of the old
interface.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 drivers/of/platform.c       |   68 -------------------------------------------
 include/linux/of_platform.h |   12 +-------
 2 files changed, 1 insertions(+), 79 deletions(-)

diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index b71d0cd..1ce4c45 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -42,74 +42,6 @@ struct platform_device *of_find_device_by_node(struct device_node *np)
 }
 EXPORT_SYMBOL(of_find_device_by_node);
 
-static int platform_driver_probe_shim(struct platform_device *pdev)
-{
-	struct platform_driver *pdrv;
-	struct of_platform_driver *ofpdrv;
-	const struct of_device_id *match;
-
-	pdrv = container_of(pdev->dev.driver, struct platform_driver, driver);
-	ofpdrv = container_of(pdrv, struct of_platform_driver, platform_driver);
-
-	/* There is an unlikely chance that an of_platform driver might match
-	 * on a non-OF platform device.  If so, then of_match_device() will
-	 * come up empty.  Return -EINVAL in this case so other drivers get
-	 * the chance to bind. */
-	match = of_match_device(pdev->dev.driver->of_match_table, &pdev->dev);
-	return match ? ofpdrv->probe(pdev, match) : -EINVAL;
-}
-
-static void platform_driver_shutdown_shim(struct platform_device *pdev)
-{
-	struct platform_driver *pdrv;
-	struct of_platform_driver *ofpdrv;
-
-	pdrv = container_of(pdev->dev.driver, struct platform_driver, driver);
-	ofpdrv = container_of(pdrv, struct of_platform_driver, platform_driver);
-	ofpdrv->shutdown(pdev);
-}
-
-/**
- * of_register_platform_driver
- */
-int of_register_platform_driver(struct of_platform_driver *drv)
-{
-	char *of_name;
-
-	/* setup of_platform_driver to platform_driver adaptors */
-	drv->platform_driver.driver = drv->driver;
-
-	/* Prefix the driver name with 'of:' to avoid namespace collisions
-	 * and bogus matches.  There are some drivers in the tree that
-	 * register both an of_platform_driver and a platform_driver with
-	 * the same name.  This is a temporary measure until they are all
-	 * cleaned up --gcl July 29, 2010 */
-	of_name = kmalloc(strlen(drv->driver.name) + 5, GFP_KERNEL);
-	if (!of_name)
-		return -ENOMEM;
-	sprintf(of_name, "of:%s", drv->driver.name);
-	drv->platform_driver.driver.name = of_name;
-
-	if (drv->probe)
-		drv->platform_driver.probe = platform_driver_probe_shim;
-	drv->platform_driver.remove = drv->remove;
-	if (drv->shutdown)
-		drv->platform_driver.shutdown = platform_driver_shutdown_shim;
-	drv->platform_driver.suspend = drv->suspend;
-	drv->platform_driver.resume = drv->resume;
-
-	return platform_driver_register(&drv->platform_driver);
-}
-EXPORT_SYMBOL(of_register_platform_driver);
-
-void of_unregister_platform_driver(struct of_platform_driver *drv)
-{
-	platform_driver_unregister(&drv->platform_driver);
-	kfree(drv->platform_driver.driver.name);
-	drv->platform_driver.driver.name = NULL;
-}
-EXPORT_SYMBOL(of_unregister_platform_driver);
-
 #if defined(CONFIG_PPC_DCR)
 #include <asm/dcr.h>
 #endif
diff --git a/include/linux/of_platform.h b/include/linux/of_platform.h
index 048949f..17c7e21 100644
--- a/include/linux/of_platform.h
+++ b/include/linux/of_platform.h
@@ -23,13 +23,7 @@
  * of_platform_driver - Legacy of-aware driver for platform devices.
  *
  * An of_platform_driver driver is attached to a basic platform_device on
- * ether the "platform bus" (platform_bus_type), or the ibm ebus
- * (ibmebus_bus_type).
- *
- * of_platform_driver is being phased out when used with the platform_bus_type,
- * and regular platform_drivers should be used instead.  When the transition
- * is complete, only ibmebus will be using this structure, and the
- * platform_driver member of this structure will be removed.
+ * the ibm ebus (ibmebus_bus_type).
  */
 struct of_platform_driver
 {
@@ -42,15 +36,11 @@ struct of_platform_driver
 	int	(*shutdown)(struct platform_device* dev);
 
 	struct device_driver	driver;
-	struct platform_driver	platform_driver;
 };
 #define	to_of_platform_driver(drv) \
 	container_of(drv,struct of_platform_driver, driver)
 
 /* Platform drivers register/unregister */
-extern int of_register_platform_driver(struct of_platform_driver *drv);
-extern void of_unregister_platform_driver(struct of_platform_driver *drv);
-
 extern struct platform_device *of_device_alloc(struct device_node *np,
 					 const char *bus_id,
 					 struct device *parent);

