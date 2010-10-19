Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758345Ab0JSLuZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 07:50:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19701 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758069Ab0JSLuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 07:50:24 -0400
Date: Tue, 19 Oct 2010 07:49:33 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Andi Kleen <andi@firstfloor.org>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] Fix array overflow in CFQ
Message-ID: <20101019114933.GA857@redhat.com>
References: <1287479450-11447-1-git-send-email-andi@firstfloor.org>
 <4CBD6C84.3020309@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4CBD6C84.3020309@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 12:01:40PM +0200, Jens Axboe wrote:
> On 2010-10-19 11:10, Andi Kleen wrote:
> > From: Andi Kleen <ak@linux.intel.com>
> > 
> > gcc 4.5 complains when compiling a recent rc with
> > 
> > linux/block/cfq-iosched.c: In function ‘cfq_dispatch_requests’:
> > linux/block/cfq-iosched.c:2156:3: warning: array subscript is above array bounds
> > 
> > and it is right:
> > 
> >  slice = group_slice * count /
> >                 max_t(unsigned, cfqg->busy_queues_avg[cfqd->serving_prio],
> >                       cfq_group_busy_queues_wl(cfqd->serving_prio, cfqd, cfqg));
> > 
> > busy_queues_avg can be indexed by this enum
> > 
> > enum wl_prio_t {
> >         BE_WORKLOAD = 0,
> >         RT_WORKLOAD = 1,
> >         IDLE_WORKLOAD = 2,
> > };
> > 
> > in cfqd->serving_prio, but is only declared as
> > 
> > unsigned int busy_queues_avg[2];
> > 
> > which is clearly off by one. Fix this here.
> 
> Indeed, that is definitely buggy. ->service_trees[][] looks buggy, too.
> WTF?!

Hi Jens,

busy_queues_avg[] definitely looks buggy. Looks like I introduced this bug
while converting corrado's logic to group logic. I will fix it in a while.
Sorry for the goof up here.

->service_trees[][] is not buggy. We maintain workload subclassification
only for RT and BE class. For IDLE class, there are no ASYNC_WORKLOAD,
SYNC_NOIDLE_WORKLOAD or SYNC_WORKLOAD. All the type of idle queues
go onto a separate service tree, service_tree_idle.

Thanks
Vivek

> 
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index 9eba291..8ce9f52 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -160,6 +160,7 @@ enum wl_prio_t {
>  	BE_WORKLOAD = 0,
>  	RT_WORKLOAD = 1,
>  	IDLE_WORKLOAD = 2,
> +	CFQ_PRIO_NR,
>  };
>  
>  /*
> @@ -168,7 +169,8 @@ enum wl_prio_t {
>  enum wl_type_t {
>  	ASYNC_WORKLOAD = 0,
>  	SYNC_NOIDLE_WORKLOAD = 1,
> -	SYNC_WORKLOAD = 2
> +	SYNC_WORKLOAD = 2,
> +	CFQ_TYPE_NR,
>  };
>  
>  /* This is per cgroup per device grouping structure */
> @@ -185,12 +187,12 @@ struct cfq_group {
>  	int nr_cfqq;
>  
>  	/* Per group busy queus average. Useful for workload slice calc. */
> -	unsigned int busy_queues_avg[2];
> +	unsigned int busy_queues_avg[CFQ_PRIO_NR];
>  	/*
>  	 * rr lists of queues with requests, onle rr for each priority class.
>  	 * Counts are embedded in the cfq_rb_root
>  	 */
> -	struct cfq_rb_root service_trees[2][3];
> +	struct cfq_rb_root service_trees[CFQ_PRIO_NR][CFQ_TYPE_NR];
>  	struct cfq_rb_root service_tree_idle;
>  
>  	unsigned long saved_workload_slice;
> 
> -- 
> Jens Axboe
