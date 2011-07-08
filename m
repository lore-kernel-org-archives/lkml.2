Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457Ab1GHFDV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:03:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42123 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754406Ab1GHFDQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:03:16 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:16:57 2011
Message-Id: <20110708001657.865460111@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:16:25 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Rafael Aquini <aquini@linux.com>, Russ Anderson <rja@sgi.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Christoph Lameter <cl@linux.com>
Subject: [053/107] mm: fix negative commitlimit when gigantic hugepages are allocated
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

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

---
 mm/hugetlb.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1111,6 +1111,14 @@ static void __init gather_bootmem_preall
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
 


