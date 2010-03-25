Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846Ab0CYUq3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 16:46:29 -0400
Received: from mail2.shareable.org ([80.68.89.115]:60026 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594Ab0CYUq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 16:46:27 -0400
Date: Thu, 25 Mar 2010 20:46:19 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Paulius Zaleckas <paulius.zaleckas@gmail.com>
Cc: dwmw2@infradead.org, nico@fluxnic.net, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, u.kleine-koenig@pengutronix.de,
       simon.kagstrom@netinsight.net, akpm@linux-foundation.org,
       linux-arm-kernel@lists.infradead.org, rth@twiddle.net
Subject: Re: [PATCH v2] MTD: Fix Orion NAND driver compilation with ARM OABI
Message-ID: <20100325204619.GC19308@shareable.org>
References: <20100325152505.17612.40158.stgit@pauliusz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100325152505.17612.40158.stgit@pauliusz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paulius Zaleckas wrote:
> Signed-off-by: Paulius Zaleckas <paulius.zaleckas@gmail.com>

It's probably worth including the people who weighed in on the
discussion with 'Cc:' headers.

> -		uint64_t x;
> +		/*
> +		 * Since GCC has no proper constraint (PR 43518)
> +		 * force x variable to r2/r3 registers as ldrd instruction
> +		 * requires first register to be even.
> +		 */
> +		register uint64_t x asm ("r2");
> +
>  		asm volatile ("ldrd\t%0, [%1]" : "=&r" (x) : "r" (io_base));
>  		buf64[i++] = x;

The "register...asm" looks fine, but it occurs to me the constraints
are too weak (and they were before), so GCC could optimise that to the
wrong behaviour.

The "volatile" prevents GCC deleting the asm if it's output isn't
used, but it doesn't stop GCC from reordering the asms, for example if
it decides to unroll the loop.  It probably won't reorder in that
case, but it could.  The result would be out of order values stored
into buf[].  It could even move the ldrd earlier than the prior byte
accesses, or after the later byte accesses.

Any one of these should fix it:

   - Make io_base a pointer-to-volatile-u64 or cast it in the asm, and
     make sure to dereference it and use an "m" constraint (or
     tighter, such as "Q", if ldrd needs it).  It must be u64, not
     pointer-to-void, to tell GCC the size.  That tells GCC which memory
     the asm accesses, and the volatile dereference should tell GCC
     not to reorder them in principle (but the GCC manual doesn't
     make a specific promise about this for asms).

     With a proper memory input with the correct size, in principle
     "asm volatile" can be changed to just "asm", but I'm not entirely
     convinced GCC will honour the volatile on the pointer, so I'd
     leave it on the asm too.

   - Add "memory" to the asm's clobbers.  Although it doesn't write,
     it does change the visible memory that *io_base sees, and anyway
     GCC's manual says to use "memory" clobber when the asm does
     unpredictable memory reads too.  With that added, you still need
     the volatile keyword after asm, because the memory is not listed
     in the inputs or outputs (only the address is).  The GCC manual
     explains that "asm volatile" is needed in that case.

     This is slightly less good because it'd prevent reordering writes
     to buf[i++] if GCC unrolled the loop.

   - Put barrier() before and after the asm, which is equivalent to
     adding a "memory" clobber (least good).

You aren't supposed to dereference pointers used with read{b,w,l}
anyway.  It doesn't matter in this driver because we "know" it's only
used on an SoC where read{b,w,l} don't do any address translation.
But will that always be true?  I suppose the cleanest approach is to
define readq, the 64-bit analogue of readl, and use that here.  x86
already defines readq, so it's got precedent.

-- Jamie
