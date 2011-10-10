Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914Ab1JJM5W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 08:57:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:55309 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993Ab1JJM5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 08:57:21 -0400
Subject: Re: [PATCH 0/3][RFC] trace_printk() using percpu buffers
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <1318249909.7904.70.camel@gandalf.stny.rr.com>
References: <20111008170227.792806635@goodmis.org>
	 <1318244697.14400.18.camel@laptop>
	 <1318249909.7904.70.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 Oct 2011 15:03:19 +0200
Message-ID: <1318251799.14400.28.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-10 at 08:31 -0400, Steven Rostedt wrote:

> > > By default, it still uses the single buffer protected by a spinlock
> > > and an atomic (for NMIs). The NMI case can cause dropped prints if
> > > the NMI happens while a trace_printk() is processing.
> > 
> > Why bother keeping that?
> 
> Because very few developers debug nmi's. printk is known not to work
> there.
> 
> I still find it useful to have without having to switch on a config
> option or kernel command line.

But its also a massive scalability fail. There's simply no sane reason
to keep the shared buffer trace_printk() implementation.

> > > When trace_printk_percpu is enabled, either via the trace options or
> > > the kernel command line, then two sets of percpu buffers are made,
> > > one for normal and irqs (interrupts are still disabled), and the other
> > > is for NMIs. These can be added or removed at anytime.
> > 
> > So why not allocate 4, one for {task, softirq, irq, NMI} resp, then all
> > you need to do is disable preemption.
> > 
> > depending on tracing/options/trace_printk ?
> 
> Preemption still needs to be disabled. But if you think that's better
> than disabling interrupts, I could do that too.

I guess it doesn't really matter that much..

> > > The last patch adds a CONFIG_TRACE_PRINTK_PERCPU that makes trace_printk()
> > > permanently use two sets of per_cpu buffers, and these can not be
> > > removed. This will give the least amount of overhead for trace_printk()
> > > with the sacrifice of memory overhead. This is an option I could imagine
> > > you would just set and forget about.
> > 
> > Is that one dereference really that expensive?
> 
> It's also a compare and jump, but I added this option for you :)

Ah, right :-)

> That way, you could set this option and forget about it.

Well, if all we have is the per-cpu option I'm fine either way.

