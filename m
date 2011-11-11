Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824Ab1KKEkk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 23:40:40 -0500
Received: from gate.crashing.org ([63.228.1.57]:41888 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754075Ab1KKEki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 23:40:38 -0500
Message-ID: <1320986410.21206.48.camel@pasglop>
Subject: Re: [RFC PATCH 00/17] powerpc/e500: separate e500 from e500mc
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Moffett, Kyle D" <Kyle.D.Moffett@boeing.com>
Cc: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Scott Wood <scottwood@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Timur Tabi <B04825@freescale.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Fri, 11 Nov 2011 15:40:10 +1100
In-Reply-To: <15AB1C61-181F-4454-AF99-772B73DE0AA5@boeing.com>
References: <4E42AB6F.1050900@freescale.com>
	 <1320883399-15911-1-git-send-email-Kyle.D.Moffett@boeing.com>
	 <FF2BF3F3-1158-4747-AEEC-03D6A7C462D9@kernel.crashing.org>
	 <C0DED343-76A8-457E-BF54-E52DFCAC83A8@boeing.com>
	 <58FDDDA5-26C4-493B-A00D-81DD94A5C26A@kernel.crashing.org>
	 <20111110165455.GE11983@schlenkerla.am.freescale.net>
	 <15AB1C61-181F-4454-AF99-772B73DE0AA5@boeing.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-10 at 18:38 -0600, Moffett, Kyle D wrote:

> Ok, so I've been poking around this code a bunch and as far as I can
> tell, the cacheline stuff has basically always been subtly wrong in
> twelve different ways and it's only largely coincidence that it works
> today.

Yay ! Somebody to clean that shit up ! :-)

That's the biggest missing step to being able to have 440 and 476 in a
single binary :-)

> So PowerPC64 systems have their own "ppc64_caches" structure set up
> before start_kernel() is called by parsing the OpenFirmware "cpu" nodes.
> That structure is then checked in every piece of 64-bit kernel code
> (except xmon) that uses the "dcbXX" and "icbXX" opcodes.

Yup. (And we should really fix xmon btw...)

> There is an entirely separate mechanism built into the "cputable" that
> is used on all PowerPC systems to compute cacheline sizes to pass in via
> ELF headers for userspace to use in memset()/memcpy(), etc.

Yeah well, it actually uses global variables which are set from cputable
on ppc32 and from the ppc64_caches structure on ppc64. Yeah it's not
pretty.

> Furthermore, the VDSO gets cacheline sizes stored into it, but on 64-bit
> they come from the ppc64_caches structure and on 32-bit they come from
> dcache_bsize/icache_bsize copied from the cputable.

Yup.

> Then there's the value in arch/powerpc/include/asm/cache.h which is used
> throughout the kernel to figure out how far apart to space CPU-specific
> datastructures (EG: __cacheline_aligned_on_smp).

Not much we can do about that one since it has to be compile time. Maybe
something like calculating the biggest cache line size supported by all
built-in processor types ?

> Despite the fact that all PPC64 have an "L1_CACHE_SIZE" value of 128,
> the PowerPC A2 and e5500 have {d,i}cache_bsize values of 64 in cputable
> and presumably also get correct values from OpenFirmware, so the bogus
> constant in asm/cache.h does nothing more than waste a bit of memory
> for unnecessary padding.

More or less yes, though we haven't totally given up on the idea of
eventually, one day, produce binaries capable of running both 64-bit S
and E :-)

> Unfortunately, lots of PPC32 assembly pretends that the value found in
> asm/cache.h is a hard truth and uses it for "dcbz", etc, which is why
> there are all of those ugly #ifdefs in asm/cache.h

Yes, well... -some- assembly, mostly the copy routines. It's been the
main reason why this hasn't been fixed yet.

> Based on all of that, my proposal is going to be a patch which does the
> following:
> 
>   (1) Conditionally set L1_CACHE_SHIFT to the maximum value used by any
>       platform being compiled in for alignment purposes.

Yay !

>   (2) Make the ppc64_caches struct apply to ppc32 as well, and
>       preinitialize it with a minimum value used by any platform being
>       compiled in (for "dcbXX"/"icbXX" purposes).  This is safe because
>       the pagesize is always a multiple of the cache block size and the
>       kernel only uses dcbXX/icbXX on whole pages.  The only impact is a
>       temporary small performance hit from flushing or zeroing the same
>       block 8 times if too small.

Are you sure about dcbz ? Getting that wrong can be deadly ... I'd
rather get rid of some fancy optims and use a soft value in some cases.
That or we can compile multiple variants for the common case of some of
the copy routines and use patching (alternate sections) to branch to the
right one at runtime, at least for the common cases (32 and 128 for
example for 440 and 476).

>   (3) Try to initialize the ppc_caches struct on ppc32 from the
>       OpenFirmware device-tree.  If that fails, then use the values we
>       find in the cputable.  After this is initialized any performance
>       hit in copy_page()/zero_page() will obviously disappear.
>
>   (4) Fix all of the PPC32 assembly code that is misusing L1_CACHE_SHIFT
>       to use the ppc_caches struct instead.

Yes. This could be done while keeping the hand-optimized stuff by
compiling several variants of it.

> Does that sound like a reasonable approach?

It absolutely does ! Thanks for looking at that, it's been on my todo
list for ages and I've been always finding good reasons to do something
else instead :-)

Cheers,
Ben.

> Cheers,
> Kyle Moffett
> 
> --
> Curious about my work on the Debian powerpcspe port?
> I'm keeping a blog here: http://pureperl.blogspot.com/


