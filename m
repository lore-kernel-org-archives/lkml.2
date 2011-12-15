Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932530Ab1LOQPf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 11:15:35 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36654 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758989Ab1LOQPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 11:15:33 -0500
Message-ID: <4EEA1D1E.8030008@kernel.dk>
Date: Thu, 15 Dec 2011 17:15:26 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Shaohua Li <shli@kernel.org>
CC: Dave Kleikamp <dave.kleikamp@oracle.com>, linux-aio@kvack.org,
        linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
        Andi Kleen <ak@linux.intel.com>, Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] AIO: Don't plug the I/O queue in do_io_submit()
References: <4EE7C74D.1020306@oracle.com> <CANejiEU3v9EwhBaL6+nWLrsp-jetV=TVWU7v4vy1cU34qA92gw@mail.gmail.com>
In-Reply-To: <CANejiEU3v9EwhBaL6+nWLrsp-jetV=TVWU7v4vy1cU34qA92gw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-12-15 02:09, Shaohua Li wrote:
> 2011/12/14 Dave Kleikamp <dave.kleikamp@oracle.com>:
>> Asynchronous I/O latency to a solid-state disk greatly increased
>> between the 2.6.32 and 3.0 kernels. By removing the plug from
>> do_io_submit(), we observed a 34% improvement in the I/O latency.
>>
>> Unfortunately, at this level, we don't know if the request is to
>> a rotating disk or not.
>>
>> Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
>> Cc: linux-aio@kvack.org
>> Cc: Chris Mason <chris.mason@oracle.com>
>> Cc: Jens Axboe <axboe@kernel.dk>
>> Cc: Andi Kleen <ak@linux.intel.com>
>> Cc: Jeff Moyer <jmoyer@redhat.com>
>>
>> diff --git a/fs/aio.c b/fs/aio.c
>> index 78c514c..d131a2c 100644
>> --- a/fs/aio.c
>> +++ b/fs/aio.c
>> @@ -1696,7 +1696,6 @@ long do_io_submit(aio_context_t ctx_id, long nr,
>>        struct kioctx *ctx;
>>        long ret = 0;
>>        int i = 0;
>> -       struct blk_plug plug;
>>        struct kiocb_batch batch;
>>
>>        if (unlikely(nr < 0))
>> @@ -1716,8 +1715,6 @@ long do_io_submit(aio_context_t ctx_id, long nr,
>>
>>        kiocb_batch_init(&batch, nr);
>>
>> -       blk_start_plug(&plug);
>> -
>>        /*
>>         * AKPM: should this return a partial result if some of the IOs were
>>         * successfully submitted?
>> @@ -1740,7 +1737,6 @@ long do_io_submit(aio_context_t ctx_id, long nr,
>>                if (ret)
>>                        break;
>>        }
>> -       blk_finish_plug(&plug);
>>
>>        kiocb_batch_free(&batch);
>>        put_ioctx(ctx);
> can you explain why this can help? Note, in 3.1 kernel we now force flush
> plug list if the list is too long, which will remove a lot of latency.

I think that would indeed be an interesting addition to test on top of
the 3.0 kernel being used.

This is a bit of a sticky situation. We want the plugging and merging on
rotational storage, and on SSDs we want the batch addition to the queue
to avoid hammering on the queue lock. At this level, we have no idea.
But we don't want to introduce longer latencies. So the question is, are
these latencies due to long queues (and hence would be helped with the
auto-replug on 3.1 and newer), or are they due to the submissions
running for too long. If the latter, then we can either look into
reducing the time spent between submitting the individual pieces. Or at
least not holding up too long.

-- 
Jens Axboe

