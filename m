Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611Ab1HWSQI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 14:16:08 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:40804 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886Ab1HWSP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 14:15:58 -0400
From: Stephen Warren <swarren@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>, Chris Ball <cjb@laptop.org>
Cc: Olof Johansson <olof@lixom.net>, Shawn Guo <shawn.guo@linaro.org>,
        linux-mmc@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 1/2] sdhci/tegra: Add Device Tree probing support
Date: Tue, 23 Aug 2011 12:15:33 -0600
Message-Id: <1314123334-23133-1-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>

Add hooks to read gpio configuration out of the device tree node.

[grant.likely: Rewrite of original patch from John Bonesio]
Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
[swarren: Fixed tegra_sdhci_get_ro() to retrieve pdata correctly]
[swarren: Reworked to avoid #ifdef CONFIG_OF]
[swarren: Reworked binding based on fsl-imx-esdhc.txt]
[swarren: Documented binding]
Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
Theoretically, these two patches should be merged in order in one place,
since the 2nd logically depends on the first. However, it's really just
a documentation dependency, so I think it's fine to merge them into the
MMC and DT trees separately and let them meet in linux-next.

 .../devicetree/bindings/mmc/nvidia-sdhci.txt       |   25 ++++++++++
 drivers/mmc/host/sdhci-tegra.c                     |   51 +++++++++++++++----
 2 files changed, 65 insertions(+), 11 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mmc/nvidia-sdhci.txt

diff --git a/Documentation/devicetree/bindings/mmc/nvidia-sdhci.txt b/Documentation/devicetree/bindings/mmc/nvidia-sdhci.txt
new file mode 100644
index 0000000..c87f667
--- /dev/null
+++ b/Documentation/devicetree/bindings/mmc/nvidia-sdhci.txt
@@ -0,0 +1,25 @@
+* NVIDIA Tegra Secure Digital Host Controller
+
+This controller on Tegra family SoCs provides an interface for MMC, SD,
+and SDIO types of memory cards.
+
+Required properties:
+- compatible : Should be "nvidia,<chip>-sdhci"
+- reg : Should contain eSDHC registers location and length
+- interrupts : Should contain eSDHC interrupt
+
+Optional properties:
+- cd-gpios : Specify GPIOs for card detection
+- wp-gpios : Specify GPIOs for write protection
+- power-gpios : Specify GPIOs for power control
+
+Example:
+
+sdhci@c8000200 {
+	compatible = "nvidia,tegra20-sdhci";
+	reg = <0xc8000200 0x200>;
+	interrupts = <47>;
+	cd-gpios = <&gpio 69 0>; /* gpio PI5 */
+	wp-gpios = <&gpio 57 0>; /* gpio PH1 */
+	power-gpios = <&gpio 155 0>; /* gpio PT3 */
+};
diff --git a/drivers/mmc/host/sdhci-tegra.c b/drivers/mmc/host/sdhci-tegra.c
index a5a9a97..9ab18d6 100644
--- a/drivers/mmc/host/sdhci-tegra.c
+++ b/drivers/mmc/host/sdhci-tegra.c
@@ -17,6 +17,7 @@
 #include <linux/platform_device.h>
 #include <linux/clk.h>
 #include <linux/io.h>
+#include <linux/of_gpio.h>
 #include <linux/gpio.h>
 #include <linux/mmc/card.h>
 #include <linux/mmc/host.h>
@@ -74,10 +75,8 @@ static void tegra_sdhci_writel(struct sdhci_host *host, u32 val, int reg)
 
 static unsigned int tegra_sdhci_get_ro(struct sdhci_host *sdhci)
 {
-	struct platform_device *pdev = to_platform_device(mmc_dev(sdhci->mmc));
-	struct tegra_sdhci_platform_data *plat;
-
-	plat = pdev->dev.platform_data;
+	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(sdhci);
+	struct tegra_sdhci_platform_data *plat = pltfm_host->priv;
 
 	if (!gpio_is_valid(plat->wp_gpio))
 		return -1;
@@ -95,12 +94,10 @@ static irqreturn_t carddetect_irq(int irq, void *data)
 
 static int tegra_sdhci_8bit(struct sdhci_host *host, int bus_width)
 {
-	struct platform_device *pdev = to_platform_device(mmc_dev(host->mmc));
-	struct tegra_sdhci_platform_data *plat;
+	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
+	struct tegra_sdhci_platform_data *plat = pltfm_host->priv;
 	u32 ctrl;
 
-	plat = pdev->dev.platform_data;
-
 	ctrl = sdhci_readb(host, SDHCI_HOST_CONTROL);
 	if (plat->is_8bit && bus_width == MMC_BUS_WIDTH_8) {
 		ctrl &= ~SDHCI_CTRL_4BITBUS;
@@ -132,6 +129,34 @@ static struct sdhci_pltfm_data sdhci_tegra_pdata = {
 	.ops  = &tegra_sdhci_ops,
 };
 
+static const struct of_device_id sdhci_tegra_dt_match[] __devinitdata = {
+	{ .compatible = "nvidia,tegra20-sdhci", },
+	{}
+};
+MODULE_DEVICE_TABLE(of, sdhci_dt_ids);
+
+static struct tegra_sdhci_platform_data * __devinit sdhci_tegra_dt_parse_pdata(
+						struct platform_device *pdev)
+{
+	struct tegra_sdhci_platform_data *plat;
+	struct device_node *np = pdev->dev.of_node;
+
+	if (!np)
+		return NULL;
+
+	plat = devm_kzalloc(&pdev->dev, sizeof(*plat), GFP_KERNEL);
+	if (!plat) {
+		dev_err(&pdev->dev, "Can't allocate platform data\n");
+		return NULL;
+	}
+
+	plat->cd_gpio = of_get_named_gpio(np, "cd-gpios", 0);
+	plat->wp_gpio = of_get_named_gpio(np, "wp-gpios", 0);
+	plat->power_gpio = of_get_named_gpio(np, "power-gpios", 0);
+
+	return plat;
+}
+
 static int __devinit sdhci_tegra_probe(struct platform_device *pdev)
 {
 	struct sdhci_pltfm_host *pltfm_host;
@@ -148,12 +173,17 @@ static int __devinit sdhci_tegra_probe(struct platform_device *pdev)
 
 	plat = pdev->dev.platform_data;
 
+	if (plat == NULL)
+		plat = sdhci_tegra_dt_parse_pdata(pdev);
+
 	if (plat == NULL) {
 		dev_err(mmc_dev(host->mmc), "missing platform data\n");
 		rc = -ENXIO;
 		goto err_no_plat;
 	}
 
+	pltfm_host->priv = plat;
+
 	if (gpio_is_valid(plat->power_gpio)) {
 		rc = gpio_request(plat->power_gpio, "sdhci_power");
 		if (rc) {
@@ -248,13 +278,11 @@ static int __devexit sdhci_tegra_remove(struct platform_device *pdev)
 {
 	struct sdhci_host *host = platform_get_drvdata(pdev);
 	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
-	struct tegra_sdhci_platform_data *plat;
+	struct tegra_sdhci_platform_data *plat = pltfm_host->priv;
 	int dead = (readl(host->ioaddr + SDHCI_INT_STATUS) == 0xffffffff);
 
 	sdhci_remove_host(host, dead);
 
-	plat = pdev->dev.platform_data;
-
 	if (gpio_is_valid(plat->wp_gpio)) {
 		tegra_gpio_disable(plat->wp_gpio);
 		gpio_free(plat->wp_gpio);
@@ -283,6 +311,7 @@ static struct platform_driver sdhci_tegra_driver = {
 	.driver		= {
 		.name	= "sdhci-tegra",
 		.owner	= THIS_MODULE,
+		.of_match_table = sdhci_tegra_dt_match,
 	},
 	.probe		= sdhci_tegra_probe,
 	.remove		= __devexit_p(sdhci_tegra_remove),
-- 
1.7.0.4

