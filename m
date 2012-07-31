Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251Ab2GaEcT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 00:32:19 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:49915 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366Ab2GaEb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 00:31:57 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 2/4] perf tool: change strlist to use the new rblist
Date: Mon, 30 Jul 2012 22:31:33 -0600
Message-Id: <1343709095-7089-3-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1343709095-7089-1-git-send-email-dsahern@gmail.com>
References: <1343709095-7089-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaces the direct use of rbtree code with the rblist API. In the end
the patch is a no-op on strlist functionality; the API for strlist is
not changed, only its implementaton.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 tools/perf/util/strlist.c |  130 ++++++++++++++++++---------------------------
 tools/perf/util/strlist.h |   11 ++--
 2 files changed, 57 insertions(+), 84 deletions(-)

diff --git a/tools/perf/util/strlist.c b/tools/perf/util/strlist.c
index 6783a20..95856ff 100644
--- a/tools/perf/util/strlist.c
+++ b/tools/perf/util/strlist.c
@@ -10,23 +10,28 @@
 #include <stdlib.h>
 #include <string.h>
 
-static struct str_node *str_node__new(const char *s, bool dupstr)
+static
+struct rb_node *strlist__node_new(struct rblist *rblist, const void *entry)
 {
-	struct str_node *self = malloc(sizeof(*self));
+	const char *s = entry;
+	struct rb_node *rc = NULL;
+	struct strlist *strlist = container_of(rblist, struct strlist, rblist);
+	struct str_node *snode = malloc(sizeof(*snode));
 
-	if (self != NULL) {
-		if (dupstr) {
+	if (snode != NULL) {
+		if (strlist->dupstr) {
 			s = strdup(s);
 			if (s == NULL)
 				goto out_delete;
 		}
-		self->s = s;
+		snode->s = s;
+		rc = &snode->rb_node;
 	}
 
-	return self;
+	return rc;
 
 out_delete:
-	free(self);
+	free(snode);
 	return NULL;
 }
 
@@ -37,36 +42,26 @@ static void str_node__delete(struct str_node *self, bool dupstr)
 	free(self);
 }
 
-int strlist__add(struct strlist *self, const char *new_entry)
+static
+void strlist__node_delete(struct rblist *rblist, struct rb_node *rb_node)
 {
-	struct rb_node **p = &self->entries.rb_node;
-	struct rb_node *parent = NULL;
-	struct str_node *sn;
-
-	while (*p != NULL) {
-		int rc;
-
-		parent = *p;
-		sn = rb_entry(parent, struct str_node, rb_node);
-		rc = strcmp(sn->s, new_entry);
-
-		if (rc > 0)
-			p = &(*p)->rb_left;
-		else if (rc < 0)
-			p = &(*p)->rb_right;
-		else
-			return -EEXIST;
-	}
+	struct strlist *slist = container_of(rblist, struct strlist, rblist);
+	struct str_node *snode = container_of(rb_node, struct str_node, rb_node);
 
-	sn = str_node__new(new_entry, self->dupstr);
-	if (sn == NULL)
-		return -ENOMEM;
+	str_node__delete(snode, slist->dupstr);
+}
 
-	rb_link_node(&sn->rb_node, parent, p);
-	rb_insert_color(&sn->rb_node, &self->entries);
-	++self->nr_entries;
+static int strlist__node_cmp(struct rb_node *rb_node, const void *entry)
+{
+	const char *str = entry;
+	struct str_node *snode = container_of(rb_node, struct str_node, rb_node);
+
+	return strcmp(snode->s, str);
+}
 
-	return 0;
+int strlist__add(struct strlist *self, const char *new_entry)
+{
+	return rblist__add_node(&self->rblist, new_entry);
 }
 
 int strlist__load(struct strlist *self, const char *filename)
@@ -96,34 +91,20 @@ out:
 	return err;
 }
 
-void strlist__remove(struct strlist *self, struct str_node *sn)
+void strlist__remove(struct strlist *slist, struct str_node *snode)
 {
-	rb_erase(&sn->rb_node, &self->entries);
-	str_node__delete(sn, self->dupstr);
+	str_node__delete(snode, slist->dupstr);
 }
 
