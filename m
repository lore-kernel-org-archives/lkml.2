Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751550Ab1ITQDb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 12:03:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:55452 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab1ITQDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 12:03:30 -0400
X-Authority-Analysis: v=1.1 cv=lfM0d0QHaVz67dfwwr9cyIw6NbaGR/pZhMD6XWNi0kk= c=1 sm=0 a=6qbAnu_Q0HoA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=AbEZUEoKyYU0kizw9McA:9 a=QoW9K_SRGMBTyI0hbUIA:7 a=PUjeQqilurYA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: Re: [RFC][PATCH 2/5] mm: Switch mod_state() to __this_cpu_read()
From: Steven Rostedt <rostedt@goodmis.org>
To: Christoph Lameter <cl@gentwo.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Lameter <cl@linux.com>, Tejun Heo <htejun@gmail.com>
In-Reply-To: <alpine.DEB.2.00.1109201055470.8056@router.home>
References: <20110919212040.745370781@goodmis.org>
	 <20110919212640.688732950@goodmis.org>
	 <alpine.DEB.2.00.1109191657150.19059@router.home>
	 <alpine.LFD.2.02.1109201334590.2723@ionos>
	 <alpine.DEB.2.00.1109200947100.8056@router.home>
	 <1316531505.29966.57.camel@gandalf.stny.rr.com>
	 <alpine.DEB.2.00.1109201055470.8056@router.home>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 20 Sep 2011 12:03:28 -0400
Message-ID: <1316534608.29966.81.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-20 at 10:59 -0500, Christoph Lameter wrote:
> On Tue, 20 Sep 2011, Steven Rostedt wrote:
> 
> > On Tue, 2011-09-20 at 09:51 -0500, Christoph Lameter wrote:
> >
> > > I see that __this_cpu_xx operations may not work as intended in
> > > preemptable contexts and there we could have more changes.
> >
> > Then why do you use it in slub.c?
> >
> > in mm/slab.c slab_alloc():
> >
> > redo:
> >
> > 	/*
> > 	 * Must read kmem_cache cpu data via this cpu ptr. Preemption is
> > 	 * enabled. We may switch back and forth between cpus while
> > 	 * reading from one cpu area. That does not matter as long
> > 	 * as we end up on the original cpu again when doing the cmpxchg.
> > 	 */
> > 	c = __this_cpu_ptr(s->cpu_slab);
> >
> > The __this_cpu_*() is in preempt enabled location. In fact, the three
> > this_cpu_write()'s in acquire_slab() is done within a spinlock and thus
> > with preemption disabled.
> 
> So the this_cpu_writes could become __this_cpu_writes
> 
> The __this_cpu_ptr operation in slab_alloc is special. We explicitly do
> address calculation and do not care from which per cpu area we fetch
> multiple per cpu data items because we can verify that we are on the same
> per cpu area during the this_cpu_cmpxchg_double operation.

ARGH! You now have special cases that break the sanity of it all? This
just proves that the design is wrong.

> 
> > The point is, people get it wrong all the time. In fact, we should
> > really require that ALL USES of this_cpu_*() must be with preemption
> > disabled. Regardless. Because anytime you touch a per cpu variable,
> 
> NO!! This defeats the whole purpose of this_cpu_ops and make the whole
> scheme utterly useless.

The thing is, the whole purpose was broken to begin with. Defeating a
broken design is a good thing!

> 
> > Monkeying around with per cpu data is tricky. If you start doing it in
> > preempt enabled code, you are most certainly about to get it wrong. Why
> > have this super optimization. A preempt_disable() is a single operation
> > that touches cache hot data.
> 
> There are trivial cases like counter increments that are not a problem at
> all. Most use cases are those. More complex ones can be developed to avoid
> various overhead in performance critical sections of the kernel.
> 

And adding a preempt_disable; this_cpu_inc(); preempt_enable; is not a
bad thing either.

What benchmarks do you have that shows this helped in anything????

-- Steve


