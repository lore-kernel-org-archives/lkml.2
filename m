Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924Ab1GTTlg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 15:41:36 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:1704 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460Ab1GTTle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 15:41:34 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 20 Jul 2011 12:41:34 -0700
From: <achew@nvidia.com>
To: <grant.likely@secretlab.ca>, <olof@lixom.net>, <swarren@nvidia.com>,
        <dwillemsen@nvidia.com>, <rklein@nvidia.com>, <mogantyv@nvidia.com>
CC: <devicetree-discuss@lists.ozlabs.org>, <linux-tegra@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Andrew Chew <achew@nvidia.com>
Subject: [PATCH 1/3 v2] usb: tegra20-ehci: Add devicetree support.
Date: Wed, 20 Jul 2011 12:38:08 -0700
Message-ID: <1311190690-18334-1-git-send-email-achew@nvidia.com>
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
---
 .../devicetree/bindings/usb/tegra20-ehci.txt       |   28 +++
 drivers/usb/host/ehci-tegra.c                      |  221 ++++++++++++++++++++
 2 files changed, 249 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/usb/tegra20-ehci.txt

diff --git a/Documentation/devicetree/bindings/usb/tegra20-ehci.txt b/Documentation/devicetree/bindings/usb/tegra20-ehci.txt
new file mode 100644
index 0000000..5a73a96
--- /dev/null
+++ b/Documentation/devicetree/bindings/usb/tegra20-ehci.txt
@@ -0,0 +1,28 @@
+NVIDIA Tegra20 SOC USB controllers
+
+The device node for a USB controller that is part of a Tegra20
+SOC is as described in the document "Open Firmware Recommended
+Practice: Universal Serial Bus" with the following modifications
+and additions:
+
+Required properties:
+ - compatible: Should be "nvidia,tegra20-ehci".
+ - mode: Should be one of "device", "host", or "otg".
+ - power_down_on_bus_suspend: For host mode only, should be <1> if you
+   want the USB phy to power down when the host is suspended.  Else, it
+   should be <0>.
+ - type: Should be one of "utmi" or "ulpi".
+
+Required properties for type = "utmi".  These values are derived from
+characterization by system engineering.
+ - hssync_start_delay
+ - idle_wait_delay
+ - elastic_limit
+ - term_range_adj
+ - xcvr_setup
+ - xcvr_lsfslew
+ - xcvr_lsrslew
+
+Required properties for type = "ulpi":
+ - reset_gpio: The GPIO used to drive reset
+ - clk
diff --git a/drivers/usb/host/ehci-tegra.c b/drivers/usb/host/ehci-tegra.c
index 02b2bfd..89144d5 100644
--- a/drivers/usb/host/ehci-tegra.c
+++ b/drivers/usb/host/ehci-tegra.c
@@ -21,10 +21,20 @@
 #include <linux/platform_data/tegra_usb.h>
 #include <linux/irq.h>
 #include <linux/usb/otg.h>
+
+#if defined(CONFIG_OF)
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/of_platform.h>
+#endif
+
 #include <mach/usb_phy.h>
 
 #define TEGRA_USB_DMA_ALIGN 32
 