-struct str_node *strlist__find(struct strlist *self, const char *entry)
+struct str_node *strlist__find(struct strlist *slist, const char *entry)
 {
-	struct rb_node **p = &self->entries.rb_node;
-	struct rb_node *parent = NULL;
-
-	while (*p != NULL) {
-		struct str_node *sn;
-		int rc;
-
-		parent = *p;
-		sn = rb_entry(parent, struct str_node, rb_node);
-		rc = strcmp(sn->s, entry);
-
-		if (rc > 0)
-			p = &(*p)->rb_left;
-		else if (rc < 0)
-			p = &(*p)->rb_right;
-		else
-			return sn;
-	}
+	struct str_node *snode = NULL;
+	struct rb_node *rb_node = rblist__find(&slist->rblist, entry);
 
-	return NULL;
+	if (rb_node)
+		snode = container_of(rb_node, struct str_node, rb_node);
+
+	return snode;
 }
 
 static int strlist__parse_list_entry(struct strlist *self, const char *s)
@@ -156,9 +137,12 @@ struct strlist *strlist__new(bool dupstr, const char *slist)
 	struct strlist *self = malloc(sizeof(*self));
 
 	if (self != NULL) {
-		self->entries	 = RB_ROOT;
+		rblist__init(&self->rblist);
+		self->rblist.node_cmp    = strlist__node_cmp;
+		self->rblist.node_new    = strlist__node_new;
+		self->rblist.node_delete = strlist__node_delete;
+
 		self->dupstr	 = dupstr;
-		self->nr_entries = 0;
 		if (slist && strlist__parse_list(self, slist) != 0)
 			goto out_error;
 	}
@@ -171,30 +155,18 @@ out_error:
 
 void strlist__delete(struct strlist *self)
 {
-	if (self != NULL) {
-		struct str_node *pos;
-		struct rb_node *next = rb_first(&self->entries);
-
-		while (next) {
-			pos = rb_entry(next, struct str_node, rb_node);
-			next = rb_next(&pos->rb_node);
-			strlist__remove(self, pos);
-		}
-		self->entries = RB_ROOT;
-		free(self);
-	}
+	if (self != NULL)
+		rblist__delete(&self->rblist);
 }
 
-struct str_node *strlist__entry(const struct strlist *self, unsigned int idx)
+struct str_node *strlist__entry(const struct strlist *slist, unsigned int idx)
 {
-	struct rb_node *nd;
+	struct str_node *snode = NULL;
+	struct rb_node *rb_node;
 
-	for (nd = rb_first(&self->entries); nd; nd = rb_next(nd)) {
-		struct str_node *pos = rb_entry(nd, struct str_node, rb_node);
+	rb_node = rblist__entry(&slist->rblist, idx);
+	if (rb_node)
+		snode = container_of(rb_node, struct str_node, rb_node);
 
-		if (!idx--)
-			return pos;
-	}
-
-	return NULL;
+	return snode;
 }
diff --git a/tools/perf/util/strlist.h b/tools/perf/util/strlist.h
index 3ba8390..dd9f922 100644
--- a/tools/perf/util/strlist.h
+++ b/tools/perf/util/strlist.h
@@ -4,14 +4,15 @@
 #include <linux/rbtree.h>
 #include <stdbool.h>
 
+#include "rblist.h"
+
 struct str_node {
 	struct rb_node rb_node;
 	const char     *s;
 };
 
 struct strlist {
-	struct rb_root entries;
-	unsigned int   nr_entries;
+	struct rblist rblist;
 	bool	       dupstr;
 };
 
@@ -32,18 +33,18 @@ static inline bool strlist__has_entry(struct strlist *self, const char *entry)
 
 static inline bool strlist__empty(const struct strlist *self)
 {
-	return self->nr_entries == 0;
+	return rblist__empty(&self->rblist);
 }
 
 static inline unsigned int strlist__nr_entries(const struct strlist *self)
 {
-	return self->nr_entries;
+	return rblist__nr_entries(&self->rblist);
 }
 
 /* For strlist iteration */
 static inline struct str_node *strlist__first(struct strlist *self)
 {
-	struct rb_node *rn = rb_first(&self->entries);
+	struct rb_node *rn = rb_first(&self->rblist.entries);
 	return rn ? rb_entry(rn, struct str_node, rb_node) : NULL;
 }
 static inline struct str_node *strlist__next(struct str_node *sn)
-- 
1.7.10.1

