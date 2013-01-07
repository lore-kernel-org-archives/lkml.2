Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031Ab3AGLXR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 06:23:17 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:39447 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442Ab3AGLXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 06:23:16 -0500
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>, Linus Walleij <linus.walleij@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Narayanan <narayanan.gopalakrishnan@stericsson.com>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 01/16] dmaengine: ste_dma40: reset priority bit for logical channels
Date: Mon,  7 Jan 2013 12:21:43 +0100
Message-Id: <1357557718-15676-2-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1357557718-15676-1-git-send-email-fabio.baltieri@linaro.org>
References: <1357557718-15676-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Narayanan <narayanan.gopalakrishnan@stericsson.com>

This patch sets the SSCFG/SDCFG bit[7] PRI only for physical channel
requests with high priority.  For logical channels, this bit will be
zero.

Signed-off-by: Narayanan G <narayanan.gopalakrishnan@stericsson.com>
Reviewed-by: Rabin Vincent <rabin.vincent@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 drivers/dma/ste_dma40_ll.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/ste_dma40_ll.c b/drivers/dma/ste_dma40_ll.c
index 851ad56..d64b72a 100644
--- a/drivers/dma/ste_dma40_ll.c
+++ b/drivers/dma/ste_dma40_ll.c
@@ -102,17 +102,18 @@ void d40_phy_cfg(struct stedma40_chan_cfg *cfg,
 		src |= cfg->src_info.data_width << D40_SREG_CFG_ESIZE_POS;
 		dst |= cfg->dst_info.data_width << D40_SREG_CFG_ESIZE_POS;
 
+		/* Set the priority bit to high for the physical channel */
+		if (cfg->high_priority) {
+			src |= 1 << D40_SREG_CFG_PRI_POS;
+			dst |= 1 << D40_SREG_CFG_PRI_POS;
+		}
+
 	} else {
 		/* Logical channel */
 		dst |= 1 << D40_SREG_CFG_LOG_GIM_POS;
 		src |= 1 << D40_SREG_CFG_LOG_GIM_POS;
 	}
 
-	if (cfg->high_priority) {
-		src |= 1 << D40_SREG_CFG_PRI_POS;
-		dst |= 1 << D40_SREG_CFG_PRI_POS;
-	}
-
 	if (cfg->src_info.big_endian)
 		src |= 1 << D40_SREG_CFG_LBE_POS;
 	if (cfg->dst_info.big_endian)
-- 
1.7.12.1

