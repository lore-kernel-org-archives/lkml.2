Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587Ab2GTG1t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 02:27:49 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:54409 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750752Ab2GTG1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 02:27:47 -0400
Date: Fri, 20 Jul 2012 08:27:20 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan@kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "andi.kleen" <andi.kleen@intel.com>, linux-mm <linux-mm@kvack.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Cgroup: Fix memory accounting scalability in
 shrink_page_list
Message-ID: <20120720062720.GD1505@cmpxchg.org>
References: <1342740866.13492.50.camel@schen9-DESK>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342740866.13492.50.camel@schen9-DESK>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2012 at 04:34:26PM -0700, Tim Chen wrote:
> Hi,
> 
> I noticed in a multi-process parallel files reading benchmark I ran on a
> 8 socket machine,  throughput slowed down by a factor of 8 when I ran
> the benchmark within a cgroup container.  I traced the problem to the
> following code path (see below) when we are trying to reclaim memory
> from file cache.  The res_counter_uncharge function is called on every
> page that's reclaimed and created heavy lock contention.  The patch
> below allows the reclaimed pages to be uncharged from the resource
> counter in batch and recovered the regression. 
> 
> Tim
> 
>      40.67%           usemem  [kernel.kallsyms]                   [k] _raw_spin_lock
>                       |
>                       --- _raw_spin_lock
>                          |
>                          |--92.61%-- res_counter_uncharge
>                          |          |
>                          |          |--100.00%-- __mem_cgroup_uncharge_common
>                          |          |          |
>                          |          |          |--100.00%-- mem_cgroup_uncharge_cache_page
>                          |          |          |          __remove_mapping
>                          |          |          |          shrink_page_list
>                          |          |          |          shrink_inactive_list
>                          |          |          |          shrink_mem_cgroup_zone
>                          |          |          |          shrink_zone
>                          |          |          |          do_try_to_free_pages
>                          |          |          |          try_to_free_pages
>                          |          |          |          __alloc_pages_nodemask
>                          |          |          |          alloc_pages_current
> 
> 
> ---
> Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>

Good one.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
