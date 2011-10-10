Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab1JJMbw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 08:31:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:41197 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867Ab1JJMbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 08:31:50 -0400
X-Authority-Analysis: v=1.1 cv=cSzO76bR5tCkfUT9bEmBgR3d7VUusRLeq08eKGxa4EU= c=1 sm=0 a=Q0RNhdNGvDcA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=YIYXtwNVfhIHOKUi7jsA:9 a=Ue1VhuO_ja9aIdhBDXMA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [PATCH 0/3][RFC] trace_printk() using percpu buffers
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Mon, 10 Oct 2011 08:31:48 -0400
In-Reply-To: <1318244697.14400.18.camel@laptop>
References: <20111008170227.792806635@goodmis.org>
	 <1318244697.14400.18.camel@laptop>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1318249909.7904.70.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-10 at 13:04 +0200, Peter Zijlstra wrote:
> On Sat, 2011-10-08 at 13:02 -0400, Steven Rostedt wrote:
> > 
> > Peter,
> > 
> > You had issues with the previous version of my trace_printk() code.
> > I rewrote it to do the following.
> > 
> > By default, it still uses the single buffer protected by a spinlock
> > and an atomic (for NMIs). The NMI case can cause dropped prints if
> > the NMI happens while a trace_printk() is processing.
> 
> Why bother keeping that?

Because very few developers debug nmi's. printk is known not to work
there.

I still find it useful to have without having to switch on a config
option or kernel command line.

> 
> > When trace_printk_percpu is enabled, either via the trace options or
> > the kernel command line, then two sets of percpu buffers are made,
> > one for normal and irqs (interrupts are still disabled), and the other
> > is for NMIs. These can be added or removed at anytime.
> 
> So why not allocate 4, one for {task, softirq, irq, NMI} resp, then all
> you need to do is disable preemption.
> 
> depending on tracing/options/trace_printk ?

Preemption still needs to be disabled. But if you think that's better
than disabling interrupts, I could do that too.

> 
> > The last patch adds a CONFIG_TRACE_PRINTK_PERCPU that makes trace_printk()
> > permanently use two sets of per_cpu buffers, and these can not be
> > removed. This will give the least amount of overhead for trace_printk()
> > with the sacrifice of memory overhead. This is an option I could imagine
> > you would just set and forget about.
> 
> Is that one dereference really that expensive?

It's also a compare and jump, but I added this option for you :)

That way, you could set this option and forget about it.

-- Steve


