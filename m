Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759631Ab2FGERG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 00:17:06 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63657 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756229Ab2FGERA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 00:17:00 -0400
Message-Id: <20120607040339.885841165@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 07 Jun 2012 13:04:00 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dave Hansen <dave@linux.vnet.ibm.com>,
        Mel Gorman <mel@csn.ul.ie>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Christoph Lameter <cl@linux.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: [ 24/82] hugetlb: fix resv_map leak in error path
In-Reply-To: <20120607041406.GA13233@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Hansen <dave@linux.vnet.ibm.com>

commit c50ac050811d6485616a193eb0f37bfbd191cc89 upstream.

When called for anonymous (non-shared) mappings, hugetlb_reserve_pages()
does a resv_map_alloc().  It depends on code in hugetlbfs's
vm_ops->close() to release that allocation.

However, in the mmap() failure path, we do a plain unmap_region() without
the remove_vma() which actually calls vm_ops->close().

This is a decent fix.  This leak could get reintroduced if new code (say,
after hugetlb_reserve_pages() in hugetlbfs_file_mmap()) decides to return
an error.  But, I think it would have to unroll the reservation anyway.

Christoph's test case:

	http://marc.info/?l=linux-mm&m=133728900729735

This patch applies to 3.4 and later.  A version for earlier kernels is at
https://lkml.org/lkml/2012/5/22/418.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reported-by: Christoph Lameter <cl@linux.com>
Tested-by: Christoph Lameter <cl@linux.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/hugetlb.c |   28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
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


