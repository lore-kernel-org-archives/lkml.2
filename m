Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345Ab0ELDEE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 23:04:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55357 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751640Ab0ELDEA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 23:04:00 -0400
Date: Wed, 12 May 2010 13:03:50 +1000
From: Nick Piggin <npiggin@suse.de>
To: Marc Gauthier <marc@tensilica.com>
Cc: Mike Frysinger <vapier.adi@gmail.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Johannes Weiner <jw@emlix.com>, Christoph Lameter <cl@linux.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oskar Schirmer <os@emlix.com>,
       Michael Hennerich <Michael.Hennerich@analog.com>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Daniel =?iso-8859-1?Q?Gl=F6ckner?= <dg@emlix.com>,
       Oliver Schneidewind <osw@emlix.com>,
       David Rientjes <rientjes@google.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Grant Likely <grant.likely@secretlab.ca>,
       Chris Zankel <chris@zankel.net>,
       Piet Delaney <Piet.Delaney@tensilica.com>
Subject: Re: [LKML] Re: [PATCH v3] ad7877: keep dma rx buffers in seperate
 cache lines
Message-ID: <20100512030350.GJ15903@laptop>
References: <1273608441.15067.1002.camel@calx>
 <AANLkTimt-eRCt_HTq7OUwzG1dgRuzJHk1tlgOcq4ocL7@mail.gmail.com>
 <alpine.DEB.2.00.1005111520260.1500@router.home>
 <AANLkTilEfZLWYxPmCQ1KHIvUGIF_8Qchali66wHNf2gB@mail.gmail.com>
 <alpine.DEB.2.00.1005111544330.8388@router.home>
 <AANLkTimzxrZyQAfocTwIt5zCVyXP7bReKOvP4K7m8epO@mail.gmail.com>
 <20100511214836.GH1726@emlix.com>
 <20100511215359.GF7396@core.coreip.homeip.net>
 <AANLkTimm7bOmIz2sdODgHwtCk26kdHgZt7PvceM6gjS3@mail.gmail.com>
 <522C1DF17AF50042AD8AE87F7887BD3D0163549554@exch.hq.tensilica.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <522C1DF17AF50042AD8AE87F7887BD3D0163549554@exch.hq.tensilica.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 11, 2010 at 07:07:35PM -0700, Marc Gauthier wrote:
> Mike Frysinger wrote:
> > lets look at the cacheline sizes for arches that dont set
> > ARCH_KMALLOC_MINALIGN to L1_CACHE_BYTES:
> >  - alplha - 32 or 64
> >  - frv - 32 or 64
> >  - blackfin - 32
> >  - parisc - 32 or 64
> >  - mn10300 - 16
> >  - s390 - 256
> >  - score - 16
> >  - sparc - 32
> >  - xtensa - 16 or 32
> >
> > assuming alpha and s390 handle cache coherency in hardware, it looks
> > to me like the proposed assumption (kmalloc returns cachealigned
> > pointers when cache management is in software) does not hold true.
> >
> > so should these other arches also be setting ARCH_KMALLOC_MINALIGN to
> > L1_CACHE_BYTES ?
> 
> IMHO, yes.  It just makes sense to avoid false-sharing issues, not to
> allocate unrelated blocks in the same cache line.
> 
> Also as it turns out (hope he doesn't me telling), Christian Zankel
> recently found a bug that was fixed exactly that way, by setting
> ARCH_KMALLOC_MINALIGN to L1_CACHE_BYTES for the Xtensa architecture.
> (Too recent to have percolated to mainline.)
> 
> A lot of the above might be cache line aligned (?).

I don't think it's necessarily a good idea. MINALIGN is an enforced
minimum alignment and the allocator has no leeway in reducing this.
In a UP system, or in a memory constrained system, it might be a better
idea to pack objects more tightly, for example.

If we allow drivers to assume kmalloc is cacheline aligned, it will be
(practically) impossible to revert this because it would require driver
audits.

So whenever strengthening API guarantees like this, it is better to be
very careful and conservative. Probably even introducing a new API with
the stronger semantics (even if it is just a wrapper in the case where
KMALLOC_MINALIGNED *is* cacheline sized).

I think adding to the DMA API would be a better idea. If the arch knows
that kmalloc is suitable for the job directly, it can be used. Drivers
can use the new interface, and kmalloc doesn't get saddled with
alignment requirements.

