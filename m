Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161161Ab2KNLU1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 06:20:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41832 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161052Ab2KNLU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 06:20:26 -0500
Date: Wed, 14 Nov 2012 11:20:22 +0000
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Ingo Molnar <mingo@kernel.org>
Cc: Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Hugh Dickins <hughd@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 29/31] sched: numa: CPU follows memory
Message-ID: <20121114112022.GJ8218@suse.de>
References: <1352805180-1607-1-git-send-email-mgorman@suse.de>
 <1352805180-1607-30-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1352805180-1607-30-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2012 at 11:12:58AM +0000, Mel Gorman wrote:
> @@ -864,6 +1106,21 @@ void task_numa_fault(int node, int pages, bool misplaced)
>  		task_numa_placement(p);
>  }
>  
> +static void reset_ptenuma_scan(struct task_struct *p)
> +{
> +	ACCESS_ONCE(p->mm->numa_scan_seq)++;
> +	
> +	if (p->mm && p->mm->mm_balancenuma)
> +		p->mm->mm_balancenuma->mm_numa_fault_tot >>= 1;
> +	if (p->task_balancenuma) {
> +		int nid;
> +		p->task_balancenuma->task_numa_fault_tot >>= 1;
> +		for_each_online_node(nid) {
> +			p->task_balancenuma->task_numa_fault[nid] >>= 1;
> +		}
> +	}
> +}

Overnight tests indicated that cpu-follows is currently broken in this
series but a large part of the problem is a missing

p->mm->numa_scan_offset = 0;

here. means that all tasks are only considered for convergence once without
proper resetting of the scanner. It's effectly becomes the vanilla kernel
with a bunch of system CPU overhead.

Of course it's not the only problem with this patch as the overhead of
finding a proper placement is mnassive and due to the slow scanning rate,
it converges very slowly. While it's based on autonuma, autonuma did the
same job outside the context of a process so it's not exactly equivalent.

-- 
Mel Gorman
SUSE Labs
