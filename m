Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508Ab0KINwO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 08:52:14 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:45484 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751439Ab0KINwM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 08:52:12 -0500
Message-ID: <4CD9520A.9020906@fusionio.com>
Date: Tue, 09 Nov 2010 14:52:10 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Shaohua Li <shaohua.li@intel.com>
CC: Vivek Goyal <vgoyal@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
        "czoccolo@gmail.com" <czoccolo@gmail.com>
Subject: Re: [patch 2/3]cfq-iosched: schedule dispatch for noidle queue
References: <1289182038.23014.190.camel@sli10-conroe>	 <20101108142842.GC16767@redhat.com>	 <1289266267.23014.196.camel@sli10-conroe>	 <20101109021540.GA29210@redhat.com>	 <1289269716.23014.208.camel@sli10-conroe>	 <20101109023919.GB29847@redhat.com> <1289271496.23014.213.camel@sli10-conroe>
In-Reply-To: <1289271496.23014.213.camel@sli10-conroe>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-11-09 03:58, Shaohua Li wrote:
> On Tue, 2010-11-09 at 10:39 +0800, Vivek Goyal wrote:
>> On Tue, Nov 09, 2010 at 10:28:36AM +0800, Shaohua Li wrote:
>>
>> [..]
>>>>>> Why do we have to wait for all requests to finish in device? Will driver
>>>>>> most likely not ask for next request when 1-2 requests have completed
>>>>>> and at that time we should expire the queue if queue is no more marked
>>>>>> as "noidle"?
>>>>> The issue is a queue is idle just because it's the last queue of the
>>>>> service tree. Then a new queue is added and the idled queue should not
>>>>> idle now. we should preempt the idled queue soon. does this make sense
>>>>> to you?
>>>>
>>>> If that's the case then you should just modify should_preempt() so that
>>>> addition of a new queue could preempt an empty queue which has now become
>>>> noidle.
>>>>
>>>> You have also modified cfq_completed_request() function, which will wake
>>>> up the worker thread and then try to dispatch a request. IMHO, in practice
>>>> driver asks for new request almost immediately and you don't gain much
>>>> by this additional wakeup.
>>>>
>>>> So my point being, that we increased the code complexity for no visible
>>>> performance improvement also increased thread wakeups resulting in more
>>>> cpu consumption.
>>> Ah, you are right, we only need modify should_preempt. Updated the patch as below.
>>>
>>
>> Thanks. Jens has already applied the patches on for-2.6.38/core branch of
>> block tree. I think you shall have to generate an incremental patch
>> which revert the bits introduced in cfq_completed_request().
> Jens, how to handle this? if you want to an incremental patch, here it
> is.
> 
> Subject: cfq-iosched: don't schedule a dispatch for a non-idle queue
> 
> Vivek suggests we don't need schedule a dispatch when an idle queue
> becomes nonidle. And he is right, cfq_should_preempt already covers
> the logic.

Thanks Vivek, I agree with your analysis. I have applied this one as well.

-- 
Jens Axboe

