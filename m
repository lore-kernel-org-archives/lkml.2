Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418Ab1IWLQu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 07:16:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:65252 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170Ab1IWLQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 07:16:48 -0400
X-Authority-Analysis: v=1.1 cv=cSzO76bR5tCkfUT9bEmBgR3d7VUusRLeq08eKGxa4EU= c=1 sm=0 a=fpqnIV_ZEzMA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=1vXkE6-Bn8A6jeki7ywA:9 a=ik1467uiI_qTl8JufQcA:7 a=PUjeQqilurYA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
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
In-Reply-To: <1316776031.9084.4.camel@twins>
References: <20110922220935.537134016@goodmis.org>
	 <20110922221030.111078233@goodmis.org>  <1316776031.9084.4.camel@twins>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 23 Sep 2011 07:16:45 -0400
Message-ID: <1316776605.29966.153.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-23 at 13:07 +0200, Peter Zijlstra wrote:
> On Fri, 2011-09-23 at 13:02 +0200, Peter Zijlstra wrote:
> > On Thu, 2011-09-22 at 18:09 -0400, Steven Rostedt wrote:
> > > 
> > > Currently, trace_printk() uses a single buffer to write into
> > > to calculate the size and format needed to save the trace. To
> > > do this safely in an SMP environment, a spin_lock() is taken
> > > to only allow one writer at a time to the buffer. But this could
> > > also affect what is being traced, and add synchronization that
> > > would not be there otherwise. 
> > 
> > so trace_printk() isn't NMI safe? #$%@^%@@$%@

It is NMI safe, always was (I use it there too). It has a percpu
recursion detection (always has), thus if an NMI interrupts a current
trace_printk(), the NMI trace_printk() will not print. I could add an
NMI buffer to allow NMIs to print, but so far, we don't usually have
issues with trace_printk(). Heck, I'm not sure printk() wont cause
issues in NMIs. I think trace_printk() is still safer than printk.

> 
> better to make all of trace_printk() depend on that extra config, there
> is absolutely 0 point in having a broken and fully serialized trace
> 'fail^wfeature'.

Not, having per cpu buffers still doesn't allow NMIs to interrupt
trace_printk(). Otherwise the NMI would just corrupt the current percpu
buffer.

-- Steve


