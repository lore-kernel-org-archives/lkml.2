Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599Ab0K2CdS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 21:33:18 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52107 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754112Ab0K2CdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 21:33:17 -0500
Message-ID: <4CF310D8.9020301@cn.fujitsu.com>
Date: Mon, 29 Nov 2010 10:32:56 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Jens Axboe <axboe@kernel.dk>, Corrado Zoccolo <czoccolo@gmail.com>,
        Chad Talbott <ctalbott@google.com>, Nauman Rafique <nauman@google.com>,
        Divyesh Shah <dpshah@google.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH 3/8] cfq-iosched: Introduce vdisktime and io weight
 for CFQ queue
References: <4CDF7BC5.9080803@cn.fujitsu.com> <4CDF9CD8.8010207@cn.fujitsu.com> <20101115193352.GB3396@redhat.com>
In-Reply-To: <20101115193352.GB3396@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-29 10:33:27,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-29 10:33:28,
	Serialize complete at 2010-11-29 10:33:28
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> On Sun, Nov 14, 2010 at 04:24:56PM +0800, Gui Jianfeng wrote:
>> Introduce vdisktime and io weight for CFQ queue scheduling. Currently, io priority
>> maps to a range [100,1000]. It also gets rid of cfq_slice_offset() logic and makes
>> use the same scheduling algorithm as CFQ group does. This helps for CFQ queue and
>> group scheduling on the same service tree.
>>
> 
> Gui,
> 
> I think we can't get rid of cfq_slice_offset() logic altogether because 
> I believe this piece can help provide some service differentiation between
> queues on SSDs or when idling is not enabled. Though that service
> differentiation is highly unpredicatable and becomes even less visible
> when NCQ is enabled.
> 
> So we shall have to replace with some similar logic. When a new queue
> entity gets backlogged on service tree, give it some jump in vdisktime
> based on ioprio. Lower ioprio gets higher vdisktime jump etc.

Vivek,

Ok, I'll consider your suggestion.

> 
> To test this, I would say take an SSD, set the queue depth to 1, and 
> then run bunch of threads with different ioprio. First see if without
> patch do you see any service differentiation and then run it again with
> your patch applied for comparision.

Ok

