Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011Ab1GSWuN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 18:50:13 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:8634 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471Ab1GSWuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 18:50:11 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 19 Jul 2011 15:50:10 -0700
From: <achew@nvidia.com>
To: <grant.likely@secretlab.ca>, <olof@lixom.net>, <swarren@nvidia.com>,
        <dwillemsen@nvidia.com>, <rklein@nvidia.com>, <mogantyv@nvidia.com>
CC: <devicetree-discuss@lists.ozlabs.org>, <linux-tegra@vger.kernel.org>,
        <linux-arm-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Andrew Chew <achew@nvidia.com>
Subject: [PATCH 1/3] usb: tegra20-ehci: Add devicetree support.
Date: Tue, 19 Jul 2011 15:46:55 -0700
Message-ID: <1311115617-9697-1-git-send-email-achew@nvidia.com>
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
 .../devicetree/bindings/usb/tegra20-ehci.txt       |   27 +++
 arch/arm/mach-tegra/include/mach/usb_phy.h         |    2 +-
 drivers/usb/host/ehci-tegra.c                      |  197 +++++++++++++++++++-
 3 files changed, 219 insertions(+), 7 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/usb/tegra20-ehci.txt

diff --git a/Documentation/devicetree/bindings/usb/tegra20-ehci.txt b/Documentation/devicetree/bindings/usb/tegra20-ehci.txt
new file mode 100644
index 0000000..89168a7
--- /dev/null
+++ b/Documentation/devicetree/bindings/usb/tegra20-ehci.txt
@@ -0,0 +1,27 @@
+NVIDIA Tegra20 SOC USB controllers
+
+The device node for a USB controller that is part of a Tegra20
+SOC is as described in the document "Open Firmware Recommended
+Practice : Universal Serial Bus" with the following modifications
+and additions :
+
+Required properties :
+ - compatible : Should be "tegra20-ehci".
+ - mode : Should be <1> for USB device, <2> for USB host, or <3> for USB OTG.
+ - power_down_on_bus_suspend : For host mode only, should be defined if you
+   want the USB phy to power down when the host is suspended.
+ - type : Should be one of "utmi" or "ulpi".
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
+ - reset_gpio : The GPIO used to drive reset
+ - clk
diff --git a/arch/arm/mach-tegra/include/mach/usb_phy.h b/arch/arm/mach-tegra/include/mach/usb_phy.h
index d4b8f9e..882af45 100644
--- a/arch/arm/mach-tegra/include/mach/usb_phy.h
+++ b/arch/arm/mach-tegra/include/mach/usb_phy.h
@@ -32,7 +32,7 @@ struct tegra_utmip_config {
 
 struct tegra_ulpi_config {
 	int reset_gpio;
-	const char *clk;
+	char *clk;
 };
 
 enum tegra_usb_phy_port_speed {
diff --git a/drivers/usb/host/ehci-tegra.c b/drivers/usb/host/ehci-tegra.c
index 02b2bfd..47d8586 100644
--- a/drivers/usb/host/ehci-tegra.c
+++ b/drivers/usb/host/ehci-tegra.c
@@ -21,6 +21,14 @@
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
@@ -574,9 +582,130 @@ static const struct hc_driver tegra_ehci_hc_driver = {
 	.port_handed_over	= ehci_port_handed_over,
 };
 
+#if defined(CONFIG_OF)
+static int tegra_ehci_parse_dt_node_utmi(struct device_node *dn,
+					 struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct tegra_ehci_platform_data *pdata = pdev->dev.platform_data;
+	struct tegra_utmip_config *phy_config;
+
+	phy_config = devm_kzalloc(dev, sizeof(struct tegra_utmip_config),
+				  GFP_KERNEL);
+	if (!phy_config)
+		return -ENOMEM;
+
+	if (of_property_read_u32(dn, "hssync_start_delay",
+			(u32 *)&phy_config->hssync_start_delay))
+		dev_warn(dev, "Missing property \"hssync_start_delay\"\n");
+
+	if (of_property_read_u32(dn, "elastic_limit",
+			(u32 *)&phy_config->elastic_limit))
+		dev_warn(dev, "Missing property \"elastic_limit\"\n");
+
+	if (of_property_read_u32(dn, "idle_wait_delay",
+			(u32 *)&phy_config->idle_wait_delay))
+		dev_warn(dev, "Missing property \"idle_wait_delay\"\n");
+
+	if (of_property_read_u32(dn, "term_range_adj",
+			(u32 *)&phy_config->term_range_adj))
+		dev_warn(dev, "Missing property \"term_range_adj\"\n");
+
+	if (of_property_read_u32(dn, "xcvr_setup",
+			(u32 *)&phy_config->xcvr_setup))
+		dev_warn(dev, "Missing property \"xcvr_setup\"\n");
+
+	if (of_property_read_u32(dn, "xcvr_lsfslew",
+			(u32 *)&phy_config->xcvr_lsfslew))
+		dev_warn(dev, "Missing property \"xcvr_lsfslew\"\n");
+
+	if (of_property_read_u32(dn, "xcvr_lsrslew",
+			(u32 *)&phy_config->xcvr_lsrslew))
+		dev_warn(dev, "Missing property \"xcvr_lsrslew\"\n");
+
+	pdata->phy_config = phy_config;
+
+	return 0;
+}
+
+static int tegra_ehci_parse_dt_node_ulpi(struct device_node *dn,
+					 struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct tegra_ehci_platform_data *pdata = pdev->dev.platform_data;
+	struct tegra_ulpi_config *phy_config;
+
+	phy_config = devm_kzalloc(dev, sizeof(struct tegra_ulpi_config),
+				  GFP_KERNEL);
+	if (!phy_config)
+		return -ENOMEM;
+
+	if (of_property_read_u32(dn, "reset_gpio", &phy_config->reset_gpio))
+		dev_warn(dev, "Missing property \"reset_gpio\"\n");
+
+	if (of_property_read_string(dn, "clk", &phy_config->clk))
+		dev_warn(dev, "Missing property \"clk\"\n");
+
+	pdata->phy_config = phy_config;
+
+	return 0;
+}
+
+static int tegra_ehci_parse_dt_node(struct device_node *dn,
+				    struct platform_device *pdev)
+{
+	static u64 tegra_ehci_dmamask = DMA_BIT_MASK(TEGRA_USB_DMA_ALIGN);
+	struct device *dev = &pdev->dev;
+	struct tegra_ehci_platform_data *pdata;
+	char *type;
+	int retval;
+
+	pdata = devm_kzalloc(dev, sizeof(struct tegra_ehci_platform_data),
+			     GFP_KERNEL);
+	if (!pdata)
+		return -ENOMEM;
+
+	pdev->dev.platform_data = pdata;
+
+	if (of_property_read_u32(dn, "mode", &pdata->operating_mode))
+		dev_warn(dev, "Missing property \"mode\"\n");
+
+	if (of_find_property(dn, "power_down_on_bus_suspend", NULL))
+		pdata->power_down_on_bus_suspend = 1;
+
+	if (of_property_read_string(dn, "type", &type))
+		dev_warn(dev, "Missing property \"type\"\n");
+
+	if (strcmp(type, "utmi") == 0) {
+		retval = tegra_ehci_parse_dt_node_utmi(dn, pdev);
+		if (retval)
+			goto fail;
+	} else if (strcmp(type, "ulpi") == 0) {
+		retval = tegra_ehci_parse_dt_node_ulpi(dn, pdev);
+		if (retval)
+			goto fail;
+	}
+
+	pdev->dev.dma_mask = &tegra_ehci_dmamask;
+	pdev->dev.coherent_dma_mask = tegra_ehci_dmamask;
+
+	return 0;
+
+fail:
+	devm_kfree(dev, pdata);
+	pdev->dev.platform_data = NULL;
+
+	return retval;
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
@@ -584,16 +713,31 @@ static int tegra_ehci_probe(struct platform_device *pdev)
 	int irq;
 	int instance = pdev->id;
 
-	pdata = pdev->dev.platform_data;
-	if (!pdata) {
-		dev_err(&pdev->dev, "Platform data missing\n");
-		return -EINVAL;
-	}
-
 	tegra = kzalloc(sizeof(struct tegra_ehci_hcd), GFP_KERNEL);
 	if (!tegra)
 		return -ENOMEM;
 
+	/*
+	 * See if there's any platform data passed via board files.
+	 * If there isn't, then allocate one and fill it by parsing
+	 * device tree node.
+	 */
+	if (!pdev->dev.platform_data) {
+#if defined(CONFIG_OF)
+		if (tegra_ehci_parse_dt_node(dn, pdev)) {
+			dev_err(&pdev->dev, "Unable to parse dt node\n");
+			err = -EINVAL;
+			goto fail_hcd;
+		}
+#else
+		dev_err(&pdev->dev, "Platform data missing\n");
+		err = -EINVAL;
+		goto fail_hcd;
+#endif
+	}
+
+	pdata = pdev->dev.platform_data;
+
 	hcd = usb_create_hcd(&tegra_ehci_hc_driver, &pdev->dev,
 					dev_name(&pdev->dev));
 	if (!hcd) {
@@ -625,12 +769,28 @@ static int tegra_ehci_probe(struct platform_device *pdev)
 	clk_enable(tegra->emc_clk);
 	clk_set_rate(tegra->emc_clk, 400000000);
 
+	/*
+	 * If there isn't an IORESOURCE_MEM defined in the board file,
+	 * then try to get that information from the device tree node.
+	 */
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res) {
+#if defined(CONFIG_OF)
+		err = of_address_to_resource(dn, 0, &of_res);
+		if (err) {
+			dev_err(&pdev->dev, "Failed to get I/O memory\n");
+			err = -ENXIO;
+			goto fail_io;
+		}
+
+		res = &of_res;
+#else
 		dev_err(&pdev->dev, "Failed to get I/O memory\n");
 		err = -ENXIO;
 		goto fail_io;
+#endif
 	}
+
 	hcd->rsrc_start = res->start;
 	hcd->rsrc_len = resource_size(res);
 	hcd->regs = ioremap(res->start, resource_size(res));
@@ -658,12 +818,26 @@ static int tegra_ehci_probe(struct platform_device *pdev)
 	tegra->power_down_on_bus_suspend = pdata->power_down_on_bus_suspend;
 	tegra->ehci = hcd_to_ehci(hcd);
 
+	/*
+	 * If there isn't an irq defined in the board file, then try to get
+	 * that information from the device tree node.
+	 */
 	irq = platform_get_irq(pdev, 0);
 	if (!irq) {
+#if defined(CONFIG_OF)
+		irq = irq_of_parse_and_map(dn, 0);
+		if (irq == NO_IRQ) {
+			dev_err(&pdev->dev, "Failed to get IRQ\n");
+			err = -ENODEV;
+			goto fail;
+		}
+#else
 		dev_err(&pdev->dev, "Failed to get IRQ\n");
 		err = -ENODEV;
 		goto fail;
+#endif
 	}
+
 	set_irq_flags(irq, IRQF_VALID);
 
 #ifdef CONFIG_USB_OTG_UTILS
@@ -761,6 +935,7 @@ static int tegra_ehci_remove(struct platform_device *pdev)
 	clk_put(tegra->emc_clk);
 
 	kfree(tegra);
+
 	return 0;
 }
 
@@ -773,6 +948,14 @@ static void tegra_ehci_hcd_shutdown(struct platform_device *pdev)
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
@@ -783,5 +966,7 @@ static struct platform_driver tegra_ehci_driver = {
 	.shutdown	= tegra_ehci_hcd_shutdown,
 	.driver		= {
 		.name	= "tegra-ehci",
+		.owner	= THIS_MODULE,
+		.of_match_table = tegra_ehci_of_match,
 	}
 };
-- 
1.7.6

