Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958Ab2JVIGr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 04:06:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57200 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750848Ab2JVIGp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 04:06:45 -0400
Date: Mon, 22 Oct 2012 08:58:57 +0100
From: Mel Gorman <mgorman@suse.de>
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        hannes@cmpxchg.org, akpm@linux-foundation.org, tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:numa/core] sched/numa/mm: Improve migration
Message-ID: <20121022075857.GA2198@suse.de>
References: <tip-yv9vbiz2s455zxq1ffzx3fye@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <tip-yv9vbiz2s455zxq1ffzx3fye@git.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 10:05:39AM -0700, tip-bot for Peter Zijlstra wrote:
> Commit-ID:  713f937655c4b15131b5a0eae4610918a4febe17
> Gitweb:     http://git.kernel.org/tip/713f937655c4b15131b5a0eae4610918a4febe17
> Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
> AuthorDate: Fri, 12 Oct 2012 19:30:14 +0200
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Mon, 15 Oct 2012 14:18:40 +0200
> 
> sched/numa/mm: Improve migration
> 
> Add THP migration. Extend task_numa_fault() to absorb THP faults.
> 
> [ Would be nice if the gents on Cc: expressed their opinion about
>   this change. A missing detail might be cgroup page accounting,
>   plus the fact that some architectures might cache PMD_NONE pmds
>   in their TLBs, needing some extra TLB magic beyond what we already
>   do here? ]
> 

I'm travelling for a conference at the moment so will not get the chance
to properly review this until I get back. Is there any plan to post the
schednuma patches to linux-mm so the full series can be reviewed? I can
extract the patches from -tip when I get back but it's still less than
ideal from a review standpoint.

Superficially, the patch looks ok but as I lack context on what the
rest of schednuma looks like I cannot be sure so I'm not going to ack
it. Basically this is very similar to __unmap_and_move except it doesn't
deal with migration PTEs -- presumably because the PTE is PROT_NONE so it
gets queued up behind it. There is a downside of that. With migration PTEs,
faults during migration will wait on the PTE. With this approach, I think
multiple faults will alloc a hugepage, realise the ptes are no longer the
same and back off. It should still work but it's potentially more expensive.
Was that considered? Is it deliberate? If so, why?

It also feels like the migration part should have been a helper function
called unmap_and_move_thp() in migrate.c instead of being buried in
mm/huge_memory.c

-- 
Mel Gorman
SUSE Labs
