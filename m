Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350Ab2KMROX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 12:14:23 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37723 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754907Ab2KMROW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 12:14:22 -0500
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Paul Turner <pjt@google.com>, Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 00/31] Latest numa/core patches, v15
Date: Tue, 13 Nov 2012 18:13:23 +0100
Message-Id: <1352826834-11774-1-git-send-email-mingo@kernel.org>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the latest iteration of our numa/core tree, which
implements adaptive NUMA affinity balancing.

Changes in this version:

    https://lkml.org/lkml/2012/11/12/315

Performance figures:

    https://lkml.org/lkml/2012/11/12/330

Any review feedback, comments and test results are welcome!

For testing purposes I'd suggest using the latest tip:master
integration tree, which has the latest numa/core tree merged:

   git pull git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git master

(But you can also directly use the tip:numa/core tree as well.)

Thanks,

    Ingo

----------------------->
Andrea Arcangeli (1):
  numa, mm: Support NUMA hinting page faults from gup/gup_fast

Gerald Schaefer (1):
  sched, numa, mm, s390/thp: Implement pmd_pgprot() for s390

Ingo Molnar (3):
  mm/pgprot: Move the pgprot_modify() fallback definition to mm.h
  sched, mm, x86: Add the ARCH_SUPPORTS_NUMA_BALANCING flag
  mm: Allow the migration of shared pages

Lee Schermerhorn (3):
  mm/mpol: Add MPOL_MF_NOOP
  mm/mpol: Check for misplaced page
  mm/mpol: Add MPOL_MF_LAZY

Peter Zijlstra (16):
  sched, numa, mm: Make find_busiest_queue() a method
  sched, numa, mm: Describe the NUMA scheduling problem formally
  mm/thp: Preserve pgprot across huge page split
  mm/mpol: Make MPOL_LOCAL a real policy
  mm/mpol: Create special PROT_NONE infrastructure
  mm/migrate: Introduce migrate_misplaced_page()
  mm/mpol: Use special PROT_NONE to migrate pages
  sched, numa, mm: Introduce sched_feat_numa()
  sched, numa, mm: Implement THP migration
  sched, numa, mm: Add last_cpu to page flags
  sched, numa, mm, arch: Add variable locality exception
  sched, numa, mm: Add the scanning page fault machinery
  sched, numa, mm: Add adaptive NUMA affinity support
  sched, numa, mm: Implement constant, per task Working Set Sampling (WSS) rate
  sched, numa, mm: Count WS scanning against present PTEs, not virtual memory ranges
  sched, numa, mm: Implement slow start for working set sampling

Ralf Baechle (1):
  sched, numa, mm, MIPS/thp: Add pmd_pgprot() implementation

Rik van Riel (6):
  mm/generic: Only flush the local TLB in ptep_set_access_flags()
  x86/mm: Only do a local tlb flush in ptep_set_access_flags()
  x86/mm: Introduce pte_accessible()
  mm: Only flush the TLB when clearing an accessible pte
  x86/mm: Completely drop the TLB flush from ptep_set_access_flags()
  sched, numa, mm: Add credits for NUMA placement

---

 CREDITS                                  |    1 +
 Documentation/scheduler/numa-problem.txt |  236 +++++++++++
 arch/mips/include/asm/pgtable.h          |    2 +
 arch/s390/include/asm/pgtable.h          |   13 +
 arch/sh/mm/Kconfig                       |    1 +
 arch/x86/Kconfig                         |    1 +
 arch/x86/include/asm/pgtable.h           |    7 +
 arch/x86/mm/pgtable.c                    |    8 +-
 include/asm-generic/pgtable.h            |    4 +
 include/linux/huge_mm.h                  |   19 +
 include/linux/hugetlb.h                  |    8 +-
 include/linux/init_task.h                |    8 +
 include/linux/mempolicy.h                |    8 +
 include/linux/migrate.h                  |    7 +
 include/linux/migrate_mode.h             |    3 +
 include/linux/mm.h                       |  122 ++++--
 include/linux/mm_types.h                 |   10 +
 include/linux/mmzone.h                   |   14 +-
 include/linux/page-flags-layout.h        |   83 ++++
 include/linux/sched.h                    |   46 ++-
 include/uapi/linux/mempolicy.h           |   16 +-
 init/Kconfig                             |   23 ++
 kernel/bounds.c                          |    2 +
 kernel/sched/core.c                      |   68 +++-
 kernel/sched/fair.c                      | 1032 ++++++++++++++++++++++++++++++++++++++++---------
 kernel/sched/features.h                  |    8 +
 kernel/sched/sched.h                     |   38 +-
 kernel/sysctl.c                          |   45 ++-
 mm/huge_memory.c                         |  253 +++++++++---
 mm/hugetlb.c                             |   10 +-
 mm/memory.c                              |  129 ++++++-
 mm/mempolicy.c                           |  206 ++++++++--
 mm/migrate.c                             |   81 +++-
 mm/mprotect.c                            |   64 ++-
 mm/pgtable-generic.c                     |    9 +-
 35 files changed, 2200 insertions(+), 385 deletions(-)
 create mode 100644 Documentation/scheduler/numa-problem.txt
 create mode 100644 include/linux/page-flags-layout.h
