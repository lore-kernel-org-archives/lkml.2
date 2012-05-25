Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758918Ab2EYU6i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 16:58:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56640 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753850Ab2EYU54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 16:57:56 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org
Cc: Kent Overstreet <koverstreet@google.com>, tj@kernel.org, axboe@kernel.dk,
        paul.gortmaker@windriver.com
Subject: [PATCH 1/3] rbtree: Add rb_insert(), rb_search(), etc.
Date: Fri, 25 May 2012 13:57:39 -0700
Message-Id: <1337979461-19654-2-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.9.3.327.g2980b
In-Reply-To: <1337979461-19654-1-git-send-email-koverstreet@google.com>
References: <1337979461-19654-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change-Id: I072d94a42b75454aa62be849c724980d27523b08

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 include/linux/rbtree.h |  110 ++++++++++++++++++++++++++++++++++++++++++++++++
 lib/rbtree.c           |   28 ++++++++++++
 2 files changed, 138 insertions(+)

diff --git a/include/linux/rbtree.h b/include/linux/rbtree.h
index 033b507..4447919 100644
--- a/include/linux/rbtree.h
+++ b/include/linux/rbtree.h
@@ -174,4 +174,114 @@ static inline void rb_link_node(struct rb_node * node, struct rb_node * parent,
 	*rb_link = node;
 }
 
+typedef int (rb_cmp_t) (struct rb_node *l, struct rb_node *r);
+
+static inline int _rb_insert(struct rb_root *root,
+			     struct rb_node *new,
+			     rb_cmp_t cmp)
+{
+	struct rb_node **n = &root->rb_node, *parent = NULL;
+	int res;
+
+	while (*n) {
+		parent = *n;
+		res = cmp(new, *n);
+		if (!res)
+			return -1;
+		n = res < 0
+			? &(*n)->rb_left
+			: &(*n)->rb_right;
+	}
+
+	rb_link_node(new, parent, n);
+	rb_insert_color(new, root);
+	return 0;
+}
+
+static inline void _rb_insert_allow_dup(struct rb_root *root,
+				       struct rb_node *new,
+				       rb_cmp_t cmp)
+{
+	struct rb_node **n = &root->rb_node, *parent = NULL;
+
+	while (*n) {
+		parent = *n;
+		n = cmp(new, *n) < 0
+			? &(*n)->rb_left
+			: &(*n)->rb_right;
+	}
+
+	rb_link_node(new, parent, n);
+	rb_insert_color(new, root);
+}
+
+static inline struct rb_node *_rb_search(struct rb_root *root,
+					 struct rb_node *search,
+					 rb_cmp_t cmp)
+{
+	struct rb_node *n = root->rb_node;
+
+	while (n) {
+		int res = cmp(search, n);
+		if (!res)
+			return n;
+
+		n = res < 0
+			? n->rb_left
+			: n->rb_right;
+	}
+
+	return NULL;
+}
+
+static inline struct rb_node *_rb_greater(struct rb_root *root,
+					  struct rb_node *search,
+					  rb_cmp_t cmp)
+{
+	struct rb_node *n = root->rb_node;
+	struct rb_node *ret = NULL;
+
+	while (n) {
+		int res = cmp(search, n);
+
+		if (res < 0) {
+			ret = n;
+			n = n->rb_left;
+		} else {
+			n = n->rb_right;
+		}
+	}
+
+	return ret;
+}
+
+int rb_insert(struct rb_root *root, struct rb_node *new, rb_cmp_t cmp);
+void rb_insert_allow_dup(struct rb_root *root,
+			 struct rb_node *new,
+			 rb_cmp_t cmp);
+struct rb_node *rb_search(struct rb_root *root,
+			  struct rb_node *search,
+			  rb_cmp_t cmp);
+struct rb_node *rb_greater(struct rb_root *root,
+			   struct rb_node *search,
+			   rb_cmp_t cmp);
+
+#define container_of_or_null(ptr, type, member)				\
+({									\
+	typeof(ptr) _ptr = ptr;						\
+	_ptr ? container_of(_ptr, type, member) : NULL;			\
+})
+
+#define RB_FIRST(root, type, member)					\
+	container_of_or_null(rb_first(root), type, member)
+
+#define RB_LAST(root, type, member)					\
+	container_of_or_null(rb_last(root), type, member)
+
+#define RB_NEXT(ptr, member)						\
+	container_of_or_null(rb_next(&(ptr)->member), typeof(*ptr), member)
+
+#define RB_PREV(ptr, member)						\
+	container_of_or_null(rb_prev(&(ptr)->member), typeof(*ptr), member)
+
 #endif	/* _LINUX_RBTREE_H */
diff --git a/lib/rbtree.c b/lib/rbtree.c
index d417556..53641b7 100644
--- a/lib/rbtree.c
+++ b/lib/rbtree.c
@@ -135,6 +135,34 @@ void rb_insert_color(struct rb_node *node, struct rb_root *root)
 }
 EXPORT_SYMBOL(rb_insert_color);
 
+int rb_insert(struct rb_root *root, struct rb_node *new, rb_cmp_t cmp)
+{
+	return _rb_insert(root, new, cmp);
+}
+EXPORT_SYMBOL(rb_insert);
+
+void rb_insert_allow_dup(struct rb_root *root, struct rb_node *new, rb_cmp_t cmp)
+{
+	_rb_insert_allow_dup(root, new, cmp);
+}
+EXPORT_SYMBOL(rb_insert_allow_dup);
+
+struct rb_node *rb_search(struct rb_root *root,
+			  struct rb_node *search,
+			  rb_cmp_t cmp)
+{
+	return _rb_search(root, search, cmp);
+}
+EXPORT_SYMBOL(rb_search);
+
+struct rb_node *rb_greater(struct rb_root *root,
+			   struct rb_node *search,
+			   rb_cmp_t cmp)
+{
+	return _rb_greater(root, search, cmp);
+}
+EXPORT_SYMBOL(rb_greater);
+
 static void __rb_erase_color(struct rb_node *node, struct rb_node *parent,
 			     struct rb_root *root)
 {
-- 
1.7.9.3.327.g2980b

