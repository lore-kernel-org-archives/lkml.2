Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004Ab0FLOS6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jun 2010 10:18:58 -0400
Received: from mail.skyhub.de ([78.46.96.112]:48164 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752197Ab0FLOSz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jun 2010 10:18:55 -0400
Date: Sat, 12 Jun 2010 16:18:37 +0200
From: Borislav Petkov <bp@alien8.de>
To: Paolo Giarrusso <p.giarrusso@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Borislav Petkov <borislav.petkov@amd.com>,
       Toralf =?utf-8?Q?F=C3=B6rster?= <toralf.foerster@gmx.de>,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Jeff Dike <jdike@addtoit.com>
Subject: Re: [uml-devel] [PATCH] x86, hweight: Fix UML boot crash
Message-ID: <20100612141837.GA28572@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Paolo Giarrusso <p.giarrusso@gmail.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Borislav Petkov <borislav.petkov@amd.com>,
	Toralf =?utf-8?Q?F=C3=B6rster?= <toralf.foerster@gmx.de>,
	user-mode-linux-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org, Jeff Dike <jdike@addtoit.com>
References: <201005271944.09541.toralf.foerster@gmx.de>
 <AANLkTimKwxYxM_PExplIDK1WPTQ9e_-CHn5SnIvfjfUg@mail.gmail.com>
 <20100530150214.GA1565@liondog.tnic>
 <201005301728.25976.toralf.foerster@gmx.de>
 <20100530170346.GC1565@liondog.tnic>
 <4C02B020.2040103@zytor.com>
 <20100530193956.GA2498@liondog.tnic>
 <20100530201738.GB2498@liondog.tnic>
 <4C02D408.1030306@zytor.com>
 <AANLkTimPSQ3K6ulqGV243w__IbMaJTG71VckB8gl701u@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <AANLkTimPSQ3K6ulqGV243w__IbMaJTG71VckB8gl701u@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paolo Giarrusso <p.giarrusso@gmail.com>
Date: Sat, Jun 12, 2010 at 03:34:38PM +0200

Hi,

> > That looks better to me, although I'm still wondering why UML can't
> > stomach the register-saving tricks... it is not at all "obvious" why
> > that can't be done.
> Hi all, and sorry for the delay, I hope you still care about this.
> 
> First, ARCH_HWEIGHT_CFLAGS should IMHO be shared with UML. I.e., moved
> to arch/x86/Kconfig.cpu (which was born as Kconfig code shared with
> UML), or copied in UML (it's not defined, as far as I can see).
> Otherwise it just can't work. And I think that's it.
> 
> Second, I've been looking at arch_hweight.h to try answering as well,
> and my question is: did somebody ever implement ALTERNATIVE support on
> UML? When I worked on it, this thing didn't exist at all. The user
> declared the host CPU, and we enabled features based on that. There's
> barely code for exception tables, and we never used it to implement
> copy_from_user and staff like that (I recall the exception handler was
> set at run-time).
> 
> Indeed, arch/um/kernel/um_arch.c:apply_alternatives() is empty. And I
> mean, implementing it is not so trivial (unlike exception handling),
> simply because it requires making the binary mapping writable, and I'm
> not sure UML does it already.

Which would mean that UML doesn't use alternatives at all and uses the
instructions which are meant to be replaced instead, no? In that case,
fixing this is either by rerouting the includes (easiest, already in
-tip) or adding alternatives support (harder, needs volunteers :)).

> A third note is that UML links with glibc, so it can have a different
> calling convention from the kernel. Say, on x86 32bit regparm doesn't
> work (in fact, -mregparm is set in arch/x86/Makefile and not in
> arch/x86/Makefile_32.cpu). And since popcnt is supported on 32bit, it
> might in theory make a difference for that case. But maybe those flags
> are simply fine, I didn't recheck the possible calling conventions.

If this is also the case, the -fcall-saved-* stuff won't work on UML and
yet another way of doing "call *func" from within asm("...") and making
sure the callee doesn't clobber caller's regs will be needed for UML.

-- 
Regards/Gruss,
    Boris.
