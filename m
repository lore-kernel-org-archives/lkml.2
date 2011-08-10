Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975Ab1HJCQi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 22:16:38 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:41930 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab1HJCQh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 22:16:37 -0400
From: Namhyung Kim <namhyung@gmail.com>
To: Kyungmin Park <kmpark@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, jaxboe@fusionio.com,
        linux-kernel@vger.kernel.org, arnd@arndb.de, jh80.chung@samsung.com
Subject: Re: [RFC PATCH] request: teach the device more intelligent
References: <20110809034724.GA22257@july>
	<CAH9JG2UqMD=S3e+BupO+8dfEZQy5eZWO2gMhbTPmmjHJFOimtw@mail.gmail.com>
Date: Wed, 10 Aug 2011 11:16:15 +0900
In-Reply-To: <CAH9JG2UqMD=S3e+BupO+8dfEZQy5eZWO2gMhbTPmmjHJFOimtw@mail.gmail.com>
	(Kyungmin Park's message of "Tue, 9 Aug 2011 23:04:41 +0900")
Message-ID: <87ipq6xb80.fsf@gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kyungmin Park <kmpark@infradead.org> writes:

> Cc the correct email address of jens
>
> On Tue, Aug 9, 2011 at 12:47 PM, Kyungmin Park <kmpark@infradead.org> wrote:
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
>>
>> Thank you,
>> Kyungmin Park
>> ---
>> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
>> index 1f96ad6..d73bfa7 100644
>> --- a/block/cfq-iosched.c
>> +++ b/block/cfq-iosched.c
>> @@ -3790,6 +3790,7 @@ new_queue:
>>        rq->elevator_private[0] = cic;
>>        rq->elevator_private[1] = cfqq;
>>        rq->elevator_private[2] = cfq_ref_get_cfqg(cfqq->cfqg);
>> +       rq->hint.context = (int) cfqq->pid;
>>        spin_unlock_irqrestore(q->queue_lock, flags);
>>        return 0;
>>
>> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
>> index 0e67c45..0145c10 100644
>> --- a/include/linux/blkdev.h
>> +++ b/include/linux/blkdev.h
>> @@ -69,6 +69,14 @@ enum rq_cmd_type_bits {
>>        REQ_TYPE_ATA_PC,
>>  };
>>
>> +/*
>> + * request hint
>> + */
>> +struct request_hint {
>> +       int context;                    /* Context ID */
>> +       int hot:1;                      /* Hot/cold data */

This 1-bit member should be a type of unsigned?

Thanks.
