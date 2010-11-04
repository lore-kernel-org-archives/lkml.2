Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957Ab0KDPju (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 11:39:50 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:42012 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909Ab0KDPjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 11:39:46 -0400
From: Borislav Petkov <bp@amd64.org>
To: <acme@infradead.org>, <fweisbec@gmail.com>, <mingo@elte.hu>,
        <peterz@infradead.org>, <rostedt@goodmis.org>
Cc: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 15/20] perf: Export strlist.ch
Date: Thu,  4 Nov 2010 16:36:51 +0100
Message-Id: <1288885016-18295-16-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1288885016-18295-1-git-send-email-bp@amd64.org>
References: <1288885016-18295-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Needed by other perf utils like map.c and symbol.c

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 tools/lib/lk/Makefile              |    2 +
 tools/lib/lk/strlist.c             |  200 ++++++++++++++++++++++++++++++++++++
 tools/lib/lk/strlist.h             |   79 ++++++++++++++
 tools/perf/Makefile                |    2 -
 tools/perf/builtin-buildid-cache.c |    2 +-
 tools/perf/builtin-probe.c         |    2 +-
 tools/perf/builtin-report.c        |    2 +-
 tools/perf/builtin-timechart.c     |    2 +-
 tools/perf/util/event.c            |    2 +-
 tools/perf/util/probe-event.c      |    2 +-
 tools/perf/util/probe-event.h      |    2 +-
 tools/perf/util/sort.h             |    2 +-
 tools/perf/util/strlist.c          |  200 ------------------------------------
 tools/perf/util/strlist.h          |   79 --------------
 tools/perf/util/symbol.c           |    2 +-
 15 files changed, 290 insertions(+), 290 deletions(-)
 create mode 100644 tools/lib/lk/strlist.c
 create mode 100644 tools/lib/lk/strlist.h
 delete mode 100644 tools/perf/util/strlist.c
 delete mode 100644 tools/perf/util/strlist.h

diff --git a/tools/lib/lk/Makefile b/tools/lib/lk/Makefile
index d62e898..36395b1 100644
--- a/tools/lib/lk/Makefile
+++ b/tools/lib/lk/Makefile
@@ -14,6 +14,7 @@ LIB_H += bitops.h
 LIB_H += bitmap.h
 LIB_H += kernel.h
 LIB_H += compiler.h
+LIB_H += strlist.h
 
 LIB_OBJS += debugfs.o
 LIB_OBJS += usage.o
@@ -23,6 +24,7 @@ LIB_OBJS += ctype.o
 LIB_OBJS += rbtree.o
 LIB_OBJS += hweight.o
 LIB_OBJS += bitmap.o
+LIB_OBJS += strlist.o
 
 LIBFILE = $(LIB_OUTPUT)lklib.a
 
