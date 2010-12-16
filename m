Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808Ab0LPROT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 12:14:19 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47848 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755884Ab0LPROL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 12:14:11 -0500
From: Wolfram Sang <w.sang@pengutronix.de>
To: devicetree-discuss@ozlabs.org
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: [PATCH 1/3] of: platform: introduce of_probe_platform_driver()
Date: Thu, 16 Dec 2010 18:13:57 +0100
Message-Id: <1292519639-21859-2-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1292519639-21859-1-git-send-email-w.sang@pengutronix.de>
References: <1292519639-21859-1-git-send-email-w.sang@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a function equivalent to platform_driver_probe() for of. This is
needed to keep some SoC devices in the __init section.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
---
 drivers/of/platform.c       |   30 +++++++++++++++++++++++++++---
 include/linux/of_platform.h |    2 ++
 2 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index 5b4a07f..511657b 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -72,7 +72,7 @@ static void platform_driver_shutdown_shim(struct platform_device *pdev)
 /**
  * of_register_platform_driver
  */
-int of_register_platform_driver(struct of_platform_driver *drv)
+int __of_register_platform_driver(struct of_platform_driver *drv, bool do_probe)
 {
 	char *of_name;
 
@@ -90,18 +90,42 @@ int of_register_platform_driver(struct of_platform_driver *drv)
 	sprintf(of_name, "of:%s", drv->driver.name);
 	drv->platform_driver.driver.name = of_name;
 
-	if (drv->probe)
-		drv->platform_driver.probe = platform_driver_probe_shim;
 	drv->platform_driver.remove = drv->remove;
 	if (drv->shutdown)
 		drv->platform_driver.shutdown = platform_driver_shutdown_shim;
 	drv->platform_driver.suspend = drv->suspend;
 	drv->platform_driver.resume = drv->resume;
 
+	if (do_probe)
+		return platform_driver_probe(&drv->platform_driver,
+					platform_driver_probe_shim);
+
+	if (drv->probe)
+		drv->platform_driver.probe = platform_driver_probe_shim;
+
 	return platform_driver_register(&drv->platform_driver);
 }
+
+int of_register_platform_driver(struct of_platform_driver *drv)
+{
+	return __of_register_platform_driver(drv, false);
+}
+
 EXPORT_SYMBOL(of_register_platform_driver);
 
+int of_probe_platform_driver(struct of_platform_driver *drv,
+		int (*probe)(struct platform_device *, const struct of_device_id *match))
+{
+	int ret;
+
+	drv->probe = probe;
+	ret = __of_register_platform_driver(drv, true);
+	drv->probe = NULL;
+
+	return ret;
+}
+EXPORT_SYMBOL(of_probe_platform_driver);
+
 void of_unregister_platform_driver(struct of_platform_driver *drv)
 {
 	platform_driver_unregister(&drv->platform_driver);
diff --git a/include/linux/of_platform.h b/include/linux/of_platform.h
index a68716a..c4082c7 100644
--- a/include/linux/of_platform.h
+++ b/include/linux/of_platform.h
@@ -53,6 +53,8 @@ extern void of_unregister_driver(struct of_platform_driver *drv);
 
 /* Platform drivers register/unregister */
 extern int of_register_platform_driver(struct of_platform_driver *drv);
+extern int of_probe_platform_driver(struct of_platform_driver *drv,
+		int (*probe)(struct platform_device *, const struct of_device_id *match));
 extern void of_unregister_platform_driver(struct of_platform_driver *drv);
 
 extern struct platform_device *of_device_alloc(struct device_node *np,
-- 
1.7.2.3

