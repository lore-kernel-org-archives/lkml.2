Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280Ab2B2BRX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 20:17:23 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33517 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753401Ab2B2BRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 20:17:21 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 29 Feb 2012 10:15:49 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>, Greg Thelen <gthelen@google.com>,
        Jan Kara <jack@suse.cz>, Ying Han <yinghan@google.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        Rik van Riel <riel@redhat.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/9] memcg: dirty page accounting support routines
Message-Id: <20120229101549.1d4ef3f3.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20120228144507.acd70d1e.akpm@linux-foundation.org>
References: <20120228140022.614718843@intel.com>
	<20120228144747.124608935@intel.com>
	<20120228144507.acd70d1e.akpm@linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Feb 2012 14:45:07 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 28 Feb 2012 22:00:26 +0800
> Fengguang Wu <fengguang.wu@intel.com> wrote:
> 
> > From: Greg Thelen <gthelen@google.com>
> > 
> > Added memcg dirty page accounting support routines.  These routines are
> > used by later changes to provide memcg aware writeback and dirty page
> > limiting.  A mem_cgroup_dirty_info() tracepoint is is also included to
> > allow for easier understanding of memcg writeback operation.
> > 
> > ...
> >
> > +/*
> > + * Return the number of additional pages that the @memcg cgroup could allocate.
> > + * If use_hierarchy is set, then this involves checking parent mem cgroups to
> > + * find the cgroup with the smallest free space.
> > + */
> 
> Comment needs revisting - use_hierarchy does not exist.
> 
> > +static unsigned long
> > +mem_cgroup_hierarchical_free_pages(struct mem_cgroup *memcg)
> > +{
> > +	u64 free;
> > +	unsigned long min_free;
> > +
> > +	min_free = global_page_state(NR_FREE_PAGES);
> > +
> > +	while (memcg) {
> > +		free = mem_cgroup_margin(memcg);
> > +		min_free = min_t(u64, min_free, free);
> > +		memcg = parent_mem_cgroup(memcg);
> > +	}
> > +
> > +	return min_free;
> > +}
> > +
> > +/*
> > + * mem_cgroup_page_stat() - get memory cgroup file cache statistics
> > + * @memcg:     memory cgroup to query
> > + * @item:      memory statistic item exported to the kernel
> > + *
> > + * Return the accounted statistic value.
> > + */
> > +unsigned long mem_cgroup_page_stat(struct mem_cgroup *memcg,
> > +				   enum mem_cgroup_page_stat_item item)
> > +{
> > +	struct mem_cgroup *iter;
> > +	s64 value;
> > +
> > +	/*
> > +	 * If we're looking for dirtyable pages we need to evaluate free pages
> > +	 * depending on the limit and usage of the parents first of all.
> > +	 */
> > +	if (item == MEMCG_NR_DIRTYABLE_PAGES)
> > +		value = mem_cgroup_hierarchical_free_pages(memcg);
> > +	else
> > +		value = 0;
> > +
> > +	/*
> > +	 * Recursively evaluate page statistics against all cgroup under
> > +	 * hierarchy tree
> > +	 */
> > +	for_each_mem_cgroup_tree(iter, memcg)
> > +		value += mem_cgroup_local_page_stat(iter, item);
> 
> What's the locking rule for for_each_mem_cgroup_tree()?  It's unobvious
> from the code and isn't documented?
> 

Because for_each_mem_cgroup_tree() uses rcu_read_lock() and referernce counting
internally, it's not required to take any lock in callers.
One rule is the caller shoud call mem_cgroup_iter_break() if he want to break
the loop.

Thanks,
-Kame






