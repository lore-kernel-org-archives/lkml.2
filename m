Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346Ab1K2DTJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 22:19:09 -0500
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:19962
	"EHLO VA3EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752095Ab1K2DTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 22:19:08 -0500
X-SpamScore: -18
X-BigFish: VS-18(zzc89bh542M1432N98dK4015Lzz1202hzz8275bh8275dhz2dh2a8h668h839h8e2h8e3h93fh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Li Yang-R58472 <r58472@freescale.com>
To: "Ira W. Snyder" <iws@ovro.caltech.edu>,
        Shi Xuelin-B29237 <B29237@freescale.com>
CC: "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH][RFC] fsldma: fix performance degradation by optimizing
 spinlock use.
Thread-Topic: [PATCH][RFC] fsldma: fix performance degradation by optimizing
 spinlock use.
Thread-Index: AQHMqUjeyxVKMMi4pUOHPPVw43Ku8JW8E5yAgAbWp4CAAELQUA==
Date: Tue, 29 Nov 2011 03:19:05 +0000
Message-ID: <3F607A5180246847A760FD34122A1E052E07B7@039-SN1MPN1-003.039d.mgd.msft.net>
References: <1321937705-19587-1-git-send-email-b29237@freescale.com>
 <20111122185924.GA23323@ovro.caltech.edu>
 <DBB740589CE8814680DECFE34BE197AB148CDD@039-SN1MPN1-006.039d.mgd.msft.net>
 <20111128163814.GA10919@ovro.caltech.edu>
In-Reply-To: <20111128163814.GA10919@ovro.caltech.edu>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.208.68]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pAT3JUT8004279

> Subject: Re: [PATCH][RFC] fsldma: fix performance degradation by optimizing
> spinlock use.
> 
> On Thu, Nov 24, 2011 at 08:12:25AM +0000, Shi Xuelin-B29237 wrote:
> > Hi Ira,
> >
> > Thanks for your review.
> >
> > After second thought, I think your scenario may not occur.
> > Because the cookie 20 we query must be returned by fsl_dma_tx_submit(...) in
> practice.
> > We never query a cookie not returned by fsl_dma_tx_submit(...).
> >
> 
> I agree about this part.
> 
> > When we call fsl_tx_status(20), the chan->common.cookie is definitely wrote as
> 20 and cpu2 could not read as 19.
> >
> 
> This is what I don't agree about. However, I'm not an expert on CPU cache vs.
> memory accesses in an multi-processor system. The section titled "CACHE
> COHERENCY" in Documentation/memory-barriers.txt leads me to believe that the
> scenario I described is possible.

For Freescale PowerPC, the chip automatically takes care of cache coherency.  Even if this is a concern, spinlock can't address it.

> 
> What happens if CPU1's write of chan->common.cookie only goes into CPU1's
> cache. It never makes it to main memory before CPU2 fetches the old value of 19.
> 
> I don't think you should see any performance impact from the smp_mb()
> operation.

Smp_mb() do have impact on performance if it's in the hot path.  While it might be safer having it, I doubt it is really necessary.  If the CPU1 doesn't have the updated last_used, it's shouldn't have known there is a cookie 20 existed either.

- Leo

