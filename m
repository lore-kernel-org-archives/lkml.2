Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050Ab1GUVVJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 17:21:09 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:15374 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753902Ab1GUVVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 17:21:02 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 21 Jul 2011 14:21:01 -0700
From: <achew@nvidia.com>
To: <grant.likely@secretlab.ca>, <olof@lixom.net>, <swarren@nvidia.com>,
        <dwillemsen@nvidia.com>, <rklein@nvidia.com>, <mogantyv@nvidia.com>
CC: <devicetree-discuss@lists.ozlabs.org>, <linux-tegra@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Andrew Chew <achew@nvidia.com>
Subject: [PATCH 1/3 v4] usb: tegra20-ehci: Add devicetree support.
Date: Thu, 21 Jul 2011 14:17:45 -0700
Message-ID: <1311283067-18952-1-git-send-email-achew@nvidia.com>
X-Mailer: git-send-email 1.7.6
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Chew <achew@nvidia.com>

Add code to try to get platform data information (register base, irq,
modes, various tuning parameters) from device tree, if not present in board
files.

Signed-off-by: Andrew Chew <achew@nvidia.com>
Acked-by: Stephen Warren <swarren@nvidia.com>
---
Applied Olof Johansson's comments:
- Use direct assignment when copying default config structs.
- Use __devinitdata for static default config structs.
- Don't compile the default config structs if CONFIG_OF is disabled, to avoid
  a warning.

 .../devicetree/bindings/usb/tegra20-ehci.txt       |   27 +++
 drivers/usb/host/ehci-tegra.c                      |  189 ++++++++++++++++++++
 2 files changed, 216 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/usb/tegra20-ehci.txt

diff --git a/Documentation/devicetree/bindings/usb/tegra20-ehci.txt b/Documentation/devicetree/bindings/usb/tegra20-ehci.txt
new file mode 100644
index 0000000..315ea6e
--- /dev/null
+++ b/Documentation/devicetree/bindings/usb/tegra20-ehci.txt
@@ -0,0 +1,27 @@
+NVIDIA Tegra20 SOC USB controllers
+
+The device node for a USB controller that is part of a Tegra20
+SOC is as described in the document "Open Firmware Recommended
+Practice: Universal Serial Bus" with the following modifications
+and additions:
+
+Required properties:
+ - compatible: Should be "nvidia,tegra20-ehci".
+ - phy-type: Should be one of "utmi" or "ulpi".  Defaults to utmi.
+ - dr-mode: Should be one of "peripheral", "host", or "otg".  Defaults to host.
+ - power-down-on-bus-suspend: For host mode only.  If present, then
+   the USB phy will power down when the host is suspended.
+
+Required properties for phy-type = "utmi".  These values are derived from
+characterization by system engineering.
+ - nvidia,hssync-start-delay: Defaults to 9.
+ - nvidia,idle-wait-delay: Defaults to 17.
+ - nvidia,elastic-limit: Defaults to 16.
+ - nvidia,term-range-adj: Defaults to 6.
+ - nvidia,xcvr-setup: Defaults to 9.
+ - nvidia,xcvr-lsfslew: Defaults to 2.
+ - nvidia,xcvr-lsrslew: Defaults to 2.
+
+Required properties for phy-type = "ulpi":
+ - reset-gpio: The GPIO used to drive reset.  Defaults to 169.
+ - clk: Defaults to "cdev2".
diff --git a/drivers/usb/host/ehci-tegra.c b/drivers/usb/host/ehci-tegra.c
index 02b2bfd..d7295eb 100644
--- a/drivers/usb/host/ehci-tegra.c
+++ b/drivers/usb/host/ehci-tegra.c
@@ -21,10 +21,34 @@
 #include <linux/platform_data/tegra_usb.h>
 #include <linux/irq.h>
 #include <linux/usb/otg.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/of_platform.h>
+
 #include <mach/usb_phy.h>
 
 #define TEGRA_USB_DMA_ALIGN 32
 
