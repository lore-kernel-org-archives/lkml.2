Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713Ab0ELRmJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 13:42:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51581 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435Ab0ELRmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 13:42:07 -0400
Date: Wed, 12 May 2010 13:41:11 -0400
From: Rik van Riel <riel@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>, Andrea Arcangeli <aarcange@redhat.com>,
       Minchan Kim <minchan.kim@gmail.com>, Linux-MM <linux-mm@kvack.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5/5] extend KSM refcounts to the anon_vma root
Message-ID: <20100512134111.467fb6c2@annuminas.surriel.com>
In-Reply-To: <20100512133815.0d048a86@annuminas.surriel.com>
References: <20100512133815.0d048a86@annuminas.surriel.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: extend KSM refcounts to the anon_vma root

KSM reference counts can cause an anon_vma to exist after the processe
it belongs to have already exited.  Because the anon_vma lock now lives
in the root anon_vma, we need to ensure that the root anon_vma stays
around until after all the "child" anon_vmas have been freed.

The obvious way to do this is to have a "child" anon_vma take a
reference to the root in anon_vma_fork.  When the anon_vma is freed
at munmap or process exit, we drop the refcount in anon_vma_unlink
and possibly free the root anon_vma.

The KSM anon_vma reference count function also needs to be modified
to deal with the possibility of freeing 2 levels of anon_vma.  The
easiest way to do this is to break out the KSM magic and make it
generic.

When compiling without CONFIG_KSM, this code is compiled out.

Signed-off-by: Rik van Riel <riel@redhat.com>
---
 include/linux/rmap.h |   12 ++++++++++++
 mm/ksm.c             |   17 ++++++-----------
 mm/rmap.c            |   45 ++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 62 insertions(+), 12 deletions(-)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 33ffe14..387d40c 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -126,6 +126,18 @@ int anon_vma_fork(struct vm_area_struct *, struct vm_area_struct *);
 void __anon_vma_link(struct vm_area_struct *);
 void anon_vma_free(struct anon_vma *);
 
+#ifdef CONFIG_KSM
+static inline void get_anon_vma(struct anon_vma *anon_vma)
+{
+	atomic_inc(&anon_vma->ksm_refcount);
+}
+
+void drop_anon_vma(struct anon_vma *);
+#else
+#define get_anon_vma(x)		do {} while(0)
+#define drop_anon_vma(x)	do {} while(0)
+#endif
+
 static inline void anon_vma_merge(struct vm_area_struct *vma,
 				  struct vm_area_struct *next)
 {
diff --git a/mm/ksm.c b/mm/ksm.c
index 7ca0dd7..9f2acc9 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -318,19 +318,14 @@ static void hold_anon_vma(struct rmap_item *rmap_item,
 			  struct anon_vma *anon_vma)
 {
 	rmap_item->anon_vma = anon_vma;
-	atomic_inc(&anon_vma->ksm_refcount);
+	get_anon_vma(anon_vma);
 }
 
-static void drop_anon_vma(struct rmap_item *rmap_item)
+static void ksm_drop_anon_vma(struct rmap_item *rmap_item)
 {
 	struct anon_vma *anon_vma = rmap_item->anon_vma;
 
-	if (atomic_dec_and_lock(&anon_vma->ksm_refcount, &anon_vma->root->lock)) {
-		int empty = list_empty(&anon_vma->head);
-		anon_vma_unlock(anon_vma);
-		if (empty)
-			anon_vma_free(anon_vma);
-	}
+	drop_anon_vma(anon_vma);
 }
 
 /*
@@ -415,7 +410,7 @@ static void break_cow(struct rmap_item *rmap_item)
 	 * It is not an accident that whenever we want to break COW
 	 * to undo, we also need to drop a reference to the anon_vma.
 	 */
-	drop_anon_vma(rmap_item);
+	ksm_drop_anon_vma(rmap_item);
 
 	down_read(&mm->mmap_sem);
 	if (ksm_test_exit(mm))
@@ -470,7 +465,7 @@ static void remove_node_from_stable_tree(struct stable_node *stable_node)
 			ksm_pages_sharing--;
 		else
 			ksm_pages_shared--;
-		drop_anon_vma(rmap_item);
+		ksm_drop_anon_vma(rmap_item);
 		rmap_item->address &= PAGE_MASK;
 		cond_resched();
 	}
@@ -558,7 +553,7 @@ static void remove_rmap_item_from_tree(struct rmap_item *rmap_item)
 		else
 			ksm_pages_shared--;
 
-		drop_anon_vma(rmap_item);
+		ksm_drop_anon_vma(rmap_item);
 		rmap_item->address &= PAGE_MASK;
 
 	} else if (rmap_item->address & UNSTABLE_FLAG) {
diff --git a/mm/rmap.c b/mm/rmap.c
index f0ba648..d63cd91 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -238,6 +238,12 @@ int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma)
 	 */
 	root_avc = list_entry(vma->anon_vma_chain.prev, struct anon_vma_chain, same_vma);
 	anon_vma->root = root_avc->anon_vma;
+	/*
+	 * With KSM refcounts, an anon_vma can stay around longer than the
+	 * process it belongs to.  The root anon_vma needs to be pinned,
+	 * because that is where the lock lives.
+	 */
+	get_anon_vma(anon_vma->root);
 	/* Mark this anon_vma as the one where our new (COWed) pages go. */
 	vma->anon_vma = anon_vma;
 	anon_vma_chain_link(vma, avc, anon_vma);
@@ -267,8 +273,11 @@ static void anon_vma_unlink(struct anon_vma_chain *anon_vma_chain)
 	empty = list_empty(&anon_vma->head) && !ksm_refcount(anon_vma);
 	anon_vma_unlock(anon_vma);
 
-	if (empty)
+	if (empty) {
+		/* We no longer need the root anon_vma */
+		drop_anon_vma(anon_vma->root);
 		anon_vma_free(anon_vma);
+	}
 }
 
 void unlink_anon_vmas(struct vm_area_struct *vma)
@@ -1355,6 +1364,40 @@ int try_to_munlock(struct page *page)
 		return try_to_unmap_file(page, TTU_MUNLOCK);
 }
 
+#ifdef CONFIG_KSM
+/*
+ * Drop an anon_vma refcount, freeing the anon_vma and anon_vma->root
+ * if necessary.  Be careful to do all the tests under the lock.  Once
+ * we know we are the last user, nobody else can get a reference and we
+ * can do the freeing without the lock.
+ */
+void drop_anon_vma(struct anon_vma *anon_vma)
+{
+	if (atomic_dec_and_lock(&anon_vma->ksm_refcount, &anon_vma->root->lock)) {
+		struct anon_vma *root = anon_vma->root;
+		int empty list_empty(&anon_vma->head);
+		int last_root_user = 0;
+		int root_empty = 0;
+
+		/*
+		 * The refcount on a non-root anon_vma got dropped.  Drop
+		 * the refcount on the root and check if we need to free it.
+		 */
+		if (empty && anon_vma != root) {
+			last_root_user = atomic_dec_and_test(&root->ksm_refcount);
+			root_empty = list_empty(&root->head);
+		}
+		anon_vma_unlock(anon_vma);
+
+		if (empty) {
+			anon_vma_free(anon_vma);
+			if (root_empty && last_root_user)
+				anon_vma_free(root);
+		}
+	}
+}
+#endif
+
 #ifdef CONFIG_MIGRATION
 /*
  * rmap_walk() and its helpers rmap_walk_anon() and rmap_walk_file():
