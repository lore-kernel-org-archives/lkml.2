Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758854Ab2EJKS4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 06:18:56 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:51523 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758822Ab2EJKSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 06:18:49 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <vinod.koul@linux.intel.com>
CC: <linux-arm-kernel@lists.infradead.org>, <plagnioj@jcrosoft.com>,
        <linux-kernel@vger.kernel.org>, <ludovic.desroches@atmel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 3/3] dmaengine: at_hdmac: take maxburst from slave configuration
Date: Thu, 10 May 2012 12:17:41 +0200
Message-ID: <4e7b718aecc03b0c2bbde75bb6fc5464a9e38115.1336644470.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1336644470.git.nicolas.ferre@atmel.com>
References: <cover.1336644470.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.159.245.203]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The maxburst/chunk size was taken from the private slave DMA data structure.
Use the common API provided by DMA_SLAVE_CONFIG to setup src/dst maxburst
values.
The ctrla field is not needed anymore in the slave private structure nor the
header constants that were located in an architecture specific directory.
The at91sam9g45_devices.c file that was using this platform data is also
modified to remove this now useless data.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/at91sam9g45_devices.c   |    1 -
 arch/arm/mach-at91/include/mach/at_hdmac.h |   21 ---------------------
 drivers/dma/at_hdmac.c                     |    7 ++++---
 drivers/dma/at_hdmac_regs.h                |   21 ++++++++++++++++++++-
 4 files changed, 24 insertions(+), 26 deletions(-)

diff --git a/arch/arm/mach-at91/at91sam9g45_devices.c b/arch/arm/mach-at91/at91sam9g45_devices.c
index 6b008ae..b3d2e19 100644
--- a/arch/arm/mach-at91/at91sam9g45_devices.c
+++ b/arch/arm/mach-at91/at91sam9g45_devices.c
@@ -441,7 +441,6 @@ void __init at91_add_device_mci(short mmc_id, struct mci_platform_data *data)
 	atslave->dma_dev = &at_hdmac_device.dev;
 	atslave->cfg = ATC_FIFOCFG_HALFFIFO
 			| ATC_SRC_H2SEL_HW | ATC_DST_H2SEL_HW;
-	atslave->ctrla = ATC_SCSIZE_16 | ATC_DCSIZE_16;
 	if (mmc_id == 0)	/* MCI0 */
 		atslave->cfg |= ATC_SRC_PER(AT_DMA_ID_MCI0)
 			      | ATC_DST_PER(AT_DMA_ID_MCI0);
