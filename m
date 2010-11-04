Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025Ab0KDPkB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 11:40:01 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:42027 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916Ab0KDPjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 11:39:55 -0400
From: Borislav Petkov <bp@amd64.org>
To: <acme@infradead.org>, <fweisbec@gmail.com>, <mingo@elte.hu>,
        <peterz@infradead.org>, <rostedt@goodmis.org>
Cc: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 18/20] Move string.c to the library
Date: Thu,  4 Nov 2010 16:36:54 +0100
Message-Id: <1288885016-18295-19-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1288885016-18295-1-git-send-email-bp@amd64.org>
References: <1288885016-18295-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

This one is generic enough so move it to lib/lk/string.c

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 tools/lib/lk/Makefile         |    1 +
 tools/lib/lk/string.c         |  296 +++++++++++++++++++++++++++++++++++++++++
 tools/lib/lk/util.h           |    2 +-
 tools/perf/Makefile           |    1 -
 tools/perf/bench/mem-memcpy.c |    2 +-
 tools/perf/util/string.c      |  296 -----------------------------------------
 6 files changed, 299 insertions(+), 299 deletions(-)
 create mode 100644 tools/lib/lk/string.c
 delete mode 100644 tools/perf/util/string.c

diff --git a/tools/lib/lk/Makefile b/tools/lib/lk/Makefile
index 36395b1..b81f11c 100644
--- a/tools/lib/lk/Makefile
+++ b/tools/lib/lk/Makefile
@@ -25,6 +25,7 @@ LIB_OBJS += rbtree.o
 LIB_OBJS += hweight.o
 LIB_OBJS += bitmap.o
 LIB_OBJS += strlist.o
+LIB_OBJS += string.o
 
 LIBFILE = $(LIB_OUTPUT)lklib.a
 
