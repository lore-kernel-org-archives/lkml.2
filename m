Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013Ab1LEGLm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 01:11:42 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:28761
	"EHLO VA3EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751442Ab1LEGLl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 01:11:41 -0500
X-SpamScore: -18
X-BigFish: VS-18(zz542M1432N98dK4015Lzz1202hzzz2dh2a8h668h839h8e2h8e3h945h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 0,
From: Shi Xuelin-B29237 <B29237@freescale.com>
To: "Ira W. Snyder" <iws@ovro.caltech.edu>
CC: "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Li Yang-R58472 <r58472@freescale.com>
Subject: RE: [PATCH][RFC] fsldma: fix performance degradation by optimizing
 spinlock use.
Thread-Topic: [PATCH][RFC] fsldma: fix performance degradation by optimizing
 spinlock use.
Thread-Index: AQHMqUjerURab3Fr/EKddPxu6BzsrpW7rS8AgAc9FICAALMMgIAA7IkAgACpYSCAAOPqAIAB3jNwgAFIIICAA5dycA==
Date: Mon, 5 Dec 2011 06:11:31 +0000
Message-ID: <DBB740589CE8814680DECFE34BE197AB14BED0@039-SN1MPN1-006.039d.mgd.msft.net>
References: <1321937705-19587-1-git-send-email-b29237@freescale.com>
 <20111122185924.GA23323@ovro.caltech.edu>
 <DBB740589CE8814680DECFE34BE197AB148CDD@039-SN1MPN1-006.039d.mgd.msft.net>
 <20111128163814.GA10919@ovro.caltech.edu>
 <3F607A5180246847A760FD34122A1E052E07B7@039-SN1MPN1-003.039d.mgd.msft.net>
 <20111129172539.GB15331@ovro.caltech.edu>
 <DBB740589CE8814680DECFE34BE197AB14A1E0@039-SN1MPN1-006.039d.mgd.msft.net>
 <20111130170737.GA25892@ovro.caltech.edu>
 <DBB740589CE8814680DECFE34BE197AB14BCBC@039-SN1MPN1-006.039d.mgd.msft.net>
 <20111202171334.GA19677@ovro.caltech.edu>
In-Reply-To: <20111202171334.GA19677@ovro.caltech.edu>
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

Hi Iris,

>Remember, without barriers, CPU-B can observe CPU-A's memory accesses in *any possible order*. Memory accesses are not guaranteed to be *complete* by 
>the time fsl_dma_tx_submit() returns!

fsl_dma_tx_submit is enclosed by spin_lock_irqsave/spin_unlock_irqrestore, when this function returns, I believe the memory access are completed. spin_unlock_irqsave is an implicit memory barrier and guaranteed this.

Thanks,
Forrest


-----Original Message-----
From: Ira W. Snyder [mailto:iws@ovro.caltech.edu] 
Sent: 2011年12月3日 1:14
To: Shi Xuelin-B29237
Cc: vinod.koul@intel.com; dan.j.williams@intel.com; linuxppc-dev@lists.ozlabs.org; linux-kernel@vger.kernel.org; Li Yang-R58472
Subject: Re: [PATCH][RFC] fsldma: fix performance degradation by optimizing spinlock use.

On Fri, Dec 02, 2011 at 03:47:27AM +0000, Shi Xuelin-B29237 wrote:
> Hi Iris,
> 
> >I'm convinced that "smp_rmb()" is needed when removing the spinlock. 
> >As noted, Documentation/memory-barriers.txt says that stores on one CPU can be observed by another CPU in a different order.
> >Previously, there was an UNLOCK (in fsl_dma_tx_submit) followed by a 
> >LOCK (in fsl_tx_status). This provided a "full barrier", forcing the operations to complete correctly when viewed by the second CPU.
> 
> I do not agree this smp_rmb() works here. Because when this smp_rmb() executed and begin to read chan->common.cookie, you still cannot avoid the order issue. Something like one is reading old value, but another CPU is updating the new value. 
> 
> My point is here the order is not important for the DMA decision.
> Completed DMA tx is decided as not complete is not a big deal, because next time it will be OK.
> 
> I believe there is no case that could cause uncompleted DMA tx is decided as completed, because the fsl_tx_status is called after fsl_dma_tx_submit for a specific cookie. If you can give me an example here, I will agree with you.
> 

According to memory-barriers.txt, writes to main memory may be observed in any order if memory barriers are not used. This means that writes can appear to happen in a different order than they were issued by the CPU.

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

> When dealing with CPU-CPU interactions, certain types of memory 
> barrier should always be paired.  A lack of appropriate pairing is almost certainly an error.
>
> A write barrier should always be paired with a data dependency barrier 
> or read barrier, though a general barrier would also be viable.

Therefore, in an SMP system, the following situation can happen.

descriptor->cookie = 2
chan->common.cookie = 1
chan->completed_cookie = 1

This occurs when CPU-A calls fsl_dma_tx_submit() and then CPU-B calls
dma_async_is_complete() ***after*** CPU-B has observed the write to
descriptor->cookie, and ***before*** before CPU-B has observed the write 
descriptor->to
chan->common.cookie.

Remember, without barriers, CPU-B can observe CPU-A's memory accesses in *any possible order*. Memory accesses are not guaranteed to be *complete* by the time fsl_dma_tx_submit() returns!

With the above values, dma_async_is_complete() returns DMA_COMPLETE. This is incorrect: the DMA is still in progress. The required invariant
chan->common.cookie >= descriptor->cookie has not been met.

By adding an smp_rmb(), I force CPU-B to stall until *both* stores in
fsl_dma_tx_submit() (descriptor->cookie and chan->common.cookie) actually hit main memory. This avoids the above situation: all CPU's observe
descriptor->cookie and chan->common.cookie to update in sync with each
other.

Is this unclear in any way?

Please run your test with the smp_rmb() and measure the performance impact.

Ira


