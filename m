Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272Ab1IARcX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 13:32:23 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48022 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756056Ab1IARcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 13:32:22 -0400
Date: Thu, 1 Sep 2011 18:31:49 +0100
From: Will Deacon <will.deacon@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Alan Stern <stern@rowland.harvard.edu>, Ming Lei <ming.lei@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Salter <msalter@redhat.com>
Subject: Re: [PATCH 0/3] RFC: addition to DMA API
Message-ID: <20110901173149.GE2803@e102144-lin.cambridge.arm.com>
References: <CACVXFVOT9FZexiZhuJtvyFP8qOPYUKg0JqGarBJgT4R8SN7p5Q@mail.gmail.com>
 <Pine.LNX.4.44L0.1109011127080.1896-100000@iolanthe.rowland.org>
 <20110901160429.GA15814@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110901160429.GA15814@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

On Thu, Sep 01, 2011 at 05:04:29PM +0100, Russell King - ARM Linux wrote:
> DMA coherent memory on ARM is implemented on ARMv5 and below by using
> 'noncacheable nonbufferable' memory.  There is no weak memory model to
> worry about, and this memory type is seen as 'strongly ordered' - the
> CPU stalls until the read or write has completed.  So no problem there.
> 
> On ARMv6 and above, the attributes change:
> 
> 1. Memory type: [Normal, Device, Strongly ordered]
>    All mappings of a physical address space are absolutely required to be
>    of the same memory type, otherwise the result is unpredictable.  There
>    is no mitigation against this.
> 
> 2. For "normal memory", a variety of options are available to adjust the
>    hints to the cache and memory subsystem - the options here are
>    [Non-cacheable, write-back write alloc, write-through non-write alloc,
>     write-back, non-write alloc.]
> 
>    Strictly to the ARM ARM, all mappings must, again, have the same
>    attributes to avoid unpredictable behaviour.  There is a _temporary_
>    architectural relaxation of this requirement provided certain conditions
>    are met - which may become permanent.

This looks set to appear in revision C of the ARM ARM.

> It _is_ possible that "unpredictable" means that we may hit cache lines in
> the [VP]IPT cache via the non-cacheable mapping which have been created
> by speculative loads via the cacheable mapping - and this is something
> that has been worrying me for a long time.

Whilst this can happen, this will only cause problems for reads performed
by the CPU (as these may hit a line speculatively loaded via the cacheable
alias). Setting bit 22 in the auxillary control register gets arounds this:

http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=6529/1

Given that I believe our coherent DMA memory is `cacheable, bufferable, do
not allocate' in terms of AXI attributes, then writes will go straight to
the write buffer on the PL310.

> So, in summary what I'm saying is that _in theory_ our DMA coherent memory
> on ARMv6+ should have nothing more than write buffering to contend with,
> but that doesn't stop this being the first real concrete report proving
> that what I've been going on about regarding the architectural requirements
> over the last few years is actually very real and valid.

I don't think what we're seeing in this case is caused by mismatched memory
attributes, especially as passing `nosmp' on the command-line makes the
performance issue disappear.

Will
