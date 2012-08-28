Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182Ab2H1JoW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 05:44:22 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:13927 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346Ab2H1JoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 05:44:20 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 28 Aug 2012 02:44:19 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: <ccross@android.com>, <olof@lixom.net>, <swarren@wwwdotorg.org>,
        <linux@arm.linux.org.uk>, <stern@rowland.harvard.edu>,
        <gregkh@linuxfoundation.org>, <balbi@ti.com>
CC: <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: [PATCH] usb: tegra: moving phy driver into drivers directory
Date: Tue, 28 Aug 2012 15:02:18 +0530
Message-ID: <1346146338-4996-1-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to keep up with the USB driver files organization,
moving USB phy driver from mach-tegra to drivers/USB directory.

Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
---
 arch/arm/mach-tegra/Makefile                       |    1 -
 arch/arm/mach-tegra/devices.c                      |    8 +-------
 arch/arm/mach-tegra/devices.h                      |    2 --
 drivers/usb/host/ehci-tegra.c                      |    2 +-
 drivers/usb/phy/Makefile                           |    1 +
 .../usb_phy.c => drivers/usb/phy/tegra_usb_phy.c   |    4 +---
 .../usb_phy.h => drivers/usb/phy/tegra_usb_phy.h   |    2 --
 7 files changed, 4 insertions(+), 16 deletions(-)
 rename arch/arm/mach-tegra/usb_phy.c => drivers/usb/phy/tegra_usb_phy.c (99%)
 rename arch/arm/mach-tegra/include/mach/usb_phy.h => drivers/usb/phy/tegra_usb_phy.h (97%)

diff --git a/arch/arm/mach-tegra/Makefile b/arch/arm/mach-tegra/Makefile
index b94858f..b542dac 100644
--- a/arch/arm/mach-tegra/Makefile
+++ b/arch/arm/mach-tegra/Makefile
@@ -25,7 +25,6 @@ obj-$(CONFIG_HOTPLUG_CPU)               += hotplug.o
 obj-$(CONFIG_TEGRA_SYSTEM_DMA)		+= dma.o
 obj-$(CONFIG_CPU_FREQ)                  += cpu-tegra.o
 obj-$(CONFIG_TEGRA_PCI)			+= pcie.o
-obj-$(CONFIG_USB_SUPPORT)		+= usb_phy.o
 
 obj-$(CONFIG_ARCH_TEGRA_2x_SOC)		+= board-dt-tegra20.o
 obj-$(CONFIG_ARCH_TEGRA_3x_SOC)		+= board-dt-tegra30.o
diff --git a/arch/arm/mach-tegra/devices.c b/arch/arm/mach-tegra/devices.c
index 61e9603..232d7e1 100644
--- a/arch/arm/mach-tegra/devices.c
+++ b/arch/arm/mach-tegra/devices.c
@@ -26,7 +26,6 @@
 #include <mach/irqs.h>
 #include <mach/iomap.h>
 #include <mach/dma.h>
-#include <mach/usb_phy.h>
 
 #include "gpio-names.h"
 #include "devices.h"
@@ -438,11 +437,6 @@ static struct resource tegra_usb3_resources[] = {
 	},
 };
 
-struct tegra_ulpi_config tegra_ehci2_ulpi_phy_config = {
-	.reset_gpio = -1,
-	.clk = "cdev2",
-};
-
 struct tegra_ehci_platform_data tegra_ehci1_pdata = {
 	.operating_mode = TEGRA_USB_OTG,
 	.power_down_on_bus_suspend = 1,
@@ -450,7 +444,7 @@ struct tegra_ehci_platform_data tegra_ehci1_pdata = {
 };
 
 struct tegra_ehci_platform_data tegra_ehci2_pdata = {
-	.phy_config = &tegra_ehci2_ulpi_phy_config,
+	.phy_config = NULL,
 	.operating_mode = TEGRA_USB_HOST,
 	.power_down_on_bus_suspend = 1,
 	.vbus_gpio = -1,
diff --git a/arch/arm/mach-tegra/devices.h b/arch/arm/mach-tegra/devices.h
index 4f50527..6bac5e6 100644
--- a/arch/arm/mach-tegra/devices.h
+++ b/arch/arm/mach-tegra/devices.h
@@ -22,8 +22,6 @@
 #include <linux/platform_device.h>
 #include <linux/platform_data/tegra_usb.h>
 
-#include <mach/usb_phy.h>
-
 extern struct tegra_ulpi_config tegra_ehci2_ulpi_phy_config;
 
 extern struct tegra_ehci_platform_data tegra_ehci1_pdata;
diff --git a/drivers/usb/host/ehci-tegra.c b/drivers/usb/host/ehci-tegra.c
index 75eca42..a03e279 100644
--- a/drivers/usb/host/ehci-tegra.c
+++ b/drivers/usb/host/ehci-tegra.c
@@ -27,7 +27,7 @@
 #include <linux/of_gpio.h>
 #include <linux/pm_runtime.h>
 
-#include <mach/usb_phy.h>
+#include "../phy/tegra_usb_phy.h"
 #include <mach/iomap.h>
 
 #define TEGRA_USB_DMA_ALIGN 32
diff --git a/drivers/usb/phy/Makefile b/drivers/usb/phy/Makefile
index eca095b..663164f 100644
--- a/drivers/usb/phy/Makefile
+++ b/drivers/usb/phy/Makefile
@@ -5,3 +5,4 @@
 ccflags-$(CONFIG_USB_DEBUG) := -DDEBUG
 
 obj-$(CONFIG_USB_ISP1301)		+= isp1301.o
+obj-$(CONFIG_USB_EHCI_TEGRA)		+= tegra_usb_phy.o
diff --git a/arch/arm/mach-tegra/usb_phy.c b/drivers/usb/phy/tegra_usb_phy.c
similarity index 99%
rename from arch/arm/mach-tegra/usb_phy.c
rename to drivers/usb/phy/tegra_usb_phy.c
index 022b33a..c856716 100644
--- a/arch/arm/mach-tegra/usb_phy.c
+++ b/drivers/usb/phy/tegra_usb_phy.c
@@ -1,6 +1,4 @@
 /*
- * arch/arm/mach-tegra/usb_phy.c
- *
  * Copyright (C) 2010 Google, Inc.
  *
  * Author:
@@ -31,7 +29,7 @@
 #include <linux/usb/ulpi.h>
 #include <asm/mach-types.h>
 #include <mach/gpio-tegra.h>
-#include <mach/usb_phy.h>
+#include "tegra_usb_phy.h"
 #include <mach/iomap.h>
 
 #define ULPI_VIEWPORT		0x170
diff --git a/arch/arm/mach-tegra/include/mach/usb_phy.h b/drivers/usb/phy/tegra_usb_phy.h
similarity index 97%
rename from arch/arm/mach-tegra/include/mach/usb_phy.h
rename to drivers/usb/phy/tegra_usb_phy.h
index 935ce9f..516c724 100644
--- a/arch/arm/mach-tegra/include/mach/usb_phy.h
+++ b/drivers/usb/phy/tegra_usb_phy.h
@@ -1,6 +1,4 @@
 /*
- * arch/arm/mach-tegra/include/mach/usb_phy.h
- *
  * Copyright (C) 2010 Google, Inc.
  *
  * This software is licensed under the terms of the GNU General Public
-- 
1.7.1.1

