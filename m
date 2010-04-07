Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932709Ab0DGO4N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 10:56:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62590 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932581Ab0DGO4M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 10:56:12 -0400
Date: Wed, 7 Apr 2010 10:54:54 -0400
From: Rik van Riel <riel@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: kosaki.motohiro@jp.fujitsu.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Borislav Petkov <bp@alien8.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com,
       hannes@cmpxchg.org
Subject: [PATCH -v2] rmap: make anon_vma_prepare link in all the anon_vmas
 of a mergeable VMA
Message-ID: <20100407105454.2e7ab9bf@annuminas.surriel.com>
In-Reply-To: <20100407151357.FB7E.A69D9226@jp.fujitsu.com>
References: <alpine.LFD.2.00.1004061609320.3487@i5.linux-foundation.org>
	<20100406195459.554265e7@annuminas.surriel.com>
	<20100407151357.FB7E.A69D9226@jp.fujitsu.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a new VMA has a mergeable anon_vma with a neighboring VMA,
make sure all of the neighbor's old anon_vma structs are also
linked in.

This is necessary because at some point the VMAs could get merged,
and we want to ensure no anon_vma structs get freed prematurely,
while the system still has anonymous pages that belong to those
structs.

Reported-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Rik van Riel <riel@redhat.com>

--- 
v2:
 - fix the locking issues spotted by Kosaki Motohiro
 - set vma->anon_vma correctly

 include/linux/mm.h |    2 +-
 mm/mmap.c          |    6 +++---
 mm/rmap.c          |   27 ++++++++++++++++++---------
 3 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index e70f21b..90ac50e 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1228,7 +1228,7 @@ extern struct vm_area_struct *vma_merge(struct mm_struct *,
 	struct vm_area_struct *prev, unsigned long addr, unsigned long end,
 	unsigned long vm_flags, struct anon_vma *, struct file *, pgoff_t,
 	struct mempolicy *);
-extern struct anon_vma *find_mergeable_anon_vma(struct vm_area_struct *);
+extern struct vm_area_struct *find_mergeable_anon_vma(struct vm_area_struct *);
 extern int split_vma(struct mm_struct *,
 	struct vm_area_struct *, unsigned long addr, int new_below);
 extern int insert_vm_struct(struct mm_struct *, struct vm_area_struct *);
diff --git a/mm/mmap.c b/mm/mmap.c
index 75557c6..bf0600c 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -832,7 +832,7 @@ struct vm_area_struct *vma_merge(struct mm_struct *mm,
  * anon_vmas being allocated, preventing vma merge in subsequent
  * mprotect.
  */
-struct anon_vma *find_mergeable_anon_vma(struct vm_area_struct *vma)
+struct vm_area_struct *find_mergeable_anon_vma(struct vm_area_struct *vma)
 {
 	struct vm_area_struct *near;
 	unsigned long vm_flags;
@@ -855,7 +855,7 @@ struct anon_vma *find_mergeable_anon_vma(struct vm_area_struct *vma)
 			can_vma_merge_before(near, vm_flags,
 				NULL, vma->vm_file, vma->vm_pgoff +
 				((vma->vm_end - vma->vm_start) >> PAGE_SHIFT)))
-		return near->anon_vma;
+		return near;
 try_prev:
 	/*
 	 * It is potentially slow to have to call find_vma_prev here.
@@ -875,7 +875,7 @@ try_prev:
   			mpol_equal(vma_policy(near), vma_policy(vma)) &&
 			can_vma_merge_after(near, vm_flags,
 				NULL, vma->vm_file, vma->vm_pgoff))
-		return near->anon_vma;
+		return near;
 none:
 	/*
 	 * There's no absolute need to look only at touching neighbours:
diff --git a/mm/rmap.c b/mm/rmap.c
index eaa7a09..abe7aa5 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -119,24 +119,33 @@ int anon_vma_prepare(struct vm_area_struct *vma)
 	might_sleep();
 	if (unlikely(!anon_vma)) {
 		struct mm_struct *mm = vma->vm_mm;
+		struct vm_area_struct *merge_vma;
 		struct anon_vma *allocated;
 
+		merge_vma = find_mergeable_anon_vma(vma);
+		if (merge_vma) {
+			int ret;
+			spin_lock(&mm->page_table_lock);
+			ret = anon_vma_clone(vma, merge_vma);
+			if (!ret)
+				vma->anon_vma = merge_vma->anon_vma;
+			spin_unlock(&mm->page_table_lock);
+			return ret;
+		}
+
 		avc = anon_vma_chain_alloc();
 		if (!avc)
 			goto out_enomem;
 
-		anon_vma = find_mergeable_anon_vma(vma);
 		allocated = NULL;
-		if (!anon_vma) {
-			anon_vma = anon_vma_alloc();
-			if (unlikely(!anon_vma))
-				goto out_enomem_free_avc;
-			allocated = anon_vma;
-		}
-		spin_lock(&anon_vma->lock);
+		anon_vma = anon_vma_alloc();
+		if (unlikely(!anon_vma))
+			goto out_enomem_free_avc;
+		allocated = anon_vma;
 
 		/* page_table_lock to protect against threads */
 		spin_lock(&mm->page_table_lock);
+		spin_lock(&anon_vma->lock);
 		if (likely(!vma->anon_vma)) {
 			vma->anon_vma = anon_vma;
 			avc->anon_vma = anon_vma;
@@ -145,9 +154,9 @@ int anon_vma_prepare(struct vm_area_struct *vma)
 			list_add(&avc->same_anon_vma, &anon_vma->head);
 			allocated = NULL;
 		}
+		spin_unlock(&anon_vma->lock);
 		spin_unlock(&mm->page_table_lock);
 
-		spin_unlock(&anon_vma->lock);
 		if (unlikely(allocated)) {
 			anon_vma_free(allocated);
 			anon_vma_chain_free(avc);

