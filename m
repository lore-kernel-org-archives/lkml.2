Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262Ab1AZVlq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 16:41:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45393 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754194Ab1AZVlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 16:41:44 -0500
Date: Wed, 26 Jan 2011 22:33:17 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Alan Stern <stern@rowland.harvard.edu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Prasad <prasad@linux.vnet.ibm.com>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Q: perf_install_in_context/perf_event_enable are racy?
Message-ID: <20110126213317.GA7403@redhat.com>
References: <1295617185.28776.273.camel@laptop> <20110121142616.GA31165@redhat.com> <1295622304.28776.293.camel@laptop> <20110121204014.GA2870@nowhere> <20110124114234.GA12166@redhat.com> <20110126175322.GA28617@redhat.com> <20110126184957.GA32578@redhat.com> <1296068731.15234.6.camel@laptop> <1296070383.15234.10.camel@laptop> <20110126211931.GA6778@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110126211931.GA6778@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26, Oleg Nesterov wrote:
>
> > +void task_function_trampoline(void *data)
> > +{
> > +	struct task_function_call *tfc = data;
> > +
> > +	if (this_rq()->curr != tfc->p)
> > +		return;
>
> Yes, I was thinking about checking rq->curr too, but this doesn't
> really help. This closes the race with "prev", but we have the similar
> race with "next".
>
> __perf_install_in_context() should not set ->task_ctx before next
> does perf_event_context_sched_in(). Otherwise it will do nothing,
> it checks cpuctx->task_ctx == ctx.

But of course, we can add rq->in_context_switch or something. This
is more or less equal to Frederic's per-cpu task_events_schedulable
but simpler, because this doesn't depend on perf_task_events.

This is what I had in mind initially but I didn't dare to add the
new member into rq, it is only needed for perf.

Oleg.

