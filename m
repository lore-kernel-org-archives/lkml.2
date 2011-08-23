Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755781Ab1HWSyE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 14:54:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:48621 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754392Ab1HWSx7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 14:53:59 -0400
Subject: Re: [PATCH v3 2/2] sched: Handle on_list ancestor in
 list_add_leaf_cfs_rq()
From: Peter Zijlstra <peterz@infradead.org>
To: "Jan H." =?ISO-8859-1?Q?Sch=F6nherr?= <schnhrr@cs.tu-berlin.de>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Turner <pjt@google.com>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 23 Aug 2011 20:53:35 +0200
In-Reply-To: <1313503666-13726-3-git-send-email-schnhrr@cs.tu-berlin.de>
References: <1313503666-13726-1-git-send-email-schnhrr@cs.tu-berlin.de>
	 <1313503666-13726-3-git-send-email-schnhrr@cs.tu-berlin.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314125615.8002.90.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-16 at 16:07 +0200, Jan H. Schönherr wrote:
> From: Jan H. Schönherr <schnhrr@cs.tu-berlin.de>
> 
> In the case of an on_list ancestor we may incorrectly place the child to
> the right of a great-ancestor on the list.
> 
> Consider:
> 
>       A
>      / \     Here, t1A results in A->cfs_rq being on_list, however when
>     B  t1A   we start enqueuing from C this will not be visible.  This is
>    /         compounded by the fact that on_list expiration may also be out
>   C          of order, punching holes in the tree.
>  /
> t1C
> 
> Prevent this by making additions to the leaf_cfs_rq_list position
> independent.
> 
> This is done by collecting additions to this list within the
> enqueue_task_fair() path until we reach the top or find an on_list
> ancestor. All additions are then spliced into the leaf_cfs_rq_list at
> once.
> 
> The additions cannot be collected in a list with the normal means as
> this violates the RCU guarantee that the next pointer of an element
> always leads back to the list as long as there could be concurrent
> readers.  However, we are still allowed to modify the next pointer of
> deleted entries as long as we make sure that they eventually return to
> the list. That is, if we have to collect more than one entry in a row,
> it is legal to set the next-pointer of the first collected entry to the
> next one. (We only need to make sure not to hit any physically deleted
> list entries.)
> 
> Suggested-by: Paul Turner <pjt@google.com>
> Signed-off-by: Jan H. Schönherr <schnhrr@cs.tu-berlin.de>
> ---
>  kernel/sched_fair.c |   79 +++++++++++++++++++++++++++++++++++++++-----------
>  1 files changed, 61 insertions(+), 18 deletions(-)
> 
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index bc8ee99..1317791 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -135,26 +135,65 @@ static inline struct cfs_rq *group_cfs_rq(struct sched_entity *grp)
>  	return grp->my_q;
>  }


It would be good to have a comment here about why we're doing things,
much like the changelog in fact, the comments in the function explain
the how of things, but not really the why of things.

