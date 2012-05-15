Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965078Ab2EOCzv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:55:51 -0400
Received: from mail1.windriver.com ([147.11.146.13]:53326 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965032Ab2EOCRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:17:08 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 084/179] mm: fix negative commitlimit when gigantic hugepages are allocated
Date: Mon, 14 May 2012 22:13:00 -0400
Message-ID: <1337048075-6132-85-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael Aquini <aquini@linux.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

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

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 mm/hugetlb.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 2583bbe..ca9ce49 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1105,6 +1105,14 @@ static void __init gather_bootmem_prealloc(void)
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
 
-- 
1.7.9.6

