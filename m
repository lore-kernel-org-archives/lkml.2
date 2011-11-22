Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116Ab1KVGK6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 01:10:58 -0500
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:3498
	"EHLO DB3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753515Ab1KVGK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 01:10:57 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bhz2dh2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: <b29237@freescale.com>
To: <dan.j.williams@intel.com>, <leoli@freescale.com>, <zw@zh-kernel.org>,
        <vinod.koul@intel.com>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        Forrest Shi <b29237@freescale.com>
Subject: [PATCH][RFC]     fsldma: fix performance degradation by optimizing spinlock use.
Date: Tue, 22 Nov 2011 12:55:05 +0800
Message-ID: <1321937705-19587-1-git-send-email-b29237@freescale.com>
X-Mailer: git-send-email 1.6.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Forrest Shi <b29237@freescale.com>

    dma status check function fsl_tx_status is heavily called in
    a tight loop and the desc lock in fsl_tx_status contended by
    the dma status update function. this caused the dma performance
    degrades much.

    this patch releases the lock in the fsl_tx_status function.
    I believe it has no neglect impact on the following call of
    dma_async_is_complete(...).

    we can see below three conditions will be identified as success
    a)  x < complete < use
    b)  x < complete+N < use+N
    c)  x < complete < use+N
    here complete is the completed_cookie, use is the last_used
    cookie, x is the querying cookie, N is MAX cookie

    when chan->completed_cookie is being read, the last_used may
    be incresed. Anyway it has no neglect impact on the dma status
    decision.

    Signed-off-by: Forrest Shi <xuelin.shi@freescale.com>
---
 drivers/dma/fsldma.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index 8a78154..1dca56f 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -986,15 +986,10 @@ static enum dma_status fsl_tx_status(struct dma_chan *dchan,
 	struct fsldma_chan *chan = to_fsl_chan(dchan);
 	dma_cookie_t last_complete;
 	dma_cookie_t last_used;
-	unsigned long flags;
-
-	spin_lock_irqsave(&chan->desc_lock, flags);
 
 	last_complete = chan->completed_cookie;
 	last_used = dchan->cookie;
 
-	spin_unlock_irqrestore(&chan->desc_lock, flags);
-
 	dma_set_tx_state(txstate, last_complete, last_used, 0);
 	return dma_async_is_complete(cookie, last_complete, last_used);
 }
-- 
1.7.0.4


