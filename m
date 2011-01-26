Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126Ab1AZV1c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 16:27:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48460 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753292Ab1AZV1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 16:27:31 -0500
Date: Wed, 26 Jan 2011 22:19:31 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Alan Stern <stern@rowland.harvard.edu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Prasad <prasad@linux.vnet.ibm.com>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Q: perf_install_in_context/perf_event_enable are racy?
Message-ID: <20110126211931.GA6778@redhat.com>
References: <20110121130323.GA12900@elte.hu> <1295617185.28776.273.camel@laptop> <20110121142616.GA31165@redhat.com> <1295622304.28776.293.camel@laptop> <20110121204014.GA2870@nowhere> <20110124114234.GA12166@redhat.com> <20110126175322.GA28617@redhat.com> <20110126184957.GA32578@redhat.com> <1296068731.15234.6.camel@laptop> <1296070383.15234.10.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296070383.15234.10.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26, Peter Zijlstra wrote:
>
> On Wed, 2011-01-26 at 20:05 +0100, Peter Zijlstra wrote:
> > On Wed, 2011-01-26 at 19:49 +0100, Oleg Nesterov wrote:
> > > On 01/26, Oleg Nesterov wrote:
> > > >
> > > > Please see the untested patch below. It doesn't change perf_event_enable(),
> > > > only perf_install_in_context().
> > >
> > > Forgot to mention... Also, it doesn't try to fix the race with do_exit(),
> > > this needs another change.
> > >
> > > And, damn, can't resist. This is mostly cosmetic issue, but I feel
> > > discomfort every time I look at task_oncpu_function_call(). It _looks_
> > > obviously wrong, even if the problem doesn't exist in practice. I'll
> > > send the pedantic fix to keep the maintainers busy ;)
> >
> > I've been trying to sit down and work my way through it today, your last
> > suggestion very nearly seemed to make sense, but I kept getting
> > distracted.
> >
> > FWIW I think perf_event_enable() has the very same issue...

Yes, yes, note the "doesn't change perf_event_enable()" above.

In fact, I _suspect_ perf_event_enable() has more problems, but
I need to recheck.

> +void task_function_trampoline(void *data)
> +{
> +	struct task_function_call *tfc = data;
> +
> +	if (this_rq()->curr != tfc->p)
> +		return;

Yes, I was thinking about checking rq->curr too, but this doesn't
really help. This closes the race with "prev", but we have the similar
race with "next".

__perf_install_in_context() should not set ->task_ctx before next
does perf_event_context_sched_in(). Otherwise it will do nothing,
it checks cpuctx->task_ctx == ctx.

Oleg.

