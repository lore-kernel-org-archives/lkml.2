Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264Ab1LTCsT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 21:48:19 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43515 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754231Ab1LTCsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 21:48:04 -0500
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Mike Frysinger <vapier@gentoo.org>, Daniel Mack <zonque@gmail.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [PATCH 3/3 v2] sound/soc/lapis: add platform driver for ML7213 IOH I2S
Date: Tue, 20 Dec 2011 11:45:44 +0900
Message-Id: <1324349144-12784-3-git-send-email-tomoya.rohm@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1324349144-12784-1-git-send-email-tomoya.rohm@gmail.com>
References: <1324349144-12784-1-git-send-email-tomoya.rohm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
---
V2
 - Delete unused module_param "index"
 - Re-desing data structure. So, some internal functions interface are changed
 - Add dai interface functions (Includes format, sysclk, clkdiv)
 - Delete snd_device_new, snd_card_create snd_card_register
---
 sound/soc/lapis/Kconfig          |    5 +
 sound/soc/lapis/Makefile         |    2 +
 sound/soc/lapis/ioh_i2s.h        |   39 +
 sound/soc/lapis/ml7213ioh-plat.c | 2033 ++++++++++++++++++++++++++++++++++++++
 sound/soc/lapis/ml7213ioh-plat.h |  583 +++++++++++
 5 files changed, 2662 insertions(+), 0 deletions(-)
 create mode 100644 sound/soc/lapis/ioh_i2s.h
 create mode 100644 sound/soc/lapis/ml7213ioh-plat.c
 create mode 100644 sound/soc/lapis/ml7213ioh-plat.h

diff --git a/sound/soc/lapis/Kconfig b/sound/soc/lapis/Kconfig
index f6c2fe5..e10e729 100644
--- a/sound/soc/lapis/Kconfig
+++ b/sound/soc/lapis/Kconfig
@@ -1,3 +1,8 @@
+config SND_SOC_ML7213_PLATFORM
+	tristate "ML7213 IOH ASoC platform driver"
+	help
+	  This option enables support for the AC Link Controllers in ML7213 IOH SoC.
+
 config SND_SOC_ML7213_MACHINE
 	tristate "ML7213 IOH ASoC machine driver"
 	select SND_SOC_ML7213_PLATFORM
diff --git a/sound/soc/lapis/Makefile b/sound/soc/lapis/Makefile
index cdb196a..812290b 100644
--- a/sound/soc/lapis/Makefile
+++ b/sound/soc/lapis/Makefile
@@ -1,4 +1,6 @@
 # Platform
 snd-soc-ml7213-machine-objs := ml7213ioh-machine.o
+snd-soc-ml7213-plat-objs := ml7213ioh-plat.o
 
 obj-$(CONFIG_SND_SOC_ML7213_MACHINE) += snd-soc-ml7213-machine.o
