Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751679Ab1GSPSI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 11:18:08 -0400
Received: from mail.cs.tu-berlin.de ([130.149.17.13]:40474 "EHLO
	mail.cs.tu-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab1GSPSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 11:18:03 -0400
Message-ID: <4E25A01C.70402@cs.tu-berlin.de>
Date: Tue, 19 Jul 2011 17:17:48 +0200
From: =?ISO-8859-1?Q?Jan_Sch=F6nherr?= <schnhrr@cs.tu-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110711 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Paul Turner <pjt@google.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] sched: Enforce order of leaf CFS runqueues
References: <1310986258-29985-1-git-send-email-schnhrr@cs.tu-berlin.de> <1310986258-29985-2-git-send-email-schnhrr@cs.tu-berlin.de> <CAPM31RLqq0hgdhoh3GA-38petKeE1zxcL=uJYba9o3yd+_7jjw@mail.gmail.com>
In-Reply-To: <CAPM31RLqq0hgdhoh3GA-38petKeE1zxcL=uJYba9o3yd+_7jjw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 19.07.2011 01:24, schrieb Paul Turner:
> hmmm, what about something like the below (only boot tested), it
> should make the insert case always safe meaning we don't need to do
> anything funky around delete:

Seems to work, too, with two modifications...


> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index eb98f77..a7e0966 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -143,26 +143,39 @@ static inline struct cfs_rq *cpu_cfs_rq(struct
> cfs_rq *cfs_rq, int this_cpu)
>  	return cfs_rq->tg->cfs_rq[this_cpu];
>  }
>
> -static inline void list_add_leaf_cfs_rq(struct cfs_rq *cfs_rq)
> +/*
> + * rq->leaf_cfs_rq_list has an order constraint that specifies children must
> + * appear before parents.  For the (!on_list) chain starting at cfs_rq this
> + * finds a satisfactory insertion point.  If no ancestor is yet on_list, this
> + * choice is arbitrary.
> + */
> +static inline struct list_head *find_leaf_cfs_rq_insertion(struct
> cfs_rq *cfs_rq)
>  {
> -	if (!cfs_rq->on_list) {
> -		/*
> -		 * Ensure we either appear before our parent (if already
> -		 * enqueued) or force our parent to appear after us when it is
> -		 * enqueued.  The fact that we always enqueue bottom-up
> -		 * reduces this to two cases.
> -		 */
> -		if (cfs_rq->tg->parent &&
> -		    cfs_rq->tg->parent->cfs_rq[cpu_of(rq_of(cfs_rq))]->on_list) {
> -			list_add_rcu(&cfs_rq->leaf_cfs_rq_list,
> -				&rq_of(cfs_rq)->leaf_cfs_rq_list);
> -		} else {
> -			list_add_tail_rcu(&cfs_rq->leaf_cfs_rq_list,
> -				&rq_of(cfs_rq)->leaf_cfs_rq_list);
> -		}
> +	struct sched_entity *se;
> +
> +	se = cfs_rq->tg->se[cpu_of(rq_of(cfs_rq))];
> +	for_each_sched_entity(se)
> +		if (cfs_rq->on_list)
> +			return &cfs_rq->leaf_cfs_rq_list;

Need to use cfs_rq corresponding to current se:

-	for_each_sched_entity(se)
-		if (cfs_rq->on_list)
-			return &cfs_rq->leaf_cfs_rq_list;
+	for_each_sched_entity(se) {
+		struct cfs_rq *se_cfs_rq = cfs_rq_of(se);
+		if (se_cfs_rq->on_list)
+			return &se_cfs_rq->leaf_cfs_rq_list;
+	}

>
> -		cfs_rq->on_list = 1;
> +	return &rq_of(cfs_rq)->leaf_cfs_rq_list;
> +}


And something like the following hack to prevent the removal
of the leaf_insertion_point itself during
	enqueue_entity()
		update_cfs_load()

(Obviously not for production:)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 2df33d4..947257d 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -832,7 +832,7 @@ static void update_cfs_load(struct cfs_rq *cfs_rq, int global_update)
        }

        /* consider updating load contribution on each fold or truncate */
-       if (global_update || cfs_rq->load_period > period
+       if (global_update==1 || cfs_rq->load_period > period
            || !cfs_rq->load_period)
                update_cfs_rq_load_contribution(cfs_rq, global_update);

@@ -847,7 +847,7 @@ static void update_cfs_load(struct cfs_rq *cfs_rq, int global_update)
                cfs_rq->load_avg /= 2;
        }

-       if (!cfs_rq->curr && !cfs_rq->nr_running && !cfs_rq->load_avg)
+       if (!cfs_rq->curr && !cfs_rq->nr_running && !cfs_rq->load_avg && global_update!=2)
                list_del_leaf_cfs_rq(cfs_rq);
 }

@@ -1063,7 +1063,7 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
         * Update run-time statistics of the 'current'.
         */
        update_curr(cfs_rq);
-       update_cfs_load(cfs_rq, 0);
+       update_cfs_load(cfs_rq, 2);
        account_entity_enqueue(cfs_rq, se);
        update_cfs_shares(cfs_rq);


