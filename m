Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520Ab1H3FWz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 01:22:55 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:13278 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970Ab1H3FWv (ORCPT
	<rfc822;groupwise-SJayaraman@suse.com:0:0>);
	Tue, 30 Aug 2011 01:22:51 -0400
Message-ID: <4E5C7359.7070602@suse.de>
Date: Tue, 30 Aug 2011 10:51:29 +0530
From: Suresh Jayaraman <sjayaraman@suse.de>
Reply-To: sjayaraman@suse.de
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110616 SUSE/3.1.11 Thunderbird/3.1.11
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jens Axboe <axboe@kernel.dk>, LKML <linux-kernel@vger.kernel.org>,
        Shaohua Li <shaohua.li@intel.com>, Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH v2] block: document blk-plug
References: <4E5B77D5.7090006@suse.de> <20110829144843.c8e9d397.akpm@linux-foundation.org>
In-Reply-To: <20110829144843.c8e9d397.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2011 03:18 AM, Andrew Morton wrote:
> On Mon, 29 Aug 2011 16:58:21 +0530
> Suresh Jayaraman <sjayaraman@suse.de> wrote:
> 
>> --- a/include/linux/blkdev.h
>> +++ b/include/linux/blkdev.h
>> @@ -863,17 +863,23 @@ struct request_queue *blk_alloc_queue_node(gfp_t, int);
>>  extern void blk_put_queue(struct request_queue *);
>>  
>>  /*
>> + * blk_plug allows to build up a queue of related requests by holding the I/O
>> + * fragments for a short period. This allows merging of sequential requests
>> + * into single larger request. As the requests are moved from per-task list to
>> + * the device's request_queue in a batch, this results in improved
>> + * scalability as the lock contention for request_queue lock is reduced.
>> + *
>>   * Note: Code in between changing the blk_plug list/cb_list or element of such
>>   * lists is preemptable, but such code can't do sleep (or be very careful),
>>   * otherwise data is corrupted. For details, please check schedule() where
>>   * blk_schedule_flush_plug() is called.
> 
> What does the older part of this comment mean?  If a code section is
> preemptible then it *will* sleep.  That's what preemption does.
> 

>From what I can understand, we don't need to explicitly disable preemption
when modifying the blk_plug->list because interrupts are disabled when we
are there.

void blk_flush_plug_list(struct blk_plug *plug, bool from_schedule)
{

..

        /*
         * Save and disable interrupts here, to avoid doing it for every
         * queue lock we have to take.
         */
        local_irq_save(flags);
        while (!list_empty(&list)) {
                rq = list_entry_rq(list.next);
                list_del_init(&rq->queuelist);
                BUG_ON(!rq->q);
                if (rq->q != q) {
                        /*
                         * This drops the queue lock
                         */
                        if (q)
                                queue_unplugged(q, depth, from_schedule);
                        q = rq->q;
                        depth = 0;
                        spin_lock(q->queue_lock);
                }


..

}

When blk_flush_plug_list() is called from schedule() via
blk_schedule_flush_plug() we must be very careful to not cause
need_resched set and thus result in a preemption check?

Does that what your comment intend to mean? Shaohua?



-- 
Suresh Jayaraman
