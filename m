Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932439Ab2ARR4z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 12:56:55 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:42222 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932252Ab2ARR4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 12:56:54 -0500
X-Authority-Analysis: v=2.0 cv=I83ntacg c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=wBu39ZheO1YA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OZNpMpAgtiifqc6JUxsA:9 a=a4qmjXvVJtCnUrc03QkA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1326909412.17534.91.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH][GIT PULL][v3.3] tracing: Add header wrappers
 event_headers_start.h and event_headers_end.h
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Date: Wed, 18 Jan 2012 12:56:52 -0500
In-Reply-To: <20120118120711.GB14863@elte.hu>
References: <1326754637.7642.177.camel@gandalf.stny.rr.com>
	 <20120117095418.GG10397@elte.hu>
	 <1326807145.17534.26.camel@gandalf.stny.rr.com>
	 <20120118120711.GB14863@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-01-18 at 13:07 +0100, Ingo Molnar wrote:

> I'd argue that __raise_softirq_irqoff() should not be inline - 
> that would solve a whole host of issues. Event tracing is 
> enabled in most distros so there's no real overhead argument to 
> be made here either - so it's probably a bit faster in fact to 
> have this uninlined. What do you think?

Sure, I have no problem moving that out of the header. I don't think
raising a softirq is in that critical a path that it can't be a function
call.

There's only one trace/events header left which is in module.h. Perhaps
we can move __module_get() and try_module_get() out of the header. We
could just move the "if" part out.

extern void inc_module(struct module *module, unsigned long ip);

static inline void __module_get(struct module *module)
{
	if (module) {
		preempt_disable();
		inc_module(module, _THIS_IP_);
		preempt_enable();
	}
}

static inline void try_module_get(struct module *module)
{
	int ret = 1;

	if (module) {
		preempt_disable();

		if (likely(module_is_live(module)))
			inc_module(module, _THIS_IP_);
		else
			ret = 0;

		preempt_enable();
	}
	return ret;
}

---

void inc_module(struct module *module, unsigned long ip)
{
	__this_cpu_inc(module->refptr->incs);
	trace_module_get(module, ip);
}


-- Steve


