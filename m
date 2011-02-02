Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760Ab1BBU5z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 15:57:55 -0500
Received: from mga14.intel.com ([143.182.124.37]:40687 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753536Ab1BBU5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 15:57:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,415,1291622400"; 
   d="scan'208";a="383371414"
From: Russ Gorby <russ.gorby@intel.com>
To: David Brownell <dbrownell@users.sourceforge.net> (maintainer:SPI
	SUBSYSTEM),
        Grant Likely <grant.likely@secretlab.ca> (maintainer:SPI SUBSYSTEM),
        spi-devel-general@lists.sourceforge.net (open list:SPI SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 1/1] spi: intel_mid_ssp_spi: new SPI driver for intel Medfield platform
Date: Wed,  2 Feb 2011 13:01:52 -0800
Message-Id: <1296680512-2758-2-git-send-email-russ.gorby@intel.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <[PATCH 0/1] Adding intel_mid_ssp_spi driver : 01/27/2011>
References: <[PATCH 0/1] Adding intel_mid_ssp_spi driver : 01/27/2011>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SPI master controller driver for the Intel MID platform Medfield
This driver uses the Penwell SSP controller and configures it to
be a SPI device (spibus 3). This bus supports a single device -
the 3G SPI modem that can operate up to 25Mhz.

Signed-off-by: Russ Gorby <russ.gorby@intel.com>
---
 drivers/spi/Kconfig                 |    7 +
 drivers/spi/Makefile                |    1 +
 drivers/spi/intel_mid_ssp_spi.c     | 1507 +++++++++++++++++++++++++++++++++++
 drivers/spi/intel_mid_ssp_spi_def.h |  139 ++++
 4 files changed, 1654 insertions(+), 0 deletions(-)
 create mode 100644 drivers/spi/intel_mid_ssp_spi.c
 create mode 100644 drivers/spi/intel_mid_ssp_spi_def.h

diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index bb233a9..60ba339 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -178,6 +178,13 @@ config SPI_IMX
 	  This enables using the Freescale i.MX SPI controllers in master
 	  mode.
 
+config SPI_INTEL_MID_SSP
+	tristate "SSP SPI controller driver for Intel Medfield platform"
+	depends on SPI_MASTER && INTEL_MID_DMAC
+	help
+	  This is the SPI master controller driver for the Intel
+	  Medfield MID platform.
+
 config SPI_LM70_LLP
 	tristate "Parallel port adapter for LM70 eval board (DEVELOPMENT)"
 	depends on PARPORT && EXPERIMENTAL
diff --git a/drivers/spi/Makefile b/drivers/spi/Makefile
index 86d1b5f..c64deb9 100644
--- a/drivers/spi/Makefile
+++ b/drivers/spi/Makefile
@@ -50,6 +50,7 @@ obj-$(CONFIG_SPI_SH_SCI)		+= spi_sh_sci.o
 obj-$(CONFIG_SPI_SH_MSIOF)		+= spi_sh_msiof.o
 obj-$(CONFIG_SPI_STMP3XXX)		+= spi_stmp.o
 obj-$(CONFIG_SPI_NUC900)		+= spi_nuc900.o
+obj-$(CONFIG_SPI_INTEL_MID_SSP)         += intel_mid_ssp_spi.o
 
 # special build for s3c24xx spi driver with fiq support
 spi_s3c24xx_hw-y			:= spi_s3c24xx.o
diff --git a/drivers/spi/intel_mid_ssp_spi.c b/drivers/spi/intel_mid_ssp_spi.c
new file mode 100644
index 0000000..19c62bc
--- /dev/null
+++ b/drivers/spi/intel_mid_ssp_spi.c
@@ -0,0 +1,1507 @@
+/*
+ *  intel_mid_ssp_spi.c - Penwell SPI master controller driver
+ *  based on pxa2xx.c
+ *
+ *  Copyright (C) Intel 2010
+ *  Ken Mills <ken.k.mills@intel.com>
+ *  Russ Gorby <russ.gorby@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301,
+ * USA
+ *
+ */
+
+#include <linux/delay.h>
+#include <linux/highmem.h>
+#include <linux/pci.h>
+#include <linux/dma-mapping.h>
+#include <linux/pm_qos_params.h>
+#include <linux/intel_mid_dma.h>
+#include <linux/interrupt.h>
+#include <linux/spi/spi.h>
+#include <linux/pm_runtime.h>
+#include "intel_mid_ssp_spi_def.h"
+
+#define DRIVER_NAME		"intel_mid_ssp_spi"
+#define PCI_DMAC_MAXDI		2047
+#define PCI_DMAC_ID		0x0827
+/* PM QoS define */
+#define MIN_EXIT_LATENCY	20
+
+#define TESTMODE_COMMON_MASK	0x00ff
+#define TESTMODE_PRIV_MASK	0xff00
+#define TESTMODE_ENABLE_DMA	0x01
+#define TESTMODE_ENABLE_POLL	0x02
+#define TESTMODE_ENABLE_LOOPBACK 0x04
+#define TESTMODE_ENABLE_INTR	0x08
+#define TESTMODE(x)		(testmode & x)
+static unsigned int testmode = (TESTMODE_ENABLE_DMA | TESTMODE_ENABLE_POLL);
+
+module_param(testmode, uint, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(testmode, "supply test mode bits");
+
+MODULE_AUTHOR("Intel");
+MODULE_DESCRIPTION("Penwell SPI3 Master Contoller");
+MODULE_LICENSE("GPL");
+
+#define RX_THRESH_DFLT		8
+#define TX_THRESH_DFLT		8
+#define TIMOUT_DFLT		1000
+
+/*
+ * For testing SSCR1 changes that require SSP restart, basically
+ * everything except the service and interrupt enables
+ */
+
+#define SSCR1_CHANGE_MASK (SSCR1_TTELP | SSCR1_TTE | SSCR1_SCFR \
+				| SSCR1_ECRA | SSCR1_ECRB | SSCR1_SCLKDIR \
+				| SSCR1_SFRMDIR | SSCR1_RWOT | SSCR1_TRAIL \
+				| SSCR1_IFS | SSCR1_STRF | SSCR1_EFWR \
+				| SSCR1_RFT | SSCR1_TFT | SSCR1_MWDS \
+				| SSCR1_SPH | SSCR1_SPO | SSCR1_LBM)
+
+#define PNWL_SSPSP (SSPSP_FSRT | SSPSP_SFRMWDTH(1) | SSPSP_SFRMP | \
+		    SSPSP_SCMODE(3))
+
+/*
+ * clock divider
+ * 8 bpw
+ * TUR/ROR do not generate interrupt
+ * SPI mode operation
+ * SSP enabled
+ */
+#define PNWL_CR0(clk, bits, spi, chip)	\
+	((SSCR0_SerClkDiv(clk) & SSCR0_SCR) |				\
+	 SSCR0_Motorola |						\
+	 SSCR0_DataSize(bits > 16 ? bits - 16 : bits) |			\
+	 SSCR0_SSE |							\
+	 SSCR0_TIM |							\
+	 SSCR0_RIM |							\
+	 (bits > 16 ? SSCR0_EDSS : 0))
+
+#define PNWL_CR1_MASTER_ROLE	0
+#define PNWL_CR1_SLAVE_ROLE	(SSCR1_SFRMDIR | SSCR1_SCLKDIR)
+/* MRST SSP must be slave */
+#define PNWL_CR1_ROLE		PNWL_CR1_MASTER_ROLE
+#define PNWL_CR1(spi, chip)	\
+	  ((chip->enable_loopback ? SSCR1_LBM : 0) | \
+	  ((spi->mode & SPI_CPHA) ? SSCR1_SPH : 0) | \
+	  ((spi->mode & SPI_CPOL) ? SSCR1_SPO : 0) | \
+	  SSCR1_SCFR | \
+	  chip->threshold | \
+	  PNWL_CR1_ROLE)
+
+
+
+struct callback_param {
+	void *drv_data;
+	int *donep;
+};
+
+enum dd_pwrstate {
+	PWRSTATE_ON = 1,
+	PWRSTATE_IDLE,
+	PWRSTATE_OFF,
+};
+
+enum dd_pwrflags {
+	PWRFLAG_RTRESUMING,
+};
+
+struct driver_data {
+	/* Driver model hookup */
+	struct pci_dev *pdev;
+	/* SPI framework hookup */
+	struct spi_master *master;
+
+	/* SSP register addresses */
+	unsigned long paddr;
+	void __iomem *ioaddr;
+	u32 iolen;
+	int irq;
+
+	/* SSP masks*/
+	u32 dma_cr1;
+	u32 int_cr1;
+	u32 clear_sr;
+	u32 mask_sr;
+
+
+	/* Current message transfer state info */
+	struct tasklet_struct poll_transfer;
+	struct spi_message *cur_msg;
+	size_t len;
+	void *tx;
+	void *tx_end;
+	void *rx;
+	void *rx_end;
+	int dma_mapped;
+	dma_addr_t rx_dma;
+	dma_addr_t tx_dma;
+	size_t rx_map_len;
+	size_t tx_map_len;
+	u8 n_bytes;
+	int (*write)(struct driver_data *drv_data);
+	int (*read)(struct driver_data *drv_data);
+	irqreturn_t (*transfer_handler)(struct driver_data *drv_data);
+	void (*cs_control)(u32 command);
+	struct workqueue_struct *wq;
+	struct work_struct resume_transfer_work;
+
+	/* controller state */
+	int dma_inited;
+
+	/* pwrstate mgmt */
+	int pwrstate;		/* enum dd_pwrstate */
+	unsigned long pwrflags;	/* enum dd_pwrflags */
+
+	/* used by DMA code */
+	struct pci_dev *dmac1;
+	struct intel_mid_dma_slave    dmas_tx;
+	struct intel_mid_dma_slave    dmas_rx;
+	struct dma_chan	   *txchan;
+	struct dma_chan	   *rxchan;
+	int txdma_done;
+	int rxdma_done;
+	struct callback_param tx_param;
+	struct callback_param rx_param;
+};
+
+struct chip_data {
+	u32 cr0;
+	u32 cr1;
+	u32 psp;
+	u32 timeout;
+	u8 n_bytes;
+	u32 threshold;
+	u8 enable_dma;		/* use dma if possible */
+	u8 poll_mode;		/* use poll mode */
+	u8 enable_loopback;	/* configure in loopback mode */
+	u8 bits_per_word;
+	u32 speed_hz;
+	int (*write)(struct driver_data *drv_data);
+	int (*read)(struct driver_data *drv_data);
+};
+
+static int transfer(struct spi_device *, struct spi_message *);
+
+static inline int have_fifo_data(struct driver_data *drv_data, u32 *sssrp)
+{
+	u32 sssr;
+	void *reg = drv_data->ioaddr;
+	sssr = ioread32(reg + SSSR);
+
+	if (sssrp)
+		*sssrp = sssr;
+	return ((sssr & SSSR_TFL) || !(sssr & SSSR_TNF)) ||
+		((sssr & SSSR_RFL) != SSSR_RFL || (sssr & SSSR_RNE));
+}
+
+static void flush(struct driver_data *drv_data)
+{
+	void *reg = drv_data->ioaddr;
+	u32 sssr;
+
+	/* If the transmit fifo is not empty, reset the interface. */
+	if (have_fifo_data(drv_data, &sssr)) {
+		dev_warn(&drv_data->pdev->dev,
+			 "ERROR: flush: fifos not empty! sssr:%x", sssr);
+		iowrite32(ioread32(reg + SSCR0) & ~SSCR0_SSE, reg + SSCR0);
+		return;
+	}
+
+	iowrite32(SSSR_ROR, reg + SSSR);
+	iowrite32(SSSR_TUR, reg + SSSR);
+}
+
+/*
+ * reader/writer functions
+ *
+ * *_reader functions return:
+ *	0: not complete (data not available)
+ *	1: *all* requested data has been read
+ *
+ * *_writer functions return:
+ *	1: data successfully writen
+ *	0: *all* requested data already written *or* full condition hit
+ *	note: this means caller must verify write-complete condition
+ *
+ */
+static int null_writer(struct driver_data *drv_data)
+{
+	void *reg = drv_data->ioaddr;
+	u8 n_bytes = drv_data->n_bytes;
+	if (((ioread32(reg + SSSR) & SSSR_TFL) == SSSR_TFL)
+	    || (drv_data->tx == drv_data->tx_end))
+		return 0;
+
+	iowrite32(0, reg + SSDR);
+	drv_data->tx += n_bytes;
+
+	return 1;
+}
+
+static int null_reader(struct driver_data *drv_data)
+{
+	void *reg = drv_data->ioaddr;
+	u8 n_bytes = drv_data->n_bytes;
+
+	while ((ioread32(reg + SSSR) & SSSR_RNE) &&
+	       (drv_data->rx < drv_data->rx_end)) {
+
+		ioread32(reg + SSDR);
+		drv_data->rx += n_bytes;
+	}
+
+	return drv_data->rx == drv_data->rx_end;
+}
+
+static int u8_writer(struct driver_data *drv_data)
+{
+	void *reg = drv_data->ioaddr;
+
+	if (((ioread32(reg + SSSR) & SSSR_TFL) == SSSR_TFL)
+	    || (drv_data->tx == drv_data->tx_end))
+		return 0;
+
+	iowrite32(*(u8 *)(drv_data->tx), reg + SSDR);
+	dev_dbg(&drv_data->pdev->dev, "u8_write: %x", ((u8 *)drv_data->tx)[0]);
+	drv_data->tx++;
+
+	return 1;
+}
+
+static int u8_reader(struct driver_data *drv_data)
+{
+	void *reg = drv_data->ioaddr;
+
+	while ((ioread32(reg + SSSR) & SSSR_RNE)
+	       && (drv_data->rx < drv_data->rx_end)) {
+
+		*(u8 *)(drv_data->rx) = ioread32(reg + SSDR);
+		drv_data->rx++;
+	}
+
+	return drv_data->rx == drv_data->rx_end;
+}
+
+static int u16_writer(struct driver_data *drv_data)
+{
+	void *reg = drv_data->ioaddr;
+	if (((ioread32(reg + SSSR) & SSSR_TFL) == SSSR_TFL)
+	    || (drv_data->tx == drv_data->tx_end))
+		return 0;
+
+	iowrite32(*(u16 *)(drv_data->tx), reg + SSDR);
+	drv_data->tx += 2;
+
+	return 1;
+}
+
+static int u16_reader(struct driver_data *drv_data)
+{
+	void *reg = drv_data->ioaddr;
+	dev_dbg(&drv_data->pdev->dev, "u16_read");
+
+	while ((ioread32(reg + SSSR) & SSSR_RNE)
+	       && (drv_data->rx < drv_data->rx_end)) {
+
+		*(u16 *)(drv_data->rx) = ioread32(reg + SSDR);
+		drv_data->rx += 2;
+	}
+
+	return drv_data->rx == drv_data->rx_end;
+}
+
+static int u32_writer(struct driver_data *drv_data)
+{
+	void *reg = drv_data->ioaddr;
+	dev_dbg(&drv_data->pdev->dev, "u32_write");
+
+	if (((ioread32(reg + SSSR) & SSSR_TFL) == SSSR_TFL)
+	    || (drv_data->tx == drv_data->tx_end)) {
+		return 0;
+	}
+
+	iowrite32(*(u32 *)(drv_data->tx), reg + SSDR);
+	drv_data->tx += 4;
+
+	return 1;
+}
+
+static int u32_reader(struct driver_data *drv_data)
+{
+	void *reg = drv_data->ioaddr;
+
+	while ((ioread32(reg + SSSR) & SSSR_RNE)
+	       && (drv_data->rx < drv_data->rx_end)) {
+
+		*(u32 *)(drv_data->rx) = ioread32(reg + SSDR);
+		drv_data->rx += 4;
+	}
+
+	return drv_data->rx == drv_data->rx_end;
+}
+
+
+/* caller already set message->status; dma and pio irqs are blocked */
+static void giveback(struct driver_data *drv_data)
+{
+	struct spi_message *msg;
+
+	msg = drv_data->cur_msg;
+	drv_data->cur_msg = NULL;
+	msg->state = NULL;
+	if (msg->complete)
+		msg->complete(msg->context);
+}
+
+static bool chan_filter(struct dma_chan *chan, void *param)
+{
+	struct driver_data *drv_data = (struct driver_data *)param;
+	bool ret = false;
+
+	if (!drv_data->dmac1)
+		return ret;
+
+	if (chan->device->dev == &drv_data->dmac1->dev)
+		ret = true;
+
+	return ret;
+}
+
+/**
+ * unmap_dma_buffers() - Unmap the DMA buffers used during the last transfer.
+ * @drv_data:		Pointer to the private driver data
+ */
+static void unmap_dma_buffers(struct driver_data *drv_data,
+			      struct spi_message *msg)
+{
+	struct device *dev = &drv_data->pdev->dev;
+
+	if (unlikely(!drv_data->dma_mapped)) {
+		dev_err(dev, "ERROR : DMA buffers not mapped");
+		return;
+	}
+	if (unlikely(msg->is_dma_mapped))
+		return;
+
+	dma_unmap_single(dev, drv_data->rx_dma, drv_data->len, DMA_FROM_DEVICE);
+	dma_unmap_single(dev, drv_data->tx_dma, drv_data->len, DMA_TO_DEVICE);
+	drv_data->dma_mapped = 0;
+}
+
+
+static void dma_transfer_complete(void *arg)
+{
+	struct callback_param *param = arg;
+	struct driver_data *drv_data = (struct driver_data *)param->drv_data;
+	int *done;
+	void *reg;
+	u32 sscr1;
+
+	done = (int *)param->donep;
+	reg = drv_data->ioaddr;
+	*done = 1;
+
+	if (!drv_data->txdma_done || !drv_data->rxdma_done)
+		return;
+
+	/* Clear Status Register */
+	iowrite32(drv_data->clear_sr, reg + SSSR);
+
+	sscr1 = ioread32(reg + SSCR1);
+
+	/* Disable Triggers to DMA */
+	sscr1 &= ~drv_data->dma_cr1;
+
+	/* Disable Interrupt */
+	sscr1 &= ~drv_data->int_cr1;
+	iowrite32(sscr1, reg + SSCR1);
+
+	/* Stop getting Time Outs */
+	iowrite32(0, reg + SSTO);
+
+	/* release DMA mappings */
+	unmap_dma_buffers(drv_data, drv_data->cur_msg);
+
+	/* Update total byte transfered return count actual bytes read */
+	drv_data->cur_msg->actual_length = drv_data->len;
+
+	drv_data->cur_msg->status = 0;
+	giveback(drv_data);
+	pm_runtime_put(&drv_data->pdev->dev);
+}
+
+/**
+ * intel_mid_ssp_spi_dma_init() - Initialize DMA
+ * @drv_data:		Pointer to the private driver data
+ *
+ * This function is called at driver setup phase to allocate DMA
+ * ressources.
+ */
+static void intel_mid_ssp_spi_dma_init(struct driver_data *drv_data)
+{
+	struct intel_mid_dma_slave *rxs, *txs;
+	dma_cap_mask_t mask;
+
+	if (drv_data->dma_inited)
+		return;
+
+	drv_data->dmac1 = pci_get_device(PCI_VENDOR_ID_INTEL, PCI_DMAC_ID,
+					 NULL);
+	if (!drv_data->dmac1) {
+		dev_warn(&drv_data->pdev->dev, "Can't find DMAC %x",
+			 PCI_DMAC_ID);
+		return;
+	}
+
+	/* 1. init rx channel */
+	rxs = &drv_data->dmas_rx;
+	rxs->hs_mode = LNW_DMA_HW_HS;
+	rxs->cfg_mode = LNW_DMA_PER_TO_MEM;
+	rxs->dma_slave.direction = DMA_FROM_DEVICE;
+	rxs->dma_slave.src_maxburst = LNW_DMA_MSIZE_8;
+	rxs->dma_slave.dst_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
+	rxs->dma_slave.src_addr_width = DMA_SLAVE_BUSWIDTH_2_BYTES;
+
+	dma_cap_zero(mask);
+	dma_cap_set(DMA_MEMCPY, mask);
+	dma_cap_set(DMA_SLAVE, mask);
+
+	drv_data->rxchan = dma_request_channel(mask, chan_filter, drv_data);
+	if (!drv_data->rxchan)
+		goto err_exit;
+	drv_data->rxchan->private = rxs;
+
+	/* 2. init tx channel */
+	txs = &drv_data->dmas_tx;
+	txs->hs_mode = LNW_DMA_HW_HS;
+	txs->cfg_mode = LNW_DMA_MEM_TO_PER;
+	txs->dma_slave.direction = DMA_TO_DEVICE;
+	txs->dma_slave.dst_maxburst = LNW_DMA_MSIZE_8;
+	txs->dma_slave.src_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
+	txs->dma_slave.dst_addr_width = DMA_SLAVE_BUSWIDTH_2_BYTES;
+
+	dma_cap_set(DMA_SLAVE, mask);
+	dma_cap_set(DMA_MEMCPY, mask);
+
+	drv_data->txchan = dma_request_channel(mask, chan_filter, drv_data);
+	if (!drv_data->txchan)
+		goto free_rxchan;
+	drv_data->txchan->private = txs;
+
+	drv_data->dma_inited = 1;
+	drv_data->txdma_done = 1;
+	drv_data->rxdma_done = 1;
+
+	drv_data->tx_param.drv_data = (void *)drv_data;
+	drv_data->tx_param.donep = &drv_data->txdma_done;
+	drv_data->rx_param.drv_data = (void *)drv_data;
+	drv_data->rx_param.donep = &drv_data->rxdma_done;
+	return;
+
+free_rxchan:
+	dev_err(&drv_data->pdev->dev, "DMA TX Channel Not available");
+	dma_release_channel(drv_data->rxchan);
+err_exit:
+	dev_err(&drv_data->pdev->dev, "DMA RX Channel Not available");
+	pci_dev_put(drv_data->dmac1);
+}
+
+/**
+ * intel_mid_ssp_spi_dma_exit() - Release DMA ressources
+ * @drv_data:		Pointer to the private driver data
+ */
+static void intel_mid_ssp_spi_dma_exit(struct driver_data *drv_data)
+{
+	if (!drv_data->dma_inited)
+		return;
+	dma_release_channel(drv_data->txchan);
+	dma_release_channel(drv_data->rxchan);
+	pci_dev_put(drv_data->dmac1);
+	drv_data->dma_inited = 0;
+}
+
+static void dma_transfer(struct driver_data *drv_data)
+{
+	dma_addr_t ssdr_addr;
+	struct dma_async_tx_descriptor *txdesc = NULL, *rxdesc = NULL;
+	struct dma_chan *txchan, *rxchan;
+	enum dma_ctrl_flags flag;
+	struct dma_slave_config *txconf, *rxconf;
+	struct device *dev = &drv_data->pdev->dev;
+
+	/* get Data Read/Write address */
+	ssdr_addr = (dma_addr_t)(drv_data->paddr + 0x10);
+	flag = DMA_PREP_INTERRUPT | DMA_CTRL_ACK;
+
+	/* 2. Prepare the RX dma transfer	- DMA_FROM_DEVICE */
+	if (drv_data->rx_dma) {
+		rxconf = &drv_data->dmas_rx.dma_slave;
+		rxconf->src_addr = drv_data->rx_dma;
+		rxchan = drv_data->rxchan;
+		rxchan->device->device_control(rxchan, DMA_SLAVE_CONFIG,
+					       (unsigned long) rxconf);
+		rxdesc = rxchan->device->device_prep_dma_memcpy
+			(rxchan,		/* DMA Channel */
+			 drv_data->rx_dma,	/* DAR */
+			 ssdr_addr,		/* SAR */
+			 drv_data->len,		/* Data Length */
+			 flag);			/* Flag */
+		if (!rxdesc) {
+			dev_err(dev, "ERROR : rxdesc is null!");
+			return;
+		}
+		rxdesc->callback = dma_transfer_complete;
+		rxdesc->callback_param = &drv_data->rx_param;
+		drv_data->rxdma_done = 0;
+	}
+
+	/* 3. Prepare the TX dma transfer	-  DMA_TO_DEVICE */
+	if (drv_data->tx_dma) {
+		txconf = &drv_data->dmas_tx.dma_slave;
+		txconf->dst_addr = drv_data->rx_dma;
+		txchan = drv_data->txchan;
+		txchan->device->device_control(txchan, DMA_SLAVE_CONFIG,
+					       (unsigned long) txconf);
+		txdesc = txchan->device->device_prep_dma_memcpy
+			(txchan,		/* DMA Channel */
+			 ssdr_addr,		/* DAR */
+			 drv_data->tx_dma,	/* SAR */
+			 drv_data->len,		/* Data Length */
+			 flag);			/* Flag */
+		if (!txdesc) {
+			dev_err(dev, "ERROR : txdesc is null!");
+			return;
+		}
+		txdesc->callback = dma_transfer_complete;
+		txdesc->callback_param = &drv_data->tx_param;
+		drv_data->txdma_done = 0;
+	}
+
+	if (rxdesc)
+		rxdesc->tx_submit(rxdesc);
+	if (txdesc)
+		txdesc->tx_submit(txdesc);
+
+}
+
+
+/**
+ * map_dma_buffers() - Map DMA buffer before a transfer
+ * @drv_data:		Pointer to the private driver data
+ */
+static int map_dma_buffers(struct driver_data *drv_data,
+			   struct spi_message *msg,
+			   struct spi_transfer *transfer)
+{
+	struct device *dev = &drv_data->pdev->dev;
+
+	if (unlikely(drv_data->dma_mapped)) {
+		dev_err(dev, "ERROR : DMA buffers already mapped");
+		return 0;
+	}
+	if (unlikely(msg->is_dma_mapped)) {
+		drv_data->rx_dma = transfer->rx_dma;
+		drv_data->tx_dma = transfer->tx_dma;
+		return 1;
+	}
+	if (drv_data->len > PCI_DMAC_MAXDI * drv_data->n_bytes) {
+		/* if length is too long we revert to programmed I/O */
+		return 0;
+	}
+
+	if (likely(drv_data->rx)) {
+		drv_data->rx_dma =
+			dma_map_single(dev, drv_data->rx,
+				       drv_data->len, DMA_FROM_DEVICE);
+		if (unlikely(dma_mapping_error(dev, drv_data->rx_dma))) {
+			dev_err(dev, "ERROR : rx dma mapping failed");
+			return 0;
+		}
+	}
+	if (likely(drv_data->tx)) {
+		drv_data->tx_dma =
+			dma_map_single(dev, drv_data->tx,
+				       drv_data->len, DMA_TO_DEVICE);
+		if (unlikely(dma_mapping_error(dev, drv_data->tx_dma))) {
+			dma_unmap_single(dev, drv_data->rx_dma,
+					 drv_data->len, DMA_FROM_DEVICE);
+			dev_err(dev, "ERROR : tx dma mapping failed");
+			return 0;
+		}
+	}
+	return 1;
+}
+
+static void set_dma_width(struct driver_data *drv_data, int bits)
+{
+	struct dma_slave_config *rxconf, *txconf;
+	rxconf = &drv_data->dmas_rx.dma_slave;
+	txconf = &drv_data->dmas_tx.dma_slave;
+
+	if (bits <= 8) {
+		rxconf->src_addr_width = DMA_SLAVE_BUSWIDTH_1_BYTE;
+		txconf->dst_addr_width = DMA_SLAVE_BUSWIDTH_1_BYTE;
+	} else if (bits <= 16) {
+		rxconf->src_addr_width = DMA_SLAVE_BUSWIDTH_2_BYTES;
+		txconf->dst_addr_width = DMA_SLAVE_BUSWIDTH_2_BYTES;
+	} else if (bits <= 32) {
+		rxconf->src_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
+		txconf->dst_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
+	}
+}
+
+static void int_error_stop(struct driver_data *drv_data, const char* msg)
+{
+	void *reg = drv_data->ioaddr;
+
+	/* Stop and reset SSP */
+	iowrite32(drv_data->clear_sr, reg + SSSR);
+	iowrite32(ioread32(reg + SSCR1) & ~drv_data->int_cr1, reg + SSCR1);
+	iowrite32(0, reg + SSTO);
+	flush(drv_data);
+
+	dev_err(&drv_data->pdev->dev, "%s", msg);
+
+}
+
+static void int_transfer_complete(struct driver_data *drv_data)
+{
+	void *reg = drv_data->ioaddr;
+	u32 sscr1;
+
+	dev_dbg(&drv_data->pdev->dev, "interrupt transfer complete");
+	/* Clear Status Register */
+	iowrite32(drv_data->clear_sr, reg + SSSR);
+
+	sscr1 = ioread32(reg + SSCR1);
+
+	/* Disable Triggers to DMA */
+	sscr1 &= ~drv_data->dma_cr1;
+
+	/* Disable Interrupt */
+	sscr1 &= ~drv_data->int_cr1;
+	iowrite32(sscr1, reg + SSCR1);
+
+	/* Stop getting Time Outs */
+	iowrite32(0, reg + SSTO);
+
+	/* Update total byte transfered return count actual bytes read */
+	drv_data->cur_msg->actual_length += drv_data->len -
+		(drv_data->rx_end - drv_data->rx);
+
+	drv_data->cur_msg->status = 0;
+	giveback(drv_data);
+	pm_runtime_put(&drv_data->pdev->dev);
+}
+
+static void transfer_complete(struct driver_data *drv_data)
+{
+	/* Update total byte transfered return count actual bytes read */
+	drv_data->cur_msg->actual_length +=
+		drv_data->len - (drv_data->rx_end - drv_data->rx);
+
+	drv_data->cur_msg->status = 0;
+	giveback(drv_data);
+	pm_runtime_put(&drv_data->pdev->dev);
+}
+
+static irqreturn_t interrupt_transfer(struct driver_data *drv_data)
+{
+	void *reg = drv_data->ioaddr;
+	u32 irq_mask = (ioread32(reg + SSCR1) & SSCR1_TIE) ?
+		drv_data->mask_sr : drv_data->mask_sr & ~SSSR_TFS;
+
+	u32 irq_status = ioread32(reg + SSSR) & irq_mask;
+	if (irq_status & SSSR_ROR) {
+		int_error_stop(drv_data, "interrupt_transfer: fifo overrun");
+		return IRQ_HANDLED;
+	}
+
+	if (irq_status & SSSR_TINT) {
+		iowrite32(SSSR_TINT, reg + SSSR);
+		if (drv_data->read(drv_data)) {
+			int_transfer_complete(drv_data);
+			return IRQ_HANDLED;
+		}
+	}
+
+	/* Drain rx fifo, Fill tx fifo and prevent overruns */
+	do {
+		if (drv_data->read(drv_data)) {
+			int_transfer_complete(drv_data);
+			return IRQ_HANDLED;
+		}
+	} while (drv_data->write(drv_data));
+
+	if (drv_data->read(drv_data)) {
+		int_transfer_complete(drv_data);
+		return IRQ_HANDLED;
+	}
+
+	if (drv_data->tx == drv_data->tx_end)
+		iowrite32(ioread32(reg + SSCR1) & ~SSCR1_TIE, reg + SSCR1);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t ssp_int(int irq, void *dev_id)
+{
+	struct driver_data *drv_data = dev_id;
+	void *reg = drv_data->ioaddr;
+	u32 status = ioread32(reg + SSSR);
+
+	if (status & (SSSR_ROR | SSSR_TUR)) {
+		dev_dbg(&drv_data->pdev->dev,
+			"--- SPI ROR or TUR Occred : SSSR=%x", status);
+
+		if (drv_data->dma_mapped) {
+			iowrite32(SSSR_ROR, reg + SSSR);	/* Clear ROR */
+			iowrite32(SSSR_TUR, reg + SSSR);	/* Clear TUR */
+			return IRQ_HANDLED;
+		}
+	}
+
+	/* just return if this is not our interrupt */
+	if (!(ioread32(reg + SSSR) & drv_data->mask_sr))
+		return IRQ_NONE;
+
+	if (!drv_data->cur_msg) {
+		iowrite32(ioread32(reg + SSCR0) & ~SSCR0_SSE, reg + SSCR0);
+		iowrite32(ioread32(reg + SSCR1) & ~drv_data->int_cr1,
+			reg + SSCR1);
+		iowrite32(drv_data->clear_sr, reg + SSSR);
+
+		/* Never fail */
+
+		return IRQ_HANDLED;
+	}
+
+	return drv_data->transfer_handler(drv_data);
+}
+
+static void poll_transfer(unsigned long data)
+{
+	struct driver_data *drv_data = (struct driver_data *)data;
+
+	if (drv_data->tx)
+		while (drv_data->tx != drv_data->tx_end) {
+			drv_data->write(drv_data);
+			drv_data->read(drv_data);
+	}
+
+	while (!drv_data->read(drv_data))
+		cpu_relax();
+
+	transfer_complete(drv_data);
+}
+
+static unsigned int ssp_get_clk_div(int speed)
+{
+	u32 clk_div;
+
+	/*
+	 * fabric clock: 100MHz
+	 * SSP clock: 25MHz max
+	 */
+	clk_div = max(100000000 / speed, 4);
+
+	return clk_div;
+}
+
+/**
+ * resume_transfer_work()	- resume from pm_runtime sleep then
+ *		perform transfer() work
+ */
+static void resume_transfer_work(struct work_struct *work)
+{
+	struct driver_data *drv_data = container_of(work, struct driver_data,
+						    resume_transfer_work);
+	struct spi_message *msg;
+
+	pm_runtime_get_sync(&drv_data->pdev->dev);
+	WARN_ON(drv_data->pwrstate != PWRSTATE_ON);
+	msg = drv_data->cur_msg;
+	drv_data->cur_msg = NULL;
+	transfer(msg->spi, msg);
+}
+
+static int transfer(struct spi_device *spi, struct spi_message *msg)
+{
+	struct driver_data *drv_data = spi_master_get_devdata(spi->master);
+	struct chip_data *chip = NULL;
+	struct spi_transfer *transfer = NULL;
+	void *reg = drv_data->ioaddr;
+	int truth;
+	u8 bits;
+	u32 clk_div;
+	u32 speed;
+	u32 cr0;
+	u32 cr1;
+
+	if (unlikely(drv_data->pwrstate == PWRSTATE_OFF)) {
+		dev_dbg(&drv_data->pdev->dev, "transfer: busy, pwrstate:%d",
+			drv_data->pwrstate);
+		return -EIO;
+	}
+	if (unlikely(drv_data->pwrstate == PWRSTATE_IDLE)) {
+		truth = test_and_set_bit(PWRFLAG_RTRESUMING,
+					 &drv_data->pwrflags);
+		if (truth > 0) {
+			WARN_ON(1);
+			return -EBUSY;
+		}
+		drv_data->cur_msg = msg;
+		queue_work(drv_data->wq, &drv_data->resume_transfer_work);
+		return 0;
+	}
+	msg->actual_length = 0;
+	msg->status = -EINPROGRESS;
+	drv_data->cur_msg = msg;
+
+	/* We handle only one transfer message since the protocol module has to
+	   control the out of band signaling. */
+	transfer = list_entry(msg->transfers.next, struct spi_transfer,
+			      transfer_list);
+
+	/* Setup the transfer state based on the type of transfer */
+	if (likely(!test_and_clear_bit(PWRFLAG_RTRESUMING,
+				       &drv_data->pwrflags)))
+		pm_runtime_get(&drv_data->pdev->dev);
+	chip = spi_get_ctldata(msg->spi);
+	flush(drv_data);
+	drv_data->n_bytes = chip->n_bytes;
+	drv_data->tx = (void *)transfer->tx_buf;
+	drv_data->tx_end = drv_data->tx + transfer->len;
+	drv_data->rx = transfer->rx_buf;
+	drv_data->rx_end = drv_data->rx + transfer->len;
+	drv_data->rx_dma = transfer->rx_dma;
+	drv_data->tx_dma = transfer->tx_dma;
+	drv_data->len = transfer->len;
+	drv_data->write = drv_data->tx ? chip->write : null_writer;
+	drv_data->read = drv_data->rx ? chip->read : null_reader;
+
+	/* Change speed and bit per word on a per transfer */
+	cr0 = chip->cr0;
+	if (transfer->speed_hz || transfer->bits_per_word) {
+
+		bits = chip->bits_per_word;
+		speed = chip->speed_hz;
+
+		if (transfer->speed_hz)
+			speed = transfer->speed_hz;
+
+		clk_div = ssp_get_clk_div(speed);
+
+		if (transfer->bits_per_word)
+			bits = transfer->bits_per_word;
+
+		if (bits <= 8) {
+			drv_data->n_bytes = 1;
+			drv_data->read = drv_data->read != null_reader ?
+				u8_reader : null_reader;
+			drv_data->write = drv_data->write != null_writer ?
+				u8_writer : null_writer;
+		} else if (bits <= 16) {
+			drv_data->n_bytes = 2;
+			drv_data->read = drv_data->read != null_reader ?
+				u16_reader : null_reader;
+			drv_data->write = drv_data->write != null_writer ?
+				u16_writer : null_writer;
+		} else if (bits <= 32) {
+			drv_data->n_bytes = 4;
+			drv_data->read = drv_data->read != null_reader ?
+				u32_reader : null_reader;
+			drv_data->write = drv_data->write != null_writer ?
+				u32_writer : null_writer;
+		}
+		if (likely(chip->enable_dma))
+			set_dma_width(drv_data, bits);
+		cr0 = PNWL_CR0(clk_div, bits, spi, chip);
+	}
+
+	/* try to map dma buffer and do a dma transfer if successful */
+	if (likely(chip->enable_dma))
+		drv_data->dma_mapped = map_dma_buffers(drv_data, msg, transfer);
+	else {
+		WARN_ON(drv_data->dma_mapped != 0);
+		drv_data->dma_mapped = 0;
+	}
+
+	drv_data->transfer_handler = interrupt_transfer;
+	iowrite32(drv_data->clear_sr, reg + SSSR);
+	cr1 = chip->cr1;
+	iowrite32(chip->timeout, reg + SSTO);
+
+	if (likely(drv_data->dma_mapped))
+		cr1 |= drv_data->dma_cr1;
+	else if (!chip->poll_mode)
+		cr1 |= drv_data->int_cr1;
+
+	dev_dbg(&drv_data->pdev->dev,
+		"%s drv_data:%p len:%d n_bytes:%d cr0:%x cr1:%x",
+		(drv_data->dma_mapped ? "DMA io:" :
+		 (chip->poll_mode ? "Poll io:" : "Intr io:")),
+		drv_data, drv_data->len, drv_data->n_bytes, cr0, cr1);
+
+	/* see if we need to reload the config registers */
+	truth = ioread32(reg + SSCR0) != cr0 ||
+		((ioread32(reg + SSCR1) & SSCR1_CHANGE_MASK) !=
+		 (cr1 & SSCR1_CHANGE_MASK));
+	if (unlikely(truth)) {
+		/* stop the SSP, and update the other bits */
+		iowrite32(cr0 & ~SSCR0_SSE, reg + SSCR0);
+		/* first set CR1 without interrupt and service enables */
+		iowrite32(cr1 & SSCR1_CHANGE_MASK, reg + SSCR1);
+		/* restart the SSP */
+		iowrite32(cr0, reg + SSCR0);
+	}
+
+	/* after chip select, release the data by enabling service
+	 * requests and interrupts, without changing any mode bits */
+	iowrite32(cr1, reg + SSCR1);
+
+	if (likely(drv_data->dma_mapped)) {
+		/* transfer using DMA */
+		dma_transfer(drv_data);
+	} else if (chip->poll_mode) {
+		/* transfer using non interrupt polling */
+		tasklet_schedule(&drv_data->poll_transfer);
+	}
+	/*
+	 * if not using dma or poll-mode, transfers are done
+	 * using interrupt driven programmed I/O
+	 */
+
+	return 0;
+}
+
+/**
+ * setup()	- configures hardware according to given @chip
+ * @espi:	ep93xx SPI controller struct
+ * @chip:	chip specific settings
+ *
+ * This function sets up the actual hardware registers with settings given in
+ * @chip
+ */
+static int setup(struct spi_device *spi)
+{
+	struct intel_mid_ssp_spi_chip *chip_info = NULL;
+	struct chip_data *chip;
+	uint tx_thres = TX_THRESH_DFLT;
+	uint rx_thres = RX_THRESH_DFLT;
+	u32 clk_div;
+	struct driver_data *drv_data = spi_master_get_devdata(spi->master);
+
+	if (drv_data->pwrstate == PWRSTATE_OFF) {
+		dev_dbg(&drv_data->pdev->dev, "setup: busy, pwrstate:%d",
+			drv_data->pwrstate);
+		return -EIO;
+	}
+
+	if (!spi->bits_per_word)
+		spi->bits_per_word = 8;
+
+	if ((spi->bits_per_word < 4 || spi->bits_per_word > 32))
+		return -EINVAL;
+
+	/* Only alloc on first setup */
+	chip = spi_get_ctldata(spi);
+	if (!chip) {
+		chip = kzalloc(sizeof(struct chip_data), GFP_KERNEL);
+		if (!chip) {
+			dev_err(&spi->dev,
+				"failed setup: can't allocate chip data");
+			return -ENOMEM;
+		}
+
+		chip->timeout = TIMOUT_DFLT;
+	}
+
+	/*
+	 *  protocol drivers may change the chip settings, so...
+	 * if chip_info exists, use it
+	 */
+	chip_info = spi->controller_data;
+
+	/* chip_info isn't always needed */
+	if (chip_info) {
+		if (chip_info->timeout)
+			chip->timeout = chip_info->timeout;
+
+		if (chip_info->tx_threshold)
+			tx_thres = chip_info->tx_threshold;
+		if (chip_info->rx_threshold)
+			rx_thres = chip_info->rx_threshold;
+	}
+	chip->enable_dma = TESTMODE(TESTMODE_ENABLE_DMA);
+	chip->poll_mode = TESTMODE(TESTMODE_ENABLE_POLL);
+	chip->enable_loopback = TESTMODE(TESTMODE_ENABLE_LOOPBACK);
+
+	if (spi->bits_per_word <= 8) {
+		chip->n_bytes = 1;
+		chip->read = u8_reader;
+		chip->write = u8_writer;
+
+	} else if (spi->bits_per_word <= 16) {
+		chip->n_bytes = 2;
+		chip->read = u16_reader;
+		chip->write = u16_writer;
+	} else if (spi->bits_per_word <= 32) {
+		chip->n_bytes = 4;
+		chip->read = u32_reader;
+		chip->write = u32_writer;
+	} else {
+		dev_err(&spi->dev, "invalid wordsize");
+		return -ENODEV;
+	}
+
+	if (chip->enable_dma) {
+		intel_mid_ssp_spi_dma_init(drv_data);
+		set_dma_width(drv_data, spi->bits_per_word);
+	}
+
+	chip->speed_hz = spi->max_speed_hz;
+	clk_div = ssp_get_clk_div(chip->speed_hz);
+
+	chip->threshold = (SSCR1_RxTresh(rx_thres) & SSCR1_RFT) |
+		(SSCR1_TxTresh(tx_thres) & SSCR1_TFT);
+	chip->bits_per_word = spi->bits_per_word;
+
+	chip->cr0 = PNWL_CR0(clk_div, spi->bits_per_word, spi, chip);
+	chip->cr1 = PNWL_CR1(spi, chip);
+
+	dev_dbg(&spi->dev,
+		"KHz:%d bpw:%d mode:%d dma:%d poll:%d loop:%d cr0:%x cr1:%x",
+		100000 / clk_div, spi->bits_per_word, spi->mode & 0x3,
+		chip->enable_dma, chip->poll_mode, chip->enable_loopback,
+		chip->cr0, chip->cr1);
+
+	spi_set_ctldata(spi, chip);
+
+	return 0;
+}
+
+/**
+ * cleanup()	- cleans up master controller specific state
+ * @spi:	SPI device to cleanup
+ *
+ * This function releases master controller specific state for given @spi
+ * device.
+ */
+static void cleanup(struct spi_device *spi)
+{
+	struct chip_data *chip = spi_get_ctldata(spi);
+	struct driver_data *drv_data = spi_master_get_devdata(spi->master);
+
+	if (drv_data->dma_inited)
+		intel_mid_ssp_spi_dma_exit(drv_data);
+	kfree(chip);
+	spi_set_ctldata(spi, NULL);
+}
+
+static int intel_mid_ssp_spi_probe(struct pci_dev *pdev,
+				   const struct pci_device_id *ent)
+{
+	struct device *dev = &pdev->dev;
+	struct spi_master *master;
+	struct driver_data *drv_data;
+	int status = 0;
+	int pci_bar = 0;
+	void __iomem *syscfg_ioaddr;
+	unsigned long syscfg;
+	u8 ssp_cfg;
+	int pos;
+
+	/* Check if the SSP we are probed for has been allocated to  */
+	/* operate as SPI master. This information is get from the   */
+	/* field adid of the Vendor-Specific PCI capability which is */
+	/* used as a configuration register.                         */
+	pos = pci_find_capability(pdev, PCI_CAP_ID_VNDR);
+	if (pos > 0) {
+		pci_read_config_byte(pdev,
+			pos + VNDR_CAPABILITY_ADID_OFFSET,
+			&ssp_cfg);
+	} else {
+		dev_info(dev, "No Vendor Specific PCI capability");
+		goto err_abort_probe;
+	}
+	if ((SSP_CFG_GET_MODE(ssp_cfg) != SSP_CFG_SPI_MODE_ID) ||
+		SSP_CFG_IS_SPI_SLAVE(ssp_cfg)) {
+		dev_info(dev, "Unsupported SSP mode (%02xh)",
+			ssp_cfg);
+		goto err_abort_probe;
+	}
+
+	dev_info(&pdev->dev, "found PCI SSP controller(ID: %04xh:%04xh"
+		" cfg: %02xh)", pdev->vendor, pdev->device, ssp_cfg);
+
+	status = pci_enable_device(pdev);
+	if (status)
+		return status;
+
+	/* Allocate Slave with space for drv_data and null dma buffer */
+	master = spi_alloc_master(dev, sizeof(struct driver_data));
+
+	if (!master) {
+		dev_err(dev, "cannot alloc spi_master");
+		status = -ENOMEM;
+		goto err_free_0;
+	}
+
+	drv_data = spi_master_get_devdata(master);
+	drv_data->master = master;
+	drv_data->pdev = pdev;
+	drv_data->pwrstate = PWRSTATE_ON;
+	drv_data->wq = create_workqueue(DRIVER_NAME);
+	INIT_WORK(&drv_data->resume_transfer_work, resume_transfer_work);
+
+	master->mode_bits = SPI_CPOL | SPI_CPHA;
+	master->bus_num = SSP_CFG_GET_SPI_BUS_NB(ssp_cfg);
+	master->num_chipselect = 1;
+	master->cleanup = cleanup;
+	master->setup = setup;
+	master->transfer = transfer;
+
+	/* get basic io resource and map it */
+	drv_data->paddr = pci_resource_start(pdev, pci_bar);
+	drv_data->iolen = pci_resource_len(pdev, pci_bar);
+
+	status = pci_request_region(pdev, pci_bar, dev_name(dev));
+	if (status)
+		goto err_free_1;
+
+	drv_data->ioaddr = ioremap_nocache(drv_data->paddr, drv_data->iolen);
+	if (!drv_data->ioaddr) {
+		status = -ENOMEM;
+		goto err_free_2;
+	}
+	dev_dbg(dev, "paddr = : %08lx", drv_data->paddr);
+	dev_dbg(dev, "ioaddr = : %p", drv_data->ioaddr);
+	dev_dbg(dev, "attaching to IRQ: %04x", pdev->irq);
+
+	/* Attach to IRQ */
+	drv_data->irq = pdev->irq;
+
+	status = request_irq(drv_data->irq, ssp_int, IRQF_SHARED,
+		"intel_mid_ssp_spi", drv_data);
+	if (status < 0) {
+		dev_err(dev, "can not get IRQ %d", drv_data->irq);
+		goto err_free_3;
+	}
+
+	/* get base address of DMA selector. */
+	syscfg = drv_data->paddr - SYSCFG;
+	syscfg_ioaddr = ioremap_nocache(syscfg, 0x10);
+	if (!syscfg_ioaddr) {
+		status = -ENOMEM;
+		goto err_free_3;
+	}
+
+	iowrite32(ioread32(syscfg_ioaddr) | 2, syscfg_ioaddr);
+
+	drv_data->int_cr1 = SSCR1_TIE | SSCR1_RIE | SSCR1_TINTE;
+	drv_data->dma_cr1 = SSCR1_TSRE | SSCR1_RSRE | SSCR1_TRAIL;
+	drv_data->clear_sr = SSSR_ROR | SSSR_TINT;
+	drv_data->mask_sr = SSSR_TINT | SSSR_RFS | SSSR_TFS | SSSR_ROR;
+
+	tasklet_init(&drv_data->poll_transfer,
+		     poll_transfer, (unsigned long)drv_data);
+
+	/* Load default SSP configuration */
+	dev_info(dev, "setup default SSP configuration");
+	iowrite32(0, drv_data->ioaddr + SSCR0);
+	iowrite32(SSCR1_RxTresh(RX_THRESH_DFLT) |
+		    SSCR1_TxTresh(TX_THRESH_DFLT),
+		    drv_data->ioaddr + SSCR1);
+	iowrite32(SSCR0_Motorola | SSCR0_DataSize(8), drv_data->ioaddr + SSCR0);
+	iowrite32(0, drv_data->ioaddr + SSTO);
+	iowrite32(PNWL_SSPSP, drv_data->ioaddr + SSPSP);
+
+	/* Register with the SPI framework */
+	dev_info(&pdev->dev, "register with SPI framework (as SPI%d)",
+		 master->bus_num);
+	status = spi_register_master(master);
+	if (status != 0) {
+		dev_err(dev, "problem registering driver");
+		goto err_free_4;
+	}
+
+	pci_set_drvdata(pdev, drv_data);
+
+	pm_runtime_set_active(&pdev->dev);
+	pm_runtime_enable(&pdev->dev);
+	pm_runtime_idle(&pdev->dev);
+	pm_runtime_allow(dev);
+
+	return status;
+
+err_free_4:
+	free_irq(drv_data->irq, drv_data);
+err_free_3:
+	iounmap(drv_data->ioaddr);
+err_free_2:
+	pci_release_region(pdev, pci_bar);
+err_free_1:
+	spi_master_put(master);
+err_free_0:
+	pci_disable_device(pdev);
+
+	return status;
+err_abort_probe:
+	dev_info(dev, "Abort probe for SSP %04xh:%04xh",
+		pdev->vendor, pdev->device);
+	return -ENODEV;
+}
+
+static void __devexit intel_mid_ssp_spi_remove(struct pci_dev *pdev)
+{
+	struct driver_data *drv_data = pci_get_drvdata(pdev);
+
+	if (!drv_data)
+		return;
+
+	pci_set_drvdata(pdev, NULL);
+
+	free_irq(drv_data->irq, drv_data);
+
+	iounmap(drv_data->ioaddr);
+
+	pci_release_region(pdev, 0);
+
+	spi_unregister_master(drv_data->master);
+
+	pci_disable_device(pdev);
+
+	return;
+}
+
+/*
+ * for now IDLE and OFF states are treated the same
+ */
+static int _pm_suspend(struct pci_dev *pdev, int to)
+{
+	struct driver_data *drv_data = pci_get_drvdata(pdev);
+	void *reg = drv_data->ioaddr;
+	int from = drv_data->pwrstate;
+	u32 sssr;
+
+
+	if (to != PWRSTATE_IDLE && to != PWRSTATE_OFF) {
+		dev_err(&pdev->dev, "ERROR: suspend: invalid dst pwrstate %x",
+			to);
+		return -EINVAL;
+	}
+
+	switch (from) {
+	case PWRSTATE_ON:
+		dev_dbg(&pdev->dev, "suspend: turn off SSP");
+		if (have_fifo_data(drv_data, &sssr)) {
+			dev_err(&pdev->dev,
+				"ERROR: suspend: i/o present! sssr:%x", sssr);
+			return -EBUSY;
+		}
+		tasklet_disable(&drv_data->poll_transfer);
+		drv_data->pwrstate = to;
+		iowrite32(0, reg + SSCR0);
+		dev_dbg(&pdev->dev, "suspend: cr0:%x cr1:%x sssr:%x",
+			ioread32(reg + SSCR0), ioread32(reg + SSCR1),
+			ioread32(reg + SSSR));
+		break;
+	case PWRSTATE_IDLE:
+	case PWRSTATE_OFF:
+		drv_data->pwrstate = to;
+		break;
+	default:
+		dev_err(&pdev->dev, "ERROR: suspend: invalid src pwrstate %x",
+			from);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/*
+ * for now IDLE and OFF states are treated the same
+ */
+static void _pm_resume(struct pci_dev *pdev)
+{
+	struct driver_data *drv_data = pci_get_drvdata(pdev);
+	void *reg = drv_data->ioaddr;
+
+	switch (drv_data->pwrstate) {
+	default:
+		dev_err(&pdev->dev, "ERROR: resume: invalid src pwrstate %x",
+			drv_data->pwrstate);
+		/* fall through ... */
+	case PWRSTATE_IDLE:
+	case PWRSTATE_OFF:
+		dev_dbg(&pdev->dev, "resume: turn on SSP");
+
+		/*
+		 * we don't bother reconfiguring the registers
+		 * on resume - that will get done when transfer()
+		 * is called
+		 */
+		tasklet_enable(&drv_data->poll_transfer);
+		dev_dbg(&pdev->dev, "resume: cr0:%x cr1:%x sssr:%x",
+			ioread32(reg + SSCR0), ioread32(reg + SSCR1),
+			ioread32(reg + SSSR));
+
+		drv_data->pwrstate = PWRSTATE_ON;
+		break;
+	case PWRSTATE_ON:
+		break;
+	}
+}
+
+
+#ifdef CONFIG_PM
+
+static int intel_mid_ssp_spi_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	int retval;
+	struct driver_data *drv_data = pci_get_drvdata(pdev);
+
+	dev_dbg(&pdev->dev, "%s called", __func__);
+	if (drv_data->pwrstate != PWRSTATE_ON)
+		dev_warn(&pdev->dev, "suspend: !on, pwrstate:%d",
+			 drv_data->pwrstate);
+	retval = _pm_suspend(pdev, PWRSTATE_OFF);
+	if (retval)
+		return retval;
+	retval = pci_prepare_to_sleep(pdev);
+	if (retval) {
+		dev_err(&pdev->dev, "suspend: prepare to sleep failed");
+		return retval;
+	}
+	pci_disable_device(pdev);
+	return 0;
+}
+
+static int intel_mid_ssp_spi_resume(struct pci_dev *pdev)
+{
+	int retval;
+	struct driver_data *drv_data = pci_get_drvdata(pdev);
+
+	dev_dbg(&pdev->dev, "%s called", __func__);
+	if (drv_data->pwrstate != PWRSTATE_OFF)
+		dev_warn(&pdev->dev, "resume: !off, pwrstate:%d",
+			 drv_data->pwrstate);
+	retval = pci_enable_device(pdev);
+	if (retval) {
+		dev_err(&pdev->dev, "resume: back from sleep failed");
+		return retval;
+	}
+	retval = pci_back_from_sleep(pdev);
+	if (retval) {
+		dev_err(&pdev->dev, "resume: back from sleep failed");
+		return retval;
+	}
+	_pm_resume(pdev);
+	return 0;
+}
+
+#else
+#define intel_mid_ssp_spi_suspend NULL
+#define intel_mid_ssp_spi_resume NULL
+#endif /* CONFIG_PM */
+
+
+static int intel_mid_ssp_spi_pm_runtime_resume(struct device *dev)
+{
+	int retval;
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct driver_data *drv_data = pci_get_drvdata(pdev);
+
+	dev_dbg(dev, "%s called", __func__);
+	if (drv_data->pwrstate == PWRSTATE_ON)
+		return 0;
+	if (drv_data->pwrstate != PWRSTATE_IDLE)
+		dev_warn(&pdev->dev, "rt resume: !idle, pwrstate:%d",
+			 drv_data->pwrstate);
+	pci_set_power_state(pdev, PCI_D0);
+	pci_restore_state(pdev);
+	retval = pci_enable_device(pdev);
+	if (retval)
+		return retval;
+	_pm_resume(pdev);
+
+	return retval;
+}
+
+static int intel_mid_ssp_spi_pm_runtime_suspend(struct device *dev)
+{
+	int retval;
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct driver_data *drv_data = pci_get_drvdata(pdev);
+
+	dev_dbg(dev, "%s called", __func__);
+	if (drv_data->pwrstate != PWRSTATE_ON)
+		dev_warn(&pdev->dev, "rt suspend: !on, pwrstate:%d",
+			 drv_data->pwrstate);
+	retval = _pm_suspend(pdev, PWRSTATE_IDLE);
+	if (retval)
+		return retval;
+	pci_save_state(pdev);
+	pci_enable_wake(pdev, PCI_D3hot, 0);
+	pci_disable_device(pdev);
+	pci_set_power_state(pdev, PCI_D3hot);
+
+	return retval;
+}
+
+static int intel_mid_ssp_spi_pm_runtime_idle(struct device *dev)
+{
+	dev_dbg(dev, "%s called", __func__);
+	pm_schedule_suspend(dev, 100);
+	return -EBUSY;
+}
+
+static const struct dev_pm_ops intel_mid_ssp_spi_pm = {
+	.runtime_resume = intel_mid_ssp_spi_pm_runtime_resume,
+	.runtime_suspend = intel_mid_ssp_spi_pm_runtime_suspend,
+	.runtime_idle =  intel_mid_ssp_spi_pm_runtime_idle,
+};
+
+static const struct pci_device_id pci_ids[] __devinitdata = {
+	{ PCI_VDEVICE(INTEL, 0x0816) },
+	{ }
+};
+
+static struct pci_driver intel_mid_ssp_spi_driver = {
+	.driver = {
+		.pm = &intel_mid_ssp_spi_pm,
+	},
+	.name =		DRIVER_NAME,
+	.id_table =	pci_ids,
+	.probe =	intel_mid_ssp_spi_probe,
+	.remove =	__devexit_p(intel_mid_ssp_spi_remove),
+	.suspend =	intel_mid_ssp_spi_suspend,
+	.resume =	intel_mid_ssp_spi_resume,
+};
+
+static int __init intel_mid_ssp_spi_init(void)
+{
+	return pci_register_driver(&intel_mid_ssp_spi_driver);
+}
+late_initcall(intel_mid_ssp_spi_init);
+
+static void __exit intel_mid_ssp_spi_exit(void)
+{
+	pci_unregister_driver(&intel_mid_ssp_spi_driver);
+}
+module_exit(intel_mid_ssp_spi_exit);
diff --git a/drivers/spi/intel_mid_ssp_spi_def.h b/drivers/spi/intel_mid_ssp_spi_def.h
new file mode 100644
index 0000000..4610d62
--- /dev/null
+++ b/drivers/spi/intel_mid_ssp_spi_def.h
@@ -0,0 +1,139 @@
+/*
+ *  Copyright (C) Intel 2010
+ *  Ken Mills <ken.k.mills@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301,
+ * USA
+ *
+ */
+#ifndef INTEL_MID_SSP_SPI_DEF_H_
+#define INTEL_MID_SSP_SPI_DEF_H_
+
+
+/*
+ * Penwell SSP register definitions
+ */
+
+#define SSCR0_DSS   (0x0000000f)     /* Data Size Select (mask) */
+#define SSCR0_DataSize(x)  ((x) - 1)	/* Data Size Select [4..16] */
+#define SSCR0_FRF   (0x00000030)     /* FRame Format (mask) */
+#define SSCR0_Motorola	      (0x0 << 4)	 /* Motorola's SPI mode */
+#define SSCR0_ECS   (1 << 6) /* External clock select */
+#define SSCR0_SSE   (1 << 7) /* Synchronous Serial Port Enable */
+
+
+#define SSCR0_SCR   (0x000fff00)      /* Serial Clock Rate (mask) */
+#define SSCR0_SerClkDiv(x) (((x) - 1) << 8) /* Divisor [1..4096] */
+#define SSCR0_EDSS	      (1 << 20)	/* Extended data size select */
+#define SSCR0_NCS   (1 << 21)		/* Network clock select */
+#define SSCR0_RIM    (1 << 22)		 /* Receive FIFO overrrun int mask */
+#define SSCR0_TUM   (1 << 23)		/* Transmit FIFO underrun int mask */
+#define SSCR0_FRDC (0x07000000)	    /* Frame rate divider control (mask) */
+#define SSCR0_SlotsPerFrm(x) (((x) - 1) << 24)	/* Time slots per frame */
+#define SSCR0_ADC   (1 << 30)		/* Audio clock select */
+#define SSCR0_MOD  (1 << 31)	       /* Mode (normal or network) */
+
+
+#define SSCR1_RIE    (1 << 0) /* Receive FIFO Interrupt Enable */
+#define SSCR1_TIE     (1 << 1) /* Transmit FIFO Interrupt Enable */
+#define SSCR1_LBM   (1 << 2) /* Loop-Back Mode */
+#define SSCR1_SPO   (1 << 3) /* SSPSCLK polarity setting */
+#define SSCR1_SPH   (1 << 4) /* Motorola SPI SSPSCLK phase setting */
+#define SSCR1_MWDS	     (1 << 5) /* Microwire Transmit Data Size */
+#define SSCR1_TFT    (0x000003c0)     /* Transmit FIFO Threshold (mask) */
+#define SSCR1_TxTresh(x) (((x) - 1) << 6) /* level [1..16] */
+#define SSCR1_RFT    (0x00003c00)     /* Receive FIFO Threshold (mask) */
+#define SSCR1_RxTresh(x) (((x) - 1) << 10) /* level [1..16] */
+
+#define SSSR_TNF     (1 << 2) /* Transmit FIFO Not Full */
+#define SSSR_RNE     (1 << 3) /* Receive FIFO Not Empty */
+#define SSSR_BSY     (1 << 4) /* SSP Busy */
+#define SSSR_TFS     (1 << 5) /* Transmit FIFO Service Request */
+#define SSSR_RFS     (1 << 6) /* Receive FIFO Service Request */
+#define SSSR_ROR    (1 << 7) /* Receive FIFO Overrun */
+#define SSSR_TFL     (0x0f00) /* Transmit FIFO Level (mask) */
+#define SSSR_RFL     (0xf000) /* Receive FIFO Level (mask) */
+
+#define SSCR0_TIM    (1 << 23)		 /* Transmit FIFO Under Run Int Mask */
+#define SSCR0_RIM    (1 << 22)		 /* Receive FIFO Over Run int Mask */
+#define SSCR0_NCS   (1 << 21)		/* Network Clock Select */
+#define SSCR0_EDSS	      (1 << 20)	/* Extended Data Size Select */
+
+#define SSCR0_TISSP	       (1 << 4) /* TI Sync Serial Protocol */
+#define SSCR0_PSP   (3 << 4) /* PSP - Programmable Serial Protocol */
+#define SSCR1_TTELP	       (1 << 31) /* TXD Tristate Enable Last Phase */
+#define SSCR1_TTE    (1 << 30)		 /* TXD Tristate Enable */
+#define SSCR1_EBCEI	       (1 << 29) /* Enable Bit Count Error interrupt */
+#define SSCR1_SCFR (1 << 28)	       /* Slave Clock free Running */
+#define SSCR1_ECRA (1 << 27)	       /* Enable Clock Request A */
+#define SSCR1_ECRB (1 << 26)	       /* Enable Clock request B */
+#define SSCR1_SCLKDIR	     (1 << 25) /* Serial Bit Rate Clock Direction */
+#define SSCR1_SFRMDIR	    (1 << 24)		/* Frame Direction */
+#define SSCR1_RWOT	      (1 << 23)		  /* Receive Without Transmit */
+#define SSCR1_TRAIL (1 << 22)		/* Trailing Byte */
+#define SSCR1_TSRE (1 << 21)	       /* Transmit Service Request Enable */
+#define SSCR1_RSRE (1 << 20)	       /* Receive Service Request Enable */
+#define SSCR1_TINTE (1 << 19)		/* Receiver Time-out Interrupt enable */
+#define SSCR1_PINTE	       (1 << 18) /* Trailing Byte Interupt Enable */
+#define SSCR1_IFS		(1 << 16)	/* Invert Frame Signal */
+#define SSCR1_STRF (1 << 15)	       /* Select FIFO or EFWR */
+#define SSCR1_EFWR	      (1 << 14)		  /* Enable FIFO Write/Read */
+
+#define SSSR_BCE     (1 << 23)		 /* Bit Count Error */
+#define SSSR_CSS     (1 << 22)		 /* Clock Synchronisation Status */
+#define SSSR_TUR     (1 << 21)		 /* Transmit FIFO Under Run */
+#define SSSR_EOC    (1 << 20)		/* End Of Chain */
+#define SSSR_TINT     (1 << 19)		  /* Receiver Time-out Interrupt */
+#define SSSR_PINT    (1 << 18)	    /* Peripheral Trailing Byte Interrupt */
+
+#define SSPSP_FSRT (1 << 25)	       /* Frame Sync Relative Timing */
+#define SSPSP_DMYSTOP(x) ((x) << 23)	     /* Dummy Stop */
+#define SSPSP_SFRMWDTH(x) ((x) << 16)	   /* Serial Frame Width */
+#define SSPSP_SFRMDLY(x) ((x) << 9)	      /* Serial Frame Delay */
+#define SSPSP_DMYSTRT(x) ((x) << 7)	      /* Dummy Start */
+#define SSPSP_STRTDLY(x) ((x) << 4)	       /* Start Delay */
+#define SSPSP_ETDS	      (1 << 3) /* End of Transfer data State */
+#define SSPSP_SFRMP	     (1 << 2) /* Serial Frame Polarity */
+#define SSPSP_SCMODE(x)	  ((x) << 0)	       /* Serial Bit Rate Clock Mode */
+
+#define SSCR0	0x00
+#define SSCR1	0x04
+#define SSSR	0x08
+#define SSITR	0x0c
+#define SSDR	0x10
+#define SSTO	0x28
+#define SSPSP	0x2c
+#define SYSCFG	0x20bc0
+
+/* SSP assignement configuration from PCI config */
+#define SSP_CFG_GET_MODE(ssp_cfg)	((ssp_cfg) & 0x07)
+#define SSP_CFG_GET_SPI_BUS_NB(ssp_cfg)	(((ssp_cfg) >> 3) & 0x07)
+#define SSP_CFG_IS_SPI_SLAVE(ssp_cfg)	((ssp_cfg) & 0x40)
+#define SSP_CFG_SPI_MODE_ID		1
+/* adid field offset is 6 inside the vendor specific capability */
+#define VNDR_CAPABILITY_ADID_OFFSET	6
+
+/* spi_board_info.controller_data for SPI slave devices,
+ * copied to spi_device.platform_data ... mostly for dma tuning
+ */
+struct intel_mid_ssp_spi_chip {
+	u8 tx_threshold;
+	u8 rx_threshold;
+	u8 dma_burst_size;
+	u32 timeout;
+	u16 extra_data[5];
+};
+
+
+#endif /* INTEL_MID_SSP_SPI_DEF_H_ */
-- 
1.7.2.3

