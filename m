Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675Ab1AZCCJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 21:02:09 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42216 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978Ab1AZCCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 21:02:07 -0500
Subject: [PATCH] driver-core: remove conditionals around devicetree pointers
To: devicetree-discuss@lists.ozlabs.org, gregkh@suse.de,
        linux-kernel@vger.kernel.org
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 25 Jan 2011 19:02:02 -0700
Message-ID: <20110126015414.31133.56437.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Having conditional around the of_match_table and the of_node pointers
turns out to make driver code use ugly #ifdef blocks.  Drop the
conditionals and remove the #ifdef blocks from the affected drivers.

Also tidy up minor whitespace issues within the same hunks.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

I've held off doing this since I didn't want to needlessly increase
the size of struct device and struct device_driver for users who don't
use CONFIG_OF.  However, its quibbling about a tiny amount of memory,
and #ifdef'ing it out this way is ugly for driver code.

Alternately, if I should be concerned about the extra memory, I could
define some macros/inlines similar to how CONFIG_NUMA is handled.

g.

 drivers/i2c/busses/i2c-ocores.c |   14 +++-----------
 drivers/i2c/i2c-core.c          |    2 --
 drivers/mmc/host/mmc_spi.c      |    4 ----
 drivers/net/ethoc.c             |    8 +-------
 drivers/spi/pxa2xx_spi.c        |    2 --
 drivers/spi/pxa2xx_spi_pci.c    |    2 --
 drivers/spi/xilinx_spi.c        |    6 ------
 include/linux/device.h          |    7 ++-----
 include/linux/i2c.h             |    2 --
 include/linux/of.h              |    4 ++--
 10 files changed, 8 insertions(+), 43 deletions(-)

diff --git a/drivers/i2c/busses/i2c-ocores.c b/drivers/i2c/busses/i2c-ocores.c
index ef3bcb1..c2ef5ce 100644
--- a/drivers/i2c/busses/i2c-ocores.c
+++ b/drivers/i2c/busses/i2c-ocores.c
@@ -330,9 +330,7 @@ static int __devinit ocores_i2c_probe(struct platform_device *pdev)
 	i2c->adap = ocores_adapter;
 	i2c_set_adapdata(&i2c->adap, i2c);
 	i2c->adap.dev.parent = &pdev->dev;
-#ifdef CONFIG_OF
 	i2c->adap.dev.of_node = pdev->dev.of_node;
-#endif
 
 	/* add i2c adapter to i2c tree */
 	ret = i2c_add_adapter(&i2c->adap);
@@ -390,15 +388,11 @@ static int ocores_i2c_resume(struct platform_device *pdev)
 #define ocores_i2c_resume	NULL
 #endif
 
-#ifdef CONFIG_OF
 static struct of_device_id ocores_i2c_match[] = {
-        {
-                .compatible = "opencores,i2c-ocores",
-        },
-        {},
+	{ .compatible = "opencores,i2c-ocores", },
+	{},
 };
 MODULE_DEVICE_TABLE(of, ocores_i2c_match);
-#endif
 
 /* work with hotplug and coldplug */
 MODULE_ALIAS("platform:ocores-i2c");
@@ -411,9 +405,7 @@ static struct platform_driver ocores_i2c_driver = {
 	.driver  = {
 		.owner = THIS_MODULE,
 		.name = "ocores-i2c",
-#ifdef CONFIG_OF
-                .of_match_table = ocores_i2c_match,
-#endif
+		.of_match_table = ocores_i2c_match,
 	},
 };
 
diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index f0bd5bc..045ba6e 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -537,9 +537,7 @@ i2c_new_device(struct i2c_adapter *adap, struct i2c_board_info const *info)
 	client->dev.parent = &client->adapter->dev;
 	client->dev.bus = &i2c_bus_type;
 	client->dev.type = &i2c_client_type;
-#ifdef CONFIG_OF
 	client->dev.of_node = info->of_node;
-#endif
 
 	dev_set_name(&client->dev, "%d-%04x", i2c_adapter_id(adap),
 		     client->addr);
diff --git a/drivers/mmc/host/mmc_spi.c b/drivers/mmc/host/mmc_spi.c
index fd877f6..2f7fc0c 100644
--- a/drivers/mmc/host/mmc_spi.c
+++ b/drivers/mmc/host/mmc_spi.c
@@ -1516,21 +1516,17 @@ static int __devexit mmc_spi_remove(struct spi_device *spi)
 	return 0;
 }
 
-#if defined(CONFIG_OF)
 static struct of_device_id mmc_spi_of_match_table[] __devinitdata = {
 	{ .compatible = "mmc-spi-slot", },
 	{},
 };
