Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317Ab3AGLYW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 06:24:22 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:57979 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754145Ab3AGLYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 06:24:19 -0500
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>, Linus Walleij <linus.walleij@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Gerald Baeza <gerald.baeza@stericsson.com>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 07/16] dmaengine: ste_dma40: support fixed physical channel allocation
Date: Mon,  7 Jan 2013 12:21:49 +0100
Message-Id: <1357557718-15676-8-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1357557718-15676-1-git-send-email-fabio.baltieri@linaro.org>
References: <1357557718-15676-1-git-send-email-fabio.baltieri@linaro.org>
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
index 9f8964a..5feab7db9 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1711,10 +1711,12 @@ static int d40_allocate_channel(struct d40_chan *d40c, bool *first_phy_user)
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
@@ -1735,12 +1737,19 @@ static int d40_allocate_channel(struct d40_chan *d40c, bool *first_phy_user)
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

