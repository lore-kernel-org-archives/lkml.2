Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934640Ab0KQIbE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 03:31:04 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59286 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933427Ab0KQIbA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 03:31:00 -0500
Date: Wed, 17 Nov 2010 09:30:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Darren Hart <dvhart@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Jason Baron <jbaron@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Christoph Hellwig <hch@lst.de>, Pekka Enberg <penberg@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [ANNOUNCE] New utility: 'trace'
Message-ID: <20101117083020.GA11336@elte.hu>
References: <alpine.LFD.2.00.1011162103580.2900@localhost6.localdomain6>
 <4CE2F747.4060406@linux.intel.com>
 <20101116221726.GB26243@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101116221726.GB26243@nowhere>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Tue, Nov 16, 2010 at 01:27:35PM -0800, Darren Hart wrote:
> > On 11/16/2010 01:04 PM, Thomas Gleixner wrote:
> >> We are pleased to announce a new tracing tool called 'trace'.
> >>
> >
> > Hi Thomas, Ingo - Congrats and Thanks!
> >
> >> At this point we'd like to ask for feedback from other users of tracing tools,
> >> which workflow components would you like to see in addition to what the 'trace'
> >> tool is offering?
> >>
> >> Comments, bug reports, suggestions welcome,
> >
> > The first thing that comes to mind is trace_marker:
> >
> > echo "Test point A" > /sys/kernel/debug/tracing/trace_marker
> >
> > I've found this sort of markup to be useful using ftrace (with C  
> > equivalents embedded in the test case). Is this supported?
> 
> 
> No, the trace_marker file sends trace_printk events. And trace_printk
> events needs to be converted to use the unified trace event interface
> (ie: implement a struct ftrace_event_call).
> 
> This shouldn't be so hard, and there are several ways we could do this.
> 
> An idea is to reproduce the kernel file hierarchy in a "printk" event
> subsystem, but this implies to allow subsystems nesting.
> 
> Imagine you have two trace_printk(), one in kernel/sched.c:117
> and one in kernel/time/tick-sched.c:228
> The result would be:
> 
> $ ls /sys/kernel/debug/tracing/events/printk
> 
> /sys/kernel/debug/tracing/events/printk:
> enable  filter  kernel/
> 
> /sys/kernel/debug/tracing/events/printk/kernel:
> enable  filter sched.c/ time/
> 
> /sys/kernel/debug/tracing/events/printk/kernel/sched.c:
> enable  filter  117/
> 
> /sys/kernel/debug/tracing/events/printk/kernel/sched.c/117:
> enable filter format id
> 
> /sys/kernel/debug/tracing/events/printk/kernel/time:
> enable  filter tick-sched.c/
> 
> /sys/kernel/debug/tracing/events/printk/kernel/time/tick-sched.c:
> enable  filter  228/
> 
> /sys/kernel/debug/tracing/events/printk/kernel/time/tick-sched.c/228:
> enable filter format id
> 
> 
> The format would be quite easy, and only one field for the whole string (strloc).
> 
> Not sure what to do with trace_marker. I just think we can add it as:
> /sys/kernel/debug/tracing/events/printk/sys/kernel/debug/tracing/trace_marker
> 
> <:o)
> 
> 
> But may be the whole idea is just fancy and nobody will care, [...]

I think it's an excellent idea, and it could also give us the framework to integrate 
the dynamic_printk points.

> [...] and would just a simple single event in a printk subsystem, on which you can 
> use a kind of virtual filter:
> 
> 	echo "path != kernel/whatever.c:226" > /sys/kernel/debug/tracing/events/printk/filter
> 
> would turn on every trace_printk() but the one in the given path.
> 
> Dunno, I like both ideas. I prefer the first one which looks to me more flexible: 
> could be useful to list the user his trace_printks for example and implement an 
> interface for him to quickly select the trace_printk he wants.

I prefer the first one too.

> For example I'm currently working with dozens of trace_printk() and I would be 
> very happy to turn some of them off half of the time.

I guess we could try such a patch. If you send a prototype i'd be interested in 
testing it out.

Thanks,

	Ingo
