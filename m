Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142Ab1AGPwO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 10:52:14 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:48124 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753944Ab1AGPwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 10:52:10 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=9cH4ACZdM5kA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=JAwFrNy2CBNqCRTFEUQA:9 a=8JTPCRdgCljdjl7RxqYA:7 a=r9LrAnFOZMdAAH-Wes5wD1Y21mwA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] tracing, perf : add cpu hotplug trace events
From: Steven Rostedt <rostedt@goodmis.org>
To: Amit Kucheria <amit.kucheria@linaro.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>, linux-kernel@vger.kernel.org,
        linux-hotplug@vger.kernel.org, fweisbec@gmail.com
In-Reply-To: <AANLkTik0i5xeNG_+tgdfWRjC1cQAbm+-0fDNGih5KfRx@mail.gmail.com>
References: <AANLkTimsR3=BKSF8EyASu4_T_vTznw4yEqmxPS8gOQCy@mail.gmail.com>
	 <AANLkTik0i5xeNG_+tgdfWRjC1cQAbm+-0fDNGih5KfRx@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 07 Jan 2011 10:52:08 -0500
Message-ID: <1294415528.26623.226.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-07 at 14:51 +0530, Amit Kucheria wrote:

> > +
> > +TRACE_EVENT(hotplug_start,
> > +
> > + TP_PROTO(unsigned int type, unsigned int step, unsigned int cpuid),
> > +
> > + TP_ARGS(type, step, cpuid),
> > +
> > + TP_STRUCT__entry(
> > + __field(u32, type)
> > + __field(u32, step)
> > + __field(u32, cpuid)
> > + ),
> > +
> > + TP_fast_assign(
> > + __entry->type = type;
> > + __entry->step = step;
> > + __entry->cpuid = cpuid;
> > + ),
> > +
> > + TP_printk("type=%lu step=%lu cpuid=%lu", (unsigned long)__entry->type,
> > + (unsigned long)__entry->step, (unsigned long)__entry->cpuid)
> > +);
> > +
> > +TRACE_EVENT(hotplug_end,
> > +
> > + TP_PROTO(unsigned int type, unsigned int step, unsigned int cpuid),
> > +
> > + TP_ARGS(type, step, cpuid),
> > +
> > + TP_STRUCT__entry(
> > + __field(u32, type)
> > + __field(u32, step)
> > + __field(u32, cpuid)
> > + ),
> > +
> > + TP_fast_assign(
> > + __entry->type = type;
> > + __entry->step = step;
> > + __entry->cpuid = cpuid;
> > + ),
> > +
> > + TP_printk("type=%lu step=%lu cpuid=%lu", (unsigned long)__entry->type,
> > + (unsigned long)__entry->step, (unsigned long)__entry->cpuid)
> > +);
> > +
> > 

Please use classes when having tracepoints that have the same fields.
This will save a bit of kernel memory. Something like:


DECLARE_EVENT_CLASS(hotplug_template,

	TP_PROTO(unsigned int type, unsigned int step, unsigned int cpuid),

	TP_ARGS(type, step, cpuid),

	TP_STRUCT__entry(
		__field(u32, type)
		__field(u32, step)
		__field(u32, cpuid)
	),

	 TP_fast_assign(
		__entry->type = type;
		__entry->step = step;
		__entry->cpuid = cpuid;
	),

	TP_printk("type=%lu step=%lu cpuid=%lu", (unsigned long)__entry->type,
		(unsigned long)__entry->step, (unsigned long)__entry->cpuid)
);

DEFINE_EVENT(hotplug_template, hotplug_start,
	TP_PROTO(unsigned int type, unsigned int step, unsigned int cpuid),
	TP_ARGS(type, step, cpuid);

DEFINE_EVENT(hotplug_template, hotplug_end,
	TP_PROTO(unsigned int type, unsigned int step, unsigned int cpuid),
	TP_ARGS(type, step, cpuid);

-- Steve


