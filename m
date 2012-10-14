Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550Ab2JNOmg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 10:42:36 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46316 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754523Ab2JNOmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:42:31 -0400
Message-Id: <20121014143549.569389596@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:37:30 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Michal Hocko <mhocko@suse.cz>, Hillf Danton <dhillf@gmail.com>,
        Mel Gorman <mel@csn.ul.ie>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 117/147] hugetlb: do not use vma_hugecache_offset() for vma_prio_tree_foreach
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Hocko <mhocko@suse.cz>

commit 36e4f20af833d1ce196e6a4ade05dc26c44652d1 upstream.

Commit 0c176d52b0b2 ("mm: hugetlb: fix pgoff computation when unmapping
page from vma") fixed pgoff calculation but it has replaced it by
vma_hugecache_offset() which is not approapriate for offsets used for
vma_prio_tree_foreach() because that one expects index in page units
rather than in huge_page_shift.

Johannes said:

: The resulting index may not be too big, but it can be too small: assume
: hpage size of 2M and the address to unmap to be 0x200000.  This is regular
: page index 512 and hpage index 1.  If you have a VMA that maps the file
: only starting at the second huge page, that VMAs vm_pgoff will be 512 but
: you ask for offset 1 and miss it even though it does map the page of
: interest.  hugetlb_cow() will try to unmap, miss the vma, and retry the
: cow until the allocation succeeds or the skipped vma(s) go away.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Hillf Danton <dhillf@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 mm/hugetlb.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 8536741..de5d1dc 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2480,7 +2480,8 @@ static int unmap_ref_private(struct mm_struct *mm, struct vm_area_struct *vma,
 	 * from page cache lookup which is in HPAGE_SIZE units.
 	 */
 	address = address & huge_page_mask(h);
-	pgoff = vma_hugecache_offset(h, vma, address);
+	pgoff = ((address - vma->vm_start) >> PAGE_SHIFT) +
+			vma->vm_pgoff;
 	mapping = vma->vm_file->f_dentry->d_inode->i_mapping;
 
 	/*


