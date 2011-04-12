Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689Ab1DLGSn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 02:18:43 -0400
Received: from mx1.fusionio.com ([64.244.102.30]:59601 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756568Ab1DLGSk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 02:18:40 -0400
X-ASG-Debug-ID: 1302589119-03d6a569fb92270001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DA3EEBD.4060005@fusionio.com>
Date: Tue, 12 Apr 2011 08:18:37 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>
CC: "hch@infradead.org" <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: Re: [PATCH 05/10] block: remove per-queue plugging
References: <1295659049-2688-6-git-send-email-jaxboe@fusionio.com>	<AANLkTin8FoXX6oqUyW+scwhadyX-TfW16_oKjvngU9-m@mail.gmail.com>	<20110303221353.GA10366@redhat.com>	<4D761E0D.8050200@fusionio.com>	<20110308202100.GA31744@redhat.com>	<4D76912C.9040705@fusionio.com>	<20110308220526.GA393@redhat.com>	<20110310005810.GA17911@redhat.com>	<20110405130541.6c2b5f86@notabene.brown>	<20110411145022.710c30e9@notabene.brown>	<20110411165923.GA15442@infradead.org> <20110412071428.4aa92c6e@notabene.brown>
X-ASG-Orig-Subj: Re: [PATCH 05/10] block: remove per-queue plugging
In-Reply-To: <20110412071428.4aa92c6e@notabene.brown>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1302589119
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.60612
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-04-11 23:14, NeilBrown wrote:
> On Mon, 11 Apr 2011 12:59:23 -0400 "hch@infradead.org" <hch@infradead.org>
> wrote:
> 
>> On Mon, Apr 11, 2011 at 02:50:22PM +1000, NeilBrown wrote:
>>> diff --git a/block/blk-core.c b/block/blk-core.c
>>> index 273d60b..903ce8d 100644
>>> --- a/block/blk-core.c
>>> +++ b/block/blk-core.c
>>> @@ -2674,19 +2674,23 @@ static void flush_plug_list(struct blk_plug *plug)
>>>  	struct request_queue *q;
>>>  	unsigned long flags;
>>>  	struct request *rq;
>>> +	struct list_head head;
>>>  
>>>  	BUG_ON(plug->magic != PLUG_MAGIC);
>>>  
>>>  	if (list_empty(&plug->list))
>>>  		return;
>>> +	list_add(&head, &plug->list);
>>> +	list_del_init(&plug->list);
>>>  
>>>  	if (plug->should_sort)
>>> -		list_sort(NULL, &plug->list, plug_rq_cmp);
>>> +		list_sort(NULL, &head, plug_rq_cmp);
>>> +	plug->should_sort = 0;
>>
>> As Jens mentioned this should be list_splice_init.  But looking over
>> flush_plug_list the code there seems strange to me.
>>
>> What does the local_irq_save in flush_plug_list protect?  Why don't
>> we need it over the list_sort?  And do we still need it when first
>> splicing the list to a local one?
>>
>> It's one of these cases where I'd really like to see more comments
>> explaining why the code is doing what it's doing.
> 
> My understanding of that was that the calling requirement of
> __elv_add_request is that the queue spinlock is held and that interrupts are
> disabled.
> So rather than possible enabling and disabling interrupts several times as
> different queue are handled, the code just disabled interrupts once, and
> then just take the spinlock once for each different queue.
> 
> The whole point of the change to plugging was to take locks less often.
> Disabling interrupts less often is presumably an analogous goal.
> 
> Though I agree that a comment would help.
> 
> 	q = NULL;
> +	/* Disable interrupts just once rather than using spin_lock_irq/sin_unlock_irq
> 	 * variants
> 	 */
> 	local_irq_save(flags);
> 
> 
> assuming my analysis is correct.

Yep that is correct, it's to avoid juggling irq on and off for multiple
queues. I will put a comment there.


-- 
Jens Axboe

