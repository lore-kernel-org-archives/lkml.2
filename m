Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754318Ab2BCQL0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 11:11:26 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40529 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631Ab2BCQLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 11:11:25 -0500
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-kernel@vger.kernel.org
Cc: dan.j.williams@intel.com, vinod.koul@intel.com,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        kernel@pengutronix.de, Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH 1/2] i.MX DMA: Add support for 2D transfers.
Date: Fri,  3 Feb 2012 17:11:13 +0100
Message-Id: <1328285474-26365-1-git-send-email-javier.martin@vista-silicon.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DMAC present in i.MX2 and i.MX1 chips have two
2D configuration slots that any DMA channel can
use to make 2D DMA transfers.

Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 arch/arm/mach-imx/dma-v1.c              |   86 +++++++++++++++++++++++++++++++
 arch/arm/mach-imx/include/mach/dma-v1.h |    7 +++
 2 files changed, 93 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-imx/dma-v1.c b/arch/arm/mach-imx/dma-v1.c
index 42afc29..7401138 100644
--- a/arch/arm/mach-imx/dma-v1.c
+++ b/arch/arm/mach-imx/dma-v1.c
@@ -121,6 +121,9 @@ struct imx_dma_channel {
 
 	int in_use;
 
+	bool enabled_2d;
+	int slot_2d;
+
 	u32 ccr_from_device;
 	u32 ccr_to_device;
 
@@ -129,6 +132,13 @@ struct imx_dma_channel {
 	int hw_chaining;
 };
 
+struct imx_dma_2d_config {
+	u16		xsr;
+	u16		ysr;
+	u16		wsr;
+	int		count;
+};
+
 static void __iomem *imx_dmav1_baseaddr;
 
 static void imx_dmav1_writel(unsigned val, unsigned offset)
@@ -143,6 +153,9 @@ static unsigned imx_dmav1_readl(unsigned offset)
 
 static struct imx_dma_channel imx_dma_channels[IMX_DMA_CHANNELS];
 
+static struct imx_dma_2d_config imx_dma_2d_slots[IMX_DMA_2D_SLOTS];
+static spinlock_t lock_2d;
+
 static struct clk *dma_clk;
 
 static int imx_dma_hw_chain(struct imx_dma_channel *imxdma)
@@ -369,6 +382,11 @@ imx_dma_config_channel(int channel, unsigned int config_port,
 	imxdma->ccr_from_device = config_port | (config_mem << 2) | dreq;
 	imxdma->ccr_to_device = config_mem | (config_port << 2) | dreq;
 
+	if (imxdma->enabled_2d && (imxdma->slot_2d == IMX_DMA_2D_SLOT_B)) {
+		imxdma->ccr_from_device |= CCR_MSEL_B;
+		imxdma->ccr_to_device |= CCR_MSEL_B;
+	}
+
 	imx_dmav1_writel(dmareq, DMA_RSSR(channel));
 
 	return 0;
@@ -382,6 +400,63 @@ void imx_dma_config_burstlen(int channel, unsigned int burstlen)
 EXPORT_SYMBOL(imx_dma_config_burstlen);
 
 /**
+ * imx_dma_config_2d - prepare i.MX DMA channel for a 2D transfer.
+ * @channel: i.MX DMA channel number
+ * @x: x-size of the 2D window.
+ * @y: number of rows that make up the 2D window.
+ * @w: display size of the 2D window
+ */
+int imx_dma_config_2d(int channel, unsigned int x, unsigned int y,
+		      unsigned int w)
+{
+	struct imx_dma_channel *imxdma = &imx_dma_channels[channel];
+	int slot = -1;
+	int i;
+
+	spin_lock(&lock_2d);
+	/* If the channel already owns a slot, free it first */
+	if (imxdma->enabled_2d) {
+		imx_dma_2d_slots[imxdma->slot_2d].count--;
+		imxdma->enabled_2d = false;
+	}
+	/* Try to get free 2D slot */
+	for (i = 0; i < IMX_DMA_2D_SLOTS; i++) {
+		if ((imx_dma_2d_slots[i].count > 0) &&
+		    ((imx_dma_2d_slots[i].xsr != x) ||
+		     (imx_dma_2d_slots[i].ysr != y) ||
+		     (imx_dma_2d_slots[i].wsr != w)))
+			continue;
+		slot = i;
+		break;
+	}
+	if (slot < 0)
+		return -EBUSY;
+
+	imx_dma_2d_slots[slot].xsr = x;
+	imx_dma_2d_slots[slot].ysr = y;
+	imx_dma_2d_slots[slot].wsr = w;
+	imx_dma_2d_slots[slot].count++;
+
+	spin_unlock(&lock_2d);
+
+	imxdma->slot_2d = slot;
+	imxdma->enabled_2d = true;
+
+	if (slot == IMX_DMA_2D_SLOT_A) {
+		imx_dmav1_writel(x, DMA_XSRA);
+		imx_dmav1_writel(y, DMA_YSRA);
+		imx_dmav1_writel(w, DMA_WSRA);
+	} else {
+		imx_dmav1_writel(x, DMA_XSRB);
+		imx_dmav1_writel(y, DMA_YSRB);
+		imx_dmav1_writel(w, DMA_WSRB);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(imx_dma_config_2d);
+
+/**
  * imx_dma_setup_handlers - setup i.MX DMA channel end and error notification
  * handlers
  * @channel: i.MX DMA channel number
@@ -732,6 +807,13 @@ void imx_dma_free(int channel)
 		return;
 	}
 
+	spin_lock(&lock_2d);
+	if (imxdma->enabled_2d) {
+		imx_dma_2d_slots[imxdma->slot_2d].count--;
+		imxdma->enabled_2d = false;
+	}
+	spin_unlock(&lock_2d);
+
 	local_irq_save(flags);
 	/* Disable interrupts */
 	imx_dma_disable(channel);
@@ -840,6 +922,10 @@ static int __init imx_dma_init(void)
 		imx_dma_channels[i].dma_num = i;
 	}
 
+	for (i = 0; i < IMX_DMA_2D_SLOTS; i++)
+		imx_dma_2d_slots[i].count = 0;
+	spin_lock_init(&lock_2d);
+
 	return ret;
 }
 
diff --git a/arch/arm/mach-imx/include/mach/dma-v1.h b/arch/arm/mach-imx/include/mach/dma-v1.h
index ac6fd71..bab9183 100644
--- a/arch/arm/mach-imx/include/mach/dma-v1.h
+++ b/arch/arm/mach-imx/include/mach/dma-v1.h
@@ -30,6 +30,10 @@
 #include <mach/dma.h>
 
 #define IMX_DMA_CHANNELS  16
+#define IMX_DMA_2D_SLOTS   2
+
+#define IMX_DMA_2D_SLOT_A  0
+#define IMX_DMA_2D_SLOT_B  1
 
 #define DMA_MODE_READ		0
 #define DMA_MODE_WRITE		1
@@ -64,6 +68,9 @@ void
 imx_dma_config_burstlen(int channel, unsigned int burstlen);
 
 int
+imx_dma_config_2d(int channel, unsigned int x, unsigned int y, unsigned int w);
+
+int
 imx_dma_setup_single(int channel, dma_addr_t dma_address,
 		unsigned int dma_length, unsigned int dev_addr,
 		unsigned int dmamode);
-- 
1.7.0.4

