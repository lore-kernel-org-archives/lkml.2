Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814Ab1HRBbR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 21:31:17 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42640 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090Ab1HRBbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 21:31:14 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 18 Aug 2011 10:23:44 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Greg Thelen <gthelen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, containers@lists.osdl.org,
        linux-fsdevel@vger.kernel.org, Balbir Singh <bsingharora@gmail.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Minchan Kim <minchan.kim@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Dave Chinner <david@fromorbit.com>, Vivek Goyal <vgoyal@redhat.com>,
        Andrea Righi <andrea@betterlinux.com>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v9 11/13] writeback: make background writeback cgroup
 aware
Message-Id: <20110818102344.110829ce.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1313597705-6093-12-git-send-email-gthelen@google.com>
References: <1313597705-6093-1-git-send-email-gthelen@google.com>
	<1313597705-6093-12-git-send-email-gthelen@google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Aug 2011 09:15:03 -0700
Greg Thelen <gthelen@google.com> wrote:

> When the system is under background dirty memory threshold but some
> cgroups are over their background dirty memory thresholds, then only
> writeback inodes associated with the over-limit cgroups.
> 
> In addition to checking if the system dirty memory usage is over the
> system background threshold, over_bground_thresh() now checks if any
> cgroups are over their respective background dirty memory thresholds.
> 
> If over-limit cgroups are found, then the new
> wb_writeback_work.for_cgroup field is set to distinguish between system
> and memcg overages.  The new wb_writeback_work.shared_inodes field is
> also set.  Inodes written by multiple cgroup are marked owned by
> I_MEMCG_SHARED rather than a particular cgroup.  Such shared inodes
> cannot easily be attributed to a cgroup, so per-cgroup writeback
> (futures version of wakeup_flusher_threads and balance_dirty_pages)
> performs suboptimally in the presence of shared inodes.  Therefore,
> write shared inodes when performing cgroup background writeback.
> 
> If performing cgroup writeback, move_expired_inodes() skips inodes that
> do not contribute dirty pages to the cgroup being written back.
> 
> After writing some pages, wb_writeback() will call
> mem_cgroup_writeback_done() to update the set of over-bg-limits memcg.
> 
> This change also makes wakeup_flusher_threads() memcg aware so that
> per-cgroup try_to_free_pages() is able to operate more efficiently
> without having to write pages of foreign containers.  This change adds a
> mem_cgroup parameter to wakeup_flusher_threads() to allow callers,
> especially try_to_free_pages() and foreground writeback from
> balance_dirty_pages(), to specify a particular cgroup to write inodes
> from.
> 
> Signed-off-by: Greg Thelen <gthelen@google.com>
> ---
> Changelog since v8:
> 
> - Added optional memcg parameter to __bdi_start_writeback(),
>   bdi_start_writeback(), wakeup_flusher_threads(), writeback_inodes_wb().
> 
> - move_expired_inodes() now uses pass in struct wb_writeback_work instead of
>   struct writeback_control.
> 
> - Added comments to over_bground_thresh().
> 
>  fs/buffer.c               |    2 +-
>  fs/fs-writeback.c         |   96 +++++++++++++++++++++++++++++++++-----------
>  fs/sync.c                 |    2 +-
>  include/linux/writeback.h |    6 ++-
>  mm/backing-dev.c          |    3 +-
>  mm/page-writeback.c       |    3 +-
>  mm/vmscan.c               |    3 +-
>  7 files changed, 84 insertions(+), 31 deletions(-)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index dd0220b..da1fb23 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -293,7 +293,7 @@ static void free_more_memory(void)
>  	struct zone *zone;
>  	int nid;
>  
> -	wakeup_flusher_threads(1024);
> +	wakeup_flusher_threads(1024, NULL);
>  	yield();
>  
>  	for_each_online_node(nid) {
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index e91fb82..ba55336 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -38,10 +38,14 @@ struct wb_writeback_work {
>  	struct super_block *sb;
>  	unsigned long *older_than_this;
>  	enum writeback_sync_modes sync_mode;
> +	unsigned short memcg_id;	/* If non-zero, then writeback specified
> +					 * cgroup. */
>  	unsigned int tagged_writepages:1;
>  	unsigned int for_kupdate:1;
>  	unsigned int range_cyclic:1;
>  	unsigned int for_background:1;
> +	unsigned int for_cgroup:1;	/* cgroup writeback */
> +	unsigned int shared_inodes:1;	/* write inodes spanning cgroups */
>  
>  	struct list_head list;		/* pending work list */
>  	struct completion *done;	/* set if the caller waits */
> @@ -114,9 +118,12 @@ static void bdi_queue_work(struct backing_dev_info *bdi,
>  	spin_unlock_bh(&bdi->wb_lock);
>  }
>  
> +/*
> + * @memcg is optional.  If set, then limit writeback to the specified cgroup.
> + */
>  static void
>  __bdi_start_writeback(struct backing_dev_info *bdi, long nr_pages,
> -		      bool range_cyclic)
> +		      bool range_cyclic, struct mem_cgroup *memcg)
>  {
>  	struct wb_writeback_work *work;
>  
> @@ -136,6 +143,8 @@ __bdi_start_writeback(struct backing_dev_info *bdi, long nr_pages,
>  	work->sync_mode	= WB_SYNC_NONE;
>  	work->nr_pages	= nr_pages;
>  	work->range_cyclic = range_cyclic;
> +	work->memcg_id = memcg ? css_id(mem_cgroup_css(memcg)) : 0;
> +	work->for_cgroup = memcg != NULL;
>  


I couldn't find a patch for mem_cgroup_css(NULL). Is it in patch 1-10 ?
Other parts seems ok to me.


Thanks,
-Kame

