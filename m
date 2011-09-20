Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389Ab1ITSfA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 14:35:00 -0400
Received: from mail.openrapids.net ([64.15.138.104]:58332 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751010Ab1ITSe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 14:34:58 -0400
Date: Tue, 20 Sep 2011 14:34:56 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Christoph Lameter <cl@gentwo.org>,
        Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 0/5] Introduce checks for preemptable code for
	this_cpu_read/write()
Message-ID: <20110920183455.GA12919@Krystal>
References: <1316531987.29966.65.camel@gandalf.stny.rr.com> <alpine.DEB.2.00.1109201108080.8056@router.home> <1316536260.29966.93.camel@gandalf.stny.rr.com> <1316537808.29966.98.camel@gandalf.stny.rr.com> <1316538541.13664.60.camel@twins> <1316538952.29966.105.camel@gandalf.stny.rr.com> <20110920172531.GA21179@Krystal> <1316541785.29966.108.camel@gandalf.stny.rr.com> <20110920181203.GA7909@Krystal> <1316543244.29966.118.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316543244.29966.118.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 14:30:52 up 300 days, 23:33,  7 users,  load average: 0.19, 0.14,
	0.15
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Tue, 2011-09-20 at 14:12 -0400, Mathieu Desnoyers wrote:
> > Not quite. What I was proposing more precisely:
> > 
> > - this_cpu_*() for the case where the caller needs to disable
> >   preemption. This is the default case. This is exactly what you
> >   proposed, with WARN_ON debug checks. This could even be "percpu_*()"
> >   now that I think of it. There is no real point in the "this_cpu"
> >   prefix.
> > 
> > - preempt_protected_percpu_*() and irq_protected_percpu_*() for
> >   statistics/slub use. Those primitives disable preemption or irq
> >   internally on non-x86 architectures. The caller of these primitives
> >   is not required to disable preemption nor irqs.
> 
> This is totally confusing. It suggests to me that the percpu requires
> preemption protected. You are coupling the implementation of the
> function too much with the name. The name should describe its use. What
> does "preempt_protected" mean?  To me, it sounds like I should use this
> in preempt protected mode. Still way too confusing.
> 
> any_cpu_*() is still much more understanding. It means that we are
> manipulating a CPU variable, and we do not care which one.
> 
> Looking at the real use cases of this_cpu(), that seems to be exactly
> the use case for it. That is, we modify the cpu variable, maybe we get
> migrated, but in the end, we just read all the cpu variables and report
> the net sum. Thus the design POV is that we do not care what CPU
> variable we read/write. From an implementation point of view, it just
> happens to be an optimization that we try to read/write to the current
> cpu pointer. But in reality it doesn't matter what CPU variable we
> touch.
> 
> Do not confuse implementation and optimizations with design. The big
> picture design is that we do not care what CPU variable is touched. The
> name should reflect that.

Yep, understood. We might want to consider percpu_*() for the case where
the caller must disable preemption, and any_percpu_*() for the case
where we don't care on which cpu we actually are. These are all touching
per-cpu variables after all. But still, it does not take into account
the "irqsafe" vs "preemptsafe" cases. So maybe irqsafe_any_percpu_*()
and preemptsafe_any_percpu_*() would do it ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
