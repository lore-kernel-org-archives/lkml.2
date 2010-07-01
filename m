Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757392Ab0GAP6A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 11:58:00 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:47059 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757016Ab0GAPyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 11:54:06 -0400
From: Borislav Petkov <bp@amd64.org>
To: <linux-kernel@vger.kernel.org>
Subject: [PATCH 07/21] perf: rewire generic library stuff, p3
Date: Thu,  1 Jul 2010 17:55:49 +0200
Message-Id: <1277999763-20357-8-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1277999763-20357-1-git-send-email-bp@amd64.org>
References: <1277999763-20357-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Carve out generic library stuff into tools/lib/lk/ and rewire it with
perf. Relocate more generic stuff into <lk/util.h>

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 tools/lib/Makefile       |    5 ++
 tools/lib/lk/pstack.c    |   75 ++++++++++++++++++++++++++
 tools/lib/lk/pstack.h    |   12 ++++
 tools/lib/lk/strbuf.c    |  133 ++++++++++++++++++++++++++++++++++++++++++++++
 tools/lib/lk/strbuf.h    |   99 ++++++++++++++++++++++++++++++++++
 tools/lib/lk/usage.c     |   80 +++++++++++++++++++++++++++
 tools/lib/lk/util.h      |   21 +++++++-
 tools/perf/Makefile      |    5 --
 tools/perf/builtin.h     |    2 +-
 tools/perf/util/cache.h  |   23 +--------
 tools/perf/util/pstack.c |   75 --------------------------
 tools/perf/util/pstack.h |   12 ----
 tools/perf/util/strbuf.c |  133 ----------------------------------------------
 tools/perf/util/strbuf.h |   92 --------------------------------
 tools/perf/util/usage.c  |   80 ---------------------------
 15 files changed, 426 insertions(+), 421 deletions(-)
 create mode 100644 tools/lib/lk/pstack.c
 create mode 100644 tools/lib/lk/pstack.h
 create mode 100644 tools/lib/lk/strbuf.c
 create mode 100644 tools/lib/lk/strbuf.h
 create mode 100644 tools/lib/lk/usage.c
 delete mode 100644 tools/perf/util/pstack.c
 delete mode 100644 tools/perf/util/pstack.h
 delete mode 100644 tools/perf/util/strbuf.c
 delete mode 100644 tools/perf/util/strbuf.h
 delete mode 100644 tools/perf/util/usage.c

diff --git a/tools/lib/Makefile b/tools/lib/Makefile
index 7ebcf8c..64c0dbd 100644
--- a/tools/lib/Makefile
+++ b/tools/lib/Makefile
@@ -8,6 +8,8 @@ LIB_H += lk/cpumap.h
 LIB_H += lk/debugfs.h
 LIB_H += lk/util.h
 LIB_H += lk/types.h
+LIB_H += lk/pstack.h
+LIB_H += lk/strbuf.h
 
 LIB_OBJS += $(OUTPUT)lk/bitmap.o
 LIB_OBJS += $(OUTPUT)lk/cpumap.o
@@ -15,6 +17,9 @@ LIB_OBJS += $(OUTPUT)lk/ctype.o
 LIB_OBJS += $(OUTPUT)lk/debugfs.o
 LIB_OBJS += $(OUTPUT)lk/hweight.o
 LIB_OBJS += $(OUTPUT)lk/util.o
+LIB_OBJS += $(OUTPUT)lk/pstack.o
+LIB_OBJS += $(OUTPUT)lk/strbuf.o
+LIB_OBJS += $(OUTPUT)lk/usage.o
 
 LIBFILE = lklib.a
 
