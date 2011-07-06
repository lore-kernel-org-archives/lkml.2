Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201Ab1GFK3g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 06:29:36 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:42549 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751670Ab1GFK3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 06:29:33 -0400
From: Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>
To: perex@perex.cz, tiwai@suse.de, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, tomoya-linux@dsn.okisemi.com,
        Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>
Subject: [PATCH] Add SoundCard driver for OKI SEMICONDUCTOR ML7213 IOH
Date: Wed,  6 Jul 2011 19:27:47 +0900
Message-Id: <1309948067-9333-1-git-send-email-toshiharu-linux@dsn.okisemi.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch is for SoundCard driver of OKI SEMICONDUCTOR ML7213
IOH(Input/Output Hub).
These ML7213 IOH is companion chip for Intel Atom E6xx series.
ML7213 IOH is for IVI(In-Vehicle Infotainment) use.

[About this driver]
Audio Codec does not exist in ML7213 IOH.
Therefore, this SoundCard driver controls ML26124 Audio Codec connected by
I2S of ML7213 IOH.
This driver consists of two modules, an ALSA sound card driver and I2S
driver.
An ALSA sound card driver performs control of ML26124 by I2C of ML7213 IOH.
When another Audio Codec is connected to I2S of ML7213 IOH,
it can respond by change of I2C control of an ALSA sound card driver.


Signed-off-by: Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>
---
 sound/drivers/Kconfig      |   34 ++
 sound/drivers/Makefile     |    8 +-
 sound/drivers/ioh_i2s.c    | 1310 ++++++++++++++++++++++++++++++++++++++++++++
 sound/drivers/ioh_i2s.h    |  116 ++++
 sound/drivers/ml7213-ioh.c |  985 +++++++++++++++++++++++++++++++++
 5 files changed, 2452 insertions(+), 1 deletions(-)
 create mode 100644 sound/drivers/ioh_i2s.c
 create mode 100644 sound/drivers/ioh_i2s.h
 create mode 100644 sound/drivers/ml7213-ioh.c

diff --git a/sound/drivers/Kconfig b/sound/drivers/Kconfig
index c896116..e098a91 100644
--- a/sound/drivers/Kconfig
+++ b/sound/drivers/Kconfig
@@ -209,6 +209,39 @@ config SND_AC97_POWER_SAVE
 
 	  See Documentation/sound/alsa/powersave.txt for more details.
 
+config ML7213_I2S
+	tristate "OKI SEMICONDUCTOR ML7213 IOH I2S Driver"
+	help
+	  This driver is OKI SEMICONDUCTOR ML7213 IOH I2S driver.
+	  ML7213 is companion chip for Intel Atom E6xx series.
+	  This driver is required to use ML7213 SoundCard.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called ioh_i2s.
+
+config ML7213_I2S_DEBUG
+	bool "ML7213 I2S driver debug"
+	depends on ML7213_I2S
+	default n
+	help
+	  This option enables the addition of a debugging code to
+	  the OKI SEMICONDUCTOR ML7213 IOH I2S Driver. If you are unsure, say N.
+
+	  To compile this driver as a debugging module, choose Y here: the module
+	  will be called ioh_i2s.
+
+config SND_ML7213_I2S
+	tristate "OKI SEMICONDUCTOR ML7213 SoundCard Driver for ML26124 Audio Codec"
+	depends on ML7213_I2S
+	default y
+	help
+	  This driver is OKI SEMICONDUCTOR ML7213 IOH SoundCard driver
+	  who controls ML26124 Audio Codec connected by I2S of ML7213 IOH.
+	  Control of ML26124 uses I2C of ML7213 IOH.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called snd-ml7213ioh.
+
 config SND_AC97_POWER_SAVE_DEFAULT
 	int "Default time-out for AC97 power-save mode"
 	depends on SND_AC97_POWER_SAVE
@@ -219,4 +252,5 @@ config SND_AC97_POWER_SAVE_DEFAULT
 
 	  See SND_AC97_POWER_SAVE for more details.
 
+
 endif	# SND_DRIVERS
diff --git a/sound/drivers/Makefile b/sound/drivers/Makefile
index 1a8440c..41350ea 100644
--- a/sound/drivers/Makefile
+++ b/sound/drivers/Makefile
@@ -11,15 +11,21 @@ snd-portman2x4-objs := portman2x4.o
 snd-serial-u16550-objs := serial-u16550.o
 snd-virmidi-objs := virmidi.o
 snd-ml403-ac97cr-objs := ml403-ac97cr.o pcm-indirect2.o
+snd-ml7213ioh-objs := ml7213-ioh.o
 
 # Toplevel Module Dependency
 obj-$(CONFIG_SND_DUMMY) += snd-dummy.o
 obj-$(CONFIG_SND_ALOOP) += snd-aloop.o
 obj-$(CONFIG_SND_VIRMIDI) += snd-virmidi.o
 obj-$(CONFIG_SND_SERIAL_U16550) += snd-serial-u16550.o
+obj-$(CONFIG_SND_ML7213_I2S) += snd-ml7213ioh.o
 obj-$(CONFIG_SND_MTPAV) += snd-mtpav.o
 obj-$(CONFIG_SND_MTS64) += snd-mts64.o
 obj-$(CONFIG_SND_PORTMAN2X4) += snd-portman2x4.o
 obj-$(CONFIG_SND_ML403_AC97CR) += snd-ml403-ac97cr.o
-
 obj-$(CONFIG_SND) += opl3/ opl4/ mpu401/ vx/ pcsp/
