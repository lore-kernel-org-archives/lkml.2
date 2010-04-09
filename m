Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab0DIP0J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 11:26:09 -0400
Received: from smtp-out.google.com ([74.125.121.35]:29230 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967Ab0DIP0G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 11:26:06 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:from:date:message-id:
	subject:to:cc:content-type:content-transfer-encoding:x-system-of-record;
	b=jLd0gUsfVMBBBV7NvBDfwKN0wA8pF/khim9JhSU0r4DjXcOz1bxXnxPJQagzlAPAR
	gr/tchAktRmlDpTWcEEBg==
MIME-Version: 1.0
In-Reply-To: <20100409140950.GC27573@redhat.com>
References: <20100409021054.13511.52377.stgit@austin.mtv.corp.google.com> 
	<20100409140950.GC27573@redhat.com>
From: Divyesh Shah <dpshah@google.com>
Date: Fri, 9 Apr 2010 08:25:42 -0700
Message-ID: <z2naf41c7c41004090825ne841e288jb9dad93f00b4b773@mail.gmail.com>
Subject: Re: [PATCH] cfq-iosched: Fix the incorrect timeslice accounting with 
	forced_dispatch.
To: Vivek Goyal <vgoyal@redhat.com>
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org, nauman@google.com,
       ctalbott@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 9, 2010 at 7:09 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Thu, Apr 08, 2010 at 07:19:00PM -0700, Divyesh Shah wrote:
>> When CFQ dispatches requests forcefully due to a barrier or changing iosched,
>> it runs through all cfqq's dispatching requests and then expires each queue.
>> However, it does not activate a cfqq before flushing its IOs resulting in
>> using stale values for computing slice_used.
>> This patch fixes it by calling activate queue before flushing reuqests from
>> each queue.
>>
>> This is useful mostly for barrier requests because when the iosched is changing
>> it really doesnt matter if we have incorrect accounting since we're going to
>> break down all structures anyway.
>>
>> We also now expire the current timeslice before moving on with the dispatch
>> to accurately account slice used for that cfqq.
>>
>> Signed-off-by: Divyesh Shah<dpshah@google.com>
>
> Thanks Divyesh. Looks good to me.
>
> Acked-by: Vivek Goyal <vgoyal@redhat.com>
>
>> ---
>> Side question that is related:
>> (W/o the change to expire the current timeslice) If there is a currently active
>> queue which has no requests pending and is idling and we enter forced_dispatch,
>> it seems to me that it is pure chance that we are not hitting the BUG_ON for
>> cfqd->busy_queues in cfq_forced_dispatch(). The current active queue (which is
>> on rr and included in the busy_queues count) can appear in any order from
>> get_next_queue_forced() and it may well happen that all non-empty cfqqs were
>> dispatched from before it and by the time we get to this queue cfqd->rq_queued
>> goes down to zero and we bail out. Hence, __cfq_slice_expired() never gets
>> called for this cfqq and it is not taken off from rr which should result in
>> cfqd->busy_queues to be non-zero and the BUG_ON I mentioned earlier should be
>> hit.
>> Does this sound correct?
>
> I think cfq_slice_expired() is covering that case (in a non-intutive way).
>
> So even if you are idling on an empty queue when we start forced dispatch, it
> will continue to remain the active queue (because during flush of other queues,
> we are not making them active queues). And once the flush is over, we will call
> cfq_slice_expired() which will expire the active queue we were idling on.
>
> I suspect that additional cfq_slice_expired() call may be redundant now.

Yes that call after flushing all queues was redundant. It is not
anymore with this patch since I've moved it before the flush to expire
the current cfqq (and take it off from rr).

>
> Vivek
>
>>
>>  block/cfq-iosched.c |    7 +++++--
>>  1 files changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
>> index 9102ffc..39b9a36 100644
>> --- a/block/cfq-iosched.c
>> +++ b/block/cfq-iosched.c
>> @@ -2196,10 +2196,13 @@ static int cfq_forced_dispatch(struct cfq_data *cfqd)
>>       struct cfq_queue *cfqq;
>>       int dispatched = 0;
>>
>> -     while ((cfqq = cfq_get_next_queue_forced(cfqd)) != NULL)
>> +     /* Expire the timeslice of the current active queue first */
>> +     cfq_slice_expired(cfqd, 0);
>> +     while ((cfqq = cfq_get_next_queue_forced(cfqd)) != NULL) {
>> +             __cfq_set_active_queue(cfqd, cfqq);
>>               dispatched += __cfq_forced_dispatch_cfqq(cfqq);
>> +     }
>>
>> -     cfq_slice_expired(cfqd, 0);
>>       BUG_ON(cfqd->busy_queues);
>>
>>       cfq_log(cfqd, "forced_dispatch=%d", dispatched);
>
