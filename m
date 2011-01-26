Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701Ab1AZKDa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 05:03:30 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50209 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557Ab1AZKD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 05:03:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GoOZW6zpuIOicNurWRnDoXe0QquHGDenjxQY6rVd4VxRgmcuSD8RBKdCh9nkcJQ1oE
         gbr1pXbF/ivR6LVHbQDup486go3Tzgp2EdscJTSYf96jJa7zPX3fudo0AxEKYuXLD7HX
         +1sZPuYmIMNT/Oiz/X4mHWdCe57HQEWvwb8kM=
Date: Wed, 26 Jan 2011 11:03:22 +0100
From: Tejun Heo <tj@kernel.org>
To: Mike Snitzer <snitzer@redhat.com>
Cc: axboe@kernel.dk, tytso@mit.edu, djwong@us.ibm.com, shli@kernel.org,
        neilb@suse.de, adilger.kernel@dilger.ca, jack@suse.cz,
        linux-kernel@vger.kernel.org, kmannth@us.ibm.com, cmm@us.ibm.com,
        linux-ext4@vger.kernel.org, rwheeler@redhat.com, hch@lst.de,
        josef@redhat.com, jmoyer@redhat.com
Subject: Re: [KNOWN BUGGY RFC PATCH 4/3] block: skip elevator
 initialization for flush requests
Message-ID: <20110126100322.GC12520@htj.dyndns.org>
References: <1295625598-15203-1-git-send-email-tj@kernel.org>
 <1295625598-15203-4-git-send-email-tj@kernel.org>
 <20110125204158.GA3013@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110125204158.GA3013@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Jan 25, 2011 at 03:41:58PM -0500, Mike Snitzer wrote:
> Unfortunately, in testing I found that flush requests that have data do
> in fact eventually get added to the queue as normal requests, via:
> 1) "data but flush is not necessary" case in blk_insert_flush
> 2) REQ_FSEQ_DATA case in blk_flush_complete_seq
> 
> I know this because in my following get_request() change to _not_ call
> elv_set_request() for flush requests hit cfq_put_request()'s
> BUG_ON(!cfqq->allocated[rw]).  cfqq->allocated[rw] gets set via
> elv_set_request()'s call to cfq_set_request().
> 
> So this seems to call in to question the running theory that flush
> requests can share 'struct request' space with elevator-specific members
> (via union) -- be it rq->rb_node or rq->elevator_private*.

As this part seems to have already been solved, I'm skipping this
part.

> diff --git a/block/blk-core.c b/block/blk-core.c
> index 72dd23b..f507888 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -764,7 +764,7 @@ static struct request *get_request(struct request_queue *q, int rw_flags,
>  	struct request_list *rl = &q->rq;
>  	struct io_context *ioc = NULL;
>  	const bool is_sync = rw_is_sync(rw_flags) != 0;
> -	int may_queue, priv;
> +	int may_queue, priv = 0;
>  
>  	may_queue = elv_may_queue(q, rw_flags);
>  	if (may_queue == ELV_MQUEUE_NO)
> @@ -808,9 +808,14 @@ static struct request *get_request(struct request_queue *q, int rw_flags,
>  	rl->count[is_sync]++;
>  	rl->starved[is_sync] = 0;
>  
> -	priv = !test_bit(QUEUE_FLAG_ELVSWITCH, &q->queue_flags);
> -	if (priv)
> -		rl->elvpriv++;
> +	/*
> +	 * Skip elevator initialization for flush requests
> +	 */
> +	if (!(bio && (bio->bi_rw & (REQ_FLUSH | REQ_FUA)))) {
> +		priv = !test_bit(QUEUE_FLAG_ELVSWITCH, &q->queue_flags);
> +		if (priv)
> +			rl->elvpriv++;
> +	}

I thought about doing it this way but I think we're burying the
REQ_FLUSH|REQ_FUA test logic too deep.  get_request() shouldn't
"magically" know not to allocate elevator data.  The decision should
be made higher in the stack and passed down to get_request().  e.g. if
REQ_SORTED is set in @rw, elevator data is allocated; otherwise, not.

> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 8a082a5..0c569ec 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -99,25 +99,29 @@ struct request {
>  	/*
>  	 * The rb_node is only used inside the io scheduler, requests
>  	 * are pruned when moved to the dispatch queue. So let the
> -	 * flush fields share space with the rb_node.
> +	 * completion_data share space with the rb_node.
>  	 */
>  	union {
>  		struct rb_node rb_node;	/* sort/lookup */
> -		struct {
> -			unsigned int			seq;
> -			struct list_head		list;
> -		} flush;
> +		void *completion_data;
>  	};
>  
> -	void *completion_data;
> -
>  	/*
>  	 * Three pointers are available for the IO schedulers, if they need
> -	 * more they have to dynamically allocate it.
> +	 * more they have to dynamically allocate it.  Let the flush fields
> +	 * share space with these three pointers.
>  	 */
> -	void *elevator_private;
> -	void *elevator_private2;
> -	void *elevator_private3;
> +	union {
> +		struct {
> +			void *private;
> +			void *private2;
> +			void *private3;
> +		} elevator;
> +		struct {
> +			unsigned int			seq;
> +			struct list_head		list;
> +		} flush;
> +	};

Another thing is, can we please make private* an array?  The number
postfixes are irksome.  It's even one based instead of zero!

Also, it would be great to better describe the lifetime difference
between the first and the second unions and why it has be organized
this way (rb_node and completion_data can live together but rb_node
and flush can't).

Thank you.

-- 
tejun
