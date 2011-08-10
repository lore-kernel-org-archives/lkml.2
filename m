Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752384Ab1HJIzm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 04:55:42 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:48636 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910Ab1HJIzk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 04:55:40 -0400
MIME-Version: 1.0
In-Reply-To: <CANejiEVW69ihzpMYqvTZ5iW+uz3jUA2y60vL7xzyZidhSxj-0g@mail.gmail.com>
References: <20110809034724.GA22257@july>
	<4E4181E4.3090704@kernel.dk>
	<CAH9JG2X5yb9JEyO60YeLFHcuNp54m-xX8M-xSR7+DEY7FKQL1Q@mail.gmail.com>
	<4E423C83.9090209@kernel.dk>
	<CAH9JG2VhPg-mk36CO_Jh8D0O6SW3RnZyjnBRNH4UqT8SXXWULQ@mail.gmail.com>
	<CANejiEVW69ihzpMYqvTZ5iW+uz3jUA2y60vL7xzyZidhSxj-0g@mail.gmail.com>
Date: Wed, 10 Aug 2011 17:55:40 +0900
X-Google-Sender-Auth: 1KHGDrB4RO93KPSmWk8DLgkumVY
Message-ID: <CAH9JG2ViS01evDeyypPPB9OWiXwCdrTLf6yqe4gZaEQoaOzaTQ@mail.gmail.com>
Subject: Re: [RFC PATCH] request: teach the device more intelligent
From: Kyungmin Park <kmpark@infradead.org>
To: Shaohua Li <shli@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, arnd@arndb.de,
        jh80.chung@samsung.com, linux-mmc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 5:47 PM, Shaohua Li <shli@kernel.org> wrote:
> 2011/8/10 Kyungmin Park <kmpark@infradead.org>:
>> On Wed, Aug 10, 2011 at 5:08 PM, Jens Axboe <axboe@kernel.dk> wrote:
>>> On 2011-08-10 01:43, Kyungmin Park wrote:
>>>> On Wed, Aug 10, 2011 at 3:52 AM, Jens Axboe <axboe@kernel.dk> wrote:
>>>>> On 2011-08-09 05:47, Kyungmin Park wrote:
>>>>>> Hi Jens
>>>>>>
>>>>>> Now eMMC device requires the upper layer information to improve the data
>>>>>> performance and reliability.
>>>>>>
>>>>>> . Context ID
>>>>>> Using the context information, it can sort out the data internally and improve the performance.
>>>>>> The main problem is that it's needed to define "What's the context".
>>>>>> Actually I expect cfq queue has own unique ID but it doesn't so decide to use the pid instead
>>>>>>
>>>>>> . Data Tag
>>>>>> Using the Data Tag (1-bit information), It writes the data at SLC area when it's hot data. So it can make the chip more reliable.
>>>>>> First I expect the REQ_META but current ext4 doesn't pass the WRITE_META. only use the READ_META. so it needs to investigate it.
>>>>>>
>>>>>> With these characteristics, it's helpful to teach the device. After some consideration. it's needed to pass out these information at request data structure.
>>>>>>
>>>>>> Can you give your opinions and does it proper fields at requests?
>>>>>
>>>>> You need this to work on all IO schedulers, not just cfq.
>>>> Of course if the concept is acceptable, I'll add the other IO schedulers also.
>>>>
>>>>> And since that's the case, there's no need to add this field since you can just
>>>>> retrieve it if the driver asks for it. For CFQ, it could look like this:
>>>>>
>>>>> static int cfq_foo(struct request *rq)
>>>>> {
>>>>>        struct cfq_queue *cfqq = rq->elevator_private[1];
>>>>>
>>>>>        if (cfqq)
>>>>>                return cfqq->pid;
>>>>>
>>>>>        return -1;
>>>>> }
>>>>
>>>> The actual user of these information is device driver. e.g.,
>>>> drivers/mmc/card/block.c
>>>> So it's not good to use cfq data structure at D/D. some time later
>>>> these are also used at scsi device drivers.
>>>
>>> No, what I'm suggesting above is the CFQ implementation. You would need
>>> to wire up an elv_ops->get_foo() and have the IO schedulers fill it in.
>>> If you notice, the above function does not take or output anything
>>> related to CFQ in particular, it'll just return you the unique key you
>>> need.
>>>
>>> It's either the above, or a field in the request that the schedulers
>>> fill out. However, it'd be somewhat annoying to grow struct request for
>>> something that has a narrow scope of use. Hence the suggestion to add a
>>> strategy helper for this.
>> Okay, I'll add new elevator function one for getting context or more hints.
>> BTW, does it okay to call elevator function call at D/D?
>>
>> The quick-n-dirty call is like this at "drivers/mmc/card/block.c"
>>
>>                struct elevator_queue *e = md->queue.queue->elevator;
>>                int context = -1;
>>
>>                if (e->ops->elevator_get_req_hint_fn && req) {
>>                        context = e->ops->elevator_get_req_hint_fn(req);
> I'm wondering how the driver deal with elevator switch. A context id from
> one elevator might just be garbage for another elevator.

In case of MMC. it doesn't need to persistent pid. it's enough to use
the temporal context ID.
Please see the test output.

 PID TTY      STAT   TIME COMMAND
...
  346 ?        S      0:01 [kworker/0:1]
  348 ?        S      0:01 [mmcqd/0]
  349 ?        S      0:00 [mmcqd/0boot0]
  350 ?        S      0:00 [mmcqd/0boot1]
  363 ?        S      0:00 [kworker/1:1]
  365 ?        S      0:00 [mmcqd/1]
  369 ?        S      0:00 [jbd2/mmcblk0p3-]
  370 ?        S<     0:00 [ext4-dio-unwrit]
  386 ?        S      0:00 [jbd2/mmcblk0p6-]
  387 ?        S<     0:00 [ext4-dio-unwrit]
  448 ttySAC2  Ss     0:00 -sh
  461 ?        Ss     0:00 /usr/sbin/inetd
  464 ttySAC2  R+     0:00 ps ax

[ 1021.153100] mmc_blk_issue_rq[1203] req df94e7e0, context 448 <- sh
[ 1021.236799] mmc_blk_issue_rq[1203] req df82c8c0, context 448

[ 1023.712727] mmc_blk_issue_rq[1203] req df82c9a0, context 464
[ 1023.722319] mmc_blk_issue_rq[1203] req df82c9a0, context 464
[ 1023.737660] mmc_blk_issue_rq[1203] req df94e700, context 464
[ 1023.744930] mmc_blk_issue_rq[1203] req df94e620, context 464

[ 1025.189639] mmc_blk_issue_rq[1203] req df82c7e0, context 369 <- jbd2
[ 1025.194334] mmc_blk_issue_rq[1203] req df82c9a0, context 369
[ 1025.200157] mmc_blk_issue_rq[1203] req df82cee0, context 369
[ 1025.213215] mmc_blk_issue_rq[1203] req df9a5b08, context 0 <- flush
[ 1025.217627] mmc_blk_issue_rq[1203] req df82cee0, context 0 <- flush

>
> Thanks,
> Shaohua
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
