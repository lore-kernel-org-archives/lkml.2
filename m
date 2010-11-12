Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554Ab0KLIS3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 03:18:29 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:40390 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755411Ab0KLISS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 03:18:18 -0500
Date: Fri, 12 Nov 2010 09:17:55 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Greg Thelen <gthelen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Minchan Kim <minchan.kim@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] memcg: make throttle_vm_writeout() memcg aware
Message-ID: <20101112081754.GE9131@cmpxchg.org>
References: <1289294671-6865-1-git-send-email-gthelen@google.com>
 <1289294671-6865-4-git-send-email-gthelen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289294671-6865-4-git-send-email-gthelen@google.com>
11;rgb: 0000/0000/0000From: Johannes Weiner <hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 01:24:28AM -0800, Greg Thelen wrote:
> If called with a mem_cgroup, then throttle_vm_writeout() should
> query the given cgroup for its dirty memory usage limits.
> 
> dirty_writeback_pages() is no longer used, so delete it.
> 
> Signed-off-by: Greg Thelen <gthelen@google.com>
> ---
>  include/linux/writeback.h |    2 +-
>  mm/page-writeback.c       |   31 ++++++++++++++++---------------
>  mm/vmscan.c               |    2 +-
>  3 files changed, 18 insertions(+), 17 deletions(-)

> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index d717fa9..bf85062 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -131,18 +131,6 @@ EXPORT_SYMBOL(laptop_mode);
>  static struct prop_descriptor vm_completions;
>  static struct prop_descriptor vm_dirties;
>  
> -static unsigned long dirty_writeback_pages(void)
> -{
> -	unsigned long ret;
> -
> -	ret = mem_cgroup_page_stat(NULL, MEMCG_NR_DIRTY_WRITEBACK_PAGES);
> -	if ((long)ret < 0)
> -		ret = global_page_state(NR_UNSTABLE_NFS) +
> -			global_page_state(NR_WRITEBACK);

There are two bugfixes in this patch.  One is getting rid of this
fallback to global numbers that are compared to memcg limits.  The
other one is that reclaim will now throttle writeout based on the
cgroup it runs on behalf of, instead of that of the current task.

Both are undocumented and should arguably not even be in the same
patch...?

> @@ -703,12 +691,25 @@ void balance_dirty_pages_ratelimited_nr(struct address_space *mapping,
>  }
>  EXPORT_SYMBOL(balance_dirty_pages_ratelimited_nr);
>  
> -void throttle_vm_writeout(gfp_t gfp_mask)
> +/*
> + * Throttle the current task if it is near dirty memory usage limits.
> + * If @mem_cgroup is NULL or the root_cgroup, then use global dirty memory
> + * information; otherwise use the per-memcg dirty limits.
> + */
> +void throttle_vm_writeout(gfp_t gfp_mask, struct mem_cgroup *mem_cgroup)
>  {
>  	struct dirty_info dirty_info;
> +	unsigned long nr_writeback;
>  
>          for ( ; ; ) {
> -		global_dirty_info(&dirty_info);
> +		if (!mem_cgroup || !memcg_dirty_info(mem_cgroup, &dirty_info)) {
> +			global_dirty_info(&dirty_info);
> +			nr_writeback = global_page_state(NR_UNSTABLE_NFS) +
> +				global_page_state(NR_WRITEBACK);
> +		} else {
> +			nr_writeback = mem_cgroup_page_stat(
> +				mem_cgroup, MEMCG_NR_DIRTY_WRITEBACK_PAGES);
> +		}

Odd branch ordering, but I may be OCDing again.

	if (mem_cgroup && memcg_dirty_info())
		do_mem_cgroup_stuff()
	else
		do_global_stuff()

would be more natural, IMO.
