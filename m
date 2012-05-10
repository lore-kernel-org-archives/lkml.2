Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751228Ab2EJETr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 00:19:47 -0400
Received: from exprod5og107.obsmtp.com ([64.18.0.184]:36969 "HELO
	exprod5og107.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750903Ab2EJETq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 00:19:46 -0400
From: "Thang Q. Nguyen" <tqnguyen@apm.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-ide@vger.kernel.org>,
        "Thang Q. Nguyen" <tqnguyen@apm.com>
Subject: [PATCH 2/5] sata_dwc: Add support device tree to specify dma_channel
Date: Thu, 10 May 2012 11:17:10 +0700
Message-Id: <1336623430-7652-1-git-send-email-tqnguyen@apm.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only channel 0 is currently support and the driver code is fixed on channel 0. This patch lets device node specifying dma-channel in case it is not 0. If no dma-channel property is specified, channel 0 is used as default.

Signed-off-by: Thang Q. Nguyen <tqnguyen@apm.com>
---
 drivers/ata/sata_dwc_460ex.c |   48 +++++++++++++++++++++++++++--------------
 1 files changed, 31 insertions(+), 17 deletions(-)
 mode change 100644 => 100755 drivers/ata/sata_dwc_460ex.c

diff --git a/drivers/ata/sata_dwc_460ex.c b/drivers/ata/sata_dwc_460ex.c
old mode 100644
new mode 100755
index ae13ef1..937aeb3
--- a/drivers/ata/sata_dwc_460ex.c
+++ b/drivers/ata/sata_dwc_460ex.c
@@ -158,6 +158,7 @@ enum {
 /* Assign HW handshaking interface (x) to destination / source peripheral */
 #define	DMA_CFG_HW_HS_DEST(int_num) (((int_num) & 0xF) << 11)
 #define	DMA_CFG_HW_HS_SRC(int_num) (((int_num) & 0xF) << 7)
+#define	DMA_CFG_HW_CH_PRIOR(int_num) (((int_num) & 0xF) << 5)
 #define	DMA_LLP_LMS(addr, master) (((addr) & 0xfffffffc) | (master))
 
 /*
@@ -318,6 +319,7 @@ struct sata_dwc_host_priv {
 	u32	dma_interrupt_count;
 	struct	ahb_dma_regs	*sata_dma_regs;
 	struct	device	*dwc_dev;
+	int	dma_channel;
 };
 struct sata_dwc_host_priv host_pvt;
 /*
@@ -437,15 +439,12 @@ static  void clear_chan_interrupts(int c)
  */
 static int dma_request_channel(void)
 {
-	int i;
-
-	for (i = 0; i < DMA_NUM_CHANS; i++) {
-		if (!(in_le32(&(host_pvt.sata_dma_regs->dma_chan_en.low)) &\
-			DMA_CHANNEL(i)))
-			return i;
-	}
-	dev_err(host_pvt.dwc_dev, "%s NO channel chan_en: 0x%08x\n", __func__,
-		in_le32(&(host_pvt.sata_dma_regs->dma_chan_en.low)));
+	/* Check if the channel is not currently in use */
+	if (!(in_le32(&(host_pvt.sata_dma_regs->dma_chan_en.low)) &
+		DMA_CHANNEL(host_pvt.dma_channel)))
+		return host_pvt.dma_channel;
+	dev_err(host_pvt.dwc_dev, "%s Channel %d is currently in use\n",
+		__func__, host_pvt.dma_channel);
 	return -1;
 }
 
@@ -481,7 +480,8 @@ static irqreturn_t dma_dwc_interrupt(int irq, void *hsdev_instance)
 	dev_dbg(ap->dev, "eot=0x%08x err=0x%08x pending=%d active port=%d\n",
 		tfr_reg, err_reg, hsdevp->dma_pending[tag], port);
 
-	for (chan = 0; chan < DMA_NUM_CHANS; chan++) {
+	chan = host_pvt.dma_channel;
+	if (chan >= 0) {
 		/* Check for end-of-transfer interrupt. */
 		if (tfr_reg & DMA_CHANNEL(chan)) {
 			/*
@@ -534,9 +534,9 @@ static irqreturn_t dma_dwc_interrupt(int irq, void *hsdev_instance)
 static int dma_request_interrupts(struct sata_dwc_device *hsdev, int irq)
 {
 	int retval = 0;
-	int chan;
+	int chan = host_pvt.dma_channel;
 
-	for (chan = 0; chan < DMA_NUM_CHANS; chan++) {
+	if (chan >= 0) {
 		/* Unmask error interrupt */
 		out_le32(&(host_pvt.sata_dma_regs)->interrupt_mask.error.low,
 			 DMA_ENABLE_CHAN(chan));
@@ -575,7 +575,10 @@ static int map_sg_to_lli(struct scatterlist *sg, int num_elems,
 	int fis_len = 0;
 	dma_addr_t next_llp;
 	int bl;
+	int sms_val, dms_val;
 
+	sms_val = 0;
+	dms_val = 1 + host_pvt.dma_channel;
 	dev_dbg(host_pvt.dwc_dev, "%s: sg=%p nelem=%d lli=%p dma_lli=0x%08x"
 		" dmadr=0x%08x\n", __func__, sg, num_elems, lli, (u32)dma_lli,
 		(u32)dmadr_addr);
@@ -635,8 +638,8 @@ static int map_sg_to_lli(struct scatterlist *sg, int num_elems,
 
 				lli[idx].ctl.low = cpu_to_le32(
 					DMA_CTL_TTFC(DMA_CTL_TTFC_P2M_DMAC) |
-					DMA_CTL_SMS(0) |
-					DMA_CTL_DMS(1) |
+					DMA_CTL_SMS(sms_val) |
+					DMA_CTL_DMS(dms_val) |
 					DMA_CTL_SRC_MSIZE(bl) |
 					DMA_CTL_DST_MSIZE(bl) |
 					DMA_CTL_SINC_NOCHANGE |
@@ -651,8 +654,8 @@ static int map_sg_to_lli(struct scatterlist *sg, int num_elems,
 
 				lli[idx].ctl.low = cpu_to_le32(
 					DMA_CTL_TTFC(DMA_CTL_TTFC_M2P_PER) |
-					DMA_CTL_SMS(1) |
-					DMA_CTL_DMS(0) |
+					DMA_CTL_SMS(dms_val) |
+					DMA_CTL_DMS(sms_val) |
 					DMA_CTL_SRC_MSIZE(bl) |
 					DMA_CTL_DST_MSIZE(bl) |
 					DMA_CTL_DINC_NOCHANGE |
@@ -744,8 +747,10 @@ static int dma_dwc_xfer_setup(struct scatterlist *sg, int num_elems,
 
 	/* Program the CFG register. */
 	out_le32(&(host_pvt.sata_dma_regs->chan_regs[dma_ch].cfg.high),
+		 DMA_CFG_HW_HS_SRC(dma_ch) | DMA_CFG_HW_HS_DEST(dma_ch) |
 		 DMA_CFG_PROTCTL | DMA_CFG_FCMOD_REQ);
-	out_le32(&(host_pvt.sata_dma_regs->chan_regs[dma_ch].cfg.low), 0);
+	out_le32(&(host_pvt.sata_dma_regs->chan_regs[dma_ch].cfg.low),
+		 DMA_CFG_HW_CH_PRIOR(dma_ch));
 
 	/* Program the address of the linked list */
 	out_le32(&(host_pvt.sata_dma_regs->chan_regs[dma_ch].llp.low),
@@ -1660,6 +1665,8 @@ static int sata_dwc_probe(struct platform_device *ofdev)
 	struct ata_host *host;
 	struct ata_port_info pi = sata_dwc_port_info[0];
 	const struct ata_port_info *ppi[] = { &pi, NULL };
+	struct device_node *np = ofdev->dev.of_node;
+	u32 dma_chan;
 
 	/* Allocate DWC SATA device */
 	hsdev = kzalloc(sizeof(*hsdev), GFP_KERNEL);
@@ -1669,6 +1676,13 @@ static int sata_dwc_probe(struct platform_device *ofdev)
 		goto error;
 	}
 
+	if (of_property_read_u32(np, "dma-channel", &dma_chan)) {
+		dev_warn(&ofdev->dev, "no dma-channel property set."
+			 " Use channel 0\n");
+		dma_chan = 0;
+	}
+	host_pvt.dma_channel = dma_chan;
+
 	/* Ioremap SATA registers */
 	base = of_iomap(ofdev->dev.of_node, 0);
 	if (!base) {
-- 
1.7.3.4

