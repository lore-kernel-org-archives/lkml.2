Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759801Ab2BNJBj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 04:01:39 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:41401 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759739Ab2BNJBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 04:01:35 -0500
Message-ID: <4F3A22D7.1070307@linux.vnet.ibm.com>
Date: Tue, 14 Feb 2012 17:01:11 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/4] prio_tree: simplify prio_tree_expand
References: <4F3A2285.7060700@linux.vnet.ibm.com>
In-Reply-To: <4F3A2285.7060700@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12021322-1618-0000-0000-000000CC2912
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In current code, the deleted-node is recorded from first to last,
actually, we can directly attach these node on 'node' we will insert
as the left child, it can let the code more readable

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 lib/prio_tree.c |   38 ++++++++++++++------------------------
 1 files changed, 14 insertions(+), 24 deletions(-)

diff --git a/lib/prio_tree.c b/lib/prio_tree.c
index 888e8b3..928482b 100644
--- a/lib/prio_tree.c
+++ b/lib/prio_tree.c
@@ -94,43 +94,33 @@ static inline unsigned long prio_tree_maxindex(unsigned int bits)
 static struct prio_tree_node *prio_tree_expand(struct prio_tree_root *root,
 		struct prio_tree_node *node, unsigned long max_heap_index)
 {
-	struct prio_tree_node *first = NULL, *prev, *last = NULL;
+	struct prio_tree_node *prev;

 	if (max_heap_index > prio_tree_maxindex(root->index_bits))
 		root->index_bits++;

+	prev = node;
+	INIT_PRIO_TREE_NODE(node);
+
 	while (max_heap_index > prio_tree_maxindex(root->index_bits)) {
+		struct prio_tree_node *tmp = root->prio_tree_node;
+
 		root->index_bits++;

 		if (prio_tree_empty(root))
 			continue;

-		if (first == NULL) {
-			first = root->prio_tree_node;
-			prio_tree_remove(root, root->prio_tree_node);
-			INIT_PRIO_TREE_NODE(first);
-			last = first;
-		} else {
-			prev = last;
-			last = root->prio_tree_node;
-			prio_tree_remove(root, root->prio_tree_node);
-			INIT_PRIO_TREE_NODE(last);
-			prev->left = last;
-			last->parent = prev;
-		}
-	}
-
-	INIT_PRIO_TREE_NODE(node);
+		prio_tree_remove(root, root->prio_tree_node);
+		INIT_PRIO_TREE_NODE(tmp);

-	if (first) {
-		node->left = first;
-		first->parent = node;
-	} else
-		last = node;
+		prev->left = tmp;
+		tmp->parent = prev;
+		prev = tmp;
+	}

 	if (!prio_tree_empty(root)) {
-		last->left = root->prio_tree_node;
-		last->left->parent = last;
+		prev->left = root->prio_tree_node;
+		prev->left->parent = prev;
 	}

 	root->prio_tree_node = node;
-- 
1.7.7.6

