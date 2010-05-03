Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757177Ab0ECAzJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 May 2010 20:55:09 -0400
Received: from mail.df.lth.se ([194.47.250.12]:61484 "EHLO df.lth.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753867Ab0ECAy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 May 2010 20:54:59 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Marcin Mielczarczyk <marcin.mielczarczyk@tieto.com>,
       Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 3/7] DMAENGINE: DMA40 fix for allocation of logical channel 0
Date: Mon,  3 May 2010 02:54:54 +0200
Message-Id: <1272848094-28833-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.2.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcin Mielczarczyk <marcin.mielczarczyk@tieto.com>

Fix for allocation failure of logical channel when event line
happens to be number 0.

Signed-off-by: Marcin Mielczarczyk <marcin.mielczarczyk@tieto.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/dma/ste_dma40.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index ed1a05c..0ac6543 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1043,11 +1043,11 @@ static int d40_validate_conf(struct d40_chan *d40c,
 }
 
 static bool d40_alloc_mask_set(struct d40_phy_res *phy, bool is_src,
-			       int log_event_line)
+			       int log_event_line, bool is_log)
 {
 	unsigned long flags;
 	spin_lock_irqsave(&phy->lock, flags);
-	if (!log_event_line) {
+	if (!is_log) {
 		/* Physical interrupts are masked per physical full channel */
 		if (phy->allocated_src == D40_ALLOC_FREE &&
 		    phy->allocated_dst == D40_ALLOC_FREE) {
@@ -1165,15 +1165,16 @@ static int d40_allocate_channel(struct d40_chan *d40c)
 			/* Find physical half channel */
 			for (i = 0; i < d40c->base->num_phy_chans; i++) {
 
-				if (d40_alloc_mask_set(&phys[i], is_src, 0))
+				if (d40_alloc_mask_set(&phys[i], is_src,
+						       0, is_log))
 					goto found_phy;
 			}
 		} else
 			for (j = 0; j < d40c->base->num_phy_chans; j += 8) {
 				int phy_num = j  + event_group * 2;
 				for (i = phy_num; i < phy_num + 2; i++) {
-					if (d40_alloc_mask_set(&phys[i],
-							       is_src, 0))
+					if (d40_alloc_mask_set(&phys[i], is_src,
+							       0, is_log))
 						goto found_phy;
 				}
 			}
@@ -1197,13 +1198,13 @@ found_phy:
 		if (is_src) {
 			for (i = phy_num; i < phy_num + 2; i++) {
 				if (d40_alloc_mask_set(&phys[i], is_src,
-						       event_line))
+						       event_line, is_log))
 					goto found_log;
 			}
 		} else {
 			for (i = phy_num + 1; i >= phy_num; i--) {
 				if (d40_alloc_mask_set(&phys[i], is_src,
-						       event_line))
+						       event_line, is_log))
 					goto found_log;
 			}
 		}
-- 
1.6.3.3

