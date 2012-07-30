Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040Ab2G3T3s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 15:29:48 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:60380 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754922Ab2G3T2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 15:28:33 -0400
Date: Mon, 30 Jul 2012 21:28:27 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: linux-sh@vger.kernel.org
cc: "Koul, Vinod" <vinod.koul@intel.com>, Paul Mundt <lethal@linux-sh.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] dmaengine: shdma: restore partial transfer calculation
In-Reply-To: <Pine.LNX.4.64.1207302114440.28003@axis700.grange>
Message-ID: <Pine.LNX.4.64.1207302119320.28003@axis700.grange>
References: <Pine.LNX.4.64.1207302114440.28003@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:c0WIoJ0n7I1ECtzfvkG/1L0/wa0nzMCO0A+P7f5p7Kr
 +g++qNPMqQ2iJ+mCiEvP6yxfnTO7AzAVEbcMqXeItUGUK411ng
 MUschkaPlpfBDuxSa1zjXSSzpdQKVyxVw6bE8kuJgcrF6rAX4j
 6S3XZu4VuMWJQflgGrwOKCsD75D78/C1x8SXoAZFoj5NVSMc6f
 pceJZtPFOrq3JrizkILh24u/kk3qnAVjiRQiJ46MQpS1HJGjEq
 J/jZVg1OFFWA+AA6b7ZE/ZRMvvK9T3UpNEcEAC0ynJxMrvjpfi
 bZWXcmtSVBNpezWgn3BXglX5oXXNu3Jqjtax4NIQ2QlqUvtR6z
 5GErnONDxGbFR5TzHEEHLXXzq+YiCTjPxG+0pfJdhxC/wfGtKj
 48TagLq1YqDPg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The recent shdma driver split has mistakenly removed support for partial
DMA transfer size calculation on forced termination. This patch restores
it.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/dma/sh/shdma-base.c |    9 +++++++++
 drivers/dma/sh/shdma.c      |   12 ++++++++++++
 include/linux/shdma-base.h  |    2 ++
 3 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/sh/shdma-base.c b/drivers/dma/sh/shdma-base.c
index 27f5c78..f4cd946 100644
--- a/drivers/dma/sh/shdma-base.c
+++ b/drivers/dma/sh/shdma-base.c
@@ -483,6 +483,7 @@ static struct shdma_desc *shdma_add_desc(struct shdma_chan *schan,
 	new->mark = DESC_PREPARED;
 	new->async_tx.flags = flags;
 	new->direction = direction;
+	new->partial = 0;
 
 	*len -= copy_size;
 	if (direction == DMA_MEM_TO_MEM || direction == DMA_MEM_TO_DEV)
@@ -644,6 +645,14 @@ static int shdma_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 	case DMA_TERMINATE_ALL:
 		spin_lock_irqsave(&schan->chan_lock, flags);
 		ops->halt_channel(schan);
+
+		if (ops->get_partial && !list_empty(&schan->ld_queue)) {
+			/* Record partial transfer */
+			struct shdma_desc *desc = list_first_entry(&schan->ld_queue,
+						struct shdma_desc, node);
+			desc->partial = ops->get_partial(schan, desc);
+		}
+
 		spin_unlock_irqrestore(&schan->chan_lock, flags);
 
 		shdma_chan_ld_cleanup(schan, true);
diff --git a/drivers/dma/sh/shdma.c b/drivers/dma/sh/shdma.c
index 027c9be..f41bcc5 100644
--- a/drivers/dma/sh/shdma.c
+++ b/drivers/dma/sh/shdma.c
@@ -381,6 +381,17 @@ static bool sh_dmae_chan_irq(struct shdma_chan *schan, int irq)
 	return true;
 }
 
+static size_t sh_dmae_get_partial(struct shdma_chan *schan,
+				  struct shdma_desc *sdesc)
+{
+	struct sh_dmae_chan *sh_chan = container_of(schan, struct sh_dmae_chan,
+						    shdma_chan);
+	struct sh_dmae_desc *sh_desc = container_of(sdesc,
+					struct sh_dmae_desc, shdma_desc);
+	return (sh_desc->hw.tcr - sh_dmae_readl(sh_chan, TCR)) <<
+		sh_chan->xmit_shift;
+}
+
 /* Called from error IRQ or NMI */
 static bool sh_dmae_reset(struct sh_dmae_device *shdev)
 {
@@ -632,6 +643,7 @@ static const struct shdma_ops sh_dmae_shdma_ops = {
 	.start_xfer = sh_dmae_start_xfer,
 	.embedded_desc = sh_dmae_embedded_desc,
 	.chan_irq = sh_dmae_chan_irq,
+	.get_partial = sh_dmae_get_partial,
 };
 
 static int __devinit sh_dmae_probe(struct platform_device *pdev)
diff --git a/include/linux/shdma-base.h b/include/linux/shdma-base.h
index 93f9821..a3728bf 100644
--- a/include/linux/shdma-base.h
+++ b/include/linux/shdma-base.h
@@ -50,6 +50,7 @@ struct shdma_desc {
 	struct list_head node;
 	struct dma_async_tx_descriptor async_tx;
 	enum dma_transfer_direction direction;
+	size_t partial;
 	dma_cookie_t cookie;
 	int chunks;
 	int mark;
@@ -98,6 +99,7 @@ struct shdma_ops {
 	void (*start_xfer)(struct shdma_chan *, struct shdma_desc *);
 	struct shdma_desc *(*embedded_desc)(void *, int);
 	bool (*chan_irq)(struct shdma_chan *, int);
+	size_t (*get_partial)(struct shdma_chan *, struct shdma_desc *);
 };
 
 struct shdma_dev {
-- 
1.7.2.5

