Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529Ab2KUKbx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 05:31:53 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43639 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753435Ab2KUKWJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 05:22:09 -0500
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Ingo Molnar <mingo@kernel.org>
Cc: Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Hugh Dickins <hughd@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Alex Shi <lkml.alex@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 07/46] mm: Optimize the TLB flush of sys_mprotect() and change_protection() users
Date: Wed, 21 Nov 2012 10:21:13 +0000
Message-Id: <1353493312-8069-8-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1353493312-8069-1-git-send-email-mgorman@suse.de>
References: <1353493312-8069-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@kernel.org>

Reuse the NUMA code's 'modified page protections' count that
change_protection() computes and skip the TLB flush if there's
no changes to a range that sys_mprotect() modifies.

Given that mprotect() already optimizes the same-flags case
I expected this optimization to dominantly trigger on
CONFIG_NUMA_BALANCING=y kernels - but even with that feature
disabled it triggers rather often.

There's two reasons for that:

1)

While sys_mprotect() already optimizes the same-flag case:

        if (newflags == oldflags) {
                *pprev = vma;
                return 0;
        }

and this test works in many cases, but it is too sharp in some
others, where it differentiates between protection values that the
underlying PTE format makes no distinction about, such as
PROT_EXEC == PROT_READ on x86.

2)

Even where the pte format over vma flag changes necessiates a
modification of the pagetables, there might be no pagetables
yet to modify: they might not be instantiated yet.

During a regular desktop bootup this optimization hits a couple
of hundred times. During a Java test I measured thousands of
hits.

So this optimization improves sys_mprotect() in general, not just
CONFIG_NUMA_BALANCING=y kernels.

[ We could further increase the efficiency of this optimization if
  change_pte_range() and change_huge_pmd() was a bit smarter about
  recognizing exact-same-value protection masks - when the hardware
  can do that safely. This would probably further speed up mprotect(). ]

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 mm/mprotect.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/mprotect.c b/mm/mprotect.c
index 1e265be..7c3628a 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -153,7 +153,9 @@ static unsigned long change_protection_range(struct vm_area_struct *vma,
 				 dirty_accountable);
 	} while (pgd++, addr = next, addr != end);
 
-	flush_tlb_range(vma, start, end);
+	/* Only flush the TLB if we actually modified any entries: */
+	if (pages)
+		flush_tlb_range(vma, start, end);
 
 	return pages;
 }
-- 
1.7.9.2

