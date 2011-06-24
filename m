Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755109Ab1FXLNN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 07:13:13 -0400
Received: from relay.parallels.com ([195.214.232.42]:54010 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234Ab1FXLNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 07:13:11 -0400
Message-ID: <4E047145.8050601@parallels.com>
Date: Fri, 24 Jun 2011 15:13:09 +0400
From: Konstantin Khlebnikov <khlebnikov@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.18) Gecko/20110416 SeaMonkey/2.0.13
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Jens Axboe <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cfq-iosched: queue groups more gracefully
References: <20110623162206.3222.3312.stgit@localhost6> <20110623175118.GD20763@redhat.com>
In-Reply-To: <20110623175118.GD20763@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> On Thu, Jun 23, 2011 at 08:22:06PM +0400, Konstantin Khlebnikov wrote:
>> This patch queue awakened cfq-groups according its current vdisktime,
>> it try to save upto one group timeslice from unused virtual disk time.
>> Thus group does not loses everything, if it was not continuously backlogged.
>>
>> Signed-off-by: Konstantin Khlebnikov<khlebnikov@openvz.org>
>
> I think this patch is not required till we start preemption across
> groups? Any more details of actual use will help.

I saw some problems with fairness and latency between groups with parallel
intensive IO and interactive groups -- cfq always put interactive groups at the end,
so its latency is extremely high. With this patch interactive groups got real chance to
be scheduled much earlier. I'm sorry, I can not show simple test-cases right now.

>
>> ---
>>   block/cfq-iosched.c |   36 ++++++++++++++++++++++++++++++------
>>   1 files changed, 30 insertions(+), 6 deletions(-)
>>
>> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
>> index c71533e..d5c7c79 100644
>> --- a/block/cfq-iosched.c
>> +++ b/block/cfq-iosched.c
>> @@ -592,6 +592,26 @@ cfq_group_slice(struct cfq_data *cfqd, struct cfq_group *cfqg)
>>   	return cfq_target_latency * cfqg->weight / st->total_weight;
>>   }
>>
>> +static inline u64
>> +cfq_group_vslice(struct cfq_data *cfqd, struct cfq_group *cfqg)
>> +{
>> +	struct cfq_rb_root *st =&cfqd->grp_service_tree;
>> +	u64 vslice;
>> +
>> +	/* There no group slices in iops mode */
>> +	if (iops_mode(cfqd))
>> +		return 0;
>> +
>> +	/*
>> +	 * Equal to cfq_scale_slice(cfq_group_slice(cfqd, cfqg), cfqg).
>> +	 * Add group weight beacuse it currently not in service tree.
>> +	 */
>> +	vslice = (u64)cfq_target_latency<<  CFQ_SERVICE_SHIFT;
>> +	vslice *= BLKIO_WEIGHT_DEFAULT;
>> +	do_div(vslice, st->total_weight + cfqg->weight);
>
> Above is not equivalent to cfq_scale_slice(cfq_group_slice(cfqd, cfqg),
> cfqg) as comment says.
>
> you are not calculating cfq_group_slice(). Instead using cfq_target_latency.

No, this this expression gives the same value as cfq_scale_slice(cfq_group_slice())
after the group will be added to service tree. It is equal to slice that the group will receive
if it will be queued immediately after the addition.

>
> Also it does not make sense. A higher weight group gets lower vslice
> and in turn gets put further away on the tree. This is reverse of what
> you want.
>
>> +	return vslice;
>> +}
>> +
>>   static inline unsigned
>>   cfq_scaled_cfqq_slice(struct cfq_data *cfqd, struct cfq_queue *cfqq)
>>   {
>> @@ -884,16 +904,20 @@ cfq_group_notify_queue_add(struct cfq_data *cfqd, struct cfq_group *cfqg)
>>   		return;
>>
>>   	/*
>> -	 * Currently put the group at the end. Later implement something
>> -	 * so that groups get lesser vtime based on their weights, so that
>> -	 * if group does not loose all if it was not continuously backlogged.
>> +	 * Bump vdisktime to be greater or equal min_vdisktime.
>> +	 */
>> +	cfqg->vdisktime = max_vdisktime(cfqg->vdisktime, st->min_vdisktime);
>> +
>
> why do we need to do this?

Time should not go back, it's dangerous.

>
>> +	/*
>> +	 * Put the group at the end, but save one slice from unused time.
>>   	 */
>>   	n = rb_last(&st->rb);
>>   	if (n) {
>>   		__cfqg = rb_entry_cfqg(n);
>> -		cfqg->vdisktime = __cfqg->vdisktime + CFQ_IDLE_DELAY;
>> -	} else
>> -		cfqg->vdisktime = st->min_vdisktime;
>> +		cfqg->vdisktime = max_vdisktime(cfqg->vdisktime,
> 						^^^^^^^
> I think you meant st->min_vdisktime here?

No, I adjust group vdisktime to put it at the end, but save up to one slice.
Although there may be a problem with the overlap, with wakeup after looong sleep..

>> +				__cfqg->vdisktime -
>> +					cfq_group_vslice(cfqd, cfqg));
>> +	}
>>   	cfq_group_service_tree_add(st, cfqg);
>>   }
>>
>
> Thanks
> Vivek

