Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757205Ab0IXVYr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 17:24:47 -0400
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:33392 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833Ab0IXVYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 17:24:46 -0400
Date: Fri, 24 Sep 2010 14:24:43 -0700
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH RFCv1 1/2] dmaengine: add support for scatterlist to
 scatterlist transfers
Message-ID: <20100924212443.GA24654@ovro.caltech.edu>
References: <1285357571-23377-1-git-send-email-iws@ovro.caltech.edu>
 <1285357571-23377-2-git-send-email-iws@ovro.caltech.edu>
 <AANLkTimfZa+N51Tww_pWFqtqMmcYYkH_V0V_P1Qizt5b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimfZa+N51Tww_pWFqtqMmcYYkH_V0V_P1Qizt5b@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Fri, 24 Sep 2010 14:24:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 24, 2010 at 01:40:56PM -0700, Dan Williams wrote:
> On Fri, Sep 24, 2010 at 12:46 PM, Ira W. Snyder <iws@ovro.caltech.edu> wrote:
> > This adds support for scatterlist to scatterlist DMA transfers. As
> > requested by Dan, this is hidden behind an ifdef so that it can be
> > selected by the drivers that need it.
> >
> > Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
> > ---
> >  drivers/dma/Kconfig       |    4 ++
> >  drivers/dma/dmaengine.c   |  119 +++++++++++++++++++++++++++++++++++++++++++++
> >  include/linux/dmaengine.h |   10 ++++
> >  3 files changed, 133 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
> > index 9520cf0..f688669 100644
> > --- a/drivers/dma/Kconfig
> > +++ b/drivers/dma/Kconfig
> > @@ -89,10 +89,14 @@ config AT_HDMAC
> >          Support the Atmel AHB DMA controller.  This can be integrated in
> >          chips such as the Atmel AT91SAM9RL.
> >
> > +config DMAENGINE_SG_TO_SG
> > +       bool
> > +
> >  config FSL_DMA
> >        tristate "Freescale Elo and Elo Plus DMA support"
> >        depends on FSL_SOC
> >        select DMA_ENGINE
> > +       select DMAENGINE_SG_TO_SG
> >        ---help---
> >          Enable support for the Freescale Elo and Elo Plus DMA controllers.
> >          The Elo is the DMA controller on some 82xx and 83xx parts, and the
> > diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
> > index 9d31d5e..57ec1e5 100644
> > --- a/drivers/dma/dmaengine.c
> > +++ b/drivers/dma/dmaengine.c
> > @@ -972,10 +972,129 @@ dma_async_memcpy_pg_to_pg(struct dma_chan *chan, struct page *dest_pg,
> >  }
> >  EXPORT_SYMBOL(dma_async_memcpy_pg_to_pg);
> >
> > +#ifdef CONFIG_DMAENGINE_SG_TO_SG
> > +dma_cookie_t
> > +dma_async_memcpy_sg_to_sg(struct dma_chan *chan,
> > +                         struct scatterlist *dst_sg, unsigned int dst_nents,
> > +                         struct scatterlist *src_sg, unsigned int src_nents,
> > +                         dma_async_tx_callback cb, void *cb_param)
> > +{
> > +       struct dma_device *dev = chan->device;
> > +       struct dma_async_tx_descriptor *tx;
> > +       dma_cookie_t cookie = -ENOMEM;
> > +       size_t dst_avail, src_avail;
> > +       struct list_head tx_list;
> > +       size_t transferred = 0;
> > +       dma_addr_t dst, src;
> > +       size_t len;
> > +
> > +       if (dst_nents == 0 || src_nents == 0)
> > +               return -EINVAL;
> > +
> > +       if (dst_sg == NULL || src_sg == NULL)
> > +               return -EINVAL;
> > +
> > +       /* get prepared for the loop */
> > +       dst_avail = sg_dma_len(dst_sg);
> > +       src_avail = sg_dma_len(src_sg);
> > +
> > +       INIT_LIST_HEAD(&tx_list);
> > +
> > +       /* run until we are out of descriptors */
> > +       while (true) {
> > +
> > +               /* create the largest transaction possible */
> > +               len = min_t(size_t, src_avail, dst_avail);
> > +               if (len == 0)
> > +                       goto fetch;
> > +
> > +               dst = sg_dma_address(dst_sg) + sg_dma_len(dst_sg) - dst_avail;
> > +               src = sg_dma_address(src_sg) + sg_dma_len(src_sg) - src_avail;
> > +
> > +               /* setup the transaction */
> > +               tx = dev->device_prep_dma_memcpy(chan, dst, src, len, 0);
> > +               if (!tx) {
> > +                       dev_err(dev->dev, "failed to alloc desc for memcpy\n");
> > +                       return -ENOMEM;
> 
> I don't think any dma channels gracefully handle descriptors that were
> prepped but not submitted.  You would probably need to submit the
> backlog, poll for completion, and then return the error.
> Alternatively, the expectation is that descriptor allocations are
> transient, i.e. once previously submitted transactions are completed
> the descriptors will return to the available pool.  So you could do
> what async_tx routines do and just poll for a descriptor.
> 

Can you give me an example? Even some pseudocode would help.

The other DMAEngine functions (dma_async_memcpy_*()) don't do anything
with the descriptor if submit fails. Take for example
dma_async_memcpy_buf_to_buf(). If tx->tx_submit(tx); fails, any code
using it has no way to return the descriptor to the free pool.

Does tx_submit() implicitly return descriptors to the free pool if it
fails?

> > +               }
> > +
> > +               /* keep track of the tx for later */
> > +               list_add_tail(&tx->entry, &tx_list);
> > +
> > +               /* update metadata */
> > +               transferred += len;
> > +               dst_avail -= len;
> > +               src_avail -= len;
> > +
> > +fetch:
> > +               /* fetch the next dst scatterlist entry */
> > +               if (dst_avail == 0) {
> > +
> > +                       /* no more entries: we're done */
> > +                       if (dst_nents == 0)
> > +                               break;
> > +
> > +                       /* fetch the next entry: if there are no more: done */
> > +                       dst_sg = sg_next(dst_sg);
> > +                       if (dst_sg == NULL)
> > +                               break;
> > +
> > +                       dst_nents--;
> > +                       dst_avail = sg_dma_len(dst_sg);
> > +               }
> > +
> > +               /* fetch the next src scatterlist entry */
> > +               if (src_avail == 0) {
> > +
> > +                       /* no more entries: we're done */
> > +                       if (src_nents == 0)
> > +                               break;
> > +
> > +                       /* fetch the next entry: if there are no more: done */
> > +                       src_sg = sg_next(src_sg);
> > +                       if (src_sg == NULL)
> > +                               break;
> > +
> > +                       src_nents--;
> > +                       src_avail = sg_dma_len(src_sg);
> > +               }
> > +       }
> > +
> > +       /* loop through the list of descriptors and submit them */
> > +       list_for_each_entry(tx, &tx_list, entry) {
> > +
> > +               /* this is the last descriptor: add the callback */
> > +               if (list_is_last(&tx->entry, &tx_list)) {
> > +                       tx->callback = cb;
> > +                       tx->callback_param = cb_param;
> > +               }
> > +
> > +               /* submit the transaction */
> > +               cookie = tx->tx_submit(tx);
> 
> Some dma drivers cannot tolerate prep being reordered with respect to
> submit (ioatdma enforces this ordering by locking in prep and
> unlocking in submit).  In general those channels can be identified by
> ones that select CONFIG_ASYNC_TX_DISABLE_CHANNEL_SWITCH.  However this
> opt-out arrangement is awkward so I'll put together a patch to make it
> opt-in (CONFIG_ASYNC_TX_CHANNEL_SWITCH).
> 
> The end implication for this patch is that CONFIG_DMAENGINE_SG_TO_SG
> can only be supported by those channels that are also prepared to
> handle channel switching i.e. can tolerate intervening calls to prep()
> before the eventual submit().
> 
> [snip]
> 

I found it difficult to detect when we were at the last descriptor
unless I did this in two steps. This is why I have two loops: one for
prep and another for submit.

How about the change inlined at the end of the email. Following your
description, I think it should work on the ioatdma driver, since it
handles prep and submit right next to each other.

> > diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
> > index c61d4ca..5507f4c 100644
> > --- a/include/linux/dmaengine.h
> > +++ b/include/linux/dmaengine.h
> > @@ -24,6 +24,7 @@
> >  #include <linux/device.h>
> >  #include <linux/uio.h>
> >  #include <linux/dma-mapping.h>
> > +#include <linux/list.h>
> >
> >  /**
> >  * typedef dma_cookie_t - an opaque DMA cookie
> > @@ -316,6 +317,9 @@ struct dma_async_tx_descriptor {
> >        dma_cookie_t (*tx_submit)(struct dma_async_tx_descriptor *tx);
> >        dma_async_tx_callback callback;
> >        void *callback_param;
> > +#ifdef CONFIG_DMAENGINE_SG_TO_SG
> > +       struct list_head entry;
> > +#endif
> >  #ifndef CONFIG_ASYNC_TX_DISABLE_CHANNEL_SWITCH
> >        struct dma_async_tx_descriptor *next;
> >        struct dma_async_tx_descriptor *parent;
> 
> Per the above comment if we are already depending on channel switch
> being enabled for sg-to-sg operation, then you can just use the 'next'
> pointer to have a singly linked list of descriptors.  Rather than
> increase the size of the base descriptor.
> 

Ok, I thought the list was clearer, but this is equally easy. How about
the following change that does away with the list completely. Then
things should work on ioatdma as well.

>From d59569ff48a89ef5411af3cf2995af7b742c5cd3 Mon Sep 17 00:00:00 2001
From: Ira W. Snyder <iws@ovro.caltech.edu>
Date: Fri, 24 Sep 2010 14:18:09 -0700
Subject: [PATCH] dma: improve scatterlist to scatterlist transfer

This is an improved algorithm to improve support on the Intel I/OAT
driver.

Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
---
 drivers/dma/dmaengine.c   |   52 +++++++++++++++++++++-----------------------
 include/linux/dmaengine.h |    3 --
 2 files changed, 25 insertions(+), 30 deletions(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 57ec1e5..cde775c 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -983,10 +983,13 @@ dma_async_memcpy_sg_to_sg(struct dma_chan *chan,
 	struct dma_async_tx_descriptor *tx;
 	dma_cookie_t cookie = -ENOMEM;
 	size_t dst_avail, src_avail;
-	struct list_head tx_list;
+	struct scatterlist *sg;
 	size_t transferred = 0;
+	size_t dst_total = 0;
+	size_t src_total = 0;
 	dma_addr_t dst, src;
 	size_t len;
+	int i;
 
 	if (dst_nents == 0 || src_nents == 0)
 		return -EINVAL;
@@ -994,12 +997,17 @@ dma_async_memcpy_sg_to_sg(struct dma_chan *chan,
 	if (dst_sg == NULL || src_sg == NULL)
 		return -EINVAL;
 
+	/* get the total count of bytes in each scatterlist */
+	for_each_sg(dst_sg, sg, dst_nents, i)
+		dst_total += sg_dma_len(sg);
+
+	for_each_sg(src_sg, sg, src_nents, i)
+		src_total += sg_dma_len(sg);
+
 	/* get prepared for the loop */
 	dst_avail = sg_dma_len(dst_sg);
 	src_avail = sg_dma_len(src_sg);
 
-	INIT_LIST_HEAD(&tx_list);
-
 	/* run until we are out of descriptors */
 	while (true) {
 
@@ -1018,14 +1026,24 @@ dma_async_memcpy_sg_to_sg(struct dma_chan *chan,
 			return -ENOMEM;
 		}
 
-		/* keep track of the tx for later */
-		list_add_tail(&tx->entry, &tx_list);
-
 		/* update metadata */
 		transferred += len;
 		dst_avail -= len;
 		src_avail -= len;
 
+		/* if this is the last transfer, setup the callback */
+		if (dst_total == transferred || src_total == transferred) {
+			tx->callback = cb;
+			tx->callback_param = cb_param;
+		}
+
+		/* submit the transaction */
+		cookie = tx->tx_submit(tx);
+		if (dma_submit_error(cookie)) {
+			dev_err(dev->dev, "failed to submit desc\n");
+			return cookie;
+		}
+
 fetch:
 		/* fetch the next dst scatterlist entry */
 		if (dst_avail == 0) {
@@ -1060,30 +1078,13 @@ fetch:
 		}
 	}
 
-	/* loop through the list of descriptors and submit them */
-	list_for_each_entry(tx, &tx_list, entry) {
-
-		/* this is the last descriptor: add the callback */
-		if (list_is_last(&tx->entry, &tx_list)) {
-			tx->callback = cb;
-			tx->callback_param = cb_param;
-		}
-
-		/* submit the transaction */
-		cookie = tx->tx_submit(tx);
-		if (dma_submit_error(cookie)) {
-			dev_err(dev->dev, "failed to submit desc\n");
-			return cookie;
-		}
-	}
-
 	/* update counters */
 	preempt_disable();
 	__this_cpu_add(chan->local->bytes_transferred, transferred);
 	__this_cpu_inc(chan->local->memcpy_count);
 	preempt_enable();
 
-	return cookie;
+	return 0;
 }
 EXPORT_SYMBOL(dma_async_memcpy_sg_to_sg);
 #endif
@@ -1092,9 +1093,6 @@ void dma_async_tx_descriptor_init(struct dma_async_tx_descriptor *tx,
 	struct dma_chan *chan)
 {
 	tx->chan = chan;
-	#ifdef CONFIG_DMAENGINE_SG_TO_SG
-	INIT_LIST_HEAD(&tx->entry);
-	#endif
 	#ifndef CONFIG_ASYNC_TX_DISABLE_CHANNEL_SWITCH
 	spin_lock_init(&tx->lock);
 	#endif
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 5507f4c..26f2712 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -317,9 +317,6 @@ struct dma_async_tx_descriptor {
 	dma_cookie_t (*tx_submit)(struct dma_async_tx_descriptor *tx);
 	dma_async_tx_callback callback;
 	void *callback_param;
-#ifdef CONFIG_DMAENGINE_SG_TO_SG
-	struct list_head entry;
-#endif
 #ifndef CONFIG_ASYNC_TX_DISABLE_CHANNEL_SWITCH
 	struct dma_async_tx_descriptor *next;
 	struct dma_async_tx_descriptor *parent;
-- 
1.7.1

