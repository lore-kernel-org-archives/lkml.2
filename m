Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288Ab2GaEcV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 00:32:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40625 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427Ab2GaEb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 00:31:58 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 3/4] perf tool: introduce intlist
Date: Mon, 30 Jul 2012 22:31:34 -0600
Message-Id: <1343709095-7089-4-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1343709095-7089-1-git-send-email-dsahern@gmail.com>
References: <1343709095-7089-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Built on rblist - like strlist. Used in the next patch.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>

---
 tools/perf/Makefile       |    2 +
 tools/perf/util/intlist.c |  101 +++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/intlist.h |   75 +++++++++++++++++++++++++++++++++
 3 files changed, 178 insertions(+)
 create mode 100644 tools/perf/util/intlist.c
 create mode 100644 tools/perf/util/intlist.h

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 285f700..32912af 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -320,6 +320,7 @@ LIB_H += util/cgroup.h
 LIB_H += $(TRACE_EVENT_DIR)event-parse.h
 LIB_H += util/target.h
 LIB_H += util/rblist.h
+LIB_H += util/intlist.h
 
 LIB_OBJS += $(OUTPUT)util/abspath.o
 LIB_OBJS += $(OUTPUT)util/alias.o
@@ -385,6 +386,7 @@ LIB_OBJS += $(OUTPUT)util/cpumap.o
 LIB_OBJS += $(OUTPUT)util/cgroup.o
 LIB_OBJS += $(OUTPUT)util/target.o
 LIB_OBJS += $(OUTPUT)util/rblist.o
+LIB_OBJS += $(OUTPUT)util/intlist.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
 
diff --git a/tools/perf/util/intlist.c b/tools/perf/util/intlist.c
new file mode 100644
index 0000000..55b3441
--- /dev/null
+++ b/tools/perf/util/intlist.c
@@ -0,0 +1,101 @@
+/*
+ * Based on intlist.c by:
+ * (c) 2009 Arnaldo Carvalho de Melo <acme@redhat.com>
+ *
+ * Licensed under the GPLv2.
+ */
+
+#include <errno.h>
+#include <stdlib.h>
+#include <linux/compiler.h>
+
+#include "intlist.h"
+
+static struct rb_node *intlist__node_new(struct rblist *rblist __used,
+					 const void *entry)
+{
+	int i = (int) ((long) entry);
+	struct rb_node *rc = NULL;
+	struct int_node *node = malloc(sizeof(*node));
+
+	if (node != NULL) {
+		node->i = i;
+		rc = &node->rb_node;
+	}
+
+	return rc;
+}
+
+static void int_node__delete(struct int_node *ilist)
+{
+	free(ilist);
+}
+
+static void intlist__node_delete(struct rblist *rblist __used,
+				 struct rb_node *rb_node)
+{
+	struct int_node *node = container_of(rb_node, struct int_node, rb_node);
+
+	int_node__delete(node);
+}
+
+static int intlist__node_cmp(struct rb_node *rb_node, const void *entry)
+{
+	int i = (int) ((long) entry);
+	struct int_node *node = container_of(rb_node, struct int_node, rb_node);
+
+	return node->i - i;
+}
+
+int intlist__add(struct intlist *ilist, int i)
+{
+	return rblist__add_node(&ilist->rblist, (void *)((long) i));
+}
+
+void intlist__remove(struct intlist *ilist __used, struct int_node *node)
+{
+	int_node__delete(node);
+}
+
+struct int_node *intlist__find(struct intlist *ilist, int i)
+{
+	struct int_node *node = NULL;
+	struct rb_node *rb_node = rblist__find(&ilist->rblist, (void *)((long) i));
+
+	if (rb_node)
+		node = container_of(rb_node, struct int_node, rb_node);
+
+	return node;
+}
+
+struct intlist *intlist__new(void)
+{
+	struct intlist *ilist = malloc(sizeof(*ilist));
+
+	if (ilist != NULL) {
+		rblist__init(&ilist->rblist);
+		ilist->rblist.node_cmp    = intlist__node_cmp;
+		ilist->rblist.node_new    = intlist__node_new;
+		ilist->rblist.node_delete = intlist__node_delete;
+	}
+
+	return ilist;
+}
+
+void intlist__delete(struct intlist *ilist)
+{
+	if (ilist != NULL)
+		rblist__delete(&ilist->rblist);
+}
+
+struct int_node *intlist__entry(const struct intlist *ilist, unsigned int idx)
+{
+	struct int_node *node = NULL;
+	struct rb_node *rb_node;
+
+	rb_node = rblist__entry(&ilist->rblist, idx);
+	if (rb_node)
+		node = container_of(rb_node, struct int_node, rb_node);
+
+	return node;
+}
diff --git a/tools/perf/util/intlist.h b/tools/perf/util/intlist.h
new file mode 100644
index 0000000..8fd70ad
--- /dev/null
+++ b/tools/perf/util/intlist.h
@@ -0,0 +1,75 @@
+#ifndef __PERF_INTLIST_H
+#define __PERF_INTLIST_H
+
+#include <linux/rbtree.h>
+#include <stdbool.h>
+
+#include "rblist.h"
+
+struct int_node {
+	struct rb_node rb_node;
+	int i;
+};
+
+struct intlist {
+	struct rblist rblist;
+};
+
+struct intlist *intlist__new(void);
+void intlist__delete(struct intlist *ilist);
+
+void intlist__remove(struct intlist *ilist, struct int_node *in);
+int intlist__add(struct intlist *ilist, int i);
+
+struct int_node *intlist__entry(const struct intlist *ilist, unsigned int idx);
+struct int_node *intlist__find(struct intlist *ilist, int i);
+
+static inline bool intlist__has_entry(struct intlist *ilist, int i)
+{
+	return intlist__find(ilist, i) != NULL;
+}
+
+static inline bool intlist__empty(const struct intlist *ilist)
+{
+	return rblist__empty(&ilist->rblist);
+}
+
+static inline unsigned int intlist__nr_entries(const struct intlist *ilist)
+{
+	return rblist__nr_entries(&ilist->rblist);
+}
+
+/* For intlist iteration */
+static inline struct int_node *intlist__first(struct intlist *ilist)
+{
+	struct rb_node *rn = rb_first(&ilist->rblist.entries);
+	return rn ? rb_entry(rn, struct int_node, rb_node) : NULL;
+}
+static inline struct int_node *intlist__next(struct int_node *in)
+{
+	struct rb_node *rn;
+	if (!in)
+		return NULL;
+	rn = rb_next(&in->rb_node);
+	return rn ? rb_entry(rn, struct int_node, rb_node) : NULL;
+}
+
+/**
+ * intlist_for_each      - iterate over a intlist
+ * @pos:	the &struct int_node to use as a loop cursor.
+ * @ilist:	the &struct intlist for loop.
+ */
+#define intlist__for_each(pos, ilist)	\
+	for (pos = intlist__first(ilist); pos; pos = intlist__next(pos))
+
+/**
+ * intlist_for_each_safe - iterate over a intlist safe against removal of
+ *                         int_node
+ * @pos:	the &struct int_node to use as a loop cursor.
+ * @n:		another &struct int_node to use as temporary storage.
+ * @ilist:	the &struct intlist for loop.
+ */
+#define intlist__for_each_safe(pos, n, ilist)	\
+	for (pos = intlist__first(ilist), n = intlist__next(pos); pos;\
+	     pos = n, n = intlist__next(n))
+#endif /* __PERF_STRLIST_H */
-- 
1.7.10.1

