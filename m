Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050Ab1JTOuo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 10:50:44 -0400
Received: from mort.rzone.de ([81.169.144.234]:64266 "EHLO mort.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752950Ab1JTOum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 10:50:42 -0400
From: Arne Jansen <sensille@gmx.net>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: [PATCH] ulist: generic data structure to build unique lists
Date: Thu, 20 Oct 2011 16:50:41 +0200
Message-Id: <1319122241-7222-1-git-send-email-sensille@gmx.net>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ulist is a generic data structure to hold a collection of unique u64
values. The only operations it supports is adding to the list and
enumerating it.
It is possible to store an auxiliary value along with the key.
The implementation is preliminary and can probably be sped up
significantly.
It is used by btrfs subvolume quota to translate recursions into iterative
loops.

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 include/linux/ulist.h |   68 +++++++++++++++
 lib/Makefile          |    2 +-
 lib/ulist.c           |  220 +++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 289 insertions(+), 1 deletions(-)

diff --git a/include/linux/ulist.h b/include/linux/ulist.h
new file mode 100644
index 0000000..2e25dec
--- /dev/null
+++ b/include/linux/ulist.h
@@ -0,0 +1,68 @@
+/*
+ * Copyright (C) 2011 STRATO AG
+ * written by Arne Jansen <sensille@gmx.net>
+ * Distributed under the GNU GPL license version 2.
+ *
+ */
+
+#ifndef __ULIST__
+#define __ULIST__
+
+/*
+ * ulist is a generic data structure to hold a collection of unique u64
+ * values. The only operations it supports is adding to the list and
+ * enumerating it.
+ * It is possible to store an auxiliary value along with the key.
+ *
+ * The implementation is preliminary and can probably be sped up
+ * significantly. A first step would be to store the values in an rbtree
+ * as soon as ULIST_SIZE is exceeded.
+ */
+
+/*
+ * number of elements statically allocated inside struct ulist
+ */
+#define ULIST_SIZE 16
+
+/*
+ * element of the list
+ */
+struct ulist_node {
+	u64 val;		/* value to store */
+	unsigned long aux;	/* auxiliary value saved along with the val */
+};
+
+struct ulist {
+	/*
+	 * number of elements stored in list
+	 */
+	unsigned long nnodes;
+
+	/*
+	 * number of nodes we already have room for
+	 */
+	unsigned long nodes_alloced;
+
+	/*
+	 * pointer to the array storing the elements. The first ULIST_SIZE
+	 * elements are stored inline. In this case the it points to int_nodes.
+	 * After exceeding ULIST_SIZE, dynamic memory is allocated.
+	 */
+	struct ulist_node *nodes;
+
+	/*
+	 * inline storage space for the first ULIST_SIZE entries
+	 */
+	struct ulist_node int_nodes[ULIST_SIZE];
+};
+
+void ulist_init(struct ulist *ulist);
+void ulist_fini(struct ulist *ulist);
+void ulist_reinit(struct ulist *ulist);
+struct ulist *ulist_alloc(unsigned long gfp_mask);
+void ulist_free(struct ulist *ulist);
+int ulist_add(struct ulist *ulist, u64 val, unsigned long aux,
+	      unsigned long gfp_mask);
+struct ulist_node *ulist_next(struct ulist *ulist, struct ulist_node *prev);
+
+#endif
diff --git a/lib/Makefile b/lib/Makefile
index 3f5bc6d..3f1a1b6 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -22,7 +22,7 @@ lib-y	+= kobject.o kref.o klist.o
 obj-y += bcd.o div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
 	 bust_spinlocks.o hexdump.o kasprintf.o bitmap.o scatterlist.o \
 	 string_helpers.o gcd.o lcm.o list_sort.o uuid.o flex_array.o \
-	 bsearch.o find_last_bit.o find_next_bit.o
+	 bsearch.o find_last_bit.o find_next_bit.o ulist.o
 obj-y += kstrtox.o
 obj-$(CONFIG_TEST_KSTRTOX) += test-kstrtox.o
 
diff --git a/lib/ulist.c b/lib/ulist.c
new file mode 100644
index 0000000..2dd615b
--- /dev/null
+++ b/lib/ulist.c
@@ -0,0 +1,220 @@
+/*
+ * Copyright (C) 2011 STRATO AG
+ * written by Arne Jansen <sensille@gmx.net>
+ * Distributed under the GNU GPL license version 2.
+ */
+
+#include <linux/slab.h>
+#include <linux/ulist.h>
+#include <linux/module.h>
+
+/*
+ * ulist is a generic data structure to hold a collection of unique u64
+ * values. The only operations it supports is adding to the list and
+ * enumerating it.
+ * It is possible to store an auxiliary value along with the key.
+ *
+ * The implementation is preliminary and can probably be sped up
+ * significantly. A first step would be to store the values in an rbtree
+ * as soon as ULIST_SIZE is exceeded.
+ *
+ * A sample usage for ulists is the enumeration of directed graphs without
+ * visiting a node twice. The pseudo-code could look like this:
+ *
+ * ulist = ulist_alloc();
+ * ulist_add(ulist, root);
+ * elem = NULL;
+ *
+ * while ((elem = ulist_next(ulist, elem)) {
+ * 	for (all child nodes n in elem)
+ *		ulist_add(ulist, n);
+ *	do something useful with the node;
+ * }
+ * ulist_free(ulist);
+ *
+ * This assumes the graph nodes are adressable by u64. This stems from the
+ * usage for tree enumeration in btrfs, where the logical addresses are
+ * 64 bit.
+ *
+ * It is also useful for tree enumeration which could be done elegantly
+ * recursively, but is not possible due to kernel stack limitations. The
+ * loop would be similar to the above.
+ */
+
+/**
+ * ulist_init - freshly initialize a ulist
+ * @ulist:	the ulist to initialize
+ *
+ * Note: don't use this function to init an already used ulist, use
+ * ulist_reinit instead.
+ */
+void ulist_init(struct ulist *ulist)
+{
+	ulist->nnodes = 0;
+	ulist->nodes = ulist->int_nodes;
+	ulist->nodes_alloced = ULIST_SIZE;
+}
+EXPORT_SYMBOL(ulist_init);
+
+/**
+ * ulist_fini - free up additionally allocated memory for the ulist
+ * @ulist:	the ulist from which to free the additional memory
+ *
+ * This is useful in cases where the base 'struct ulist' has been statically
+ * allocated.
+ */
+void ulist_fini(struct ulist *ulist)
+{
+	/*
+	 * The first ULIST_SIZE elements are stored inline in struct ulist.
+	 * Only if more elements are alocated they need to be freed.
+	 */
+	if (ulist->nodes_alloced > ULIST_SIZE)
+		kfree(ulist->nodes);
+	ulist->nodes_alloced = 0;	/* in case ulist_fini is called twice */
+}
+EXPORT_SYMBOL(ulist_fini);
+
+/**
+ * ulist_reinit - prepare a ulist for reuse
+ * @ulist:	ulist to be reused
+ *
+ * Free up all additional memory allocated for the list elements and reinit
+ * the ulist.
+ */
+void ulist_reinit(struct ulist *ulist)
+{
+	ulist_fini(ulist);
+	ulist_init(ulist);
+}
+EXPORT_SYMBOL(ulist_reinit);
+
+/**
+ * ulist_alloc - dynamically allocate a ulist
+ * @gfp_mask:	allocation flags to for base allocation
+ *
+ * The allocated ulist will be returned in an initialized state.
+ */
+struct ulist *ulist_alloc(unsigned long gfp_mask)
+{
+	struct ulist *ulist = kmalloc(sizeof(*ulist), gfp_mask);
+
+	if (!ulist)
+		return NULL;
+
+	ulist_init(ulist);
+
+	return ulist;
+}
+EXPORT_SYMBOL(ulist_alloc);
+
+/**
+ * ulist_free - free dynamically allocated ulist
+ * @ulist:	ulist to free
+ *
+ * It is not necessary to call ulist_fini before.
+ */
+void ulist_free(struct ulist *ulist)
+{
+	if (!ulist)
+		return;
+	ulist_fini(ulist);
+	kfree(ulist);
+}
+EXPORT_SYMBOL(ulist_free);
+
+/**
+ * ulist_add - add an element to the ulist
+ * @ulist:	ulist to add the element to
+ * @val:	value to add to ulist
+ * @aux:	auxiliary value to store along with val
+ * @gfp_mask:	flags to use for allocation
+ *
+ * Note: locking must be provided by the caller. In case of rwlocks write
+ *       locking is needed
+ *
+ * Add an element to a ulist. The @val will only be added if it doesn't
+ * already exist. If it is added, the auxiliary value @aux is stored along with
+ * it. In case @val already exists in the ulist, @aux is ignored, even if
+ * it differs from the already stored value.
+ *
+ * ulist_add returns 0 if @val already exists in ulist and 1 if @val has been
+ * inserted.
+ * In case of allocation failure -ENOMEM is returned and the ulist stays
+ * unaltered.
+ */
+int ulist_add(struct ulist *ulist, u64 val, unsigned long aux,
+	      unsigned long gfp_mask)
+{
+	int i;
+
+	for (i = 0; i < ulist->nnodes; ++i) {
+		if (ulist->nodes[i].val == val)
+			return 0;
+	}
+
+	if (ulist->nnodes >= ulist->nodes_alloced) {
+		u64 new_alloced = ulist->nodes_alloced + 128;
+		struct ulist_node *new_nodes;
+		void *old = NULL;
+
+		/*
+		 * if nodes_alloced == ULIST_SIZE no memory has been allocated
+		 * yet, so pass NULL to krealloc
+		 */
+		if (ulist->nodes_alloced > ULIST_SIZE)
+			old = ulist->nodes;
+
+		new_nodes = krealloc(old, sizeof(*new_nodes) * new_alloced,
+				     gfp_mask);
+		if (!new_nodes)
+			return -ENOMEM;
+
+		if (!old)
+			memcpy(new_nodes, ulist->int_nodes,
+			       sizeof(ulist->int_nodes));
+
+		ulist->nodes = new_nodes;
+		ulist->nodes_alloced = new_alloced;
+	}
+	ulist->nodes[ulist->nnodes].val = val;
+	ulist->nodes[ulist->nnodes].aux = aux;
+	++ulist->nnodes;
+
+	return 1;
+}
+EXPORT_SYMBOL(ulist_add);
+
+/**
+ * ulist_next - iterate ulist
+ * @ulist:	ulist to iterate
+ * @prev:	previously returned element or %NULL to start iteration
+ *
+ * Note: locking must be provided by the caller. In case of rwlocks only read
+ *       locking is needed
+ *
+ * This function is used to iterate an ulist. The iteration is started with
+ * @prev = %NULL. It returns the next element from the ulist or %NULL when the
+ * end is reached. No guarantee is made with respect to the order in which
+ * the elements are returned. They might neither be returned in order of
+ * addition nor in ascending order.
+ * It is allowed to call ulist_add during an enumeration. Newly added items
+ * are guaranteed to show up in the running enumeration.
+ */
+struct ulist_node *ulist_next(struct ulist *ulist, struct ulist_node *prev)
+{
+	int next;
+
+	if (ulist->nnodes == 0)
+		return NULL;
+
+	if (!prev)
+		return &ulist->nodes[0];
+
+	next = (prev - ulist->nodes) + 1;
+	if (next < 0 || next >= ulist->nnodes)
+		return NULL;
+
+	return &ulist->nodes[next];
+}
+EXPORT_SYMBOL(ulist_next);
-- 
1.7.3.4

