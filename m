Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932152Ab2JNPLx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 11:11:53 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46187 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754342Ab2JNOmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:42:10 -0400
Message-Id: <20121014143551.203642738@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:37:42 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mel Gorman <mgorman@suse.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Christoph Lameter <cl@linux.com>, Josh Boyer <jwboyer@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 129/147] mempolicy: fix a race in shared_policy_replace()
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mel Gorman <mgorman@suse.de>

commit b22d127a39ddd10d93deee3d96e643657ad53a49 upstream.

shared_policy_replace() use of sp_alloc() is unsafe.  1) sp_node cannot
be dereferenced if sp->lock is not held and 2) another thread can modify
sp_node between spin_unlock for allocating a new sp node and next
spin_lock.  The bug was introduced before 2.6.12-rc2.

Kosaki's original patch for this problem was to allocate an sp node and
policy within shared_policy_replace and initialise it when the lock is
reacquired.  I was not keen on this approach because it partially
duplicates sp_alloc().  As the paths were sp->lock is taken are not that
performance critical this patch converts sp->lock to sp->mutex so it can
sleep when calling sp_alloc().

[kosaki.motohiro@jp.fujitsu.com: Original patch]
Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Christoph Lameter <cl@linux.com>
Cc: Josh Boyer <jwboyer@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/mempolicy.h |    2 +-
 mm/mempolicy.c            |   37 ++++++++++++++++---------------------
 2 files changed, 17 insertions(+), 22 deletions(-)

diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
index 95b738c..df08254 100644
--- a/include/linux/mempolicy.h
+++ b/include/linux/mempolicy.h
@@ -188,7 +188,7 @@ struct sp_node {
 
 struct shared_policy {
 	struct rb_root root;
-	spinlock_t lock;
+	struct mutex mutex;
 };
 
 void mpol_shared_policy_init(struct shared_policy *sp, struct mempolicy *mpol);
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index f0728ae..b2f12ec 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2083,7 +2083,7 @@ bool __mpol_equal(struct mempolicy *a, struct mempolicy *b)
  */
 
 /* lookup first element intersecting start-end */
-/* Caller holds sp->lock */
+/* Caller holds sp->mutex */
 static struct sp_node *
 sp_lookup(struct shared_policy *sp, unsigned long start, unsigned long end)
 {
@@ -2147,13 +2147,13 @@ mpol_shared_policy_lookup(struct shared_policy *sp, unsigned long idx)
 
 	if (!sp->root.rb_node)
 		return NULL;
-	spin_lock(&sp->lock);
+	mutex_lock(&sp->mutex);
 	sn = sp_lookup(sp, idx, idx+1);
 	if (sn) {
 		mpol_get(sn->policy);
 		pol = sn->policy;
 	}
-	spin_unlock(&sp->lock);
+	mutex_unlock(&sp->mutex);
 	return pol;
 }
 
@@ -2193,10 +2193,10 @@ static struct sp_node *sp_alloc(unsigned long start, unsigned long end,
 static int shared_policy_replace(struct shared_policy *sp, unsigned long start,
 				 unsigned long end, struct sp_node *new)
 {
-	struct sp_node *n, *new2 = NULL;
+	struct sp_node *n;
+	int ret = 0;
 
-restart:
-	spin_lock(&sp->lock);
+	mutex_lock(&sp->mutex);
 	n = sp_lookup(sp, start, end);
 	/* Take care of old policies in the same range. */
 	while (n && n->start < end) {
@@ -2209,16 +2209,14 @@ restart:
 		} else {
 			/* Old policy spanning whole new range. */
 			if (n->end > end) {
+				struct sp_node *new2;
+				new2 = sp_alloc(end, n->end, n->policy);
 				if (!new2) {
-					spin_unlock(&sp->lock);
-					new2 = sp_alloc(end, n->end, n->policy);
-					if (!new2)
-						return -ENOMEM;
-					goto restart;
+					ret = -ENOMEM;
+					goto out;
 				}
 				n->end = start;
 				sp_insert(sp, new2);
-				new2 = NULL;
 				break;
 			} else
 				n->end = start;
@@ -2229,12 +2227,9 @@ restart:
 	}
 	if (new)
 		sp_insert(sp, new);
-	spin_unlock(&sp->lock);
-	if (new2) {
-		mpol_put(new2->policy);
-		kmem_cache_free(sn_cache, new2);
-	}
-	return 0;
+out:
+	mutex_unlock(&sp->mutex);
+	return ret;
 }
 
 /**
@@ -2252,7 +2247,7 @@ void mpol_shared_policy_init(struct shared_policy *sp, struct mempolicy *mpol)
 	int ret;
 
 	sp->root = RB_ROOT;		/* empty tree == default mempolicy */
-	spin_lock_init(&sp->lock);
+	mutex_init(&sp->mutex);
 
 	if (mpol) {
 		struct vm_area_struct pvma;
@@ -2318,7 +2313,7 @@ void mpol_free_shared_policy(struct shared_policy *p)
 
 	if (!p->root.rb_node)
 		return;
-	spin_lock(&p->lock);
+	mutex_lock(&p->mutex);
 	next = rb_first(&p->root);
 	while (next) {
 		n = rb_entry(next, struct sp_node, nd);
@@ -2327,7 +2322,7 @@ void mpol_free_shared_policy(struct shared_policy *p)
 		mpol_put(n->policy);
 		kmem_cache_free(sn_cache, n);
 	}
-	spin_unlock(&p->lock);
+	mutex_unlock(&p->mutex);
 }
 
 /* assumes fs == KERNEL_DS */


