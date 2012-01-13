Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757498Ab2AMDLE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 22:11:04 -0500
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:39370
	"EHLO DB3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757277Ab2AMDK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 22:10:28 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275dhz2dhc1ahc1bh87h2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Richard Zhao <richard.zhao@linaro.org>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
CC: <dan.j.williams@intel.com>, <vinod.koul@intel.com>, <shawn.guo@linaro.org>,
        <kernel@pengutronix.de>, <eric.miao@linaro.org>, <patches@linaro.org>,
        Richard Zhao <richard.zhao@linaro.org>
Subject: [PATCH v2 6/6] dma/imx-sdma: convernt to use bit ops
Date: Fri, 13 Jan 2012 11:10:01 +0800
Message-ID: <1326424201-20056-7-git-send-email-richard.zhao@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1326424201-20056-1-git-send-email-richard.zhao@linaro.org>
References: <1326424201-20056-1-git-send-email-richard.zhao@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need extra lock, so we use non-atomic bit ops to set/clear bits,

merge event_mask0 and event_mask1 into an array, it helps use bit ops.

It also fixs the issue:

sdmac->event_mask0 = 1 << sdmac->event_id0;
sdmac->event_mask1 = 1 << (sdmac->event_id0 - 32);

It event_id0 < 32, it shifts negative number. If event_id0 >= 32, it
shifts number >= sizeof(int). Both the cases behavior is undefined.

Signed-off-by: Richard Zhao <richard.zhao@linaro.org>
---
 drivers/dma/imx-sdma.c |   68 ++++++++++++++++++++++++------------------------
 1 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index 22fd561..984c0f7 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -20,6 +20,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/types.h>
+#include <linux/bitops.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
 #include <linux/clk.h>
