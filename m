Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758221Ab2CWLud (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 07:50:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44577 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758193Ab2CWLub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 07:50:31 -0400
Date: Fri, 23 Mar 2012 11:50:25 +0000
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Dan Smith <danms@us.ibm.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [RFC][PATCH 03/26] mm, mpol: add MPOL_MF_LAZY ...
Message-ID: <20120323115025.GE16573@suse.de>
References: <20120316144028.036474157@chello.nl>
 <20120316144240.307470041@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20120316144240.307470041@chello.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2012 at 03:40:31PM +0100, Peter Zijlstra wrote:
> From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
> 
> This patch adds another mbind() flag to request "lazy migration".
> The flag, MPOL_MF_LAZY, modifies MPOL_MF_MOVE* such that the selected
> pages are simply unmapped from the calling task's page table ['_MOVE]
> or from all referencing page tables [_MOVE_ALL].  Anon pages will first
> be added to the swap [or migration?] cache, if necessary.  The pages
> will be migrated in the fault path on "first touch", if the policy
> dictates at that time.
> 
> <SNIP>
>
> @@ -950,6 +950,98 @@ static int unmap_and_move_huge_page(new_
>  }
>  
>  /*
> + * Lazy migration:  just unmap pages, moving anon pages to swap cache, if
> + * necessary.  Migration will occur, if policy dictates, when a task faults
> + * an unmapped page back into its page table--i.e., on "first touch" after
> + * unmapping.  Note that migrate-on-fault only migrates pages whose mapping
> + * [e.g., file system] supplies a migratepage op, so we skip pages that
> + * wouldn't migrate on fault.
> + *
> + * Pages are placed back on the lru whether or not they were successfully
> + * unmapped.  Like migrate_pages().
> + *
> + * Unline migrate_pages(), this function is only called in the context of
> + * a task that is unmapping it's own pages while holding its map semaphore
> + * for write.
> + */
> +int migrate_pages_unmap_only(struct list_head *pagelist)

I'm not properly reviewing these patches at the moment but am taking a
quick look as I play some catch up on linux-mm.

I think it's worth pointing out that this potentially will confuse
reclaim. Lets say a process is being migrated to another node and it
gets unmapped like this then some heuristics will change.

1. If the page was referenced prior to the unmapping then it should be
   activated if the page reached the end of the LRU due to the checks
   in page_check_references(). If the process has been unmapped for
   migrate-on-fault, the pages will instead be reclaimed.

2. The heuristic that applies pressure to slab pages if pages are mapped
   is changed. Prior to migrate-on-fault sc->nr_scanned is incremented
   for mapped pages to increase the number of slab pages scanned to
   avoid swapping. During migrate-on-fault, this pressure is relieved

3. zone_reclaim_mode in default mode will reclaim pages it would
   previously have skipped over. It potentially will call shrink_zone more
   for the local node than falling back to other nodes because it thinks
   most pages are unmapped. This could lead to some trashing.

It may not even be a major problem but it's worth thinking about. If it
is a problem, it will be necessary to account for migrate-on-fault pages
similar to mapped pages during reclaim.

-- 
Mel Gorman
SUSE Labs
