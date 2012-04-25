Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757694Ab2DYSsg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 14:48:36 -0400
Received: from smtp-out-106.synserver.de ([212.40.185.106]:1094 "EHLO
	smtp-out-098.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757300Ab2DYSse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 14:48:34 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 1421
From: Lars-Peter Clausen <lars@metafoo.de>
To: Vinod Koul <vinod.koul@intel.com>, Russell King <linux@arm.linux.org.uk>
Cc: Viresh Kumar <viresh.kumar@st.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Javier Martin <javier.martin@vista-silicon.com>,
        Richard Zhao <richard.zhao@linaro.org>,
        Yong Wang <yong.y.wang@intel.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 1/3] dmaengine: Use sg_dma_address instead of sg_phys
Date: Wed, 25 Apr 2012 20:50:51 +0200
Message-Id: <1335379853-10122-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dmaengine drivers should always use sg_dma_address instead of sg_phys to get the
addresses for the transfer from a sg element.

To quote Russel King:
	sg_phys(sg) of course has nothing to do with DMA addresses. It's the
	physical address _to the CPU_ of the memory associated with the scatterlist
	entry. That may, or may not have the same value for the DMA engine,
	particularly if IOMMUs are involved.

	And if these drivers are used on ARM, they must be fixed, sooner rather
	than later.  There's patches in the works which will mean we will end up
	with IOMMU support in the DMA mapping later, which means everything I've
	said above will become reality.

The patch has been generated using the following coccinelle patch:
<smpl>
@@
struct scatterlist *sg;
@@
-sg_phys(sg)
+sg_dma_address(sg)
</smpl>

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>

---
Compile tested only
---
 drivers/dma/amba-pl08x.c    |    4 ++--
 drivers/dma/coh901318_lli.c |    4 ++--
 drivers/dma/dw_dmac.c       |    4 ++--
 drivers/dma/intel_mid_dma.c |    2 +-
 drivers/dma/pch_dma.c       |    2 +-
 5 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index e7d5550..003220a 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -1382,11 +1382,11 @@ static struct dma_async_tx_descriptor *pl08x_prep_slave_sg(
 
 		dsg->len = sg_dma_len(sg);
 		if (direction == DMA_MEM_TO_DEV) {
-			dsg->src_addr = sg_phys(sg);
+			dsg->src_addr = sg_dma_address(sg);
 			dsg->dst_addr = slave_addr;
 		} else {
 			dsg->src_addr = slave_addr;
-			dsg->dst_addr = sg_phys(sg);
+			dsg->dst_addr = sg_dma_address(sg);
 		}
 	}
 
diff --git a/drivers/dma/coh901318_lli.c b/drivers/dma/coh901318_lli.c
index 6c0e2d4..780e042 100644
--- a/drivers/dma/coh901318_lli.c
+++ b/drivers/dma/coh901318_lli.c
@@ -270,10 +270,10 @@ coh901318_lli_fill_sg(struct coh901318_pool *pool,
 
 		if (dir == DMA_MEM_TO_DEV)
 			/* increment source address */
-			src = sg_phys(sg);
+			src = sg_dma_address(sg);
 		else
 			/* increment destination address */
-			dst =  sg_phys(sg);
+			dst = sg_dma_address(sg);
 
 		bytes_to_transfer = sg_dma_len(sg);
 
diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 7439079..930076b 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -742,7 +742,7 @@ dwc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 			struct dw_desc	*desc;
 			u32		len, dlen, mem;
 
-			mem = sg_phys(sg);
+			mem = sg_dma_address(sg);
 			len = sg_dma_len(sg);
 
 			if (!((mem | len) & 7))
@@ -809,7 +809,7 @@ slave_sg_todev_fill_desc:
 			struct dw_desc	*desc;
 			u32		len, dlen, mem;
 
-			mem = sg_phys(sg);
+			mem = sg_dma_address(sg);
 			len = sg_dma_len(sg);
 
 			if (!((mem | len) & 7))
diff --git a/drivers/dma/intel_mid_dma.c b/drivers/dma/intel_mid_dma.c
index c900ca7..d0ef593 100644
--- a/drivers/dma/intel_mid_dma.c
+++ b/drivers/dma/intel_mid_dma.c
@@ -398,7 +398,7 @@ static int midc_lli_fill_sg(struct intel_mid_dma_chan *midc,
 							desc->width,
 							midc->dma->block_size);
 		/*Populate SAR and DAR values*/
-		sg_phy_addr = sg_phys(sg);
+		sg_phy_addr = sg_dma_address(sg);
 		if (desc->dirn ==  DMA_MEM_TO_DEV) {
 			lli_bloc_desc->sar  = sg_phy_addr;
 			lli_bloc_desc->dar  = mids->dma_slave.dst_addr;
diff --git a/drivers/dma/pch_dma.c b/drivers/dma/pch_dma.c
index 65c0495..987ab5c 100644
--- a/drivers/dma/pch_dma.c
+++ b/drivers/dma/pch_dma.c
@@ -621,7 +621,7 @@ static struct dma_async_tx_descriptor *pd_prep_slave_sg(struct dma_chan *chan,
 			goto err_desc_get;
 
 		desc->regs.dev_addr = reg;
-		desc->regs.mem_addr = sg_phys(sg);
+		desc->regs.mem_addr = sg_dma_address(sg);
 		desc->regs.size = sg_dma_len(sg);
 		desc->regs.next = DMA_DESC_FOLLOW_WITHOUT_IRQ;
 
-- 
1.7.9.5

