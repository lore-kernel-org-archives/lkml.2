Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593Ab1HJIrx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 04:47:53 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:62735 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910Ab1HJIrw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 04:47:52 -0400
MIME-Version: 1.0
In-Reply-To: <CAH9JG2VhPg-mk36CO_Jh8D0O6SW3RnZyjnBRNH4UqT8SXXWULQ@mail.gmail.com>
References: <20110809034724.GA22257@july>
	<4E4181E4.3090704@kernel.dk>
	<CAH9JG2X5yb9JEyO60YeLFHcuNp54m-xX8M-xSR7+DEY7FKQL1Q@mail.gmail.com>
	<4E423C83.9090209@kernel.dk>
	<CAH9JG2VhPg-mk36CO_Jh8D0O6SW3RnZyjnBRNH4UqT8SXXWULQ@mail.gmail.com>
Date: Wed, 10 Aug 2011 16:47:50 +0800
X-Google-Sender-Auth: Pyikq5Mign3OLwcRcldyHpvngl4
Message-ID: <CANejiEVW69ihzpMYqvTZ5iW+uz3jUA2y60vL7xzyZidhSxj-0g@mail.gmail.com>
Subject: Re: [RFC PATCH] request: teach the device more intelligent
From: Shaohua Li <shli@kernel.org>
To: Kyungmin Park <kmpark@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, arnd@arndb.de,
        jh80.chung@samsung.com, linux-mmc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/8/10 Kyungmin Park <kmpark@infradead.org>:
> On Wed, Aug 10, 2011 at 5:08 PM, Jens Axboe <axboe@kernel.dk> wrote:
>> On 2011-08-10 01:43, Kyungmin Park wrote:
>>> On Wed, Aug 10, 2011 at 3:52 AM, Jens Axboe <axboe@kernel.dk> wrote:
>>>> On 2011-08-09 05:47, Kyungmin Park wrote:
>>>>> Hi Jens
>>>>>
>>>>> Now eMMC device requires the upper layer information to improve the data
>>>>> performance and reliability.
>>>>>
>>>>> . Context ID
>>>>> Using the context information, it can sort out the data internally and improve the performance.
>>>>> The main problem is that it's needed to define "What's the context".
>>>>> Actually I expect cfq queue has own unique ID but it doesn't so decide to use the pid instead
>>>>>
>>>>> . Data Tag
>>>>> Using the Data Tag (1-bit information), It writes the data at SLC area when it's hot data. So it can make the chip more reliable.
>>>>> First I expect the REQ_META but current ext4 doesn't pass the WRITE_META. only use the READ_META. so it needs to investigate it.
>>>>>
>>>>> With these characteristics, it's helpful to teach the device. After some consideration. it's needed to pass out these information at request data structure.
>>>>>
>>>>> Can you give your opinions and does it proper fields at requests?
>>>>
>>>> You need this to work on all IO schedulers, not just cfq.
>>> Of course if the concept is acceptable, I'll add the other IO schedulers also.
>>>
>>>> And since that's the case, there's no need to add this field since you can just
>>>> retrieve it if the driver asks for it. For CFQ, it could look like this:
>>>>
>>>> static int cfq_foo(struct request *rq)
>>>> {
>>>>        struct cfq_queue *cfqq = rq->elevator_private[1];
>>>>
>>>>        if (cfqq)
>>>>                return cfqq->pid;
>>>>
>>>>        return -1;
>>>> }
>>>
>>> The actual user of these information is device driver. e.g.,
>>> drivers/mmc/card/block.c
>>> So it's not good to use cfq data structure at D/D. some time later
>>> these are also used at scsi device drivers.
>>
>> No, what I'm suggesting above is the CFQ implementation. You would need
>> to wire up an elv_ops->get_foo() and have the IO schedulers fill it in.
>> If you notice, the above function does not take or output anything
>> related to CFQ in particular, it'll just return you the unique key you
>> need.
>>
>> It's either the above, or a field in the request that the schedulers
>> fill out. However, it'd be somewhat annoying to grow struct request for
>> something that has a narrow scope of use. Hence the suggestion to add a
>> strategy helper for this.
> Okay, I'll add new elevator function one for getting context or more hints.
> BTW, does it okay to call elevator function call at D/D?
>
> The quick-n-dirty call is like this at "drivers/mmc/card/block.c"
>
>                struct elevator_queue *e = md->queue.queue->elevator;
>                int context = -1;
>
>                if (e->ops->elevator_get_req_hint_fn && req) {
>                        context = e->ops->elevator_get_req_hint_fn(req);
I'm wondering how the driver deal with elevator switch. A context id from
one elevator might just be garbage for another elevator.

Thanks,
Shaohua
