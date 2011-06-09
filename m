Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287Ab1FIOeP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 10:34:15 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:59648 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751547Ab1FIOeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 10:34:14 -0400
Message-ID: <4DF0D9E0.1060107@kernel.dk>
Date: Thu, 09 Jun 2011 16:34:08 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Tao Ma <tm@tao.ma>, linux-kernel@vger.kernel.org
Subject: Re: CFQ: async queue blocks the whole system
References: <1307616577-6101-1-git-send-email-tm@tao.ma> <20110609141451.GD29913@redhat.com>
In-Reply-To: <20110609141451.GD29913@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-06-09 16:14, Vivek Goyal wrote:
> On Thu, Jun 09, 2011 at 06:49:37PM +0800, Tao Ma wrote:
>> Hi Jens and Vivek,
>> 	We are current running some heavy ext4 metadata test,
>> and we found a very severe problem for CFQ. Please correct me if
>> my statement below is wrong.
>>
>> CFQ only has an async queue for every priority of every class and
>> these queues have a very low serving priority, so if the system
>> has a large number of sync reads, these queues will be delayed a
>> lot of time. As a result, the flushers will be blocked, then the
>> journal and finally our applications[1].
>>
>> I have tried to let jbd/2 to use WRITE_SYNC so that they can checkpoint
>> in time and the patches are sent. But today we found another similar
>> block in kswapd which make me think that maybe CFQ should be changed
>> somehow so that all these callers can benefit from it.
>>
>> So is there any way to let the async queue work timely or at least
>> is there any deadline for async queue to finish an request in time
>> even in case there are many reads?
>>
>> btw, We have tested deadline scheduler and it seems to work in our test.
>>
>> [1] the message we get from one system:
>> INFO: task flush-8:0:2950 blocked for more than 120 seconds.
>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> flush-8:0       D ffff88062bfde738     0  2950      2 0x00000000
>>  ffff88062b137820 0000000000000046 ffff88062b137750 ffffffff812b7bc3
>>  ffff88032cddc000 ffff88062bfde380 ffff88032d3d8840 0000000c2be37400
>>  000000002be37601 0000000000000006 ffff88062b137760 ffffffff811c242e
>> Call Trace:
>>  [<ffffffff812b7bc3>] ? scsi_request_fn+0x345/0x3df
>>  [<ffffffff811c242e>] ? __blk_run_queue+0x1a/0x1c
>>  [<ffffffff811c57cc>] ? queue_unplugged+0x77/0x8e
>>  [<ffffffff813dbe67>] io_schedule+0x47/0x61
>>  [<ffffffff811c512c>] get_request_wait+0xe0/0x152
> 
> Ok, so flush slept on trying to get a "request" allocated on request 
> queue. That means all the ASYNC request descriptors are already consumed
> and we are not making progress with ASYNc requests.
> 
> A relatively recent patch allowed sync queues to always preempt async queues
> and schedule sync workload instead of async. This had the potential to
> starve async queues and looks like that's what we are running into.
> 
> commit f8ae6e3eb8251be32c6e913393d9f8d9e0609489
> Author: Shaohua Li <shaohua.li@intel.com>
> Date:   Fri Jan 14 08:41:02 2011 +0100
> 
>     block cfq: make queue preempt work for queues from different workload
> 
> Do you have few seconds of blktrace. I just wanted to verify that this
> is what we are running into. 

That's a good first step. Tao Ma, is this a known regression or is that
unknown?

On vacation this week, I'll look into as soon as I get back.

-- 
Jens Axboe

