Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761319Ab2EIXsa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 19:48:30 -0400
Received: from nm7-vm0.access.bullet.mail.mud.yahoo.com ([66.94.237.189]:30027
	"HELO nm7-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759115Ab2EIXsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 19:48:25 -0400
X-Yahoo-Newman-Id: 276463.42523.bm@smtp109.sbc.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: zRdqtjcVM1nGOZQZzGDUwSoOynKwnLYRrjVf3XhYQ54h6Sn
 47hZYKqeDjQuYopkUBHQmGdt5807jIsytzDhukIwpZ01JPpFlupfDV5F61T0
 OrZ7ZMswrXTBZ5Mr_LsVhtU5RX_F9MLKaGD1IexYw9ju6yAEPWF1GsctQIvH
 fGOCBVa8CwzVjKqa_Uiv7W4AnE4auJ56akKPLodgMzjmEJUYHHwGEg6LNjRZ
 rynMy_8IgHkvnjCtiaDSvny2FOl5kgUxpnNcAcKIOt0g9qMeCvuE_W4pM0aE
 c56R4N.nfxZevYbTEoHMXsSAmKfPPsDmI2dfMU4Mc8HUj.f5jWonQ_6tUrS6
 TwKSK2rJzSRvGsywMDunhD9f_utJhkjkPhTwR.MPOP6zHLFtB_uRd6ouQ2sP
 Pi4XQW33B1ZgugP__fdDvq_.jmGDdHNS_GC6QEpsIMs86
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
Message-ID: <4FAB0249.7030804@att.net>
Date: Wed, 09 May 2012 18:48:25 -0500
From: Daniel Santos <danielfsantos@att.net>
Reply-To: daniel.santos@pobox.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120502 Thunderbird/10.0.4
MIME-Version: 1.0
To: daniel.santos@pobox.com, linux-kernel@vger.kernel.org
CC: Peter Zijlstra <peterz@infradead.org>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Request feedback please: generic rbtree search, insert & remove (with
 leftmost, augmented, etc.)
References: <4F9E7365.2040907@att.net> <1335871228.13683.141.camel@twins> <1335888000.13683.158.camel@twins> <4FA44F93.7090009@att.net>
In-Reply-To: <4FA44F93.7090009@att.net>
X-Enigmail-Version: 1.3.5
Content-Type: multipart/mixed;
 boundary="------------050803030700050104070607"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050803030700050104070607
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

I've been working on this more and have gone through several
iterations.  I have a small problem: my mechanism will never inline the
key compare function call since it calls it by pointer.  I'm not sure if
this is dictated in the C specification or if it's just something gcc
can't currently detect as a compile-time constant and optimize out. 
Every other option specified via the struct rb_relationship is getting
nicely optimized, removing unused code, etc.

Here is the current feature set (all optimized out when not used):
* leftmost - keep a pointer to the leftmost (lowest value) node cached
in your container struct (thanks Peter)
* rightmost - ditto for rightmost (greatest value)
* unique or non-unique keys with some minor tuning options
* relative searches - when you already have a node that is likely near
another one you want to search for
* augmented / interval tree support (not yet tested)

So back to the problem, as I see it here are my options:
1. Create a header file where you #define your parameters and include it
to define your search, insert & remove functions.  Example:

#define RBTREE_CONTAINER_TYPE     struct my_container
#define RBTREE_CONTAINER_ROOT     rb_root       /* struct rb_root member */
#define RBTREE_CONTAINER_LEFTMOST leftmost      /* struct rb_node *member */
#define RBTREE_CONTAINER_RIGHTMOST              /* none */
#define RBTREE_OBJECT_TYPE        struct my_obj
#define RBTREE_OBJECT_NODE        rb_node       /* struct rb_node member */
#define RBTREE_OBJECT_KEY         mykey
#define RBTREE_KEY_COMPARE        compare_my_key
#define etc...
#include <linux/grbtree.h> /* expands parameters where needed and then
#undefs them. */

2. Use a big ugly macro to define them.  Example:
RB_DEFINE_CORE(struct my_container, rb_root, etc...) /* expands to all
function implementations */

3. Accept the compare function call overhead for search & insert
functions and keep them normal (i.e., __always_inline, non-preprocessor)
generic functions.

Here are the benefits of each, as I see it:
Debugging information will still point you to a real line of code
1. Yes, 2. No, 3. Yes

Type safety implemented (you pass pointers to your container & object
structs directly rather than node pointers)
1. Yes, 2. Yes, 3. No

Maximum efficiency (no function calls to inline-ables like compare and
augmented)
1. Yes, 2. Yes, 3. No

Relies primarily upon:
1. cpp, 2. cpp, 3. cc


To me, the first option seems like it makes the most sense, although I
despise heavy use of the preprocessor (it would be sweet if ANSI came
out with a C templates standard).  Attached is my current working
version which implements approach 3 as described above.  It has a
GRB_DEFINE_INTERFACE() macro, but it only defines a type a type-safe
interface and doesn't fix the compare function not inlined problem.
(Much of comment docs are out of date too.)

Thanks in advance.

Daniel



--------------050803030700050104070607
Content-Type: text/x-patch;
 name="generic_rbtree.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="generic_rbtree.patch"

diff --git a/include/linux/grbtree.h b/include/linux/grbtree.h
new file mode 100644
index 0000000..06f40cf
--- /dev/null
+++ b/include/linux/grbtree.h
@@ -0,0 +1,597 @@
+/*
+ * Generic Red Black Tree Extensions
+ *
+ * Copyright (C) 2012  Daniel Santos <daniel.santos@pobox.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301,
+ * USA.
+ */
+
+/**
+ * DOC: Generic Red Black Tree Extensions
+ *
+ * Generic Red Black Tree Extensions extends upon Andrea Arcangeli's original
+ * rbtree implementation adding the ability to generically define
+ * relationships between containers and their contents (see struct
+ * grb_relationship) and feeding that definition to generic function
+ * implementations. By using a compile-time constant instance of struct
+ * grb_relationship and a single instantiation of the static inline find &
+ * insert functions, gcc will generate code that is exactly as efficient as if
+ * you had implemented your own find & insert functions (as explained in the
+ * rbtree documentation) without the source bloat and added complexity.
+ * Further, by wrapping calls to the generic (__always_inline) functions in
+ * singular (non-inline) functions, type-safety can be achieved while
+ * preventing the bloat of inline expansion.
+ *
+ * The struct grb_relationship object should be thought of as a database's DDL
+ * (Data Definition Language) that defines the relationship between two
+ * tables: primary & foreign keys, unique constraints, sort ordering, tuning
+ * hints, etc. (although in practice, some of those are specified when making
+ * SQL queries).  It also specifies extended features you're using, like
+ * rather or not your container caches a pointer to the leftmost node in the
+ * tree -- enabling them in the generic function implementations or ensuring
+ * that they are compiled-out if you are not.
+ *
+ * It is important to understand that while grbtree extends upon rbtree's
+ * functionality, it uses a different interface paradigm: where rbtree's
+ * interface deals with the types struct rb_root and rb_node, grbtree is
+ * concerned with your containers and their objects and is designed to
+ * relegate the overhead for such genericity to the compiler.  So rather than
+ * passing a pointer to the struct rb_node or rb_root member of your
+ * container or object, you will simply pass a pointer to your container or
+ * object its self, likewise for return values.
+ *
+ * Because C does not (yet) support templates, this all means that the generic
+ * function accept and return void *pointers, killing type safety.  To
+ * restore type safety, its reccomeded you either wrap all calls to generic
+ * functions in your own type-specific function (inline or not) or use the
+ * unholy (but sufficient) GRB_DEFINE_INTERFACE() macro to have this done for
+ * you.
+ *
+ * Egg Sample:
+ *
+ * struct house {
+ *     struct rb_root mice;
+ * };
+ *
+ * struct mouse {
+ *     struct rb_node node;
+ *     const char*    name;
+ * };
+ *
+ * static __always_inline long name_cmp(const char **a, const char **b) {
+ *     return strcmp(*a, *b);
+ * }
+ *
+ * static const struct grb_relationship rel_house_to_mouse =
+ * GRB_RELATIONHIP(struct house, mice, / * noleft * /, / * noright * /,
+ *                 struct mouse, node, name, name_cmp,
+ *                 1, 0, 1, 0);
+ *
+ * struct mouse *find_mouse(struct house *house, const char *name) {
+ *     return rb_find(house, name, &rel_house_to_mouse);
+ * }
+ *
+ * struct mouse *put_mouse_in_house(struct house *house, struct mouse *mouse) {
+ *     return rb_insert(house, mouse, &rel_house_to_mouse);
+ * }
+ *
+ *
+ */
+#ifndef _LINUX_GRBTREE_H
+#define _LINUX_GRBTREE_H
+
+#include <linux/rbtree.h>
+
+typedef long (*rb_compare_f)(const void *a, const void *b);
+
+/* will submit this for include/linux/bug.h after I verify working gcc
+ * versions better and fully document caveats
+ */
+/**
+ * BUILD_BUG_ON_NON_CONST_STRUCT - break compile if a struct member is not a
+ *                                 compile-time constant
+ * @exp: struct member to test for compile-time constness
+ *
+ * If you have some code that depends upon struct instance being a compile-
+ * time constant (or more specifically one or more of its members), then you
+ * can use this macro to trigger a BUILD_BUG if it is not.  Note that one
+ * member of a struct instrance can be determined a compile-time constant by
+ * gcc and not another.
+ *
+ * Caveats: TODO
+ */
+#if defined(__OPTIMIZE__) && (__GNUC__ > 4 || __GNUC__ == 4 && __GNUC_MINOR__ >= 1)
+#define BUILD_BUG_ON_NON_CONST_STRUCT(exp) \
+	BUILD_BUG_ON(!__builtin_constant_p(exp))
+#else
+#define BUILD_BUG_ON_NON_CONST_STRUCT(exp)
+#endif
+
+
+#define __JUNK junk,
+#define _iff_empty(test_or_junk, t, f) __iff_empty(test_or_junk, t, f)
+#define __iff_empty(__ignored1, __ignored2, result, ...) result
+
+/**
+ * IFF_EMPTY() - Expands to the second argument when the first is empty, the
+ *               third if non-empty.
+ * test:         An argument to test for emptiness.
+ * on_true:      A value to expand to if test is empty.
+ * on_false:     A value to expand to if test is non-empty.
+ *
+ * Examples:
+ * IFF_EMPTY(a, b, c) = c
+ * IFF_EMPTY( , b, c) = b
+ * IFF_EMPTY( ,  , c) = (nothing)
+ */
+#define IFF_EMPTY(test, t, f) _iff_empty(__JUNK##test, t, f)
+
+/**
+ * IS_EMPTY() - test if a pre-processor argument is empty.
+ * arg:         An argument (empty or non-empty)
+ *
+ * If empty, expands to 1, 0 otherwise.
+ */
+#define IS_EMPTY(arg)	IFF_EMPTY(arg, 1, 0)
+
+/**
+ * OPT_OFFSETOF() - return the offsetof for the supplied expression, or zero
+ *                  if m is an empty argument.
+ * type:            struct/union type
+ * m:               (optional) struct member name
+ *
+ * Since any offsetof can return zero if the specified member is the first in
+ * the struct/union, you should also check if the argument is empty separately
+ * with IS_EMPTY(m).
+ */
+#define OPT_OFFSETOF(type, m) ((size_t) &((*((type *)0)) IFF_EMPTY(m,,.m)))
+
+
+/**
+ * struct grb_relationship - Defines relationship between a container and
+ *                      the objects it contains.
+ * @root_offset:        Offset of container's struct rb_root member.
+ * @has_left:           Non-zero if the container has a leftmost member, zero
+ *                      otherwise.
+ * @has_right:          Non-zero if the container has a rightmost member, zero
+ *                      otherwise.
+ * @left_offset:        (Used only if has_left.) Offset of the container's
+ *                      struct rb_node *leftmost member for storing a pointer
+ *                      to the leftmost node in the tree, which is kept
+ *                      updated as inserts and deletions are made.
+ * @right_offset:       Same as left_offset, except for right side of tree.
+ * @node_offset:        Offset of object's struct rb_node member.
+ * @key_offset:         Offset of object's key member.
+ * @compare:            Compare function for object keys -- should be an
+ *                      inline function in the same translation unit for
+ *                      proper optimization, although this is the only field
+ *                      that isn't required to be a compile-time constant.
+ *                      The compare function should accept pointers to the key
+ *                      type and return long.
+ * @unique:             Zero if duplicate keys are allowed, non-zero otherwise.
+ * @tune_many_dupes:    (Used only if !unique.) Tune searches & inserts when
+ *                      not using unique keys and many duplilcates are likely.
+ * @ins_replace:        (Used only if unique.) Rather or not the __grb_insert
+ *                      function should replace existing objects.
+ * @is_augmented:       Rather or this is an augmented rbtree (and the
+ *                      augmented is non-null)
+ * @augmented:          Not yet implemented (pointer to rb_augmented_f function)
+ *
+ * Instances of struct grb_relationship should be compile-time constants (or
+ * rather, the value of its members).
+ *
+ * Note: If your container stores the leftmost or rightmost, you must use the
+ * generic __rb_remove to keep them current.
+ */
+struct grb_relationship {
+	long root_offset;
+	int has_left;
+	int has_right;
+	long left_offset;
+	long right_offset;
+	long node_offset;
+	long key_offset;
+	rb_compare_f compare;
+	int unique;
+	int tune_many_dupes;
+	int ins_replace;
+	int is_augmented;
+	rb_augment_f augmented;
+};
+
+static __always_inline
+struct rb_root *__grb_to_root(const void *ptr, const struct grb_relationship *rel)
+{
+	BUILD_BUG_ON_NON_CONST_STRUCT(rel->root_offset);
+	return (struct rb_root *)((char *)ptr + rel->root_offset);
+}
+
+static __always_inline
+struct rb_node **__grb_to_left(void *ptr, const struct grb_relationship *rel)
+{
+	BUILD_BUG_ON(!rel->has_left);
+	BUILD_BUG_ON_NON_CONST_STRUCT(rel->left_offset);
+	return (struct rb_node **)((char *)ptr + rel->left_offset);
+}
+
+static __always_inline
+struct rb_node **__grb_to_right(void *ptr, const struct grb_relationship *rel)
+{
+	BUILD_BUG_ON(!rel->has_right);
+	BUILD_BUG_ON_NON_CONST_STRUCT(rel->right_offset);
+	return (struct rb_node **)((char *)ptr + rel->right_offset);
+}
+
+static __always_inline
+struct rb_node *__grb_to_node(const void *ptr, const struct grb_relationship *rel)
+{
+	BUILD_BUG_ON_NON_CONST_STRUCT(rel->node_offset);
+	return (struct rb_node *)((char *)ptr + rel->node_offset);
+}
+
+static __always_inline
+const void *__grb_to_key(const void *ptr, const struct grb_relationship *rel)
+{
+	BUILD_BUG_ON_NON_CONST_STRUCT(rel->key_offset);
+	return (const void *)((const char *)ptr + rel->key_offset);
+}
+
+static __always_inline
+const void *__grb_node_to_key(const void *ptr, const struct grb_relationship *rel)
+{
+	BUILD_BUG_ON_NON_CONST_STRUCT(rel->node_offset);
+	BUILD_BUG_ON_NON_CONST_STRUCT(rel->key_offset);
+	return (const void *)((const char *)ptr - rel->node_offset + rel->key_offset);
+}
+
+static __always_inline
+char *__grb_node_to_obj(const void *ptr, const struct grb_relationship *rel)
+{
+	BUILD_BUG_ON_NON_CONST_STRUCT(rel->node_offset);
+	return ((char *)ptr - rel->node_offset);
+}
+
+/**
+ * grb_find_down_from - search a tree (normally) starting from the specified node
+ */
+static __always_inline
+void *grb_find_down_from(const struct rb_node *node,
+			 const void *key,
+			 const struct grb_relationship *rel)
+{
+	while (node) {
+		int diff = rel->compare(__grb_node_to_key(node, rel), key);
+
+		if (diff > 0)
+			node = node->rb_right;
+		else if (diff < 0)
+			node = node->rb_left;
+		else
+			return __grb_node_to_obj(node, rel);
+	}
+
+	return 0;
+}
+
+/**
+ * grb_find_up_from - search a tree climbing upwards, starting at the 'from'
+ *                    object and then descending (if needed) to find a
+ *                    matching object or no match.
+ */
+static __always_inline
+void *grb_find_up_from(const void *from,
+		       const void *key,
+		       const struct grb_relationship *rel)
+{
+	const struct rb_node *node = __grb_to_node(from, rel);
+	long diff = rel->compare(__grb_node_to_key(node, rel), key);
+	int go_left = diff < 0;
+
+	if (!diff)
+		return (void *)from;
+
+	while ((node = rb_parent(node))) {
+		diff = rel->compare(__grb_node_to_key(node, rel), key);
+
+		if (!diff)
+			return __grb_node_to_obj(node, rel);
+		else if (go_left ? diff > 0 : diff < 0)
+			return grb_find_down_from(node, key, rel);
+	}
+
+	return 0;
+}
+
+/**
+ * grb_find() - Searches a red black tree.
+ * @container:  Container to search.
+ * @key:        Pointer to the key you want to find.
+ * @rel:        Pointer to the compile-time constant relationship definition.
+ *
+ * On success, returns a pointer to the object (not the struct rb_node), NULL
+ * otherwise. If rel is not a compile-time constant, a link-time error will
+ * be generated.
+ *
+ * If your code calls this function from more than one place, it is highly
+ * recommended that you wrap this function in a non-inline function to avoid
+ * object code bloat. You have been advised!  Even if you are calling it from
+ * one place, wrapping it in a type-specific function (inline or otherwise)
+ * improves type-safety.
+ *
+ *
+ */
+static __always_inline
+void *grb_find(const void *container,
+	       const void *key,
+	       const struct grb_relationship *rel)
+{
+	return grb_find_down_from(__grb_to_root(container, rel)->rb_node, key,
+				  rel);
+}
+
+/**
+ * grb_insert() - Inserts an object into a container.
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
+void *grb_insert(void *container,
+		 void *obj,
+		 const struct grb_relationship *rel)
+{
+	struct rb_root *root   = __grb_to_root(container, rel);
+	struct rb_node **p     = &root->rb_node;
+	struct rb_node *parent = NULL;
+	struct rb_node *node   = __grb_to_node(obj, rel);
+	void *ret              = NULL;
+	const void *key        = __grb_to_key(obj, rel);
+	int rightmost          = 1;
+	int leftmost           = 1;
+
+	BUILD_BUG_ON_NON_CONST_STRUCT(rel->has_left);
+	BUILD_BUG_ON_NON_CONST_STRUCT(rel->has_right);
+	BUILD_BUG_ON_NON_CONST_STRUCT(rel->unique);
+	BUILD_BUG_ON_NON_CONST_STRUCT(rel->tune_many_dupes);
+	BUILD_BUG_ON_NON_CONST_STRUCT(rel->ins_replace);
+	BUILD_BUG_ON_NON_CONST_STRUCT(rel->is_augmented);
+
+	while (*p) {
+		int diff = rel->compare(__grb_node_to_key(*p, rel), key);
+		parent   = *p;
+
+		if (diff > 0) {
+			p = &(*p)->rb_right;
+			if (rel->has_left)
+				leftmost = 0;
+		/* if keys are not unique, we can skip additional tests,
+		 * although it will be slower if there are often duplicate
+		 * keys, so rel->tune_many_dupes will dictate how we
+		 * behave.
+		 */
+		} else if ((!rel->unique && !rel->tune_many_dupes) || diff < 0) {
+			p = &(*p)->rb_left;
+			if (rel->has_right)
+				rightmost = 0;
+		} else
+			break;
+	}
+
+	if (rel->has_left && leftmost)
+		*__grb_to_left(container, rel) = node;
+	if (rel->has_right && rightmost)
+		*__grb_to_right(container, rel) = node;
+
+	if (rel->unique && *p) {
+		ret = __grb_node_to_obj(*p, rel);
+		if (rel->ins_replace)
+			rb_replace_node(*p, node, root);
+	} else {
+		rb_link_node(node, parent, p);
+		rb_insert_color(node, root);
+	}
+
+	if (rel->is_augmented)
+		rb_augment_insert(node, rel->augmented, NULL);
+
+	return ret;
+}
+
+static __always_inline
+void grb_remove(void *container,
+		void *obj,
+		const struct grb_relationship *rel)
+{
+	struct rb_root *root   = __grb_to_root(container, rel);
+	struct rb_node *node   = __grb_to_node(obj, rel);
+	struct rb_node *deepest;
+
+	BUILD_BUG_ON_NON_CONST_STRUCT(rel->has_right);
+	BUILD_BUG_ON_NON_CONST_STRUCT(rel->has_left);
+	BUILD_BUG_ON_NON_CONST_STRUCT(rel->is_augmented);
+
+	if (rel->is_augmented)
+		deepest = rb_augment_erase_begin(node);
+
+	if (rel->has_left) {
+		struct rb_node **left = __grb_to_left(container, rel);
+
+		if (*left == node)
+			*left = rb_next(node);
+	}
+
+	if (rel->has_right) {
+		struct rb_node **right = __grb_to_right(container, rel);
+
+		if (*right == node)
+			*right = rb_prev(node);
+	}
+
+	rb_erase(node, root);
+
+	if (rel->is_augmented)
+		rb_augment_erase_end(deepest, rel->augmented, NULL);
+}
+
+/**
+ * GRB_RELATIONHIP - Define the relationship bewteen a container with a
+ *                   struct rb_root member, and the objects it contains.
+ * cont_type:       .
+ * root:            .
+ * left:            .
+ * right:           .
+ * obj_type:        .
+ * node:            .
+ * key:             .
+ * compare:         .
+ * unique:          .
+ * tune_many_dupes: .
+ * ins_replace:     .
+ * augmented:       .
+ */
+#define GRB_RELATIONHIP(						\
+		cont_type, root, left, right,				\
+		obj_type, node, key, _compare,				\
+		_unique, _tune_many_dupes, _ins_replace, _augmented) {	\
+	.root_offset     = offsetof(cont_type, root),			\
+	.has_left        = !IS_EMPTY(left),				\
+	.has_right       = !IS_EMPTY(right),				\
+	.left_offset     = OPT_OFFSETOF(cont_type, left),		\
+	.right_offset    = OPT_OFFSETOF(cont_type, right),		\
+	.node_offset     = offsetof(obj_type, node),			\
+	.key_offset      = offsetof(obj_type, key),			\
+	.compare         = (rb_compare_f)_compare,			\
+	.unique          = _unique,					\
+	.tune_many_dupes = _tune_many_dupes,				\
+	.ins_replace     = _ins_replace,				\
+	.is_augmented    = !IS_EMPTY(left),				\
+	.augmented       = IFF_EMPTY(_augmented, 0, _augmented),	\
+}
+
+#define __GRB_DEFINE_INTERFACE(						\
+	rel_var, insert_func, find_func, remove_func, 			\
+	cont_type, root, left, right,					\
+	obj_type, node, key, compare,					\
+	unique, tune_many_dupes, ins_replace, augmented,		\
+	insert_func_mod, find_func_mod)					\
+static const struct grb_relationship rel_var = GRB_RELATIONHIP(		\
+	cont_type, root, left, right,					\
+	obj_type, node, key, compare,					\
+	unique, tune_many_dupes, ins_replace, augmented);		\
+									\
+insert_func_mod								\
+obj_type *insert_func(cont_type *container, obj_type *obj) {		\
+	return (obj_type *)grb_insert(container, obj, &rel_var);	\
+}									\
+									\
+find_func_mod								\
+obj_type *find_func(const cont_type *container,				\
+		    const typeof(((obj_type *)0)->key) *key) {		\
+	return (obj_type *)grb_find(container, key, &rel_var);		\
+}									\
+									\
+static __always_inline							\
+void remove_func(cont_type *container, obj_type *obj) {			\
+	grb_remove(container, obj, &rel_var);				\
+}									\
+
+/** GRB_DEFINE_INTERFACE - Defines a struct grb_relationship object and
+ *                         type-safe inteface functions.
+ * prefix:          .
+ * cont_type:       .
+ * root:            .
+ * left:            .
+ * right:           .
+ * obj_type:        .
+ * node:            .
+ * key:             .
+ * compare:         .
+ * unique:          .
+ * tune_many_dupes: .
+ * ins_replace:     .
+ * augmented:       .
+ * insert_func_mod: .
+ * find_func_mod:   .
+ */
+#define GRB_DEFINE_INTERFACE(prefix, ...)\
+__GRB_DEFINE_INTERFACE(			\
+	prefix ## rel,			\
+	prefix ## insert,		\
+	prefix ## find,			\
+	prefix ## remove,		\
+	__VA_ARGS__)
+
+
+/** GRB_DEFINE_INTERFACE_OBJ  - A cute way to contain the type-safe interface
+ *                              in a single object, but killing inline-ability.
+ * interface_name:  name of your interface object
+ * cont_type:       .
+ * root:            .
+ * left:            .
+ * right:           .
+ * obj_type:        .
+ * node:            .
+ * key:             .
+ * compare:         .
+ * unique:          .
+ * tune_many_dupes: .
+ * ins_replace:     .
+ * augmented:       .
+ */
+#define GRB_DEFINE_INTERFACE_OBJ(					\
+	interface_name,							\
+	cont_type, root, left, right,					\
+	obj_type, node, key, compare,					\
+	unique, tune_many_dupes, ins_replace, augmented)		\
+static const struct {							\
+	struct grb_relationship rel;					\
+	obj_type *(*insert)(cont_type *c, obj_type *o,			\
+			    const struct grb_relationship *rel);	\
+	obj_type   *(*find)(const cont_type *c,				\
+			    const typeof(((obj_type *)0)->key) *key,	\
+			    const struct grb_relationship *rel);	\
+	void      (*remove)(cont_type *c, obj_type *o,			\
+			    const struct grb_relationship *rel);	\
+} interface_name = {							\
+.rel = GRB_RELATIONHIP(							\
+	cont_type, root, left, right,					\
+	obj_type, node, key, compare,					\
+	unique, tune_many_dupes, ins_replace, augmented),		\
+									\
+.insert  = (obj_type *(*)(cont_type *,					\
+			  obj_type *,					\
+			  const struct grb_relationship *))grb_insert,	\
+.find    = (obj_type *(*)(const cont_type *,				\
+			  const typeof(((obj_type *)0)->key) *,		\
+			  const struct grb_relationship *))grb_find,	\
+.remove  = (void      (*)(cont_type *, obj_type *,			\
+			  const struct grb_relationship *))grb_remove,	\
+};
+
+
+
+#endif	/* _LINUX_GRBTREE_H */

--------------050803030700050104070607--
