Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab1IWL2x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 07:28:53 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54789 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327Ab1IWL2w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 07:28:52 -0400
Subject: Re: [PATCH 21/21] tracing: Add optional percpu buffers for
 trace_printk()
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Fri, 23 Sep 2011 13:28:26 +0200
In-Reply-To: <1316776605.29966.153.camel@gandalf.stny.rr.com>
References: <20110922220935.537134016@goodmis.org>
	 <20110922221030.111078233@goodmis.org>  <1316776031.9084.4.camel@twins>
	 <1316776605.29966.153.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316777306.9084.11.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-23 at 07:16 -0400, Steven Rostedt wrote:
> On Fri, 2011-09-23 at 13:07 +0200, Peter Zijlstra wrote:
> > On Fri, 2011-09-23 at 13:02 +0200, Peter Zijlstra wrote:
> > > On Thu, 2011-09-22 at 18:09 -0400, Steven Rostedt wrote:
> > > > 
> > > > Currently, trace_printk() uses a single buffer to write into
> > > > to calculate the size and format needed to save the trace. To
> > > > do this safely in an SMP environment, a spin_lock() is taken
> > > > to only allow one writer at a time to the buffer. But this could
> > > > also affect what is being traced, and add synchronization that
> > > > would not be there otherwise. 
> > > 
> > > so trace_printk() isn't NMI safe? #$%@^%@@$%@
> 
> It is NMI safe, always was (I use it there too). It has a percpu
> recursion detection (always has), thus if an NMI interrupts a current
> trace_printk(), the NMI trace_printk() will not print. I could add an
> NMI buffer to allow NMIs to print, but so far, we don't usually have
> issues with trace_printk(). Heck, I'm not sure printk() wont cause
> issues in NMIs. I think trace_printk() is still safer than printk.

Of course, printk() is most useless, its too slow, and its definitely
not NMI-safe.

If you've only got a single buffer, I don't see why you would need
per-cpu recursion detection, just spin_try_lock() the thing and if you
fail, bail. But that's not what the changelog said, or at least implied.

The possibility of dropping trace output like that is most worrying
though. I can imagine myself tearing my hair out trying to make sense of
a trace, and then wanting to kick you after finding out it lost the
crucial bit.

> > better to make all of trace_printk() depend on that extra config, there
> > is absolutely 0 point in having a broken and fully serialized trace
> > 'fail^wfeature'.
> 
> Not, having per cpu buffers still doesn't allow NMIs to interrupt
> trace_printk(). Otherwise the NMI would just corrupt the current percpu
> buffer.

Multiple buffers sounds about right, not sure if you disable interrupts
over the normal trace path, but ISTR you don't, so you need
task/softirq/irq/nmi buffers per cpu.

Really loosing trace output is not an option, ever (aside from stuff
falling of the end of the buffer). Reliability first, performance
second.


