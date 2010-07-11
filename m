Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360Ab0GKWDY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 18:03:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:40789 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755252Ab0GKWDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 18:03:22 -0400
X-Authority-Analysis: v=1.1 cv=eWk9bc5BAcy1KEyGm/gc5mmqTM7Cp/ADlcqpp9MTMWU= c=1 sm=0 a=3ZTPfBE-TBkA:10 a=UBIxAjGgU1YA:10 a=IkcTkHD0fZMA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=CJpA_YuFbY3abpFh5JIA:9 a=8QJS4x4FI2lnaDaGUEvtlrcM7k0A:4 a=QEXdDO2ut3YA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [RFC PATCH] x86-64: software IRQ masking and handling
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <AANLkTik8EHarsrnAisuj9SKbeXddlA6Dz-KzDOPsmBxh@mail.gmail.com>
References: <4C3A06E3.50402@kernel.org>
	 <AANLkTik8EHarsrnAisuj9SKbeXddlA6Dz-KzDOPsmBxh@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 11 Jul 2010 18:03:17 -0400
Message-ID: <1278885797.6740.18.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-07-11 at 13:29 -0700, Linus Torvalds wrote:

> But if it actually helps on real hardware (which is possible), that
> would be interesting. However, quite frankly, I doubt you can really
> measure it on any bigger load. cli-sti do not tend to be all that
> expensive any more (on a P4 it's probably noticeable, I doubt it shows
> up very much anywhere else).

I have seen some hits with cli-sti. I was considering swapping all
preempt_disable() with local_irq_save() in ftrace, but hackbench showed
a 30% performance degradation when I did that.

The test was simply to switch the stack tracer from disabling preemption
to disabling IRQs, and I got this as a result:

<This is from my IRC log on OFTC #linux-rt IRC discussing this with
Thomas Gleixner>

Feb 04 10:02:27 <rostedt>       running hackbench 10 times with stack tracer using preempt disable:
Feb 04 10:02:30 <rostedt>       # cat stack-preempt.out 
Feb 04 10:02:30 <rostedt>       Time: 3.206
Feb 04 10:02:30 <rostedt>       Time: 3.283
Feb 04 10:02:30 <rostedt>       Time: 3.238
Feb 04 10:02:30 <rostedt>       Time: 3.230
Feb 04 10:02:30 <rostedt>       Time: 3.223
Feb 04 10:02:30 <rostedt>       Time: 3.266
Feb 04 10:02:30 <rostedt>       Time: 3.236
Feb 04 10:02:30 <rostedt>       Time: 3.258
Feb 04 10:02:30 <rostedt>       Time: 3.241
Feb 04 10:02:30 <rostedt>       Time: 3.244
Feb 04 10:03:09 <rostedt>       replacing preempt_disable with local_irq_save, and removing the internal local_irq_save when a max is reached:
Feb 04 10:03:12 <rostedt>       # cat stack-irq.out     
Feb 04 10:03:12 <rostedt>       Time: 4.116
Feb 04 10:03:12 <rostedt>       Time: 4.117
Feb 04 10:03:12 <rostedt>       Time: 4.154
Feb 04 10:03:12 <rostedt>       Time: 4.125
Feb 04 10:03:12 <rostedt>       Time: 4.138
Feb 04 10:03:12 <rostedt>       Time: 4.159
Feb 04 10:03:12 <rostedt>       Time: 4.141
Feb 04 10:03:12 <rostedt>       Time: 4.099
Feb 04 10:03:12 <rostedt>       Time: 4.100
Feb 04 10:03:12 <rostedt>       Time: 4.098
Feb 04 10:03:36 <rostedt>       30% slow down

Thomas asked me to use perf to find where it was taking the hit and with
the help from Peter Zijlstra I had this:

Feb 05 09:29:09 <rostedt>           4.36 :      ffffffff810a5ce9:       41 54                   push   %r12
Feb 05 09:29:09 <rostedt>           0.00 :      ffffffff810a5ceb:       9d                      popfq  
Feb 05 09:29:09 <rostedt>          35.30 :      ffffffff810a5cec:       48 83 c4 18             add    $0x18,%rsp
Feb 05 09:29:37 <rostedt>       nothing else is over 10
Feb 05 09:30:31 <peterz>        popfq is expensive it seems
Feb 05 09:30:33 <rostedt>       it looks like disabling interrupts are not an issue, it's enabling them that is
Feb 05 09:30:47 <peterz>        or that add is missing all caches
Feb 05 09:31:14 <peterz>        which is hard to so with an imm,reg op
Feb 05 09:31:15 <rostedt>       it's adding to the stack
Feb 05 09:31:21 <rostedt>       hehe
Feb 05 09:33:11 <rostedt>       with preempt disable:
Feb 05 09:33:14 <rostedt>           25.06%        hackbench  [kernel]                     [k] stack_trace_call
Feb 05 09:33:14 <rostedt>           10.21%        hackbench  [kernel]                     [k] ftrace_caller
Feb 05 09:33:14 <rostedt>            3.35%        hackbench  [kernel]                     [k] __lock_text_start
Feb 05 09:33:14 <rostedt>            2.29%        hackbench  [kernel]                     [k] clear_page_c
Feb 05 09:34:06 <rostedt>       nothing is over 9
Feb 05 09:34:48 <rostedt>       where with irqs off we had a couple:
Feb 05 09:34:51 <rostedt>           0.81 :      ffffffff810a5b78:       9c                      pushfq 
Feb 05 09:34:51 <rostedt>           9.06 :      ffffffff810a5b79:       41 5c                   pop    %r12
Feb 05 09:34:51 <rostedt>           3.44 :      ffffffff810a5b7b:       fa                      cli    
Feb 05 09:34:51 <rostedt>           9.59 :      ffffffff810a5b7c:       65 44 8b 2c 25 c0 cc    mov    %gs:0xccc0,%r13d
Feb 05 09:40:04 <rostedt>       disabling/enabling interrupts is more than 50% of the entire stack_trace function call

Here's the box this was all executed on:

vendor_id	: GenuineIntel
cpu family	: 6
model		: 23
model name	: Intel(R) Core(TM)2 Quad  CPU   Q9450  @ 2.66GHz
stepping	: 6
cpu MHz		: 2659.644
cache size	: 6144 KB
physical id	: 0
siblings	: 4
core id		: 0
cpu cores	: 4
apicid		: 0
initial apicid	: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic mtrr pge mca cmov pat
pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm
constant_tsc arch_perfmon pebs bts rep_good aperfmperf pni dtes64
monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm sse4_1 lahf_lm
tpr_shadow vnmi flexpriority
bogomips	: 5319.28
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

Perhaps newer hardware is getting better at this. Also, this is an
extreme case, where I'm enabling and disabling interrupts at the start
of every function in the kernel.

This is all just an FYI,

-- Steve


