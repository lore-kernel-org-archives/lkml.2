Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065Ab0ERXLx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 19:11:53 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:47897 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068Ab0ERXLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 19:11:51 -0400
Date: Wed, 19 May 2010 08:10:53 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: David Miller <davem@davemloft.net>
Cc: penberg@cs.helsinki.fi, mpm@selenic.com, herbert@gondor.hengli.com.au,
       ken@codelabs.ch, geert@linux-m68k.org, michael-dev@fami-braun.de,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
       anemo@mba.ocn.ne.jp
Subject: Re: [BUG] SLOB breaks Crypto
Message-ID: <20100518231053.GD5933@linux-sh.org>
References: <AANLkTik3tKpPvilnWV6eVIm5_rUPeuCzXBDwmnZl9N6o@mail.gmail.com> <20100518.142021.135951273.davem@davemloft.net> <20100518223507.GB5933@linux-sh.org> <20100518.154059.139137292.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100518.154059.139137292.davem@davemloft.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 18, 2010 at 03:40:59PM -0700, David Miller wrote:
> From: Paul Mundt <lethal@linux-sh.org>
> Date: Wed, 19 May 2010 07:35:10 +0900
> 
> > On Tue, May 18, 2010 at 02:20:21PM -0700, David Miller wrote:
> >> So one of two things should happen:
> >> 
> >> 1) SLOB conforms to SLAB/SLUB in it's test
> >> 
> >> 2) SLAB/SLUB conforms to SLOB in it's test
> >> 
> >> And yes this is an either-or, you can't say they are both valid.
> > 
> > I don't see any reason to punish SLOB for the assumptions that SLAB/SLUB
> > arbitrarily took up, presumably on an architecture that should have
> > specified its own alignment requirements and simply couldn't be bothered.
> > Making SLAB redzoning work with arbitrary alignment is another matter
> > entirely, and something that should probably be revisited.
> > 
> > Anything that assumes more than BYTES_PER_WORD is simply broken and
> > should be reverted.
> 
> You can't make the default different in each allocator, PERIOD.
> 
I don't disagree that having different defaults is a bit unorthodox, but
that has not been a problem for any code that didn't attempt to make
its own assumptions about the alignment.

> If you can't know what the default is, how in the world can you know
> if you need to override it?  You can't.  It's a guess, and you can't
> say otherwise.
> 
If an architecture requires 64-bit alignment for addressing 64-bit values
on 32-bit, then that's a hard architecture requirement irrespective of
whatever the slab allocator defaults to. The whole idea behind
architecture minimum alignment requirements is that they are
minimum requirements.

> All of the CPP tests like the one used by linux/crypto.h are
> ludicrious.  It should absolutely be not necessary for any code to
> duplicate this kind of calculation.
> 
Agreed.

> Instead, this sequence should be in linux/slab.h, and be used
> universally by slab, slub, slob and anything that wants to know the
> allocators alignment guarentees.
> 
Having a slab_alignment() routine or something sounds fine, but we
already have headers split out for all of the different allocators, so
there's no specific reason why slob_def.h can't deviate here, too.

Again, it's the crypto code that is broken for making bogus alignment
assumptions in the first place.

> I don't even know of a 32-bit chip outside of x86 that doesn't
> potentially emit alignment requiring 64-bit memory operations for
> 64-bit objects.  So what SLOB is doing with a different default is
> even more strange.  And I bet you that even without the requirement,
> x86 runs faster with 64-bit alignment of 64-bit objects.

I assumed ppc32 too, but if they're really in a minority then we
could also consider just inverting the logic (both x86 and ppc set
HAVE_EFFICIENT_UNALIGNED_ACCESS for example).
