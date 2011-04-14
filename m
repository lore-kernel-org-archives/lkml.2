Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758766Ab1DNKri (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 06:47:38 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39989 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758747Ab1DNKrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 06:47:36 -0400
Subject: Re: [PATCH 2/2] sched: next buddy hint on sleep and preempt path
 -v2
From: Peter Zijlstra <peterz@infradead.org>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Paul Turner <pjt@google.com>, Mike Galbraith <efault@gmx.de>,
        Rik van Riel <riel@redhat.com>
In-Reply-To: <1302744070-30079-3-git-send-email-venki@google.com>
References: <AANLkTi=ao5dci3gb=+UmegZx_ag_X6gAFZ5mBb+8=9hR@mail.gmail.com>
	 <1302744070-30079-3-git-send-email-venki@google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Apr 2011 12:50:02 +0200
Message-ID: <1302778202.2035.23.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-13 at 18:21 -0700, Venkatesh Pallipadi wrote:
> ---
>  kernel/sched_fair.c |   26 +++++++++++++++++++++++---
>  1 files changed, 23 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index d3513b7..8828a7e 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -1340,6 +1340,8 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
>         hrtick_update(rq);
>  }
>  
> +static void set_next_buddy(struct sched_entity *se);
> +
>  /*
>   * The dequeue_task method is called before nr_running is
>   * decreased. We remove the task from the rbtree and
> @@ -1349,14 +1351,22 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
>  {
>         struct cfs_rq *cfs_rq;
>         struct sched_entity *se = &p->se;
> +       int task_sleep = flags & DEQUEUE_SLEEP;
>  
>         for_each_sched_entity(se) {
>                 cfs_rq = cfs_rq_of(se);
>                 dequeue_entity(cfs_rq, se, flags);
>  
>                 /* Don't dequeue parent if it has other entities besides us */
> -               if (cfs_rq->load.weight)
> +               if (cfs_rq->load.weight) {
> +                       /*
> +                        * Bias pick_next to pick a task from this cfs_rq, as
> +                        * p is sleeping when it is within its sched_slice.
> +                        */
> +                       if (task_sleep && se->parent)
> +                               set_next_buddy(se->parent);
>                         break;
> +               }
>                 flags |= DEQUEUE_SLEEP;
>         }
>  

You made my compiler sad:

In file included from /home/root/src/linux-2.6/kernel/sched.c:2006:
/home/root/src/linux-2.6/kernel/sched_fair.c: In function ‘dequeue_task_fair’:
/home/root/src/linux-2.6/kernel/sched_fair.c:1370: error: ‘struct sched_entity’ has no member named ‘parent’
/home/root/src/linux-2.6/kernel/sched_fair.c:1371: error: ‘struct sched_entity’ has no member named ‘parent’


