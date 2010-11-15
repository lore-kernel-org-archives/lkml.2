Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933558Ab0KOTN5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 14:13:57 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40022 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933542Ab0KOTNz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 14:13:55 -0500
MIME-Version: 1.0
In-Reply-To: <4CE17FB6.7000800@redhat.com>
References: <4CD538CA.8010901@xs4all.nl> <87wroostw3.fsf@basil.nowhere.org>
 <m2hbfsu57i.fsf@igel.home> <87k4kospnd.fsf@basil.nowhere.org>
 <AANLkTikG6kBxSrO7EZ5_nZqTKqo8Rjm2stoEGVJWxanz@mail.gmail.com> <4CE17FB6.7000800@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 15 Nov 2010 11:04:49 -0800
Message-ID: <AANLkTim48YSGCdtPLqpPyELA8w-Jo=zMGkDN3omJW1ec@mail.gmail.com>
Subject: Re: gcc 4.5.1 / as 2.20.51.0.11 miscompiling drivers/char/i8k.c ?
To: Jeff Law <law@redhat.com>
Cc: Richard Guenther <richard.guenther@gmail.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andreas Schwab <schwab@linux-m68k.org>, Jim <jim876@xs4all.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        gcc@gcc.gnu.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 15, 2010 at 10:45 AM, Jeff Law <law@redhat.com> wrote:
>
> A memory clobber should clobber anything in memory, including autos in
> memory; if it doesn't, then that seems like a major problem.  I'd like to
> see the rationale behind not clobbering autos in memory.

Yes. It turns out that the "asm optimized away" was entirely wrong (we
never saw that, it was just a report on another mailing list).

Looking at the asm posted, it seems to me that gcc actually compiles
the asm itself 100% correctly, and the "memory" clobber is working
fine inside that function. So the code generated for i8k_smm() itself
is all good.

But _while_ generating the good code, gcc doesn't seem to realize that
it writes to anything, so it decides to mark the function
"__attribute__((const))", which is obviously wrong (a memory clobber
definitely implies that it's not const). And as a result, the callers
will be mis-optimized, because they do things like

    static int i8k_get_bios_version(void)
    {
        struct smm_regs regs = { .eax = I8K_SMM_BIOS_VERSION, };

        return i8k_smm(&regs) ? : regs.eax;
    }

and since gcc has (incorrectly) decided that "i8k_smm()" is a const
function, it thinks that "regs.eax" hasn't changed, so it doesn't
bother to reload it: it "knows" that it is still I8K_SMM_BIOS_VERSION
that it initialized it with. So it will basically have rewritten that
final return statement as

        return i8k_smm(&regs) ? : I8K_SMM_BIOS_VERSION;

which obviously doesn't really work.

This also explains why adding "volatile" worked. The "asm volatile"
triggered "this is not a const function".

Similarly, the "+m" works, because it also makes clear that the asm is
writing to memory, and isn't a const function.

Now, the "memory" clobber should clearly also have done that, but I'd
be willing to bet that some version of gcc (possibly extra slackware
patches) had forgotten the trivial logic to say "a memory clobber also
makes the user function non-const".

                 Linus
