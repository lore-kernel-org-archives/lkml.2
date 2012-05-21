Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757047Ab2EUU2c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 16:28:32 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:60444 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752680Ab2EUU2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 16:28:30 -0400
Subject: [PATCH] hugetlb: fix resv_map leak in error path
To: cl@linux.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, aarcange@redhat.com,
        kosaki.motohiro@jp.fujitsu.com, hughd@google.com, rientjes@google.com,
        adobriyan@gmail.com, akpm@linux-foundation.org, mel@csn.ul.ie,
        Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Mon, 21 May 2012 13:28:14 -0700
Message-Id: <20120521202814.E01F0FE1@kernel>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12052120-7182-0000-0000-00000190D625
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When called for anonymous (non-shared) mappings,
hugetlb_reserve_pages() does a resv_map_alloc().  It depends on
code in hugetlbfs's vm_ops->close() to release that allocation.

However, in the mmap() failure path, we do a plain unmap_region()
without the remove_vma() which actually calls vm_ops->close().

This is a decent fix.  This leak could get reintroduced if
new code (say, after hugetlb_reserve_pages() in
hugetlbfs_file_mmap()) decides to return an error.  But, I think
it would have to unroll the reservation anyway.

This hasn't been extensively tested.  Pretty much compile and
boot tested along with Christoph's test case:

	http://marc.info/?l=linux-mm&m=133728900729735

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
ecked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reported/tested-by: Christoph Lameter <cl@linux.com>

---

 linux-2.6.git-dave/mm/hugetlb.c |   28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff -puN mm/hugetlb.c~hugetlb-fix-leak mm/hugetlb.c
--- linux-2.6.git/mm/hugetlb.c~hugetlb-fix-leak	2012-05-21 13:24:38.369857759 -0700
+++ linux-2.6.git-dave/mm/hugetlb.c	2012-05-21 13:24:38.377857849 -0700
@@ -2157,6 +2157,15 @@ static void hugetlb_vm_op_open(struct vm
 		kref_get(&reservations->refs);
 }
 
+static void resv_map_put(struct vm_area_struct *vma)
+{
+	struct resv_map *reservations = vma_resv_map(vma);
+
+	if (!reservations)
+		return;
+	kref_put(&reservations->refs, resv_map_release);
+}
+
 static void hugetlb_vm_op_close(struct vm_area_struct *vma)
 {
 	struct hstate *h = hstate_vma(vma);
@@ -2173,7 +2182,7 @@ static void hugetlb_vm_op_close(struct v
 		reserve = (end - start) -
 			region_count(&reservations->regions, start, end);
 
-		kref_put(&reservations->refs, resv_map_release);
+		resv_map_put(vma);
 
 		if (reserve) {
 			hugetlb_acct_memory(h, -reserve);
@@ -2990,12 +2999,16 @@ int hugetlb_reserve_pages(struct inode *
 		set_vma_resv_flags(vma, HPAGE_RESV_OWNER);
 	}
 
-	if (chg < 0)
-		return chg;
+	if (chg < 0) {
+		ret = chg;
+		goto out_err;
+	}
 
 	/* There must be enough pages in the subpool for the mapping */
-	if (hugepage_subpool_get_pages(spool, chg))
-		return -ENOSPC;
+	if (hugepage_subpool_get_pages(spool, chg)) {
+		ret = -ENOSPC;
+		goto out_err;
+	}
 
 	/*
 	 * Check enough hugepages are available for the reservation.
@@ -3004,7 +3017,7 @@ int hugetlb_reserve_pages(struct inode *
 	ret = hugetlb_acct_memory(h, chg);
 	if (ret < 0) {
 		hugepage_subpool_put_pages(spool, chg);
-		return ret;
+		goto out_err;
 	}
 
 	/*
@@ -3021,6 +3034,9 @@ int hugetlb_reserve_pages(struct inode *
 	if (!vma || vma->vm_flags & VM_MAYSHARE)
 		region_add(&inode->i_mapping->private_list, from, to);
 	return 0;
+out_err:
+	resv_map_put(vma);
+	return ret;
 }
 
 void hugetlb_unreserve_pages(struct inode *inode, long offset, long freed)
diff -puN Documentation/stable_kernel_rules.txt~hugetlb-fix-leak Documentation/stable_kernel_rules.txt
_

