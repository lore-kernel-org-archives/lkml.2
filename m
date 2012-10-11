Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934442Ab2JKC1q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 22:27:46 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:46803 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934406Ab2JKC07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 22:26:59 -0400
X-Sasl-enc: g1W/41Lm2sYcLWcFClEH5QJwpKYi/Ug9Ylh+5OA+/Tzm 1349922417
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Mel Gorman <mgorman@suse.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Christoph Lameter <cl@linux.com>, Josh Boyer <jwboyer@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 76/84] mempolicy: fix a race in shared_policy_replace()
Date: Thu, 11 Oct 2012 11:04:00 +0900
Message-Id: <20121011015430.744047863@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121011015417.017144658@linuxfoundation.org>
References: <20121011015417.017144658@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/mempolicy.h |    2 +-
 mm/mempolicy.c            |   37 ++++++++++++++++---------------------
 2 files changed, 17 insertions(+), 22 deletions(-)

--- a/include/linux/mempolicy.h
+++ b/include/linux/mempolicy.h
@@ -188,7 +188,7 @@ struct sp_node {
 
 struct shared_policy {
 	struct rb_root root;
-	spinlock_t lock;
+	struct mutex mutex;
 };
 
 void mpol_shared_policy_init(struct shared_policy *sp, struct mempolicy *mpol);
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2021,7 +2021,7 @@ int __mpol_equal(struct mempolicy *a, st
  */
 
 /* lookup first element intersecting start-end */
-/* Caller holds sp->lock */
+/* Caller holds sp->mutex */
 static struct sp_node *
 sp_lookup(struct shared_policy *sp, unsigned long start, unsigned long end)
 {
@@ -2085,13 +2085,13 @@ mpol_shared_policy_lookup(struct shared_
 
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
 
@@ -2131,10 +2131,10 @@ static struct sp_node *sp_alloc(unsigned
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
@@ -2147,16 +2147,14 @@ restart:
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
@@ -2167,12 +2165,9 @@ restart:
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
@@ -2190,7 +2185,7 @@ void mpol_shared_policy_init(struct shar
 	int ret;
 
 	sp->root = RB_ROOT;		/* empty tree == default mempolicy */
-	spin_lock_init(&sp->lock);
+	mutex_init(&sp->mutex);
 
 	if (mpol) {
 		struct vm_area_struct pvma;
@@ -2256,7 +2251,7 @@ void mpol_free_shared_policy(struct shar
 
 	if (!p->root.rb_node)
 		return;
-	spin_lock(&p->lock);
+	mutex_lock(&p->mutex);
 	next = rb_first(&p->root);
 	while (next) {
 		n = rb_entry(next, struct sp_node, nd);
@@ -2265,7 +2260,7 @@ void mpol_free_shared_policy(struct shar
 		mpol_put(n->policy);
 		kmem_cache_free(sn_cache, n);
 	}
-	spin_unlock(&p->lock);
+	mutex_unlock(&p->mutex);
 }
 
 /* assumes fs == KERNEL_DS */


