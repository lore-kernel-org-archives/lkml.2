Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758059Ab0KOS4p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 13:56:45 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36178 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757067Ab0KOS4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 13:56:43 -0500
MIME-Version: 1.0
In-Reply-To: <4CE17C4B.1070305@xs4all.nl>
References: <4CD843DC.10106@gmail.com> <Pine.LNX.4.64.1011091352460.29956@wotan.suse.de>
 <20101109134816.GB29433@basil.fritz.box> <m3lj52txaq.fsf@redhat.com>
 <4CD97A3D.1040602@xs4all.nl> <m31v6nmmr3.fsf@jhcloos.com> <AANLkTim2rCuF4p0719YQ3=0s7jhk5FOuTHHAeBWBhvR=@mail.gmail.com>
 <20101115085605.GE2583@sunsite.ms.mff.cuni.cz> <20101115100331.GG2583@sunsite.ms.mff.cuni.cz>
 <20101115105446.GD7269@basil.fritz.box> <20101115111642.GU29412@tyan-ft48-01.lab.bos.redhat.com>
 <AANLkTi=jwrt2VE5tnL9NR2WhGDnQtv+k6rapnHfsy_aL@mail.gmail.com>
 <4CE17098.8090000@xs4all.nl> <AANLkTimEw0U5TqMcmoeShXQ67kqp32hp5fwd2oRQhWo2@mail.gmail.com>
 <4CE17C4B.1070305@xs4all.nl>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 15 Nov 2010 10:56:14 -0800
Message-ID: <AANLkTinr8wFmXibOy8SgAsbH=u8G7QVp4UUcjTRjOOqs@mail.gmail.com>
Subject: Re: gcc 4.5.1 / as 2.20.51.0.11 miscompiling drivers/char/i8k.c ?
To: Jim Bos <jim876@xs4all.nl>
Cc: Jakub Jelinek <jakub@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        James Cloos <cloos@jhcloos.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andreas Schwab <schwab@redhat.com>, Michael Matz <matz@suse.de>,
        Dave Korn <dave.korn.cygwin@gmail.com>,
        Richard Guenther <richard.guenther@gmail.com>, gcc@gcc.gnu.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 15, 2010 at 10:30 AM, Jim Bos <jim876@xs4all.nl> wrote:
>
> Attached version with plain 2.6.36 source and version with the committed
> patch, i.e with the '"+m" (*regs)'

Looks 100% identical in i8k_smm() itself, and I'm not seeing anything
bad. The asm has certainly not been optimized away as implied in the
archlinux thread.

There are differences, but they are with code generation *elsewhere*.

To me it is starting to look like the real problem is that gcc has
decided that the "i8k_smm()" function is "__attribute__((const))".

Which is clearly totally bogus. If a function has an inline asm that
has a memory clobber, it is clearly *not* 'const'. But that does
explain the bug, and does explain why "+m" makes a difference and why
"noinline" does not.

So what I _think_ happens is that

 - gcc logic for the automatic 'const' attribute for functions is
broken, so it marks that function 'const'.

 - since the rule for a const function is that it only _looks_ at its
attributes and has no side effects, now the callers will decide that
'i8k_smm()' cannot change the passed-in structure, so they'll happily
optimize away all the accesses to it.

                       Linus
