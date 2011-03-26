Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572Ab1CZS1X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 14:27:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:38330 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535Ab1CZS1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 14:27:21 -0400
Subject: Re: [PATCH,RFC] perf: panic due to inclied cpu context task_ctx
 value
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <20110326173545.GA22919@redhat.com>
References: <20110324164436.GC1930@jolsa.brq.redhat.com>
	 <1301153868.2250.359.camel@laptop> <20110326161346.GA18272@redhat.com>
	 <1301157483.2250.366.camel@laptop> <20110326170922.GA20329@redhat.com>
	 <20110326173545.GA22919@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 26 Mar 2011 19:29:28 +0100
Message-ID: <1301164168.2250.370.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-03-26 at 18:35 +0100, Oleg Nesterov wrote:
> On 03/26, Oleg Nesterov wrote:
> >
> > On 03/26, Peter Zijlstra wrote:
> > >
> > > diff --git a/kernel/perf_event.c b/kernel/perf_event.c
> > > index c75925c..e9e4e35 100644
> > > --- a/kernel/perf_event.c
> > > +++ b/kernel/perf_event.c
> > > @@ -1073,6 +1073,8 @@ event_sched_out(struct perf_event *event,
> > >  	if (!is_software_event(event))
> > >  		cpuctx->active_oncpu--;
> > >  	ctx->nr_active--;
> > > +	if (!ctx->nr_active && cpuctx->task_ctx == ctx)
> > > +		cpuctx->task_ctx = NULL;
> >
> > If we clear cpuctx->task_ctx, we should also clear ctx->is_active.

Right.

> > Otherwise I can't see any problem, but I do not understand this code
> > enough.
> 
> but probably we also need update_context_time().

It looks like event_sched_out() relies on up-to-date ctx->time through
perf_event_time() and most call-paths leading to event_sched_out() do
indeed seem to update the ctx time, all except the move_group branch in
perf_event_open() afaict.

Sadly the reproducer doesn't seem to trigger the issue at all, its still
running on a plain -tip kernel.

