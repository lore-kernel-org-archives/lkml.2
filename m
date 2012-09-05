Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756380Ab2IENeq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 09:34:46 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1348 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050Ab2IENeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 09:34:44 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 05 Sep 2012 06:27:40 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: <balbi@ti.com>, <swarren@wwwdotorg.org>
CC: <linux-kernel@vger.kernel.org>, Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: [PATCH] usb: move phy driver from mach-tegra to drivers/usb
Date: Wed, 5 Sep 2012 18:50:23 +0530
Message-ID: <1346851223-29180-1-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As part of this patch:
	1. Moved existing tegra phy driver to drivers/USB directory.
	2. Added standard USB phy driver APIs to tegra phy driver.

Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
---
 arch/arm/mach-tegra/Makefile                       |    1 -
 arch/arm/mach-tegra/devices.c                      |    2 +-
 arch/arm/mach-tegra/devices.h                      |    2 +-
 drivers/usb/host/ehci-tegra.c                      |   14 +-
 drivers/usb/phy/Makefile                           |    1 +
 .../usb_phy.c => drivers/usb/phy/tegra_usb_phy.c   |  152 +++++++++++---------
 .../usb_phy.h => include/linux/usb/tegra_usb_phy.h |   16 +--
 7 files changed, 103 insertions(+), 85 deletions(-)
 rename arch/arm/mach-tegra/usb_phy.c => drivers/usb/phy/tegra_usb_phy.c (94%)
 rename arch/arm/mach-tegra/include/mach/usb_phy.h => include/linux/usb/tegra_usb_phy.h (86%)

diff --git a/arch/arm/mach-tegra/Makefile b/arch/arm/mach-tegra/Makefile
index c3d7303..0e82b7f 100644
--- a/arch/arm/mach-tegra/Makefile
+++ b/arch/arm/mach-tegra/Makefile
@@ -21,7 +21,6 @@ obj-$(CONFIG_HOTPLUG_CPU)               += hotplug.o
 obj-$(CONFIG_TEGRA_SYSTEM_DMA)		+= dma.o
 obj-$(CONFIG_CPU_FREQ)                  += cpu-tegra.o
 obj-$(CONFIG_TEGRA_PCI)			+= pcie.o
-obj-$(CONFIG_USB_SUPPORT)		+= usb_phy.o
 
 obj-$(CONFIG_ARCH_TEGRA_2x_SOC)		+= board-dt-tegra20.o
 obj-$(CONFIG_ARCH_TEGRA_3x_SOC)		+= board-dt-tegra30.o
diff --git a/arch/arm/mach-tegra/devices.c b/arch/arm/mach-tegra/devices.c
index c70e65f..d8ab762 100644
--- a/arch/arm/mach-tegra/devices.c
+++ b/arch/arm/mach-tegra/devices.c
@@ -27,7 +27,7 @@
 #include <mach/irqs.h>
 #include <mach/iomap.h>
 #include <mach/dma.h>
-#include <mach/usb_phy.h>
+#include <linux/usb/tegra_usb_phy.h>
 
 #include "gpio-names.h"
 #include "devices.h"
diff --git a/arch/arm/mach-tegra/devices.h b/arch/arm/mach-tegra/devices.h
index 4f50527..906a61f 100644
--- a/arch/arm/mach-tegra/devices.h
+++ b/arch/arm/mach-tegra/devices.h
@@ -22,7 +22,7 @@
 #include <linux/platform_device.h>
 #include <linux/platform_data/tegra_usb.h>
 
-#include <mach/usb_phy.h>
+#include <linux/usb/tegra_usb_phy.h>
 
 extern struct tegra_ulpi_config tegra_ehci2_ulpi_phy_config;
 
diff --git a/drivers/usb/host/ehci-tegra.c b/drivers/usb/host/ehci-tegra.c
index 26dedb3..c0d4732 100644
--- a/drivers/usb/host/ehci-tegra.c
+++ b/drivers/usb/host/ehci-tegra.c
@@ -27,7 +27,7 @@
 #include <linux/of_gpio.h>
 #include <linux/pm_runtime.h>
 
-#include <mach/usb_phy.h>
+#include <linux/usb/tegra_usb_phy.h>
 #include <mach/iomap.h>
 
 #define TEGRA_USB_DMA_ALIGN 32
@@ -49,7 +49,7 @@ static void tegra_ehci_power_up(struct usb_hcd *hcd)
 
 	clk_prepare_enable(tegra->emc_clk);
 	clk_prepare_enable(tegra->clk);
-	tegra_usb_phy_power_on(tegra->phy);
+	usb_phy_set_suspend(&tegra->phy->u_phy, 0);
 	tegra->host_resumed = 1;
 }
 
