Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030258Ab2I1XlY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 19:41:24 -0400
Received: from nm26.bullet.mail.bf1.yahoo.com ([98.139.212.185]:42679 "HELO
	nm26.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965102Ab2I1XlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 19:41:17 -0400
X-Yahoo-Newman-Id: 321281.10138.bm@smtp115.sbc.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: Eryy0gsVM1nM_.v13evz.da9MG7W9HWzdk9BE2zI1P5HbrD
 XMhsnAG7JKNs0qMSuyaDLLYLTzOqtroqAxeuTCz78l5eOn18NFNwEqWO1gkA
 TdF9_dq6t9tdOK3jJ_S7RaLEIcRViUhAS1qU_vf.wjuwLOIvlEM1QqYzvdDy
 HQr7b.HXM2pGTdggiNZz4YxbO5NW5SQkEuqdMQshcPVMUhnbPeHZIAyW6K88
 7Fvro__M_aOoxIcZgjJVtFoLqdAH9CkFZuuE_r.rAHG44LWEb6ym_s3df8.q
 19szsLuuawqGnUYKc.D5joUO5XKnDM3aL9UvJv7MfV8MQtKN2b32oKo7LBXK
 GcOSuY3AiIubJdjK_EhK.OXxlv3LzcbY8VQXSZRK4XjByeNn.SlOqZ9WhQqH
 LFh9Z3OQfql3trYyKSABkZ_rY7h83KZ88JEwvZ4RacoGfsoLUIgyD
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
From: Daniel Santos <daniel.santos@pobox.com>
To: LKML <linux-kernel@vger.kernel.org>, Akinobu Mita <akinobu.mita@gmail.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Santos <daniel.santos@pobox.com>,
        David Woodhouse <David.Woodhouse@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        John Stultz <john.stultz@linaro.org>, linux-doc@vger.kernel.org,
        Michel Lespinasse <walken@google.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>, Rob Landley <rob@landley.net>
Subject: [PATCH v6 4/10] rbtree.h: Add test & validation framework
Date: Fri, 28 Sep 2012 18:40:19 -0500
Message-Id: <1348875625-28669-5-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1348875625-28669-1-git-send-email-daniel.santos@pobox.com>
References: <1348875625-28669-1-git-send-email-daniel.santos@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This introduces the following .config variables:

DEBUG_GRBTREE
DEBUG_GRBTREE_VALIDATE

DEBUG_GRBTREE will enable the use of the following new flags in struct
rb_relationship's flags member. When DEBUG_GRBTREE is not enabled in the
config, these flags will evaluate to zero.

RB_VERIFY_USAGE - Perform additional checks to assure that nodes are not
inserted into more than one tree by mistake, but adds the requirement
that nodes are initialized (rb_debug_clear_node) prior to insertion.

RB_VERIFY_INTEGRITY - Perform exhaustive integrity checks on tree during
most manipulation & access functions (high run-time overhead)

Finally, the DEBUG_GRBTREE_VALIDATE .config variable will force-enable
the RB_VERIFY_INTEGRITY behavior on all trees.

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
---
 include/linux/rbtree.h |  153 ++++++++++++++++++++++++++++++++++++++++++++---
 lib/Kconfig.debug      |   22 +++++++-
 2 files changed, 164 insertions(+), 11 deletions(-)

diff --git a/include/linux/rbtree.h b/include/linux/rbtree.h
index 48e325f..5f10915 100644
--- a/include/linux/rbtree.h
+++ b/include/linux/rbtree.h
@@ -85,7 +85,6 @@ static inline void rb_link_node(struct rb_node * node, struct rb_node * parent,
 	*rb_link = node;
 }
 
-
 #define __JUNK junk,
 #define _iff_empty(test_or_junk, t, f) __iff_empty(test_or_junk, t, f)
 #define __iff_empty(__ignored1, __ignored2, result, ...) result
@@ -134,6 +133,18 @@ static inline void rb_link_node(struct rb_node * node, struct rb_node * parent,
  */
 #define OPT_OFFSETOF(type, member) IFF_EMPTY(member, 0, offsetof(type, member))
 
+
+#define GRBTREE_DEBUG IS_ENABLED(DEBUG_GRBTREE)
+#define GRBTREE_VALIDATE IS_ENABLED(DEBUG_GRBTREE_VALIDATE)
+
+/* keep disabled debug code out of older compilers that fail to optimize out
+ * const struct member values */
+#if GRBTREE_DEBUG
+# define __RB_DEBUG_ENABLE_MASK 0xffffffff
+#else
+# define __RB_DEBUG_ENABLE_MASK 0
+#endif
+
 /**
  * enum rb_flags - values for strct rb_relationship's flags
  * @RB_HAS_LEFTMOST:	The container has a struct rb_node *leftmost member
@@ -147,18 +158,47 @@ static inline void rb_link_node(struct rb_node * node, struct rb_node * parent,
  * @RB_INSERT_REPLACES:	When set, the rb_insert() will replace a value if it
  * 			matches the supplied one (valid only when
  * 			RB_UNIQUE_KEYS is set).
+ * @RB_VERIFY_USAGE:	Perform checks upon node insertion for a small run-time
+ * 			overhead. This has other usage restrictions, so read
+ * 			the Description section before using. Available only
+ * 			when CONFIG_DEBUG_GRBTREE is enabled.
+ * @RB_VERIFY_INTEGRITY:Perform exauhstive integrity checks on most operations
+ * 			(large run-time overhead). Available only when
+ * 			CONFIG_DEBUG_GRBTREE is enabled.
  * @RB_ALL_FLAGS:	(internal use)
+ *
+ *
+ * When RB_VERIFY_USAGE is set in the relationship flags and
+ * CONFIG_DEBUG_GRBTREE is enabled, you will be required to initialize nodes
+ * with rb_debug_clear_node() prior to inserting them (which is normally not
+ * necessary).  Upon insertion (rb_insert and rb_insert_near), additional
+ * checks will be performed to verify that the node is properly initialized and
+ * does not belong to another tree.  Upon removal (rb_remove) the node is
+ * re-initialized, so calling rb_debug_clear_node() is only required when you
+ * originally create the node.  If you remove it and re-add it multiple times
+ * (or to multiple trees) you do not have to manually re-initialize it.  This
+ * causes a small run-time overhead.
+ *
+ * When RB_VERIFY_INTEGRITY is set and CONFIG_DEBUG_GRBTREE is enabled,
+ * validation of tree integrity will occur in most functions.  As the tree is
+ * traversed downward, each child's parent link will be verified.  When the
+ * tree is traversed upwards (__rb_find_subtree) each parent's left or right
+ * link (respective to the traversal) will be verified.  Finally, when
+ * iterating over a tree, the compare function will be called to verify the
+ * order of elements.  This has a high run-time overhead.
  */
-
 enum rb_flags {
 	RB_HAS_LEFTMOST		= 0x00000001,
 	RB_HAS_RIGHTMOST	= 0x00000002,
 	RB_HAS_COUNT		= 0x00000004,
 	RB_UNIQUE_KEYS		= 0x00000008,
 	RB_INSERT_REPLACES	= 0x00000010,
+	RB_VERIFY_USAGE		= 0x00000080 & __RB_DEBUG_ENABLE_MASK,
+	RB_VERIFY_INTEGRITY	= 0x00000100 & __RB_DEBUG_ENABLE_MASK,
 	RB_ALL_FLAGS		= RB_HAS_LEFTMOST | RB_HAS_RIGHTMOST
 			| RB_HAS_COUNT | RB_UNIQUE_KEYS
-			| RB_INSERT_REPLACES,
+			| RB_INSERT_REPLACES
+			| RB_VERIFY_USAGE | RB_VERIFY_INTEGRITY,
 };
 
 /**
@@ -257,7 +297,6 @@ const void *rb_to_key(const void *ptr, const struct rb_relationship *rel)
 	return __RB_PTR(const void, ptr, rel->key_offset);
 }
 
-
 /* checked conversion functions that will error on run-time values */
 static __always_inline
 struct rb_root *__rb_to_root(const void *ptr,
@@ -367,6 +406,87 @@ void __rb_assert_good_rel(const struct rb_relationship *rel)
 }
 
 
+
+#if GRBTREE_DEBUG
+/* debug functions */
+
+/*
+ * __rb_verify_parent - validate a child's parent link
+ */
+static inline
+void __rb_verify_parent(const rb_node *child, const rb_node *parent,
+			const struct rb_relationship *rel)
+{
+	if ((rel->flags & RB_VERIFY_INTEGRITY) || GRBTREE_VALIDATE) {
+		BUG_ON(rb_parent(child) != parent);
+	}
+}
+
+/*
+ * __rb_verify_child - validate a parent's right or left link
+ */
+static inline
+void __rb_verify_child(const rb_node *parent, const rb_node *child,
+		       const int is_left, const struct rb_relationship *rel)
+{
+	BUILD_BUG_ON_NON_CONST(is_left);
+	if ((rel->flags & RB_VERIFY_INTEGRITY) || GRBTREE_VALIDATE) {
+		const rb_node *ptr = is_left ? parent->rb_left : parent->right;
+		BUG_ON(ptr != child);
+	}
+}
+
+/*
+ * __rb_verify_less - call compare function and verify node order
+ */
+static inline
+void __rb_verify_less(const rb_node *a, const rb_node *b,
+		      const struct rb_relationship *rel)
+{
+	if ((rel->flags & RB_VERIFY_INTEGRITY) || GRBTREE_VALIDATE) {
+		/* if we're using non-unique keys, diff can be zero */
+		const long max_diff = (rel->flags & RB_UNIQUE_KEYS) ? -1 : 0;
+		long diff = rel->compare(__rb_node_to_key(a, rel),
+					 __rb_node_to_key(a, rel))
+		BUG_ON(diff > max_diff);
+	}
+}
+
+/*
+ * __rb_verify_node_cleared - verify a node has been initialized/cleared
+ */
+static inline
+void __rb_verify_node_cleared(const rb_node *node,
+			      const struct rb_relationship *rel)
+{
+	if ((rel->flags & RB_VERIFY_USAGE) || GRBTREE_VALIDATE) {
+		BUG_ON(node->rb_parent_color != (unsigned long)node);
+		BUG_ON(node->rb_left != NULL);
+		BUG_ON(node->rb_right != NULL);
+	}
+}
+
+/**
+ * rb_debug_clear_node - clear a node (enabled when GRBTREE_DEBUG is set)
+ */
+static inline
+void rb_debug_clear_node(rb_node *node)
+{
+	node->__rb_parent_color = (unsigned long)node;
+	node->rb_left = NULL;
+	node->rb_right = NULL;
+}
+
+
+#else /* GRBTREE_DEBUG */
+# define __rb_verify_parent(child, parent, rel)		((void) 0)
+# define __rb_verify_child(parent, child, is_left, rel)	((void) 0)
+# define __rb_verify_less(a, b, rel)			((void) 0)
+# define __rb_verify_node_cleared(node, rel)		((void) 0)
+# define rb_debug_clear_node(node)			((void) 0)
+#endif /* GRBTREE_DEBUG */
+
+
 /**
  * __rb_find() - Perform a (normal) search on a Red-Black Tree, starting at the
  *		 specified node, traversing downward.
@@ -384,11 +504,13 @@ struct rb_node *__rb_find(
 	while (node) {
 		long diff = rel->compare(key, __rb_node_to_key(node, rel));
 
-		if (diff > 0)
+		if (diff > 0) {
+			__rb_verify_parent(node->rb_right, node, rel);
 			node = node->rb_right;
-		else if (diff < 0)
+		} else if (diff < 0) {
+			__rb_verify_parent(node->rb_left, node, rel);
 			node = node->rb_left;
-		else
+		} else
 			return node;
 	}
 
@@ -426,11 +548,13 @@ struct rb_node *__rb_find_first_last(
 	while (node) {
 		long diff = rel->compare(key, __rb_node_to_key(node, rel));
 
-		if (diff > 0)
+		if (diff > 0) {
+			__rb_verify_parent(node->rb_right, node, rel);
 			node = node->rb_right;
-		else if (diff < 0)
+		} else if (diff < 0) {
+			__rb_verify_parent(node->rb_left, node, rel);
 			node = node->rb_left;
-		else {
+		} else {
 			if (find_first && node->rb_left)
 				node = node->rb_left;
 			else if (!find_first && node->rb_right)
@@ -767,6 +891,7 @@ struct rb_node *rb_insert(
 #endif
 
 	__rb_assert_good_rel(rel);
+	__rb_verify_node_cleared(node, rel);
 
 
 	while (*p) {
@@ -845,6 +970,7 @@ struct rb_node *rb_insert_near(
 	long diff;
 
 	BUILD_BUG_ON_NON_CONST42(rel->flags);
+	__rb_verify_node_cleared(node, rel);
 
 	ret = __rb_find_subtree(root, start, key, &matched, &p, &parent, rel,
 				1);
@@ -917,6 +1043,11 @@ void rb_remove(
 
 	if ((rel->flags & RB_HAS_COUNT))
 		--*__rb_root_to_count(root, rel);
+
+	/* When RB_VERIFY_USAGE enabled, we re-init node upon removal */
+	if (GRBTREE_DEBUG && (rel->flags & RB_VERIFY_USAGE)) {
+		rb_debug_clear_node(node);
+	}
 }
 
 
@@ -1182,12 +1313,14 @@ obj_type *prefix ## _find_prev(const obj_type *obj)			\
 static __always_inline obj_type *prefix ## _next(const obj_type *obj)	\
 {									\
 	struct rb_node *ret = rb_next(&obj->node);			\
+	__rb_verify_less(&obj->node, ret, &prefix ## _rel);		\
 	return ret ? rb_entry(ret, obj_type, node) : 0;			\
 }									\
 									\
 static __always_inline obj_type *prefix ## _prev(const obj_type *obj)	\
 {									\
 	struct rb_node *ret = rb_prev(&obj->node);			\
+	__rb_verify_less(ret, &obj->node, &prefix ## _rel);		\
 	return ret ? rb_entry(ret, obj_type, node) : 0;			\
 }									\
 									\
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 42cd4d8..0f42fd5 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -747,7 +747,7 @@ config DEBUG_KOBJECT
 	depends on DEBUG_KERNEL
 	help
 	  If you say Y here, some extra kobject debugging messages will be sent
-	  to the syslog. 
+	  to the syslog.
 
 config DEBUG_HIGHMEM
 	bool "Highmem debugging"
@@ -868,6 +868,26 @@ config TEST_LIST_SORT
 
 	  If unsure, say N.
 
+config DEBUG_GRBTREE
+	bool "Debug generic red-black trees"
+	depends on DEBUG_KERNEL
+	help
+	  Enables debug checks to red-black trees.  Enabling this parameter
+	  causes flags RB_VERIFY_USAGE and RB_VERIFY_INTEGRITY to become
+	  useable (see rbtree.h for more details).
+
+	  If unsure, say N.
+
+config DEBUG_GRBTREE_VALIDATE
+	bool "Generic Red-black tree validation"
+	depends on DEBUG_GRBTREE
+	help
+	  Perform exahustive checks on all generic red-black tree operations.
+	  This is the same as enabling the RB_VERIFY_INTEGRITY flag for all
+	  generic red-black trees.
+
+	  If unsure, say N.
+
 config DEBUG_SG
 	bool "Debug SG table operations"
 	depends on DEBUG_KERNEL
-- 
1.7.3.4

