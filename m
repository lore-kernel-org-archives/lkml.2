Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944Ab1HXV1j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 17:27:39 -0400
Received: from mail.cs.tu-berlin.de ([130.149.17.13]:34111 "EHLO
	mail.cs.tu-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871Ab1HXV1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 17:27:38 -0400
Message-ID: <4E556CB2.3060502@cs.tu-berlin.de>
Date: Wed, 24 Aug 2011 23:27:14 +0200
From: =?UTF-8?B?IkphbiBILiBTY2jDtm5oZXJyIg==?= <schnhrr@cs.tu-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110508 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Paul Turner <pjt@google.com>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] sched: Handle on_list ancestor in list_add_leaf_cfs_rq()
References: <1313503666-13726-1-git-send-email-schnhrr@cs.tu-berlin.de>	 <1313503666-13726-3-git-send-email-schnhrr@cs.tu-berlin.de> <1314125615.8002.90.camel@twins>
In-Reply-To: <1314125615.8002.90.camel@twins>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 23.08.2011 20:53, schrieb Peter Zijlstra:
> On Tue, 2011-08-16 at 16:07 +0200, Jan H. Schönherr wrote:
[...]
> It would be good to have a comment here about why we're doing things,
> much like the changelog in fact, the comments in the function explain
> the how of things, but not really the why of things.

I'll try to do this.

>> +static inline void list_add_leaf_cfs_rq(struct cfs_rq *cfs_rq,
>> +					struct list_head *leaf_cfs_rqs)
>>  {
>> +	if (cfs_rq->on_list)
>> +		return;
>> +
>> +	/*
>> +	 * Carefully collect leaf-cfs entries:
>> +	 *
>> +	 * We might still have concurrent readers on these entries from before
>> +	 * the previous delete operation. Therefore we cannot collect them in a
>> +	 * totally independent list. Instead, we reorganize the deleted entries
>> +	 * within the deleted list, making sure that the next pointers always
>> +	 * lead back to the list.
>> +	 */
>> +	if (list_empty(leaf_cfs_rqs)) {
>>  		/*
>> +		 * Nothing has been collected so far. Make this cfs_rq the
>> +		 * first entry. There is no need to take care of its next
>> +		 * pointer.
>>  		 */
>> +		leaf_cfs_rqs->next = &cfs_rq->leaf_cfs_rq_list;
>> +		leaf_cfs_rqs->prev = &cfs_rq->leaf_cfs_rq_list;
>>  
>> +	} else {
>> +		/*
>> +		 * We already collected at least one entry. Add this cfs_rq
>> +		 * after the collected ones. Before that, however, we need to
>> +		 * set its next pointer to a not deleted list entry so that
>> +		 * concurrent readers of already collected elements cannot run
>> +		 * into physically deleted elements.
>> +		 */
>> +		cfs_rq->leaf_cfs_rq_list.next =
>> +					&rq_of(cfs_rq)->leaf_cfs_rq_list;
> 
> So __list_link_rcu() adds a smp_wmb() right here, I somehow can't seem
> to make my mind up on how that's important..

It makes sure that a reader from the private list cannot see
the old next pointer of the current element that was overwritten
just above. The old next pointer might lead to memory that is
freed.

>> +		__list_link_rcu(leaf_cfs_rqs->prev, &cfs_rq->leaf_cfs_rq_list);
>> +		leaf_cfs_rqs->prev = &cfs_rq->leaf_cfs_rq_list;
>>  	}
> 
> OK, so the above part queues the passed cfs_rq on the private list in
> bottom up fashion. Existing (lingering) iterators can get trapped on
> this list and go round and round for a while.

They are not trapped: the next-pointer of the last element of the
private list does not point to the head of the private list, but to
the head of the leaf-list.

>> +
>> +	/*
>> +	 * If our parent is on_list or if there is no parent, then splice all
>> +	 * entries collected so far at the correct position into the
>> +	 * leaf_cfs_rq_list.
>> +	 *
>> +	 * If our parent is not on the list, it will be collected during the
>> +	 * next call to this function.
>> +	 */
>> +	if (cfs_rq->tg->parent) {
>> +		int cpu = cpu_of(rq_of(cfs_rq));
>> +		struct cfs_rq *parent_cfs_rq = cfs_rq->tg->parent->cfs_rq[cpu];
>> +		if (parent_cfs_rq->on_list) {
>> +			list_splice_tail_init_rcu(leaf_cfs_rqs,
>> +					&parent_cfs_rq->leaf_cfs_rq_list);
>> +		}
>> +	} else {
>> +		list_splice_tail_init_rcu(leaf_cfs_rqs,
>> +					&rq_of(cfs_rq)->leaf_cfs_rq_list);
>> +	}
>> +
>> +	cfs_rq->on_list = 1;
> 
> And this part is where we splice the queue into the bigger list, and can
> be simplified (see below), at this point the trapped iterators are
> released and will complete their traversal 'up' and reach the
> rq->leaf_cfs_rq_list list head for termination.
> 
> Since all this is done with IRQs disabled the delay imposed on the
> trapped iterators is bounded by our own runtime, which again should be
> limited because we're in the middle of the scheduler (bounded by the
> cgroup hierarchy depth).

