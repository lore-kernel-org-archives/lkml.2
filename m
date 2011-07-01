Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932133Ab1GAOsM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 10:48:12 -0400
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:37628 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756920Ab1GAOsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 10:48:07 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] dmaengine/coh901318: fix slave submission semantics
Date: Fri, 1 Jul 2011 16:47:28 +0200
Message-ID: <1309531648-16163-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

While testing Per Forlins MMC speed improvements I noticed a
semantic bug in the COH901318 driver: it will write to channel
registers in the prep_slave_sg() function, instead of deferring
it to later, breaking the assumption from the drivers to be able
to queue up new jobs while another job is running. Fix this by
storing up the initial register writes in the job descriptors
and write them to hardware when we process the descriptor
instead. Now the stress tests work.

Acked-by: Per Forlin <per.forlin@linaro.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/dma/coh901318.c |   19 ++++++++++++-------
 1 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/dma/coh901318.c b/drivers/dma/coh901318.c
index af8c0b5..a7fca16 100644
--- a/drivers/dma/coh901318.c
+++ b/drivers/dma/coh901318.c
@@ -40,6 +40,8 @@ struct coh901318_desc {
 	struct coh901318_lli *lli;
 	enum dma_data_direction dir;
 	unsigned long flags;
+	u32 head_config;
+	u32 head_ctrl;
 };
 
 struct coh901318_base {
@@ -660,6 +662,9 @@ static struct coh901318_desc *coh901318_queue_start(struct coh901318_chan *cohc)
 
 		coh901318_desc_submit(cohc, cohd);
 
+		/* Program the transaction head */
+		coh901318_set_conf(cohc, cohd->head_config);
+		coh901318_set_ctrl(cohc, cohd->head_ctrl);
 		coh901318_prep_linked_list(cohc, cohd->lli);
 
 		/* start dma job on this channel */
@@ -1090,8 +1095,6 @@ coh901318_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 	} else
 		goto err_direction;
 
-	coh901318_set_conf(cohc, config);
-
 	/* The dma only supports transmitting packages up to
 	 * MAX_DMA_PACKET_SIZE. Calculate to total number of
 	 * dma elemts required to send the entire sg list
@@ -1128,16 +1131,18 @@ coh901318_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 	if (ret)
 		goto err_lli_fill;
 
-	/*
-	 * Set the default ctrl for the channel to the one from the lli,
-	 * things may have changed due to odd buffer alignment etc.
-	 */
-	coh901318_set_ctrl(cohc, lli->control);
 
 	COH_DBG(coh901318_list_print(cohc, lli));
 
 	/* Pick a descriptor to handle this transfer */
 	cohd = coh901318_desc_get(cohc);
+	cohd->head_config = config;
+	/*
+	 * Set the default head ctrl for the channel to the one from the
+	 * lli, things may have changed due to odd buffer alignment
+	 * etc.
+	 */
+	cohd->head_ctrl = lli->control;
 	cohd->dir = direction;
 	cohd->flags = flags;
 	cohd->desc.tx_submit = coh901318_tx_submit;
-- 
1.7.3.2

