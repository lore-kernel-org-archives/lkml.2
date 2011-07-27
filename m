Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827Ab1G0Vtq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 17:49:46 -0400
Received: from mga14.intel.com ([143.182.124.37]:57368 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755495Ab1G0Vt1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:49:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,279,1309762800"; 
   d="scan'208";a="32274835"
From: Andi Kleen <andi@firstfloor.org>
References: <20110727247.325703029@firstfloor.org>
In-Reply-To: <20110727247.325703029@firstfloor.org>
To: aquini@linux.com, rja@sgi.com, aarcange@redhat.com, cl@linux.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [73/99] mm: fix negative commitlimit when gigantic hugepages are allocated
Message-Id: <20110727214912.9A61F2403FF@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 14:49:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Rafael Aquini <aquini@linux.com>

commit b0320c7b7d1ac1bd5c2d9dff3258524ab39bad32 upstream.

When 1GB hugepages are allocated on a system, free(1) reports less
available memory than what really is installed in the box.  Also, if the
total size of hugepages allocated on a system is over half of the total
memory size, CommitLimit becomes a negative number.

The problem is that gigantic hugepages (order > MAX_ORDER) can only be
allocated at boot with bootmem, thus its frames are not accounted to
'totalram_pages'.  However, they are accounted to hugetlb_total_pages()

What happens to turn CommitLimit into a negative number is this
calculation, in fs/proc/meminfo.c:

        allowed = ((totalram_pages - hugetlb_total_pages())
                * sysctl_overcommit_ratio / 100) + total_swap_pages;

A similar calculation occurs in __vm_enough_memory() in mm/mmap.c.

Also, every vm statistic which depends on 'totalram_pages' will render
confusing values, as if system were 'missing' some part of its memory.

Impact of this bug:

When gigantic hugepages are allocated and sysctl_overcommit_memory ==
OVERCOMMIT_NEVER.  In a such situation, __vm_enough_memory() goes through
the mentioned 'allowed' calculation and might end up mistakenly returning
-ENOMEM, thus forcing the system to start reclaiming pages earlier than it
would be ususal, and this could cause detrimental impact to overall
system's performance, depending on the workload.

Besides the aforementioned scenario, I can only think of this causing
annoyances with memory reports from /proc/meminfo and free(1).

[akpm@linux-foundation.org: standardize comment layout]
Reported-by: Russ Anderson <rja@sgi.com>
Signed-off-by: Rafael Aquini <aquini@linux.com>
Acked-by: Russ Anderson <rja@sgi.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 mm/hugetlb.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: linux-2.6.35.y/mm/hugetlb.c
===================================================================
--- linux-2.6.35.y.orig/mm/hugetlb.c
+++ linux-2.6.35.y/mm/hugetlb.c
@@ -1109,6 +1109,14 @@ static void __init gather_bootmem_preall
 		WARN_ON(page_count(page) != 1);
 		prep_compound_huge_page(page, h->order);
 		prep_new_huge_page(h, page, page_to_nid(page));
+		/*
+		 * If we had gigantic hugepages allocated at boot time, we need
+		 * to restore the 'stolen' pages to totalram_pages in order to
+		 * fix confusing memory reports from free(1) and another
+		 * side-effects, like CommitLimit going negative.
+		 */
+		if (h->order > (MAX_ORDER - 1))
+			totalram_pages += 1 << h->order;
 	}
 }
 
