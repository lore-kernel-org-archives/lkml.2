Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173Ab1HCVBJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 17:01:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3385 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754516Ab1HCVBC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 17:01:02 -0400
Date: Wed, 3 Aug 2011 17:00:54 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] CFQ: clarify code touching 'cic_index' a bit
Message-ID: <20110803210054.GD32385@redhat.com>
References: <1312400476.22854.1.camel@t41.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312400476.22854.1.camel@t41.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 03, 2011 at 09:41:12PM +0200, Paul Bolle wrote:
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
>  block/cfq-iosched.c |   17 ++++++++---------
>  1 files changed, 8 insertions(+), 9 deletions(-)
> 
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index 1f96ad6..601a24c 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -3948,39 +3948,38 @@ static void cfq_exit_queue(struct elevator_queue *e)
>  	kfree(cfqd);
>  }
>  
> -static int cfq_alloc_cic_index(void)
> +static int cfq_alloc_cic_index(int *cic_index)

Changing function signature does not make it any more clear.


>  {
> -	int index, error;
> +	int error;
>  
>  	do {
>  		if (!ida_pre_get(&cic_index_ida, GFP_KERNEL))
>  			return -ENOMEM;
>  
>  		spin_lock(&cic_index_lock);
> -		error = ida_get_new(&cic_index_ida, &index);
> +		error = ida_get_new(&cic_index_ida, cic_index);
>  		spin_unlock(&cic_index_lock);
>  		if (error && error != -EAGAIN)
>  			return error;
>  	} while (error);
>  
> -	return index;
> +	return 0;
>  }
>  
>  static void *cfq_init_queue(struct request_queue *q)
>  {
>  	struct cfq_data *cfqd;
> -	int i, j;
> +	int i, j, cic_index;

If you want it little more clear then rename i to cic_index.

Thanks
Vivek

>  	struct cfq_group *cfqg;
>  	struct cfq_rb_root *st;
>  
> -	i = cfq_alloc_cic_index();
> -	if (i < 0)
> +	if (cfq_alloc_cic_index(&cic_index))
>  		return NULL;
>  
>  	cfqd = kmalloc_node(sizeof(*cfqd), GFP_KERNEL | __GFP_ZERO, q->node);
>  	if (!cfqd) {
>  		spin_lock(&cic_index_lock);
> -		ida_remove(&cic_index_ida, i);
> +		ida_remove(&cic_index_ida, cic_index);
>  		spin_unlock(&cic_index_lock);
>  		return NULL;
>  	}
> @@ -3989,7 +3988,7 @@ static void *cfq_init_queue(struct request_queue *q)
>  	 * Don't need take queue_lock in the routine, since we are
>  	 * initializing the ioscheduler, and nobody is using cfqd
>  	 */
> -	cfqd->cic_index = i;
> +	cfqd->cic_index = cic_index;
>  
>  	/* Init root service tree */
>  	cfqd->grp_service_tree = CFQ_RB_ROOT;
> -- 
> 1.7.6
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