> 
> 
>> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
>> ---
>>  block/cfq-iosched.c |  194 ++++++++++++++++++++++++++++++++++----------------
>>  1 files changed, 132 insertions(+), 62 deletions(-)
>>
>> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
>> index 5cce1e8..ef88931 100644
>> --- a/block/cfq-iosched.c
>> +++ b/block/cfq-iosched.c
>> @@ -102,10 +102,7 @@ struct io_sched_entity {
>>  	struct cfq_rb_root *service_tree;
>>  	/* service_tree member */
>>  	struct rb_node rb_node;
>> -	/* service_tree key, represent the position on the tree */
>> -	unsigned long rb_key;
>> -
>> -	/* group service_tree key */
>> +	/* service_tree key */
>>  	u64 vdisktime;
>>  	bool on_st;
>>  	bool is_group_entity;
>> @@ -118,6 +115,8 @@ struct io_sched_entity {
>>  struct cfq_queue {
>>  	/* The schedule entity */
>>  	struct io_sched_entity queue_entity;
>> +	/* Reposition time */
>> +	unsigned long reposition_time;
>>  	/* reference count */
>>  	atomic_t ref;
>>  	/* various state flags, see below */
>> @@ -306,6 +305,22 @@ struct cfq_data {
>>  	struct rcu_head rcu;
>>  };
>>  
>> +/*
>> + * Map io priority(7 ~ 0) to io weight(100 ~ 1000)
>> + */
>> +static inline unsigned int cfq_prio_to_weight(unsigned short ioprio)
>> +{
>> +	unsigned int step;
>> +
>> +	BUG_ON(ioprio >= IOPRIO_BE_NR);
>> +
>> +	step = (BLKIO_WEIGHT_MAX - BLKIO_WEIGHT_MIN) / (IOPRIO_BE_NR - 1);
>> +	if (ioprio == 0)
>> +		return BLKIO_WEIGHT_MAX;
>> +
>> +	return BLKIO_WEIGHT_MIN + (IOPRIO_BE_NR - ioprio - 1) * step;
>> +}
>> +
> 
> What's the rationale behind above formula? How does it map prio to
> weigths?

This formula map ioprio to weight as follow:

prio	0     1     2    3    4    5    6     7
weight  1000  868   740  612  484  356  228   100 (new prio to weight mapping)

> 
> Could we just do following.
> 
> 	step = BLKIO_WEIGHT_MAX/IOPRIO_BE_NR
> 
> 	return BLKIO_WEIGHT_MAX - (ioprio * step) 
> 
> above should map prio to weights as follows.
> 
> slice  180   160   140  120  100  80   60    40 (old prio to slice mapping)
> prio	0     1     2    3    4    5    6     7
> weight  1000  875   750  625  500  375 250   125 (new prio to weight mapping)
> 
>>  static inline struct cfq_queue *
>>  cfqq_of_entity(struct io_sched_entity *io_entity)
>>  {
>> @@ -551,12 +566,13 @@ cfq_prio_to_slice(struct cfq_data *cfqd, struct cfq_queue *cfqq)
>>  	return cfq_prio_slice(cfqd, cfq_cfqq_sync(cfqq), cfqq->ioprio);
>>  }
>>  
>> -static inline u64 cfq_scale_slice(unsigned long delta, struct cfq_group *cfqg)
>> +static inline u64
>> +cfq_scale_slice(unsigned long delta, struct io_sched_entity *entity)
>>  {
>>  	u64 d = delta << CFQ_SERVICE_SHIFT;
>>  
>>  	d = d * BLKIO_WEIGHT_DEFAULT;
>> -	do_div(d, cfqg->group_entity.weight);
>> +	do_div(d, entity->weight);
> 
> This can go in previous patch?

Sure.

> 
>>  	return d;
> 
>>  }
>>  
>> @@ -581,16 +597,16 @@ static inline u64 min_vdisktime(u64 min_vdisktime, u64 vdisktime)
>>  static void update_min_vdisktime(struct cfq_rb_root *st)
>>  {
>>  	u64 vdisktime = st->min_vdisktime;
>> -	struct io_sched_entity *group_entity;
>> +	struct io_sched_entity *entity;
>>  
>>  	if (st->active) {
>> -		group_entity = rb_entry_entity(st->active);
>> -		vdisktime = group_entity->vdisktime;
>> +		entity = rb_entry_entity(st->active);
>> +		vdisktime = entity->vdisktime;
>>  	}
>>  
>>  	if (st->left) {
>> -		group_entity = rb_entry_entity(st->left);
>> -		vdisktime = min_vdisktime(vdisktime, group_entity->vdisktime);
>> +		entity = rb_entry_entity(st->left);
>> +		vdisktime = min_vdisktime(vdisktime, entity->vdisktime);
>>  	}
>>  
> 
> Can go in previous patch?

Sure.

> 
>>  	st->min_vdisktime = max_vdisktime(st->min_vdisktime, vdisktime);
>> @@ -838,16 +854,6 @@ cfq_find_next_rq(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>>  	return cfq_choose_req(cfqd, next, prev, blk_rq_pos(last));
>>  }
>>  
>> -static unsigned long cfq_slice_offset(struct cfq_data *cfqd,
>> -				      struct cfq_queue *cfqq)
>> -{
>> -	/*
>> -	 * just an approximation, should be ok.
>> -	 */
>> -	return (cfqq->cfqg->nr_cfqq - 1) * (cfq_prio_slice(cfqd, 1, 0) -
>> -		       cfq_prio_slice(cfqd, cfq_cfqq_sync(cfqq), cfqq->ioprio));
>> -}
>> -
>>  static inline s64
>>  entity_key(struct cfq_rb_root *st, struct io_sched_entity *entity)
>>  {
>> @@ -983,7 +989,7 @@ static void cfq_group_served(struct cfq_data *cfqd, struct cfq_group *cfqg,
>>  
>>  	/* Can't update vdisktime while group is on service tree */
>>  	cfq_rb_erase(&group_entity->rb_node, st);
>> -	group_entity->vdisktime += cfq_scale_slice(charge, cfqg);
>> +	group_entity->vdisktime += cfq_scale_slice(charge, group_entity);
> 
> can go in previous patch?

Sure.

> 
> [..]
>>  
>> +/*
>> + * The time when a CFQ queue is put onto a service tree is recoreded in
>> + * cfqq->reposition_time. Currently, we check the first priority CFQ queues
>> + * on each service tree, and select the workload type that contain the lowest
>> + * reposition_time CFQ queue among them.
>> + */
> 
> What is the rational behind reposition_time. Can you explain it a bit more
> that why do we need it. I can't figure it out yet.

In original CFQ, rb_key is cross trees. We select the lowest rb_key one among
three workload trees. When vdisktime is introduced, vdisktime is maintained
by each tree self. But we still want to choose the first priority one cross trees,
So for the time being, I record the reposition_time for each cfqq, and select
the smallest reposition_time one as the next servicing workload when selecting
a new workload.

Gui

> 
> Vivek
> 
>>  static enum wl_type_t cfq_choose_wl(struct cfq_data *cfqd,
>>  				struct cfq_group *cfqg, enum wl_prio_t prio)
>>  {
>>  	struct io_sched_entity *queue_entity;
>> +	struct cfq_queue *cfqq;
>> +	unsigned long lowest_start_time;
>>  	int i;
>> -	bool key_valid = false;
>> -	unsigned long lowest_key = 0;
>> +	bool time_valid = false;
>>  	enum wl_type_t cur_best = SYNC_NOIDLE_WORKLOAD;
>>  
>> +	/*
>> +	 * TODO: We may take io priority into account when choosing a workload
>> +	 * type. But for the time being just make use of reposition_time only.
>> +	 */
>>  	for (i = 0; i <= SYNC_WORKLOAD; ++i) {
>> -		/* select the one with lowest rb_key */
>>  		queue_entity = cfq_rb_first(service_tree_for(cfqg, prio, i));
>> +		cfqq = cfqq_of_entity(queue_entity);
>>  		if (queue_entity &&
>> -		    (!key_valid ||
>> -		     time_before(queue_entity->rb_key, lowest_key))) {
>> -			lowest_key = queue_entity->rb_key;
>> +		    (!time_valid ||
>> +		     cfqq->reposition_time < lowest_start_time)) {
>> +			lowest_start_time = cfqq->reposition_time;
>>  			cur_best = i;
>> -			key_valid = true;
>> +			time_valid = true;
>>  		}
> 
