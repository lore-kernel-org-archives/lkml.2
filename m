Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672Ab1EFQtn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 12:49:43 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:52765 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756619Ab1EFQtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 12:49:41 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: vinod.koul@intel.com, dan.j.williams@intel.com,
        linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH v2 3/3] dmaengine: at_hdmac: use descriptor chaining help function
Date: Fri,  6 May 2011 19:56:53 +0200
Message-Id: <f2d2fb135151456f81dd3ac1938771589a0e5503.1304704588.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <f4341d4672a23a958398b75cb4305e0e680f2e32.1304532833.git.nicolas.ferre@atmel.com>
References: <f4341d4672a23a958398b75cb4305e0e680f2e32.1304532833.git.nicolas.ferre@atmel.com>
In-Reply-To: <f4341d4672a23a958398b75cb4305e0e680f2e32.1304704588.git.nicolas.ferre@atmel.com>
References: <f4341d4672a23a958398b75cb4305e0e680f2e32.1304704588.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A little function helps to chain descriptors:
it is already used in cyclic dma operations, now use it in memcpy and slave_sg
preparation functions.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/dma/at_hdmac.c |   33 +++------------------------------
 1 files changed, 3 insertions(+), 30 deletions(-)

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index 5968245..2c6bc3a 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -626,16 +626,7 @@ atc_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
 
 		desc->txd.cookie = 0;
 
-		if (!first) {
-			first = desc;
-		} else {
-			/* inform the HW lli about chaining */
-			prev->lli.dscr = desc->txd.phys;
-			/* insert the link descriptor to the LD ring */
-			list_add_tail(&desc->desc_node,
-					&first->tx_list);
-		}
-		prev = desc;
+		atc_desc_chain(&first, &prev, desc);
 	}
 
 	/* First descriptor of the chain embedds additional information */
@@ -726,16 +717,7 @@ atc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 					| len >> mem_width;
 			desc->lli.ctrlb = ctrlb;
 
-			if (!first) {
-				first = desc;
-			} else {
-				/* inform the HW lli about chaining */
-				prev->lli.dscr = desc->txd.phys;
-				/* insert the link descriptor to the LD ring */
-				list_add_tail(&desc->desc_node,
-						&first->tx_list);
-			}
-			prev = desc;
+			atc_desc_chain(&first, &prev, desc);
 			total_len += len;
 		}
 		break;
@@ -769,16 +751,7 @@ atc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 					| len >> reg_width;
 			desc->lli.ctrlb = ctrlb;
 
-			if (!first) {
-				first = desc;
-			} else {
-				/* inform the HW lli about chaining */
-				prev->lli.dscr = desc->txd.phys;
-				/* insert the link descriptor to the LD ring */
-				list_add_tail(&desc->desc_node,
-						&first->tx_list);
-			}
-			prev = desc;
+			atc_desc_chain(&first, &prev, desc);
 			total_len += len;
 		}
 		break;
-- 
1.7.3

