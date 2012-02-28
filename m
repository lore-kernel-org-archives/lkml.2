Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757418Ab2B1WpL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 17:45:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58378 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755456Ab2B1WpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 17:45:09 -0500
Date: Tue, 28 Feb 2012 14:45:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Greg Thelen <gthelen@google.com>, Jan Kara <jack@suse.cz>,
        Ying Han <yinghan@google.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/9] memcg: dirty page accounting support routines
Message-Id: <20120228144507.acd70d1e.akpm@linux-foundation.org>
In-Reply-To: <20120228144747.124608935@intel.com>
References: <20120228140022.614718843@intel.com>
	<20120228144747.124608935@intel.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Feb 2012 22:00:26 +0800
Fengguang Wu <fengguang.wu@intel.com> wrote:

> From: Greg Thelen <gthelen@google.com>
> 
> Added memcg dirty page accounting support routines.  These routines are
> used by later changes to provide memcg aware writeback and dirty page
> limiting.  A mem_cgroup_dirty_info() tracepoint is is also included to
> allow for easier understanding of memcg writeback operation.
> 
> ...
>
> +/*
> + * Return the number of additional pages that the @memcg cgroup could allocate.
> + * If use_hierarchy is set, then this involves checking parent mem cgroups to
> + * find the cgroup with the smallest free space.
> + */

Comment needs revisting - use_hierarchy does not exist.

> +static unsigned long
> +mem_cgroup_hierarchical_free_pages(struct mem_cgroup *memcg)
> +{
> +	u64 free;
> +	unsigned long min_free;
> +
> +	min_free = global_page_state(NR_FREE_PAGES);
> +
> +	while (memcg) {
> +		free = mem_cgroup_margin(memcg);
> +		min_free = min_t(u64, min_free, free);
> +		memcg = parent_mem_cgroup(memcg);
> +	}
> +
> +	return min_free;
> +}
> +
> +/*
> + * mem_cgroup_page_stat() - get memory cgroup file cache statistics
> + * @memcg:     memory cgroup to query
> + * @item:      memory statistic item exported to the kernel
> + *
> + * Return the accounted statistic value.
> + */
> +unsigned long mem_cgroup_page_stat(struct mem_cgroup *memcg,
> +				   enum mem_cgroup_page_stat_item item)
> +{
> +	struct mem_cgroup *iter;
> +	s64 value;
> +
> +	/*
> +	 * If we're looking for dirtyable pages we need to evaluate free pages
> +	 * depending on the limit and usage of the parents first of all.
> +	 */
> +	if (item == MEMCG_NR_DIRTYABLE_PAGES)
> +		value = mem_cgroup_hierarchical_free_pages(memcg);
> +	else
> +		value = 0;
> +
> +	/*
> +	 * Recursively evaluate page statistics against all cgroup under
> +	 * hierarchy tree
> +	 */
> +	for_each_mem_cgroup_tree(iter, memcg)
> +		value += mem_cgroup_local_page_stat(iter, item);

What's the locking rule for for_each_mem_cgroup_tree()?  It's unobvious
from the code and isn't documented?

> +	/*
> +	 * Summing of unlocked per-cpu counters is racy and may yield a slightly
> +	 * negative value.  Zero is the only sensible value in such cases.
> +	 */
> +	if (unlikely(value < 0))
> +		value = 0;
> +
> +	return value;
> +}
> +
>
> ...
>
