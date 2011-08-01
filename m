Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825Ab1HAJkj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 05:40:39 -0400
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:50317 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753632Ab1HAJjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 05:39:44 -0400
From: Viresh Kumar <viresh.kumar@st.com>
To: <linus.walleij@linaro.org>
Cc: <vinod.koul@intel.com>, <dan.j.williams@intel.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux@arm.linux.org.uk>, <armando.visconti@st.com>,
        <shiraz.hashim@st.com>, <vipin.kumar@st.com>,
        <rajeev-dlh.kumar@st.com>, <deepak.sikri@st.com>,
        <vipulkumar.samar@st.com>, <amit.virdi@st.com>, <viresh.kumar@st.com>,
        <pratyush.anand@st.com>, <bhupesh.sharma@st.com>,
        <viresh.linux@gmail.com>
Subject: [PATCH V2 17/20] dmaengine/amba-pl08x: Pass flow controller information with slave channel data
Date: Mon, 1 Aug 2011 15:07:27 +0530
Message-ID: <75eeef2d64881c9ef21065e2b15188876a13a4ed.1312190881.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1312190881.git.viresh.kumar@st.com>
References: <cover.1312190881.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At least, on SPEAr platforms there is one peripheral, JPEG, which can be flow
controller for DMA transfer. Currently DMA controller driver didn't support
peripheral flow controller configurations.

This patch adds device_fc field in struct pl08x_channel_data, which will be used
only for slave transfers and is not used in case of mem2mem transfers.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 drivers/dma/amba-pl08x.c   |   61 ++++++++++++++++++++++++++++++++++++++------
 include/linux/amba/pl08x.h |    4 +++
 2 files changed, 57 insertions(+), 8 deletions(-)

diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index c969309..d573dc2 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -66,11 +66,6 @@
  *    after the final transfer signalled by LBREQ or LSREQ.  The DMAC
  *    will then move to the next LLI entry.
  *
- * Only the former works sanely with scatter lists, so we only implement
- * the DMAC flow control method.  However, peripherals which use the LBREQ
- * and LSREQ signals (eg, MMCI) are unable to use this mode, which through
- * these hardware restrictions prevents them from using scatter DMA.
- *
  * Global TODO:
  * - Break out common code from arch/arm/mach-s3c64xx and share
  */
@@ -615,6 +610,49 @@ static int pl08x_fill_llis_for_desc(struct pl08x_driver_data *pl08x,
 		 sbus == &bd.srcbus ? "src" : "dst");
 
 	/*
+	 * Zero length is only allowed if all these requirements are met:
+	 * - flow controller is peripheral.
+	 * - src.addr is aligned to src.width
+	 * - dst.addr is aligned to dst.width
+	 *
+	 * sg_len == 1 should be true, as there can be two cases here:
+	 * - Memory addresses are contiguous and are not scattered. Here, Only
+	 * one sg will be passed by user driver, with memory address and zero
+	 * length. We pass this to controller and after the transfer it will
+	 * receive the last burst request from peripheral and so transfer
+	 * finishes.
+	 *
+	 * - Memory addresses are scattered and are not contiguous. Here,
+	 * Obviously as DMA controller doesn't know when a lli's transfer gets
+	 * over, it can't load next lli. So in this case, there has to be an
+	 * assumption that only one lli is supported. Thus, we can't have
+	 * scattered addresses.
+	 */
+	if (!bd.remainder) {
+		u32 fc = (txd->ccfg & PL080_CONFIG_FLOW_CONTROL_MASK) >>
+			PL080_CONFIG_FLOW_CONTROL_SHIFT;
+		if (!((fc >= PL080_FLOW_SRC2DST_DST) &&
+					(fc <= PL080_FLOW_SRC2DST_SRC))) {
+			dev_err(&pl08x->adev->dev, "%s sg len can't be zero",
+				__func__);
+			return 0;
+		}
+
+		if ((bd.srcbus.addr % bd.srcbus.buswidth) ||
+				(bd.srcbus.addr % bd.srcbus.buswidth)) {
+			dev_err(&pl08x->adev->dev,
+				"%s src & dst address must be aligned to src"
+				" & dst width if peripheral is flow controller",
+				__func__);
+			return 0;
+		}
+
+		cctl = pl08x_cctl_bits(cctl, bd.srcbus.buswidth,
+				bd.dstbus.buswidth, 0);
+		pl08x_fill_lli_for_desc(&bd, num_llis++, 0, cctl);
+	}
+
+	/*
 	 * Send byte by byte for following cases
 	 * - Less than a bus width available
 	 * - until master bus is aligned
@@ -1255,7 +1293,7 @@ static struct dma_async_tx_descriptor *pl08x_prep_slave_sg(
 	struct pl08x_dma_chan *plchan = to_pl08x_chan(chan);
 	struct pl08x_driver_data *pl08x = plchan->host;
 	struct pl08x_txd *txd;
-	int ret;
+	int ret, tmp;
 
 	/*
 	 * Current implementation ASSUMES only one sg
@@ -1289,12 +1327,10 @@ static struct dma_async_tx_descriptor *pl08x_prep_slave_sg(
 	txd->len = sgl->length;
 
 	if (direction == DMA_TO_DEVICE) {
-		txd->ccfg |= PL080_FLOW_MEM2PER << PL080_CONFIG_FLOW_CONTROL_SHIFT;
 		txd->cctl = plchan->dst_cctl;
 		txd->src_addr = sgl->dma_address;
 		txd->dst_addr = plchan->dst_addr;
 	} else if (direction == DMA_FROM_DEVICE) {
-		txd->ccfg |= PL080_FLOW_PER2MEM << PL080_CONFIG_FLOW_CONTROL_SHIFT;
 		txd->cctl = plchan->src_cctl;
 		txd->src_addr = plchan->src_addr;
 		txd->dst_addr = sgl->dma_address;
@@ -1304,6 +1340,15 @@ static struct dma_async_tx_descriptor *pl08x_prep_slave_sg(
 		return NULL;
 	}
 
+	if (plchan->cd->device_fc)
+		tmp = (direction == DMA_TO_DEVICE) ? PL080_FLOW_MEM2PER_PER :
+			PL080_FLOW_PER2MEM_PER;
+	else
+		tmp = (direction == DMA_TO_DEVICE) ? PL080_FLOW_MEM2PER :
+			PL080_FLOW_PER2MEM;
+
+	txd->ccfg |= tmp << PL080_CONFIG_FLOW_CONTROL_SHIFT;
+
 	ret = pl08x_prep_channel_resources(plchan, txd);
 	if (ret)
 		return NULL;
diff --git a/include/linux/amba/pl08x.h b/include/linux/amba/pl08x.h
index ecd17f5..a22662c 100644
--- a/include/linux/amba/pl08x.h
+++ b/include/linux/amba/pl08x.h
@@ -47,6 +47,9 @@ enum {
  * @muxval: a number usually used to poke into some mux regiser to
  * mux in the signal to this channel
  * @cctl_opt: default options for the channel control register
+ * @device_fc: Flow Controller Settings for ccfg register. Only valid for slave
+ * channels. Fill with 'true' if peripheral should be flow controller. Direction
+ * will be selected at Runtime.
  * @addr: source/target address in physical memory for this DMA channel,
  * can be the address of a FIFO register for burst requests for example.
  * This can be left undefined if the PrimeCell API is used for configuring
@@ -65,6 +68,7 @@ struct pl08x_channel_data {
 	int max_signal;
 	u32 muxval;
 	u32 cctl;
+	bool device_fc;
 	dma_addr_t addr;
 	bool circular_buffer;
 	bool single;
-- 
1.7.2.2

