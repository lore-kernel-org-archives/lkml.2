Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934429Ab2JKC1L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 22:27:11 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:58931 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933452Ab2JKC1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 22:27:05 -0400
X-Sasl-enc: 5lhJNaBfgdMdDc+7ED0V95gDdIP68vA3CZe0ttnux6y/ 1349922423
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Christoph Lameter <cl@linux.com>,
        Josh Boyer <jwboyer@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 77/84] mempolicy: fix refcount leak in mpol_set_shared_policy()
Date: Thu, 11 Oct 2012 11:04:01 +0900
Message-Id: <20121011015430.922243674@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121011015417.017144658@linuxfoundation.org>
References: <20121011015417.017144658@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/mempolicy.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2095,12 +2095,17 @@ mpol_shared_policy_lookup(struct shared_
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
@@ -2239,7 +2244,7 @@ int mpol_set_shared_policy(struct shared
 	}
 	err = shared_policy_replace(info, vma->vm_pgoff, vma->vm_pgoff+sz, new);
 	if (err && new)
-		kmem_cache_free(sn_cache, new);
+		sp_free(new);
 	return err;
 }
 
@@ -2256,9 +2261,7 @@ void mpol_free_shared_policy(struct shar
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


