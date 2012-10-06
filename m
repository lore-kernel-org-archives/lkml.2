Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751726Ab2JFOvt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 10:51:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8638 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071Ab2JFOvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 10:51:48 -0400
X-Authority-Analysis: v=2.0 cv=dvhZ+ic4 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=zYQHrSgTeTAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=_67WK3i7ub8A:10 a=LxbkeVMq36MxkYlhrp0A:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1349535105.6755.104.camel@gandalf.local.home>
Subject: Re: [PATCH v4] trace,x86: add x86 irq vector tracepoints
From: Steven Rostedt <rostedt@goodmis.org>
To: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Seiji Aguchi <seiji.aguchi@hds.com>,
        "Thomas Gleixner (tglx@linutronix.de)" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "'mingo@elte.hu' (mingo@elte.hu)" <mingo@elte.hu>,
        "x86@kernel.org" <x86@kernel.org>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Date: Sat, 06 Oct 2012 10:51:45 -0400
In-Reply-To: <20121006130532.GB11120@liondog.tnic>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D41385F33C@USINDEM103.corp.hds.com>
	 <50612729.2080307@zytor.com>
	 <A5ED84D3BB3A384992CBB9C77DEDA4D41386426D@USINDEM103.corp.hds.com>
	 <50650A7E.90807@zytor.com>
	 <A5ED84D3BB3A384992CBB9C77DEDA4D413869FD7@USINDEM103.corp.hds.com>
	 <1349446428.6755.56.camel@gandalf.local.home> <506F7849.2080805@zytor.com>
	 <1349492261.6755.87.camel@gandalf.local.home>
	 <20121006130532.GB11120@liondog.tnic>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-10-06 at 15:05 +0200, Borislav Petkov wrote:

> What I'm missing with all those patches on LKML is: here's a patch that
> doesn't add a new feature but gives us n% improv with this and that
> workload. I wish we had more of those instead of the gazillion new
> features each 3 months.

That would be nice too. But we can also add a patch that gives us
negligible improvement that makes things a little more complex and also
opens the possibility of a security hole.

Thus my question is, is the swap IDT really worth it? I'm fine if
someone goes ahead and implements it. Heck, I'd love to implement it
when I have time, as it refreshes my knowledge of how intel archs do
interrupt processing.

I'm just worried that we are adding more complexity to code for very
little gain.

I think we need to take another look at this.

1) Are the tracepoints that Seiji worth adding? If not then we can stop
the discussion here.

2) Are the tracepoints done in a way that it's not going to cause "ABI"
issues. If not then we need to redesign the tracepoints.

3) If we are here, then we have tracepoints that are worth adding and
are done in a way that they should be stable for the long term. OK, how
to implement them?  The question really is, should we keep it 0% impact
when not active by the IDT switch or allow for the negligible impact by
adding the tracepoints into the code directly and not worrying about it.

  a) The tracepoints are going in the code regardless. Even with a 
  switch we need to have a duplicate of the calls, one with and one
  without the tracepoints.

  b) It can be done with one big change: add the tracepoints and do the
  duplicate with and without versions for the IDT switch. Or we can
  break it into two parts. First, add the tracepoints, then add the
  switch with the duplicates. I prefer this method if we are doing
  the switch.

I expect that if we do the switch we would have something like this:

void __irq_entry smp_apic_timer_interrupt(struct pt_regs *regs)
{
	struct pt_regs *old_regs = set_irq_regs(regs);

	/*
	 * NOTE! We'd better ACK the irq immediately,
	 * because timer handling can be slow.
	 */
	ack_APIC_irq();
	/*
	 * update_process_times() expects us to have done irq_enter().
	 * Besides, if we don't timer interrupts ignore the global
	 * interrupt lock, which is the WrongThing (tm) to do.
	 */
	irq_enter();
	exit_idle();
	local_apic_timer_interrupt();
	irq_exit();

	set_irq_regs(old_regs);
}

void __irq_entry trace_smp_apic_timer_interrupt(struct pt_regs *regs)
{
	struct pt_regs *old_regs = set_irq_regs(regs);

	/*
	 * NOTE! We'd better ACK the irq immediately,
	 * because timer handling can be slow.
	 */
	ack_APIC_irq();
	/*
	 * update_process_times() expects us to have done irq_enter().
	 * Besides, if we don't timer interrupts ignore the global
	 * interrupt lock, which is the WrongThing (tm) to do.
	 */
	irq_enter();
	exit_idle();
	trace_local_timer_entry(LOCAL_TIMER_VECTOR);
	local_apic_timer_interrupt();
	trace_local_timer_exit(LOCAL_TIMER_VECTOR);
	irq_exit();

	set_irq_regs(old_regs);
}

Now we have two functions accomplishing the same task. Any change to one
must be done to change the other. Due to rcu idle, the tracepoint needs
to be after the exit_idle() and before irq_exit().

We could force the two to be in step by using ugly macro magic:

#define APIC_TIMER_INTERRUPT(trace, trace_enter, trace_exit)	\
void __irq_entry trace##_smp_apic_timer_interrupt(struct pt_regs *regs) \
{ \
	struct pt_regs *old_regs = set_irq_regs(regs); \
\
	/* \
	 * NOTE! We'd better ACK the irq immediately, \
	 * because timer handling can be slow. \
	 */ \
	ack_APIC_irq(); \
	/* \
	 * update_process_times() expects us to have done irq_enter(). \
	 * Besides, if we don't timer interrupts ignore the global \
	 * interrupt lock, which is the WrongThing (tm) to do. \
	 */ \
	irq_enter(); \
	exit_idle(); \
	trace_enter; \
	local_apic_timer_interrupt(); \
	trace_exit; \
	irq_exit(); \
 \
	set_irq_regs(old_regs); \
}

APIC_TIMER_INTERRUPT(,,)
APIC_TIMER_INTERRUPT(trace,trace_local_timer_entry(LOCAL_TIMER_VECTOR), trace_local_timer_exit(LOCAL_TIMER_VECTOR))
 

But I'm not sure we want to go there.

-- Steve


