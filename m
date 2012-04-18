Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752533Ab2DRG1A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 02:27:00 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:42958 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab2DRG0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 02:26:30 -0400
From: Venkatraman S <svenkatr@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-mmc@vger.kernel.org>
CC: <arnd.bergmann@linaro.org>, <cjb@laptop.org>, <alex.limberg@sandisk.com>,
        <ilan.smith@sandisk.com>, <lporzio@micron.com>,
        Venkatraman S <svenkatr@ti.com>
Subject: [RFC PATCH 09/11] mmc: block: Detect HPI support in card and host controller
Date: Wed, 18 Apr 2012 11:55:30 +0530
Message-ID: <1334730332-22244-10-git-send-email-svenkatr@ti.com>
X-Mailer: git-send-email 1.7.10.rc2
In-Reply-To: <1334730332-22244-1-git-send-email-svenkatr@ti.com>
References: <1334730332-22244-1-git-send-email-svenkatr@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If both the card and host controller support HPI related
operations, set a flag in MMC queue to remember it.

Signed-off-by: Venkatraman S <svenkatr@ti.com>
---
 drivers/mmc/card/block.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index dabec55..11833e4 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -88,6 +88,7 @@ struct mmc_blk_data {
 	unsigned int	flags;
 #define MMC_BLK_CMD23	(1 << 0)	/* Can do SET_BLOCK_COUNT for multiblock */
 #define MMC_BLK_REL_WR	(1 << 1)	/* MMC Reliable write support */
+#define MMC_HPI_SUPPORT	(1 << 2)
 
 	unsigned int	usage;
 	unsigned int	read_only;
@@ -1548,12 +1549,15 @@ static struct mmc_blk_data *mmc_blk_alloc_req(struct mmc_card *card,
 			md->flags |= MMC_BLK_CMD23;
 	}
 
-	if (mmc_card_mmc(card) &&
-	    md->flags & MMC_BLK_CMD23 &&
+	if (mmc_card_mmc(card)) {
+		if (md->flags & MMC_BLK_CMD23 &&
 	    ((card->ext_csd.rel_param & EXT_CSD_WR_REL_PARAM_EN) ||
 	     card->ext_csd.rel_sectors)) {
-		md->flags |= MMC_BLK_REL_WR;
-		blk_queue_flush(md->queue.queue, REQ_FLUSH | REQ_FUA);
+			md->flags |= MMC_BLK_REL_WR;
+			blk_queue_flush(md->queue.queue, REQ_FLUSH | REQ_FUA);
+		}
+		if (card->host->ops->abort_req && card->ext_csd.hpi_en)
+			md->flags |= MMC_HPI_SUPPORT;
 	}
 
 	return md;
-- 
1.7.10.rc2

