Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756125Ab1HDDOQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 23:14:16 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:61488 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028Ab1HDDOK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 23:14:10 -0400
MIME-Version: 1.0
In-Reply-To: <4E39FD41.4090103@cn.fujitsu.com>
References: <4E38C314.8070305@cn.fujitsu.com>
	<CANejiEViuKky1A7Xh0MQKBVNMj_fgzwayWyON7hFGfP3wa62SQ@mail.gmail.com>
	<4E3902C7.9050907@cn.fujitsu.com>
	<CANejiEVqFt4j1-qTVnxEAe75z0y010s=ST2XtCDDTqDEQT=EcQ@mail.gmail.com>
	<4E391986.90108@cn.fujitsu.com>
	<20110803154533.GB32385@redhat.com>
	<20110803175101.GC32385@redhat.com>
	<CANejiEXAtzExExqmTXA=hmpGh8DVVo9ncbRMdkB+avq+G3LuqQ@mail.gmail.com>
	<4E39FD41.4090103@cn.fujitsu.com>
Date: Thu, 4 Aug 2011 11:14:09 +0800
X-Google-Sender-Auth: cqzLPI1Ike0vxB4cObJHFHuaahk
Message-ID: <CANejiEVh4hvi5S18H7XHihxZt+JcRU7W5MGpQwQc_ZtiFCa2jw@mail.gmail.com>
Subject: Re: fio posixaio performance problem
From: Shaohua Li <shli@kernel.org>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <jaxboe@fusionio.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

在 2011年8月4日 上午10:00，Gui Jianfeng <guijianfeng@cn.fujitsu.com> 写道：
> On 2011-8-4 8:53, Shaohua Li wrote:
>> 2011/8/4 Vivek Goyal <vgoyal@redhat.com>:
>>> On Wed, Aug 03, 2011 at 11:45:33AM -0400, Vivek Goyal wrote:
>>>> On Wed, Aug 03, 2011 at 05:48:54PM +0800, Gui Jianfeng wrote:
>>>>> On 2011-8-3 16:22, Shaohua Li wrote:
>>>>>> 2011/8/3 Gui Jianfeng <guijianfeng@cn.fujitsu.com>:
>>>>>>> On 2011-8-3 15:38, Shaohua Li wrote:
>>>>>>>> 2011/8/3 Gui Jianfeng <guijianfeng@cn.fujitsu.com>:
>>>>>>>>> Hi,
>>>>>>>>>
>>>>>>>>> I ran a fio test to simulate qemu-kvm io behaviour.
>>>>>>>>> When job number is greater than 2, IO performance is
>>>>>>>>> really bad.
>>>>>>>>>
>>>>>>>>> 1 thread: aggrb=15,129KB/s
>>>>>>>>> 4 thread: aggrb=1,049KB/s
>>>>>>>>>
>>>>>>>>> Kernel: lastest upstream
>>>>>>>>>
>>>>>>>>> Any idea?
>>>>>>>>>
>>>>>>>>> ---
>>>>>>>>> [global]
>>>>>>>>> runtime=30
>>>>>>>>> time_based=1
>>>>>>>>> size=1G
>>>>>>>>> group_reporting=1
>>>>>>>>> ioengine=posixaio
>>>>>>>>> exec_prerun='echo 3 > /proc/sys/vm/drop_caches'
>>>>>>>>> thread=1
>>>>>>>>>
>>>>>>>>> [kvmio-1]
>>>>>>>>> description=kvmio-1
>>>>>>>>> numjobs=4
>>>>>>>>> rw=write
>>>>>>>>> bs=4k
>>>>>>>>> direct=1
>>>>>>>>> filename=/mnt/sda4/1G.img
>>>>>>>> Hmm, the test runs always about 15M/s at my side regardless how many threads.
>>>>>>>
>>>>>>> CFQ？
>>>>>> yes.
>>>>>>
>>>>>>> what's the slice_idle value?
>>>>>> default value. I didn't change it.
>>>>>
>>>>> Hmm, I use a sata disk, and can reproduce this bug every time...
>>>>
>>>> Do you have blktrace of run with 4 jobs?
>>>
>>> I can't reproduce it too. On my sata disk single thread is getting around
>>> 23-24MB/s and 4 threads get around 19-20MB/sec. Some of the throughput
>>> is gone into seeking so that is expected.
>>>
>>> I think what you are trying to point out is idling issue. In your workload
>>> every thread is doing sync-idle IO. So idling is enabled on each thread.
>>> On my system I see that next thread preempts the current idle thread
>>> because they all are doing IO in nearby area of file and rq_close() is
>>> true hence preemption is allowed.
>>>
>>> On your system, I think somehow rq_close() is not true hence preemption
>>> does not take place and we continue to idle on that thread. That also
>>> is not necessarily too bad but it might be happening that we are waiting
>>> for completion of IO from some other thread before this thread (we are
>>> idling on) can do more writes due to some filesystem rescrition and
>>> that can lead to sudden throughput drop. blktrace will give some idea.
>> with idle, the workload fallbacks like the one thread case, I don't
>> expect so big reduction.
>> I saw some back seek in the workload because we have rq_close() preempt here.
>> is it possible back seek penality in the disk is big?
>
> Shaohua,
>
> what do you mean "back seek penality" here. AFAIK, back seek penality only happens
> when choosing next request to serve. Is there anything to do with preemption logic?
oh, not related per your blktrace. so we have two problems here:
1. fio doesn't dispatch request in 8ms.
2. no close request preempt.
both looks quite wield. can you post a longer blktrace output, like
for one second? the piece is too short.
and do you have anything others running?
