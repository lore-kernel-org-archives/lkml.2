Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757032Ab2CHMSW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 07:18:22 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34250 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194Ab2CHMST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 07:18:19 -0500
Date: Thu, 8 Mar 2012 12:17:55 +0000
From: Dave Martin <dave.martin@linaro.org>
To: Richard Earnshaw <Richard.Earnshaw@arm.com>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Vrabel <david.vrabel@citrix.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH-WIP 01/13] xen/arm: use r12 to pass the hypercall number
 to the hypervisor
Message-ID: <20120308121755.GA2703@linaro.org>
References: <20120227180355.GB2023@linaro.org>
 <1330371219.10008.34.camel@dagon.hellion.org.uk>
 <20120228102040.GB2063@linaro.org>
 <1330426133.31269.70.camel@zakaz.uk.xensource.com>
 <alpine.DEB.2.00.1202281149210.23091@kaball-desktop>
 <20120229093436.GA2077@linaro.org>
 <1330509362.4270.20.camel@zakaz.uk.xensource.com>
 <20120229125826.GC2077@linaro.org>
 <alpine.LFD.2.02.1203021528150.31242@xanadu.home>
 <4F5882BF.1030104@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F5882BF.1030104@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2012 at 09:58:23AM +0000, Richard Earnshaw wrote:
> On 02/03/12 21:15, Nicolas Pitre wrote:
> > [ coming back from vacation and trying to catch up ]
> >
> > On Wed, 29 Feb 2012, Dave Martin wrote:
> >
> >> Just had a chat with some tools guys -- apparently, when passing register
> >> arguments to gcc inline asms there really isn't a guarantee that those
> >> variables will be in the expected registers on entry to the inline asm.
> >>
> >> If gcc reorders other function calls or other code around the inline asm
> >> (which it can do, except under certain controlled situations), then
> >> intervening code can clobber any registers in general.
> >
> > I'm hearing this argument about once every year or so for the last 8
> > years.  I think that the tools people are getting confused between
> > themselves as you may get a different interpretation of what gcc should
> > do depending to whom you happen to talk to.
> >
> > I did submit a bug to gcc in 2004 about this:
> >
> >       http://gcc.gnu.org/bugzilla/show_bug.cgi?id=15089
> >
> > You can see the confusion among gcc developers lurking there.
> >
> > So let's quote the relevant gcc documentation:
> >
> > -> * C Extensions::    GNU extensions to the C language family.
> >    -> * Explicit Reg Vars::   Defining variables residing in specified registers.
> >
> > |GNU C allows you to put a few global variables into specified hardware
> > |registers.  You can also specify the register in which an ordinary
> > |register variable should be allocated.
> > |
> > |   * Global register variables reserve registers throughout the program.
> > |     This may be useful in programs such as programming language
> > |     interpreters which have a couple of global variables that are
> > |     accessed very often.
> > |
> > |   * Local register variables in specific registers do not reserve the
> > |     registers, except at the point where they are used as input or
> > |     output operands in an `asm' statement and the `asm' statement
> > |     itself is not deleted.  The compiler's data flow analysis is
> > |     capable of determining where the specified registers contain live
> > |     values, and where they are available for other uses.  Stores into
> > |     local register variables may be deleted when they appear to be
> > |     dead according to dataflow analysis.  References to local register
> > |     variables may be deleted or moved or simplified.
> > |
> > |     These local variables are sometimes convenient for use with the
> > |     extended `asm' feature (*note Extended Asm::), if you want to
> > |     write one output of the assembler instruction directly into a
> > |     particular register.  (This will work provided the register you
> > |     specify fits the constraints specified for that operand in the
> > |     `asm'.)
> >
> >       -> * Local Reg Vars::
> >
> > [...]
> >
> > | Defining such a register variable does not reserve the register; it
> > |remains available for other uses in places where flow control
> > |determines the variable's value is not live.
> > |
> > | This option does not guarantee that GCC will generate code that has
> > |this variable in the register you specify at all times.  You may not
> > |code an explicit reference to this register in the _assembler
> > |instruction template_ part of an `asm' statement and assume it will
> > |always refer to this variable.  However, using the variable as an `asm'
> > |_operand_ guarantees that the specified register is used for the
> > |operand.

Hmmm, it's a while since I saw that documentation, and it had clearly
fallen out of my head when I made my previous statements...

> >
> > So, to me, the gcc documentation is perfectly clear on this topic.
> > there really _is_ a guarantee that those asm marked variables will be in
> > the expected registers on entry to the inline asm, given that the
> > variable is _also_ listed as an operand to the asm statement.  But only
> > in that case.
> >
> > It is true that gcc may reorder other function calls or other code
> > around the inline asm and then intervening code can clobber any
> > registers.  Then it is up to gcc to preserve the variable's content
> > elsewhere when its register is used for other purposes, and restore it
> > when some inline asm statement is referring to it.
> >
> > And if gcc does not do this then it is buggy.  Version 3.4.0 of gcc was
> > buggy.  No other gcc versions in the last 7 years had such a problem or
> > the __asmeq macro in the kernel would have told us.
> >
> >> Or, to summarise another way, there is no way to control which register
> >> is used to pass something to an inline asm in general (often we get away
> >> with this, and there are a lot of inline asms in the kernel that assume
> >> it works, but the more you inline the more likely you are to get nasty
> >> surprises).
> >
> > This statement is therefore unfounded and wrong.  Please direct the
> > tools guy who mislead you to the above gcc documentation.
> >
> 
> The problem is not really about re-ordering functions but about implicit
> functions that come from the source code; for example
> 
> int foo (int a, int b)
> {
>   register int x __asm__("r0") = 33;
> 
>   register int c __asm__("r1") = a / b; /* Ooops, clobbers r0 with
> division function call.  */
> 
>   asm ("svc 0" : : "r" (x));
> }

|   * Local register variables in specific registers do not reserve the
|     registers, except at the point where they are used as input or
|     output operands in an `asm' statement and the `asm' statement
|     itself is not deleted.  The compiler's data flow analysis is

So, I guess the issue is how to interpret this statement in the context
of the above code:  i.e., what does it mean for a register to be reserved
for a local register variable?

"The above paragraph says that Local register variables [do] reserve the
registers _[at] the point_ where they are used as input or output
operands in an `asm' statement and the `asm' statement itself is not
deleted." (my emphasis)

Under that reading, r0 must be reserved for x on entry to the asm, but
not necessarily at points preceding that.  If the asm sees anything in
r0 except for x, that would be noncompliant with the above paragraph.

Nevertheless, a slightly modified version of the above which does not
allow gcc to optimise the asm away does trigger just the kind of
behaviour you describe:

int foo(int a, int b)
{
	register int x asm("r0") = 33;
	register int c asm("r1") = a / b;

	asm("svc 0" : "+r" (x) : "r" (c));

	return x;
}

 -->

00000000 <foo>:
   0:   e92d4008        push    {r3, lr}
   4:   ebfffffe        bl      0 <__aeabi_idiv>
   8:   e1a01000        mov     r1, r0
   c:   ef000000        svc     0x00000000
  10:   e8bd8008        pop     {r3, pc}


This is doubly weird: x is an I/O to the asm with a "+r" constraint,
so even if the asm("rX") assignments are not guaranteed, then x should
be _somewhere_ on entry to the asm (even if not in r0).  But it is
completely gone.

Is this allowed, or wrong?  I don't see how this can be rationalised
with the gcc documentation that Nico quoted.

Have I missed something?

Cheers
---Dave
