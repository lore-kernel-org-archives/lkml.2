Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751345Ab0IFN62 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 09:58:28 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43607 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750840Ab0IFN6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 09:58:22 -0400
Date: Mon, 6 Sep 2010 15:54:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@kernel.org>
Cc: Avi Kivity <avi@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
        Tom Zanussi <tzanussi@gmail.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-perf-users@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: disabling group leader perf_event
Message-ID: <20100906135456.GA29291@elte.hu>
References: <4C84B088.5050003@redhat.com>
 <1283772256.1930.303.camel@laptop>
 <4C84D1CE.3070205@redhat.com>
 <1283774045.1930.341.camel@laptop>
 <4C84D77B.6040600@redhat.com>
 <20100906124330.GA22314@elte.hu>
 <4C84E265.1020402@redhat.com>
 <20100906125905.GA25414@elte.hu>
 <AANLkTin8Ggcu=PYhfNbjFwSkL3=UZL40UQH+1WD5Hz6p@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTin8Ggcu=PYhfNbjFwSkL3=UZL40UQH+1WD5Hz6p@mail.gmail.com>
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


* Pekka Enberg <penberg@kernel.org> wrote:

> On 09/06/2010 03:43 PM, Ingo Molnar wrote:
> >> > Yes. The filter engine is a safe, in-kernel interpreted language in
> >> > the making. The C syntax was chosen because it's close to the heart
> >> > of every kernel developer.
> >> >
> * Avi Kivity <avi@redhat.com> wrote:
> >> > It might make sense to bring this concept a few steps further. Looks
> >> > rather complex but also rather cool ...
> >>
> >> Is this a roundabout way of saying "jit"?
> 
> On Mon, Sep 6, 2010 at 3:59 PM, Ingo Molnar <mingo@elte.hu> wrote:
> > Partly. I'm not sure we want to actually upload programs in bytecode
> > form. ASCII is just fine - just like a .gz Javascript is fine for web
> > apps. (and in most cases compresses down better than the bytecode
> > equivalent)
> >
> > So a clear language (the simpler initially the better) plus an in-kernel
> > compiler.
> >
> > This could be used for far more than just instrumentation: IMO security
> > policies could be expressed in such a way. (Simplified, they are quite
> > similar to filters installed on syscall entry/exit, with the ability of
> > the filter to influence whether the syscall is performed.)
> 
> Filter engine? I've never heard of it before. Where does it live?

It's in kernel/trace/trace_events_filter.c, and currently bound to trace 
events - but that is just an implementational detail really.

It allows us to do things like:

   perf record -a -g -e sched:sched_switch \
              --filter "prev_pid == 0 && prev_prio == 120" sleep 10

This profiles context switches that go into the idle task from 
SCHED_NORMAL tasks (and excludes all other types of context switches). 
I.e. this counts 'go idle' events and excludes all other types of 
context switches.

You can also see/use it via /debug/tracing/events/*/*/filter. Allowed 
fields are those that are named in /debug/tracing/events/*/*/format.

Thanks,

	Ingo
