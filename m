Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752341Ab0FWM5u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 08:57:50 -0400
Received: from ozlabs.org ([203.10.76.45]:49440 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351Ab0FWM5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 08:57:49 -0400
Date: Wed, 23 Jun 2010 22:57:40 +1000
From: Paul Mackerras <paulus@samba.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Hitting WARN_ON in hw_breakpoint code
Message-ID: <20100623125740.GA3368@brick.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic,

I'm hitting the WARN_ONCE at line 114 of kernel/hw_breakpoints.c,
like so:

No perf context for this task
------------[ cut here ]------------
Badness at /home/paulus/kernel/perf/kernel/hw_breakpoint.c:114
NIP: c0000000000cb470 LR: c0000000000cb46c CTR: c00000000032d9b8
REGS: c000000118e7b570 TRAP: 0700   Not tainted  (2.6.35-rc3-perf-00008-g76b0f13
)
MSR: 9000000000029032 <EE,ME,CE,IR,DR>  CR: 44004424  XER: 000fffff
TASK = c0000001187dcad0[3143] 'perf' THREAD: c000000118e78000 CPU: 1
GPR00: c0000000000cb46c c000000118e7b7f0 c0000000009866a0 0000000000000020 
GPR04: 0000000000000000 000000000000001d 0000000000000000 0000000000000001 
GPR08: c0000000009bed68 c00000000086dff8 c000000000a5bf10 0000000000000001 
GPR12: 0000000024004422 c00000000ffff200 0000000000000000 0000000000000000 
GPR16: 0000000000000000 0000000000000000 0000000000000018 00000000101150f4 
GPR20: 0000000010206b40 0000000000000000 0000000000000000 00000000101150f4 
GPR24: c0000001199090c0 0000000000000001 0000000000000000 0000000000000001 
GPR28: 0000000000000000 0000000000000000 c0000000008ec290 0000000000000000 
NIP [c0000000000cb470] .task_bp_pinned+0x5c/0x12c
LR [c0000000000cb46c] .task_bp_pinned+0x58/0x12c
Call Trace:
[c000000118e7b7f0] [c0000000000cb46c] .task_bp_pinned+0x58/0x12c (unreliable)
[c000000118e7b8a0] [c0000000000cb584] .toggle_bp_task_slot+0x44/0xe4
[c000000118e7b940] [c0000000000cb6c8] .toggle_bp_slot+0xa4/0x164
[c000000118e7b9f0] [c0000000000cbafc] .release_bp_slot+0x44/0x6c
[c000000118e7ba80] [c0000000000c4178] .bp_perf_event_destroy+0x10/0x24
[c000000118e7bb00] [c0000000000c4aec] .free_event+0x180/0x1bc
[c000000118e7bbc0] [c0000000000c54c4] .perf_event_release_kernel+0x14c/0x170
[c000000118e7bc50] [c00000000010cee8] .fput+0x1b0/0x2a8
[c000000118e7bd00] [c000000000109698] .filp_close+0xb4/0xdc
[c000000118e7bd90] [c000000000109778] .SyS_close+0xb8/0x124
[c000000118e7be30] [c0000000000075d4] syscall_exit+0x0/0x40
Instruction dump:
7c992378 eba30940 2fbd0000 40fe0038 e93e8010 3b400000 88090008 2f800000 
40fe00b0 e87e8018 4bf8f535 60000000 <0fe00000> e93e8010 38000001 98090008 

This was triggered by doing "perf stat -e mem:0x10010830 ./vtouch"
on a ppc64 box, using the patches from K. Prasad to implement
perf_event hw_breakpoint support on ppc64.

It looks like perf is closing the perf_event fd after the child
process has exited, and that's why the child doesn't have a
perf_event context any more, and that's why the WARN_ONCE triggers.

Is this something you know about already, or should I go digging to
work out how to fix it?

Also, I have a question about hw_breakpoints on x86.  When you get
a hw_breakpoint event, does the pc value that gets recorded in the
sample point to the instruction that did the access, or to the
following instruction?  And does the breakpoint trap happen after
the instruction that does the access has completed, or before?

Thanks,
Paul.
