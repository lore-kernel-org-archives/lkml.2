Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759166Ab2CMRyO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 13:54:14 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:55683 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758394Ab2CMRyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 13:54:13 -0400
Date: Tue, 13 Mar 2012 18:53:56 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Tejun Heo <tj@kernel.org>, Ying Han <yinghan@google.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 3.3] memcg: free mem_cgroup by RCU to fix oops
Message-ID: <20120313175356.GB1708@cmpxchg.org>
References: <alpine.LSU.2.00.1203072155140.11048@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1203072155140.11048@eggly.anvils>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2012 at 10:01:50PM -0800, Hugh Dickins wrote:
> After fixing the GPF in mem_cgroup_lru_del_list(), three times one
> machine running a similar load (moving and removing memcgs while swapping)
> has oopsed in mem_cgroup_zone_nr_lru_pages(), when retrieving memcg zone
> numbers for get_scan_count() for shrink_mem_cgroup_zone(): this is where a
> struct mem_cgroup is first accessed after being chosen by mem_cgroup_iter().
> 
> Just what protects a struct mem_cgroup from being freed, in between
> mem_cgroup_iter()'s css_get_next() and its css_tryget()?  css_tryget()
> fails once css->refcnt is zero with CSS_REMOVED set in flags, yes: but
> what if that memory is freed and reused for something else, which sets
> "refcnt" non-zero?  Hmm, and scope for an indefinite freeze if refcnt
> is left at zero but flags are cleared.
> 
> It's tempting to move the css_tryget() into css_get_next(), to make it
> really "get" the css, but I don't think that actually solves anything:
> the same difficulty in moving from css_id found to stable css remains.

I don't think so, either, as long as the css_id can be found after the
synchronize_rcu() between freezing the refcount and freeing the group.

> But we already have rcu_read_lock() around the two, so it's easily
> fixed if __mem_cgroup_free() just uses kfree_rcu() to free mem_cgroup.
> 
> However, a big struct mem_cgroup is allocated with vzalloc() instead
> of kzalloc(), and we're not allowed to vfree() at interrupt time:
> there doesn't appear to be a general vfree_rcu() to help with this,
> so roll our own using schedule_work().  The compiler decently removes
> vfree_work() and vfree_rcu() when the config doesn't need them.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
