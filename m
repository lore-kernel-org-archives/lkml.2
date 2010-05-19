Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924Ab0ESNhG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 09:37:06 -0400
Received: from cantor.suse.de ([195.135.220.2]:56332 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751714Ab0ESNhC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 09:37:02 -0400
Date: Wed, 19 May 2010 23:36:56 +1000
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
Message-ID: <20100519133656.GY2516@laptop>
References: <alpine.DEB.2.00.1005111544330.8388@router.home>
 <AANLkTimzxrZyQAfocTwIt5zCVyXP7bReKOvP4K7m8epO@mail.gmail.com>
 <20100511214836.GH1726@emlix.com>
 <20100511215359.GF7396@core.coreip.homeip.net>
 <AANLkTimm7bOmIz2sdODgHwtCk26kdHgZt7PvceM6gjS3@mail.gmail.com>
 <522C1DF17AF50042AD8AE87F7887BD3D0163549554@exch.hq.tensilica.com>
 <20100512030350.GJ15903@laptop>
 <1274273325.6930.10022.camel@macbook.infradead.org>
 <20100519130710.GX2516@laptop>
 <1274275067.6930.10073.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274275067.6930.10073.camel@macbook.infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19, 2010 at 02:17:47PM +0100, David Woodhouse wrote:
> On Wed, 2010-05-19 at 23:07 +1000, Nick Piggin wrote:
> > On Wed, May 19, 2010 at 01:48:45PM +0100, David Woodhouse wrote:
> > > However, we _do_ allow drivers to assume that kmalloc is DMA-safe. That
> > > happens to mean "cacheline-aligned" for cache-incoherent architectures,
> > > but drivers should never really have to think about that.
> > 
> > DMA-safe for GFP_DMA, or all kmalloc?
> 
> Try not to think about that. Seriously, look over there! A kitten!
> 
> (You have to use the DMA API anyway, so swiotlb will handle things if
> you're trying to use pages which are above the range that certain
> devices can reach. But we're only talking about the problems of sharing
> cache lines here; don't worry about that bit.)

Yeah, well, GFP_DMA is pretty crappy anyway. I was just curious, but
it's no big deal to support dma with regular kmalloc.

 
> > > > So whenever strengthening API guarantees like this, it is better to be
> > > > very careful and conservative. Probably even introducing a new API with
> > > > the stronger semantics (even if it is just a wrapper in the case where
> > > > KMALLOC_MINALIGNED *is* cacheline sized).
> > > 
> > > We're not talking about strengthening API guarantees. It's _always_ been
> > > this way; it's just that some architectures are buggy.
> > 
> > It just appeared, in the post I replied to, that there was a suggestion
> > of making it explicitly cacheline aligned. If I misread that, ignore
> > me.
> 
> Actually I think you read it just fine -- but it was misguided. They
> meant to say "cacheline aligned on architectures with cache-incoherent
> DMA which need that". But that's what ARCH_KMALLOC_MINALIGN is _already_
> supposed to do. If any architecture needs to set ARCH_KMALLOC_MINALIGN
> but doesn't, that's broken.
> 
> The 'cacheline aligned' misconception did manage to get into the ad7877
> driver in commit 3843384a though -- it now uses ____cacheline_aligned
> instead of __attribute__((__aligned__(ARCH_KMALLOC_MINALIGN))) as it
> should.

OK so long as there is not a "must be cacheline aligned" requirement.
Your proposal for a __dma_aligned attribute in an arch header looks
like a good idea there.