diff --git a/tools/lib/lk/string.c b/tools/lib/lk/string.c
new file mode 100644
index 0000000..0b02099
--- /dev/null
+++ b/tools/lib/lk/string.c
@@ -0,0 +1,296 @@
+#include <lk/util.h>
+#include "string.h"
+
+#define K 1024LL
+/*
+ * lk_atoll()
+ * Parse (\d+)(b|B|kb|KB|mb|MB|gb|GB|tb|TB) (e.g. "256MB")
+ * and return its numeric value
+ */
+s64 lk_atoll(const char *str)
+{
+	unsigned int i;
+	s64 length = -1, unit = 1;
+
+	if (!isdigit(str[0]))
+		goto out_err;
+
+	for (i = 1; i < strlen(str); i++) {
+		switch (str[i]) {
+		case 'B':
+		case 'b':
+			break;
+		case 'K':
+			if (str[i + 1] != 'B')
+				goto out_err;
+			else
+				goto kilo;
+		case 'k':
+			if (str[i + 1] != 'b')
+				goto out_err;
+kilo:
+			unit = K;
+			break;
+		case 'M':
+			if (str[i + 1] != 'B')
+				goto out_err;
+			else
+				goto mega;
+		case 'm':
+			if (str[i + 1] != 'b')
+				goto out_err;
+mega:
+			unit = K * K;
+			break;
+		case 'G':
+			if (str[i + 1] != 'B')
+				goto out_err;
+			else
+				goto giga;
+		case 'g':
+			if (str[i + 1] != 'b')
+				goto out_err;
+giga:
+			unit = K * K * K;
+			break;
+		case 'T':
+			if (str[i + 1] != 'B')
+				goto out_err;
+			else
+				goto tera;
+		case 't':
+			if (str[i + 1] != 'b')
+				goto out_err;
+tera:
+			unit = K * K * K * K;
+			break;
+		case '\0':	/* only specified figures */
+			unit = 1;
+			break;
+		default:
+			if (!isdigit(str[i]))
+				goto out_err;
+			break;
+		}
+	}
+
+	length = atoll(str) * unit;
+	goto out;
+
+out_err:
+	length = -1;
+out:
+	return length;
+}
+
+/*
+ * Helper function for splitting a string into an argv-like array.
+ * originaly copied from lib/argv_split.c
+ */
+static const char *skip_sep(const char *cp)
+{
+	while (*cp && isspace(*cp))
+		cp++;
+
+	return cp;
+}
+
+static const char *skip_arg(const char *cp)
+{
+	while (*cp && !isspace(*cp))
+		cp++;
+
+	return cp;
+}
+
+static int count_argc(const char *str)
+{
+	int count = 0;
+
+	while (*str) {
+		str = skip_sep(str);
+		if (*str) {
+			count++;
+			str = skip_arg(str);
+		}
+	}
+
+	return count;
+}
+
+/**
+ * argv_free - free an argv
+ * @argv - the argument vector to be freed
+ *
+ * Frees an argv and the strings it points to.
+ */
+void argv_free(char **argv)
+{
+	char **p;
+	for (p = argv; *p; p++)
+		free(*p);
+
+	free(argv);
+}
+
+/**
+ * argv_split - split a string at whitespace, returning an argv
+ * @str: the string to be split
+ * @argcp: returned argument count
+ *
+ * Returns an array of pointers to strings which are split out from
+ * @str.  This is performed by strictly splitting on white-space; no
+ * quote processing is performed.  Multiple whitespace characters are
+ * considered to be a single argument separator.  The returned array
+ * is always NULL-terminated.  Returns NULL on memory allocation
+ * failure.
+ */
+char **argv_split(const char *str, int *argcp)
+{
+	int argc = count_argc(str);
+	char **argv = zalloc(sizeof(*argv) * (argc+1));
+	char **argvp;
+
+	if (argv == NULL)
+		goto out;
+
+	if (argcp)
+		*argcp = argc;
+
+	argvp = argv;
+
+	while (*str) {
+		str = skip_sep(str);
+
+		if (*str) {
+			const char *p = str;
+			char *t;
+
+			str = skip_arg(str);
+
+			t = strndup(p, str-p);
+			if (t == NULL)
+				goto fail;
+			*argvp++ = t;
+		}
+	}
+	*argvp = NULL;
+
+out:
+	return argv;
+
+fail:
+	argv_free(argv);
+	return NULL;
+}
+
+/* Character class matching */
+static bool __match_charclass(const char *pat, char c, const char **npat)
+{
+	bool complement = false, ret = true;
+
+	if (*pat == '!') {
+		complement = true;
+		pat++;
+	}
+	if (*pat++ == c)	/* First character is special */
+		goto end;
+
+	while (*pat && *pat != ']') {	/* Matching */
+		if (*pat == '-' && *(pat + 1) != ']') {	/* Range */
+			if (*(pat - 1) <= c && c <= *(pat + 1))
+				goto end;
+			if (*(pat - 1) > *(pat + 1))
+				goto error;
+			pat += 2;
+		} else if (*pat++ == c)
+			goto end;
+	}
+	if (!*pat)
+		goto error;
+	ret = false;
+
+end:
+	while (*pat && *pat != ']')	/* Searching closing */
+		pat++;
+	if (!*pat)
+		goto error;
+	*npat = pat + 1;
+	return complement ? !ret : ret;
+
+error:
+	return false;
+}
+
+/* Glob/lazy pattern matching */
+static bool __match_glob(const char *str, const char *pat, bool ignore_space)
+{
+	while (*str && *pat && *pat != '*') {
+		if (ignore_space) {
+			/* Ignore spaces for lazy matching */
+			if (isspace(*str)) {
+				str++;
+				continue;
+			}
+			if (isspace(*pat)) {
+				pat++;
+				continue;
+			}
+		}
+		if (*pat == '?') {	/* Matches any single character */
+			str++;
+			pat++;
+			continue;
+		} else if (*pat == '[')	/* Character classes/Ranges */
+			if (__match_charclass(pat + 1, *str, &pat)) {
+				str++;
+				continue;
+			} else
+				return false;
+		else if (*pat == '\\') /* Escaped char match as normal char */
+			pat++;
+		if (*str++ != *pat++)
+			return false;
+	}
+	/* Check wild card */
+	if (*pat == '*') {
+		while (*pat == '*')
+			pat++;
+		if (!*pat)	/* Tail wild card matches all */
+			return true;
+		while (*str)
+			if (strglobmatch(str++, pat))
+				return true;
+	}
+	return !*str && !*pat;
+}
+
+/**
+ * strglobmatch - glob expression pattern matching
+ * @str: the target string to match
+ * @pat: the pattern string to match
+ *
+ * This returns true if the @str matches @pat. @pat can includes wildcards
+ * ('*','?') and character classes ([CHARS], complementation and ranges are
+ * also supported). Also, this supports escape character ('\') to use special
+ * characters as normal character.
+ *
+ * Note: if @pat syntax is broken, this always returns false.
+ */
+bool strglobmatch(const char *str, const char *pat)
+{
+	return __match_glob(str, pat, false);
+}
+
+/**
+ * strlazymatch - matching pattern strings lazily with glob pattern
+ * @str: the target string to match
+ * @pat: the pattern string to match
+ *
+ * This is similar to strglobmatch, except this ignores spaces in
+ * the target string.
+ */
+bool strlazymatch(const char *str, const char *pat)
+{
+	return __match_glob(str, pat, true);
+}
diff --git a/tools/lib/lk/util.h b/tools/lib/lk/util.h
index 23f3e61..bb6ba42 100644
--- a/tools/lib/lk/util.h
+++ b/tools/lib/lk/util.h
@@ -261,7 +261,7 @@ static inline int sane_case(int x, int high)
 int mkdir_p(char *path, mode_t mode);
 int copyfile(const char *from, const char *to);
 
