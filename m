Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751314Ab2LUHQy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 02:16:54 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13588 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804Ab2LUHQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 02:16:50 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 20 Dec 2012 23:16:48 -0800
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: <swarren@wwwdotorg.org>, <stern@rowland.harvard.edu>,
        <gregkh@linuxfoundation.org>, <balbi@ti.com>,
        <linux-usb@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: [PATCH] usb: tegra: Removing dependency on PHY instance number
Date: Fri, 21 Dec 2012 12:28:25 +0530
Message-ID: <1356073105-13043-1-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tegra2 has two varieties of USB PHYs:
Instance 0 - legacy PHY interface and
Instace 1 & 2 - non-legacy standard PHY interfaces.

PHY driver is using instance numbers to identify the
interface type.

With this patch Modified PHY driver to make use of
DT property for handling this.

ULPI PHY is used on USB PHY instance 1 & UTMI is
used on other two instances. Hence modified PHY type
detection also from instance number to the parameter
passed from host driver.

Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
---
As PHY instance 2 is of UTMI type with non legacy interface,
replaced "phy->instance == 2" check in all UTMI functions
with "!phy->is_legacy_mode".


 drivers/usb/host/ehci-tegra.c     |   27 ++-------------
 drivers/usb/phy/tegra_usb_phy.c   |   66 ++++++++++++++++--------------------
 include/linux/usb/tegra_usb_phy.h |    8 +++--
 3 files changed, 38 insertions(+), 63 deletions(-)

diff --git a/drivers/usb/host/ehci-tegra.c b/drivers/usb/host/ehci-tegra.c
index 55a9cde..9876700 100644
--- a/drivers/usb/host/ehci-tegra.c
+++ b/drivers/usb/host/ehci-tegra.c
@@ -615,7 +615,8 @@ static int tegra_ehci_probe(struct platform_device *pdev)
 	struct tegra_ehci_platform_data *pdata;
 	int err = 0;
 	int irq;
-	int instance = pdev->id;
+	const struct device_node *np = pdev->dev.of_node;
+	bool is_legacy_mode;
 
 	pdata = pdev->dev.platform_data;
 	if (!pdata) {
@@ -685,29 +686,9 @@ static int tegra_ehci_probe(struct platform_device *pdev)
 		goto fail_io;
 	}
 
-	/* This is pretty ugly and needs to be fixed when we do only
-	 * device-tree probing. Old code relies on the platform_device
-	 * numbering that we lack for device-tree-instantiated devices.
-	 */
-	if (instance < 0) {
-		switch (res->start) {
-		case TEGRA_USB_BASE:
-			instance = 0;
-			break;
-		case TEGRA_USB2_BASE:
-			instance = 1;
-			break;
-		case TEGRA_USB3_BASE:
-			instance = 2;
-			break;
-		default:
-			err = -ENODEV;
-			dev_err(&pdev->dev, "unknown usb instance\n");
-			goto fail_io;
-		}
-	}
+	is_legacy_mode = of_property_read_bool(np, "nvidia,has-legacy-mode");
 