-#endif
 
 static struct spi_driver mmc_spi_driver = {
 	.driver = {
 		.name =		"mmc_spi",
 		.bus =		&spi_bus_type,
 		.owner =	THIS_MODULE,
-#if defined(CONFIG_OF)
 		.of_match_table = mmc_spi_of_match_table,
-#endif
 	},
 	.probe =	mmc_spi_probe,
 	.remove =	__devexit_p(mmc_spi_remove),
diff --git a/drivers/net/ethoc.c b/drivers/net/ethoc.c
index b79d7e1..db0290f 100644
--- a/drivers/net/ethoc.c
+++ b/drivers/net/ethoc.c
@@ -1163,15 +1163,11 @@ static int ethoc_resume(struct platform_device *pdev)
 # define ethoc_resume  NULL
 #endif
 
-#ifdef CONFIG_OF
 static struct of_device_id ethoc_match[] = {
-	{
-		.compatible = "opencores,ethoc",
-	},
+	{ .compatible = "opencores,ethoc", },
 	{},
 };
 MODULE_DEVICE_TABLE(of, ethoc_match);
-#endif
 
 static struct platform_driver ethoc_driver = {
 	.probe   = ethoc_probe,
@@ -1181,9 +1177,7 @@ static struct platform_driver ethoc_driver = {
 	.driver  = {
 		.name = "ethoc",
 		.owner = THIS_MODULE,
-#ifdef CONFIG_OF
 		.of_match_table = ethoc_match,
-#endif
 	},
 };
 
diff --git a/drivers/spi/pxa2xx_spi.c b/drivers/spi/pxa2xx_spi.c
index 9592883..a429b01 100644
--- a/drivers/spi/pxa2xx_spi.c
+++ b/drivers/spi/pxa2xx_spi.c
@@ -1557,9 +1557,7 @@ static int __devinit pxa2xx_spi_probe(struct platform_device *pdev)
 	drv_data->ssp = ssp;
 
 	master->dev.parent = &pdev->dev;
-#ifdef CONFIG_OF
 	master->dev.of_node = pdev->dev.of_node;
-#endif
 	/* the spi->mode bits understood by this driver: */
 	master->mode_bits = SPI_CPOL | SPI_CPHA | SPI_CS_HIGH;
 
diff --git a/drivers/spi/pxa2xx_spi_pci.c b/drivers/spi/pxa2xx_spi_pci.c
index 351d8a3..b6589bb 100644
--- a/drivers/spi/pxa2xx_spi_pci.c
+++ b/drivers/spi/pxa2xx_spi_pci.c
@@ -98,9 +98,7 @@ static int __devinit ce4100_spi_probe(struct pci_dev *dev,
 	pdev->dev.parent = &dev->dev;
 	pdev->dev.platform_data = &spi_info->spi_pdata;
 
-#ifdef CONFIG_OF
 	pdev->dev.of_node = dev->dev.of_node;
-#endif
 	pdev->dev.release = plat_dev_release;
 
 	spi_pdata->num_chipselect = dev->devfn;
diff --git a/drivers/spi/xilinx_spi.c b/drivers/spi/xilinx_spi.c
index 7adaef6..4d2c75d 100644
--- a/drivers/spi/xilinx_spi.c
+++ b/drivers/spi/xilinx_spi.c
@@ -351,14 +351,12 @@ static irqreturn_t xilinx_spi_irq(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-#ifdef CONFIG_OF
 static const struct of_device_id xilinx_spi_of_match[] = {
 	{ .compatible = "xlnx,xps-spi-2.00.a", },
 	{ .compatible = "xlnx,xps-spi-2.00.b", },
 	{}
 };
 MODULE_DEVICE_TABLE(of, xilinx_spi_of_match);
-#endif
 
 struct spi_master *xilinx_spi_init(struct device *dev, struct resource *mem,
 	u32 irq, s16 bus_num, int num_cs, int little_endian, int bits_per_word)
@@ -394,9 +392,7 @@ struct spi_master *xilinx_spi_init(struct device *dev, struct resource *mem,
 
 	master->bus_num = bus_num;
 	master->num_chipselect = num_cs;
-#ifdef CONFIG_OF
 	master->dev.of_node = dev->of_node;
-#endif
 
 	xspi->mem = *mem;
 	xspi->irq = irq;
@@ -539,9 +535,7 @@ static struct platform_driver xilinx_spi_driver = {
 	.driver = {
 		.name = XILINX_SPI_NAME,
 		.owner = THIS_MODULE,
-#ifdef CONFIG_OF
 		.of_match_table = xilinx_spi_of_match,
-#endif
 	},
 };
 
diff --git a/include/linux/device.h b/include/linux/device.h
index 1bf5cf0..ca5d252 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -128,9 +128,7 @@ struct device_driver {
 
 	bool suppress_bind_attrs;	/* disables bind/unbind via sysfs */
 
-#if defined(CONFIG_OF)
 	const struct of_device_id	*of_match_table;
-#endif
 
 	int (*probe) (struct device *dev);
 	int (*remove) (struct device *dev);
@@ -441,9 +439,8 @@ struct device {
 					     override */
 	/* arch specific additions */
 	struct dev_archdata	archdata;
-#ifdef CONFIG_OF
-	struct device_node	*of_node;
-#endif
+
+	struct device_node	*of_node; /* associated device tree node */
 
 	dev_t			devt;	/* dev_t, creates the sysfs "dev" */
 
diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index 903576d..06a8d9c 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -258,9 +258,7 @@ struct i2c_board_info {
 	unsigned short	addr;
 	void		*platform_data;
 	struct dev_archdata	*archdata;
-#ifdef CONFIG_OF
 	struct device_node *of_node;
-#endif
 	int		irq;
 };
 
diff --git a/include/linux/of.h b/include/linux/of.h
index cad7cf0..d9dd664 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -23,8 +23,6 @@
 
 #include <asm/byteorder.h>
 
-#ifdef CONFIG_OF
-
 typedef u32 phandle;
 typedef u32 ihandle;
 
@@ -65,6 +63,8 @@ struct device_node {
 #endif
 };
 
+#ifdef CONFIG_OF
+
 /* Pointer for first entry in chain of all nodes. */
 extern struct device_node *allnodes;
 extern struct device_node *of_chosen;

