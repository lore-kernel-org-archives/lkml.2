Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab1IWLjh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 07:39:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:48991 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327Ab1IWLjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 07:39:35 -0400
X-Authority-Analysis: v=1.1 cv=XWD5/VRj2HUJOhsR8cgmvPBlhMACpZXxseY1Kn/ehQI= c=1 sm=0 a=fpqnIV_ZEzMA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=ggbMXSSPus1lnWScO54A:9 a=-Ofyw6oqVC0nW6zrHScA:7 a=PUjeQqilurYA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: Re: [PATCH 21/21] tracing: Add optional percpu buffers for
 trace_printk()
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1316777306.9084.11.camel@twins>
References: <20110922220935.537134016@goodmis.org>
	 <20110922221030.111078233@goodmis.org>  <1316776031.9084.4.camel@twins>
	 <1316776605.29966.153.camel@gandalf.stny.rr.com>
	 <1316777306.9084.11.camel@twins>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 23 Sep 2011 07:39:33 -0400
Message-ID: <1316777973.29966.163.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-23 at 13:28 +0200, Peter Zijlstra wrote:

> Of course, printk() is most useless, its too slow, and its definitely
> not NMI-safe.
> 
> If you've only got a single buffer, I don't see why you would need
> per-cpu recursion detection, just spin_try_lock() the thing and if you
> fail, bail. But that's not what the changelog said, or at least implied.

Not sure if the raw_spin_locks() had a try lock back when this was
written. The recursion detection was there from day one, and has nothing
to do with this patch. Which is why the changelog said nothing about it.
This patch only is about not having the trace_printk() cause extra
synchronization. This bit me once as trace_printk() cause a race to
disappear.


> 
> The possibility of dropping trace output like that is most worrying
> though. I can imagine myself tearing my hair out trying to make sense of
> a trace, and then wanting to kick you after finding out it lost the
> crucial bit.

Understood, but NMIs are always something to be worried about causing
strange issues.

> 
> > > better to make all of trace_printk() depend on that extra config, there
> > > is absolutely 0 point in having a broken and fully serialized trace
> > > 'fail^wfeature'.
> > 
> > Not, having per cpu buffers still doesn't allow NMIs to interrupt
> > trace_printk(). Otherwise the NMI would just corrupt the current percpu
> > buffer.
> 
> Multiple buffers sounds about right, not sure if you disable interrupts
> over the normal trace path, but ISTR you don't, so you need
> task/softirq/irq/nmi buffers per cpu.

trace_printk() does disable interrupts, so it is only an NMI issue.


> 
> Really loosing trace output is not an option, ever (aside from stuff
> falling of the end of the buffer). Reliability first, performance
> second.
> 

Fine, then I'll add (on top of this patch) a CONFIG_TRACE_PRINTK_FULL or
some such name that will create the per cpu NMI and normal buffers,
which will not miss any interrupts. I just want to limit the unused
memory for 99.99999% of users.

I could make the TRACE_PRINTK_FULL not even disable interrupts and have
the normal/softirq/irq/nmi per cpu buffers. This will be something that
would *not* be enabled in production.

-- Steve


