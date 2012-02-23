Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab2BWFsc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 00:48:32 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39646 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777Ab2BWFrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 00:47:41 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of tomoya.rohm@gmail.com designates 10.68.74.72 as permitted sender) smtp.mail=tomoya.rohm@gmail.com; dkim=pass header.i=tomoya.rohm@gmail.com
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [PATCH v3] sound/soc/lapis: add platform driver for ML7213
Date: Thu, 23 Feb 2012 14:46:50 +0900
Message-Id: <1329976011-2251-2-git-send-email-tomoya.rohm@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1329976011-2251-1-git-send-email-tomoya.rohm@gmail.com>
References: <1329976011-2251-1-git-send-email-tomoya.rohm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver is for LAPIS Semiconductor ML7213 IOH I2S.

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
---
V3
 - Delete parameter "ignore_overrun"
 - Obey kernel comment description rule
 - if() statement replace switch() statement possible
 - Care for read-modify-write
 - Modify interrupt status condition
 - Change DMA function name "filter()"
 - Delete internal buffer
 - Add mapping function between number and channel
 - Delete magic numbers
 - Commonalize/Reduce functions
 - Use error macro (e.g. -ENOMEM) not negative integer value
 - Use ASoC suspend/resume functions.
---
 sound/soc/Kconfig                |    1 +
 sound/soc/Makefile               |    1 +
 sound/soc/lapis/Kconfig          |    4 +
 sound/soc/lapis/Makefile         |    4 +
 sound/soc/lapis/ioh_i2s.h        |   39 +
 sound/soc/lapis/ml7213ioh-plat.c | 1543 ++++++++++++++++++++++++++++++++++++++
 sound/soc/lapis/ml7213ioh-plat.h |  367 +++++++++
 7 files changed, 1959 insertions(+), 0 deletions(-)
 create mode 100644 sound/soc/lapis/Kconfig
 create mode 100644 sound/soc/lapis/Makefile
 create mode 100644 sound/soc/lapis/ioh_i2s.h
 create mode 100644 sound/soc/lapis/ml7213ioh-plat.c
 create mode 100644 sound/soc/lapis/ml7213ioh-plat.h

diff --git a/sound/soc/Kconfig b/sound/soc/Kconfig
index 1381db8..ff7678f 100644
--- a/sound/soc/Kconfig
+++ b/sound/soc/Kconfig
@@ -49,6 +49,7 @@ source "sound/soc/ep93xx/Kconfig"
 source "sound/soc/fsl/Kconfig"
 source "sound/soc/imx/Kconfig"
 source "sound/soc/jz4740/Kconfig"
+source "sound/soc/lapis/Kconfig"
 source "sound/soc/nuc900/Kconfig"
 source "sound/soc/omap/Kconfig"
 source "sound/soc/kirkwood/Kconfig"
diff --git a/sound/soc/Makefile b/sound/soc/Makefile
index 9ea8ac8..9592f41 100644
--- a/sound/soc/Makefile
+++ b/sound/soc/Makefile
@@ -11,6 +11,7 @@ obj-$(CONFIG_SND_SOC)	+= ep93xx/
 obj-$(CONFIG_SND_SOC)	+= fsl/
 obj-$(CONFIG_SND_SOC)   += imx/
 obj-$(CONFIG_SND_SOC)	+= jz4740/
+obj-$(CONFIG_SND_SOC)	+= lapis/
 obj-$(CONFIG_SND_SOC)	+= mid-x86/
 obj-$(CONFIG_SND_SOC)	+= mxs/
 obj-$(CONFIG_SND_SOC)	+= nuc900/
