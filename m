Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598Ab0CURRR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 13:17:17 -0400
Received: from mail2.shareable.org ([80.68.89.115]:59569 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab0CURRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 13:17:15 -0400
Date: Sun, 21 Mar 2010 17:16:34 +0000
From: Jamie Lokier <jamie@shareable.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Paulius Zaleckas <paulius.zaleckas@gmail.com>, nico@cam.org,
       rth@twiddle.net, nico@fluxnic.net, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, u.kleine-koenig@pengutronix.de,
       simon.kagstrom@netinsight.net, akpm@linux-foundation.org,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] MTD: Fix Orion NAND driver compilation with ARM OABI
Message-ID: <20100321171634.GB4174@shareable.org>
References: <20100320085507.4038.96426.stgit@pauliusz> <1269078083.4028.5586.camel@macbook.infradead.org> <badfd5ba1003200420xc0680c1h8b4cccd02a8fdaba@mail.gmail.com> <1269086286.4028.6039.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269086286.4028.6039.camel@macbook.infradead.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse wrote:
> Strictly speaking, I think your version is wrong -- although you force
> the variable 'x' to be stored in r2/r3, you don't actually force GCC to
> use r2/r3 as the output registers for the asm statement -- it could
> happily use other registers, then move their contents into r2/r3
> afterwards.

We used to do that a lot in the syscall macros in <asm/unistd.h>, on a
lot of architectures.  Were they all broken?

> Obviously it _won't_ do that most of the time, but it _could_. GCC PR
> #15089 was filed for the fact that sometimes it does, but I think Nico
> was missing the point -- GCC is _allowed_ to do that, and if it makes
> you sad then you should be asking for better assembly constraints which
> would allow you to tell it not to.

>From the GCC info documentation:

    Sometimes you need to make an `asm' operand be a specific register,
    but there's no matching constraint letter for that register _by
    itself_.  To force the operand into that register, use a local variable
    for the operand and specify the register in the variable declaration.
    *Note Explicit Reg Vars::.  Then for the `asm' operand, use any
    register constraint letter that matches the register:

         register int *p1 asm ("r0") = ...;
         register int *p2 asm ("r1") = ...;
         register int *result asm ("r0");
         asm ("sysint" : "=r" (result) : "0" (p1), "r" (p2));

Fwiw, that note is present in GCC-4.0.1, but not GCC-3.3.6.  But we've
depended on that behaviour for a long time.

Note that we've depended on GCC not copying values with a dereferenced
memory location for a long time too: E.g. "+m" (*ptr) is used a lot in
spinlocks.

I'm sure I've read email confirmation (on these very lists) that GCC
will always work with a memory constraint used in that way, without
copying the value to/from a different location such as a stack slot.

But suprisingly, the GCC documentation says:

    Extended asm supports input-output or read-write operands.  Use
    the constraint character `+' to indicate such an operand and list
    it with the output operands.  You should only use read-write
    operands when the constraints for the operand (or the operand in
    which only some of the bits are to be changed) allow a register.
                                                   ^^^^^^^^^^^^^^^^

Maybe we're relying on undefined GCC behaviour for the "+m" constraint?

> See the __asmeq() macro in <asm/system.h> for a dirty hack which will
> check which registers are used and abort at compile time, although your
> compilation is going to fail anyway so I'm not sure it makes much of a
> difference in this particular case.
> 
> The real fix here is to add an asm constraint to GCC which allows you to
> specify "any even GPR" (or whatever's most suitable for the ldrd
> instruction). Being able to give specific registers, like you can on
> other architectures, would be useful too.

See above GCC documentation for using register variables to designate
specific registers.  Many supported architectures don't have asm
letter constraints for each register - hence so many of the old
_syscallN macros in <asm/unistd.h> having to use register variables.

I am surprised GCC doesn't have a constraint for "any even register
suitable for ldrd" on ARM, but I've just checked gcc-4.4.3 and it doesn't.

However, if I'm reading the source correctly, if not compiling for
Thumb-1, and GCC believes the target machine supports ldrd, then all
doubleword values are constrained to an even register pair anyway.
That's why GCC itself does not need an even-register constraint letter.

...Which is I guess why it throws up only with OABI, or with pre-arm5e
archs: GCC doesn't consider OABI targets to support ldrd.  (It's
actually some more obscure condition, let's not go there).

Something else from the lovely GCC source:

    mfix-cortex-m3-ldrd
    Target Report Var(fix_cm3_ldrd) Init(2)
    Avoid overlapping destination and address registers on LDRD instructions
    that may trigger Cortex-M3 errata.

In other words, the "=&" earlyclobber *is* needed on Cortex-M3.

Enjoy!
-- Jamie
