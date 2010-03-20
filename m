Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879Ab0CTOlp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 10:41:45 -0400
Received: from relais.videotron.ca ([24.201.245.36]:34669 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465Ab0CTOlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 10:41:44 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Sat, 20 Mar 2010 10:41:43 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: David Woodhouse <dwmw2@infradead.org>
Cc: Paulius Zaleckas <paulius.zaleckas@gmail.com>, rth@twiddle.net,
       akpm@linux-foundation.org, u.kleine-koenig@pengutronix.de,
       simon.kagstrom@netinsight.net, linux-mtd@lists.infradead.org,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MTD: Fix Orion NAND driver compilation with ARM OABI
In-reply-to: <1269086286.4028.6039.camel@macbook.infradead.org>
Message-id: <alpine.LFD.2.00.1003200944380.31128@xanadu.home>
References: <20100320085507.4038.96426.stgit@pauliusz>
 <1269078083.4028.5586.camel@macbook.infradead.org>
 <badfd5ba1003200420xc0680c1h8b4cccd02a8fdaba@mail.gmail.com>
 <1269086286.4028.6039.camel@macbook.infradead.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Mar 2010, David Woodhouse wrote:

> On Sat, 2010-03-20 at 13:20 +0200, Paulius Zaleckas wrote:
> > On Sat, Mar 20, 2010 at 11:41 AM, David Woodhouse <dwmw2@infradead.org> wrote:
> > > On Sat, 2010-03-20 at 10:55 +0200, Paulius Zaleckas wrote:
> > >> -             uint64_t x;
> > >> +             /*
> > >> +              * force x variable to r2/r3 registers since ldrd instruction
> > >> +              * requires first register to be even.
> > >> +              */
> > >> +             register uint64_t x asm ("r2");
> > >> +
> > >>               asm volatile ("ldrd\t%0, [%1]" : "=&r" (x) : "r" (io_base));
> > >
> > > Hm, isn't there an asm constraint which will force it into an
> > > appropriate register pair?
> > 
> > Not that I know of...

Digging into the gcc code there is indeed no way to specify an even 
register pair as a constraint. What's there is:

#define TARGET_LDRD                     (arm_arch5e && ARM_DOUBLEWORD_ALIGN)

and

#define ARM_DOUBLEWORD_ALIGN    TARGET_AAPCS_BASED

where AAPCS is equivalent to EABI.

> > > Failing that, "=&r2,r4,r6,r8" ought to work.
> > 
> > No, fails with error: matching constraint not valid in output operand
> 
> Hm, crap -- GCC on ARM doesn't let you give specific registers, so that
> trick doesn't work.
> 
> Strictly speaking, I think your version is wrong -- although you force
> the variable 'x' to be stored in r2/r3, you don't actually force GCC to
> use r2/r3 as the output registers for the asm statement -- it could
> happily use other registers, then move their contents into r2/r3
> afterwards.

Actually that's the other way around, and the GCC manual is 
contradicting you.  The value can be moved in other registers, but at 
the point of reference (which is the inline asm in this case) then the 
value has to be in the specified register.  Quoting the GCC manual in 
section 5.40 "Variables in Specified Registers":

|Local register variables in specific registers do not reserve the 
|registers, except at the point where they are used as input or output 
|operands in an `asm' statement and the `asm' statement itself is not 
|deleted.  The compiler's data flow analysis is capable of determining 
|where the specified registers contain live values, and where they are 
|available for other uses.  Stores into local register variables may be 
|deleted when they appear to be dead according to dataflow analysis.  
|References to local register variables may be deleted or moved or 
|simplified.
|
|These local variables are sometimes convenient for use with 
|the extended `asm' feature (*note Extended Asm::), if you want to write 
|one output of the assembler instruction directly into a particular 
|register.  (This will work provided the register you specify fits the 
|constraints specified for that operand in the `asm'.)

And that last paragraph is precisely what is being relied 
upon here.  Otherwise what would be the purpose left for this construct?

> Obviously it _won't_ do that most of the time, but it _could_. GCC PR
> #15089 was filed for the fact that sometimes it does, but I think Nico
> was missing the point -- GCC is _allowed_ to do that, and if it makes
> you sad then you should be asking for better assembly constraints which
> would allow you to tell it not to.

No.  PR #15089 was filed because this has been broken at some point when 
some code generation optimizations kicked in.  And the bug as now been 
fixed for more than 5 years now.

> See the __asmeq() macro in <asm/system.h> for a dirty hack which will
> check which registers are used and abort at compile time, although your
> compilation is going to fail anyway so I'm not sure it makes much of a
> difference in this particular case.

The __asmeq hack has been used as a safety guard so not to ban what used 
to be the current GCC version at the time this bug was discovered. 
Since this bug seemed to appear much less frequently
when using -Os instead of -O2 (the default on ARM) then the __asmeq was 
a good way to still use the broken GCC without ending up with broken 
code unknowingly.

Unless people are still using ancient GCC versions, there is little 
reason to worry about this bug anymore.

Just to say that I don't think that Paulius' version is wrong.  Maybe 
suboptimal but not wrong.  And his choice of r2 matches with the 
compiler's choice in the EABI case anyway, so in practice the code is as 
optimal as it would otherwise be.

> The real fix here is to add an asm constraint to GCC which allows you to
> specify "any even GPR" (or whatever's most suitable for the ldrd
> instruction). Being able to give specific registers, like you can on
> other architectures, would be useful too.

I agree completely with the fact that a proper constraint is lacking.

Being able to give a specific register is already supported though, 
although this is not directly through the inline asm constraint.

> Please file a PR, then resubmit your patch with a comment explaining
> that the code is known to be broken because GCC doesn't allow you to do
> any better, and containing a reference to your PR. If people copy your
> code, I want them to at least know that they're propagating a bug.

This is sensible I guess.


Nicolas
