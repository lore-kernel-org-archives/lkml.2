Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757050Ab2EVVFI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 17:05:08 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:44891 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754933Ab2EVVFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 17:05:06 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: hdZcRcAVM1nUlM_T5fTYsqn3jsC4hn2IBWtbttVJthEysb1
 NJ0HTcjtnakIXiW59uwC6.4ZMYJMfOZdjKWBLTuxxgIRyF0edgzfGltQd.RZ
 8R.Cwlq95.8LhLSUz0HMin5PMWeySCrFS_RJCpnz7GvBpIL1EM68KcTWurpb
 ZJcbtKfvj_Btri5e.oUClyZRCjr3SRq1wXRK3TFzDr4zQ_Zei6X3OKELUKoA
 rp0qVmoIllZQZ0pSgS7Hyqn9hm3moCRoQvHINxZ2_qwZ0G.tKAWVO7Kj8S.F
 vi3gpnNTTI7fXPlABCUHynQfjw80KJVX3oKgYx.vaYc.rphrWWvoDx3DEf3H
 BEbzrvtCAYM1BP55GISRuGiBC3f6mHnNSm5izQDmCz83MFMR8v09F_aXiUt9
 N
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 22 May 2012 16:05:02 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Andrew Morton <akpm@linux-foundation.org>
cc: Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, aarcange@redhat.com,
        kosaki.motohiro@jp.fujitsu.com, hughd@google.com, rientjes@google.com,
        adobriyan@gmail.com, mel@csn.ul.ie
Subject: Re: [PATCH] hugetlb: fix resv_map leak in error path
In-Reply-To: <20120522134558.49255899.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.1205221603290.21828@router.home>
References: <20120521202814.E01F0FE1@kernel> <20120522134558.49255899.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 May 2012, Andrew Morton wrote:

> On Mon, 21 May 2012 13:28:14 -0700
> Dave Hansen <dave@linux.vnet.ibm.com> wrote:
>
> > When called for anonymous (non-shared) mappings,
> > hugetlb_reserve_pages() does a resv_map_alloc().  It depends on
> > code in hugetlbfs's vm_ops->close() to release that allocation.
> >
> > However, in the mmap() failure path, we do a plain unmap_region()
> > without the remove_vma() which actually calls vm_ops->close().
> >
> > This is a decent fix.  This leak could get reintroduced if
> > new code (say, after hugetlb_reserve_pages() in
> > hugetlbfs_file_mmap()) decides to return an error.  But, I think
> > it would have to unroll the reservation anyway.
>
> How far back does this bug go?  The patch applies to 3.4 but gets
> rejects in 3.3 and earlier.

The earliest that I have seen it on was 2.6.32. I have rediffed the patch
against 2.6.32 and 3.2.0.

----

>From dave@linux.vnet.ibm.com Fri May 18 13:50:17 2012
Date: Fri, 18 May 2012 11:46:30 -0700
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: cl@linux.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, aarcange@redhat.com, kosaki.motohiro@jp.fujitsu.com, hughd@google.com, rientjes@google.com, adobriyan@gmail.com, akpm@linux-foundation.org, mel@csn.ul.ie, Dave Hansen <dave@linux.vnet.ibm.com>
Subject: [RFC][PATCH] hugetlb: fix resv_map leak in error path


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
boot tested along with Christoph's test case.

Comments?


Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 mm/hugetlb.c |   28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

Index: linux-3.2.0/mm/hugetlb.c
===================================================================
--- linux-3.2.0.orig/mm/hugetlb.c	2012-01-04 17:55:44.000000000 -0600
+++ linux-3.2.0/mm/hugetlb.c	2012-05-22 03:32:37.760054550 -0500
@@ -2068,6 +2068,15 @@ static void hugetlb_vm_op_open(struct vm
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
@@ -2083,7 +2092,7 @@ static void hugetlb_vm_op_close(struct v
 		reserve = (end - start) -
 			region_count(&reservations->regions, start, end);

-		kref_put(&reservations->refs, resv_map_release);
+		resv_map_put(vma);

 		if (reserve) {
 			hugetlb_acct_memory(h, -reserve);
@@ -2883,12 +2892,16 @@ int hugetlb_reserve_pages(struct inode *
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
@@ -2897,7 +2910,7 @@ int hugetlb_reserve_pages(struct inode *
 	ret = hugetlb_acct_memory(h, chg);
 	if (ret < 0) {
 		hugetlb_put_quota(inode->i_mapping, chg);
-		return ret;
+		goto out_err;
 	}

 	/*
@@ -2914,6 +2927,9 @@ int hugetlb_reserve_pages(struct inode *
 	if (!vma || vma->vm_flags & VM_MAYSHARE)
 		region_add(&inode->i_mapping->private_list, from, to);
 	return 0;
+out_err:
+	resv_map_put(vma);
+	return ret;
 }

 void hugetlb_unreserve_pages(struct inode *inode, long offset, long freed)

