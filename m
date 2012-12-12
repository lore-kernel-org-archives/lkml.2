Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795Ab2LLJig (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 04:38:36 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:43882 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753622Ab2LLJie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 04:38:34 -0500
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Gerald Baeza <gerald.baeza@stericsson.com>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 7/7] dmaengine: ste_dma40: support fixed physical channel allocation
Date: Wed, 12 Dec 2012 10:37:21 +0100
Message-Id: <1355305041-2338-8-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1355305041-2338-1-git-send-email-fabio.baltieri@linaro.org>
References: <1355305041-2338-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gerald Baeza <gerald.baeza@stericsson.com>

This patch makes existing use_fixed_channel field (of stedma40_chan_cfg
structure) applicable to physical channels.

Signed-off-by: Gerald Baeza <gerald.baeza@stericsson.com>
Tested-by: Yannick Fertre <yannick.fertre@stericsson.com>
Reviewed-by: Per Forlin <per.forlin@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 drivers/dma/ste_dma40.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index f871df6..efe8be7 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1712,10 +1712,12 @@ static int d40_allocate_channel(struct d40_chan *d40c, bool *first_phy_user)
 	int i;
 	int j;
 	int log_num;
+	int num_phy_chans;
 	bool is_src;
 	bool is_log = d40c->dma_cfg.mode == STEDMA40_MODE_LOGICAL;
 
 	phys = d40c->base->phy_res;
+	num_phy_chans = d40c->base->num_phy_chans;
 
 	if (d40c->dma_cfg.dir == STEDMA40_PERIPH_TO_MEM) {
 		dev_type = d40c->dma_cfg.src_dev_type;
@@ -1736,12 +1738,19 @@ static int d40_allocate_channel(struct d40_chan *d40c, bool *first_phy_user)
 	if (!is_log) {
 		if (d40c->dma_cfg.dir == STEDMA40_MEM_TO_MEM) {
 			/* Find physical half channel */
-			for (i = 0; i < d40c->base->num_phy_chans; i++) {
-
+			if (d40c->dma_cfg.use_fixed_channel) {
+				i = d40c->dma_cfg.phy_channel;
 				if (d40_alloc_mask_set(&phys[i], is_src,
 						       0, is_log,
 						       first_phy_user))
 					goto found_phy;
+			} else {
+				for (i = 0; i < num_phy_chans; i++) {
+					if (d40_alloc_mask_set(&phys[i], is_src,
+						       0, is_log,
+						       first_phy_user))
+						goto found_phy;
+				}
 			}
 		} else
 			for (j = 0; j < d40c->base->num_phy_chans; j += 8) {
-- 
1.7.12.1

