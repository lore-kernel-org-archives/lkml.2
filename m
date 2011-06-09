Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757000Ab1FIWjR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 18:39:17 -0400
Received: from smtp-out.google.com ([74.125.121.67]:46039 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710Ab1FIWjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 18:39:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=psR3r7fWe1tvzd7GxOi6lXa7hjSvJllhDmPEQqzrmn1+h4sVRlFW09bY4A7JqeUpT/
         7xmfItTaGBCYogLe3xlw==
Date: Thu, 9 Jun 2011 15:39:07 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Shaohua Li <shaohua.li@intel.com>,
        "Zhang, Yanmin" <yanmin.zhang@intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH 5/7] tmpfs: simplify prealloc_page
In-Reply-To: <alpine.LSU.2.00.1106091529060.2200@sister.anvils>
Message-ID: <alpine.LSU.2.00.1106091535510.2200@sister.anvils>
References: <alpine.LSU.2.00.1106091529060.2200@sister.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The prealloc_page handling in shmem_getpage_gfp() is unnecessarily
complicated: first simplify that before going on to filepage/swappage.

That's right, don't report ENOMEM when the preallocation fails: we may
or may not need the page.  But simply report ENOMEM once we find we do
need it, instead of dropping lock, repeating allocation, unwinding on
failure etc.  And leave the out label on the fast path, don't goto.

Fix something that looks like a bug but turns out not to be: set
PageSwapBacked on prealloc_page before its mem_cgroup_cache_charge(),
as the removed case was doing.  That's important before adding to LRU
(determines which LRU the page goes on), and does affect which path it
takes through memcontrol.c, but in the end MEM_CGROUP_CHANGE_TYPE_
SHMEM is handled no differently from CACHE.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Shaohua Li <shaohua.li@intel.com>
Cc: "Zhang, Yanmin" <yanmin.zhang@intel.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
---
 mm/shmem.c |   59 ++++++++++++---------------------------------------
 1 file changed, 15 insertions(+), 44 deletions(-)

--- linux.orig/mm/shmem.c	2011-06-09 11:39:32.361240481 -0700
+++ linux/mm/shmem.c	2011-06-09 11:39:42.845292474 -0700
@@ -1269,9 +1269,9 @@ repeat:
 			goto failed;
 		radix_tree_preload_end();
 		if (sgp != SGP_READ && !prealloc_page) {
-			/* We don't care if this fails */
 			prealloc_page = shmem_alloc_page(gfp, info, idx);
 			if (prealloc_page) {
+				SetPageSwapBacked(prealloc_page);
 				if (mem_cgroup_cache_charge(prealloc_page,
 						current->mm, GFP_KERNEL)) {
 					page_cache_release(prealloc_page);
@@ -1403,7 +1403,8 @@ repeat:
 			goto repeat;
 		}
 		spin_unlock(&info->lock);
-	} else {
+
+	} else if (prealloc_page) {
 		shmem_swp_unmap(entry);
 		sbinfo = SHMEM_SB(inode->i_sb);
 		if (sbinfo->max_blocks) {
@@ -1419,41 +1420,8 @@ repeat:
 		if (!filepage) {
 			int ret;
 
-			if (!prealloc_page) {
-				spin_unlock(&info->lock);
-				filepage = shmem_alloc_page(gfp, info, idx);
-				if (!filepage) {
-					spin_lock(&info->lock);
-					shmem_unacct_blocks(info->flags, 1);
-					shmem_free_blocks(inode, 1);
-					spin_unlock(&info->lock);
-					error = -ENOMEM;
-					goto failed;
-				}
-				SetPageSwapBacked(filepage);
-
-				/*
-				 * Precharge page while we can wait, compensate
-				 * after
-				 */
-				error = mem_cgroup_cache_charge(filepage,
-					current->mm, GFP_KERNEL);
-				if (error) {
-					page_cache_release(filepage);
-					spin_lock(&info->lock);
-					shmem_unacct_blocks(info->flags, 1);
-					shmem_free_blocks(inode, 1);
-					spin_unlock(&info->lock);
-					filepage = NULL;
-					goto failed;
-				}
-
-				spin_lock(&info->lock);
-			} else {
-				filepage = prealloc_page;
-				prealloc_page = NULL;
-				SetPageSwapBacked(filepage);
-			}
+			filepage = prealloc_page;
+			prealloc_page = NULL;
 
 			entry = shmem_swp_alloc(info, idx, sgp, gfp);
 			if (IS_ERR(entry))
@@ -1492,11 +1460,19 @@ repeat:
 		SetPageUptodate(filepage);
 		if (sgp == SGP_DIRTY)
 			set_page_dirty(filepage);
+	} else {
+		error = -ENOMEM;
+		goto out;
 	}
 done:
 	*pagep = filepage;
 	error = 0;
-	goto out;
+out:
+	if (prealloc_page) {
+		mem_cgroup_uncharge_cache_page(prealloc_page);
+		page_cache_release(prealloc_page);
+	}
+	return error;
 
 nospace:
 	/*
@@ -1520,12 +1496,7 @@ failed:
 		unlock_page(filepage);
 		page_cache_release(filepage);
 	}
-out:
-	if (prealloc_page) {
-		mem_cgroup_uncharge_cache_page(prealloc_page);
-		page_cache_release(prealloc_page);
-	}
-	return error;
+	goto out;
 }
 
 static int shmem_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
