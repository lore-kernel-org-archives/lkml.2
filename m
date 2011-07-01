Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246Ab1GAMzJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 08:55:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:63239 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755148Ab1GAMzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 08:55:06 -0400
X-Authority-Analysis: v=1.1 cv=yMxAJ7W7nAoPh8ZdbvCArpG6pAdHwgpzIvOq8QbMesM= c=1 sm=0 a=EAdfuy46jrwA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=aXUIwMEJxfJcm6oWEiAA:9 a=isRWt_RdPDXcef3l-64A:7 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH] kprobes: Add separate preempt_disabling for
 kprobes
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        yrl.pp-manager.tt@hitachi.com
In-Reply-To: <4E0DABCC.1090303@hitachi.com>
References: <1309440213.26417.76.camel@gandalf.stny.rr.com>
	 <1309449117.26417.90.camel@gandalf.stny.rr.com>
	 <4E0D5682.3050806@hitachi.com>  <4E0DABCC.1090303@hitachi.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 01 Jul 2011 08:54:56 -0400
Message-ID: <1309524896.26417.139.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-01 at 20:13 +0900, Masami Hiramatsu wrote:
> Hi Steve,
> 
> (2011/07/01 14:09), Masami Hiramatsu wrote:
> > (2011/07/01 0:51), Steven Rostedt wrote:
> >> Kprobes requires preemption to be disabled as it single steps the code
> >> it replaced with a breakpoint. But because the code that is single
> >> stepped could be reading the preempt count, the kprobe disabling of the
> >> preempt count can cause the wrong value to end up as a result. Here's an
> >> example:
> >>
> >> If we add a kprobe on a inc_preempt_count() call:
> > 
> > BTW, on my tip tree, add_preempt_count (a.k.a. inc_preempt_count())
> > is marked as __kprobes, so it can not be probed. Is there any change?
> 
> Finally, I've stacked on this point. It seems that
> the add_preempt_count() (or inc_preempt_count) is called somewhere
> inside the do_int3 and it causes double fault and reboot.
> 
> I guess following loop could be happen,
> inc_preempt_count->int3->do_int3->preempt_conditional_sti->inc_preempt_count..
> 
> I'm still investigating that. Could you tell me what the basic tree
> you are working on? I'm using the latest -tip tree.

I'm using latest Linus tree. I think it was v3.0-rc5.

The bug I hit was when I added my trace point here:

