Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713Ab2FWECZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 00:02:25 -0400
Received: from nm30-vm0.access.bullet.mail.mud.yahoo.com ([66.94.237.86]:41322
	"HELO nm30-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751527Ab2FWEBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 00:01:47 -0400
X-Yahoo-Newman-Id: 201962.55476.bm@smtp103.sbc.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: mTk57ikVM1k2cvDKA_DCgqer5.zSZ2zUgVZXoq4IWLrHX3d
 WlpjbD4AePrxOwCP04lIQPFfk.HchUQOhQJ1DB2deMveGHZAk3Yd9rC0QQnR
 v3X71iCteCJHEMpJaI1yr75BKHctJIiq2aZdqPbyAMrqee53dEfbttThrSt8
 ktCTaMFQQdiyfwTum8ge0kpoaNAvPB9rWK64C7zpu_x2Cwf_W.8.DXhxc8Hi
 K9N64JnHf8k3ur.baME7cWCoiKIO0vadFHR_MLsVvhVvTNyFdSoKRuirrwia
 rG1MUpoO7YtdJLJ.ZPzRissPnr38bwtwfUGYr_HY1Dk9eyybeO70Nfil.IMU
 6jC1unyk2g26_JYhgE63nAtC_4tMSNfjZ_BJHO4x.TPe7mnExjzrJFX7_HoS
 qOSIwX2x6KzbXobuA57Nrw3iJKws5qrSsNGYybw--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
From: Daniel Santos <daniel.santos@pobox.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Christopher Li <sparse@chrisli.org>,
        Daniel Santos <daniel.santos@pobox.com>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Ingo Molnar <mingo@kernel.org>, Joe Perches <joe@perches.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-doc@vger.kernel.org, linux-sparse@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Paul Turner <pjt@google.com>, Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Richard Weinberger <richard@nod.at>, Rob Landley <rob@landley.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH v4 11/13] rbtree.h: Generic Red-Black Trees
Date: Fri, 22 Jun 2012 23:00:46 -0500
Message-Id: <1340424048-7759-12-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1340424048-7759-1-git-send-email-daniel.santos@pobox.com>
References: <1340424048-7759-1-git-send-email-daniel.santos@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add generic red-black tree code to rbtree.h

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
---
 include/linux/rbtree.h | 1044 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 1042 insertions(+), 2 deletions(-)

diff --git a/include/linux/rbtree.h b/include/linux/rbtree.h
index 033b507..959bd27 100644
--- a/include/linux/rbtree.h
+++ b/include/linux/rbtree.h
@@ -1,7 +1,8 @@
 /*
   Red Black Trees
   (C) 1999  Andrea Arcangeli <andrea@suse.de>
-
+  (C) 2012  Daniel Santos <daniel.santos@pobox.com>
+
   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
@@ -96,6 +97,8 @@ static inline struct page * rb_insert_page_cache(struct inode * inode,

 #include <linux/kernel.h>
 #include <linux/stddef.h>
+#include <linux/typecheck.h>
+#include <linux/bug.h>

 struct rb_node
 {
@@ -148,6 +151,7 @@ extern void rb_insert_color(struct rb_node *, struct rb_root *);
 extern void rb_erase(struct rb_node *, struct rb_root *);

 typedef void (*rb_augment_f)(struct rb_node *node, void *data);
+typedef long (*rb_compare_f)(const void *a, const void *b);

 extern void rb_augment_insert(struct rb_node *node,
 			      rb_augment_f func, void *data);
@@ -162,7 +166,7 @@ extern struct rb_node *rb_first(const struct rb_root *);
 extern struct rb_node *rb_last(const struct rb_root *);

 /* Fast replacement of a single node without remove/rebalance/add/rebalance */
