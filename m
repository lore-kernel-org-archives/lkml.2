Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509Ab1C1Ojt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 10:39:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22136 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754084Ab1C1Ojr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 10:39:47 -0400
Date: Mon, 28 Mar 2011 15:30:33 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH,RFC] perf: panic due to inclied cpu context task_ctx
	value
Message-ID: <20110328133033.GA8254@redhat.com>
References: <20110324164436.GC1930@jolsa.brq.redhat.com> <1301153868.2250.359.camel@laptop> <20110326161346.GA18272@redhat.com> <1301157483.2250.366.camel@laptop> <20110326170922.GA20329@redhat.com> <20110326173545.GA22919@redhat.com> <1301164168.2250.370.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301164168.2250.370.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26, Peter Zijlstra wrote:
>
> On Sat, 2011-03-26 at 18:35 +0100, Oleg Nesterov wrote:
> > On 03/26, Oleg Nesterov wrote:
> > >
> > > On 03/26, Peter Zijlstra wrote:
> > > >
> > > > diff --git a/kernel/perf_event.c b/kernel/perf_event.c
> > > > index c75925c..e9e4e35 100644
> > > > --- a/kernel/perf_event.c
> > > > +++ b/kernel/perf_event.c
> > > > @@ -1073,6 +1073,8 @@ event_sched_out(struct perf_event *event,
> > > >  	if (!is_software_event(event))
> > > >  		cpuctx->active_oncpu--;
> > > >  	ctx->nr_active--;
> > > > +	if (!ctx->nr_active && cpuctx->task_ctx == ctx)
> > > > +		cpuctx->task_ctx = NULL;
> > >
> > > If we clear cpuctx->task_ctx, we should also clear ctx->is_active.
>
> Right.

Wait... Yes, we have to clear ctx->is_active, otherwise we break, say,
perf_install_in_context().

But if we clear ->is_active we break perf_event_enable(). Suppose we
are doing ioctl(PERF_EVENT_IOC_DISABLE) + ioctl(PERF_EVENT_IOC_ENABLE).
PERF_EVENT_IOC_DISABLE can sched_out the last event, but _IOC_ENABLE
treats ctx->is_active == F as "it is not running".


Btw, why ctx_sched_out() checks nr_events under perf_pmu_disable() ?

Oleg.