Dump of assembler code for function schedule:
   0xffffffff814e042d <+0>:	push   %rbp
   0xffffffff814e042e <+1>:	mov    %rsp,%rbp
   0xffffffff814e0431 <+4>:	push   %r15
   0xffffffff814e0433 <+6>:	push   %r14
   0xffffffff814e0435 <+8>:	push   %r13
   0xffffffff814e0437 <+10>:	push   %r12
   0xffffffff814e0439 <+12>:	push   %rbx
   0xffffffff814e043a <+13>:	sub    $0x88,%rsp
   0xffffffff814e0441 <+20>:	callq  0xffffffff814e8b40
   0xffffffff814e0446 <+25>:	mov    %gs:0xb5c8,%rdx
   0xffffffff814e044f <+34>:	mov    $0x10f40,%rax
   0xffffffff814e0456 <+41>:	mov    %rdx,-0x60(%rbp)
   0xffffffff814e045a <+45>:	mov    %rdx,-0x88(%rbp)
   0xffffffff814e0461 <+52>:	mov    %gs:0xb5c0,%rcx
   0xffffffff814e046a <+61>:	mov    %rax,-0x58(%rbp)
   0xffffffff814e046e <+65>:	mov    %rax,-0x80(%rbp)
   0xffffffff814e0472 <+69>:	mov    %rax,-0x68(%rbp)
   0xffffffff814e0476 <+73>:	mov    %rcx,-0x90(%rbp)
   0xffffffff814e047d <+80>:	mov    %rax,-0x98(%rbp)
   0xffffffff814e0484 <+87>:	mov    %rax,-0x70(%rbp)
   0xffffffff814e0488 <+91>:	mov    %rax,-0x78(%rbp)
   0xffffffff814e048c <+95>:	mov    %rax,-0xa0(%rbp)
   0xffffffff814e0493 <+102>:	mov    $0x1,%edi
   0xffffffff814e0498 <+107>:	callq  0xffffffff814e5d53 <add_preempt_count>
   0xffffffff814e049d <+112>:	callq  0xffffffff81248b98 <debug_smp_processor_id>
   0xffffffff814e04a2 <+117>:	mov    %eax,%r14d
   0xffffffff814e04a5 <+120>:	cltq   
   0xffffffff814e04a7 <+122>:	mov    -0x58(%rbp),%rbx
   0xffffffff814e04ab <+126>:	mov    %r14d,%edi
   0xffffffff814e04ae <+129>:	add    -0x7e4adcf0(,%rax,8),%rbx
   0xffffffff814e04b6 <+137>:	callq  0xffffffff810a9fa0 <rcu_note_context_switch>
   0xffffffff814e04bb <+142>:	mov    -0x60(%rbp),%rdi
   0xffffffff814e04bf <+146>:	mov    0x8b8(%rbx),%rsi
   0xffffffff814e04c6 <+153>:	mov    -0x1fbc(%rdi),%eax
   0xffffffff814e04cc <+159>:	mov    %rsi,-0x48(%rbp)
   0xffffffff814e04d0 <+163>:	and    $0xefffffff,%eax
   0xffffffff814e04d5 <+168>:	dec    %eax
   0xffffffff814e04d7 <+170>:	je     0xffffffff814e04ea <schedule+189>

I added a probe at +153. That is where it reads preempt_count(). Funny
thing is, I only inserted it there, as a random place to find the "prev"
pointer. I hit this bug just by coincidence.

Here's the code:

asmlinkage void __sched schedule(void)
{
	struct task_struct *prev, *next;
	unsigned long *switch_count;
	struct rq *rq;
	int cpu;

need_resched:
	preempt_disable();
	cpu = smp_processor_id();
	rq = cpu_rq(cpu);
	rcu_note_context_switch(cpu);
	prev = rq->curr;

	schedule_debug(prev);

----

static inline void schedule_debug(struct task_struct *prev)
{
	/*
	 * Test if we are atomic. Since do_exit() needs to call into
	 * schedule() atomically, we ignore that path for now.
	 * Otherwise, whine if we are scheduling when we should not be.
	 */
	if (unlikely(in_atomic_preempt_off() && !prev->exit_state))
		__schedule_bug(prev);

	profile_hit(SCHED_PROFILING, __builtin_return_address(0));

	schedstat_inc(this_rq(), sched_count);
}

# define PREEMPT_CHECK_OFFSET 1

#define in_atomic_preempt_off() \
		((preempt_count() & ~PREEMPT_ACTIVE) != PREEMPT_CHECK_OFFSET)

The read of preempt_count() in in_atomic_preempt_off() was where I
placed my probe. Instead of placing a 1 into %eax, because kprobes had
preemption disabled as well, it placed a 2 there. This made the compare
to PREEMPT_CHECK_OFFSET fail.

What happened next was that every schedule triggered the schedule_bug,
and caused the printk to write. The problem wasn't that the system
crashed, but it lived locked. Nothing would move forward as by the time
printk finished, something else was scheduled in. By changing the code
to:

static noinline void __schedule_bug(struct task_struct *prev)
{
	struct pt_regs *regs = get_irq_regs();
	static int once;

	if (once)
		return;
	once++;

	printk(KERN_ERR "BUG: scheduling while atomic: %s/%d/0x%08x\n",
		prev->comm, prev->pid, preempt_count());

It printed the error once, and everything continued to run normally.
That's because the value of the corrupted preempt count only was used
for this test and not for anything else more meaningful.

But, this is when I realized that it is possible to corrupt
inc_preempt_count() when debug and preempt tracing is not set.

-- Steve







