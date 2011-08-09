Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751765Ab1HIXn5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 19:43:57 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:46037 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526Ab1HIXn4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 19:43:56 -0400
MIME-Version: 1.0
In-Reply-To: <4E4181E4.3090704@kernel.dk>
References: <20110809034724.GA22257@july>
	<4E4181E4.3090704@kernel.dk>
Date: Wed, 10 Aug 2011 08:43:55 +0900
X-Google-Sender-Auth: ryGTEqB3_txEzZfKYOVCtbG0P1U
Message-ID: <CAH9JG2X5yb9JEyO60YeLFHcuNp54m-xX8M-xSR7+DEY7FKQL1Q@mail.gmail.com>
Subject: Re: [RFC PATCH] request: teach the device more intelligent
From: Kyungmin Park <kmpark@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, jh80.chung@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 3:52 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On 2011-08-09 05:47, Kyungmin Park wrote:
>> Hi Jens
>>
>> Now eMMC device requires the upper layer information to improve the data
>> performance and reliability.
>>
>> . Context ID
>> Using the context information, it can sort out the data internally and improve the performance.
>> The main problem is that it's needed to define "What's the context".
>> Actually I expect cfq queue has own unique ID but it doesn't so decide to use the pid instead
>>
>> . Data Tag
>> Using the Data Tag (1-bit information), It writes the data at SLC area when it's hot data. So it can make the chip more reliable.
>> First I expect the REQ_META but current ext4 doesn't pass the WRITE_META. only use the READ_META. so it needs to investigate it.
>>
>> With these characteristics, it's helpful to teach the device. After some consideration. it's needed to pass out these information at request data structure.
>>
>> Can you give your opinions and does it proper fields at requests?
>
> You need this to work on all IO schedulers, not just cfq.
Of course if the concept is acceptable, I'll add the other IO schedulers also.

> And since that's the case, there's no need to add this field since you can just
> retrieve it if the driver asks for it. For CFQ, it could look like this:
>
> static int cfq_foo(struct request *rq)
> {
>        struct cfq_queue *cfqq = rq->elevator_private[1];
>
>        if (cfqq)
>                return cfqq->pid;
>
>        return -1;
> }

The actual user of these information is device driver. e.g.,
drivers/mmc/card/block.c
So it's not good to use cfq data structure at D/D. some time later
these are also used at scsi device drivers.
>
> As to the hot part, I think that would be better as just a request flag
> like eg the meta flag.
Yes it can use the JBD_flags at cfq. but same reason it's not proper
reference at device drivers. that's reason to make a filed at request.

Device driver should or must see the request data structure and don't
refer the upper layer data structures.

Thank you,
Kyungmin Park
