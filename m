Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759757Ab2BNJBC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 04:01:02 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:44101 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759699Ab2BNJA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 04:00:58 -0500
Message-ID: <4F3A22A9.3060901@linux.vnet.ibm.com>
Date: Tue, 14 Feb 2012 17:00:25 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/4] prio_tree: cleanup prio_tree_left/prio_tree_right
References: <4F3A2285.7060700@linux.vnet.ibm.com>
In-Reply-To: <4F3A2285.7060700@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12021322-1396-0000-0000-000000AC29F0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce iter_walk_down/iter_walk_up to remove the common code
between prio_tree_left and prio_tree_right

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 lib/prio_tree.c |   78 ++++++++++++++++++++++++++-----------------------------
 1 files changed, 37 insertions(+), 41 deletions(-)

diff --git a/lib/prio_tree.c b/lib/prio_tree.c
index 423eba8..888e8b3 100644
--- a/lib/prio_tree.c
+++ b/lib/prio_tree.c
@@ -304,6 +304,40 @@ void prio_tree_remove(struct prio_tree_root *root, struct prio_tree_node *node)
 		cur = prio_tree_replace(root, cur->parent, cur);
 }

+static void iter_walk_down(struct prio_tree_iter *iter)
+{
+	iter->mask >>= 1;
+	if (iter->mask) {
+		if (iter->size_level)
+			iter->size_level++;
+		return;
+	}
+
+	if (iter->size_level) {
+		BUG_ON(!prio_tree_left_empty(iter->cur));
+		BUG_ON(!prio_tree_right_empty(iter->cur));
+		iter->size_level++;
+		iter->mask = ULONG_MAX;
+	} else {
+		iter->size_level = 1;
+		iter->mask = 1UL << (BITS_PER_LONG - 1);
+	}
+}
+
+static void iter_walk_up(struct prio_tree_iter *iter)
+{
+	if (iter->mask == ULONG_MAX)
+		iter->mask = 1UL;
+	else if (iter->size_level == 1)
+		iter->mask = 1UL;
+	else
+		iter->mask <<= 1;
+	if (iter->size_level)
+		iter->size_level--;
+	if (!iter->size_level && (iter->value & iter->mask))
+		iter->value ^= iter->mask;
+}
+
 /*
  * Following functions help to enumerate all prio_tree_nodes in the tree that
  * overlap with the input interval X [radix_index, heap_index]. The enumeration
@@ -322,21 +356,7 @@ static struct prio_tree_node *prio_tree_left(struct prio_tree_iter *iter,

 	if (iter->r_index <= *h_index) {
 		iter->cur = iter->cur->left;
-		iter->mask >>= 1;
-		if (iter->mask) {
-			if (iter->size_level)
-				iter->size_level++;
-		} else {
-			if (iter->size_level) {
-				BUG_ON(!prio_tree_left_empty(iter->cur));
-				BUG_ON(!prio_tree_right_empty(iter->cur));
-				iter->size_level++;
-				iter->mask = ULONG_MAX;
-			} else {
-				iter->size_level = 1;
-				iter->mask = 1UL << (BITS_PER_LONG - 1);
-			}
-		}
+		iter_walk_down(iter);
 		return iter->cur;
 	}

@@ -363,22 +383,7 @@ static struct prio_tree_node *prio_tree_right(struct prio_tree_iter *iter,

 	if (iter->r_index <= *h_index) {
 		iter->cur = iter->cur->right;
-		iter->mask >>= 1;
-		iter->value = value;
-		if (iter->mask) {
-			if (iter->size_level)
-				iter->size_level++;
-		} else {
-			if (iter->size_level) {
-				BUG_ON(!prio_tree_left_empty(iter->cur));
-				BUG_ON(!prio_tree_right_empty(iter->cur));
-				iter->size_level++;
-				iter->mask = ULONG_MAX;
-			} else {
-				iter->size_level = 1;
-				iter->mask = 1UL << (BITS_PER_LONG - 1);
-			}
-		}
+		iter_walk_down(iter);
 		return iter->cur;
 	}

@@ -388,16 +393,7 @@ static struct prio_tree_node *prio_tree_right(struct prio_tree_iter *iter,
 static struct prio_tree_node *prio_tree_parent(struct prio_tree_iter *iter)
 {
 	iter->cur = iter->cur->parent;
-	if (iter->mask == ULONG_MAX)
-		iter->mask = 1UL;
-	else if (iter->size_level == 1)
-		iter->mask = 1UL;
-	else
-		iter->mask <<= 1;
-	if (iter->size_level)
-		iter->size_level--;
-	if (!iter->size_level && (iter->value & iter->mask))
-		iter->value ^= iter->mask;
+	iter_walk_up(iter);
 	return iter->cur;
 }

-- 
1.7.7.6

