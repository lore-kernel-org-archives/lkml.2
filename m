Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934872Ab1ESVgg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 17:36:36 -0400
Received: from ozlabs.org ([203.10.76.45]:36573 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934807Ab1ESVge (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 17:36:34 -0400
From: Michael Neuling <mikey@neuling.org>
To: Eric Van Hensbergen <ericvh@gmail.com>
cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        bg-linux@lists.anl-external.org
Subject: Re: [PATCH 3/7] [RFC] add support for BlueGene/P FPU
In-reply-to: <BANLkTimKhApFW8G1-pG0u_9Kv2YB0R1O0w@mail.gmail.com>
References: <1305753895-24845-1-git-send-email-ericvh@gmail.com> <1305753895-24845-3-git-send-email-ericvh@gmail.com> <425.1305784718@neuling.org> <BANLkTimKhApFW8G1-pG0u_9Kv2YB0R1O0w@mail.gmail.com>
Comments: In-reply-to Eric Van Hensbergen <ericvh@gmail.com>
   message dated "Thu, 19 May 2011 08:53:51 -0500."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.2.1
Date: Fri, 20 May 2011 07:36:32 +1000
Message-ID: <29601.1305840992@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <BANLkTimKhApFW8G1-pG0u_9Kv2YB0R1O0w@mail.gmail.com> you wrote:
> On Thu, May 19, 2011 at 12:58 AM, Michael Neuling <mikey@neuling.org> wrote=
> :
> > Eric,
> >
> >> This patch adds save/restore register support for the BlueGene/P
> >> double hummer FPU.
> >
> > What does this mean? =A0Needs more details here.
> >
> 
> Hi Mikey,
> 
> any specific details you are looking for here?  AFAIK these patches
> are required for the kernel to save/restore the double hummer
> properly.

I should have been more specific.  What does double hammer mean?

I description of how double hammer differs from normal and why a change
in the fpu code is needed would be great.

> 
> >>
> >> +#ifdef CONFIG_BGP
> >> +#define LFPDX(frt, ra, rb) =A0 .long (31<<26)|((frt)<<21)|((ra)<<16)| \
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ((rb)<<11)|(462<<1)
> >> +#define STFPDX(frt, ra, rb) =A0.long (31<<26)|((frt)<<21)|((ra)<<16)| \
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ((rb)<<11)|(974<<1)
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
> >> +#define SAVE_FPR(n, b, base) li b, THREAD_FPR0+(16*(n)); STFPDX(n, base=
> , b)
> >> +#define REST_FPR(n, b, base) li b, THREAD_FPR0+(16*(n)); LFPDX(n, base,=
>  b)
> >
> > 16*? =A0Are these FP regs 64 or 128 bits wide? =A0If 128 you are doing to
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
> (seems plausible).  

Ok, sounds like there is 32*8*2 bytes of data, rather than the normal
32*8 bytes for FP only (ignoring VSX).  If this is the case, then you'll
need make 'fpr' in the thread struct bigger which you can do by setting
TS_FPRWIDTH = 2 like we do for VSX.

If there is some instruction that saves and restores two of these at a
time (which LFPDX/STFPDX might I guess), then we can use that, otherwise
we'll have to do 64 saves/restores.  Double load/stores will be faster
I'm guessing though.  

If two at a time, do we need to increase the index in pairs?

> If this is not the way to go, I can certainly
> switch the kittyhawk version of the patch with the *, the extra
> SAVE32SFPR and the extra double hummer specific storage space in the
> thread_struct.  

I'd be tempted to keep it in the 'fpr' part of the struct so you can
then access it with ptrace/signals/core dumps.

> If it would help I can post an alternate version of the patch for
> discussion with the kittyhawk version.

Sure.

The most useful thing would be to see the instruction definition for
STFPDX/LFPDX.

> 
> >> =A0/*
> >> diff --git a/arch/powerpc/platforms/44x/Kconfig b/arch/powerpc/platforms=
> /44x/
> > Kconfig
> >> index f485fc5f..24a515e 100644
> >> --- a/arch/powerpc/platforms/44x/Kconfig
> >> +++ b/arch/powerpc/platforms/44x/Kconfig
> >> @@ -169,6 +169,15 @@ config YOSEMITE
> >> =A0 =A0 =A0 help
> >> =A0 =A0 =A0 =A0 This option enables support for the AMCC PPC440EP evalua=
> tion board.
> >>
> >> +config =A0 =A0 =A0 BGP
> >
> > Does this FPU feature have a specific name like double hammer? =A0I'd
> > rather have the BGP defconfig depend on PPC_FPU_DOUBLE_HUMMER, or
> > something like that...
> >
> >> + =A0 =A0 bool "Blue Gene/P"
> >> + =A0 =A0 depends on 44x
> >> + =A0 =A0 default n
> >> + =A0 =A0 select PPC_FPU
> >> + =A0 =A0 select PPC_DOUBLE_FPU
> >
> > ... in fact, it seem you are doing something like these here but you
> > don't use PPC_DOUBLE_FPU anywhere?
> >
> 
> A fair point.  I'm fine with calling it DOUBLE_HUMMER, but I wasn't sure if
> that was "too internal" of a name for the kernel.  Let me know and
> I'll fix it up.

What I'm mostly concerned about is disassociating it with a particular
CPU.  

If it has an external name, then all the better.

> I'll also change the CONFIG_BGP defines in the FPU code to PPC_DOUBLE_FPU
> or PPC_DOUBLE_HUMMER depending on what the community decides.

Mikey
