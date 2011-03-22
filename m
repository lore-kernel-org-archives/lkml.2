Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932431Ab1CVV7M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 17:59:12 -0400
Received: from smtp-out.google.com ([216.239.44.51]:47734 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932353Ab1CVV7K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 17:59:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=vv5HkNBMhQDUH9AcyJtMCGcGDdhzqWB31iNH5AhLzdUs3yufj+fomi5fHinQljwroP
         xXLIm1G3ACwzxSsCwTXQ==
MIME-Version: 1.0
In-Reply-To: <20110322205905.GM3757@redhat.com>
References: <1300825050-11371-1-git-send-email-teravest@google.com>
 <1300825050-11371-2-git-send-email-teravest@google.com> <20110322205905.GM3757@redhat.com>
From: Justin TerAvest <teravest@google.com>
Date: Tue, 22 Mar 2011 14:58:48 -0700
Message-ID: <AANLkTi=GcnW2JCrc0JE4+y5PwSgNjcaquEn-btydS4NT@mail.gmail.com>
Subject: Re: [PATCH 1/2] cfq-iosched: Don't set active queue in preempt
To: Vivek Goyal <vgoyal@redhat.com>
Cc: jaxboe@fusionio.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 1:59 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Tue, Mar 22, 2011 at 01:17:29PM -0700, Justin TerAvest wrote:
>> Commit "Add unaccounted time to timeslice_used" changed the behavior of
>> cfq_preempt_queue to set cfqq active. Vivek pointed out that other
>> preemption rules might get involved, so we shouldn't manually set which
>> queue is active.
>>
>> This cleans up the code to just clear the queue stats at preemption
>> time.
>>
>> Signed-off-by: Justin TerAvest <teravest@google.com>
>> ---
>>  block/cfq-iosched.c |   39 +++++++++++++++++++++++----------------
>>  1 files changed, 23 insertions(+), 16 deletions(-)
>>
>> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
>> index 12e380b..69208d7 100644
>> --- a/block/cfq-iosched.c
>> +++ b/block/cfq-iosched.c
>> @@ -1620,27 +1620,33 @@ static inline void cfq_del_timer(struct cfq_data *cfqd, struct cfq_queue *cfqq)
>>       cfq_blkiocg_update_idle_time_stats(&cfqq->cfqg->blkg);
>>  }
>>
>> +static void cfq_clear_queue_stats(struct cfq_data *cfqd,
>> +                               struct cfq_queue *cfqq)
>> +{
>> +     cfq_blkiocg_update_avg_queue_size_stats(&cfqq->cfqg->blkg);
>> +     cfqq->slice_start = 0;
>> +     cfqq->dispatch_start = jiffies;
>> +     cfqq->allocated_slice = 0;
>> +     cfqq->slice_end = 0;
>> +     cfqq->slice_dispatch = 0;
>> +     cfqq->nr_sectors = 0;
>> +
>> +     cfq_clear_cfqq_wait_request(cfqq);
>> +     cfq_clear_cfqq_must_dispatch(cfqq);
>> +     cfq_clear_cfqq_must_alloc_slice(cfqq);
>> +     cfq_clear_cfqq_fifo_expire(cfqq);
>> +     cfq_mark_cfqq_slice_new(cfqq);
>> +
>> +     cfq_del_timer(cfqd, cfqq);
>> +}
>> +
>>  static void __cfq_set_active_queue(struct cfq_data *cfqd,
>>                                  struct cfq_queue *cfqq)
>>  {
>>       if (cfqq) {
>>               cfq_log_cfqq(cfqd, cfqq, "set_active wl_prio:%d wl_type:%d",
>>                               cfqd->serving_prio, cfqd->serving_type);
>> -             cfq_blkiocg_update_avg_queue_size_stats(&cfqq->cfqg->blkg);
>> -             cfqq->slice_start = 0;
>> -             cfqq->dispatch_start = jiffies;
>> -             cfqq->allocated_slice = 0;
>> -             cfqq->slice_end = 0;
>> -             cfqq->slice_dispatch = 0;
>> -             cfqq->nr_sectors = 0;
>> -
>> -             cfq_clear_cfqq_wait_request(cfqq);
>> -             cfq_clear_cfqq_must_dispatch(cfqq);
>> -             cfq_clear_cfqq_must_alloc_slice(cfqq);
>> -             cfq_clear_cfqq_fifo_expire(cfqq);
>> -             cfq_mark_cfqq_slice_new(cfqq);
>> -
>> -             cfq_del_timer(cfqd, cfqq);
>> +             cfq_clear_queue_stats(cfqd, cfqq);
>>       }
>>
>>       cfqd->active_queue = cfqq;
>> @@ -3332,7 +3338,8 @@ static void cfq_preempt_queue(struct cfq_data *cfqd, struct cfq_queue *cfqq)
>>       BUG_ON(!cfq_cfqq_on_rr(cfqq));
>>
>>       cfq_service_tree_add(cfqd, cfqq, 1);
>> -     __cfq_set_active_queue(cfqd, cfqq);
>> +
>> +     cfq_clear_queue_stats(cfqd, cfqq);
>
> Hi Justin,
>
> Why do we have to clear queue stats here for the preempting queue?
>
> Especially look at cfqq->dispatch_start = jiffies. We have not started
> the dispatch yet. When this queue is selected next, then we will start
> the dispatch.
>
> So this patch has introduced another bug now. Now after preemption if
> we don't select this group, then we have a queue with wrong dispatch
> start and that will result in huge slice_used for the queue and
> it will not get its fair share.

Hi Vivek,

Ugh, you're right. Sorry, I had some bad ideas in my head for how
preemption worked that clearly aren't true.
I think that if the stats aren't cleared here, everything should then
be fine because jiffies will then be picked up when the active queue
is set. Does that sound sane to you?

Thanks for explaining this problem.

Justin

>
> Thanks
> Vivek
>
