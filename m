Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585Ab1ITIcn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 04:32:43 -0400
Received: from www.linutronix.de ([62.245.132.108]:59794 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203Ab1ITIcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 04:32:41 -0400
Date: Tue, 20 Sep 2011 10:32:34 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Lameter <cl@linux.com>, Tejun Heo <htejun@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC][PATCH 0/5] Introduce checks for preemptable code for
 this_cpu_read/write()
In-Reply-To: <1316488378.29966.35.camel@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.2.02.1109200933310.2723@ionos>
References: <20110919212040.745370781@goodmis.org>  <m2ehzcdkf2.fsf@firstfloor.org> <1316488378.29966.35.camel@gandalf.stny.rr.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Sep 2011, Steven Rostedt wrote:
> On Mon, 2011-09-19 at 19:20 -0700, Andi Kleen wrote:
> > Steven Rostedt <rostedt@goodmis.org> writes:
> > 
> > > I just found out that the this_cpu_*() functions do not perform the
> > > test to see if the usage is in atomic or not. Thus, the blind
> > > conversion of the per_cpu(*, smp_processor_id()) and the get_cpu_var()
> > > code to this_cpu_*() introduce the regression to detect the hard
> > > to find case where a per cpu variable is used in preempt code that
> > > migrates and causes bugs.

Just for the record. I added some this_cpu_* debug checks to my
filesystem eating 2.6.38-rt and guess what: They trigger right away in
the FS code and without digging deeper I'm 100% sure, that this is the
root cause of the problems I was hunting for weeks. Thanks for wasting
my time and racking my nerves.

People who remove debugability blindly have earned an one way ticket
to the Oort cloud. There is utter chaos already so they wont be
noticed at all.

> > Didn't preempt-rt recently get changed to not migrate in kernel-preempt
> > regions. How about just fixing the normal preemption to not do this
> > either.
> 
> Actually, that's part of the issue. RT has made spin_locks not migrate.
> But this has also increased the overhead of those same spinlocks. I'm
> hoping to do away with the big hammer approach (although Thomas is less
> interested in this). I would like to have areas that require per-cpu
> variables to be annotated,

Yes, annotation is definitely something which is needed badly.

Right now preempt_disable()/local_irq_disable() are used explicit or
implicit (through spin_lock*) to protect per cpu sections, but we have
no clue, where such a section really starts and ends.

In fact preempt_disable/local_irq_disable() have become the new cpu
local BKL and the per cpu stuff just happily (ab)uses that without
documenting the scope of the code sections which rely on that. It's
just nesting inside spinlocked sections at random places without
giving a clue what needs to be kept on a cpu or not.

That's what makes it basically impossible to use anything else than
the big hammer approach in RT. Nobody has the bandwidth to audit all
this stuff and I seriously doubt that we can improve that situation
unless we get proper annotation of the per cpu sections in place.

Can we please put that on the KS agenda? This definitely needs to be
addressed urgently.

> and not have every spinlock disable preemption.

That doesn't work, you're prone to deadlocks then. I guess you meant
not disable migration on RT, right?

Thanks,

	tglx
