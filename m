Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696Ab2ERPDU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 11:03:20 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:17892 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab2ERPDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 11:03:18 -0400
Message-ID: <4FB664B3.7090100@tilera.com>
Date: Fri, 18 May 2012 11:03:15 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        <libc-ports@sourceware.org>
CC: David Daney <ddaney.cavm@gmail.com>, Ralf Baechle <ralf@linux-mips.org>,
        "H.J. Lu" <hjl.tools@gmail.com>, <linux-kernel@vger.kernel.org>,
        <linux-arch@vger.kernel.org>, <mingo@kernel.org>, <tglx@linutronix.de>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 08/10] Use __kernel_ulong_t in struct msqid64_ds
References: <1337292816-10839-1-git-send-email-hjl.tools@gmail.com> <1337292816-10839-9-git-send-email-hjl.tools@gmail.com> <4FB58EFD.7010302@zytor.com> <CA+55aFy+XOc350sVuLKDHAaKtz9GdLcVmjxs98N8XLTK4zmMYg@mail.gmail.com> <4FB59474.2020505@zytor.com> <4FB597F3.3060909@gmail.com> <4FB599AC.1010807@zytor.com>
In-Reply-To: <4FB599AC.1010807@zytor.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Cc'ing libc-ports and Arnd Bergmann.)

On 5/17/2012 8:37 PM, H. Peter Anvin wrote:
> It looks like MIPS has a private definition of struct msqid64_ds, as do
> most other architectures; the MIPS one is completely broken for user
> space usages as it uses CONFIG_* macros:
> 
> #if defined(CONFIG_32BIT) && !defined(CONFIG_CPU_LITTLE_ENDIAN)
>         unsigned long   __unused2;
> #endif
>         __kernel_time_t msg_rtime;      /* last msgrcv time */
> #if defined(CONFIG_32BIT) && defined(CONFIG_CPU_LITTLE_ENDIAN)
>         unsigned long   __unused2;
> #endif
> 
> It looks like the only users of asm-generic here are:
> 
> arch/microblaze/include/asm/msgbuf.h:#include <asm-generic/msgbuf.h>
> arch/score/include/asm/msgbuf.h:#include <asm-generic/msgbuf.h>
> arch/sh/include/asm/msgbuf.h:#include <asm-generic/msgbuf.h>
> arch/x86/include/asm/msgbuf.h:#include <asm-generic/msgbuf.h>
> 
> ... and unless I'm mistaken, x86 is the only one of those which isn't 32
> bits only, which explains the reason it "works"...

Don't forget the newer architectures that use generic-y:

arch/blackfin/include/asm/Kbuild:generic-y += msgbuf.h
arch/c6x/include/asm/Kbuild:generic-y += msgbuf.h
arch/hexagon/include/asm/Kbuild:generic-y += msgbuf.h
arch/openrisc/include/asm/Kbuild:generic-y += msgbuf.h
arch/tile/include/asm/Kbuild:generic-y += msgbuf.h
arch/unicore32/include/asm/Kbuild:generic-y += msgbuf.h

On 5/17/2012 8:22 PM, Linus Torvalds wrote:
> That's why I think it's unfixable. It started out broken, and I
> presume that 32-bit user land on a 64-bit MIPS/PPC thing either do not
> work, or there's some compat crap (like special user-land headers)
> fixing things up. Or they just don't use that buggered msqid64_ds
> thing at all.

Yes, it's compat crap.  Each architecture defines its own compat_msqid64_ds
that carefully places the padding in the same place as the corresponding
native 32-bit kernel puts it, and glibc doesn't use <asm/msgbuf.h> at all,
but instead provides a hand-rolled <bits/msq.h>.

I added a glibc <bits/msq.h> that targets the asm-generic version of the
header, so it puts the padding after the time_t, even on big-endian
platforms.  This is of course crazy, but it's what you need to do to use
the current asm-generic header.

However, now is a good time to ask whether this is the right thing to do
going forward.  The tile architecture is the only one that currently offers
a 32-bit big-endian userspace (only in linux-next, queued for 3.5) and also
uses <asm-generic> for the SysV stuff, so if someone wants to advocate for
changing this, now is definitely a good time for it.

We could modify asm-generic so that it puts the padding where it "ought" to
go, easily enough.  This would then allow three of the four big-endian
32-bit architectures (sparc, parisc, powerpc) to use the generic headers,
if they wished.  (The fourth one, s390, puts the padding after, like
asm-generic currently does.)

This might then allow us to consider making "struct compat_msqid64_ds" and
friends something that is defined in <linux/compat.h> rather than
per-architecture, though we'd need a hook to allow architectures like s390
to override and provide their own definition.

As far as x32 goes, this should all be largely irrelevant, since it likely
won't use the compat structures anyway, and since we're not proposing
breaking the little-endian layout.  But future x32-style compat big-endian
architectures would benefit from having a msqid64_ds structure that
actually lays out the same in 32- or 64-bit mode.
-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com
