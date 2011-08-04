Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910Ab1HDIfk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 04:35:40 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51603 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752596Ab1HDIfh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 04:35:37 -0400
Message-ID: <4E3A59DD.6010907@cn.fujitsu.com>
Date: Thu, 04 Aug 2011 16:35:41 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Shaohua Li <shli@kernel.org>
CC: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <jaxboe@fusionio.com>,
        linux-kernel@vger.kernel.org
Subject: Re: fio posixaio performance problem
References: <4E38C314.8070305@cn.fujitsu.com> <CANejiEViuKky1A7Xh0MQKBVNMj_fgzwayWyON7hFGfP3wa62SQ@mail.gmail.com> <4E3902C7.9050907@cn.fujitsu.com> <CANejiEVqFt4j1-qTVnxEAe75z0y010s=ST2XtCDDTqDEQT=EcQ@mail.gmail.com> <4E391986.90108@cn.fujitsu.com> <20110803154533.GB32385@redhat.com> <20110803175101.GC32385@redhat.com> <CANejiEXAtzExExqmTXA=hmpGh8DVVo9ncbRMdkB+avq+G3LuqQ@mail.gmail.com> <4E39FD41.4090103@cn.fujitsu.com> <CANejiEVh4hvi5S18H7XHihxZt+JcRU7W5MGpQwQc_ZtiFCa2jw@mail.gmail.com> <4E3A4DF7.3020605@cn.fujitsu.com> <CANejiEXkv75kVxTS2w-v2GHZZRdmOR8HXUY16-eas9M45ZKqKg@mail.gmail.com>
In-Reply-To: <CANejiEXkv75kVxTS2w-v2GHZZRdmOR8HXUY16-eas9M45ZKqKg@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-04 16:34:20,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-04 16:34:25
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-8-4 16:25, Shaohua Li wrote:
> 在 2011年8月4日 下午3:44，Gui Jianfeng <guijianfeng@cn.fujitsu.com> 写道：
>> On 2011-8-4 11:14, Shaohua Li wrote:
>>> 在 2011年8月4日 上午10:00，Gui Jianfeng <guijianfeng@cn.fujitsu.com> 写道：
>>>> On 2011-8-4 8:53, Shaohua Li wrote:
>>>>> 2011/8/4 Vivek Goyal <vgoyal@redhat.com>:
>>>>>> On Wed, Aug 03, 2011 at 11:45:33AM -0400, Vivek Goyal wrote:
>>>>>>> On Wed, Aug 03, 2011 at 05:48:54PM +0800, Gui Jianfeng wrote:
>>>>>>>> On 2011-8-3 16:22, Shaohua Li wrote:
>>>>>>>>> 2011/8/3 Gui Jianfeng <guijianfeng@cn.fujitsu.com>:
>>>>>>>>>> On 2011-8-3 15:38, Shaohua Li wrote:
>>>>>>>>>>> 2011/8/3 Gui Jianfeng <guijianfeng@cn.fujitsu.com>:
>>>>>>>>>>>> Hi,
>>>>>>>>>>>>
>>>>>>>>>>>> I ran a fio test to simulate qemu-kvm io behaviour.
>>>>>>>>>>>> When job number is greater than 2, IO performance is
>>>>>>>>>>>> really bad.
>>>>>>>>>>>>
>>>>>>>>>>>> 1 thread: aggrb=15,129KB/s
>>>>>>>>>>>> 4 thread: aggrb=1,049KB/s
>>>>>>>>>>>>
>>>>>>>>>>>> Kernel: lastest upstream
>>>>>>>>>>>>
>>>>>>>>>>>> Any idea?
>>>>>>>>>>>>
>>>>>>>>>>>> ---
>>>>>>>>>>>> [global]
>>>>>>>>>>>> runtime=30
>>>>>>>>>>>> time_based=1
>>>>>>>>>>>> size=1G
>>>>>>>>>>>> group_reporting=1
>>>>>>>>>>>> ioengine=posixaio
>>>>>>>>>>>> exec_prerun='echo 3 > /proc/sys/vm/drop_caches'
>>>>>>>>>>>> thread=1
>>>>>>>>>>>>
>>>>>>>>>>>> [kvmio-1]
>>>>>>>>>>>> description=kvmio-1
>>>>>>>>>>>> numjobs=4
>>>>>>>>>>>> rw=write
>>>>>>>>>>>> bs=4k
>>>>>>>>>>>> direct=1
>>>>>>>>>>>> filename=/mnt/sda4/1G.img
>>>>>>>>>>> Hmm, the test runs always about 15M/s at my side regardless how many threads.
>>>>>>>>>>
>>>>>>>>>> CFQ？
>>>>>>>>> yes.
>>>>>>>>>
>>>>>>>>>> what's the slice_idle value?
>>>>>>>>> default value. I didn't change it.
>>>>>>>>
>>>>>>>> Hmm, I use a sata disk, and can reproduce this bug every time...
>>>>>>>
>>>>>>> Do you have blktrace of run with 4 jobs?
>>>>>>
>>>>>> I can't reproduce it too. On my sata disk single thread is getting around
>>>>>> 23-24MB/s and 4 threads get around 19-20MB/sec. Some of the throughput
>>>>>> is gone into seeking so that is expected.
>>>>>>
>>>>>> I think what you are trying to point out is idling issue. In your workload
>>>>>> every thread is doing sync-idle IO. So idling is enabled on each thread.
>>>>>> On my system I see that next thread preempts the current idle thread
>>>>>> because they all are doing IO in nearby area of file and rq_close() is
>>>>>> true hence preemption is allowed.
>>>>>>
>>>>>> On your system, I think somehow rq_close() is not true hence preemption
>>>>>> does not take place and we continue to idle on that thread. That also
>>>>>> is not necessarily too bad but it might be happening that we are waiting
>>>>>> for completion of IO from some other thread before this thread (we are
>>>>>> idling on) can do more writes due to some filesystem rescrition and
>>>>>> that can lead to sudden throughput drop. blktrace will give some idea.
>>>>> with idle, the workload fallbacks like the one thread case, I don't
>>>>> expect so big reduction.
>>>>> I saw some back seek in the workload because we have rq_close() preempt here.
>>>>> is it possible back seek penality in the disk is big?
>>>>
>>>> Shaohua,
>>>>
>>>> what do you mean "back seek penality" here. AFAIK, back seek penality only happens
>>>> when choosing next request to serve. Is there anything to do with preemption logic?
>>> oh, not related per your blktrace. so we have two problems here:
>>> 1. fio doesn't dispatch request in 8ms.
>>> 2. no close request preempt.
>>
>> Yes, these're actual factors why performance is so bad.
>>
>>> both looks quite wield. can you post a longer blktrace output, like
>>> for one second? the piece is too short.
>>
>> Attached.
>>
>>> and do you have anything others running?
>>
>> No.
> looks the system does a write in every 8ms. This is quite wrong. does
> the posixaio
> engine have something wrong? can you use a new fio or try libaio please.

Yes, I also highly suspect that fio's posixaio engine works bad.
On the other hand, I'm not sure why preempting in cfqs doesn't happen.
It seems requests from different threads is close enough...

Thanks,
Gui

> 
> Thanks,
> Shaohua
> 
> 


