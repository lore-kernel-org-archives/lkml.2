Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759791Ab2BNJC3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 04:02:29 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:34718 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755371Ab2BNJC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 04:02:26 -0500
Message-ID: <4F3A230A.20301@linux.vnet.ibm.com>
Date: Tue, 14 Feb 2012 17:02:02 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/4] prio_tree: introduce prio_set_parent
References: <4F3A2285.7060700@linux.vnet.ibm.com>
In-Reply-To: <4F3A2285.7060700@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12021322-5490-0000-0000-000000BBEE6A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce prio_set_parent to abstraction the operation which
used to attach the node to its parent

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 lib/prio_tree.c |   47 ++++++++++++++++++++++-------------------------
 1 files changed, 22 insertions(+), 25 deletions(-)

diff --git a/lib/prio_tree.c b/lib/prio_tree.c
index 928482b..8d443af 100644
--- a/lib/prio_tree.c
+++ b/lib/prio_tree.c
@@ -85,6 +85,17 @@ static inline unsigned long prio_tree_maxindex(unsigned int bits)
 	return index_bits_to_maxindex[bits - 1];
 }

+static void prio_set_parent(struct prio_tree_node *parent,
+			    struct prio_tree_node *child, bool left)
+{
+	if (left)
+		parent->left = child;
+	else
+		parent->right = child;
+
+	child->parent = parent;
+}
+
 /*
  * Extend a priority search tree so that it can store a node with heap_index
  * max_heap_index. In the worst case, this algorithm takes O((log n)^2).
@@ -113,15 +124,12 @@ static struct prio_tree_node *prio_tree_expand(struct prio_tree_root *root,
 		prio_tree_remove(root, root->prio_tree_node);
 		INIT_PRIO_TREE_NODE(tmp);

-		prev->left = tmp;
-		tmp->parent = prev;
+		prio_set_parent(prev, tmp, true);
 		prev = tmp;
 	}

-	if (!prio_tree_empty(root)) {
-		prev->left = root->prio_tree_node;
-		prev->left->parent = prev;
-	}
+	if (!prio_tree_empty(root))
+		prio_set_parent(prev, root->prio_tree_node, true);

 	root->prio_tree_node = node;
 	return node;
@@ -142,23 +150,14 @@ struct prio_tree_node *prio_tree_replace(struct prio_tree_root *root,
 		 * and does not help much to improve performance (IMO).
 		 */
 		root->prio_tree_node = node;
-	} else {
-		node->parent = old->parent;
-		if (old->parent->left == old)
-			old->parent->left = node;
-		else
-			old->parent->right = node;
-	}
+	} else
+		prio_set_parent(old->parent, node, old->parent->left == old);

-	if (!prio_tree_left_empty(old)) {
-		node->left = old->left;
-		old->left->parent = node;
-	}
+	if (!prio_tree_left_empty(old))
+		prio_set_parent(node, old->left, true);

-	if (!prio_tree_right_empty(old)) {
-		node->right = old->right;
-		old->right->parent = node;
-	}
+	if (!prio_tree_right_empty(old))
+		prio_set_parent(node, old->right, false);

 	return old;
 }
@@ -218,16 +217,14 @@ struct prio_tree_node *prio_tree_insert(struct prio_tree_root *root,
 		if (index & mask) {
 			if (prio_tree_right_empty(cur)) {
 				INIT_PRIO_TREE_NODE(node);
-				cur->right = node;
-				node->parent = cur;
+				prio_set_parent(cur, node, false);
 				return res;
 			} else
 				cur = cur->right;
 		} else {
 			if (prio_tree_left_empty(cur)) {
 				INIT_PRIO_TREE_NODE(node);
-				cur->left = node;
-				node->parent = cur;
+				prio_set_parent(cur, node, true);
 				return res;
 			} else
 				cur = cur->left;
-- 
1.7.7.6

