Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673Ab0C0AVG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 20:21:06 -0400
Received: from mga14.intel.com ([143.182.124.37]:35480 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752077Ab0C0AVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 20:21:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,317,1267430400"; 
   d="scan'208";a="259307177"
Subject: Re: [PATCH 2/2] DMAENGINE: generic channel status v2
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Sosnowski, Maciej" <maciej.sosnowski@intel.com>,
       Nicolas Ferre <nicolas.ferre@atmel.com>, Pavel Machek <pavel@ucw.cz>,
       Li Yang <leoli@freescale.com>, Paul Mundt <lethal@linux-sh.org>,
       Ralf Baechle <ralf@linux-mips.org>,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Magnus Damm <damm@opensource.se>, Liam Girdwood <lrg@slimlogic.co.uk>,
       Joe Perches <joe@perches.com>, Roland Dreier <rdreier@cisco.com>,
       Richard =?ISO-8859-1?Q?R=F6jfors?= 
	<richard.rojfors@pelagicore.com>,
       "Steven J. Magnani" <steve@digidescorp.com>
In-Reply-To: <1269613211-12673-1-git-send-email-linus.walleij@stericsson.com>
References: <1269613211-12673-1-git-send-email-linus.walleij@stericsson.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Mar 2010 17:17:19 -0700
Message-ID: <1269649039.23499.15.camel@dwillia2-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-03-26 at 07:20 -0700, Linus Walleij wrote:
> Convert the device_is_tx_complete() operation on the
> DMA engine to a generic device_tx_status()operation which
> can return three states, DMA_TX_RUNNING, DMA_TX_COMPLETE,
> DMA_TX_PAUSED.
> 

Ok, this one and the previous both look good to me.  I fixed them up for
the new timberdale driver, and added the patch below.  They pass
build_dma.sh without issue, so I'll get them pushed out to my next
branch.

Sidenote: one thing I notice via this exercise is that not every driver
is triggering a descriptor cleanup in their device_tx_status()
implementation.  It's really only needed for the drivers that will
service requests from the async_tx api (now the minority), but something
to keep in mind.  In some cases async_tx polls for completion on
descriptor allocation failure, so either ->device_tx_status() or
->device_prep* needs to run descriptor reclaim.

Thanks,
Dan

---

dmaengine: provide helper for setting txstate

From: Dan Williams <dan.j.williams@intel.com>

Simple conditional struct filler to cut out some duplicated code.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 drivers/dma/at_hdmac.c      |    7 +------
 drivers/dma/coh901318.c     |    8 ++------
 drivers/dma/dw_dmac.c       |    6 +-----
 drivers/dma/fsldma.c        |    6 +-----
 drivers/dma/ioat/dma.h      |    6 +-----
 drivers/dma/iop-adma.c      |   15 ++-------------
 drivers/dma/ipu/ipu_idmac.c |    6 +-----
 drivers/dma/mpc512x_dma.c   |    7 +------
 drivers/dma/mv_xor.c        |   13 ++-----------
 drivers/dma/ppc4xx/adma.c   |   12 ++----------
 drivers/dma/shdma.c         |    7 +------
 drivers/dma/timb_dma.c      |    6 +-----
 drivers/dma/txx9dmac.c      |    6 +-----
 include/linux/dmaengine.h   |   10 ++++++++++
 14 files changed, 27 insertions(+), 88 deletions(-)


diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index ff75cf1..93ed99c 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -834,12 +834,7 @@ atc_tx_status(struct dma_chan *chan,
 
 	spin_unlock_bh(&atchan->lock);
 
-	if (txstate) {
-		txstate->last = last_complete;
-		txstate->used = last_used;
-		txstate->residue = 0;
-	}
-
+	dma_set_tx_state(txstate, last_complete, last_used, 0);
 	dev_vdbg(chan2dev(chan), "tx_status: %d (d%d, u%d)\n",
 		 cookie, last_complete ? last_complete : 0,
 		 last_used ? last_used : 0);
diff --git a/drivers/dma/coh901318.c b/drivers/dma/coh901318.c
index 309db3b..4233440 100644
--- a/drivers/dma/coh901318.c
+++ b/drivers/dma/coh901318.c
@@ -1147,12 +1147,8 @@ coh901318_tx_status(struct dma_chan *chan, dma_cookie_t cookie,
 
 	ret = dma_async_is_complete(cookie, last_complete, last_used);
 
-	if (txstate) {
-		txstate->last = last_complete;
-		txstate->used = last_used;
-		txstate->residue = coh901318_get_bytes_left(chan);
-	}
-
+	dma_set_tx_state(txstate, last_complete, last_used,
+			 coh901318_get_bytes_left(chan));
 	if (ret == DMA_IN_PROGRESS && cohc->stopped)
 		ret = DMA_PAUSED;
 
diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 263b70e..18fb5b4 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -841,11 +841,7 @@ dwc_tx_status(struct dma_chan *chan,
 		ret = dma_async_is_complete(cookie, last_complete, last_used);
 	}
 
-	if (txstate) {
-		txstate->last = last_complete;
-		txstate->used = last_used;
-		txstate->residue = 0;
-	}
+	dma_set_tx_state(txstate, last_complete, last_used, 0);
 
 	return ret;
 }
diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index ca5e8a3..cb1924f 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -987,11 +987,7 @@ static enum dma_status fsl_tx_status(struct dma_chan *dchan,
 	last_used = dchan->cookie;
 	last_complete = chan->completed_cookie;
 
-	if (txstate) {
-		txstate->last = last_complete;
-		txstate->used = last_used;
-		txstate->residue = 0;
-	}
+	dma_set_tx_state(txstate, last_complete, last_used, 0);
 
 	return dma_async_is_complete(cookie, last_complete, last_used);
 }
diff --git a/drivers/dma/ioat/dma.h b/drivers/dma/ioat/dma.h
index 2339967..26f48ef 100644
--- a/drivers/dma/ioat/dma.h
+++ b/drivers/dma/ioat/dma.h
@@ -158,11 +158,7 @@ ioat_tx_status(struct dma_chan *c, dma_cookie_t cookie,
 	last_used = c->cookie;
 	last_complete = chan->completed_cookie;
 
-	if (txstate) {
-		txstate->last = last_complete;
-		txstate->used = last_used;
-		txstate->residue = 0;
-	}
+	dma_set_tx_state(txstate, last_complete, last_used, 0);
 
 	return dma_async_is_complete(cookie, last_complete, last_used);
 }
diff --git a/drivers/dma/iop-adma.c b/drivers/dma/iop-adma.c
index ee40dbb..e5d4b97 100644
--- a/drivers/dma/iop-adma.c
+++ b/drivers/dma/iop-adma.c
@@ -909,13 +909,7 @@ static enum dma_status iop_adma_status(struct dma_chan *chan,
 
 	last_used = chan->cookie;
 	last_complete = iop_chan->completed_cookie;
-
-	if (txstate) {
-		txstate->last = last_complete;
-		txstate->used = last_used;
-		txstate->residue = 0;
-	}
-
+	dma_set_tx_state(txstate, last_complete, last_used, 0);
 	ret = dma_async_is_complete(cookie, last_complete, last_used);
 	if (ret == DMA_SUCCESS)
 		return ret;
@@ -924,12 +918,7 @@ static enum dma_status iop_adma_status(struct dma_chan *chan,
 
 	last_used = chan->cookie;
 	last_complete = iop_chan->completed_cookie;
-
-	if (txstate) {
-		txstate->last = last_complete;
-		txstate->used = last_used;
-		txstate->residue = 0;
-	}
+	dma_set_tx_state(txstate, last_complete, last_used, 0);
 
 	return dma_async_is_complete(cookie, last_complete, last_used);
 }
diff --git a/drivers/dma/ipu/ipu_idmac.c b/drivers/dma/ipu/ipu_idmac.c
index b9cef8b..246a614 100644
--- a/drivers/dma/ipu/ipu_idmac.c
+++ b/drivers/dma/ipu/ipu_idmac.c
@@ -1651,11 +1651,7 @@ static enum dma_status idmac_tx_status(struct dma_chan *chan,
 {
 	struct idmac_channel *ichan = to_idmac_chan(chan);
 
-	if (txstate) {
-		txstate->last = ichan->completed;
-		txstate->used = chan->cookie;
-		txstate->residue = 0;
-	}
+	dma_set_tx_state(txstate, ichan->completed, chan->cookie, 0);
 	if (cookie != chan->cookie)
 		return DMA_ERROR;
 	return DMA_SUCCESS;
diff --git a/drivers/dma/mpc512x_dma.c b/drivers/dma/mpc512x_dma.c
index cb3a8e9..7a750b9 100644
--- a/drivers/dma/mpc512x_dma.c
+++ b/drivers/dma/mpc512x_dma.c
@@ -553,12 +553,7 @@ mpc_dma_tx_status(struct dma_chan *chan, dma_cookie_t cookie,
 	last_complete = mchan->completed_cookie;
 	spin_unlock_irqrestore(&mchan->lock, flags);
 
-	if (txstate) {
-		txstate->last = last_complete;
-		txstate->used = last_used;
-		txstate->residue = 0;
-	}
-
+	dma_set_tx_state(txstate, last_complete, last_used, 0);
 	return dma_async_is_complete(cookie, last_complete, last_used);
 }
 
diff --git a/drivers/dma/mv_xor.c b/drivers/dma/mv_xor.c
index 79fb1de..4b8c1fc 100644
--- a/drivers/dma/mv_xor.c
+++ b/drivers/dma/mv_xor.c
@@ -826,11 +826,7 @@ static enum dma_status mv_xor_status(struct dma_chan *chan,
 	last_used = chan->cookie;
 	last_complete = mv_chan->completed_cookie;
 	mv_chan->is_complete_cookie = cookie;
-	if (txstate) {
-		txstate->last = last_complete;
-		txstate->used = last_used;
-		txstate->residue = 0;
-	}
+	dma_set_tx_state(txstate, last_complete, last_used, 0);
 
 	ret = dma_async_is_complete(cookie, last_complete, last_used);
 	if (ret == DMA_SUCCESS) {
@@ -842,12 +838,7 @@ static enum dma_status mv_xor_status(struct dma_chan *chan,
 	last_used = chan->cookie;
 	last_complete = mv_chan->completed_cookie;
 
-	if (txstate) {
-		txstate->last = last_complete;
-		txstate->used = last_used;
-		txstate->residue = 0;
-	}
-
+	dma_set_tx_state(txstate, last_complete, last_used, 0);
 	return dma_async_is_complete(cookie, last_complete, last_used);
 }
 
diff --git a/drivers/dma/ppc4xx/adma.c b/drivers/dma/ppc4xx/adma.c
index d9a54c0..5558419 100644
--- a/drivers/dma/ppc4xx/adma.c
+++ b/drivers/dma/ppc4xx/adma.c
@@ -3951,11 +3951,7 @@ static enum dma_status ppc440spe_adma_tx_status(struct dma_chan *chan,
 	last_used = chan->cookie;
 	last_complete = ppc440spe_chan->completed_cookie;
 
-	if (txstate) {
-		txstate->last = last_complete;
-		txstate->used = last_used;
-		txstate->residue = 0;
-	}
+	dma_set_tx_state(txstate, last_complete, last_used, 0);
 
 	ret = dma_async_is_complete(cookie, last_complete, last_used);
 	if (ret == DMA_SUCCESS)
@@ -3966,11 +3962,7 @@ static enum dma_status ppc440spe_adma_tx_status(struct dma_chan *chan,
 	last_used = chan->cookie;
 	last_complete = ppc440spe_chan->completed_cookie;
 
-	if (txstate) {
-		txstate->last = last_complete;
-		txstate->used = last_used;
-		txstate->residue = 0;
-	}
+	dma_set_tx_state(txstate, last_complete, last_used, 0);
 
 	return dma_async_is_complete(cookie, last_complete, last_used);
 }
diff --git a/drivers/dma/shdma.c b/drivers/dma/shdma.c
index 8aeda9c..98f82cd 100644
--- a/drivers/dma/shdma.c
+++ b/drivers/dma/shdma.c
@@ -752,12 +752,7 @@ static enum dma_status sh_dmae_tx_status(struct dma_chan *chan,
 	last_used = chan->cookie;
 	last_complete = sh_chan->completed_cookie;
 	BUG_ON(last_complete < 0);
-
-	if (txstate) {
-		txstate->last = last_complete;
-		txstate->used = last_used;
-		txstate->residue = 0;
-	}
+	dma_set_tx_state(txstate, last_complete, last_used, 0);
 
 	spin_lock_bh(&sh_chan->desc_lock);
 
diff --git a/drivers/dma/timb_dma.c b/drivers/dma/timb_dma.c
index 8fc2881..e20d5c1 100644
--- a/drivers/dma/timb_dma.c
+++ b/drivers/dma/timb_dma.c
@@ -527,11 +527,7 @@ static enum dma_status td_tx_status(struct dma_chan *chan, dma_cookie_t cookie,
 
 	ret = dma_async_is_complete(cookie, last_complete, last_used);
 
-	if (txstate) {
-		txstate->last = last_complete;
-		txstate->used = last_used;
-		txstate->residue = 0;
-	}
+	dma_set_tx_state(txstate, last_complete, last_used, 0);
 
 	dev_dbg(chan2dev(chan),
 		"%s: exit, ret: %d, last_complete: %d, last_used: %d\n",
diff --git a/drivers/dma/txx9dmac.c b/drivers/dma/txx9dmac.c
index a44e422..e523737 100644
--- a/drivers/dma/txx9dmac.c
+++ b/drivers/dma/txx9dmac.c
@@ -990,11 +990,7 @@ txx9dmac_tx_status(struct dma_chan *chan, dma_cookie_t cookie,
 		ret = dma_async_is_complete(cookie, last_complete, last_used);
 	}
 
-	if (txstate) {
-		txstate->last = last_complete;
-		txstate->used = last_used;
-		txstate->residue = 0;
-	}
+	dma_set_tx_state(txstate, last_complete, last_used, 0);
 
 	return ret;
 }
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 55b08e8..50b7b3e 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -628,6 +628,16 @@ static inline enum dma_status dma_async_is_complete(dma_cookie_t cookie,
 	return DMA_IN_PROGRESS;
 }
 
+static inline void
+dma_set_tx_state(struct dma_tx_state *st, dma_cookie_t last, dma_cookie_t used, u32 residue)
+{
+	if (st) {
+		st->last = last;
+		st->used = used;
+		st->residue = residue;
+	}
+}
+
 enum dma_status dma_sync_wait(struct dma_chan *chan, dma_cookie_t cookie);
 #ifdef CONFIG_DMA_ENGINE
 enum dma_status dma_wait_for_async_tx(struct dma_async_tx_descriptor *tx);



