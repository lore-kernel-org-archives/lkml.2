Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758653Ab2EaX0n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 19:26:43 -0400
Received: from nm3-vm0.access.bullet.mail.sp2.yahoo.com ([98.139.44.108]:45319
	"HELO nm3-vm0.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758635Ab2EaX0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 19:26:42 -0400
X-Yahoo-Newman-Id: 915006.8308.bm@omp1010.access.mail.sp2.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: tsqp8aYVM1nE1uaEaIpqolAFJinP0XtIVF2rBncTfddt9QA
 bcYTbfdgxwMOkZeLvtYgz.vPp7Mg8e2XIIe0AvtYyqAdAmG3NtpwUnSHznyO
 mFXzzF3YwDq1BVlK.232F499emMxcLJWYbKWTIIsvNOx1vqeobMohifYZRoO
 bguYWCV9xBx31yC0ROgPrwOrfewitifuuArxbyYLcj4i4q19OSC3yQCiNCRC
 dig03By8PHGEEWZwEuUHjIwPcwSgJRfta9oJWvz3avBaqXEozvRXtIg7wPT_
 iRRduFvJJqGuRh3UOcyc.4SCcuHzFdxvmf5C1LzSGiST1QjclUHqoWD2daGF
 hDMQO7ZHvVRp8o2ThYqe6baLkl.hkDi3OJIU5.V3ZBqyP6zNwv6bGIa6ZEBG
 VCIQGCA--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
Message-ID: <4FC7FE2F.6010600@att.net>
Date: Thu, 31 May 2012 18:26:39 -0500
From: Daniel Santos <danielfsantos@att.net>
Reply-To: daniel.santos@pobox.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120502 Thunderbird/10.0.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Kent Overstreet <koverstreet@google.com>, tj@kernel.org,
        Peter Zijlstra <peterz@infradead.org>, axboe@kernel.dk,
        paul.gortmaker@windriver.com, Andi Kleen <andi@firstfloor.org>,
        jack@suse.cz, Andrea Arcangeli <aarcange@redhat.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH v2 2/3] [RFC] Generic Red-Black Trees
References: <4FC7FD23.6080800@att.net>
In-Reply-To: <4FC7FD23.6080800@att.net>
X-Enigmail-Version: 1.3.5
Content-Type: multipart/mixed;
 boundary="------------080002000604090606030803"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080002000604090606030803
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit



--------------080002000604090606030803
Content-Type: text/x-patch;
 name="0007-Generic-search-insert-for-Red-Black-Trees.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0007-Generic-search-insert-for-Red-Black-Trees.patch"

>From 5d71e7b4bc2b43f40568e0493b65332218dce0ba Mon Sep 17 00:00:00 2001
From: Daniel Santos <daniel.santos@pobox.com>
Date: Thu, 31 May 2012 17:43:24 -0500
Subject: Generic search & insert for Red-Black Trees

---
 include/linux/rbtree.h |  623 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 623 insertions(+), 0 deletions(-)

