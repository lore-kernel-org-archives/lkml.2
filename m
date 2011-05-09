Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622Ab1EIAdh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 20:33:37 -0400
Received: from mga02.intel.com ([134.134.136.20]:21044 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756550Ab1EIAdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 20:33:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,337,1301900400"; 
   d="scan'208";a="744199426"
From: Samuel Ortiz <sameo@linux.intel.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        =?UTF-8?q?Richard=20R=C3=B6jfors?= <richard.rojfors@pelagicore.com>
Subject: [PATCH 10/19] mfd: Use mfd cell platform_data for timberdale cells platform bits
Date: Mon,  9 May 2011 02:32:02 +0200
Message-Id: <1304901131-7104-11-git-send-email-sameo@linux.intel.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1304901131-7104-1-git-send-email-sameo@linux.intel.com>
References: <1304901131-7104-1-git-send-email-sameo@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the addition of a device platform mfd_cell pointer, MFD drivers
can go back to passing platform data back to their sub drivers.
This allows for an mfd_cell->mfd_data removal and thus keep the
sub drivers MFD agnostic. This is mostly needed for non MFD aware
sub drivers.

Cc: Richard Röjfors <richard.rojfors@pelagicore.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/dma/timb_dma.c           |    3 +-
 drivers/gpio/timbgpio.c          |    6 +-
 drivers/i2c/busses/i2c-ocores.c  |    3 +-
 drivers/i2c/busses/i2c-xiic.c    |    3 +-
 drivers/media/radio/radio-timb.c |    3 +-
 drivers/media/video/timblogiw.c  |    3 +-
 drivers/mfd/timberdale.c         |   81 +++++++++++++++++++++++++-------------
 drivers/net/ks8842.c             |    3 +-
 drivers/spi/xilinx_spi.c         |    3 +-
 9 files changed, 64 insertions(+), 44 deletions(-)

diff --git a/drivers/dma/timb_dma.c b/drivers/dma/timb_dma.c
index d2c75fe..f69f90a 100644
--- a/drivers/dma/timb_dma.c
+++ b/drivers/dma/timb_dma.c
@@ -27,7 +27,6 @@
 #include <linux/io.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
-#include <linux/mfd/core.h>
 #include <linux/slab.h>
 
 #include <linux/timb_dma.h>
@@ -685,7 +684,7 @@ static irqreturn_t td_irq(int irq, void *devid)
 
 static int __devinit td_probe(struct platform_device *pdev)
 {
-	struct timb_dma_platform_data *pdata = mfd_get_data(pdev);
+	struct timb_dma_platform_data *pdata = pdev->dev.platform_data;
 	struct timb_dma *td;
 	struct resource *iomem;
 	int irq;
diff --git a/drivers/gpio/timbgpio.c b/drivers/gpio/timbgpio.c
index edbe1ea..0265872 100644
--- a/drivers/gpio/timbgpio.c
+++ b/drivers/gpio/timbgpio.c
@@ -23,7 +23,6 @@
 #include <linux/module.h>
 #include <linux/gpio.h>
 #include <linux/platform_device.h>
-#include <linux/mfd/core.h>
 #include <linux/irq.h>
 #include <linux/io.h>
 #include <linux/timb_gpio.h>
@@ -229,7 +228,7 @@ static int __devinit timbgpio_probe(struct platform_device *pdev)
 	struct gpio_chip *gc;
 	struct timbgpio *tgpio;
 	struct resource *iomem;
-	struct timbgpio_platform_data *pdata = mfd_get_data(pdev);
+	struct timbgpio_platform_data *pdata = pdev->dev.platform_data;
 	int irq = platform_get_irq(pdev, 0);
 
 	if (!pdata || pdata->nr_pins > 32) {
@@ -320,13 +319,14 @@ err_mem:
 static int __devexit timbgpio_remove(struct platform_device *pdev)
 {
 	int err;
+	struct timbgpio_platform_data *pdata = pdev->dev.platform_data;
 	struct timbgpio *tgpio = platform_get_drvdata(pdev);
 	struct resource *iomem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	int irq = platform_get_irq(pdev, 0);
 
 	if (irq >= 0 && tgpio->irq_base > 0) {
 		int i;
-		for (i = 0; i < tgpio->gpio.ngpio; i++) {
+		for (i = 0; i < pdata->nr_pins; i++) {
 			irq_set_chip(tgpio->irq_base + i, NULL);
 			irq_set_chip_data(tgpio->irq_base + i, NULL);
 		}
diff --git a/drivers/i2c/busses/i2c-ocores.c b/drivers/i2c/busses/i2c-ocores.c
index fee1a26..1b46a9d 100644
--- a/drivers/i2c/busses/i2c-ocores.c
+++ b/drivers/i2c/busses/i2c-ocores.c
@@ -49,7 +49,6 @@
 #include <linux/init.h>
 #include <linux/errno.h>
 #include <linux/platform_device.h>
-#include <linux/mfd/core.h>
 #include <linux/i2c.h>
 #include <linux/interrupt.h>
 #include <linux/wait.h>
@@ -306,7 +305,7 @@ static int __devinit ocores_i2c_probe(struct platform_device *pdev)
 		return -EIO;
 	}
 
-	pdata = mfd_get_data(pdev);
+	pdata = pdev->dev.platform_data;
 	if (pdata) {
 		i2c->regstep = pdata->regstep;
 		i2c->clock_khz = pdata->clock_khz;
diff --git a/drivers/i2c/busses/i2c-xiic.c b/drivers/i2c/busses/i2c-xiic.c
index e9d5ff4..4bb68f3 100644
--- a/drivers/i2c/busses/i2c-xiic.c
+++ b/drivers/i2c/busses/i2c-xiic.c
@@ -34,7 +34,6 @@
 #include <linux/errno.h>
 #include <linux/delay.h>
 #include <linux/platform_device.h>
-#include <linux/mfd/core.h>
 #include <linux/i2c.h>
 #include <linux/interrupt.h>
 #include <linux/wait.h>
@@ -705,7 +704,7 @@ static int __devinit xiic_i2c_probe(struct platform_device *pdev)
 	if (irq < 0)
 		goto resource_missing;
 
-	pdata = mfd_get_data(pdev);
+	pdata = (struct xiic_i2c_platform_data *) pdev->dev.platform_data;
 	if (!pdata)
 		return -EINVAL;
 
diff --git a/drivers/media/radio/radio-timb.c b/drivers/media/radio/radio-timb.c
index 1e3a8dd..a185610 100644
--- a/drivers/media/radio/radio-timb.c
+++ b/drivers/media/radio/radio-timb.c
@@ -21,7 +21,6 @@
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-device.h>
 #include <linux/platform_device.h>
-#include <linux/mfd/core.h>
 #include <linux/interrupt.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
@@ -149,7 +148,7 @@ static const struct v4l2_file_operations timbradio_fops = {
 
 static int __devinit timbradio_probe(struct platform_device *pdev)
 {
-	struct timb_radio_platform_data *pdata = mfd_get_data(pdev);
+	struct timb_radio_platform_data *pdata = pdev->dev.platform_data;
 	struct timbradio *tr;
 	int err;
 
diff --git a/drivers/media/video/timblogiw.c b/drivers/media/video/timblogiw.c
index 84d4c7c..fc611eb 100644
--- a/drivers/media/video/timblogiw.c
+++ b/drivers/media/video/timblogiw.c
@@ -24,7 +24,6 @@
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <linux/dmaengine.h>
-#include <linux/mfd/core.h>
 #include <linux/scatterlist.h>
 #include <linux/interrupt.h>
 #include <linux/list.h>
@@ -791,7 +790,7 @@ static int __devinit timblogiw_probe(struct platform_device *pdev)
 {
 	int err;
 	struct timblogiw *lw = NULL;
-	struct timb_video_platform_data *pdata = mfd_get_data(pdev);
+	struct timb_video_platform_data *pdata = pdev->dev.platform_data;
 
 	if (!pdata) {
 		dev_err(&pdev->dev, "No platform data\n");
diff --git a/drivers/mfd/timberdale.c b/drivers/mfd/timberdale.c
index 94c6c8a..69272e4 100644
--- a/drivers/mfd/timberdale.c
+++ b/drivers/mfd/timberdale.c
@@ -384,7 +384,8 @@ static __devinitdata struct mfd_cell timberdale_cells_bar0_cfg0[] = {
 		.name = "timb-dma",
 		.num_resources = ARRAY_SIZE(timberdale_dma_resources),
 		.resources = timberdale_dma_resources,
-		.mfd_data = &timb_dma_platform_data,
+		.platform_data = &timb_dma_platform_data,
+		.pdata_size = sizeof(timb_dma_platform_data),
 	},
 	{
 		.name = "timb-uart",
@@ -395,37 +396,43 @@ static __devinitdata struct mfd_cell timberdale_cells_bar0_cfg0[] = {
 		.name = "xiic-i2c",
 		.num_resources = ARRAY_SIZE(timberdale_xiic_resources),
 		.resources = timberdale_xiic_resources,
-		.mfd_data = &timberdale_xiic_platform_data,
+		.platform_data = &timberdale_xiic_platform_data,
+		.pdata_size = sizeof(timberdale_xiic_platform_data),
 	},
 	{
 		.name = "timb-gpio",
 		.num_resources = ARRAY_SIZE(timberdale_gpio_resources),
 		.resources = timberdale_gpio_resources,
-		.mfd_data = &timberdale_gpio_platform_data,
+		.platform_data = &timberdale_gpio_platform_data,
+		.pdata_size = sizeof(timberdale_gpio_platform_data),
 	},
 	{
 		.name = "timb-video",
 		.num_resources = ARRAY_SIZE(timberdale_video_resources),
 		.resources = timberdale_video_resources,
-		.mfd_data = &timberdale_video_platform_data,
+		.platform_data = &timberdale_video_platform_data,
+		.pdata_size = sizeof(timberdale_video_platform_data),
 	},
 	{
 		.name = "timb-radio",
 		.num_resources = ARRAY_SIZE(timberdale_radio_resources),
 		.resources = timberdale_radio_resources,
-		.mfd_data = &timberdale_radio_platform_data,
+		.platform_data = &timberdale_radio_platform_data,
+		.pdata_size = sizeof(timberdale_radio_platform_data),
 	},
 	{
 		.name = "xilinx_spi",
 		.num_resources = ARRAY_SIZE(timberdale_spi_resources),
 		.resources = timberdale_spi_resources,
-		.mfd_data = &timberdale_xspi_platform_data,
+		.platform_data = &timberdale_xspi_platform_data,
+		.pdata_size = sizeof(timberdale_xspi_platform_data),
 	},
 	{
 		.name = "ks8842",
 		.num_resources = ARRAY_SIZE(timberdale_eth_resources),
 		.resources = timberdale_eth_resources,
-		.mfd_data = &timberdale_ks8842_platform_data,
+		.platform_data = &timberdale_ks8842_platform_data,
+		.pdata_size = sizeof(timberdale_ks8842_platform_data),
 	},
 };
 
@@ -434,7 +441,8 @@ static __devinitdata struct mfd_cell timberdale_cells_bar0_cfg1[] = {
 		.name = "timb-dma",
 		.num_resources = ARRAY_SIZE(timberdale_dma_resources),
 		.resources = timberdale_dma_resources,
-		.mfd_data = &timb_dma_platform_data,
+		.platform_data = &timb_dma_platform_data,
+		.pdata_size = sizeof(timb_dma_platform_data),
 	},
 	{
 		.name = "timb-uart",
@@ -450,13 +458,15 @@ static __devinitdata struct mfd_cell timberdale_cells_bar0_cfg1[] = {
 		.name = "xiic-i2c",
 		.num_resources = ARRAY_SIZE(timberdale_xiic_resources),
 		.resources = timberdale_xiic_resources,
-		.mfd_data = &timberdale_xiic_platform_data,
+		.platform_data = &timberdale_xiic_platform_data,
+		.pdata_size = sizeof(timberdale_xiic_platform_data),
 	},
 	{
 		.name = "timb-gpio",
 		.num_resources = ARRAY_SIZE(timberdale_gpio_resources),
 		.resources = timberdale_gpio_resources,
-		.mfd_data = &timberdale_gpio_platform_data,
+		.platform_data = &timberdale_gpio_platform_data,
+		.pdata_size = sizeof(timberdale_gpio_platform_data),
 	},
 	{
 		.name = "timb-mlogicore",
@@ -467,25 +477,29 @@ static __devinitdata struct mfd_cell timberdale_cells_bar0_cfg1[] = {
 		.name = "timb-video",
 		.num_resources = ARRAY_SIZE(timberdale_video_resources),
 		.resources = timberdale_video_resources,
-		.mfd_data = &timberdale_video_platform_data,
+		.platform_data = &timberdale_video_platform_data,
+		.pdata_size = sizeof(timberdale_video_platform_data),
 	},
 	{
 		.name = "timb-radio",
 		.num_resources = ARRAY_SIZE(timberdale_radio_resources),
 		.resources = timberdale_radio_resources,
-		.mfd_data = &timberdale_radio_platform_data,
+		.platform_data = &timberdale_radio_platform_data,
+		.pdata_size = sizeof(timberdale_radio_platform_data),
 	},
 	{
 		.name = "xilinx_spi",
 		.num_resources = ARRAY_SIZE(timberdale_spi_resources),
 		.resources = timberdale_spi_resources,
-		.mfd_data = &timberdale_xspi_platform_data,
+		.platform_data = &timberdale_xspi_platform_data,
+		.pdata_size = sizeof(timberdale_xspi_platform_data),
 	},
 	{
 		.name = "ks8842",
 		.num_resources = ARRAY_SIZE(timberdale_eth_resources),
 		.resources = timberdale_eth_resources,
-		.mfd_data = &timberdale_ks8842_platform_data,
+		.platform_data = &timberdale_ks8842_platform_data,
+		.pdata_size = sizeof(timberdale_ks8842_platform_data),
 	},
 };
 
@@ -494,7 +508,8 @@ static __devinitdata struct mfd_cell timberdale_cells_bar0_cfg2[] = {
 		.name = "timb-dma",
 		.num_resources = ARRAY_SIZE(timberdale_dma_resources),
 		.resources = timberdale_dma_resources,
-		.mfd_data = &timb_dma_platform_data,
+		.platform_data = &timb_dma_platform_data,
+		.pdata_size = sizeof(timb_dma_platform_data),
 	},
 	{
 		.name = "timb-uart",
@@ -505,31 +520,36 @@ static __devinitdata struct mfd_cell timberdale_cells_bar0_cfg2[] = {
 		.name = "xiic-i2c",
 		.num_resources = ARRAY_SIZE(timberdale_xiic_resources),
 		.resources = timberdale_xiic_resources,
-		.mfd_data = &timberdale_xiic_platform_data,
+		.platform_data = &timberdale_xiic_platform_data,
+		.pdata_size = sizeof(timberdale_xiic_platform_data),
 	},
 	{
 		.name = "timb-gpio",
 		.num_resources = ARRAY_SIZE(timberdale_gpio_resources),
 		.resources = timberdale_gpio_resources,
-		.mfd_data = &timberdale_gpio_platform_data,
+		.platform_data = &timberdale_gpio_platform_data,
+		.pdata_size = sizeof(timberdale_gpio_platform_data),
 	},
 	{
 		.name = "timb-video",
 		.num_resources = ARRAY_SIZE(timberdale_video_resources),
 		.resources = timberdale_video_resources,
-		.mfd_data = &timberdale_video_platform_data,
+		.platform_data = &timberdale_video_platform_data,
+		.pdata_size = sizeof(timberdale_video_platform_data),
 	},
 	{
 		.name = "timb-radio",
 		.num_resources = ARRAY_SIZE(timberdale_radio_resources),
 		.resources = timberdale_radio_resources,
-		.mfd_data = &timberdale_radio_platform_data,
+		.platform_data = &timberdale_radio_platform_data,
+		.pdata_size = sizeof(timberdale_radio_platform_data),
 	},
 	{
 		.name = "xilinx_spi",
 		.num_resources = ARRAY_SIZE(timberdale_spi_resources),
 		.resources = timberdale_spi_resources,
-		.mfd_data = &timberdale_xspi_platform_data,
+		.platform_data = &timberdale_xspi_platform_data,
+		.pdata_size = sizeof(timberdale_xspi_platform_data),
 	},
 };
 
@@ -538,7 +558,8 @@ static __devinitdata struct mfd_cell timberdale_cells_bar0_cfg3[] = {
 		.name = "timb-dma",
 		.num_resources = ARRAY_SIZE(timberdale_dma_resources),
 		.resources = timberdale_dma_resources,
-		.mfd_data = &timb_dma_platform_data,
+		.platform_data = &timb_dma_platform_data,
+		.pdata_size = sizeof(timb_dma_platform_data),
 	},
 	{
 		.name = "timb-uart",
@@ -549,37 +570,43 @@ static __devinitdata struct mfd_cell timberdale_cells_bar0_cfg3[] = {
 		.name = "ocores-i2c",
 		.num_resources = ARRAY_SIZE(timberdale_ocores_resources),
 		.resources = timberdale_ocores_resources,
-		.mfd_data = &timberdale_ocores_platform_data,
+		.platform_data = &timberdale_ocores_platform_data,
+		.pdata_size = sizeof(timberdale_ocores_platform_data),
 	},
 	{
 		.name = "timb-gpio",
 		.num_resources = ARRAY_SIZE(timberdale_gpio_resources),
 		.resources = timberdale_gpio_resources,
-		.mfd_data = &timberdale_gpio_platform_data,
+		.platform_data = &timberdale_gpio_platform_data,
+		.pdata_size = sizeof(timberdale_gpio_platform_data),
 	},
 	{
 		.name = "timb-video",
 		.num_resources = ARRAY_SIZE(timberdale_video_resources),
 		.resources = timberdale_video_resources,
-		.mfd_data = &timberdale_video_platform_data,
+		.platform_data = &timberdale_video_platform_data,
+		.pdata_size = sizeof(timberdale_video_platform_data),
 	},
 	{
 		.name = "timb-radio",
 		.num_resources = ARRAY_SIZE(timberdale_radio_resources),
 		.resources = timberdale_radio_resources,
-		.mfd_data = &timberdale_radio_platform_data,
+		.platform_data = &timberdale_radio_platform_data,
+		.pdata_size = sizeof(timberdale_radio_platform_data),
 	},
 	{
 		.name = "xilinx_spi",
 		.num_resources = ARRAY_SIZE(timberdale_spi_resources),
 		.resources = timberdale_spi_resources,
-		.mfd_data = &timberdale_xspi_platform_data,
+		.platform_data = &timberdale_xspi_platform_data,
+		.pdata_size = sizeof(timberdale_xspi_platform_data),
 	},
 	{
 		.name = "ks8842",
 		.num_resources = ARRAY_SIZE(timberdale_eth_resources),
 		.resources = timberdale_eth_resources,
-		.mfd_data = &timberdale_ks8842_platform_data,
+		.platform_data = &timberdale_ks8842_platform_data,
+		.pdata_size = sizeof(timberdale_ks8842_platform_data),
 	},
 };
 
diff --git a/drivers/net/ks8842.c b/drivers/net/ks8842.c
index f0d8346..4d40626 100644
--- a/drivers/net/ks8842.c
+++ b/drivers/net/ks8842.c
@@ -26,7 +26,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
-#include <linux/mfd/core.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
@@ -1146,7 +1145,7 @@ static int __devinit ks8842_probe(struct platform_device *pdev)
 	struct resource *iomem;
 	struct net_device *netdev;
 	struct ks8842_adapter *adapter;
-	struct ks8842_platform_data *pdata = mfd_get_data(pdev);
+	struct ks8842_platform_data *pdata = pdev->dev.platform_data;
 	u16 id;
 	unsigned i;
 
diff --git a/drivers/spi/xilinx_spi.c b/drivers/spi/xilinx_spi.c
index c69c6f2..4d2c75d 100644
--- a/drivers/spi/xilinx_spi.c
+++ b/drivers/spi/xilinx_spi.c
@@ -18,7 +18,6 @@
 #include <linux/interrupt.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
-#include <linux/mfd/core.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/spi_bitbang.h>
 #include <linux/spi/xilinx_spi.h>
@@ -471,7 +470,7 @@ static int __devinit xilinx_spi_probe(struct platform_device *dev)
 	struct spi_master *master;
 	u8 i;
 
-	pdata = mfd_get_data(dev);
+	pdata = dev->dev.platform_data;
 	if (pdata) {
 		num_cs = pdata->num_chipselect;
 		little_endian = pdata->little_endian;
-- 
1.7.2.3

