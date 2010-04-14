Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820Ab0DNXwa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 19:52:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16507 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755471Ab0DNXw2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 19:52:28 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <4BC6286F.6030308@cisco.com>
References: <4BC6286F.6030308@cisco.com> <20100412060609.GA25273@dvomlehn-lnx2.corp.sa.net> <24048.1271070978@redhat.com>
To: David VomLehn <dvomlehn@cisco.com>
Cc: dhowells@redhat.com, to@dvomlehn-lnx2.corp.sa.net,
       linux-arch@vger.kernel.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, maint_arch@dvomlehn-lnx2.corp.sa.net
Subject: Re: [PATCH 1/23] Make register values available to panic notifiers
Date: Thu, 15 Apr 2010 00:52:14 +0100
Message-ID: <28376.1271289134@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David VomLehn <dvomlehn@cisco.com> wrote:

> > Can the use of va_start() clobber lots of registers, thereby rendering the
> > exercise pointless on some arches?
> >   
>
> The implementations I'm familiar with only need one or two registers. What
> it *does* do is to force the contents of registers being used to pass
> argument values onto the stack. This is roughly what gcc does for asm()
> statements when you tell it registers are clobbered.

How about something like Sparc, where you can pass up to 8 arguments (if I
remember correctly) in registers.  I'm not sure how Sparc handles varargs
functions, though.

> > Also, can the save_ptregs() function be out of line asm?  The FRV
> > constructed inline statement is huge (and wrong).
> 
> With this implementation it has to be inline. One use of the saved registers
> is to backtrace the stack.

Indeed, but you've probably already lost that by using va_start().

> If you call a function to save the registers, the stack pointer and program
> counter would be those of the called function, which will not be valid after
> it returns.

Well, they'll be the context of panic() in your implementation.

> I expect that you could come up with an alternative out-of-line function

Yes.  The easiest way might be to write the saver in assembly and call it from
within an inline asm statement.

> --on every processor I know, you could backtrace one frame to get reasonable
> values for those registers,. Unfortunately, you would run the risk of
> clobbering other registers by doing the function call. The more you change
> register values from those in the function that calls panic(), the less
> useful this becomes.

Indeed, but the more things panic() does, the more likely it is to clobber
registers anyway.

Note, also: panic() is __attribute__((noreturn)), which means that the
compiler calling it is not required to save the return address or registers
before jumping to panic() or even in panic() itself.

> In this case, I think an inline function is worth the effort to get working.

As I mentioned above, you can use asm for this.  For instance, you can write
an inline asm statement that saves onto the stack the registers that need to
be clobbered to make a jump, then make the jump, and then have the saver
routine retrieve the register values from the stack and place them in the
storage area.

In fact, you could insert a prologue wrapper on panic() with a bit of asm to
save the registers, for example on FRV:

	panic:
		subi	sp,#-8,sp
		stdi.p	gr4,@(sp,#0)		# save GR4/GR5 on stack
		addi	sp,#8,gr5
		sethi.p	%hi(__panic_reg_save),gr4  # get the save space addr
		setlo	%lo(__panic_reg_save),gr4
		sti	gr5,@(gr4,#REG_SP))	# save orig stack pointer
		stdi	gr2,@(gr4,#REG_GR(2))	# save GR2/GR3
		ldi	@(sp,#0),gr5
		sti	gr5,@(gr4,#REG_GR(4))	# save orig GR4
		ldi	@(sp,#4),gr5
		sti	gr5,@(gr4,#REG_GR(5))	# save orig GR5
		stdi	gr6,@(gr4,#REG_GR(6))	# save GR6/GR7
		stdi	gr8,@(gr4,#REG_GR(8))	# save GR8/GR9
		...
		lddi.p	@(sp,#0),gr4		# restore GR4/GR5 from stack
		addi	sp,#8,sp
		bra	real_panic		# chain

Then real_panic() would be the original C panic function.

> (I'd be interested in know more details about how things are broken in the
> FRV)

Most load/store instructions come in two types, and you need to modify the
opcode according to the addressing mode and indicate that you're interpolating
a memory dereference argument rather than an address:

	asm("ldd%I1 %M1,%0"
	    : "=e"(counter)
	    : "m"(v->counter));

You're also trying to load data into GR0 which won't achieve anything.  GR0 is
hardwired to 0.  It's used as the target of instructions where you don't care
about the calculated result (eg: compare is implemented as subtract to GR0),
and as a source of 0.

David
