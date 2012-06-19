Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919Ab2FSCBT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 22:01:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10429 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751708Ab2FSCBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 22:01:15 -0400
Message-ID: <4FDFDDBE.3050506@redhat.com>
Date: Tue, 19 Jun 2012 10:02:38 +0800
From: Asias He <asias@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Jens Axboe <axboe@kernel.dk>, Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH 1/3] block: Introduce __blk_segment_map_sg() helper
References: <1340002390-3950-1-git-send-email-asias@redhat.com> <1340002390-3950-2-git-send-email-asias@redhat.com> <20120618213103.GC32733@google.com>
In-Reply-To: <20120618213103.GC32733@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2012 05:31 AM, Tejun Heo wrote:
> Hello, Asias.
>
> On Mon, Jun 18, 2012 at 02:53:08PM +0800, Asias He wrote:
>> Split the mapping code in blk_rq_map_sg() to a helper
>> __blk_segment_map_sg(), so that other mapping function, e.g.
>> blk_bio_map_sg(), can share the code.
>>
>> Cc: Jens Axboe <axboe@kernel.dk>
>> Cc: Tejun Heo <tj@kernel.org>
>> Cc: Shaohua Li <shli@kernel.org>
>> Cc: linux-kernel@vger.kernel.org
>> Suggested-by: Tejun Heo <tj@kernel.org>
>> Suggested-by: Jens Axboe <axboe@kernel.dk>
>> Signed-off-by: Asias He <asias@redhat.com>
>> ---
>>   block/blk-merge.c |   80 ++++++++++++++++++++++++++++++-----------------------
>>   1 file changed, 45 insertions(+), 35 deletions(-)
>>
>> diff --git a/block/blk-merge.c b/block/blk-merge.c
>> index 160035f..576b68e 100644
>> --- a/block/blk-merge.c
>> +++ b/block/blk-merge.c
>> @@ -110,6 +110,49 @@ static int blk_phys_contig_segment(struct request_queue *q, struct bio *bio,
>>   	return 0;
>>   }
>>
>> +static void
>> +__blk_segment_map_sg(struct request_queue *q, struct bio_vec *bvec,
>> +		     struct scatterlist *sglist, struct bio_vec **bvprv,
>> +		     struct scatterlist **sg, int *nsegs, int *cluster)
>> +{
>> +
>> +	int nbytes = bvec->bv_len;
>> +
>> +	if (*bvprv && *cluster) {
>> +		if ((*sg)->length + nbytes > queue_max_segment_size(q))
>> +			goto new_segment;
>> +
>> +		if (!BIOVEC_PHYS_MERGEABLE(*bvprv, bvec))
>> +			goto new_segment;
>> +		if (!BIOVEC_SEG_BOUNDARY(q, *bvprv, bvec))
>> +			goto new_segment;
>> +
>> +		(*sg)->length += nbytes;
>> +	} else {
>> +new_segment:
>> +		if (!*sg)
>> +			*sg = sglist;
>> +		else {
>> +			/*
>> +			 * If the driver previously mapped a shorter
>> +			 * list, we could see a termination bit
>> +			 * prematurely unless it fully inits the sg
>> +			 * table on each mapping. We KNOW that there
>> +			 * must be more entries here or the driver
>> +			 * would be buggy, so force clear the
>> +			 * termination bit to avoid doing a full
>> +			 * sg_init_table() in drivers for each command.
>> +			 */
>> +			(*sg)->page_link &= ~0x02;
>> +			*sg = sg_next(*sg);
>> +		}
>> +
>> +		sg_set_page(*sg, bvec->bv_page, nbytes, bvec->bv_offset);
>> +		(*nsegs)++;
>> +	}
>> +	*bvprv = bvec;
>> +}
>
> I *hope* this is a bit prettier.  e.g. Do we really need to pass in
> @sglist and keep using "goto new_segment"?

I think this deserves another patch on top of this splitting one. I'd 
like to clean this up later.

-- 
Asias


