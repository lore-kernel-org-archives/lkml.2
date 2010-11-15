Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114Ab0KOI5V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 03:57:21 -0500
Received: from sunsite.ms.mff.cuni.cz ([195.113.15.26]:39913 "EHLO
	sunsite.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941Ab0KOI5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 03:57:19 -0500
Date: Mon, 15 Nov 2010 09:56:05 +0100
From: Jakub Jelinek <jakub@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: James Cloos <cloos@jhcloos.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andreas Schwab <schwab@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Michael Matz <matz@suse.de>, Dave Korn <dave.korn.cygwin@gmail.com>,
        Richard Guenther <richard.guenther@gmail.com>, gcc@gcc.gnu.org,
        Jim Bos <jim876@xs4all.nl>
Subject: Re: gcc 4.5.1 / as 2.20.51.0.11 miscompiling drivers/char/i8k.c ?
Message-ID: <20101115085605.GE2583@sunsite.ms.mff.cuni.cz>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <87k4kospnd.fsf@basil.nowhere.org> <AANLkTikG6kBxSrO7EZ5_nZqTKqo8Rjm2stoEGVJWxanz@mail.gmail.com> <877hgorrj1.fsf@basil.nowhere.org> <4CD843DC.10106@gmail.com> <Pine.LNX.4.64.1011091352460.29956@wotan.suse.de> <20101109134816.GB29433@basil.fritz.box> <m3lj52txaq.fsf@redhat.com> <4CD97A3D.1040602@xs4all.nl> <m31v6nmmr3.fsf@jhcloos.com> <AANLkTim2rCuF4p0719YQ3=0s7jhk5FOuTHHAeBWBhvR=@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTim2rCuF4p0719YQ3=0s7jhk5FOuTHHAeBWBhvR=@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 14, 2010 at 07:21:50PM -0800, Linus Torvalds wrote:
> So when Richard Gunther says "a memory clobber doesn't cover automatic
> storage", to me that very clearly spells "gcc is buggy as hell".
> Because automatic storage with its address taken _very_ much gets
> clobbered by things like memset etc. If the compiler doesn't
> understand that, the compiler is just broken.

I'll leave the discussion about meaning of "memory" clobber aside to
Richard,

> And now, if even the (superfluous) "+m" isn't working, it sounds like
> we have no sane options left. Except to say that gcc-4.5.1 is totally

just to say that of course there are sane options left.

	    :"=a"(rc), "+m" (*regs)
            :    "a"(regs)
            :    "%ebx", "%ecx", "%edx", "%esi", "%edi", "memory");

is simply too high register pressure for i386 if you force also
-fno-omit-frame-pointer, there is not a single register left.

Yes, reload should figure out it has address of regs already tied to %eax,
unfortunately starting with IRA it doesn't (I'll file a GCC bug about that;
so that leaves 4.4/4.5/4.6 currently not being able to compile it).

That said, changing the inline asm to just clobber one less register
would be completely sufficient to make it work well with all gccs out there,
just push/pop one of the register around the whole body.  I doubt calling
out SMM BIOS is actually so performance critical that one push and one pop
would ruin it.  Of course x86_64 version can stay as is, there are enough
registers left...

	Jakub
