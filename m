Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624Ab2FNX6t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 19:58:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56620 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753663Ab2FNX6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 19:58:46 -0400
Message-Id: <20120614235646.013938906@linuxfoundation.org>
User-Agent: quilt/0.60-20.1
Date: Thu, 14 Jun 2012 16:57:04 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dave Hansen <dave@linux.vnet.ibm.com>,
        Mel Gorman <mel@csn.ul.ie>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Christoph Lameter <cl@linux.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: [ 20/20] hugetlb: fix resv_map leak in error path
In-Reply-To: <20120614235648.GA6552@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Hansen <dave@linux.vnet.ibm.com>

commit c50ac050811d6485616a193eb0f37bfbd191cc89 and
4523e1458566a0e8ecfaff90f380dd23acc44d27 upstream.

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
 mm/hugetlb.c |   29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2060,6 +2060,15 @@ static void hugetlb_vm_op_open(struct vm
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
@@ -2075,7 +2084,7 @@ static void hugetlb_vm_op_close(struct v
 		reserve = (end - start) -
 			region_count(&reservations->regions, start, end);
 
-		kref_put(&reservations->refs, resv_map_release);
+		resv_map_put(vma);
 
 		if (reserve) {
 			hugetlb_acct_memory(h, -reserve);
@@ -2877,12 +2886,16 @@ int hugetlb_reserve_pages(struct inode *
 		set_vma_resv_flags(vma, HPAGE_RESV_OWNER);
 	}
 
-	if (chg < 0)
-		return chg;
+	if (chg < 0) {
+		ret = chg;
+		goto out_err;
+	}
 
 	/* There must be enough filesystem quota for the mapping */
-	if (hugetlb_get_quota(inode->i_mapping, chg))
-		return -ENOSPC;
+	if (hugetlb_get_quota(inode->i_mapping, chg)) {
+		ret = -ENOSPC;
+		goto out_err;
+	}
 
 	/*
 	 * Check enough hugepages are available for the reservation.
@@ -2891,7 +2904,7 @@ int hugetlb_reserve_pages(struct inode *
 	ret = hugetlb_acct_memory(h, chg);
 	if (ret < 0) {
 		hugetlb_put_quota(inode->i_mapping, chg);
-		return ret;
+		goto out_err;
 	}
 
 	/*
@@ -2908,6 +2921,10 @@ int hugetlb_reserve_pages(struct inode *
 	if (!vma || vma->vm_flags & VM_MAYSHARE)
 		region_add(&inode->i_mapping->private_list, from, to);
 	return 0;
+out_err:
+	if (vma)
+		resv_map_put(vma);
+	return ret;
 }
 
 void hugetlb_unreserve_pages(struct inode *inode, long offset, long freed)


