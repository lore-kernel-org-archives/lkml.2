Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400Ab2LLJiQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 04:38:16 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:54443 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865Ab2LLJiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 04:38:13 -0500
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Narayanan G <narayanan.gopalakrishnan@stericsson.com>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 1/7] dmaengine: ste_dma40: reset priority bit for logical channels
Date: Wed, 12 Dec 2012 10:37:15 +0100
Message-Id: <1355305041-2338-2-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1355305041-2338-1-git-send-email-fabio.baltieri@linaro.org>
References: <1355305041-2338-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Narayanan G <narayanan.gopalakrishnan@stericsson.com>

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
index cad9e1d..536e848 100644
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

