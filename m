Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539Ab2AKHzD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 02:55:03 -0500
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:40446
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752457Ab2AKHzA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 02:55:00 -0500
X-SpamScore: -11
X-BigFish: VS-11(zz542Mdf9M4015Lzz1202hzz8275bh8275dhz2dhc1ahc1bh2a8h668h839h8e2h8e3h945hbe9k)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Shi Xuelin-B29237 <B29237@freescale.com>
To: "iws@ovro.caltech.edu" <iws@ovro.caltech.edu>
CC: "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH]     fsldma: fix performance degradation by optimizing
 spinlock use.
Thread-Topic: [PATCH]     fsldma: fix performance degradation by optimizing
 spinlock use.
Thread-Index: AQHMw5qGc5XFHvvUIkC2vfg0WOM0aZYG5Iug
Date: Wed, 11 Jan 2012 07:54:55 +0000
Message-ID: <DBB740589CE8814680DECFE34BE197AB1665A3@039-SN1MPN1-006.039d.mgd.msft.net>
References: <1324879263-11845-1-git-send-email-b29237@freescale.com>
In-Reply-To: <1324879263-11845-1-git-send-email-b29237@freescale.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.208.103]
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Iris,

As we discussed in the previous patch, I add one smp_mb() in fsl_tx_status.
In my testing with iozone, this smp_mb() could cause 1%~2% performance degradation.
Anyway it is acceptable for me. Do you have any other comments?

Thanks,
Forrest

-----Original Message-----
From: Shi Xuelin-B29237 
Sent: 2011年12月26日 14:01
To: iws@ovro.caltech.edu; vinod.koul@intel.com; dan.j.williams@intel.com; linuxppc-dev@lists.ozlabs.org; linux-kernel@vger.kernel.org
Cc: Shi Xuelin-B29237
Subject: [PATCH] fsldma: fix performance degradation by optimizing spinlock use.

From: Forrest shi <b29237@freescale.com>

    dma status check function fsl_tx_status is heavily called in
    a tight loop and the desc lock in fsl_tx_status contended by
    the dma status update function. this caused the dma performance
    degrades much.

    this patch releases the lock in the fsl_tx_status function, and
    introduce the smp_mb() to avoid possible memory inconsistency.

    Signed-off-by: Forrest Shi <xuelin.shi@freescale.com>
---
 drivers/dma/fsldma.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c index 8a78154..008fb5e 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -986,15 +986,11 @@ static enum dma_status fsl_tx_status(struct dma_chan *dchan,
 	struct fsldma_chan *chan = to_fsl_chan(dchan);
 	dma_cookie_t last_complete;
 	dma_cookie_t last_used;
-	unsigned long flags;
-
-	spin_lock_irqsave(&chan->desc_lock, flags);
 
	last_complete = chan->completed_cookie;
+	smp_mb();
	last_used = dchan->cookie;
 
-	spin_unlock_irqrestore(&chan->desc_lock, flags);
-
 	dma_set_tx_state(txstate, last_complete, last_used, 0);
 	return dma_async_is_complete(cookie, last_complete, last_used); }
--
1.7.0.4


