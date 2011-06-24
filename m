Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200Ab1FXK3I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 06:29:08 -0400
Received: from relay.parallels.com ([195.214.232.42]:48514 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735Ab1FXK3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 06:29:02 -0400
Message-ID: <4E0466EC.9030309@openvz.org>
Date: Fri, 24 Jun 2011 14:29:00 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.18) Gecko/20110416 SeaMonkey/2.0.13
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Jens Axboe <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cfq-iosched: allow groups preemption for sync-noidle
 workloads
References: <20110623162159.3192.87699.stgit@localhost6> <20110623203459.GF20763@redhat.com>
In-Reply-To: <20110623203459.GF20763@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> On Thu, Jun 23, 2011 at 08:21:59PM +0400, Konstantin Khlebnikov wrote:
>> commit v2.6.32-102-g8682e1f "blkio: Provide some isolation between groups" break
>> fast switching between task and journal-thread for very common write-fsync workload.
>> cfq wait idle slice at each cfqq switch, if this task is from non-root blkio cgroup.
>>
>> This patch move idling sync-noidle preempting check little bit upwards and update
>> new service_tree->count check for case with two different groups.
>> I do not quite understand what means these check for new_cfqq, but now it even works.
>>
>> Without patch I got 49 iops and with this patch 798, for this trivial fio script:
>>
>> [write-fsync]
>> cgroup=test
>> cgroup_weight=1000
>> rw=write
>> fsync=1
>> size=100m
>> runtime=10s
>
> What kind of storage and filesystem you are using? I tried this on a SATA
> disk and I really don't get good throughput. With deadline scheduler I
> get aggrb=103KB/s.
>
> I think with fsync we are generating so many FLUSH requests that it
> really slows down fsync.
>
> Even if I use CFQ with and without cgroups, I get following.
>
> CFQ, without cgroup
> ------------------
> aggrb=100KB/s
>
> CFQ with cgroup
> --------------
> aggrb=94KB/s
>
> So with FLUSH requests, not much difference in throughput for this
> workload.
>
> I guess you must be running with barriers off or something like that.

Yes, it was ext4 on sata hdd without barriers, seems like ssd are not affected,
at least my intel x25m-g2. But I have problem report at openvz bugzilla where
this bug appears even with barriers on some cool server hardware:
http://bugzilla.openvz.org/show_bug.cgi?id=1913

>
> Thanks
> Vivek
>
>
>>
>> Signed-off-by: Konstantin Khlebnikov<khlebnikov@openvz.org>
>> ---
>>   block/cfq-iosched.c |   14 +++++++-------
>>   1 files changed, 7 insertions(+), 7 deletions(-)
>>
>> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
>> index 3c7b537..c71533e 100644
>> --- a/block/cfq-iosched.c
>> +++ b/block/cfq-iosched.c
>> @@ -3318,19 +3318,19 @@ cfq_should_preempt(struct cfq_data *cfqd, struct cfq_queue *new_cfqq,
>>   	if (rq_is_sync(rq)&&  !cfq_cfqq_sync(cfqq))
>>   		return true;
>>
>> -	if (new_cfqq->cfqg != cfqq->cfqg)
>> -		return false;
>> -
>> -	if (cfq_slice_used(cfqq))
>> -		return true;
>> -
>>   	/* Allow preemption only if we are idling on sync-noidle tree */
>>   	if (cfqd->serving_type == SYNC_NOIDLE_WORKLOAD&&
>>   	cfqq_type(new_cfqq) == SYNC_NOIDLE_WORKLOAD&&
>> -	    new_cfqq->service_tree->count == 2&&
>> +	    new_cfqq->service_tree->count == 1+(new_cfqq->cfqg == cfqq->cfqg)&&
>>   	RB_EMPTY_ROOT(&cfqq->sort_list))
>>   		return true;
>>
>> +	if (new_cfqq->cfqg != cfqq->cfqg)
>> +		return false;
>> +
>> +	if (cfq_slice_used(cfqq))
>> +		return true;
>> +
>>   	/*
>>   	 * So both queues are sync. Let the new request get disk time if
>>   	 * it's a metadata request and the current queue is doing regular IO.

