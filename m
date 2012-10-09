Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050Ab2JIQ70 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 12:59:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53586 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752926Ab2JIQ6s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 12:58:48 -0400
From: Mel Gorman <mgorman@suse.de>
To: Stable <stable@vger.kernel.org>
Cc: Andi Kleen <ak@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Dave Jones <davej@redhat.com>, Christoph Lameter <cl@linux.com>,
        Hugh Dickins <hughd@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 4/5] mempolicy: fix refcount leak in mpol_set_shared_policy()
Date: Tue,  9 Oct 2012 17:58:40 +0100
Message-Id: <1349801921-16598-5-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1349801921-16598-1-git-send-email-mgorman@suse.de>
References: <1349801921-16598-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

commit 63f74ca21f1fad36d075e063f06dcc6d39fe86b2 upstream.

When shared_policy_replace() fails to allocate new->policy is not freed
correctly by mpol_set_shared_policy().  The problem is that shared
mempolicy code directly call kmem_cache_free() in multiple places where
it is easy to make a mistake.

This patch creates an sp_free wrapper function and uses it. The bug was
introduced pre-git age (IOW, before 2.6.12-rc2).

[mgorman@suse.de: Editted changelog]
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Christoph Lameter <cl@linux.com>
Cc: Josh Boyer <jwboyer@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/mempolicy.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index b2f12ec..1763418 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2157,12 +2157,17 @@ mpol_shared_policy_lookup(struct shared_policy *sp, unsigned long idx)
 	return pol;
 }
 
+static void sp_free(struct sp_node *n)
+{
+	mpol_put(n->policy);
+	kmem_cache_free(sn_cache, n);
+}
+
 static void sp_delete(struct shared_policy *sp, struct sp_node *n)
 {
 	pr_debug("deleting %lx-l%lx\n", n->start, n->end);
 	rb_erase(&n->nd, &sp->root);
-	mpol_put(n->policy);
-	kmem_cache_free(sn_cache, n);
+	sp_free(n);
 }
 
 static struct sp_node *sp_alloc(unsigned long start, unsigned long end,
@@ -2301,7 +2306,7 @@ int mpol_set_shared_policy(struct shared_policy *info,
 	}
 	err = shared_policy_replace(info, vma->vm_pgoff, vma->vm_pgoff+sz, new);
 	if (err && new)
-		kmem_cache_free(sn_cache, new);
+		sp_free(new);
 	return err;
 }
 
@@ -2318,9 +2323,7 @@ void mpol_free_shared_policy(struct shared_policy *p)
 	while (next) {
 		n = rb_entry(next, struct sp_node, nd);
 		next = rb_next(&n->nd);
-		rb_erase(&n->nd, &p->root);
-		mpol_put(n->policy);
-		kmem_cache_free(sn_cache, n);
+		sp_delete(p, n);
 	}
 	mutex_unlock(&p->mutex);
 }
-- 
1.7.9.2

