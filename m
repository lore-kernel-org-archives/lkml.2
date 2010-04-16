Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751512Ab0DPEU4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 00:20:56 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61727 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751178Ab0DPEUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 00:20:54 -0400
Message-ID: <4BC7E56C.4070906@cn.fujitsu.com>
Date: Fri, 16 Apr 2010 12:19:56 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Divyesh Shah <dpshah@google.com>, jens.axboe@oracle.com
CC: vgoyal@redhat.com, linux-kernel@vger.kernel.org, lizf@cn.fujitsu.com
Subject: Re: [PATCH] blkio: Initialize blkg->stats_lock for the root cfqg
 too
References: <20100416040144.3739.94764.stgit@austin.mtv.corp.google.com>
In-Reply-To: <20100416040144.3739.94764.stgit@austin.mtv.corp.google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Divyesh Shah wrote:
> This fixes the lockdep warning reported by Gui Jianfeng.
> 
> Signed-off-by: Divyesh Shah <dpshah@google.com>

This patch looks good to me.
Reviewed-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>

> ---
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
> 
> 
> 
> 

-- 
Regards
Gui Jianfeng

