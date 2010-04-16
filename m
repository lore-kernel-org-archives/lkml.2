Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758403Ab0DPNSX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 09:18:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757155Ab0DPNSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 09:18:21 -0400
Date: Fri, 16 Apr 2010 09:18:08 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Divyesh Shah <dpshah@google.com>
Cc: jens.axboe@oracle.com, guijianfeng@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, lizf@cn.fujitsu.com
Subject: Re: [PATCH] blkio: Initialize blkg->stats_lock for the root cfqg
	too
Message-ID: <20100416131808.GA19151@redhat.com>
References: <20100416040144.3739.94764.stgit@austin.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100416040144.3739.94764.stgit@austin.mtv.corp.google.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 15, 2010 at 09:02:22PM -0700, Divyesh Shah wrote:
> This fixes the lockdep warning reported by Gui Jianfeng.
> 
> Signed-off-by: Divyesh Shah <dpshah@google.com>
> ---

This looks good.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Vivek

> 
>  block/blk-cgroup.c  |    7 +------
>  block/blk-cgroup.h  |    2 --
>  block/cfq-iosched.c |    1 -
>  3 files changed, 1 insertions(+), 9 deletions(-)
> 
> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index 80c1261..83930f6 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -86,12 +86,6 @@ struct blkio_cgroup *cgroup_to_blkio_cgroup(struct cgroup *cgroup)
>  }
>  EXPORT_SYMBOL_GPL(cgroup_to_blkio_cgroup);
>  
> -void blkio_group_init(struct blkio_group *blkg)
> -{
> -	spin_lock_init(&blkg->stats_lock);
> -}
> -EXPORT_SYMBOL_GPL(blkio_group_init);
> -
>  /*
>   * Add to the appropriate stat variable depending on the request type.
>   * This should be called with the blkg->stats_lock held.
> @@ -349,6 +343,7 @@ void blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
>  	unsigned long flags;
>  
>  	spin_lock_irqsave(&blkcg->lock, flags);
> +	spin_lock_init(&blkg->stats_lock);
>  	rcu_assign_pointer(blkg->key, key);
>  	blkg->blkcg_id = css_id(&blkcg->css);
>  	hlist_add_head_rcu(&blkg->blkcg_node, &blkcg->blkg_list);
> diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
> index 1d409ad..2c956a0 100644
> --- a/block/blk-cgroup.h
> +++ b/block/blk-cgroup.h
> @@ -217,7 +217,6 @@ extern void blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
>  extern int blkiocg_del_blkio_group(struct blkio_group *blkg);
>  extern struct blkio_group *blkiocg_lookup_group(struct blkio_cgroup *blkcg,
>  						void *key);
> -void blkio_group_init(struct blkio_group *blkg);
>  void blkiocg_update_timeslice_used(struct blkio_group *blkg,
>  					unsigned long time);
>  void blkiocg_update_dispatch_stats(struct blkio_group *blkg, uint64_t bytes,
> @@ -235,7 +234,6 @@ struct cgroup;
>  static inline struct blkio_cgroup *
>  cgroup_to_blkio_cgroup(struct cgroup *cgroup) { return NULL; }
>  
> -static inline void blkio_group_init(struct blkio_group *blkg) {}
>  static inline void blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
>  			struct blkio_group *blkg, void *key, dev_t dev) {}
>  
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index 0177109..62defd0 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -961,7 +961,6 @@ cfq_find_alloc_cfqg(struct cfq_data *cfqd, struct cgroup *cgroup, int create)
>  	for_each_cfqg_st(cfqg, i, j, st)
>  		*st = CFQ_RB_ROOT;
>  	RB_CLEAR_NODE(&cfqg->rb_node);
> -	blkio_group_init(&cfqg->blkg);
>  
>  	/*
>  	 * Take the initial reference that will be released on destroy