+obj-$(CONFIG_SND_SOC_ML7213_PLATFORM) += snd-soc-ml7213-plat.o
diff --git a/sound/soc/lapis/ioh_i2s.h b/sound/soc/lapis/ioh_i2s.h
new file mode 100644
index 0000000..9f19f70
--- /dev/null
+++ b/sound/soc/lapis/ioh_i2s.h
@@ -0,0 +1,39 @@
+/*
+ * Copyright (C) 2011 LAPIS Semiconductor Co., Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307, USA.
+ */
+
+#ifndef ML7213_IOH_I2S
+#define ML7213_IOH_I2S
+
+enum ioh_bclkfs {
+	ML7213IOH_BCLKFS0 = 0,
+	ML7213IOH_BCLKFS1,
+	ML7213IOH_BCLKFS2,
+	ML7213IOH_BCLKFS3,
+	ML7213IOH_BCLKFS4,
+	ML7213IOH_BCLKFS5,
+};
+
+enum ioh_mclkfs {
+	ML7213IOH_MCLKFS0 = 6,
+	ML7213IOH_MCLKFS1,
+	ML7213IOH_MCLKFS2,
+	ML7213IOH_MCLKFS3,
+	ML7213IOH_MCLKFS4,
+	ML7213IOH_MCLKFS5,
+};
+
+#endif
diff --git a/sound/soc/lapis/ml7213ioh-plat.c b/sound/soc/lapis/ml7213ioh-plat.c
new file mode 100644
index 0000000..4b9ed3c
--- /dev/null
+++ b/sound/soc/lapis/ml7213ioh-plat.c
@@ -0,0 +1,2033 @@
+/*
+ * Copyright (C) 2011 LAPIS Semiconductor Co., Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307, USA.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/scatterlist.h>
+#include <linux/slab.h>
+#include <linux/delay.h>
+#include <linux/pci.h>
+#include <linux/clk.h>
+#include <linux/dma-mapping.h>
+#include <sound/core.h>
+#include <sound/pcm.h>
+#include <sound/pcm_params.h>
+#include <sound/soc.h>
+#include <sound/initval.h>
+
+#include "ioh_i2s.h"
+#include "ml7213ioh-plat.h"
+
+static struct ioh_i2s_data *i2s_data;
+static struct ioh_i2s_dma dmadata[MAX_I2S_CH];
+static int ignore_overrun = 1;
+module_param(ignore_overrun, int, 0444);
+MODULE_PARM_DESC(ignore_overrun, "ignore RX overruns (default=0)");
+
+/*****************************************************************************
+ *	I2S HAL (Hardware Abstruction Layer)
+ *****************************************************************************/
+static void ioh_i2s_reset(int ch)
+{
+	iowrite32(1 << ch, i2s_data->iobase + I2SSRST_OFFSET);
+	iowrite32(0, i2s_data->iobase + I2SSRST_OFFSET);
+}
+
+static void ioh_i2s_enable_interrupts(int ch, enum dma_data_direction dir)
+{
+	unsigned int intr_lines;
+
+	if (dir)
+		intr_lines = 1 << (I2S_IMASK_RX_BIT_START + ch);
+
+	else
+		intr_lines = 1 << (I2S_IMASK_TX_BIT_START + ch);
+
+	/*enable interrupts for specified channel */
+	iowrite32(intr_lines, i2s_data->iobase + I2SIMASKCLR_OFFSET);
+}
+
+static void ioh_i2s_disable_interrupts(int ch, enum dma_data_direction dir)
+{
+	unsigned int intr_lines;
+
+	/*intr_lines&=I2S_ALL_INTERRUPT_BITS; */
+	intr_lines = ioread32(i2s_data->iobase + I2SIMASK_OFFSET);
+
+	/*disable interrupts for specified channel */
+	if (dir)
+		intr_lines |= 1 << (I2S_IMASK_RX_BIT_START + ch);
+	else
+		intr_lines |= 1 << (I2S_IMASK_TX_BIT_START + ch);
+
+	/*Mask the specific interrupt bits */
+	iowrite32(intr_lines, i2s_data->iobase + I2SIMASK_OFFSET);
+}
+
+/* Run FIFO */
+static void ioh_i2s_run_tx_fifo(int ch)
+{
+	int offset = ch * 0x800;
+	u32 val;
+
+	val = ioread32(i2s_data->iobase + I2SFIFOCTX_OFFSET + offset);
+	val |= I2S_FIFO_TX_RUN;
+
+	iowrite32(val, i2s_data->iobase + I2SFIFOCTX_OFFSET + offset);
+}
+
+/* Clear TX FIFO */
+static void ioh_i2s_clear_tx_fifo(int ch)
+{
+	int offset = ch * 0x800;
+	u32 val;
+
+	val = ioread32(i2s_data->iobase + I2SFIFOCTX_OFFSET + offset);
+	val |= I2S_FIFO_TX_FCLR;
+
+	iowrite32(val, i2s_data->iobase + I2SFIFOCTX_OFFSET + offset);
+}
+
+/* Clear interrupt status */
+static void ioh_i2s_clear_tx_sts_ir(int ch)
+{
+	int offset = ch * 0x800;
+
+	iowrite32(I2S_TX_FINT | I2S_TX_AFINT | I2S_TX_EINT | I2S_TX_AEINT,
+		i2s_data->iobase + I2SISTTX_OFFSET + offset);
+}
+
+/* Run FIFO */
+static void ioh_i2s_run_rx_fifo(int ch)
+{
+	int offset = ch * 0x800;
+	u32 val;
+
+	val = ioread32(i2s_data->iobase + I2SFIFOCRX_OFFSET + offset);
+	val |= I2S_FIFO_RX_RUN;
+	iowrite32(val, i2s_data->iobase + I2SFIFOCRX_OFFSET + offset);
+}
+
+/* Clear RX FIFO */
+static void ioh_i2s_clear_rx_fifo(int ch)
+{
+	int offset = ch * 0x800;
+	u32 val;
+
+	val = ioread32(i2s_data->iobase + I2SFIFOCRX_OFFSET + offset);
+	val |= I2S_FIFO_RX_FCLR;
+	iowrite32(val, i2s_data->iobase + I2SFIFOCRX_OFFSET + offset);
+}
+
+/* Clear interrupt status */
+static void ioh_i2s_clear_rx_sts_ir(int ch)
+{
+	int offset = ch * 0x800;
+
+	iowrite32(I2S_RX_FINT | I2S_RX_AFINT | I2S_RX_EINT | I2S_RX_AEINT,
+		i2s_data->iobase + I2SISTRX_OFFSET + offset);
+}
+
+/* Clear DMA mask setting */
+static void ioh_i2s_tx_clear_dma_mask(int ch)
+{
+	int offset = ch * 0x800;
+	u32 val;
+
+	val = ioread32(i2s_data->iobase + I2SMSKTX_OFFSET + offset);
+	val &= ~TX_BIT_DMAMSK; /* Enable Tx DMA Request */
+
+	iowrite32(val, i2s_data->iobase + I2SMSKTX_OFFSET + offset);
+}
+
+/* Clear DMA mask setting */
+static void ioh_i2s_rx_clear_dma_mask(int ch)
+{
+	int offset = ch * 0x800;
+	u32 val;
+
+	val = ioread32(i2s_data->iobase + I2SMSKRX_OFFSET + offset);
+	val &= ~RX_BIT_DMAMSK; /* Enable Rx DMA Request */
+	iowrite32(val, i2s_data->iobase + I2SMSKRX_OFFSET + offset);
+}
+
+/* Clear the mask setting of the corresponding interrupt source bit */
+static void ioh_i2s_enable_tx_empty_ir(int ch)
+{
+	int offset = ch * 0x800;
+	u32 val;
+
+	val = ioread32(i2s_data->iobase + I2SMSKTX_OFFSET + offset);
+	val &= ~TX_BIT_AEIMSK; /* Enable Almost empty interrupt */
+	val &= ~TX_BIT_EIMSK; /* Enable Empty interrupt */
+
+	iowrite32(val, i2s_data->iobase + I2SMSKTX_OFFSET + offset);
+}
+
+/* Clear the mask setting of the corresponding interrupt source bit */
+static void ioh_i2s_enable_rx_full_ir(int ch)
+{
+	int offset = ch * 0x800;
+	u32 val;
+	val = ioread32(i2s_data->iobase + I2SMSKRX_OFFSET + offset);
+
+	val &= ~RX_BIT_AFIMSK; /* Enable Almost empty interrupt */
+	val &= ~RX_BIT_FIMSK; /* Enable Empty interrupt */
+
+	iowrite32(val, i2s_data->iobase + I2SMSKRX_OFFSET + offset);
+}
+
+static void ioh_i2s_disable_tx_empty_ir(int ch)
+{
+	int offset = ch * 0x800;
+	u32 val;
+
+	val = ioread32(i2s_data->iobase + I2SMSKTX_OFFSET + offset);
+	val |= TX_BIT_AEIMSK; /* Disble Almost empty interrupt */
+	val |= TX_BIT_EIMSK; /* Disble Empty interrupt */
+
+	iowrite32(val, i2s_data->iobase + I2SMSKTX_OFFSET + offset);
+}
+
+static void ioh_i2s_disable_rx_full_ir(int ch)
+{
+	int offset = ch * 0x800;
+	u32 val;
+
+	val = ioread32(i2s_data->iobase + I2SMSKRX_OFFSET + offset);
+	val |= RX_BIT_AFIMSK; /* Disble Almost full interrupt */
+	val |= RX_BIT_FIMSK; /* Disble full interrupt */
+
+	iowrite32(val, i2s_data->iobase + I2SMSKRX_OFFSET + offset);
+}
+
+/*****************************************************************************
+ *	I2S Middle ware
+ *****************************************************************************/
+static bool filter(struct dma_chan *chan, void *slave)
+{
+	struct pch_dma_slave *param = slave;
+
+	if ((chan->chan_id == param->chan_id) && (param->dma_dev ==
+						  chan->device->dev)) {
+		chan->private = param;
+		return true;
+	} else {
+		return false;
+	}
+}
+
+static struct dma_chan *ioh_request_dma_channel(
+		   int ch, struct ioh_i2s_dma *dma, enum dma_data_direction dir)
+{
+	dma_cap_mask_t mask;
+	struct dma_chan *chan;
+	struct pci_dev *dma_dev;
+	dma_cap_zero(mask);
+	dma_cap_set(DMA_SLAVE, mask);
+
+	dma_dev = pci_get_bus_and_slot(2, PCI_DEVFN(0, 1)); /* Get DMA's dev
+								information */
+
+	if (dir == DMA_FROM_DEVICE) { /* Rx */
+		dma->param_rx.width = dma->dma_rx_width;
+		dma->param_rx.dma_dev = &dma_dev->dev;
+		dma->param_rx.chan_id = ch * 2 + 1; /* ch Rx=1,3,...11 */
+		dma->param_rx.rx_reg = (dma_addr_t)(i2s_data->mapbase +\
+					ch * 0x800 + I2SDRRXMIRROR_OFFSET);
+		chan = dma_request_channel(mask, filter, &dma->param_rx);
+		if (chan == NULL) {
+			dev_err(i2s_data->dev, "Failed dma_request_channel for"
+				" I2S %d\n", ch);
+			return NULL;
+		}
+		dma->chan_rx = chan;
+
+	} else if (dir == DMA_TO_DEVICE) { /* Tx */
+		dma->param_tx.width = dma->dma_tx_width;
+		dma->param_tx.dma_dev = &dma_dev->dev;
+		dma->param_tx.chan_id = ch * 2; /* DMA ch Tx=0,2,...10 */
+
+		dma->param_tx.tx_reg = (dma_addr_t)(i2s_data->mapbase +\
+					ch * 0x800 + I2SDRTXMIRROR_OFFSET);
+
+		chan = dma_request_channel(mask, filter, &dma->param_tx);
+		if (chan == NULL) {
+			dev_err(i2s_data->dev, "Failed dma_request_channel for"
+				" I2S %d\n", ch);
+			return NULL;
+		}
+		dma->chan_tx = chan;
+	} else {
+		dev_err(i2s_data->dev, "Invalid direction (%d)\n", dir);
+		return NULL;
+	}
+
+	return chan;
+}
+
+static void ioh_i2s_ignore_rx_overrun(void)
+{
+	i2s_data->ignore_rx_overrun = 1;
+}
+
+static void
+ioh_i2s_write(struct snd_pcm_substream *substream, const void *data, int len)
+{
+	int rem1;
+	int rem2;
+	int tx_index;
+	int ch = substream->number;
+	struct ioh_i2s_dma *dma = &dmadata[ch];
+	struct scatterlist *sg = dma->sg_tx_p;
+	int t_num = 0;
+	int l;
+	int *ptr_fmt;
+	int *ptr32;
+	short *ptr16;
+	char *ptr8;
+	int tx_unit = dmadata[ch].dma_tx_unit;
+	struct device *dev = substream->pcm->card->dev;
+
+	if (dma->tx_avail >= INTER_BUFF_SIZE) {
+		dev_err(dev, "%s[%d]: internal buffer full\n",
+			__func__, ch);
+		return;
+	}
+
+	dev_dbg(dev, "%s: [ch%d] len=%d data_head=%p data_complete=%p",
+		__func__, ch, len, dma->tx_data_head, dma->tx_complete);
+
+	if ((dma->tx_data_head + ((len/tx_unit) * 4)) <= dma->tx_tail) {
+		tx_index = (int)(dma->tx_data_head - dma->tx_head) /
+				(I2S_AEMPTY_THRESH * 4);
+		sg = sg + tx_index;
+		t_num = len/(I2S_AEMPTY_THRESH * tx_unit);
+		dma_sync_sg_for_cpu(dev, sg, t_num, DMA_TO_DEVICE);
+
+		ptr_fmt = (int *)dma->tx_data_head;
+		switch (tx_unit) {
+		case 1:
+			ptr8 = (char *)data;
+			for (l = 0; l < (len/tx_unit); l++)
+				*ptr_fmt++ = (int)*ptr8++;
+			break;
+		case 2:
+			ptr16 = (short *)data;
+			for (l = 0; l < (len/tx_unit); l++)
+				*ptr_fmt++ = (int)*ptr16++;
+			break;
+		case 4:
+			ptr32 = (int *)data;
+			for (l = 0; l < (len/tx_unit); l++)
+				*ptr_fmt++ = *ptr32++;
+			break;
+		}
+		dma_sync_sg_for_device(dev, sg, t_num, DMA_TO_DEVICE);
+		dma->tx_data_head += (len/tx_unit) * 4;
+	} else {
+		rem1 = (dma->tx_tail - dma->tx_data_head) / 4;
+		rem2 = (len/tx_unit) - rem1;
+		tx_index = (int)(dma->tx_data_head-dma->tx_head) /
+				(I2S_AEMPTY_THRESH * 4);
+		sg = sg + tx_index;
+		t_num = rem1/I2S_AEMPTY_THRESH;
+		dma_sync_sg_for_cpu(dev, sg, t_num, DMA_TO_DEVICE);
+		ptr_fmt = (int *)dma->tx_data_head;
+		switch (tx_unit) {
+		case 1:
+			ptr8 = (char *)data;
+			for (l = 0; l < rem1; l++)
+				*ptr_fmt++ = (int)*ptr8++;
+			break;
+		case 2:
+			ptr16 = (short *)data;
+			for (l = 0; l < rem1; l++)
+				*ptr_fmt++ = (int)*ptr16++;
+			break;
+		case 4:
+			ptr32 = (int *)data;
+			for (l = 0; l < rem1; l++)
+				*ptr_fmt++ = *ptr32++;
+			break;
+		}
+
+		dma_sync_sg_for_device(dev, sg, t_num, DMA_TO_DEVICE);
+		dma->tx_data_head = dma->tx_head;
+		sg = dma->sg_tx_p;
+		t_num = rem2/I2S_AEMPTY_THRESH;
+		dma_sync_sg_for_cpu(dev, sg, t_num, DMA_TO_DEVICE);
+
+		ptr_fmt = (int *)dma->tx_data_head;
+
+		switch (tx_unit) {
+		case 1:
+			ptr8 = (char *)(data+rem1*tx_unit);
+			for (l = 0; l < rem2; l++)
+				*ptr_fmt++ = (int)*ptr8++;
+			break;
+		case 2:
+			ptr16 = (short *)(data+rem1*tx_unit);
+			for (l = 0; l < rem2; l++)
+				*ptr_fmt++ = (int)*ptr16++;
+			break;
+		case 4:
+			ptr32 = (int *)(data+rem1*tx_unit);
+			for (l = 0; l < rem2; l++)
+				*ptr_fmt++ = *ptr32++;
+			break;
+		}
+
+		dma_sync_sg_for_device(dev, sg, t_num, DMA_TO_DEVICE);
+		dma->tx_data_head += rem2 * 4;
+	}
+
+	if (dma->tx_data_head >= dma->tx_tail)
+		dma->tx_data_head = dma->tx_head;
+
+	dev_dbg(dev, "-->data_head=%p\n", dma->tx_data_head);
+
+	dma->tx_avail += (len/tx_unit) * 4;
+}
+
+static void ioh_i2s_stop_i2s_regs(int ch, enum ioh_direction dir)
+{
+	if (dir) {
+		/* Interrupt stop */
+		ioh_i2s_disable_rx_full_ir(ch);
+
+		/* FIFO setting */
+		ioh_i2s_clear_rx_fifo(ch);
+		ioh_i2s_clear_rx_sts_ir(ch);
+	} else {
+		/* Interrupt stop */
+		ioh_i2s_disable_tx_empty_ir(ch);
+
+		/* FIFO setting */
+		ioh_i2s_clear_tx_fifo(ch);
+		ioh_i2s_clear_tx_sts_ir(ch);
+	}
+}
+
+static void ioh_i2s_configure_i2s_regs(int ch, enum ioh_direction dir)
+{
+	int offset = ch * 0x800;
+
+	if (dir) {
+		/* Rx register */
+		iowrite32(I2S_AFULL_THRESH / 2,
+			  i2s_data->iobase + I2SAFRX_OFFSET + offset);
+		iowrite32(0x1F, i2s_data->iobase + I2SAERX_OFFSET + offset);
+		iowrite32(0x1F, i2s_data->iobase + I2SMSKRX_OFFSET + offset);
+		iowrite32(0xC, i2s_data->iobase + I2SISTRX_OFFSET + offset);
+
+		/* FIFO setting */
+		ioh_i2s_clear_rx_fifo(ch);
+		ioh_i2s_run_rx_fifo(ch);
+
+		/* Interrupt setting */
+		ioh_i2s_clear_rx_sts_ir(ch);
+		ioh_i2s_enable_rx_full_ir(ch);
+
+	} else {
+		iowrite32(0x0, i2s_data->iobase + I2SAFTX_OFFSET + offset);
+		iowrite32(I2S_AEMPTY_THRESH / 2,
+			  i2s_data->iobase + I2SAETX_OFFSET + offset);
+		iowrite32(0x1F, i2s_data->iobase + I2SMSKTX_OFFSET + offset);
+		iowrite32(0xC, i2s_data->iobase + I2SISTTX_OFFSET + offset);
+
+		/* FIFO setting */
+		ioh_i2s_clear_tx_fifo(ch);
+		ioh_i2s_run_tx_fifo(ch);
+
+		/* Interrupt setting */
+		ioh_i2s_clear_tx_sts_ir(ch);
+		ioh_i2s_enable_tx_empty_ir(ch);
+	}
+}
+
+static void i2s_rx_tasklet(unsigned long data)
+{
+	struct ioh_i2s_data *priv = (struct ioh_i2s_data *)data;
+	struct ioh_i2s_dma *dma = &dmadata[priv->ch];
+	int num = 0;
+
+	if (dma->rxexe_flag) {
+		if (dma->rx_done) {
+			switch (dma->dma_rx_unit) {
+			case 1:
+				num = dma->rx_avail / 4;
+				break;
+			case 2:
+				num = dma->rx_avail / 2;
+				break;
+			case 4:
+				num = dma->rx_avail;
+				break;
+			}
+			dma->rx_done(dma->rx_callback_data, IOH_EOK, num, num);
+		}
+	}
+}
+
+static void i2s_tx_tasklet(unsigned long data)
+{
+	struct ioh_i2s_data *priv = (struct ioh_i2s_data *)data;
+	struct ioh_i2s_dma *dma = &dmadata[priv->ch];
+	int num = 0;
+	int avail = 0;
+
+	if (dma->txexe_flag) {
+		if (dma->tx_done) {
+			switch (dmadata[priv->ch].dma_tx_unit) {
+			case 1:
+				num = (INTER_BUFF_SIZE - dma->tx_avail) / 4;
+				avail = dma->tx_avail / 4;
+				break;
+			case 2:
+				num = (INTER_BUFF_SIZE - dma->tx_avail) / 2;
+				avail = dma->tx_avail / 2;
+				break;
+			case 4:
+				num = (INTER_BUFF_SIZE - dma->tx_avail);
+				avail = dma->tx_avail;
+				break;
+			}
+			dma->tx_done(dma->tx_callback_data,
+				      IOH_EOK, num, avail);
+		}
+	}
+}
+
+static void ioh_i2s_release(int ch, enum ioh_direction dir)
+{
+	struct ioh_i2s_dma *dma;
+
+	dma = &dmadata[ch];
+	if (dir) {
+		dma_sync_sg_for_cpu(i2s_data->dev, dma->sg_rx_p, dma->rx_nent,
+				    DMA_FROM_DEVICE);
+
+		ioh_i2s_disable_interrupts(ch, IOH_CAPTURE);
+		ioh_i2s_disable_rx_full_ir(ch);
+		if (dma->chan_rx) {
+			dma->chan_rx->device->device_control(dma->chan_rx,
+							     DMA_TERMINATE_ALL,
+							     0);
+			dma_release_channel(dma->chan_rx);
+			dma->chan_rx = NULL;
+		}
+
+		kfree(dma->sg_rx_p);
+		if (dma->rxbuf_virt)
+			dma_free_coherent(i2s_data->dev, INTER_BUFF_SIZE,
+					  dma->rxbuf_virt, dma->rx_buf_dma);
+
+		dma->rxbuf_virt = NULL;
+		dma->rx_buf_dma = 0;
+		atomic_dec(&dma->rx_busy);
+
+		tasklet_disable(&dma->rx_tasklet);
+		tasklet_kill(&dma->rx_tasklet);
+
+	} else {
+		dma_sync_sg_for_cpu(i2s_data->dev, dma->sg_tx_p, dma->tx_nent,
+				    DMA_TO_DEVICE);
+
+		ioh_i2s_disable_interrupts(ch, IOH_PLAYBACK);
+		ioh_i2s_disable_tx_empty_ir(ch);
+		if (dma->chan_tx) {
+			dma->chan_tx->device->device_control(dma->chan_tx,
+							     DMA_TERMINATE_ALL,
+							     0);
+			dma_release_channel(dma->chan_tx);
+			dma->chan_tx = NULL;
+		}
+
+		kfree(dma->sg_tx_p);
+		if (dma->txbuf_virt)
+			dma_free_coherent(i2s_data->dev, INTER_BUFF_SIZE,
+					  dma->txbuf_virt, dma->tx_buf_dma);
+
+		dma->txbuf_virt = NULL;
+		dma->tx_buf_dma = 0;
+		atomic_dec(&dma->tx_busy);
+
+		tasklet_disable(&dma->tx_tasklet);
+		tasklet_kill(&dma->tx_tasklet);
+	}
+}
+
+static struct ioh_i2s_data *ioh_i2s_open(int ch, enum ioh_direction dir,
+					 const char *name)
+{
+	struct ioh_i2s_data *obj = NULL;
+	struct scatterlist *sg;
+	int rx_size;
+	int rx_num;
+	int tx_size;
+	int tx_num;
+	int i;
+	struct ioh_i2s_dma *dma;
+
+	if (ch >= MAX_I2S_CH) {
+		dev_err(obj->dev,
+			"Tried to open i2s with number %d which is more then"
+			" the available number\n", ch);
+		return 0;
+	}
+
+	dma = &dmadata[ch];
+	i2s_data = kzalloc(sizeof(*i2s_data), GFP_KERNEL);
+	i2s_data->ignore_rx_overrun = 0;
+
+	atomic_set(&dma->rx_busy, 0);
+	atomic_set(&dma->tx_busy, 0);
+
+	dma->dma_tx_width = PCH_DMA_WIDTH_4_BYTES;
+	dma->dma_rx_width = PCH_DMA_WIDTH_4_BYTES;
+
+	if (dir) {
+		/* Rx configuration */
+		if (atomic_read(&dma->rx_busy)) {
+			dev_err(i2s_data->dev, "rx i2s%dalready opened\n", ch);
+			atomic_dec(&dma->rx_busy);
+			return NULL;
+		}
+		atomic_inc(&dma->rx_busy);
+
+		ioh_request_dma_channel(ch, dma, DMA_FROM_DEVICE);
+		if (!dma->chan_rx) {
+			dev_err(obj->dev, "%s:ioh_setup_rx_dma failed\n",
+				__func__);
+			return NULL;
+		}
+
+		dma->rxbuf_virt = dma_alloc_coherent(obj->dev, INTER_BUFF_SIZE,
+						&dma->rx_buf_dma, GFP_KERNEL);
+		if (!dma->rxbuf_virt) {
+			dev_err(obj->dev, "dma_alloc_coherent Failed\n");
+			return NULL;
+		}
+
+		rx_size = I2S_AFULL_THRESH * 4;
+		/* The number of scatter list (Franction area is not used) */
+		rx_num = INTER_BUFF_SIZE / rx_size;
+
+		dev_dbg(obj->dev, "%s: rx: scatter_num=%d scatter_size=%d\n",
+			__func__, rx_num, rx_size);
+
+		dma->sg_rx_p =\
+		       kzalloc(sizeof(struct scatterlist) * rx_num, GFP_ATOMIC);
+
+		sg = dma->sg_rx_p;
+		sg_init_table(sg, rx_num); /* Initialize SG table */
+
+		for (i = 0; i < rx_num; i++, sg++) {
+			sg_set_page(sg, virt_to_page(dma->rxbuf_virt), rx_size,
+				    rx_size * i);
+			sg_dma_len(sg) = rx_size / 4;
+			sg_dma_address(sg) = dma->rx_buf_dma + sg->offset;
+		}
+
+		dma->rx_head = (unsigned char *)dma->rxbuf_virt;
+		dma->rx_tail = (unsigned char *)dma->rxbuf_virt +
+			       rx_num * rx_size;
+		dma->rx_data_head = (unsigned char *)dma->rxbuf_virt;
+		dma->rx_complete = (unsigned char *)dma->rxbuf_virt;
+		dma->rx_avail = 0;
+
+		dma->rx_nent = rx_num;
+		dma_sync_sg_for_device(obj->dev, dma->sg_rx_p, dma->rx_nent,
+				       DMA_FROM_DEVICE);
+
+		tasklet_init(&dma->rx_tasklet, i2s_rx_tasklet,
+			     (unsigned long)obj);
+	} else {
+		/* Tx configuration */
+		if (atomic_read(&dma->tx_busy)) {
+			dev_err(obj->dev, "tx i2s%d have already opened\n", ch);
+			atomic_dec(&dma->tx_busy);
+			return NULL;
+		}
+		atomic_inc(&dma->tx_busy);
+
+		ioh_request_dma_channel(ch, dma, DMA_TO_DEVICE);
+
+		if (!dma->chan_tx) {
+			dev_err(obj->dev, "%s:ioh_setup_tx_dma failed\n",
+				__func__);
+			return NULL;
+		}
+
+		tx_size = I2S_AEMPTY_THRESH * 4;
+		if (INTER_BUFF_SIZE % tx_size)
+			/* tx_num = The number of scatter list */
+			tx_num = INTER_BUFF_SIZE / tx_size + 1;
+		else
+			tx_num = INTER_BUFF_SIZE / tx_size;
+
+		dma->txbuf_virt = dma_alloc_coherent(obj->dev, INTER_BUFF_SIZE,
+						&dma->tx_buf_dma, GFP_KERNEL);
+
+		if (!dma->txbuf_virt) {
+			dev_err(obj->dev, "dma_alloc_coherent Failed\n");
+			return NULL;
+		}
+
+		dma->tx_head = (unsigned char *)dma->txbuf_virt;
+		dma->tx_tail = (unsigned char *)dma->txbuf_virt +
+			       INTER_BUFF_SIZE;
+		dma->tx_data_head = (unsigned char *)dma->txbuf_virt;
+		dma->tx_complete = (unsigned char *)dma->txbuf_virt;
+		dma->tx_avail = 0;
+
+		dev_dbg(obj->dev, "%s: tx: scatter_num=%d scatter_size=%d\n",
+			__func__, tx_num, tx_size);
+
+		dma->sg_tx_p =\
+		       kzalloc(sizeof(struct scatterlist) * tx_num, GFP_ATOMIC);
+
+		sg_init_table(dma->sg_tx_p, tx_num); /* Initialize SG table */
+		sg = dma->sg_tx_p;
+
+		for (i = 0; i < tx_num; i++, sg++) {
+			if (i == (tx_num - 1)) {
+				if (INTER_BUFF_SIZE % tx_size) {
+					sg_set_page(sg,
+						  virt_to_page(dma->txbuf_virt),
+						  INTER_BUFF_SIZE % tx_size,
+						  tx_size * i);
+					sg_dma_len(sg) =
+						  (INTER_BUFF_SIZE % tx_size)
+						  / 4;
+				} else {
+					sg_set_page(sg,
+						  virt_to_page(dma->txbuf_virt),
+						  tx_size, tx_size * i);
+					sg_dma_len(sg) = tx_size / 4;
+				}
+			} else {
+				sg_set_page(sg, virt_to_page(dma->txbuf_virt),
+					    tx_size, tx_size * i);
+				sg_dma_len(sg) = tx_size / 4;
+			}
+			sg_dma_address(sg) = dma->tx_buf_dma + sg->offset;
+		}
+		dma->tx_nent = tx_num;
+		dma_sync_sg_for_device(obj->dev, dma->sg_tx_p, dma->tx_nent,
+				       DMA_TO_DEVICE);
+
+		tasklet_init(&dma->tx_tasklet, i2s_tx_tasklet,
+			     (unsigned long)obj);
+	}
+
+	return obj;
+}
+
+static void
+ioh_i2s_read(struct snd_pcm_substream *substream, void *data, int len)
+{
+	unsigned int rem1 = 0, rem2 = 0;
+	int ch = substream->number;
+	struct ioh_i2s_dma *dma = &dmadata[ch];
+	struct scatterlist *sg = dma->sg_rx_p;
+	int rx_index;
+	int t_num = 0;
+	int *ptr_fmt;
+	int *ptr32;
+	short *ptr16;
+	char *ptr8;
+	int l;
+	int rx_unit = dma->dma_rx_unit;
+	struct device *dev = substream->pcm->card->dev;
+
+	switch (rx_unit) {
+	case 1:
+		t_num = dma->rx_avail / 4;
+		break;
+	case 2:
+		t_num = dma->rx_avail / 2;
+		break;
+	case 4:
+		t_num = dma->rx_avail;
+		break;
+	}
+
+	if (t_num < len) {
+		dev_err(dev, "%s[%d]: internal buffer empty\n",
+			__func__, ch);
+		return;
+	}
+
+	if ((dma->rx_complete + ((len/rx_unit) * 4)) <= dma->rx_tail) {
+		rx_index = (int)(dma->rx_complete - dma->rx_head) /
+				(I2S_AFULL_THRESH * 4);
+		sg = sg + rx_index;
+		t_num = len/(I2S_AFULL_THRESH * rx_unit);
+		dma_sync_sg_for_cpu(dev, sg, t_num, DMA_FROM_DEVICE);
+
+		ptr_fmt = (int *)dma->rx_complete;
+		switch (rx_unit) {
+		case 1:
+			ptr8 = (char *)data;
+			for (l = 0; l < (len/rx_unit); l++)
+				*ptr8++ = (char)*ptr_fmt++;
+			break;
+		case 2:
+			ptr16 = (short *)data;
+			for (l = 0; l < (len/rx_unit); l++)
+				*ptr16++ = (short)*ptr_fmt++;
+			break;
+		case 4:
+			ptr32 = (int *)data;
+			for (l = 0; l < (len/rx_unit); l++)
+				*ptr32++ = *ptr_fmt++;
+			break;
+		}
+		dma_sync_sg_for_device(dev, sg, t_num, DMA_FROM_DEVICE);
+		dma->rx_complete += (len/rx_unit) * 4;
+	} else {
+		rem1 = (dma->rx_tail - dma->rx_complete) / 4;
+		rem2 = (len/rx_unit) - rem1;
+		rx_index = (int)(dma->rx_complete-dma->rx_head) /
+				(I2S_AFULL_THRESH * 4);
+		sg = sg + rx_index;
+		t_num = rem1/I2S_AFULL_THRESH;
+		dma_sync_sg_for_cpu(dev, sg, t_num, DMA_FROM_DEVICE);
+		ptr_fmt = (int *)dma->rx_complete;
+		switch (rx_unit) {
+		case 1:
+			ptr8 = (char *)data;
+			for (l = 0; l < rem1; l++)
+				*ptr8++ = (char)*ptr_fmt++;
+			break;
+		case 2:
+			ptr16 = (short *)data;
+			for (l = 0; l < rem1; l++)
+				*ptr16++ = (short)*ptr_fmt++;
+			break;
+		case 4:
+			ptr32 = (int *)data;
+			for (l = 0; l < rem1; l++)
+				*ptr32++ = *ptr_fmt++;
+			break;
+		}
+		dma_sync_sg_for_device(dev, sg, t_num, DMA_FROM_DEVICE);
+		dma->rx_complete = dma->rx_head;
+		sg = dma->sg_rx_p;
+		t_num = rem2/I2S_AFULL_THRESH;
+		dma_sync_sg_for_cpu(dev, sg, t_num, DMA_FROM_DEVICE);
+		ptr_fmt = (int *)dma->rx_complete;
+		switch (rx_unit) {
+		case 1:
+			ptr8 = (char *)(data+rem1*rx_unit);
+			for (l = 0; l < rem2; l++)
+				*ptr8++ = (char)*ptr_fmt++;
+			break;
+		case 2:
+			ptr16 = (short *)(data+rem1*rx_unit);
+			for (l = 0; l < rem2; l++)
+				*ptr16++ = (short)*ptr_fmt++;
+			break;
+		case 4:
+			ptr32 = (int *)(data+rem1*rx_unit);
+			for (l = 0; l < rem2; l++)
+				*ptr32++ = *ptr_fmt++;
+			break;
+		}
+		dma_sync_sg_for_device(dev, sg, t_num, DMA_FROM_DEVICE);
+		dma->rx_complete += rem2 * 4;
+	}
+
+	if (dma->rx_complete >= dma->rx_tail)
+		dma->rx_complete = dma->rx_head;
+
+	dma->rx_avail -= (len/rx_unit) * 4;
+}
+
+static void i2s_dma_rx_complete(void *arg)
+{
+	int ch = (int)arg;
+	struct ioh_i2s_dma *dma = &dmadata[ch];
+	struct scatterlist *sg = dma->sg_rx_cur;
+	int num = dma->rx_num;
+	int i;
+
+	async_tx_ack(dma->desc_rx);
+
+	for (i = 0; i < num; i++, sg++) {
+		dma->rx_data_head += sg_dma_len(sg) * 4;
+		dma->rx_avail += sg_dma_len(sg) * 4;
+	}
+
+	if (dma->rx_data_head >= dma->rx_tail)
+		dma->rx_data_head = dma->rx_head;
+
+	ioh_i2s_clear_rx_sts_ir(ch);
+	ioh_i2s_enable_rx_full_ir(ch);
+	kfree(arg);
+}
+
+static void i2s_dma_tx_complete(void *arg)
+{
+	int ch = (int)arg;
+	struct ioh_i2s_dma *dma = &dmadata[ch];
+	struct scatterlist *sg = dma->sg_tx_cur;
+	int num = dma->tx_num;
+	int i;
+
+	async_tx_ack(dma->desc_tx);
+
+	for (i = 0; i < num; i++, sg++) {
+		dma->tx_complete += sg_dma_len(sg) * 4;
+		dma->tx_avail -= sg_dma_len(sg) * 4;
+	}
+
+	if (dma->tx_complete >= dma->tx_tail)
+		dma->tx_complete = dma->tx_head;
+	ioh_i2s_clear_tx_sts_ir(ch);
+	ioh_i2s_enable_tx_empty_ir(ch);
+	kfree(arg);
+}
+
+/*****************************************************************************
+ *	Interrupt control
+ *****************************************************************************/
+static void i2s_tx_almost_empty_ir(int ch)
+{
+	struct dma_async_tx_descriptor *desc;
+	int num;
+	int tx_comp_index;
+	struct ioh_i2s_dma *dma = &dmadata[ch];
+	struct scatterlist *sg = dma->sg_tx_p;
+	void *cb_ch;
+
+	dev_dbg(i2s_data->dev, "%s: data_head=%p data_complete=%p\n", __func__,
+		dma->tx_data_head, dma->tx_complete);
+
+	num = ((int)dma->tx_avail) / (I2S_AEMPTY_THRESH * 4);
+
+	tx_comp_index = (((int)(dma->tx_complete - dma->tx_head))) /\
+			(I2S_AEMPTY_THRESH * 4);
+
+	if ((tx_comp_index + num) >= dma->tx_nent)
+		num = dma->tx_nent - tx_comp_index;
+
+	if (num > I2S_DMA_SG_NUM)
+		num = I2S_DMA_SG_NUM;
+
+	if (!num) {
+		dev_err(i2s_data->dev, "%s:Internal buffer empty\n",
+			__func__);
+		tasklet_schedule(&dma->tx_tasklet);
+		return; /* No data to transmit */
+	}
+
+	sg = sg + tx_comp_index; /* Point head of sg must be sent */
+	dma->sg_tx_cur = sg; /* Save tx condition */
+	dma->tx_num = num; /* Save tx condition */
+
+	desc = dma->chan_tx->device->device_prep_slave_sg(dma->chan_tx,
+					sg, num, DMA_TO_DEVICE,
+					DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+
+	if (!desc) {
+		dev_err(i2s_data->dev, "%s:device_prep_slave_sg Failed\n",
+			__func__);
+		return;
+	}
+
+	/* To prevent this function from calling again before DMA completion */
+	ioh_i2s_disable_tx_empty_ir(ch);
+
+	dma->desc_tx = desc;
+
+	cb_ch = kzalloc(sizeof(int), GFP_KERNEL);
+	cb_ch = (void *)ch;
+
+	desc->callback = i2s_dma_tx_complete;
+	desc->callback_param = cb_ch;
+
+	atomic_inc(&dma->pending_tx);
+	desc->tx_submit(desc);
+
+	tasklet_schedule(&dma->tx_tasklet);
+}
+
+void i2s_tx_empty_ir(int ch)
+{
+	dev_warn(i2s_data->dev, "%s:I2S%d under flow occurs\n", __func__, ch);
+}
+
+void i2s_rx_full_ir(int ch)
+{
+	dev_warn(i2s_data->dev, "%s:I2S%d overrun occurs\n", __func__, ch);
+}
+
+static inline void ioh_i2s_interrupt_sub_tx(int ch)
+{
+	unsigned int status;
+	int offset = ch * 0x800;
+
+	status = ioread32(i2s_data->iobase + I2SISTTX_OFFSET + offset);
+	if (status & I2S_TX_EINT)
+		i2s_tx_empty_ir(ch);
+	if (status & I2S_TX_AEINT)
+		i2s_tx_almost_empty_ir(ch);
+
+	/*Clear the interrupt status */
+	iowrite32(status, i2s_data->iobase + I2SISTTX_OFFSET + offset);
+}
+
+static void i2s_rx_almost_full_ir(int ch)
+{
+	struct dma_async_tx_descriptor *desc;
+	struct scatterlist *sg;
+	int rx_data_index;
+	int num;
+	void *cb_ch;
+	struct ioh_i2s_dma *dma = &dmadata[ch];
+
+	num = (int)(INTER_BUFF_SIZE - dma->rx_avail) / (I2S_AFULL_THRESH * 4);
+	if (num < 1) {
+		dev_err(i2s_data->dev, "%s:Internal buffer full\n",
+			__func__);
+		tasklet_schedule(&dma->rx_tasklet);
+		return;
+	}
+
+	sg = dma->sg_rx_p;
+	rx_data_index = ((int)(dma->rx_data_head - dma->rx_head)) /\
+			(I2S_AFULL_THRESH * 4);
+
+	if ((rx_data_index + num) >= dma->rx_nent)
+		num = dma->rx_nent - rx_data_index;
+
+	if (num > I2S_DMA_SG_NUM)
+		num = I2S_DMA_SG_NUM;
+
+	sg += rx_data_index;
+
+	desc = dma->chan_rx->device->device_prep_slave_sg(dma->chan_rx,
+			sg, num, DMA_FROM_DEVICE,
+			DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+	if (!desc) {
+		dev_err(i2s_data->dev, "%s:device_prep_slave_sg Failed\n",
+			__func__);
+		return;
+	}
+
+	dma->sg_rx_cur = sg; /* Save rx condition */
+	ioh_i2s_disable_rx_full_ir(ch);
+	dma->rx_num = num;
+
+	cb_ch = kzalloc(sizeof(int), GFP_KERNEL);
+	cb_ch = (void *)ch;
+
+	dma->desc_rx = desc;
+	desc->callback = i2s_dma_rx_complete;
+	desc->callback_param = cb_ch;
+	desc->tx_submit(desc);
+
+	tasklet_schedule(&dma->rx_tasklet);
+}
+
+static inline void ioh_i2s_interrupt_sub_rx(int ch)
+{
+	unsigned int status;
+	int offset = ch * 0x800;
+
+	status = ioread32(i2s_data->iobase + I2SISTRX_OFFSET + offset);
+	if (status & I2S_RX_FINT)
+		i2s_rx_full_ir(ch);
+	if (status & I2S_RX_AFINT)
+		i2s_rx_almost_full_ir(ch);
+
+	/*Clear the interrupt status */
+	iowrite32(status, i2s_data->iobase + I2SISTRX_OFFSET + offset);
+}
+
+void ioh_i2s_event(u32 idisp, int ch)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&i2s_data->tx_lock, flags);
+
+	if (idisp & BIT(ch + 16)) {
+		dev_dbg(i2s_data->dev, "Rx%d interrupt occures\n", ch);
+		ioh_i2s_interrupt_sub_rx(ch);
+	}
+
+	if (idisp & BIT(ch)) {
+		dev_dbg(i2s_data->dev, "Tx%d interrupt occures\n", ch);
+		ioh_i2s_interrupt_sub_tx(ch);
+	}
+
+	spin_unlock_irqrestore(&i2s_data->tx_lock, flags);
+	return;
+}
+
+static irqreturn_t ioh_i2s_irq(int irq, void *data)
+{
+	int i;
+	u32 idisp;
+
+	idisp = ioread32(i2s_data->iobase + I2SIDISP_OFFSET);
+	for (i = 0; i < MAX_I2S_CH; i++)
+		ioh_i2s_event(idisp, i);
+
+	return IRQ_HANDLED;
+}
+
+/*****************************************************************************
+ *	Sound Card
+ *****************************************************************************/
+static void i2s_read_period(struct snd_pcm_substream *substream)
+{
+	struct ml7213i2s_runtime_data *rtd;
+	int period;
+	void *read_ptr;
+	int read_size;
+
+	rtd = substream->runtime->private_data;
+	period = substream->runtime->period_size;
+
+	read_ptr = substream->runtime->dma_area
+			  +(snd_pcm_lib_period_bytes(substream) * rtd->irq_pos);
+	read_size = period * (substream->runtime->sample_bits / 8) *
+						(substream->runtime->channels);
+
+	ioh_i2s_read(substream, read_ptr, read_size);
+	rtd->irq_pos = (rtd->irq_pos + 1) % substream->runtime->periods;
+}
+
+static void read_done(void *callback_data, int status, int num, int avail)
+{
+	struct snd_pcm_substream *substream =
+				      (struct snd_pcm_substream *)callback_data;
+	struct ml7213i2s_runtime_data *rtd;
+	int ch = substream->number;
+	rtd = substream->runtime->private_data;
+
+	if (num < snd_card_ml7213i2s_capture[ch].period_bytes_max)
+		return;
+
+	switch (status) {
+	case IOH_EOK:
+		if (!rtd->stop) {
+			i2s_read_period(substream);
+			rtd->buf_pos = (rtd->buf_pos + 1) %
+				substream->runtime->periods;
+			snd_pcm_period_elapsed(substream);
+		}
+
+		rtd->cnt++;
+		break;
+	case IOH_EDONE:
+		pr_debug("Done stopping channel %d\n", rtd->stop);
+		rtd->stop = 2;
+		break;
+
+	case IOH_EOVERRUN:
+		if (ignore_overrun)
+			pr_debug("overrun ignore\n");
+		else {
+			pr_err("RX overrun\n");
+			rtd->stop = 2;
+		}
+		break;
+
+	case IOH_EFRAMESYNC:
+		pr_err("Frame sync error\n");
+		rtd->stop = 2;
+		break;
+	}
+	if (rtd->stop)
+		pr_debug("stopping... %d\n", rtd->stop);
+}
+
+static int setup_i2s_read(struct snd_pcm_substream *substream)
+{
+	struct ml7213i2s_runtime_data *rtd;
+	int ret = 0;
+	int ch = substream->number;
+
+	rtd = substream->runtime->private_data;
+
+	if (!ioh_i2s_open(ch, IOH_CAPTURE, "radio-i2s-in")) {
+		pr_err("%s: Cannot open the device\n", __func__);
+		return -1;
+	}
+
+	if (ignore_overrun)
+		ioh_i2s_ignore_rx_overrun();
+
+	ioh_i2s_configure_i2s_regs(ch, IOH_CAPTURE);
+	return ret;
+}
+
+static void i2s_write_period(struct snd_pcm_substream *substream)
+{
+	struct ml7213i2s_runtime_data *rtd;
+	int period;
+	void *write_ptr;
+	int write_size;
+
+	rtd = substream->runtime->private_data;
+	period = substream->runtime->period_size;
+	write_ptr = substream->runtime->dma_area
+			 + (snd_pcm_lib_period_bytes(substream) * rtd->irq_pos);
+	write_size = period * (substream->runtime->sample_bits / 8) *
+						(substream->runtime->channels);
+
+	ioh_i2s_write(substream, write_ptr, write_size);
+	rtd->irq_pos = (rtd->irq_pos + 1) % substream->runtime->periods;
+}
+
+static void write_done(void *callback_data, int status, int num, int avail)
+{
+	struct snd_pcm_substream *substream =
+				      (struct snd_pcm_substream *)callback_data;
+	struct ml7213i2s_runtime_data *rtd;
+	int ch = substream->number;
+
+	rtd = substream->runtime->private_data;
+
+	if (num < snd_card_ml7213i2s_playback[ch].period_bytes_max)
+		return;
+	if (avail >= snd_card_ml7213i2s_playback[ch].period_bytes_max * 2)
+		return;
+
+	if (!substream) {
+		pr_debug("%s:!substream NULL\n", __func__);
+		return;
+	}
+	if (!substream->runtime) {
+		pr_debug("%s:!substream->runtime NULL\n", __func__);
+		return;
+	}
+	if (!substream->runtime->private_data) {
+		pr_debug("%s:!substream->runtime->private_data NULL\n",
+			__func__);
+		return;
+	}
+	switch (status) {
+	case IOH_EOK:
+		if (!rtd->stop) {
+			i2s_write_period(substream);
+			rtd->buf_pos = (rtd->buf_pos + 1) %
+					substream->runtime->periods;
+			snd_pcm_period_elapsed(rtd->substream);
+		}
+		rtd->cnt++;
+		break;
+	case IOH_EDONE:
+		pr_debug("Done stopping channel %d\n", rtd->stop);
+		rtd->stop = 2;
+		break;
+	default:
+		pr_debug("%s:default(%d)\n", __func__, status);
+	break;
+	}
+}
+
+static int setup_i2s_write(struct snd_pcm_substream *substream)
+{
+	int ret = 0;
+	struct ml7213i2s_runtime_data *rtd;
+	int ch = substream->number;
+
+	rtd = substream->runtime->private_data;
+
+	if (!ioh_i2s_open(ch, IOH_PLAYBACK, "radio-i2s-out")) {
+		pr_err("%s: Cannot open the device\n", __func__);
+		return -1;
+	}
+
+	if (ignore_overrun)
+		ioh_i2s_ignore_rx_overrun();
+
+	ioh_i2s_configure_i2s_regs(ch, IOH_PLAYBACK);
+	return ret;
+}
+
+static void __snd_card_ml7213i2s_runtime_free(struct snd_pcm_runtime *runtime)
+{
+	struct ml7213i2s_runtime_data *rtd;
+	static int cnt;
+
+	rtd = (struct ml7213i2s_runtime_data *)runtime->private_data;
+	if (!rtd->stop)
+		rtd->stop = 1;
+	else {
+		while (rtd->stop != 2) {
+			if (cnt++ > 100) {
+				pr_debug("oops, failed to close ml7213i2s..\n");
+				pr_debug("it's ok if i2s isn't running\n");
+				break;
+			}
+			msleep(20);
+		}
+	}
+}
+
+static void snd_card_ml7213i2s_runtime_capture_free
+					(struct snd_pcm_runtime *runtime)
+{
+	__snd_card_ml7213i2s_runtime_free(runtime);
+	kfree(runtime->private_data);
+}
+
+static struct ml7213i2s_runtime_data *
+ml7213i2s_new_pcm_stream(struct snd_pcm_substream *substream)
+{
+	struct ml7213i2s_runtime_data *rtd;
+
+	rtd = kzalloc(sizeof(*rtd), GFP_KERNEL);
+	if (!rtd)
+		return NULL;
+	spin_lock_init(&rtd->lock);
+	rtd->substream = substream;
+	return rtd;
+}
+
+static int snd_card_ml7213i2s_open(struct snd_pcm_substream *substream)
+{
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	struct ml7213i2s_runtime_data *rtd;
+	int err;
+
+	rtd = ml7213i2s_new_pcm_stream(substream);
+	if (!rtd)
+		return -ENOMEM;
+
+	runtime->private_data = rtd;
+	/* makes the infrastructure responsible for freeing dma */
+	runtime->private_free = snd_card_ml7213i2s_runtime_capture_free;
+
+	if (substream->stream == SNDRV_PCM_STREAM_CAPTURE)
+		rtd->rw = SND_CAPTURE_SUBSTREAM;
+	else
+		rtd->rw = SND_PLAYBACK_SUBSTREAM;
+
+	snd_soc_set_runtime_hwparams(substream,
+				&snd_card_ml7213i2s_capture[substream->number]);
+
+	err = add_capture_constraints(runtime);
+	if (err < 0)
+		return err;
+
+	return 0;
+}
+
+static int snd_card_ml7213i2s_close(struct snd_pcm_substream *substream)
+{
+	if (substream->stream == SNDRV_PCM_STREAM_CAPTURE)
+		ioh_i2s_release(substream->number, IOH_CAPTURE);
+	else
+		ioh_i2s_release(substream->number, IOH_PLAYBACK);
+	return 0;
+}
+
+static int snd_card_ml7213i2s_hw_params(struct snd_pcm_substream *substream,
+				    struct snd_pcm_hw_params *hw_params)
+{
+	return snd_pcm_lib_malloc_pages(substream,
+					params_buffer_bytes(hw_params));
+}
+
+static int snd_card_ml7213i2s_hw_free(struct snd_pcm_substream *substream)
+{
+	return snd_pcm_lib_free_pages(substream);
+}
+
+void ioh_i2s_irq_stop(int ch, enum ioh_direction dir)
+{
+	struct ioh_i2s_dma *dma = &dmadata[ch];
+
+	if (dir) {
+		ioh_i2s_disable_interrupts(ch, IOH_CAPTURE);
+		ioh_i2s_disable_rx_full_ir(ch);
+		ioh_i2s_clear_rx_sts_ir(ch);
+		dma->rxexe_flag = 0;
+
+	} else {
+		ioh_i2s_disable_interrupts(ch, IOH_PLAYBACK);
+		ioh_i2s_disable_tx_empty_ir(ch);
+		ioh_i2s_clear_tx_sts_ir(ch);
+		dma->txexe_flag = 0;
+	}
+}
+
+void ioh_i2s_write_start(void *callback_data,
+			 void (*done) (void *callback_data, int status,
+				       int num, int avail))
+{
+	struct snd_pcm_substream *substream = callback_data;
+	int ch = substream->number;
+	struct ioh_i2s_dma *dma = &dmadata[ch];
+
+	dma->txexe_flag = 1;
+	dma->tx_data_head = dma->tx_head;
+	dma->tx_complete = dma->tx_head;
+	dma->tx_avail = 0;
+	dma->tx_callback_data = callback_data;
+	dma->tx_done = done;
+
+	ioh_i2s_clear_tx_sts_ir(ch);
+	ioh_i2s_tx_clear_dma_mask(ch);
+	ioh_i2s_enable_interrupts(ch, IOH_PLAYBACK);
+}
+
+void ioh_i2s_read_start(void *callback_data,
+			void (*done) (void *callback_data, int status,
+				      int num, int avail))
+{
+	struct snd_pcm_substream *substream = callback_data;
+	int ch = substream->number;
+	struct ioh_i2s_dma *dma = &dmadata[ch];
+
+	dma->rxexe_flag = 1;
+	dma->rx_data_head = dma->rx_head;
+	dma->rx_complete = dma->rx_head;
+	dma->rx_avail = 0;
+	dma->rx_callback_data = callback_data;
+	dma->rx_done = done;
+
+	ioh_i2s_clear_rx_sts_ir(ch);
+	ioh_i2s_rx_clear_dma_mask(ch);
+	ioh_i2s_enable_interrupts(ch, IOH_CAPTURE);
+}
+
+static inline void
+snd_card_ml7213i2s_pcm_i2s_start(struct snd_pcm_substream *substream)
+{
+	struct ml7213i2s_runtime_data *rtd;
+	rtd = substream->runtime->private_data;
+
+	if (substream->stream == SNDRV_PCM_STREAM_CAPTURE) {
+		ioh_i2s_read_start(substream, read_done);
+	} else {
+		ioh_i2s_write_start(substream, write_done);
+		i2s_write_period(substream);
+	}
+}
+
+static int snd_card_ml7213i2s_pcm_trigger
+				(struct snd_pcm_substream *substream, int cmd)
+{
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	struct ml7213i2s_runtime_data *rtd = runtime->private_data;
+	int err = 0;
+
+	spin_lock(&rtd->lock);
+
+	switch (cmd) {
+	case SNDRV_PCM_TRIGGER_START:
+	case SNDRV_PCM_TRIGGER_RESUME:
+		rtd->stop = 0;
+		snd_card_ml7213i2s_pcm_i2s_start(substream);
+		break;
+	case SNDRV_PCM_TRIGGER_STOP:
+	case SNDRV_PCM_TRIGGER_SUSPEND:
+		pr_debug("stop..\n");
+		if (!rtd->stop)
+			rtd->stop = 1;
+		else
+			pr_debug("already stopped %d\n", rtd->stop);
+		if (substream->stream == SNDRV_PCM_STREAM_CAPTURE)
+			ioh_i2s_irq_stop(substream->number, IOH_CAPTURE);
+		else
+			ioh_i2s_irq_stop(substream->number, IOH_PLAYBACK);
+		break;
+	default:
+		err = -EINVAL;
+		break;
+	}
+
+	spin_unlock(&rtd->lock);
+	return 0;
+}
+
+static int snd_card_ml7213i2s_pcm_prepare(struct snd_pcm_substream *substream)
+{
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	struct ml7213i2s_runtime_data *rtd = runtime->private_data;
+
+	rtd->irq_pos = 0;
+	rtd->buf_pos = 0;
+
+	snd_pcm_format_set_silence(runtime->format, runtime->dma_area,
+				bytes_to_samples(runtime, runtime->dma_bytes));
+
+	return 0;
+}
+
+static snd_pcm_uframes_t
+snd_card_ml7213i2s_pcm_pointer(struct snd_pcm_substream *substream)
+{
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	struct ml7213i2s_runtime_data *rtd = runtime->private_data;
+
+	return substream->runtime->period_size*rtd->buf_pos;
+}
+
+static struct snd_pcm_ops snd_card_ml7213i2s_capture_ops = {
+	.open =			snd_card_ml7213i2s_open,
+	.close =		snd_card_ml7213i2s_close,
+	.ioctl =		snd_pcm_lib_ioctl,
+	.hw_params =		snd_card_ml7213i2s_hw_params,
+	.hw_free =		snd_card_ml7213i2s_hw_free,
+	.prepare =		snd_card_ml7213i2s_pcm_prepare,
+	.trigger =		snd_card_ml7213i2s_pcm_trigger,
+	.pointer =		snd_card_ml7213i2s_pcm_pointer,
+};
+
+static int ml7213ioh_pcm_new(struct snd_soc_pcm_runtime *rtd)
+{
+	struct snd_pcm *pcm = rtd->pcm;
+
+	snd_pcm_lib_preallocate_pages_for_all(
+		pcm, SNDRV_DMA_TYPE_CONTINUOUS,
+		snd_dma_continuous_data(GFP_KERNEL),
+		0, 64 * 1024);
+
+	return 0;
+}
+
+static struct snd_soc_platform_driver ml7213ioh_soc_platform = {
+	.pcm_new	= ml7213ioh_pcm_new,
+	.ops		= &snd_card_ml7213i2s_capture_ops,
+};
+
+/*****************************************************************************
+ *	DAI functions
+ *****************************************************************************/
+static int ml7213i2s_dai_hw_params(struct snd_pcm_substream *substream,
+			    struct snd_pcm_hw_params *hw_params,
+			    struct snd_soc_dai *dai)
+{
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	struct ml7213i2s_runtime_data *rtd = runtime->private_data;
+	int ch = substream->number;
+	int byte;
+
+	switch (params_format(hw_params)) {
+	case SNDRV_PCM_FORMAT_U8:
+		byte = 8;
+	case SNDRV_PCM_FORMAT_S16_LE:
+		byte = 16;
+		break;
+	case SNDRV_PCM_FORMAT_S32_LE:
+		byte = 24;
+		break;
+	default:
+		pr_err("%s: Failed not support format\n", __func__);
+		return -1;
+		break;
+	}
+
+	switch (rtd->rw) {
+	case SND_CAPTURE_SUBSTREAM:
+		dmadata[ch].dma_rx_unit = byte;
+		if (setup_i2s_read(substream))
+			return -1;
+		break;
+	case SND_PLAYBACK_SUBSTREAM:
+		dmadata[ch].dma_rx_unit = byte;
+		if (setup_i2s_write(substream))
+			return -1;
+		break;
+	default:
+		return -1;
+	}
+
+	return 0;
+}
+
+static int ml7213i2s_dai_hw_free(struct snd_pcm_substream *substream,
+				 struct snd_soc_dai *dai)
+{
+	struct ml7213i2s_runtime_data *rtd = substream->runtime->private_data;
+	unsigned int ch = substream->number;
+
+	switch (rtd->rw) {
+	case SND_CAPTURE_SUBSTREAM:
+		ioh_i2s_stop_i2s_regs(ch, IOH_CAPTURE);
+		break;
+
+	case SND_PLAYBACK_SUBSTREAM:
+		ioh_i2s_stop_i2s_regs(ch, IOH_PLAYBACK);
+		break;
+
+	default:
+		return -1;
+	}
+
+	return 0;
+}
+
+static int ml7213i2s_dai_set_dai_fmt(struct snd_soc_dai *dai,
+				     unsigned int fmt)
+{
+	struct ml7213i2s_dai *i2s = snd_soc_dai_get_drvdata(dai);
+	u32 cmn_reg[MAX_I2S_CH];
+	u32 tx_reg[MAX_I2S_CH];
+	u32 rx_reg[MAX_I2S_CH];
+	int i;
+	int offset = 0;
+	void *iobase = i2s->iobase;
+
+	/* set master/slave audio interface */
+	for (i = 0; i < MAX_I2S_CH; i++, offset = i * 0x800) {
+		cmn_reg[i] = ioread32(iobase + I2SCLKCNT0_OFFSET + 0x10 * i);
+		tx_reg[i] = ioread32(iobase + offset + I2SCNTTX_OFFSET);
+		rx_reg[i] = ioread32(iobase + offset + I2SCNTRX_OFFSET);
+
+		switch (fmt & SND_SOC_DAIFMT_MASTER_MASK) {
+		case SND_SOC_DAIFMT_CBM_CFM:
+			cmn_reg[i] |= I2SCLKCNT_MSSEL;
+			break;
+		case SND_SOC_DAIFMT_CBS_CFS:
+			cmn_reg[i] &= ~I2SCLKCNT_MSSEL;
+			break;
+		default:
+			return -EINVAL;
+		}
+
+		/* interface format */
+		switch (fmt & SND_SOC_DAIFMT_FORMAT_MASK) {
+		case SND_SOC_DAIFMT_I2S:
+			cmn_reg[i] &= ~ML7213I2S_LRCLK_FMT;
+			tx_reg[i] &= ~ML7213I2S_TX_I2S | ~ML7213I2S_TX_DLY |\
+				  ~ML7213I2S_TX_MSB_LSB |\
+				  ~ML7213I2S_TX_LR_POL | ~ML7213I2S_TX_AFT;
+			rx_reg[i] &= ~ML7213I2S_RX_I2S | ~ML7213I2S_RX_DLY |\
+				  ~ML7213I2S_RX_MSB_LSB |\
+				  ~ML7213I2S_RX_LR_POL | ~ML7213I2S_RX_AFT;
+			break;
+		default:
+			return -EINVAL;
+		}
+
+		/* clock inversion */
+		switch (fmt & SND_SOC_DAIFMT_INV_MASK) {
+		case SND_SOC_DAIFMT_NB_NF:
+			cmn_reg[i] &= ~ML7213I2S_BCLKPOL;
+			break;
+		default:
+			return -EINVAL;
+		}
+
+		iowrite32(cmn_reg[i], iobase + I2SCLKCNT0_OFFSET + 0x10 * i);
+		iowrite32(tx_reg[i], iobase + offset + I2SCNTTX_OFFSET);
+		iowrite32(rx_reg[i], iobase + offset + I2SCNTRX_OFFSET);
+	}
+
+	return 0;
+}
+
+static int ml7213i2s_dai_set_dai_sysclk(struct snd_soc_dai *dai,
+					int clk_id, unsigned int freq, int dir)
+{
+	u32 reg[MAX_I2S_CH];
+	struct ml7213i2s_dai *i2s = snd_soc_dai_get_drvdata(dai);
+	void *iobase = i2s->iobase;
+	int i;
+
+	if (i2s->freq != freq)
+		i2s->freq = freq;
+
+	for (i = 0; i < MAX_I2S_CH; i++) {
+		reg[i] = ioread32(iobase + I2SCLKCNT0_OFFSET + 0x10 * i);
+		if (clk_id == IOH_MASTERCLKSEL_MCLK)
+			reg[i] &= ~ML7213I2S_MASTER_CLK_SEL;
+		else if (clk_id == IOH_MASTERCLKSEL_MLBCLK)
+			reg[i] |= ML7213I2S_MASTER_CLK_SEL;
+		iowrite32(reg[i], iobase + I2SCLKCNT0_OFFSET + 0x10 * i);
+	}
+
+	return 0;
+}
+
+static int ml7213i2s_dai_set_clkdiv(struct snd_soc_dai *dai,
+				  int div_id, int div)
+{
+	struct ml7213i2s_dai *i2s = snd_soc_dai_get_drvdata(dai);
+	u32 bclkfs = 0;
+	u32 mclkfs = 0;
+	int ch;
+	void *iobase = i2s->iobase;
+	u32 i2sclkcnt;
+
+	switch (div_id) {
+	case ML7213IOH_BCLKFS0:
+	case ML7213IOH_MCLKFS0:
+		ch = 0;
+		break;
+	case ML7213IOH_BCLKFS1:
+	case ML7213IOH_MCLKFS1:
+		ch = 1;
+		break;
+	case ML7213IOH_BCLKFS2:
+	case ML7213IOH_MCLKFS2:
+		ch = 2;
+		break;
+	case ML7213IOH_BCLKFS3:
+	case ML7213IOH_MCLKFS3:
+		ch = 3;
+		break;
+	case ML7213IOH_BCLKFS4:
+	case ML7213IOH_MCLKFS4:
+		ch = 4;
+		break;
+	case ML7213IOH_BCLKFS5:
+	case ML7213IOH_MCLKFS5:
+		ch = 5;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	switch (div_id) {
+	case ML7213IOH_BCLKFS0:
+	case ML7213IOH_BCLKFS1:
+	case ML7213IOH_BCLKFS2:
+	case ML7213IOH_BCLKFS3:
+	case ML7213IOH_BCLKFS4:
+	case ML7213IOH_BCLKFS5:
+		if (div == 8)
+			bclkfs = IOH_BCLKFS_8FS;
+		else if (div == 16)
+			bclkfs = IOH_BCLKFS_16FS;
+		else if (div == 32)
+			bclkfs = IOH_BCLKFS_32FS;
+		else if (div == 64)
+			bclkfs = IOH_BCLKFS_64FS;
+		break;
+	case ML7213IOH_MCLKFS0:
+	case ML7213IOH_MCLKFS1:
+	case ML7213IOH_MCLKFS2:
+	case ML7213IOH_MCLKFS3:
+	case ML7213IOH_MCLKFS4:
+	case ML7213IOH_MCLKFS5:
+		if (div == 64)
+			mclkfs = IOH_MCLKFS_64FS;
+		else if (div == 128)
+			mclkfs = IOH_MCLKFS_128FS;
+		else if (div == 192)
+			mclkfs = IOH_MCLKFS_192FS;
+		else if (div == 256)
+			mclkfs = IOH_MCLKFS_256FS;
+		else if (div == 384)
+			mclkfs = IOH_MCLKFS_384FS;
+		else if (div == 512)
+			mclkfs = IOH_MCLKFS_512FS;
+		else if (div == 768)
+			mclkfs = IOH_MCLKFS_768FS;
+		else if (div == 1024)
+			mclkfs = IOH_MCLKFS_1024FS;
+		break;
+	default:
+		return -EINVAL;
+	}
+	i2sclkcnt = ioread32(i2s_data->iobase + I2SCLKCNT0_OFFSET + 0x10 * ch);
+	i2sclkcnt |= bclkfs << I2SCLKCNT_BCLKFS_OFFSET;
+	i2sclkcnt |= mclkfs << I2SCLKCNT_MCLKFS_OFFSET;
+	iowrite32(i2sclkcnt, iobase + I2SCLKCNT0_OFFSET + 0x10 * ch);
+
+	return 0;
+}
+
+static const struct snd_soc_dai_ops ml7213i2s_dai_ops = {
+	.hw_params	= ml7213i2s_dai_hw_params,
+	.hw_free	= ml7213i2s_dai_hw_free,
+	.set_fmt	= ml7213i2s_dai_set_dai_fmt,
+	.set_sysclk	= ml7213i2s_dai_set_dai_sysclk,
+	.set_clkdiv	= ml7213i2s_dai_set_clkdiv,
+};
+
+static struct snd_soc_dai_driver ml7213i2s_dai_data = {
+	.playback = {
+		.channels_min = USE_CHANNELS_MIN,
+		.channels_max = USE_CHANNELS_MAX,
+		.rates = ML7213_I2S_RATES,
+		.formats = SNDRV_PCM_FMTBIT_U8 | SNDRV_PCM_FMTBIT_S16_LE |\
+			   SNDRV_PCM_FMTBIT_S32_LE,
+	},
+	.capture = {
+		.channels_min = USE_CHANNELS_MIN,
+		.channels_max = USE_CHANNELS_MAX,
+		.rates = ML7213_I2S_RATES,
+		.formats = SNDRV_PCM_FMTBIT_U8 | SNDRV_PCM_FMTBIT_S16_LE |\
+			   SNDRV_PCM_FMTBIT_S32_LE,
+	},
+	.ops = &ml7213i2s_dai_ops,
+};
+
+/*****************************************************************************
+ *	PCI functions
+ *****************************************************************************/
+DEFINE_PCI_DEVICE_TABLE(ioh_pci_tbl) = {
+	{
+		.vendor = PCI_VENDOR_ID_ROHM,
+		.device = PCI_DEVICE_ID_ML7213_I2S,
+		.subvendor = PCI_ANY_ID,
+		.subdevice = PCI_ANY_ID,
+	},
+	{0,}
+};
+
+static int ioh_i2s_pci_probe(struct pci_dev *pdev,
+			     const struct pci_device_id *id)
+{
+	int rv = 0;
+	void __iomem *tbl;
+	unsigned int mapbase;
+	struct ml7213i2s_dai *i2s_dai;
+
+	rv = pci_enable_device(pdev);
+	if (rv)
+		goto enable_device;
+
+	tbl = pci_iomap(pdev, 1, 0);
+	if (!tbl) {
+		rv = -ENOMEM;
+		printk(KERN_ERR "pci_iomap failed\n");
+		goto out_ipmap;
+	}
+
+	mapbase = pci_resource_start(pdev, 1);
+	if (!mapbase) {
+		rv = -ENOMEM;
+		printk(KERN_ERR "pci_resource_start failed\n");
+		goto out_pci_resource;
+	}
+
+	i2s_data = devm_kzalloc(&pdev->dev, sizeof(*i2s_data), GFP_KERNEL);
+	if (!i2s_data) {
+		dev_err(&pdev->dev, "Can't allocate i2s_data\n");
+		rv = -ENOMEM;
+		goto out_kzalloc_data;
+	}
+
+	i2s_data->dev = &pdev->dev;
+	i2s_data->iobase = tbl;
+	i2s_data->mapbase = mapbase;
+	spin_lock_init(&i2s_data->tx_lock);
+
+	rv = request_irq(pdev->irq, ioh_i2s_irq, IRQF_SHARED, "ml7213_ioh",
+			 pdev);
+	if (rv != 0) {
+		printk(KERN_ERR "Failed to allocate irq\n");
+		goto out_irq;
+	}
+
+	i2s_dai = devm_kzalloc(&pdev->dev, sizeof(*i2s_dai), GFP_KERNEL);
+	if (!i2s_dai) {
+		dev_err(&pdev->dev, "Can't allocate i2s_dai\n");
+		rv = -ENOMEM;
+		goto out_kzalloc_i2s_dai;
+	}
+	dev_set_drvdata(&pdev->dev, i2s_dai);
+
+	rv = snd_soc_register_platform(&pdev->dev, &ml7213ioh_soc_platform);
+	if (rv < 0) {
+		printk(KERN_ERR "Failed to snd_soc_register_platform\n");
+		goto out_register_plat;
+	}
+
+	i2s_dai->iobase = tbl;
+	i2s_dai->dev = &pdev->dev;
+	rv = snd_soc_register_dai(&pdev->dev, &ml7213i2s_dai_data);
+	if (rv < 0) {
+		printk(KERN_ERR "Failed to snd_soc_register_dai\n");
+		goto out_register_dai;
+	}
+
+	return 0;
+
+out_register_dai:
+	snd_soc_unregister_platform(&pdev->dev);
+out_register_plat:
+out_kzalloc_i2s_dai:
+	free_irq(pdev->irq, pdev);
+out_irq:
+out_kzalloc_data:
+out_pci_resource:
+	pci_iounmap(pdev, i2s_data->iobase);
+out_ipmap:
+	pci_disable_device(pdev);
+enable_device:
+
+	return rv;
+}
+
+static void ioh_i2s_pci_remove(struct pci_dev *pdev)
+{
+	int i;
+
+	for (i = 0; i < MAX_I2S_CH; i++)
+		ioh_i2s_reset(i);
+
+	snd_soc_unregister_platform(&pdev->dev);
+	free_irq(pdev->irq, pdev);
+	pci_iounmap(pdev, i2s_data->iobase);
+	pci_disable_device(pdev);
+}
+
+static void ioh_i2s_save_reg_conf(struct pci_dev *pdev)
+{
+	int i;
+	void *iobase;
+	struct ioh_i2s_pm_ch_reg *save;
+	struct ioh_i2s_pm_ch_reg_cmn *save_cmn;
+	int offset;
+
+	iobase = i2s_data->iobase;
+	for (i = 0, offset = 0; i < MAX_I2S_CH; i++, offset = i * 0x800) {
+		save = &i2s_data->ch_reg_save[i];
+
+		save->i2sdrtx = ioread32(iobase + offset + I2SDRTX_OFFSET);
+		save->i2scnttx = ioread32(iobase + offset + I2SCNTTX_OFFSET);
+		save->i2sfifoctx =
+				ioread32(iobase + offset + I2SFIFOCTX_OFFSET);
+		save->i2saftx = ioread32(iobase + offset + I2SAFTX_OFFSET);
+		save->i2saetx = ioread32(iobase + offset + I2SAETX_OFFSET);
+		save->i2smsktx = ioread32(iobase + offset + I2SMSKTX_OFFSET);
+		save->i2sisttx = ioread32(iobase + offset + I2SISTTX_OFFSET);
+
+		save->i2scntrx = ioread32(iobase + offset + I2SCNTRX_OFFSET);
+		save->i2sfifocrx =
+				ioread32(iobase + offset + I2SFIFOCRX_OFFSET);
+		save->i2safrx = ioread32(iobase + offset + I2SAFRX_OFFSET);
+		save->i2saerx = ioread32(iobase + offset + I2SAERX_OFFSET);
+		save->i2smskrx = ioread32(iobase + offset + I2SMSKRX_OFFSET);
+		save->i2sistrx = ioread32(iobase + offset + I2SISTRX_OFFSET);
+	}
+
+	save_cmn = &i2s_data->cmn_reg_save;
+	for (i = 0; i < MAX_I2S_CH; i++) {
+		save_cmn->i2sclkcnt[i] =
+		ioread32(i2s_data->iobase + I2SCLKCNT0_OFFSET + 0x10 * i);
+	}
+	save_cmn->i2simask = ioread32(i2s_data->iobase + I2SIMASK_OFFSET);
+}
+
+static int ioh_i2s_pci_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	int ret;
+
+	ioh_i2s_save_reg_conf(pdev);
+	ret = pci_save_state(pdev);
+	if (ret) {
+		dev_err(&pdev->dev,
+			" %s -pci_save_state returns %d\n", __func__, ret);
+		return ret;
+	}
+	pci_enable_wake(pdev, PCI_D3hot, 0);
+	pci_disable_device(pdev);
+	pci_set_power_state(pdev, pci_choose_state(pdev, state));
+
+	return 0;
+}
+
+static void ioh_i2s_restore_reg_conf(struct pci_dev *pdev)
+{
+	int i;
+	void *iobase;
+	struct ioh_i2s_pm_ch_reg *save;
+	int offset;
+
+	iobase = i2s_data->iobase;
+	save = &i2s_data->ch_reg_save[0];
+	for (i = 0, offset = 0; i < MAX_I2S_CH; i++, offset = i * 0x800) {
+		iowrite32(save->i2sdrtx, iobase + offset + I2SDRTX_OFFSET);
+		iowrite32(save->i2scnttx, iobase + offset + I2SCNTTX_OFFSET);
+		iowrite32(save->i2sfifoctx,
+			  iobase + offset + I2SFIFOCTX_OFFSET);
+		iowrite32(save->i2saftx, iobase + offset + I2SAFTX_OFFSET);
+		iowrite32(save->i2saetx, iobase + offset + I2SAETX_OFFSET);
+		iowrite32(save->i2smsktx, iobase + offset + I2SMSKTX_OFFSET);
+		iowrite32(save->i2sisttx, iobase + offset + I2SISTTX_OFFSET);
+
+		iowrite32(save->i2scntrx, iobase + offset + I2SCNTRX_OFFSET);
+		iowrite32(save->i2sfifocrx,
+			  iobase + offset + I2SFIFOCRX_OFFSET);
+		iowrite32(save->i2safrx, iobase + offset + I2SAFRX_OFFSET);
+		iowrite32(save->i2saerx, iobase + offset + I2SAERX_OFFSET);
+		iowrite32(save->i2smskrx, iobase + offset + I2SMSKRX_OFFSET);
+		iowrite32(save->i2sistrx, iobase + offset + I2SISTRX_OFFSET);
+	}
+
+	for (i = 0; i < MAX_I2S_CH; i++) {
+		iowrite32(i2s_data->cmn_reg_save.i2sclkcnt[i],
+			 i2s_data->iobase + I2SCLKCNT0_OFFSET + 0x10 * i);
+	}
+
+	iowrite32(i2s_data->cmn_reg_save.i2simask,
+		  i2s_data->iobase + I2SIMASK_OFFSET);
+}
+
+static int ioh_i2s_pci_resume(struct pci_dev *pdev)
+{
+	int ret;
+
+	pci_set_power_state(pdev, PCI_D0);
+	pci_restore_state(pdev);
+	ret = pci_enable_device(pdev);
+	if (ret) {
+		dev_err(&pdev->dev,
+		"%s-pci_enable_device failed(ret=%d) ", __func__, ret);
+		return ret;
+	}
+
+	pci_enable_wake(pdev, PCI_D3hot, 0);
+	ioh_i2s_restore_reg_conf(pdev);
+
+	return 0;
+}
+
+static struct pci_driver ioh_i2s_driver = {
+	.name = DRV_NAME,
+	.probe = ioh_i2s_pci_probe,
+	.remove = __devexit_p(ioh_i2s_pci_remove),
+	.id_table = ioh_pci_tbl,
+#ifdef CONFIG_PM
+	.suspend = ioh_i2s_pci_suspend,
+	.resume = ioh_i2s_pci_resume,
+#endif
+};
+
+static int __init ioh_i2s_init(void)
+{
+	return pci_register_driver(&ioh_i2s_driver);
+}
+
+static void __exit ioh_i2s_cleanup(void)
+{
+	pci_unregister_driver(&ioh_i2s_driver);
+}
+
+module_init(ioh_i2s_init);
+module_exit(ioh_i2s_cleanup);
+
+MODULE_AUTHOR("Tomoya MORINAGA <tomoya.rohm@gmail.com>");
+MODULE_DESCRIPTION("LAPIS Semiconductor ML7213 IOH ALSA SoC platform driver");
+MODULE_LICENSE("GPL");
diff --git a/sound/soc/lapis/ml7213ioh-plat.h b/sound/soc/lapis/ml7213ioh-plat.h
new file mode 100644
index 0000000..614f762
--- /dev/null
+++ b/sound/soc/lapis/ml7213ioh-plat.h
@@ -0,0 +1,583 @@
+/*
+ * Copyright (C) 2011 LAPIS Semiconductor Co., Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307, USA.
+ */
+
+#ifndef ML7213IOH_PLAT_H
+#define ML7213IOH_PLAT_H
+
+#include <linux/interrupt.h>
+#include <linux/pch_dma.h>
+
+#ifndef add_capture_constraints
+#define add_capture_constraints(x) 0
+#endif
+
+#define	SND_CAPTURE_SUBSTREAM	0
+#define	SND_PLAYBACK_SUBSTREAM	1
+
+#define I2SCLKCNT_MSSEL		BIT(0)
+#define I2SCLKCNT_BCLKPOL	BIT(1)
+
+#define DRV_NAME "ml7213_ioh_i2s"
+#define PCI_VENDOR_ID_ROHM	0X10DB
+#define PCI_DEVICE_ID_ML7213_I2S	0X8033
+
+#define ML7213I2S_BCLKPOL	BIT(1)
+#define ML7213I2S_LRCLK_FMT	(BIT(4) | BIT(5))
+#define ML7213I2S_TX_I2S	BIT(0)
+#define ML7213I2S_TX_DLY	BIT(12)
+#define ML7213I2S_TX_MSB_LSB	BIT(13)
+#define ML7213I2S_TX_LR_POL	BIT(14)
+#define ML7213I2S_TX_AFT	BIT(15)
+#define ML7213I2S_RX_I2S	BIT(0)
+#define ML7213I2S_RX_DLY	BIT(12)
+#define ML7213I2S_RX_MSB_LSB	BIT(13)
+#define ML7213I2S_RX_LR_POL	BIT(14)
+#define ML7213I2S_RX_AFT	BIT(15)
+#define ML7213I2S_MASTER_CLK_SEL	BIT(2)
+
+#define ML7213_I2S_RATES \
+	(SNDRV_PCM_RATE_16000 | SNDRV_PCM_RATE_32000 | SNDRV_PCM_RATE_48000)
+
+/* ioh_bclkfs_t */
+#define	IOH_BCLKFS_8FS		0
+#define	IOH_BCLKFS_16FS		1
+#define	IOH_BCLKFS_32FS		2
+#define	IOH_BCLKFS_64FS		3
+
+#define	I2SCLKCNT_MCLKFS_OFFSET		(8)
+#define	I2SCLKCNT_BCLKFS_OFFSET		(12)
+
+#define I2SCLKCNT0_OFFSET	0x3000
+#define I2SCLKCNT1_OFFSET	0x3010
+#define I2SCLKCNT2_OFFSET	0x3020
+#define I2SCLKCNT3_OFFSET	0x3030
+#define I2SCLKCNT4_OFFSET	0x3040
+#define I2SCLKCNT5_OFFSET	0x3050
+#define I2SISTATUS_OFFSET	0x3080
+#define I2SIDISP_OFFSET		0x3084
+#define I2SIMASK_OFFSET		0x3088
+#define I2SIMASKCLR_OFFSET	0x308C
+#define I2SSRST_OFFSET		0x3FFC
+#define I2SDRTX_OFFSET		0x0
+#define I2SCNTTX_OFFSET		0x4
+#define I2SFIFOCTX_OFFSET	0x8
+#define I2SAFTX_OFFSET		0xC
+#define I2SAETX_OFFSET		0x10
+#define I2SMSKTX_OFFSET		0x14
+#define I2SISTTX_OFFSET		0x18
+#define I2SMONTX_OFFSET		0x1C
+#define I2SDRRX_OFFSET		0x20
+#define I2SCNTRX_OFFSET		0x24
+#define I2SFIFOCRX_OFFSET	0x28
+#define I2SAFRX_OFFSET		0x2C
+#define I2SAERX_OFFSET		0x30
+#define I2SMSKRX_OFFSET		0x34
+#define I2SISTRX_OFFSET		0x38
+#define I2SMONRX_OFFSET		0x3C
+#define FIRST_TX_OFFSET		0x0
+#define FIRST_RX_OFFSET		0x0
+
+#define I2SDRTXMIRROR_OFFSET	0x100
+#define I2SDRRXMIRROR_OFFSET	0x400
+
+#define I2S_ALL_INTERRUPT_BITS	0x3F003F
+#define I2S_IDISP_BITS		0x3F003F
+#define I2S_IDISP_TX_BITS	0x00003F
+#define I2S_IDISP_RX_BITS	0x3F0000
+#define TX_BIT_FIMSK	0x1	/*Fifo full interrupt mask bit*/
+#define TX_BIT_AFIMSK	0x2	/*Fifo Almost full interrupt mask bit*/
+#define TX_BIT_EIMSK	0x4	/*Fifo empty interrupt mask bit*/
+#define TX_BIT_AEIMSK	0x8	/*Fifo Almost empty interrupt mask bit*/
+#define TX_BIT_DMAMSK	0x10	/*Masks DMA*/
+#define TX_BIT_DMATC	0x100
+#define I2S_TX_ALL_INTR_MASK_BITS (TX_BIT_FIMSK | TX_BIT_AFIMSK | TX_BIT_EIMSK \
+							| TX_BIT_AEIMSK)
+#define I2S_TX_NORMAL_INTR_MASK_BITS (TX_BIT_FIMSK | TX_BIT_AFIMSK)
+#define RX_BIT_FIMSK	0x1	/*Fifo full interrupt mask bit*/
+#define RX_BIT_AFIMSK	0x2	/*Fifo Almost full interrupt mask bit*/
+#define RX_BIT_EIMSK	0x4	/*Fifo empty interrupt mask bit*/
+#define RX_BIT_AEIMSK	0x8	/*Fifo Almost empty interrupt mask bit*/
+#define RX_BIT_DMAMSK	0x10	/*Masks DMA*/
+#define RX_BIT_DMATC	0x100
+#define I2S_RX_ALL_INTR_MASK_BITS (RX_BIT_FIMSK | RX_BIT_AFIMSK | RX_BIT_EIMSK \
+							| RX_BIT_AEIMSK)
+#define I2S_RX_NORMAL_INTR_MASK_BITS (RX_BIT_EIMSK | RX_BIT_AEIMSK)
+#define I2S_TX_FINT	0x1	/*Full Interrupt*/
+#define I2S_TX_AFINT	0x2	/*Almost full interrupt*/
+#define I2S_TX_EINT	0x4	/*Empty interrupt*/
+#define I2S_TX_AEINT	0x8	/*Almost empty interrupt*/
+#define I2S_RX_FINT	0x1	/*Full Interrupt*/
+#define I2S_RX_AFINT	0x2	/*Almost full interrupt*/
+#define I2S_RX_EINT	0x4	/*Empty interrupt*/
+#define I2S_RX_AEINT	0x8	/*Almost empty interrupt*/
+
+#define I2S_FIFO_TX_FCLR	BIT(0)
+#define I2S_FIFO_TX_RUN		BIT(4)
+#define I2S_FIFO_RX_FCLR	BIT(0)
+#define I2S_FIFO_RX_RUN		BIT(4)
+
+#define FIFO_CTRL_BIT_TX_RUN	0x10
+#define FIFO_CTRL_BIT_RX_RUN	0x10
+#define I2S_CNT_BIT_TEL		0x1
+#define I2S_IMASK_TX_BIT_START	0
+#define I2S_IMASK_RX_BIT_START	16
+
+
+/* DMA processing */
+#define	PERIOD_POS_MAX		I2S_DMA_SG_NUM
+#define	PERIOD_LEN_TX		(I2S_AEMPTY_THRESH * PERIOD_POS_MAX)
+#define	PERIOD_LEN_RX		(I2S_AFULL_THRESH * PERIOD_POS_MAX)
+
+#define	SUPPORT_FORMAT		(SNDRV_PCM_FMTBIT_U8 | \
+				 SNDRV_PCM_FMTBIT_S16_LE | \
+				 SNDRV_PCM_FMTBIT_S32_LE)
+#define	MAX_PERIOD_SIZE_TX	(PERIOD_LEN_TX * 4)
+#define	MAX_PERIOD_SIZE_RX	(PERIOD_LEN_RX * 4)
+
+#define USE_CHANNELS_MIN	1
+#define USE_CHANNELS_MAX	2
+#define	MAX_I2S_CH		6		/*I2S0 ~ I2S5*/
+#define USE_PERIODS_MIN		(I2S_DMA_SG_MAX)
+#define USE_PERIODS_MAX		(I2S_DMA_SG_MAX)
+
+#define I2S_AEMPTY_THRESH	64	/* Almost  Empty Threshold */
+#define I2S_AFULL_THRESH	64	/* Almost  Full Threshold */
+
+#define	INTER_BUFF_SIZE		(I2S_AEMPTY_THRESH * 4 \
+				 * I2S_DMA_SG_NUM \
+				 * I2S_DMA_SG_MAX)
+#define	I2S_DMA_SG_NUM		(128)
+#define	I2S_DMA_SG_MAX		(64)
+
+#define	IOH_MSSEL_MASTER	1
+
+enum ioh_direction {
+	IOH_PLAYBACK = 0,
+	IOH_CAPTURE,
+};
+
+enum ioh_i2s_fifo_type {
+	IOH_FIFO_32 = 4,
+	IOH_FIFO_16 = 2,
+	IOH_FIFO_8 = 1,
+};
+
+enum ioh_i2s_status {
+	IOH_EOK = 0,
+	IOH_EDONE = 1,
+	IOH_EUNDERRUN = 2,
+	IOH_EOVERRUN = 3,
+	IOH_EFRAMESYNC = 4,
+};
+
+struct ml7213i2s_runtime_data {
+	spinlock_t lock;
+	unsigned int irq_pos;
+	unsigned int buf_pos;
+	struct snd_pcm_substream *substream;
+	int stop;
+	int cnt;
+	unsigned int rw;
+};
+
+enum ioh_bclkpol_t {
+	ioh_BCLKPOL_FALLING = 0,
+	ioh_BCLKPOL_RISING,
+};
+
+enum ioh_masterclksel_t {
+	IOH_MASTERCLKSEL_MCLK = 0,
+	IOH_MASTERCLKSEL_MLBCLK,
+};
+
+enum ioh_lrckfmt_t {
+	IOH_LRCLKFMT_I2S = 1,
+	IOH_LRCLKFMT_LONGFRAME,
+	IOH_LRCLKFMT_SHORTFRAME,
+};
+
+enum ioh_mclkfs_t {
+	IOH_MCLKFS_64FS = 0,
+	IOH_MCLKFS_128FS,
+	IOH_MCLKFS_192FS,
+	IOH_MCLKFS_256FS,
+	IOH_MCLKFS_384FS,
+	IOH_MCLKFS_512FS,
+	IOH_MCLKFS_768FS,
+	IOH_MCLKFS_1024FS,
+};
+
+enum ioh_dlyoff_t {
+	IOH_DLYOFF_DLY_ON = 0,		/* date delat on */
+	IOH_DLYOFF_DLY_OFF,		/* date delat off */
+};
+
+
+
+enum ioh_lrpol_t {
+	IOH_LRPOL_NO_INVERT = 0,	/* Low of LRCLK is L data.
+					   High of LRCLK is R data. */
+	IOH_LRPOL_INVERT,		/* Low of LRCLK is R data.
+					   High of LRCLK is L data. */
+};
+
+enum ioh_aft_t {
+	IOH_AFR_FRONT = 0,
+	IOH_AFR_BACK,
+};
+
+struct ioh_i2s_pm_ch_reg {
+	u32 i2sdrtx;	/* Tx: data register */
+	u32 i2scnttx; /* Tx: control register */
+	u32 i2sfifoctx;	/* Tx: FIFO control register */
+	u32 i2saftx;	/* Tx: almost full threshold setting */
+	u32 i2saetx;	/* Tx: almost empty threshold setting */
+	u32 i2smsktx;	/* Tx: interrupt mask settings */
+	u32 i2sisttx;	/* Tx: for acknowledging interrupts */
+	u32 i2scntrx;	/* Rx: control register */
+	u32 i2sfifocrx; /* Rx: FIFO control register */
+	u32 i2safrx;	/* Rx: almost full threshold setting */
+	u32 i2saerx;	/* Rx: almost empty threshold setting */
+	u32 i2smskrx;	/* Rx: interrupt mask settings */
+	u32 i2sistrx;	/* Rx: for acknowledging interrupts */
+};
+
+struct ioh_i2s_pm_ch_reg_cmn {
+	u32 i2sclkcnt[MAX_I2S_CH];	/*clock control register(ch0~5) */
+	u32 i2simask;		/*interrupt mask */
+};
+
+struct ioh_i2s_data {
+	struct device *dev;
+	void *iobase;
+	unsigned int mapbase;
+	int ch;
+	int ignore_rx_overrun;
+	spinlock_t tx_lock;
+	struct ioh_i2s_pm_ch_reg_cmn cmn_reg_save;
+	struct ioh_i2s_pm_ch_reg ch_reg_save[MAX_I2S_CH];
+};
+
+struct ioh_i2s_dma {
+	atomic_t rx_busy;
+	atomic_t tx_busy;
+
+	/* Transmit side DMA */
+	atomic_t pending_tx;
+
+	struct ioh_dma_config *dma_config;
+
+	struct scatterlist	*sg_tx_p;
+	struct scatterlist	*sg_rx_p;
+
+	struct scatterlist	*sg_tx_cur; /* current head of tx sg */
+	struct scatterlist	*sg_rx_cur; /* current head of tx sg */
+
+	int tx_num;	/* The number of sent sg */
+	int rx_num;	/* The number of sent sg */
+
+	void *rxbuf_virt;
+	void *txbuf_virt;
+	unsigned char *tx_tail;
+	unsigned char *tx_head;
+	unsigned char *tx_data_head;
+	unsigned char *tx_complete;
+	unsigned int  tx_avail;
+	unsigned char *rx_tail;
+	unsigned char *rx_head;
+	unsigned char *rx_data_head;
+	unsigned char *rx_complete;
+	unsigned int rx_avail;
+
+	struct dma_chan			*chan_tx;
+	struct dma_chan			*chan_rx;
+
+	int rx_nent;	/* The number of rx scatter list */
+	int tx_nent;	/* The number of tx scatter list */
+
+	struct dma_async_tx_descriptor	*desc_tx;
+	struct dma_async_tx_descriptor	*desc_rx;
+
+	dma_addr_t			tx_buf_dma;
+	dma_addr_t			rx_buf_dma;
+
+	struct pch_dma_slave		param_tx;
+	struct pch_dma_slave		param_rx;
+
+	void *rx_callback_data;
+	void (*rx_done) (void *callback_data, int status, int num, int avail);
+	void *tx_callback_data;
+	void (*tx_done) (void *callback_data, int status, int num, int avail);
+
+	int dma_tx_unit; /* 1Byte of 2Byte or 4Byte */
+	int dma_rx_unit; /* 1Byte of 2Byte or 4Byte */
+	int dma_tx_width;
+	int dma_rx_width;
+
+	int txexe_flag;
+	int rxexe_flag;
+
+	struct tasklet_struct	tx_tasklet;
+	struct tasklet_struct	rx_tasklet;
+};
+
+struct ml7213i2s_dai {
+	struct snd_soc_dai_driver dai;
+	struct device	*dev;
+	void *iobase;
+	u32 freq;
+};
+
+struct ioh_i2s_config_common_reg {
+	u32 i2sclkcnt;	/*clock control register(ch0~5) */
+	u32 i2sistatus;	/*interrupt status */
+	u32 i2sidisp;		/*active interrupts */
+	u32 i2simask;		/*interrupt mask */
+	u32 i2simaskclr;	/*interrupt mask clear */
+};
+
+struct ioh_i2s_config_tx_reg {
+	u32 i2sdrtx;	/*data register */
+	u32 i2scnttx; /*control register */
+	u32 i2sfifoctx;	/*FIFO control register */
+	u32 i2saftx;	/*almost full threshold setting */
+	u32 i2saetx;	/*almost empty threshold setting */
+	u32 i2smsktx;	/*interrupt mask settings */
+	u32 i2sisttx;	/*for acknowledging interrupts */
+	u32 i2smontx;	/*monitor register */
+};
+
+struct ioh_i2s_config_rx_reg {
+	u32 i2sdrrx;	/* data register */
+	u32 i2scntrx;	/* control register */
+	u32 i2sfifocrx;/* FIFO control register */
+	u32 i2safrx;	/* almost full threshold setting */
+	u32 i2saerx;	/* almost empty threshold setting */
+	u32 i2smskrx;	/* interrupt mask settings */
+	u32 i2sistrx;	/* for acknowledging interrupts */
+	u32 i2smonrx;	/* monitor register */
+};
+
+struct ioh_i2s_config_reg {
+	/* The common register settings */
+	struct ioh_i2s_config_common_reg cmn;
+
+	/* TX channel settings */
+	struct ioh_i2s_config_tx_reg tx;
+
+	/* RX channel settings */
+	struct ioh_i2s_config_rx_reg rx;
+};
+
+static struct snd_pcm_hardware snd_card_ml7213i2s_capture[MAX_I2S_CH] = {
+	{
+		.info =			(SNDRV_PCM_INFO_MMAP |
+					 SNDRV_PCM_INFO_INTERLEAVED |
+					 SNDRV_PCM_INFO_RESUME |
+					 SNDRV_PCM_INFO_MMAP_VALID),
+		.formats =		SUPPORT_FORMAT,
+		.channels_min =		USE_CHANNELS_MIN,
+		.channels_max =		USE_CHANNELS_MAX,
+		.buffer_bytes_max =	(MAX_PERIOD_SIZE_RX *
+					 USE_PERIODS_MAX),
+		.period_bytes_min =	MAX_PERIOD_SIZE_RX,
+		.period_bytes_max =	MAX_PERIOD_SIZE_RX,
+		.periods_min =		USE_PERIODS_MIN,
+		.periods_max =		USE_PERIODS_MAX,
+		.fifo_size =		0,
+	},
+	{
+		.info =			(SNDRV_PCM_INFO_MMAP |
+					 SNDRV_PCM_INFO_INTERLEAVED |
+					 SNDRV_PCM_INFO_RESUME |
+					 SNDRV_PCM_INFO_MMAP_VALID),
+		.formats =		SUPPORT_FORMAT,
+		.channels_min =		USE_CHANNELS_MIN,
+		.channels_max =		USE_CHANNELS_MAX,
+		.buffer_bytes_max =	(MAX_PERIOD_SIZE_RX *
+					 USE_PERIODS_MAX),
+		.period_bytes_min =	MAX_PERIOD_SIZE_RX,
+		.period_bytes_max =	MAX_PERIOD_SIZE_RX,
+		.periods_min =		USE_PERIODS_MIN,
+		.periods_max =		USE_PERIODS_MAX,
+		.fifo_size =		0,
+	},
+	{
+		.info =			(SNDRV_PCM_INFO_MMAP |
+					 SNDRV_PCM_INFO_INTERLEAVED |
+					 SNDRV_PCM_INFO_RESUME |
+					 SNDRV_PCM_INFO_MMAP_VALID),
+		.formats =		SUPPORT_FORMAT,
+		.channels_min =		USE_CHANNELS_MIN,
+		.channels_max =		USE_CHANNELS_MAX,
+		.buffer_bytes_max =	(MAX_PERIOD_SIZE_RX *
+					 USE_PERIODS_MAX),
+		.period_bytes_min =	MAX_PERIOD_SIZE_RX,
+		.period_bytes_max =	MAX_PERIOD_SIZE_RX,
+		.periods_min =		USE_PERIODS_MIN,
+		.periods_max =		USE_PERIODS_MAX,
+		.fifo_size =		0,
+	},
+	{
+		.info =			(SNDRV_PCM_INFO_MMAP |
+					 SNDRV_PCM_INFO_INTERLEAVED |
+					 SNDRV_PCM_INFO_RESUME |
+					 SNDRV_PCM_INFO_MMAP_VALID),
+		.formats =		SUPPORT_FORMAT,
+		.channels_min =		USE_CHANNELS_MIN,
+		.channels_max =		USE_CHANNELS_MAX,
+		.buffer_bytes_max =	(MAX_PERIOD_SIZE_RX *
+					 USE_PERIODS_MAX),
+		.period_bytes_min =	MAX_PERIOD_SIZE_RX,
+		.period_bytes_max =	MAX_PERIOD_SIZE_RX,
+		.periods_min =		USE_PERIODS_MIN,
+		.periods_max =		USE_PERIODS_MAX,
+		.fifo_size =		0,
+	},
+	{
+		.info =			(SNDRV_PCM_INFO_MMAP |
+					 SNDRV_PCM_INFO_INTERLEAVED |
+					 SNDRV_PCM_INFO_RESUME |
+					 SNDRV_PCM_INFO_MMAP_VALID),
+		.formats =		SUPPORT_FORMAT,
+		.channels_min =		USE_CHANNELS_MIN,
+		.channels_max =		USE_CHANNELS_MAX,
+		.buffer_bytes_max =	(MAX_PERIOD_SIZE_RX *
+					 USE_PERIODS_MAX),
+		.period_bytes_min =	MAX_PERIOD_SIZE_RX,
+		.period_bytes_max =	MAX_PERIOD_SIZE_RX,
+		.periods_min =		USE_PERIODS_MIN,
+		.periods_max =		USE_PERIODS_MAX,
+		.fifo_size =		0,
+	},
+	{
+		.info =			(SNDRV_PCM_INFO_MMAP |
+					 SNDRV_PCM_INFO_INTERLEAVED |
+					 SNDRV_PCM_INFO_RESUME |
+					 SNDRV_PCM_INFO_MMAP_VALID),
+		.formats =		SUPPORT_FORMAT,
+		.channels_min =		USE_CHANNELS_MIN,
+		.channels_max =		USE_CHANNELS_MAX,
+		.buffer_bytes_max =	(MAX_PERIOD_SIZE_RX *
+					 USE_PERIODS_MAX),
+		.period_bytes_min =	MAX_PERIOD_SIZE_RX,
+		.period_bytes_max =	MAX_PERIOD_SIZE_RX,
+		.periods_min =		USE_PERIODS_MIN,
+		.periods_max =		USE_PERIODS_MAX,
+		.fifo_size =		0,
+	},
+};
+
+static struct snd_pcm_hardware snd_card_ml7213i2s_playback[MAX_I2S_CH] = {
+	{
+		.info =			(SNDRV_PCM_INFO_MMAP |
+					 SNDRV_PCM_INFO_INTERLEAVED |
+					 SNDRV_PCM_INFO_RESUME |
+					 SNDRV_PCM_INFO_MMAP_VALID),
+		.formats =		SUPPORT_FORMAT,
+		.channels_min =		USE_CHANNELS_MIN,
+		.channels_max =		USE_CHANNELS_MAX,
+		.buffer_bytes_max =	(MAX_PERIOD_SIZE_TX *
+					 USE_PERIODS_MAX),
+		.period_bytes_min =	MAX_PERIOD_SIZE_TX,
+		.period_bytes_max =	MAX_PERIOD_SIZE_TX,
+		.periods_min =		USE_PERIODS_MIN,
+		.periods_max =		USE_PERIODS_MAX,
+		.fifo_size =		0,
+	},
+	{
+		.info =			(SNDRV_PCM_INFO_MMAP |
+					 SNDRV_PCM_INFO_INTERLEAVED |
+					 SNDRV_PCM_INFO_RESUME |
+					 SNDRV_PCM_INFO_MMAP_VALID),
+		.formats =		SUPPORT_FORMAT,
+		.channels_min =		USE_CHANNELS_MIN,
+		.channels_max =		USE_CHANNELS_MAX,
+		.buffer_bytes_max =	(MAX_PERIOD_SIZE_TX *
+					 USE_PERIODS_MAX),
+		.period_bytes_min =	MAX_PERIOD_SIZE_TX,
+		.period_bytes_max =	MAX_PERIOD_SIZE_TX,
+		.periods_min =		USE_PERIODS_MIN,
+		.periods_max =		USE_PERIODS_MAX,
+		.fifo_size =		0,
+	},
+	{
+		.info =			(SNDRV_PCM_INFO_MMAP |
+					 SNDRV_PCM_INFO_INTERLEAVED |
+					 SNDRV_PCM_INFO_RESUME |
+					 SNDRV_PCM_INFO_MMAP_VALID),
+		.formats =		SUPPORT_FORMAT,
+		.channels_min =		USE_CHANNELS_MIN,
+		.channels_max =		USE_CHANNELS_MAX,
+		.buffer_bytes_max =	(MAX_PERIOD_SIZE_TX *
+					 USE_PERIODS_MAX),
+		.period_bytes_min =	MAX_PERIOD_SIZE_TX,
+		.period_bytes_max =	MAX_PERIOD_SIZE_TX,
+		.periods_min =		USE_PERIODS_MIN,
+		.periods_max =		USE_PERIODS_MAX,
+		.fifo_size =		0,
+	},
+	{
+		.info =			(SNDRV_PCM_INFO_MMAP |
+					 SNDRV_PCM_INFO_INTERLEAVED |
+					 SNDRV_PCM_INFO_RESUME |
+					 SNDRV_PCM_INFO_MMAP_VALID),
+		.formats =		SUPPORT_FORMAT,
+		.channels_min =		USE_CHANNELS_MIN,
+		.channels_max =		USE_CHANNELS_MAX,
+		.buffer_bytes_max =	(MAX_PERIOD_SIZE_TX *
+					 USE_PERIODS_MAX),
+		.period_bytes_min =	MAX_PERIOD_SIZE_TX,
+		.period_bytes_max =	MAX_PERIOD_SIZE_TX,
+		.periods_min =		USE_PERIODS_MIN,
+		.periods_max =		USE_PERIODS_MAX,
+		.fifo_size =		0,
+	},
+	{
+		.info =			(SNDRV_PCM_INFO_MMAP |
+					 SNDRV_PCM_INFO_INTERLEAVED |
+					 SNDRV_PCM_INFO_RESUME |
+					 SNDRV_PCM_INFO_MMAP_VALID),
+		.formats =		SUPPORT_FORMAT,
+		.channels_min =		USE_CHANNELS_MIN,
+		.channels_max =		USE_CHANNELS_MAX,
+		.buffer_bytes_max =	(MAX_PERIOD_SIZE_TX *
+					 USE_PERIODS_MAX),
+		.period_bytes_min =	MAX_PERIOD_SIZE_TX,
+		.period_bytes_max =	MAX_PERIOD_SIZE_TX,
+		.periods_min =		USE_PERIODS_MIN,
+		.periods_max =		USE_PERIODS_MAX,
+		.fifo_size =		0,
+	},
+	{
+		.info =			(SNDRV_PCM_INFO_MMAP |
+					 SNDRV_PCM_INFO_INTERLEAVED |
+					 SNDRV_PCM_INFO_RESUME |
+					 SNDRV_PCM_INFO_MMAP_VALID),
+		.formats =		SUPPORT_FORMAT,
+		.channels_min =		USE_CHANNELS_MIN,
+		.channels_max =		USE_CHANNELS_MAX,
+		.buffer_bytes_max =	(MAX_PERIOD_SIZE_TX *
+					 USE_PERIODS_MAX),
+		.period_bytes_min =	MAX_PERIOD_SIZE_TX,
+		.period_bytes_max =	MAX_PERIOD_SIZE_TX,
+		.periods_min =		USE_PERIODS_MIN,
+		.periods_max =		USE_PERIODS_MAX,
+		.fifo_size =		0,
+	},
+};
+#endif
-- 
1.7.4.4