diff --git a/arch/arm/mach-at91/include/mach/at_hdmac.h b/arch/arm/mach-at91/include/mach/at_hdmac.h
index 810a13e..cab0997 100644
--- a/arch/arm/mach-at91/include/mach/at_hdmac.h
+++ b/arch/arm/mach-at91/include/mach/at_hdmac.h
@@ -27,12 +27,10 @@ struct at_dma_platform_data {
  * struct at_dma_slave - Controller-specific information about a slave
  * @dma_dev: required DMA master device
  * @cfg: Platform-specific initializer for the CFG register
- * @ctrla: Platform-specific initializer for the CTRLA register
  */
 struct at_dma_slave {
 	struct device		*dma_dev;
 	u32			cfg;
-	u32			ctrla;
 };
 
 
@@ -59,24 +57,5 @@ struct at_dma_slave {
 #define		ATC_FIFOCFG_HALFFIFO		(0x1 << 28)
 #define		ATC_FIFOCFG_ENOUGHSPACE		(0x2 << 28)
 
-/* Platform-configurable bits in CTRLA */
-#define	ATC_SCSIZE_MASK		(0x7 << 16)	/* Source Chunk Transfer Size */
-#define		ATC_SCSIZE_1		(0x0 << 16)
-#define		ATC_SCSIZE_4		(0x1 << 16)
-#define		ATC_SCSIZE_8		(0x2 << 16)
-#define		ATC_SCSIZE_16		(0x3 << 16)
-#define		ATC_SCSIZE_32		(0x4 << 16)
-#define		ATC_SCSIZE_64		(0x5 << 16)
-#define		ATC_SCSIZE_128		(0x6 << 16)
-#define		ATC_SCSIZE_256		(0x7 << 16)
-#define	ATC_DCSIZE_MASK		(0x7 << 20)	/* Destination Chunk Transfer Size */
-#define		ATC_DCSIZE_1		(0x0 << 20)
-#define		ATC_DCSIZE_4		(0x1 << 20)
-#define		ATC_DCSIZE_8		(0x2 << 20)
-#define		ATC_DCSIZE_16		(0x3 << 20)
-#define		ATC_DCSIZE_32		(0x4 << 20)
-#define		ATC_DCSIZE_64		(0x5 << 20)
-#define		ATC_DCSIZE_128		(0x6 << 20)
-#define		ATC_DCSIZE_256		(0x7 << 20)
 
 #endif /* AT_HDMAC_H */
diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index b3f7cbd..07eda80 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -664,7 +664,8 @@ atc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 		return NULL;
 	}
 
-	ctrla = atslave->ctrla;
+	ctrla =   ATC_SCSIZE(sconfig->src_maxburst)
+		| ATC_DCSIZE(sconfig->dst_maxburst);
 	ctrlb = ATC_IEN;
 
 	switch (direction) {
@@ -792,12 +793,12 @@ atc_dma_cyclic_fill_desc(struct dma_chan *chan, struct at_desc *desc,
 		enum dma_transfer_direction direction)
 {
 	struct at_dma_chan	*atchan = to_at_dma_chan(chan);
-	struct at_dma_slave	*atslave = chan->private;
 	struct dma_slave_config	*sconfig = &atchan->dma_sconfig;
 	u32			ctrla;
 
 	/* prepare common CRTLA value */
-	ctrla = atslave->ctrla
+	ctrla =   ATC_SCSIZE(sconfig->src_maxburst)
+		| ATC_DCSIZE(sconfig->dst_maxburst)
 		| ATC_DST_WIDTH(reg_width)
 		| ATC_SRC_WIDTH(reg_width)
 		| period_len >> reg_width;
diff --git a/drivers/dma/at_hdmac_regs.h b/drivers/dma/at_hdmac_regs.h
index 897a8bc..8a6c8e8 100644
--- a/drivers/dma/at_hdmac_regs.h
+++ b/drivers/dma/at_hdmac_regs.h
@@ -87,7 +87,26 @@
 /* Bitfields in CTRLA */
 #define	ATC_BTSIZE_MAX		0xFFFFUL	/* Maximum Buffer Transfer Size */
 #define	ATC_BTSIZE(x)		(ATC_BTSIZE_MAX & (x)) /* Buffer Transfer Size */
-/* Chunck Tranfer size definitions are in at_hdmac.h */
+#define	ATC_SCSIZE_MASK		(0x7 << 16)	/* Source Chunk Transfer Size */
+#define		ATC_SCSIZE(x)		(ATC_SCSIZE_MASK & ((x) << 16))
+#define		ATC_SCSIZE_1		(0x0 << 16)
+#define		ATC_SCSIZE_4		(0x1 << 16)
+#define		ATC_SCSIZE_8		(0x2 << 16)
+#define		ATC_SCSIZE_16		(0x3 << 16)
+#define		ATC_SCSIZE_32		(0x4 << 16)
+#define		ATC_SCSIZE_64		(0x5 << 16)
+#define		ATC_SCSIZE_128		(0x6 << 16)
+#define		ATC_SCSIZE_256		(0x7 << 16)
+#define	ATC_DCSIZE_MASK		(0x7 << 20)	/* Destination Chunk Transfer Size */
+#define		ATC_DCSIZE(x)		(ATC_DCSIZE_MASK & ((x) << 20))
+#define		ATC_DCSIZE_1		(0x0 << 20)
+#define		ATC_DCSIZE_4		(0x1 << 20)
+#define		ATC_DCSIZE_8		(0x2 << 20)
+#define		ATC_DCSIZE_16		(0x3 << 20)
+#define		ATC_DCSIZE_32		(0x4 << 20)
+#define		ATC_DCSIZE_64		(0x5 << 20)
+#define		ATC_DCSIZE_128		(0x6 << 20)
+#define		ATC_DCSIZE_256		(0x7 << 20)
 #define	ATC_SRC_WIDTH_MASK	(0x3 << 24)	/* Source Single Transfer Size */
 #define		ATC_SRC_WIDTH(x)	((x) << 24)
 #define		ATC_SRC_WIDTH_BYTE	(0x0 << 24)
-- 
1.7.10

