Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862Ab1FOTH7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 15:07:59 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40347 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248Ab1FOTH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 15:07:58 -0400
Subject: [PATCH] spi/tegra: add devicetree support
To: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Erik Gilling <konkers@android.com>
From: Grant Likely <grant.likely@secretlab.ca>
Cc: Stephen Warren <swarren@nvidia.com>
Date: Wed, 15 Jun 2011 13:07:54 -0600
Message-ID: <20110615190754.11693.26335.stgit@ponder>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow the tegra spi driver to obtain populate the spi bus with devices
from the device tree.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 .../devicetree/bindings/spi/spi_nvidia.txt         |    5 +++++
 drivers/spi/spi-tegra.c                            |   12 ++++++++++++
 2 files changed, 17 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/spi/spi_nvidia.txt

diff --git a/Documentation/devicetree/bindings/spi/spi_nvidia.txt b/Documentation/devicetree/bindings/spi/spi_nvidia.txt
new file mode 100644
index 0000000..bde450b
--- /dev/null
+++ b/Documentation/devicetree/bindings/spi/spi_nvidia.txt
@@ -0,0 +1,5 @@
+NVIDIA Tegra 2 SPI device
+
+Required properties:
+- compatible : should be "nvidia,tegra250-spi".
+- gpios : should specify GPIOs used for chipselect.
diff --git a/drivers/spi/spi-tegra.c b/drivers/spi/spi-tegra.c
index 8e30727..a43ceeb 100644
--- a/drivers/spi/spi-tegra.c
+++ b/drivers/spi/spi-tegra.c
@@ -546,6 +546,7 @@ static int __init spi_tegra_probe(struct platform_device *pdev)
 	tspi->rx_dma_req.req_sel = spi_tegra_req_sels[pdev->id];
 	tspi->rx_dma_req.dev = tspi;
 
+	master->dev.of_node = pdev->dev.of_node;
 	ret = spi_register_master(master);
 
 	if (ret < 0)
@@ -595,10 +596,21 @@ static int __devexit spi_tegra_remove(struct platform_device *pdev)
 
 MODULE_ALIAS("platform:spi_tegra");
 
+#ifdef CONFIG_OF
+static struct of_device_id spi_tegra_of_match_table[] __devinitdata = {
+	{ .compatible = "nvidia,tegra250-spi", },
+	{}
+};
+MODULE_DEVICE_TABLE(of, spi_tegra_of_match_table);
+#else /* CONFIG_OF */
+#define spi_tegra_of_match_table NULL
+#endif /* CONFIG_OF */
+
 static struct platform_driver spi_tegra_driver = {
 	.driver = {
 		.name =		"spi_tegra",
 		.owner =	THIS_MODULE,
+		.of_match_table = spi_tegra_of_match_table,
 	},
 	.remove =	__devexit_p(spi_tegra_remove),
 };

