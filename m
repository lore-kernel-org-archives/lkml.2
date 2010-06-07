Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173Ab0FGLUR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 07:20:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:41223 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440Ab0FGLUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 07:20:06 -0400
Message-Id: <20100607111406.662536918@chello.nl>
User-Agent: quilt/0.48-1
Date: Mon, 07 Jun 2010 13:06:57 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH 03/28] rename anon_vma_lock to vma_lock_anon_vma
References: <20100607110654.606530953@chello.nl>
Content-Disposition: inline; filename=riel-01-mm-rename_anon_vma_lock_to_vma_lock_anon_vma.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>

Rename anon_vma_lock to vma_lock_anon_vma.  This matches the
naming style used in page_lock_anon_vma and will come in really
handy further down in this patch series.

Signed-off-by: Rik van Riel <riel@redhat.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20100526153853.55b72183@annuminas.surriel.com>
---
 include/linux/rmap.h |    4 ++--
 mm/mmap.c            |   12 ++++++------
 2 files changed, 8 insertions(+), 8 deletions(-)

Index: linux-2.6/include/linux/rmap.h
===================================================================
--- linux-2.6.orig/include/linux/rmap.h
+++ linux-2.6/include/linux/rmap.h
@@ -99,14 +99,14 @@ static inline struct anon_vma *page_anon
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
Index: linux-2.6/mm/mmap.c
===================================================================
--- linux-2.6.orig/mm/mmap.c
+++ linux-2.6/mm/mmap.c
@@ -452,12 +452,12 @@ static void vma_link(struct mm_struct *m
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
 
@@ -1710,7 +1710,7 @@ int expand_upwards(struct vm_area_struct
 	 */
 	if (unlikely(anon_vma_prepare(vma)))
 		return -ENOMEM;
-	anon_vma_lock(vma);
+	vma_lock_anon_vma(vma);
 
 	/*
 	 * vma->vm_start/vm_end cannot change under us because the caller
@@ -1721,7 +1721,7 @@ int expand_upwards(struct vm_area_struct
 	if (address < PAGE_ALIGN(address+4))
 		address = PAGE_ALIGN(address+4);
 	else {
-		anon_vma_unlock(vma);
+		vma_unlock_anon_vma(vma);
 		return -ENOMEM;
 	}
 	error = 0;
@@ -1737,7 +1737,7 @@ int expand_upwards(struct vm_area_struct
 		if (!error)
 			vma->vm_end = address;
 	}
-	anon_vma_unlock(vma);
+	vma_unlock_anon_vma(vma);
 	return error;
 }
 #endif /* CONFIG_STACK_GROWSUP || CONFIG_IA64 */
@@ -1762,7 +1762,7 @@ static int expand_downwards(struct vm_ar
 	if (error)
 		return error;
 
-	anon_vma_lock(vma);
+	vma_lock_anon_vma(vma);
 
 	/*
 	 * vma->vm_start/vm_end cannot change under us because the caller