+static u64 tegra_ehci_dmamask = DMA_BIT_MASK(TEGRA_USB_DMA_ALIGN);
+
+#if defined(CONFIG_OF)
+static struct tegra_utmip_config utmi_default __devinitdata = {
+	.hssync_start_delay = 9,
+	.idle_wait_delay = 17,
+	.elastic_limit = 16,
+	.term_range_adj = 6,
+	.xcvr_setup = 9,
+	.xcvr_lsfslew = 2,
+	.xcvr_lsrslew = 2,
+};
+
+static struct tegra_ulpi_config ulpi_default __devinitdata = {
+	.reset_gpio = 169,
+	.clk = "cdev2",
+};
+#endif
+
 struct tegra_ehci_hcd {
 	struct ehci_hcd *ehci;
 	struct tegra_usb_phy *phy;
@@ -574,9 +598,155 @@ static const struct hc_driver tegra_ehci_hc_driver = {
 	.port_handed_over	= ehci_port_handed_over,
 };
 
+#if defined(CONFIG_OF)
+static int tegra_ehci_parse_dt_node_utmi(struct device_node *dn,
+					 struct platform_device *pdev,
+					 struct tegra_ehci_platform_data *pdata)
+{
+	struct device *dev = &pdev->dev;
+	struct tegra_utmip_config *phy_config;
+	u32 val;
+
+	phy_config = devm_kzalloc(dev, sizeof(struct tegra_utmip_config),
+				  GFP_KERNEL);
+	if (!phy_config)
+		return -ENOMEM;
+
+	/* Copy default values. */
+	*phy_config = utmi_default;
+
+	/* Values can be overridden from their defaults. */
+	if (of_property_read_u32(dn, "nvidia,hssync-start-delay", &val) == 0)
+		phy_config->hssync_start_delay = val;
+
+	if (of_property_read_u32(dn, "nvidia,elastic-limit", &val) == 0)
+		phy_config->elastic_limit = val;
+
+	if (of_property_read_u32(dn, "nvidia,idle-wait-delay", &val) == 0)
+		phy_config->idle_wait_delay = val;
+
+	if (of_property_read_u32(dn, "nvidia,term-range-adj", &val) == 0)
+		phy_config->term_range_adj = val;
+
+	if (of_property_read_u32(dn, "nvidia,xcvr-setup", &val) == 0)
+		phy_config->xcvr_setup = val;
+
+	if (of_property_read_u32(dn, "nvidia,xcvr-lsfslew", &val) == 0)
+		phy_config->xcvr_lsfslew = val;
+
+	if (of_property_read_u32(dn, "nvidia,xcvr-lsrslew", &val) == 0)
+		phy_config->xcvr_lsrslew = val;
+
+	pdata->phy_config = phy_config;
+
+	return 0;
+}
+
+static int tegra_ehci_parse_dt_node_ulpi(struct device_node *dn,
+					 struct platform_device *pdev,
+					 struct tegra_ehci_platform_data *pdata)
+{
+	struct device *dev = &pdev->dev;
+	struct tegra_ulpi_config *phy_config;
+	u32 val;
+	char *sval;
+
+	phy_config = devm_kzalloc(dev, sizeof(struct tegra_ulpi_config),
+				  GFP_KERNEL);
+	if (!phy_config)
+		return -ENOMEM;
+
+	/* Copy default values. */
+	*phy_config = ulpi_default;
+
+	/* Values can be overridden from their defaults. */
+	if (of_property_read_u32(dn, "reset-gpio", &val) == 0)
+		phy_config->reset_gpio = val;
+
+	if (of_property_read_string(dn, "clk", &sval) == 0)
+		phy_config->clk = sval;
+
+	pdata->phy_config = phy_config;
+
+	return 0;
+}
+
+static struct tegra_ehci_platform_data *tegra_ehci_parse_dt_node(
+	struct device_node *dn,
+	struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct tegra_ehci_platform_data *pdata;
+	char *mode;
+	char *type;
+
+	pdata = devm_kzalloc(dev, sizeof(struct tegra_ehci_platform_data),
+			     GFP_KERNEL);
+	if (!pdata)
+		return NULL;
+
+	/* Default to host if this property is not present. */
+	if (of_property_read_string(dn, "dr-mode", &mode) != 0)
+		pdata->operating_mode = TEGRA_USB_HOST;
+	else if (strcmp(mode, "peripheral") == 0)
+		pdata->operating_mode = TEGRA_USB_DEVICE;
+	else if (strcmp(mode, "host") == 0)
+		pdata->operating_mode = TEGRA_USB_HOST;
+	else if (strcmp(mode, "otg") == 0)
+		pdata->operating_mode = TEGRA_USB_OTG;
+	else {
+		dev_err(dev, "Invalid dt property \"dr-mode\" value %s\n",
+			mode);
+		goto fail;
+	}
+
+	/* power-down-on-bus-suspend is only relevant if dr-mode is host. */
+	if (of_find_property(dn, "power-down-on-bus-suspend", NULL) != 0) {
+		if (pdata->operating_mode != TEGRA_USB_HOST) {
+			dev_err(dev, "The dt property "
+				     "\"power-down-on-bus-suspend\" "
+				     "is only valid when dr-mode is "
+				     "\"host\"\n");
+			goto fail;
+		}
+		pdata->power_down_on_bus_suspend = 1;
+	}
+
+	/* Default to utmi if this property is not present. */
+	if (of_property_read_string(dn, "phy-type", &type) != 0) {
+		if (tegra_ehci_parse_dt_node_utmi(dn, pdev, pdata))
+			goto fail;
+	} else if (strcmp(type, "utmi") == 0) {
+		if (tegra_ehci_parse_dt_node_utmi(dn, pdev, pdata))
+			goto fail;
+	} else if (strcmp(type, "ulpi") == 0) {
+		if (tegra_ehci_parse_dt_node_ulpi(dn, pdev, pdata))
+			goto fail;
+	} else {
+		dev_err(dev, "Invalid dt property \"type\" value %s\n", type);
+		goto fail;
+	}
+
+	return pdata;
+
+fail:
+	devm_kfree(dev, pdata);
+
+	return NULL;
+}
+#else
+static struct tegra_ehci_platform_data *tegra_ehci_parse_dt_node(
+	struct device_node *dn,
+	struct platform_device *pdev)
+{
+	return NULL;
+}
+#endif /* defined(CONFIG_OF) */
+
 static int tegra_ehci_probe(struct platform_device *pdev)
 {
 	struct resource *res;
+	struct device_node *dn = pdev->dev.of_node;
 	struct usb_hcd *hcd;
 	struct tegra_ehci_hcd *tegra;
 	struct tegra_ehci_platform_data *pdata;
@@ -584,8 +754,19 @@ static int tegra_ehci_probe(struct platform_device *pdev)
 	int irq;
 	int instance = pdev->id;
 
+	/*
+	 * See if there's any platform data passed via board files.
+	 * If there isn't, then allocate one and fill it by parsing
+	 * device tree node.
+	 */
 	pdata = pdev->dev.platform_data;
 	if (!pdata) {
+		pdata = tegra_ehci_parse_dt_node(dn, pdev);
+
+		pdev->dev.dma_mask = &tegra_ehci_dmamask;
+		pdev->dev.coherent_dma_mask = tegra_ehci_dmamask;
+	}
+	if (!pdata) {
 		dev_err(&pdev->dev, "Platform data missing\n");
 		return -EINVAL;
 	}
@@ -773,6 +954,12 @@ static void tegra_ehci_hcd_shutdown(struct platform_device *pdev)
 		hcd->driver->shutdown(hcd);
 }
 
+static const struct of_device_id tegra_ehci_of_match[] = {
+	{ .compatible = "nvidia,tegra20-ehci", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, tegra_ehci_of_match);
+
 static struct platform_driver tegra_ehci_driver = {
 	.probe		= tegra_ehci_probe,
 	.remove		= tegra_ehci_remove,
@@ -783,5 +970,7 @@ static struct platform_driver tegra_ehci_driver = {
 	.shutdown	= tegra_ehci_hcd_shutdown,
 	.driver		= {
 		.name	= "tegra-ehci",
+		.owner	= THIS_MODULE,
+		.of_match_table = tegra_ehci_of_match,
 	}
 };
-- 
1.7.6

