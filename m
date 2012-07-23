Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866Ab2GWNjO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 09:39:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58818 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753797Ab2GWNjJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 09:39:09 -0400
From: Mel Gorman <mgorman@suse.de>
To: Stable <stable@vger.kernel.org>
Cc: Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 34/34] mm/hugetlb: fix warning in alloc_huge_page/dequeue_huge_page_vma
Date: Mon, 23 Jul 2012 14:38:47 +0100
Message-Id: <1343050727-3045-35-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1343050727-3045-1-git-send-email-mgorman@suse.de>
References: <1343050727-3045-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Konstantin Khlebnikov <khlebnikov@openvz.org>

commit b1c12cbcd0a02527c180a862e8971e249d3b347d upstream.

Stable note: Not tracked in Bugzilla. [get|put]_mems_allowed() is extremely
	expensive and severely impacted page allocator performance. This
	is part of a series of patches that reduce page allocator overhead.

Fix a gcc warning (and bug?) introduced in cc9a6c877 ("cpuset: mm: reduce
large amounts of memory barrier related damage v3")

Local variable "page" can be uninitialized if the nodemask from vma policy
does not intersects with nodemask from cpuset.  Even if it doesn't happens
it is better to initialize this variable explicitly than to introduce
a kernel oops in a weird corner case.

mm/hugetlb.c: In function `alloc_huge_page':
mm/hugetlb.c:1135:5: warning: `page' may be used uninitialized in this function

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Acked-by: Mel Gorman <mgorman@suse.de>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 64f2b7a..ae60a53 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -454,7 +454,7 @@ static struct page *dequeue_huge_page_vma(struct hstate *h,
 				struct vm_area_struct *vma,
 				unsigned long address, int avoid_reserve)
 {
-	struct page *page;
+	struct page *page = NULL;
 	struct mempolicy *mpol;
 	nodemask_t *nodemask;
 	struct zonelist *zonelist;
-- 
1.7.9.2

