Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942Ab2HEQ7j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 12:59:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57019 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754670Ab2HEQ7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 12:59:38 -0400
Date: Sun, 5 Aug 2012 09:56:04 -0700
From: tip-bot for David Ahern <dsahern@gmail.com>
Message-ID: <tip-37bbd3fff1480a1f5d57abb9e9e56f468954c1b1@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, fweisbec@gmail.com, peterz@infradead.org,
        dsahern@gmail.com, tglx@linutronix.de, namhyung@kernel.org,
        jolsa@redhat.com
In-Reply-To: <1343709095-7089-2-git-send-email-dsahern@gmail.com>
References: <1343709095-7089-2-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Introducing rblist
Git-Commit-ID: 37bbd3fff1480a1f5d57abb9e9e56f468954c1b1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 05 Aug 2012 09:56:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  37bbd3fff1480a1f5d57abb9e9e56f468954c1b1
Gitweb:     http://git.kernel.org/tip/37bbd3fff1480a1f5d57abb9e9e56f468954c1b1
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Mon, 30 Jul 2012 22:31:32 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 3 Aug 2012 10:37:21 -0300

perf tools: Introducing rblist

rblist is the rbtree based code from strlist. It will be the common code
for strlist and the to-be-introduced intlist.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1343709095-7089-2-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile      |    2 +
 tools/perf/util/rblist.c |  107 ++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/rblist.h |   47 ++++++++++++++++++++
 3 files changed, 156 insertions(+), 0 deletions(-)

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
index 0000000..6d0cae5
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
+	int (*node_cmp)(struct rb_node *rbn, const void *entry);
+	struct rb_node *(*node_new)(struct rblist *rlist, const void *new_entry);
+	void (*node_delete)(struct rblist *rblist, struct rb_node *rb_node);
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
