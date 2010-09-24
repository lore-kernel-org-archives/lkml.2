Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758231Ab0IXWEW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 18:04:22 -0400
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:52431 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753705Ab0IXWEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 18:04:21 -0400
Date: Fri, 24 Sep 2010 15:04:19 -0700
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFCv1 1/2] dmaengine: add support for scatterlist to
 scatterlist transfers
Message-ID: <20100924220419.GC24654@ovro.caltech.edu>
References: <1285357571-23377-1-git-send-email-iws@ovro.caltech.edu>
 <1285357571-23377-2-git-send-email-iws@ovro.caltech.edu>
 <AANLkTimfZa+N51Tww_pWFqtqMmcYYkH_V0V_P1Qizt5b@mail.gmail.com>
 <20100924212443.GA24654@ovro.caltech.edu>
 <1285365194.21375.22.camel@dwillia2-linux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285365194.21375.22.camel@dwillia2-linux>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Fri, 24 Sep 2010 15:04:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 24, 2010 at 02:53:14PM -0700, Dan Williams wrote:
> On Fri, 2010-09-24 at 14:24 -0700, Ira W. Snyder wrote:
> > On Fri, Sep 24, 2010 at 01:40:56PM -0700, Dan Williams wrote:
> > > I don't think any dma channels gracefully handle descriptors that were
> > > prepped but not submitted.  You would probably need to submit the
> > > backlog, poll for completion, and then return the error.
> > > Alternatively, the expectation is that descriptor allocations are
> > > transient, i.e. once previously submitted transactions are completed
> > > the descriptors will return to the available pool.  So you could do
> > > what async_tx routines do and just poll for a descriptor.
> > >
> > 
> > Can you give me an example? Even some pseudocode would help.
> 
> Here is one from do_async_gen_syndrome() in crypto/async_tx/async_pq.c:
> 
>         /* Since we have clobbered the src_list we are committed
>          * to doing this asynchronously.  Drivers force forward
>          * progress in case they can not provide a descriptor
>          */
>         for (;;) {
>                 tx = dma->device_prep_dma_pq(chan, dma_dest,
>                                              &dma_src[src_off],
>                                              pq_src_cnt,
>                                              &coefs[src_off], len,
>                                              dma_flags);
>                 if (likely(tx))
>                         break;  
>                 async_tx_quiesce(&submit->depend_tx);
>                 dma_async_issue_pending(chan);
>         }       
> 
> > The other DMAEngine functions (dma_async_memcpy_*()) don't do anything
> > with the descriptor if submit fails. Take for example
> > dma_async_memcpy_buf_to_buf(). If tx->tx_submit(tx); fails, any code
> > using it has no way to return the descriptor to the free pool.
> > 
> > Does tx_submit() implicitly return descriptors to the free pool if it
> > fails?
> 
> No, submit() failures are a hold over from when the ioatdma driver used
> to perform additional descriptor allocation at ->submit() time.  After
> prep() the expectation is that the engine is just waiting to be told
> "go" and can't fail.  The only reason ->submit() retains a return code
> is to support the "cookie" based method for polling for operation
> completion.  A dma driver should handle all descriptor submission
> failure scenarios at prep time.
> 

Ok, that's more like what I expected. So we still need the try forever
code similar to the above. I can add that for the next version.

> > Ok, I thought the list was clearer, but this is equally easy. How about
> > the following change that does away with the list completely. Then
> > things should work on ioatdma as well.
> > 
> > From d59569ff48a89ef5411af3cf2995af7b742c5cd3 Mon Sep 17 00:00:00 2001
> > From: Ira W. Snyder <iws@ovro.caltech.edu>
> > Date: Fri, 24 Sep 2010 14:18:09 -0700
> > Subject: [PATCH] dma: improve scatterlist to scatterlist transfer
> > 
> > This is an improved algorithm to improve support on the Intel I/OAT
> > driver.
> > 
> > Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
> > ---
> >  drivers/dma/dmaengine.c   |   52 +++++++++++++++++++++-----------------------
> >  include/linux/dmaengine.h |    3 --
> >  2 files changed, 25 insertions(+), 30 deletions(-)
> > 
> > diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
> > index 57ec1e5..cde775c 100644
> > --- a/drivers/dma/dmaengine.c
> > +++ b/drivers/dma/dmaengine.c
> > @@ -983,10 +983,13 @@ dma_async_memcpy_sg_to_sg(struct dma_chan *chan,
> >         struct dma_async_tx_descriptor *tx;
> >         dma_cookie_t cookie = -ENOMEM;
> >         size_t dst_avail, src_avail;
> > -       struct list_head tx_list;
> > +       struct scatterlist *sg;
> >         size_t transferred = 0;
> > +       size_t dst_total = 0;
> > +       size_t src_total = 0;
> >         dma_addr_t dst, src;
> >         size_t len;
> > +       int i;
> > 
> >         if (dst_nents == 0 || src_nents == 0)
> >                 return -EINVAL;
> > @@ -994,12 +997,17 @@ dma_async_memcpy_sg_to_sg(struct dma_chan *chan,
> >         if (dst_sg == NULL || src_sg == NULL)
> >                 return -EINVAL;
> > 
> > +       /* get the total count of bytes in each scatterlist */
> > +       for_each_sg(dst_sg, sg, dst_nents, i)
> > +               dst_total += sg_dma_len(sg);
> > +
> > +       for_each_sg(src_sg, sg, src_nents, i)
> > +               src_total += sg_dma_len(sg);
> > +
> 
> What about overrun or underrun do we not care if src_total != dst_total?
> 
> Otherwise looks ok.
> 

I don't know if we should care about that. The algorithm handles that
case just fine. It copies the maximum amount it can, which is exactly
min(src_total, dst_total). Whichever scatterlist runs out of entries
first is the shortest.

As a real world example, my driver verifies that both scatterlists have
exactly the right number of bytes available before trying to program the
hardware.

Ira
