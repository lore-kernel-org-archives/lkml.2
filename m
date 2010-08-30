Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432Ab0H3N7m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 09:59:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:57039 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753718Ab0H3N7k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 09:59:40 -0400
Message-ID: <4C7BB932.1070405@kernel.org>
Date: Mon, 30 Aug 2010 15:59:14 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Mike Snitzer <snitzer@redhat.com>
CC: jaxboe@fusionio.com, k-ueda@ct.jp.nec.com, j-nomura@ce.jp.nec.com,
        jamie@shareable.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 4/5] dm: implement REQ_FLUSH/FUA support for request-based
 dm
References: <1283162296-13650-1-git-send-email-tj@kernel.org> <1283162296-13650-5-git-send-email-tj@kernel.org> <20100830132836.GB5283@redhat.com>
In-Reply-To: <20100830132836.GB5283@redhat.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 30 Aug 2010 13:59:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 08/30/2010 03:28 PM, Mike Snitzer wrote:
>> +	clone->cmd = rq->cmd;
>> +	clone->cmd_len = rq->cmd_len;
>> +	clone->sense = rq->sense;
>> +	clone->buffer = rq->buffer;
>>  	clone->end_io = end_clone_request;
>>  	clone->end_io_data = tio;
> 
> blk_rq_prep_clone() of a REQ_FLUSH request will result in a
> rq_data_dir(clone) of read.

Hmmm... why?  blk_rq_prep_clone() copies all REQ_* flags in
REQ_CLONE_MASK and REQ_WRITE is definitely there.  I'll check.

> I still had the following:
> 
>         if (rq->cmd_flags & REQ_FLUSH) {
>                 blk_rq_init(NULL, clone);
>                 clone->cmd_type = REQ_TYPE_FS;
>                 /* without this the clone has a rq_data_dir of 0 */
>                 clone->cmd_flags |= WRITE_FLUSH;
>         } else {
>                 r = blk_rq_prep_clone(clone, rq, tio->md->bs, GFP_ATOMIC,
>                                       dm_rq_bio_constructor, tio);
>                 ...
> 
> Request-based DM's REQ_FLUSH still works without this special casing but
> I figured I'd raise this to ask: what is the proper rq_data_dir() is for
> a REQ_FLUSH?

Technically block layer doesn't care one way or the other but WRITE
definitely.  Maybe it would be a good idea to enforce that from block
layer.

>> @@ -1709,15 +1621,12 @@ static void dm_request_fn(struct request_queue *q)
>>  		if (!rq)
>>  			goto plug_and_out;
>>  
>> -		if (unlikely(dm_rq_is_flush_request(rq))) {
>> -			BUG_ON(md->flush_request);
>> -			md->flush_request = rq;
>> -			blk_start_request(rq);
>> -			queue_work(md->wq, &md->barrier_work);
>> -			goto out;
>> -		}
>> +		/* always use block 0 to find the target for flushes for now */
>> +		pos = 0;
>> +		if (!(rq->cmd_flags & REQ_FLUSH))
>> +			pos = blk_rq_pos(rq);
>>  
>> -		ti = dm_table_find_target(map, blk_rq_pos(rq));
>> +		ti = dm_table_find_target(map, pos);
> 
> I added the following here: BUG_ON(!dm_target_is_valid(ti));

I'll add it.

>>  		if (ti->type->busy && ti->type->busy(ti))
>>  			goto plug_and_out;
> 
> I also needed to avoid the ->busy call for REQ_FLUSH:
> 
>                 if (!(rq->cmd_flags & REQ_FLUSH)) {
>                         ti = dm_table_find_target(map, blk_rq_pos(rq));
>                         BUG_ON(!dm_target_is_valid(ti));
>                         if (ti->type->busy && ti->type->busy(ti))
>                                 goto plug_and_out;
>                 } else {
>                         /* rq-based only ever has one target! leverage this for FLUSH */
>                         ti = dm_table_get_target(map, 0);
>                 }
> 
> If I allowed ->busy to be called for REQ_FLUSH it would result in a
> deadlock.  I haven't identified where/why yet.

Ah... that's probably from "if (!elv_queue_empty(q))" check below,
flushes are on a separate queue but I forgot to update
elv_queue_empty() to check the flush queue.  elv_queue_empty() can
return %true spuriously in which case the queue won't be plugged and
restarted later leading to queue hang.  I'll fix elv_queue_empty().

Thanks.

-- 
tejun
