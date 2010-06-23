Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751708Ab0FWRtQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 13:49:16 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46868 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab0FWRtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 13:49:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=P7cU6BLcJFP61s3rCBaAprTx3vdDj7FaxjBly77Z7swWKtlHMWBWMXdyb1G2g1i539
         bwIUSpLYvCltH+ssvsw47O0n4QUzfxKTBQ/lXXFizYga3usZc6GGYCC9i9/Jg9I+hSuM
         fhswTm50rgDvWuWq/11katC/MxHEtgeJ9ga58=
Date: Wed, 23 Jun 2010 19:49:20 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Paul Mackerras <paulus@samba.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: Hitting WARN_ON in hw_breakpoint code
Message-ID: <20100623174918.GH5242@nowhere>
References: <20100623125740.GA3368@brick.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100623125740.GA3368@brick.ozlabs.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 23, 2010 at 10:57:40PM +1000, Paul Mackerras wrote:
> Frederic,
> 
> I'm hitting the WARN_ONCE at line 114 of kernel/hw_breakpoints.c,
> like so:
> 
> No perf context for this task
> ------------[ cut here ]------------
> Badness at /home/paulus/kernel/perf/kernel/hw_breakpoint.c:114
> NIP: c0000000000cb470 LR: c0000000000cb46c CTR: c00000000032d9b8
> REGS: c000000118e7b570 TRAP: 0700   Not tainted  (2.6.35-rc3-perf-00008-g76b0f13
> )
> MSR: 9000000000029032 <EE,ME,CE,IR,DR>  CR: 44004424  XER: 000fffff
> TASK = c0000001187dcad0[3143] 'perf' THREAD: c000000118e78000 CPU: 1
> GPR00: c0000000000cb46c c000000118e7b7f0 c0000000009866a0 0000000000000020 
> GPR04: 0000000000000000 000000000000001d 0000000000000000 0000000000000001 
> GPR08: c0000000009bed68 c00000000086dff8 c000000000a5bf10 0000000000000001 
> GPR12: 0000000024004422 c00000000ffff200 0000000000000000 0000000000000000 
> GPR16: 0000000000000000 0000000000000000 0000000000000018 00000000101150f4 
> GPR20: 0000000010206b40 0000000000000000 0000000000000000 00000000101150f4 
> GPR24: c0000001199090c0 0000000000000001 0000000000000000 0000000000000001 
> GPR28: 0000000000000000 0000000000000000 c0000000008ec290 0000000000000000 
> NIP [c0000000000cb470] .task_bp_pinned+0x5c/0x12c
> LR [c0000000000cb46c] .task_bp_pinned+0x58/0x12c
> Call Trace:
> [c000000118e7b7f0] [c0000000000cb46c] .task_bp_pinned+0x58/0x12c (unreliable)
> [c000000118e7b8a0] [c0000000000cb584] .toggle_bp_task_slot+0x44/0xe4
> [c000000118e7b940] [c0000000000cb6c8] .toggle_bp_slot+0xa4/0x164
> [c000000118e7b9f0] [c0000000000cbafc] .release_bp_slot+0x44/0x6c
> [c000000118e7ba80] [c0000000000c4178] .bp_perf_event_destroy+0x10/0x24
> [c000000118e7bb00] [c0000000000c4aec] .free_event+0x180/0x1bc
> [c000000118e7bbc0] [c0000000000c54c4] .perf_event_release_kernel+0x14c/0x170
> [c000000118e7bc50] [c00000000010cee8] .fput+0x1b0/0x2a8
> [c000000118e7bd00] [c000000000109698] .filp_close+0xb4/0xdc
> [c000000118e7bd90] [c000000000109778] .SyS_close+0xb8/0x124
> [c000000118e7be30] [c0000000000075d4] syscall_exit+0x0/0x40
> Instruction dump:
> 7c992378 eba30940 2fbd0000 40fe0038 e93e8010 3b400000 88090008 2f800000 
> 40fe00b0 e87e8018 4bf8f535 60000000 <0fe00000> e93e8010 38000001 98090008 
> 
> This was triggered by doing "perf stat -e mem:0x10010830 ./vtouch"
> on a ppc64 box, using the patches from K. Prasad to implement
> perf_event hw_breakpoint support on ppc64.
> 
> It looks like perf is closing the perf_event fd after the child
> process has exited, and that's why the child doesn't have a
> perf_event context any more, and that's why the WARN_ONCE triggers.



Indeed. I'm suprised I've never seen this problem before while the
bug is quite obvious.

Anyway I'm cooking a fix, thanks for this report!



> Also, I have a question about hw_breakpoints on x86.  When you get
> a hw_breakpoint event, does the pc value that gets recorded in the
> sample point to the instruction that did the access, or to the
> following instruction?  And does the breakpoint trap happen after
> the instruction that does the access has completed, or before?



So it depends whether this is a data breakpoint or an instruction
breakpoint.

Instruction breakpoints trigger before the instruction is executed,
the recorded address is then the instruction that triggered the
breakpoint.

And when it returns from the exception, we go back to this very
instruction. So to avoid a recursion, we have to play with an RF
(resume flag) bit in the cpu flags. When set, this flag "masks"
an instruction breakpoint. But this is a one-shot thing: once
an instruction gets executed, this flag gets cleared.

This is how that works in x86: you take the flags from the dumped
regs, set this RF, then you return from the exception, jump back
to the instruction that breakpointed, the breakpoint is still set
but now that RF is set, it is ignored, and on the next instruction,
RF will be cleared.

Now this is not implemented in the kernel, and a small bug prevented
to make instruction breakpoints working. I'm cooking a patch for
that too.

Concerning data breakpoints in x86 it's the opposite: the cpu checks
the address of the data once the instruction has been executed and then
triggers the trap.

So the watchpoint trap happens after the instruction that touched the data,
the ip reported is the one that follows the trapped execution, and returning
from the exception bring us to the instruction that follow the trapping
one.

