Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662Ab0FKGdb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 02:33:31 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54149 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754659Ab0FKGd3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 02:33:29 -0400
Message-ID: <4C11D82C.50902@cn.fujitsu.com>
Date: Fri, 11 Jun 2010 14:31:08 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Divyesh Shah <dpshah@google.com>
CC: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <jens.axboe@oracle.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] io-controller: Add new interfaces to trace backlogged
 	group status
References: <4BF64712.1070500@cn.fujitsu.com> <20100521131751.GA15302@redhat.com> 	<4BF9D265.70008@cn.fujitsu.com> <20100524212207.GC28685@redhat.com> 	<4BFB29DB.10507@cn.fujitsu.com> <20100525020339.GA8214@redhat.com> 	<4BFB3D66.1080001@cn.fujitsu.com> <20100525132554.GA3310@redhat.com> <AANLkTikZSgnSqK_JMVqy9ncFse0EbZm8j4WTTcJ00hwL@mail.gmail.com>
In-Reply-To: <AANLkTikZSgnSqK_JMVqy9ncFse0EbZm8j4WTTcJ00hwL@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Divyesh Shah wrote:
> On Tue, May 25, 2010 at 6:25 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> On Tue, May 25, 2010 at 11:00:54AM +0800, Gui Jianfeng wrote:
>>> Vivek Goyal wrote:
>>>> On Tue, May 25, 2010 at 09:37:31AM +0800, Gui Jianfeng wrote:
>>>>> Vivek Goyal wrote:
>>>>>> On Mon, May 24, 2010 at 09:12:05AM +0800, Gui Jianfeng wrote:
>>>>>>> Vivek Goyal wrote:
>>>>>>>> On Fri, May 21, 2010 at 04:40:50PM +0800, Gui Jianfeng wrote:
>>>>>>>>> Hi,
>>>>>>>>>
>>>>>>>>> This series implements three new interfaces to keep track of tranferred bytes,
>>>>>>>>> elapsing time and io rate since group getting backlogged. If the group dequeues
>>>>>>>>> from service tree, these three interfaces will reset and shows zero.
>>>>>>>> Hi Gui,
>>>>>>>>
>>>>>>>> Can you give some details regarding how this functionality is useful? Why
>>>>>>>> would somebody be interested in only in stats of till group was
>>>>>>>> backlogged and not in total stats?
>>>>>>>>
>>>>>>>> Groups can come and go so fast and these stats will reset so many times
>>>>>>>> that I am not able to visualize how these stats will be useful.
>>>>>>> Hi Vivek,
>>>>>>>
>>>>>>> Currently, we assign weight to a group, but user still doesn't know how fast the
>>>>>>> group runs. With io rate interface, users can check the rate of a group at any
>>>>>>> moment, or to determine whether the weight assigned to a group is enough.
>>>>>>> bytes and time interface is just for debug purpose.
>>>>>> Gui,
>>>>>>
>>>>>> I still don't understand that why blkio.sectors or blkio.io_service_bytes
>>>>>> or blkio.io_serviced interfaces are not good enough to determine at what
>>>>>> rate a group is doing IO.
>>>>>>
>>>>>> I think we can very well write something in userspace like "iostat" to
>>>>>> display the per group rate. Utility can read the any of the above files
>>>>>> say at the interfval of 1s, calculate the diff between the values and
>>>>>> display that as group effective rate.
>>>>> Hi Vivek,
>>>>>
>>>>> blkio.io_active_rate reflects the rate since group get backlogged, so the rate is a smooth
>>>>> value. This value represents the actual rate a group runs. IMO, io rate calculated from
>>>>> user space is not accurate in following two scenarios:
>>>>>
>>>>> 1 Userspace app chooses the interval of 1s, if 0.5s is backlogged and 0.5s is not, the
>>>>>   rate calculated in this interval doesn't make sense.
>>>>>
>>>> If you are not servicing groups for long time, anyway it is very bad for
>>>> latency. So that's why soft limit of 300ms of CFQ makes sense and
>>>> practically I am not sure you will be blocking groups for .5s.
>>>>
>>>> Even if you do, then user just needs to choose a bigger interval and you
>>>> will see more smooth rates. Reduce the interval and you might see little
>>>> bursty rate.
>>> Vivek,
>>>
>>> IIUC, the most big problem for user app is the user app doesn't know how long
>>> the group has been dequeued during the interval. For example, user choose
>>> 10s interval, 8s of which is not backlogged, but when user app calculates
>>> io rate, this 8s still include. So this rate isn't what we want. Am i missing
>>> something?
>> Gui,
>>
>> If user application is not doing enough IO and group is getting deleted
>> fast, io_active_rate is not going to give you any meaningful data as it
>> will be lost the moment group gets deleted.
>>
>> Hence one needs to monitor the IO rate when a workload is running and is
>> keeping disk busy more or less all the time.
>>
>> Even in your example, if you monitored IO rate over 10 second interval and
>> group is not doing any IO, you just can't do anything about it. Just that
>> your measurement e method is wrong. Even io_active_rate will not help you
>> here as by the time you read the file, group is gone and there is no data.
>>
>> The very reason you want to monitor rate is that you want to make sure
>> group is getting enough BW. If group is not doing IO then one can look at
>> blkio.dequeue file and see if group is getting deleted too frequently. If
>> yes, that means group is not doing enough IO to keep the disk busy. One
>> can also try increasing the weight of the group but that will not help
>> much if group does not remain backlogged for significant amount of time.
>>
>>> "io_active_rate" will never take un-backlogged time into account when calculating
>>> io rate.
>>>
>> Theoritically blkio.sectors/blkio.time gives the rate excluding the time
>> when group was not backlogged?
> 
> I agree with Vivek here. We use blkio.time as a source for io rate
> count for each cgroup, knowing that it is not entirely accurate but a
> good enough approximation.
> 
> Gui, if you want to find out whether the cgroup has enough weight or
> not, I'd recommend looking at the wait_time stat in addition to
> blkio.time. It has been very useful in identifying jobs that are not
> getting enough IO done due to less weight assigned to them.

Ok, see. :)

Thanks,
Gui

> 
>> But I will not recommend using blkio.time as it is very approximate.
>>
>> I really am not able to see what this interface is really buying you.
>>
>> Thanks
>> Vivek
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
> 
