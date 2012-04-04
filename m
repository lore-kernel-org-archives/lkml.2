Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314Ab2DDWUi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 18:20:38 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:56818 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556Ab2DDWUh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 18:20:37 -0400
MIME-Version: 1.0
In-Reply-To: <20120404144656.7b2a06ec.akpm@linux-foundation.org>
References: <1325254651-15379-1-git-send-email-glorioustao@gmail.com> <20120404144656.7b2a06ec.akpm@linux-foundation.org>
From: Tao Guo <glorioustao@gmail.com>
Date: Wed, 4 Apr 2012 15:20:16 -0700
Message-ID: <CAAV8rn+T7FM7bG+Q6fyoUrVtzOkYOx94Nh87Rg12UqCdk9HhWQ@mail.gmail.com>
Subject: Re: [PATCH] umem: fix up unplugging.
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, neilb@suse.de, axboe@fusionio.com,
        Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Thanks for your reply.

Yes, without this patch the umem driver just doesn't work.
It is a bug introduced by commit 7eaceaccab5f40bbfda044629a6298616aeaed50.
In that patch, Jens removed the whole mm_unplug_device() function,
which used to be
the trigger to make umem start to work.

Thanks,
-Tao


On Wed, Apr 4, 2012 at 2:46 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Fri, 30 Dec 2011 09:17:31 -0500
>
> (Long delay...)
>
> Tao Guo <glorioustao@gmail.com> wrote:
>
>> We need to implement unplugging to make umem start to work, or I/O
>> will never be triggered.
>>
>
> I take it from this that umem simply doesn't work at all?
>
> If so, for how long has this been the case and should we just delete the
> thing?
>
>>
>> --- a/drivers/block/umem.c
>> +++ b/drivers/block/umem.c
>> @@ -111,7 +111,8 @@ struct cardinfo {
>>       int             current_idx;
>>       sector_t        current_sector;
>>
>> -     struct request_queue *queue;
>> +     struct request_queue    *queue;
>> +     struct blk_plug_cb      plug_cb;
>>
>>       struct mm_page {
>>               dma_addr_t              page_dma;
>> @@ -513,6 +514,33 @@ static void process_page(unsigned long data)
>>       }
>>  }
>>
>> +static void mm_unplug(struct blk_plug_cb *cb)
>> +{
>> +     struct cardinfo *card = container_of(cb, struct cardinfo, plug_cb);
>> +
>> +     spin_lock_irq(&card->lock);
>> +     activate(card);
>> +     spin_unlock_irq(&card->lock);
>> +}
>> +
>> +int mm_check_plugged(struct cardinfo *card)
>> +{
>> +     struct blk_plug *plug = current->plug;
>> +     struct cardinfo *c;
>> +
>> +     if (!plug)
>> +             return 0;
>> +
>> +     list_for_each_entry(c, &plug->cb_list, plug_cb.list) {
>> +             if (c == card)
>> +                     return 1;
>> +     }
>> +
>> +     /* set up unplug callback */
>> +     list_add(&card->plug_cb.list, &plug->cb_list);
>> +     return 1;
>> +}
>> +
>>  static void mm_make_request(struct request_queue *q, struct bio *bio)
>>  {
>>       struct cardinfo *card = q->queuedata;
>> @@ -523,6 +551,8 @@ static void mm_make_request(struct request_queue *q, struct bio *bio)
>>       *card->biotail = bio;
>>       bio->bi_next = NULL;
>>       card->biotail = &bio->bi_next;
>> +     if (bio->bi_rw & REQ_SYNC || !mm_check_plugged(card))
>> +             activate(card);
>>       spin_unlock_irq(&card->lock);
>>
>>       return;
>> @@ -884,6 +914,7 @@ static int __devinit mm_pci_probe(struct pci_dev *dev,
>>       blk_queue_make_request(card->queue, mm_make_request);
>>       card->queue->queue_lock = &card->lock;
>>       card->queue->queuedata = card;
>> +     card->plug_cb.callback = mm_unplug;
>>
>>       tasklet_init(&card->tasklet, process_page, (unsigned long)card);
>
