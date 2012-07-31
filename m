Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130Ab2GaEcP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 00:32:15 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40625 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201Ab2GaEby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 00:31:54 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 1/4] perf tool: introducing rblist
Date: Mon, 30 Jul 2012 22:31:32 -0600
Message-Id: <1343709095-7089-2-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1343709095-7089-1-git-send-email-dsahern@gmail.com>
References: <1343709095-7089-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rblist is the rbtree based code from strlist. It will be the common
code for strlist and the to-be-introduced intlist.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 tools/perf/Makefile      |    2 +
 tools/perf/util/rblist.c |  107 ++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/rblist.h |   47 ++++++++++++++++++++
 3 files changed, 156 insertions(+)
 create mode 100644 tools/perf/util/rblist.c
 create mode 100644 tools/perf/util/rblist.h

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 77f124f..285f700 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -319,6 +319,7 @@ LIB_H += $(ARCH_INCLUDE)
 LIB_H += util/cgroup.h
 LIB_H += $(TRACE_EVENT_DIR)event-parse.h
 LIB_H += util/target.h
+LIB_H += util/rblist.h
 
 LIB_OBJS += $(OUTPUT)util/abspath.o
 LIB_OBJS += $(OUTPUT)util/alias.o
@@ -383,6 +384,7 @@ LIB_OBJS += $(OUTPUT)util/xyarray.o
 LIB_OBJS += $(OUTPUT)util/cpumap.o
 LIB_OBJS += $(OUTPUT)util/cgroup.o
 LIB_OBJS += $(OUTPUT)util/target.o
+LIB_OBJS += $(OUTPUT)util/rblist.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
 
diff --git a/tools/perf/util/rblist.c b/tools/perf/util/rblist.c
new file mode 100644
index 0000000..0171fb6
--- /dev/null
+++ b/tools/perf/util/rblist.c
@@ -0,0 +1,107 @@
+/*
+ * Based on strlist.c by:
+ * (c) 2009 Arnaldo Carvalho de Melo <acme@redhat.com>
+ *
+ * Licensed under the GPLv2.
+ */
+
+#include <errno.h>
+#include <stdio.h>
+#include <stdlib.h>
+
+#include "rblist.h"
+
+int rblist__add_node(struct rblist *rblist, const void *new_entry)
+{
+	struct rb_node **p = &rblist->entries.rb_node;
+	struct rb_node *parent = NULL, *new_node;
+
+	while (*p != NULL) {
+		int rc;
+
+		parent = *p;
+
+		rc = rblist->node_cmp(parent, new_entry);
+		if (rc > 0)
+			p = &(*p)->rb_left;
+		else if (rc < 0)
+			p = &(*p)->rb_right;
+		else
+			return -EEXIST;
+	}
+
+	new_node = rblist->node_new(rblist, new_entry);
+	if (new_node == NULL)
+		return -ENOMEM;
+
+	rb_link_node(new_node, parent, p);
+	rb_insert_color(new_node, &rblist->entries);
+	++rblist->nr_entries;
+
+	return 0;
+}
+
+void rblist__remove_node(struct rblist *rblist, struct rb_node *rb_node)
+{
+	rb_erase(rb_node, &rblist->entries);
+	rblist->node_delete(rblist, rb_node);
+}
+
+struct rb_node *rblist__find(struct rblist *rblist, const void *entry)
+{
+	struct rb_node **p = &rblist->entries.rb_node;
+	struct rb_node *parent = NULL;
+
+	while (*p != NULL) {
+		int rc;
+
+		parent = *p;
+
+		rc = rblist->node_cmp(parent, entry);
+		if (rc > 0)
+			p = &(*p)->rb_left;
+		else if (rc < 0)
+			p = &(*p)->rb_right;
+		else
+			return parent;
+	}
+
+	return NULL;
+}
+
+void rblist__init(struct rblist *rblist)
+{
+	if (rblist != NULL) {
+		rblist->entries	 = RB_ROOT;
+		rblist->nr_entries = 0;
+	}
+
+	return;
+}
+
+void rblist__delete(struct rblist *rblist)
+{
+	if (rblist != NULL) {
+		struct rb_node *pos, *next = rb_first(&rblist->entries);
+
+		while (next) {
+			pos = next;
+			next = rb_next(pos);
+			rb_erase(pos, &rblist->entries);
+			rblist->node_delete(rblist, pos);
+		}
+		free(rblist);
+	}
+}
+
+struct rb_node *rblist__entry(const struct rblist *rblist, unsigned int idx)
+{
+	struct rb_node *node;
+
+	for (node = rb_first(&rblist->entries); node; node = rb_next(node)) {
+		if (!idx--)
+			return node;
+	}
+
+	return NULL;
+}
diff --git a/tools/perf/util/rblist.h b/tools/perf/util/rblist.h
new file mode 100644
index 0000000..13f4f45
--- /dev/null
+++ b/tools/perf/util/rblist.h
@@ -0,0 +1,47 @@
+#ifndef __PERF_RBLIST_H
+#define __PERF_RBLIST_H
+
+#include <linux/rbtree.h>
+#include <stdbool.h>
+
+/*
+ * create node structs of the form:
+ * struct my_node {
+ *     struct rb_node rb_node;
+ *     ... my data ...
+ * };
+ *
+ * create list structs of the form:
+ * struct mylist {
+ *     struct rblist rblist;
+ *     ... my data ...
+ * };
+ */
+
+struct rblist {
+	struct rb_root entries;
+	unsigned int   nr_entries;
+
+	int (*node_cmp) (struct rb_node *rbn, const void *entry);
+	struct rb_node *(*node_new) (struct rblist *rlist, const void *new_entry);
+	void (*node_delete) (struct rblist *rblist, struct rb_node *rb_node);
+};
+
+void rblist__init(struct rblist *rblist);
+void rblist__delete(struct rblist *rblist);
+int rblist__add_node(struct rblist *rblist, const void *new_entry);
+void rblist__remove_node(struct rblist *rblist, struct rb_node *rb_node);
+struct rb_node *rblist__find(struct rblist *rblist, const void *entry);
+struct rb_node *rblist__entry(const struct rblist *rblist, unsigned int idx);
+
+static inline bool rblist__empty(const struct rblist *rblist)
+{
+	return rblist->nr_entries == 0;
+}
+
+static inline unsigned int rblist__nr_entries(const struct rblist *rblist)
+{
+	return rblist->nr_entries;
+}
+
+#endif /* __PERF_RBLIST_H */
-- 
1.7.10.1

