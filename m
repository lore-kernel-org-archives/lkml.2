Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758812Ab0FJLBo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 07:01:44 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35747 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754016Ab0FJLBn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 07:01:43 -0400
Subject: Re: [PATCH 4/5] perf: Introduce task, softirq and hardirq contexts
 exclusion
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Stephane Eranian <eranian@google.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <1276141760-11590-5-git-send-regression-fweisbec@gmail.com>
References: <1276141760-11590-1-git-send-regression-fweisbec@gmail.com>
	 <1276141760-11590-5-git-send-regression-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 10 Jun 2010 13:01:27 +0200
Message-ID: <1276167687.2077.120.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-10 at 05:49 +0200, Frederic Weisbecker wrote:
> @@ -642,17 +643,31 @@ event_sched_in(struct perf_event *event,
>         if (event->state <= PERF_EVENT_STATE_OFF)
>                 return 0;
>  
> -       event->state = PERF_EVENT_STATE_ACTIVE;
> +       if (event->attr.exclude_task)
> +               event->state = PERF_EVENT_STATE_PAUSED;
> +       else
> +               event->state = PERF_EVENT_STATE_ACTIVE;
> +
>         event->oncpu = smp_processor_id();
> +

Aah, so that is why you added the PAUSE state knowledge to the arch
code, you want to be able to call ->enable() on a PAUSEd event.

That means you need to audit/touch all implementations anyway, isn't
there a better interface we can use, like maybe extend ->enable() with a
flags argument?

>         /*
>          * The new state must be visible before we turn it on in the hardware:
>          */
>         smp_wmb();
>  
> -       if (event->pmu->enable(event)) {
> -               event->state = PERF_EVENT_STATE_INACTIVE;
> -               event->oncpu = -1;
> -               return -EAGAIN;
> +       /*
> +        * If we exclude the tasks, we only need to schedule hardware
> +        * events that need to settle themselves, even in a pause mode.
> +        * Software events can simply be scheduled anytime.
> +        * If we want more granularity in all that, we can still provide
> +        * later a pmu->reserve callback.
> +        */
> +       if (!event->attr.exclude_task || !is_software_event(event)) {
> +               if (event->pmu->enable(event)) {
> +                       event->state = PERF_EVENT_STATE_INACTIVE;
> +                       event->oncpu = -1;
> +                       return -EAGAIN;
> +               }
>         }
>  
>         event->tstamp_running += ctx->time - event->tstamp_stopped; 

Remove is_software_event(), not add more.
