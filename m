Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757632Ab1FJCG5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 22:06:57 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:51514 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756887Ab1FJCG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 22:06:56 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=tao.ma;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=YpHEUKaFYR19xd1ZRLdF61OjQdqEUCRghyDe+D53mYCY42sDRbhLl1NI6NEsp0W9928gLR8bZt00Uf1Pw9KC8vHBqmimBMnBzvywzwoj75eF9t+wkAmajPuJIbeyrtsb;
Message-ID: <4DF17C38.2010306@tao.ma>
Date: Fri, 10 Jun 2011 10:06:48 +0800
From: Tao Ma <tm@tao.ma>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Shaohua Li <shli@kernel.org>
CC: Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: CFQ: async queue blocks the whole system
References: <1307616577-6101-1-git-send-email-tm@tao.ma>	<20110609141451.GD29913@redhat.com>	<4DF0DD0F.8090407@tao.ma>	<20110609153738.GF29913@redhat.com>	<BANLkTinMp5_TS-=Y0ZsxB45RLQv18WCZDg@mail.gmail.com> <BANLkTikNrxqxcouafDA-HuuDm8G_Ho7Mwg@mail.gmail.com>
In-Reply-To: <BANLkTikNrxqxcouafDA-HuuDm8G_Ho7Mwg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 114.251.86.0 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2011 09:34 AM, Shaohua Li wrote:
> 2011/6/10 Shaohua Li <shaohua.li@intel.com>:
>> 2011/6/9 Vivek Goyal <vgoyal@redhat.com>:
>>> On Thu, Jun 09, 2011 at 10:47:43PM +0800, Tao Ma wrote:
>>>> Hi Vivek,
>>>>       Thanks for the quick response.
>>>> On 06/09/2011 10:14 PM, Vivek Goyal wrote:
>>>>> On Thu, Jun 09, 2011 at 06:49:37PM +0800, Tao Ma wrote:
>>>>>> Hi Jens and Vivek,
>>>>>>    We are current running some heavy ext4 metadata test,
>>>>>> and we found a very severe problem for CFQ. Please correct me if
>>>>>> my statement below is wrong.
>>>>>>
>>>>>> CFQ only has an async queue for every priority of every class and
>>>>>> these queues have a very low serving priority, so if the system
>>>>>> has a large number of sync reads, these queues will be delayed a
>>>>>> lot of time. As a result, the flushers will be blocked, then the
>>>>>> journal and finally our applications[1].
>>>>>>
>>>>>> I have tried to let jbd/2 to use WRITE_SYNC so that they can checkpoint
>>>>>> in time and the patches are sent. But today we found another similar
>>>>>> block in kswapd which make me think that maybe CFQ should be changed
>>>>>> somehow so that all these callers can benefit from it.
>>>>>>
>>>>>> So is there any way to let the async queue work timely or at least
>>>>>> is there any deadline for async queue to finish an request in time
>>>>>> even in case there are many reads?
>>>>>>
>>>>>> btw, We have tested deadline scheduler and it seems to work in our test.
>>>>>>
>>>>>> [1] the message we get from one system:
>>>>>> INFO: task flush-8:0:2950 blocked for more than 120 seconds.
>>>>>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>>>>>> flush-8:0       D ffff88062bfde738     0  2950      2 0x00000000
>>>>>>  ffff88062b137820 0000000000000046 ffff88062b137750 ffffffff812b7bc3
>>>>>>  ffff88032cddc000 ffff88062bfde380 ffff88032d3d8840 0000000c2be37400
>>>>>>  000000002be37601 0000000000000006 ffff88062b137760 ffffffff811c242e
>>>>>> Call Trace:
>>>>>>  [<ffffffff812b7bc3>] ? scsi_request_fn+0x345/0x3df
>>>>>>  [<ffffffff811c242e>] ? __blk_run_queue+0x1a/0x1c
>>>>>>  [<ffffffff811c57cc>] ? queue_unplugged+0x77/0x8e
>>>>>>  [<ffffffff813dbe67>] io_schedule+0x47/0x61
>>>>>>  [<ffffffff811c512c>] get_request_wait+0xe0/0x152
>>>>>
>>>>> Ok, so flush slept on trying to get a "request" allocated on request
>>>>> queue. That means all the ASYNC request descriptors are already consumed
>>>>> and we are not making progress with ASYNc requests.
>>>>>
>>>>> A relatively recent patch allowed sync queues to always preempt async queues
>>>>> and schedule sync workload instead of async. This had the potential to
>>>>> starve async queues and looks like that's what we are running into.
>>>>>
>>>>> commit f8ae6e3eb8251be32c6e913393d9f8d9e0609489
>>>>> Author: Shaohua Li <shaohua.li@intel.com>
>>>>> Date:   Fri Jan 14 08:41:02 2011 +0100
>>>>>
>>>>>     block cfq: make queue preempt work for queues from different workload
>>>>>
>>>>> Do you have few seconds of blktrace. I just wanted to verify that this
>>>>> is what we are running into.
>>>> We are using the latest kernel, so the patch is already there. :(
>>>>
>>>> You are right that all the requests have been allocated and the flusher
>>>> is waiting for requests to be available. But the root cause is that in
>>>> heavy sync read, the async queue in cfq is delayed too much. I have
>>>> added some traces in the cfq codes path and after several investigation,
>>>> I found several interesting things and tried to improve it. But I am not
>>>> sure whether it is bug or it is designed intentionally.
>>>>
>>>> 1. In cfq_dispatch_requests we select a sync queue to serve, but if the
>>>> queue has too much requests in flight, the cfq_slice_used_soon may be
>>>> true and the cfqq isn't allowed to send and will waste some timeslice.
>>>> Then why choose this cfqq? Why not choose a qualified one?
>>>
>>> CFQ in general tries not to drive too deep a queue depth in an effort
>>> to improve latencies. CFQ is generally recommened for slow SATA drives
>>> and dispatching too many requests from a single queue can only serve to
>>> increase the latency.
>>>
>>>>
>>>> 2. async queue isn't allowed to be sent if there is some sync request in
>>>> fly, but as now most of the devices has a greater depth, should we
>>>> improve it somehow? I guess queue_depth should be a valid number maybe?
>>>
>>> We seem to be running this batching thing in cfq_may_dispatch() where
>>> we drain sync requests before async is dispatched and vice-a-versa.
>>> I am not sure how does this batching thing helps. I think Jens should
>>> be a better person to comment on that.
>>>
>>> I ran a fio job with few readers and few writers. I do see that few times
>>> we have schedule ASYNC workload/queue but did not dispatch a request
>>> from that. And reason being that there are sync requests in flight. And
>>> by the time sync requests finish, async queue gets preempted.
>>>
>>> So async queue does it scheduled but never gets a chance to dispatch
>>> a request because there was sync IO in flight.
>>>
>>> If there is no major advantage of draining sync requests before async
>>> is dispatched, I think this should be an easy fix.
>> I thought this is to avoid sync latency if we switch from an async
>> queue to sync queue later.
>>
>>>> 3. Even there is no sync i/o, the async queue isn't allowed to send too
>>>> much requests because of the check in cfq_may_dispatch "Async queues
>>>> must wait a bit before being allowed dispatch", so in my test the async
>>>> queue has several chances to be selected, but it is only allowed
>>>> todispatch one request at a time. It is really amazing.
>>>
>>> Again heavily loaded to improve sync latencies. Say you have queue
>>> depth of 128 and you fill that all with async requests because right
>>> now there is no sync request around. Then a sync request comes in.
>>> We don't have a way to give it a priority and it might happen that
>>> it gets executed after 128 async requests have finished (driver and
>>> drive dependent though).
>>>
>>> So in an attempt to improve sync latencies we don't drive too
>>> high queue depths.
>>>
>>> Its latency vs throughput tradeoff.
>> The current cfq do be able to stave async queue, because we want to give small
>> latency to sync queue.
>> I agree we should do something to improve async starvation, but the
>> problem is how
>> long async queue slice should be. A sd card I tested has very high
>> latency for write. A 4k write can take > 300ms. Just dispatching a
>> singe write can dramatically impact
>> read throughput. Even in modern SSD, read is several times faster than write.
> My previous experiment is if a queue is preempted, it will not be
> preempted at the second time. This can improve something, but can't
> resolve the problem completely.
> I thought we can't completely solve this issue if we give high
> priority to sync queue,
> async queue is unavoidable to be able starved.
I am fine that async queue tends to be starved, but the problem is that
it is been starved too long. And although it is asynced, some sync
process are waiting for it, like jbd2 in my test. So CFQ should provide
us with at least some deadline. In my tests sometimes flusher is blocked
for more than 500 seconds before it can be waken up in get_request_wait.
 It is really amazing for me.

Regards,
Tao
