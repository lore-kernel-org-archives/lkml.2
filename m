Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933653Ab1ESXQp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 19:16:45 -0400
Received: from ozlabs.org ([203.10.76.45]:54697 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932723Ab1ESXQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 19:16:43 -0400
From: Michael Neuling <mikey@neuling.org>
To: Eric Van Hensbergen <ericvh@gmail.com>
cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        bg-linux@lists.anl-external.org
Subject: Re: [PATCH 3/7] [RFC] add support for BlueGene/P FPU
In-reply-to: <BANLkTi=rc5vZm3xAXHpHSxSH1wBWKhv92A@mail.gmail.com>
References: <1305753895-24845-1-git-send-email-ericvh@gmail.com> <1305753895-24845-3-git-send-email-ericvh@gmail.com> <425.1305784718@neuling.org> <BANLkTimKhApFW8G1-pG0u_9Kv2YB0R1O0w@mail.gmail.com> <29601.1305840992@neuling.org> <BANLkTi=rc5vZm3xAXHpHSxSH1wBWKhv92A@mail.gmail.com>
Comments: In-reply-to Eric Van Hensbergen <ericvh@gmail.com>
   message dated "Thu, 19 May 2011 16:55:06 -0500."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.2.1
Date: Fri, 20 May 2011 09:16:41 +1000
Message-ID: <6241.1305847001@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <BANLkTi=rc5vZm3xAXHpHSxSH1wBWKhv92A@mail.gmail.com> you wrote:
> Damnit Mikey, just after I hit send on [V2].....
> 
> On Thu, May 19, 2011 at 4:36 PM, Michael Neuling <mikey@neuling.org> wrote:
> > In message <BANLkTimKhApFW8G1-pG0u_9Kv2YB0R1O0w@mail.gmail.com> you wrote=
> :
> >> On Thu, May 19, 2011 at 12:58 AM, Michael Neuling <mikey@neuling.org> wr=
> ote=3D
> >> :
> >> > Eric,
> >> >
> >> >> This patch adds save/restore register support for the BlueGene/P
> >> >> double hummer FPU.
> >> >
> >> > What does this mean? =3DA0Needs more details here.
> >> >
> 
> okay, I've changed it a bit in [V2], if you want more I can do my best.

If you can describe the whole primary and secondary registers that'd be
cool.  ASCII art would be awesome! :-)


> 
> >> "Each of the two FPU units contains 32 64-bit floating point registers
> >> for a total of 64 FP registers per processor." which would seem to
> >> point to the kittyhawk version - but they have a second SAVE_32SFPRS
> >> for the second hummer. =A0What wasn't clear to me with this version of
> >> the code was whether or not they were doing something clever like
> >> saving the pair of the 64-bit FPU registers in a single 128-bit slot
> >> (seems plausible).
> >
> > Ok, sounds like there is 32*8*2 bytes of data, rather than the normal
> > 32*8 bytes for FP only (ignoring VSX). =A0If this is the case, then you'l=
> l
> > need make 'fpr' in the thread struct bigger which you can do by setting
> > TS_FPRWIDTH =3D 2 like we do for VSX.
> >
> 
> Okay, I'll incorporate that into [V3].
> 
> > If there is some instruction that saves and restores two of these at a
> > time (which LFPDX/STFPDX might I guess), then we can use that, otherwise
> > we'll have to do 64 saves/restores. =A0Double load/stores will be faster
> > I'm guessing though.
> 
> I assume that's true.
> 
> >
> > If two at a time, do we need to increase the index in pairs?
> >
> 
> I don't believe so.
> 
> >> If this is not the way to go, I can certainly
> >> switch the kittyhawk version of the patch with the *, the extra
> >> SAVE32SFPR and the extra double hummer specific storage space in the
> >> thread_struct.
> >
> > I'd be tempted to keep it in the 'fpr' part of the struct so you can
> > then access it with ptrace/signals/core dumps.
> >
> >> If it would help I can post an alternate version of the patch for
> >> discussion with the kittyhawk version.
> >
> > Sure.
> >
> 
> Kittyhawk version can be seen here:
> 
> http://git.kernel.org/?p=3Dlinux/kernel/git/ericvh/bluegene.git;a=3Dcommitd=
> iff;h=3D94bffe786324b9bd07187b11afd836e3ec362d95

OK.  I can see the secondary.

