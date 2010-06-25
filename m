Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648Ab0FYSGa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 14:06:30 -0400
Received: from imap.ru.mvista.com ([213.79.90.228]:3812 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753042Ab0FYSG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 14:06:29 -0400
Date: Fri, 25 Jun 2010 22:06:27 +0400
From: Anton Vorontsov <avorontsov@mvista.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ben Dooks <ben@simtec.co.uk>,
       Richard =?utf-8?Q?R=C3=B6jfors?= <richard.rojfors@pelagicore.com>,
       linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] sdhci-pltfm: Switch to module device table matching
Message-ID: <20100625180627.GA18241@oksana.dev.rtsoft.ru>
References: <20100625180527.GA11280@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100625180527.GA11280@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes want to place SoC-specific parts alongside with the generic
driver, and to do so, we have to switch the driver over to the module
device table matching.

Note that drivers/mmc/host/sdhci-pltfm.h is so far empty, but it'll
hold SoC-specific driver data handlers soon.

Signed-off-by: Anton Vorontsov <avorontsov@mvista.com>
---
 drivers/mmc/host/sdhci-pltfm.c |   14 +++++++++++++-
 drivers/mmc/host/sdhci-pltfm.h |   14 ++++++++++++++
 2 files changed, 27 insertions(+), 1 deletions(-)
 create mode 100644 drivers/mmc/host/sdhci-pltfm.h

diff --git a/drivers/mmc/host/sdhci-pltfm.c b/drivers/mmc/host/sdhci-pltfm.c
index b6ee0d7..4c043bb 100644
--- a/drivers/mmc/host/sdhci-pltfm.c
+++ b/drivers/mmc/host/sdhci-pltfm.c
@@ -24,6 +24,7 @@
 
 #include <linux/delay.h>
 #include <linux/highmem.h>
+#include <linux/mod_devicetable.h>
 #include <linux/platform_device.h>
 
 #include <linux/mmc/host.h>
@@ -32,6 +33,7 @@
 #include <linux/sdhci-pltfm.h>
 
 #include "sdhci.h"
+#include "sdhci-pltfm.h"
 
 /*****************************************************************************\
  *                                                                           *
@@ -51,10 +53,14 @@ static struct sdhci_ops sdhci_pltfm_ops = {
 static int __devinit sdhci_pltfm_probe(struct platform_device *pdev)
 {
 	struct sdhci_pltfm_data *pdata = pdev->dev.platform_data;
+	const struct platform_device_id *platid = platform_get_device_id(pdev);
 	struct sdhci_host *host;
 	struct resource *iomem;
 	int ret;
 
+	if (!pdata && platid && platid->driver_data)
+		pdata = (void *)platid->driver_data;
+
 	iomem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!iomem) {
 		ret = -ENOMEM;
@@ -150,6 +156,12 @@ static int __devexit sdhci_pltfm_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static const struct platform_device_id sdhci_pltfm_ids[] = {
+	{ "sdhci", },
+	{ },
+};
+MODULE_DEVICE_TABLE(platform, sdhci_pltfm_ids);
+
 static struct platform_driver sdhci_pltfm_driver = {
 	.driver = {
 		.name	= "sdhci",
@@ -157,6 +169,7 @@ static struct platform_driver sdhci_pltfm_driver = {
 	},
 	.probe		= sdhci_pltfm_probe,
 	.remove		= __devexit_p(sdhci_pltfm_remove),
+	.id_table	= sdhci_pltfm_ids,
 };
 
 /*****************************************************************************\
@@ -181,4 +194,3 @@ module_exit(sdhci_drv_exit);
 MODULE_DESCRIPTION("Secure Digital Host Controller Interface platform driver");
 MODULE_AUTHOR("Mocean Laboratories <info@mocean-labs.com>");
 MODULE_LICENSE("GPL v2");
-MODULE_ALIAS("platform:sdhci");
diff --git a/drivers/mmc/host/sdhci-pltfm.h b/drivers/mmc/host/sdhci-pltfm.h
new file mode 100644
index 0000000..4aa07a9
--- /dev/null
+++ b/drivers/mmc/host/sdhci-pltfm.h
@@ -0,0 +1,14 @@
+/*
+ * Copyright 2010 MontaVista Software, LLC.
+ *
+ * Author: Anton Vorontsov <avorontsov@ru.mvista.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _DRIVERS_MMC_SDHCI_PLTFM_H
+#define _DRIVERS_MMC_SDHCI_PLTFM_H
+
+#endif /* _DRIVERS_MMC_SDHCI_PLTFM_H */
-- 
1.7.0.5

