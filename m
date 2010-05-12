Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923Ab0ELRmW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 13:42:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756902Ab0ELRmS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 13:42:18 -0400
Date: Wed, 12 May 2010 13:39:31 -0400
From: Rik van Riel <riel@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>, Andrea Arcangeli <aarcange@redhat.com>,
       Minchan Kim <minchan.kim@gmail.com>, Linux-MM <linux-mm@kvack.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 1/5] rename anon_vma_lock to vma_lock_anon_vma
Message-ID: <20100512133931.14c79d22@annuminas.surriel.com>
In-Reply-To: <20100512133815.0d048a86@annuminas.surriel.com>
References: <20100512133815.0d048a86@annuminas.surriel.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: rename anon_vma_lock to vma_lock_anon_vma

Rename anon_vma_lock to vma_lock_anon_vma.  This matches the
naming style used in page_lock_anon_vma and will come in really
handy further down in this patch series.

Signed-off-by: Rik van Riel <riel@redhat.com>
---
 include/linux/rmap.h |    4 ++--
 mm/mmap.c            |   14 +++++++-------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index d25bd22..88cae59 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -90,14 +90,14 @@ static inline struct anon_vma *page_anon_vma(struct page *page)
 	return page_rmapping(page);
 }
 
-static inline void anon_vma_lock(struct vm_area_struct *vma)
+static inline void vma_lock_anon_vma(struct vm_area_struct *vma)
 {
 	struct anon_vma *anon_vma = vma->anon_vma;
 	if (anon_vma)
 		spin_lock(&anon_vma->lock);
 }
 
-static inline void anon_vma_unlock(struct vm_area_struct *vma)
+static inline void vma_unlock_anon_vma(struct vm_area_struct *vma)
 {
 	struct anon_vma *anon_vma = vma->anon_vma;
 	if (anon_vma)
diff --git a/mm/mmap.c b/mm/mmap.c
index 456ec6f..d30bed3 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -452,12 +452,12 @@ static void vma_link(struct mm_struct *mm, struct vm_area_struct *vma,
 		spin_lock(&mapping->i_mmap_lock);
 		vma->vm_truncate_count = mapping->truncate_count;
 	}
-	anon_vma_lock(vma);
+	vma_lock_anon_vma(vma);
 
 	__vma_link(mm, vma, prev, rb_link, rb_parent);
 	__vma_link_file(vma);
 
-	anon_vma_unlock(vma);
+	vma_unlock_anon_vma(vma);
 	if (mapping)
 		spin_unlock(&mapping->i_mmap_lock);
 
@@ -1710,7 +1710,7 @@ int expand_upwards(struct vm_area_struct *vma, unsigned long address)
 	 */
 	if (unlikely(anon_vma_prepare(vma)))
 		return -ENOMEM;
-	anon_vma_lock(vma);
+	vma_lock_anon_vma(vma);
 
 	/*
 	 * vma->vm_start/vm_end cannot change under us because the caller
@@ -1721,7 +1721,7 @@ int expand_upwards(struct vm_area_struct *vma, unsigned long address)
 	if (address < PAGE_ALIGN(address+4))
 		address = PAGE_ALIGN(address+4);
 	else {
-		anon_vma_unlock(vma);
+		vma_unlock_anon_vma(vma);
 		return -ENOMEM;
 	}
 	error = 0;
@@ -1737,7 +1737,7 @@ int expand_upwards(struct vm_area_struct *vma, unsigned long address)
 		if (!error)
 			vma->vm_end = address;
 	}
-	anon_vma_unlock(vma);
+	vma_unlock_anon_vma(vma);
 	return error;
 }
 #endif /* CONFIG_STACK_GROWSUP || CONFIG_IA64 */
@@ -1762,7 +1762,7 @@ static int expand_downwards(struct vm_area_struct *vma,
 	if (error)
 		return error;
 
-	anon_vma_lock(vma);
+	vma_lock_anon_vma(vma);
 
 	/*
 	 * vma->vm_start/vm_end cannot change under us because the caller
@@ -1783,7 +1783,7 @@ static int expand_downwards(struct vm_area_struct *vma,
 			vma->vm_pgoff -= grow;
 		}
 	}
-	anon_vma_unlock(vma);
+	vma_unlock_anon_vma(vma);
 	return error;
 }
 
