Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932609Ab1BRDI3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 22:08:29 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:51909 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751630Ab1BRDIR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 22:08:17 -0500
From: Andres Salomon <dilinger@queued.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Wim Van Sebroeck <wim@iguana.be>,
        Florian Fainelli <florian@openwrt.org>, linux-watchdog@vger.kernel.org
Subject: [PATCH 25/29] rdc321x-southbridge: use mfd_data instead of driver_data (v2)
Date: Thu, 17 Feb 2011 19:07:32 -0800
Message-Id: <1297998456-7615-26-git-send-email-dilinger@queued.net>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1297998456-7615-1-git-send-email-dilinger@queued.net>
References: <1297998456-7615-1-git-send-email-dilinger@queued.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use mfd_data for passing information from mfd drivers to soc
clients.  The mfd_cell's driver_data field is being phased out.

Clients that were using driver_data now access .mfd_data
via mfd_get_data().

v2: add some missing mfd/core.h includes

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/gpio/rdc321x-gpio.c       |    3 ++-
 drivers/mfd/rdc321x-southbridge.c |    4 ++--
 drivers/watchdog/rdc321x_wdt.c    |    3 ++-
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/gpio/rdc321x-gpio.c b/drivers/gpio/rdc321x-gpio.c
index 897e057..a9bda88 100644
--- a/drivers/gpio/rdc321x-gpio.c
+++ b/drivers/gpio/rdc321x-gpio.c
@@ -27,6 +27,7 @@
 #include <linux/pci.h>
 #include <linux/gpio.h>
 #include <linux/mfd/rdc321x.h>
+#include <linux/mfd/core.h>
 #include <linux/slab.h>
 
 struct rdc321x_gpio {
@@ -135,7 +136,7 @@ static int __devinit rdc321x_gpio_probe(struct platform_device *pdev)
 	struct rdc321x_gpio *rdc321x_gpio_dev;
 	struct rdc321x_gpio_pdata *pdata;
 
-	pdata = platform_get_drvdata(pdev);
+	pdata = mfd_get_data(pdev);
 	if (!pdata) {
 		dev_err(&pdev->dev, "no platform data supplied\n");
 		return -ENODEV;
diff --git a/drivers/mfd/rdc321x-southbridge.c b/drivers/mfd/rdc321x-southbridge.c
index 5092297..193c940 100644
--- a/drivers/mfd/rdc321x-southbridge.c
+++ b/drivers/mfd/rdc321x-southbridge.c
@@ -61,12 +61,12 @@ static struct mfd_cell rdc321x_sb_cells[] = {
 		.name		= "rdc321x-wdt",
 		.resources	= rdc321x_wdt_resource,
 		.num_resources	= ARRAY_SIZE(rdc321x_wdt_resource),
-		.driver_data	= &rdc321x_wdt_pdata,
+		.mfd_data	= &rdc321x_wdt_pdata,
 	}, {
 		.name		= "rdc321x-gpio",
 		.resources	= rdc321x_gpio_resources,
 		.num_resources	= ARRAY_SIZE(rdc321x_gpio_resources),
-		.driver_data	= &rdc321x_gpio_pdata,
+		.mfd_data	= &rdc321x_gpio_pdata,
 	},
 };
 
diff --git a/drivers/watchdog/rdc321x_wdt.c b/drivers/watchdog/rdc321x_wdt.c
index 3939e53..d8e7250 100644
--- a/drivers/watchdog/rdc321x_wdt.c
+++ b/drivers/watchdog/rdc321x_wdt.c
@@ -37,6 +37,7 @@
 #include <linux/io.h>
 #include <linux/uaccess.h>
 #include <linux/mfd/rdc321x.h>
+#include <linux/mfd/core.h>
 
 #define RDC_WDT_MASK	0x80000000 /* Mask */
 #define RDC_WDT_EN	0x00800000 /* Enable bit */
@@ -231,7 +232,7 @@ static int __devinit rdc321x_wdt_probe(struct platform_device *pdev)
 	struct resource *r;
 	struct rdc321x_wdt_pdata *pdata;
 
-	pdata = platform_get_drvdata(pdev);
+	pdata = mfd_get_data(pdev);
 	if (!pdata) {
 		dev_err(&pdev->dev, "no platform data supplied\n");
 		return -ENODEV;
-- 
1.7.2.3