diff --git a/tools/lib/lk/strlist.c b/tools/lib/lk/strlist.c
new file mode 100644
index 0000000..6783a20
--- /dev/null
+++ b/tools/lib/lk/strlist.c
@@ -0,0 +1,200 @@
+/*
+ * (c) 2009 Arnaldo Carvalho de Melo <acme@redhat.com>
+ *
+ * Licensed under the GPLv2.
+ */
+
+#include "strlist.h"
+#include <errno.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+
+static struct str_node *str_node__new(const char *s, bool dupstr)
+{
+	struct str_node *self = malloc(sizeof(*self));
+
+	if (self != NULL) {
+		if (dupstr) {
+			s = strdup(s);
+			if (s == NULL)
+				goto out_delete;
+		}
+		self->s = s;
+	}
+
+	return self;
+
+out_delete:
+	free(self);
+	return NULL;
+}
+
+static void str_node__delete(struct str_node *self, bool dupstr)
+{
+	if (dupstr)
+		free((void *)self->s);
+	free(self);
+}
+
+int strlist__add(struct strlist *self, const char *new_entry)
+{
+	struct rb_node **p = &self->entries.rb_node;
+	struct rb_node *parent = NULL;
+	struct str_node *sn;
+
+	while (*p != NULL) {
+		int rc;
+
+		parent = *p;
+		sn = rb_entry(parent, struct str_node, rb_node);
+		rc = strcmp(sn->s, new_entry);
+
+		if (rc > 0)
+			p = &(*p)->rb_left;
+		else if (rc < 0)
+			p = &(*p)->rb_right;
+		else
+			return -EEXIST;
+	}
+
+	sn = str_node__new(new_entry, self->dupstr);
+	if (sn == NULL)
+		return -ENOMEM;
+
+	rb_link_node(&sn->rb_node, parent, p);
+	rb_insert_color(&sn->rb_node, &self->entries);
+	++self->nr_entries;
+
+	return 0;
+}
+
+int strlist__load(struct strlist *self, const char *filename)
+{
+	char entry[1024];
+	int err;
+	FILE *fp = fopen(filename, "r");
+
+	if (fp == NULL)
+		return errno;
+
+	while (fgets(entry, sizeof(entry), fp) != NULL) {
+		const size_t len = strlen(entry);
+
+		if (len == 0)
+			continue;
+		entry[len - 1] = '\0';
+
+		err = strlist__add(self, entry);
+		if (err != 0)
+			goto out;
+	}
+
+	err = 0;
+out:
+	fclose(fp);
+	return err;
+}
+
+void strlist__remove(struct strlist *self, struct str_node *sn)
+{
+	rb_erase(&sn->rb_node, &self->entries);
+	str_node__delete(sn, self->dupstr);
+}
+
+struct str_node *strlist__find(struct strlist *self, const char *entry)
+{
+	struct rb_node **p = &self->entries.rb_node;
+	struct rb_node *parent = NULL;
+
+	while (*p != NULL) {
+		struct str_node *sn;
+		int rc;
+
+		parent = *p;
+		sn = rb_entry(parent, struct str_node, rb_node);
+		rc = strcmp(sn->s, entry);
+
+		if (rc > 0)
+			p = &(*p)->rb_left;
+		else if (rc < 0)
+			p = &(*p)->rb_right;
+		else
+			return sn;
+	}
+
+	return NULL;
+}
+
+static int strlist__parse_list_entry(struct strlist *self, const char *s)
+{
+	if (strncmp(s, "file://", 7) == 0)
+		return strlist__load(self, s + 7);
+
+	return strlist__add(self, s);
+}
+
+int strlist__parse_list(struct strlist *self, const char *s)
+{
+	char *sep;
+	int err;
+
+	while ((sep = strchr(s, ',')) != NULL) {
+		*sep = '\0';
+		err = strlist__parse_list_entry(self, s);
+		*sep = ',';
+		if (err != 0)
+			return err;
+		s = sep + 1;
+	}
+
+	return *s ? strlist__parse_list_entry(self, s) : 0;
+}
+
+struct strlist *strlist__new(bool dupstr, const char *slist)
+{
+	struct strlist *self = malloc(sizeof(*self));
+
+	if (self != NULL) {
+		self->entries	 = RB_ROOT;
+		self->dupstr	 = dupstr;
+		self->nr_entries = 0;
+		if (slist && strlist__parse_list(self, slist) != 0)
+			goto out_error;
+	}
+
+	return self;
+out_error:
+	free(self);
+	return NULL;
+}
+
+void strlist__delete(struct strlist *self)
+{
+	if (self != NULL) {
+		struct str_node *pos;
+		struct rb_node *next = rb_first(&self->entries);
+
+		while (next) {
+			pos = rb_entry(next, struct str_node, rb_node);
+			next = rb_next(&pos->rb_node);
+			strlist__remove(self, pos);
+		}
+		self->entries = RB_ROOT;
+		free(self);
+	}
+}
+
+struct str_node *strlist__entry(const struct strlist *self, unsigned int idx)
+{
+	struct rb_node *nd;
+
+	for (nd = rb_first(&self->entries); nd; nd = rb_next(nd)) {
+		struct str_node *pos = rb_entry(nd, struct str_node, rb_node);
+
+		if (!idx--)
+			return pos;
+	}
+
+	return NULL;
+}
diff --git a/tools/lib/lk/strlist.h b/tools/lib/lk/strlist.h
new file mode 100644
index 0000000..a21ba37
--- /dev/null
+++ b/tools/lib/lk/strlist.h
@@ -0,0 +1,79 @@
+#ifndef __LK_STRLIST_H
+#define __LK_STRLIST_H
+
+#include <lk/kernel.h>
+#include <lk/rbtree.h>
+#include <stdbool.h>
+
+struct str_node {
+	struct rb_node rb_node;
+	const char     *s;
+};
+
+struct strlist {
+	struct rb_root entries;
+	unsigned int   nr_entries;
+	bool	       dupstr;
+};
+
+struct strlist *strlist__new(bool dupstr, const char *slist);
+void strlist__delete(struct strlist *self);
+
+void strlist__remove(struct strlist *self, struct str_node *sn);
+int strlist__load(struct strlist *self, const char *filename);
+int strlist__add(struct strlist *self, const char *str);
+
+struct str_node *strlist__entry(const struct strlist *self, unsigned int idx);
+struct str_node *strlist__find(struct strlist *self, const char *entry);
+
+static inline bool strlist__has_entry(struct strlist *self, const char *entry)
+{
+	return strlist__find(self, entry) != NULL;
+}
+
+static inline bool strlist__empty(const struct strlist *self)
+{
+	return self->nr_entries == 0;
+}
+
+static inline unsigned int strlist__nr_entries(const struct strlist *self)
+{
+	return self->nr_entries;
+}
+
+/* For strlist iteration */
+static inline struct str_node *strlist__first(struct strlist *self)
+{
+	struct rb_node *rn = rb_first(&self->entries);
+	return rn ? rb_entry(rn, struct str_node, rb_node) : NULL;
+}
+static inline struct str_node *strlist__next(struct str_node *sn)
+{
+	struct rb_node *rn;
+	if (!sn)
+		return NULL;
+	rn = rb_next(&sn->rb_node);
+	return rn ? rb_entry(rn, struct str_node, rb_node) : NULL;
+}
+
+/**
+ * strlist_for_each      - iterate over a strlist
+ * @pos:	the &struct str_node to use as a loop cursor.
+ * @self:	the &struct strlist for loop.
+ */
+#define strlist__for_each(pos, self)	\
+	for (pos = strlist__first(self); pos; pos = strlist__next(pos))
+
+/**
+ * strlist_for_each_safe - iterate over a strlist safe against removal of
+ *                         str_node
+ * @pos:	the &struct str_node to use as a loop cursor.
+ * @n:		another &struct str_node to use as temporary storage.
+ * @self:	the &struct strlist for loop.
+ */
+#define strlist__for_each_safe(pos, n, self)	\
+	for (pos = strlist__first(self), n = strlist__next(pos); pos;\
+	     pos = n, n = strlist__next(n))
+
+int strlist__parse_list(struct strlist *self, const char *s);
+#endif /* __LK_STRLIST_H */
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 9af0817..66fd9c2 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -364,7 +364,6 @@ LIB_H += util/header.h
 LIB_H += util/help.h
 LIB_H += util/session.h
 LIB_H += util/strbuf.h
