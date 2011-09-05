Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427Ab1IEMsb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 08:48:31 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:3348 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab1IEMsZ (ORCPT
	<rfc822;groupwise-SJayaraman@suse.com:0:0>);
	Mon, 5 Sep 2011 08:48:25 -0400
Message-ID: <4E64C4B9.5060201@suse.de>
Date: Mon, 05 Sep 2011 18:16:49 +0530
From: Suresh Jayaraman <sjayaraman@suse.de>
Reply-To: sjayaraman@suse.de
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110616 SUSE/3.1.11 Thunderbird/3.1.11
MIME-Version: 1.0
To: Shaohua Li <shaohua.li@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
        LKML <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH v2] block: document blk-plug
References: <4E5B77D5.7090006@suse.de>	 <20110829144843.c8e9d397.akpm@linux-foundation.org>	 <4E5C7359.7070602@suse.de> <1314687646.29510.52.camel@sli10-conroe>
In-Reply-To: <1314687646.29510.52.camel@sli10-conroe>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2011 12:30 PM, Shaohua Li wrote:
> On Tue, 2011-08-30 at 13:21 +0800, Suresh Jayaraman wrote:
>> On 08/30/2011 03:18 AM, Andrew Morton wrote:
>>> On Mon, 29 Aug 2011 16:58:21 +0530
>>> Suresh Jayaraman <sjayaraman@suse.de> wrote:
>>>
>>>> --- a/include/linux/blkdev.h
>>>> +++ b/include/linux/blkdev.h
>>>> @@ -863,17 +863,23 @@ struct request_queue *blk_alloc_queue_node(gfp_t, int);
>>>>  extern void blk_put_queue(struct request_queue *);
>>>>  
>>>>  /*
>>>> + * blk_plug allows to build up a queue of related requests by holding the I/O
>>>> + * fragments for a short period. This allows merging of sequential requests
>>>> + * into single larger request. As the requests are moved from per-task list to
>>>> + * the device's request_queue in a batch, this results in improved
>>>> + * scalability as the lock contention for request_queue lock is reduced.
>>>> + *
>>>>   * Note: Code in between changing the blk_plug list/cb_list or element of such
>>>>   * lists is preemptable, but such code can't do sleep (or be very careful),
>>>>   * otherwise data is corrupted. For details, please check schedule() where
>>>>   * blk_schedule_flush_plug() is called.
>>>
>>> What does the older part of this comment mean?  If a code section is
>>> preemptible then it *will* sleep.  That's what preemption does.
>>>
>>
>> From what I can understand, we don't need to explicitly disable preemption
>> when modifying the blk_plug->list because interrupts are disabled when we
>> are there.
>>
>> void blk_flush_plug_list(struct blk_plug *plug, bool from_schedule)
>> {
>>
>> ..
>>
>>         /*
>>          * Save and disable interrupts here, to avoid doing it for every
>>          * queue lock we have to take.
>>          */
>>         local_irq_save(flags);
>>         while (!list_empty(&list)) {
>>                 rq = list_entry_rq(list.next);
>>                 list_del_init(&rq->queuelist);
>>                 BUG_ON(!rq->q);
>>                 if (rq->q != q) {
>>                         /*
>>                          * This drops the queue lock
>>                          */
>>                         if (q)
>>                                 queue_unplugged(q, depth, from_schedule);
>>                         q = rq->q;
>>                         depth = 0;
>>                         spin_lock(q->queue_lock);
>>                 }
>>
>>
>> ..
>>
>> }
>>
>> When blk_flush_plug_list() is called from schedule() via
>> blk_schedule_flush_plug() we must be very careful to not cause
>> need_resched set and thus result in a preemption check?
>>
>> Does that what your comment intend to mean? Shaohua?
> the code adding request to the plug list and doing merge doesn't disable
> preempt. That is ok because blk_schedule_flush_plug() only flush the
> list when the task truly enters sleep (setting task->state non-running
> and call schedule()). That's why I mean the code can be preempted but
> can't do sleep.
> 

Sorry, I'm not sure I understood the above after reading it multiple times.

Yes, preemption is not disabled when adding request to the plug list and
doing merge. But, still there is a possibility of corruption for
instance - when we are doing list_add_tail() in __make_request(), we get
preempted and then go to a sleep. Before we go to sleep,
blk_scheduler_flush_plug() via schedule() tries to flush the list
leading to corruption, no? What am I missing?

[PS. Sorry about the delay in following it up, back from short vacation]

Thanks,

-- 
Suresh Jayaraman
