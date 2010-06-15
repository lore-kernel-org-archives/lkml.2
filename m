Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836Ab0FOLb4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 07:31:56 -0400
Received: from cantor.suse.de ([195.135.220.2]:41911 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752747Ab0FOLby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 07:31:54 -0400
Date: Tue, 15 Jun 2010 21:31:50 +1000
From: Nick Piggin <npiggin@suse.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Robert Hancock <hancockrwd@gmail.com>, Tejun Heo <tj@kernel.org>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Colin Tuckley <colin.tuckley@arm.com>, Jeff Garzik <jeff@garzik.org>,
       linux-arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH v2] sata_sil24: Use memory barriers before issuing
 commands
Message-ID: <20100615113150.GM6138@laptop>
References: <AANLkTilxkyOVQU6OjL7ceucxPnbX9qAjWjjM1U16M1Rm@mail.gmail.com>
 <1276600253.26369.46.camel@e102109-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276600253.26369.46.camel@e102109-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 15, 2010 at 12:10:53PM +0100, Catalin Marinas wrote:
> On Sat, 2010-06-12 at 02:30 +0100, Robert Hancock wrote:
> > > So if that's the API for the above case and we are strictly referring to
> > > the sata_sil24 patch I sent - shouldn't we just add wmb() in the driver
> > > between the write to the DMA buffer and the writel() to start the DMA
> > > transfer? Do we need to move the wmb() to the writel() macro?
> > 
> > I think it would be best if writel, etc. did the write buffer flushing
> > by default. As Nick said, if there are some performance critical areas
> > then those can use the relaxed versions but it's safest if the default
> > behavior works as drivers expect.
> 
> I went through the past discussion pointed to by Fujita (thanks!) but I
> wouldn't say it resulted in a definitive guideline on how architectures
> should implement the I/O accessors.
> 
> >From an ARM perspective, I would prefer to add wmb() in the drivers
> where it matters - basically only those using DMA coherent buffers. A
> lot of drivers already have this in place and that's already documented
> in DMA-API.txt (maybe with a bit of clarification).
> 
> Some statistics - grepping drivers/ for alloc_coherent shows 285 files.
> Of these, 69 already use barriers. It's not trivial to go through 200+
> drivers and add barriers but I wouldn't say that's impossible.

I disagree. Firstly, you will get subtle bugs, not able to be reproduced
and situations where driver writers don't even have that architecture to
test on. Secondly, it is not a one-time audit and be done with it, code
is constantly being changed and added. Driver code is going to be
written and tested and run on different archs or even different
implementations that do different things to ordering.

On the other hand, a performance slowdown should be far more reproducible
and traceable.

 
> If we go the other route of adding mb() in writel() (though I don't
> prefer it), there are two additional issues:
> 
> (1) how relaxed would the "writel_relaxed" etc. accessors be? Are they
> relaxed only with regards to coherent DMA buffers or relaxed with other
> I/O operations as well? Can the compiler reorder them?

That was up for debate. I think totally weak (like SMP ordering)
should be fine, but that may require that we need some more barriers
like io_wmb() (which just orders two writels from the same CPU).
Remember we want to restrict their use outside critical fastpaths
of important drivers -- this is a far smaller task than auditing all
accesses in all drivers.


> (2) do we go through all the drivers that currently have *mb() and
> remove them? A quick grep in drivers/ shows over 1600 occurrences of
> *mb().

No need, but the ones that matter will get updated slowly. The ones
that don't will continue to work (from an ordering point of view) on
obscure or untested hardware.

