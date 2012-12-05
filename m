Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372Ab2LEC7k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 21:59:40 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:58307 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795Ab2LEC7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 21:59:39 -0500
MIME-Version: 1.0
In-Reply-To: <20121202151232.GB12911@gmail.com>
References: <1354305521-11583-1-git-send-email-mingo@kernel.org>
	<CA+55aFwjxm7OYuucHeE2WFr4p+jwr63t=kSdHndta_QkyFbyBQ@mail.gmail.com>
	<20121201094927.GA12366@gmail.com>
	<20121201122649.GA20322@gmail.com>
	<CA+55aFx8QtP0hg8qxn__4vHQuzH7QkhTN-4fwgOpM-A=KuBBjA@mail.gmail.com>
	<20121201184135.GA32449@gmail.com>
	<CA+55aFyq7OaUxcEHXvJhp0T57KN14o-RGxqPmA+ks8ge6zJh5w@mail.gmail.com>
	<20121201201538.GB2704@gmail.com>
	<50BA69B7.30002@redhat.com>
	<20121202151232.GB12911@gmail.com>
Date: Tue, 4 Dec 2012 18:59:38 -0800
Message-ID: <CANN689H1yckQyTZMWBexdU-u=T=RrLDCpoua3HU09mXx+CVpvg@mail.gmail.com>
Subject: Re: [PATCH 2/2, v2] mm/migration: Make rmap_walk_anon() and
 try_to_unmap_anon() more scalable
From: Michel Lespinasse <walken@google.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 2, 2012 at 7:12 AM, Ingo Molnar <mingo@kernel.org> wrote:
> Subject: [PATCH] mm/rmap, migration: Make rmap_walk_anon() and
>  try_to_unmap_anon() more scalable
>
> rmap_walk_anon() and try_to_unmap_anon() appears to be too
> careful about locking the anon vma: while it needs protection
> against anon vma list modifications, it does not need exclusive
> access to the list itself.
>
> Transforming this exclusive lock to a read-locked rwsem removes
> a global lock from the hot path of page-migration intense
> threaded workloads which can cause pathological performance like
> this:
>
>     96.43%        process 0  [kernel.kallsyms]  [k] perf_trace_sched_switch
>                   |
>                   --- perf_trace_sched_switch
>                       __schedule
>                       schedule
>                       schedule_preempt_disabled
>                       __mutex_lock_common.isra.6
>                       __mutex_lock_slowpath
>                       mutex_lock
>                      |
>                      |--50.61%-- rmap_walk
>                      |          move_to_new_page
>                      |          migrate_pages
>                      |          migrate_misplaced_page
>                      |          __do_numa_page.isra.69
>                      |          handle_pte_fault
>                      |          handle_mm_fault
>                      |          __do_page_fault
>                      |          do_page_fault
>                      |          page_fault
>                      |          __memset_sse2
>                      |          |
>                      |           --100.00%-- worker_thread
>                      |                     |
>                      |                      --100.00%-- start_thread
>                      |
>                       --49.39%-- page_lock_anon_vma
>                                 try_to_unmap_anon
>                                 try_to_unmap
>                                 migrate_pages
>                                 migrate_misplaced_page
>                                 __do_numa_page.isra.69
>                                 handle_pte_fault
>                                 handle_mm_fault
>                                 __do_page_fault
>                                 do_page_fault
>                                 page_fault
>                                 __memset_sse2
>                                 |
>                                  --100.00%-- worker_thread
>                                            start_thread
>
> With this change applied the profile is now nicely flat
> and there's no anon-vma related scheduling/blocking.

Wouldn't the same reasoning apply to i_mmap_mutex ? Should we make
that a rwsem as well ? I take it that Ingo's test case does not show
this, but i_mmap_mutex's role with file pages is actually quite
similar to the anon_vma lock with anon pages...

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
