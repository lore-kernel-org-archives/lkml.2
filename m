Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030282Ab2I1XtN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 19:49:13 -0400
Received: from nm1.bullet.mail.bf1.yahoo.com ([98.139.212.160]:46285 "HELO
	nm1.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S964855Ab2I1XtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 19:49:08 -0400
X-Yahoo-Newman-Id: 103267.40552.bm@smtp101.sbc.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 6dIN2rMVM1mWuwvprrvh2Myf5YwLL_rlTYlCRRAfp8AmR3y
 zW..thTPQU.Dhko1ockuIXkXxJEnyOyp2Ey.uzV6rkkBXMfNr02YpLySavOR
 1znAoqcGHTRvN8njoVq6ksHXRLWqX0YCPA459tsEweDcVIWM68ZIR8ugRAFS
 v07wSfV_WwclGoo.NnAjI.09ujDbNhSRsKxDaoaa31ufKNMQFAyBWSje4VOH
 xWIMF1e5R_KMtln9pHfvyM3a7o31NTaaC_ZWyDGjJtl2AcVzRTFmX9b_WqqN
 MprbjUp.MsGsI6T6ajGyUAU.q_yzFxJaaw5LWzGnBkoHi94k6g_jzsxdvU9H
 BZbYPOww0oFUHzelBOcZZR6gC0jXsYiBzrsr5fBoljomJmPYVETHPSPYnXIv
 gLQFeCzI2cf4hGy2fgyAzVe_wwoILICXJ86ZUi06zGQoUdh9NnXSpgg--
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
Subject: [PATCH v6 6/10] selftest: Add generic tree self-test common code.
Date: Fri, 28 Sep 2012 18:48:42 -0500
Message-Id: <1348876126-28792-1-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1348875625-28669-1-git-send-email-daniel.santos@pobox.com>
References: <1348875625-28669-1-git-send-email-daniel.santos@pobox.com>
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
 tools/testing/selftests/grbtree/common.c |  892 ++++++++++++++++++++++++++++++
 tools/testing/selftests/grbtree/common.h |  293 ++++++++++
 2 files changed, 1185 insertions(+), 0 deletions(-)
 create mode 100644 tools/testing/selftests/grbtree/common.c
 create mode 100644 tools/testing/selftests/grbtree/common.h

diff --git a/tools/testing/selftests/grbtree/common.c b/tools/testing/selftests/grbtree/common.c
new file mode 100644
index 0000000..f5383be
--- /dev/null
+++ b/tools/testing/selftests/grbtree/common.c
@@ -0,0 +1,892 @@
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
+static inline long compare_s8(const s8 *a, const s8 *b) {return *a - *b;}
+static inline long greater_s8(const s8 *a, const s8 *b) {return *a > *b;}
+
+static inline long compare_u8(const u8 *a, const u8 *b) {return (long)*a - (long)*b;}
+static inline long greater_u8(const u8 *a, const u8 *b) {return *a > *b;}
+
+static inline long compare_s16(const s16 *a, const s16 *b) {return *a - *b;}
+static inline long greater_s16(const s16 *a, const s16 *b) {return *a > *b;}
+
+static inline long compare_u16(const u16 *a, const u16 *b) {return (long)*a - (long)*b;}
+static inline long greater_u16(const u16 *a, const u16 *b) {return *a > *b;}
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
+static __always_inline struct object *mytree_find(struct container *cont, GRBTEST_KEY_TYPE *key)
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
+static __always_inline struct object *mytree_insert(struct container *cont,
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
+		return container_of(found, struct object, node);
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
+	return NULL;
+}
+
+static __always_inline void mytree_remove(struct container *cont, struct object *obj)
+{
+	struct rb_node *node = &obj->node;
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
+					evicted->node.__rb_parent_color =
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
+				if (p->node.__rb_parent_color !=
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
+	/* compile-time config */
+	print_msg("compiler%s",		d);
+	print_msg("key_type%s",		d);
+	print_msg("payload%s",		d);
+	print_msg("userland%s",		d);
+	print_msg("use_generic%s",	d);
+	print_msg("use_leftmost%s",	d);
+	print_msg("use_rightmost%s",	d);
+	print_msg("use_count%s",	d);
+	print_msg("unique_keys%s",	d);
+	print_msg("insert_replaces%s",	d);
+	print_msg("debug%s",		d);
+	print_msg("debug_validate%s",	d);
+	print_msg("arch%s",		d);
+	print_msg("arch_flags%s",	d);
+	print_msg("processor%s",	d);
+	print_msg("cc%s",		d);
+	print_msg("cflags%s",		d);
+
+	/* run-time config */
+	print_msg("test%s",		d);
+	print_msg("in_seed%s",		d);
+	print_msg("seed%s",		d);
+	print_msg("key_mask%s",		d);
+	print_msg("object_count%s",	d);
+	print_msg("pool_count%s",	d);
+	print_msg("reps%s",		d);
+	/* fields human_readable, delimiter, text_enclosure
+	 * and print_header omited */
+
+	/* result */
+	print_msg("node_size%s",	d);
+	print_msg("object_size%s",	d);
+	print_msg("pool_size%s",	d);
+	print_msg("insertions%s",	d);
+	print_msg("insertion_time%s",	d);
+	print_msg("evictions%s",	d);
+	print_msg("deletions%s",	d);
+	print_msg("deletion_time\n");
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
+	/* compile-time config */
+	print_msg("%s" GRBTEST_COMPILER "%s%s",			q, q, d);
+	print_msg("%s" __stringify(GRBTEST_KEY_TYPE) "%s%s",	q, q, d);
+	print_msg(__stringify(GRBTEST_PAYLOAD) "%s",		d);
+	print_msg(__stringify(GRBTEST_USERLAND) "%s",		d);
+	print_msg(__stringify(GRBTEST_BUILD_GENERIC) "%s",	d);
+	print_msg(__stringify(GRBTEST_USE_LEFTMOST) "%s",	d);
+	print_msg(__stringify(GRBTEST_USE_RIGHTMOST) "%s",	d);
+	print_msg(__stringify(GRBTEST_USE_COUNT) "%s",		d);
+	print_msg(__stringify(GRBTEST_UNIQUE_KEYS) "%s",	d);
+	print_msg(__stringify(GRBTEST_INSERT_REPLACES) "%s",	d);
+	print_msg(__stringify(config_enabled(CONFIG_DEBUG_GRBTREE)) "%s",		d);
+	print_msg(__stringify(config_enabled(CONFIG_DEBUG_GRBTREE_VALIDATE)) "%s",	d);
+	print_msg("%s" __stringify(GRBTEST_ARCH) "%s%s",	q, q, d);
+	print_msg("%s" __stringify(GRBTEST_ARCH_FLAGS) "%s%s",	q, q, d);
+	print_msg("%s" __stringify(GRBTEST_PROCESSOR) "%s%s",	q, q, d);
+	print_msg("%s" __stringify(GRBTEST_CC) "%s%s",		q, q, d);
+	print_msg("%s" __stringify(GRBTEST_CFLAGS) "%s%s",	q, q, d);
+
+	/* run-time config */
+	print_msg("%u%s",	config->test, d);
+	print_msg("%llu%s",	(unsigned long long)config->in_seed, d);
+	print_msg("%llu%s",	(unsigned long long)config->seed, d);
+	print_msg("%u%s",	config->key_mask, d);
+	print_msg("%u%s",	config->object_count, d);
+	print_msg("%u%s",	config->pool_count, d);
+	print_msg("%u%s",	config->reps, d);
+
+	/* result */
+	print_msg("%u%s",	result->node_size, d);
+	print_msg("%u%s",	result->object_size, d);
+	print_msg("%u%s",	result->pool_size, d);
+	print_msg("%llu%s",	(unsigned long long)result->insertions, d);
+	print_msg("%llu%s",	(unsigned long long)result->insertion_time, d);
+	print_msg("%llu%s",	(unsigned long long)result->evictions, d);
+	print_msg("%llu%s",	(unsigned long long)result->deletions, d);
+	print_msg("%llu\n",	(unsigned long long)result->deletion_time);
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
index 0000000..8a23dcc
--- /dev/null
+++ b/tools/testing/selftests/grbtree/common.h
@@ -0,0 +1,293 @@
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
+ * GRBTEST_KEY_TYPE		FIXME: doc me
+ * GRBTEST_PAYLOAD		FIXME: doc me
+ * GRBTEST_USERLAND		If non-zero, compile for userspace, kernelspace
+ * 				otherwise.
+ * GRBTEST_BUILD_GENERIC	If non-zero, use generic implementation,
+ * 				otherwise, use hand-coded implementation.
+ * GRBTEST_USE_LEFTMOST		Maintain a pointer to the leftmost (smallest)
+ * 				in all insert & delete operations.
+ * GRBTEST_USE_RIGHTMOST	Same as above, except for rightmost (greatest)
+ * 				value
+ * GRBTEST_USE_COUNT		Maintain a count of objects in tree
+ * GRBTEST_UNIQUE_KEYS		If non-zero, tree contains only unique keys.
+ * GRBTEST_INSERT_REPLACES	Valid only if GRBTEST_UNIQUE_KEYS is non-zero.
+ * 				If non-zero, insert function will replace any
+ * 				existing object with the same key.
+ *
+ * The following preprocessor variables are generated automatically, either by the Makefile, the kernel's .config or in this header:
+ *
+ * GRBTEST_COMPILER
+ * CONFIG_DEBUG_RBTREE
+ * CONFIG_DEBUG_RBTREE_VALIDATE
+ * GRBTEST_CFLAGS
+ * GRBTEST_CC
+ */
+#ifndef _GRBTESTCOMMON_H
+#define _GRBTESTCOMMON_H
+
+#include <linux/rbtree.h>
+#include <linux/stringify.h>
+
+#ifndef GRBTEST_KEY_TYPE
+# error GRBTEST_KEY_TYPE not defined
+#endif
+#ifndef GRBTEST_PAYLOAD
+# error GRBTEST_PAYLOAD not defined
+#endif
+#ifndef GRBTEST_USERLAND
+# error GRBTEST_USERLAND not defined
+#endif
+#ifndef GRBTEST_BUILD_GENERIC
+# error GRBTEST_BUILD_GENERIC not defined
+#endif
+#ifndef GRBTEST_USE_LEFTMOST
+# error GRBTEST_USE_LEFTMOST not defined
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
+
+#if 0
+#ifndef GRBTEST_COL_DELIMITER_STR
+# define GRBTEST_COL_DELIMITER_STR ","
+#endif
+#ifndef GRBTEST_ROW_DELIMITER_STR
+# define GRBTEST_ROW_DELIMITER_STR "\n"
+#endif
+#ifndef GRBTEST_OPEN_QUOTE_STR
+# define GRBTEST_OPEN_QUOTE_STR ""
+#endif
+#ifndef GRBTEST_CLOSE_QUOTE_STR
+# define GRBTEST_CLOSE_QUOTE_STR ""
+#endif
+#endif
+
+#ifdef __GNUC__
+# define GCC_VERSION_STR			\
+		__stringify(__GNUC__) "."	\
+		__stringify(__GNUC_MINOR__) "."	\
+		__stringify(__GNUC_PATCHLEVEL__)
+# ifdef __INTEL_COMPILER
+#  define GRBTEST_COMPILER "intel "		\
+		__stringify(__INTEL_COMPILER)	\
+		" (gcc-" GCC_VERSION_STR ")"
+# else
+#  define GRBTEST_COMPILER "gcc-" GCC_VERSION_STR
+# endif
+#else
+/* NOTE: Add support for other compilers here */
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
+		"compiler        " GRBTEST_COMPILER "\n"
+#if GRBTEST_BUILD_GENERIC
+		"type            generic\n"
+#else
+		"type            hand-coded\n"
+#endif
+		"key type        " __stringify(GRBTEST_KEY_TYPE) "\n"
+		"payload         char[" __stringify(GRBTEST_PAYLOAD) "]\n"
+		"use leftmost    " __stringify(GRBTEST_USE_LEFTMOST) "\n"
+		"use rightmost   " __stringify(GRBTEST_USE_RIGHTMOST) "\n"
+		"use count       " __stringify(GRBTEST_USE_COUNT) "\n"
+		"unique keys     " __stringify(GRBTEST_UNIQUE_KEYS) "\n"
+		"insert replaces " __stringify(GRBTEST_INSERT_REPLACES) "\n"
+		__stringify(config_enabled(CONFIG_DEBUG_GRBTREE)) "\n"
+		"DEBUG_RBTREE_VALIDATE "
+		__stringify(config_enabled(CONFIG_DEBUG_GRBTREE_VALIDATE)) "\n"
+		"CFLAGS          " __stringify(GRBTEST_CFLAGS) "\n"
+		"CC              " __stringify(GRBTEST_CC) "\n";
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
+	struct rb_node	node;
+	GRBTEST_KEY_TYPE key;
+	unsigned char	payload[GRBTEST_PAYLOAD];
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
+static inline void grbtest_init_node(struct rb_node *node)
+{
+	node->__rb_parent_color = (unsigned long)node;
+	node->rb_right = NULL;
+	node->rb_left = NULL;
+}
+
+static inline int grbtest_node_is_clear(const struct rb_node *node)
+{
+	return (node->__rb_parent_color == (unsigned long)node)
+	       && (node->rb_right == NULL)
+	       && (node->rb_left == NULL);
+}
+
+static inline void init_object(struct object *obj, GRBTEST_KEY_TYPE key)
+{
+	grbtest_init_node(&obj->node);
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