> +static inline void list_add_leaf_cfs_rq(struct cfs_rq *cfs_rq,
> +					struct list_head *leaf_cfs_rqs)
>  {
> +	if (cfs_rq->on_list)
> +		return;
> +
> +	/*
> +	 * Carefully collect leaf-cfs entries:
> +	 *
> +	 * We might still have concurrent readers on these entries from before
> +	 * the previous delete operation. Therefore we cannot collect them in a
> +	 * totally independent list. Instead, we reorganize the deleted entries
> +	 * within the deleted list, making sure that the next pointers always
> +	 * lead back to the list.
> +	 */
> +	if (list_empty(leaf_cfs_rqs)) {
>  		/*
> +		 * Nothing has been collected so far. Make this cfs_rq the
> +		 * first entry. There is no need to take care of its next
> +		 * pointer.
>  		 */
> +		leaf_cfs_rqs->next = &cfs_rq->leaf_cfs_rq_list;
> +		leaf_cfs_rqs->prev = &cfs_rq->leaf_cfs_rq_list;
>  
> +	} else {
> +		/*
> +		 * We already collected at least one entry. Add this cfs_rq
> +		 * after the collected ones. Before that, however, we need to
> +		 * set its next pointer to a not deleted list entry so that
> +		 * concurrent readers of already collected elements cannot run
> +		 * into physically deleted elements.
> +		 */
> +		cfs_rq->leaf_cfs_rq_list.next =
> +					&rq_of(cfs_rq)->leaf_cfs_rq_list;

So __list_link_rcu() adds a smp_wmb() right here, I somehow can't seem
to make my mind up on how that's important..

> +		__list_link_rcu(leaf_cfs_rqs->prev, &cfs_rq->leaf_cfs_rq_list);
> +		leaf_cfs_rqs->prev = &cfs_rq->leaf_cfs_rq_list;
>  	}

OK, so the above part queues the passed cfs_rq on the private list in
bottom up fashion. Existing (lingering) iterators can get trapped on
this list and go round and round for a while.

> +
> +	/*
> +	 * If our parent is on_list or if there is no parent, then splice all
> +	 * entries collected so far at the correct position into the
> +	 * leaf_cfs_rq_list.
> +	 *
> +	 * If our parent is not on the list, it will be collected during the
> +	 * next call to this function.
> +	 */
> +	if (cfs_rq->tg->parent) {
> +		int cpu = cpu_of(rq_of(cfs_rq));
> +		struct cfs_rq *parent_cfs_rq = cfs_rq->tg->parent->cfs_rq[cpu];
> +		if (parent_cfs_rq->on_list) {
> +			list_splice_tail_init_rcu(leaf_cfs_rqs,
> +					&parent_cfs_rq->leaf_cfs_rq_list);
> +		}
> +	} else {
> +		list_splice_tail_init_rcu(leaf_cfs_rqs,
> +					&rq_of(cfs_rq)->leaf_cfs_rq_list);
> +	}
> +
> +	cfs_rq->on_list = 1;

And this part is where we splice the queue into the bigger list, and can
be simplified (see below), at this point the trapped iterators are
released and will complete their traversal 'up' and reach the
rq->leaf_cfs_rq_list list head for termination.

Since all this is done with IRQs disabled the delay imposed on the
trapped iterators is bounded by our own runtime, which again should be
limited because we're in the middle of the scheduler (bounded by the
cgroup hierarchy depth).

>  }
>  
>  static inline void list_del_leaf_cfs_rq(struct cfs_rq *cfs_rq)

> @@ -1307,12 +1345,17 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
>  {
>  	struct cfs_rq *cfs_rq;
>  	struct sched_entity *se = &p->se;
> +	struct list_head leaf_cfs_rqs;
> +
> +	INIT_LIST_HEAD(&leaf_cfs_rqs);

>  	for_each_sched_entity(se) {
>  		if (se->on_rq)
>  			break;
>  		cfs_rq = cfs_rq_of(se);
>  		enqueue_entity(cfs_rq, se, flags);
> +		if (cfs_rq->nr_running == 1)
> +			list_add_leaf_cfs_rq(cfs_rq, &leaf_cfs_rqs);
>  		flags = ENQUEUE_WAKEUP;
>  	}


I think splitting the function into two parts would make the thing
saner, something like:


	LIST_HEAD(leaf_queue);

	for_each_sched_entity(se) {
		if (se->on_rq)
			break;
		cfs_rq = cfs_rq_of(se);
		enqueue_entity(cfs_rq, se, flags);
		flags = ENQUEUE_WAKEUP;
		if (cfs_rq->nr_running == 1)
			leaf_add_queue(cfs_rq, &leaf_queue);
	}
	/* XXX does ->on_rq imply ->on_list ? */
	if (se->on_list)
		leaf_splice_queue(cfs_rq, &leaf_queue);

that splits the add to queue and add queue to list part and avoids the
parent_cfs_rq peeking.

Now I don't really like the above because its hard to make the code go
away in the !FAIR_GROUP case, but maybe we can come up with something
for that.
