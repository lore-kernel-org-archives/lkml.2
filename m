Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222Ab2IMNh7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 09:37:59 -0400
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:45325 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752657Ab2IMNhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 09:37:53 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>
Cc: alsa-devel@alsa-project.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        Ricardo Neri <ricardo.neri@ti.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Barry Song <baohua.song@csr.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Vista Silicon <javier.martin@vista-silicon.com>,
        Zhangfei Gao <zhangfei.gao@marvell.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH v2 04/15] dmaengine: Pass no_wakeup parameter via device_prep_dma_cyclic() callback
Date: Thu, 13 Sep 2012 16:37:54 +0300
Message-Id: <1347543485-339-5-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1347543485-339-1-git-send-email-peter.ujfalusi@ti.com>
References: <1347543485-339-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the parameter list of device_prep_dma_cyclic() so the DMA drivers
can receive the no_wakeup request coming from client drivers.
This feature can be used during audio operation to disable all audio
related interrupts.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>
CC: Barry Song <baohua.song@csr.com>
CC: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Vista Silicon <javier.martin@vista-silicon.com>
CC: Zhangfei Gao <zhangfei.gao@marvell.com>
CC: Shawn Guo <shawn.guo@linaro.org>
CC: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/dma/at_hdmac.c        | 3 ++-
 drivers/dma/ep93xx_dma.c      | 4 +++-
 drivers/dma/imx-dma.c         | 2 +-
 drivers/dma/imx-sdma.c        | 2 +-
 drivers/dma/mmp_tdma.c        | 2 +-
 drivers/dma/mxs-dma.c         | 2 +-
 drivers/dma/omap-dma.c        | 3 ++-
 drivers/dma/pl330.c           | 2 +-
 drivers/dma/sa11x0-dma.c      | 2 +-
 drivers/dma/sirf-dma.c        | 2 +-
 drivers/dma/ste_dma40.c       | 3 ++-
 drivers/dma/tegra20-apb-dma.c | 2 +-
 include/linux/dmaengine.h     | 5 +++--
 13 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index 3934fcc..c1ea42c 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -841,12 +841,13 @@ atc_dma_cyclic_fill_desc(struct dma_chan *chan, struct at_desc *desc,
  * @buf_len: total number of bytes for the entire buffer
  * @period_len: number of bytes for each period
  * @direction: transfer direction, to or from device
+ * @no_wakeup: suppress interrupts
  * @context: transfer context (ignored)
  */
 static struct dma_async_tx_descriptor *
 atc_prep_dma_cyclic(struct dma_chan *chan, dma_addr_t buf_addr, size_t buf_len,
 		size_t period_len, enum dma_transfer_direction direction,
-		void *context)
+		bool no_wakeup, void *context)
 {
 	struct at_dma_chan	*atchan = to_at_dma_chan(chan);
 	struct at_dma_slave	*atslave = chan->private;
diff --git a/drivers/dma/ep93xx_dma.c b/drivers/dma/ep93xx_dma.c
index c64917e..dfaf0df 100644
--- a/drivers/dma/ep93xx_dma.c
+++ b/drivers/dma/ep93xx_dma.c
@@ -1120,6 +1120,7 @@ fail:
  * @buf_len: length of the buffer (in bytes)
  * @period_len: lenght of a single period
  * @dir: direction of the operation
+ * @no_wakeup: suppress interrupts
  * @context: operation context (ignored)
  *
  * Prepares a descriptor for cyclic DMA operation. This means that once the
@@ -1133,7 +1134,8 @@ fail:
 static struct dma_async_tx_descriptor *
 ep93xx_dma_prep_dma_cyclic(struct dma_chan *chan, dma_addr_t dma_addr,
 			   size_t buf_len, size_t period_len,
-			   enum dma_transfer_direction dir, void *context)
+			   enum dma_transfer_direction dir, bool no_wakeup,
+			   void *context)
 {
 	struct ep93xx_dma_chan *edmac = to_ep93xx_dma_chan(chan);
 	struct ep93xx_dma_desc *desc, *first;
diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
index 5084975..8f05eb2 100644
--- a/drivers/dma/imx-dma.c
+++ b/drivers/dma/imx-dma.c
@@ -801,7 +801,7 @@ static struct dma_async_tx_descriptor *imxdma_prep_slave_sg(
 static struct dma_async_tx_descriptor *imxdma_prep_dma_cyclic(
 		struct dma_chan *chan, dma_addr_t dma_addr, size_t buf_len,
 		size_t period_len, enum dma_transfer_direction direction,
-		void *context)
+		bool no_wakeup, void *context)
 {
 	struct imxdma_channel *imxdmac = to_imxdma_chan(chan);
 	struct imxdma_engine *imxdma = imxdmac->imxdma;
diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index 1dc2a4a..3109fa0 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -1012,7 +1012,7 @@ err_out:
 static struct dma_async_tx_descriptor *sdma_prep_dma_cyclic(
 		struct dma_chan *chan, dma_addr_t dma_addr, size_t buf_len,
 		size_t period_len, enum dma_transfer_direction direction,
-		void *context)
+		bool no_wakeup, void *context)
 {
 	struct sdma_channel *sdmac = to_sdma_chan(chan);
 	struct sdma_engine *sdma = sdmac->sdma;
diff --git a/drivers/dma/mmp_tdma.c b/drivers/dma/mmp_tdma.c
index 8a15cf2..6d70d9c 100644
--- a/drivers/dma/mmp_tdma.c
+++ b/drivers/dma/mmp_tdma.c
@@ -358,7 +358,7 @@ struct mmp_tdma_desc *mmp_tdma_alloc_descriptor(struct mmp_tdma_chan *tdmac)
 static struct dma_async_tx_descriptor *mmp_tdma_prep_dma_cyclic(
 		struct dma_chan *chan, dma_addr_t dma_addr, size_t buf_len,
 		size_t period_len, enum dma_transfer_direction direction,
-		void *context)
+		bool no_wakeup, void *context)
 {
 	struct mmp_tdma_chan *tdmac = to_mmp_tdma_chan(chan);
 	struct mmp_tdma_desc *desc;
diff --git a/drivers/dma/mxs-dma.c b/drivers/dma/mxs-dma.c
index 7f41b25..d137ebb 100644
--- a/drivers/dma/mxs-dma.c
+++ b/drivers/dma/mxs-dma.c
@@ -531,7 +531,7 @@ err_out:
 static struct dma_async_tx_descriptor *mxs_dma_prep_dma_cyclic(
 		struct dma_chan *chan, dma_addr_t dma_addr, size_t buf_len,
 		size_t period_len, enum dma_transfer_direction direction,
-		void *context)
+		bool no_wakeup, void *context)
 {
 	struct mxs_dma_chan *mxs_chan = to_mxs_dma_chan(chan);
 	struct mxs_dma_engine *mxs_dma = mxs_chan->mxs_dma;
diff --git a/drivers/dma/omap-dma.c b/drivers/dma/omap-dma.c
index 71d7869..c6a711d 100644
--- a/drivers/dma/omap-dma.c
+++ b/drivers/dma/omap-dma.c
@@ -366,7 +366,8 @@ static struct dma_async_tx_descriptor *omap_dma_prep_slave_sg(
 
 static struct dma_async_tx_descriptor *omap_dma_prep_dma_cyclic(
 	struct dma_chan *chan, dma_addr_t buf_addr, size_t buf_len,
-	size_t period_len, enum dma_transfer_direction dir, void *context)
+	size_t period_len, enum dma_transfer_direction dir, bool no_wakeup,
+	void *context)
 {
 	struct omap_chan *c = to_omap_dma_chan(chan);
 	enum dma_slave_buswidth dev_width;
diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index e4feba6..865db3f 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -2683,7 +2683,7 @@ static inline int get_burst_len(struct dma_pl330_desc *desc, size_t len)
 static struct dma_async_tx_descriptor *pl330_prep_dma_cyclic(
 		struct dma_chan *chan, dma_addr_t dma_addr, size_t len,
 		size_t period_len, enum dma_transfer_direction direction,
-		void *context)
+		bool no_wakeup, void *context)
 {
 	struct dma_pl330_desc *desc;
 	struct dma_pl330_chan *pch = to_pchan(chan);
diff --git a/drivers/dma/sa11x0-dma.c b/drivers/dma/sa11x0-dma.c
index f5a7360..f26132c 100644
--- a/drivers/dma/sa11x0-dma.c
+++ b/drivers/dma/sa11x0-dma.c
@@ -614,7 +614,7 @@ static struct dma_async_tx_descriptor *sa11x0_dma_prep_slave_sg(
 
 static struct dma_async_tx_descriptor *sa11x0_dma_prep_dma_cyclic(
 	struct dma_chan *chan, dma_addr_t addr, size_t size, size_t period,
-	enum dma_transfer_direction dir, void *context)
+	enum dma_transfer_direction dir, bool no_wakeup, void *context)
 {
 	struct sa11x0_dma_chan *c = to_sa11x0_dma_chan(chan);
 	struct sa11x0_dma_desc *txd;
diff --git a/drivers/dma/sirf-dma.c b/drivers/dma/sirf-dma.c
index 434ad31..2db0574 100644
--- a/drivers/dma/sirf-dma.c
+++ b/drivers/dma/sirf-dma.c
@@ -489,7 +489,7 @@ err_dir:
 static struct dma_async_tx_descriptor *
 sirfsoc_dma_prep_cyclic(struct dma_chan *chan, dma_addr_t addr,
 	size_t buf_len, size_t period_len,
-	enum dma_transfer_direction direction, void *context)
+	enum dma_transfer_direction direction, bool no_wakeup, void *context)
 {
 	struct sirfsoc_dma_chan *schan = dma_chan_to_sirfsoc_dma_chan(chan);
 	struct sirfsoc_dma_desc *sdesc = NULL;
diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 000d309..b5e8e6c 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -2347,7 +2347,8 @@ static struct dma_async_tx_descriptor *d40_prep_slave_sg(struct dma_chan *chan,
 static struct dma_async_tx_descriptor *
 dma40_prep_dma_cyclic(struct dma_chan *chan, dma_addr_t dma_addr,
 		     size_t buf_len, size_t period_len,
-		     enum dma_transfer_direction direction, void *context)
+		     enum dma_transfer_direction direction, bool no_wakeup,
+		     void *context)
 {
 	unsigned int periods = buf_len / period_len;
 	struct dma_async_tx_descriptor *txd;
diff --git a/drivers/dma/tegra20-apb-dma.c b/drivers/dma/tegra20-apb-dma.c
index 24acd71..61af0a5 100644
--- a/drivers/dma/tegra20-apb-dma.c
+++ b/drivers/dma/tegra20-apb-dma.c
@@ -990,7 +990,7 @@ static struct dma_async_tx_descriptor *tegra_dma_prep_slave_sg(
 struct dma_async_tx_descriptor *tegra_dma_prep_dma_cyclic(
 	struct dma_chan *dc, dma_addr_t buf_addr, size_t buf_len,
 	size_t period_len, enum dma_transfer_direction direction,
-	void *context)
+	bool no_wakeup, void *context)
 {
 	struct tegra_dma_channel *tdc = to_tegra_dma_chan(dc);
 	struct tegra_dma_desc *dma_desc = NULL;
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 990444b..a4ec3c9 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -591,7 +591,7 @@ struct dma_device {
 	struct dma_async_tx_descriptor *(*device_prep_dma_cyclic)(
 		struct dma_chan *chan, dma_addr_t buf_addr, size_t buf_len,
 		size_t period_len, enum dma_transfer_direction direction,
-		void *context);
+		bool no_wakeup, void *context);
 	struct dma_async_tx_descriptor *(*device_prep_interleaved_dma)(
 		struct dma_chan *chan, struct dma_interleaved_template *xt,
 		unsigned long flags);
@@ -657,7 +657,8 @@ static inline struct dma_async_tx_descriptor *dmaengine_prep_dma_cyclic(
 		bool no_wakeup)
 {
 	return chan->device->device_prep_dma_cyclic(chan, buf_addr, buf_len,
-						period_len, dir, NULL);
+						period_len, dir, no_wakeup,
+					        NULL);
 }
 
 static inline int dmaengine_terminate_all(struct dma_chan *chan)
-- 
1.7.12

