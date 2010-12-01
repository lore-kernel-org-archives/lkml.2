Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab0LAKuZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 05:50:25 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:28141 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751361Ab0LAKuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 05:50:23 -0500
Message-ID: <4CF6284C.1010802@dsn.okisemi.com>
Date: Wed, 01 Dec 2010 19:49:48 +0900
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; ja; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org
CC: kok.howg.ewe@intel.com, "Wang Qi\"" <qi.wang@intel.com>,
        "Wang Yong Y\"" <yong.y.wang@intel.com>,
        "Intel OTC\"" <joel.clark@intel.com>, margie.foster@intel.com,
        "Andrew\"" <andrew.chih.howe.khor@intel.com>
Subject: [PATCH] dma : EG20T PCH: Fix miss-setting DMA descriptor
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>



Currently, in case of using scatter/gather mode, head of data is not sent to

destination. The cause is second descriptor address is set to NEXT.

The NEXT must have head of descriptor address.

This patch sets head of descriptor address to the NEXT.



Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
 drivers/dma/pch_dma.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/dma/pch_dma.c b/drivers/dma/pch_dma.c
index 92b6790..a3d54c0 100644
--- a/drivers/dma/pch_dma.c
+++ b/drivers/dma/pch_dma.c
@@ -259,11 +259,6 @@ static void pdc_dostart(struct pch_dma_chan *pd_chan, struct pch_dma_desc* desc)
 		return;
 	}
 
-	channel_writel(pd_chan, DEV_ADDR, desc->regs.dev_addr);
-	channel_writel(pd_chan, MEM_ADDR, desc->regs.mem_addr);
-	channel_writel(pd_chan, SIZE, desc->regs.size);
-	channel_writel(pd_chan, NEXT, desc->regs.next);
-
 	dev_dbg(chan2dev(&pd_chan->chan), "chan %d -> dev_addr: %x\n",
 		pd_chan->chan.chan_id, desc->regs.dev_addr);
 	dev_dbg(chan2dev(&pd_chan->chan), "chan %d -> mem_addr: %x\n",
@@ -273,10 +268,16 @@ static void pdc_dostart(struct pch_dma_chan *pd_chan, struct pch_dma_desc* desc)
 	dev_dbg(chan2dev(&pd_chan->chan), "chan %d -> next: %x\n",
 		pd_chan->chan.chan_id, desc->regs.next);
 
-	if (list_empty(&desc->tx_list))
+	if (list_empty(&desc->tx_list)) {
+		channel_writel(pd_chan, DEV_ADDR, desc->regs.dev_addr);
+		channel_writel(pd_chan, MEM_ADDR, desc->regs.mem_addr);
+		channel_writel(pd_chan, SIZE, desc->regs.size);
+		channel_writel(pd_chan, NEXT, desc->regs.next);
 		pdc_set_mode(&pd_chan->chan, DMA_CTL0_ONESHOT);
-	else
+	} else {
+		channel_writel(pd_chan, NEXT, virt_to_phys(&desc->regs));
 		pdc_set_mode(&pd_chan->chan, DMA_CTL0_SG);
+	}
 
 	val = dma_readl(pd, CTL2);
 	val |= 1 << (DMA_CTL2_START_SHIFT_BITS + pd_chan->chan.chan_id);
-- 
1.6.0.6

