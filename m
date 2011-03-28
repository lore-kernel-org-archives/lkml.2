Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538Ab1C1O6Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 10:58:24 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45173 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750Ab1C1O6X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 10:58:23 -0400
Subject: Re: [PATCH,RFC] perf: panic due to inclied cpu context task_ctx
 value
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <20110328133033.GA8254@redhat.com>
References: <20110324164436.GC1930@jolsa.brq.redhat.com>
	 <1301153868.2250.359.camel@laptop> <20110326161346.GA18272@redhat.com>
	 <1301157483.2250.366.camel@laptop> <20110326170922.GA20329@redhat.com>
	 <20110326173545.GA22919@redhat.com> <1301164168.2250.370.camel@laptop>
	 <20110328133033.GA8254@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 28 Mar 2011 16:57:55 +0200
Message-ID: <1301324275.4859.25.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-03-28 at 15:30 +0200, Oleg Nesterov wrote:
> On 03/26, Peter Zijlstra wrote:
> >
> > On Sat, 2011-03-26 at 18:35 +0100, Oleg Nesterov wrote:
> > > On 03/26, Oleg Nesterov wrote:
> > > >
> > > > On 03/26, Peter Zijlstra wrote:
> > > > >
> > > > > diff --git a/kernel/perf_event.c b/kernel/perf_event.c
> > > > > index c75925c..e9e4e35 100644
> > > > > --- a/kernel/perf_event.c
> > > > > +++ b/kernel/perf_event.c
> > > > > @@ -1073,6 +1073,8 @@ event_sched_out(struct perf_event *event,
> > > > >  	if (!is_software_event(event))
> > > > >  		cpuctx->active_oncpu--;
> > > > >  	ctx->nr_active--;
> > > > > +	if (!ctx->nr_active && cpuctx->task_ctx == ctx)
> > > > > +		cpuctx->task_ctx = NULL;
> > > >
> > > > If we clear cpuctx->task_ctx, we should also clear ctx->is_active.
> >
> > Right.
> 
> Wait... Yes, we have to clear ctx->is_active, otherwise we break, say,
> perf_install_in_context().
> 
> But if we clear ->is_active we break perf_event_enable(). Suppose we
> are doing ioctl(PERF_EVENT_IOC_DISABLE) + ioctl(PERF_EVENT_IOC_ENABLE).
> PERF_EVENT_IOC_DISABLE can sched_out the last event, but _IOC_ENABLE
> treats ctx->is_active == F as "it is not running".

Right, same for the tick, if say we can only schedule 1 event at a time
and we close the 1 event that is active, the tick will not rotate a new
event in.

/me goes ponder things..

> Btw, why ctx_sched_out() checks nr_events under perf_pmu_disable() ?

hysterical-raisins or somesuch, how about the below:

---
Subject: perf: Optimize ctx_sched_out
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon Mar 28 16:55:36 CEST 2011

Oleg noted that ctx_sched_out() disables the PMU even though it might
not actually do something, avoid needless PMU-disabling.

Reported-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
---
 kernel/perf_event.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -1767,7 +1767,6 @@ static void ctx_sched_out(struct perf_ev
 	struct perf_event *event;
 
 	raw_spin_lock(&ctx->lock);
-	perf_pmu_disable(ctx->pmu);
 	ctx->is_active = 0;
 	if (likely(!ctx->nr_events))
 		goto out;
@@ -1777,6 +1776,7 @@ static void ctx_sched_out(struct perf_ev
 	if (!ctx->nr_active)
 		goto out;
 
+	perf_pmu_disable(ctx->pmu);
 	if (event_type & EVENT_PINNED) {
 		list_for_each_entry(event, &ctx->pinned_groups, group_entry)
 			group_sched_out(event, cpuctx, ctx);
@@ -1786,8 +1786,8 @@ static void ctx_sched_out(struct perf_ev
 		list_for_each_entry(event, &ctx->flexible_groups, group_entry)
 			group_sched_out(event, cpuctx, ctx);
 	}
-out:
 	perf_pmu_enable(ctx->pmu);
+out:
 	raw_spin_unlock(&ctx->lock);
 }
 

