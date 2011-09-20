Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590Ab1ITSMH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 14:12:07 -0400
Received: from mail.openrapids.net ([64.15.138.104]:37112 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751023Ab1ITSMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 14:12:06 -0400
Date: Tue, 20 Sep 2011 14:12:03 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Christoph Lameter <cl@gentwo.org>,
        Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 0/5] Introduce checks for preemptable code for
	this_cpu_read/write()
Message-ID: <20110920181203.GA7909@Krystal>
References: <27409.1316522696@turing-police.cc.vt.edu> <alpine.DEB.2.00.1109200955190.8056@router.home> <1316531987.29966.65.camel@gandalf.stny.rr.com> <alpine.DEB.2.00.1109201108080.8056@router.home> <1316536260.29966.93.camel@gandalf.stny.rr.com> <1316537808.29966.98.camel@gandalf.stny.rr.com> <1316538541.13664.60.camel@twins> <1316538952.29966.105.camel@gandalf.stny.rr.com> <20110920172531.GA21179@Krystal> <1316541785.29966.108.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316541785.29966.108.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 14:06:41 up 300 days, 23:09,  7 users,  load average: 0.37, 0.28,
	0.28
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Tue, 2011-09-20 at 13:25 -0400, Mathieu Desnoyers wrote:
> > * Steven Rostedt (rostedt@goodmis.org) wrote:
> > > On Tue, 2011-09-20 at 19:09 +0200, Peter Zijlstra wrote:
> > > > On Tue, 2011-09-20 at 12:56 -0400, Steven Rostedt wrote:
> > > > > random_cpu_*()    // Thomas's idea
> > > > 
> > > > I like this one best..
> > > 
> > > I like it too, but not really the most appropriate.
> > > 
> > > > 
> > > > But you forgot do deal with the irqsafe_cpu() crap, that's the same
> > > > brainfart as this_cpu() but more expensive because it frobs IRQ state.
> > > 
> > > But irqsafe_cpu_*() doesn't really have any real meaning to me. That is
> > > something when I see it, I go and read the comments about it. It doesn't
> > > contain "this_cpu" which is something that seems to explain what it is,
> > > even though the obvious is not what it is.
> > 
> > Throwing ideas from the IRC discussion into the mix (Paul McKenney and I
> > came up with it at the same time):
> > 
> > preempt_protected_percpu_*()
> > irq_protected_percpu_*()
> > 
> > Seems to be quite self-explanatory.
> > 
> 
> For use where the per_cpu data is protected with preemption disabled?
> But isn't that the default case? Why make it hard to type for when you
> should use it in the normal case.
> 
> It should be hard to type when it is a hack. As I recommended on IRC, we
> probably should have it as:
> 
> use_this_if_you_really_do_not_care_what_cpu_you_are_on_but_are_anal_about_performance_cpu_*()
> 
> 1) it is very self descriptive.
> 2) it would limit the usage as people wont like to have it in their
> code ;)

Not quite. What I was proposing more precisely:

- this_cpu_*() for the case where the caller needs to disable
  preemption. This is the default case. This is exactly what you
  proposed, with WARN_ON debug checks. This could even be "percpu_*()"
  now that I think of it. There is no real point in the "this_cpu"
  prefix.

- preempt_protected_percpu_*() and irq_protected_percpu_*() for
  statistics/slub use. Those primitives disable preemption or irq
  internally on non-x86 architectures. The caller of these primitives
  is not required to disable preemption nor irqs.

Thoughts ?

Thanks,

Mathieu


-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
