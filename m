Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214Ab1JJJbZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 05:31:25 -0400
Received: from mort.rzone.de ([81.169.144.234]:23050 "EHLO mort.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753097Ab1JJJbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 05:31:24 -0400
X-Greylist: delayed 558 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Oct 2011 05:31:24 EDT
From: Arne Jansen <sensille@gmx.net>
To: linux-kernel@vger.kernel.org
Subject: [RFC PATCH] ulist: generic data structure to build unique lists
Date: Mon, 10 Oct 2011 11:22:05 +0200
Message-Id: <1318238525-28879-1-git-send-email-sensille@gmx.net>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ulist is a generic data structures to hold a collection of unique u64
values. The only operations it supports is adding to the list and
enumerating it.

It is possible to store an auxiliary value along with the key.
The implementation is preliminary and can probably be sped up
significantly.
The main purpose of this submission is to get some idea whether this
data structure is worth having generally available.

It is used by btrfs subvolume quota to translate recursions into iterative
loops and to gather a unique list of roots. Once I had built this data
structure, several uses for it popped up.

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 include/linux/ulist.h |   46 ++++++++++++++++++++++
 lib/ulist.c           |  103 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 149 insertions(+), 0 deletions(-)

diff --git a/include/linux/ulist.h b/include/linux/ulist.h
new file mode 100644
index 0000000..ebba91a
--- /dev/null
+++ b/include/linux/ulist.h
@@ -0,0 +1,46 @@
+/*
+ * Copyright (C) 2011 STRATO AG
+ * written by Arne Jansen <sensille@gmx.net>
+ * Distributed under the GNU GPL license version 2.
+ *
+ * ulist is a generic data structures to hold a collection of unique u64
+ * values. The only operations it supports is adding to the list and
+ * enumerating it.
+ * It is possible to store an auxiliary value along with the key.
+ *
+ * The implementation is preliminary and can probably be sped up
+ * significantly. A first step would be to store the values in an rbtree
+ * as soon as ULIST_SIZE is exceeded.
+ */
+
+#ifndef __ULIST__
+#define __ULIST__
+
+#define ULIST_SIZE 16
+
+struct ulist_node {
+	u64 val;
+	unsigned long aux;
+	unsigned long next;
+};
+
+struct ulist {
+	unsigned long nnodes;
+	unsigned long gfp_mask;
+	struct ulist_node *nodes;
+	unsigned long nodes_alloced;
+	struct ulist_node int_nodes[ULIST_SIZE];
+};
+
+void ulist_init(struct ulist *ulist, unsigned long gfp_mask);
+void ulist_fini(struct ulist *ulist);
+void ulist_reinit(struct ulist *ulist);
+struct ulist *ulist_alloc(unsigned long gfp_mask);
+void ulist_free(struct ulist *ulist);
+
+/* returns < 0 on error, 0 on duplicate, 1 on insert */
+int ulist_add(struct ulist *ulist, u64 val, unsigned long aux);
+
+struct ulist_node *ulist_next(struct ulist *ulist, struct ulist_node *prev);
+
+#endif
diff --git a/lib/ulist.c b/lib/ulist.c
new file mode 100644
index 0000000..641a90f
--- /dev/null
+++ b/lib/ulist.c
@@ -0,0 +1,103 @@
+/*
+ * Copyright (C) 2011 STRATO AG
+ * written by Arne Jansen <sensille@gmx.net>
+ * Distributed under the GNU GPL license version 2.
+ *
+ * ulist is a generic data structures to hold a collection of unique u64
+ * values. The only operations it supports is adding to the list and
+ * enumerating it.
+ * It is possible to store an auxiliary value along with the key.
+ *
+ * The implementation is preliminary and can probably be sped up
+ * significantly. A first step would be to store the values in an rbtree
+ * as soon as ULIST_SIZE is exceeded.
+ */
+
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/ulist.h>
+
+void ulist_init(struct ulist *ulist, unsigned long gfp_mask)
+{
+	ulist->nnodes = 0;
+	ulist->gfp_mask = gfp_mask;
+	ulist->nodes = ulist->int_nodes;
+	ulist->nodes_alloced = ULIST_SIZE;
+}
+
+void ulist_fini(struct ulist *ulist)
+{
+	if (ulist->nodes_alloced > ULIST_SIZE)
+		kfree(ulist->nodes);
+}
+
+void ulist_reinit(struct ulist *ulist)
+{
+	ulist_fini(ulist);
+	ulist_init(ulist, ulist->gfp_mask);
+}
+
+struct ulist *ulist_alloc(unsigned long gfp_mask)
+{
+	struct ulist *ulist = kmalloc(sizeof(*ulist), gfp_mask);
+
+	if (!ulist)
+		return NULL;
+
+	ulist_init(ulist, gfp_mask);
+
+	return ulist;
+}
+
+void ulist_free(struct ulist *ulist)
+{
+	if (!ulist)
+		return;
+	ulist_fini(ulist);
+	kfree(ulist);
+}
+
+int ulist_add(struct ulist *ulist, u64 val, unsigned long aux)
+{
+	int i;
+
+	for (i = 0; i < ulist->nnodes; ++i) {
+		if (ulist->nodes[i].val == val)
+			return 0;
+	}
+
+	if (ulist->nnodes > ulist->nodes_alloced) {
+		u64 new_alloced = ulist->nodes_alloced + 128;
+		struct ulist_node *new_nodes = kmalloc(sizeof(*new_nodes) *
+					       new_alloced, ulist->gfp_mask);
+
+		if (!new_nodes)
+			return -ENOMEM;
+		memcpy(new_nodes, ulist->nodes,
+		       sizeof(*new_nodes) * ulist->nnodes);
+		if (ulist->nodes_alloced > ULIST_SIZE)
+			kfree(ulist->nodes);
+		ulist->nodes = new_nodes;
+		ulist->nodes_alloced = new_alloced;
+	}
+	ulist->nodes[ulist->nnodes].val = val;
+	ulist->nodes[ulist->nnodes].aux = aux;
+	ulist->nodes[ulist->nnodes].next = ulist->nnodes + 1;
+	++ulist->nnodes;
+
+	return 1;
+}
+
+struct ulist_node *ulist_next(struct ulist *ulist, struct ulist_node *prev)
+{
+	if (ulist->nnodes == 0)
+		return NULL;
+
+	if (!prev)
+		return &ulist->nodes[0];
+
+	if (prev->next < 0 || prev->next >= ulist->nnodes)
+		return NULL;
+
+	return &ulist->nodes[prev->next];
+}
-- 
1.7.3.4

