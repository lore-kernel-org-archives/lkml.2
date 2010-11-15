Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932607Ab0KODWN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 22:22:13 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36820 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932550Ab0KODWM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 22:22:12 -0500
MIME-Version: 1.0
In-Reply-To: <m31v6nmmr3.fsf@jhcloos.com>
References: <4CD538CA.8010901@xs4all.nl> <87wroostw3.fsf@basil.nowhere.org>
 <m2hbfsu57i.fsf@igel.home> <87k4kospnd.fsf@basil.nowhere.org>
 <AANLkTikG6kBxSrO7EZ5_nZqTKqo8Rjm2stoEGVJWxanz@mail.gmail.com>
 <877hgorrj1.fsf@basil.nowhere.org> <4CD843DC.10106@gmail.com>
 <Pine.LNX.4.64.1011091352460.29956@wotan.suse.de> <20101109134816.GB29433@basil.fritz.box>
 <m3lj52txaq.fsf@redhat.com> <4CD97A3D.1040602@xs4all.nl> <m31v6nmmr3.fsf@jhcloos.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 14 Nov 2010 19:21:50 -0800
Message-ID: <AANLkTim2rCuF4p0719YQ3=0s7jhk5FOuTHHAeBWBhvR=@mail.gmail.com>
Subject: Re: gcc 4.5.1 / as 2.20.51.0.11 miscompiling drivers/char/i8k.c ?
To: James Cloos <cloos@jhcloos.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andreas Schwab <schwab@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Michael Matz <matz@suse.de>, Dave Korn <dave.korn.cygwin@gmail.com>,
        Richard Guenther <richard.guenther@gmail.com>, gcc@gcc.gnu.org,
        Jim Bos <jim876@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 14, 2010 at 4:52 PM, James Cloos <cloos@jhcloos.com> wrote:
> Gcc 4.5.1 running on an amd64 box "cross"-compiling for a P3 i8k fails
> to compile the module since commit 6b4e81db2552bad04100e7d5ddeed7e848f53b48
> with:
>
>  CC      drivers/char/i8k.o
> drivers/char/i8k.c: In function ‘i8k_smm’:
> drivers/char/i8k.c:149:2: error: can't find a register in class ‘GENERAL_REGS’ while reloading ‘asm’
> drivers/char/i8k.c:149:2: error: ‘asm’ operand has impossible constraints

At this point, I think this falls clearly under "unresolvable gcc bug".

Quite frankly, I think gcc was buggy to begin with: since we had a
memory clobber, the "+m" (*regs) should not have mattered. The fact
that "*regs" may be some local variable doesn't make any difference
what-so-ever, since we took the address of the variable. So the memory
clobber _clearly_ can change that variable.

So when Richard Gunther says "a memory clobber doesn't cover automatic
storage", to me that very clearly spells "gcc is buggy as hell".
Because automatic storage with its address taken _very_ much gets
clobbered by things like memset etc. If the compiler doesn't
understand that, the compiler is just broken.

And now, if even the (superfluous) "+m" isn't working, it sounds like
we have no sane options left. Except to say that gcc-4.5.1 is totally
broken wrt asms.

Can we just get gcc to realize that when you pass the address of
automatic storage to an asm, that means that "memory" really does
clobber it? Because clearly that is the case.

                        Linus
