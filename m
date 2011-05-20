Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934586Ab1ETAxW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 20:53:22 -0400
Received: from gate.crashing.org ([63.228.1.57]:44314 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932618Ab1ETAxV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 20:53:21 -0400
Subject: Re: [PATCH 3/7] [RFC] add support for BlueGene/P FPU
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Michael Neuling <mikey@neuling.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, bg-linux@lists.anl-external.org
In-Reply-To: <BANLkTimKhApFW8G1-pG0u_9Kv2YB0R1O0w@mail.gmail.com>
References: <1305753895-24845-1-git-send-email-ericvh@gmail.com>
	 <1305753895-24845-3-git-send-email-ericvh@gmail.com>
	 <425.1305784718@neuling.org>
	 <BANLkTimKhApFW8G1-pG0u_9Kv2YB0R1O0w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 May 2011 10:53:06 +1000
Message-ID: <1305852786.7481.104.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-19 at 08:53 -0500, Eric Van Hensbergen wrote:
> On Thu, May 19, 2011 at 12:58 AM, Michael Neuling <mikey@neuling.org> wrote:
> > Eric,
> >
> >> This patch adds save/restore register support for the BlueGene/P
> >> double hummer FPU.
> >
> > What does this mean?  Needs more details here.
> >
> 
> Hi Mikey,
> 
> any specific details you are looking for here?  AFAIK these patches
> are required for the kernel to save/restore the double hummer
> properly.

A description of the double hummer would be good.

Cheers,
Ben.

> >>
> >> +#ifdef CONFIG_BGP
> >> +#define LFPDX(frt, ra, rb)   .long (31<<26)|((frt)<<21)|((ra)<<16)| \
> >> +                                                     ((rb)<<11)|(462<<1)
> >> +#define STFPDX(frt, ra, rb)  .long (31<<26)|((frt)<<21)|((ra)<<16)| \
> >> +                                                     ((rb)<<11)|(974<<1)
> >> +#endif /* CONFIG_BGP */
> >
> > Put these in arch/powerpc/include/asm/ppc-opcode.h and reformat to fit
> > whats there already.
> >
> > Also, don't need to put these defines inside a #ifdef.
> >
> 
> Sure, I'll fix that up.
> 
> >> +#ifdef CONFIG_BGP
> >> +#define SAVE_FPR(n, b, base) li b, THREAD_FPR0+(16*(n)); STFPDX(n, base, b)
> >> +#define REST_FPR(n, b, base) li b, THREAD_FPR0+(16*(n)); LFPDX(n, base, b)
> >
> > 16*?  Are these FP regs 64 or 128 bits wide?  If 128 you are doing to
> > have to play with TS_WIDTH to get the size of the FPs correct in the
> > thread_struct.
> >
> > I think there's a bug here.
> >
> 
> I actually have three different versions of this code from different
> source patches that I'm drawing from - so your help in figuring out
> the best way to approach this is appreciated.  The kittyhawk version
> of the code has 8* instead of 16*.  According to the docs:
> "Each of the two FPU units contains 32 64-bit floating point registers
> for a total of 64 FP registers per processor." which would seem to
> point to the kittyhawk version - but they have a second SAVE_32SFPRS
> for the second hummer.  What wasn't clear to me with this version of
> the code was whether or not they were doing something clever like
> saving the pair of the 64-bit FPU registers in a single 128-bit slot
> (seems plausible).  If this is not the way to go, I can certainly
> switch the kittyhawk version of the patch with the *, the extra
> SAVE32SFPR and the extra double hummer specific storage space in the
> thread_struct.  If it would help I can post an alternate version of
> the patch for discussion with the kittyhawk version.
> 
> >>  /*
> >> diff --git a/arch/powerpc/platforms/44x/Kconfig b/arch/powerpc/platforms/44x/
> > Kconfig
> >> index f485fc5f..24a515e 100644
> >> --- a/arch/powerpc/platforms/44x/Kconfig
> >> +++ b/arch/powerpc/platforms/44x/Kconfig
> >> @@ -169,6 +169,15 @@ config YOSEMITE
> >>       help
> >>         This option enables support for the AMCC PPC440EP evaluation board.
> >>
> >> +config       BGP
> >
> > Does this FPU feature have a specific name like double hammer?  I'd
> > rather have the BGP defconfig depend on PPC_FPU_DOUBLE_HUMMER, or
> > something like that...
> >
> >> +     bool "Blue Gene/P"
> >> +     depends on 44x
> >> +     default n
> >> +     select PPC_FPU
> >> +     select PPC_DOUBLE_FPU
> >
> > ... in fact, it seem you are doing something like these here but you
> > don't use PPC_DOUBLE_FPU anywhere?
> >
> 
> A fair point.  I'm fine with calling it DOUBLE_HUMMER, but I wasn't sure if
> that was "too internal" of a name for the kernel.  Let me know and
> I'll fix it up.
> I'll also change the CONFIG_BGP defines in the FPU code to PPC_DOUBLE_FPU
> or PPC_DOUBLE_HUMMER depending on what the community decides.
> 
> Thanks for the feedback!
> 
>         -eric
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev


