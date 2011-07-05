Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756233Ab1GEMDM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 08:03:12 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:51055 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755887Ab1GEMDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 08:03:10 -0400
From: Tommy Lin <tommy.lin.1101@gmail.com>
To: Russell King <linux@arm.linux.org.uk>,
        Anton Vorontsov <avorontsov@mvista.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mac.lin@caviumnetworks.com, Tommy Lin <tommy.lin@caviumnetworks.com>
Subject: [PATCH 1/2] watchdog: Add MPcore watchdog support for cns3xxx SOCs
Date: Tue,  5 Jul 2011 20:03:02 +0800
Message-Id: <1309867382-7806-1-git-send-email-tommy.lin@caviumnetworks.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. Made the connection between CNS3xxx SOCs(ARCH_CNS3xxx) and MPcore watchdog
   since the CNS3xxx SOCs have ARM11 MPcore CPU.
2. Enable mpcore_watchdog option as module to default configuration at
   arch/arm/configs/cns3420vb_defconfig.

Signed-off-by: Tommy Lin <tommy.lin@caviumnetworks.com>
---
 arch/arm/Kconfig                     |    1 +
 arch/arm/configs/cns3420vb_defconfig |    2 ++
 arch/arm/mach-cns3xxx/cns3420vb.c    |   22 ++++++++++++++++++++++
 3 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 9adc278..3262b15 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -326,6 +326,7 @@ config ARCH_CNS3XXX
 	select ARM_GIC
 	select MIGHT_HAVE_PCI
 	select PCI_DOMAINS if PCI
+	select HAVE_ARM_TWD
 	help
 	  Support for Cavium Networks CNS3XXX platform.
 
diff --git a/arch/arm/configs/cns3420vb_defconfig b/arch/arm/configs/cns3420vb_defconfig
index 313627a..bd0a355 100644
--- a/arch/arm/configs/cns3420vb_defconfig
+++ b/arch/arm/configs/cns3420vb_defconfig
@@ -53,6 +53,8 @@ CONFIG_LEGACY_PTY_COUNT=16
 # CONFIG_HW_RANDOM is not set
 # CONFIG_HWMON is not set
 # CONFIG_VGA_CONSOLE is not set
+CONFIG_WATCHDOG=y
+CONFIG_MPCORE_WATCHDOG=m
 # CONFIG_HID_SUPPORT is not set
 # CONFIG_USB_SUPPORT is not set
 CONFIG_MMC=y
diff --git a/arch/arm/mach-cns3xxx/cns3420vb.c b/arch/arm/mach-cns3xxx/cns3420vb.c
index 08e5c87..09f20fe 100644
--- a/arch/arm/mach-cns3xxx/cns3420vb.c
+++ b/arch/arm/mach-cns3xxx/cns3420vb.c
@@ -159,10 +159,32 @@ static struct platform_device cns3xxx_usb_ohci_device = {
 	},
 };
 
+/* Watchdog */
+static struct resource cns3xxx_watchdog_resources[] = {
+	[0] = {
+		.start = CNS3XXX_TC11MP_TWD_BASE,
+		.end   = CNS3XXX_TC11MP_TWD_BASE + PAGE_SIZE - 1,
+		.flags = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start = IRQ_LOCALWDOG,
+		.end   = IRQ_LOCALWDOG,
+		.flags = IORESOURCE_IRQ,
+	}
+};
+
+static struct platform_device cns3xxx_watchdog_device = {
+	.name		= "mpcore_wdt",
+	.id		= -1,
+	.num_resources	= ARRAY_SIZE(cns3xxx_watchdog_resources),
+	.resource	= cns3xxx_watchdog_resources,
+};
+
 /*
  * Initialization
  */
 static struct platform_device *cns3420_pdevs[] __initdata = {
+	&cns3xxx_watchdog_device,
 	&cns3420_nor_pdev,
 	&cns3xxx_usb_ehci_device,
 	&cns3xxx_usb_ohci_device,
-- 
1.7.6

