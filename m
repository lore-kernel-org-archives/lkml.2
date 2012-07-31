Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793Ab2GaFGg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 01:06:36 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48523 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755316Ab2GaEuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 00:50:04 -0400
Message-Id: <20120731044313.816574497@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 31 Jul 2012 05:43:26 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>
Subject: [ 16/73] mm/hugetlb: fix warning in alloc_huge_page/dequeue_huge_page_vma
In-Reply-To: <20120731044310.013763753@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index cd65cb1..5a16423 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -532,7 +532,7 @@ static struct page *dequeue_huge_page_vma(struct hstate *h,
 				struct vm_area_struct *vma,
 				unsigned long address, int avoid_reserve)
 {
-	struct page *page;
+	struct page *page = NULL;
 	struct mempolicy *mpol;
 	nodemask_t *nodemask;
 	struct zonelist *zonelist;


