Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647Ab1EIAdj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 20:33:39 -0400
Received: from mga01.intel.com ([192.55.52.88]:3564 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756609Ab1EIAdf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 20:33:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,337,1301900400"; 
   d="scan'208";a="919713009"
From: Samuel Ortiz <sameo@linux.intel.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Wim Van Sebroeck <wim@iguana.be>,
        Florian Fainelli <florian@openwrt.org>
Subject: [PATCH 11/19] mfd: Use mfd cell platform_data for rdc321x cells platform bits
Date: Mon,  9 May 2011 02:32:03 +0200
Message-Id: <1304901131-7104-12-git-send-email-sameo@linux.intel.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1304901131-7104-1-git-send-email-sameo@linux.intel.com>
References: <1304901131-7104-1-git-send-email-sameo@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the addition of a platform device mfd_cell pointer, MFD drivers
can go back to passing platform data back to their sub drivers.
This allows for an mfd_cell->mfd_data removal and thus keep the
sub drivers MFD agnostic. This is mostly needed for non MFD aware
sub drivers.

Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: Florian Fainelli <florian@openwrt.org>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/gpio/rdc321x-gpio.c       |    3 +--
 drivers/mfd/rdc321x-southbridge.c |    6 ++++--
 drivers/watchdog/rdc321x_wdt.c    |    3 +--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/gpio/rdc321x-gpio.c b/drivers/gpio/rdc321x-gpio.c
index a9bda88..2762698 100644
--- a/drivers/gpio/rdc321x-gpio.c
+++ b/drivers/gpio/rdc321x-gpio.c
@@ -27,7 +27,6 @@
 #include <linux/pci.h>
 #include <linux/gpio.h>
 #include <linux/mfd/rdc321x.h>
-#include <linux/mfd/core.h>
 #include <linux/slab.h>
 
 struct rdc321x_gpio {
@@ -136,7 +135,7 @@ static int __devinit rdc321x_gpio_probe(struct platform_device *pdev)
 	struct rdc321x_gpio *rdc321x_gpio_dev;
 	struct rdc321x_gpio_pdata *pdata;
 
-	pdata = mfd_get_data(pdev);
+	pdata = pdev->dev.platform_data;
 	if (!pdata) {
 		dev_err(&pdev->dev, "no platform data supplied\n");
 		return -ENODEV;
diff --git a/drivers/mfd/rdc321x-southbridge.c b/drivers/mfd/rdc321x-southbridge.c
index 10dbe63..809bd4a 100644
--- a/drivers/mfd/rdc321x-southbridge.c
+++ b/drivers/mfd/rdc321x-southbridge.c
@@ -61,12 +61,14 @@ static struct mfd_cell rdc321x_sb_cells[] = {
 		.name		= "rdc321x-wdt",
 		.resources	= rdc321x_wdt_resource,
 		.num_resources	= ARRAY_SIZE(rdc321x_wdt_resource),
-		.mfd_data	= &rdc321x_wdt_pdata,
+		.platform_data	= &rdc321x_wdt_pdata,
+		.pdata_size	= sizeof(rdc321x_wdt_pdata),
 	}, {
 		.name		= "rdc321x-gpio",
 		.resources	= rdc321x_gpio_resources,
 		.num_resources	= ARRAY_SIZE(rdc321x_gpio_resources),
-		.mfd_data	= &rdc321x_gpio_pdata,
+		.platform_data	= &rdc321x_gpio_pdata,
+		.pdata_size	= sizeof(rdc321x_gpio_pdata),
 	},
 };
 
diff --git a/drivers/watchdog/rdc321x_wdt.c b/drivers/watchdog/rdc321x_wdt.c
index d8e7250..428f8a1 100644
--- a/drivers/watchdog/rdc321x_wdt.c
+++ b/drivers/watchdog/rdc321x_wdt.c
@@ -37,7 +37,6 @@
 #include <linux/io.h>
 #include <linux/uaccess.h>
 #include <linux/mfd/rdc321x.h>
-#include <linux/mfd/core.h>
 
 #define RDC_WDT_MASK	0x80000000 /* Mask */
 #define RDC_WDT_EN	0x00800000 /* Enable bit */
@@ -232,7 +231,7 @@ static int __devinit rdc321x_wdt_probe(struct platform_device *pdev)
 	struct resource *r;
 	struct rdc321x_wdt_pdata *pdata;
 
-	pdata = mfd_get_data(pdev);
+	pdata = pdev->dev.platform_data;
 	if (!pdata) {
 		dev_err(&pdev->dev, "no platform data supplied\n");
 		return -ENODEV;
-- 
1.7.2.3