+obj-$(CONFIG_ML7213_I2S) += ioh_i2s.o
+ifeq ($(CONFIG_ML7213_I2S_DEBUG),y)
+EXTRA_CFLAG += -DDEBUG
+endif
+
diff --git a/sound/drivers/ioh_i2s.c b/sound/drivers/ioh_i2s.c
new file mode 100644
index 0000000..a40f6df
--- /dev/null
+++ b/sound/drivers/ioh_i2s.c
@@ -0,0 +1,1310 @@
+/*
+ * Copyright (C) 2010 OKI SEMICONDUCTOR CO., LTD.
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
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/io.h>
+#include <linux/ctype.h>
+#include <linux/interrupt.h>
+#include <linux/device.h>
+
+#include "ioh_i2s.h"
+
+#include <linux/dmaengine.h>
+#include <linux/dma-mapping.h>
+#include <linux/scatterlist.h>
+#include <linux/completion.h>
+#include <linux/delay.h>
+
+#include <linux/string.h>
+#include <linux/timer.h>
+#include <linux/workqueue.h>
+
+#include <linux/pci.h>
+#include <linux/pch_dma.h>
+
+#define MAX_I2S_IF	6	/*I2S0 ~ I2S5*/
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
+#define TX_OFFSET_INCREMENT	0x800
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
+/* DMA channel name configuration */
+static struct ioh_dma_config {
+	char rx_chan[8];
+	char tx_chan[8];
+} ioh_dma_config[] = {
+	{ /* I2S0 */
+		.tx_chan = "i2s_tx0",
+		.rx_chan = "i2s_rx0",
+	},
+	{ /* I2S1 */
+		.tx_chan = "i2s_tx1",
+		.rx_chan = "i2s_rx1",
+	},
+	{ /* I2S2 */
+		.tx_chan = "i2s_tx2",
+		.rx_chan = "i2s_rx2",
+	},
+	{ /* I2S3 */
+		.tx_chan = "i2s_tx3",
+		.rx_chan = "i2s_rx3",
+	},
+	{ /* I2S4 */
+		.tx_chan = "i2s_tx4",
+		.rx_chan = "i2s_rx4",
+	},
+	{ /* I2S5 */
+		.tx_chan = "i2s_tx5",
+		.rx_chan = "i2s_rx5",
+	},
+};
+
+struct ioh_i2s_data {
+	struct device *dev;
+	void *iobase;
+	int ch;
+	atomic_t rx_busy;
+	atomic_t tx_busy;
+
+	int ignore_rx_overrun;
+
+	/* Transmit side DMA */
+	atomic_t pending_tx;
+
+	struct ioh_dma_config *dma_config;
+
+	char rx_name[16];
+	char tx_name[16];
+
+	struct scatterlist	*sg_tx_p;
+	struct scatterlist	*sg_rx_p;
+
+	struct scatterlist	*sg_tx_cur; /* current head of tx sg */
+	struct scatterlist	*sg_rx_cur; /* current head of tx sg */
+	int tx_num;	/* The number of sent sg */
+
+	void *rxbuf_virt;
+	void *txbuf_virt;
+	unsigned char *tx_tail;
+	unsigned char *tx_head;
+	unsigned char *tx_data_head;
+	unsigned char *tx_complete;
+	unsigned char *rx_tail;
+	unsigned char *rx_head;
+	unsigned char *rx_data_head;
+	unsigned char *rx_complete;
+	struct dma_chan			*chan_tx;
+	struct dma_chan			*chan_rx;
+
+	int rx_nent;	/* The number of rx scatter list  */
+	int tx_nent;	/* The number of tx scatter list */
+
+	struct dma_async_tx_descriptor	*desc_tx;
+	struct dma_async_tx_descriptor	*desc_rx;
+
+	dma_addr_t			tx_buf_dma;
+	dma_addr_t			rx_buf_dma;
+
+	spinlock_t tx_lock;
+
+	struct pch_dma_slave		param_tx;
+	struct pch_dma_slave		param_rx;
+	unsigned int			mapbase;
+
+	void *rx_callback_data;
+	void (*rx_done) (void *callback_data, int status);
+	void *tx_callback_data;
+	void (*tx_done) (void *callback_data, int status);
+
+	unsigned int tx_lower_data_flag;
+
+	int dma_tx_unit; /* 1Byte of 2Byte or 4Byte */
+
+	int dma_tx_flag;	/* Now waiting tx DMA completion */
+	int dma_rx_flag;	/* Now waiting rx DMA completion */
+};
+
+static struct ioh_i2s_data devs[MAX_I2S_IF];
+
+/******************************************************************************
+	HAL (Hardware Abstruction Layer)
+*******************************************************************************/
+static void ioh_i2s_reset(struct ioh_i2s_data *priv)
+{
+	int channel = priv->ch;
+
+	iowrite32(1 << channel, priv->iobase + I2SSRST_OFFSET);
+	iowrite32(0, priv->iobase + I2SSRST_OFFSET);
+}
+
+static void ioh_i2s_enable_interrupts(struct ioh_i2s_data *priv,
+				      enum dma_data_direction dir)
+{
+	int channel = priv->ch;
+	unsigned int intr_lines;
+
+	if (dir)
+		intr_lines = 1 << (I2S_IMASK_RX_BIT_START + channel);
+
+	else
+		intr_lines = 1 << (I2S_IMASK_TX_BIT_START + channel);
+
+	/*enable interrupts for specified channel */
+	iowrite32(intr_lines, priv->iobase + I2SIMASKCLR_OFFSET);
+}
+
+static void ioh_i2s_disable_interrupts(struct ioh_i2s_data *priv,
+				       enum dma_data_direction dir)
+{
+	int channel = priv->ch;
+	unsigned int intr_lines;
+
+	/*intr_lines&=I2S_ALL_INTERRUPT_BITS; */
+	intr_lines = ioread32(priv->iobase + I2SIMASK_OFFSET);
+
+	/*disable interrupts for specified channel */
+	if (dir)
+		intr_lines |= 1 << (I2S_IMASK_RX_BIT_START + channel);
+	else
+		intr_lines |= 1 << (I2S_IMASK_TX_BIT_START + channel);
+
+	/*Mask the specific interrupt bits */
+	iowrite32(intr_lines, priv->iobase + I2SIMASK_OFFSET);
+}
+
+/* Run FIFO */
+static void ioh_i2s_run_tx_fifo(struct ioh_i2s_data *priv)
+{
+	int ch = priv->ch;
+	int offset = ch * 0x800;
+	u32 val;
+
+	val = ioread32(priv->iobase + I2SFIFOCTX_OFFSET + offset);
+	val |= I2S_FIFO_TX_RUN;
+	iowrite32(val, priv->iobase + I2SFIFOCTX_OFFSET + offset);
+}
+
+/* Clear TX FIFO */
+static void ioh_i2s_clear_tx_fifo(struct ioh_i2s_data *priv)
+{
+	int ch = priv->ch;
+	int offset = ch * 0x800;
+	u32 val;
+
+	val = ioread32(priv->iobase + I2SFIFOCTX_OFFSET + offset);
+	val |= I2S_FIFO_TX_FCLR;
+	iowrite32(val, priv->iobase + I2SFIFOCTX_OFFSET + offset);
+}
+
+/* Clear interrupt status */
+static void ioh_i2s_clear_tx_sts_ir(struct ioh_i2s_data *priv)
+{
+	int ch = priv->ch;
+	int offset = ch * 0x800;
+
+	iowrite32(I2S_TX_FINT | I2S_TX_AFINT | I2S_TX_EINT | I2S_TX_AEINT,
+		priv->iobase + I2SISTTX_OFFSET + offset);
+}
+
+/* Run FIFO */
+static void ioh_i2s_run_rx_fifo(struct ioh_i2s_data *priv)
+{
+	int ch = priv->ch;
+	int offset = ch * 0x800;
+	u32 val;
+
+	val = ioread32(priv->iobase + I2SFIFOCRX_OFFSET + offset);
+	val |= I2S_FIFO_RX_RUN;
+	iowrite32(val, priv->iobase + I2SFIFOCRX_OFFSET + offset);
+}
+
+/* Clear RX FIFO */
+static void ioh_i2s_clear_rx_fifo(struct ioh_i2s_data *priv)
+{
+	int ch = priv->ch;
+	int offset = ch * 0x800;
+	u32 val;
+
+	val = ioread32(priv->iobase + I2SFIFOCRX_OFFSET + offset);
+	val |= I2S_FIFO_RX_FCLR;
+	iowrite32(val, priv->iobase + I2SFIFOCRX_OFFSET + offset);
+}
+
+/* Clear interrupt status */
+static void ioh_i2s_clear_rx_sts_ir(struct ioh_i2s_data *priv)
+{
+	int ch = priv->ch;
+	int offset = ch * 0x800;
+
+	iowrite32(I2S_RX_FINT | I2S_RX_AFINT | I2S_RX_EINT | I2S_RX_AEINT,
+		priv->iobase + I2SISTRX_OFFSET + offset);
+}
+
+/* Clear DMA mask setting */
+static void ioh_i2s_tx_clear_dma_mask(struct ioh_i2s_data *priv)
+{
+	int ch = priv->ch;
+	int offset = ch * 0x800;
+	u32 val;
+
+	val = ioread32(priv->iobase + I2SMSKTX_OFFSET + offset);
+	val &= ~TX_BIT_DMAMSK; /* Enable Tx DMA Request */
+	iowrite32(val, priv->iobase + I2SMSKTX_OFFSET + offset);
+}
+
+/* Clear DMA mask setting */
+static void ioh_i2s_rx_clear_dma_mask(struct ioh_i2s_data *priv)
+{
+	int ch = priv->ch;
+	int offset = ch * 0x800;
+	u32 val;
+
+	val = ioread32(priv->iobase + I2SMSKRX_OFFSET + offset);
+	val &= ~RX_BIT_DMAMSK; /* Enable Rx DMA Request */
+	iowrite32(val, priv->iobase + I2SMSKRX_OFFSET + offset);
+}
+
+/* Clear the mask setting of the corresponding interrupt source bit */
+static void ioh_i2s_enable_tx_empty_ir(struct ioh_i2s_data *priv)
+{
+	int ch = priv->ch;
+	int offset = ch * 0x800;
+	u32 val;
+
+	val = ioread32(priv->iobase + I2SMSKTX_OFFSET + offset);
+	val &= ~TX_BIT_AEIMSK; /* Enable Almost empty interrupt */
+	val &= ~TX_BIT_EIMSK; /* Enable Empty interrupt */
+
+	iowrite32(val, priv->iobase + I2SMSKTX_OFFSET + offset);
+}
+
+/* Clear the mask setting of the corresponding interrupt source bit */
+static void ioh_i2s_enable_rx_full_ir(struct ioh_i2s_data *priv)
+{
+	int ch = priv->ch;
+	int offset = ch * 0x800;
+	u32 val;
+	val = ioread32(priv->iobase + I2SMSKRX_OFFSET + offset);
+
+	val &= ~RX_BIT_AFIMSK; /* Enable Almost empty interrupt */
+	val &= ~RX_BIT_FIMSK; /* Enable Empty interrupt */
+
+	iowrite32(val, priv->iobase + I2SMSKRX_OFFSET + offset);
+}
+
+static void ioh_i2s_disable_tx_empty_ir(struct ioh_i2s_data *priv)
+{
+	int ch = priv->ch;
+	int offset = ch * 0x800;
+	u32 val;
+
+	val = ioread32(priv->iobase + I2SMSKTX_OFFSET + offset);
+	val |= TX_BIT_AEIMSK; /* Disble Almost empty interrupt */
+	val |= TX_BIT_EIMSK; /* Disble Empty interrupt */
+
+	iowrite32(val, priv->iobase + I2SMSKTX_OFFSET + offset);
+}
+
+static void ioh_i2s_disable_rx_full_ir(struct ioh_i2s_data *priv)
+{
+	int ch = priv->ch;
+	int offset = ch * 0x800;
+	u32 val;
+
+	val = ioread32(priv->iobase + I2SMSKRX_OFFSET + offset);
+	val |= RX_BIT_AFIMSK; /* Disble Almost full interrupt */
+	val |= RX_BIT_FIMSK; /* Disble full interrupt */
+
+	iowrite32(val, priv->iobase + I2SMSKRX_OFFSET + offset);
+}
+
+/******************************************************************************
+	DMA Functions
+*******************************************************************************/
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
+static	struct dma_chan *ioh_request_dma_channel_common(
+			struct ioh_i2s_data *priv,
+			char *chan_name,
+			enum dma_data_direction dir)
+{
+	dma_cap_mask_t mask;
+	struct dma_chan *chan;
+	struct pci_dev *dma_dev;
+
+	dma_cap_zero(mask);
+	dma_cap_set(DMA_SLAVE, mask);
+
+	dma_dev = pci_get_bus_and_slot(2, PCI_DEVFN(0, 1)); /* Get DMA's dev
+								information */
+
+	if (dir == DMA_FROM_DEVICE) { /* Rx */
+		priv->param_rx.width = PCH_DMA_WIDTH_2_BYTES;
+		priv->param_rx.dma_dev = &dma_dev->dev;
+		priv->param_rx.chan_id = priv->ch * 2 + 1; /* ch Rx=1,3,...11 */
+		priv->param_rx.rx_reg = (dma_addr_t)((char *)priv->mapbase +\
+					priv->ch * 0x800 +\
+					I2SDRRXMIRROR_OFFSET);
+		chan = dma_request_channel(mask, filter, &priv->param_rx);
+		if (chan == NULL) {
+			dev_err(priv->dev, "Failed dma_request_channel %s for"
+				" I2S %s\n", chan_name, priv->rx_name);
+			return NULL;
+		}
+		priv->chan_rx = chan;
+
+	} else if (dir == DMA_TO_DEVICE) { /* Tx */
+		priv->param_tx.width = PCH_DMA_WIDTH_2_BYTES;
+		priv->param_tx.dma_dev = &dma_dev->dev;
+		priv->param_tx.chan_id = priv->ch * 2; /* DMA ch Tx=0,2,...10 */
+		priv->param_tx.tx_reg = (dma_addr_t)((char *)priv->mapbase +\
+					priv->ch * 0x800 +\
+					I2SDRTXMIRROR_OFFSET);
+		chan = dma_request_channel(mask, filter, &priv->param_tx);
+		if (chan == NULL) {
+			dev_err(priv->dev, "Failed dma_request_channel %s for"
+				" I2S %s\n", chan_name, priv->tx_name);
+			return NULL;
+		}
+		priv->chan_tx = chan;
+	} else {
+		dev_err(priv->dev, "%s:Invalid direction (%d)\n",
+			chan_name, dir);
+		return NULL;
+	}
+
+	return chan;
+}
+
+static void ioh_setup_rx_dma(struct ioh_i2s_data *priv)
+{
+	ioh_request_dma_channel_common(
+		priv,
+		priv->dma_config->rx_chan,
+		DMA_FROM_DEVICE);
+}
+
+static void ioh_setup_tx_dma(struct ioh_i2s_data *priv)
+{
+	ioh_request_dma_channel_common(
+		priv,
+		priv->dma_config->tx_chan,
+		DMA_TO_DEVICE);
+}
+
+static void i2s_dma_tx_complete(void *arg)
+{
+	struct ioh_i2s_data *priv = arg;
+	struct scatterlist *sg = priv->sg_tx_cur;
+	int i;
+
+	dev_dbg(priv->dev, "%s: data_head=%p data_complete=%p sg_len=%d num=%d",
+		__func__, priv->tx_data_head, priv->tx_complete, sg_dma_len(sg),
+		priv->tx_num);
+	dma_sync_sg_for_cpu(priv->dev, sg, priv->tx_num, DMA_TO_DEVICE);
+
+	for (i = 0; i < priv->tx_num; i++, sg++)
+		priv->tx_complete += sg_dma_len(sg) * priv->dma_tx_unit;
+
+	if (priv->tx_complete > priv->tx_tail) {
+		priv->tx_complete =\
+			     (char *)(((u32)priv->tx_complete &  0x00000fff) |\
+			     ((u32)priv->tx_head & 0xfffff000));
+	}
+
+	dev_dbg(priv->dev, "-->data_complete=%p\n", priv->tx_complete);
+
+	if ((priv->tx_complete - 1) == priv->tx_data_head)
+		ioh_i2s_disable_interrupts(priv, IOH_PLAYBACK);
+
+	async_tx_ack(priv->desc_tx);
+	if (priv->tx_done)
+		priv->tx_done(priv->tx_callback_data, IOH_EOK);
+
+	ioh_i2s_enable_tx_empty_ir(priv);
+	priv->dma_tx_flag = 0;
+}
+
+static void i2s_dma_rx_complete(void *arg)
+{
+	struct ioh_i2s_data *priv = arg;
+	struct scatterlist *sg = priv->sg_rx_cur;
+
+	dev_dbg(priv->dev, "%s: data_head=%p data_complete=%p sg_dma_len=%d\n",
+		__func__, priv->rx_data_head, priv->rx_complete,
+		sg_dma_len(sg));
+
+	priv->rx_data_head += sg_dma_len(sg) * priv->dma_tx_unit;
+
+	dev_dbg(priv->dev, "-->data_head=%p\n", priv->rx_data_head);
+
+	async_tx_ack(priv->desc_rx);
+
+	dma_sync_sg_for_cpu(priv->dev, sg, 1, DMA_FROM_DEVICE);
+
+	if (priv->rx_done)
+		priv->rx_done(priv->rx_callback_data, IOH_EOK);
+
+	ioh_i2s_enable_rx_full_ir(priv);
+	priv->dma_rx_flag = 0;
+}
+
+/******************************************************************************
+	Intrrupt Functions
+*******************************************************************************/
+void i2s_tx_almost_empty_ir(struct ioh_i2s_data *priv, int ch)
+{
+	struct dma_async_tx_descriptor *desc;
+	int num;
+	int tx_data_index;
+	int tx_comp_index;
+	struct scatterlist *sg = priv->sg_tx_p;
+
+	dev_dbg(priv->dev, "%s: data_head=%p data_complete=%p\n", __func__,
+		priv->tx_data_head, priv->tx_complete);
+
+	tx_data_index = (((int)priv->tx_data_head) & 0xfff) /\
+			(I2S_AEMPTY_THRESH * I2S_1PERIODS_BYTES);
+	tx_comp_index = (((int)priv->tx_complete) & 0xfff) /\
+			(I2S_AEMPTY_THRESH * I2S_1PERIODS_BYTES);
+
+	if (tx_data_index > tx_comp_index)
+		num = tx_data_index - tx_comp_index - 1;
+	else if (tx_comp_index == (priv->tx_nent - 1))
+		num = tx_data_index;
+	else
+		num = priv->tx_nent - tx_comp_index - 1;
+
+	dev_dbg(priv->dev, "%s: head_index=%d complete_index=%d num=%d\n",
+		__func__, tx_data_index, tx_comp_index, num);
+
+	if (num < 1) { /* there is no data */
+		priv->tx_lower_data_flag += 1;
+		if (priv->tx_lower_data_flag >= 10) {
+			priv->tx_lower_data_flag = 0;
+			priv->tx_data_head = priv->tx_head;
+			priv->tx_complete = priv->tx_tail;
+			ioh_i2s_disable_interrupts(priv, IOH_PLAYBACK);
+			ioh_i2s_disable_tx_empty_ir(priv);
+			dev_dbg(priv->dev, "%s:No data to send\n", __func__);
+		}
+		return; /* No data to transmit */
+	}
+
+	priv->tx_lower_data_flag = 0;
+
+	tx_comp_index = (tx_comp_index + 1) % (priv->tx_nent);
+	sg = sg + tx_comp_index; /* Point head of sg must be sent */
+	priv->sg_tx_cur = sg; /* Save tx condition */
+	priv->tx_num = num; /* Save tx condition */
+
+	dev_dbg(priv->dev, "%s: sg = sg + %d tx_nent=%d\n",
+		__func__, tx_comp_index, priv->tx_nent);
+
+	desc = priv->chan_tx->device->device_prep_slave_sg(priv->chan_tx,
+					sg, num, DMA_TO_DEVICE,
+					DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+	if (!desc) {
+		dev_err(priv->dev, "%s:device_prep_slave_sg Failed\n",
+			__func__);
+		return;
+	}
+
+	/* To prevent this function from calling again before DMA completion */
+	ioh_i2s_disable_tx_empty_ir(priv);
+	priv->dma_tx_flag = 1;
+
+	dma_sync_sg_for_device(priv->dev, sg, num, DMA_TO_DEVICE);
+	priv->desc_tx = desc;
+	desc->callback = i2s_dma_tx_complete;
+	desc->callback_param = priv;
+
+	atomic_inc(&priv->pending_tx);
+	desc->tx_submit(desc);
+
+	dma_async_issue_pending(priv->chan_tx);
+}
+
+void i2s_rx_almost_full_ir(struct ioh_i2s_data *priv)
+{
+	struct dma_async_tx_descriptor *desc;
+	struct scatterlist *sg;
+	int rx_data_index;
+
+	sg = priv->sg_rx_p;
+	rx_data_index = (((int)priv->rx_data_head) & 0xfff) /\
+			(I2S_AFULL_THRESH * I2S_1PERIODS_BYTES);
+	if (rx_data_index > priv->rx_nent)
+		rx_data_index = 0;
+
+	dev_dbg(priv->dev, "%s: data_head=%p data_complete=%p data_index=%d\n",
+		__func__, priv->rx_data_head, priv->rx_complete, rx_data_index);
+
+	sg += rx_data_index;
+
+	desc = priv->chan_rx->device->device_prep_slave_sg(priv->chan_rx,
+			sg, 1, DMA_FROM_DEVICE,
+			DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+	if (!desc) {
+		dev_err(priv->dev, "%s:device_prep_slave_sg Failed\n",
+			__func__);
+		return;
+	}
+
+	priv->sg_rx_cur = sg; /* Save rx condition */
+	ioh_i2s_disable_rx_full_ir(priv);
+	priv->dma_rx_flag = 1;
+	dma_sync_sg_for_device(priv->dev, sg, 1, DMA_FROM_DEVICE);
+
+	priv->desc_rx = desc;
+	desc->callback = i2s_dma_rx_complete;
+	desc->callback_param = priv;
+	desc->tx_submit(desc);
+	dma_async_issue_pending(priv->chan_rx);
+}
+
+void i2s_tx_empty_ir(struct ioh_i2s_data *priv, int ch)
+{
+	dev_warn(priv->dev, "%s:I2S under flow occurs(ch=%d)\n", __func__, ch);
+}
+
+void i2s_rx_full_ir(struct ioh_i2s_data *priv, int ch)
+{
+	dev_warn(priv->dev, "%s:I2S overrun occurs(ch=%d)\n", __func__, ch);
+}
+
+static inline void ioh_i2s_interrupt_sub_rx(struct ioh_i2s_data *priv)
+{
+	unsigned int status;
+	int channel = priv->ch;
+	int offset = channel * 0x800;
+
+	if (!priv->dma_rx_flag) {
+		status = ioread32(priv->iobase + I2SISTRX_OFFSET + offset);
+		if (status & I2S_RX_FINT)
+			i2s_rx_full_ir(priv, channel);
+		if (status & I2S_RX_AFINT)
+			i2s_rx_almost_full_ir(priv);
+
+		/*Clear the interrupt status */
+		iowrite32(status, priv->iobase + I2SISTRX_OFFSET + offset);
+	}
+}
+
+static inline void ioh_i2s_interrupt_sub_tx(struct ioh_i2s_data *priv)
+{
+	unsigned int status;
+	int channel = priv->ch;
+	int offset = channel * 0x800;
+
+	if (!priv->dma_tx_flag) {
+		status = ioread32(priv->iobase + I2SISTTX_OFFSET + offset);
+		if (status & I2S_TX_EINT)
+			i2s_tx_empty_ir(priv, channel);
+		if (status & I2S_TX_AEINT)
+			i2s_tx_almost_empty_ir(priv, channel);
+
+		/*Clear the interrupt status */
+		iowrite32(status, priv->iobase + I2SISTTX_OFFSET + offset);
+	}
+}
+
+int ioh_i2s_event(struct ioh_i2s_data *priv)
+{
+	u32 idisp;
+	unsigned long flags;
+	int ret = IRQ_NONE;
+
+	spin_lock_irqsave(&priv->tx_lock, flags);
+
+	idisp = ioread32(priv->iobase + I2SIDISP_OFFSET);
+	if (idisp & BIT(priv->ch + 16)) {
+		dev_dbg(priv->dev, "Rx%d interrupt occures\n", priv->ch);
+		ioh_i2s_interrupt_sub_rx(priv);
+		ret = IRQ_HANDLED;
+	}
+
+	if (idisp & BIT(priv->ch)) {
+		dev_dbg(priv->dev, "Tx%d interrupt occures\n", priv->ch);
+		ioh_i2s_interrupt_sub_tx(priv);
+		ret = IRQ_HANDLED;
+	}
+
+	spin_unlock_irqrestore(&priv->tx_lock, flags);
+
+	return ret;
+}
+
+/******************************************************************************
+	External Functions (Called by Sourdcard driver)
+*******************************************************************************/
+void ioh_i2s_ignore_rx_overrun(struct ioh_i2s_data *priv)
+{
+	priv->ignore_rx_overrun = 1;
+}
+EXPORT_SYMBOL_GPL(ioh_i2s_ignore_rx_overrun);
+
+struct ioh_i2s_data *ioh_i2s_open(int ch, enum ioh_direction dir,
+				     const char *name, void *cbd,
+				     void (*cb)(void *cbd, int status))
+{
+	struct ioh_i2s_data *obj = NULL;
+	struct scatterlist *sg;
+	int rx_size;
+	int rx_num;
+	int tx_size;
+	int tx_num;
+	int i;
+
+	if (ch >= MAX_I2S_IF) {
+		dev_err(obj->dev,
+			"Tried to open i2s with number %d which is more then"
+			" the available number\n", ch);
+		return 0;
+	}
+	obj = &devs[ch];
+
+	obj->ignore_rx_overrun = 0;
+	obj->dma_tx_unit = 2;	/* Tx transmits wuth 2Byte Unit */
+
+	if (dir) {
+		/* Rx configuration */
+		if (atomic_read(&obj->rx_busy)) {
+			dev_err(obj->dev, "rx i2s%d have already opened\n", ch);
+			atomic_dec(&obj->rx_busy);
+			return 0;
+		}
+		atomic_inc(&obj->rx_busy);
+
+		strcpy(obj->rx_name, name);
+		ioh_setup_rx_dma(obj);
+		if (!obj->chan_rx) {
+			dev_err(obj->dev, "%s:ioh_setup_rx_dma failed\n",
+				__func__);
+			return NULL;
+		}
+
+		obj->rxbuf_virt = dma_alloc_coherent(obj->dev, PAGE_SIZE,
+						&obj->rx_buf_dma, GFP_KERNEL);
+		if (!obj->rxbuf_virt) {
+			dev_err(obj->dev, "dma_alloc_coherent Failed\n");
+			return NULL;
+		}
+
+		rx_size = I2S_AFULL_THRESH * I2S_1PERIODS_BYTES;
+
+		/* The number of scatter list (Franction area is not used) */
+		rx_num = PAGE_SIZE / rx_size;
+
+		dev_dbg(obj->dev, "%s: rx: scatter_num=%d scatter_size=%d\n",
+			__func__, rx_num, rx_size);
+
+		obj->sg_rx_p =\
+		       kzalloc(sizeof(struct scatterlist) *rx_num, GFP_ATOMIC);
+
+		sg = obj->sg_rx_p;
+		sg_init_table(sg, rx_num); /* Initialize SG table */
+
+		for (i = 0; i < rx_num; i++, sg++) {
+			sg_set_page(sg, virt_to_page(obj->rxbuf_virt), rx_size,
+				    rx_size * i);
+			sg_dma_len(sg) = rx_size / obj->dma_tx_unit;
+			sg_dma_address(sg) = obj->rx_buf_dma + sg->offset;
+		}
+
+		obj->rx_head = (unsigned char *)obj->rxbuf_virt;
+		obj->rx_tail = (unsigned char *)obj->rxbuf_virt +\
+				rx_num * rx_size - 1;
+		obj->rx_data_head = (unsigned char *)obj->rxbuf_virt;
+		obj->rx_complete = (unsigned char *)obj->rx_tail;
+
+		obj->rx_nent = rx_num;
+	} else {
+		/* Tx configuration */
+		if (atomic_read(&obj->tx_busy)) {
+			dev_err(obj->dev, "tx i2s%d have already opened\n", ch);
+			atomic_dec(&obj->tx_busy);
+			return 0;
+		}
+		atomic_inc(&obj->tx_busy);
+
+		strcpy(obj->tx_name, name);
+		ioh_setup_tx_dma(obj);
+		if (!obj->chan_tx) {
+			dev_err(obj->dev, "%s:ioh_setup_tx_dma failed\n",
+				__func__);
+			return NULL;
+		}
+
+		obj->txbuf_virt = dma_alloc_coherent(obj->dev, PAGE_SIZE,
+						&obj->tx_buf_dma, GFP_KERNEL);
+
+		if (!obj->txbuf_virt) {
+			dev_err(obj->dev, "dma_alloc_coherent Failed\n");
+			return NULL;
+		}
+
+		obj->tx_head = (unsigned char *)obj->txbuf_virt;
+		obj->tx_tail = (unsigned char *)obj->txbuf_virt + PAGE_SIZE - 1;
+		obj->tx_data_head = (unsigned char *)obj->txbuf_virt;
+		obj->tx_complete = (unsigned char *)obj->tx_tail;
+
+		tx_size = I2S_AEMPTY_THRESH * I2S_1PERIODS_BYTES;
+		if (PAGE_SIZE % tx_size)
+			/* tx_num = The number of scatter list */
+			tx_num = PAGE_SIZE / tx_size + 1;
+		else
+			tx_num = PAGE_SIZE / tx_size;
+
+		dev_dbg(obj->dev, "%s: tx: scatter_num=%d scatter_size=%d\n",
+			__func__, tx_num, tx_size);
+
+		obj->sg_tx_p =\
+		       kzalloc(sizeof(struct scatterlist) *tx_num, GFP_ATOMIC);
+
+		sg_init_table(obj->sg_tx_p, tx_num); /* Initialize SG table */
+		sg = obj->sg_tx_p;
+
+		for (i = 0; i < tx_num; i++, sg++) {
+			if (i == (tx_num - 1)) {
+				if (PAGE_SIZE % tx_size) {
+					sg_set_page(sg,
+						  virt_to_page(obj->txbuf_virt),
+						  PAGE_SIZE % tx_size,
+						  tx_size * i);
+					sg_dma_len(sg) = (PAGE_SIZE % tx_size)\
+							/ obj->dma_tx_unit;
+				} else {
+					sg_set_page(sg,
+						  virt_to_page(obj->txbuf_virt),
+						  tx_size, tx_size * i);
+					sg_dma_len(sg) = tx_size\
+							/ obj->dma_tx_unit;
+				}
+			} else {
+				sg_set_page(sg, virt_to_page(obj->txbuf_virt),
+					    tx_size, tx_size * i);
+				sg_dma_len(sg) = tx_size / obj->dma_tx_unit;
+			}
+			sg_dma_address(sg) = obj->tx_buf_dma + sg->offset;
+		}
+		obj->tx_nent = tx_num;
+	}
+
+	return obj;
+}
+EXPORT_SYMBOL_GPL(ioh_i2s_open);
+
+void ioh_i2s_release(struct ioh_i2s_data *priv, enum ioh_direction dir)
+{
+	if (!priv) {
+		dev_err(priv->dev, "%s: i2s is NULL\n", __func__);
+		return;
+	}
+
+	if (dir) {
+		ioh_i2s_disable_interrupts(priv, IOH_CAPTURE);
+		ioh_i2s_disable_rx_full_ir(priv);
+		if (priv->chan_rx) {
+			priv->chan_rx->device->device_control(priv->chan_rx,
+							     DMA_TERMINATE_ALL,
+							     0);
+			dma_release_channel(priv->chan_rx);
+			priv->chan_rx = NULL;
+		}
+
+		kfree(priv->sg_rx_p);
+		if (priv->rxbuf_virt)
+			dma_free_coherent(priv->dev, PAGE_SIZE,
+					  priv->rxbuf_virt,
+					  priv->rx_buf_dma);
+
+		priv->rxbuf_virt = NULL;
+		priv->rx_buf_dma = 0;
+		atomic_dec(&priv->rx_busy);
+
+	} else {
+		ioh_i2s_disable_interrupts(priv, IOH_PLAYBACK);
+		ioh_i2s_disable_tx_empty_ir(priv);
+		if (priv->chan_tx) {
+			priv->chan_tx->device->device_control(priv->chan_tx,
+							     DMA_TERMINATE_ALL,
+							     0);
+			dma_release_channel(priv->chan_tx);
+			priv->chan_tx = NULL;
+		}
+
+		kfree(priv->sg_tx_p);
+		if (priv->txbuf_virt)
+			dma_free_coherent(priv->dev, PAGE_SIZE,
+					  priv->txbuf_virt,
+					  priv->tx_buf_dma);
+
+		priv->txbuf_virt = NULL;
+		priv->tx_buf_dma = 0;
+		atomic_dec(&priv->tx_busy);
+	}
+}
+EXPORT_SYMBOL_GPL(ioh_i2s_release);
+
+
+void ioh_i2s_configure_i2s_regs(struct ioh_i2s_data *priv,
+				    unsigned long bitrate,
+				    struct ioh_i2s_config_reg *config,
+				    enum ioh_direction dir)
+{
+	int ch = priv->ch;
+	int offset = ch * 0x800;
+
+	/* Common register */
+	iowrite32(config->cmn.i2sclkcnt,
+		  priv->iobase + I2SCLKCNT0_OFFSET + 0x10*ch);
+
+	if (dir) {
+		/* Rx register */
+		iowrite32(config->rx.i2scntrx,
+			  priv->iobase + I2SCNTRX_OFFSET + offset);
+		iowrite32(config->rx.i2sfifocrx,
+			  priv->iobase + I2SFIFOCRX_OFFSET + offset);
+		iowrite32(config->rx.i2safrx,
+			  priv->iobase + I2SAFRX_OFFSET + offset);
+		iowrite32(config->rx.i2saerx,
+			  priv->iobase + I2SAERX_OFFSET + offset);
+		iowrite32(config->rx.i2smskrx,
+			  priv->iobase + I2SMSKRX_OFFSET + offset);
+		iowrite32(config->rx.i2sistrx,
+			  priv->iobase + I2SISTRX_OFFSET + offset);
+
+		/* FIFO setting */
+		ioh_i2s_clear_rx_fifo(priv);
+		ioh_i2s_run_rx_fifo(priv);
+
+		/* Interrupt setting */
+		ioh_i2s_clear_rx_sts_ir(priv);
+		ioh_i2s_enable_rx_full_ir(priv);
+
+	} else {
+		/* Tx register */
+		iowrite32(config->tx.i2scnttx,
+			  priv->iobase + I2SCNTTX_OFFSET + offset);
+		iowrite32(config->tx.i2sfifoctx,
+			  priv->iobase + I2SFIFOCTX_OFFSET + offset);
+		iowrite32(config->tx.i2saftx,
+			  priv->iobase + I2SAFTX_OFFSET + offset);
+		iowrite32(config->tx.i2saetx,
+			  priv->iobase + I2SAETX_OFFSET + offset);
+		iowrite32(config->tx.i2smsktx,
+			  priv->iobase + I2SMSKTX_OFFSET + offset);
+		iowrite32(config->tx.i2sisttx,
+			  priv->iobase + I2SISTTX_OFFSET + offset);
+
+		/* FIFO setting */
+		ioh_i2s_clear_tx_fifo(priv);
+		ioh_i2s_run_tx_fifo(priv);
+
+		/* Interrupt setting */
+		ioh_i2s_clear_tx_sts_ir(priv);
+		ioh_i2s_enable_tx_empty_ir(priv);
+	}
+}
+EXPORT_SYMBOL_GPL(ioh_i2s_configure_i2s_regs);
+
+void ioh_i2s_write(struct ioh_i2s_data *priv,
+		       const void *data,
+		       int len,
+		       void *callback_data,
+		       void (*done) (void *callback_data, int status))
+{
+	int rem1;
+	int rem2;
+
+	priv->tx_callback_data = callback_data;
+	priv->tx_done = done;
+
+	dev_dbg(priv->dev, "%s: [ch%d] len=%d data_head=%p data_complete=%p",
+		__func__, priv->ch, len, priv->tx_data_head, priv->tx_complete);
+
+	if (priv->tx_data_head > priv->tx_tail)
+		priv->tx_data_head = priv->tx_head;
+
+	if ((priv->tx_data_head + len - 1) <= priv->tx_tail) {
+		memcpy(priv->tx_data_head, data, len);
+		priv->tx_data_head += len;
+	} else {
+		rem1 = priv->tx_tail - priv->tx_data_head + 1;
+		rem2 = len - rem1;
+		memcpy(priv->tx_data_head, data, rem1);
+		priv->tx_data_head = priv->tx_head;
+		memcpy(priv->tx_data_head, data + rem1, rem2);
+		priv->tx_data_head += rem2;
+	}
+	dev_dbg(priv->dev, "-->data_head=%p\n", priv->tx_data_head);
+
+	ioh_i2s_clear_tx_sts_ir(priv);
+	ioh_i2s_tx_clear_dma_mask(priv);
+	ioh_i2s_enable_tx_empty_ir(priv);
+	ioh_i2s_enable_interrupts(priv, IOH_PLAYBACK);
+}
+EXPORT_SYMBOL_GPL(ioh_i2s_write);
+
+void ioh_i2s_read(struct ioh_i2s_data *priv,
+		      void *data,
+		      int len,
+		      void *callback_data,
+		      void (*done) (void *callback_data, int status))
+{
+	int rx_ready_bytes;
+	unsigned int rem1 = 0, rem2 = 0;
+	char *rem;
+	char *copy_head;
+
+	priv->rx_callback_data = callback_data;
+	priv->rx_done = done;
+
+	ioh_i2s_clear_rx_sts_ir(priv);
+	ioh_i2s_rx_clear_dma_mask(priv);
+	ioh_i2s_enable_rx_full_ir(priv);
+	ioh_i2s_enable_interrupts(priv, IOH_CAPTURE);
+
+	dev_dbg(priv->dev, "%s: [ch%d]data_head=%p data_complete=%p len=%d\n",
+		__func__, priv->ch, priv->rx_data_head, priv->rx_complete, len);
+
+	if (((u32)priv->rx_data_head & 0xffff) ==\
+				      ((u32)(priv->rx_complete + 1) & 0xffff)) {
+		dev_dbg(priv->dev, "%s:No data to read\n", __func__);
+		return;
+	}
+
+	if (((u32)(priv->rx_complete + 1) & 0xfff) ==\
+					       (((u32)priv->rx_head) & 0xfff)) {
+		rx_ready_bytes = priv->rx_data_head - priv->rx_head;
+	} else if (priv->rx_complete < priv->rx_data_head) {
+		rx_ready_bytes = priv->rx_data_head - priv->rx_complete - 1;
+	} else {
+		rem1 = priv->rx_tail - priv->rx_complete;
+		if (rem1 < len)
+			rem2 = priv->rx_data_head - priv->rx_head;
+
+		dev_dbg(priv->dev, "%s:rem1=%d rem2=%d\n",
+			__func__, rem1, rem2);
+		rx_ready_bytes = rem1 + rem2;
+	}
+
+	dev_dbg(priv->dev,
+		"%s:rx_ready_bytes=%d(%d, %d) head_index=%d com_index=%d\n",
+		__func__, rx_ready_bytes, rem1, rem2,
+		(((int)priv->rx_data_head) & 0xfff) /\
+					(I2S_AFULL_THRESH * I2S_1PERIODS_BYTES),
+		(((int)priv->rx_complete) & 0xfff) /\
+				       (I2S_AFULL_THRESH * I2S_1PERIODS_BYTES));
+
+	if (priv->rx_data_head > priv->rx_tail)
+		priv->rx_data_head = priv->rx_head;
+
+	if (len > rx_ready_bytes) {
+		dev_dbg(priv->dev, "%s:Not enough data in bufffer\n", __func__);
+		return;
+	}
+
+	if (rem2) {
+		memcpy(data, priv->rx_complete + 1, rem1);
+
+		rem = (char *)data + rem1;
+		memcpy(rem, priv->rx_head, len - rem1);
+		priv->rx_complete = priv->rx_head + len - rem1 - 1;
+	} else {
+		copy_head = (char *)(((u32)(priv->rx_complete + 1) & 0xfff) |\
+			    ((u32)priv->rx_head & 0xfffff000));
+		memcpy(data, copy_head, len);
+		priv->rx_complete += len;
+	}
+
+	priv->rx_complete = (char *)((((u32)priv->rx_complete) & 0x00000fff) |\
+				    (((u32)priv->rx_head) & 0xfffff000));
+
+	dev_dbg(priv->dev, "com_index=%d data_complete=%p\n",
+		(((int)priv->rx_complete) & 0xfff) /\
+		(I2S_AFULL_THRESH * I2S_1PERIODS_BYTES),
+		priv->rx_complete);
+
+}
+EXPORT_SYMBOL_GPL(ioh_i2s_read);
+
+/******************************************************************************
+	PCI Functions
+*******************************************************************************/
+struct ioh_i2s_data *ioh_i2s_create(struct device *dev, void *iobase,
+				       unsigned int mapbase, int ch)
+{
+	struct ioh_i2s_data *obj;
+
+	dev_dbg(dev, "Instantiate an i2s instance with io at v0x%p.\n", iobase);
+
+	obj = &devs[ch];
+	obj->iobase = iobase;
+	obj->mapbase = mapbase;
+	obj->ch = ch;
+	obj->dev = dev;
+
+	atomic_set(&obj->rx_busy, 0);
+	atomic_set(&obj->tx_busy, 0);
+	strcpy(obj->rx_name, "FREE");
+	strcpy(obj->tx_name, "FREE");
+
+	return obj;
+}
+
+void ioh_i2s_destroy(struct ioh_i2s_data *priv)
+{
+}
+
+#define DRV_NAME "ml7213_ioh_i2s"
+#define PCI_VENDOR_ID_ROHM	0X10DB
+#define PCI_DEVICE_ID_ML7213_I2S	0X8033
+
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
+struct ioh_i2s_data_pci {
+	struct ioh_i2s_data *devs[MAX_I2S_IF];
+	void __iomem *membase;
+	unsigned int mapbase;
+};
+
+static irqreturn_t ioh_i2s_irq(int irq, void *data)
+{
+	struct pci_dev *pdev = (struct pci_dev *)data;
+	struct ioh_i2s_data_pci *drvdata = pci_get_drvdata(pdev);
+	int handled;
+
+	do {
+		int i;
+
+		handled = 0;
+		for (i = 0; i < MAX_I2S_IF; i++)
+			handled |= ioh_i2s_event(drvdata->devs[i]);
+
+	} while (handled);
+
+	return IRQ_HANDLED;
+}
+
+static int ioh_i2s_pci_probe(struct pci_dev *pdev,
+				 const struct pci_device_id *id)
+{
+	int rv = 0;
+	int i;
+	struct ioh_i2s_data_pci *drvdata;
+	void __iomem *tbl;
+	unsigned int mapbase;
+
+	drvdata = kzalloc(sizeof(struct ioh_i2s_data_pci), GFP_KERNEL);
+	if (!drvdata)
+		return -ENOMEM;
+
+	pci_set_drvdata(pdev, drvdata);
+
+	rv = pci_enable_device(pdev);
+	if (rv)
+		goto out_free;
+
+	tbl = pci_iomap(pdev, 1, 0);
+	mapbase = pci_resource_start(pdev, 1);
+	if (!mapbase) {
+		rv = -ENOMEM;
+		printk(KERN_ERR "pci_resource_start failed\n");
+		goto out_pci_resource_start;
+	}
+	drvdata->membase = tbl;
+	drvdata->mapbase = mapbase;
+
+	for (i = 0; i < MAX_I2S_IF; i++) {
+		drvdata->devs[i] =
+			    ioh_i2s_create(&pdev->dev, tbl, mapbase, i);
+
+		spin_lock_init(&drvdata->devs[i]->tx_lock);
+		drvdata->devs[i]->dma_config = &ioh_dma_config[i];
+	}
+
+	rv = request_irq(pdev->irq, ioh_i2s_irq, IRQF_SHARED, "ml7213_ioh",
+			 pdev);
+	if (rv != 0) {
+		printk(KERN_ERR "Failed to allocate irq\n");
+		goto out_disable;
+	}
+
+	return rv;
+out_pci_resource_start:
+	pci_iounmap(pdev, tbl);
+out_disable:
+	pci_disable_device(pdev);
+out_free:
+	kfree(drvdata);
+
+	return rv;
+}
+
+static void ioh_i2s_pci_remove(struct pci_dev *pdev)
+{
+	struct ioh_i2s_data_pci *drvdata = pci_get_drvdata(pdev);
+	int i;
+
+	free_irq(pdev->irq, pdev);
+	for (i = 0; i < MAX_I2S_IF; i++) {
+		if (drvdata->devs[i]) {
+			ioh_i2s_reset(drvdata->devs[i]);
+			ioh_i2s_destroy(drvdata->devs[i]);
+		}
+	}
+	pci_iounmap(pdev, drvdata->membase);
+	pci_disable_device(pdev);
+	pci_set_drvdata(pdev, NULL);
+	kfree(drvdata);
+}
+
+static int ioh_i2s_pci_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	BUG_ON(1);
+	return -EINVAL;
+}
+
+static int ioh_i2s_pci_resume(struct pci_dev *pdev)
+{
+	BUG_ON(1);
+	return -EINVAL;
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
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("OKI SEMICONDUCTOR ML7213 IOH");
+MODULE_DESCRIPTION("OKI SEMICONDUCTOR ML7213 IOH I2S driver");
+MODULE_DEVICE_TABLE(pci, ioh_pci_tbl);
+MODULE_VERSION("1.0");
diff --git a/sound/drivers/ioh_i2s.h b/sound/drivers/ioh_i2s.h
new file mode 100644
index 0000000..f652cef
--- /dev/null
+++ b/sound/drivers/ioh_i2s.h
@@ -0,0 +1,116 @@
+/*
+ * Copyright (C) 2010 OKI SEMICONDUCTOR CO., LTD.
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
+#define I2S_AEMPTY_THRESH	64	/* Almost  Empty Threshold */
+#define I2S_AFULL_THRESH	64	/* Almost  Full Threshold */
+#define USE_CHANNELS_MIN	1
+#define USE_CHANNELS_MAX	2
+#define I2S_1PERIODS_BYTES	2	/* 1 period byte suze (2 means 16bit) */
+
+#define MAX_I2S_RX_CH	6
+#define MAX_I2S_TX_CH	6
+
+struct ioh_i2s_data;
+
+
+enum ioh_direction {
+	IOH_PLAYBACK = 0,
+	IOH_CAPTURE,
+};
+
+struct ioh_i2s_data *ioh_i2s_open(int id, enum ioh_direction dir,
+				     const char *name, void *cbd,
+				     void (*cb)(void *cbd, int status));
+void ioh_i2s_release(struct ioh_i2s_data *priv, enum ioh_direction dir);
+void ioh_i2s_ignore_rx_overrun(struct ioh_i2s_data *priv);
+
+enum ioh_i2s_fifo_type {
+	IOH_FIFO_32  = 4,
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
+void ioh_i2s_configure_i2s_regs(struct ioh_i2s_data *priv,
+				      unsigned long bitrate,
+				      struct ioh_i2s_config_reg *config,
+				      enum ioh_direction dir);
+
+void ioh_i2s_write(struct ioh_i2s_data *priv,
+		       const void *data,
+		       int len,
+		       void *callback_data,
+		       void (*done) (void *callback_data, int status));
+
+void ioh_i2s_read(struct ioh_i2s_data *priv,
+		      void *data,
+		      int len,
+		      void *callback_data,
+		      void (*done) (void *callback_data, int status));
+
+#endif
diff --git a/sound/drivers/ml7213-ioh.c b/sound/drivers/ml7213-ioh.c
new file mode 100644
index 0000000..9ffb420
--- /dev/null
+++ b/sound/drivers/ml7213-ioh.c
@@ -0,0 +1,985 @@
+/*
+ * Copyright (c) 2010-2011 by Wind River
+ * Copyright (C) 2011 OKI SEMICONDUCTOR CO., LTD.
+ *
+ * This code was derived from the Wind River MSP/I2S audio capture for STA2X11.
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
+#include <linux/init.h>
+#include <linux/err.h>
+#include <linux/platform_device.h>
+#include <linux/jiffies.h>
+#include <linux/slab.h>
+#include <linux/moduleparam.h>
+#include <linux/i2c.h>
+#include <sound/core.h>
+#include <sound/pcm.h>
+#include <sound/initval.h>
+
+#include "ioh_i2s.h"
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("OKI SEMICONDUCTOR ML7213 IOH");
+MODULE_DESCRIPTION("OKI SEMICONDUCTOR ML7213 IOH I2S driver");
+MODULE_SUPPORTED_DEVICE("{{ALSA,ml7213i2s sound card}}");
+
+#define USE_FORMATS		SNDRV_PCM_FMTBIT_S16_LE
+#define USE_RATE		(SNDRV_PCM_RATE_16000|SNDRV_PCM_RATE_32000|\
+				SNDRV_PCM_RATE_48000)
+#define USE_RATE_MIN		16000
+#define USE_RATE_MAX		48000
+#define MAX_BUFFER_SIZE		(MAX_PERIOD_SIZE*USE_PERIODS_MAX)
+#define MIN_PERIOD_SIZE		64
+#define MAX_PERIOD_SIZE		(I2S_AFULL_THRESH*2) /* 16bit(=1word=2Byte)
+							FIFOsize=128word */
+
+#define USE_PERIODS_MIN		2
+#define USE_PERIODS_MAX		64
+
+#ifndef add_capture_constraints
+#define add_capture_constraints(x) 0
+#endif
+
+/* Direction configuration master(=1) or slave(=0) */
+#define I2S_WRITE_MASTER	1
+#define I2S_READ_MASTER		(I2S_WRITE_MASTER)
+
+/* RW flag */
+#define	SND_CAPTURE_SUBSTREAM	0
+#define	SND_PLAYBACK_SUBSTREAM	1
+
+/* Codec Device Address */
+#define	CODEC_DEV_ADDR		(0x1A)
+
+static int index = SNDRV_DEFAULT_IDX1;	/* Index 0-MAX */
+static char *id = SNDRV_DEFAULT_STR1;	/* ID for this card */
+static struct i2c_client *i2c;
+static struct i2c_board_info ioh_hwmon_info[] = {
+	{I2C_BOARD_INFO("ioh_i2c-0", CODEC_DEV_ADDR+0)},
+	{I2C_BOARD_INFO("ioh_i2c-1", CODEC_DEV_ADDR+0)},
+	{I2C_BOARD_INFO("ioh_i2c-2", CODEC_DEV_ADDR+0)},
+	{I2C_BOARD_INFO("ioh_i2c-3", CODEC_DEV_ADDR+0)},
+	{I2C_BOARD_INFO("ioh_i2c-4", CODEC_DEV_ADDR+0)},
+	{I2C_BOARD_INFO("ioh_i2c-5", CODEC_DEV_ADDR+0)},
+};
+
+static void setup_i2s_read(struct snd_pcm_substream *substream, int ch);
+static void setup_i2s_write(struct snd_pcm_substream *substream, int ch);
+
+module_param(index, int, 0444);
+MODULE_PARM_DESC(index, "Index value for ml7213i2s sound card.");
+module_param(id, charp, 0444);
+MODULE_PARM_DESC(id, "ID string for ml7213i2s sound card.");
+
+static int ignore_overrun = 1;
+module_param(ignore_overrun, int, 0444);
+MODULE_PARM_DESC(ignore_overrun, "ignore RX overruns (default=0)");
+
+static struct platform_device *_device;
+static struct mutex i2c_mutex;
+
+struct snd_ml7213i2s {
+	struct snd_card *card;
+	struct snd_pcm *pcm;
+};
+
+struct cbdata {
+	struct ioh_i2s_data *priv;
+	int stop;
+	int cnt;
+};
+
+static int errors;
+
+struct snd_ml7213i2s_pcm {
+	struct snd_ml7213i2s *ml7213i2s;
+	spinlock_t lock;
+	unsigned int irq_pos;
+	unsigned int buf_pos;
+	struct snd_pcm_substream *substream;
+	struct cbdata cbd;              /* i2s callback info */
+	unsigned int channels;
+	unsigned int rw;
+	unsigned int rate;
+};
+
+
+static void i2s_read_period(struct snd_pcm_substream *substream);
+static void i2s_write_period(struct snd_pcm_substream *substream);
+static void read_done(void *cbd, int status);
+static void write_done(void *cbd, int status);
+
+static inline void
+snd_card_ml7213i2s_pcm_i2s_capture_start(struct snd_pcm_substream *substream)
+{
+	i2s_read_period(substream);
+}
+
+static inline void
+snd_card_ml7213i2s_pcm_i2s_playback_start(struct snd_pcm_substream *substream)
+{
+	i2s_write_period(substream);
+}
+
+static int snd_card_ml7213i2s_pcm_capture_trigger
+				(struct snd_pcm_substream *substream, int cmd)
+{
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	struct snd_ml7213i2s_pcm *dpcm = runtime->private_data;
+	int err = 0;
+
+	spin_lock(&dpcm->lock);
+	switch (cmd) {
+	case SNDRV_PCM_TRIGGER_START:
+	case SNDRV_PCM_TRIGGER_RESUME:
+		dpcm->cbd.stop = 0;
+		snd_card_ml7213i2s_pcm_i2s_capture_start(substream);
+		break;
+	case SNDRV_PCM_TRIGGER_STOP:
+	case SNDRV_PCM_TRIGGER_SUSPEND:
+		pr_debug("stop..\n");
+		if (!dpcm->cbd.stop)
+			dpcm->cbd.stop = 1;
+		else
+			pr_debug("already stopped %d\n", dpcm->cbd.stop);
+		break;
+	default:
+		err = -EINVAL;
+		break;
+	}
+	spin_unlock(&dpcm->lock);
+	return 0;
+}
+
+
+static int snd_card_ml7213i2s_pcm_playback_trigger
+				(struct snd_pcm_substream *substream, int cmd)
+{
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	struct snd_ml7213i2s_pcm *dpcm = runtime->private_data;
+	int err = 0;
+
+	spin_lock(&dpcm->lock);
+	switch (cmd) {
+	case SNDRV_PCM_TRIGGER_START:
+	case SNDRV_PCM_TRIGGER_RESUME:
+		dpcm->cbd.stop = 0;
+		snd_card_ml7213i2s_pcm_i2s_playback_start(substream);
+		break;
+	case SNDRV_PCM_TRIGGER_STOP:
+	case SNDRV_PCM_TRIGGER_SUSPEND:
+		pr_debug("stop..\n");
+		if (!dpcm->cbd.stop)
+			dpcm->cbd.stop = 1;
+		else
+			pr_debug("already stopped %d\n", dpcm->cbd.stop);
+		break;
+	default:
+		err = -EINVAL;
+		break;
+	}
+	spin_unlock(&dpcm->lock);
+	return 0;
+}
+
+static int snd_card_ml7213i2s_pcm_prepare(struct snd_pcm_substream *substream)
+{
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	struct snd_ml7213i2s_pcm *dpcm = runtime->private_data;
+
+	dpcm->irq_pos = 0;
+	dpcm->buf_pos = 0;
+
+	snd_pcm_format_set_silence(runtime->format, runtime->dma_area,
+			bytes_to_samples(runtime, runtime->dma_bytes));
+
+	return 0;
+}
+
+static snd_pcm_uframes_t
+snd_card_ml7213i2s_pcm_pointer(struct snd_pcm_substream *substream)
+{
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	struct snd_ml7213i2s_pcm *dpcm = runtime->private_data;
+
+	return substream->runtime->period_size*dpcm->buf_pos;
+}
+
+static struct snd_pcm_hardware snd_card_ml7213i2s_capture = {
+	.info =			(SNDRV_PCM_INFO_MMAP |
+				 SNDRV_PCM_INFO_INTERLEAVED |
+				 SNDRV_PCM_INFO_RESUME |
+				 SNDRV_PCM_INFO_MMAP_VALID),
+	.formats =		USE_FORMATS,
+	.rates =		USE_RATE,
+	.rate_min =		USE_RATE_MIN,
+	.rate_max =		USE_RATE_MAX,
+	.channels_min =		USE_CHANNELS_MIN,
+	.channels_max =		USE_CHANNELS_MAX,
+	.buffer_bytes_max =	MAX_BUFFER_SIZE,
+	.period_bytes_min =	MIN_PERIOD_SIZE,
+	.period_bytes_max =	MAX_PERIOD_SIZE,
+	.periods_min =		USE_PERIODS_MIN,
+	.periods_max =		USE_PERIODS_MAX,
+	.fifo_size =		0,
+};
+
+static void __snd_card_ml7213i2s_runtime_free(struct snd_pcm_runtime *runtime)
+{
+	struct snd_ml7213i2s_pcm *dpcm;
+	static int cnt;
+
+	dpcm = (struct snd_ml7213i2s_pcm *)runtime->private_data;
+	/* FIXME: This is just a big ball of race right now...
+	 */
+	if (!dpcm->cbd.stop)
+		dpcm->cbd.stop = 1;
+	else {
+		while (dpcm->cbd.stop != 2) {
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
+static void snd_card_ml7213i2s_runtime_playback_free
+					(struct snd_pcm_runtime *runtime)
+{
+	struct snd_ml7213i2s_pcm *dpcm;
+	dpcm = (struct snd_ml7213i2s_pcm *)runtime->private_data;
+
+	__snd_card_ml7213i2s_runtime_free(runtime);
+
+	ioh_i2s_release(dpcm->cbd.priv, IOH_PLAYBACK);
+	kfree(runtime->private_data);
+}
+
+static void snd_card_ml7213i2s_runtime_capture_free
+					(struct snd_pcm_runtime *runtime)
+{
+	struct snd_ml7213i2s_pcm *dpcm;
+	dpcm = (struct snd_ml7213i2s_pcm *)runtime->private_data;
+
+	__snd_card_ml7213i2s_runtime_free(runtime);
+
+	ioh_i2s_release(dpcm->cbd.priv, IOH_CAPTURE);
+	kfree(runtime->private_data);
+}
+
+static int snd_card_codec_reg_read(unsigned char reg, unsigned char *val)
+{
+	unsigned char data;
+
+	if (i2c_master_send(i2c, &reg, 1) != 1)
+		return -1;
+
+	if (i2c_master_recv(i2c, &data, 1) != 1)
+		return -1;
+
+	*val = data;
+	return 0;
+}
+
+static int snd_card_codec_reg_write(unsigned char reg, unsigned char val)
+{
+	unsigned char buf[2] = {(reg|1), val};
+
+	if (i2c_master_send(i2c, &buf[0], 2) != 2)
+		return -1;
+	return 0;
+}
+
+static int snd_card_codec_set(int number, unsigned int rate,
+			      unsigned int channels)
+{
+	unsigned char data;
+
+	mutex_lock(&i2c_mutex);
+
+	i2c = i2c_new_device(i2c_get_adapter(1), &ioh_hwmon_info[number]);
+	if (!i2c) {
+		mutex_unlock(&i2c_mutex);
+		return -1;
+	}
+
+	snd_card_codec_reg_read(0x30, &data);
+
+	snd_card_codec_reg_write(0x10, 0x01);	/* soft reset assert */
+	snd_card_codec_reg_write(0x10, 0x00);	/* soft reset negate */
+
+	snd_card_codec_reg_write(0x0c, 0x00);
+
+	switch (rate) {
+	case 16000:
+		snd_card_codec_reg_write(0x00, 0x03);
+		snd_card_codec_reg_write(0x02, 0x0c);
+		snd_card_codec_reg_write(0x04, 0x00);
+		snd_card_codec_reg_write(0x06, 0x20);
+		snd_card_codec_reg_write(0x08, 0x00);
+		snd_card_codec_reg_write(0x0a, 0x04);
+		break;
+	case 32000:
+		snd_card_codec_reg_write(0x00, 0x06);
+		snd_card_codec_reg_write(0x02, 0x0c);
+		snd_card_codec_reg_write(0x04, 0x00);
+		snd_card_codec_reg_write(0x06, 0x20);
+		snd_card_codec_reg_write(0x08, 0x00);
+		snd_card_codec_reg_write(0x0a, 0x04);
+		break;
+	case 48000:
+		snd_card_codec_reg_write(0x00, 0x08);
+		snd_card_codec_reg_write(0x02, 0x0c);
+		snd_card_codec_reg_write(0x04, 0x00);
+		snd_card_codec_reg_write(0x06, 0x30);
+		snd_card_codec_reg_write(0x08, 0x00);
+		snd_card_codec_reg_write(0x0a, 0x04);
+		break;
+	default:
+		pr_err("%s:this rate is no support for ml26124\n", __func__);
+		break;
+	}
+
+	snd_card_codec_reg_write(0x0c, 0x03);
+	msleep(20);
+	snd_card_codec_reg_write(0x0c, 0x0f);
+	snd_card_codec_reg_write(0x0e, 0x04);
+
+	snd_card_codec_reg_write(0x60, 0x00);
+	snd_card_codec_reg_write(0x62, 0x00);
+
+	snd_card_codec_reg_write(0x64, 0x00);	/* master/slave */
+
+	snd_card_codec_reg_write(0x20, 0x02);
+	msleep(50);
+
+	snd_card_codec_reg_write(0x20, 0x06);
+	snd_card_codec_reg_write(0x22, 0x0a);
+	snd_card_codec_reg_write(0x24, 0x02);
+	snd_card_codec_reg_write(0x26, 0x13);
+	snd_card_codec_reg_write(0x26, 0x1f);
+	snd_card_codec_reg_write(0x28, 0x02);
+
+	snd_card_codec_reg_write(0x54, 0x02);
+	snd_card_codec_reg_write(0x5a, 0x00);
+
+	snd_card_codec_reg_write(0x12, 0x01);
+	snd_card_codec_reg_write(0x12, 0x03);
+	msleep(20);
+	snd_card_codec_reg_write(0x66, 0x03);
+
+	snd_card_codec_reg_write(0x3a, 0x27);
+	snd_card_codec_reg_write(0x32, 0x20);
+
+	i2c_unregister_device(i2c);
+
+	mutex_unlock(&i2c_mutex);
+	return 0;
+}
+
+static int snd_card_codec_free(int number, unsigned int rate,
+			       unsigned int channels)
+{
+	mutex_lock(&i2c_mutex);
+
+	i2c = i2c_new_device(i2c_get_adapter(1), &ioh_hwmon_info[number]);
+	if (!i2c) {
+		mutex_unlock(&i2c_mutex);
+		return -1;
+	}
+
+	snd_card_codec_reg_write(0x10, 1);	/* soft reset assert */
+
+	i2c_unregister_device(i2c);
+	mutex_unlock(&i2c_mutex);
+	return 0;
+}
+
+static int snd_card_ml7213i2s_hw_params(struct snd_pcm_substream *substream,
+				    struct snd_pcm_hw_params *hw_params)
+{
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	struct snd_ml7213i2s_pcm *dpcm = runtime->private_data;
+
+	dpcm->channels = params_channels(hw_params);
+	dpcm->rate = params_rate(hw_params);
+
+
+	switch (dpcm->rw) {
+	case SND_CAPTURE_SUBSTREAM:
+		setup_i2s_read(substream, substream->number);
+		break;
+	case SND_PLAYBACK_SUBSTREAM:
+		setup_i2s_write(substream, substream->number);
+		break;
+	default:
+		return -1;
+	}
+
+	if (snd_card_codec_set(substream->number, dpcm->rate, dpcm->channels))
+		return -1;
+
+
+	return snd_pcm_lib_malloc_pages(substream,
+					params_buffer_bytes(hw_params));
+}
+
+static int snd_card_ml7213i2s_hw_free(struct snd_pcm_substream *substream)
+{
+	struct snd_ml7213i2s_pcm *dpcm = substream->runtime->private_data;
+
+	if (snd_card_codec_free(substream->number, dpcm->rate, dpcm->channels))
+		return -1;
+
+	return snd_pcm_lib_free_pages(substream);
+}
+
+static struct snd_ml7213i2s_pcm *
+new_pcm_stream(struct snd_pcm_substream *substream)
+{
+	struct snd_ml7213i2s_pcm *dpcm;
+
+	dpcm = kzalloc(sizeof(*dpcm), GFP_KERNEL);
+	if (!dpcm)
+		return dpcm;
+	spin_lock_init(&dpcm->lock);
+	dpcm->substream = substream;
+	return dpcm;
+}
+
+static void i2s_read_period(struct snd_pcm_substream *substream)
+{
+	struct snd_ml7213i2s_pcm *dpcm;
+	struct cbdata *cbd;
+	int period;
+	void *read_ptr;
+	int read_size;
+
+	dpcm = substream->runtime->private_data;
+	cbd = &dpcm->cbd;
+
+	if (!cbd->priv)
+		return;
+
+	period = substream->runtime->period_size;
+
+	read_ptr = substream->runtime->dma_area
+	  +(snd_pcm_lib_period_bytes(substream) * dpcm->irq_pos);
+	read_size = period * I2S_1PERIODS_BYTES * (dpcm->channels);
+
+	ioh_i2s_read(cbd->priv,
+			 read_ptr,
+			 read_size,
+			 substream,
+			 read_done);
+
+	dpcm->irq_pos = (dpcm->irq_pos + 1) % substream->runtime->periods;
+}
+
+static void i2s_write_period(struct snd_pcm_substream *substream)
+{
+	struct snd_ml7213i2s_pcm *dpcm;
+	struct cbdata *cbd;
+	int period;
+	void *write_ptr;
+	int write_size;
+
+	dpcm = substream->runtime->private_data;
+	cbd = &dpcm->cbd;
+
+	if (!cbd->priv)
+		return;
+
+	period = substream->runtime->period_size;
+	write_ptr = substream->runtime->dma_area
+	  +(snd_pcm_lib_period_bytes(substream) * dpcm->irq_pos);
+	write_size = period * I2S_1PERIODS_BYTES * (dpcm->channels);
+
+	ioh_i2s_write(cbd->priv,
+			 write_ptr,
+			 write_size,
+			 substream,
+			 write_done);
+
+	dpcm->irq_pos = (dpcm->irq_pos + 1) % substream->runtime->periods;
+}
+
+static void read_done(void *callback_data, int status)
+{
+	struct snd_pcm_substream *substream =
+		(struct snd_pcm_substream *)callback_data;
+	struct snd_ml7213i2s_pcm *dpcm;
+	struct cbdata *cbd;
+	dpcm = substream->runtime->private_data;
+	cbd = &dpcm->cbd;
+	switch (status) {
+	case IOH_EOK:
+		if (!cbd->stop) {
+			i2s_read_period(substream);
+			dpcm->buf_pos = (dpcm->buf_pos + 1) %
+				substream->runtime->periods;
+			snd_pcm_period_elapsed(dpcm->substream);
+
+		}
+
+		cbd->cnt++;
+		break;
+	case IOH_EDONE:
+		pr_debug("Done stopping channel %d\n", cbd->stop);
+		cbd->stop = 2;
+		break;
+
+	case IOH_EOVERRUN:
+		if (ignore_overrun)
+			pr_debug("overrun ignore\n");
+		else {
+			pr_err("RX overrun\n");
+			cbd->stop = 2;
+		}
+		break;
+
+	case IOH_EFRAMESYNC:
+		pr_err("Frame sync error\n");
+		errors++;
+		cbd->stop = 2;
+		break;
+	}
+	if (cbd->stop)
+		pr_debug("stopping... %d\n", cbd->stop);
+}
+
+static void write_done(void *callback_data, int status)
+{
+	struct snd_pcm_substream *substream =
+		(struct snd_pcm_substream *)callback_data;
+	struct snd_ml7213i2s_pcm *dpcm;
+	struct cbdata *cbd;
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
+	dpcm = substream->runtime->private_data;
+	cbd = &dpcm->cbd;
+
+	switch (status) {
+	case IOH_EOK:
+		if (!cbd->stop) {
+			i2s_write_period(substream);
+			dpcm->buf_pos = (dpcm->buf_pos + 1) %
+				substream->runtime->periods;
+			snd_pcm_period_elapsed(dpcm->substream);
+		}
+		cbd->cnt++;
+		break;
+	case IOH_EDONE:
+		pr_debug("Done stopping channel %d\n", cbd->stop);
+		cbd->stop = 2;
+		break;
+	default:
+		pr_debug("%s:default(%d)\n", __func__, status);
+	break;
+	}
+}
+#define I2SCNTRX_RXDABIT_8BIT	0
+#define I2SCNTRX_RXDABIT_14BIT	BIT(8)
+#define I2SCNTRX_RXDABIT_16BIT	BIT(9)
+#define I2SCNTRX_RXDABIT_18BIT	(BIT(8) | BIT(9))
+#define I2SCNTRX_RXDABIT_20BIT	BIT(10)
+#define I2SCNTRX_RXDABIT_24BIT	(BIT(8) | BIT(10))
+
+#define I2SCNTTX_TXDABIT_8BIT	I2SCNTRX_RXDABIT_8BIT
+#define I2SCNTTX_TXDABIT_14BIT	I2SCNTRX_RXDABIT_14BIT
+#define I2SCNTTX_TXDABIT_16BIT	I2SCNTRX_RXDABIT_16BIT
+#define I2SCNTTX_TXDABIT_18BIT	I2SCNTRX_RXDABIT_18BIT
+#define I2SCNTTX_TXDABIT_20BIT	I2SCNTRX_RXDABIT_20BIT
+#define I2SCNTTX_TXDABIT_24BIT	I2SCNTRX_RXDABIT_24BIT
+
+#define I2SCLKCNT_MCLKFS_64FS	0
+#define I2SCLKCNT_MCLKFS_128FS	BIT(8)
+#define I2SCLKCNT_MCLKFS_192FS	BIT(9)
+#define I2SCLKCNT_MCLKFS_256FS	(BIT(8) | BIT(9))
+#define I2SCLKCNT_MCLKFS_384FS	BIT(10)
+#define I2SCLKCNT_MCLKFS_512FS	(BIT(8) | BIT(10))
+#define I2SCLKCNT_MCLKFS_768FS	(BIT(9) | BIT(10))
+#define I2SCLKCNT_MCLKFS_1024FS	(BIT(8) | BIT(9) | BIT(10))
+
+#define I2SCLKCNT_BCLKFS_8FS	0
+#define I2SCLKCNT_BCLKFS_16FS	BIT(12)
+#define I2SCLKCNT_BCLKFS_32FS	BIT(13)
+#define I2SCLKCNT_BCLKFS_64FS	(BIT(12) | BIT(13))
+
+#define I2SCLKCNT_MSSEL	BIT(0)
+
+static void i2s_set_default(struct ioh_i2s_config_reg *config)
+{
+	/* Set ML7213 IOH register default value */
+	config->cmn.i2simask = 0x003f003f;
+
+	config->tx.i2saftx = 0x1F;
+	config->tx.i2smsktx = 0x1F;
+	config->tx.i2sisttx = 0xC;
+
+	config->rx.i2scntrx = 0x3F;
+	config->rx.i2smskrx = 0x1F;
+	config->rx.i2sistrx = 0xC;
+}
+
+
+static int i2s_configure_rate(unsigned int rate)
+{
+	int value;
+
+	switch (rate) {
+	/* LR=12288/MCLKFS, BCLKFS=channels*format */
+	case 16000:
+		value = I2SCLKCNT_MCLKFS_768FS | I2SCLKCNT_BCLKFS_32FS;
+		break;
+	case 32000:
+		value = I2SCLKCNT_MCLKFS_384FS | I2SCLKCNT_BCLKFS_32FS;
+		break;
+	case 48000:
+		value = I2SCLKCNT_MCLKFS_256FS | I2SCLKCNT_BCLKFS_32FS;
+		break;
+	default:
+		value = I2SCLKCNT_MCLKFS_256FS | I2SCLKCNT_BCLKFS_32FS;
+		break;
+	}
+	return value;
+}
+
+static void i2s_slave_configure_reg(struct ioh_i2s_config_reg *config,
+				    unsigned int rate)
+{
+	memset(config, 0, sizeof(*config));
+
+	i2s_set_default(config);
+
+	/* Configuration */
+	config->tx.i2scnttx = I2SCNTTX_TXDABIT_16BIT;
+	config->tx.i2saetx = I2S_AEMPTY_THRESH / 2; /* Almost empty threshold */
+	config->rx.i2scntrx = I2SCNTRX_RXDABIT_16BIT;
+	config->rx.i2safrx = I2S_AFULL_THRESH / 2; /* Almost full threshold */
+	config->cmn.i2sclkcnt = i2s_configure_rate(rate);
+}
+
+static void i2s_master_configure_reg(struct ioh_i2s_config_reg *config,
+				     unsigned int rate)
+{
+	memset(config, 0, sizeof(*config));
+
+	i2s_set_default(config);
+
+	/* Configuration */
+	config->tx.i2scnttx = I2SCNTTX_TXDABIT_16BIT;
+	config->tx.i2saetx = I2S_AEMPTY_THRESH / 2; /* Almost empty threshold */
+	config->rx.i2scntrx = I2SCNTRX_RXDABIT_16BIT;
+	config->rx.i2safrx = I2S_AFULL_THRESH / 2; /* Almost full threshold */
+	config->cmn.i2sclkcnt = i2s_configure_rate(rate) | I2SCLKCNT_MSSEL;
+}
+
+static void setup_i2s_read(struct snd_pcm_substream *substream, int ch)
+{
+	struct snd_ml7213i2s_pcm *dpcm;
+	struct ioh_i2s_config_reg config;
+
+	dpcm = substream->runtime->private_data;
+
+	dpcm->cbd.priv = ioh_i2s_open(ch, IOH_CAPTURE, "radio-i2s-in",
+					 substream,
+					 read_done);
+
+	if (!dpcm->cbd.priv) {
+		pr_err("%s: Cannot open the device\n", __func__);
+		return;
+	}
+
+	if (ignore_overrun)
+		ioh_i2s_ignore_rx_overrun(dpcm->cbd.priv);
+
+	if (I2S_READ_MASTER)
+		i2s_master_configure_reg(&config, dpcm->rate);
+	else
+		i2s_slave_configure_reg(&config, dpcm->rate);
+
+	ioh_i2s_configure_i2s_regs(dpcm->cbd.priv, 0, &config, IOH_CAPTURE);
+}
+
+static void setup_i2s_write(struct snd_pcm_substream *substream, int ch)
+{
+	struct snd_ml7213i2s_pcm *dpcm;
+	struct ioh_i2s_config_reg config;
+
+	dpcm = substream->runtime->private_data;
+
+	dpcm->cbd.priv = ioh_i2s_open(ch, IOH_PLAYBACK, "radio-i2s-out",
+					 substream,
+					 write_done);
+
+	if (!dpcm->cbd.priv) {
+		pr_err("%s: Cannot open the device\n", __func__);
+		return;
+	}
+
+	if (ignore_overrun)
+		ioh_i2s_ignore_rx_overrun(dpcm->cbd.priv);
+
+	if (I2S_WRITE_MASTER)
+		i2s_master_configure_reg(&config, dpcm->rate);
+	else
+		i2s_slave_configure_reg(&config, dpcm->rate);
+
+	ioh_i2s_configure_i2s_regs(dpcm->cbd.priv, 0, &config, IOH_PLAYBACK);
+}
+
+static int snd_card_ml7213i2s_capture_open(struct snd_pcm_substream *substream)
+{
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	struct snd_ml7213i2s_pcm *dpcm;
+	int err;
+
+	dpcm = new_pcm_stream(substream);
+	if (dpcm == NULL)
+		return -ENOMEM;
+
+	runtime->private_data = dpcm;
+	/* makes the infrastructure responsible for freeing dpcm */
+	runtime->private_free = snd_card_ml7213i2s_runtime_capture_free;
+	runtime->hw = snd_card_ml7213i2s_capture;
+
+	dpcm->rw = SND_CAPTURE_SUBSTREAM;
+
+	err = add_capture_constraints(runtime);
+	if (err < 0)
+		return err;
+
+	return 0;
+}
+
+static int snd_card_ml7213i2s_playback_open(struct snd_pcm_substream *substream)
+{
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	struct snd_ml7213i2s_pcm *dpcm;
+	int err;
+
+	dpcm = new_pcm_stream(substream);
+	if (dpcm == NULL)
+		return -ENOMEM;
+
+	runtime->private_data = dpcm;
+	/* makes the infrastructure responsible for freeing dpcm */
+	runtime->private_free = snd_card_ml7213i2s_runtime_playback_free;
+	runtime->hw = snd_card_ml7213i2s_capture;
+
+	dpcm->rw = SND_PLAYBACK_SUBSTREAM;
+
+	err = add_capture_constraints(runtime);
+	if (err < 0)
+		return err;
+
+	return 0;
+}
+
+static int snd_card_ml7213i2s_capture_close(
+	struct snd_pcm_substream *substream)
+{
+	return 0;
+}
+
+static int snd_card_ml7213i2s_playback_close(
+	struct snd_pcm_substream *substream)
+{
+	return 0;
+}
+
+static struct snd_pcm_ops snd_card_ml7213i2s_capture_ops = {
+	.open =			snd_card_ml7213i2s_capture_open,
+	.close =		snd_card_ml7213i2s_capture_close,
+	.ioctl =		snd_pcm_lib_ioctl,
+	.hw_params =		snd_card_ml7213i2s_hw_params,
+	.hw_free =		snd_card_ml7213i2s_hw_free,
+	.prepare =		snd_card_ml7213i2s_pcm_prepare,
+	.trigger =		snd_card_ml7213i2s_pcm_capture_trigger,
+	.pointer =		snd_card_ml7213i2s_pcm_pointer,
+};
+
+static struct snd_pcm_ops snd_card_ml7213i2s_playback_ops = {
+	.open =			snd_card_ml7213i2s_playback_open,
+	.close =		snd_card_ml7213i2s_playback_close,
+	.ioctl =		snd_pcm_lib_ioctl,
+	.hw_params =		snd_card_ml7213i2s_hw_params,
+	.hw_free =		snd_card_ml7213i2s_hw_free,
+	.prepare =		snd_card_ml7213i2s_pcm_prepare,
+	.trigger =		snd_card_ml7213i2s_pcm_playback_trigger,
+	.pointer =		snd_card_ml7213i2s_pcm_pointer,
+};
+
+static int __devinit snd_card_ml7213i2s_pcm(struct snd_ml7213i2s *ml7213i2s,
+					     int device)
+{
+	struct snd_pcm *pcm;
+	int err;
+
+	/* The number of I2S interface is (Rx + Tx) x 6CH */
+	err = snd_pcm_new(ml7213i2s->card, "ml7213i2s PCM", device,
+			       MAX_I2S_TX_CH, MAX_I2S_RX_CH, &pcm);
+	if (err < 0)
+		return err;
+	ml7213i2s->pcm = pcm;
+	snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_CAPTURE,
+			&snd_card_ml7213i2s_capture_ops);
+	snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_PLAYBACK,
+			&snd_card_ml7213i2s_playback_ops);
+	pcm->private_data = ml7213i2s;
+	pcm->info_flags = 0;
+	strcpy(pcm->name, "ml7213i2s PCM");
+
+	snd_pcm_lib_preallocate_pages_for_all(
+		pcm, SNDRV_DMA_TYPE_CONTINUOUS,
+		snd_dma_continuous_data(GFP_KERNEL),
+		0, 64*1024);
+	return 0;
+}
+
+static struct snd_device_ops ops = {NULL};
+
+static int __devinit snd_ml7213i2s_probe(struct platform_device *devptr)
+{
+	struct snd_card *card;
+	struct snd_ml7213i2s *ml7213i2s;
+	int err;
+	int dev = devptr->id;
+
+	err = snd_card_create(index, "ml7213i2s", THIS_MODULE,
+			      sizeof(struct snd_ml7213i2s), &card);
+
+	if (err < 0)
+		return err;
+	ml7213i2s = card->private_data;
+	ml7213i2s->card = card;
+	err = snd_card_ml7213i2s_pcm(ml7213i2s, 0);
+	if (err < 0)
+		goto __nodev;
+
+	strcpy(card->driver, "ml7213i2s");
+	strcpy(card->shortname, "ml7213i2s");
+	sprintf(card->longname, "ml7213i2s %i", dev + 1);
+
+	snd_card_set_dev(card, &devptr->dev);
+
+	snd_device_new(card, SNDRV_DEV_LOWLEVEL, ml7213i2s, &ops);
+
+	mutex_init(&i2c_mutex);
+
+	err = snd_card_register(card);
+	if (err == 0) {
+		platform_set_drvdata(devptr, card);
+		return 0;
+	}
+__nodev:
+	snd_card_free(card);
+	return err;
+}
+
+static int __devexit snd_ml7213i2s_remove(struct platform_device *devptr)
+{
+	snd_card_free(platform_get_drvdata(devptr));
+	platform_set_drvdata(devptr, NULL);
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int snd_ml7213i2s_suspend(struct platform_device *pdev,
+				  pm_message_t state)
+{
+	struct snd_card *card = platform_get_drvdata(pdev);
+	struct snd_ml7213i2s *ml7213i2s = card->private_data;
+
+	snd_power_change_state(card, SNDRV_CTL_POWER_D3hot);
+	snd_pcm_suspend_all(ml7213i2s->pcm);
+	return 0;
+}
+
+static int snd_ml7213i2s_resume(struct platform_device *pdev)
+{
+	struct snd_card *card = platform_get_drvdata(pdev);
+
+	snd_power_change_state(card, SNDRV_CTL_POWER_D0);
+	return 0;
+}
+#endif
+
+
+#define snd_ml7213i2s_DRIVER	"snd_ml7213i2s"
+
+static struct platform_driver snd_ml7213i2s_driver = {
+	.probe		= snd_ml7213i2s_probe,
+	.remove		= __devexit_p(snd_ml7213i2s_remove),
+#ifdef CONFIG_PM
+	.suspend	= snd_ml7213i2s_suspend,
+	.resume		= snd_ml7213i2s_resume,
+#endif
+	.driver		= {
+		.name	= snd_ml7213i2s_DRIVER
+	},
+};
+
+static void snd_ml7213i2s_unregister(void)
+{
+	platform_device_unregister(_device);
+	platform_driver_unregister(&snd_ml7213i2s_driver);
+}
+
+static int __init alsa_card_ml7213i2s_init(void)
+{
+	int  err;
+	struct platform_device *device;
+
+	err = platform_driver_register(&snd_ml7213i2s_driver);
+	if (err < 0)
+		return err;
+
+	device = platform_device_register_simple(snd_ml7213i2s_DRIVER,
+						 0, NULL, 0);
+	if (IS_ERR(device))
+		return -1;
+	if (!platform_get_drvdata(device)) {
+		platform_device_unregister(device);
+		return -1;
+	}
+	_device = device;
+
+	return 0;
+}
+
+static void __exit alsa_card_ml7213i2s_exit(void)
+{
+	snd_ml7213i2s_unregister();
+}
+
+module_init(alsa_card_ml7213i2s_init)
+module_exit(alsa_card_ml7213i2s_exit)
-- 
1.7.4

