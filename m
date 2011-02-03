Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932106Ab1BCM5t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 07:57:49 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:41488 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756350Ab1BCM5r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 07:57:47 -0500
Subject: Re: [PATCH -v8a 3/7] sched: use a buddy to implement
 yield_task_fair
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Rik van Riel <riel@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>,
        "Nakajima, Jun" <jun.nakajima@intel.com>
In-Reply-To: <20110201095103.3a79e92a@annuminas.surriel.com>
References: <20110201094433.72829892@annuminas.surriel.com>
	 <20110201095103.3a79e92a@annuminas.surriel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 03 Feb 2011 13:58:34 +0100
Message-ID: <1296737914.26581.365.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-01 at 09:51 -0500, Rik van Riel wrote:
> -static void yield_task_fair(struct rq *rq)
> -{
> -       struct task_struct *curr = rq->curr;
> -       struct cfs_rq *cfs_rq = task_cfs_rq(curr);
> -       struct sched_entity *rightmost, *se = &curr->se;
> -
> -       /*
> -        * Are we the only task in the tree?
> -        */
> -       if (unlikely(rq->nr_running == 1))
> -               return;
> -
> -       clear_buddies(cfs_rq, se);
> -
> -       if (likely(!sysctl_sched_compat_yield) && curr->policy != SCHED_BATCH) {
> -               update_rq_clock(rq);
> -               /*
> -                * Update run-time statistics of the 'current'.
> -                */
> -               update_curr(cfs_rq);
> -
> -               return;
> -       }
> -       /*
> -        * Find the rightmost entry in the rbtree:
> -        */
> -       rightmost = __pick_last_entity(cfs_rq);
> -       /*
> -        * Already in the rightmost position?
> -        */
> -       if (unlikely(!rightmost || entity_before(rightmost, se)))
> -               return;
> -
> -       /*
> -        * Minimally necessary key value to be last in the tree:
> -        * Upon rescheduling, sched_class::put_prev_task() will place
> -        * 'current' within the tree based on its new key value.
> -        */
> -       se->vruntime = rightmost->vruntime + 1;
> -} 


This also wants the below bit in order to build without warnings for
SCHED_DEBUG=n:


---
Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -431,6 +431,7 @@ static struct sched_entity *__pick_next_
 	return rb_entry(next, struct sched_entity, run_node);
 }
 
+#ifdef CONFIG_SCHED_DEBUG
 static struct sched_entity *__pick_last_entity(struct cfs_rq *cfs_rq)
 {
 	struct rb_node *last = rb_last(&cfs_rq->tasks_timeline);
@@ -445,7 +446,6 @@ static struct sched_entity *__pick_last_
  * Scheduling class statistics methods:
  */
 
-#ifdef CONFIG_SCHED_DEBUG
 int sched_proc_update_handler(struct ctl_table *table, int write,
 		void __user *buffer, size_t *lenp,
 		loff_t *ppos)

