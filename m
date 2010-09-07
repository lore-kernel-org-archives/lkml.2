Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757226Ab0IGPHx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 11:07:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:62294 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830Ab0IGPHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 11:07:47 -0400
X-Authority-Analysis: v=1.1 cv=kSl6L8luU05z5mpL051isgeeLpAUfowbwuc/WIqEapw= c=1 sm=0 a=DRyNg-0iXyMA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=Vrj5tWq_V90gqbJsK74A:9 a=9vXcHVeHisQs9QUhhKwA:7 a=NVKMYTLVVI2qXOqIVOY1m6EQrlkA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] trace: add graph output support for wakeup tracer
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20100907141846.GC5375@nowhere>
References: <1281020247-5756-1-git-send-email-jolsa@redhat.com>
	 <20100907141846.GC5375@nowhere>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 07 Sep 2010 11:07:45 -0400
Message-ID: <1283872065.5133.116.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-09-07 at 16:18 +0200, Frederic Weisbecker wrote:
> On Thu, Aug 05, 2010 at 04:57:27PM +0200, Jiri Olsa wrote:

> > +static void wakeup_graph_return(struct ftrace_graph_ret *trace)
> > +{
> > +	struct trace_array *tr = wakeup_trace;
> > +	struct trace_array_cpu *data;
> > +	unsigned long flags;
> > +	long disabled;
> > +	int cpu, pc;
> > +
> > +	if (likely(!wakeup_task))
> > +		return;
> > +
> > +	pc = preempt_count();
> > +	preempt_disable_notrace();
> > +
> > +	cpu = raw_smp_processor_id();
> > +	if (cpu != wakeup_current_cpu)
> > +		goto out_enable;
> > +
> > +	data = tr->data[cpu];
> > +	disabled = atomic_inc_return(&data->disabled);
> > +	if (unlikely(disabled != 1))
> > +		goto out;
> > +
> > +	local_irq_save(flags);
> > +	__trace_graph_return(tr, trace, flags, pc);
> > +	local_irq_restore(flags);
> 
> 
> 
> Do you disable irqs to avoid losing traces? If so there is a race
> window between the recursion barrier in data->disabled and the
> time you disable irqs.
> 
> If you don't want to lose anything (except NMIs), you need to
> replace the preempt_disable by the local_irq_save, ie disable
> irqs before the recursion protection.
> 


Or is it just to get the flags variable? If so then use
local_save_flags() instead.

-- Steve


