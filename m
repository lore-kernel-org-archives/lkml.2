Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796Ab2LLKDs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 05:03:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55047 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750987Ab2LLKDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 05:03:45 -0500
Date: Wed, 12 Dec 2012 10:03:38 +0000
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
Subject: [GIT PULL] Automatic NUMA Balancing V11
Message-ID: <20121212100338.GS1009@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is a pull request for "Automatic NUMA Balancing V11". The list
of changes since commit f4a75d2eb7b1e2206094b901be09adb31ba63681:

  Linux 3.7-rc6 (2012-11-16 17:42:40 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mel/linux-balancenuma.git balancenuma-v11

for you to fetch changes up to 4fc3f1d66b1ef0d7b8dc11f4ff1cc510f78b37d6:

  mm/rmap, migration: Make rmap_walk_anon() and try_to_unmap_anon() more scalable (2012-12-11 14:43:00 +0000)

There are three implementations for NUMA balancing, this tree (balancenuma),
numacore which has been developed in tip/master and autonuma which is in
aa.git. In almost all respects balancenuma is the dumbest of the three
because its main impact is on the VM side with no attempt to be smart
about scheduling.  In the interest of getting the ball rolling, it would
be desirable to see this much merged for 3.8 with the view to building
scheduler smarts on top and adapting the VM where required for 3.9.

The most recent set of comparisons available from different people are

mel:    https://lkml.org/lkml/2012/12/9/108
mingo:  https://lkml.org/lkml/2012/12/7/331
tglx:   https://lkml.org/lkml/2012/12/10/437
srikar: https://lkml.org/lkml/2012/12/10/397

The results are a mixed bag. In my own tests, balancenuma does reasonably
well. It's dumb as rocks and does not regress against mainline. On the
other hand, Ingo's tests shows that balancenuma is incapable of converging
for this workloads driven by perf which is bad but is potentially explained
by the lack of scheduler smarts. Thomas' results show balancenuma improves
on mainline but falls far short of numacore or autonuma. Srikar's results
indicate we all suffer on a large machine with imbalanced node sizes.

My own testing showed that recent numacore results have improved
dramatically, particularly in the last week but not universally.  We've
butted heads heavily on system CPU usage and high levels of migration even
when it shows that overall performance is better. There are also cases
where it regresses. Of interest is that for specjbb in some configurations
it will regress for lower numbers of warehouses and show gains for higher
numbers which is not reported by the tool by default and sometimes missed
in treports. Recently I reported for numacore that the JVM was crashing
with NullPointerExceptions but currently it's unclear what the source of
this problem is. Initially I thought it was in how numacore batch handles
PTEs but I'm no longer think this is the case. It's possible numacore is
just able to trigger it due to higher rates of migration.

These reports were quite late in the cycle so I/we would like to start
with this tree as it contains much of the code we can agree on and has
not changed significantly over the last 2-3 weeks.

Thanks.

Andrea Arcangeli (5):
      mm: numa: define _PAGE_NUMA
      mm: numa: pte_numa() and pmd_numa()
      mm: numa: Support NUMA hinting page faults from gup/gup_fast
      mm: numa: split_huge_page: transfer the NUMA type from the pmd to the pte
      mm: numa: Structures for Migrate On Fault per NUMA migration rate limiting

Hillf Danton (2):
      mm: numa: split_huge_page: Transfer last_nid on tail page
      mm: numa: migrate: Set last_nid on newly allocated page

Ingo Molnar (3):
      mm: Optimize the TLB flush of sys_mprotect() and change_protection() users
      mm/rmap: Convert the struct anon_vma::mutex to an rwsem
      mm/rmap, migration: Make rmap_walk_anon() and try_to_unmap_anon() more scalable

Lee Schermerhorn (3):
      mm: mempolicy: Add MPOL_NOOP
      mm: mempolicy: Check for misplaced page
      mm: mempolicy: Add MPOL_MF_LAZY

Mel Gorman (26):
      mm: Check if PTE is already allocated during page fault
      mm: compaction: Move migration fail/success stats to migrate.c
      mm: migrate: Add a tracepoint for migrate_pages
      mm: compaction: Add scanned and isolated counters for compaction
      mm: numa: Create basic numa page hinting infrastructure
      mm: migrate: Drop the misplaced pages reference count if the target node is full
      mm: mempolicy: Use _PAGE_NUMA to migrate pages
      mm: mempolicy: Implement change_prot_numa() in terms of change_protection()
      mm: mempolicy: Hide MPOL_NOOP and MPOL_MF_LAZY from userspace for now
      sched, numa, mm: Count WS scanning against present PTEs, not virtual memory ranges
      mm: numa: Add pte updates, hinting and migration stats
      mm: numa: Migrate on reference policy
      mm: numa: Migrate pages handled during a pmd_numa hinting fault
      mm: numa: Rate limit the amount of memory that is migrated between nodes
      mm: numa: Rate limit setting of pte_numa if node is saturated
      sched: numa: Slowly increase the scanning period as NUMA faults are handled
      mm: numa: Introduce last_nid to the page frame
      mm: numa: Use a two-stage filter to restrict pages being migrated for unlikely task<->node relationships
      mm: sched: Adapt the scanning rate if a NUMA hinting fault does not migrate
      mm: sched: numa: Control enabling and disabling of NUMA balancing
      mm: sched: numa: Control enabling and disabling of NUMA balancing if !SCHED_DEBUG
      mm: sched: numa: Delay PTE scanning until a task is scheduled on a new node
      mm: numa: Add THP migration for the NUMA working set scanning fault case.
      mm: numa: Add THP migration for the NUMA working set scanning fault case build fix
      mm: numa: Account for failed allocations and isolations as migration failures
      mm: migrate: Account a transhuge page properly when rate limiting

Peter Zijlstra (6):
      mm: Count the number of pages affected in change_protection()
      mm: mempolicy: Make MPOL_LOCAL a real policy
      mm: migrate: Introduce migrate_misplaced_page()
      mm: numa: Add fault driven placement and migration
      mm: sched: numa: Implement constant, per task Working Set Sampling (WSS) rate
      mm: sched: numa: Implement slow start for working set sampling

Rik van Riel (5):
      x86: mm: only do a local tlb flush in ptep_set_access_flags()
      x86: mm: drop TLB flush from ptep_set_access_flags
      mm,generic: only flush the local TLB in ptep_set_access_flags
      x86/mm: Introduce pte_accessible()
      mm: Only flush the TLB when clearing an accessible pte

 Documentation/kernel-parameters.txt  |    3 +
 arch/sh/mm/Kconfig                   |    1 +
 arch/x86/Kconfig                     |    2 +
 arch/x86/include/asm/pgtable.h       |   17 +-
 arch/x86/include/asm/pgtable_types.h |   20 ++
 arch/x86/mm/pgtable.c                |    8 +-
 include/asm-generic/pgtable.h        |  110 +++++++++++
 include/linux/huge_mm.h              |   16 +-
 include/linux/hugetlb.h              |    8 +-
 include/linux/mempolicy.h            |    8 +
 include/linux/migrate.h              |   47 ++++-
 include/linux/mm.h                   |   39 ++++
 include/linux/mm_types.h             |   31 ++++
 include/linux/mmzone.h               |   13 ++
 include/linux/rmap.h                 |   33 ++--
 include/linux/sched.h                |   27 +++
 include/linux/vm_event_item.h        |   12 +-
 include/linux/vmstat.h               |    8 +
 include/trace/events/migrate.h       |   51 +++++
 include/uapi/linux/mempolicy.h       |   15 +-
 init/Kconfig                         |   45 +++++
 kernel/fork.c                        |    3 +
 kernel/sched/core.c                  |   71 +++++--
 kernel/sched/fair.c                  |  227 +++++++++++++++++++++++
 kernel/sched/features.h              |   11 ++
 kernel/sched/sched.h                 |   12 ++
 kernel/sysctl.c                      |   45 ++++-
 mm/compaction.c                      |   15 +-
 mm/huge_memory.c                     |  108 ++++++++++-
 mm/hugetlb.c                         |   10 +-
 mm/internal.h                        |    7 +-
 mm/ksm.c                             |    6 +-
 mm/memcontrol.c                      |    7 +-
 mm/memory-failure.c                  |    7 +-
 mm/memory.c                          |  199 +++++++++++++++++++-
 mm/memory_hotplug.c                  |    3 +-
 mm/mempolicy.c                       |  283 +++++++++++++++++++++++++---
 mm/migrate.c                         |  337 +++++++++++++++++++++++++++++++++-
 mm/mmap.c                            |   10 +-
 mm/mprotect.c                        |  135 +++++++++++---
 mm/mremap.c                          |    2 +-
 mm/page_alloc.c                      |   10 +-
 mm/pgtable-generic.c                 |    9 +-
 mm/rmap.c                            |   66 +++----
 mm/vmstat.c                          |   16 +-
 45 files changed, 1940 insertions(+), 173 deletions(-)
 create mode 100644 include/trace/events/migrate.h

-- 
Mel Gorman
SUSE Labs
