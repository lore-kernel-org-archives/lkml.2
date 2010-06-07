Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932654Ab0FGLYV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 07:24:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:41247 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398Ab0FGLUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 07:20:16 -0400
Message-Id: <20100607111406.754933642@chello.nl>
User-Agent: quilt/0.48-1
Date: Mon, 07 Jun 2010 13:06:58 +0200
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
Subject: [PATCH 04/28] change direct call of spin_lock(anon_vma->lock) to inline function
References: <20100607110654.606530953@chello.nl>
Content-Disposition: inline; filename=riel-02-mm-change_direct_call_of_spin_lock_anon_vma-_lock__to_inline_function.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>

Subsitute a direct call of spin_lock(anon_vma->lock) with
an inline function doing exactly the same.

This makes it easier to do the substitution to the root
anon_vma lock in a following patch.

We will deal with the handful of special locks (nested,
dec_and_lock, etc) separately.

Signed-off-by: Rik van Riel <riel@redhat.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20100526153926.1272945b@annuminas.surriel.com>
---
 include/linux/rmap.h |   10 ++++++++++
 mm/ksm.c             |   18 +++++++++---------
 mm/migrate.c         |    2 +-
 mm/mmap.c            |    2 +-
 mm/rmap.c            |   20 ++++++++++----------
 5 files changed, 31 insertions(+), 21 deletions(-)

Index: linux-2.6/include/linux/rmap.h
===================================================================
--- linux-2.6.orig/include/linux/rmap.h
+++ linux-2.6/include/linux/rmap.h
@@ -113,6 +113,16 @@ static inline void vma_unlock_anon_vma(s
 		spin_unlock(&anon_vma->lock);
 }
 
+static inline void anon_vma_lock(struct anon_vma *anon_vma)
+{
+	spin_lock(&anon_vma->lock);
+}
+
+static inline void anon_vma_unlock(struct anon_vma *anon_vma)
+{
+	spin_unlock(&anon_vma->lock);
+}
+
 /*
  * anon_vma helper functions.
  */
Index: linux-2.6/mm/ksm.c
===================================================================
--- linux-2.6.orig/mm/ksm.c
+++ linux-2.6/mm/ksm.c
@@ -327,7 +327,7 @@ static void drop_anon_vma(struct rmap_it
 
 	if (atomic_dec_and_lock(&anon_vma->external_refcount, &anon_vma->lock)) {
 		int empty = list_empty(&anon_vma->head);
-		spin_unlock(&anon_vma->lock);
+		anon_vma_unlock(anon_vma);
 		if (empty)
 			anon_vma_free(anon_vma);
 	}
@@ -1566,7 +1566,7 @@ again:
 		struct anon_vma_chain *vmac;
 		struct vm_area_struct *vma;
 
-		spin_lock(&anon_vma->lock);
+		anon_vma_lock(anon_vma);
 		list_for_each_entry(vmac, &anon_vma->head, same_anon_vma) {
 			vma = vmac->vma;
 			if (rmap_item->address < vma->vm_start ||
@@ -1589,7 +1589,7 @@ again:
 			if (!search_new_forks || !mapcount)
 				break;
 		}
-		spin_unlock(&anon_vma->lock);
+		anon_vma_unlock(anon_vma);
 		if (!mapcount)
 			goto out;
 	}
@@ -1619,7 +1619,7 @@ again:
 		struct anon_vma_chain *vmac;
 		struct vm_area_struct *vma;
 
-		spin_lock(&anon_vma->lock);
+		anon_vma_lock(anon_vma);
 		list_for_each_entry(vmac, &anon_vma->head, same_anon_vma) {
 			vma = vmac->vma;
 			if (rmap_item->address < vma->vm_start ||
@@ -1637,11 +1637,11 @@ again:
 			ret = try_to_unmap_one(page, vma,
 					rmap_item->address, flags);
 			if (ret != SWAP_AGAIN || !page_mapped(page)) {
-				spin_unlock(&anon_vma->lock);
+				anon_vma_unlock(anon_vma);
 				goto out;
 			}
 		}
-		spin_unlock(&anon_vma->lock);
+		anon_vma_unlock(anon_vma);
 	}
 	if (!search_new_forks++)
 		goto again;
@@ -1671,7 +1671,7 @@ again:
 		struct anon_vma_chain *vmac;
 		struct vm_area_struct *vma;
 
-		spin_lock(&anon_vma->lock);
+		anon_vma_lock(anon_vma);
 		list_for_each_entry(vmac, &anon_vma->head, same_anon_vma) {
 			vma = vmac->vma;
 			if (rmap_item->address < vma->vm_start ||
@@ -1688,11 +1688,11 @@ again:
 
 			ret = rmap_one(page, vma, rmap_item->address, arg);
 			if (ret != SWAP_AGAIN) {
-				spin_unlock(&anon_vma->lock);
+				anon_vma_unlock(anon_vma);
 				goto out;
 			}
 		}
-		spin_unlock(&anon_vma->lock);
+		anon_vma_unlock(anon_vma);
 	}
 	if (!search_new_forks++)
 		goto again;
Index: linux-2.6/mm/mmap.c
===================================================================
--- linux-2.6.orig/mm/mmap.c
+++ linux-2.6/mm/mmap.c
@@ -2589,7 +2589,7 @@ static void vm_unlock_anon_vma(struct an
 		if (!__test_and_clear_bit(0, (unsigned long *)
 					  &anon_vma->head.next))
 			BUG();
-		spin_unlock(&anon_vma->lock);
+		anon_vma_unlock(anon_vma);
 	}
 }
 
