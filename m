Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932579Ab1IAQE5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 12:04:57 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54724 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932452Ab1IAQE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 12:04:56 -0400
Date: Thu, 1 Sep 2011 17:04:29 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Ming Lei <ming.lei@canonical.com>, Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Salter <msalter@redhat.com>
Subject: Re: [PATCH 0/3] RFC: addition to DMA API
Message-ID: <20110901160429.GA15814@n2100.arm.linux.org.uk>
References: <CACVXFVOT9FZexiZhuJtvyFP8qOPYUKg0JqGarBJgT4R8SN7p5Q@mail.gmail.com> <Pine.LNX.4.44L0.1109011127080.1896-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1109011127080.1896-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 01, 2011 at 11:42:23AM -0400, Alan Stern wrote:
> On Thu, 1 Sep 2011, Ming Lei wrote:
> 
> > First, most of barriers have made this kind of flush not necessary, as
> > explained int the example above.
> 
> You don't seem to understand the difference between memory barriers and 
> write flushes.  Neither makes the other unnecessary -- they do 
> different things.
> 
> Now, there is good reason to question why write flushes should be 
> needed at all.  According to the definition in 
> Documentation/DMA-API.txt (the document doesn't distinguish between 
> coherent memory and consistent memory):
> 
>   Consistent memory is memory for which a write by either the device or
>   the processor can immediately be read by the processor or device
>   without having to worry about caching effects.  (You may however need
>   to make sure to flush the processor's write buffers before telling
>   devices to read that memory.)
> 
> As far as I can tell, we are talking about a cache flush rather than a 
> processor write buffer flush.  If that's so, it would appear that the 
> memory in question is not truly coherent.

DMA coherent memory on ARM is implemented on ARMv5 and below by using
'noncacheable nonbufferable' memory.  There is no weak memory model to
worry about, and this memory type is seen as 'strongly ordered' - the
CPU stalls until the read or write has completed.  So no problem there.

On ARMv6 and above, the attributes change:

1. Memory type: [Normal, Device, Strongly ordered]
   All mappings of a physical address space are absolutely required to be
   of the same memory type, otherwise the result is unpredictable.  There
   is no mitigation against this.

2. For "normal memory", a variety of options are available to adjust the
   hints to the cache and memory subsystem - the options here are
   [Non-cacheable, write-back write alloc, write-through non-write alloc,
    write-back, non-write alloc.]

   Strictly to the ARM ARM, all mappings must, again, have the same
   attributes to avoid unpredictable behaviour.  There is a _temporary_
   architectural relaxation of this requirement provided certain conditions
   are met - which may become permanent.

We remap system memory (which has its standard direct-mapped kernel mapping
as 'normal memory, write-back' for DMA coherent memory into a separate
region marking it 'normal memory, non-cacheable'.  Strictly this violates
the architecture - but we have no other way at present to obtain DMA
coherent memory as we can't unmap the standard direct-mapped kernel mapping
(we'd have to touch _every_ page table in the system, and then issue TLB
flushes which may have to be smp_call_function'd, which you can't do from
IRQ context - one of the contexts which dma_alloc_coherent must work from.)

So far, no one has reported any ill effects - and there's been much pressure
from lots of people to ignore the architecture reference manual over this,
including from the CMA guys.

It _is_ possible that "unpredictable" means that we may hit cache lines in
the [VP]IPT cache via the non-cacheable mapping which have been created
by speculative loads via the cacheable mapping - and this is something
that has been worrying me for a long time.

I've tried several ways to fix this but the result has been regressions.
So far, I have no fix for this which will not cause a regression, which
will satisfy the ARM ARM, which will satisfy peoples expectations, etc.
There is a plan with CMA to try and do something about this, but that's
a long way off yet.

So, in summary what I'm saying is that _in theory_ our DMA coherent memory
on ARMv6+ should have nothing more than write buffering to contend with,
but that doesn't stop this being the first real concrete report proving
that what I've been going on about regarding the architectural requirements
over the last few years is actually very real and valid.