-extern void rb_replace_node(struct rb_node *victim, struct rb_node *new,
+extern void rb_replace_node(struct rb_node *victim, struct rb_node *new,
 			    struct rb_root *root);

 static inline void rb_link_node(struct rb_node * node, struct rb_node * parent,
@@ -174,4 +178,1040 @@ static inline void rb_link_node(struct rb_node * node, struct rb_node * parent,
 	*rb_link = node;
 }

+
+#define __JUNK junk,
+#define _iff_empty(test_or_junk, t, f) __iff_empty(test_or_junk, t, f)
+#define __iff_empty(__ignored1, __ignored2, result, ...) result
+
+/**
+ * IFF_EMPTY() - Expands to the second argument when the first is empty, the
+ *               third if non-empty.
+ * @test:        An argument to test for emptiness.
+ * @t:           A value to expand to if test is empty.
+ * @f:           A value to expand to if test is non-empty.
+ *
+ * Caveats:
+ * IFF_EMPTY isn't perfect.  The test parmater must either be empty or a valid
+ * pre-processor token as well as result in a valid token when pasted to the
+ * end of a word.
+ *
+ * Valid Examples:
+ * IFF_EMPTY(a, b, c) = c
+ * IFF_EMPTY( , b, c) = b
+ * IFF_EMPTY( ,  , c) = (nothing)
+ *
+ * Invalid Examples:
+ * IFF_EMPTY(.,  b, c)
+ * IFF_EMPTY(+,  b, c)
+ */
+#define IFF_EMPTY(test, t, f) _iff_empty(__JUNK##test, t, f)
+
+/**
+ * IS_EMPTY() - test if a pre-processor argument is empty.
+ * @arg:        An argument (empty or non-empty)
+ *
+ * If empty, expands to 1, 0 otherwise.  See IFF_EMPTY() for caveats &
+ * limitations.
+ */
+#define IS_EMPTY(arg)	IFF_EMPTY(arg, 1, 0)
+
+/**
+ * OPT_OFFSETOF() - return the offsetof for the supplied expression, or zero
+ *                  if m is an empty argument.
+ * @type:           struct/union type
+ * @m:              (optional) struct member name
+ *
+ * Since any offsetof can return zero if the specified member is the first in
+ * the struct/union, you should also check if the argument is empty separately
+ * with IS_EMPTY(m).
+ */
+#define OPT_OFFSETOF(type, member) IFF_EMPTY(member, 0, offsetof(type, member))
+
+enum rb_flags {
+RB_HAS_LEFTMOST	   = 0x00000001, /* The container has a struct rb_node *leftmost
+				    member that will receive a pointer to the
+				    leftmost (smallest) object in the tree that
+				    is updated during inserts & deletions */
+RB_HAS_RIGHTMOST   = 0x00000002, /* same as above (for right side of tree) */
+RB_HAS_COUNT	   = 0x00000004, /* The container has an unsigned long integer
+				    field that will receive updates of the
+				    object count in the tree. */
+RB_UNIQUE_KEYS	   = 0x00000008, /* the tree contains only unique values. */
+RB_INSERT_REPLACES = 0x00000010, /* when set, the rb_insert() will replace a
+				    value if it matches the supplied one (valid
+				    only when RB_UNIQUE_KEYS is set). */
+RB_IS_AUGMENTED	   = 0x00000020, /* is an augmented tree */
+RB_CRITICAL_PATH   = 0x00000040, /* generate larger code for {find,insert}_near
+				    functions that can be faster on some CPUs
+				    with large L1 caches (but slower on a
+				    Phenom 9850). This may be a complete flop
+				    and just need to be removed. */
+RB_ALL_FLAGS	   = RB_HAS_LEFTMOST | RB_HAS_RIGHTMOST
+		   | RB_HAS_COUNT | RB_UNIQUE_KEYS
+		   | RB_INSERT_REPLACES | RB_IS_AUGMENTED
+		   | RB_CRITICAL_PATH,
+};
+
+/**
+ * struct rb_relationship - Defines relationship between a container and
+ *                          the objects it contains.
+ * @root_offset:  Offset of container's struct rb_root member.
+ * @left_offset:  (Used only if has_left.) Offset of the container's struct
+ *                rb_node *leftmost member for storing a pointer to the
+ *                leftmost node in the tree, which is kept updated as inserts
+ *                and deletions are made.
+ * @right_offset: Same as left_offset, except for right side of tree.
+ * @count_offset:
+ * @node_offset:  Offset of object's struct rb_node member.
+ * @key_offset:   Offset of object's key member.
+ * @flags:        TODO
+ * @compare:      Pointer to key rb_compare_f function to compare keys.
+ *                Although it will be cast to and called as type long (*)(const
+ *                void *a, const void *b), you should delcare it as accepting
+ *                pointers to your key members, or sanity checks will fail.
+ *                Further, it is optimial if the function is declared inline.
+ * @augment:      Pointer to the rb_augment_f or zero if tree is not augmented.
+ *
+ * Instances of struct rb_relationship should be compile-time constants (or
+ * rather, the value of its members).
+ */
+struct rb_relationship {
+	ssize_t root_offset;
+	ssize_t left_offset;
+	ssize_t right_offset;
+	ssize_t count_offset;
+	ssize_t node_offset;
+	ssize_t key_offset;
+	int flags;
+	const rb_compare_f compare;
+	const rb_augment_f augment;
+};
+
+#define __RB_PTR(type, ptr, offset) ((type *)((char *)(ptr) + (offset)))
+
+/* public conversion functions for use with run-time values */
+static __always_inline
+struct rb_root *rb_to_root(const void *ptr,
+			   const struct rb_relationship *rel)
+{
+	return __RB_PTR(struct rb_root, ptr, rel->root_offset);
+}
+
+static __always_inline
+struct rb_node **rb_root_to_left(struct rb_root *root,
+				 const struct rb_relationship *rel)
+{
+	return __RB_PTR(struct rb_node *, root,
+			rel->left_offset - rel->root_offset);
+}
+
+static __always_inline
+struct rb_node **rb_root_to_right(struct rb_root *root,
+				  const struct rb_relationship *rel)
+{
+	return __RB_PTR(struct rb_node *, root,
+			rel->right_offset - rel->root_offset);
+}
+
+static __always_inline
+unsigned long *rb_root_to_count(struct rb_root *root,
+			       const struct rb_relationship *rel)
+{
+	return __RB_PTR(unsigned long, root,
+			rel->count_offset - rel->root_offset);
+}
+
+static __always_inline
+const void *rb_node_to_key(const struct rb_node *node,
+			   const struct rb_relationship *rel)
+{
+	return __RB_PTR(const void, node,
+			rel->key_offset - rel->node_offset);
+}
+
+static __always_inline
+void *rb_node_to_obj(const struct rb_node *node,
+		     const struct rb_relationship *rel)
+{
+	return __RB_PTR(void, node, -rel->node_offset);
+}
+
+static __always_inline
+struct rb_node *rb_to_node(const void *ptr, const struct rb_relationship *rel)
+{
+	return __RB_PTR(struct rb_node, ptr, rel->node_offset);
+}
+
+static __always_inline
+const void *rb_to_key(const void *ptr, const struct rb_relationship *rel)
+{
+	return __RB_PTR(const void, ptr, rel->key_offset);
+}
+
+
+/* checked conversion functions that will error on run-time values */
+static __always_inline
+struct rb_root *__rb_to_root(const void *ptr,
+			     const struct rb_relationship *rel)
+{
+	BUILD_BUG_ON_NON_CONST42(rel->root_offset);
+	return rb_to_root(ptr, rel);
+}
+
+static __always_inline
+struct rb_node **__rb_root_to_left(struct rb_root *root,
+				   const struct rb_relationship *rel)
+{
+	BUILD_BUG_ON42(!(rel->flags & RB_HAS_LEFTMOST));
+	BUILD_BUG_ON_NON_CONST42(rel->root_offset);
+	BUILD_BUG_ON_NON_CONST42(rel->left_offset);
+	return rb_root_to_left(root, rel);
+}
+
+static __always_inline
+struct rb_node **__rb_root_to_right(struct rb_root *root,
+				    const struct rb_relationship *rel)
+{
+	BUILD_BUG_ON42(!(rel->flags & RB_HAS_RIGHTMOST));
+	BUILD_BUG_ON_NON_CONST42(rel->root_offset);
+	BUILD_BUG_ON_NON_CONST42(rel->right_offset);
+	return rb_root_to_right(root, rel);
+}
+
+static __always_inline
+unsigned long *__rb_root_to_count(struct rb_root *root,
+				  const struct rb_relationship *rel)
+{
+	BUILD_BUG_ON42(!(rel->flags & RB_HAS_COUNT));
+	BUILD_BUG_ON_NON_CONST42(rel->root_offset);
+	BUILD_BUG_ON_NON_CONST42(rel->count_offset);
+	return rb_root_to_count(root, rel);
+}
+
+static __always_inline
+const void *__rb_node_to_key(const struct rb_node *node,
+			     const struct rb_relationship *rel)
+{
+	BUILD_BUG_ON_NON_CONST42(rel->node_offset);
+	BUILD_BUG_ON_NON_CONST42(rel->key_offset);
+	return rb_node_to_key(node, rel);
+}
+
+static __always_inline
+void *__rb_node_to_obj(const struct rb_node *node,
+		       const struct rb_relationship *rel)
+{
+	BUILD_BUG_ON_NON_CONST42(rel->node_offset);
+	return rb_node_to_obj(node, rel);
+}
+
+static __always_inline
+struct rb_node *__rb_to_node(const void *ptr, const struct rb_relationship *rel)
+{
+	BUILD_BUG_ON_NON_CONST42(rel->node_offset);
+	return rb_to_node(ptr, rel);
+}
+
+static __always_inline
+const void *__rb_to_key(const void *ptr, const struct rb_relationship *rel)
+{
+	BUILD_BUG_ON_NON_CONST42(rel->key_offset);
+	return rb_to_key(ptr, rel);
+}
+
+/** __rb_assert_good_rel -- perform compile-time sanity checks on a struct
+ *                          rb_relationship
+ * rel: Pointer to a const struct rb_relationship to check
+ */
+static __always_inline
+void __rb_assert_good_rel(const struct rb_relationship *rel)
+{
+	BUILD_BUG_ON_NON_CONST42(rel->flags);
+	BUILD_BUG_ON42(rel->flags & ~RB_ALL_FLAGS);
+
+	BUILD_BUG_ON_NON_CONST42(rel->root_offset);
+	BUILD_BUG_ON_NON_CONST42(rel->node_offset);
+	BUILD_BUG_ON_NON_CONST42(rel->key_offset);
+
+	if (rel->flags & RB_HAS_LEFTMOST)
+		BUILD_BUG_ON_NON_CONST42(rel->count_offset);
+
+	if (rel->flags & RB_HAS_RIGHTMOST)
+		BUILD_BUG_ON_NON_CONST42(rel->right_offset);
+
+	if (rel->flags & RB_HAS_COUNT)
+		BUILD_BUG_ON_NON_CONST42(rel->left_offset);
+
+	/* need if () construct to avoid false-positive prior to gcc 4.6 */
+	if (rel->flags & RB_INSERT_REPLACES)
+		BUILD_BUG_ON42(!(rel->flags & RB_UNIQUE_KEYS));
+}
+
+
+/** __rb_find - Perform a (normal) search of rbtree starting at the specified
+ *              node, traversing downward.
+ * node:        Node (root or subtree) to start the search from
+ * key:         Pointer to a key to search for
+ * rel:         Pointer to a const struct rb_relationship
+ */
+static __always_inline __flatten
+struct rb_node *__rb_find(
+		struct rb_node *node,
+		const void *key,
+		const struct rb_relationship *rel)
+{
+	__rb_assert_good_rel(rel);
+	while (node) {
+		long diff = rel->compare(key, __rb_node_to_key(node, rel));
+
+		if (diff > 0)
+			node = node->rb_right;
+		else if (diff < 0)
+			node = node->rb_left;
+		else
+			return node;
+	}
+
+	return 0;
+}
+
+/** rb_find - Perform a (normal) search of a Red-Black Tree.
+ * root:      Root of the tree
+ * key:       Pointer to a key to search for
+ * rel:       Pointer to a const struct rb_relationship
+ */
+static __always_inline __flatten
+struct rb_node *rb_find(
+		struct rb_root *root,
+		const void *key,
+		const struct rb_relationship *rel)
+{
+	return __rb_find(root->rb_node, key, rel);
+}
+
+static __always_inline __flatten
+struct rb_node *__rb_find_first_last(
+		struct rb_node *node,
+		const void *key,
+		const struct rb_relationship *rel,
+		const int find_first)
+{
+	__rb_assert_good_rel(rel);
+
+	/* calling this function with a unique key tree maps to normal find */
+	if (rel->flags & RB_UNIQUE_KEYS)
+		return __rb_find(node, key, rel);
+
+	/* if this section is compiled, we should non-unqiue only */
+	BUILD_BUG_ON42(rel->flags & RB_UNIQUE_KEYS);
+	BUILD_BUG_ON_NON_CONST(find_first);
+
+	while (node) {
+		long diff = rel->compare(key, __rb_node_to_key(node, rel));
+
+		if (diff > 0)
+			node = node->rb_right;
+		else if (diff < 0)
+			node = node->rb_left;
+		else {
+			if (find_first && node->rb_left)
+				node = node->rb_left;
+			else if (!find_first && node->rb_right)
+				node = node->rb_right;
+			else
+				return node;
+		}
+	}
+
+	return 0;
+}
+
+/** rb_find_first - Search for first occurrence of key in the tree.
+ * root:      Root of the tree
+ * key:       Pointer to a key
+ * rel:       Pointer to a const struct rb_relationship
+ *
+ * This function is intended for use with trees containing non-unique keys.
+ * When called for trees with unique keys, it maps to __rb_find (a normal
+ * search).
+ */
+static __always_inline __flatten
+struct rb_node *rb_find_first(
+		struct rb_root *root,
+		const void *key,
+		const struct rb_relationship *rel)
+{
+	return __rb_find_first_last(root->rb_node, key, rel, 1);
+}
+
+/** rb_find_last - Search for last occurrence of key in the tree.
+ * root:      Root of the tree
+ * key:       Pointer to a key
+ * rel:       Pointer to a const struct rb_relationship
+ *
+ * This function is intended for use with trees containing non-unique keys.
+ * When called for trees with unique keys, it maps to __rb_find (a normal
+ * search).
+ */
+static __always_inline __flatten
+struct rb_node *rb_find_last(
+		struct rb_root *root,
+		const void *key,
+		const struct rb_relationship *rel)
+{
+	return __rb_find_first_last(root->rb_node, key, rel, 0);
+}
+
+/** rb_find_next - Locate the next node (in a non-unique tree) whos key matches
+ *                 the supplied node.
+ * node:           Node of the current object in the tree.
+ * rel:            Pointer to a const struct rb_relationship
+ *
+ * Gernerally for use after calling rb_find_first().  Only valid for use with a
+ * tree with non-unique keys.
+ */
+static __always_inline __flatten
+struct rb_node *rb_find_next(
+		const struct rb_node *node,
+		const struct rb_relationship *rel)
+{
+	const void *key      = __rb_node_to_key(node, rel);
+	struct rb_node *next = rb_next(node);
+
+	BUILD_BUG_ON42(rel->flags & RB_UNIQUE_KEYS);
+	return (next && !rel->compare(key, __rb_node_to_key(next, rel)))
+	       ? next : NULL;
+}
+
+/** rb_find_prev - Locate the previous node (in a non-unique tree) whos key
+ *                 matches the supplied node.
+ * node:           Node of the current object in the tree.
+ * rel:            Pointer to a const struct rb_relationship
+ *
+ * Gernerally for use after calling rb_find_last().  Only valid for use with a
+ * tree with non-unique keys.
+ */
+static __always_inline __flatten
+struct rb_node *rb_find_prev(
+		const struct rb_node *node,
+		const struct rb_relationship *rel)
+{
+	const void *key      = __rb_node_to_key(node, rel);
+	struct rb_node *prev = rb_prev(node);
+
+	BUILD_BUG_ON42(rel->flags & RB_UNIQUE_KEYS);
+	return (prev && !rel->compare(key, __rb_node_to_key(prev, rel)))
+	       ? prev : NULL;
+}
+
+
+enum rb_find_subtree_match {
+	RB_MATCH_NONE		= 0,
+	RB_MATCH_IMMEDIATE	= 2,
+	RB_MATCH_LEFT		= -1,
+	RB_MATCH_RIGHT		= 1,
+};
+
+/**
+ * __rb_find_subtree - Locate the subtree that contains the specified key (if
+ *		       it exists) starting from a specific node traversing
+ *		       upwards.
+ *
+ * This function is used by find_near and insert_near, but behaves differently
+ * for each case (maybe it could have been made separate functions).
+ * Specifically, when doing_insert is non-zero, it will set values in the
+ * location provided by populate ret_link & ret_parent.
+ *
+ */
+static __always_inline __flatten
+struct rb_node *__rb_find_subtree(
+		struct rb_root *root,
+		struct rb_node *start,
+		const void *key,
+		int *matched,
+		struct rb_node ***ret_link, /* wow, tripple indirection.
+					       Am I smart or just nuts? */
+		struct rb_node **ret_parent,
+		const struct rb_relationship *rel,
+		const int doing_insert)
+{
+	struct rb_node *prev = start;
+	struct rb_node *node = rb_parent(start);
+	long diff;
+
+	__rb_assert_good_rel(rel);
+	BUILD_BUG_ON_NON_CONST(doing_insert);
+	BUG_ON(doing_insert && (!root || !ret_link || !ret_parent));
+
+	/* already at top of tree, so return start value */
+	if (!node) {
+		*matched = RB_MATCH_NONE;
+		if (doing_insert) {
+			*ret_link = &root->rb_node;
+			*ret_parent = **ret_link;
+		}
+		return start;
+	}
+
+	/* The first compare is just to figure out which direction up the tree
+	 * we're traveling.  When compare returns a value with a different
+	 * sign, we'll have found our subtree, or an exact match if zero.
+	 */
+	diff = rel->compare(key, __rb_node_to_key(node, rel));
+
+	if (diff) {
+		int go_left = diff < 0;
+		while (1) {
+			prev = node;
+			node = rb_parent(prev);
+			if (!node)
+				/* Reached top of tree.  In this case. rather
+				 * than having the top down search start from
+				 * the root, we'll start on the prev sibling
+				 * since we've already tested the root node, we
+				 * know that we don't need to go back the way
+				 * we came.
+				 */
+				break;
+
+			diff = rel->compare(key, __rb_node_to_key(node, rel));
+			if (go_left ? diff > 0 : diff < 0)
+				/* found the divering node, so the child on the
+				 * opposite side (of prev) is the subtree that
+				 * will contain the key
+				 */
+				break;
+			else if (!diff) {
+				/* exact match */
+				*matched = go_left
+					 ? RB_MATCH_LEFT
+					 : RB_MATCH_RIGHT;
+
+				goto find_parent_link;
+			}
+		}
+
+		*matched = RB_MATCH_NONE;
+		if (doing_insert) {
+			*ret_parent = prev;
+			*ret_link = go_left ? &prev->rb_left : &prev->rb_right;
+			return **ret_link;
+		} else {
+			return go_left ? prev->rb_left : prev->rb_right;
+		}
+	}
+
+	/* start node's parent was an exact match */
+	*matched = RB_MATCH_IMMEDIATE;
+
+find_parent_link:
+	if (doing_insert) {
+		struct rb_node *parent = rb_parent(node);
+
+		if (!parent) {
+			*ret_link = &root->rb_node;
+			*ret_parent = **ret_link;
+		} else if (parent->rb_left == node) {
+			*ret_link = &parent->rb_left;
+			*ret_parent = parent;
+		} else if (parent->rb_right == node) {
+			*ret_link = &parent->rb_left;
+			*ret_parent = parent;
+		} else {
+			BUG();
+		}
+	}
+
+	return node;
+}
+
+static __always_inline __flatten
+struct rb_node *rb_find_near(
+		struct rb_node *from,
+		const void *key,
+		const struct rb_relationship *rel)
+{
+	int matched;
+	struct rb_node *subtree;
+
+	subtree = __rb_find_subtree(NULL, from, key, &matched, NULL, NULL,
+				    rel, 0);
+
+	if (matched)
+		return subtree;
+
+	return __rb_find(subtree, key, rel);
+}
+
+/* common insert epilogue used by rb_insert() and rb_insert_near() */
+static __always_inline __flatten
+struct rb_node *__rb_insert_epilogue(
+		struct rb_root *root,
+		struct rb_node *parent,
+		struct rb_node *node,
+		struct rb_node *found,
+		struct rb_node **rb_link,
+		const struct rb_relationship *rel)
+{
+	if ((rel->flags & RB_UNIQUE_KEYS) && found) {
+		if (rel->flags & RB_INSERT_REPLACES) {
+			/* if we're replacing the entry, we don't incrment
+			 * count, but we do still need to do augment
+			 */
+			rb_replace_node(found, node, root);
+			goto do_augment;
+		} else {
+			/* otherwise, we don't do either */
+			goto done;
+		}
+	} else {
+		rb_link_node(node, parent, rb_link);
+		rb_insert_color(node, root);
+	}
+
+	if ((rel->flags & RB_HAS_COUNT))
+		++*__rb_root_to_count(root, rel);
+
+do_augment:
+	if (rel->augment)
+		rb_augment_insert(node, rel->augment, NULL);
+
+done:
+	return found;
+}
+
+
+/**
+ * rb_insert() - Inserts an object into a container.
+ * @root:	Pointer to struct rb_root.
+ * @node:	Pointer to the node of the new object to insert.
+ * @rel:	Pointer to the compile-time constant relationship definition.
+ * @compare:	Compare function
+ * @augmented:	Augmented function (if using an augmented rbtree)
+ *
+ * If an object with the same key already exists and RB_INSERT_REPLACES is set
+ * then it is replaced with new object node; if RB_INSERT_REPLACES is not set,
+ * then no change is made. In either case, a pointer to the existing object
+ * node is returned.
+ *
+ * If no object with the same key exists, then the new object node is inserted
+ * and NULL is returned.
+ */
+static __always_inline __flatten
+struct rb_node *rb_insert(
+		struct rb_root *root,
+		struct rb_node *node,
+		const struct rb_relationship *rel)
+{
+	struct rb_node **p     = &root->rb_node;
+	struct rb_node *parent = NULL;
+	const void *key        = __rb_node_to_key(node, rel);
+	int leftmost           = 1;
+	int rightmost          = 1;
+
+	__rb_assert_good_rel(rel);
+
+	while (*p) {
+		long diff = rel->compare(key, __rb_node_to_key(*p, rel));
+		parent    = *p;
+
+		if (diff > 0) {
+			p = &(*p)->rb_right;
+			if (rel->flags & RB_HAS_LEFTMOST)
+				leftmost = 0;
+		} else if (!(rel->flags & RB_UNIQUE_KEYS) || diff < 0) {
+			p = &(*p)->rb_left;
+			if (rel->flags & RB_HAS_RIGHTMOST)
+				rightmost = 0;
+		} else
+			break;
+	}
+
+	if ((rel->flags & RB_HAS_LEFTMOST) && leftmost) {
+		struct rb_node **left = __rb_root_to_left(root, rel);
+
+		if (!(rel->flags & RB_INSERT_REPLACES) || !(*p) || *left == *p)
+			*left = node;
+	}
+	if ((rel->flags & RB_HAS_RIGHTMOST) && rightmost) {
+		struct rb_node **right = __rb_root_to_right(root, rel);
+
+		if (!(rel->flags & RB_INSERT_REPLACES) || !(*p) || *right == *p)
+			*right = node;
+	}
+
+	return __rb_insert_epilogue(root, parent, node, *p, p, rel);
+}
+
+static __always_inline __flatten
+struct rb_node *rb_insert_near(
+		struct rb_root *root,
+		struct rb_node *start,
+		struct rb_node *node,
+		const struct rb_relationship *rel)
+{
+	const void *key = __rb_node_to_key(node, rel);
+	struct rb_node **p;
+	struct rb_node *parent;
+	struct rb_node *ret;
+	int matched;
+	long diff;
+
+	BUILD_BUG_ON_NON_CONST42(rel->flags);
+
+	ret = __rb_find_subtree(root, start, key, &matched, &p, &parent, rel,
+				1);
+
+	if (!matched) {
+		while (*p) {
+			diff   = rel->compare(__rb_node_to_key(*p, rel), key);
+			parent = *p;
+
+			if (diff > 0)
+				p = &(*p)->rb_right;
+			else if (!(rel->flags & RB_UNIQUE_KEYS) || diff < 0)
+				p = &(*p)->rb_left;
+			else
+				break;
+		}
+		ret = *p;
+	}
+
+	/* the longer way to see if we're left- or right-most (since we aren't
+	 * starting from the top, we can't use the mechanism rb_insert()
+	 * does.)
+	 */
+	if (rel->flags & RB_HAS_LEFTMOST) {
+		struct rb_node **left = __rb_root_to_left(root, rel);
+		if (!*left || *left == ret ||
+				(*left == parent && &parent->rb_left == p))
+			*left = node;
+	}
+
+	if (rel->flags & RB_HAS_RIGHTMOST) {
+		struct rb_node **right = __rb_root_to_right(root, rel);
+		if (!*right || *right == ret ||
+				(*right == parent && &parent->rb_right == p))
+			*right = node;
+	}
+
+	return __rb_insert_epilogue(root, parent, node, ret, p, rel);
+}
+
+static __always_inline __flatten
+void rb_remove(
+	struct rb_root *root,
+	struct rb_node *node,
+	const struct rb_relationship *rel)
+{
+	struct rb_node *uninitialized_var(deepest);
+
+	BUILD_BUG_ON_NON_CONST42(rel->flags);
+
+	if (rel->augment)
+		deepest = rb_augment_erase_begin(node);
+
+	if (rel->flags & RB_HAS_LEFTMOST) {
+		struct rb_node **left = __rb_root_to_left(root, rel);
+
+		if (*left == node)
+			*left = rb_next(node);
+	}
+
+	if (rel->flags & RB_HAS_RIGHTMOST) {
+		struct rb_node **right = __rb_root_to_right(root, rel);
+
+		if (*right == node)
+			*right = rb_prev(node);
+	}
+
+	rb_erase(node, root);
+
+	if ((rel->flags & RB_HAS_COUNT))
+		--*__rb_root_to_count(root, rel);
+
+	if (rel->augment)
+		rb_augment_erase_end(deepest, rel->augment, NULL);
+}
+
+
+/**
+ * RB_RELATIONHIP - Define the relationship bewteen a container with a
+ *                  struct rb_root member, and the objects it contains.
+ * @cont_type: container type
+ * @root:      Container's struct rb_root member name
+ * @left:      (Optional) If the container needs a pointer to the tree's
+ *             leftmost (smallest) object, then specify the container's struct
+ *             rb_node *leftmost member.  Otherwise, leave this parameter
+ *             empty.
+ * @right:     (Optional) Same as left, but for the rightmost (largest)
+ * @count      (Optional) Name of container's unsigned int member that will be
+ *             updated with the number of objects in the tree.  It is assumed
+ *             that there will never be more than 2^32 objects in a kernel
+ *             rbtree, so overlfow is not handled or checked for. Note that if
+ *             you add or remove objects from the tree without using the
+ *             generic functions, you must update this value yourself.
+ * @obj_type:  Type of object stored in container
+ * @node:      The struct rb_node memeber of the object
+ * @key:       The key member of the object
+ * @flags      see enum rb_flags.  Note: you do not have to specify
+ *             RB_HAS_LEFTMOST, RB_HAS_RIGHTMOST, RB_HAS_COUNT or
+ *             RB_IS_AUGMENTED as these will be added automatically if their
+ *             respective field is non-empty.
+ * @compare:   Pointer to key rb_compare_f function to compare keys.
+ *             Although it will be cast to and called as type long (*)(const
+ *             void *a, const void *b), you should delcare it as accepting
+ *             pointers to your key members, or sanity checks will fail.
+ *             Further, it is optimial if the function is declared inline.
+ * @_augment:  (optional) pointer to the rb_augment_f or empty if tree is not
+ *             augmented.
+ *
+ * Example:
+ * struct my_container {
+ *     struct rb_root root;
+ *     unsigned int count;
+ *     struct rb_node *left;
+ * };
+ *
+ * struct my_object {
+ *     struct rb_node node;
+ *     int key;
+ * };
+ *
+ * static inline long compare_int(const int *a, const int *b)
+ * {
+ *     return (long)*a - (long)*b);
+ * }
+ *
+ * static const struct rb_relationship my_rel = RB_RELATIONSHIP(
+ *     struct my_container, root, left, , count, // no rightmost
+ *     struct my_object, node, key,
+ *     0, compare_int, );                        // no augment
+ */
+#define RB_RELATIONSHIP(						\
+		cont_type, root, left, right, count,			\
+		obj_type, node, key,					\
+		_flags, _compare, _augment) {				\
+	.root_offset     = offsetof(cont_type, root),			\
+	.left_offset     = OPT_OFFSETOF(cont_type, left),		\
+	.right_offset    = OPT_OFFSETOF(cont_type, right),		\
+	.count_offset    = OPT_OFFSETOF(cont_type, count),		\
+	.node_offset     = offsetof(obj_type, node),			\
+	.key_offset      = offsetof(obj_type, key),			\
+	.flags           = (_flags)					\
+			 | IFF_EMPTY(left ,    0,  RB_HAS_LEFTMOST)	\
+			 | IFF_EMPTY(right,    0,  RB_HAS_RIGHTMOST)	\
+			 | IFF_EMPTY(count,    0,  RB_HAS_COUNT)	\
+			 | IFF_EMPTY(_augment, 0,  RB_IS_AUGMENTED),	\
+	.compare         = (const rb_compare_f) (_compare),		\
+	.augment         = IFF_EMPTY(_augment, 0, _augment)		\
+}
+
+/* type-validation functions used by __rb_sanity_check_##prefix */
+static inline void __rb_verify_root(struct rb_root *root) {}
+static inline void __rb_verify_left(struct rb_node * const *left) {}
+static inline void __rb_verify_right(struct rb_node * const *right) {}
+static inline void __rb_verify_count(const unsigned int *count) {}
+static inline void __rb_verify_node(struct rb_node *node) {}
+static inline void __rb_verify_compare_fn_ret(long *diff) {}
+
+/**
+ * RB_DEFINE_INTERFACE - Defines a complete interface for a relationship
+ *                       between container and object including a struct
+ *                       rb_relationship and an interface of type-safe wrapper
+ *                       functions.
+ * @prefix:    name for the relationship (see explanation below)
+ * @cont_type: see RB_RELATIONHIP
+ * @root:      see RB_RELATIONHIP
+ * @left:      see RB_RELATIONHIP
+ * @right:     see RB_RELATIONHIP
+ * @count      see RB_RELATIONHIP
+ * @obj_type:  see RB_RELATIONHIP
+ * @node:      see RB_RELATIONHIP
+ * @key:       see RB_RELATIONHIP
+ * @flags      see RB_RELATIONHIP
+ * @compare:   see RB_RELATIONHIP
+ * @augment:   see RB_RELATIONHIP
+ * @insert_mod:      (Optional) Function modifiers for insert function,
+ *                   defaults to "static __always_inline" if left empty.
+ * @insert_near_mod: (Optional) Same as above, for insert_near.
+ * @find_mod:        (Optional) Same as above, for find.
+ * @find_near_mod:   (Optional) Same as above, for find_near.
+ *
+ * This macro can be delcared in the global scope of either a source or header
+ * file and will generate a static const struct rb_relationship variable named
+ * prefix##_rel as well as similarly named (i.e., prefix##_##func_name)
+ * type-safe wrapper functions for find, find_near, insert, insert_near and
+ * remove.  If these function names are not sufficient, you can use the
+ * __RB_DEFINE_INTERFACE macro to specify them explicitly.
+ *
+ * The compare function will be passed pointers to the key members of two
+ * objects.  If your compare function needs access to other members of your
+ * struct (e.g., compound keys, etc.) , you can use the rb_entry macro to
+ * access other members.  However, if you use this mechanism, your find
+ * function must always pass it's key parameter as a pointer to the key member
+ * of an object of type obj_type, since the compare function is used for both
+ * inserts and lookups (else, you'll be screwed).
+ *
+ * Example:
+ * struct my_container {
+ *     struct rb_root root;
+ *     unsigned int count;
+ *     struct rb_node *left;
+ * };
+ *
+ * struct my_object {
+ *     struct rb_node node;
+ *     int key;
+ * };
+ *
+ * static inline long compare_int(const int *a, const int *b)
+ * {
+ *     return (long)*a - (long)*b);
+ * }
+ *
+ * RB_DEFINE_INTERFACE(
+ *     my_tree,
+ *     struct my_container, root, left, , count, // no rightmost
+ *     struct my_object, node, key,
+ *     0, compare_int,
+ *     ,                          // defaults for find
+ *     static __flatten,     // let gcc decide rather or not to inline insert()
+ *     ,                          // defaults on find_near
+ *     static __flatten noinline) // don't let gcc inline insert_near()
+ */
+#define RB_DEFINE_INTERFACE(						\
+	prefix,								\
+	cont_type, root, left, right, count,				\
+	obj_type, node, key,						\
+	flags, compare, augment,					\
+	find_mod, insert_mod, find_near_mod, insert_near_mod)		\
+									\
+/* You need not call this function for validation to occur.  We	define	\
+ * __rb_sanity_check function first, so errors will (hopefully) get	\
+ * caught here and produce a more helpful error message than a failure	\
+ * in the RB_RELATIONSHIP macro expansion.				\
+ */									\
+static inline __maybe_unused						\
+void __rb_sanity_check_ ## prefix(cont_type *cont, obj_type *obj)	\
+{									\
+	/* compare function should accept pointer to key member */	\
+	typeof((compare)(&obj->key, &obj->key)) diff =			\
+			(compare)(&obj->key, &obj->key);		\
+	__rb_verify_compare_fn_ret(&diff);				\
+									\
+	/* validate types of container members */			\
+	__rb_verify_root(&cont->root);					\
+	__rb_verify_left (IFF_EMPTY(left  , 0, &cont->left));		\
+	__rb_verify_right(IFF_EMPTY(right , 0, &cont->right));		\
+	__rb_verify_count(IFF_EMPTY(count , 0, &cont->count));		\
+									\
+	/* validate types of object node */				\
+	__rb_verify_node(&obj->node);					\
+}									\
+									\
+static const struct rb_relationship prefix ## _rel =			\
+RB_RELATIONSHIP(							\
+	cont_type, root, left, right, count,				\
+	obj_type, node, key,						\
+	flags, compare, augment);					\
+									\
+IFF_EMPTY(find_mod, static __always_inline, find_mod)			\
+obj_type *prefix ## _find(cont_type *cont,				\
+			  const typeof(((obj_type *)0)->key) *_key)	\
+{									\
+	struct rb_node *ret = rb_find(					\
+			&cont->root, _key, &prefix ## _rel);		\
+	return ret ? rb_entry(ret, obj_type, node) : 0;			\
+}									\
+									\
+IFF_EMPTY(insert_mod, static __always_inline, insert_mod)		\
+obj_type *prefix ## _insert(cont_type *cont, obj_type *obj)		\
+{									\
+	struct rb_node *ret = rb_insert(				\
+			&cont->root, &obj->node, &prefix ## _rel);	\
+	return ret ? rb_entry(ret, obj_type, node) : 0;			\
+}									\
+									\
+IFF_EMPTY(find_near_mod, static __always_inline, find_near_mod)		\
+obj_type *prefix ## _find_near(obj_type *near,				\
+		    const typeof(((obj_type *)0)->key) *_key)		\
+{									\
+	struct rb_node *ret = rb_find_near(				\
+			&near->node, _key, &prefix ## _rel);		\
+	return ret ? rb_entry(ret, obj_type, node) : 0;			\
+}									\
+									\
+IFF_EMPTY(insert_near_mod, static __always_inline, insert_near_mod)	\
+obj_type *prefix ## _insert_near(cont_type *cont, obj_type *near,	\
+				 obj_type *obj)				\
+{									\
+	struct rb_node *ret = rb_insert_near(				\
+			&cont->root, &near->node, &obj->node,		\
+			&prefix ## _rel);				\
+	return ret ? rb_entry(ret, obj_type, node) : 0;			\
+}									\
+									\
+static __always_inline							\
+void prefix ## _remove(cont_type *cont, obj_type *obj)			\
+{									\
+	rb_remove(&cont->root, &obj->node, &prefix ## _rel);		\
+}									\
+									\
+IFF_EMPTY(find_mod, static __always_inline, find_mod) __maybe_unused	\
+obj_type *prefix ## _find_first(cont_type *cont,			\
+			  const typeof(((obj_type *)0)->key) *_key)	\
+{									\
+	struct rb_node *ret = rb_find_first(				\
+			&cont->root, _key, &prefix ## _rel);		\
+	return ret ? rb_entry(ret, obj_type, node) : 0;			\
+}									\
+									\
+IFF_EMPTY(find_mod, static __always_inline, find_mod) __maybe_unused	\
+obj_type *prefix ## _find_last(cont_type *cont,				\
+			  const typeof(((obj_type *)0)->key) *_key)	\
+{									\
+	struct rb_node *ret = rb_find_last(				\
+			&cont->root, _key, &prefix ## _rel);		\
+	return ret ? rb_entry(ret, obj_type, node) : 0;			\
+}									\
+									\
+static __always_inline							\
+obj_type *prefix ## _find_next(const obj_type *obj)			\
+{									\
+	struct rb_node *ret = rb_find_next(&obj->node, &prefix ## _rel);\
+	return ret ? rb_entry(ret, obj_type, node) : 0;			\
+}									\
+									\
+static __always_inline							\
+obj_type *prefix ## _find_prev(const obj_type *obj)			\
+{									\
+	struct rb_node *ret = rb_find_prev(&obj->node, &prefix ## _rel);\
+	return ret ? rb_entry(ret, obj_type, node) : 0;			\
+}									\
+									\
+static __always_inline obj_type *prefix ## _next(const obj_type *obj)	\
+{									\
+	struct rb_node *ret = rb_next(&obj->node);			\
+	return ret ? rb_entry(ret, obj_type, node) : 0;			\
+}									\
+									\
+static __always_inline obj_type *prefix ## _prev(const obj_type *obj)	\
+{									\
+	struct rb_node *ret = rb_prev(&obj->node);			\
+	return ret ? rb_entry(ret, obj_type, node) : 0;			\
+}									\
+									\
+static __always_inline obj_type *prefix ## _first(cont_type *cont)	\
+{									\
+	struct rb_node *ret = rb_first(&cont->root);			\
+	return ret ? rb_entry(ret, obj_type, node) : 0;			\
+}									\
+									\
+static __always_inline obj_type *prefix ## _last(cont_type *cont)	\
+{									\
+	struct rb_node *ret = rb_last(&cont->root);			\
+	return ret ? rb_entry(ret, obj_type, node) : 0;			\
+}
+
 #endif	/* _LINUX_RBTREE_H */
--
1.7.3.4