diff --git a/include/linux/rbtree.h b/include/linux/rbtree.h
index 033b507..1133682 100644
--- a/include/linux/rbtree.h
+++ b/include/linux/rbtree.h
@@ -96,6 +96,8 @@ static inline struct page * rb_insert_page_cache(struct inode * inode,
 
 #include <linux/kernel.h>
 #include <linux/stddef.h>
+#include <linux/typecheck.h>
+#include <linux/bug.h>
 
 struct rb_node
 {
@@ -148,6 +150,7 @@ extern void rb_insert_color(struct rb_node *, struct rb_root *);
 extern void rb_erase(struct rb_node *, struct rb_root *);
 
 typedef void (*rb_augment_f)(struct rb_node *node, void *data);
+typedef long (*rb_compare_f)(const void *a, const void *b);
 
 extern void rb_augment_insert(struct rb_node *node,
 			      rb_augment_f func, void *data);
@@ -174,4 +177,624 @@ static inline void rb_link_node(struct rb_node * node, struct rb_node * parent,
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
+#define OPT_OFFSETOF(type, m) ((size_t) &((*((type *)0)) IFF_EMPTY(m, , .m)))
+
+
+enum rb_flags {
+	RB_HAS_LEFTMOST	   = 0x00000001,
+	RB_HAS_RIGHTMOST   = 0x00000002,
+	RB_UNIQUE_KEYS	   = 0x00000004,
+	RB_INSERT_REPLACES = 0x00000008,
+	RB_ALL_FLAGS	   = RB_HAS_LEFTMOST | RB_HAS_RIGHTMOST
+			   | RB_UNIQUE_KEYS | RB_INSERT_REPLACES,
+};
+
+/**
+ * struct rb_relationship - Defines relationship between a container and
+ *                      the objects it contains.
+ * @root_offset:        Offset of container's struct rb_root member.
+ * @left_offset:        (Used only if has_left.) Offset of the container's
+ *                      struct rb_node *leftmost member for storing a pointer
+ *                      to the leftmost node in the tree, which is kept
+ *                      updated as inserts and deletions are made.
+ * @right_offset:       Same as left_offset, except for right side of tree.
+ * @node_offset:        Offset of object's struct rb_node member.
+ * @key_offset:         Offset of object's key member.
+ * @flags:              TODO
+ *
+ * Instances of struct rb_relationship should be compile-time constants (or
+ * rather, the value of its members).
+ */
+struct rb_relationship {
+	long root_offset;
+	long left_offset;
+	long right_offset;
+	long node_offset;
+	long key_offset;
+	int flags;
+};
+
+static __always_inline
+struct rb_root *__rb_to_root(const void *ptr, const struct rb_relationship *rel)
+{
+	BUILD_BUG_ON_NON_CONST2(rel->root_offset);
+	return (struct rb_root *)((char *)ptr + rel->root_offset);
+}
+
+static __always_inline
+struct rb_node **__rb_root_to_left(void *ptr, const struct rb_relationship *rel)
+{
+	BUILD_BUG_ON(!(rel->flags & RB_HAS_LEFTMOST));
+	BUILD_BUG_ON_NON_CONST2(rel->root_offset);
+	BUILD_BUG_ON_NON_CONST2(rel->left_offset);
+	return (struct rb_node **)((char *)ptr - rel->root_offset
+					       + rel->left_offset);
+}
+
+static __always_inline
+struct rb_node **__rb_root_to_right(void *ptr, const struct rb_relationship *rel)
+{
+	BUILD_BUG_ON(!(rel->flags & RB_HAS_RIGHTMOST));
+	BUILD_BUG_ON_NON_CONST2(rel->root_offset);
+	BUILD_BUG_ON_NON_CONST2(rel->right_offset);
+	return (struct rb_node **)((char *)ptr - rel->root_offset
+					       + rel->right_offset);
+}
+
+static __always_inline
+const void *__rb_node_to_key(const void *ptr, const struct rb_relationship *rel)
+{
+	BUILD_BUG_ON_NON_CONST2(rel->node_offset);
+	BUILD_BUG_ON_NON_CONST2(rel->key_offset);
+	return (const void *)((const char *)ptr - rel->node_offset
+						+ rel->key_offset);
+}
+
+static __always_inline
+char *__rb_node_to_obj(const void *ptr, const struct rb_relationship *rel)
+{
+	BUILD_BUG_ON_NON_CONST2(rel->node_offset);
+	return (char *)ptr - rel->node_offset;
+}
+
+/* not used anymore */
+#if 0
+static __always_inline
+struct rb_node *__rb_to_node(const void *ptr, const struct rb_relationship *rel)
+{
+	BUILD_BUG_ON_NON_CONST2(rel->node_offset);
+	return (struct rb_node *)((char *)ptr + rel->node_offset);
+}
+
+static __always_inline
+const void *__rb_to_key(const void *ptr, const struct rb_relationship *rel)
+{
+	BUILD_BUG_ON_NON_CONST2(rel->key_offset);
+	return (const void *)((const char *)ptr + rel->key_offset);
+}
+
+#endif
+
+/** __rb_find -
+ *
+ */
+static __always_inline
+struct rb_node *__rb_find(
+		struct rb_node *node,
+		const void *key,
+		const struct rb_relationship *rel,
+		const rb_compare_f compare)
+{
+	while (node) {
+		long diff = compare(key, __rb_node_to_key(node, rel));
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
+
+static __always_inline
+struct rb_node *rb_find(
+	struct rb_root *root,
+	const void *key,
+	const struct rb_relationship *rel,
+	const rb_compare_f compare)
+{
+	return __rb_find(root->rb_node, key, rel, compare);
+}
+
+enum rb_find_subtree_match {
+	RB_MATCH_NONE		= 0,
+	RB_MATCH_IMMEDIATE	= 2,
+	RB_MATCH_LEFT		= -1,
+	RB_MATCH_RIGHT		= 1,
+};
+
+
+/**
+ * rb_find_subtree - Locate the subtree that contains the specified key (if it
+ * 		     exists) starting from a specific node traversing upwards.
+ *
+ */
+static __always_inline
+struct rb_node *__rb_find_subtree(
+		struct rb_node *from,
+		const void *key,
+		int *matched,
+		const struct rb_relationship *rel,
+		const rb_compare_f compare)
+{
+	struct rb_node *prev = from;
+	struct rb_node *node = rb_parent(from);
+	long diff;
+
+	if (!node) {
+		*matched = RB_MATCH_NONE;
+		return prev;
+	}
+
+	diff = compare(key, __rb_node_to_key(node, rel));
+
+	if (diff > 0) {
+		while (1) {
+			prev = node;
+			node = rb_parent(prev);
+			if (!node)
+				break;
+
+			diff = compare(key, __rb_node_to_key(node, rel));
+			if (diff < 0)
+				break;
+			else if (!diff) {
+				*matched = RB_MATCH_LEFT;
+				return node;
+			}
+		}
+		*matched = RB_MATCH_NONE;
+		return prev->rb_left;
+	} else if (diff < 0) {
+		while (1) {
+			prev = node;
+			node = rb_parent(prev);
+			if (!node)
+				break;
+
+			diff = compare(key, __rb_node_to_key(node, rel));
+			if (diff > 0)
+				break;
+			else if (!diff) {
+				*matched = RB_MATCH_RIGHT;
+				return node;
+			}
+		}
+		*matched = RB_MATCH_NONE;
+		return prev->rb_right;
+	}
+
+	*matched = RB_MATCH_IMMEDIATE;
+	return node;
+}
+
+static __always_inline
+struct rb_node *rb_find_near(
+	struct rb_node *from,
+	const void *key,
+	const struct rb_relationship *rel,
+	const rb_compare_f compare)
+{
+	int matched;
+	struct rb_node *subtree;
+
+	subtree = __rb_find_subtree(from, key, &matched, rel, compare);
+
+	if (matched) {
+		return subtree;
+	}
+
+	return __rb_find(subtree, key, rel, compare);
+}
+
+static __always_inline
+struct rb_node *__rb_insert_epilogue(
+	struct rb_root *root,
+	struct rb_node *parent,
+	struct rb_node *node,
+	struct rb_node *found,
+	struct rb_node **rb_link,
+	const struct rb_relationship *rel,
+	const rb_augment_f augmented) {
+
+	if ((rel->flags & RB_UNIQUE_KEYS) && found) {
+		/* if replacing, we will still need to call do augmented */
+		if (rel->flags & RB_INSERT_REPLACES)
+			rb_replace_node(found, node, root);
+		/* otherwise, we can bail */
+		else
+			goto exit;
+	} else {
+		rb_link_node(node, parent, rb_link);
+		rb_insert_color(node, root);
+	}
+
+	if (augmented)	/* TODO: check verify which versions of gcc compile this out */
+		rb_augment_insert(node, augmented, NULL);
+
+exit:
+	return found;
+}
+
+
+/**
+ * rb_insert() - Inserts an object into a container.
+ * @container:  Pointer to the container.
+ * @obj:        Pointer to the new object to insert.
+ * @rel:        Pointer to the compile-time constant relationship definition.
+ *
+ * If an object with the same key already exists and rel->ins_replace is non-zero,
+ * then it is replaced with obj; if rel->ins_replace is zero, then no change is made.
+ * In either case, a pointer to the existing object is returned. Note that
+ * return values are pointers to the objects themselves, not to the struct
+ * rb_node.
+ *
+ * If no object with the same key exists, then obj is inserted and NULL is
+ * returned.
+ *
+ * See rb_find for example.
+ */
+static __always_inline
+struct rb_node *rb_insert(
+	struct rb_root *root,
+	struct rb_node *node,
+	const struct rb_relationship *rel,
+	const rb_compare_f compare,
+	const rb_augment_f augmented)
+{
+	struct rb_node **p     = &root->rb_node;
+	struct rb_node *parent = NULL;
+	const void *key        = __rb_node_to_key(node, rel);
+	int leftmost           = 1;
+	int rightmost          = 1;
+
+	BUILD_BUG_ON_NON_CONST2(rel->flags);
+	BUG_ON((rel->flags & RB_INSERT_REPLACES)
+		 && !(rel->flags & RB_UNIQUE_KEYS));
+
+	while (*p) {
+		long diff = compare(key, __rb_node_to_key(*p, rel));
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
+	return __rb_insert_epilogue(root, parent, node, *p, p, rel, augmented);
+}
+
+static __always_inline
+struct rb_node *rb_insert_near(
+		struct rb_root *root,
+		struct rb_node *start,
+		struct rb_node *node,
+		const struct rb_relationship *rel,
+		const rb_compare_f compare,
+		const rb_augment_f augmented)
+{
+
+	return 0;
+/* TODO: not yet finished */
+#if 0
+	const void *key        = __rb_node_to_key(node, rel);
+	struct rb_node **p     = &start;
+	struct rb_node *parent = NULL;
+	struct rb_node *ret;
+	int matched;
+	long diff;
+
+	BUILD_BUG_ON_NON_CONST2(rel->flags);
+
+	ret = __rb_find_subtree(start, key, &matched, rel, compare);
+
+	if (!matched) {
+		while (*p) {
+			diff   = compare(__rb_node_to_key(*p, rel), key);
+			parent = *p;
+
+			if (diff > 0) {
+				p = &(*p)->rb_right;
+			} else if (!(rel->flags & RB_UNIQUE_KEYS) || diff < 0) {
+				p = &(*p)->rb_left;
+			} else
+				break;
+		}
+		ret = *p;
+	} else {
+		/* FIXME: p will not be correctly set to point to the parent's
+		 * rb_left or rb_right member here when it's passed as
+		 * __rb_insert_epilogue()'s rb_link parameter.
+		 */
+		if (rel->flags & (RB_HAS_LEFTMOST | RB_HAS_RIGHTMOST)) {
+			if ((rel->flags & RB_HAS_LEFTMOST)) {
+				struct rb_node **left = __rb_root_to_left(root, rel);
+				if (*left == ret) {
+					*left = node;
+				}
+			}
+
+			if ((rel->flags & RB_HAS_RIGHTMOST)) {
+				struct rb_node **right = __rb_root_to_right(root, rel);
+				if (*right == ret) {
+					*right = node;
+				}
+			}
+		}
+	}
+
+	if (rel->flags & RB_HAS_LEFTMOST | RB_HAS_RIGHTMOST) {
+
+	}
+
+	if ((rel->flags & RB_HAS_LEFTMOST)) {
+		struct rb_node **left = __rb_root_to_left(root, rel);
+		if (!*left || (*left == parent && diff < 0)) {
+			*left = node;
+		}
+	}
+
+	if ((rel->flags & RB_HAS_RIGHTMOST)) {
+		struct rb_node **right = __rb_root_to_right(root, rel);
+		if ((*right == parent && diff > 0) || !*right) {
+			*right = node;
+		}
+	}
+
+	return __rb_insert_epilogue(root, parent, node, ret, p, rel, augmented);
+#endif
+}
+
+static __always_inline
+void rb_remove(
+	struct rb_root *root,
+	struct rb_node *node,
+	const struct rb_relationship *rel,
+	const rb_augment_f augmented)
+{
+	struct rb_node *deepest = NULL;
+
+	BUILD_BUG_ON_NON_CONST2(rel->flags);
+
+	if (augmented)
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
+	if (augmented)
+		rb_augment_erase_end(deepest, augmented, NULL);
+}
+
+
+/**
+ * RB_RELATIONHIP - Define the relationship bewteen a container with a
+ *                  struct rb_root member, and the objects it contains.
+ * @cont_type: container type
+ * @root:      container's struct rb_root member name
+ * @left:      (optional) if the container needs a pointer to the tree's
+ *             leftmost (smallest) object, then specify the container's struct
+ *             rb_node *leftmost member.  Otherwise, leave this parameter
+ *             empty.
+ * @right:     (optional) same as left, but for the rightmost (largest)
+ * @obj_type:  the type of object stored in container
+ * @node:      the struct rb_node memeber of the object
+ * @key:       the key member of the object
+ * @flags      see rb_flags.  Note: you do not have to specify RB_HAS_LEFTMOST
+ *             or RB_HAS_RIGHTMOST as these will be added automatically if the
+ *             left or right parameter (respectively) is non-empty
+ */
+#define RB_RELATIONHIP(							\
+		cont_type, root, left, right,				\
+		obj_type, node, key,					\
+		_flags) {						\
+	.root_offset     = offsetof(cont_type, root),			\
+	.left_offset     = OPT_OFFSETOF(cont_type, left),		\
+	.right_offset    = OPT_OFFSETOF(cont_type, right),		\
+	.node_offset     = offsetof(obj_type, node),			\
+	.key_offset      = offsetof(obj_type, key),			\
+	.flags           = (_flags)					\
+			 | IFF_EMPTY(left , 0, RB_HAS_LEFTMOST)		\
+			 | IFF_EMPTY(right, 0, RB_HAS_RIGHTMOST),	\
+}
+
+/**
+ * RB_DEFINE_INTERFACE - Defines a complete interface for a relationship
+ *                       between container and object including a struct
+ *                       rb_relationship and an interface of type-safe wrapper
+ *                       functions.
+ * @prefix:    name for the relationship (see explanation below)
+ * @cont_type: container type
+ * @root:      container's struct rb_root member name
+ * @left:      (optional) if the container needs a pointer to the tree's
+ *             leftmost (smallest) object, then specify the container's struct
+ *             rb_node *leftmost member.  Otherwise, leave this parameter
+ *             empty.
+ * @right:     (optional) same as left, but for the rightmost (largest)
+ * @obj_type:  the type of object stored in container
+ * @node:      the struct rb_node memeber of the object
+ * @key:       the key member of the object
+ * @flags      see rb_flags.  Note: you do not have to specify RB_HAS_LEFTMOST
+ *             or RB_HAS_RIGHTMOST as these will be added automatically if the
+ *             left or right parameter (respectively) is non-empty
+ * @compare:   pointer to key rb_compare_f function to compare keys.  Function
+ *             will be cast to and called as type long (*)(const void *a, const
+ *             void *b), hence type-safety is lost (FIXME: can this be improved
+ *             at all?).
+ * @augmented: pointer to the rb_augment_f or zero if tree is not augmented.
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
+ * inserts and lookups.
+ */
+#define RB_DEFINE_INTERFACE(prefix, ...)\
+__RB_DEFINE_INTERFACE(			\
+	prefix ## _rel,			\
+	prefix ## _insert,		\
+	prefix ## _insert_near,		\
+	prefix ## _find,		\
+	prefix ## _find_near,		\
+	prefix ## _remove,		\
+	__VA_ARGS__)
+
+
+#define __RB_DEFINE_INTERFACE(						\
+	rel_var, insert, insert_near, find, find_near, remove,		\
+	cont_type, root, left, right,					\
+	obj_type, node, key,						\
+	flags, compare, augmented)					\
+static const struct rb_relationship rel_var = RB_RELATIONHIP(		\
+	cont_type, root, left, right,					\
+	obj_type, node, key,						\
+	flags);								\
+									\
+static __always_inline							\
+obj_type *insert(cont_type *cont, obj_type *obj)			\
+{									\
+	struct rb_node *ret = rb_insert(				\
+			&cont->root, &obj->node, &rel_var,		\
+			(const rb_compare_f)compare, augmented);	\
+	return ret ? rb_entry(ret, obj_type, node) : 0;			\
+}									\
+									\
+static __always_inline							\
+obj_type *insert_near(cont_type *cont, obj_type *near, obj_type *obj)	\
+{									\
+	struct rb_node *ret = rb_insert_near(				\
+			&cont->root, &near->node, &obj->node, &rel_var,	\
+			(const rb_compare_f)compare, augmented);	\
+	return ret ? rb_entry(ret, obj_type, node) : 0;			\
+}									\
+									\
+static __always_inline							\
+obj_type *find(cont_type *cont,						\
+	       const typeof(((obj_type *)0)->key) *_key)		\
+{									\
+	struct rb_node *ret = rb_find(					\
+			&cont->root, _key, &rel_var,			\
+			(const rb_compare_f)compare);			\
+	return ret ? rb_entry(ret, obj_type, node) : 0;			\
+}									\
+									\
+static __always_inline							\
+obj_type *find_near(obj_type *near,					\
+		    const typeof(((obj_type *)0)->key) *_key)		\
+{									\
+	struct rb_node *ret = rb_find_near(				\
+			&near->node, _key, &rel_var,			\
+			(const rb_compare_f)compare);			\
+	return ret ? rb_entry(ret, obj_type, node) : 0;			\
+}									\
+									\
+static __always_inline							\
+void remove(cont_type *cont, obj_type *obj)				\
+{									\
+	rb_remove(&cont->root, &obj->node, &rel_var, augmented);	\
+}									\
+
 #endif	/* _LINUX_RBTREE_H */
-- 
1.7.3.4


--------------080002000604090606030803--
