Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253Ab2LQLMV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 06:12:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49511 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751897Ab2LQLMU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 06:12:20 -0500
Date: Mon, 17 Dec 2012 11:12:14 +0000
From: Mel Gorman <mgorman@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Hugh Dickins <hughd@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Paul Turner <pjt@google.com>, Hillf Danton <dhillf@gmail.com>,
        David Rientjes <rientjes@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Alex Shi <lkml.alex@gmail.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Automatic NUMA Balancing V11
Message-ID: <20121217111214.GE9887@suse.de>
References: <20121212100338.GS1009@suse.de>
 <CA+55aFzedbhcuo-WObUjigrXGuG2VGLqDOvh_HFA9Cn_BRkwjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <CA+55aFzedbhcuo-WObUjigrXGuG2VGLqDOvh_HFA9Cn_BRkwjQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 16, 2012 at 03:19:20PM -0800, Linus Torvalds wrote:
> On Wed, Dec 12, 2012 at 2:03 AM, Mel Gorman <mgorman@suse.de> wrote:
> > This is a pull request for "Automatic NUMA Balancing V11". The list
> 
> Ok, guys, I've pulled this and pushed out. There were some conflicts
> with both the VM changes and with the scheduler tree, but they were
> pretty small and looked simple, so I fixed them up and hope they all
> work.
> 

Thanks very much.

> Has anybody tested the impact on single-node systems?

Not as much as I'd like. I'll be queueing a full set of tests to run against
3.8-rc1 when it's released and I should have latest -stable kernel results
to compare against.

> If distros
> enable this by default (and it does have 'default y', which is a big
> no-no for new features - I undid that part)

My bad. That switch to default y was a last-minute change by me when I
was taking a final look through. I switched it to default y based on the
distribution and upstream discussion at the last kernel summit. I expected
that distributions, particularly the enterprise ones, would be enabling
this by default and I thought that the upstream default should be the same.

> then there will be tons of
> people running this without actually having multiple sockets. Does it
> gracefully avoid pointless overheads for this case?
> 

Good question. I'm expecting the impact to be low for two reasons.

First, commit 1a687c2e (mm: sched: numa: Control enabling and disabling of
NUMA balancing) disables the feature by default and it is only enabled by
check_numabalancing_enable() if nr_node_ids > 1. It would have been even
better if the check in task_tick_numa was based on numabalancing_enabled
because that would save a small cost if !CONFIG_SCHED_DEBUG.

Second, even if it is enabled by numa_balancing=enable on UMA then commit
5bca2303 (mm: sched: numa: Delay PTE scanning until a task is scheduled
on a new node) comes into play. On single socket systems it should never
be possible to schedule on a new node and so the PTE scanner should stay
inactive unless the user uses the scheduler debugging feature to enable
NUMA_FORCE.

Either commit should prevent UMA systems scanning PTEs, marking them pte_numa
and incurring numa hinting faults which hides the vast bulk of the cost.
I'm currently guessing that if there is a visible impact from the series
on UMA it'll be due to anon_vma mutex changing to a rwsem. I consider a
regression due to this change to be very unlikely as compaction and THP
migrate far less than automatic NUMA balancing potentially does. If a bug
of this type is reported then I'm more likely to consider the real bug to
be that compaction is migrating excessively and the locking change just
made the bug more obvious.

> Anyway, hopefully we'll have a more real numa balancing for 3.9, and
> this is still considered a reasonable base for that work.
> 

That is what I'm hoping!

-- 
Mel Gorman
SUSE Labs