Luckily, there is no trapping, so we don't need to consider the effects. :)

>>  }
>>  
>>  static inline void list_del_leaf_cfs_rq(struct cfs_rq *cfs_rq)
> 
>> @@ -1307,12 +1345,17 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
>>  {
>>  	struct cfs_rq *cfs_rq;
>>  	struct sched_entity *se = &p->se;
>> +	struct list_head leaf_cfs_rqs;
>> +
>> +	INIT_LIST_HEAD(&leaf_cfs_rqs);
> 
>>  	for_each_sched_entity(se) {
>>  		if (se->on_rq)
>>  			break;
>>  		cfs_rq = cfs_rq_of(se);
>>  		enqueue_entity(cfs_rq, se, flags);
>> +		if (cfs_rq->nr_running == 1)
>> +			list_add_leaf_cfs_rq(cfs_rq, &leaf_cfs_rqs);
>>  		flags = ENQUEUE_WAKEUP;
>>  	}
> 
> 
> I think splitting the function into two parts would make the thing
> saner, something like:
> 
> 
> 	LIST_HEAD(leaf_queue);
> 
> 	for_each_sched_entity(se) {
> 		if (se->on_rq)
> 			break;
> 		cfs_rq = cfs_rq_of(se);
> 		enqueue_entity(cfs_rq, se, flags);
> 		flags = ENQUEUE_WAKEUP;
> 		if (cfs_rq->nr_running == 1)
> 			leaf_add_queue(cfs_rq, &leaf_queue);
> 	}
> 	/* XXX does ->on_rq imply ->on_list ? */
> 	if (se->on_list)
> 		leaf_splice_queue(cfs_rq, &leaf_queue);
> 
> that splits the add to queue and add queue to list part and avoids the
> parent_cfs_rq peeking.

Unfortunately that won't work. The problem here is that some of the
traversed SEs are on_list and others aren't. And the on_list status
of one SE is independent from other SEs. So, if we don't want to remove
on_list elements during the traversal, we need to splice collected
entries as soon as we find a SE that is on_list.

We might get away with collecting all entries always (removing on_list entries
temporarily) and splice them after the loop, but that would
introduce more work than normally necessary. And we should double check
for new concurrency issues...


> Now I don't really like the above because its hard to make the code go
> away in the !FAIR_GROUP case, but maybe we can come up with something
> for that.

Hmmm... you might want to reconsider my original approach to solve this:
http://lkml.org/lkml/2011/7/18/86

That might have been the cleanest one in this respect.

Paul Turner did not like the introduced in-order removal, but the
out-of-order removal is causing most problems.


Regards
Jan (not quite sure which path to follow)
