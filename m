Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934511Ab0KQLgE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 06:36:04 -0500
Received: from canuck.infradead.org ([134.117.69.58]:54771 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934287Ab0KQLgB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 06:36:01 -0500
Subject: Re: [ANNOUNCE] New utility: 'trace'
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
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
In-Reply-To: <20101117083020.GA11336@elte.hu>
References: <alpine.LFD.2.00.1011162103580.2900@localhost6.localdomain6>
	 <4CE2F747.4060406@linux.intel.com> <20101116221726.GB26243@nowhere>
	 <20101117083020.GA11336@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 17 Nov 2010 12:35:50 +0100
Message-ID: <1289993750.2109.718.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-17 at 09:30 +0100, Ingo Molnar wrote:
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > On Tue, Nov 16, 2010 at 01:27:35PM -0800, Darren Hart wrote:
> > > On 11/16/2010 01:04 PM, Thomas Gleixner wrote:
> > >> We are pleased to announce a new tracing tool called 'trace'.
> > >>
> > >
> > > Hi Thomas, Ingo - Congrats and Thanks!
> > >
> > >> At this point we'd like to ask for feedback from other users of tracing tools,
> > >> which workflow components would you like to see in addition to what the 'trace'
> > >> tool is offering?
> > >>
> > >> Comments, bug reports, suggestions welcome,
> > >
> > > The first thing that comes to mind is trace_marker:
> > >
> > > echo "Test point A" > /sys/kernel/debug/tracing/trace_marker
> > >
> > > I've found this sort of markup to be useful using ftrace (with C  
> > > equivalents embedded in the test case). Is this supported?
> > 
> > 
> > No, the trace_marker file sends trace_printk events. And trace_printk
> > events needs to be converted to use the unified trace event interface
> > (ie: implement a struct ftrace_event_call).
> > 
> > This shouldn't be so hard, and there are several ways we could do this.
> > 
> > An idea is to reproduce the kernel file hierarchy in a "printk" event
> > subsystem, but this implies to allow subsystems nesting.
> > 
> > Imagine you have two trace_printk(), one in kernel/sched.c:117
> > and one in kernel/time/tick-sched.c:228
> > The result would be:
> > 
> > $ ls /sys/kernel/debug/tracing/events/printk
> > 
> > /sys/kernel/debug/tracing/events/printk:
> > enable  filter  kernel/
> > 
> > /sys/kernel/debug/tracing/events/printk/kernel:
> > enable  filter sched.c/ time/
> > 
> > /sys/kernel/debug/tracing/events/printk/kernel/sched.c:
> > enable  filter  117/
> > 
> > /sys/kernel/debug/tracing/events/printk/kernel/sched.c/117:
> > enable filter format id
> > 
> > /sys/kernel/debug/tracing/events/printk/kernel/time:
> > enable  filter tick-sched.c/
> > 
> > /sys/kernel/debug/tracing/events/printk/kernel/time/tick-sched.c:
> > enable  filter  228/
> > 
> > /sys/kernel/debug/tracing/events/printk/kernel/time/tick-sched.c/228:
> > enable filter format id
> > 
> > 
> > The format would be quite easy, and only one field for the whole string (strloc).
> > 
> > Not sure what to do with trace_marker. I just think we can add it as:
> > /sys/kernel/debug/tracing/events/printk/sys/kernel/debug/tracing/trace_marker
> > 
> > <:o)
> > 
> > 
> > But may be the whole idea is just fancy and nobody will care, [...]
> 
> I think it's an excellent idea, and it could also give us the framework to integrate 
> the dynamic_printk points.
> 
> > [...] and would just a simple single event in a printk subsystem, on which you can 
> > use a kind of virtual filter:
> > 
> > 	echo "path != kernel/whatever.c:226" > /sys/kernel/debug/tracing/events/printk/filter
> > 
> > would turn on every trace_printk() but the one in the given path.
> > 
> > Dunno, I like both ideas. I prefer the first one which looks to me more flexible: 
> > could be useful to list the user his trace_printks for example and implement an 
> > interface for him to quickly select the trace_printk he wants.
> 
> I prefer the first one too.
> 
> > For example I'm currently working with dozens of trace_printk() and I would be 
> > very happy to turn some of them off half of the time.
> 
> I guess we could try such a patch. If you send a prototype i'd be interested in 
> testing it out.

I don't see the point, the kernel shouldn't contain any trace_printk()s
to begin with..
