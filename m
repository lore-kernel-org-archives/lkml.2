Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441Ab3AIIRs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 03:17:48 -0500
Received: from mga03.intel.com ([143.182.124.21]:10943 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757417Ab3AIIRe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 03:17:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,436,1355126400"; 
   d="scan'208";a="189184472"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        spear-devel <spear-devel@list.st.com>
Subject: [resend][PATCH 14/16] dw_dmac: update tx_node_active in dwc_do_single_block
Date: Wed,  9 Jan 2013 10:17:13 +0200
Message-Id: <1357719435-29955-15-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357719435-29955-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <20130108155423.GJ19691@intel.com>
 <1357719435-29955-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "else" keyword in the dw_dma_tasklet is removed as well. All together
simplifies the logic of the code and understanding of what is happening there.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/dma/dw_dmac.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 05a8265..8afbda6 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -264,6 +264,9 @@ static inline void dwc_do_single_block(struct dw_dma_chan *dwc,
 	channel_writel(dwc, CTL_LO, ctllo);
 	channel_writel(dwc, CTL_HI, desc->lli.ctlhi);
 	channel_set_bit(dw, CH_EN, dwc->mask);
+
+	/* Move pointer to next descriptor */
+	dwc->tx_node_active = dwc->tx_node_active->next;
 }
 
 /* Called with dwc->lock held and bh disabled */
@@ -295,7 +298,7 @@ static void dwc_dostart(struct dw_dma_chan *dwc, struct dw_desc *first)
 		dwc_initialize(dwc);
 
 		dwc->tx_list = &first->tx_list;
-		dwc->tx_node_active = first->tx_list.next;
+		dwc->tx_node_active = &first->tx_list;
 
 		dwc_do_single_block(dwc, first);
 
@@ -621,18 +624,13 @@ static void dw_dma_tasklet(unsigned long data)
 
 					dma_writel(dw, CLEAR.XFER, dwc->mask);
 
-					/* move pointer to next descriptor */
-					dwc->tx_node_active =
-						dwc->tx_node_active->next;
-
 					dwc_do_single_block(dwc, desc);
 
 					spin_unlock_irqrestore(&dwc->lock, flags);
 					continue;
-				} else {
-					/* we are done here */
-					clear_bit(DW_DMA_IS_SOFT_LLP, &dwc->flags);
 				}
+				/* we are done here */
+				clear_bit(DW_DMA_IS_SOFT_LLP, &dwc->flags);
 			}
 			spin_unlock_irqrestore(&dwc->lock, flags);
 
-- 
1.7.10.4