-LIB_H += util/strlist.h
 LIB_H += util/svghelper.h
 LIB_H += util/run-command.h
 LIB_H += util/sigchain.h
@@ -392,7 +391,6 @@ LIB_OBJS += $(OUTPUT)util/run-command.o
 LIB_OBJS += $(OUTPUT)util/quote.o
 LIB_OBJS += $(OUTPUT)util/strbuf.o
 LIB_OBJS += $(OUTPUT)util/string.o
-LIB_OBJS += $(OUTPUT)util/strlist.o
 LIB_OBJS += $(OUTPUT)util/wrapper.o
 LIB_OBJS += $(OUTPUT)util/sigchain.o
 LIB_OBJS += $(OUTPUT)util/symbol.o
diff --git a/tools/perf/builtin-buildid-cache.c b/tools/perf/builtin-buildid-cache.c
index 29ad20e..43e4faa 100644
--- a/tools/perf/builtin-buildid-cache.c
+++ b/tools/perf/builtin-buildid-cache.c
@@ -12,7 +12,7 @@
 #include "util/debug.h"
 #include "util/header.h"
 #include "util/parse-options.h"
-#include "util/strlist.h"
+#include <lk/strlist.h>
 #include "util/symbol.h"
 
 static char const *add_name_list_str, *remove_name_list_str;
diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index a762878..9303cab 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -37,7 +37,7 @@
 
 #include "perf.h"
 #include "builtin.h"
-#include "util/strlist.h"
+#include <lk/strlist.h>
 #include "util/symbol.h"
 #include "util/debug.h"
 #include "util/parse-options.h"
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index c4e50e4..2fa7635 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -15,7 +15,7 @@
 #include <lk/rbtree.h>
 #include "util/symbol.h"
 #include "util/callchain.h"
-#include "util/strlist.h"
+#include <lk/strlist.h>
 #include "util/values.h"
 
 #include "perf.h"
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 35678a5..c0e0dab 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -22,7 +22,7 @@
 #include <lk/rbtree.h>
 #include "util/symbol.h"
 #include "util/callchain.h"
