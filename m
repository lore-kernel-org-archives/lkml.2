Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592Ab1HKBKw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 21:10:52 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:47657 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755576Ab1HKBKu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 21:10:50 -0400
MIME-Version: 1.0
In-Reply-To: <20110811004216.GA24810@july>
References: <20110811004216.GA24810@july>
Date: Thu, 11 Aug 2011 09:10:49 +0800
X-Google-Sender-Auth: PYmwts40G72TsUndiaf3rNeNcjk
Message-ID: <CANejiEXgsVW4qk3hwHvd6YzgRsZueAB3ZSh3Rvx3fz9tM7KHPw@mail.gmail.com>
Subject: Re: [RFC PATCH v2] Add new elevator ops for request hint
From: Shaohua Li <shli@kernel.org>
To: Kyungmin Park <kmpark@infradead.org>
Cc: jaxboe@fusionio.com, linux-kernel@vger.kernel.org, arnd@arndb.de,
        jh80.chung@samsung.com, linux-mmc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/8/11 Kyungmin Park <kmpark@infradead.org>:
> Hi Jens
>
> Now eMMC device requires the upper layer information to improve the data
> performance and reliability.
>
> . Context ID
> Using the context information, it can sort out the data internally and improve the performance.
> The main problem is that it's needed to define "What's the context".
> Actually I expect cfq queue has own unique ID but it doesn't so decide to use the pid instead
>
> . Data Tag
> Using the Data Tag (1-bit information), It writes the data at SLC area when it's hot data. So it can make the chip more reliable.
> First I expect the REQ_META but current ext4 doesn't pass the WRITE_META. only use the READ_META. so it needs to investigate it.
>
> With these characteristics, it's helpful to teach the device. After some consideration. it's needed to pass out these information at request data structure.
>
> Sample usage is following in drivers/mmc/card/block.c
>
>        struct elevator_queue *e = md->queue.queue->elevator;
>        struct request_hint hint;
>        int ret;
>
>        if (e->ops->elevator_get_req_hint_fn && req)
>                ret = e->ops->elevator_get_req_hint_fn(req, &hint);
please put this to blkdev.h or similar. directly using it here
is abnormal.

> Thank you,
> Kyungmin Park
> ---
> Changelog v2
> - Don't add the request member. instead add new elevator ops
>
> ---
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index 1f96ad6..5089f67 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -3800,6 +3800,18 @@ queue_fail:
>        return 1;
>  }
>
> +static int cfq_get_request_hint(struct request *rq, struct request_hint *hint)
> +{
> +       struct cfq_queue *cfqq = RQ_CFQQ(rq);
> +
> +       if (cfqq) {
> +               hint->context = cfqq->pid;
> +               hint->hot = !!(rq->cmd_flags & REQ_META);
> +       }
if the rq is in cfq, the cfqq is always valid, so don't need the check.

Thanks,
Shaohua
