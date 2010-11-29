Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630Ab0K2Ce3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 21:34:29 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:61653 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754448Ab0K2Ce2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 21:34:28 -0500
Message-ID: <4CF3111E.60507@cn.fujitsu.com>
Date: Mon, 29 Nov 2010 10:34:06 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Jens Axboe <axboe@kernel.dk>, Corrado Zoccolo <czoccolo@gmail.com>,
        Chad Talbott <ctalbott@google.com>, Nauman Rafique <nauman@google.com>,
        Divyesh Shah <dpshah@google.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH 4/8] cfq-iosched: Get rid of st->active
References: <4CDF7BC5.9080803@cn.fujitsu.com> <4CDF9CE0.3060606@cn.fujitsu.com> <20101115194855.GC3396@redhat.com>
In-Reply-To: <20101115194855.GC3396@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-29 10:34:37,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-29 10:34:37,
	Serialize complete at 2010-11-29 10:34:37
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> On Sun, Nov 14, 2010 at 04:25:04PM +0800, Gui Jianfeng wrote:
>> When a cfq group is running, it won't be dequeued from service tree, so
>> there's no need to store the active one in st->active. Just gid rid of it.
>>
>> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> 
> Hmm..., once I was also wondering if ->active pointer is superflous. Looks
> like it is and st->left will always represent the element being served. I
> think this is more of a cleanup patch and can either be first patch in the
> series or you can post it independently.

Ok.

Gui

> 
> Vivek
> 
>> ---
>>  block/cfq-iosched.c |   15 +--------------
>>  1 files changed, 1 insertions(+), 14 deletions(-)
>>
>> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
>> index ef88931..ad577b5 100644
>> --- a/block/cfq-iosched.c
>> +++ b/block/cfq-iosched.c
>> @@ -88,7 +88,6 @@ struct cfq_rb_root {
>>  	unsigned count;
>>  	unsigned total_weight;
>>  	u64 min_vdisktime;
>> -	struct rb_node *active;
>>  };
>>  #define CFQ_RB_ROOT	(struct cfq_rb_root) { .rb = RB_ROOT, .left = NULL, \
>>  			.count = 0, .min_vdisktime = 0, }
>> @@ -599,11 +598,6 @@ static void update_min_vdisktime(struct cfq_rb_root *st)
>>  	u64 vdisktime = st->min_vdisktime;
>>  	struct io_sched_entity *entity;
>>  
>> -	if (st->active) {
>> -		entity = rb_entry_entity(st->active);
>> -		vdisktime = entity->vdisktime;
>> -	}
>> -
>>  	if (st->left) {
>>  		entity = rb_entry_entity(st->left);
>>  		vdisktime = min_vdisktime(vdisktime, entity->vdisktime);
>> @@ -925,9 +919,6 @@ cfq_group_service_tree_del(struct cfq_data *cfqd, struct cfq_group *cfqg)
>>  	struct cfq_rb_root *st = &cfqd->grp_service_tree;
>>  	struct io_sched_entity *group_entity = &cfqg->group_entity;
>>  
>> -	if (st->active == &group_entity->rb_node)
>> -		st->active = NULL;
>> -
>>  	BUG_ON(cfqg->nr_cfqq < 1);
>>  	cfqg->nr_cfqq--;
>>  
>> @@ -1130,7 +1121,7 @@ static void cfq_put_cfqg(struct cfq_group *cfqg)
>>  	if (!atomic_dec_and_test(&cfqg->ref))
>>  		return;
>>  	for_each_cfqg_st(cfqg, i, j, st)
>> -		BUG_ON(!RB_EMPTY_ROOT(&st->rb) || st->active != NULL);
>> +		BUG_ON(!RB_EMPTY_ROOT(&st->rb));
>>  	kfree(cfqg);
>>  }
>>  
>> @@ -1773,9 +1764,6 @@ __cfq_slice_expired(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>>  	if (cfqq == cfqd->active_queue)
>>  		cfqd->active_queue = NULL;
>>  
>> -	if (&cfqq->cfqg->group_entity.rb_node == cfqd->grp_service_tree.active)
>> -		cfqd->grp_service_tree.active = NULL;
>> -
>>  	if (cfqd->active_cic) {
>>  		put_io_context(cfqd->active_cic->ioc);
>>  		cfqd->active_cic = NULL;
>> @@ -2305,7 +2293,6 @@ static struct cfq_group *cfq_get_next_cfqg(struct cfq_data *cfqd)
>>  	group_entity = cfq_rb_first_entity(st);
>>  	cfqg = cfqg_of_entity(group_entity);
>>  	BUG_ON(!cfqg);
>> -	st->active = &group_entity->rb_node;
>>  	update_min_vdisktime(st);
>>  	return cfqg;
>>  }
>> -- 
>> 1.6.5.2
>>
>>
> 
