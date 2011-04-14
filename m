Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934018Ab1DNTXK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 15:23:10 -0400
Received: from mx2.parallels.com ([64.131.90.16]:60637 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932481Ab1DNTXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 15:23:08 -0400
Message-ID: <4DA7498C.7080006@parallels.com>
Date: Thu, 14 Apr 2011 14:22:52 -0500
From: Rob Landley <rlandley@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        Pallipadi Venkatesh <venkatesh.pallipadi@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH] Attempt to clarify "Augmented Trees" section of Documentation/rbtree.txt
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [208.54.86.198]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Landley <rlandley@parallels.com>

I had trouble understanding the new rbtree section on augmented rbtrees, so
I read up on them until I thought I had a handle on the subject, and updated
the documentation accordingly.  I also turned the pseudo-code example function
into untested but actual C, which might even be algorithmically correct.

(I'd appreciate comments from the original authors of this section, I don't
claim to be an expert on this area.  Quite the opposite, actually.)

Signed-off-by: Rob Landley <rlandley@parallels.com>
---

 Documentation/rbtree.txt |  126 ++++++++++++++++++++-----------------
 1 file changed, 71 insertions(+), 55 deletions(-)

diff --git a/Documentation/rbtree.txt b/Documentation/rbtree.txt
index 19f8278..244dd42 100644
--- a/Documentation/rbtree.txt
+++ b/Documentation/rbtree.txt
@@ -190,61 +190,77 @@ Example:
   for (node = rb_first(&mytree); node; node = rb_next(node))
 	printk("key=%s\n", rb_entry(node, struct mytype, node)->keystring);
 
-Support for Augmented rbtrees
------------------------------
+Augmented rbtrees and Interval Trees
+------------------------------------
+
+  The Linux Weekly News article on augmented rbtrees:
+    http://lwn.net/Articles/388118/
+
+Augmented rbtrees add a callback function to rb_root allowing nodes to respond
+to changes in their children, ala:
+
+    void my_augment_callback(struct rb_node *node);
+    struct rb_root my_root = RB_AUGMENT_ROOT(my_augment_callback);
+
+This function is called when either of a node's children change.  It is not
+called recursively: the callback function is responsible for traversing parent
+nodes and updating their information as necessary.
+
+The purpose of this callback is to allow nodes to maintain additional data
+about their children, which can greatly speed certain types of searches.
+
+For example, it's possible to select the Nth element in a tree (array-style
+access) in O(log n) time if each node records the total number of nodes in
+the subtree it's the root of.  (The same information can just as quickly
+find the position of a given node.)
+
+Another common use is to implement "Interval trees", which store ranges of
+low/high values, and which allow nodes with overlaping ranges in the same
+tree.
+
+Implementing an interval tree by storing nodes sorted by low value, and also
+recording the largest high value found under each node, allows an O(log n)
+lookup for lowest match (lowest start address among all possible matches)
+with the following rbtree search:
+
+  struct mytype *find_lowest_match(struct rb_root *root, int low, int high)
+  {
+  	struct rb_node *node = root->rb_node;
+  
+  	while (node) {
+    		struct mytype *data;
+  
+  		/* Does the left child have a lower overlap than this node? */
+  		data = container_of(node->rb_left, struct mytype, node);
+  		if (node->rb_left != NULL && data->highest > low) {
+  			node = node->rb_left;
+  			continue;
+  		}
 
-Augmented rbtree is an rbtree with "some" additional data stored in each node.
-This data can be used to augment some new functionality to rbtree.
-Augmented rbtree is an optional feature built on top of basic rbtree
-infrastructure. rbtree user who wants this feature will have an augment
-callback function in rb_root initialized.
-
-This callback function will be called from rbtree core routines whenever
-a node has a change in one or both of its children. It is the responsibility
-of the callback function to recalculate the additional data that is in the
-rb node using new children information. Note that if this new additional
-data affects the parent node's additional data, then callback function has
-to handle it and do the recursive updates.
-
-
-Interval tree is an example of augmented rb tree. Reference -
-"Introduction to Algorithms" by Cormen, Leiserson, Rivest and Stein.
-More details about interval trees:
-
-Classical rbtree has a single key and it cannot be directly used to store
-interval ranges like [lo:hi] and do a quick lookup for any overlap with a new
-lo:hi or to find whether there is an exact match for a new lo:hi.
-
-However, rbtree can be augmented to store such interval ranges in a structured
-way making it possible to do efficient lookup and exact match.
-
-This "extra information" stored in each node is the maximum hi
-(max_hi) value among all the nodes that are its descendents. This
-information can be maintained at each node just be looking at the node
-and its immediate children. And this will be used in O(log n) lookup
-for lowest match (lowest start address among all possible matches)
-with something like:
-
-find_lowest_match(lo, hi, node)
-{
-	lowest_match = NULL;
-	while (node) {
-		if (max_hi(node->left) > lo) {
-			// Lowest overlap if any must be on left side
-			node = node->left;
-		} else if (overlap(lo, hi, node)) {
-			lowest_match = node;
-			break;
-		} else if (lo > node->lo) {
-			// Lowest overlap if any must be on right side
-			node = node->right;
-		} else {
-			break;
+  		/* Does this node have a lower overlap than the right child? */
+  		data = container_of(node, struct mytype, node);
+  		if (low <= data->high && high >= data->low)
+  			return data;
+ 
+
+  		/* Is lowest overlap under the right child? */
+  		data = container_of(node->rb_right, struct mytype, node);
+  		if (node->rb_right != NULL && low > data->low) {
+  			node = node->rb_right
+  			continue;
 		}
-	}
-	return lowest_match;
-}
 
-Finding exact match will be to first find lowest match and then to follow
-successor nodes looking for exact match, until the start of a node is beyond
-the hi value we are looking for.
+  		/* No match in tree */
+  		return NULL;
+  	}
+  }
+			
+To find an exact match, first find the lowest match and then follow rb_next()
+nodes looking for an exact match.  Since nodes are sorted by low value, stop
+when a node's low value is greater than the low value of the search.
+
+See "Introduction to Algorithms" by Cormen, Leiserson, Rivest and Stein for
+details on interval trees, or the Wikipedia entry at:
+    http://en.wikipedia.org/wiki/Interval_tree
+
+
