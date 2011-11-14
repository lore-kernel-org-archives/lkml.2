Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918Ab1KNMCR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 07:02:17 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54136 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab1KNMCR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 07:02:17 -0500
Subject: Re: [patch 3/3] From: Ben Segall <bsegall@google.com>
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Ben Segall <bsegall@google.com>
Date: Mon, 14 Nov 2011 13:01:56 +0100
In-Reply-To: <4EBB3742.7060404@google.com>
References: <20111108042632.977080206@google.com>
	 <20111108042736.683407863@google.com> <4EBB3742.7060404@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1321272116.1421.11.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-09 at 18:30 -0800, Paul Turner wrote:
> 
> sched: update task accounting on throttle so that idle_balance() will trigger
> From: Ben Segall <bsegall@google.com>
> 
> Since throttling occurs in the put_prev_task() path we do not get to observe
> this delta against nr_running when making the decision to idle_balance().
> 
> Fix this by first enumerating cfs_rq throttle states so that we can distinguish
> throttling cfs_rqs.  Then remove tasks that will be throttled in put_prev_task
> from rq->nr_running/cfs_rq->h_nr_running when in account_cfs_rq_runtime,
> rather than delaying until put_prev_task.
> 
> This allows schedule() to call idle_balance when we go idle due to throttling.
> 
> Using Kamalesh's nested-cgroup test case[1] we see the following improvement on
> a 16 core system:
> baseline: Average CPU Idle percentage 13.9667%
>    +patch: Average CPU Idle percentage 3.53333%
> [1]: https://lkml.org/lkml/2011/9/15/261
> 
> Signed-off-by: Ben Segall <bsegall@google.com>
> Signed-off-by: Paul Turner <pjt@google.com>

I really don't like this patch... There's something wrong about
decoupling the dequeue from nr_running accounting.

That said, I haven't got a bright idea either.. anyway, I think the
patch is somewhat too big for 3.2 at this point.

> ---
>   kernel/sched.c      |   24 ++++++++----
>   kernel/sched_fair.c |  101 ++++++++++++++++++++++++++++++++++++----------------
>   2 files changed, 87 insertions(+), 38 deletions(-)
> 
> Index: tip/kernel/sched.c
> ===================================================================
> --- tip.orig/kernel/sched.c
> +++ tip/kernel/sched.c
> @@ -269,6 +269,13 @@ struct cfs_bandwidth {
>   #endif
>   };
> 
> +enum runtime_state {
> +       RUNTIME_UNLIMITED,
> +       RUNTIME_AVAILABLE,
> +       RUNTIME_THROTTLING,
> +       RUNTIME_THROTTLED
> +};

What's the difference between throttling and throttled? Throttling is
between actually getting throttled and put_prev_task() getting called?
This all wants a comment.

> +static void account_nr_throttling(struct cfs_rq *cfs_rq, long nr_throttling)
> +{
> +       struct sched_entity *se;
> +
> +       se = cfs_rq->tg->se[cpu_of(rq_of(cfs_rq))];
> +
> +       for_each_sched_entity(se) {
> +               struct cfs_rq *qcfs_rq = cfs_rq_of(se);
> +               if (!se->on_rq)
> +                       break;
> +
> +               qcfs_rq->h_nr_running -= nr_throttling;
> +
> +               if (qcfs_rq->runtime_state == RUNTIME_THROTTLING)
> +                       break;
> +       }
> +
> +       if (!se)
> +               rq_of(cfs_rq)->nr_running -= nr_throttling;
> +}

Since you'll end up calling this stuff with a negative nr_throttling,
please use += to avoid the double negative brain twist.

>   static void __account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
>                                      unsigned long delta_exec)
>   {
> @@ -1401,14 +1422,33 @@ static void __account_cfs_rq_runtime(str
>          * if we're unable to extend our runtime we resched so that the active
>          * hierarchy can be throttled
>          */
> -       if (!assign_cfs_rq_runtime(cfs_rq) && likely(cfs_rq->curr))
> -               resched_task(rq_of(cfs_rq)->curr);
> +       if (assign_cfs_rq_runtime(cfs_rq))
> +               return;
> +
> +       if (unlikely(!cfs_rq->curr) || throttled_hierarchy(cfs_rq) ||
> +          cfs_rq->runtime_state == RUNTIME_THROTTLING)
> +               return;

How exactly can we get here if we're throttling already?

> +       resched_task(rq_of(cfs_rq)->curr);
> +
> +       /*
> +       * Remove us from nr_running/h_nr_running so
> +       * that idle_balance gets called if necessary
> +       */
> +       account_nr_throttling(cfs_rq, cfs_rq->h_nr_running);
> +       cfs_rq->runtime_state = RUNTIME_THROTTLING;
> +}

> @@ -1416,7 +1456,9 @@ static __always_inline void account_cfs_
> 
>   static inline int cfs_rq_throttled(struct cfs_rq *cfs_rq)
>   {
> -       return cfs_bandwidth_used() && cfs_rq->throttled;
> +       return cfs_bandwidth_used() &&
> +               (cfs_rq->runtime_state == RUNTIME_THROTTLED ||
> +                cfs_rq->runtime_state == RUNTIME_THROTTLING);
>   }

>= THROTTLING saves a test.