-s64 perf_atoll(const char *str);
+s64 lk_atoll(const char *str);
 char **argv_split(const char *str, int *argcp);
 void argv_free(char **argv);
 bool strglobmatch(const char *str, const char *pat);
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index f899b08..96f7c65 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -387,7 +387,6 @@ LIB_OBJS += $(OUTPUT)util/parse-events.o
 LIB_OBJS += $(OUTPUT)util/run-command.o
 LIB_OBJS += $(OUTPUT)util/quote.o
 LIB_OBJS += $(OUTPUT)util/strbuf.o
-LIB_OBJS += $(OUTPUT)util/string.o
 LIB_OBJS += $(OUTPUT)util/wrapper.o
 LIB_OBJS += $(OUTPUT)util/sigchain.o
 LIB_OBJS += $(OUTPUT)util/pager.o
diff --git a/tools/perf/bench/mem-memcpy.c b/tools/perf/bench/mem-memcpy.c
index 1b2f508..86db09e 100644
--- a/tools/perf/bench/mem-memcpy.c
+++ b/tools/perf/bench/mem-memcpy.c
@@ -105,7 +105,7 @@ int bench_mem_memcpy(int argc, const char **argv,
 
 	tv_diff.tv_sec = 0;
 	tv_diff.tv_usec = 0;
-	length = (size_t)perf_atoll((char *)length_str);
+	length = (size_t)lk_atoll((char *)length_str);
 
 	if ((s64)length <= 0) {
 		fprintf(stderr, "Invalid length:%s\n", length_str);
diff --git a/tools/perf/util/string.c b/tools/perf/util/string.c
deleted file mode 100644
index 881ef63..0000000
--- a/tools/perf/util/string.c
+++ /dev/null
@@ -1,296 +0,0 @@
-#include <lk/util.h>
-#include "string.h"
-
-#define K 1024LL
-/*
- * perf_atoll()
- * Parse (\d+)(b|B|kb|KB|mb|MB|gb|GB|tb|TB) (e.g. "256MB")
- * and return its numeric value
- */
-s64 perf_atoll(const char *str)
-{
-	unsigned int i;
-	s64 length = -1, unit = 1;
-
-	if (!isdigit(str[0]))
-		goto out_err;
-
-	for (i = 1; i < strlen(str); i++) {
-		switch (str[i]) {
-		case 'B':
-		case 'b':
-			break;
-		case 'K':
-			if (str[i + 1] != 'B')
-				goto out_err;
-			else
-				goto kilo;
-		case 'k':
-			if (str[i + 1] != 'b')
-				goto out_err;
-kilo:
-			unit = K;
-			break;
-		case 'M':
-			if (str[i + 1] != 'B')
-				goto out_err;
-			else
-				goto mega;
-		case 'm':
-			if (str[i + 1] != 'b')
-				goto out_err;
-mega:
-			unit = K * K;
-			break;
-		case 'G':
-			if (str[i + 1] != 'B')
-				goto out_err;
-			else
-				goto giga;
-		case 'g':
-			if (str[i + 1] != 'b')
-				goto out_err;
-giga:
-			unit = K * K * K;
-			break;
-		case 'T':
-			if (str[i + 1] != 'B')
-				goto out_err;
-			else
-				goto tera;
-		case 't':
-			if (str[i + 1] != 'b')
-				goto out_err;
-tera:
-			unit = K * K * K * K;
-			break;
-		case '\0':	/* only specified figures */
-			unit = 1;
-			break;
-		default:
-			if (!isdigit(str[i]))
-				goto out_err;
-			break;
-		}
-	}
-
-	length = atoll(str) * unit;
-	goto out;
-
-out_err:
-	length = -1;
-out:
-	return length;
-}
-
-/*
- * Helper function for splitting a string into an argv-like array.
- * originaly copied from lib/argv_split.c
- */
-static const char *skip_sep(const char *cp)
-{
-	while (*cp && isspace(*cp))
-		cp++;
-
-	return cp;
-}
-
-static const char *skip_arg(const char *cp)
-{
-	while (*cp && !isspace(*cp))
-		cp++;
-
-	return cp;
-}
-
-static int count_argc(const char *str)
-{
-	int count = 0;
-
-	while (*str) {
-		str = skip_sep(str);
-		if (*str) {
-			count++;
-			str = skip_arg(str);
-		}
-	}
-
-	return count;
-}
-
-/**
- * argv_free - free an argv
- * @argv - the argument vector to be freed
- *
- * Frees an argv and the strings it points to.
- */
-void argv_free(char **argv)
-{
-	char **p;
-	for (p = argv; *p; p++)
-		free(*p);
-
-	free(argv);
-}
-
-/**
- * argv_split - split a string at whitespace, returning an argv
- * @str: the string to be split
- * @argcp: returned argument count
- *
- * Returns an array of pointers to strings which are split out from
- * @str.  This is performed by strictly splitting on white-space; no
- * quote processing is performed.  Multiple whitespace characters are
- * considered to be a single argument separator.  The returned array
- * is always NULL-terminated.  Returns NULL on memory allocation
- * failure.
- */
-char **argv_split(const char *str, int *argcp)
-{
-	int argc = count_argc(str);
-	char **argv = zalloc(sizeof(*argv) * (argc+1));
-	char **argvp;
-
-	if (argv == NULL)
-		goto out;
-
-	if (argcp)
-		*argcp = argc;
-
-	argvp = argv;
-
-	while (*str) {
-		str = skip_sep(str);
-
-		if (*str) {
-			const char *p = str;
-			char *t;
-
-			str = skip_arg(str);
-
-			t = strndup(p, str-p);
-			if (t == NULL)
-				goto fail;
-			*argvp++ = t;
-		}
-	}
-	*argvp = NULL;
-
-out:
-	return argv;
-
-fail:
-	argv_free(argv);
-	return NULL;
-}
-
-/* Character class matching */
-static bool __match_charclass(const char *pat, char c, const char **npat)
-{
-	bool complement = false, ret = true;
-
-	if (*pat == '!') {
-		complement = true;
-		pat++;
-	}
-	if (*pat++ == c)	/* First character is special */
-		goto end;
-
-	while (*pat && *pat != ']') {	/* Matching */
-		if (*pat == '-' && *(pat + 1) != ']') {	/* Range */
-			if (*(pat - 1) <= c && c <= *(pat + 1))
-				goto end;
-			if (*(pat - 1) > *(pat + 1))
-				goto error;
-			pat += 2;
-		} else if (*pat++ == c)
-			goto end;
-	}
-	if (!*pat)
-		goto error;
-	ret = false;
-
-end:
-	while (*pat && *pat != ']')	/* Searching closing */
-		pat++;
-	if (!*pat)
-		goto error;
-	*npat = pat + 1;
-	return complement ? !ret : ret;
-
-error:
-	return false;
-}
-
-/* Glob/lazy pattern matching */
-static bool __match_glob(const char *str, const char *pat, bool ignore_space)
-{
-	while (*str && *pat && *pat != '*') {
-		if (ignore_space) {
-			/* Ignore spaces for lazy matching */
-			if (isspace(*str)) {
-				str++;
-				continue;
-			}
-			if (isspace(*pat)) {
-				pat++;
-				continue;
-			}
-		}
-		if (*pat == '?') {	/* Matches any single character */
-			str++;
-			pat++;
-			continue;
-		} else if (*pat == '[')	/* Character classes/Ranges */
-			if (__match_charclass(pat + 1, *str, &pat)) {
-				str++;
-				continue;
-			} else
-				return false;
-		else if (*pat == '\\') /* Escaped char match as normal char */
-			pat++;
-		if (*str++ != *pat++)
-			return false;
-	}
-	/* Check wild card */
-	if (*pat == '*') {
-		while (*pat == '*')
-			pat++;
-		if (!*pat)	/* Tail wild card matches all */
-			return true;
-		while (*str)
-			if (strglobmatch(str++, pat))
-				return true;
-	}
-	return !*str && !*pat;
-}
-
-/**
- * strglobmatch - glob expression pattern matching
- * @str: the target string to match
- * @pat: the pattern string to match
- *
- * This returns true if the @str matches @pat. @pat can includes wildcards
- * ('*','?') and character classes ([CHARS], complementation and ranges are
- * also supported). Also, this supports escape character ('\') to use special
- * characters as normal character.
- *
- * Note: if @pat syntax is broken, this always returns false.
- */
-bool strglobmatch(const char *str, const char *pat)
-{
-	return __match_glob(str, pat, false);
-}
-
-/**
- * strlazymatch - matching pattern strings lazily with glob pattern
- * @str: the target string to match
- * @pat: the pattern string to match
- *
- * This is similar to strglobmatch, except this ignores spaces in
- * the target string.
- */
-bool strlazymatch(const char *str, const char *pat)
-{
-	return __match_glob(str, pat, true);
-}
-- 
1.7.3.1