+static u64 tegra_ehci_dmamask = DMA_BIT_MASK(TEGRA_USB_DMA_ALIGN);
+
 struct tegra_ehci_hcd {
 	struct ehci_hcd *ehci;
 	struct tegra_usb_phy *phy;
@@ -574,9 +584,181 @@ static const struct hc_driver tegra_ehci_hc_driver = {
 	.port_handed_over	= ehci_port_handed_over,
 };
 
+#if defined(CONFIG_OF)
+static int tegra_ehci_parse_dt_node_utmi(struct device_node *dn,
+					 struct platform_device *pdev,
+					 struct tegra_ehci_platform_data *pdata)
+{
+	struct device *dev = &pdev->dev;
+	struct tegra_utmip_config *phy_config;
+	int retval;
+
+	phy_config = devm_kzalloc(dev, sizeof(struct tegra_utmip_config),
+				  GFP_KERNEL);
+	if (!phy_config)
+		return -ENOMEM;
+
+	retval = of_property_read_u32(dn, "hssync_start_delay",
+				      (u32 *)&phy_config->hssync_start_delay);
+	if (retval) {
+		dev_err(dev, "Missing dt property \"hssync_start_delay\"\n");
+		return retval;
+	}
+
+	retval = of_property_read_u32(dn, "elastic_limit",
+				      (u32 *)&phy_config->elastic_limit);
+	if (retval) {
+		dev_err(dev, "Missing dt property \"elastic_limit\"\n");
+		return retval;
+	}
+
+	retval = of_property_read_u32(dn, "idle_wait_delay",
+				      (u32 *)&phy_config->idle_wait_delay);
+	if (retval) {
+		dev_err(dev, "Missing dt property \"idle_wait_delay\"\n");
+		return retval;
+	}
+
+	retval = of_property_read_u32(dn, "term_range_adj",
+				      (u32 *)&phy_config->term_range_adj);
+	if (retval) {
+		dev_err(dev, "Missing dt property \"term_range_adj\"\n");
+		return retval;
+	}
+
+	retval = of_property_read_u32(dn, "xcvr_setup",
+				      (u32 *)&phy_config->xcvr_setup);
+	if (retval) {
+		dev_err(dev, "Missing dt property \"xcvr_setup\"\n");
+		return retval;
+	}
+
+	retval = of_property_read_u32(dn, "xcvr_lsfslew",
+				      (u32 *)&phy_config->xcvr_lsfslew);
+	if (retval) {
+		dev_err(dev, "Missing dt property \"xcvr_lsfslew\"\n");
+		return retval;
+	}
+
+	retval = of_property_read_u32(dn, "xcvr_lsrslew",
+				      (u32 *)&phy_config->xcvr_lsrslew);
+	if (retval) {
+		dev_err(dev, "Missing dt property \"xcvr_lsrslew\"\n");
+		return retval;
+	}
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
+	int retval;
+
+	phy_config = devm_kzalloc(dev, sizeof(struct tegra_ulpi_config),
+				  GFP_KERNEL);
+	if (!phy_config)
+		return -ENOMEM;
+
+	retval = of_property_read_u32(dn, "reset_gpio",
+				      &phy_config->reset_gpio);
+	if (retval) {
+		dev_err(dev, "Missing dt property \"reset_gpio\"\n");
+		return retval;
+	}
+
+	retval = of_property_read_string(dn, "clk",
+					 (char **)&phy_config->clk);
+	if (retval) {
+		dev_err(dev, "Missing dt property \"clk\"\n");
+		return retval;
+	}
+
+	pdata->phy_config = phy_config;
+
+	return 0;
+}
+
+static struct tegra_ehci_platform_data *
+tegra_ehci_parse_dt_node(struct device_node *dn,
+			 struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct tegra_ehci_platform_data *pdata;
+	char *mode;
+	char *type;
+	int retval;
+
+	pdata = devm_kzalloc(dev, sizeof(struct tegra_ehci_platform_data),
+			     GFP_KERNEL);
+	if (!pdata)
+		return NULL;
+
+	retval = of_property_read_string(dn, "mode", &mode);
+	if (retval) {
+		dev_err(dev, "Missing dt property \"mode\"\n");
+		goto fail;
+	}
+
+	if (strcmp(mode, "device") == 0)
+		pdata->operating_mode = TEGRA_USB_DEVICE;
+	else if (strcmp(mode, "host") == 0)
+		pdata->operating_mode = TEGRA_USB_HOST;
+	else if (strcmp(mode, "otg") == 0)
+		pdata->operating_mode = TEGRA_USB_OTG;
+	else {
+		dev_err(dev, "Invalid dt property \"mode\" value %s\n", mode);
+		goto fail;
+	}
+
+	retval = of_property_read_u32(dn, "power_down_on_bus_suspend",
+				      &pdata->power_down_on_bus_suspend);
+	if (retval) {
+		dev_err(dev, "Missing dt property "
+			     "\"power_down_on_bus_suspend\"\n");
+		goto fail;
+	}
+
+	retval = of_property_read_string(dn, "type", &type);
+	if (retval) {
+		dev_err(dev, "Missing dt property \"type\"\n");
+		goto fail;
+	}
+
+	if (strcmp(type, "utmi") == 0) {
+		retval = tegra_ehci_parse_dt_node_utmi(dn, pdev, pdata);
+		if (retval)
+			goto fail;
+	} else if (strcmp(type, "ulpi") == 0) {
+		retval = tegra_ehci_parse_dt_node_ulpi(dn, pdev, pdata);
+		if (retval)
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
+#endif
+
 static int tegra_ehci_probe(struct platform_device *pdev)
 {
 	struct resource *res;
+#if defined(CONFIG_OF)
+	struct device_node *dn = pdev->dev.of_node;
+	struct resource of_res;
+#endif
 	struct usb_hcd *hcd;
 	struct tegra_ehci_hcd *tegra;
 	struct tegra_ehci_platform_data *pdata;
@@ -584,7 +766,20 @@ static int tegra_ehci_probe(struct platform_device *pdev)
 	int irq;
 	int instance = pdev->id;
 
+	/*
+	 * See if there's any platform data passed via board files.
+	 * If there isn't, then allocate one and fill it by parsing
+	 * device tree node.
+	 */
 	pdata = pdev->dev.platform_data;
+#if defined(CONFIG_OF)
+	if (!pdata) {
+		pdata = tegra_ehci_parse_dt_node(dn, pdev);
+
+		pdev->dev.dma_mask = &tegra_ehci_dmamask;
+		pdev->dev.coherent_dma_mask = tegra_ehci_dmamask;
+	}
+#endif
 	if (!pdata) {
 		dev_err(&pdev->dev, "Platform data missing\n");
 		return -EINVAL;
@@ -625,7 +820,15 @@ static int tegra_ehci_probe(struct platform_device *pdev)
 	clk_enable(tegra->emc_clk);
 	clk_set_rate(tegra->emc_clk, 400000000);
 
+	/*
+	 * If there isn't an IORESOURCE_MEM defined in the board file,
+	 * then try to get that information from the device tree node.
+	 */
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+#if defined(CONFIG_OF)
+	if (!res && (of_address_to_resource(dn, 0, &of_res) == 0))
+		res = &of_res;
+#endif
 	if (!res) {
 		dev_err(&pdev->dev, "Failed to get I/O memory\n");
 		err = -ENXIO;
@@ -658,7 +861,15 @@ static int tegra_ehci_probe(struct platform_device *pdev)
 	tegra->power_down_on_bus_suspend = pdata->power_down_on_bus_suspend;
 	tegra->ehci = hcd_to_ehci(hcd);
 
+	/*
+	 * If there isn't an irq defined in the board file, then try to get
+	 * that information from the device tree node.
+	 */
 	irq = platform_get_irq(pdev, 0);
+#if defined(CONFIG_OF)
+	if (!irq)
+		irq = irq_of_parse_and_map(dn, 0);
+#endif
 	if (!irq) {
 		dev_err(&pdev->dev, "Failed to get IRQ\n");
 		err = -ENODEV;
@@ -773,6 +984,14 @@ static void tegra_ehci_hcd_shutdown(struct platform_device *pdev)
 		hcd->driver->shutdown(hcd);
 }
 
+static const struct of_device_id tegra_ehci_of_match[] = {
+	{
+		.compatible = "nvidia,tegra20-ehci",
+	},
+	{},
+};
+MODULE_DEVICE_TABLE(of, tegra_ehci_of_match);
+
 static struct platform_driver tegra_ehci_driver = {
 	.probe		= tegra_ehci_probe,
 	.remove		= tegra_ehci_remove,
@@ -783,5 +1002,7 @@ static struct platform_driver tegra_ehci_driver = {
 	.shutdown	= tegra_ehci_hcd_shutdown,
 	.driver		= {
 		.name	= "tegra-ehci",
+		.owner	= THIS_MODULE,
+		.of_match_table = tegra_ehci_of_match,
 	}
 };
-- 
1.7.6

