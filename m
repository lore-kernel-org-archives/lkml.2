Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994Ab2IMNl0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 09:41:26 -0400
Received: from na3sys009aog128.obsmtp.com ([74.125.149.141]:46799 "EHLO
	na3sys009aog128.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753539Ab2IMNh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 09:37:56 -0400
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
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v2 05/15] dmaengine: omap-dma: Add support for no_wakeup in cyclic mode
Date: Thu, 13 Sep 2012 16:37:55 +0300
Message-Id: <1347543485-339-6-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1347543485-339-1-git-send-email-peter.ujfalusi@ti.com>
References: <1347543485-339-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When requested disable all DMA interrupts for the channel. In this mode
user space does not expect periodic reports from kernel about the progress
of the audio stream - PulseAudio for example support this type of mode.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
CC: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/dma/omap-dma.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/omap-dma.c b/drivers/dma/omap-dma.c
index c6a711d..cbe087e 100644
--- a/drivers/dma/omap-dma.c
+++ b/drivers/dma/omap-dma.c
@@ -374,6 +374,7 @@ static struct dma_async_tx_descriptor *omap_dma_prep_dma_cyclic(
 	struct omap_desc *d;
 	dma_addr_t dev_addr;
 	unsigned es, sync_type;
+	unsigned long tx_flags = 0;
 	u32 burst;
 
 	if (dir == DMA_DEV_TO_MEM) {
@@ -429,7 +430,11 @@ static struct dma_async_tx_descriptor *omap_dma_prep_dma_cyclic(
 	if (!c->cyclic) {
 		c->cyclic = true;
 		omap_dma_link_lch(c->dma_ch, c->dma_ch);
-		omap_enable_dma_irq(c->dma_ch, OMAP_DMA_FRAME_IRQ);
+
+		if (!no_wakeup) {
+			omap_enable_dma_irq(c->dma_ch, OMAP_DMA_FRAME_IRQ);
+			tx_flags = DMA_CTRL_ACK | DMA_PREP_INTERRUPT;
+		}
 		omap_disable_dma_irq(c->dma_ch, OMAP_DMA_BLOCK_IRQ);
 	}
 
@@ -438,7 +443,7 @@ static struct dma_async_tx_descriptor *omap_dma_prep_dma_cyclic(
 		omap_set_dma_dest_burst_mode(c->dma_ch, OMAP_DMA_DATA_BURST_16);
 	}
 
-	return vchan_tx_prep(&c->vc, &d->vd, DMA_CTRL_ACK | DMA_PREP_INTERRUPT);
+	return vchan_tx_prep(&c->vc, &d->vd, tx_flags);
 }
 
 static int omap_dma_slave_config(struct omap_chan *c, struct dma_slave_config *cfg)
-- 
1.7.12