@@ -58,7 +58,7 @@ static void tegra_ehci_power_down(struct usb_hcd *hcd)
 	struct tegra_ehci_hcd *tegra = dev_get_drvdata(hcd->self.controller);
 
 	tegra->host_resumed = 0;
-	tegra_usb_phy_power_off(tegra->phy);
+	usb_phy_set_suspend(&tegra->phy->u_phy, 1);
 	clk_disable_unprepare(tegra->clk);
 	clk_disable_unprepare(tegra->emc_clk);
 }
@@ -715,7 +715,9 @@ static int tegra_ehci_probe(struct platform_device *pdev)
 		goto fail_phy;
 	}
 
-	err = tegra_usb_phy_power_on(tegra->phy);
+	usb_phy_init(&tegra->phy->u_phy);
+
+	err = usb_phy_set_suspend(&tegra->phy->u_phy, 0);
 	if (err) {
 		dev_err(&pdev->dev, "Failed to power on the phy\n");
 		goto fail;
@@ -762,7 +764,7 @@ fail:
 		usb_put_phy(tegra->transceiver);
 	}
 #endif
-	tegra_usb_phy_close(tegra->phy);
+	usb_phy_shutdown(&tegra->phy->u_phy);
 fail_phy:
 	iounmap(hcd->regs);
 fail_io:
@@ -800,7 +802,7 @@ static int tegra_ehci_remove(struct platform_device *pdev)
 
 	usb_remove_hcd(hcd);
 
-	tegra_usb_phy_close(tegra->phy);
+	usb_phy_shutdown(&tegra->phy->u_phy);
 	iounmap(hcd->regs);
 
 	usb_put_hcd(hcd);
diff --git a/drivers/usb/phy/Makefile b/drivers/usb/phy/Makefile
index cf38f08..bb948fb 100644
--- a/drivers/usb/phy/Makefile
+++ b/drivers/usb/phy/Makefile
@@ -6,3 +6,4 @@ ccflags-$(CONFIG_USB_DEBUG) := -DDEBUG
 
 obj-$(CONFIG_USB_ISP1301)		+= isp1301.o
 obj-$(CONFIG_MV_U3D_PHY)		+= mv_u3d_phy.o
+obj-$(CONFIG_USB_EHCI_TEGRA)	+= tegra_usb_phy.o
diff --git a/arch/arm/mach-tegra/usb_phy.c b/drivers/usb/phy/tegra_usb_phy.c
similarity index 94%
rename from arch/arm/mach-tegra/usb_phy.c
rename to drivers/usb/phy/tegra_usb_phy.c
index 022b33a..4739903 100644
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
+#include <linux/usb/tegra_usb_phy.h>
 #include <mach/iomap.h>
 
 #define ULPI_VIEWPORT		0x170
@@ -482,7 +480,7 @@ static int utmi_phy_power_on(struct tegra_usb_phy *phy)
 	return 0;
 }
 
-static void utmi_phy_power_off(struct tegra_usb_phy *phy)
+static int utmi_phy_power_off(struct tegra_usb_phy *phy)
 {
 	unsigned long val;
 	void __iomem *base = phy->regs;
@@ -514,7 +512,7 @@ static void utmi_phy_power_off(struct tegra_usb_phy *phy)
 	       UTMIP_FORCE_PDDR_POWERDOWN;
 	writel(val, base + UTMIP_XCVR_CFG1);
 
-	utmip_pad_power_off(phy);
+	return utmip_pad_power_off(phy);
 }
 
 static void utmi_phy_preresume(struct tegra_usb_phy *phy)
@@ -638,7 +636,7 @@ static int ulpi_phy_power_on(struct tegra_usb_phy *phy)
 	return 0;
 }
 
