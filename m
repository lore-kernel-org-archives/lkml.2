Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846Ab2CHGOM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 01:14:12 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44176 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034Ab2CHGOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 01:14:08 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 8 Mar 2012 15:12:32 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Tejun Heo <tj@kernel.org>, Ying Han <yinghan@google.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 3.3] memcg: free mem_cgroup by RCU to fix oops
Message-Id: <20120308151232.8a9c6e3d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.LSU.2.00.1203072155140.11048@eggly.anvils>
References: <alpine.LSU.2.00.1203072155140.11048@eggly.anvils>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Mar 2012 22:01:50 -0800 (PST)
Hugh Dickins <hughd@google.com> wrote:

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
> 
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

Thank you.
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