diff --git a/sound/soc/lapis/Kconfig b/sound/soc/lapis/Kconfig
new file mode 100644
index 0000000..551e385
--- /dev/null
+++ b/sound/soc/lapis/Kconfig
@@ -0,0 +1,4 @@
+config SND_SOC_ML7213_PLATFORM
+	tristate "ML7213 IOH ASoC platform driver"
+	help
+	  This option enables support for the AC Link Controllers in ML7213 IOH SoC.
diff --git a/sound/soc/lapis/Makefile b/sound/soc/lapis/Makefile
new file mode 100644
index 0000000..aba1630
--- /dev/null
+++ b/sound/soc/lapis/Makefile
@@ -0,0 +1,4 @@
+# Platform
+snd-soc-ml7213-plat-objs := ml7213ioh-plat.o
+
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
index 0000000..94ebfd6
--- /dev/null
+++ b/sound/soc/lapis/ml7213ioh-plat.c
@@ -0,0 +1,1543 @@
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
+
+/* I2S HAL (Hardware Abstruction Layer) */
+static void ioh_i2s_reset(int ch)
+{
+	iowrite32(1 << ch, i2s_data->iobase + I2SSRST_OFFSET);
+	iowrite32(0, i2s_data->iobase + I2SSRST_OFFSET);
+}
+
+static void ioh_i2s_enable_interrupts(int ch, int dir)
+{
+	unsigned int intr_lines = 0;
+
+	switch (dir) {
+	case SNDRV_PCM_STREAM_CAPTURE:
+		intr_lines = 1 << (I2S_IMASK_RX_BIT_START + ch);
+		break;
+	case SNDRV_PCM_STREAM_PLAYBACK:
+		intr_lines = 1 << (I2S_IMASK_TX_BIT_START + ch);
+		break;
+	}
+
+	/* enable interrupts for specified channel */
+	iowrite32(intr_lines, i2s_data->iobase + I2SIMASKCLR_OFFSET);
+}
+
+static void ioh_i2s_disable_interrupts(int ch, int dir)
+{
+	unsigned int intr_lines;
+
+	intr_lines = ioread32(i2s_data->iobase + I2SIMASK_OFFSET);
+
+	switch (dir) {
+	case SNDRV_PCM_STREAM_CAPTURE:
+		intr_lines |= 1 << (I2S_IMASK_RX_BIT_START + ch);
+		break;
+	case SNDRV_PCM_STREAM_PLAYBACK:
+		intr_lines |= 1 << (I2S_IMASK_TX_BIT_START + ch);
+		break;
+	}
+
+	/* Mask the specific interrupt bits */
+	iowrite32(intr_lines, i2s_data->iobase + I2SIMASK_OFFSET);
+}
+
+#define IOH_FIFO_CLR	0
+#define IOH_FIFO_RUN	1
+
+static void ioh_i2s_ctrl_fifo(int ch, int dir, int ctrl)
+{
+	int offset = ch * 0x800;
+	u32 val;
+	u32 reg_addr = 0;
+
+	switch (dir) {
+	case SNDRV_PCM_STREAM_CAPTURE:
+		reg_addr = I2SFIFOCRX_OFFSET;
+		break;
+	case SNDRV_PCM_STREAM_PLAYBACK:
+		reg_addr = I2SFIFOCTX_OFFSET;
+		break;
+	}
+
+	val = ioread32(i2s_data->iobase + reg_addr + offset);
+	if (ctrl)
+		val |= I2S_FIFO_TX_RUN;
+	else
+		val |= I2S_FIFO_TX_FCLR;
+
+	iowrite32(val, i2s_data->iobase + reg_addr + offset);
+}
+
+/* Clear interrupt status */
+static void ioh_i2s_clear_sts_ir(int ch, int dir)
+{
+	int offset = ch * 0x800;
+	u32 reg_addr = 0;
+	u32 val = 0;
+
+	switch (dir) {
+	case SNDRV_PCM_STREAM_CAPTURE:
+		reg_addr = I2SISTRX_OFFSET;
+		break;
+	case SNDRV_PCM_STREAM_PLAYBACK:
+		reg_addr = I2SISTTX_OFFSET;
+		break;
+	}
+	val = ioread32(i2s_data->iobase + reg_addr + offset) & 0xf;
+	if (val)
+		iowrite32(val, i2s_data->iobase + reg_addr + offset);
+}
+
+static void ioh_i2s_clear_dma_mask(int ch, int dir)
+{
+	u32 val = 0;
+	u32 mask = 0;
+	u32 reg_addr = 0;
+	int offset = ch * 0x800;
+
+	switch (dir) {
+	case SNDRV_PCM_STREAM_CAPTURE:
+		reg_addr = I2SMSKRX_OFFSET;
+		mask = RX_BIT_DMAMSK;
+		break;
+	case SNDRV_PCM_STREAM_PLAYBACK:
+		reg_addr = I2SMSKTX_OFFSET;
+		mask = TX_BIT_DMAMSK;
+		break;
+	}
+
+	val = ioread32(i2s_data->iobase + reg_addr + offset);
+	val &= ~mask; /* Enable Tx DMA Request */
+
+	iowrite32(val, i2s_data->iobase + reg_addr + offset);
+}
+
+#define IOH_DIS_IRQ		0
+#define IOH_EN_IRQ		1
+
+static void ioh_i2s_irq_ctrl(int ch, int dir, int ctrl)
+{
+	u32 val;
+	int offset = ch * 0x800;
+
+	switch (dir) {
+	case SNDRV_PCM_STREAM_CAPTURE:
+		val = ioread32(i2s_data->iobase + I2SMSKRX_OFFSET + offset);
+		if (ctrl) {
+			val &= ~RX_BIT_AFIMSK; /* Enable Almost empty IR */
+			val &= ~RX_BIT_FIMSK; /* Enable Empty IR */
+		} else {
+			val |= RX_BIT_AFIMSK; /* Disble Almost full IR */
+			val |= RX_BIT_FIMSK; /* Disble full IR */
+		}
+		iowrite32(val, i2s_data->iobase + I2SMSKRX_OFFSET + offset);
+		break;
+	case SNDRV_PCM_STREAM_PLAYBACK:
+		val = ioread32(i2s_data->iobase + I2SMSKTX_OFFSET + offset);
+		if (ctrl) {
+			val &= ~TX_BIT_AEIMSK; /* Enable Almost empty IR */
+			val &= ~TX_BIT_EIMSK; /* Enable Empty IR */
+		} else {
+			val |= TX_BIT_AEIMSK; /* Disble Almost empty IR */
+			val |= TX_BIT_EIMSK; /* Disble Empty IR */
+		}
+		iowrite32(val, i2s_data->iobase + I2SMSKTX_OFFSET + offset);
+		break;
+	}
+
+}
+
+/* Linux standard DMA functions */
+static bool ioh_dma_filter(struct dma_chan *chan, void *slave)
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
+int ioh_request_dma_channel(
+		   int ch, struct ioh_i2s_dma *ioh, enum dma_data_direction dir)
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
+	switch (dir) {
+	case DMA_FROM_DEVICE:
+		ioh->param_rx.width = ioh->dma_rx_width;
+		ioh->param_rx.dma_dev = &dma_dev->dev;
+		ioh->param_rx.chan_id = ch * 2 + 1; /* ch Rx=1,3,...11 */
+		ioh->param_rx.rx_reg = (dma_addr_t)(i2s_data->mapbase +\
+					ch * 0x800 + I2SDRRXMIRROR_OFFSET);
+		chan = dma_request_channel(mask, ioh_dma_filter,
+					   &ioh->param_rx);
+		if (chan == NULL) {
+			dev_err(i2s_data->dev, "Failed dma_request_channel for"
+				" I2S %d\n", ch);
+			return -ENOMEM;
+		}
+		ioh->chan_rx = chan;
+		break;
+	case DMA_TO_DEVICE:
+		ioh->param_tx.width = ioh->dma_tx_width;
+		ioh->param_tx.dma_dev = &dma_dev->dev;
+		ioh->param_tx.chan_id = ch * 2; /* DMA ch Tx=0,2,...10 */
+
+		ioh->param_tx.tx_reg = (dma_addr_t)(i2s_data->mapbase +\
+					ch * 0x800 + I2SDRTXMIRROR_OFFSET);
+
+		chan = dma_request_channel(mask, ioh_dma_filter,
+					   &ioh->param_tx);
+		if (chan == NULL) {
+			dev_err(i2s_data->dev, "Failed dma_request_channel for"
+				" I2S %d\n", ch);
+			return -ENOMEM;
+		}
+		ioh->chan_tx = chan;
+		break;
+	default:
+		dev_err(i2s_data->dev, "Invalid direction (%d)\n", dir);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static void ioh_i2s_stop_i2s_regs(int ch, int dir)
+{
+	switch (dir) {
+	case SNDRV_PCM_STREAM_CAPTURE:
+		/* Interrupt stop */
+		ioh_i2s_irq_ctrl(ch, SNDRV_PCM_STREAM_CAPTURE, IOH_DIS_IRQ);
+
+		/* FIFO setting */
+		ioh_i2s_ctrl_fifo(ch, SNDRV_PCM_STREAM_CAPTURE, IOH_FIFO_CLR);
+		ioh_i2s_clear_sts_ir(ch, SNDRV_PCM_STREAM_CAPTURE);
+		break;
+	case SNDRV_PCM_STREAM_PLAYBACK:
+		/* Interrupt stop */
+		ioh_i2s_irq_ctrl(ch, SNDRV_PCM_STREAM_PLAYBACK, IOH_DIS_IRQ);
+
+		/* FIFO setting */
+		ioh_i2s_ctrl_fifo(ch, SNDRV_PCM_STREAM_PLAYBACK, IOH_FIFO_CLR);
+		ioh_i2s_clear_sts_ir(ch, SNDRV_PCM_STREAM_PLAYBACK);
+		break;
+	}
+}
+
+static void ioh_i2s_configure_i2s_regs(int ch, int dir)
+{
+	int offset = ch * 0x800;
+
+	switch (dir) {
+	case SNDRV_PCM_STREAM_CAPTURE:
+		/* Rx register */
+		iowrite32(I2S_AFULL_THRESH / 2,
+		i2s_data->iobase + I2SAFRX_OFFSET + offset);
+		iowrite32(ML7213_I2SAERX_DEFAULT,
+			  i2s_data->iobase + I2SAERX_OFFSET + offset);
+		iowrite32(ML7213_I2SMSKRX_DEFAULT,
+			  i2s_data->iobase + I2SMSKRX_OFFSET + offset);
+		iowrite32(ML7213_I2SISTRX_DEFAULT,
+			  i2s_data->iobase + I2SISTRX_OFFSET + offset);
+		break;
+	case SNDRV_PCM_STREAM_PLAYBACK:
+		iowrite32(0, i2s_data->iobase + I2SAFTX_OFFSET + offset);
+		iowrite32(I2S_AEMPTY_THRESH / 2,
+		i2s_data->iobase + I2SAETX_OFFSET + offset);
+		iowrite32(ML7213_I2SMSKTX_DEFAULT,
+			  i2s_data->iobase + I2SMSKTX_OFFSET + offset);
+		iowrite32(ML7213_I2SISTTX_DEFAULT,
+			  i2s_data->iobase + I2SISTTX_OFFSET + offset);
+		break;
+	}
+}
+
+static void i2s_dma_rx_complete(void *arg)
+{
+	struct ioh_i2s_dma *ioh = (struct ioh_i2s_dma *)arg;
+	struct ml7213i2s_runtime_data *ioh_rtd =\
+				ioh->rx_substream->runtime->private_data;
+
+	pr_debug("%s in rx_cur_period=%d\n", __func__, ioh->rx_cur_period);
+
+	if (ioh_rtd->rx_stop) {
+		pr_debug("%s stopped. return.\n", __func__);
+		return;
+	}
+
+	ioh->rx_cur_period++;
+	if (ioh->rx_cur_period == ioh->buf_frags)
+		ioh->rx_cur_period = 0;
+
+	async_tx_ack(ioh->desc_rx);
+	if (ioh->rx_substream)
+		snd_pcm_period_elapsed(ioh->rx_substream);
+	ioh_i2s_irq_ctrl(ioh->number, SNDRV_PCM_STREAM_CAPTURE, IOH_EN_IRQ);
+}
+
+static void i2s_dma_tx_complete(void *arg)
+{
+	struct ioh_i2s_dma *ioh = (struct ioh_i2s_dma *)arg;
+	struct ml7213i2s_runtime_data *ioh_rtd =\
+				ioh->tx_substream->runtime->private_data;
+
+	pr_debug("%s in tx_cur_period=%d\n", __func__, ioh->tx_cur_period);
+
+	if (ioh_rtd->tx_stop) {
+		pr_debug("%s stopped. return.\n", __func__);
+		return;
+	}
+
+	ioh->tx_cur_period++;
+	if (ioh->tx_cur_period == ioh->buf_frags)
+		ioh->tx_cur_period = 0;
+
+	async_tx_ack(ioh->desc_tx);
+
+	if (ioh->tx_substream)
+		snd_pcm_period_elapsed(ioh->tx_substream);
+
+	ioh_i2s_irq_ctrl(ioh->number, SNDRV_PCM_STREAM_PLAYBACK, IOH_EN_IRQ);
+}
+
+static void i2s_dma_rx_start(struct ioh_i2s_dma *ioh, char *buff)
+{
+	struct dma_async_tx_descriptor *desc;
+	int rx_size;
+	int rx_num;
+	int i;
+	struct scatterlist *sg;
+
+	rx_size = I2S_AFULL_THRESH * 4;
+
+	/* The number of scatter list (Franction area is not used) */
+	if (ioh->period_bytes % rx_size)
+		/* rx_num = The number of scatter list */
+		rx_num = ioh->period_bytes / rx_size + 1;
+	else
+		rx_num = ioh->period_bytes / rx_size;
+
+	dev_dbg(i2s_data->dev, "%s: rx: scatter_num=%d scatter_size=%d\n",
+		__func__, rx_num, rx_size);
+
+	ioh->sg_rx_p =\
+	       kzalloc(sizeof(struct scatterlist) * rx_num, GFP_ATOMIC);
+
+	sg = ioh->sg_rx_p;
+
+	sg_init_table(sg, rx_num); /* Initialize SG table */
+	for (i = 0; i < rx_num; i++, sg++) {
+		sg_set_page(sg,  virt_to_page(buff), rx_size, rx_size * i);
+		sg_dma_len(sg) = rx_size / 4;
+		sg_dma_address(sg) = ioh->physical_addr + sg->offset;
+	}
+	ioh->rx_nent = rx_num;
+
+	dma_sync_sg_for_device(i2s_data->dev, ioh->sg_rx_p, ioh->rx_nent,
+			       DMA_FROM_DEVICE);
+
+	sg = ioh->sg_rx_p;
+
+	desc = ioh->chan_rx->device->device_prep_slave_sg(ioh->chan_rx,
+			sg, rx_num, DMA_FROM_DEVICE,
+			DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+	if (!desc) {
+		dev_err(i2s_data->dev, "%s:device_prep_slave_sg Failed\n",
+			__func__);
+		return;
+	}
+	ioh_i2s_irq_ctrl(ioh->number, SNDRV_PCM_STREAM_CAPTURE, IOH_DIS_IRQ);
+
+	ioh->desc_rx = desc;
+
+	desc->callback = i2s_dma_rx_complete;
+	desc->callback_param = ioh;
+
+	desc->tx_submit(desc);
+}
+
+static void i2s_dma_tx_start(struct ioh_i2s_dma *ioh, char *buff)
+{
+	struct dma_async_tx_descriptor *desc;
+	int tx_size;
+	int tx_num;
+	int i;
+	struct scatterlist *sg;
+
+	tx_size = I2S_AEMPTY_THRESH * 4;
+	if (ioh->period_bytes % tx_size)
+		/* tx_num = The number of scatter list */
+		tx_num = ioh->period_bytes / tx_size + 1;
+	else
+		tx_num = ioh->period_bytes / tx_size;
+
+	dev_dbg(i2s_data->dev, "%s: tx: scatter_num=%d scatter_size=%d\n",
+		__func__, tx_num, tx_size);
+
+	ioh->sg_tx_p =\
+	       kzalloc(sizeof(struct scatterlist) * tx_num, GFP_ATOMIC);
+
+	sg = ioh->sg_tx_p;
+	sg_init_table(sg, tx_num); /* Initialize SG table */
+
+	for (i = 0; i < tx_num; i++, sg++) {
+		sg_set_page(sg,  virt_to_page(buff), tx_size, tx_size * i);
+		sg_dma_len(sg) = tx_size / 4;
+		sg_dma_address(sg) = ioh->physical_addr + sg->offset;
+	}
+	ioh->tx_nent = tx_num;
+
+	dma_sync_sg_for_device(i2s_data->dev, ioh->sg_tx_p, ioh->tx_nent,
+			       DMA_TO_DEVICE);
+
+	sg = ioh->sg_tx_p;
+
+	desc = ioh->chan_tx->device->device_prep_slave_sg(ioh->chan_tx,
+					sg, tx_num, DMA_TO_DEVICE,
+					DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+	if (!desc) {
+		dev_err(i2s_data->dev, "%s:device_prep_slave_sg Failed\n",
+			__func__);
+		return;
+	}
+
+	ioh_i2s_irq_ctrl(ioh->number, SNDRV_PCM_STREAM_PLAYBACK, IOH_DIS_IRQ);
+
+	ioh->desc_tx = desc;
+
+	desc->callback = i2s_dma_tx_complete;
+	desc->callback_param = ioh;
+	desc->tx_submit(desc);
+}
+
+static void ioh_i2s_release(int ch, int dir)
+{
+	struct ioh_i2s_dma *ioh;
+
+	ioh = &dmadata[ch];
+
+	switch (dir) {
+	case SNDRV_PCM_STREAM_CAPTURE:
+		dma_sync_sg_for_cpu(i2s_data->dev, ioh->sg_rx_p, ioh->rx_nent,
+				    DMA_FROM_DEVICE);
+
+		ioh_i2s_disable_interrupts(ch, SNDRV_PCM_STREAM_CAPTURE);
+		ioh_i2s_irq_ctrl(ch, SNDRV_PCM_STREAM_CAPTURE, IOH_DIS_IRQ);
+		if (ioh->chan_rx) {
+			ioh->chan_rx->device->device_control(ioh->chan_rx,
+							     DMA_TERMINATE_ALL,
+							     0);
+			dma_release_channel(ioh->chan_rx);
+			ioh->chan_rx = NULL;
+		}
+
+		kfree(ioh->sg_rx_p);
+		ioh->rx_buf_dma = 0;
+		break;
+	case SNDRV_PCM_STREAM_PLAYBACK:
+		dma_sync_sg_for_cpu(i2s_data->dev, ioh->sg_tx_p, ioh->tx_nent,
+				    DMA_TO_DEVICE);
+
+		ioh_i2s_disable_interrupts(ch, SNDRV_PCM_STREAM_PLAYBACK);
+		ioh_i2s_irq_ctrl(ch, SNDRV_PCM_STREAM_PLAYBACK, IOH_DIS_IRQ);
+		if (ioh->chan_tx) {
+			ioh->chan_tx->device->device_control(ioh->chan_tx,
+							     DMA_TERMINATE_ALL,
+							     0);
+			dma_release_channel(ioh->chan_tx);
+			ioh->chan_tx = NULL;
+		}
+		kfree(ioh->sg_tx_p);
+		ioh->tx_buf_dma = 0;
+		break;
+	}
+}
+
+static inline void ioh_i2s_interrupt_sub_tx(int ch)
+{
+	unsigned int status;
+	int offset = ch * 0x800;
+	struct ioh_i2s_dma *ioh = &dmadata[ch];
+	struct ml7213i2s_runtime_data *ioh_rtd =\
+				ioh->tx_substream->runtime->private_data;
+	char *buff = ioh->dma_addr + ioh->tx_cur_period * ioh->period_bytes;
+
+	status = ioread32(i2s_data->iobase + I2SISTTX_OFFSET + offset);
+
+	if (status & I2S_TX_EINT)
+		dev_dbg(i2s_data->dev, "%s:I2S%d under flow occurs\n",
+			__func__, ch);
+	if (status & I2S_TX_AEINT)
+		if (!ioh_rtd->tx_stop)
+			i2s_dma_tx_start(ioh, buff);
+
+	/*Clear the interrupt status */
+	iowrite32(status, i2s_data->iobase + I2SISTTX_OFFSET + offset);
+}
+
+static inline void ioh_i2s_interrupt_sub_rx(int ch)
+{
+	unsigned int status;
+	int offset = ch * 0x800;
+	struct ioh_i2s_dma *ioh = &dmadata[ch];
+	struct ml7213i2s_runtime_data *ioh_rtd =\
+				ioh->rx_substream->runtime->private_data;
+	char *buff = ioh->dma_addr + ioh->rx_cur_period * ioh->period_bytes;
+
+	status = ioread32(i2s_data->iobase + I2SISTRX_OFFSET + offset);
+
+	if (status & I2S_RX_FINT)
+		dev_dbg(i2s_data->dev, "%s:I2S%d overrun occurs\n",
+			__func__, ch);
+	if (status & I2S_RX_AFINT)
+		if (!ioh_rtd->rx_stop)
+			i2s_dma_rx_start(ioh, buff);
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
+static int snd_card_ml7213i2s_open(struct snd_pcm_substream *substream)
+{
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	struct ml7213i2s_runtime_data *ioh_rtd;
+
+	ioh_rtd = kzalloc(sizeof(*ioh_rtd), GFP_KERNEL);
+	if (ioh_rtd == NULL)
+		return -ENOMEM;
+
+	runtime->private_data = ioh_rtd;
+
+	/* makes the infrastructure responsible for freeing dma */
+	snd_pcm_hw_constraint_integer(runtime, SNDRV_PCM_HW_PARAM_PERIODS);
+	snd_soc_set_runtime_hwparams(substream, &ml7213i2s_pcm_hw);
+
+	spin_lock_init(&ioh_rtd->lock);
+	return 0;
+}
+
+static int snd_card_ml7213i2s_close(struct snd_pcm_substream *substream)
+{
+	struct snd_pcm_runtime *runtime = substream->runtime;
+
+	kfree(runtime->private_data);
+
+	return 0;
+}
+
+static int snd_card_ml7213i2s_hw_params(struct snd_pcm_substream *substream,
+				    struct snd_pcm_hw_params *hw_params)
+{
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	struct snd_soc_pcm_runtime *rtd = substream->private_data;
+	struct ml7213i2s_runtime_data *ioh_rtd = runtime->private_data;
+	struct ioh_i2s_dma *dma =\
+			snd_soc_dai_get_dma_data(rtd->cpu_dai, substream);
+
+	ioh_rtd->dma = dma;
+
+	snd_pcm_set_runtime_buffer(substream, &substream->dma_buffer);
+	runtime->dma_bytes = params_buffer_bytes(hw_params);
+
+	return 0;
+}
+
+static int snd_card_ml7213i2s_hw_free(struct snd_pcm_substream *substream)
+{
+	struct ml7213i2s_runtime_data *ioh_rtd;
+	ioh_rtd = substream->runtime->private_data;
+
+	ioh_rtd->dma = NULL;
+	snd_pcm_set_runtime_buffer(substream, NULL);
+
+	return 0;
+}
+
+void ioh_i2s_irq_stop(int ch, int dir)
+{
+	switch (dir) {
+	case SNDRV_PCM_STREAM_CAPTURE:
+		ioh_i2s_disable_interrupts(ch, SNDRV_PCM_STREAM_CAPTURE);
+		ioh_i2s_irq_ctrl(ch, SNDRV_PCM_STREAM_CAPTURE, IOH_DIS_IRQ);
+		ioh_i2s_clear_sts_ir(ch, SNDRV_PCM_STREAM_CAPTURE);
+		break;
+	case SNDRV_PCM_STREAM_PLAYBACK:
+		ioh_i2s_disable_interrupts(ch, SNDRV_PCM_STREAM_PLAYBACK);
+		ioh_i2s_irq_ctrl(ch, SNDRV_PCM_STREAM_PLAYBACK, IOH_DIS_IRQ);
+		ioh_i2s_clear_sts_ir(ch, SNDRV_PCM_STREAM_PLAYBACK);
+		break;
+	}
+}
+
+static inline void
+snd_card_ml7213i2s_pcm_i2s_start(struct snd_pcm_substream *substream)
+{
+	int ch;
+	struct ioh_i2s_dma *ioh;
+
+	switch (substream->stream) {
+	int ret;
+	case SNDRV_PCM_STREAM_CAPTURE:
+		ch = dmadata[substream->number].mapped_rx_ch;
+		ioh = &dmadata[ch];
+		ioh->rx_substream = substream;
+		ret = ioh_request_dma_channel(ch, &dmadata[ch],
+					      DMA_FROM_DEVICE);
+		if (ret)
+			return;
+
+		break;
+	case SNDRV_PCM_STREAM_PLAYBACK:
+		ch = dmadata[substream->number].mapped_tx_ch;
+		ioh = &dmadata[ch];
+		ioh->tx_substream = substream;
+		ret = ioh_request_dma_channel(ch, &dmadata[ch], DMA_TO_DEVICE);
+		if (ret)
+			return;
+
+		break;
+	}
+
+	switch (substream->stream) {
+	case SNDRV_PCM_STREAM_CAPTURE:
+		ch = dmadata[substream->number].mapped_rx_ch;
+		ioh_i2s_clear_sts_ir(ch, SNDRV_PCM_STREAM_CAPTURE);
+		ioh_i2s_clear_dma_mask(ch, SNDRV_PCM_STREAM_CAPTURE);
+		ioh_i2s_enable_interrupts(ch, SNDRV_PCM_STREAM_CAPTURE);
+		break;
+	case SNDRV_PCM_STREAM_PLAYBACK:
+		ch = dmadata[substream->number].mapped_tx_ch;
+		ioh_i2s_clear_sts_ir(ch, SNDRV_PCM_STREAM_PLAYBACK);
+		ioh_i2s_clear_dma_mask(ch, SNDRV_PCM_STREAM_PLAYBACK);
+		ioh_i2s_enable_interrupts(ch, SNDRV_PCM_STREAM_PLAYBACK);
+		break;
+	}
+}
+
+static int snd_card_ml7213i2s_pcm_trigger
+				(struct snd_pcm_substream *substream, int cmd)
+{
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	struct ml7213i2s_runtime_data *ioh_rtd = runtime->private_data;
+	int err = 0;
+	unsigned long flags;
+	int ch;
+	spin_lock_irqsave(&ioh_rtd->lock, flags);
+
+	switch (cmd) {
+	case SNDRV_PCM_TRIGGER_START:
+	case SNDRV_PCM_TRIGGER_RESUME:
+		if (substream->stream == SNDRV_PCM_STREAM_CAPTURE)
+			ioh_rtd->rx_stop = 0;
+		else
+			ioh_rtd->tx_stop = 0;
+
+		snd_card_ml7213i2s_pcm_i2s_start(substream);
+		break;
+	case SNDRV_PCM_TRIGGER_STOP:
+	case SNDRV_PCM_TRIGGER_SUSPEND:
+		pr_debug("stop..\n");
+		if (substream->stream == SNDRV_PCM_STREAM_CAPTURE) {
+			ioh_rtd->rx_stop = 1;
+			ch = dmadata[substream->number].mapped_rx_ch;
+			ioh_i2s_irq_stop(ch, SNDRV_PCM_STREAM_CAPTURE);
+		} else {
+			ioh_rtd->tx_stop = 1;
+			ch = dmadata[substream->number].mapped_tx_ch;
+			ioh_i2s_irq_stop(ch, SNDRV_PCM_STREAM_PLAYBACK);
+		}
+		switch (substream->stream) {
+		case SNDRV_PCM_STREAM_CAPTURE:
+			ch = dmadata[substream->number].mapped_rx_ch;
+			ioh_i2s_release(ch, SNDRV_PCM_STREAM_CAPTURE);
+			break;
+		case SNDRV_PCM_STREAM_PLAYBACK:
+			ch = dmadata[substream->number].mapped_tx_ch;
+			ioh_i2s_release(ch, SNDRV_PCM_STREAM_PLAYBACK);
+			break;
+		}
+		break;
+	default:
+		err = -EINVAL;
+		break;
+	}
+
+	spin_unlock_irqrestore(&ioh_rtd->lock, flags);
+
+	return 0;
+}
+
+static int snd_card_ml7213i2s_pcm_prepare(struct snd_pcm_substream *substream)
+{
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	struct ml7213i2s_runtime_data *ioh_rtd = runtime->private_data;
+
+	switch (substream->stream) {
+	case SNDRV_PCM_STREAM_CAPTURE:
+		ioh_rtd->dma->rx_cur_period = 0;
+		break;
+	case SNDRV_PCM_STREAM_PLAYBACK:
+		ioh_rtd->dma->tx_cur_period = 0;
+		break;
+	}
+
+	ioh_rtd->dma->dma_addr = runtime->dma_area;
+	ioh_rtd->dma->physical_addr = runtime->dma_addr;
+	ioh_rtd->dma->buffer_bytes = snd_pcm_lib_buffer_bytes(substream);
+	ioh_rtd->dma->period_bytes = snd_pcm_lib_period_bytes(substream);
+	ioh_rtd->dma->buf_frags =\
+		ioh_rtd->dma->buffer_bytes / ioh_rtd->dma->period_bytes;
+
+	return 0;
+}
+
+static snd_pcm_uframes_t
+snd_card_ml7213i2s_pcm_pointer(struct snd_pcm_substream *substream)
+{
+	struct ml7213i2s_runtime_data *ioh_rtd =\
+					substream->runtime->private_data;
+	unsigned long offset = 0;
+
+	switch (substream->stream) {
+	case SNDRV_PCM_STREAM_CAPTURE:
+		offset =\
+		    ioh_rtd->dma->rx_cur_period * ioh_rtd->dma->period_bytes;
+		break;
+	case SNDRV_PCM_STREAM_PLAYBACK:
+		offset =\
+		    ioh_rtd->dma->tx_cur_period * ioh_rtd->dma->period_bytes;
+		break;
+	}
+
+	return bytes_to_frames(substream->runtime, offset);
+}
+
+static struct snd_pcm_ops snd_card_ml7213i2s_ops = {
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
+static int ml7213ioh_alloc_dma_buffer(struct snd_pcm *pcm, int stream)
+{
+	struct snd_pcm_substream *substream = pcm->streams[stream].substream;
+	struct snd_dma_buffer *buf = &substream->dma_buffer;
+	size_t size =  ml7213i2s_pcm_hw.buffer_bytes_max;
+
+	buf->dev.type = SNDRV_DMA_TYPE_DEV;
+	buf->dev.dev = pcm->card->dev;
+	buf->private_data = NULL;
+	buf->area = dma_alloc_coherent(pcm->card->dev, size,
+			&buf->addr, GFP_KERNEL);
+	if (!buf->area)
+		return -ENOMEM;
+	buf->bytes = size;
+
+	return 0;
+}
+
+static u64 idma_mask = DMA_BIT_MASK(32);
+static int ml7213ioh_pcm_new(struct snd_soc_pcm_runtime *rtd)
+{
+	struct snd_card *card = rtd->card->snd_card;
+	struct snd_soc_dai *dai = rtd->cpu_dai;
+	struct snd_pcm *pcm = rtd->pcm;
+	int ret = 0;
+
+	if (!card->dev->dma_mask)
+		card->dev->dma_mask = &idma_mask;
+	if (!card->dev->coherent_dma_mask)
+		card->dev->coherent_dma_mask = DMA_BIT_MASK(32);
+	if (dai->driver->playback.channels_min) {
+		ret = ml7213ioh_alloc_dma_buffer(pcm,
+			SNDRV_PCM_STREAM_PLAYBACK);
+		if (ret)
+			goto out;
+	}
+
+	if (dai->driver->capture.channels_min) {
+		ret = ml7213ioh_alloc_dma_buffer(pcm,
+			SNDRV_PCM_STREAM_CAPTURE);
+		if (ret)
+			goto out;
+	}
+out:
+	return ret;
+}
+
+static void ml7213ioh_pcm_free(struct snd_pcm *pcm)
+{
+	struct snd_pcm_substream *substream;
+	struct snd_dma_buffer *buf;
+	int stream;
+
+	for (stream = 0; stream < 2; stream++) {
+		substream = pcm->streams[stream].substream;
+		if (!substream)
+			continue;
+		buf = &substream->dma_buffer;
+		if (!buf->area)
+			continue;
+		buf->area = NULL;
+	}
+}
+
+static struct snd_soc_platform_driver ml7213ioh_soc_platform = {
+	.pcm_new	= ml7213ioh_pcm_new,
+	.pcm_free	= ml7213ioh_pcm_free,
+	.ops		= &snd_card_ml7213i2s_ops,
+};
+
+/* DAI functions */
+static int ml7213i2s_dai_hw_params(struct snd_pcm_substream *substream,
+			    struct snd_pcm_hw_params *hw_params,
+			    struct snd_soc_dai *dai)
+{
+	int ch;
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
+		return -EINVAL;
+		break;
+	}
+
+	switch (substream->stream) {
+	case SNDRV_PCM_STREAM_CAPTURE:
+		ch = dmadata[substream->number].mapped_rx_ch;
+		dmadata[ch].dma_rx_unit = byte;
+		dmadata[ch].dma_rx_width = PCH_DMA_WIDTH_4_BYTES;
+		ioh_i2s_configure_i2s_regs(ch, SNDRV_PCM_STREAM_CAPTURE);
+
+		/* FIFO setting */
+		ioh_i2s_ctrl_fifo(ch, SNDRV_PCM_STREAM_CAPTURE, IOH_FIFO_CLR);
+		ioh_i2s_ctrl_fifo(ch, SNDRV_PCM_STREAM_CAPTURE, IOH_FIFO_RUN);
+
+		/* Interrupt setting */
+		ioh_i2s_clear_sts_ir(ch, SNDRV_PCM_STREAM_CAPTURE);
+		ioh_i2s_irq_ctrl(ch, SNDRV_PCM_STREAM_CAPTURE, IOH_EN_IRQ);
+		break;
+	case SNDRV_PCM_STREAM_PLAYBACK:
+		ch = dmadata[substream->number].mapped_tx_ch;
+		dmadata[ch].dma_tx_unit = byte;
+		dmadata[ch].dma_tx_width = PCH_DMA_WIDTH_4_BYTES;
+		ioh_i2s_configure_i2s_regs(ch, SNDRV_PCM_STREAM_PLAYBACK);
+		/* FIFO setting */
+		ioh_i2s_ctrl_fifo(ch, SNDRV_PCM_STREAM_PLAYBACK, IOH_FIFO_CLR);
+		ioh_i2s_ctrl_fifo(ch, SNDRV_PCM_STREAM_PLAYBACK, IOH_FIFO_CLR);
+
+		/* Interrupt setting */
+		ioh_i2s_clear_sts_ir(ch, SNDRV_PCM_STREAM_PLAYBACK);
+		ioh_i2s_irq_ctrl(ch, SNDRV_PCM_STREAM_PLAYBACK, IOH_EN_IRQ);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	snd_soc_dai_set_dma_data(dai, substream, &dmadata[ch]);
+
+	return 0;
+}
+
+static int ml7213i2s_dai_hw_free(struct snd_pcm_substream *substream,
+				 struct snd_soc_dai *dai)
+{
+	unsigned int ch;
+
+	switch (substream->stream) {
+	case SNDRV_PCM_STREAM_CAPTURE:
+		ch = dmadata[substream->number].mapped_rx_ch;
+		ioh_i2s_stop_i2s_regs(ch, SNDRV_PCM_STREAM_CAPTURE);
+		break;
+
+	case SNDRV_PCM_STREAM_PLAYBACK:
+		ch = dmadata[substream->number].mapped_tx_ch;
+		ioh_i2s_stop_i2s_regs(ch, SNDRV_PCM_STREAM_PLAYBACK);
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int ml7213i2s_dai_set_dai_fmt(struct snd_soc_dai *dai,
+				     unsigned int fmt)
+{
+	u32 cmn_reg[MAX_I2S_CH];
+	u32 tx_reg[MAX_I2S_CH];
+	u32 rx_reg[MAX_I2S_CH];
+	int i;
+	int offset = 0;
+	void *iobase = i2s_data->iobase;
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
+			cmn_reg[i] |= ML7213I2S_LRCLK_FMT_I2S;
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
+	void *iobase = i2s_data->iobase;
+	int i;
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
+	u32 bclkfs = 0;
+	u32 mclkfs = 0;
+	void *iobase = i2s_data->iobase;
+	int ch;
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
+		switch (div) {
+		case 8:
+			bclkfs = IOH_BCLKFS_8FS;
+			break;
+		case 16:
+			bclkfs = IOH_BCLKFS_16FS;
+			break;
+		case 32:
+			bclkfs = IOH_BCLKFS_32FS;
+			break;
+		case 64:
+			bclkfs = IOH_BCLKFS_64FS;
+			break;
+		}
+		break;
+	case ML7213IOH_MCLKFS0:
+	case ML7213IOH_MCLKFS1:
+	case ML7213IOH_MCLKFS2:
+	case ML7213IOH_MCLKFS3:
+	case ML7213IOH_MCLKFS4:
+	case ML7213IOH_MCLKFS5:
+		switch (div) {
+		case 64:
+			mclkfs = IOH_MCLKFS_64FS;
+			break;
+		case 128:
+			mclkfs = IOH_MCLKFS_128FS;
+			break;
+		case 192:
+			mclkfs = IOH_MCLKFS_192FS;
+			break;
+		case 256:
+			mclkfs = IOH_MCLKFS_256FS;
+			break;
+		case 384:
+			mclkfs = IOH_MCLKFS_384FS;
+			break;
+		case 512:
+			mclkfs = IOH_MCLKFS_512FS;
+			break;
+		case 768:
+			mclkfs = IOH_MCLKFS_768FS;
+			break;
+		case 1024:
+			mclkfs = IOH_MCLKFS_1024FS;
+			break;
+		}
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	i2sclkcnt = ioread32(i2s_data->iobase + I2SCLKCNT0_OFFSET + 0x10 * ch);
+	i2sclkcnt |= bclkfs << I2SCLKCNT_BCLKFS_OFFSET;
+	i2sclkcnt |= mclkfs << I2SCLKCNT_MCLKFS_OFFSET;
+	iowrite32(i2sclkcnt, iobase + I2SCLKCNT0_OFFSET + 0x10 * ch);
+
+	return 0;
+}
+
+static int ml7213i2s_dai_set_channel_map(struct snd_soc_dai *dai,
+		unsigned int tx_num, unsigned int *tx_slot,
+		unsigned int rx_num, unsigned int *rx_slot)
+{
+	int i;
+	unsigned int slot;
+	unsigned int tx_mapped = 0, rx_mapped = 0;
+
+	if ((tx_num > MAX_I2S_CH) || (rx_num > MAX_I2S_CH))
+		return -EINVAL;
+
+	for (i = 0; i < tx_num; i++) {
+		slot = tx_slot[i];
+		if ((slot < MAX_I2S_CH) &&
+				(!(tx_mapped & (1 << slot)))) {
+			dmadata[i].mapped_tx_ch = slot;
+			tx_mapped |= 1 << slot;
+		} else
+			return -EINVAL;
+	}
+
+	for (i = 0; i < rx_num; i++) {
+		slot = rx_slot[i];
+		if ((slot < MAX_I2S_CH) &&
+				(!(rx_mapped & (1 << slot)))) {
+			dmadata[i].mapped_rx_ch = slot;
+			rx_mapped |= 1 << slot;
+		} else
+			return -EINVAL;
+	}
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static void ioh_i2s_save_reg_conf(void)
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
+static void ioh_i2s_restore_reg_conf(void)
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
+static int ml7213i2s_soc_suspend(struct snd_soc_dai *cpu_dai)
+{
+	ioh_i2s_save_reg_conf();
+
+	return 0;
+}
+
+static int ml7213i2s_soc_resume(struct snd_soc_dai *cpu_dai)
+{
+	ioh_i2s_restore_reg_conf();
+
+	return 0;
+}
+#else
+#define ml7213i2s_soc_suspend NULL
+#define spdif_soc_resume NULL
+#endif
+
+static const struct snd_soc_dai_ops ml7213i2s_dai_ops = {
+	.hw_params	= ml7213i2s_dai_hw_params,
+	.hw_free	= ml7213i2s_dai_hw_free,
+	.set_fmt	= ml7213i2s_dai_set_dai_fmt,
+	.set_sysclk	= ml7213i2s_dai_set_dai_sysclk,
+	.set_clkdiv	= ml7213i2s_dai_set_clkdiv,
+	.set_channel_map	= ml7213i2s_dai_set_channel_map,
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
+#ifdef CONFIG_PM
+	.suspend = ml7213i2s_soc_suspend,
+	.resume = ml7213i2s_soc_resume,
+#endif
+};
+
+/* PCI functions */
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
+static __devinit int ioh_i2s_probe(struct platform_device *pdev)
+{
+	int rv;
+
+	rv = snd_soc_register_platform(&pdev->dev, &ml7213ioh_soc_platform);
+	if (rv < 0)
+		printk(KERN_ERR "Failed to snd_soc_register_platform\n");
+
+	return rv;
+}
+
+static int __devexit ioh_i2s_remove(struct platform_device *pdev)
+{
+	snd_soc_unregister_platform(&pdev->dev);
+
+	return 0;
+}
+
+static struct platform_driver ioh_i2s_driver_plat = {
+	.driver = {
+		.name = "ml7213-i2s-audio",
+		.owner = THIS_MODULE,
+	},
+	.probe	= ioh_i2s_probe,
+	.remove	= __devexit_p(ioh_i2s_remove),
+};
+
+static struct platform_driver ioh_dai_driver_plat = {
+	.driver = {
+		.name = "ml7213ioh",
+		.owner = THIS_MODULE,
+	},
+};
+
+static struct platform_device *ioh_platform;
+static struct platform_device *ioh_platform_dai;
+static int ioh_i2s_pci_probe(struct pci_dev *pdev,
+			     const struct pci_device_id *id)
+{
+	int rv = 0;
+	void __iomem *tbl;
+	unsigned int mapbase;
+	int i;
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
+	dev_set_name(&pdev->dev, "%s", "ml7213ioh");
+
+	rv = snd_soc_register_dai(&pdev->dev, &ml7213i2s_dai_data);
+	if (rv < 0) {
+		printk(KERN_ERR "Failed to snd_soc_register_dai\n");
+		goto out_register_dai;
+	}
+
+	ioh_platform = platform_device_alloc("ml7213-i2s-audio", -1);
+	if (!ioh_platform) {
+		rv = -ENOMEM;
+		goto out_dev_alloc;
+	}
+
+	platform_set_drvdata(ioh_platform, i2s_data);
+
+	rv = platform_device_add(ioh_platform);
+	if (rv) {
+		dev_err(&pdev->dev, "failed to add platform device\n");
+		goto out_plat_dev_add;
+	}
+
+	ioh_platform_dai = platform_device_alloc("ml7213ioh", -1);
+	if (!ioh_platform_dai) {
+		rv = -ENOMEM;
+		goto out_dev_alloc_dai;
+	}
+
+	platform_set_drvdata(ioh_platform_dai, i2s_data);
+
+	rv = platform_device_add(ioh_platform_dai);
+	if (rv) {
+		dev_err(&pdev->dev, "failed to add platform device\n");
+		goto out_plat_dev_add_dai;
+	}
+
+	for (i = 0; i < MAX_I2S_CH; i++)
+		dmadata[i].number = i;
+
+	return 0;
+
+out_plat_dev_add_dai:
+	platform_device_put(ioh_platform_dai);
+out_dev_alloc_dai:
+	platform_device_del(ioh_platform_dai);
+
+out_plat_dev_add:
+	platform_device_put(ioh_platform);
+
+out_dev_alloc:
+	platform_device_del(ioh_platform);
+
+out_register_dai:
+	snd_soc_unregister_platform(&pdev->dev);
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
+	platform_device_unregister(ioh_platform_dai);
+	platform_device_unregister(ioh_platform);
+	snd_soc_unregister_dai(&pdev->dev);
+	snd_soc_unregister_platform(&pdev->dev);
+
+	free_irq(pdev->irq, pdev);
+	pci_iounmap(pdev, i2s_data->iobase);
+	pci_disable_device(pdev);
+}
+
+static int ioh_i2s_pci_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	int ret;
+
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
+static int __init ioh_plat_init(void)
+{
+	platform_driver_register(&ioh_i2s_driver_plat);
+	platform_driver_register(&ioh_dai_driver_plat);
+	return pci_register_driver(&ioh_i2s_driver);
+}
+
+static void __exit ioh_i2s_cleanup(void)
+{
+	pci_unregister_driver(&ioh_i2s_driver);
+	platform_driver_unregister(&ioh_dai_driver_plat);
+	platform_driver_unregister(&ioh_i2s_driver_plat);
+}
+
+module_init(ioh_plat_init);
+module_exit(ioh_i2s_cleanup);
+
+MODULE_AUTHOR("Tomoya MORINAGA <tomoya.rohm@gmail.com>");
+MODULE_DESCRIPTION("LAPIS Semiconductor ML7213 IOH ALSA SoC platform driver");
+MODULE_LICENSE("GPL");
diff --git a/sound/soc/lapis/ml7213ioh-plat.h b/sound/soc/lapis/ml7213ioh-plat.h
new file mode 100644
index 0000000..bd198f7
--- /dev/null
+++ b/sound/soc/lapis/ml7213ioh-plat.h
@@ -0,0 +1,367 @@
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
+#define DRV_NAME "ml7213ioh-i2s-pci"
+#define PCI_VENDOR_ID_ROHM	0X10DB
+#define PCI_DEVICE_ID_ML7213_I2S	0X8033
+
+#define I2SCLKCNT_MSSEL		BIT(0)
+#define ML7213I2S_BCLKPOL	BIT(1)
+#define ML7213I2S_LRCLK_FMT	(BIT(4) | BIT(5))
+#define ML7213I2S_LRCLK_FMT_I2S	BIT(4)
+
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
+/* DMA processing */
+#define	PERIOD_POS_MAX		I2S_DMA_SG_NUM
+#define	PERIOD_LEN		(I2S_AFULL_THRESH * PERIOD_POS_MAX)
+
+#define	SUPPORT_FORMAT		(SNDRV_PCM_FMTBIT_U8 | \
+				 SNDRV_PCM_FMTBIT_S16_LE | \
+				 SNDRV_PCM_FMTBIT_S32_LE)
+#define	MAX_PERIOD_SIZE		(PERIOD_LEN * 4)
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
+#define	I2S_DMA_SG_NUM		(128)
+#define	I2S_DMA_SG_MAX		(64)
+
+#define	IOH_MSSEL_MASTER	1
+
+#define ML7213_I2SAERX_DEFAULT	0x1f
+#define ML7213_I2SMSKRX_DEFAULT	0x1f
+#define ML7213_I2SISTRX_DEFAULT	0xC
+
+#define ML7213_I2SMSKTX_DEFAULT	0x1f
+#define ML7213_I2SISTTX_DEFAULT	0xC
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
+struct ml7213i2s_runtime_data {
+	spinlock_t lock;
+	int tx_stop;
+	int rx_stop;
+	struct ioh_i2s_dma *dma;
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
+	int ignore_rx_overrun;
+	spinlock_t tx_lock;
+	struct ioh_i2s_pm_ch_reg_cmn cmn_reg_save;
+	struct ioh_i2s_pm_ch_reg ch_reg_save[MAX_I2S_CH];
+};
+
+struct ioh_i2s_dma {
+	/* Transmit side DMA */
+	struct scatterlist	*sg_tx_p;
+	struct scatterlist	*sg_rx_p;
+
+	int tx_num;	/* The number of sent sg */
+	int rx_num;	/* The number of sent sg */
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
+	int dma_tx_unit; /* 1Byte of 2Byte or 4Byte */
+	int dma_rx_unit; /* 1Byte of 2Byte or 4Byte */
+	int dma_tx_width;
+	int dma_rx_width;
+
+	struct snd_pcm_substream *tx_substream;
+	struct snd_pcm_substream *rx_substream;
+
+	int number;
+
+	int mapped_tx_ch;
+	int mapped_rx_ch;
+
+	unsigned char *dma_addr;
+	dma_addr_t physical_addr;
+	unsigned long buffer_bytes;
+	unsigned long period_bytes;
+
+	int buf_frags;
+	int tx_cur_period;
+	int rx_cur_period;
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
+static struct snd_pcm_hardware ml7213i2s_pcm_hw = {
+	.info =			(SNDRV_PCM_INFO_MMAP |
+				 SNDRV_PCM_INFO_INTERLEAVED |
+				 SNDRV_PCM_INFO_RESUME |
+				 SNDRV_PCM_INFO_MMAP_VALID),
+	.formats =		SUPPORT_FORMAT,
+	.channels_min =	USE_CHANNELS_MIN,
+	.channels_max =	USE_CHANNELS_MAX,
+	.buffer_bytes_max =	MAX_PERIOD_SIZE * USE_PERIODS_MAX,
+	.period_bytes_min =	MAX_PERIOD_SIZE,
+	.period_bytes_max =	MAX_PERIOD_SIZE,
+	.periods_min =	USE_PERIODS_MIN,
+	.periods_max =	USE_PERIODS_MAX,
+	.fifo_size =		0,
+};
+#endif
-- 
1.7.7.6

