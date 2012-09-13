Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420Ab2IMNht (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 09:37:49 -0400
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:53763 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752657Ab2IMNho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 09:37:44 -0400
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
Subject: [PATCH v2 02/15] dmaengine: omap: Add support for pause/resume in cyclic dma mode
Date: Thu, 13 Sep 2012 16:37:52 +0300
Message-Id: <1347543485-339-3-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1347543485-339-1-git-send-email-peter.ujfalusi@ti.com>
References: <1347543485-339-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The audio stack used omap_stop_dma/omap_start_dma to pause/resume the DMA.
This method has been used for years on OMAP based products.
We only allow pause/resume when the DMA has been configured in cyclic mode
which is used by the audio stack.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
CC: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/dma/omap-dma.c | 30 +++++++++++++++++++++++++-----
 1 file changed, 25 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/omap-dma.c b/drivers/dma/omap-dma.c
index b77a40d..71d7869 100644
--- a/drivers/dma/omap-dma.c
+++ b/drivers/dma/omap-dma.c
@@ -34,6 +34,7 @@ struct omap_chan {
 	struct dma_slave_config	cfg;
 	unsigned dma_sig;
 	bool cyclic;
+	bool paused;
 
 	int dma_ch;
 	struct omap_desc *desc;
@@ -470,11 +471,14 @@ static int omap_dma_terminate_all(struct omap_chan *c)
 	 */
 	if (c->desc) {
 		c->desc = NULL;
-		omap_stop_dma(c->dma_ch);
+		/* Avoid stopping the dma twice */
+		if (!c->paused)
+			omap_stop_dma(c->dma_ch);
 	}
 
 	if (c->cyclic) {
 		c->cyclic = false;
+		c->paused = false;
 		omap_dma_unlink_lch(c->dma_ch, c->dma_ch);
 	}
 
@@ -487,14 +491,30 @@ static int omap_dma_terminate_all(struct omap_chan *c)
 
 static int omap_dma_pause(struct omap_chan *c)
 {
-	/* FIXME: not supported by platform private API */
-	return -EINVAL;
+	/* Pause/Resume only allowed with cyclic mode */
+	if (!c->cyclic)
+		return -EINVAL;
+
+	if (!c->paused) {
+		omap_stop_dma(c->dma_ch);
+		c->paused = true;
+	}
+
+	return 0;
 }
 
 static int omap_dma_resume(struct omap_chan *c)
 {
-	/* FIXME: not supported by platform private API */
-	return -EINVAL;
+	/* Pause/Resume only allowed with cyclic mode */
+	if (!c->cyclic)
+		return -EINVAL;
+
+	if (c->paused) {
+		omap_start_dma(c->dma_ch);
+		c->paused = false;
+	}
+
+	return 0;
 }
 
 static int omap_dma_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
-- 
1.7.12

