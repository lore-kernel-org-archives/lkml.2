Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093Ab0LPLEn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 06:04:43 -0500
Received: from canuck.infradead.org ([134.117.69.58]:51011 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754699Ab0LPLEj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 06:04:39 -0500
Subject: Re: [patch 2/2] sched: charge unaccounted run-time on entity
 re-weight
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20101216031038.159704378@google.com>
References: <20101216031016.186364650@google.com>
	 <20101216031038.159704378@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 16 Dec 2010 12:03:44 +0100
Message-ID: <1292497424.6803.4573.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-15 at 19:10 -0800, Paul Turner wrote:
> plain text document attachment (update_on_reweight.patch)
> Mike Galbraith reported poor interactivity[*] when the new shares distribution 
> code was combined with autogroups.
> 
> The root cause turns out to be a mis-ordering of accounting accrued execution
> time and shares updates.  Since update_curr() is issued hierarchically,
> updating the parent entity weights to reflect child enqueue/dequeue results in
> the parent's unaccounted execution time then being accrued (vs vruntime) at the
> new weight as opposed to the weight present at accumulation.
> 
> While this doesn't have much effect on processes with timeslices that cross a
> tick, it is particularly problematic for an interactive process (e.g. Xorg)
> which incurs many (tiny) timeslices.  In this scenario almost all updates are
> at dequeue which can result in significant fairness perturbation (especially if
> it is the only thread, resulting in potential {tg->shares, MIN_SHARES}
> transitions).
> 
> Correct this by ensuring unaccounted time is accumulated prior to manipulating
> an entity's weight.
> 
> [*] http://xkcd.com/619/ is perversely Nostradamian here.
> 
> Signed-off-by: Paul Turner <pjt@google.com>
> 
> ---
>  kernel/sched_fair.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> Index: tip3/kernel/sched_fair.c
> ===================================================================
> --- tip3.orig/kernel/sched_fair.c
> +++ tip3/kernel/sched_fair.c
> @@ -767,8 +767,12 @@ static void update_cfs_load(struct cfs_r
>  static void reweight_entity(struct cfs_rq *cfs_rq, struct sched_entity *se,
>  			    unsigned long weight)
>  {
> -	if (se->on_rq)
> +	if (se->on_rq) {
> +		/* commit outstanding execution time */
> +		if (cfs_rq->curr == se)
> +			update_curr(cfs_rq);
>  		account_entity_dequeue(cfs_rq, se);
> +	}
>  
>  	update_load_set(&se->load, weight);
>  

Hrmm,. so we have:

entity_tick()
  update_curr()
  update_entity_shares_tick()
    update_cfs_shares()
      reweight_entity()


{en,de}queue_entity()
  update_curr()
  update_cfs_shares()
    reweight_entity()

{en,de}queue_task_fair()
  update_cfs_shares() (the other branch)

update_shares_cpu()
  update_cfs_shares()

So wouldn't something like the below be nicer?

---

Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -1249,6 +1249,7 @@ enqueue_task_fair(struct rq *rq, struct
 	for_each_sched_entity(se) {
 		struct cfs_rq *cfs_rq = cfs_rq_of(se);
 
+		update_curr(cfs_rq);
 		update_cfs_load(cfs_rq, 0);
 		update_cfs_shares(cfs_rq, 0);
 	}
@@ -1279,6 +1280,7 @@ static void dequeue_task_fair(struct rq
 	for_each_sched_entity(se) {
 		struct cfs_rq *cfs_rq = cfs_rq_of(se);
 
+		update_curr(cfs_rq);
 		update_cfs_load(cfs_rq, 0);
 		update_cfs_shares(cfs_rq, 0);
 	}
@@ -2085,6 +2087,7 @@ static int update_shares_cpu(struct task
 	raw_spin_lock_irqsave(&rq->lock, flags);
 
 	update_rq_clock(rq);
+	update_curr(cfs_rq);
 	update_cfs_load(cfs_rq, 1);
 
 	/*


