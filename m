Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759174Ab0EZCnL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 22:43:11 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:37745 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758814Ab0EZCnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 22:43:09 -0400
Message-ID: <4BFC896A.6050306@ct.jp.nec.com>
Date: Wed, 26 May 2010 11:37:30 +0900
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: Mike Snitzer <snitzer@redhat.com>
CC: Jens Axboe <jens.axboe@oracle.com>, dm-devel@redhat.com,
       Alasdair Kergon <agk@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: avoid unconditionally freeing previously allocated
 request_queue
References: <1274744795-9825-1-git-send-email-snitzer@redhat.com> <1274744795-9825-3-git-send-email-snitzer@redhat.com> <4BFBB21A.3030105@ct.jp.nec.com> <20100525124912.GA7447@redhat.com> <20100525163455.GA10155@redhat.com>
In-Reply-To: <20100525163455.GA10155@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On 05/26/2010 01:34 AM +0900, Mike Snitzer wrote:
> Mike Snitzer <snitzer@redhat.com> wrote:
>> Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote:
>>>> +/*
>>>> + * Fully initialize a request-based queue (->elevator, ->request_fn, etc).
>>>> + */
>>>> +static int dm_init_request_based_queue(struct mapped_device *md)
>>>> +{
>>>> +	struct request_queue *q = NULL;
>>>> +
>>>> +	/* Avoid re-initializing the queue if already fully initialized */
>>>> +	if (!md->queue->elevator) {
>>>> +		/* Fully initialize the queue */
>>>> +		q = blk_init_allocated_queue(md->queue, dm_request_fn, NULL);
>>>> +		if (!q)
>>>> +			return 0;
>>>
>>> When blk_init_allocated_queue() fails, the block-layer seems not to
>>> guarantee that the queue is still available.
>>
>> Ouch, yes this portion of blk_init_allocated_queue_node() is certainly
>> problematic:
>>
>>         if (blk_init_free_list(q)) {
>>                 kmem_cache_free(blk_requestq_cachep, q);
>>                 return NULL;
>>         }

Not only that.  The blk_put_queue() in blk_init_allocated_queue_node()
will also free the queue:

	if (!elevator_init(q, NULL)) {
		blk_queue_congestion_threshold(q);
		return q;
	}

	blk_put_queue(q);
	return NULL;

Thanks,
Kiyoshi Ueda
