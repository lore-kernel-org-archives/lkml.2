Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167Ab2IYXjF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 19:39:05 -0400
Received: from nm8-vm0.bullet.mail.bf1.yahoo.com ([98.139.213.95]:22578 "HELO
	nm8-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754981Ab2IYXjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 19:39:01 -0400
X-Yahoo-Newman-Id: 302494.52644.bm@smtp114.sbc.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: o890v.YVM1m1QjTBpjvZ.knmmaPdOHHqdqLn4c0LTa6Na8e
 t1BnreaXfdMHyBmJLx1Yz_mwA3qsTZqbpDHAr68409gPisq_wJ0KbsD3pDVX
 gJEDGcazMDE.pkT6nyKFQThe.SYNTNvuuMDviXT0UcIonlXH_K.8.MhIce0R
 Yi2H9n4vC9zr3s2G17RZTPqfZU_UVmfkL96QK7FOyzhGSve8QiZ3TB4GY11Z
 kCyNhoFUn4PQeTe82UDgmHD8.oDUJjNDhuh2.C2_P6n5huaaq7_rq109Yt5p
 jel7Km_3sqgOOCRqzv5uASRUZD2riDhQgJlPXR99kRmaDZ1VsEqGZh_11DX3
 Cyjh6.R4rG9ry9zfWs7DRpLkPpNuichU37tfVEMLAXxbL4s3whmlEkU40Ibf
 0iE.fCavBpe0i.H9QL5HMe8WgSBzUqZ_R1njpjwHKQc_8T1mWlqYb
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
From: Daniel Santos <daniel.santos@pobox.com>
To: Daniel Santos <daniel.santos@pobox.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Richard Weinberger <richard@nod.at>,
        LKML <linux-kernel@vger.kernel.org>,
        Michel Lespinasse <walken@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>
Subject: [PATCH v5 20/25] selftest: Add generic tree self-test common code.
Date: Tue, 25 Sep 2012 18:32:00 -0500
Message-Id: <1348615920-10622-1-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1348615467-9850-1-git-send-email-daniel.santos@pobox.com>
References: <1348615467-9850-1-git-send-email-daniel.santos@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Self-test code for both performance and correctness testing. The files
tools/testing/selftests/grbtree/common.{h,c} contain code for use in
both the user- and kernel-space test program/module and depends upon a
few functions being made available by said.

The purpose of these tests is to verify correctness across compilers and
document the performance difference between the generic and hand-coded
red-black tree implementations on various compilers, which is identified
as critical for determining feasibility of adding this this tree
implementation to the kernel, as older compilers optimize the generic
code more poorly than its hand-coded counterpart.

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
---
 tools/testing/selftests/grbtree/common.c |  957 ++++++++++++++++++++++++++++++
 tools/testing/selftests/grbtree/common.h |  252 ++++++++
 2 files changed, 1209 insertions(+), 0 deletions(-)
 create mode 100644 tools/testing/selftests/grbtree/common.c
 create mode 100644 tools/testing/selftests/grbtree/common.h

diff --git a/tools/testing/selftests/grbtree/common.c b/tools/testing/selftests/grbtree/common.c
new file mode 100644
index 0000000..9625d60
--- /dev/null
+++ b/tools/testing/selftests/grbtree/common.c
@@ -0,0 +1,957 @@
+/* common.c - generic red-black tree test functions for use in both kernel and
+ * user space.
+ * Copyright (C) 2012  Daniel Santos <daniel.santos@pobox.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
+ */
+
+#include "common.h"
+
+#define _CONCAT2(a, b) a ## b
+#define _CONCAT(a, b) _CONCAT2(a, b)
+
+
+const char *grbtest_type_desc[GRBTEST_TYPE_COUNT] = {
+	"insertion performance",
+	"insertion & deletion performance",
+	"insertion validation"
+};
+
+#if GRBTEST_USE_AUGMENTED
+static void mytree_augment_fn(struct rb_node *node, void *data)
+{
+	// does nothing
+}
+#endif
+
+/* more efficient alternative to rb_init_node */
+static inline void grbtest_init_node(struct rb_node *node)
+{
+	node->rb_parent_color = (unsigned long)node;
+	node->rb_right = NULL;
+	node->rb_left = NULL;
+}
+
+#if GRBTEST_BUILD_GENERIC
+/****************************************************************************
+ * Generic Implementation
+ */
+
+#define __GRBTEST_FLAGS						\
+	((GRBTEST_UNIQUE_KEYS ? RB_UNIQUE_KEYS : 0) |		\
+	 (GRBTEST_INSERT_REPLACES ? RB_INSERT_REPLACES : 0))
+
+
+
+static inline long compare_s32(const s32 *a, const s32 *b) {return *a - *b;}
+static inline long greater_s32(const s32 *a, const s32 *b) {return *a > *b;}
+
+static inline long compare_u32(const u32 *a, const u32 *b) {return (long)*a - (long)*b;}
+static inline long greater_u32(const u32 *a, const u32 *b) {return *a > *b;}
+
+static inline long compare_s64(const s64 *a, const s64 *b) {return *a - *b;}
+static inline long greater_s64(const s64 *a, const s64 *b) {return *a > *b;}
+
+static inline long compare_u64(const u64 *a, const u64 *b) {return *a - *b;}
+static inline long greater_u64(const u64 *a, const u64 *b) {return *a > *b;}
+
+
+RB_DEFINE_INTERFACE(
+	mytree,
+	struct container, tree,
+#if GRBTEST_USE_LEFTMOST
+	leftmost
+#endif
+	,
+#if GRBTEST_USE_RIGHTMOST
+	rightmost
+#endif
+	,
+#if GRBTEST_USE_COUNT
+	count
+#endif
+	,
+	struct object, node, key,
+	__GRBTEST_FLAGS, _CONCAT(compare_, GRBTEST_KEY_TYPE),
+#if GRBTEST_UNIQUE_KEYS
+	_CONCAT(compare_, GRBTEST_KEY_TYPE),
+#else
+	_CONCAT(greater_, GRBTEST_KEY_TYPE),
+#endif
+#if GRBTEST_USE_AUGMENTED
+	mytree_augment_fn
+#endif
+	,
+	static __flatten inline,	/* find */
+	static __flatten inline,	/* insert */
+	static __flatten inline,	/* find_near */
+	static __flatten inline);	/* insert_near */
+
+
+#else /* GRBTEST_BUILD_GENERIC */
+
+/****************************************************************************
+ * Hand-coded Implementation
+ *
+ * This section implements the find, insert & remove functions as one would do
+ * so were they hand-coding it, except that we use pre-processor to include (or
+ * omit) the various features & rules.
+ *
+ * In order to account for compilers that may fail to optimize out a simple
+ * if(0) or if(1) construct, we'll make sure that such extra code is not
+ * generated by using these ugly pre-processor #ifs in this "hand-coded"
+ * section.  This makes the code prety ugly, but is percieved as necessary by
+ * the author for correctness. TODO: Is this overkill?
+ */
+
+static inline struct object *mytree_find(struct container *cont, GRBTEST_KEY_TYPE *key)
+{
+	struct rb_node *node = cont->tree.rb_node;
+
+	while (node) {
+		struct object *obj = container_of(node, struct object, node);
+		if (*key > obj->key) {
+			node = node->rb_right;
+		} else if (*key < obj->key) {
+			node = node->rb_left;
+		} else
+			return obj;
+	}
+
+	return 0;
+}
+
+static inline struct object *mytree_insert(struct container *cont,
+					   struct object *obj)
+{
+	struct rb_root *root   = &cont->tree;
+	struct rb_node **p     = &root->rb_node;
+	struct rb_node *parent = NULL;
+	GRBTEST_KEY_TYPE key   = obj->key;
+#if GRBTEST_UNIQUE_KEYS
+	struct rb_node *found;
+#endif
+#if GRBTEST_USE_LEFTMOST
+	int leftmost           = 1;
+#endif
+#if GRBTEST_USE_RIGHTMOST
+	int rightmost          = 1;
+#endif
+
+	while (*p) {
+		parent = *p;
+		GRBTEST_KEY_TYPE cur_key = container_of(*p, struct object, node)->key;
+
+		if (key < cur_key) {
+			p = &(*p)->rb_left;
+#if GRBTEST_USE_RIGHTMOST
+			rightmost = 0;
+#endif
+/* if not using/enforcing unique keys, the below test is superflorous */
+#if GRBTEST_UNIQUE_KEYS
+		} else if (key > cur_key) {
+#else
+		} else {
+#endif /* GRBTEST_UNIQUE_KEYS */
+			p = &(*p)->rb_right;
+#if GRBTEST_USE_LEFTMOST
+			leftmost = 0;
+#endif
+		}
+/* again, if not using unique keys, the if/else is completed above, and we
+ * never exit the loop until we find a leaf
+ */
+#if GRBTEST_UNIQUE_KEYS
+		  else
+			break;
+#endif
+	}
+
+
+#if GRBTEST_USE_LEFTMOST
+	if (leftmost)
+		cont->leftmost = *p;
+#endif
+
+#if GRBTEST_USE_RIGHTMOST
+	if (rightmost)
+		cont->rightmost = *p;
+#endif
+
+#if GRBTEST_UNIQUE_KEYS
+	found = *p;
+	if (found) {
+#if GRBTEST_INSERT_REPLACES
+		rb_replace_node(found, &obj->node, root);
+#endif
+
+#if GRBTEST_USE_AUGMENTED
+		/* If we're using an augment tree with unique keys, we'll
+		 * re-purpose 'found' for efficiency and make sure the
+		 * augmented function is called.
+		 */
+		found = (struct rb_node*)container_of(found, struct object, node);
+		goto do_augmented;
+#else
+		/* If we're not using an augmented tree, let's not give the
+		 * compiler a chance to generate extra code by storing the
+		 * return value and just return it directly here.
+		 */
+		return container_of(found, struct object, node);
+#endif /* GRBTEST_USE_AUGMENTED */
+	} else
+#endif /* GRBTEST_UNIQUE_KEYS */
+	{
+		rb_link_node(&obj->node, parent, p);
+		rb_insert_color(&obj->node, root);
+	}
+
+#if GRBTEST_USE_COUNT
+	++cont->count;
+#endif
+
+#if GRBTEST_USE_AUGMENTED
+#if GRBTEST_UNIQUE_KEYS
+/* We need the label only if augmented & unique keys, otherwise, we'll generate
+ * a compiler warning or error.
+ */
+do_augmented:
+#endif
+	rb_augment_insert(&obj->node, mytree_augment_fn, NULL);
+	return (struct object*)found;
+#else
+	return NULL;
+#endif /* GRBTEST_USE_AUGMENTED */
+}
+
+static inline void mytree_remove(struct container *cont, struct object *obj)
+{
+	struct rb_node *node = &obj->node;
+#if GRBTEST_USE_AUGMENTED
+	struct rb_node *deepest = rb_augment_erase_begin(node);
+#endif
+
+#if GRBTEST_USE_LEFTMOST
+	if (cont->leftmost == node)
+		cont->leftmost = rb_next(node);
+#endif
+
+#if GRBTEST_USE_RIGHTMOST
+	if (cont->rightmost == node)
+		cont->rightmost = rb_prev(node);
+#endif
+
+	rb_erase(node, &cont->tree);
+
+#if GRBTEST_USE_COUNT
+	--cont->count;
+#endif
+
+#if GRBTEST_USE_AUGMENTED
+	rb_augment_erase_end(deepest, mytree_augment_fn, NULL);
+#endif
+}
+
+
+#endif /* GRBTEST_BUILD_GENERIC */
+
+
+
+/****************************************************************************
+ * Test functions
+ */
+
+#define VALIDATE_PARAM(fmt, param, test)			\
+do {								\
+	if (unlikely(!(test))) {				\
+		print_err(#param " invalid: %" #fmt " (" #test ")\n", \
+				param);				\
+		return -EINVAL;					\
+	}							\
+} while(0)
+
+long grbtest_init(struct grbtest_config *config)
+{
+	long i;
+	void *rnd_state;
+
+	VALIDATE_PARAM(u, config->pool_count, config->pool_count);
+	VALIDATE_PARAM(u, config->object_count, config->object_count);
+
+	config->seed = config->in_seed;
+	rnd_state = rand_init(&config->seed);
+	if (!rnd_state) {
+		print_err("failed to init random number generator\n");
+		return -ENOMEM;
+	}
+
+	/* if already initialized, cleanup and start over */
+	if(objects.pools) {
+		grbtest_cleanup();
+	}
+
+	objects.pools        = malloc(sizeof(struct object *) *
+			       config->pool_count);
+	objects.pool_count   = config->pool_count;
+	objects.object_count = config->object_count;
+	objects.pool_size    = sizeof(struct object) * config->object_count;
+
+	if (0) {
+	print_err("allocating %u pools of %u objects (%lu bytes) each for a "
+		  "total of %lu bytes of memory.\n",
+		  config->pool_count, config->object_count,
+		  (unsigned long)objects.pool_size,
+		  (unsigned long)(config->pool_count * objects.pool_size));
+	}
+
+	for (i = 0; i != config->pool_count; ++i) {
+		objects.pools[i] = mem_alloc(objects.pool_size);
+		if (unlikely(!objects.pools[i])) {
+			print_err("out of memory, you probably did something "
+				  "stupid...\n");
+			objects.pool_count = i;
+			grbtest_cleanup();
+			return -ENOMEM;
+		}
+	}
+
+	/* initialize objects in all pools */
+	for (i = 0; i < config->pool_count; ++i) {
+		struct object *p = objects.pools[i];
+		struct object *end = &p[objects.object_count];
+
+		if (!i) {
+			/* pool zero gets random keys */
+			for (; p != end; ++p)
+				init_object(p, rand() & config->key_mask);
+		} else {
+			/* remaining pools copy keys from pool zero */
+			const struct object *p0 = objects.pools[0];
+			for (; p != end; ++p, ++p0)
+				init_object(p, p0->key);
+		}
+	}
+
+	return 0;
+}
+
+void grbtest_cleanup()
+{
+	BUG_ON(!objects.pools);
+
+	while (objects.pool_count--)
+		mem_free(objects.pools[objects.pool_count]);
+	mem_free(objects.pools);
+
+	memset(&objects, 0, sizeof(objects));
+	objects.pools	     = NULL;
+	objects.pool_count   = 0;
+	objects.object_count = 0;
+	objects.pool_size    = 0;
+}
+
+long reset_objects(unsigned int pool_count) {
+	unsigned i;
+
+	VALIDATE_PARAM(u, pool_count, pool_count <= objects.pool_count);
+
+	for (i = 0; i < pool_count; ++i) {
+		struct object *p = objects.pools[i];
+		struct object *end = &p[objects.object_count];
+
+		for (; p != end; ++p) {
+			grbtest_init_node(&p->node);
+		}
+	}
+
+	return 0;
+}
+
+long grbtest_run_test(
+		struct grbtest_config *config,
+		struct grbtest_result *result,
+		struct container *cont)
+{
+	grbtest_init_results(config, result);
+
+	switch (config->test) {
+		case GRBTEST_TYPE_INSERTION:
+			return grbtest_perftest(config, result, cont, 0);
+
+		case GRBTEST_TYPE_INSERTION_DELETION:
+			return grbtest_perftest(config, result, cont, 1);
+
+		case GRBTEST_TYPE_VALIDATE_INSERTIONS:
+			return grbtest_validate_insertion(config, result, cont);
+
+		default:
+			print_err("Invalid test specified");
+			return -1;
+	}
+}
+
+/* flatten needed for gcc 4.3.x, that otherwise fails to inline mytree_insert */
+__flatten
+long grbtest_perftest(
+		struct grbtest_config *config,
+		struct grbtest_result *result,
+		struct container *cont,
+		int do_deletes)
+{
+	u64 start_time, end_time;
+	struct object *p, *start, *evicted;
+	const struct object *end;
+	unsigned i;
+	unsigned pool = 0;
+
+	VALIDATE_PARAM(u, pool, pool < objects.pool_count);
+	VALIDATE_PARAM(u, config->object_count, config->object_count
+		<= objects.object_count);
+
+	start = objects.pools[pool];
+	end = &objects.pools[pool][config->object_count];
+
+	if (!do_deletes) {
+		/* profile insertions with cheap container purge */
+
+		start_time = getCurTicks();
+		for (i = 0; i < config->reps; ++i) {
+			init_container(cont);
+
+			for (p = start; p != end; ++p) {
+				if (mytree_insert(cont, p))
+					++result->evictions;
+			}
+		}
+
+		result->insertion_time += (u64)(getCurTicks() - start_time);
+		result->insertions += config->reps * config->object_count;
+	} else {
+		/* profile insertions & deletions */
+
+		for (i = 0; i < config->reps; ++i) {
+			init_container(cont);
+
+			/* populate tree */
+			start_time = getCurTicks();
+			for (p = start; p != end; ++p) {
+				if ((evicted = mytree_insert(cont, p))) {
+					evicted->node.rb_parent_color =
+						(unsigned long)&evicted->node;
+					++result->evictions;
+				}
+			}
+
+			end_time = getCurTicks();
+			result->insertion_time += (u64)(end_time - start_time);
+
+			/* remove items from tree */
+			start_time = end_time;
+			for (p = start; p != end; ++p) {
+				if (p->node.rb_parent_color !=
+						(unsigned long)&p->node) {
+					mytree_remove(cont, p);
+					++result->deletions;
+				}
+			}
+
+			end_time = getCurTicks();
+			result->deletion_time += (u64)(end_time - start_time);
+
+			/* tree should now be empty */
+			BUG_ON(cont->tree.rb_node != NULL);
+		}
+		result->insertions = config->reps * config->object_count;
+	}
+
+	return 0;
+}
+
+
+long grbtest_validate_insertion(
+		struct grbtest_config *config,
+		struct grbtest_result *result,
+		struct container *cont)
+{
+	struct object *p, *near;
+	struct object *start = objects.pools[0];
+	const struct object *end;
+	u64 start_time;
+	unsigned num_nodes;
+	unsigned pool = 0;
+
+	VALIDATE_PARAM(u, config->object_count, config->object_count
+		<= objects.object_count);
+	VALIDATE_PARAM(u, pool, pool < objects.pool_count);
+	/* currently ignored, pass zero for now */
+	VALIDATE_PARAM(u, config->reps, !config->reps);
+
+	start_time = getCurTicks();
+	for (num_nodes = 1; num_nodes <= config->object_count; ++num_nodes) {
+		end = &start[num_nodes];
+		init_container(cont);
+		reset_objects(1);
+
+		for (p = start; p != end; ++p) {
+			struct object *evicted = mytree_insert(cont, p);
+
+#if 0
+			if (evicted && (mytree_rel.flags & RB_UNIQUE_KEYS)
+				    && (mytree_rel.flags & RB_INSERT_REPLACES)) {
+#endif
+			if (evicted && GRBTEST_INSERT_REPLACES) {
+				++result->evictions;
+				grbtest_init_node(&evicted->node);
+			}
+		}
+
+		/* make sure we can find them */
+		for (p = start; p != end; ++p) {
+			struct object *found = mytree_find(cont, &p->key);
+
+			/* if the object is inserted, it should be there */
+			if (is_inserted(p)) {
+				BUG_ON(found != p);
+			/* otherwise, it was evicted and shouldn't be there */
+			} else {
+#if GRBTEST_BUILD_GENERIC
+				BUG_ON(!(mytree_rel.flags & RB_UNIQUE_KEYS));
+#else
+				BUG_ON(!GRBTEST_UNIQUE_KEYS);
+#endif
+				BUG_ON(found == p);
+			}
+		}
+
+		/* make sure we can find_near them */
+		for (near = start; near != end; ++near) {
+
+			/* we wont use a non-inserted object for a near search */
+			if (!is_inserted(near)) {
+#if GRBTEST_BUILD_GENERIC
+				BUG_ON(!(mytree_rel.flags & RB_UNIQUE_KEYS));
+#else
+				BUG_ON(!GRBTEST_UNIQUE_KEYS);
+#endif
+				continue;
+			}
+
+/* we're not doing find_near on hand-coded stuff */
+#if GRBTEST_BUILD_GENERIC
+			for (p = start; p != end; ++p) {
+				struct object *found =
+					mytree_find_near(near, &p->key);
+
+				if (is_inserted(p)) {
+					BUG_ON(found != p);
+				} else {
+					BUG_ON(!(mytree_rel.flags & RB_UNIQUE_KEYS));
+					BUG_ON(found == p);
+				}
+			}
+#endif /* GRBTEST_BUILD_GENERIC */
+		}
+
+		/* walk the tree and verify order using compare function */
+		for (near = start; near != end; ++near) {
+			// count objects
+			// count inserted objects using start -> end and make sure they match
+			// verify count field
+
+		}
+
+		/* now we'll delete them and make sure they are removed */
+		for (near = start; near != end; ++near) {
+
+		}
+
+	}
+	result->insertion_time += (u64)(getCurTicks() - start_time);
+
+	return 0;
+}
+
+
+/****************************************************************************
+ * Test result functions
+ */
+
+void grbtest_init_results(const struct grbtest_config *config,
+			  struct grbtest_result *result)
+{
+	memset(result, 0, sizeof(*result));
+	result->node_size   = sizeof(struct rb_node);
+	result->object_size = sizeof(struct object);
+	result->pool_size   = sizeof(struct object) * config->object_count;
+}
+
+void grbtest_print_result_header(const struct grbtest_config *config)
+{
+	const char *d = config->delimiter;
+	print_msg(
+		/* compile-time config */
+		"compiler%s"
+		"key_type%s"
+		"userland%s"
+		"use_generic%s"
+		"use_leftmost%s"
+		"use_rightmost%s"
+		"use_count%s"
+		"unique_keys%s"
+		"insert_replaces%s"
+		"use_augmented%s"
+		"debug%s"
+		"debug_validate%s"
+		"arch%s"
+		"arch_flags%s"
+		"processor%s"
+		"cc%s"
+		"cflags%s"
+
+		/* run-time config */
+		"test%s"
+		"in_seed%s"
+		"seed%s"
+		"key_mask%s"
+		"object_count%s"
+		"pool_count%s"
+		"reps%s"
+		/* fields human_readable, delimiter, text_enclosure
+		 * and print_header omited */
+
+		/* result */
+		"node_size%s"
+		"object_size%s"
+		"pool_size%s"
+		"insertions%s"
+		"insertion_time%s"
+		"evictions%s"
+		"deletions%s"
+		"deletion_time\n",
+		d, d, d, d, d, d, d, d, d, d, d, d, d, d, d, d, d, d, d, d, d,
+		d, d, d, d, d, d, d, d, d, d);
+}
+
+void grbtest_print_result_row(const struct grbtest_config *config,
+			      const struct grbtest_result *result)
+{
+	const char *d = config->delimiter;
+	const char *q = config->text_enclosure;
+
+	/* FIXME: Will formating u64 as "%llu" wont be correct on all
+	 * architectures?
+	 */
+	print_msg(/* compile-time config */
+		  "%s" GRBTEST_COMPILER "%s%s"
+		  "%s" strize(GRBTEST_KEY_TYPE) "%s%s"
+		  strize(GRBTEST_USERLAND) "%s"
+		  strize(GRBTEST_BUILD_GENERIC) "%s"
+		  strize(GRBTEST_USE_LEFTMOST) "%s"
+		  strize(GRBTEST_USE_RIGHTMOST) "%s"
+		  strize(GRBTEST_USE_COUNT) "%s"
+		  strize(GRBTEST_UNIQUE_KEYS) "%s"
+		  strize(GRBTEST_INSERT_REPLACES) "%s"
+		  strize(GRBTEST_USE_AUGMENTED) "%s"
+		  strize(config_enabled(CONFIG_DEBUG_RBTREE)) "%s"
+		  strize(config_enabled(CONFIG_DEBUG_RBTREE_VALIDATE)) "%s"
+		  "%s" strize(GRBTEST_ARCH) "%s%s"
+		  "%s" strize(GRBTEST_ARCH_FLAGS) "%s%s"
+		  "%s" strize(GRBTEST_PROCESSOR) "%s%s"
+		  "%s" strize(GRBTEST_CC) "%s%s"
+		  "%s" strize(GRBTEST_CFLAGS) "%s%s"
+
+		  /* run-time config */
+		  "%u%s"
+		  "%llu%s"
+		  "%llu%s"
+		  "%u%s"
+		  "%u%s"
+		  "%u%s"
+		  "%u%s"
+
+		  /* result */
+		  "%u%s"
+		  "%u%s"
+		  "%u%s"
+		  "%llu%s"
+		  "%llu%s"
+		  "%llu%s"
+		  "%llu%s"
+		  "%llu\n",
+
+		  q, q, d,
+		  q, q, d,
+		  d, d, d, d, d, d, d, d, d, d,
+		  q, q, d,
+		  q, q, d,
+		  q, q, d,
+		  q, q, d,
+		  q, q, d,
+		  config->test, d,
+		  (unsigned long long)config->in_seed, d,
+		  (unsigned long long)config->seed, d,
+		  config->key_mask, d,
+		  config->object_count, d,
+		  config->pool_count, d,
+		  config->reps, d,
+		  result->node_size, d,
+		  result->object_size, d,
+		  result->pool_size, d,
+		  (unsigned long long)result->insertions, d,
+		  (unsigned long long)result->insertion_time, d,
+		  (unsigned long long)result->evictions, d,
+		  (unsigned long long)result->deletions, d,
+		  (unsigned long long)result->deletion_time);
+}
+
+#if 0
+
+int retrieve_from_empty_container()
+{
+	return 0;
+}
+Requirements for Generic Red-Black Tree tests
+
+Correctness testing
+Input parameters
+max_nodes - maximum number of nodes to use for tests
+
+Create an array of max_nodes objects and initialize their keys to random values.
+Start from a tree with zero objects and perform lookups of non-existant objects (which should all return NULL).
+
+int num_nodes;
+int i;
+
+/* correctness tests */
+for (int num_nodes = 0; i < max_nodes; ++num_nodes) {
+	// clear tree
+	for (i = 0; i < num_nodes; ++ i) {
+		// insert nodes
+	}
+	// insert a node with an existing key and verify outcome
+	for (i = 0; i < num_nodes; ++i) {
+		// find object i and verify outcome
+		for (j = 0; j < num_nodes; ++j) {
+			// perform find_near starting at i, looking for j
+			// and verify outcome
+		}
+		// delete object i & verify
+		// re-insert object i & verify
+	}
+	for (i = 0; i < num_nodes; ++i) {
+		// delete node i
+		// search for node i and make sure we get nothing
+		// search for next node and make sure we get one
+	}
+	// verify that tree is empty
+
+	// insert node zero
+	for (i = 1; i < num_nodes; ++ i) {
+		// insert_near, using previous node as start
+	}
+	// verify tree
+
+	// repeat find tests above
+}
+
+/* performance tests */
+int reps;  /* number of times to repeat a test */
+for (int num_nodes = 0; i < max_nodes; ++num_nodes) {
+	for (rep = 0; rep < reps; ++rep) {
+		// clear tree
+		// get start time
+		for (i = 0; i < num_nodes; ++ i) {
+			// insert nodes
+		}
+		// get end time & add
+	}
+}
+// insertion test
+// insert near test (separate data for each size, for each node distance)
+// insert replace test
+// find test
+// find_near test (again, for each size, for each node distance)
+
+__attribute__((flatten))
+long run_test(unsigned int count) {
+	size_t buf_size = sizeof(struct object) * count;
+	struct container cont;
+	struct object *obj_pools[2];
+	struct object **tree_contents;
+	size_t pool_size;
+	int pool_in_use;
+	long i, j, k;
+	struct object *found;
+	struct rb_node *node;
+	long long start, end;
+
+	long long now = getCurTicks();
+
+	srand((now & 0xffffffff) ^ (now >> 32));
+
+	if (count < 1 || count > 0x1000000) { /* 16.8 million should be a reasonable limit */
+		return -1;
+	}
+
+	print_err("allocating two pools of %u objects each\n", count);
+
+	cont.tree      = RB_ROOT;
+	cont.count     = 0;
+	cont.leftmost  = 0;
+	cont.rightmost = 0;
+	pool_in_use      = 0;
+	obj_pools[0]     = (struct object *)malloc(buf_size);
+	obj_pools[1]     = (struct object *)malloc(buf_size);
+
+	fprintf(stderr, "initializing objects\n");
+
+	/* init a psudo-random using a real-random seed */
+//	get_random_bytes(&seed, sizeof(seed));
+//	prandom32_seed(&grbtest.rand, seed);
+
+	for (i = 0; i < 2; ++i) {
+		struct object *p = obj_pools[i];
+		struct object *end = &p[count];
+
+		for (; p != end; ++p) {
+			p->id = rand() & 0xfffff;
+			rb_init_node(&p->node);
+		}
+	}
+	pool_size = count;
+
+	for (j = 0; j < 2; ++j) {
+		struct object *pool = obj_pools[j];
+		start = getCurTicks();
+
+		for (i = count; i; ) {
+			struct object *new = &pool[--i];
+
+			mytree_insert(&cont, new);
+		}
+		pool_in_use ^= 1;
+		end = getCurTicks();
+		fprintf(stderr, "Inserted %u objects in %llu\n", count, end - start);
+	}
+
+	fprintf(stderr, "walking tree now...\n");
+	tree_contents = (struct object **)malloc(sizeof(void*) * cont.count);
+	start = getCurTicks();
+	for (i = 0, node = cont.leftmost; node; node = rb_next(node), ++i) {
+		tree_contents[i] = rb_entry(node, struct object, node);
+	}
+	end = getCurTicks();
+	fprintf(stderr, "Finished walking tree of %u in %llu\n", cont.count, end - start);
+
+	fprintf(stderr, "root = %p, count = %u\n", cont.tree.rb_node, cont.count);
+	//dumpNode(cont.tree.rb_node);
+
+	//dumpTree(&cont.tree, 16);
+	start = getCurTicks();
+#define NEAR_RANGE 8
+#if 0
+	for (i = 0; i < cont.count; ++i) {
+		for (j = 0; j < cont.count; ++j) {
+			found = mytree_find_near(tree_contents[i], &tree_contents[j]->id);
+			if (found != tree_contents[j]) {
+				fprintf(stderr, "find_near found %p near %p (expected %p)\n",
+					found, tree_contents[i], tree_contents[j]);
+				found = mytree_find_near(tree_contents[i], &tree_contents[j]->id);
+			}
+		}
+	}
+#else
+for (k = 0; k < 8; ++k) {
+	for (i = 0; i < cont.count; ++i) {
+		int max = i + NEAR_RANGE;
+		if (max > cont.count)
+			max = cont.count;
+		for (j = i > NEAR_RANGE ? i - NEAR_RANGE : 0;
+		     j < max; ++j) {
+			found = mytree_find_near(tree_contents[i], &tree_contents[j]->id);
+			if (found != tree_contents[j]) {
+				fprintf(stderr, "find_near found %p near %p (expected %p)\n",
+					found, tree_contents[i], tree_contents[j]);
+				found = mytree_find_near(tree_contents[i], &tree_contents[j]->id);
+			}
+		}
+	}
+}
+
+#endif
+	end = getCurTicks();
+	fprintf(stderr, "find_near duration = %llu\n", end - start);
+
+	start = getCurTicks();
+for (k = 0; k < 8; ++k) {
+	for (i = 0; i < cont.count; ++i) {
+		int max = i + NEAR_RANGE;
+		if (max > cont.count)
+			max = cont.count;
+		for (j = i > NEAR_RANGE ? i - NEAR_RANGE : 0;
+		     j < max; ++j) {
+			found = mytree_find(&cont, &tree_contents[j]->id);
+			if (found != tree_contents[j]) {
+				fprintf(stderr, "find_near found %p near %p (expected %p)\n",
+					found, tree_contents[i], tree_contents[j]);
+				found = mytree_find_near(tree_contents[i], &tree_contents[j]->id);
+			}
+		}
+	}
+}
+
+	end = getCurTicks();
+	fprintf(stderr, "find duration = %llu\n", end - start);
+
+	// cleanup
+
+	fprintf(stderr, "Forward iteration (%u objects)\n", cont.count);
+	for (node = cont.leftmost; node ; node = rb_next(node)) {
+		struct object *obj = (struct object *)__rb_node_to_obj(node, &mytree_rel);
+		//fprintf(stderr, "id = 0x%08x\n", obj->id);
+	}
+
+	fprintf(stderr, "Reverse iteration (%u objects)\n", cont.count);
+	for (node = cont.rightmost; node ; node = rb_prev(node)) {
+		struct object *obj = (struct object *)__rb_node_to_obj(node, &mytree_rel);
+		//fprintf(stderr, "id = 0x%08x\n", obj->id);
+	}
+
+
+	fprintf(stderr, "Starting cleanup, %u objects\n", cont.count);
+	while (cont.leftmost) {
+		struct object *obj = (struct object *)__rb_node_to_obj(cont.leftmost, &mytree_rel);
+		//fprintf(stderr, "Removing object at 0x%p id = 0x%04x\n", obj, obj->id);
+		mytree_remove(&cont, obj);
+		//--cont.count;
+	}
+
+	if(obj_pools[0]) {
+		free(obj_pools[0]);
+		free(obj_pools[1]);
+		obj_pools[0] = 0;
+		obj_pools[1] = 0;
+		free(tree_contents);
+	}
+	pool_in_use = 0;
+	cont.leftmost = 0;
+	cont.rightmost = 0;
+
+
+	fprintf(stderr, "Cleanup complete, %u objects left in container.\n", cont.count);
+
+	return 0;
+}
+#endif
diff --git a/tools/testing/selftests/grbtree/common.h b/tools/testing/selftests/grbtree/common.h
new file mode 100644
index 0000000..62cb5e2
--- /dev/null
+++ b/tools/testing/selftests/grbtree/common.h
@@ -0,0 +1,252 @@
+/* common.h - generic red-black tree test functions for use in both kernel and
+ * user space.
+ * Copyright (C) 2012  Daniel Santos <daniel.santos@pobox.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
+ */
+
+/**
+ * The following preprocessor variables should be defined to either 1 or 0 when
+ * compiling common.{c,h}
+ *
+ * GRBTEST_USERLAND		If non-zero, compile for userspace, kernelspace
+ * 				otherwise.
+ * GRBTEST_BUILD_GENERIC	If non-zero, use generic implementation,
+ * 				otherwise, use hand-coded implementation.
+ * GRBTEST_KEY_TYPE
+ * GRBTEST_USE_LEFTMOST		Maintain a pointer to the leftmost (smallest)
+ * 				in all insert & delete operations.
+ * GRBTEST_USE_RIGHTMOST	Same as above, except for rightmost (greatest)
+ * 				value
+ * GRBTEST_USE_COUNT		Maintain a count of objects in tree
+ * GRBTEST_UNIQUE_KEYS		If non-zero, tree contains only unique keys.
+ * GRBTEST_INSERT_REPLACES	Valid only if GRBTEST_UNIQUE_KEYS is non-zero.
+ * 				If non-zero, insert function will replace any
+ * 				existing object with the same key.
+ * GRBTEST_USE_AUGMENTED	Simulate an augmented tree (partially
+ * 				implemented)
+ */
+#ifndef _GRBTESTCOMMON_H
+#define _GRBTESTCOMMON_H
+
+#include <linux/rbtree.h>
+
+#ifndef GRBTEST_USERLAND
+# error GRBTEST_USERLAND not defined
+#endif
+#ifndef GRBTEST_BUILD_GENERIC
+# error GRBTEST_BUILD_GENERIC not defined
+#endif
+#ifndef GRBTEST_USE_LEFTMOST
+# error GRBTEST_USE_LEFTMOST not defined
+#endif
+#ifndef GRBTEST_KEY_TYPE
+# error GRBTEST_KEY_TYPE not defined
+#endif
+#ifndef GRBTEST_USE_RIGHTMOST
+# error GRBTEST_USE_RIGHTMOST not defined
+#endif
+#ifndef GRBTEST_USE_COUNT
+# error GRBTEST_USE_COUNT not defined
+#endif
+#ifndef GRBTEST_UNIQUE_KEYS
+# error GRBTEST_UNIQUE_KEYS not defined
+#endif
+#ifndef GRBTEST_INSERT_REPLACES
+# error GRBTEST_INSERT_REPLACES not defined
+#endif
+#ifndef GRBTEST_USE_AUGMENTED
+# error GRBTEST_INSERT_REPLACES not defined
+#endif
+
+#define strize(arg) strize2(arg)
+#define strize2(arg) #arg
+
+#ifdef __GNUC__
+# define GRBTEST_COMPILER "gcc-" \
+		strize(__GNUC__) "." \
+		strize(__GNUC_MINOR__) "." \
+		strize(__GNUC_PATCHLEVEL__)
+#else
+/* TODO: Add support for other compilers here */
+# define GRBTEST_COMPILER "non-gcc"
+#endif
+
+
+/**
+ * grbtest_config - Returns a string describing the build configuration.
+ */
+static inline const char *grbtest_config(void)
+{
+	return
+		"key type        " strize(GRBTEST_KEY_TYPE) "\n"
+#if GRBTEST_BUILD_GENERIC
+		"type            generic\n"
+#else
+		"type            hand-coded\n"
+#endif
+		"use leftmost    " strize(GRBTEST_USE_LEFTMOST) "\n"
+		"use rightmost   " strize(GRBTEST_USE_RIGHTMOST) "\n"
+		"use count       " strize(GRBTEST_USE_COUNT) "\n"
+		"unique keys     " strize(GRBTEST_UNIQUE_KEYS) "\n"
+		"insert replaces " strize(GRBTEST_INSERT_REPLACES) "\n"
+		"augmented       " strize(GRBTEST_USE_AUGMENTED) "\n"
+		"DEBUG_RBTREE    "
+		strize(config_enabled(CONFIG_DEBUG_RBTREE)) "\n"
+		"DEBUG_RBTREE_VALIDATE "
+		strize(config_enabled(CONFIG_DEBUG_RBTREE_VALIDATE)) "\n"
+		"CFLAGS          " strize(GRBTEST_CFLAGS) "\n"
+		"CC              " strize(GRBTEST_CC) "\n";
+
+}
+
+/* Functions provided by {module,user}/facilities.c for common.c */
+
+extern void facilities_init(void);
+extern u64 getCurTicks(void);
+extern void *rand_init(u64 *seed);
+
+//typedef unsigned int uint;
+
+
+#if GRBTEST_USERLAND
+#   define print_msg(...)	printf(__VA_ARGS__)
+#   define print_err(...)	fprintf(stderr, __VA_ARGS__)
+
+static inline void *mem_alloc(size_t size)	{return malloc(size);}
+static inline void mem_free(void *ptr)		{return free(ptr);}
+static inline u32 rand_get(void *state) 	{return rand();}
+static inline void rand_free(void *state)	{}
+
+#else /* GRBTEST_USERLAND */
+
+#    define print_msg(...) printk("grbtest: " __VA_ARGS__)
+#    define print_err(...) printk(KERN_ALERT "grbtest: " __VA_ARGS__)
+
+static inline void *mem_alloc(size_t size) {return kzalloc(size, GFP_KERNEL);}
+static inline void mem_free(void *ptr)	   {return kfree(ptr);}
+static inline u32 rand_get(struct rnd_state *state) {return prandom32(state);}
+static inline void rand_free(struct rnd_state *state) {kzfree(state);}
+
+#endif
+
+/****************************************************************************
+ * Structures
+ */
+
+struct object {
+	struct rb_node node;
+	GRBTEST_KEY_TYPE key;
+};
+
+struct container {
+	struct rb_root	tree;
+	unsigned int	count;
+	struct rb_node	*leftmost;
+	struct rb_node	*rightmost;
+	unsigned int	pool_in_use;
+};
+
+struct object_pools {
+	struct object	**pools;
+	unsigned int	pool_count;	/**< number of pools */
+	unsigned int	object_count;	/**< num objects in each pool */
+	size_t		pool_size;	/**< size of each pool in bytes */
+};
+
+enum grbtest_type {
+	GRBTEST_TYPE_INSERTION,
+	GRBTEST_TYPE_INSERTION_DELETION,
+	GRBTEST_TYPE_VALIDATE_INSERTIONS,
+	GRBTEST_TYPE_COUNT
+};
+
+extern const char *grbtest_type_desc[GRBTEST_TYPE_COUNT];
+
+struct grbtest_config {
+	enum grbtest_type test;
+	u64		  in_seed;
+	u64		  seed;
+	u32		  key_mask;
+	unsigned	  object_count;
+	unsigned	  pool_count;
+	unsigned	  reps;
+	int		  human_readable;
+	char		 *delimiter;
+	char		 *text_enclosure;
+	int		  print_header;
+};
+
+struct grbtest_result {
+	unsigned	node_size;
+	unsigned	object_size;
+	unsigned	pool_size;
+	u64		insertions;
+	u64		insertion_time;
+	u64		evictions;
+	u64		deletions;
+	u64		deletion_time;
+};
+
+/****************************************************************************
+ * Global data
+ */
+
+extern struct object_pools objects;
+
+
+static void inline init_container(struct container *cont)
+{
+	cont->tree	= RB_ROOT;
+	cont->count	= 0;
+	cont->leftmost	= 0;
+	cont->rightmost	= 0;
+}
+
+static void inline init_object(struct object *obj, GRBTEST_KEY_TYPE key)
+{
+	rb_init_node(&obj->node);
+	obj->key = key;
+}
+
+static int inline is_inserted(struct object *obj)
+{
+	return rb_parent(&obj->node) != &obj->node;
+}
+
+/* exported by common.c */
+extern long grbtest_init(struct grbtest_config *config);
+extern void grbtest_cleanup(void);
+extern long grbtest_run_test(
+		struct grbtest_config *config,
+		struct grbtest_result *result,
+		struct container *cont);
+extern long grbtest_perftest(
+		struct grbtest_config *config,
+		struct grbtest_result *result,
+		struct container *cont,
+		int do_deletes);
+extern long grbtest_validate_insertion(
+		struct grbtest_config *config,
+		struct grbtest_result *result,
+		struct container *cont);
+
+extern void grbtest_init_results(const struct grbtest_config *config,
+				 struct grbtest_result *result);
+extern void grbtest_print_result_header(const struct grbtest_config *config);
+extern void grbtest_print_result_row(const struct grbtest_config *config,
+				     const struct grbtest_result *result);
+
+#endif /* _GRBTESTCOMMON_H */
-- 
1.7.3.4

