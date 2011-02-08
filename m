Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751655Ab1BHFTJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 00:19:09 -0500
Received: from www.wytron.com.tw ([211.75.82.101]:59436 "EHLO
	www.wytron.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794Ab1BHFTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 00:19:07 -0500
From: Thomas Chou <thomas@wytron.com.tw>
To: David Brownell <dbrownell@users.sourceforge.net>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, nios2-dev@sopc.et.ntust.edu.tw,
        devicetree-discuss@lists.ozlabs.org,
        spi-devel-general@lists.sourceforge.net,
        Thomas Chou <thomas@wytron.com.tw>
Subject: [PATCH v8] spi: New driver for Altera SPI
Date: Tue,  8 Feb 2011 13:21:49 +0800
Message-Id: <1297142509-20158-1-git-send-email-thomas@wytron.com.tw>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <87aai8zzd1.fsf@macbook.be.48ers.dk>
References: <87aai8zzd1.fsf@macbook.be.48ers.dk>
X-SA-Exim-Connect-IP: 192.168.1.15
X-SA-Exim-Mail-From: thomas@wytron.com.tw
X-SA-Exim-Scanned: No (on www.wytron.com.tw); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new SPI driver to support the Altera SOPC Builder
SPI component. It uses the bitbanging library.

Signed-off-by: Thomas Chou <thomas@wytron.com.tw>
---
v2 add devicetree support
v3 remove platform header, as Grant suggested.
   no irq resource means polling.
v4 minor cleanup, as Grant suggested.
v5 add compat version.
v6 change compatible vendor to uppercase, ALTR.
   add dts binding doc.
v7 use platform driver register.
   use devm_ to help cleanup.
v8 remove default n in Kconfig.

 .../devicetree/bindings/spi/spi_altera.txt         |    4 +
 drivers/spi/Kconfig                                |    6 +
 drivers/spi/Makefile                               |    1 +
 drivers/spi/spi_altera.c                           |  335 ++++++++++++++++++++
 4 files changed, 346 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/spi/spi_altera.txt
 create mode 100644 drivers/spi/spi_altera.c

diff --git a/Documentation/devicetree/bindings/spi/spi_altera.txt b/Documentation/devicetree/bindings/spi/spi_altera.txt
new file mode 100644
index 0000000..dda3759
--- /dev/null
+++ b/Documentation/devicetree/bindings/spi/spi_altera.txt
@@ -0,0 +1,4 @@
+Altera SPI
+
+Required properties:
+- compatible : should be "ALTR,spi-1.0".
diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index bb233a9..e791579 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -53,6 +53,12 @@ if SPI_MASTER
 
 comment "SPI Master Controller Drivers"
 
+config SPI_ALTERA
+	tristate "Altera SPI Controller"
+	select SPI_BITBANG
+	help
+	  This is the driver for the Altera SPI Controller.
+
 config SPI_ATH79
 	tristate "Atheros AR71XX/AR724X/AR913X SPI controller driver"
 	depends on ATH79 && GENERIC_GPIO
diff --git a/drivers/spi/Makefile b/drivers/spi/Makefile
index 86d1b5f..4d2e35a 100644
--- a/drivers/spi/Makefile
+++ b/drivers/spi/Makefile
@@ -9,6 +9,7 @@ ccflags-$(CONFIG_SPI_DEBUG) := -DDEBUG
 obj-$(CONFIG_SPI_MASTER)		+= spi.o
 
 # SPI master controller drivers (bus)
+obj-$(CONFIG_SPI_ALTERA)		+= spi_altera.o
 obj-$(CONFIG_SPI_ATMEL)			+= atmel_spi.o
 obj-$(CONFIG_SPI_ATH79)			+= ath79_spi.o
 obj-$(CONFIG_SPI_BFIN)			+= spi_bfin5xx.o
diff --git a/drivers/spi/spi_altera.c b/drivers/spi/spi_altera.c
new file mode 100644
index 0000000..e7f4835
--- /dev/null
+++ b/drivers/spi/spi_altera.c
@@ -0,0 +1,335 @@
+/*
+ * Altera SPI driver
+ *
+ * Copyright (C) 2008 Thomas Chou <thomas@wytron.com.tw>
+ *
+ * Based on spi_s3c24xx.c, which is:
+ * Copyright (c) 2006 Ben Dooks
+ * Copyright (c) 2006 Simtec Electronics
+ *	Ben Dooks <ben@simtec.co.uk>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/errno.h>
+#include <linux/platform_device.h>
+#include <linux/spi/spi.h>
+#include <linux/spi/spi_bitbang.h>
+#include <linux/io.h>
+#include <linux/of.h>
+
+#define DRV_NAME "spi_altera"
+
+#define ALTERA_SPI_RXDATA	0
+#define ALTERA_SPI_TXDATA	4
+#define ALTERA_SPI_STATUS	8
+#define ALTERA_SPI_CONTROL	12
+#define ALTERA_SPI_SLAVE_SEL	20
+
+#define ALTERA_SPI_STATUS_ROE_MSK	0x8
+#define ALTERA_SPI_STATUS_TOE_MSK	0x10
+#define ALTERA_SPI_STATUS_TMT_MSK	0x20
+#define ALTERA_SPI_STATUS_TRDY_MSK	0x40
+#define ALTERA_SPI_STATUS_RRDY_MSK	0x80
+#define ALTERA_SPI_STATUS_E_MSK		0x100
+
+#define ALTERA_SPI_CONTROL_IROE_MSK	0x8
+#define ALTERA_SPI_CONTROL_ITOE_MSK	0x10
+#define ALTERA_SPI_CONTROL_ITRDY_MSK	0x40
+#define ALTERA_SPI_CONTROL_IRRDY_MSK	0x80
+#define ALTERA_SPI_CONTROL_IE_MSK	0x100
+#define ALTERA_SPI_CONTROL_SSO_MSK	0x400
+
+struct altera_spi {
+	/* bitbang has to be first */
+	struct spi_bitbang bitbang;
+	struct completion done;
+
+	void __iomem *base;
+	int irq;
+	int len;
+	int count;
+	int bytes_per_word;
+	unsigned long imr;
+
+	/* data buffers */
+	const unsigned char *tx;
+	unsigned char *rx;
+};
+
+static inline struct altera_spi *altera_spi_to_hw(struct spi_device *sdev)
+{
+	return spi_master_get_devdata(sdev->master);
+}
+
+static void altera_spi_chipsel(struct spi_device *spi, int value)
+{
+	struct altera_spi *hw = altera_spi_to_hw(spi);
+
+	if (spi->mode & SPI_CS_HIGH) {
+		switch (value) {
+		case BITBANG_CS_INACTIVE:
+			writel(1 << spi->chip_select,
+			       hw->base + ALTERA_SPI_SLAVE_SEL);
+			hw->imr |= ALTERA_SPI_CONTROL_SSO_MSK;
+			writel(hw->imr, hw->base + ALTERA_SPI_CONTROL);
+			break;
+
+		case BITBANG_CS_ACTIVE:
+			hw->imr &= ~ALTERA_SPI_CONTROL_SSO_MSK;
+			writel(hw->imr, hw->base + ALTERA_SPI_CONTROL);
+			writel(0, hw->base + ALTERA_SPI_SLAVE_SEL);
+			break;
+		}
+	} else {
+		switch (value) {
+		case BITBANG_CS_INACTIVE:
+			hw->imr &= ~ALTERA_SPI_CONTROL_SSO_MSK;
+			writel(hw->imr, hw->base + ALTERA_SPI_CONTROL);
+			break;
+
+		case BITBANG_CS_ACTIVE:
+			writel(1 << spi->chip_select,
+			       hw->base + ALTERA_SPI_SLAVE_SEL);
+			hw->imr |= ALTERA_SPI_CONTROL_SSO_MSK;
+			writel(hw->imr, hw->base + ALTERA_SPI_CONTROL);
+			break;
+		}
+	}
+}
+
+static int altera_spi_setupxfer(struct spi_device *spi, struct spi_transfer *t)
+{
+	return 0;
+}
+
+static int altera_spi_setup(struct spi_device *spi)
+{
+	return 0;
+}
+
+static inline unsigned int hw_txbyte(struct altera_spi *hw, int count)
+{
+	if (hw->tx) {
+		switch (hw->bytes_per_word) {
+		case 1:
+			return hw->tx[count];
+		case 2:
+			return (hw->tx[count * 2]
+				| (hw->tx[count * 2 + 1] << 8));
+		}
+	}
+	return 0;
+}
+
+static int altera_spi_txrx(struct spi_device *spi, struct spi_transfer *t)
+{
+	struct altera_spi *hw = altera_spi_to_hw(spi);
+
+	hw->tx = t->tx_buf;
+	hw->rx = t->rx_buf;
+	hw->count = 0;
+	hw->bytes_per_word = (t->bits_per_word ? : spi->bits_per_word) / 8;
+	hw->len = t->len / hw->bytes_per_word;
+
+	if (hw->irq >= 0) {
+		/* enable receive interrupt */
+		hw->imr |= ALTERA_SPI_CONTROL_IRRDY_MSK;
+		writel(hw->imr, hw->base + ALTERA_SPI_CONTROL);
+
+		/* send the first byte */
+		writel(hw_txbyte(hw, 0), hw->base + ALTERA_SPI_TXDATA);
+
+		wait_for_completion(&hw->done);
+		/* disable receive interrupt */
+		hw->imr &= ~ALTERA_SPI_CONTROL_IRRDY_MSK;
+		writel(hw->imr, hw->base + ALTERA_SPI_CONTROL);
+	} else {
+		/* send the first byte */
+		writel(hw_txbyte(hw, 0), hw->base + ALTERA_SPI_TXDATA);
+
+		while (1) {
+			unsigned int rxd;
+
+			while (!(readl(hw->base + ALTERA_SPI_STATUS) &
+				 ALTERA_SPI_STATUS_RRDY_MSK))
+				cpu_relax();
+
+			rxd = readl(hw->base + ALTERA_SPI_RXDATA);
+			if (hw->rx) {
+				switch (hw->bytes_per_word) {
+				case 1:
+					hw->rx[hw->count] = rxd;
+					break;
+				case 2:
+					hw->rx[hw->count * 2] = rxd;
+					hw->rx[hw->count * 2 + 1] = rxd >> 8;
+					break;
+				}
+			}
+
+			hw->count++;
+
+			if (hw->count < hw->len)
+				writel(hw_txbyte(hw, hw->count),
+				       hw->base + ALTERA_SPI_TXDATA);
+			else
+				break;
+		}
+
+	}
+
+	return hw->count * hw->bytes_per_word;
+}
+
+static irqreturn_t altera_spi_irq(int irq, void *dev)
+{
+	struct altera_spi *hw = dev;
+	unsigned int rxd;
+
+	rxd = readl(hw->base + ALTERA_SPI_RXDATA);
+	if (hw->rx) {
+		switch (hw->bytes_per_word) {
+		case 1:
+			hw->rx[hw->count] = rxd;
+			break;
+		case 2:
+			hw->rx[hw->count * 2] = rxd;
+			hw->rx[hw->count * 2 + 1] = rxd >> 8;
+			break;
+		}
+	}
+
+	hw->count++;
+
+	if (hw->count < hw->len)
+		writel(hw_txbyte(hw, hw->count), hw->base + ALTERA_SPI_TXDATA);
+	else
+		complete(&hw->done);
+
+	return IRQ_HANDLED;
+}
+
+static int __devinit altera_spi_probe(struct platform_device *pdev)
+{
+	struct altera_spi_platform_data *platp = pdev->dev.platform_data;
+	struct altera_spi *hw;
+	struct spi_master *master;
+	struct resource *res;
+	int err = -ENODEV;
+
+	master = spi_alloc_master(&pdev->dev, sizeof(struct altera_spi));
+	if (!master)
+		return err;
+
+	/* setup the master state. */
+	master->bus_num = pdev->id;
+	master->num_chipselect = 16;
+	master->mode_bits = SPI_CS_HIGH;
+	master->setup = altera_spi_setup;
+
+	hw = spi_master_get_devdata(master);
+	platform_set_drvdata(pdev, hw);
+
+	/* setup the state for the bitbang driver */
+	hw->bitbang.master = spi_master_get(master);
+	if (!hw->bitbang.master)
+		return err;
+	hw->bitbang.setup_transfer = altera_spi_setupxfer;
+	hw->bitbang.chipselect = altera_spi_chipsel;
+	hw->bitbang.txrx_bufs = altera_spi_txrx;
+
+	/* find and map our resources */
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		goto exit_busy;
+	if (!devm_request_mem_region(&pdev->dev, res->start, resource_size(res),
+				     pdev->name))
+		goto exit_busy;
+	hw->base = devm_ioremap_nocache(&pdev->dev, res->start,
+					resource_size(res));
+	if (!hw->base)
+		goto exit_busy;
+	/* program defaults into the registers */
+	hw->imr = 0;		/* disable spi interrupts */
+	writel(hw->imr, hw->base + ALTERA_SPI_CONTROL);
+	writel(0, hw->base + ALTERA_SPI_STATUS);	/* clear status reg */
+	if (readl(hw->base + ALTERA_SPI_STATUS) & ALTERA_SPI_STATUS_RRDY_MSK)
+		readl(hw->base + ALTERA_SPI_RXDATA);	/* flush rxdata */
+	/* irq is optional */
+	hw->irq = platform_get_irq(pdev, 0);
+	if (hw->irq >= 0) {
+		init_completion(&hw->done);
+		err = devm_request_irq(&pdev->dev, hw->irq, altera_spi_irq, 0,
+				       pdev->name, hw);
+		if (err)
+			goto exit;
+	}
+	/* find platform data */
+	if (!platp)
+		hw->bitbang.master->dev.of_node = pdev->dev.of_node;
+
+	/* register our spi controller */
+	err = spi_bitbang_start(&hw->bitbang);
+	if (err)
+		goto exit;
+	dev_info(&pdev->dev, "base %p, irq %d\n", hw->base, hw->irq);
+
+	return 0;
+
+exit_busy:
+	err = -EBUSY;
+exit:
+	platform_set_drvdata(pdev, NULL);
+	spi_master_put(master);
+	return err;
+}
+
+static int __devexit altera_spi_remove(struct platform_device *dev)
+{
+	struct altera_spi *hw = platform_get_drvdata(dev);
+	struct spi_master *master = hw->bitbang.master;
+
+	spi_bitbang_stop(&hw->bitbang);
+	platform_set_drvdata(dev, NULL);
+	spi_master_put(master);
+	return 0;
+}
+
+static const struct of_device_id altera_spi_match[] = {
+	{ .compatible = "ALTR,spi-1.0", },
+	{},
+}
+MODULE_DEVICE_TABLE(of, altera_spi_match);
+
+static struct platform_driver altera_spi_driver = {
+	.probe = altera_spi_probe,
+	.remove = __devexit_p(altera_spi_remove),
+	.driver = {
+		.name = DRV_NAME,
+		.owner = THIS_MODULE,
+		.pm = NULL,
+		.of_match_table = altera_spi_match,
+	},
+};
+
+static int __init altera_spi_init(void)
+{
+	return platform_driver_register(&altera_spi_driver);
+}
+module_init(altera_spi_init);
+
+static void __exit altera_spi_exit(void)
+{
+	platform_driver_unregister(&altera_spi_driver);
+}
+module_exit(altera_spi_exit);
+
+MODULE_DESCRIPTION("Altera SPI driver");
+MODULE_AUTHOR("Thomas Chou <thomas@wytron.com.tw>");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:" DRV_NAME);
-- 
1.7.4