BTW I think it's buggy in a different way.

--- a/arch/powerpc/kernel/fpu.S
+++ b/arch/powerpc/kernel/fpu.S
@@ -51,6 +51,9 @@ _GLOBAL(load_up_fpu)
        toreal(r4)
        addi    r4,r4,THREAD            /* want last_task_used_math->thread */
        SAVE_32FPRS(0, r4)
+#ifdef CONFIG_DOUBLE_HUMMER
+        SAVE_32SFPRS(0, r10, r3)
+#endif /* CONFIG_DOUBLE_HUMMER */
        mffs    fr0
        stfd    fr0,THREAD_FPSCR(r4)
        PPC_LL  r5,PT_REGS(r4)
@@ -78,6 +81,9 @@ _GLOBAL(load_up_fpu)
        lfd     fr0,THREAD_FPSCR(r5)
        MTFSF_L(fr0)
        REST_32FPRS(0, r5)
+#ifdef  CONFIG_DOUBLE_HUMMER
+        REST_32SFPRS(0, r10, r5)
+#endif  /* CONFIG_DOUBLE_HUMMER */

REST uses r5 as the base in both cases (primary and secondary) which is
good.  SAVE uses r4 in the primary case and r3 in the secondary, which
is the wrong base. 

> 
> >
> > The most useful thing would be to see the instruction definition for
> > STFPDX/LFPDX.
> >
> 
> https://wiki.alcf.anl.gov/images/d/d9/PPC440_FP2_arch.pdf

stfpdx  does Primary->DW[EA]  Secondary->DW[EA+8]

I'm tempted to continue to use this and store the data in 'fpr' in the
thread_struct.  Doing it this way the primary register will continue to
be in the same location as before, which will mean ptrace etc will
continue to work at least for the primary.  The secondary will be
accessible using ptrace etc as well, but it'll be a bit of kludge
because it'll appear in the VSX location.

Putting the secondary register in a new area in the thread struct will
mean it's totally inaccessible for debugging without extra code in
ptrace.c/signals.c etc

We are going to need 16x spacing but you are doing to have to increase
the size using TS_FPRWIDTH = 2.

> >>
> >> >> =3DA0/*
> >> >> diff --git a/arch/powerpc/platforms/44x/Kconfig b/arch/powerpc/platfo=
> rms=3D
> >> /44x/
> >> > Kconfig
> >> >> index f485fc5f..24a515e 100644
> >> >> --- a/arch/powerpc/platforms/44x/Kconfig
> >> >> +++ b/arch/powerpc/platforms/44x/Kconfig
> >> >> @@ -169,6 +169,15 @@ config YOSEMITE
> >> >> =3DA0 =3DA0 =3DA0 help
> >> >> =3DA0 =3DA0 =3DA0 =3DA0 This option enables support for the AMCC PPC4=
> 40EP evalua=3D
> >> tion board.
> >> >>
> >> >> +config =3DA0 =3DA0 =3DA0 BGP
> >> >
> >> > Does this FPU feature have a specific name like double hammer? =3DA0I'=
> d
> >> > rather have the BGP defconfig depend on PPC_FPU_DOUBLE_HUMMER, or
> >> > something like that...
> >> >
> >> >> + =3DA0 =3DA0 bool "Blue Gene/P"
> >> >> + =3DA0 =3DA0 depends on 44x
> >> >> + =3DA0 =3DA0 default n
> >> >> + =3DA0 =3DA0 select PPC_FPU
> >> >> + =3DA0 =3DA0 select PPC_DOUBLE_FPU
> >> >
> >> > ... in fact, it seem you are doing something like these here but you
> >> > don't use PPC_DOUBLE_FPU anywhere?
> >> >
> >>
> >> A fair point. =A0I'm fine with calling it DOUBLE_HUMMER, but I wasn't su=
> re if
> >> that was "too internal" of a name for the kernel. =A0Let me know and
> >> I'll fix it up.
> >
> > What I'm mostly concerned about is disassociating it with a particular
> > CPU.
> >
> > If it has an external name, then all the better.
> >
> 
> Since it isn't available on other chips, shoudl it just be PPC_BGP_FPU
> or PPC_BGP_DOUBLE_FPU?

I'd probably still prefer it disassociated with the CPU name, but we are
really bike shedding here.  I'm not too fussed.

Mikey
