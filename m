Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650Ab0KLIUJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 03:20:09 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:40400 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754998Ab0KLIUH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 03:20:07 -0500
Date: Fri, 12 Nov 2010 09:19:57 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Greg Thelen <gthelen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Minchan Kim <minchan.kim@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] memcg: simplify mem_cgroup_page_stat()
Message-ID: <20101112081957.GF9131@cmpxchg.org>
References: <1289294671-6865-1-git-send-email-gthelen@google.com>
 <1289294671-6865-5-git-send-email-gthelen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289294671-6865-5-git-send-email-gthelen@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 01:24:29AM -0800, Greg Thelen wrote:
> The cgroup given to mem_cgroup_page_stat() is no allowed to be
> NULL or the root cgroup.  So there is no need to complicate the code
> handling those cases.
> 
> Signed-off-by: Greg Thelen <gthelen@google.com>
> ---
>  mm/memcontrol.c |   48 ++++++++++++++++++++++--------------------------
>  1 files changed, 22 insertions(+), 26 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index eb621ee..f8df350 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1364,12 +1364,10 @@ memcg_hierarchical_free_pages(struct mem_cgroup *mem)
>  
>  /*
>   * mem_cgroup_page_stat() - get memory cgroup file cache statistics
> - * @mem:	optional memory cgroup to query.  If NULL, use current task's
> - *		cgroup.
> + * @mem:	memory cgroup to query
>   * @item:	memory statistic item exported to the kernel
>   *
> - * Return the accounted statistic value or negative value if current task is
> - * root cgroup.
> + * Return the accounted statistic value.
>   */
>  long mem_cgroup_page_stat(struct mem_cgroup *mem,
>  			  enum mem_cgroup_nr_pages_item item)
> @@ -1377,29 +1375,27 @@ long mem_cgroup_page_stat(struct mem_cgroup *mem,
>  	struct mem_cgroup *iter;
>  	long value;
>  
> +	VM_BUG_ON(!mem);
> +	VM_BUG_ON(mem_cgroup_is_root(mem));
> +
>  	get_online_cpus();
> -	rcu_read_lock();
> -	if (!mem)
> -		mem = mem_cgroup_from_task(current);
> -	if (__mem_cgroup_has_dirty_limit(mem)) {

What about mem->use_hierarchy that is checked in
__mem_cgroup_has_dirty_limit()?  Is it no longer needed?
