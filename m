Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756288Ab0JSWlb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 18:41:31 -0400
Received: from mail.openrapids.net ([64.15.138.104]:49777 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754479Ab0JSWla convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 18:41:30 -0400
Date: Tue, 19 Oct 2010 18:41:27 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>,
        Koki Sanagi <sanagi.koki@jp.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>, nhorman@tuxdriver.com,
        scott.a.mcmillan@intel.com, laijs@cn.fujitsu.com,
        LKML <linux-kernel@vger.kernel.org>, eric.dumazet@gmail.com,
        kaneshige.kenji@jp.fujitsu.com, David Miller <davem@davemloft.net>,
        izumi.taku@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "Luck, Tony" <tony.luck@intel.com>, Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH] tracing: Cleanup the convoluted softirq tracepoints
Message-ID: <20101019224126.GD3519@Krystal>
References: <20101019132236.GA19197@Krystal> <alpine.LFD.2.00.1010191524160.6815@localhost6.localdomain6> <1287496495.16971.372.camel@gandalf.stny.rr.com> <alpine.LFD.2.00.1010191558250.6815@localhost6.localdomain6> <20101019142820.GA14520@Krystal> <alpine.LFD.2.00.1010191842270.6815@localhost6.localdomain6> <1287521757.16971.397.camel@gandalf.stny.rr.com> <alpine.LFD.2.00.1010192302000.6815@localhost6.localdomain6> <1287523439.16971.433.camel@gandalf.stny.rr.com> <4CBE122B.9020807@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <4CBE122B.9020807@zytor.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 18:20:15 up 27 days,  2:22,  4 users,  load average: 0.09, 0.10,
	0.13
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* H. Peter Anvin (hpa@zytor.com) wrote:
> On 10/19/2010 02:23 PM, Steven Rostedt wrote:
> > 
> > But it seemed that gcc for you inlined the code in the wrong spot.
> > Perhaps it's not a good idea to have the something like h - softirq_vec
> > in the parameter of the tracepoint. Not saying that your change is not
> > worth it. It is, because h - softirq_vec is used by others now too.
> > 
> 
> OK, first of all, there are some serious WTFs here:
> 
> # define JUMP_LABEL_INITIAL_NOP ".byte 0xe9 \n\t .long 0\n\t"
> 
> A jump instruction is one of the worst possible NOPs.  Why are we doing
> this?

This code is dynamically patched at boot time (and module load time) with a
better nop, just like the function tracer does.

> 
> The second thing that I found when implementing static_cpu_has() was
> that it is actually better to encapsulate the asm goto in a small inline
> which returns bool (true/false) -- gcc will happily optimize out the
> variable and only see it as a flow of control thing.  I would be very
> curious if that wouldn't make gcc generate better code in cases like that.
> 
> gcc 4.5.0 has a bug in that there must be a flowthrough case in the asm
> goto (you can't have it unconditionally branch one way or the other), so
> that should be the likely case and accordingly it should be annotated
> likely() so that gcc doesn't reorder.  I suspect in the end one ends up
> with code like this:
> 
> static __always_inline __pure bool __switch_point(...)
> {
> 	asm goto("1: " JUMP_LABEL_INITIAL_NOP
> 		 /* ... patching stuff */
> 		: : : : t_jump);
> 	return false;
> t_jump:
> 	return true;
> }
> 
> #define SWITCH_POINT(x) unlikely(__switch_point(x))
> 
> I *suspect* this will resolve the need for hot/cold labels just fine.

Thanks for the hint! We'll make sure to try it out. Having the ability to force
gcc to put the tracepoint in an unlikely branch is deeply needed here.

I'm a bit curious about the nop vs jump overhead comparison you are referring
to. It is an instruction latency benchmark or throughput benchmark ?

Intel's manual "Intel 64 and IA-32 Architectures Optimization Reference Manual"

http://www.intel.com/Assets/PDF/manual/248966.pdf

Page C-33 (or 577 in the pdf)

"7. Selection of conditional jump instructions should be based on the
    recommendation of section Section 3.4.1, “Branch Prediction Optimization,” to
    improve the predictability of branches. When branches are predicted
    successfully, the latency of jcc is effectively zero."

So it mentions "jcc", but not jmp. Is there any reason for jmp to have a higher
latency than jcc ?

In this manual, the latency of predicted jcc is therefore 0 cycle, and its
throughput is 0.5 cycle/insn.

NOP (page C-29) is stated to have a latency of 0.5 to 1 cycle/insn (depending on
the exact HW), and throughput of 0.5 cycle/insn.

However, I have not found "jmp" explicitly in this listing.

So if we were executing tracepoints in a maze of jumps, we could argue that
instruction throughput is the most important there. However, if we expect the
common case to be surrounded by some non-ALU instructions, latency tends to
become the most important criterion.

But I feel I might be missing something important that distinguish "jcc" from
"jmp".

Thanks,

Mathieu


-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
