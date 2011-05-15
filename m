Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759975Ab1EOLed (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 07:34:33 -0400
Received: from londo.lunn.ch ([80.238.139.98]:59455 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758548Ab1EOLea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 07:34:30 -0400
From: Andrew Lunn <andrew@lunn.ch>
To: kernel@wantstofly.org, nico@fluxnic.net
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        saeed.bishara@gmail.com, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCHv2 08/15] [orion] Consolidate the platform data setup for the watchdog.
Date: Sun, 15 May 2011 13:32:47 +0200
Message-Id: <1305459174-25517-9-git-send-email-andrew@lunn.ch>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1305459174-25517-1-git-send-email-andrew@lunn.ch>
References: <1305459174-25517-1-git-send-email-andrew@lunn.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 arch/arm/mach-kirkwood/common.c           |   17 +----------------
 arch/arm/mach-orion5x/common.c            |   17 +----------------
 arch/arm/plat-orion/common.c              |   21 +++++++++++++++++++++
 arch/arm/plat-orion/include/plat/common.h |    2 ++
 4 files changed, 25 insertions(+), 32 deletions(-)

diff --git a/arch/arm/mach-kirkwood/common.c b/arch/arm/mach-kirkwood/common.c
index af864fc..08847a6 100644
--- a/arch/arm/mach-kirkwood/common.c
+++ b/arch/arm/mach-kirkwood/common.c
@@ -29,7 +29,6 @@
 #include <plat/mvsdio.h>
 #include <plat/mv_xor.h>
 #include <plat/orion_nand.h>
-#include <plat/orion_wdt.h>
 #include <plat/common.h>
 #include <plat/time.h>
 #include "common.h"
@@ -575,23 +574,9 @@ static void __init kirkwood_xor1_init(void)
 /*****************************************************************************
  * Watchdog
  ****************************************************************************/
-static struct orion_wdt_platform_data kirkwood_wdt_data = {
-	.tclk		= 0,
-};
-
-static struct platform_device kirkwood_wdt_device = {
-	.name		= "orion_wdt",
-	.id		= -1,
-	.dev		= {
-		.platform_data	= &kirkwood_wdt_data,
-	},
-	.num_resources	= 0,
-};
-
 static void __init kirkwood_wdt_init(void)
 {
-	kirkwood_wdt_data.tclk = kirkwood_tclk;
-	platform_device_register(&kirkwood_wdt_device);
+	orion_wdt_init(kirkwood_tclk);
 }
 
 
diff --git a/arch/arm/mach-orion5x/common.c b/arch/arm/mach-orion5x/common.c
index d2dee43..c26e6db 100644
--- a/arch/arm/mach-orion5x/common.c
+++ b/arch/arm/mach-orion5x/common.c
@@ -30,7 +30,6 @@
 #include <plat/ehci-orion.h>
 #include <plat/mv_xor.h>
 #include <plat/orion_nand.h>
-#include <plat/orion_wdt.h>
 #include <plat/time.h>
 #include <plat/common.h>
 #include "common.h"
@@ -380,23 +379,9 @@ static int __init orion5x_crypto_init(void)
 /*****************************************************************************
  * Watchdog
  ****************************************************************************/
-static struct orion_wdt_platform_data orion5x_wdt_data = {
-	.tclk			= 0,
-};
-
-static struct platform_device orion5x_wdt_device = {
-	.name		= "orion_wdt",
-	.id		= -1,
-	.dev		= {
-		.platform_data	= &orion5x_wdt_data,
-	},
-	.num_resources	= 0,
-};
-
 void __init orion5x_wdt_init(void)
 {
-	orion5x_wdt_data.tclk = orion5x_tclk;
-	platform_device_register(&orion5x_wdt_device);
+	orion_wdt_init(orion5x_tclk);
 }
 
 
diff --git a/arch/arm/plat-orion/common.c b/arch/arm/plat-orion/common.c
index 2afe79d..6502209 100644
--- a/arch/arm/plat-orion/common.c
+++ b/arch/arm/plat-orion/common.c
@@ -18,6 +18,7 @@
 #include <linux/mv643xx_i2c.h>
 #include <net/dsa.h>
 #include <linux/spi/orion_spi.h>
+#include <plat/orion_wdt.h>
 
 /* Fill in the resources structure and link it into the platform
    device structure. There is always a memory region, and nearly
@@ -564,3 +565,23 @@ void __init orion_spi_1_init(unsigned long mapbase,
 		       mapbase, SZ_512 - 1, NO_IRQ);
 	platform_device_register(&orion_spi_1);
 }
+
+/*****************************************************************************
+ * Watchdog
+ ****************************************************************************/
+static struct orion_wdt_platform_data orion_wdt_data;
+
+static struct platform_device orion_wdt_device = {
+	.name		= "orion_wdt",
+	.id		= -1,
+	.dev		= {
+		.platform_data	= &orion_wdt_data,
+	},
+	.num_resources	= 0,
+};
+
+void __init orion_wdt_init(unsigned long tclk)
+{
+	orion_wdt_data.tclk = tclk;
+	platform_device_register(&orion_wdt_device);
+}
diff --git a/arch/arm/plat-orion/include/plat/common.h b/arch/arm/plat-orion/include/plat/common.h
index e72c146..38ae4bf 100644
--- a/arch/arm/plat-orion/include/plat/common.h
+++ b/arch/arm/plat-orion/include/plat/common.h
@@ -79,4 +79,6 @@ void __init orion_spi_init(unsigned long mapbase,
 
 void __init orion_spi_1_init(unsigned long mapbase,
 			     unsigned long tclk);
+
+void __init orion_wdt_init(unsigned long tclk);
 #endif
-- 
1.7.4.4