-	tegra->phy = tegra_usb_phy_open(&pdev->dev, instance, hcd->regs,
+	tegra->phy = tegra_usb_phy_open(&pdev->dev, is_legacy_mode, hcd->regs,
 					pdata->phy_config,
 					TEGRA_USB_PHY_MODE_HOST);
 	if (IS_ERR(tegra->phy)) {
diff --git a/drivers/usb/phy/tegra_usb_phy.c b/drivers/usb/phy/tegra_usb_phy.c
index 9d13c81..9385216 100644
--- a/drivers/usb/phy/tegra_usb_phy.c
+++ b/drivers/usb/phy/tegra_usb_phy.c
@@ -208,11 +208,6 @@ static struct tegra_utmip_config utmip_default[] = {
 	},
 };
 
-static inline bool phy_is_ulpi(struct tegra_usb_phy *phy)
-{
-	return (phy->instance == 1);
-}
-
 static int utmip_pad_open(struct tegra_usb_phy *phy)
 {
 	phy->pad_clk = clk_get_sys("utmip-pad", NULL);
@@ -221,7 +216,7 @@ static int utmip_pad_open(struct tegra_usb_phy *phy)
 		return PTR_ERR(phy->pad_clk);
 	}
 
-	if (phy->instance == 0) {
+	if (phy->is_legacy_mode) {
 		phy->pad_regs = phy->regs;
 	} else {
 		phy->pad_regs = ioremap(TEGRA_USB_BASE, TEGRA_USB_SIZE);
@@ -236,7 +231,7 @@ static int utmip_pad_open(struct tegra_usb_phy *phy)
 
 static void utmip_pad_close(struct tegra_usb_phy *phy)
 {
-	if (phy->instance != 0)
+	if (!phy->is_legacy_mode)
 		iounmap(phy->pad_regs);
 	clk_put(phy->pad_clk);
 }
@@ -305,7 +300,7 @@ static void utmi_phy_clk_disable(struct tegra_usb_phy *phy)
 	unsigned long val;
 	void __iomem *base = phy->regs;
 
-	if (phy->instance == 0) {
+	if (phy->is_legacy_mode) {
 		val = readl(base + USB_SUSP_CTRL);
 		val |= USB_SUSP_SET;
 		writel(val, base + USB_SUSP_CTRL);
@@ -315,9 +310,7 @@ static void utmi_phy_clk_disable(struct tegra_usb_phy *phy)
 		val = readl(base + USB_SUSP_CTRL);
 		val &= ~USB_SUSP_SET;
 		writel(val, base + USB_SUSP_CTRL);
-	}
-
-	if (phy->instance == 2) {
+	} else {
 		val = readl(base + USB_PORTSC1);
 		val |= USB_PORTSC1_PHCD;
 		writel(val, base + USB_PORTSC1);
@@ -332,7 +325,7 @@ static void utmi_phy_clk_enable(struct tegra_usb_phy *phy)
 	unsigned long val;
 	void __iomem *base = phy->regs;
 
-	if (phy->instance == 0) {
+	if (phy->is_legacy_mode) {
 		val = readl(base + USB_SUSP_CTRL);
 		val |= USB_SUSP_CLR;
 		writel(val, base + USB_SUSP_CTRL);
@@ -342,9 +335,7 @@ static void utmi_phy_clk_enable(struct tegra_usb_phy *phy)
 		val = readl(base + USB_SUSP_CTRL);
 		val &= ~USB_SUSP_CLR;
 		writel(val, base + USB_SUSP_CTRL);
-	}
-
-	if (phy->instance == 2) {
+	} else {
 		val = readl(base + USB_PORTSC1);
 		val &= ~USB_PORTSC1_PHCD;
 		writel(val, base + USB_PORTSC1);
@@ -365,7 +356,7 @@ static int utmi_phy_power_on(struct tegra_usb_phy *phy)
 	val |= UTMIP_RESET;
 	writel(val, base + USB_SUSP_CTRL);
 
-	if (phy->instance == 0) {
+	if (phy->is_legacy_mode) {
 		val = readl(base + USB1_LEGACY_CTRL);
 		val |= USB1_NO_LEGACY_MODE;
 		writel(val, base + USB1_LEGACY_CTRL);
@@ -440,16 +431,14 @@ static int utmi_phy_power_on(struct tegra_usb_phy *phy)
 	val |= UTMIP_BIAS_PDTRK_COUNT(0x5);
 	writel(val, base + UTMIP_BIAS_CFG1);
 
-	if (phy->instance == 0) {
+	if (phy->is_legacy_mode) {
 		val = readl(base + UTMIP_SPARE_CFG0);
 		if (phy->mode == TEGRA_USB_PHY_MODE_DEVICE)
 			val &= ~FUSE_SETUP_SEL;
 		else
 			val |= FUSE_SETUP_SEL;
 		writel(val, base + UTMIP_SPARE_CFG0);
-	}
-
-	if (phy->instance == 2) {
+	} else {
 		val = readl(base + USB_SUSP_CTRL);
 		val |= UTMIP_PHY_ENABLE;
 		writel(val, base + USB_SUSP_CTRL);
@@ -459,7 +448,7 @@ static int utmi_phy_power_on(struct tegra_usb_phy *phy)
 	val &= ~UTMIP_RESET;
 	writel(val, base + USB_SUSP_CTRL);
 
-	if (phy->instance == 0) {
+	if (phy->is_legacy_mode) {
 		val = readl(base + USB1_LEGACY_CTRL);
 		val &= ~USB1_VBUS_SENSE_CTL_MASK;
 		val |= USB1_VBUS_SENSE_CTL_A_SESS_VLD;
@@ -472,7 +461,7 @@ static int utmi_phy_power_on(struct tegra_usb_phy *phy)
 
 	utmi_phy_clk_enable(phy);
 
-	if (phy->instance == 2) {
+	if (!phy->is_legacy_mode) {
 		val = readl(base + USB_PORTSC1);
 		val &= ~USB_PORTSC1_PTS(~0);
 		writel(val, base + USB_PORTSC1);
@@ -660,7 +649,7 @@ static int	tegra_phy_init(struct usb_phy *x)
 	struct tegra_ulpi_config *ulpi_config;
 	int err;
 
-	if (phy_is_ulpi(phy)) {
+	if (phy->is_ulpi_phy) {
 		ulpi_config = phy->config;
 		phy->clk = clk_get_sys(NULL, ulpi_config->clk);
 		if (IS_ERR(phy->clk)) {
@@ -698,7 +687,7 @@ static void tegra_usb_phy_close(struct usb_phy *x)
 {
 	struct tegra_usb_phy *phy = container_of(x, struct tegra_usb_phy, u_phy);
 
-	if (phy_is_ulpi(phy))
+	if (phy->is_ulpi_phy)
 		clk_put(phy->clk);
 	else
 		utmip_pad_close(phy);
@@ -709,7 +698,7 @@ static void tegra_usb_phy_close(struct usb_phy *x)
 
 static int tegra_usb_phy_power_on(struct tegra_usb_phy *phy)
 {
-	if (phy_is_ulpi(phy))
+	if (phy->is_ulpi_phy)
 		return ulpi_phy_power_on(phy);
 	else
 		return utmi_phy_power_on(phy);
@@ -717,7 +706,7 @@ static int tegra_usb_phy_power_on(struct tegra_usb_phy *phy)
 
 static int tegra_usb_phy_power_off(struct tegra_usb_phy *phy)
 {
-	if (phy_is_ulpi(phy))
+	if (phy->is_ulpi_phy)
 		return ulpi_phy_power_off(phy);
 	else
 		return utmi_phy_power_off(phy);
@@ -732,31 +721,34 @@ static int	tegra_usb_phy_suspend(struct usb_phy *x, int suspend)
 		return tegra_usb_phy_power_on(phy);
 }
 
-struct tegra_usb_phy *tegra_usb_phy_open(struct device *dev, int instance,
-	void __iomem *regs, void *config, enum tegra_usb_phy_mode phy_mode)
+struct tegra_usb_phy *tegra_usb_phy_open(struct device *dev,
+	bool is_legacy_mode, void __iomem *regs, void *config,
+	enum tegra_usb_phy_mode phy_mode)
 {
 	struct tegra_usb_phy *phy;
 	unsigned long parent_rate;
 	int i;
 	int err;
+	u8 index = is_legacy_mode ? 0 : 2;
 
 	phy = kmalloc(sizeof(struct tegra_usb_phy), GFP_KERNEL);
 	if (!phy)
 		return ERR_PTR(-ENOMEM);
 
-	phy->instance = instance;
+	phy->is_legacy_mode = is_legacy_mode;
 	phy->regs = regs;
 	phy->config = config;
 	phy->mode = phy_mode;
 	phy->dev = dev;
+	phy->is_ulpi_phy = config ? true : false;
 
 	if (!phy->config) {
-		if (phy_is_ulpi(phy)) {
+		if (phy->is_ulpi_phy) {
 			pr_err("%s: ulpi phy configuration missing", __func__);
 			err = -EINVAL;
 			goto err0;
 		} else {
-			phy->config = &utmip_default[instance];
+			phy->config = &utmip_default[index];
 		}
 	}
 
@@ -798,14 +790,14 @@ EXPORT_SYMBOL_GPL(tegra_usb_phy_open);
 
 void tegra_usb_phy_preresume(struct tegra_usb_phy *phy)
 {
-	if (!phy_is_ulpi(phy))
+	if (!phy->is_ulpi_phy)
 		utmi_phy_preresume(phy);
 }
 EXPORT_SYMBOL_GPL(tegra_usb_phy_preresume);
 
 void tegra_usb_phy_postresume(struct tegra_usb_phy *phy)
 {
-	if (!phy_is_ulpi(phy))
+	if (!phy->is_ulpi_phy)
 		utmi_phy_postresume(phy);
 }
 EXPORT_SYMBOL_GPL(tegra_usb_phy_postresume);
@@ -813,28 +805,28 @@ EXPORT_SYMBOL_GPL(tegra_usb_phy_postresume);
 void tegra_ehci_phy_restore_start(struct tegra_usb_phy *phy,
 				 enum tegra_usb_phy_port_speed port_speed)
 {
-	if (!phy_is_ulpi(phy))
+	if (!phy->is_ulpi_phy)
 		utmi_phy_restore_start(phy, port_speed);
 }
 EXPORT_SYMBOL_GPL(tegra_ehci_phy_restore_start);
 
 void tegra_ehci_phy_restore_end(struct tegra_usb_phy *phy)
 {
-	if (!phy_is_ulpi(phy))
+	if (!phy->is_ulpi_phy)
 		utmi_phy_restore_end(phy);
 }
 EXPORT_SYMBOL_GPL(tegra_ehci_phy_restore_end);
 
 void tegra_usb_phy_clk_disable(struct tegra_usb_phy *phy)
 {
-	if (!phy_is_ulpi(phy))
+	if (!phy->is_ulpi_phy)
 		utmi_phy_clk_disable(phy);
 }
 EXPORT_SYMBOL_GPL(tegra_usb_phy_clk_disable);
 
 void tegra_usb_phy_clk_enable(struct tegra_usb_phy *phy)
 {
-	if (!phy_is_ulpi(phy))
+	if (!phy->is_ulpi_phy)
 		utmi_phy_clk_enable(phy);
 }
 EXPORT_SYMBOL_GPL(tegra_usb_phy_clk_enable);
diff --git a/include/linux/usb/tegra_usb_phy.h b/include/linux/usb/tegra_usb_phy.h
index 176b1ca..d065f59 100644
--- a/include/linux/usb/tegra_usb_phy.h
+++ b/include/linux/usb/tegra_usb_phy.h
@@ -47,7 +47,8 @@ enum tegra_usb_phy_mode {
 struct tegra_xtal_freq;
 
 struct tegra_usb_phy {
-	int instance;
+	bool is_legacy_mode;
+	bool is_ulpi_phy;
 	const struct tegra_xtal_freq *freq;
 	void __iomem *regs;
 	void __iomem *pad_regs;
@@ -61,8 +62,9 @@ struct tegra_usb_phy {
 	struct device *dev;
 };
 
-struct tegra_usb_phy *tegra_usb_phy_open(struct device *dev, int instance,
-	void __iomem *regs, void *config, enum tegra_usb_phy_mode phy_mode);
+struct tegra_usb_phy *tegra_usb_phy_open(struct device *dev,
+	bool is_legacy_mode, void __iomem *regs, void *config,
+	enum tegra_usb_phy_mode phy_mode);
 
 void tegra_usb_phy_clk_disable(struct tegra_usb_phy *phy);
 
-- 
1.7.0.4