Index: linux-2.6/mm/rmap.c
===================================================================
--- linux-2.6.orig/mm/rmap.c
+++ linux-2.6/mm/rmap.c
@@ -134,7 +134,7 @@ int anon_vma_prepare(struct vm_area_stru
 			allocated = anon_vma;
 		}
 
-		spin_lock(&anon_vma->lock);
+		anon_vma_lock(anon_vma);
 		/* page_table_lock to protect against threads */
 		spin_lock(&mm->page_table_lock);
 		if (likely(!vma->anon_vma)) {
@@ -147,7 +147,7 @@ int anon_vma_prepare(struct vm_area_stru
 			avc = NULL;
 		}
 		spin_unlock(&mm->page_table_lock);
-		spin_unlock(&anon_vma->lock);
+		anon_vma_unlock(anon_vma);
 
 		if (unlikely(allocated))
 			anon_vma_free(allocated);
@@ -170,9 +170,9 @@ static void anon_vma_chain_link(struct v
 	avc->anon_vma = anon_vma;
 	list_add(&avc->same_vma, &vma->anon_vma_chain);
 
-	spin_lock(&anon_vma->lock);
+	anon_vma_lock(anon_vma);
 	list_add_tail(&avc->same_anon_vma, &anon_vma->head);
-	spin_unlock(&anon_vma->lock);
+	anon_vma_unlock(anon_vma);
 }
 
 /*
@@ -246,12 +246,12 @@ static void anon_vma_unlink(struct anon_
 	if (!anon_vma)
 		return;
 
-	spin_lock(&anon_vma->lock);
+	anon_vma_lock(anon_vma);
 	list_del(&anon_vma_chain->same_anon_vma);
 
 	/* We must garbage collect the anon_vma if it's empty */
 	empty = list_empty(&anon_vma->head) && !anonvma_external_refcount(anon_vma);
-	spin_unlock(&anon_vma->lock);
+	anon_vma_unlock(anon_vma);
 
 	if (empty)
 		anon_vma_free(anon_vma);
@@ -302,7 +302,7 @@ struct anon_vma *page_lock_anon_vma(stru
 		goto out;
 
 	anon_vma = (struct anon_vma *) (anon_mapping - PAGE_MAPPING_ANON);
-	spin_lock(&anon_vma->lock);
+	anon_vma_lock(anon_vma);
 	return anon_vma;
 out:
 	rcu_read_unlock();
@@ -311,7 +311,7 @@ out:
 
 void page_unlock_anon_vma(struct anon_vma *anon_vma)
 {
-	spin_unlock(&anon_vma->lock);
+	anon_vma_unlock(anon_vma);
 	rcu_read_unlock();
 }
 
@@ -1389,7 +1389,7 @@ static int rmap_walk_anon(struct page *p
 	anon_vma = page_anon_vma(page);
 	if (!anon_vma)
 		return ret;
-	spin_lock(&anon_vma->lock);
+	anon_vma_lock(anon_vma);
 	list_for_each_entry(avc, &anon_vma->head, same_anon_vma) {
 		struct vm_area_struct *vma = avc->vma;
 		unsigned long address = vma_address(page, vma);
@@ -1399,7 +1399,7 @@ static int rmap_walk_anon(struct page *p
 		if (ret != SWAP_AGAIN)
 			break;
 	}
-	spin_unlock(&anon_vma->lock);
+	anon_vma_unlock(anon_vma);
 	return ret;
 }
 
Index: linux-2.6/mm/migrate.c
===================================================================
--- linux-2.6.orig/mm/migrate.c
+++ linux-2.6/mm/migrate.c
@@ -684,7 +684,7 @@ rcu_unlock:
 	/* Drop an anon_vma reference if we took one */
 	if (anon_vma && atomic_dec_and_lock(&anon_vma->external_refcount, &anon_vma->lock)) {
 		int empty = list_empty(&anon_vma->head);
-		spin_unlock(&anon_vma->lock);
+		anon_vma_unlock(anon_vma);
 		if (empty)
 			anon_vma_free(anon_vma);
 	}


