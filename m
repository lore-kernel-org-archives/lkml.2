Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751833Ab0HVBnh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 21:43:37 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:58946 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784Ab0HVBnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 21:43:35 -0400
Date: Sun, 22 Aug 2010 02:43:33 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: cyp@abwesend.de
cc: linux-kernel@vger.kernel.org
Subject: Re: signo issues in arch/x86/kernel/traps.c
In-Reply-To: <AANLkTi=i3RP6x8ns09-6r4UCVay56U=DA3Ln_VupHbh5@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1008220142560.900@eddie.linux-mips.org>
References: <AANLkTi=i3RP6x8ns09-6r4UCVay56U=DA3Ln_VupHbh5@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Aug 2010, cyp@abwesend.de wrote:

> There are several  -- to me, peculiar -- signal number choices being
> made in arch/x86/kernel/traps.c. Here are my observations...

 Interesting...

> #1. Exception 9 -- "coprocessor segment overrun" -- should not be
> forwarded, leave alone forwarded as a SIGFPE. Exception 9 is not a
> fault, but an abort-class exception. The task _must_ die. Exception 9
> occurs when a discrete coprocessor -- i.e. one that is not on the same
> die as the processor -- writes to an operand in memory that crosses a
> page boundary, _and_ one page is writeable but the other is not. So,
> under these conditions, when the coprocessor writes to mem, part of
> the write succeeds and the other part fails. Since the operand in
> memory then contains garbage, subsequent cpu and fpu instructions must
> be prevented from using it, and with the fpu confused (should its
> state be that from before or after the computation that precipitated
> the write?), the task cannot be allowed to recover from the exception.
> 
> Incidentally: it seems that the math emulator is trying to avoid just
> that sort of partial-write-success situation with all the limits
> checking that its doing. (pm_address() in math-emu/get_address.c)
> Perhaps a uaccess function for atomic writes (either write completely
> or not at all) would be generally useful?

 I am fairly sure with the i386 this exception can only happen if a 
*middle* part of the memory operand used by the coprocessor is 
inaccessible as the CPU checks both the start and the end address of the 
operand for validity before passing the operation over to the FPU.  This 
is extremely rare and I doubt it can happen under Linux.

 One example is where the argument is placed such that its beginning is 
close enough to the end of a segment that it "wraps around" to the 
beginning, but the size of the segment is slightly less then the maximum.  
E.g. "fldl 65532" in a 16-bit segment whose limit is set to 65533.  I 
doubt you can arrange for the exception to happen in a 32-bit segment (as 
their granularity is 4kB that is bigger than the largest FP operand) and 
for the same reason it never happens for page faults as they are handled 
before the operation is handed over to the FPU.

 The 80286 didn't check the end of the argument, so you could get the 
overrun more easily, but that's irrelevant in the context of Linux.

 Yes, for the sake of correctness, I agree this should be a SIGKILL, 
perhaps even with a register, etc. state dump -- would you care to propose 
a patch?

> #2. An exception 7 -- "device not available" -- exception should not
> result in a SIGFPE being sent to the task. An FPE can -- nomen est
> omen -- (what is it with traps.c's reticence in passing siginfo?)
> precipitate fiddling with the state of the (non-existent) fpu, which
> will naturally trip another "device not available". Since the "device
> not available" exception is just a particular kind of "cannot handle
> this opcode" event, and the appropriate signal for "cannot handle this
> opcode" events is SIGILL, exception 7 should cause a SIGILL.

 That's in line with other platforms where FP operations unimplemented in 
hardware (like on denormals) use this signal to emulate them in software.  
I fail to see the reason to overload SIGILL causing additional trouble for 
userland emulators.

> #3. Exception 12 -- named "stack segment" in traps.c -- should
> translate into a SEGV, not a SIGBUS. Exception 12 is a segment
> violation, even if it is a particular kind of segment violation. The
> "Stack-Segment Fault" is the %ss selector's equivalent of a GPF that
> occurs for an access with %cs/ds/es/fs/gs. Just as loading
> cs/es/ds/fs/gs with a bad/null selector will trip exception 13, so
> will loading ss with a bad/null selector cause an exception 12. The
> principle function of exception 12 is to automatically grow an
> expand-down stack segment when an access occurs beyond the limit
> defined in the %ss selector's descriptor. But a simple mov <bad
> address>, %ebp; mov (%ebp), %eax can trip it too since %ebp is
> implicitly based against %ss. Not functionally any different from a
> simple mov <bad address>, %ebx; mov (%ebx), %eax. I can't think of any
> reason why exception 12 should be a SIGBUS while exception 13 is a
> SEGV.

 Yeah, probably.  Do we ever have an invalid stack segment though?

> #4. Exception 5 -- "bounds" -- should not translate to a SEGV.
> Exception 5 occurs when a programmer deliberately wants to test
> whether an integer is within a certain range, for which he/she uses
> the BOUND instruction.
> if (foo < range.lo || foo > range.hi)
>   printf("hey! out of bounds\n");
> The if() is simple signed integer math comparison, not a bad memory
> access. (if there were a fault accessing range.{hi|lo}, the exception
> being raised would be a GPF, not a bounds).

 You can handle the exception in the SEGV handler -- what's the deal? 
Which other signal would you propose instead anyway?

> #5. Exception 4 -- "overflow" -- should probably not translate to a
> SEGV. Exception 4 ("interrupt 4"), generated by INTO, is like
> exception 3 ("interrupt 3"), generated by INT3. It too is a trap-class
> exception, and really a debug instruction. As with all trap-class
> exceptions, the task's eip is pointing to the next instruction, and a
> simple ret will seamlessly continue execution as if nothing had
> happened (unlike a real SEGV). In this sense, its probably not a good
> idea to deal with it as a SEGV. There is also no violation there,
> leave alone a segment violation. It isn't like an INT x for an
> unhandled interrupt vector. After all, the interrupt is being handled.
> I suggest treating it just like int3 is treated. i.e. SIGTRAP.

 I sort-of agree here -- SIGFPE seems the right signal with the FPE_INTOVF 
trap code set as for other platforms.  But have you checked what the x86 
ABI has to say about it?

 At this stage I suppose backwards compatibility precludes a simple change 
of the signal -- would you care do design a proper solution?

  Maciej
