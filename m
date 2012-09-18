Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757733Ab2IRNzV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 09:55:21 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:37030 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752149Ab2IRNzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 09:55:17 -0400
From: Roland Stigge <stigge@antcom.de>
To: arnd@arndb.de, broonie@opensource.wolfsonmicro.com,
        grant.likely@secretlab.ca, linus.walleij@linaro.org,
        lee.jones@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, STEricsson_nomadik_linux@list.st.com,
        devicetree-discuss@lists.ozlabs.org, aletes.xgr@gmail.com,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH v2] spi/pl022: Devicetree support w/o platform data
Date: Tue, 18 Sep 2012 15:53:53 +0200
Message-Id: <1347976433-1176-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10.4
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even with devicetree support, we needed platform data to provide some data,
leading to mixed device tree and platform data. This patch makes it possible to
provide all that information via device tree. Now, the data must be provided
via platform data _or_ device tree completely.

Only in case of DMA where a callback specification is necessary (dma_filter()),
platform data is the only option.

Signed-off-by: Roland Stigge <stigge@antcom.de>

---
Changes since v1:
* Removed property pl022,bus-id: Set to -1 (auto) in DT case
* Removed property pl022,enable-dma: Only useful in platform data (no OF node)
  case, since dma_filter() callback only possible via platform data

 Documentation/devicetree/bindings/spi/spi_pl022.txt |    7 +++
 drivers/spi/spi-pl022.c                             |   39 +++++++++++++++++---
 2 files changed, 41 insertions(+), 5 deletions(-)

--- linux-2.6.orig/Documentation/devicetree/bindings/spi/spi_pl022.txt
+++ linux-2.6/Documentation/devicetree/bindings/spi/spi_pl022.txt
@@ -10,6 +10,13 @@ Optional properties:
 - cs-gpios : should specify GPIOs used for chipselects.
   The gpios will be referred to as reg = <index> in the SPI child nodes.
   If unspecified, a single SPI device without a chip select can be used.
+- pl022,autosuspend-delay : delay in ms following transfer completion before
+			    the runtime power management system suspends the
+			    device. A setting of 0 indicates no delay and the
+                            device will be suspended immediately
+- pl022,rt : indicates the controller should run the message pump with realtime
+             priority to minimise the transfer latency on the bus (boolean)
+
 
 SPI slave nodes must be children of the SPI master node and can
 contain the following properties.
--- linux-2.6.orig/drivers/spi/spi-pl022.c
+++ linux-2.6/drivers/spi/spi-pl022.c
@@ -2024,6 +2024,34 @@ static void pl022_cleanup(struct spi_dev
 	kfree(chip);
 }
 
+static struct pl022_ssp_controller *
+pl022_platform_data_dt_get(struct device *dev)
+{
+	struct device_node *np = dev->of_node;
+	struct pl022_ssp_controller *pd;
+	u32 tmp;
+
+	if (!np) {
+		dev_err(dev, "no dt node defined\n");
+		return NULL;
+	}
+
+	pd = devm_kzalloc(dev, sizeof(struct pl022_ssp_controller), GFP_KERNEL);
+	if (!pd) {
+		dev_err(dev, "cannot allocate platform data memory\n");
+		return NULL;
+	}
+
+	pd->bus_id = -1;
+	of_property_read_u32(np, "num-cs", &tmp);
+	pd->num_chipselect = tmp;
+	of_property_read_u32(np, "pl022,autosuspend-delay",
+			     &pd->autosuspend_delay);
+	pd->rt = of_property_read_bool(np, "pl022,rt");
+
+	return pd;
+}
+
 static int __devinit
 pl022_probe(struct amba_device *adev, const struct amba_id *id)
 {
@@ -2036,18 +2064,19 @@ pl022_probe(struct amba_device *adev, co
 
 	dev_info(&adev->dev,
 		 "ARM PL022 driver, device ID: 0x%08x\n", adev->periphid);
-	if (platform_info == NULL) {
-		dev_err(&adev->dev, "probe - no platform data supplied\n");
+	if (!platform_info && IS_ENABLED(CONFIG_OF))
+		platform_info = pl022_platform_data_dt_get(dev);
+
+	if (!platform_info) {
+		dev_err(dev, "probe: no platform data defined\n");
 		status = -ENODEV;
 		goto err_no_pdata;
 	}
 
 	if (platform_info->num_chipselect) {
 		num_cs = platform_info->num_chipselect;
-	} else if (IS_ENABLED(CONFIG_OF)) {
-		of_property_read_u32(np, "num-cs", &num_cs);
 	} else {
-		dev_err(&adev->dev, "probe: no chip select defined\n");
+		dev_err(dev, "probe: no chip select defined\n");
 		status = -ENODEV;
 		goto err_no_pdata;
 	}
