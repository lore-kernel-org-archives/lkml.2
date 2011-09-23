Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399Ab1IWLTO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 07:19:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:38905 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170Ab1IWLTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 07:19:12 -0400
X-Authority-Analysis: v=1.1 cv=agqPq5NoKwAPC9P66H7dbYUCjxvmT73as08i4x3aqAA= c=1 sm=0 a=pPwHPQqvJkcA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=meVymXHHAAAA:8 a=VwQbUJbxAAAA:8 a=NKZoUttrmXKZofYut5QA:9 a=PUjeQqilurYA:10 a=U62fhAwekXMA:10 a=jeBq3FmKZ4MA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: Re: [PATCH 19/21] tracing: Account for preempt off in
 preempt_schedule()
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1316775648.9084.1.camel@twins>
References: <20110922220935.537134016@goodmis.org>
	 <20110922221029.678324653@goodmis.org>  <1316775648.9084.1.camel@twins>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 23 Sep 2011 07:19:09 -0400
Message-ID: <1316776749.29966.156.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-23 at 13:00 +0200, Peter Zijlstra wrote:
>  
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > ---
> >  kernel/sched.c |    9 +++++++++
> >  1 files changed, 9 insertions(+), 0 deletions(-)
> > 
> > diff --git a/kernel/sched.c b/kernel/sched.c
> > index ccacdbd..4b096cc 100644
> > --- a/kernel/sched.c
> > +++ b/kernel/sched.c
> > @@ -4435,7 +4435,16 @@ asmlinkage void __sched notrace preempt_schedule(void)
> >  
> >  	do {
> >  		add_preempt_count_notrace(PREEMPT_ACTIVE);
> > +		/*
> > +		 * The add/subtract must not be traced by the function
> > +		 * tracer. But we still want to account for the
> > +		 * preempt off latency tracer. Since the _notrace versions
> > +		 * of add/subtract skip the accounting for latency tracer
> > +		 * we must force it manually.
> > +		 */
> > +		start_critical_timings();
> >  		schedule();
> > +		stop_critical_timings();
> >  		sub_preempt_count_notrace(PREEMPT_ACTIVE);
> >  
> >  		/*
> 
> This won't apply, you're patching ancient code.

Yes, that's the way git usually works. I could start a new branch for
this. But since we are not doing many pulls while kernel.org is down, my
kernel base has become a bit out of date. I thought that's the way Linus
wants it. I'm sure this would apply with a trivial merge fixup.

But if you want to take this patch, then I could rebase my tree and take
it out.

> 
> Anyway, this all stinks, and reading the changelog of
> d1f74e20b5b064a130cd0743a256c2d3cfe84010 and the above just makes me
> confused.
> 

What would you suggest? Just ignore the latencies that schedule
produces, even though its been one of the top causes of latencies?

-- Steve


