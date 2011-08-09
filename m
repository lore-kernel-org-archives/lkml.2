Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332Ab1HIVE5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 17:04:57 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:37798 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882Ab1HIVEz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 17:04:55 -0400
MIME-Version: 1.0
In-Reply-To: <1312919938.17118.YahooMailNeo@web120010.mail.ne1.yahoo.com>
References: <20110805200945.GA14014@tassilo.jf.intel.com> <4E3C5154.2050307@zytor.com>
 <CAObL_7E3yOHtx9N3qd2UXVn+h6tACoNjekRhiMcHrzb=Mu4q8A@mail.gmail.com>
 <4E3C571C.1070903@zytor.com> <20110805205222.GK5782@one.firstfloor.org>
 <CAObL_7G2TqBVXvfuh2GPNteYBNoc8_s398KS+jPOPQYAhPHz0Q@mail.gmail.com>
 <20110805212153.GL5782@one.firstfloor.org> <CAObL_7Exnu8rHNY67o_HutizpLrGMx0heYU8wKXeEutXZywvdA@mail.gmail.com>
 <20110809150424.GO5782@one.firstfloor.org> <CAObL_7HL7SwCfXsD3dPesE4cU-nmoMCRVCP6u2Mn8efo7EG5Zg@mail.gmail.com>
 <4E416716.1040904@zytor.com> <CAObL_7FzTisOGJLP7wGUKDCO6qJ20-kaMFWdjm0a+dKpNWBe3g@mail.gmail.com>
 <1312919938.17118.YahooMailNeo@web120010.mail.ne1.yahoo.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Tue, 9 Aug 2011 17:04:35 -0400
X-Google-Sender-Auth: J-EiOu0hOyFdp5hdOJu6lU-ghhs
Message-ID: <CAObL_7G09yBtfFpdvmRMNn59T-jTsj_MFK+xBer+qq3BUjcKUg@mail.gmail.com>
Subject: Re: New vsyscall emulation breaks JITs
To: Greg Lueck <lueckintel@yahoo.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "kimwooyoung@gmail.com" <kimwooyoung@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 9, 2011 at 3:58 PM, Greg Lueck <lueckintel@yahoo.com> wrote:
> I apologize that I’m just jumping into this conversation now.  I was swamped
> yesterday and this morning, and I only just started reading it today.
> Pin needs to recognize all possible syscall trap instructions, so we will
> need to change our code to recognize INT 0xCC as a syscall trap.  When Pin
> recognizes a system call trap instruction, it does _not_ copy the
> instruction into the translated code area.  Instead, we arrange for the trap
> to be executed natively from within our Pin VM engine.  On 64-bit, we use
> the SYSCALL instruction to do the trap regardless of what the original
> instruction was.  The SEGV that Andi saw is really just fallout from the
> fact that Pin didn’t know about INT 0xCC.  We assume that any INT
> instruction with no special semantic will just fault.  We copy these unknown
> INT’s into the Pin translated code area and execute them from there, where
> we expect them to raise a synchronous signal.  Pin’s signal emulation will
> take over from this point in case the application intentionally executed the
> weird INT with the expectation of handling the signal.
> In addition to recognizing the INT 0xCC instruction as a system call, we
> should probably handle unknown INT’s in the vdso / vsyscall gate area
> specially.  For example, we may want to raise a warning since this case
> probably indicates a new system call trap that we must handle specially.
> I need to read through the thread in more detail still, but I think one of
> the proposals was to use additional INT’s for syscall traps in the vsyscall
> area.  If so, Pin will need to recognize these.  It would be helpful to us
> if you could provide a disassembly of the proposed vsyscall and vdso gate
> areas.  Or, we could probably work with Andi to get these from the kernel
> sources.  In particular, we need to know how to find the system call number
> and its arguments at the point when the application executes the INT that
> traps into the kernel.  (We know the normal ABI for passing system call
> arguments, but I suppose it’s possible that these new INT’s will use a
> different ABI.)

Eek.  I'd really rather not have anything make any assumption beyond
the fact that a call or jump to the vsyscall page has certain
semantics.

> I also saw that you bumped into a Pin error with 3.0 kernels.
> Coincidentally, this was fixed last week and will be available in our next
> Pin release.  If you would like a private kit with this fix, I can send you
> one.

That would be helpful.

> Finally, I’d like to answer your questions about why Pin can’t just execute
> the vdso / vsyscall code natively.  We changed the way Pin handles the gate
> code when we added our attach / detach feature, allowing Pin to attach to a
> native process.  Consider that Pin may attach to a process that is executing
> in the middle of the gate code, or worse, it may attach while in a signal
> handler that will subsequently return into the middle of the gate code.  In
> both cases, Pin will not see the CALL instruction that enters the gate, so
> it’s too late to simply call the gate code natively.  We can’t natively
> execute in the middle of the gate because the RET will execute natively and
> continue native execution of the rest of the application, outside of Pin’s
> JIT compiler.  We thought about single-stepping the application until the PC
> is outside of the gate area, but this wouldn’t work in the signal handler
> case.

That's a fun corner case.  Is the problem that you might receive a
signal while single-stepping?

>  Instead, we decided to let Pin JIT-compile the gate code instructions
> just like any other application code, and we handle the SYSENTER instruction
> specially (on 32-bit).  When we see SYSENTER, Pin executes the syscall
> natively and then resumes JIT-compilation at the normal resume point in the
> gate area.  This works regardless of where Pin attaches to the application,
> and it also has the nice advantage that Pin tools see the exact sequence of
> user space instructions that the application would execute if it ran
> natively.

Here's a different proposal, then:

What if the kernel had the sequence:

mov $__NR_whatever,%eax
syscall
ret

in the vsyscall page but marked the vsyscall page NX.  Then the kernel
would emulate the vsyscall when it received an instruction fetch page
fault.  pin could do exactly what it does right now, since the code
that RIP is pointing at if the attach happens right before the fault
would do what it's supposed to do.

--Andy
