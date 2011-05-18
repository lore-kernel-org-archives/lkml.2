Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834Ab1ERHag (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 03:30:36 -0400
Received: from www.linutronix.de ([62.245.132.108]:50589 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570Ab1ERHaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 03:30:35 -0400
Date: Wed, 18 May 2011 09:30:22 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Lutomirski <luto@mit.edu>
cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Borislav Petkov <bp@amd64.org>
Subject: Re: [PATCH v4 0/6] Micro-optimize vclock_gettime
In-Reply-To: <BANLkTik9+UGLvPCLYO246N4fMxJ5F=vHwA@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1105180839370.3078@ionos>
References: <20110516160943.GC25898@one.firstfloor.org> <alpine.LFD.2.02.1105161817120.3078@ionos> <20110516164939.GD25898@one.firstfloor.org> <BANLkTintkmnkN3kW06oa+TjT7W0Q1yQQGA@mail.gmail.com> <m2fwoeo0pf.fsf@firstfloor.org> <alpine.LFD.2.02.1105162345110.3078@ionos>
 <BANLkTinVnr1ZM2wOxuH-rHZGh+_SBWT-+g@mail.gmail.com> <alpine.LFD.2.02.1105170022430.3078@ionos> <20110517080029.GB22093@elte.hu> <BANLkTimpEfb3P9FWgrCDwSSVr6RA8nXb5w@mail.gmail.com> <20110517113634.GC13475@elte.hu> <4DD2BEFB.6070609@mit.edu>
 <m2hb8typxt.fsf@firstfloor.org> <alpine.LFD.2.02.1105172354040.3078@ionos> <BANLkTik9+UGLvPCLYO246N4fMxJ5F=vHwA@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 May 2011, Andrew Lutomirski wrote:
> On Tue, May 17, 2011 at 6:59 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > Furthermore any halfways up to date deployemnt is using VDSO for
> > obvious reasons and the archaic stuff which might be affected is not
> > using a recent kernel at all (except for akpm on his retro laptop, but
> > that "performance penalty" is probably the least of his worries).
> 
> Sadly that's not quite true.  glibc git right now contains this:
> 
> ENTRY (__gettimeofday)
>         /* Align stack.  */
>         sub     $0x8, %rsp
>         cfi_adjust_cfa_offset(8)
> #ifdef SHARED
>         movq    __vdso_gettimeofday(%rip), %rax
>         PTR_DEMANGLE (%rax)
> #else
>         movq    $VSYSCALL_ADDR_vgettimeofday, %rax
> #endif
>         callq   *%rax

I know that, but again: Are statically linked binaries a real issue ?
 
> And time() and sched_getcpu() call the vsyscall page unconditionally.

Dammit, time() is a real problem. I missed that and thought that it's
gettimeofday() alone for the static case. sched_getcpu() is nothing to
worry about.

> We should either declare CLOCK_REALTIME_COARSE to be acceptable for
> time() or add a new vDSO call.

Separate call.

> IMO we should put a note in feature-removal-schedule.txt, add vsyscall
> emulation as a config option for 2.6.41 but leave it turned off by
> default, and turn it on by default (or just remove the old code) in
> 2.6.43 or so.  That'll give glibc a chance to stop generating *new*
> static binaries that call it.
> 
> I'm not volunteering to dig around the libdl stuff to fix it myself.
> 
> klibc doesn't seem to use vsyscalls or the vDSO.  I haven't looked at
> uclibc, and I don't think that Bionic has any released version on
> x86_64.

uclibc is safe as well. The VSYSCALL usage is in the futex code, but
is conditional and not used on current kernels. That code is copied
from glibc.

Thanks,

	tglx