@@ -260,8 +261,8 @@ struct sdma_channel {
 	unsigned int			pc_from_device, pc_to_device;
 	unsigned long			flags;
 	dma_addr_t			per_address;
-	u32				event_mask0, event_mask1;
-	u32				watermark_level;
+	unsigned long			event_mask[2];
+	unsigned long			watermark_level;
 	u32				shp_addr, per_addr;
 	struct dma_chan			chan;
 	spinlock_t			lock;
@@ -272,7 +273,7 @@ struct sdma_channel {
 	unsigned int			chn_real_count;
 };
 
-#define IMX_DMA_SG_LOOP		(1 << 0)
+#define IMX_DMA_SG_LOOP		BIT(0)
 
 #define MAX_DMA_CHANNELS 32
 #define MXC_SDMA_DEFAULT_PRIORITY 1
@@ -346,9 +347,9 @@ static const struct of_device_id sdma_dt_ids[] = {
 };
 MODULE_DEVICE_TABLE(of, sdma_dt_ids);
 
-#define SDMA_H_CONFIG_DSPDMA	(1 << 12) /* indicates if the DSPDMA is used */
-#define SDMA_H_CONFIG_RTD_PINS	(1 << 11) /* indicates if Real-Time Debug pins are enabled */
-#define SDMA_H_CONFIG_ACR	(1 << 4)  /* indicates if AHB freq /core freq = 2 or 1 */
+#define SDMA_H_CONFIG_DSPDMA	BIT(12) /* indicates if the DSPDMA is used */
+#define SDMA_H_CONFIG_RTD_PINS	BIT(11) /* indicates if Real-Time Debug pins are enabled */
+#define SDMA_H_CONFIG_ACR	BIT(4)  /* indicates if AHB freq /core freq = 2 or 1 */
 #define SDMA_H_CONFIG_CSM	(3)       /* indicates which context switch mode is selected*/
 
 static inline u32 chnenbl_ofs(struct sdma_engine *sdma, unsigned int event)
@@ -363,7 +364,7 @@ static int sdma_config_ownership(struct sdma_channel *sdmac,
 {
 	struct sdma_engine *sdma = sdmac->sdma;
 	int channel = sdmac->channel;
-	u32 evt, mcu, dsp;
+	unsigned long evt, mcu, dsp;
 
 	if (event_override && mcu_override && dsp_override)
 		return -EINVAL;
@@ -373,19 +374,19 @@ static int sdma_config_ownership(struct sdma_channel *sdmac,
 	dsp = readl_relaxed(sdma->regs + SDMA_H_DSPOVR);
 
 	if (dsp_override)
-		dsp &= ~(1 << channel);
+		__clear_bit(channel, &dsp);
 	else
-		dsp |= (1 << channel);
+		__set_bit(channel, &dsp);
 
 	if (event_override)
-		evt &= ~(1 << channel);
+		__clear_bit(channel, &evt);
 	else
-		evt |= (1 << channel);
+		__set_bit(channel, &evt);
 
 	if (mcu_override)
-		mcu &= ~(1 << channel);
+		__clear_bit(channel, &mcu);
 	else
-		mcu |= (1 << channel);
+		__set_bit(channel, &mcu);
 
 	writel_relaxed(evt, sdma->regs + SDMA_H_EVTOVR);
 	writel_relaxed(mcu, sdma->regs + SDMA_H_HOSTOVR);
@@ -396,7 +397,7 @@ static int sdma_config_ownership(struct sdma_channel *sdmac,
 
 static void sdma_enable_channel(struct sdma_engine *sdma, int channel)
 {
-	writel(1 << channel, sdma->regs + SDMA_H_START);
+	writel(BIT(channel), sdma->regs + SDMA_H_START);
 }
 
 /*
@@ -457,11 +458,11 @@ static void sdma_event_enable(struct sdma_channel *sdmac, unsigned int event)
 {
 	struct sdma_engine *sdma = sdmac->sdma;
 	int channel = sdmac->channel;
-	u32 val;
+	unsigned long val;
 	u32 chnenbl = chnenbl_ofs(sdma, event);
 
 	val = readl_relaxed(sdma->regs + chnenbl);
-	val |= (1 << channel);
+	__set_bit(channel, &val);
 	writel_relaxed(val, sdma->regs + chnenbl);
 }
 
@@ -470,10 +471,10 @@ static void sdma_event_disable(struct sdma_channel *sdmac, unsigned int event)
 	struct sdma_engine *sdma = sdmac->sdma;
 	int channel = sdmac->channel;
 	u32 chnenbl = chnenbl_ofs(sdma, event);
-	u32 val;
+	unsigned long val;
 
 	val = readl_relaxed(sdma->regs + chnenbl);
-	val &= ~(1 << channel);
+	__clear_bit(channel, &val);
 	writel_relaxed(val, sdma->regs + chnenbl);
 }
 
@@ -550,7 +551,7 @@ static void mxc_sdma_handle_channel(struct sdma_channel *sdmac)
 static irqreturn_t sdma_int_handler(int irq, void *dev_id)
 {
 	struct sdma_engine *sdma = dev_id;
-	u32 stat;
+	unsigned long stat;
 
 	stat = readl_relaxed(sdma->regs + SDMA_H_INTR);
 	writel_relaxed(stat, sdma->regs + SDMA_H_INTR);
@@ -561,7 +562,7 @@ static irqreturn_t sdma_int_handler(int irq, void *dev_id)
 
 		mxc_sdma_handle_channel(sdmac);
 
-		stat &= ~(1 << channel);
+		__clear_bit(channel, &stat);
 	}
 
 	return IRQ_HANDLED;
@@ -669,11 +670,11 @@ static int sdma_load_context(struct sdma_channel *sdmac)
 		return load_address;
 
 	dev_dbg(sdma->dev, "load_address = %d\n", load_address);
-	dev_dbg(sdma->dev, "wml = 0x%08x\n", sdmac->watermark_level);
+	dev_dbg(sdma->dev, "wml = 0x%08x\n", (u32)sdmac->watermark_level);
 	dev_dbg(sdma->dev, "shp_addr = 0x%08x\n", sdmac->shp_addr);
 	dev_dbg(sdma->dev, "per_addr = 0x%08x\n", sdmac->per_addr);
-	dev_dbg(sdma->dev, "event_mask0 = 0x%08x\n", sdmac->event_mask0);
-	dev_dbg(sdma->dev, "event_mask1 = 0x%08x\n", sdmac->event_mask1);
+	dev_dbg(sdma->dev, "event_mask0 = 0x%08x\n", (u32)sdmac->event_mask[0]);
+	dev_dbg(sdma->dev, "event_mask1 = 0x%08x\n", (u32)sdmac->event_mask[1]);
 
 	mutex_lock(&sdma->channel_0_lock);
 
@@ -683,8 +684,8 @@ static int sdma_load_context(struct sdma_channel *sdmac)
 	/* Send by context the event mask,base address for peripheral
 	 * and watermark level
 	 */
-	context->gReg[0] = sdmac->event_mask1;
-	context->gReg[1] = sdmac->event_mask0;
+	context->gReg[0] = sdmac->event_mask[1];
+	context->gReg[1] = sdmac->event_mask[0];
 	context->gReg[2] = sdmac->per_addr;
 	context->gReg[6] = sdmac->shp_addr;
 	context->gReg[7] = sdmac->watermark_level;
@@ -707,7 +708,7 @@ static void sdma_disable_channel(struct sdma_channel *sdmac)
 	struct sdma_engine *sdma = sdmac->sdma;
 	int channel = sdmac->channel;
 
-	writel_relaxed(1 << channel, sdma->regs + SDMA_H_STATSTOP);
+	writel_relaxed(BIT(channel), sdma->regs + SDMA_H_STATSTOP);
 	sdmac->status = DMA_ERROR;
 }
 
@@ -717,8 +718,8 @@ static int sdma_config_channel(struct sdma_channel *sdmac)
 
 	sdma_disable_channel(sdmac);
 
-	sdmac->event_mask0 = 0;
-	sdmac->event_mask1 = 0;
+	sdmac->event_mask[0] = 0;
+	sdmac->event_mask[1] = 0;
 	sdmac->shp_addr = 0;
 	sdmac->per_addr = 0;
 
@@ -746,15 +747,14 @@ static int sdma_config_channel(struct sdma_channel *sdmac)
 			(sdmac->peripheral_type != IMX_DMATYPE_DSP)) {
 		/* Handle multiple event channels differently */
 		if (sdmac->event_id1) {
-			sdmac->event_mask1 = 1 << (sdmac->event_id1 % 32);
+			sdmac->event_mask[1] = BIT(sdmac->event_id1 % 32);
 			if (sdmac->event_id1 > 31)
-				sdmac->watermark_level |= 1 << 31;
-			sdmac->event_mask0 = 1 << (sdmac->event_id0 % 32);
+				__set_bit(31, &sdmac->watermark_level);
+			sdmac->event_mask[0] = BIT(sdmac->event_id0 % 32);
 			if (sdmac->event_id0 > 31)
-				sdmac->watermark_level |= 1 << 30;
+				__set_bit(30, &sdmac->watermark_level);
 		} else {
-			sdmac->event_mask0 = 1 << sdmac->event_id0;
-			sdmac->event_mask1 = 1 << (sdmac->event_id0 - 32);
+			__set_bit(sdmac->event_id0, sdmac->event_mask);
 		}
 		/* Watermark Level */
 		sdmac->watermark_level |= sdmac->watermark_level;
-- 
1.7.5.4


