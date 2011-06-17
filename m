Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759195Ab1FQOer (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 10:34:47 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:50886 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759172Ab1FQOeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 10:34:46 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=tao.ma;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=YZKSrxLAMKkC7iILnIO5VM2XUAuWJoHuaIUabuX7DaYcKoQBD+y3d+yKT1dJgm8gIvYCLBNE7TIQh8ZxlnBQ1rVmaR1WW2w9GuaQCKO2ZmC1bWQXoeb7anVcqYgHEFp2;
Message-ID: <4DFB65F7.1060703@tao.ma>
Date: Fri, 17 Jun 2011 22:34:31 +0800
From: Tao Ma <tm@tao.ma>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: CFQ: async queue blocks the whole system
References: <20110609141451.GD29913@redhat.com> <4DF0DD0F.8090407@tao.ma> <20110609153738.GF29913@redhat.com> <4DF0EA55.10209@tao.ma> <20110609182706.GG29913@redhat.com> <4DF1B035.7080009@tao.ma> <20110610091427.GB4183@redhat.com> <4DF1EB45.1070706@tao.ma> <20110610154414.GA31853@redhat.com> <4DFAC453.70806@tao.ma> <20110617125015.GA8169@redhat.com>
In-Reply-To: <20110617125015.GA8169@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 114.254.74.68 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2011 08:50 PM, Vivek Goyal wrote:
> On Fri, Jun 17, 2011 at 11:04:51AM +0800, Tao Ma wrote:
>> Hi Vivek,
>> On 06/10/2011 11:44 PM, Vivek Goyal wrote:
>>> On Fri, Jun 10, 2011 at 06:00:37PM +0800, Tao Ma wrote:
>>>> On 06/10/2011 05:14 PM, Vivek Goyal wrote:
>>>>> On Fri, Jun 10, 2011 at 01:48:37PM +0800, Tao Ma wrote:
>>>>>
>>>>> [..]
>>>>>>>> btw, reverting the patch doesn't work. I can still get the livelock.
>>>>>
>>>>> What test exactly you are running. I am primarily interested in whether
>>>>> you still get the hung task timeout warning where a writer is waiting on
>>>>> get_request_wait() for more than 120 secods or not.
>>>>>
>>>>> Livelock might be a different problem and for which Christoph provided
>>>>> a patch for XFS.
>>>>>
>>>>>>>
>>>>>>> Can you give following patch a try and see if it helps. On my system this
>>>>>>> does allow CFQ to dispatch some writes once in a while.
>>>>>> Sorry, this patch doesn't work in my test.
>>>>>
>>>>> Can you give me backtrace of say 15 seconds each with and without patch.
>>>>> I think now we must be dispatching some writes, that's a different thing
>>>>> that writer still sleeps more than 120 seconds because there are  way
>>>>> too many readers.
>>>>>
>>>>> May be we need to look into show workload tree scheduling takes place and
>>>>> tweak that logic a bit.
>>>> OK, our test cases can be downloaded for free. ;)
>>>> svn co http://code.taobao.org/svn/dirbench/trunk/meta_test/press/set_vs_get
>>>> Modify run.sh to be fit for your need. Normally within 10 mins, you will
>>>> get the livelock. We have a SAS disk with 15000 RPMs.
>>>>
>>>> btw, you have to mount the volume on /test since the test program are
>>>> not that clever. :)
>>>
>>> Thanks for the test program. System keeps on working, that's a different
>>> thing that writes might not make lot of progress. 
>>>
>>> What do you mean by livelock in your case. How do you define that?
>>>
>>> Couple of times I did see hung_task warning with your test. And I also
>>> saw that we have most of the time starved WRITES but one in a while we
>>> will dispatch some writes.
>>>
>>> Having said that I will still admit that current logic can completely
>>> starve async writes if there are sufficient number of readers. I can
>>> reproduce this simply by launching lots of readers and bunch of writers
>>> using fio.
>>>
>>> So I have written another patch, where I don't allow preemption of 
>>> async queue if it waiting for sync requests to drain and has not
>>> dispatched any request after having been scheduled.
>>>
>>> This atleast makes sure that writes are not starved. But that does not
>>> mean that whole bunch of async writes are dispatched. In presence of
>>> lots of read activity, expect 1 write to be dispatched every few seconds.
>>>
>>> Please give this patch a try and if it still does not work, please upload
>>> some bltraces while test is running.
>>>
>>> You can also run iostat on disk and should be able to see that with
>>> the patch you are dispatching writes more often than before.
>> I am testing your patch heavily these days.
>> With this patch, the workload is better to survive. But in some our test
>> machines we can still find the hung task. After we tune slice_idle to 0,
>> it is OK now. So do you think this tuning is valid?
> 
> By slice_idle=0 you turn off the idling and that's the core of the CFQ.
> So practically you have more deadline like behavior.
Sure, but as our original test without this patch doesn't survive even
in slice_idle = 0, so I guess this patch does improve somehow in our
test. ;)
> 
>>
>> btw do you think the patch is the final version? We have some plans of
>> carrying it in our product system to see whether it works.
> 
> If this patch is helping, I will do some testing with single reader and
> multiple writers and see how badly does it impact reader in that case.
> If it is not too bad, may be it is reasonable to include this patch.
cool, btw you can add my Reported-and-Tested-by.

Thanks
Tao
> 
> Thanks
> Vivek
> 
>>
>> Regards,
>> Tao
>>>
>>> Thanks
>>> Vivek
>>>
>>> ---
>>>  block/cfq-iosched.c |    9 ++++++++-
>>>  1 file changed, 8 insertions(+), 1 deletion(-)
>>>
>>> Index: linux-2.6/block/cfq-iosched.c
>>> ===================================================================
>>> --- linux-2.6.orig/block/cfq-iosched.c	2011-06-10 09:13:01.000000000 -0400
>>> +++ linux-2.6/block/cfq-iosched.c	2011-06-10 10:02:31.850831735 -0400
>>> @@ -3315,8 +3315,15 @@ cfq_should_preempt(struct cfq_data *cfqd
>>>  	 * if the new request is sync, but the currently running queue is
>>>  	 * not, let the sync request have priority.
>>>  	 */
>>> -	if (rq_is_sync(rq) && !cfq_cfqq_sync(cfqq))
>>> +	if (rq_is_sync(rq) && !cfq_cfqq_sync(cfqq)) {
>>> +		/*
>>> +		 * Allow atleast one dispatch otherwise this can repeat
>>> +		 * and writes can be starved completely
>>> +		 */
>>> +		if (!cfqq->slice_dispatch)
>>> +			return false;
>>>  		return true;
>>> +	}
>>>  
>>>  	if (new_cfqq->cfqg != cfqq->cfqg)
>>>  		return false;
>>>

