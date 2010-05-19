Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758090Ab0ESMtX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 08:49:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:48231 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758067Ab0ESMtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 08:49:20 -0400
Subject: Re: [LKML] Re: [PATCH v3] ad7877: keep dma rx buffers in seperate
 cache lines
From: David Woodhouse <dwmw2@infradead.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Marc Gauthier <marc@tensilica.com>, Mike Frysinger <vapier.adi@gmail.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Johannes Weiner <jw@emlix.com>, Christoph Lameter <cl@linux.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oskar Schirmer <os@emlix.com>,
       Michael Hennerich <Michael.Hennerich@analog.com>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Daniel =?ISO-8859-1?Q?Gl=F6ckner?= <dg@emlix.com>,
       Oliver Schneidewind <osw@emlix.com>,
       David Rientjes <rientjes@google.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Grant Likely <grant.likely@secretlab.ca>,
       Chris Zankel <chris@zankel.net>,
       Piet Delaney <Piet.Delaney@tensilica.com>
In-Reply-To: <20100512030350.GJ15903@laptop>
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
	 <20100512030350.GJ15903@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 May 2010 13:48:45 +0100
Message-ID: <1274273325.6930.10022.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-12 at 13:03 +1000, Nick Piggin wrote:
> I don't think it's necessarily a good idea. MINALIGN is an enforced
> minimum alignment and the allocator has no leeway in reducing this.
> In a UP system, or in a memory constrained system, it might be a better
> idea to pack objects more tightly, for example.
> 
> If we allow drivers to assume kmalloc is cacheline aligned, it will be
> (practically) impossible to revert this because it would require driver
> audits.

No, we definitely don't, and shouldn't, allow drivers to assume that
kmalloc is cacheline-aligned.

However, we _do_ allow drivers to assume that kmalloc is DMA-safe. That
happens to mean "cacheline-aligned" for cache-incoherent architectures,
but drivers should never really have to think about that.

> So whenever strengthening API guarantees like this, it is better to be
> very careful and conservative. Probably even introducing a new API with
> the stronger semantics (even if it is just a wrapper in the case where
> KMALLOC_MINALIGNED *is* cacheline sized).

We're not talking about strengthening API guarantees. It's _always_ been
this way; it's just that some architectures are buggy.

But it looks like ARM, PowerPC, SH, MIPS, Microblaze, AVR32 and all
unconditionally cache-coherent architectures _do_ get it right already.

> I think adding to the DMA API would be a better idea. If the arch knows
> that kmalloc is suitable for the job directly, it can be used. Drivers
> can use the new interface, and kmalloc doesn't get saddled with
> alignment requirements.

No, that would be a change which would require auditing all drivers. The
_current_ rule is that buffers returned from kmalloc() are OK for DMA.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

