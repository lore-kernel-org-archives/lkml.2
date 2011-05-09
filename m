Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069Ab1EIHKT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 03:10:19 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:5061 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752717Ab1EIHKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 03:10:16 -0400
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
To: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH V3 3/6] pch_dma: Fix DMA setting issue
Date: Mon,  9 May 2011 16:09:37 +0900
Message-Id: <1304924980-3433-3-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1304924980-3433-1-git-send-email-tomoya-linux@dsn.okisemi.com>
References: <1304924980-3433-1-git-send-email-tomoya-linux@dsn.okisemi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, Direct-Start mode(*) is enabled.
Our IOH's devices must not use this mode.
This causes unexpected behavior.
This patch deletes Direct-Start setting.
(*) This mode is used in order for CPU to generate the DMA request.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
 drivers/dma/pch_dma.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/dma/pch_dma.c b/drivers/dma/pch_dma.c
index 0fa01e7..a755756 100644
--- a/drivers/dma/pch_dma.c
+++ b/drivers/dma/pch_dma.c
@@ -254,9 +254,6 @@ static bool pdc_is_idle(struct pch_dma_chan *pd_chan)
 
 static void pdc_dostart(struct pch_dma_chan *pd_chan, struct pch_dma_desc* desc)
 {
-	struct pch_dma *pd = to_pd(pd_chan->chan.device);
-	u32 val;
-
 	if (!pdc_is_idle(pd_chan)) {
 		dev_err(chan2dev(&pd_chan->chan),
 			"BUG: Attempt to start non-idle channel\n");
@@ -282,10 +279,6 @@ static void pdc_dostart(struct pch_dma_chan *pd_chan, struct pch_dma_desc* desc)
 		channel_writel(pd_chan, NEXT, desc->txd.phys);
 		pdc_set_mode(&pd_chan->chan, DMA_CTL0_SG);
 	}
-
-	val = dma_readl(pd, CTL2);
-	val |= 1 << (DMA_CTL2_START_SHIFT_BITS + pd_chan->chan.chan_id);
-	dma_writel(pd, CTL2, val);
 }
 
 static void pdc_chain_complete(struct pch_dma_chan *pd_chan,
-- 
1.7.4

