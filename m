Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932194Ab1G2KuZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 06:50:25 -0400
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:34087 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932173Ab1G2KuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 06:50:16 -0400
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
Subject: [PATCH 15/18] dmaengine/amba-pl08x: Pass flow controller information with slave channel data
Date: Fri, 29 Jul 2011 16:19:25 +0530
Message-ID: <2f6001455c4e54f56716a245c7e319eb25a9bb0d.1311936524.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1311936523.git.viresh.kumar@st.com>
References: <cover.1311936523.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At least, on SPEAr platforms there is one peripheral, JPEG, which can be flow
controller for DMA transfer. Currently DMA controller driver didn't support
peripheral flow controller configurations.

This patch adds fc field in struct pl08x_channel_data, which will be used only
for slave transfers and is not used in case of mem2mem transfers. In case this
is passed as 0, then flow controller is decided based on DMA_DIRECTION.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 drivers/dma/amba-pl08x.c   |   46 +++++++++++++++++++++++++++++++++++++++----
 include/linux/amba/pl08x.h |    5 ++++
 2 files changed, 46 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index 6b0ca26..9eea0d1 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -632,6 +632,38 @@ static int pl08x_fill_llis_for_desc(struct pl08x_driver_data *pl08x,
 
 	if (bd.remainder) {
 		/*
+		 * Zero length is only allowed if all these requirements are
+		 * met:
+		 * - flow controller is peripheral.
+		 * - src.addr is aligned to src.width
+		 * - dst.addr is aligned to dst.width
+		 */
+		if (!bd.remainder) {
+			u32 fc = (txd->cctl & PL080_CONFIG_FLOW_CONTROL_MASK) >>
+				PL080_CONFIG_FLOW_CONTROL_SHIFT;
+			if (!((fc >= PL080_FLOW_SRC2DST_DST) &&
+					(fc <= PL080_FLOW_SRC2DST_SRC))) {
+				dev_err(&pl08x->adev->dev, "%s sg len can't be "
+						"zero", __func__);
+				return 0;
+			}
+
+			if ((bd.srcbus.addr % bd.srcbus.buswidth) ||
+					(bd.srcbus.addr % bd.srcbus.buswidth)) {
+				dev_err(&pl08x->adev->dev, "%s src & dst "
+						"address must be aligned to src"
+						" & dst width if peripheral is "
+						"flow controller", __func__);
+				return 0;
+			}
+
+			cctl = pl08x_cctl_bits(cctl, bd.srcbus.buswidth,
+					bd.dstbus.buswidth, 0);
+			pl08x_fill_lli_for_desc(&bd, num_llis++, 0, cctl);
+			continue;
+		}
+
+		/*
 		 * Master now aligned
 		 * - if slave is not then we must set its width down
 		 */
@@ -1255,7 +1287,7 @@ static struct dma_async_tx_descriptor *pl08x_prep_slave_sg(
 	struct pl08x_dma_chan *plchan = to_pl08x_chan(chan);
 	struct pl08x_driver_data *pl08x = plchan->host;
 	struct pl08x_txd *txd;
-	int ret;
+	int ret, tmp;
 
 	/*
 	 * Current implementation ASSUMES only one sg
@@ -1289,14 +1321,10 @@ static struct dma_async_tx_descriptor *pl08x_prep_slave_sg(
 	txd->len = sgl->length;
 
 	if (direction == DMA_TO_DEVICE) {
-		txd->ccfg |= PL080_FLOW_MEM2PER <<
-			PL080_CONFIG_FLOW_CONTROL_SHIFT;
 		txd->cctl = plchan->dst_cctl;
 		txd->src_addr = sgl->dma_address;
 		txd->dst_addr = plchan->dst_addr;
 	} else if (direction == DMA_FROM_DEVICE) {
-		txd->ccfg |= PL080_FLOW_PER2MEM <<
-			PL080_CONFIG_FLOW_CONTROL_SHIFT;
 		txd->cctl = plchan->src_cctl;
 		txd->src_addr = plchan->src_addr;
 		txd->dst_addr = sgl->dma_address;
@@ -1306,6 +1334,14 @@ static struct dma_async_tx_descriptor *pl08x_prep_slave_sg(
 		return NULL;
 	}
 
+	if (plchan->cd->fc)
+		tmp = plchan->cd->fc;
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
index 98628a8..febb0da 100644
--- a/include/linux/amba/pl08x.h
+++ b/include/linux/amba/pl08x.h
@@ -47,6 +47,10 @@ enum {
  * @muxval: a number usually used to poke into some mux regiser to
  * mux in the signal to this channel
  * @cctl_opt: default options for the channel control register
+ * @fc: Flow Controller Settings for ccfg register. Only valid for slave
+ * channels. Fill with any PL080_FLOW_* macro's present in
+ * <asm/hardware/pl080.h>. If passed as 0, then Flow control will be decided
+ * according to DMA direction.
  * @addr: source/target address in physical memory for this DMA channel,
  * can be the address of a FIFO register for burst requests for example.
  * This can be left undefined if the PrimeCell API is used for configuring
@@ -65,6 +69,7 @@ struct pl08x_channel_data {
 	int max_signal;
 	u32 muxval;
 	u32 cctl;
+	u32 fc;
 	dma_addr_t addr;
 	bool circular_buffer;
 	bool single;
-- 
1.7.2.2

