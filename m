Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800Ab1AXWxE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 17:53:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56276 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751878Ab1AXWxC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 17:53:02 -0500
Date: Mon, 24 Jan 2011 17:52:53 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Jens Axboe <axboe@kernel.dk>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Corrado Zoccolo <czoccolo@gmail.com>,
        Chad Talbott <ctalbott@google.com>, Nauman Rafique <nauman@google.com>,
        Divyesh Shah <dpshah@google.com>, jmoyer@redhat.com,
        Shaohua Li <shaohua.li@intel.com>
Subject: Re: [PATCH 5/6 v3] cfq-iosched: CFQ group hierarchical scheduling
 and use_hierarchy interface
Message-ID: <20110124225253.GF9420@redhat.com>
References: <4D180ECE.4000305@cn.fujitsu.com>
 <4D185382.8080601@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D185382.8080601@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 27, 2010 at 04:51:14PM +0800, Gui Jianfeng wrote:

[..]
> -static struct cfq_group *cfq_get_next_cfqg(struct cfq_data *cfqd);
> -
>  static struct cfq_rb_root *service_tree_for(struct cfq_group *cfqg,
>  					    enum wl_prio_t prio,
>  					    enum wl_type_t type)
> @@ -640,10 +646,19 @@ static inline unsigned cfq_group_get_avg_queues(struct cfq_data *cfqd,
>  static inline unsigned
>  cfq_group_slice(struct cfq_data *cfqd, struct cfq_group *cfqg)
>  {
> -	struct cfq_rb_root *st = &cfqd->grp_service_tree;
>  	struct cfq_entity *cfqe = &cfqg->cfqe;
> +	struct cfq_rb_root *st = cfqe->service_tree;
> +	int group_slice = cfq_target_latency;
> +
> +	/* Calculate group slice in a hierarchical way */
> +	do {
> +		group_slice = group_slice * cfqe->weight / st->total_weight;
> +		cfqe = cfqe->parent;
> +		if (cfqe)
> +			st = cfqe->service_tree;
> +	} while (cfqe);
>  
> -	return cfq_target_latency * cfqe->weight / st->total_weight;
> +	return group_slice;
>  }

Gui, I think this is still not fully correct. In flat mode there was
only 1 service tree at top and all the groups were on that service tree
so st->total_weight worked fine.

But now with hierarchical mode, children group might be on one of the
sync-idle tree and there might be other queues on other service tree
in the parent group. 

So we shall have to have a notion of total group weigt (and not just
service tree weight) to calculate this accurately I think.

Secondly, this logic does not take into account the ioprio or sync/async
to calculate the group share. I think for the time being we can keep
it simple and later look into it to refine it.

Also I want to have some integration/simplification of workload slice
a and cfqq slice calculation logic with group slice logic. I guess will take
that up later.

>  
>  static inline void
> @@ -666,7 +681,8 @@ cfq_set_prio_slice(struct cfq_data *cfqd, struct cfq_queue *cfqq)
>  			/* scale low_slice according to IO priority
>  			 * and sync vs async */
>  			unsigned low_slice =
> -				min(slice, base_low_slice * slice / sync_slice);
> +				min(slice, base_low_slice * slice /
> +				    sync_slice);

Why extra line?

Thanks
Vivek
