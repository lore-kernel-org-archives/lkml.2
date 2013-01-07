Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483Ab3AGB66 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 20:58:58 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:65299 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378Ab3AGB4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 20:56:30 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, nicolas.ferre@atmel.com,
        plagnioj@jcrosoft.com, richard.genoud@gmail.com, JM.Lin@atmel.com,
        wenyou.yang@atmel.com, grant.likely@secretlab.ca,
        spi-devel-general@lists.sourceforge.net
Subject: [v3 PATCH 03/12] spi/atmel_spi: status information passed through controller data
Date: Mon,  7 Jan 2013 09:50:04 +0800
Message-Id: <1357523413-27209-4-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1357523413-27209-1-git-send-email-wenyou.yang@atmel.com>
References: <1357523413-27209-1-git-send-email-wenyou.yang@atmel.com>
X-OriginalArrivalTime: 07 Jan 2013 01:56:12.0272 (UTC) FILETIME=[2B72C700:01CDEC7A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolas Ferre <nicolas.ferre@atmel.com>

The status of transfer is stored in controller data structure
so that it can be used not only by atmel_spi_msg_done() function.
This will be useful for upcoming dmaengine enabled driver.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: grant.likely@secretlab.ca
Cc: spi-devel-general@lists.sourceforge.net
---
 drivers/spi/spi-atmel.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/spi/spi-atmel.c b/drivers/spi/spi-atmel.c
index 9782206..687075e 100644
--- a/drivers/spi/spi-atmel.c
+++ b/drivers/spi/spi-atmel.c
@@ -202,6 +202,7 @@ struct atmel_spi {
 	unsigned long		current_remaining_bytes;
 	struct spi_transfer	*next_transfer;
 	unsigned long		next_remaining_bytes;
+	int			done_status;
 
 	void			*buffer;
 	dma_addr_t		buffer_dma;
@@ -545,15 +546,15 @@ static void atmel_spi_dma_unmap_xfer(struct spi_master *master,
 
 static void
 atmel_spi_msg_done(struct spi_master *master, struct atmel_spi *as,
-		struct spi_message *msg, int status, int stay)
+		struct spi_message *msg, int stay)
 {
-	if (!stay || status < 0)
+	if (!stay || as->done_status < 0)
 		cs_deactivate(as, msg->spi);
 	else
 		as->stay = msg->spi;
 
 	list_del(&msg->queue);
-	msg->status = status;
+	msg->status = as->done_status;
 
 	dev_dbg(master->dev.parent,
 		"xfer complete: %u bytes transferred\n",
@@ -565,6 +566,7 @@ atmel_spi_msg_done(struct spi_master *master, struct atmel_spi *as,
 
 	as->current_transfer = NULL;
 	as->next_transfer = NULL;
+	as->done_status = 0;
 
 	/* continue if needed */
 	if (list_empty(&as->queue) || as->stopping)
@@ -642,7 +644,8 @@ atmel_spi_interrupt(int irq, void *dev_id)
 		/* Clear any overrun happening while cleaning up */
 		spi_readl(as, SR);
 
-		atmel_spi_msg_done(master, as, msg, -EIO, 0);
+		as->done_status = -EIO;
+		atmel_spi_msg_done(master, as, msg, 0);
 	} else if (pending & (SPI_BIT(RXBUFF) | SPI_BIT(ENDRX))) {
 		ret = IRQ_HANDLED;
 
@@ -660,7 +663,7 @@ atmel_spi_interrupt(int irq, void *dev_id)
 
 			if (atmel_spi_xfer_is_last(msg, xfer)) {
 				/* report completed message */
-				atmel_spi_msg_done(master, as, msg, 0,
+				atmel_spi_msg_done(master, as, msg,
 						xfer->cs_change);
 			} else {
 				if (xfer->cs_change) {
-- 
1.7.9.5