-#include "util/strlist.h"
+#include <lk/strlist.h>
 
 #include "perf.h"
 #include "util/header.h"
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index dab9e75..09ff091 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -4,7 +4,7 @@
 #include "session.h"
 #include "sort.h"
 #include "string.h"
-#include "strlist.h"
+#include <lk/strlist.h>
 #include "thread.h"
 
 const char *event__name[] = {
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 7377dff..a6c8d3e 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -38,7 +38,7 @@
 
 #include "event.h"
 #include "string.h"
-#include "strlist.h"
+#include <lk/strlist.h>
 #include "debug.h"
 #include "cache.h"
 #include <perf/color.h>
diff --git a/tools/perf/util/probe-event.h b/tools/perf/util/probe-event.h
index 5af3924..2852634 100644
--- a/tools/perf/util/probe-event.h
+++ b/tools/perf/util/probe-event.h
@@ -2,7 +2,7 @@
 #define _PROBE_EVENT_H
 
 #include <stdbool.h>
-#include "strlist.h"
+#include <lk/strlist.h>
 
 extern bool probe_event_dry_run;
 
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index b2c89b4..e2fb61a 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -11,7 +11,7 @@
 #include "symbol.h"
 #include "string.h"
 #include "callchain.h"
-#include "strlist.h"
+#include <lk/strlist.h>
 #include "values.h"
 
 #include "../perf.h"
diff --git a/tools/perf/util/strlist.c b/tools/perf/util/strlist.c
deleted file mode 100644
index 6783a20..0000000
--- a/tools/perf/util/strlist.c
+++ /dev/null
@@ -1,200 +0,0 @@
-/*
- * (c) 2009 Arnaldo Carvalho de Melo <acme@redhat.com>
- *
- * Licensed under the GPLv2.
- */
-
-#include "strlist.h"
-#include <errno.h>
-#include <stdio.h>
-#include <stdlib.h>
-#include <string.h>
-
-static struct str_node *str_node__new(const char *s, bool dupstr)
-{
-	struct str_node *self = malloc(sizeof(*self));
-
-	if (self != NULL) {
-		if (dupstr) {
-			s = strdup(s);
-			if (s == NULL)
-				goto out_delete;
-		}
-		self->s = s;
-	}
-
-	return self;
-
-out_delete:
-	free(self);
-	return NULL;
-}
-
-static void str_node__delete(struct str_node *self, bool dupstr)
-{
-	if (dupstr)
-		free((void *)self->s);
-	free(self);
-}
-
-int strlist__add(struct strlist *self, const char *new_entry)
-{
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
-
-	sn = str_node__new(new_entry, self->dupstr);
-	if (sn == NULL)
-		return -ENOMEM;
-
-	rb_link_node(&sn->rb_node, parent, p);
-	rb_insert_color(&sn->rb_node, &self->entries);
-	++self->nr_entries;
-
-	return 0;
-}
-
-int strlist__load(struct strlist *self, const char *filename)
-{
-	char entry[1024];
-	int err;
-	FILE *fp = fopen(filename, "r");
-
-	if (fp == NULL)
-		return errno;
-
-	while (fgets(entry, sizeof(entry), fp) != NULL) {
-		const size_t len = strlen(entry);
-
-		if (len == 0)
-			continue;
-		entry[len - 1] = '\0';
-
-		err = strlist__add(self, entry);
-		if (err != 0)
-			goto out;
-	}
-
-	err = 0;
-out:
-	fclose(fp);
-	return err;
-}
-
-void strlist__remove(struct strlist *self, struct str_node *sn)
-{
-	rb_erase(&sn->rb_node, &self->entries);
-	str_node__delete(sn, self->dupstr);
-}
-
-struct str_node *strlist__find(struct strlist *self, const char *entry)
-{
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
-
-	return NULL;
-}
-
-static int strlist__parse_list_entry(struct strlist *self, const char *s)
-{
-	if (strncmp(s, "file://", 7) == 0)
-		return strlist__load(self, s + 7);
-
-	return strlist__add(self, s);
-}
-
-int strlist__parse_list(struct strlist *self, const char *s)
-{
-	char *sep;
-	int err;
-
-	while ((sep = strchr(s, ',')) != NULL) {
-		*sep = '\0';
-		err = strlist__parse_list_entry(self, s);
-		*sep = ',';
-		if (err != 0)
-			return err;
-		s = sep + 1;
-	}
-
-	return *s ? strlist__parse_list_entry(self, s) : 0;
-}
-
-struct strlist *strlist__new(bool dupstr, const char *slist)
-{
-	struct strlist *self = malloc(sizeof(*self));
-
-	if (self != NULL) {
-		self->entries	 = RB_ROOT;
-		self->dupstr	 = dupstr;
-		self->nr_entries = 0;
-		if (slist && strlist__parse_list(self, slist) != 0)
-			goto out_error;
-	}
-
-	return self;
-out_error:
-	free(self);
-	return NULL;
-}
-
-void strlist__delete(struct strlist *self)
-{
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
-}
-
-struct str_node *strlist__entry(const struct strlist *self, unsigned int idx)
-{
-	struct rb_node *nd;
-
-	for (nd = rb_first(&self->entries); nd; nd = rb_next(nd)) {
-		struct str_node *pos = rb_entry(nd, struct str_node, rb_node);
-
-		if (!idx--)
-			return pos;
-	}
-
-	return NULL;
-}
diff --git a/tools/perf/util/strlist.h b/tools/perf/util/strlist.h
deleted file mode 100644
index 964da20..0000000
--- a/tools/perf/util/strlist.h
+++ /dev/null
@@ -1,79 +0,0 @@
-#ifndef __PERF_STRLIST_H
-#define __PERF_STRLIST_H
-
-#include <lk/kernel.h>
-#include <lk/rbtree.h>
-#include <stdbool.h>
-
-struct str_node {
-	struct rb_node rb_node;
-	const char     *s;
-};
-
-struct strlist {
-	struct rb_root entries;
-	unsigned int   nr_entries;
-	bool	       dupstr;
-};
-
-struct strlist *strlist__new(bool dupstr, const char *slist);
-void strlist__delete(struct strlist *self);
-
-void strlist__remove(struct strlist *self, struct str_node *sn);
-int strlist__load(struct strlist *self, const char *filename);
-int strlist__add(struct strlist *self, const char *str);
-
-struct str_node *strlist__entry(const struct strlist *self, unsigned int idx);
-struct str_node *strlist__find(struct strlist *self, const char *entry);
-
-static inline bool strlist__has_entry(struct strlist *self, const char *entry)
-{
-	return strlist__find(self, entry) != NULL;
-}
-
-static inline bool strlist__empty(const struct strlist *self)
-{
-	return self->nr_entries == 0;
-}
-
-static inline unsigned int strlist__nr_entries(const struct strlist *self)
-{
-	return self->nr_entries;
-}
-
-/* For strlist iteration */
-static inline struct str_node *strlist__first(struct strlist *self)
-{
-	struct rb_node *rn = rb_first(&self->entries);
-	return rn ? rb_entry(rn, struct str_node, rb_node) : NULL;
-}
-static inline struct str_node *strlist__next(struct str_node *sn)
-{
-	struct rb_node *rn;
-	if (!sn)
-		return NULL;
-	rn = rb_next(&sn->rb_node);
-	return rn ? rb_entry(rn, struct str_node, rb_node) : NULL;
-}
-
-/**
- * strlist_for_each      - iterate over a strlist
- * @pos:	the &struct str_node to use as a loop cursor.
- * @self:	the &struct strlist for loop.
- */
-#define strlist__for_each(pos, self)	\
-	for (pos = strlist__first(self); pos; pos = strlist__next(pos))
-
-/**
- * strlist_for_each_safe - iterate over a strlist safe against removal of
- *                         str_node
- * @pos:	the &struct str_node to use as a loop cursor.
- * @n:		another &struct str_node to use as temporary storage.
- * @self:	the &struct strlist for loop.
- */
-#define strlist__for_each_safe(pos, n, self)	\
-	for (pos = strlist__first(self), n = strlist__next(pos); pos;\
-	     pos = n, n = strlist__next(n))
-
-int strlist__parse_list(struct strlist *self, const char *s);
-#endif /* __PERF_STRLIST_H */
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index b2f5ae9..0319325 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -14,7 +14,7 @@
 #include "build-id.h"
 #include "debug.h"
 #include "symbol.h"
-#include "strlist.h"
+#include <lk/strlist.h>
 
 #include <libelf.h>
 #include <gelf.h>
-- 
1.7.3.1

