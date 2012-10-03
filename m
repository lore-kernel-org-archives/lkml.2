Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932716Ab2JCPOI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 11:14:08 -0400
Received: from zmc.proxad.net ([212.27.53.206]:36954 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932593Ab2JCPN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 11:13:58 -0400
From: Florian Fainelli <florian@openwrt.org>
To: stern@rowland.harvard.edu
Cc: linux-usb@vger.kernel.org, Florian Fainelli <florian@openwrt.org>,
        Anton Vorontsov <avorontsov@mvista.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 16/25] ARM: cns3xxx: use OHCI platform driver
Date: Wed,  3 Oct 2012 17:03:12 +0200
Message-Id: <1349276601-8371-18-git-send-email-florian@openwrt.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349276601-8371-1-git-send-email-florian@openwrt.org>
References: <1349276601-8371-1-git-send-email-florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since both the EHCI and OHCI platform drivers use the same power_{on,off}
callbacks, rename them to cns3xx_usb_power_{on,off} to show that they are
shared.

Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
 arch/arm/mach-cns3xxx/cns3420vb.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-cns3xxx/cns3420vb.c b/arch/arm/mach-cns3xxx/cns3420vb.c
index 906094c..8a00cee8 100644
--- a/arch/arm/mach-cns3xxx/cns3420vb.c
+++ b/arch/arm/mach-cns3xxx/cns3420vb.c
@@ -25,6 +25,7 @@
 #include <linux/mtd/physmap.h>
 #include <linux/mtd/partitions.h>
 #include <linux/usb/ehci_pdriver.h>
+#include <linux/usb/ohci_pdriver.h>
 #include <asm/setup.h>
 #include <asm/mach-types.h>
 #include <asm/hardware/gic.h>
@@ -127,7 +128,7 @@ static struct resource cns3xxx_usb_ehci_resources[] = {
 
 static u64 cns3xxx_usb_ehci_dma_mask = DMA_BIT_MASK(32);
 
-static int csn3xxx_usb_ehci_power_on(struct platform_device *pdev)
+static int csn3xxx_usb_power_on(struct platform_device *pdev)
 {
 	/*
 	 * EHCI and OHCI share the same clock and power,
@@ -148,7 +149,7 @@ static int csn3xxx_usb_ehci_power_on(struct platform_device *pdev)
 	return 0;
 }
 
-static void csn3xxx_usb_ehci_power_off(struct platform_device *pdev)
+static void csn3xxx_usb_power_off(struct platform_device *pdev)
 {
 	/*
 	 * EHCI and OHCI share the same clock and power,
@@ -162,8 +163,8 @@ static void csn3xxx_usb_ehci_power_off(struct platform_device *pdev)
 
 static struct usb_ehci_pdata cns3xxx_usb_ehci_pdata = {
 	.port_power_off	= 1,
-	.power_on	= csn3xxx_usb_ehci_power_on,
-	.power_off	= csn3xxx_usb_ehci_power_off,
+	.power_on	= csn3xxx_usb_power_on,
+	.power_off	= csn3xxx_usb_power_off,
 };
 
 static struct platform_device cns3xxx_usb_ehci_device = {
@@ -191,13 +192,20 @@ static struct resource cns3xxx_usb_ohci_resources[] = {
 
 static u64 cns3xxx_usb_ohci_dma_mask = DMA_BIT_MASK(32);
 
+static struct usb_ohci_pdata cns3xxx_usb_ohci_pdata = {
+	.num_ports	= 1,
+	.power_on	= csn3xxx_usb_power_on,
+	.power_off	= csn3xxx_usb_power_off,
+};
+
 static struct platform_device cns3xxx_usb_ohci_device = {
-	.name          = "cns3xxx-ohci",
+	.name          = "ohci-platform",
 	.num_resources = ARRAY_SIZE(cns3xxx_usb_ohci_resources),
 	.resource      = cns3xxx_usb_ohci_resources,
 	.dev           = {
 		.dma_mask          = &cns3xxx_usb_ohci_dma_mask,
 		.coherent_dma_mask = DMA_BIT_MASK(32),
+		.platform_data	   = &cns3xxx_usb_ohci_pdata,
 	},
 };
 
-- 
1.7.9.5

