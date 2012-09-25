Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502Ab2IYSLj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 14:11:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:35982 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760Ab2IYSLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 14:11:37 -0400
Message-ID: <5061F3D2.6050502@kernel.dk>
Date: Tue, 25 Sep 2012 20:11:30 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: Mikulas Patocka <mpatocka@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Jan Kara <jack@suse.cz>,
        dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        kosaki.motohiro@jp.fujitsu.com, linux-fsdevel@vger.kernel.org,
        lwoodman@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
Subject: Re: [PATCH 0/4] Fix a crash when block device is read and block size
 is changed at the same time
References: <Pine.LNX.4.64.1206272226050.22857@file.rdu.redhat.com> <x49ipdmyz4q.fsf@segfault.boston.devel.redhat.com> <Pine.LNX.4.64.1207181512530.10923@file.rdu.redhat.com> <x49k3xzq3jc.fsf@segfault.boston.devel.redhat.com> <Pine.LNX.4.64.1207281236230.30415@file.rdu.redhat.com> <Pine.LNX.4.64.1207281240270.30415@file.rdu.redhat.com> <1343508252.2626.13184.camel@edumazet-glaptop> <Pine.LNX.4.64.1207290107460.29910@file.rdu.redhat.com> <1343556630.2626.13257.camel@edumazet-glaptop> <1343586962.2626.13266.camel@edumazet-glaptop> <Pine.LNX.4.64.1208011601280.21832@file.rdu.redhat.com> <Pine.LNX.4.64.1208311433480.2212@file.rdu.redhat.com> <Pine.LNX.4.64.1208311518340.16960@file.rdu.redhat.com> <x49liguyg6r.fsf@segfault.boston.devel.redhat.com> <x49wqzswdn3.fsf@segfault.boston.devel.redhat.com> <Pine.LNX.4.64.1209181257410.11735@file.rdu.redhat.com> <x49ehlzrt01.fsf@segfault.boston.devel.redhat.com> <x49sja6ouv4.fsf@segfault.boston.devel.redhat.com> <5061F0E6.5000403@kernel.dk>
In-Reply-To: <5061F0E6.5000403@kernel.dk>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-09-25 19:59, Jens Axboe wrote:
> On 2012-09-25 19:49, Jeff Moyer wrote:
>> Jeff Moyer <jmoyer@redhat.com> writes:
>>
>>> Mikulas Patocka <mpatocka@redhat.com> writes:
>>>
>>>> Hi Jeff
>>>>
>>>> Thanks for testing.
>>>>
>>>> It would be interesting ... what happens if you take the patch 3, leave 
>>>> "struct percpu_rw_semaphore bd_block_size_semaphore" in "struct 
>>>> block_device", but remove any use of the semaphore from fs/block_dev.c? - 
>>>> will the performance be like unpatched kernel or like patch 3? It could be 
>>>> that the change in the alignment affects performance on your CPU too, just 
>>>> differently than on my CPU.
>>>
>>> It turns out to be exactly the same performance as with the 3rd patch
>>> applied, so I guess it does have something to do with cache alignment.
>>> Here is the patch (against vanilla) I ended up testing.  Let me know if
>>> I've botched it somehow.
>>>
>>> So, I next up I'll play similar tricks to what you did (padding struct
>>> block_device in all kernels) to eliminate the differences due to
>>> structure alignment and provide a clear picture of what the locking
>>> effects are.
>>
>> After trying again with the same padding you used in the struct
>> bdev_inode, I see no performance differences between any of the
>> patches.  I tried bumping up the number of threads to saturate the
>> number of cpus on a single NUMA node on my hardware, but that resulted
>> in lower IOPS to the device, and hence consumption of less CPU time.
>> So, I believe my results to be inconclusive.
>>
>> After talking with Vivek about the problem, he had mentioned that it
>> might be worth investigating whether bd_block_size could be protected
>> using SRCU.  I looked into it, and the one thing I couldn't reconcile is
>> updating both the bd_block_size and the inode->i_blkbits at the same
>> time.  It would involve (afaiui) adding fields to both the inode and the
>> block_device data structures and using rcu_assign_pointer  and
>> rcu_dereference to modify and access the fields, and both fields would
>> need to protected by the same struct srcu_struct.  I'm not sure whether
>> that's a desirable approach.  When I started to implement it, it got
>> ugly pretty quickly.  What do others think?
>>
>> For now, my preference is to get the full patch set in.  I will continue
>> to investigate the performance impact of the data structure size changes
>> that I've been seeing.
>>
>> So, for the four patches:
>>
>> Acked-by: Jeff Moyer <jmoyer@redhat.com>
>>
>> Jens, can you have a look at the patch set?  We are seeing problem
>> reports of this in the wild[1][2].
> 
> I'll queue it up for 3.7. I can run my regular testing on the 8-way, it
> has a nack for showing scaling problems very nicely in aio/dio. As long
> as we're not adding per-inode cache line dirtying per IO (and the
> per-cpu rw sem looks OK), then I don't think there's too much to worry
> about.

I take that back. The series doesn't apply to my current tree. Not too
unexpected, since it's some weeks old. But more importantly, please send
this is a "real" patch series. I don't want to see two implementations
of rw semaphores. I think it's perfectly fine to first do a regular rw
sem, then a last patch adding the cache friendly variant from Eric and
converting to that.

In other words, get rid of 3/4.

-- 
Jens Axboe

