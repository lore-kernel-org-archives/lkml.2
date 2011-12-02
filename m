Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757188Ab1LBRNi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 12:13:38 -0500
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:60555 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757154Ab1LBRNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 12:13:37 -0500
Date: Fri, 2 Dec 2011 09:13:35 -0800
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: Shi Xuelin-B29237 <B29237@freescale.com>
Cc: "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Li Yang-R58472 <r58472@freescale.com>
Subject: Re: [PATCH][RFC] fsldma: fix performance degradation by optimizing
 spinlock use.
Message-ID: <20111202171334.GA19677@ovro.caltech.edu>
References: <1321937705-19587-1-git-send-email-b29237@freescale.com>
 <20111122185924.GA23323@ovro.caltech.edu>
 <DBB740589CE8814680DECFE34BE197AB148CDD@039-SN1MPN1-006.039d.mgd.msft.net>
 <20111128163814.GA10919@ovro.caltech.edu>
 <3F607A5180246847A760FD34122A1E052E07B7@039-SN1MPN1-003.039d.mgd.msft.net>
 <20111129172539.GB15331@ovro.caltech.edu>
 <DBB740589CE8814680DECFE34BE197AB14A1E0@039-SN1MPN1-006.039d.mgd.msft.net>
 <20111130170737.GA25892@ovro.caltech.edu>
 <DBB740589CE8814680DECFE34BE197AB14BCBC@039-SN1MPN1-006.039d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DBB740589CE8814680DECFE34BE197AB14BCBC@039-SN1MPN1-006.039d.mgd.msft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (ovro.ovro.caltech.edu); Fri, 02 Dec 2011 09:13:36 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 02, 2011 at 03:47:27AM +0000, Shi Xuelin-B29237 wrote:
> Hi Iris,
> 
> >I'm convinced that "smp_rmb()" is needed when removing the spinlock. As noted, Documentation/memory-barriers.txt says that stores on one CPU can be
> >observed by another CPU in a different order.
> >Previously, there was an UNLOCK (in fsl_dma_tx_submit) followed by a LOCK (in fsl_tx_status). This provided a "full barrier", forcing the operations to 
> >complete correctly when viewed by the second CPU. 
> 
> I do not agree this smp_rmb() works here. Because when this smp_rmb() executed and begin to read chan->common.cookie, you still cannot avoid the order issue. Something like one is reading old value, but another CPU is updating the new value. 
> 
> My point is here the order is not important for the DMA decision.
> Completed DMA tx is decided as not complete is not a big deal, because next time it will be OK.
> 
> I believe there is no case that could cause uncompleted DMA tx is decided as completed, because the fsl_tx_status is called after fsl_dma_tx_submit for a specific cookie. If you can give me an example here, I will agree with you.
> 

According to memory-barriers.txt, writes to main memory may be observed in
any order if memory barriers are not used. This means that writes can
appear to happen in a different order than they were issued by the CPU.

Citing from the text:

> There are certain things that the Linux kernel memory barriers do not guarantee:
>
>  (*) There is no guarantee that any of the memory accesses specified before a
>      memory barrier will be _complete_ by the completion of a memory barrier
>      instruction; the barrier can be considered to draw a line in that CPU's
>      access queue that accesses of the appropriate type may not cross.

Also:

> Without intervention, CPU 2 may perceive the events on CPU 1 in some
> effectively random order, despite the write barrier issued by CPU 1:

Also:

> When dealing with CPU-CPU interactions, certain types of memory barrier should
> always be paired.  A lack of appropriate pairing is almost certainly an error.
>
> A write barrier should always be paired with a data dependency barrier or read
> barrier, though a general barrier would also be viable.

Therefore, in an SMP system, the following situation can happen.

descriptor->cookie = 2
chan->common.cookie = 1
chan->completed_cookie = 1

This occurs when CPU-A calls fsl_dma_tx_submit() and then CPU-B calls
dma_async_is_complete() ***after*** CPU-B has observed the write to
descriptor->cookie, and ***before*** before CPU-B has observed the write to
chan->common.cookie.

Remember, without barriers, CPU-B can observe CPU-A's memory accesses in
*any possible order*. Memory accesses are not guaranteed to be *complete*
by the time fsl_dma_tx_submit() returns!

With the above values, dma_async_is_complete() returns DMA_COMPLETE. This
is incorrect: the DMA is still in progress. The required invariant
chan->common.cookie >= descriptor->cookie has not been met.

By adding an smp_rmb(), I force CPU-B to stall until *both* stores in
fsl_dma_tx_submit() (descriptor->cookie and chan->common.cookie) actually
hit main memory. This avoids the above situation: all CPU's observe
descriptor->cookie and chan->common.cookie to update in sync with each
other.

Is this unclear in any way?

Please run your test with the smp_rmb() and measure the performance
impact.

Ira
