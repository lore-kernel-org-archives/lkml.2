Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758351Ab0LMQ7g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 11:59:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5549 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758315Ab0LMQ7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 11:59:35 -0500
Date: Mon, 13 Dec 2010 11:59:26 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Jens Axboe <axboe@kernel.dk>, Corrado Zoccolo <czoccolo@gmail.com>,
        Chad Talbott <ctalbott@google.com>, Nauman Rafique <nauman@google.com>,
        Divyesh Shah <dpshah@google.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/8 v2] cfq-iosched: Introduce cfq_entity for CFQ group
Message-ID: <20101213165925.GF20454@redhat.com>
References: <4CDF7BC5.9080803@cn.fujitsu.com>
 <4CDF9CC6.2040106@cn.fujitsu.com>
 <20101115165319.GI30792@redhat.com>
 <4CE2718C.6010406@kernel.dk>
 <4D01C6AB.9040807@cn.fujitsu.com>
 <4D057A81.1000901@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D057A81.1000901@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 13, 2010 at 09:44:33AM +0800, Gui Jianfeng wrote:
> Introduce cfq_entity for CFQ group
> 
> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> ---
>  block/cfq-iosched.c |  113 ++++++++++++++++++++++++++++++--------------------
>  1 files changed, 68 insertions(+), 45 deletions(-)
> 
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index 9b07a24..91e9833 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -1,5 +1,5 @@
>  /*
> - *  CFQ, or complete fairness queueing, disk scheduler.
> + *  Cfq, or complete fairness queueing, disk scheduler.

Is this really required?

>   *
>   *  Based on ideas from a previously unfinished io
>   *  scheduler (round robin per-process disk scheduling) and Andrea Arcangeli.
> @@ -73,7 +73,8 @@ static DEFINE_IDA(cic_index_ida);
>  #define cfq_class_rt(cfqq)	((cfqq)->ioprio_class == IOPRIO_CLASS_RT)
>  
>  #define sample_valid(samples)	((samples) > 80)
> -#define rb_entry_cfqg(node)	rb_entry((node), struct cfq_group, rb_node)
> +#define rb_entry_entity(node)	rb_entry((node), struct cfq_entity,\
> +					 rb_node)
>  
>  /*
>   * Most of our rbtree usage is for sorting with min extraction, so
> @@ -102,6 +103,11 @@ struct cfq_entity {
>  	struct rb_node rb_node;
>  	/* service_tree key, represent the position on the tree */
>  	unsigned long rb_key;
> +
> +	/* group service_tree key */
> +	u64 vdisktime;
> +	bool is_group_entity;
> +	unsigned int weight;
>  };
>  
>  /*
> @@ -183,12 +189,8 @@ enum wl_type_t {
>  
>  /* This is per cgroup per device grouping structure */
>  struct cfq_group {
> -	/* group service_tree member */
> -	struct rb_node rb_node;
> -
> -	/* group service_tree key */
> -	u64 vdisktime;
> -	unsigned int weight;
> +	/* cfq group sched entity */
> +	struct cfq_entity cfqe;
>  
>  	/* number of cfqq currently on this group */
>  	int nr_cfqq;
> @@ -315,12 +317,21 @@ struct cfq_data {
>  static inline struct cfq_queue *
>  cfqq_of_entity(struct cfq_entity *cfqe)
>  {
> -	if (cfqe)
> +	if (cfqe && !cfqe->is_group_entity)
>  		return container_of(cfqe, struct cfq_queue,
>  				    cfqe);

can be single line above. I think came from previous patch.

>  	return NULL;
>  }
>  
> +static inline struct cfq_group *
> +cfqg_of_entity(struct cfq_entity *cfqe)
> +{
> +	if (cfqe && cfqe->is_group_entity)
> +		return container_of(cfqe, struct cfq_group,
> +				    cfqe);

No need to split line.

> +	return NULL;
> +}
> +
>  static struct cfq_group *cfq_get_next_cfqg(struct cfq_data *cfqd);
>  
>  static struct cfq_rb_root *service_tree_for(struct cfq_group *cfqg,
> @@ -548,12 +559,12 @@ cfq_prio_to_slice(struct cfq_data *cfqd, struct cfq_queue *cfqq)
>  	return cfq_prio_slice(cfqd, cfq_cfqq_sync(cfqq), cfqq->ioprio);
>  }
>  
> -static inline u64 cfq_scale_slice(unsigned long delta, struct cfq_group *cfqg)
> +static inline u64 cfq_scale_slice(unsigned long delta, struct cfq_entity *cfqe)
>  {
>  	u64 d = delta << CFQ_SERVICE_SHIFT;
>  
>  	d = d * BLKIO_WEIGHT_DEFAULT;
> -	do_div(d, cfqg->weight);
> +	do_div(d, cfqe->weight);
>  	return d;
>  }
>  
> @@ -578,11 +589,11 @@ static inline u64 min_vdisktime(u64 min_vdisktime, u64 vdisktime)
>  static void update_min_vdisktime(struct cfq_rb_root *st)
>  {
>  	u64 vdisktime = st->min_vdisktime;
> -	struct cfq_group *cfqg;
> +	struct cfq_entity *cfqe;
>  
>  	if (st->left) {
> -		cfqg = rb_entry_cfqg(st->left);
> -		vdisktime = min_vdisktime(vdisktime, cfqg->vdisktime);
> +		cfqe = rb_entry_entity(st->left);
> +		vdisktime = min_vdisktime(vdisktime, cfqe->vdisktime);
>  	}
>  
>  	st->min_vdisktime = max_vdisktime(st->min_vdisktime, vdisktime);
> @@ -613,8 +624,9 @@ static inline unsigned
>  cfq_group_slice(struct cfq_data *cfqd, struct cfq_group *cfqg)
>  {
>  	struct cfq_rb_root *st = &cfqd->grp_service_tree;
> +	struct cfq_entity *cfqe = &cfqg->cfqe;
>  
> -	return cfq_target_latency * cfqg->weight / st->total_weight;
> +	return cfq_target_latency * cfqe->weight / st->total_weight;
>  }
>  
>  static inline void
> @@ -777,13 +789,13 @@ static struct cfq_entity *cfq_rb_first(struct cfq_rb_root *root)
>  	return NULL;
>  }
>  
> -static struct cfq_group *cfq_rb_first_group(struct cfq_rb_root *root)
> +static struct cfq_entity *cfq_rb_first_entity(struct cfq_rb_root *root)

So now we have two functions. One cfq_rb_first() and one cfq_rb_first_entity()
both returning cfq_entity*? This is confusing. Or you are getting rid of
one in later patches. Why not make use of existing cfq_rb_first()?

Thanks
Vivek