-static void ulpi_phy_power_off(struct tegra_usb_phy *phy)
+static int ulpi_phy_power_off(struct tegra_usb_phy *phy)
 {
 	unsigned long val;
 	void __iomem *base = phy->regs;
@@ -651,15 +649,92 @@ static void ulpi_phy_power_off(struct tegra_usb_phy *phy)
 	val &= ~(USB_PORTSC1_WKOC | USB_PORTSC1_WKDS | USB_PORTSC1_WKCN);
 	writel(val, base + USB_PORTSC1);
 
-	gpio_direction_output(config->reset_gpio, 0);
 	clk_disable(phy->clk);
+	return gpio_direction_output(config->reset_gpio, 0);
+}
+
+static int	tegra_phy_init(struct usb_phy *x)
+{
+	struct tegra_usb_phy *phy = container_of(x, struct tegra_usb_phy, u_phy);
+	struct tegra_ulpi_config *ulpi_config;
+	int err;
+
+	if (phy_is_ulpi(phy)) {
+		ulpi_config = phy->config;
+		phy->clk = clk_get_sys(NULL, ulpi_config->clk);
+		if (IS_ERR(phy->clk)) {
+			pr_err("%s: can't get ulpi clock\n", __func__);
+			err = -ENXIO;
+			goto err1;
+		}
+		if (!gpio_is_valid(ulpi_config->reset_gpio))
+			ulpi_config->reset_gpio =
+				of_get_named_gpio(phy->dev->of_node,
+						  "nvidia,phy-reset-gpio", 0);
+		if (!gpio_is_valid(ulpi_config->reset_gpio)) {
+			pr_err("%s: invalid reset gpio: %d\n", __func__,
+			       ulpi_config->reset_gpio);
+			err = -EINVAL;
+			goto err1;
+		}
+		gpio_request(ulpi_config->reset_gpio, "ulpi_phy_reset_b");
+		gpio_direction_output(ulpi_config->reset_gpio, 0);
+		phy->ulpi = otg_ulpi_create(&ulpi_viewport_access_ops, 0);
+		phy->ulpi->io_priv = phy->regs + ULPI_VIEWPORT;
+	} else {
+		err = utmip_pad_open(phy);
+		if (err < 0)
+			goto err1;
+	}
+	return 0;
+err1:
+	clk_disable_unprepare(phy->pll_u);
+	clk_put(phy->pll_u);
+	return err;
+}
+
+static void tegra_usb_phy_close(struct usb_phy *x)
+{
+	struct tegra_usb_phy *phy = container_of(x, struct tegra_usb_phy, u_phy);
+
+	if (phy_is_ulpi(phy))
+		clk_put(phy->clk);
+	else
+		utmip_pad_close(phy);
+	clk_disable_unprepare(phy->pll_u);
+	clk_put(phy->pll_u);
+	kfree(phy);
+}
+
+static int tegra_usb_phy_power_on(struct tegra_usb_phy *phy)
+{
+	if (phy_is_ulpi(phy))
+		return ulpi_phy_power_on(phy);
+	else
+		return utmi_phy_power_on(phy);
+}
+
+static int tegra_usb_phy_power_off(struct tegra_usb_phy *phy)
+{
+	if (phy_is_ulpi(phy))
+		return ulpi_phy_power_off(phy);
+	else
+		return utmi_phy_power_off(phy);
+}
+
+static int	tegra_usb_phy_suspend(struct usb_phy *x, int suspend)
+{
+	struct tegra_usb_phy *phy = container_of(x, struct tegra_usb_phy, u_phy);
+	if (suspend)
+		return tegra_usb_phy_power_off(phy);
+	else
+		return tegra_usb_phy_power_on(phy);
 }
 
 struct tegra_usb_phy *tegra_usb_phy_open(struct device *dev, int instance,
 	void __iomem *regs, void *config, enum tegra_usb_phy_mode phy_mode)
 {
 	struct tegra_usb_phy *phy;
-	struct tegra_ulpi_config *ulpi_config;
 	unsigned long parent_rate;
 	int i;
 	int err;
@@ -672,6 +747,7 @@ struct tegra_usb_phy *tegra_usb_phy_open(struct device *dev, int instance,
 	phy->regs = regs;
 	phy->config = config;
 	phy->mode = phy_mode;
+	phy->dev = dev;
 
 	if (!phy->config) {
 		if (phy_is_ulpi(phy)) {
@@ -704,33 +780,9 @@ struct tegra_usb_phy *tegra_usb_phy_open(struct device *dev, int instance,
 		goto err1;
 	}
 
-	if (phy_is_ulpi(phy)) {
-		ulpi_config = config;
-		phy->clk = clk_get_sys(NULL, ulpi_config->clk);
-		if (IS_ERR(phy->clk)) {
-			pr_err("%s: can't get ulpi clock\n", __func__);
-			err = -ENXIO;
-			goto err1;
-		}
-		if (!gpio_is_valid(ulpi_config->reset_gpio))
-			ulpi_config->reset_gpio =
-				of_get_named_gpio(dev->of_node,
-						  "nvidia,phy-reset-gpio", 0);
-		if (!gpio_is_valid(ulpi_config->reset_gpio)) {
-			pr_err("%s: invalid reset gpio: %d\n", __func__,
-			       ulpi_config->reset_gpio);
-			err = -EINVAL;
-			goto err1;
-		}
-		gpio_request(ulpi_config->reset_gpio, "ulpi_phy_reset_b");
-		gpio_direction_output(ulpi_config->reset_gpio, 0);
-		phy->ulpi = otg_ulpi_create(&ulpi_viewport_access_ops, 0);
-		phy->ulpi->io_priv = regs + ULPI_VIEWPORT;
-	} else {
-		err = utmip_pad_open(phy);
-		if (err < 0)
-			goto err1;
-	}
+	phy->u_phy.init = tegra_phy_init;
+	phy->u_phy.shutdown = tegra_usb_phy_close;
+	phy->u_phy.set_suspend = tegra_usb_phy_suspend;
 
 	return phy;
 
@@ -743,24 +795,6 @@ err0:
 }
 EXPORT_SYMBOL_GPL(tegra_usb_phy_open);
 
-int tegra_usb_phy_power_on(struct tegra_usb_phy *phy)
-{
-	if (phy_is_ulpi(phy))
-		return ulpi_phy_power_on(phy);
-	else
-		return utmi_phy_power_on(phy);
-}
-EXPORT_SYMBOL_GPL(tegra_usb_phy_power_on);
-
-void tegra_usb_phy_power_off(struct tegra_usb_phy *phy)
-{
-	if (phy_is_ulpi(phy))
-		ulpi_phy_power_off(phy);
-	else
-		utmi_phy_power_off(phy);
-}
-EXPORT_SYMBOL_GPL(tegra_usb_phy_power_off);
-
 void tegra_usb_phy_preresume(struct tegra_usb_phy *phy)
 {
 	if (!phy_is_ulpi(phy))
@@ -803,15 +837,3 @@ void tegra_usb_phy_clk_enable(struct tegra_usb_phy *phy)
 		utmi_phy_clk_enable(phy);
 }
 EXPORT_SYMBOL_GPL(tegra_usb_phy_clk_enable);
-
-void tegra_usb_phy_close(struct tegra_usb_phy *phy)
-{
-	if (phy_is_ulpi(phy))
-		clk_put(phy->clk);
-	else
-		utmip_pad_close(phy);
-	clk_disable_unprepare(phy->pll_u);
-	clk_put(phy->pll_u);
-	kfree(phy);
-}
-EXPORT_SYMBOL_GPL(tegra_usb_phy_close);
diff --git a/arch/arm/mach-tegra/include/mach/usb_phy.h b/include/linux/usb/tegra_usb_phy.h
similarity index 86%
rename from arch/arm/mach-tegra/include/mach/usb_phy.h
rename to include/linux/usb/tegra_usb_phy.h
index 935ce9f..176b1ca 100644
--- a/arch/arm/mach-tegra/include/mach/usb_phy.h
+++ b/include/linux/usb/tegra_usb_phy.h
@@ -1,6 +1,4 @@
 /*
- * arch/arm/mach-tegra/include/mach/usb_phy.h
- *
  * Copyright (C) 2010 Google, Inc.
  *
  * This software is licensed under the terms of the GNU General Public
@@ -14,8 +12,8 @@
  *
  */
 
-#ifndef __MACH_USB_PHY_H
-#define __MACH_USB_PHY_H
+#ifndef __TEGRA_USB_PHY_H
+#define __TEGRA_USB_PHY_H
 
 #include <linux/clk.h>
 #include <linux/usb/otg.h>
@@ -59,19 +57,17 @@ struct tegra_usb_phy {
 	enum tegra_usb_phy_mode mode;
 	void *config;
 	struct usb_phy *ulpi;
+	struct usb_phy u_phy;
+	struct device *dev;
 };
 
 struct tegra_usb_phy *tegra_usb_phy_open(struct device *dev, int instance,
 	void __iomem *regs, void *config, enum tegra_usb_phy_mode phy_mode);
 
-int tegra_usb_phy_power_on(struct tegra_usb_phy *phy);
-
 void tegra_usb_phy_clk_disable(struct tegra_usb_phy *phy);
 
 void tegra_usb_phy_clk_enable(struct tegra_usb_phy *phy);
 
-void tegra_usb_phy_power_off(struct tegra_usb_phy *phy);
-
 void tegra_usb_phy_preresume(struct tegra_usb_phy *phy);
 
 void tegra_usb_phy_postresume(struct tegra_usb_phy *phy);
@@ -81,6 +77,4 @@ void tegra_ehci_phy_restore_start(struct tegra_usb_phy *phy,
 
 void tegra_ehci_phy_restore_end(struct tegra_usb_phy *phy);
 
-void tegra_usb_phy_close(struct tegra_usb_phy *phy);
-
-#endif /* __MACH_USB_PHY_H */
+#endif /* __TEGRA_USB_PHY_H */
-- 
1.7.1.1

