Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758991Ab2GLMX7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 08:23:59 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:40018 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754701Ab2GLMX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 08:23:58 -0400
From: Roland Stigge <stigge@antcom.de>
To: linux-arm-kernel@lists.infradead.org, arnd@arndb.de,
        linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com, aletes.xgr@gmail.com,
        dwmw2@infradead.org, artem.bityutskiy@linux.intel.com,
        linux-mtd@lists.infradead.org
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH 1/2] mtd: lpc32xx_slc: Adjust to pl08x DMA interface changes
Date: Thu, 12 Jul 2012 14:22:56 +0200
Message-Id: <1342095778-13403-2-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1342095778-13403-1-git-send-email-stigge@antcom.de>
References: <1342095778-13403-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adjusts the LPC32xx SLC NAND driver to the new pl08x DMA interface,
fixing the compile error resulting from changed pl08x structures.

Signed-off-by: Roland Stigge <stigge@antcom.de>

---

Applies to today's linux-next (integrated lpc32xx-next and dma branches which collide)

 drivers/mtd/nand/lpc32xx_slc.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/mtd/nand/lpc32xx_slc.c b/drivers/mtd/nand/lpc32xx_slc.c
index 1719387..c8c1d06 100644
--- a/drivers/mtd/nand/lpc32xx_slc.c
+++ b/drivers/mtd/nand/lpc32xx_slc.c
@@ -714,17 +714,6 @@ static int lpc32xx_nand_write_page_raw_syndrome(struct mtd_info *mtd,
 	return 0;
 }
 
-static bool lpc32xx_dma_filter(struct dma_chan *chan, void *param)
-{
-	struct pl08x_dma_chan *ch =
-		container_of(chan, struct pl08x_dma_chan, chan);
-
-	/* In LPC32xx's PL080 DMA wiring, the SLC NAND DMA signal is #1 */
-	if (ch->cd->min_signal == 1)
-		return true;
-	return false;
-}
-
 static int lpc32xx_nand_dma_setup(struct lpc32xx_nand_host *host)
 {
 	struct mtd_info *mtd = &host->mtd;
@@ -732,7 +721,7 @@ static int lpc32xx_nand_dma_setup(struct lpc32xx_nand_host *host)
 
 	dma_cap_zero(mask);
 	dma_cap_set(DMA_SLAVE, mask);
-	host->dma_chan = dma_request_channel(mask, lpc32xx_dma_filter, NULL);
+	host->dma_chan = dma_request_channel(mask, pl08x_filter_id, "nand-slc");
 	if (!host->dma_chan) {
 		dev_err(mtd->dev.parent, "Failed to request DMA channel\n");
 		return -EBUSY;
-- 
1.7.10.4

