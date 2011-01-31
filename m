Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767Ab1AaL7q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 06:59:46 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53495 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755721Ab1AaL7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 06:59:42 -0500
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 2/5] dmaengine i.MX sdma: check sg entries for valid addresses and lengths
Date: Mon, 31 Jan 2011 12:59:29 +0100
Message-Id: <1296475172-23900-3-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1296475172-23900-1-git-send-email-s.hauer@pengutronix.de>
References: <1296475172-23900-1-git-send-email-s.hauer@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch lets sdma_prep_slave_sg fail if the entries of an
sg list do not start on multiples of the word size or if the
lengths are not multiple of the word size.
Also, catch the previously unhandled DMA_SLAVE_BUSWIDTH_8_BYTES
and DMA_SLAVE_BUSWIDTH_UNDEFINED cases.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/dma/imx-sdma.c |   20 +++++++++++++++++---
 1 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index c503050..8707723 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -925,10 +925,24 @@ static struct dma_async_tx_descriptor *sdma_prep_slave_sg(
 			ret =  -EINVAL;
 			goto err_out;
 		}
-		if (sdmac->word_size == DMA_SLAVE_BUSWIDTH_4_BYTES)
+
+		switch (sdmac->word_size) {
+		case DMA_SLAVE_BUSWIDTH_4_BYTES:
 			bd->mode.command = 0;
-		else
-			bd->mode.command = sdmac->word_size;
+			if (count & 3 || sg->dma_address & 3)
+				return NULL;
+			break;
+		case DMA_SLAVE_BUSWIDTH_2_BYTES:
+			bd->mode.command = 2;
+			if (count & 1 || sg->dma_address & 1)
+				return NULL;
+			break;
+		case DMA_SLAVE_BUSWIDTH_1_BYTE:
+			bd->mode.command = 1;
+			break;
+		default:
+			return NULL;
+		}
 
 		param = BD_DONE | BD_EXTD | BD_CONT;
 
-- 
1.7.2.3

