Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224Ab2LGO41 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 09:56:27 -0500
Received: from queue01.mail.zen.net.uk ([212.23.3.234]:45371 "EHLO
	queue01.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755131Ab2LGO40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 09:56:26 -0500
Message-ID: <1354892111.13000.50.camel@linaro1.home>
Subject: Re: [PATCH] ARM: ftrace: Ensure code modifications are synchronised
 across all cpus
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Rabin Vincent <rabin@rab.in>,
        linux-kernel@vger.kernel.org
Date: Fri, 07 Dec 2012 14:55:11 +0000
In-Reply-To: <1354888985.17101.41.camel@gandalf.local.home>
References: <1354817466.30905.13.camel@linaro1.home>
	 <1354821581.17101.17.camel@gandalf.local.home>
	 <1354872138.3176.15.camel@computer5.home>
	 <1354888985.17101.41.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-Smarthost01-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-12-07 at 09:03 -0500, Steven Rostedt wrote:
> On Fri, 2012-12-07 at 09:22 +0000, Jon Medhurst (Tixy) wrote:
> > On Thu, 2012-12-06 at 14:19 -0500, Steven Rostedt wrote:
> > > Hmm, your use of "may or may not" seems as you may not know this answer.
> > > I wonder if you can use the break point method as x86 does now, and
> > > remove the stop machine completely. Basically this is how it works:
> > > 
> > > add sw breakpoints to all locations to modify (the bp handler just does
> > > a nop over the instruction).
> > > 
> > > send an IPI to all CPUs to flush their icache.
> > > 
> > > Modify the non breakpoint part of the instruction with the new
> > > instruction.
> > > 
> > > send an IPI to all CPUs to flush their icache
> > > 
> > > Replace the breakpoint with the finished instruction.
> > 
> > If I understand correctly then this method can't work on ARM because a
> > 'software breakpoint' is 'replace an instruction with a known undefined
> > instruction _of the same size_'. It haa to be the same size because code
> > like this:
> > 
> > 	it eq       /* If condition code 'eq' true */
> >         insA        /* then execute this instruction */
> >         insB        /* Always execute this */
> > 
> > if we replace insA with a breakpoint which is shorter, then we have
> > 
> > 	it eq       /* If condition code 'eq' true */
> >         bkpt        /* then execute the breakpoint */
> >         insA-part2  /* Always execute this garbage */
> 
> Why always execute the garbage? Do what we do in x86, where the
> breakpoint is only 1 byte and the instruction being replaced is 5 bytes.

We don't get any say in the matter, if the condition is false, then the
CPU will skip over bkpt and go on to execute insA-part2, that's how the
instruction set works. If the condition is true, then it's
implementation defined whether the CPU will skip bkt or not.

The 'it' instruction is a separate instruction to insA, it's not any
kind of prefix used to make a more complex single instruction. You can
do something like:

	iteet eq   /* if-then-else-else-then */
        insA       /* executed if 'eq' */
        insB       /* executed if not 'eq' */
        insC       /* executed if not 'eq' */
        insD       /* executed if 'eq' */

which is five separate CPU instructions, and you can get interrupted
after any of them (the current state of conditional instruction
execution is stored in the status register). Replacing insB with a
shorter 'breakpoint' would give...

	iteet eq   /* if-then-else-else-then */
        insA       /* executed if 'eq' */
        bkpt       /* executed if not 'eq' (implementation defined) */
        insB-part2 /* executed if not 'eq' (garbage) */
        insC       /* executed if 'eq' */
        insD       /* always executed */

which is not good ;-)

> The breakpoint handler returns to the instruction after the
> "garbage" (insB).
> 
> >         insB        /* Always execute this */
> > 
> > and to complicate matters more, the 'it' instruction can make up to the
> > next four instructions conditional, so you can't reverse decode the
> > instruction stream reliably to even detect such code.
> > 
> > And further, it's implementation defined (up to who every creates the
> > silicon) whether an undefined instructions actually causes an abort when
> > it occurs in such an 'it' block, it may just execute as a nop.
> > 
> > Welcome to the work of ARM :-)
> > 
> 
> But also realize that function tracing is special :-) We have no cases
> like this. The instruction being replaced is a call to mcount. In fact,
> we replace it at boot with a nop. And this method only replaces that nop
> into a call to function tracer, or replaces the call to function tracer
> back to a nop. Always at the start of the function, and never involved
> with conditionals. This limitation that function tracing imposes on what
> we replace makes things a bit more sane in how we replace it.

Then perhaps the method you suggest will work on ARM :-). However, that
is not something I personally propose to implement at this time. (I was
doing my good Samaritan act by trying to fix the crashes which another
team was getting when trying to use ftrace.)

-- 
Tixy

