Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758361Ab0IXWx7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 18:53:59 -0400
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:52333 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756789Ab0IXWx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 18:53:58 -0400
Date: Fri, 24 Sep 2010 15:53:53 -0700
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: Dan Williams <dan.j.williams@intel.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFCv1 1/2] dmaengine: add support for scatterlist to
 scatterlist transfers
Message-ID: <20100924225352.GD24654@ovro.caltech.edu>
References: <1285357571-23377-1-git-send-email-iws@ovro.caltech.edu>
 <1285357571-23377-2-git-send-email-iws@ovro.caltech.edu>
 <AANLkTimfZa+N51Tww_pWFqtqMmcYYkH_V0V_P1Qizt5b@mail.gmail.com>
 <20100924212443.GA24654@ovro.caltech.edu>
 <1285365194.21375.22.camel@dwillia2-linux>
 <20100924220419.GC24654@ovro.caltech.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100924220419.GC24654@ovro.caltech.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Fri, 24 Sep 2010 15:53:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 24, 2010 at 03:04:19PM -0700, Ira W. Snyder wrote:
> On Fri, Sep 24, 2010 at 02:53:14PM -0700, Dan Williams wrote:
> > On Fri, 2010-09-24 at 14:24 -0700, Ira W. Snyder wrote:
> > > On Fri, Sep 24, 2010 at 01:40:56PM -0700, Dan Williams wrote:
> > > > I don't think any dma channels gracefully handle descriptors that were
> > > > prepped but not submitted.  You would probably need to submit the
> > > > backlog, poll for completion, and then return the error.
> > > > Alternatively, the expectation is that descriptor allocations are
> > > > transient, i.e. once previously submitted transactions are completed
> > > > the descriptors will return to the available pool.  So you could do
> > > > what async_tx routines do and just poll for a descriptor.
> > > >
> > > 
> > > Can you give me an example? Even some pseudocode would help.
> > 
> > Here is one from do_async_gen_syndrome() in crypto/async_tx/async_pq.c:
> > 
> >         /* Since we have clobbered the src_list we are committed
> >          * to doing this asynchronously.  Drivers force forward
> >          * progress in case they can not provide a descriptor
> >          */
> >         for (;;) {
> >                 tx = dma->device_prep_dma_pq(chan, dma_dest,
> >                                              &dma_src[src_off],
> >                                              pq_src_cnt,
> >                                              &coefs[src_off], len,
> >                                              dma_flags);
> >                 if (likely(tx))
> >                         break;  
> >                 async_tx_quiesce(&submit->depend_tx);
> >                 dma_async_issue_pending(chan);
> >         }       
> > 
> > > The other DMAEngine functions (dma_async_memcpy_*()) don't do anything
> > > with the descriptor if submit fails. Take for example
> > > dma_async_memcpy_buf_to_buf(). If tx->tx_submit(tx); fails, any code
> > > using it has no way to return the descriptor to the free pool.
> > > 
> > > Does tx_submit() implicitly return descriptors to the free pool if it
> > > fails?
> > 
> > No, submit() failures are a hold over from when the ioatdma driver used
> > to perform additional descriptor allocation at ->submit() time.  After
> > prep() the expectation is that the engine is just waiting to be told
> > "go" and can't fail.  The only reason ->submit() retains a return code
> > is to support the "cookie" based method for polling for operation
> > completion.  A dma driver should handle all descriptor submission
> > failure scenarios at prep time.
> > 
> 
> Ok, that's more like what I expected. So we still need the try forever
> code similar to the above. I can add that for the next version.
> 

When coding this change, I've noticed one problem that would break my
driver. I cannot issue dma_async_issue_pending() on the channel while
creating the descriptors, since this will start transferring the
previously submitted DMA descriptors. This breaks the external hardware
control requirement.

Imagine this scenario:
1) device is not yet setup for external control (nothing is pulsing the pins)
2) dma_async_memcpy_sg_to_sg()

- this hits an allocation failure, which calls dma_async_issue_pending()
- this causes the DMA engine to start transferring to a device which is
  not ready yet
- memory pressure stops, and allocation succeeds again
- some descriptors have been transferred, but not the ones since the
  alloc failure
- now the first half of the descriptors (pre alloc failure) have been
  transferred
- the second half of the descriptors (post alloc failure) are still
  pending
- the dma_async_memcpy_sg_to_sg() returns success: all tx_submit()
  succeeded

3) device_control() - setup external control mode
4) dma_async_issue_pending() - start the externally controlled transfer
5) tell the external agent to start controlling the DMA transaction

- now there isn't enough data left, and the external agent fails to
  program the FPGAs

I don't mind adding it to the code, since I have enough memory that I
don't ever see allocation failures. It is an embedded system, and we've
been careful not to overcommit memory. I think for all other users, it
would be the appropriate thing to do. Most people don't care if the
scatterlist is copied in two chunks with a time gap in the middle.

An alternative implementation would be to implement
device_prep_sg_to_sg() that returned a struct dma_async_tx_descriptor,
which could then be used as normal by higher layers. This would allow
the driver to allocate / cleanup all descriptors in one shot. This would
be completely robust to this error situation.

Is there one solution you'd prefer over the other? They're both similar
in the amount of code, though duplication would probably be increased in
the device_prep_sg_to_sg() case. If any other driver implements it.

Thanks,
Ira
