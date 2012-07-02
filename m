Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932899Ab2GBU2M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 16:28:12 -0400
Received: from relay1.sgi.com ([192.48.179.29]:42322 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932104Ab2GBU2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 16:28:11 -0400
Date: Mon, 2 Jul 2012 15:28:09 -0500
From: Nathan Zimmer <nzimmer@sgi.com>
To: Nathan Zimmer <nzimmer@sgi.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Christoph Lameter <cl@linux.com>, Nick Piggin <npiggin@gmail.com>,
        Hugh Dickins <hughd@google.com>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>
Subject: [PATCH 1/2 v4][rfc] shmem: provide vm_ops when also providing a
	mem policy
Message-ID: <20120702202809.GA15696@gulag1.americas.sgi.com>
References: <20120702202635.GA20284@gulag1.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120702202635.GA20284@gulag1.americas.sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updating shmem_get_policy to use the vma_policy if provided.
This is to allows us to safely provide shmem_vm_ops to the vma when the vm_file
has not been setup which is the case on the pseudo vmas.


Cc: Christoph Lameter <cl@linux.com>
Cc: Nick Piggin <npiggin@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Nathan T Zimmer <nzimmer@sgi.com>
---

 mm/shmem.c |   18 +++++++++++++++---
 1 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index a15a466..9bd599b 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -921,8 +921,11 @@ static struct page *shmem_swapin(swp_entry_t swap, gfp_t gfp,
 	/* Create a pseudo vma that just contains the policy */
 	pvma.vm_start = 0;
 	pvma.vm_pgoff = index;
-	pvma.vm_ops = NULL;
 	pvma.vm_policy = spol;
+	if( pvma.vm_policy )
+		pvma.vm_ops = &shmem_vm_ops;
+	else
+		pvma.vm_ops = NULL;
 	return swapin_readahead(swap, gfp, &pvma, 0);
 }
 
@@ -934,8 +937,11 @@ static struct page *shmem_alloc_page(gfp_t gfp,
 	/* Create a pseudo vma that just contains the policy */
 	pvma.vm_start = 0;
 	pvma.vm_pgoff = index;
-	pvma.vm_ops = NULL;
 	pvma.vm_policy = mpol_shared_policy_lookup(&info->policy, index);
+	if( pvma.vm_policy )
+		pvma.vm_ops = &shmem_vm_ops;
+	else
+		pvma.vm_ops = NULL;
 
 	/*
 	 * alloc_page_vma() will drop the shared policy reference
@@ -1296,8 +1302,14 @@ static int shmem_set_policy(struct vm_area_struct *vma, struct mempolicy *mpol)
 static struct mempolicy *shmem_get_policy(struct vm_area_struct *vma,
 					  unsigned long addr)
 {
-	struct inode *inode = vma->vm_file->f_path.dentry->d_inode;
 	pgoff_t index;
+	struct inode *inode;
+
+	// If the vma knows what policy it wants use that one.
+	if (vma->vm_policy)
+		return vma->vm_policy;
+
+	inode = vma->vm_file->f_path.dentry->d_inode;
 
 	index = ((addr - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
 	return mpol_shared_policy_lookup(&SHMEM_I(inode)->policy, index);
