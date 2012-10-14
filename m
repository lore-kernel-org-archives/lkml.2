Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591Ab2JNPGn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 11:06:43 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46315 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754527Ab2JNOme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:42:34 -0400
Message-Id: <20121014143549.435146549@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:37:29 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Hillf Danton <dhillf@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
        Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 116/147] mm: hugetlb: fix pgoff computation when unmapping page from vma
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hillf Danton <dhillf@gmail.com>

commit 0c176d52b0b2619f231b2bbf329b90c028134f58 upstream.

The computation for pgoff is incorrect, at least with

	(vma->vm_pgoff >> PAGE_SHIFT)

involved.  It is fixed with the available method if HPAGE_SIZE is
concerned in page cache lookup.

[akpm@linux-foundation.org: use vma_hugecache_offset() directly, per Michal]
Signed-off-by: Hillf Danton <dhillf@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Michal Hocko <mhocko@suse.cz>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 mm/hugetlb.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2429,8 +2429,7 @@ static int unmap_ref_private(struct mm_s
 	 * from page cache lookup which is in HPAGE_SIZE units.
 	 */
 	address = address & huge_page_mask(h);
-	pgoff = ((address - vma->vm_start) >> PAGE_SHIFT)
-		+ (vma->vm_pgoff >> PAGE_SHIFT);
+	pgoff = vma_hugecache_offset(h, vma, address);
 	mapping = vma->vm_file->f_dentry->d_inode->i_mapping;
 
 	/*


