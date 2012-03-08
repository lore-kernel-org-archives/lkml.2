Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431Ab2CHUkO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 15:40:14 -0500
Received: from mxout1.idt.com ([157.165.5.25]:37957 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894Ab2CHUkH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 15:40:07 -0500
From: Alexandre Bounine <alexandre.bounine@idt.com>
To: vinod.koul@intel.com, dan.j.williams@intel.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org
Cc: Alexandre Bounine <alexandre.bounine@idt.com>, jaswinder.singh@linaro.org,
        linus.walleij@stericsson.com, leoli@freescale.com, zw@zh-kernel.org,
        STEricsson_nomadik_linux@list.st.com, ben-linux@fluff.org,
        kgene.kim@samsung.com, mchehab@infradead.org,
        ludovic.desroches@atmel.com, cjb@laptop.org, g.liakhovetski@gmx.de,
        ian@mnementh.co.uk, dwmw2@infradead.org, grant.likely@secretlab.ca,
        alan@linux.intel.com, balbi@ti.com, FlorianSchandinat@gmx.de,
        perex@perex.cz, tiwai@suse.de, viresh.kumar@st.com,
        baohua.song@csr.com, srinidhi.kasagar@stericsson.com
Subject: [PATCH 2/2 V2] dmaengine: add context parameter to prep_slave_sg and prep_dma_cyclic
Date: Thu,  8 Mar 2012 15:35:13 -0500
Message-Id: <1331238913-25818-3-git-send-email-alexandre.bounine@idt.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1331238913-25818-1-git-send-email-alexandre.bounine@idt.com>
References: <1331238913-25818-1-git-send-email-alexandre.bounine@idt.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add context parameter to device_prep_slave_sg() and device_prep_dma_cyclic()
interfaces to allow passing client/target specific information associated
with the data transfer.
Modify all affected DMA engine drivers.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
---
 drivers/dma/amba-pl08x.c    |    2 +-
 drivers/dma/at_hdmac.c      |    7 +++++--
 drivers/dma/coh901318.c     |    2 +-
 drivers/dma/dw_dmac.c       |    2 +-
 drivers/dma/ep93xx_dma.c    |    6 ++++--
 drivers/dma/fsldma.c        |    4 +++-
 drivers/dma/imx-dma.c       |    5 +++--
 drivers/dma/imx-sdma.c      |    5 +++--
 drivers/dma/intel_mid_dma.c |    3 ++-
 drivers/dma/ipu/ipu_idmac.c |    3 ++-
 drivers/dma/mxs-dma.c       |    5 +++--
 drivers/dma/pch_dma.c       |    3 ++-
 drivers/dma/pl330.c         |    5 +++--
 drivers/dma/shdma.c         |    3 ++-
 drivers/dma/sirf-dma.c      |    2 +-
 drivers/dma/ste_dma40.c     |    5 +++--
 drivers/dma/timb_dma.c      |    3 ++-
 drivers/dma/txx9dmac.c      |    2 +-
 include/linux/dmaengine.h   |   12 +++++++-----
 19 files changed, 49 insertions(+), 30 deletions(-)

diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index 8a28158..776f9e2 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -1326,7 +1326,7 @@ static struct dma_async_tx_descriptor *pl08x_prep_dma_memcpy(
 static struct dma_async_tx_descriptor *pl08x_prep_slave_sg(
 		struct dma_chan *chan, struct scatterlist *sgl,
 		unsigned int sg_len, enum dma_transfer_direction direction,
-		unsigned long flags)
+		unsigned long flags, void *context)
 {
 	struct pl08x_dma_chan *plchan = to_pl08x_chan(chan);
 	struct pl08x_driver_data *pl08x = plchan->host;
diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index f4aed5f..e1a1d42 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -659,11 +659,12 @@ err_desc_get:
  * @sg_len: number of entries in @scatterlist
  * @direction: DMA direction
  * @flags: tx descriptor status flags
+ * @context: transaction context (ignored)
  */
 static struct dma_async_tx_descriptor *
 atc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 		unsigned int sg_len, enum dma_transfer_direction direction,
-		unsigned long flags)
+		unsigned long flags, void *context)
 {
 	struct at_dma_chan	*atchan = to_at_dma_chan(chan);
 	struct at_dma_slave	*atslave = chan->private;
@@ -860,10 +861,12 @@ atc_dma_cyclic_fill_desc(struct at_dma_slave *atslave, struct at_desc *desc,
  * @buf_len: total number of bytes for the entire buffer
  * @period_len: number of bytes for each period
  * @direction: transfer direction, to or from device
+ * @context: transfer context (ignored)
  */
 static struct dma_async_tx_descriptor *
 atc_prep_dma_cyclic(struct dma_chan *chan, dma_addr_t buf_addr, size_t buf_len,
-		size_t period_len, enum dma_transfer_direction direction)
+		size_t period_len, enum dma_transfer_direction direction,
+		void *context)
 {
 	struct at_dma_chan	*atchan = to_at_dma_chan(chan);
 	struct at_dma_slave	*atslave = chan->private;
diff --git a/drivers/dma/coh901318.c b/drivers/dma/coh901318.c
index d65a718..f42b54e 100644
--- a/drivers/dma/coh901318.c
+++ b/drivers/dma/coh901318.c
@@ -1035,7 +1035,7 @@ coh901318_prep_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
 static struct dma_async_tx_descriptor *
 coh901318_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 			unsigned int sg_len, enum dma_transfer_direction direction,
-			unsigned long flags)
+			unsigned long flags, void *context)
 {
 	struct coh901318_chan *cohc = to_coh901318_chan(chan);
 	struct coh901318_lli *lli;
diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 9b592b0..058bddf 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -731,7 +731,7 @@ err_desc_get:
 static struct dma_async_tx_descriptor *
 dwc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 		unsigned int sg_len, enum dma_transfer_direction direction,
-		unsigned long flags)
+		unsigned long flags, void *context)
 {
 	struct dw_dma_chan	*dwc = to_dw_dma_chan(chan);
 	struct dw_dma_slave	*dws = chan->private;
diff --git a/drivers/dma/ep93xx_dma.c b/drivers/dma/ep93xx_dma.c
index 59e7a96..c79de61 100644
--- a/drivers/dma/ep93xx_dma.c
+++ b/drivers/dma/ep93xx_dma.c
@@ -983,13 +983,14 @@ fail:
  * @sg_len: number of entries in @sgl
  * @dir: direction of tha DMA transfer
  * @flags: flags for the descriptor
+ * @context: operation context (ignored)
  *
  * Returns a valid DMA descriptor or %NULL in case of failure.
  */
 static struct dma_async_tx_descriptor *
 ep93xx_dma_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 			 unsigned int sg_len, enum dma_transfer_direction dir,
-			 unsigned long flags)
+			 unsigned long flags, void *context)
 {
 	struct ep93xx_dma_chan *edmac = to_ep93xx_dma_chan(chan);
 	struct ep93xx_dma_desc *desc, *first;
@@ -1056,6 +1057,7 @@ fail:
  * @buf_len: length of the buffer (in bytes)
  * @period_len: lenght of a single period
  * @dir: direction of the operation
+ * @context: operation context (ignored)
  *
  * Prepares a descriptor for cyclic DMA operation. This means that once the
  * descriptor is submitted, we will be submitting in a @period_len sized
@@ -1068,7 +1070,7 @@ fail:
 static struct dma_async_tx_descriptor *
 ep93xx_dma_prep_dma_cyclic(struct dma_chan *chan, dma_addr_t dma_addr,
 			   size_t buf_len, size_t period_len,
-			   enum dma_transfer_direction dir)
+			   enum dma_transfer_direction dir, void *context)
 {
 	struct ep93xx_dma_chan *edmac = to_ep93xx_dma_chan(chan);
 	struct ep93xx_dma_desc *desc, *first;
diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index b98070c..51d33e5 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -765,6 +765,7 @@ fail:
  * @sg_len: number of entries in @scatterlist
  * @direction: DMA direction
  * @flags: DMAEngine flags
+ * @context: transaction context (ignored)
  *
  * Prepare a set of descriptors for a DMA_SLAVE transaction. Following the
  * DMA_SLAVE API, this gets the device-specific information from the
@@ -772,7 +773,8 @@ fail:
  */
 static struct dma_async_tx_descriptor *fsl_dma_prep_slave_sg(
 	struct dma_chan *dchan, struct scatterlist *sgl, unsigned int sg_len,
-	enum dma_transfer_direction direction, unsigned long flags)
+	enum dma_transfer_direction direction, unsigned long flags,
+	void *context)
 {
 	/*
 	 * This operation is not supported on the Freescale DMA controller
diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
index e4383ee..42d5dc5 100644
--- a/drivers/dma/imx-dma.c
+++ b/drivers/dma/imx-dma.c
@@ -225,7 +225,7 @@ static void imxdma_free_chan_resources(struct dma_chan *chan)
 static struct dma_async_tx_descriptor *imxdma_prep_slave_sg(
 		struct dma_chan *chan, struct scatterlist *sgl,
 		unsigned int sg_len, enum dma_transfer_direction direction,
-		unsigned long flags)
+		unsigned long flags, void *context)
 {
 	struct imxdma_channel *imxdmac = to_imxdma_chan(chan);
 	struct scatterlist *sg;
@@ -271,7 +271,8 @@ static struct dma_async_tx_descriptor *imxdma_prep_slave_sg(
 
 static struct dma_async_tx_descriptor *imxdma_prep_dma_cyclic(
 		struct dma_chan *chan, dma_addr_t dma_addr, size_t buf_len,
-		size_t period_len, enum dma_transfer_direction direction)
+		size_t period_len, enum dma_transfer_direction direction,
+		void *context)
 {
 	struct imxdma_channel *imxdmac = to_imxdma_chan(chan);
 	struct imxdma_engine *imxdma = imxdmac->imxdma;
diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index 8bc5acf..5313946 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -917,7 +917,7 @@ static void sdma_free_chan_resources(struct dma_chan *chan)
 static struct dma_async_tx_descriptor *sdma_prep_slave_sg(
 		struct dma_chan *chan, struct scatterlist *sgl,
 		unsigned int sg_len, enum dma_transfer_direction direction,
-		unsigned long flags)
+		unsigned long flags, void *context)
 {
 	struct sdma_channel *sdmac = to_sdma_chan(chan);
 	struct sdma_engine *sdma = sdmac->sdma;
@@ -1015,7 +1015,8 @@ err_out:
 
 static struct dma_async_tx_descriptor *sdma_prep_dma_cyclic(
 		struct dma_chan *chan, dma_addr_t dma_addr, size_t buf_len,
-		size_t period_len, enum dma_transfer_direction direction)
+		size_t period_len, enum dma_transfer_direction direction,
+		void *context)
 {
 	struct sdma_channel *sdmac = to_sdma_chan(chan);
 	struct sdma_engine *sdma = sdmac->sdma;
diff --git a/drivers/dma/intel_mid_dma.c b/drivers/dma/intel_mid_dma.c
index 74f70aa..2a202e5 100644
--- a/drivers/dma/intel_mid_dma.c
+++ b/drivers/dma/intel_mid_dma.c
@@ -732,13 +732,14 @@ err_desc_get:
  * @sg_len: length of sg txn
  * @direction: DMA transfer dirtn
  * @flags: DMA flags
+ * @context: transfer context (ignored)
  *
  * Prepares LLI based periphral transfer
  */
 static struct dma_async_tx_descriptor *intel_mid_dma_prep_slave_sg(
 			struct dma_chan *chan, struct scatterlist *sgl,
 			unsigned int sg_len, enum dma_transfer_direction direction,
-			unsigned long flags)
+			unsigned long flags, void *context)
 {
 	struct intel_mid_dma_chan *midc = NULL;
 	struct intel_mid_dma_slave *mids = NULL;
diff --git a/drivers/dma/ipu/ipu_idmac.c b/drivers/dma/ipu/ipu_idmac.c
index 6212b16..aadd57c 100644
--- a/drivers/dma/ipu/ipu_idmac.c
+++ b/drivers/dma/ipu/ipu_idmac.c
@@ -1341,7 +1341,8 @@ static void ipu_gc_tasklet(unsigned long arg)
 /* Allocate and initialise a transfer descriptor. */
 static struct dma_async_tx_descriptor *idmac_prep_slave_sg(struct dma_chan *chan,
 		struct scatterlist *sgl, unsigned int sg_len,
-		enum dma_transfer_direction direction, unsigned long tx_flags)
+		enum dma_transfer_direction direction, unsigned long tx_flags,
+		void *context)
 {
 	struct idmac_channel *ichan = to_idmac_chan(chan);
 	struct idmac_tx_desc *desc = NULL;
diff --git a/drivers/dma/mxs-dma.c b/drivers/dma/mxs-dma.c
index b06cd4c..3e65974 100644
--- a/drivers/dma/mxs-dma.c
+++ b/drivers/dma/mxs-dma.c
@@ -352,7 +352,7 @@ static void mxs_dma_free_chan_resources(struct dma_chan *chan)
 static struct dma_async_tx_descriptor *mxs_dma_prep_slave_sg(
 		struct dma_chan *chan, struct scatterlist *sgl,
 		unsigned int sg_len, enum dma_transfer_direction direction,
-		unsigned long append)
+		unsigned long append, void *context)
 {
 	struct mxs_dma_chan *mxs_chan = to_mxs_dma_chan(chan);
 	struct mxs_dma_engine *mxs_dma = mxs_chan->mxs_dma;
@@ -447,7 +447,8 @@ err_out:
 
 static struct dma_async_tx_descriptor *mxs_dma_prep_dma_cyclic(
 		struct dma_chan *chan, dma_addr_t dma_addr, size_t buf_len,
-		size_t period_len, enum dma_transfer_direction direction)
+		size_t period_len, enum dma_transfer_direction direction,
+		void *context)
 {
 	struct mxs_dma_chan *mxs_chan = to_mxs_dma_chan(chan);
 	struct mxs_dma_engine *mxs_dma = mxs_chan->mxs_dma;
diff --git a/drivers/dma/pch_dma.c b/drivers/dma/pch_dma.c
index 823f581..d0a334d 100644
--- a/drivers/dma/pch_dma.c
+++ b/drivers/dma/pch_dma.c
@@ -607,7 +607,8 @@ static void pd_issue_pending(struct dma_chan *chan)
 
 static struct dma_async_tx_descriptor *pd_prep_slave_sg(struct dma_chan *chan,
 			struct scatterlist *sgl, unsigned int sg_len,
-			enum dma_transfer_direction direction, unsigned long flags)
+			enum dma_transfer_direction direction, unsigned long flags,
+			void *context)
 {
 	struct pch_dma_chan *pd_chan = to_pd_chan(chan);
 	struct pch_dma_slave *pd_slave = chan->private;
diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index b8ec03e..1e8dee6 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -621,7 +621,8 @@ static inline int get_burst_len(struct dma_pl330_desc *desc, size_t len)
 
 static struct dma_async_tx_descriptor *pl330_prep_dma_cyclic(
 		struct dma_chan *chan, dma_addr_t dma_addr, size_t len,
-		size_t period_len, enum dma_transfer_direction direction)
+		size_t period_len, enum dma_transfer_direction direction,
+		void *context)
 {
 	struct dma_pl330_desc *desc;
 	struct dma_pl330_chan *pch = to_pchan(chan);
@@ -711,7 +712,7 @@ pl330_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dst,
 static struct dma_async_tx_descriptor *
 pl330_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 		unsigned int sg_len, enum dma_transfer_direction direction,
-		unsigned long flg)
+		unsigned long flg, void *context)
 {
 	struct dma_pl330_desc *first, *desc = NULL;
 	struct dma_pl330_chan *pch = to_pchan(chan);
diff --git a/drivers/dma/shdma.c b/drivers/dma/shdma.c
index 812fd76..6b94f22 100644
--- a/drivers/dma/shdma.c
+++ b/drivers/dma/shdma.c
@@ -673,7 +673,8 @@ static struct dma_async_tx_descriptor *sh_dmae_prep_memcpy(
 
 static struct dma_async_tx_descriptor *sh_dmae_prep_slave_sg(
 	struct dma_chan *chan, struct scatterlist *sgl, unsigned int sg_len,
-	enum dma_transfer_direction direction, unsigned long flags)
+	enum dma_transfer_direction direction, unsigned long flags,
+	void *context)
 {
 	struct sh_dmae_slave *param;
 	struct sh_dmae_chan *sh_chan;
diff --git a/drivers/dma/sirf-dma.c b/drivers/dma/sirf-dma.c
index 2333810..b899a86 100644
--- a/drivers/dma/sirf-dma.c
+++ b/drivers/dma/sirf-dma.c
@@ -497,7 +497,7 @@ err_dir:
 static struct dma_async_tx_descriptor *
 sirfsoc_dma_prep_cyclic(struct dma_chan *chan, dma_addr_t addr,
 	size_t buf_len, size_t period_len,
-	enum dma_transfer_direction direction)
+	enum dma_transfer_direction direction, void *context)
 {
 	struct sirfsoc_dma_chan *schan = dma_chan_to_sirfsoc_dma_chan(chan);
 	struct sirfsoc_dma_desc *sdesc = NULL;
diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index cc5ecbc..3cbf78e 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -2299,7 +2299,8 @@ static struct dma_async_tx_descriptor *d40_prep_slave_sg(struct dma_chan *chan,
 							 struct scatterlist *sgl,
 							 unsigned int sg_len,
 							 enum dma_transfer_direction direction,
-							 unsigned long dma_flags)
+							 unsigned long dma_flags,
+							 void *context)
 {
 	if (direction != DMA_DEV_TO_MEM && direction != DMA_MEM_TO_DEV)
 		return NULL;
@@ -2310,7 +2311,7 @@ static struct dma_async_tx_descriptor *d40_prep_slave_sg(struct dma_chan *chan,
 static struct dma_async_tx_descriptor *
 dma40_prep_dma_cyclic(struct dma_chan *chan, dma_addr_t dma_addr,
 		     size_t buf_len, size_t period_len,
-		     enum dma_transfer_direction direction)
+		     enum dma_transfer_direction direction, void *context)
 {
 	unsigned int periods = buf_len / period_len;
 	struct dma_async_tx_descriptor *txd;
diff --git a/drivers/dma/timb_dma.c b/drivers/dma/timb_dma.c
index a6f9c16..a4c61ed 100644
--- a/drivers/dma/timb_dma.c
+++ b/drivers/dma/timb_dma.c
@@ -558,7 +558,8 @@ static void td_issue_pending(struct dma_chan *chan)
 
 static struct dma_async_tx_descriptor *td_prep_slave_sg(struct dma_chan *chan,
 	struct scatterlist *sgl, unsigned int sg_len,
-	enum dma_transfer_direction direction, unsigned long flags)
+	enum dma_transfer_direction direction, unsigned long flags,
+	void *context)
 {
 	struct timb_dma_chan *td_chan =
 		container_of(chan, struct timb_dma_chan, chan);
diff --git a/drivers/dma/txx9dmac.c b/drivers/dma/txx9dmac.c
index 6122c36..fa66ebb 100644
--- a/drivers/dma/txx9dmac.c
+++ b/drivers/dma/txx9dmac.c
@@ -846,7 +846,7 @@ txx9dmac_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
 static struct dma_async_tx_descriptor *
 txx9dmac_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 		unsigned int sg_len, enum dma_transfer_direction direction,
-		unsigned long flags)
+		unsigned long flags, void *context)
 {
 	struct txx9dmac_chan *dc = to_txx9dmac_chan(chan);
 	struct txx9dmac_dev *ddev = dc->ddev;
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 6e88f09..9a8140f 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -575,10 +575,11 @@ struct dma_device {
 	struct dma_async_tx_descriptor *(*device_prep_slave_sg)(
 		struct dma_chan *chan, struct scatterlist *sgl,
 		unsigned int sg_len, enum dma_transfer_direction direction,
-		unsigned long flags);
+		unsigned long flags, void *context);
 	struct dma_async_tx_descriptor *(*device_prep_dma_cyclic)(
 		struct dma_chan *chan, dma_addr_t buf_addr, size_t buf_len,
-		size_t period_len, enum dma_transfer_direction direction);
+		size_t period_len, enum dma_transfer_direction direction,
+		void *context);
 	struct dma_async_tx_descriptor *(*device_prep_interleaved_dma)(
 		struct dma_chan *chan, struct dma_interleaved_template *xt,
 		unsigned long flags);
@@ -612,7 +613,8 @@ static inline struct dma_async_tx_descriptor *dmaengine_prep_slave_single(
 	struct scatterlist sg;
 	sg_init_one(&sg, buf, len);
 
-	return chan->device->device_prep_slave_sg(chan, &sg, 1, dir, flags);
+	return chan->device->device_prep_slave_sg(chan, &sg, 1,
+						  dir, flags, NULL);
 }
 
 static inline struct dma_async_tx_descriptor *dmaengine_prep_slave_sg(
@@ -620,7 +622,7 @@ static inline struct dma_async_tx_descriptor *dmaengine_prep_slave_sg(
 	enum dma_transfer_direction dir, unsigned long flags)
 {
 	return chan->device->device_prep_slave_sg(chan, sgl, sg_len,
-						  dir, flags);
+						  dir, flags, NULL);
 }
 
 static inline struct dma_async_tx_descriptor *dmaengine_prep_dma_cyclic(
@@ -628,7 +630,7 @@ static inline struct dma_async_tx_descriptor *dmaengine_prep_dma_cyclic(
 		size_t period_len, enum dma_transfer_direction dir)
 {
 	return chan->device->device_prep_dma_cyclic(chan, buf_addr, buf_len,
-							period_len, dir);
+						period_len, dir, NULL);
 }
 
 static inline int dmaengine_terminate_all(struct dma_chan *chan)
-- 
1.7.8.4

