Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197Ab1AQOG7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 09:06:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6293 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752728Ab1AQOG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 09:06:57 -0500
Date: Mon, 17 Jan 2011 09:06:48 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Jens Axboe <jaxboe@fusionio.com>,
        "jmoyer@redhat.com" <jmoyer@redhat.com>,
        Corrado Zoccolo <czoccolo@gmail.com>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [PATCH 2/2]block cfq: compensate preempted queue even if it has
 no slice assigned
Message-ID: <20110117140648.GB5624@redhat.com>
References: <1294735917.1949.638.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294735917.1949.638.camel@sli10-conroe>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 04:51:57PM +0800, Shaohua Li wrote:
> If a queue is preempted before it gets slice assigned, the queue doesn't get
> compensation, which looks unfair. For such queue, we compensate it for a whole
> slice.
> 
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> 
> ---
>  block/cfq-iosched.c |   19 +++++++++++++++----
>  1 file changed, 15 insertions(+), 4 deletions(-)
> 
> Index: linux/block/cfq-iosched.c
> ===================================================================
> --- linux.orig/block/cfq-iosched.c	2011-01-10 15:37:33.000000000 +0800
> +++ linux/block/cfq-iosched.c	2011-01-10 15:54:28.000000000 +0800
> @@ -605,8 +605,8 @@ cfq_group_slice(struct cfq_data *cfqd, s
>  	return cfq_target_latency * cfqg->weight / st->total_weight;
>  }
>  
> -static inline void
> -cfq_set_prio_slice(struct cfq_data *cfqd, struct cfq_queue *cfqq)
> +static inline unsigned
> +cfq_scaled_group_slice(struct cfq_data *cfqd, struct cfq_queue *cfqq)
>  {

Shaohua,

Above name "cfq_scaled_group_slice()" does not seem appropriate. It sounds
as if we are calculating scaled group slice length but the fact is we
are trying to come up with slice length of cfqq. So a better name might
be cfq_scaled_slice_cfqq() or cfqq_scaled_slice() something like that. 

Thanks
Vivek

>  	unsigned slice = cfq_prio_to_slice(cfqd, cfqq);
>  	if (cfqd->cfq_latency) {
> @@ -632,6 +632,14 @@ cfq_set_prio_slice(struct cfq_data *cfqd
>  				    low_slice);
>  		}
>  	}
> +	return slice;
> +}
> +
> +static inline void
> +cfq_set_prio_slice(struct cfq_data *cfqd, struct cfq_queue *cfqq)
> +{
> +	unsigned slice = cfq_scaled_group_slice(cfqd, cfqq);
> +
>  	cfqq->slice_start = jiffies;
>  	cfqq->slice_end = jiffies + slice;
>  	cfqq->allocated_slice = slice;
> @@ -1672,8 +1680,11 @@ __cfq_slice_expired(struct cfq_data *cfq
>  	/*
>  	 * store what was left of this slice, if the queue idled/timed out
>  	 */
> -	if (timed_out && !cfq_cfqq_slice_new(cfqq)) {
> -		cfqq->slice_resid = cfqq->slice_end - jiffies;
> +	if (timed_out) {
> +		if (cfq_cfqq_slice_new(cfqq))
> +			cfqq->slice_resid = cfq_scaled_group_slice(cfqd, cfqq);
> +		else
> +			cfqq->slice_resid = cfqq->slice_end - jiffies;
>  		cfq_log_cfqq(cfqd, cfqq, "resid=%ld", cfqq->slice_resid);
>  	}
>  
> 
