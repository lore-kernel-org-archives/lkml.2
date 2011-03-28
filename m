Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814Ab1C1Q2N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 12:28:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:49106 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145Ab1C1Q2L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 12:28:11 -0400
Subject: Re: [PATCH,RFC] perf: panic due to inclied cpu context task_ctx
 value
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <20110328151511.GA3608@redhat.com>
References: <20110324164436.GC1930@jolsa.brq.redhat.com>
	 <1301153868.2250.359.camel@laptop> <20110326161346.GA18272@redhat.com>
	 <1301157483.2250.366.camel@laptop> <20110326170922.GA20329@redhat.com>
	 <20110326173545.GA22919@redhat.com> <1301164168.2250.370.camel@laptop>
	 <20110328133033.GA8254@redhat.com> <1301324275.4859.25.camel@twins>
	 <20110328151511.GA3608@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 28 Mar 2011 18:27:43 +0200
Message-ID: <1301329663.4859.32.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-03-28 at 17:15 +0200, Oleg Nesterov wrote:
> On 03/28, Peter Zijlstra wrote:
> >
> > --- linux-2.6.orig/kernel/perf_event.c
> > +++ linux-2.6/kernel/perf_event.c
> > @@ -1767,7 +1767,6 @@ static void ctx_sched_out(struct perf_ev
> >  	struct perf_event *event;
> >
> >  	raw_spin_lock(&ctx->lock);
> > -	perf_pmu_disable(ctx->pmu);
> >  	ctx->is_active = 0;
> >  	if (likely(!ctx->nr_events))
> >  		goto out;
> > @@ -1777,6 +1776,7 @@ static void ctx_sched_out(struct perf_ev
> >  	if (!ctx->nr_active)
> >  		goto out;
> >
> > +	perf_pmu_disable(ctx->pmu);
> >  	if (event_type & EVENT_PINNED) {
> >  		list_for_each_entry(event, &ctx->pinned_groups, group_entry)
> >  			group_sched_out(event, cpuctx, ctx);
> > @@ -1786,8 +1786,8 @@ static void ctx_sched_out(struct perf_ev
> >  		list_for_each_entry(event, &ctx->flexible_groups, group_entry)
> >  			group_sched_out(event, cpuctx, ctx);
> >  	}
> > -out:
> >  	perf_pmu_enable(ctx->pmu);
> > +out:
> >  	raw_spin_unlock(&ctx->lock);
> 
> Yes, thanks.
> 
> Probably this doesn't matter from the perfomance pov, but imho this
> makes the code more understandable. This is important for occasional
> readers like me ;)

Could actually save quite a lot of cycles, pmu-disable/enable can be
very expensive on some hardware.

> Could you answer another question? It is not immediately clear why
> ctx_sched_in() does not check nr_active != 0 before doing
> ctx_XXX_sched_in(). I guess, the only reason is perf_rotate_context()
> and the similar logic in perf_event_context_sched_in(). If we are
> doing, say, cpu_ctx_sched_out(FLEXIBLE) + cpu_ctx_sched_in(FLEXIBLE)
> then ->nr_active can be zero after cpu_ctx_sched_out().
> 
> Is my understanding correct? Or is there another reason?

nr_active counts the number of events that have been scheduled in, so
its perfectly fine to have either nr_active or !nr_active at that
point. 