diff --git a/tools/lib/lk/pstack.c b/tools/lib/lk/pstack.c
new file mode 100644
index 0000000..13d36fa
--- /dev/null
+++ b/tools/lib/lk/pstack.c
@@ -0,0 +1,75 @@
+/*
+ * Simple pointer stack
+ *
+ * (c) 2010 Arnaldo Carvalho de Melo <acme@redhat.com>
+ */
+
+#include "util.h"
+#include "pstack.h"
+#include <linux/kernel.h>
+#include <stdlib.h>
+
+struct pstack {
+	unsigned short	top;
+	unsigned short	max_nr_entries;
+	void		*entries[0];
+};
+
+struct pstack *pstack__new(unsigned short max_nr_entries)
+{
+	struct pstack *self = zalloc((sizeof(*self) +
+				     max_nr_entries * sizeof(void *)));
+	if (self != NULL)
+		self->max_nr_entries = max_nr_entries;
+	return self;
+}
+
+void pstack__delete(struct pstack *self)
+{
+	free(self);
+}
+
+bool pstack__empty(const struct pstack *self)
+{
+	return self->top == 0;
+}
+
+void pstack__remove(struct pstack *self, void *key)
+{
+	unsigned short i = self->top, last_index = self->top - 1;
+
+	while (i-- != 0) {
+		if (self->entries[i] == key) {
+			if (i < last_index)
+				memmove(self->entries + i,
+					self->entries + i + 1,
+					(last_index - i) * sizeof(void *));
+			--self->top;
+			return;
+		}
+	}
+	pr_err("%s: %p not on the pstack!\n", __func__, key);
+}
+
+void pstack__push(struct pstack *self, void *key)
+{
+	if (self->top == self->max_nr_entries) {
+		pr_err("%s: top=%d, overflow!\n", __func__, self->top);
+		return;
+	}
+	self->entries[self->top++] = key;
+}
+
+void *pstack__pop(struct pstack *self)
+{
+	void *ret;
+
+	if (self->top == 0) {
+		pr_err("%s: underflow!\n", __func__);
+		return NULL;
+	}
+
+	ret = self->entries[--self->top];
+	self->entries[self->top] = NULL;
+	return ret;
+}
diff --git a/tools/lib/lk/pstack.h b/tools/lib/lk/pstack.h
new file mode 100644
index 0000000..aa0c248
--- /dev/null
+++ b/tools/lib/lk/pstack.h
@@ -0,0 +1,12 @@
+#ifndef __LK_PSTACK_H
+#define __LK_PSTACK_H
+
+struct pstack;
+struct pstack *pstack__new(unsigned short max_nr_entries);
+void pstack__delete(struct pstack *self);
+bool pstack__empty(const struct pstack *self);
+void pstack__remove(struct pstack *self, void *key);
+void pstack__push(struct pstack *self, void *key);
+void *pstack__pop(struct pstack *self);
+
+#endif /* __LK_PSTACK_H */
diff --git a/tools/lib/lk/strbuf.c b/tools/lib/lk/strbuf.c
new file mode 100644
index 0000000..699143e
--- /dev/null
+++ b/tools/lib/lk/strbuf.c
@@ -0,0 +1,133 @@
+#include "strbuf.h"
+
+int prefixcmp(const char *str, const char *prefix)
+{
+	for (; ; str++, prefix++)
+		if (!*prefix)
+			return 0;
+		else if (*str != *prefix)
+			return (unsigned char)*prefix - (unsigned char)*str;
+}
+
+/*
+ * Used as the default ->buf value, so that people can always assume
+ * buf is non NULL and ->buf is NUL terminated even for a freshly
+ * initialized strbuf.
+ */
+char strbuf_slopbuf[1];
+
+void strbuf_init(struct strbuf *sb, ssize_t hint)
+{
+	sb->alloc = sb->len = 0;
+	sb->buf = strbuf_slopbuf;
+	if (hint)
+		strbuf_grow(sb, hint);
+}
+
+void strbuf_release(struct strbuf *sb)
+{
+	if (sb->alloc) {
+		free(sb->buf);
+		strbuf_init(sb, 0);
+	}
+}
+
+char *strbuf_detach(struct strbuf *sb, size_t *sz)
+{
+	char *res = sb->alloc ? sb->buf : NULL;
+	if (sz)
+		*sz = sb->len;
+	strbuf_init(sb, 0);
+	return res;
+}
+
+void strbuf_grow(struct strbuf *sb, size_t extra)
+{
+	if (sb->len + extra + 1 <= sb->len)
+		die("you want to use way too much memory");
+	if (!sb->alloc)
+		sb->buf = NULL;
+	ALLOC_GROW(sb->buf, sb->len + extra + 1, sb->alloc);
+}
+
+static void strbuf_splice(struct strbuf *sb, size_t pos, size_t len,
+				   const void *data, size_t dlen)
+{
+	if (pos + len < pos)
+		die("you want to use way too much memory");
+	if (pos > sb->len)
+		die("`pos' is too far after the end of the buffer");
+	if (pos + len > sb->len)
+		die("`pos + len' is too far after the end of the buffer");
+
+	if (dlen >= len)
+		strbuf_grow(sb, dlen - len);
+	memmove(sb->buf + pos + dlen,
+			sb->buf + pos + len,
+			sb->len - pos - len);
+	memcpy(sb->buf + pos, data, dlen);
+	strbuf_setlen(sb, sb->len + dlen - len);
+}
+
+void strbuf_remove(struct strbuf *sb, size_t pos, size_t len)
+{
+	strbuf_splice(sb, pos, len, NULL, 0);
+}
+
+void strbuf_add(struct strbuf *sb, const void *data, size_t len)
+{
+	strbuf_grow(sb, len);
+	memcpy(sb->buf + sb->len, data, len);
+	strbuf_setlen(sb, sb->len + len);
+}
+
+void strbuf_addf(struct strbuf *sb, const char *fmt, ...)
+{
+	int len;
+	va_list ap;
+
+	if (!strbuf_avail(sb))
+		strbuf_grow(sb, 64);
+	va_start(ap, fmt);
+	len = vsnprintf(sb->buf + sb->len, sb->alloc - sb->len, fmt, ap);
+	va_end(ap);
+	if (len < 0)
+		die("your vsnprintf is broken");
+	if (len > strbuf_avail(sb)) {
+		strbuf_grow(sb, len);
+		va_start(ap, fmt);
+		len = vsnprintf(sb->buf + sb->len, sb->alloc - sb->len, fmt, ap);
+		va_end(ap);
+		if (len > strbuf_avail(sb)) {
+			die("this should not happen, your snprintf is broken");
+		}
+	}
+	strbuf_setlen(sb, sb->len + len);
+}
+
+ssize_t strbuf_read(struct strbuf *sb, int fd, ssize_t hint)
+{
+	size_t oldlen = sb->len;
+	size_t oldalloc = sb->alloc;
+
+	strbuf_grow(sb, hint ? hint : 8192);
+	for (;;) {
+		ssize_t cnt;
+
+		cnt = read(fd, sb->buf + sb->len, sb->alloc - sb->len - 1);
+		if (cnt < 0) {
+			if (oldalloc == 0)
+				strbuf_release(sb);
+			else
+				strbuf_setlen(sb, oldlen);
+			return -1;
+		}
+		if (!cnt)
+			break;
+		sb->len += cnt;
+		strbuf_grow(sb, 8192);
+	}
+
+	sb->buf[sb->len] = '\0';
+	return sb->len - oldlen;
+}
diff --git a/tools/lib/lk/strbuf.h b/tools/lib/lk/strbuf.h
new file mode 100644
index 0000000..147c5b4
--- /dev/null
+++ b/tools/lib/lk/strbuf.h
@@ -0,0 +1,99 @@
+#ifndef __LK_STRBUF_H
+#define __LK_STRBUF_H
+
+/*
+ * Strbuf's can be use in many ways: as a byte array, or to store arbitrary
+ * long, overflow safe strings.
+ *
+ * Strbufs has some invariants that are very important to keep in mind:
+ *
+ * 1. the ->buf member is always malloc-ed, hence strbuf's can be used to
+ *    build complex strings/buffers whose final size isn't easily known.
+ *
+ *    It is NOT legal to copy the ->buf pointer away.
+ *    `strbuf_detach' is the operation that detachs a buffer from its shell
+ *    while keeping the shell valid wrt its invariants.
+ *
+ * 2. the ->buf member is a byte array that has at least ->len + 1 bytes
+ *    allocated. The extra byte is used to store a '\0', allowing the ->buf
+ *    member to be a valid C-string. Every strbuf function ensure this
+ *    invariant is preserved.
+ *
+ *    Note that it is OK to "play" with the buffer directly if you work it
+ *    that way:
+ *
+ *    strbuf_grow(sb, SOME_SIZE);
+ *       ... Here, the memory array starting at sb->buf, and of length
+ *       ... strbuf_avail(sb) is all yours, and you are sure that
+ *       ... strbuf_avail(sb) is at least SOME_SIZE.
+ *    strbuf_setlen(sb, sb->len + SOME_OTHER_SIZE);
+ *
+ *    Of course, SOME_OTHER_SIZE must be smaller or equal to strbuf_avail(sb).
+ *
+ *    Doing so is safe, though if it has to be done in many places, adding the
+ *    missing API to the strbuf module is the way to go.
+ *
+ *    XXX: do _not_ assume that the area that is yours is of size ->alloc - 1
+ *         even if it's true in the current implementation. Alloc is somehow a
+ *         "private" member that should not be messed with.
+ */
+
+#include <assert.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/types.h>
+
+#include "util.h"
+
+extern char strbuf_slopbuf[];
+struct strbuf {
+	size_t alloc;
+	size_t len;
+	char *buf;
+};
+
+#define STRBUF_INIT  { 0, 0, strbuf_slopbuf }
+
+extern int prefixcmp(const char *str, const char *prefix);
+
+/*----- strbuf life cycle -----*/
+extern void strbuf_init(struct strbuf *buf, ssize_t hint);
+extern void strbuf_release(struct strbuf *);
+extern char *strbuf_detach(struct strbuf *, size_t *);
+
+/*----- strbuf size related -----*/
+static inline ssize_t strbuf_avail(const struct strbuf *sb) {
+	return sb->alloc ? sb->alloc - sb->len - 1 : 0;
+}
+
+extern void strbuf_grow(struct strbuf *, size_t);
+
+static inline void strbuf_setlen(struct strbuf *sb, size_t len) {
+	if (!sb->alloc)
+		strbuf_grow(sb, 0);
+	assert(len < sb->alloc);
+	sb->len = len;
+	sb->buf[len] = '\0';
+}
+
+/*----- add data in your buffer -----*/
+static inline void strbuf_addch(struct strbuf *sb, int c) {
+	strbuf_grow(sb, 1);
+	sb->buf[sb->len++] = c;
+	sb->buf[sb->len] = '\0';
+}
+
+extern void strbuf_remove(struct strbuf *, size_t pos, size_t len);
+
+extern void strbuf_add(struct strbuf *, const void *, size_t);
+static inline void strbuf_addstr(struct strbuf *sb, const char *s) {
+	strbuf_add(sb, s, strlen(s));
+}
+
+__attribute__((format(printf,2,3)))
+extern void strbuf_addf(struct strbuf *sb, const char *fmt, ...);
+
+/* XXX: if read fails, any partial read is undone */
+extern ssize_t strbuf_read(struct strbuf *, int fd, ssize_t hint);
+
+#endif /* __LK_STRBUF_H */
diff --git a/tools/lib/lk/usage.c b/tools/lib/lk/usage.c
new file mode 100644
index 0000000..d438743
--- /dev/null
+++ b/tools/lib/lk/usage.c
@@ -0,0 +1,80 @@
+/*
+ * GIT - The information manager from hell
+ *
+ * Copyright (C) Linus Torvalds, 2005
+ */
+#include <lk/util.h>
+
+static void report(const char *prefix, const char *err, va_list params)
+{
+	char msg[1024];
+	vsnprintf(msg, sizeof(msg), err, params);
+	fprintf(stderr, " %s%s\n", prefix, msg);
+}
+
+static NORETURN void usage_builtin(const char *err)
+{
+	fprintf(stderr, "\n Usage: %s\n", err);
+	exit(129);
+}
+
+static NORETURN void die_builtin(const char *err, va_list params)
+{
+	report(" Fatal: ", err, params);
+	exit(128);
+}
+
+static void error_builtin(const char *err, va_list params)
+{
+	report(" Error: ", err, params);
+}
+
+static void warn_builtin(const char *warn, va_list params)
+{
+	report(" Warning: ", warn, params);
+}
+
+/* If we are in a dlopen()ed .so write to a global variable would segfault
+ * (ugh), so keep things static. */
+static void (*usage_routine)(const char *err) NORETURN = usage_builtin;
+static void (*die_routine)(const char *err, va_list params) NORETURN = die_builtin;
+static void (*error_routine)(const char *err, va_list params) = error_builtin;
+static void (*warn_routine)(const char *err, va_list params) = warn_builtin;
+
+void set_die_routine(void (*routine)(const char *err, va_list params) NORETURN)
+{
+	die_routine = routine;
+}
+
+void usage(const char *err)
+{
+	usage_routine(err);
+}
+
+void die(const char *err, ...)
+{
+	va_list params;
+
+	va_start(params, err);
+	die_routine(err, params);
+	va_end(params);
+}
+
+int error(const char *err, ...)
+{
+	va_list params;
+
+	va_start(params, err);
+	error_routine(err, params);
+	va_end(params);
+	return -1;
+}
+
+void warning(const char *warn, ...)
+{
+	va_list params;
+
+	va_start(params, warn);
+	warn_routine(warn, params);
+	va_end(params);
+}
diff --git a/tools/lib/lk/util.h b/tools/lib/lk/util.h
index f380fed..dc88970 100644
--- a/tools/lib/lk/util.h
+++ b/tools/lib/lk/util.h
@@ -141,6 +141,26 @@ extern void die(const char *err, ...) NORETURN __attribute__((format (printf, 1,
 extern int error(const char *err, ...) __attribute__((format (printf, 1, 2)));
 extern void warning(const char *err, ...) __attribute__((format (printf, 1, 2)));
 
+#define alloc_nr(x) (((x)+16)*3/2)
+
+/*
+ * Realloc the buffer pointed at by variable 'x' so that it can hold
+ * at least 'nr' entries; the number of entries currently allocated
+ * is 'alloc', using the standard growing factor alloc_nr() macro.
+ *
+ * DO NOT USE any expression with side-effect for 'x' or 'alloc'.
+ */
+#define ALLOC_GROW(x, nr, alloc) \
+	do { \
+		if ((nr) > alloc) { \
+			if (alloc_nr(alloc) < (nr)) \
+				alloc = (nr); \
+			else \
+				alloc = alloc_nr(alloc); \
+			x = xrealloc((x), alloc * sizeof(*(x))); \
+		} \
+	} while(0)
+
 #include "../../../include/linux/stringify.h"
 
 #define DIE_IF(cnd)	\
@@ -152,7 +172,6 @@ extern void warning(const char *err, ...) __attribute__((format (printf, 1, 2)))
 
 extern void set_die_routine(void (*routine)(const char *err, va_list params) NORETURN);
 
-extern int prefixcmp(const char *str, const char *prefix);
 extern void set_buildid_dir(void);
 extern void disable_buildid_cache(void);
 
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index e224788..6fc4c4a 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -366,7 +366,6 @@ LIB_H += util/quote.h
 LIB_H += util/header.h
 LIB_H += util/help.h
 LIB_H += util/session.h
-LIB_H += util/strbuf.h
 LIB_H += util/strlist.h
 LIB_H += util/svghelper.h
 LIB_H += util/run-command.h
@@ -380,7 +379,6 @@ LIB_H += util/thread.h
 LIB_H += util/trace-event.h
 LIB_H += util/probe-finder.h
 LIB_H += util/probe-event.h
-LIB_H += util/pstack.h
 
 LIB_OBJS += $(OUTPUT)util/abspath.o
 LIB_OBJS += $(OUTPUT)util/alias.o
@@ -397,10 +395,8 @@ LIB_OBJS += $(OUTPUT)util/path.o
 LIB_OBJS += $(OUTPUT)util/rbtree.o
 LIB_OBJS += $(OUTPUT)util/run-command.o
 LIB_OBJS += $(OUTPUT)util/quote.o
-LIB_OBJS += $(OUTPUT)util/strbuf.o
 LIB_OBJS += $(OUTPUT)util/string.o
 LIB_OBJS += $(OUTPUT)util/strlist.o
-LIB_OBJS += $(OUTPUT)util/usage.o
 LIB_OBJS += $(OUTPUT)util/wrapper.o
 LIB_OBJS += $(OUTPUT)util/sigchain.o
 LIB_OBJS += $(OUTPUT)util/symbol.o
@@ -411,7 +407,6 @@ LIB_OBJS += $(OUTPUT)util/callchain.o
 LIB_OBJS += $(OUTPUT)util/values.o
 LIB_OBJS += $(OUTPUT)util/debug.o
 LIB_OBJS += $(OUTPUT)util/map.o
-LIB_OBJS += $(OUTPUT)util/pstack.o
 LIB_OBJS += $(OUTPUT)util/session.o
 LIB_OBJS += $(OUTPUT)util/thread.o
 LIB_OBJS += $(OUTPUT)util/trace-event-parse.o
diff --git a/tools/perf/builtin.h b/tools/perf/builtin.h
index 08e69d2..8d46079 100644
--- a/tools/perf/builtin.h
+++ b/tools/perf/builtin.h
@@ -2,7 +2,7 @@
 #define BUILTIN_H
 
 #include <lk/util.h>
-#include "util/strbuf.h"
+#include <lk/strbuf.h>
 
 extern const char perf_version_string[];
 extern const char perf_usage_string[];
diff --git a/tools/perf/util/cache.h b/tools/perf/util/cache.h
index ce83e82..93570a8 100644
--- a/tools/perf/util/cache.h
+++ b/tools/perf/util/cache.h
@@ -3,7 +3,7 @@
 
 #include <stdbool.h>
 #include <lk/util.h>
-#include "strbuf.h"
+#include <lk/strbuf.h>
 #include "../perf.h"
 #include <linux/compiler.h>
 
@@ -47,27 +47,6 @@ void exit_browser(bool wait_for_ok);
 char *alias_lookup(const char *alias);
 int split_cmdline(char *cmdline, const char ***argv);
 
-#define alloc_nr(x) (((x)+16)*3/2)
-
-/*
- * Realloc the buffer pointed at by variable 'x' so that it can hold
- * at least 'nr' entries; the number of entries currently allocated
- * is 'alloc', using the standard growing factor alloc_nr() macro.
- *
- * DO NOT USE any expression with side-effect for 'x' or 'alloc'.
- */
-#define ALLOC_GROW(x, nr, alloc) \
-	do { \
-		if ((nr) > alloc) { \
-			if (alloc_nr(alloc) < (nr)) \
-				alloc = (nr); \
-			else \
-				alloc = alloc_nr(alloc); \
-			x = xrealloc((x), alloc * sizeof(*(x))); \
-		} \
-	} while(0)
-
-
 static inline int is_absolute_path(const char *path)
 {
 	return path[0] == '/';
diff --git a/tools/perf/util/pstack.c b/tools/perf/util/pstack.c
deleted file mode 100644
index aacedb8..0000000
--- a/tools/perf/util/pstack.c
+++ /dev/null
@@ -1,75 +0,0 @@
-/*
- * Simple pointer stack
- *
- * (c) 2010 Arnaldo Carvalho de Melo <acme@redhat.com>
- */
-
-#include <lk/util.h>
-#include "pstack.h"
-#include <linux/kernel.h>
-#include <stdlib.h>
-
-struct pstack {
-	unsigned short	top;
-	unsigned short	max_nr_entries;
-	void		*entries[0];
-};
-
-struct pstack *pstack__new(unsigned short max_nr_entries)
-{
-	struct pstack *self = zalloc((sizeof(*self) +
-				     max_nr_entries * sizeof(void *)));
-	if (self != NULL)
-		self->max_nr_entries = max_nr_entries;
-	return self;
-}
-
-void pstack__delete(struct pstack *self)
-{
-	free(self);
-}
-
-bool pstack__empty(const struct pstack *self)
-{
-	return self->top == 0;
-}
-
-void pstack__remove(struct pstack *self, void *key)
-{
-	unsigned short i = self->top, last_index = self->top - 1;
-
-	while (i-- != 0) {
-		if (self->entries[i] == key) {
-			if (i < last_index)
-				memmove(self->entries + i,
-					self->entries + i + 1,
-					(last_index - i) * sizeof(void *));
-			--self->top;
-			return;
-		}
-	}
-	pr_err("%s: %p not on the pstack!\n", __func__, key);
-}
-
-void pstack__push(struct pstack *self, void *key)
-{
-	if (self->top == self->max_nr_entries) {
-		pr_err("%s: top=%d, overflow!\n", __func__, self->top);
-		return;
-	}
-	self->entries[self->top++] = key;
-}
-
-void *pstack__pop(struct pstack *self)
-{
-	void *ret;
-
-	if (self->top == 0) {
-		pr_err("%s: underflow!\n", __func__);
-		return NULL;
-	}
-
-	ret = self->entries[--self->top];
-	self->entries[self->top] = NULL;
-	return ret;
-}
diff --git a/tools/perf/util/pstack.h b/tools/perf/util/pstack.h
deleted file mode 100644
index 5ad0702..0000000
--- a/tools/perf/util/pstack.h
+++ /dev/null
@@ -1,12 +0,0 @@
-#ifndef _PERF_PSTACK_
-#define _PERF_PSTACK_
-
-struct pstack;
-struct pstack *pstack__new(unsigned short max_nr_entries);
-void pstack__delete(struct pstack *self);
-bool pstack__empty(const struct pstack *self);
-void pstack__remove(struct pstack *self, void *key);
-void pstack__push(struct pstack *self, void *key);
-void *pstack__pop(struct pstack *self);
-
-#endif /* _PERF_PSTACK_ */
diff --git a/tools/perf/util/strbuf.c b/tools/perf/util/strbuf.c
deleted file mode 100644
index 92e0685..0000000
--- a/tools/perf/util/strbuf.c
+++ /dev/null
@@ -1,133 +0,0 @@
-#include "cache.h"
-
-int prefixcmp(const char *str, const char *prefix)
-{
-	for (; ; str++, prefix++)
-		if (!*prefix)
-			return 0;
-		else if (*str != *prefix)
-			return (unsigned char)*prefix - (unsigned char)*str;
-}
-
-/*
- * Used as the default ->buf value, so that people can always assume
- * buf is non NULL and ->buf is NUL terminated even for a freshly
- * initialized strbuf.
- */
-char strbuf_slopbuf[1];
-
-void strbuf_init(struct strbuf *sb, ssize_t hint)
-{
-	sb->alloc = sb->len = 0;
-	sb->buf = strbuf_slopbuf;
-	if (hint)
-		strbuf_grow(sb, hint);
-}
-
-void strbuf_release(struct strbuf *sb)
-{
-	if (sb->alloc) {
-		free(sb->buf);
-		strbuf_init(sb, 0);
-	}
-}
-
-char *strbuf_detach(struct strbuf *sb, size_t *sz)
-{
-	char *res = sb->alloc ? sb->buf : NULL;
-	if (sz)
-		*sz = sb->len;
-	strbuf_init(sb, 0);
-	return res;
-}
-
-void strbuf_grow(struct strbuf *sb, size_t extra)
-{
-	if (sb->len + extra + 1 <= sb->len)
-		die("you want to use way too much memory");
-	if (!sb->alloc)
-		sb->buf = NULL;
-	ALLOC_GROW(sb->buf, sb->len + extra + 1, sb->alloc);
-}
-
-static void strbuf_splice(struct strbuf *sb, size_t pos, size_t len,
-				   const void *data, size_t dlen)
-{
-	if (pos + len < pos)
-		die("you want to use way too much memory");
-	if (pos > sb->len)
-		die("`pos' is too far after the end of the buffer");
-	if (pos + len > sb->len)
-		die("`pos + len' is too far after the end of the buffer");
-
-	if (dlen >= len)
-		strbuf_grow(sb, dlen - len);
-	memmove(sb->buf + pos + dlen,
-			sb->buf + pos + len,
-			sb->len - pos - len);
-	memcpy(sb->buf + pos, data, dlen);
-	strbuf_setlen(sb, sb->len + dlen - len);
-}
-
-void strbuf_remove(struct strbuf *sb, size_t pos, size_t len)
-{
-	strbuf_splice(sb, pos, len, NULL, 0);
-}
-
-void strbuf_add(struct strbuf *sb, const void *data, size_t len)
-{
-	strbuf_grow(sb, len);
-	memcpy(sb->buf + sb->len, data, len);
-	strbuf_setlen(sb, sb->len + len);
-}
-
-void strbuf_addf(struct strbuf *sb, const char *fmt, ...)
-{
-	int len;
-	va_list ap;
-
-	if (!strbuf_avail(sb))
-		strbuf_grow(sb, 64);
-	va_start(ap, fmt);
-	len = vsnprintf(sb->buf + sb->len, sb->alloc - sb->len, fmt, ap);
-	va_end(ap);
-	if (len < 0)
-		die("your vsnprintf is broken");
-	if (len > strbuf_avail(sb)) {
-		strbuf_grow(sb, len);
-		va_start(ap, fmt);
-		len = vsnprintf(sb->buf + sb->len, sb->alloc - sb->len, fmt, ap);
-		va_end(ap);
-		if (len > strbuf_avail(sb)) {
-			die("this should not happen, your snprintf is broken");
-		}
-	}
-	strbuf_setlen(sb, sb->len + len);
-}
-
-ssize_t strbuf_read(struct strbuf *sb, int fd, ssize_t hint)
-{
-	size_t oldlen = sb->len;
-	size_t oldalloc = sb->alloc;
-
-	strbuf_grow(sb, hint ? hint : 8192);
-	for (;;) {
-		ssize_t cnt;
-
-		cnt = read(fd, sb->buf + sb->len, sb->alloc - sb->len - 1);
-		if (cnt < 0) {
-			if (oldalloc == 0)
-				strbuf_release(sb);
-			else
-				strbuf_setlen(sb, oldlen);
-			return -1;
-		}
-		if (!cnt)
-			break;
-		sb->len += cnt;
-		strbuf_grow(sb, 8192);
-	}
-
-	sb->buf[sb->len] = '\0';
-	return sb->len - oldlen;
-}
diff --git a/tools/perf/util/strbuf.h b/tools/perf/util/strbuf.h
deleted file mode 100644
index 436ac31..0000000
--- a/tools/perf/util/strbuf.h
+++ /dev/null
@@ -1,92 +0,0 @@
-#ifndef __PERF_STRBUF_H
-#define __PERF_STRBUF_H
-
-/*
- * Strbuf's can be use in many ways: as a byte array, or to store arbitrary
- * long, overflow safe strings.
- *
- * Strbufs has some invariants that are very important to keep in mind:
- *
- * 1. the ->buf member is always malloc-ed, hence strbuf's can be used to
- *    build complex strings/buffers whose final size isn't easily known.
- *
- *    It is NOT legal to copy the ->buf pointer away.
- *    `strbuf_detach' is the operation that detachs a buffer from its shell
- *    while keeping the shell valid wrt its invariants.
- *
- * 2. the ->buf member is a byte array that has at least ->len + 1 bytes
- *    allocated. The extra byte is used to store a '\0', allowing the ->buf
- *    member to be a valid C-string. Every strbuf function ensure this
- *    invariant is preserved.
- *
- *    Note that it is OK to "play" with the buffer directly if you work it
- *    that way:
- *
- *    strbuf_grow(sb, SOME_SIZE);
- *       ... Here, the memory array starting at sb->buf, and of length
- *       ... strbuf_avail(sb) is all yours, and you are sure that
- *       ... strbuf_avail(sb) is at least SOME_SIZE.
- *    strbuf_setlen(sb, sb->len + SOME_OTHER_SIZE);
- *
- *    Of course, SOME_OTHER_SIZE must be smaller or equal to strbuf_avail(sb).
- *
- *    Doing so is safe, though if it has to be done in many places, adding the
- *    missing API to the strbuf module is the way to go.
- *
- *    XXX: do _not_ assume that the area that is yours is of size ->alloc - 1
- *         even if it's true in the current implementation. Alloc is somehow a
- *         "private" member that should not be messed with.
- */
-
-#include <assert.h>
-
-extern char strbuf_slopbuf[];
-struct strbuf {
-	size_t alloc;
-	size_t len;
-	char *buf;
-};
-
-#define STRBUF_INIT  { 0, 0, strbuf_slopbuf }
-
-/*----- strbuf life cycle -----*/
-extern void strbuf_init(struct strbuf *buf, ssize_t hint);
-extern void strbuf_release(struct strbuf *);
-extern char *strbuf_detach(struct strbuf *, size_t *);
-
-/*----- strbuf size related -----*/
-static inline ssize_t strbuf_avail(const struct strbuf *sb) {
-	return sb->alloc ? sb->alloc - sb->len - 1 : 0;
-}
-
-extern void strbuf_grow(struct strbuf *, size_t);
-
-static inline void strbuf_setlen(struct strbuf *sb, size_t len) {
-	if (!sb->alloc)
-		strbuf_grow(sb, 0);
-	assert(len < sb->alloc);
-	sb->len = len;
-	sb->buf[len] = '\0';
-}
-
-/*----- add data in your buffer -----*/
-static inline void strbuf_addch(struct strbuf *sb, int c) {
-	strbuf_grow(sb, 1);
-	sb->buf[sb->len++] = c;
-	sb->buf[sb->len] = '\0';
-}
-
-extern void strbuf_remove(struct strbuf *, size_t pos, size_t len);
-
-extern void strbuf_add(struct strbuf *, const void *, size_t);
-static inline void strbuf_addstr(struct strbuf *sb, const char *s) {
-	strbuf_add(sb, s, strlen(s));
-}
-
-__attribute__((format(printf,2,3)))
-extern void strbuf_addf(struct strbuf *sb, const char *fmt, ...);
-
-/* XXX: if read fails, any partial read is undone */
-extern ssize_t strbuf_read(struct strbuf *, int fd, ssize_t hint);
-
-#endif /* __PERF_STRBUF_H */
diff --git a/tools/perf/util/usage.c b/tools/perf/util/usage.c
deleted file mode 100644
index d438743..0000000
--- a/tools/perf/util/usage.c
+++ /dev/null
@@ -1,80 +0,0 @@
-/*
- * GIT - The information manager from hell
- *
- * Copyright (C) Linus Torvalds, 2005
- */
-#include <lk/util.h>
-
-static void report(const char *prefix, const char *err, va_list params)
-{
-	char msg[1024];
-	vsnprintf(msg, sizeof(msg), err, params);
-	fprintf(stderr, " %s%s\n", prefix, msg);
-}
-
-static NORETURN void usage_builtin(const char *err)
-{
-	fprintf(stderr, "\n Usage: %s\n", err);
-	exit(129);
-}
-
-static NORETURN void die_builtin(const char *err, va_list params)
-{
-	report(" Fatal: ", err, params);
-	exit(128);
-}
-
-static void error_builtin(const char *err, va_list params)
-{
-	report(" Error: ", err, params);
-}
-
-static void warn_builtin(const char *warn, va_list params)
-{
-	report(" Warning: ", warn, params);
-}
-
-/* If we are in a dlopen()ed .so write to a global variable would segfault
- * (ugh), so keep things static. */
-static void (*usage_routine)(const char *err) NORETURN = usage_builtin;
-static void (*die_routine)(const char *err, va_list params) NORETURN = die_builtin;
-static void (*error_routine)(const char *err, va_list params) = error_builtin;
-static void (*warn_routine)(const char *err, va_list params) = warn_builtin;
-
-void set_die_routine(void (*routine)(const char *err, va_list params) NORETURN)
-{
-	die_routine = routine;
-}
-
-void usage(const char *err)
-{
-	usage_routine(err);
-}
-
-void die(const char *err, ...)
-{
-	va_list params;
-
-	va_start(params, err);
-	die_routine(err, params);
-	va_end(params);
-}
-
-int error(const char *err, ...)
-{
-	va_list params;
-
-	va_start(params, err);
-	error_routine(err, params);
-	va_end(params);
-	return -1;
-}
-
-void warning(const char *warn, ...)
-{
-	va_list params;
-
-	va_start(params, warn);
-	warn_routine(warn, params);
-	va_end(params);
-}
-- 
1.7.1

