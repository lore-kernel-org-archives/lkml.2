Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895Ab1C1PBP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 11:01:15 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41026 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205Ab1C1PBO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 11:01:14 -0400
Subject: Re: [PATCH,RFC] perf: panic due to inclied cpu context task_ctx
 value
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <1301324275.4859.25.camel@twins>
References: <20110324164436.GC1930@jolsa.brq.redhat.com>
	 <1301153868.2250.359.camel@laptop> <20110326161346.GA18272@redhat.com>
	 <1301157483.2250.366.camel@laptop> <20110326170922.GA20329@redhat.com>
	 <20110326173545.GA22919@redhat.com> <1301164168.2250.370.camel@laptop>
	 <20110328133033.GA8254@redhat.com>  <1301324275.4859.25.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 28 Mar 2011 17:00:49 +0200
Message-ID: <1301324449.4859.26.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-03-28 at 16:57 +0200, Peter Zijlstra wrote:
> 
> ---
> Subject: perf: Optimize ctx_sched_out
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Mon Mar 28 16:55:36 CEST 2011
> 
> Oleg noted that ctx_sched_out() disables the PMU even though it might
> not actually do something, avoid needless PMU-disabling.
> 
> Reported-by: Oleg Nesterov <oleg@redhat.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> LKML-Reference: <new-submission>
> ---
>  kernel/perf_event.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/kernel/perf_event.c
> ===================================================================
> --- linux-2.6.orig/kernel/perf_event.c
> +++ linux-2.6/kernel/perf_event.c
> @@ -1767,7 +1767,6 @@ static void ctx_sched_out(struct perf_ev
>         struct perf_event *event;
>  
>         raw_spin_lock(&ctx->lock);
> -       perf_pmu_disable(ctx->pmu);
>         ctx->is_active = 0;
>         if (likely(!ctx->nr_events))
>                 goto out;
> @@ -1777,6 +1776,7 @@ static void ctx_sched_out(struct perf_ev
>         if (!ctx->nr_active)
>                 goto out;
>  
> +       perf_pmu_disable(ctx->pmu);
>         if (event_type & EVENT_PINNED) {
>                 list_for_each_entry(event, &ctx->pinned_groups, group_entry)
>                         group_sched_out(event, cpuctx, ctx);
> @@ -1786,8 +1786,8 @@ static void ctx_sched_out(struct perf_ev
>                 list_for_each_entry(event, &ctx->flexible_groups, group_entry)
>                         group_sched_out(event, cpuctx, ctx);
>         }
> -out:
>         perf_pmu_enable(ctx->pmu);
> +out:
>         raw_spin_unlock(&ctx->lock);
>  }

We could probably remove the PMU disabling all together, but that would
involve like actual thinking :-)
