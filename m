Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350Ab1CNVzw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 17:55:52 -0400
Received: from smtp-out.google.com ([74.125.121.67]:24609 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755825Ab1CNVzv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 17:55:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=yOJ2B46UKKYONGatOhhQ2LNyrCa7ndEOk+i5NiG8NjoSPB+OveeEubSnfXG5YMKe1z
         wnyX5sF46IBDp5+xTXOw==
MIME-Version: 1.0
In-Reply-To: <20110314135516.GA31120@redhat.com>
References: <1299877572-30353-1-git-send-email-teravest@google.com> <20110314135516.GA31120@redhat.com>
From: Justin TerAvest <teravest@google.com>
Date: Mon, 14 Mar 2011 14:55:27 -0700
Message-ID: <AANLkTi=UwYRUkZ4WjqU3eiFcnmW4KnnB4xNBanopip9S@mail.gmail.com>
Subject: Re: [PATCH] Add unaccounted time to timeslice_used.
To: Vivek Goyal <vgoyal@redhat.com>
Cc: jaxboe@fusionio.com, ctalbott@google.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 14, 2011 at 6:55 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Fri, Mar 11, 2011 at 01:06:12PM -0800, Justin TerAvest wrote:
>> There are two kind of times that tasks are not charged for: the first
>> seek and the extra time slice used over the allocated timeslice. Both
>> of these exported as a new unaccounted_time stat.
>>
>> I think it would be good to have this reported in 'time' as well, but
>> that is probably a separate discussion.
>>
>
> Justin,
>
> I would say that for such optimization do make sure that you mention that
> these are useful only if one is driving a queue depth of 1.

Hi Vivek,

That's a good point. I should have mentioned that.

>
> Otherwise previous queue might have dumped bunch of requests in device
> and expired. Now new queue's first request completion time is also
> impacted by the requests dumped by other queues.
>
> There are already so many stats which I have never used so far and I have
> not encountered anybody else using these either. I think primary reason
> being that in general nobody forced the queue depth of 1 hence most of the
> timing stats are of no use.

We could probably put the data collected here back into "time"
eventually, but having it separate right now helps build confidence in
the accuracy of the stats.

>
> So personally I am not very keen on keep on increasing number of stats in
> CFQ which are useful only when using queue depth 1 as that might not be
> the common case. But Jens likes it, so....
>
> Also a comment inline.
>
> [..]
>> @@ -3314,9 +3321,7 @@ static void cfq_preempt_queue(struct cfq_data *cfqd, struct cfq_queue *cfqq)
>>       BUG_ON(!cfq_cfqq_on_rr(cfqq));
>>
>>       cfq_service_tree_add(cfqd, cfqq, 1);
>> -
>> -     cfqq->slice_end = 0;
>> -     cfq_mark_cfqq_slice_new(cfqq);
>> +     __cfq_set_active_queue(cfqd, cfqq);
>
> So far a new queue selection was always in select_queue(). Now this will
> change it and new queue selection will also take place in
> cfq_preempt_queue().
>
> Also I think this is not right. It is not necessary that we select the
> preempting queue. For example a sync queue in one group can preempt the
> async in root group but it might happen that we still select again
> the root group's sync queue for dispatch.
>
> So queue selection logic should be driven by select_queue() which selects
> group first then workload with-in group and then queue with-in workload
> and we shoud not be setting active queue here.

That sounds reasonable. I will send out another version of the patch
that will only clear the stats for the cfqq.

Thanks,
Justin

>
> Thanks
> Vivek
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