> 
> Thanks,
> Ira
> 
> > -----Original Message-----
> > From: Ira W. Snyder [mailto:iws@ovro.caltech.edu]
> > Sent: 2011å¹´11æœˆ23æ—¥ 2:59
> > To: Shi Xuelin-B29237
> > Cc: dan.j.williams@intel.com; Li Yang-R58472; zw@zh-kernel.org;
> > vinod.koul@intel.com; linuxppc-dev@lists.ozlabs.org;
> > linux-kernel@vger.kernel.org
> > Subject: Re: [PATCH][RFC] fsldma: fix performance degradation by optimizing
> spinlock use.
> >
> > On Tue, Nov 22, 2011 at 12:55:05PM +0800, b29237@freescale.com wrote:
> > > From: Forrest Shi <b29237@freescale.com>
> > >
> > >     dma status check function fsl_tx_status is heavily called in
> > >     a tight loop and the desc lock in fsl_tx_status contended by
> > >     the dma status update function. this caused the dma performance
> > >     degrades much.
> > >
> > >     this patch releases the lock in the fsl_tx_status function.
> > >     I believe it has no neglect impact on the following call of
> > >     dma_async_is_complete(...).
> > >
> > >     we can see below three conditions will be identified as success
> > >     a)  x < complete < use
> > >     b)  x < complete+N < use+N
> > >     c)  x < complete < use+N
> > >     here complete is the completed_cookie, use is the last_used
> > >     cookie, x is the querying cookie, N is MAX cookie
> > >
> > >     when chan->completed_cookie is being read, the last_used may
> > >     be incresed. Anyway it has no neglect impact on the dma status
> > >     decision.
> > >
> > >     Signed-off-by: Forrest Shi <xuelin.shi@freescale.com>
> > > ---
> > >  drivers/dma/fsldma.c |    5 -----
> > >  1 files changed, 0 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c index
> > > 8a78154..1dca56f 100644
> > > --- a/drivers/dma/fsldma.c
> > > +++ b/drivers/dma/fsldma.c
> > > @@ -986,15 +986,10 @@ static enum dma_status fsl_tx_status(struct
> dma_chan *dchan,
> > >  	struct fsldma_chan *chan = to_fsl_chan(dchan);
> > >  	dma_cookie_t last_complete;
> > >  	dma_cookie_t last_used;
> > > -	unsigned long flags;
> > > -
> > > -	spin_lock_irqsave(&chan->desc_lock, flags);
> > >
> >
> > This will cause a bug. See below for a detailed explanation. You need this instead:
> >
> > 	/*
> > 	 * On an SMP system, we must ensure that this CPU has seen the
> > 	 * memory accesses performed by another CPU under the
> > 	 * chan->desc_lock spinlock.
> > 	 */
> > 	smp_mb();
> > >  	last_complete = chan->completed_cookie;
> > >  	last_used = dchan->cookie;
> > >
> > > -	spin_unlock_irqrestore(&chan->desc_lock, flags);
> > > -
> > >  	dma_set_tx_state(txstate, last_complete, last_used, 0);
> > >  	return dma_async_is_complete(cookie, last_complete, last_used);  }
> >
> > Facts:
> > - dchan->cookie is the same member as chan->common.cookie (same memory
> > location)
> > - chan->common.cookie is the "last allocated cookie for a pending transaction"
> > - chan->completed_cookie is the "last completed transaction"
> >
> > I have replaced "dchan->cookie" with "chan->common.cookie" in the below
> explanation, to keep everything referenced from the same structure.
> >
> > Variable usage before your change. Everything is used locked.
> > - RW chan->common.cookie		(fsl_dma_tx_submit)
> > - R  chan->common.cookie		(fsl_tx_status)
> > - R  chan->completed_cookie		(fsl_tx_status)
> > - W  chan->completed_cookie		(dma_do_tasklet)
> >
> > Variable usage after your change:
> > - RW chan->common.cookie		LOCKED
> > - R  chan->common.cookie		NO LOCK
> > - R  chan->completed_cookie		NO LOCK
> > - W  chan->completed_cookie             LOCKED
> >
> > What if we assume that you have a 2 CPU system (such as a P2020). After your
> changes, one possible sequence is:
> >
> > === CPU1 - allocate + submit descriptor: fsl_dma_tx_submit() ===
> > spin_lock_irqsave
> > descriptor->cookie = 20		(x in your example)
> > chan->common.cookie = 20	(used in your example)
> > spin_unlock_irqrestore
> >
> > === CPU2 - immediately calls fsl_tx_status() ===
> > chan->common.cookie == 19
> > chan->completed_cookie == 19
> > descriptor->cookie == 20
> >
> > Since we don't have locks anymore, CPU2 may not have seen the write to
> > chan->common.cookie yet.
> >
> > Also assume that the DMA hardware has not started processing the
> > transaction yet. Therefore dma_do_tasklet() has not been called, and
> > chan->completed_cookie has not been updated.
> >
> > In this case, dma_async_is_complete() (on CPU2) returns DMA_SUCCESS, even
> though the DMA operation has not succeeded. The DMA operation has not even
> started yet!
> >
> > The smp_mb() fixes this, since it forces CPU2 to have seen all memory operations
> that happened before CPU1 released the spinlock. Spinlocks are implicit SMP
> memory barriers.
> >
> > Therefore, the above example becomes:
> > smp_mb();
> > chan->common.cookie == 20
> > chan->completed_cookie == 19
> > descriptor->cookie == 20
> >
> > Then dma_async_is_complete() returns DMA_IN_PROGRESS, which is correct.
> >
> > Thanks,
> > Ira
> >
> >
> > _______________________________________________
> > Linuxppc-dev mailing list
> > Linuxppc-dev@lists.ozlabs.org
> > https://lists.ozlabs.org/listinfo/linuxppc-dev

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
