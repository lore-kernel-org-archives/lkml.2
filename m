Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751219Ab0ESNHT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 09:07:19 -0400
Received: from cantor.suse.de ([195.135.220.2]:55474 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830Ab0ESNHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 09:07:17 -0400
Date: Wed, 19 May 2010 23:07:10 +1000
From: Nick Piggin <npiggin@suse.de>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Marc Gauthier <marc@tensilica.com>, Mike Frysinger <vapier.adi@gmail.com>,
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
Message-ID: <20100519130710.GX2516@laptop>
References: <alpine.DEB.2.00.1005111520260.1500@router.home>
 <AANLkTilEfZLWYxPmCQ1KHIvUGIF_8Qchali66wHNf2gB@mail.gmail.com>
 <alpine.DEB.2.00.1005111544330.8388@router.home>
 <AANLkTimzxrZyQAfocTwIt5zCVyXP7bReKOvP4K7m8epO@mail.gmail.com>
 <20100511214836.GH1726@emlix.com>
 <20100511215359.GF7396@core.coreip.homeip.net>
 <AANLkTimm7bOmIz2sdODgHwtCk26kdHgZt7PvceM6gjS3@mail.gmail.com>
 <522C1DF17AF50042AD8AE87F7887BD3D0163549554@exch.hq.tensilica.com>
 <20100512030350.GJ15903@laptop>
 <1274273325.6930.10022.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274273325.6930.10022.camel@macbook.infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19, 2010 at 01:48:45PM +0100, David Woodhouse wrote:
> On Wed, 2010-05-12 at 13:03 +1000, Nick Piggin wrote:
> > I don't think it's necessarily a good idea. MINALIGN is an enforced
> > minimum alignment and the allocator has no leeway in reducing this.
> > In a UP system, or in a memory constrained system, it might be a better
> > idea to pack objects more tightly, for example.
> > 
> > If we allow drivers to assume kmalloc is cacheline aligned, it will be
> > (practically) impossible to revert this because it would require driver
> > audits.
> 
> No, we definitely don't, and shouldn't, allow drivers to assume that
> kmalloc is cacheline-aligned.

Good.


> However, we _do_ allow drivers to assume that kmalloc is DMA-safe. That
> happens to mean "cacheline-aligned" for cache-incoherent architectures,
> but drivers should never really have to think about that.

DMA-safe for GFP_DMA, or all kmalloc?

Either way, yes the arch should take care of those details.

 
> > So whenever strengthening API guarantees like this, it is better to be
> > very careful and conservative. Probably even introducing a new API with
> > the stronger semantics (even if it is just a wrapper in the case where
> > KMALLOC_MINALIGNED *is* cacheline sized).
> 
> We're not talking about strengthening API guarantees. It's _always_ been
> this way; it's just that some architectures are buggy.

It just appeared, in the post I replied to, that there was a suggestion
of making it explicitly cacheline aligned. If I misread that, ignore
me.

> 
> But it looks like ARM, PowerPC, SH, MIPS, Microblaze, AVR32 and all
> unconditionally cache-coherent architectures _do_ get it right already.
> 
> > I think adding to the DMA API would be a better idea. If the arch knows
> > that kmalloc is suitable for the job directly, it can be used. Drivers
> > can use the new interface, and kmalloc doesn't get saddled with
> > alignment requirements.
> 
> No, that would be a change which would require auditing all drivers. The
> _current_ rule is that buffers returned from kmalloc() are OK for DMA.
> 
> -- 
> David Woodhouse                            Open Source Technology Centre
> David.Woodhouse@intel.com                              Intel Corporation
