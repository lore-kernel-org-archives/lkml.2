Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274Ab0ERWij (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 18:38:39 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:59475 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839Ab0ERWih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 18:38:37 -0400
Date: Wed, 19 May 2010 07:37:40 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: David Miller <davem@davemloft.net>
Cc: penberg@cs.helsinki.fi, mpm@selenic.com, herbert@gondor.hengli.com.au,
       ken@codelabs.ch, geert@linux-m68k.org, michael-dev@fami-braun.de,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
       anemo@mba.ocn.ne.jp, Christoph Lameter <cl@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [BUG] SLOB breaks Crypto
Message-ID: <20100518223739.GC5933@linux-sh.org>
References: <1274211235.11603.1205.camel@calx> <20100518.135945.180391159.davem@davemloft.net> <AANLkTik3tKpPvilnWV6eVIm5_rUPeuCzXBDwmnZl9N6o@mail.gmail.com> <20100518.142021.135951273.davem@davemloft.net> <20100518223507.GB5933@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100518223507.GB5933@linux-sh.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(adding Christoph and dwmw2 to the Cc..)

On Wed, May 19, 2010 at 07:35:07AM +0900, Paul Mundt wrote:
> On Tue, May 18, 2010 at 02:20:21PM -0700, David Miller wrote:
> > From: Pekka Enberg <penberg@cs.helsinki.fi>
> > Date: Wed, 19 May 2010 00:15:46 +0300
> > 
> > > On Tue, May 18, 2010 at 11:59 PM, David Miller <davem@davemloft.net> wrote:
> > >> From: Matt Mackall <mpm@selenic.com>
> > >> Date: Tue, 18 May 2010 14:33:55 -0500
> > >>
> > >>> SLOB honors ARCH_KMALLOC_MINALIGN. If your arch has alignment
> > >>> requirements, I recommend you set it.
> > >>
> > >> I recommend that the alignment provided by the allocator is not
> > >> determined by which allocator I happen to have enabled.
> > >>
> > >> The values and ifdef'ery should be identical in all of our
> > >> allocators.
> > > 
> > > Why? It doesn't make much sense for SLOB, which tries to be as space
> > > efficient as possible, as a default. If things break on sparc, it
> > > really needs to set ARCH_KMALLOC_MINALIGN as slab default alignment is
> > > not something you really want to depend on.
> > 
> > I think it does make sense to expect that, whatever my architecture
> > defines or does not define, I can expect the allocators to provide the
> > same minimum alignment guarentee.  Otherwise it is no guarantee at all.
> > 
> SLAB/SLUB/SLOB all used to have the same BYTES_PER_WORD alignment
> guarantee, with SLAB and SLUB having moved away from this to unsigned
> long long in b46b8f19 and 47bfdc0d respectively. This was due to mixing
> 64-bit integers in data structures, which in the SLAB case resulted in
> misaligned structures and also broke redzoning (architecture overrides
> also disabled it completely). The SLUB change was made a couple of days
> earlier for the same structure misalignment reasons (64-bit integers on
> 32-bit platforms).
> 
> The default changes in SLAB/SLUB at least assume that 32-bit
> architectures can only address 64-bit values on a 64-bit boundary. While
> this is true for most cases, these have always been handled through the
> bumping of the architecture minalign values in the past. Indeed, this was
> the rationale I had for adding the architecture-specific slab minalign
> override in the first place. The kmalloc one on the other hand is largely
> just overriden for platforms with DMA requirements -- usually a
> cacheline boundary.
> 
> > It's already obvious from these reports that such dependencies do
> > exist.
> > 
> These dependencies were then introduced after SLAB/SLUB changed the
> rules, suggesting that not enough testing was done.
> 
> > So one of two things should happen:
> > 
> > 1) SLOB conforms to SLAB/SLUB in it's test
> > 
> > 2) SLAB/SLUB conforms to SLOB in it's test
> > 
> > And yes this is an either-or, you can't say they are both valid.
> 
> I don't see any reason to punish SLOB for the assumptions that SLAB/SLUB
> arbitrarily took up, presumably on an architecture that should have
> specified its own alignment requirements and simply couldn't be bothered.
> Making SLAB redzoning work with arbitrary alignment is another matter
> entirely, and something that should probably be revisited.
> 
> Anything that assumes more than BYTES_PER_WORD is simply broken and
> should be reverted.
