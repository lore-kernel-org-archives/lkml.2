Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118Ab0CYW7j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 18:59:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:58730 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722Ab0CYW7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 18:59:13 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 5/6] perf symbols: Move hex2u64 and strxfrchar to symbol.c
Date: Thu, 25 Mar 2010 19:59:00 -0300
Message-Id: <1269557941-15617-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1269557941-15617-1-git-send-email-acme@infradead.org>
References: <1269557941-15617-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Mostly used in symbol.c so move them there to reduce the number of files
needed to use the symbol system.

Also do some header adjustments with the same intent.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/parse-events.c |    1 +
 tools/perf/util/string.c       |   43 --------------------
 tools/perf/util/string.h       |    2 -
 tools/perf/util/symbol.c       |   85 +++++++++++++++++++++++++++++++--------
 tools/perf/util/symbol.h       |   10 ++++-
 5 files changed, 76 insertions(+), 65 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index a201445..435781e 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -5,6 +5,7 @@
 #include "parse-events.h"
 #include "exec_cmd.h"
 #include "string.h"
+#include "symbol.h"
 #include "cache.h"
 #include "header.h"
 #include "debugfs.h"
diff --git a/tools/perf/util/string.c b/tools/perf/util/string.c
index a175949..d438924 100644
--- a/tools/perf/util/string.c
+++ b/tools/perf/util/string.c
@@ -1,49 +1,6 @@
 #include "string.h"
 #include "util.h"
 
-static int hex(char ch)
-{
-	if ((ch >= '0') && (ch <= '9'))
-		return ch - '0';
-	if ((ch >= 'a') && (ch <= 'f'))
-		return ch - 'a' + 10;
-	if ((ch >= 'A') && (ch <= 'F'))
-		return ch - 'A' + 10;
-	return -1;
-}
-
-/*
- * While we find nice hex chars, build a long_val.
- * Return number of chars processed.
- */
-int hex2u64(const char *ptr, u64 *long_val)
-{
-	const char *p = ptr;
-	*long_val = 0;
-
-	while (*p) {
-		const int hex_val = hex(*p);
-
-		if (hex_val < 0)
-			break;
-
-		*long_val = (*long_val << 4) | hex_val;
-		p++;
-	}
-
-	return p - ptr;
-}
-
-char *strxfrchar(char *s, char from, char to)
-{
-	char *p = s;
-
-	while ((p = strchr(p, from)) != NULL)
-		*p++ = to;
-
-	return s;
-}
-
 #define K 1024LL
 /*
  * perf_atoll()
diff --git a/tools/perf/util/string.h b/tools/perf/util/string.h
index 542e44d..7005824 100644
--- a/tools/perf/util/string.h
+++ b/tools/perf/util/string.h
@@ -4,8 +4,6 @@
 #include <stdbool.h>
 #include "types.h"
 
-int hex2u64(const char *ptr, u64 *val);
-char *strxfrchar(char *s, char from, char to);
 s64 perf_atoll(const char *str);
 char **argv_split(const char *str, int *argcp);
 void argv_free(char **argv);
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 3eb9de4..f3d4151 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1,13 +1,19 @@
-#include "util.h"
-#include "../perf.h"
-#include "sort.h"
-#include "string.h"
+#define _GNU_SOURCE
+#include <ctype.h>
+#include <dirent.h>
+#include <errno.h>
+#include <libgen.h>
+#include <stdlib.h>
+#include <stdio.h>
+#include <string.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/param.h>
+#include <fcntl.h>
+#include <unistd.h>
 #include "symbol.h"
-#include "thread.h"
+#include "strlist.h"
 
-#include "debug.h"
-
-#include <asm/bug.h>
 #include <libelf.h>
 #include <gelf.h>
 #include <elf.h>
@@ -114,8 +120,8 @@ static void map_groups__fixup_end(struct map_groups *self)
 static struct symbol *symbol__new(u64 start, u64 len, const char *name)
 {
 	size_t namelen = strlen(name) + 1;
-	struct symbol *self = zalloc(symbol_conf.priv_size +
-				     sizeof(*self) + namelen);
+	struct symbol *self = calloc(1, (symbol_conf.priv_size +
+					 sizeof(*self) + namelen));
 	if (self == NULL)
 		return NULL;
 
@@ -166,7 +172,7 @@ static void dso__set_basename(struct dso *self)
 
 struct dso *dso__new(const char *name)
 {
-	struct dso *self = zalloc(sizeof(*self) + strlen(name) + 1);
+	struct dso *self = calloc(1, sizeof(*self) + strlen(name) + 1);
 
 	if (self != NULL) {
 		int i;
@@ -1382,13 +1388,13 @@ static int dso__kernel_module_get_build_id(struct dso *self)
 	return 0;
 }
 
-static int map_groups__set_modules_path_dir(struct map_groups *self, char *dirname)
+static int map_groups__set_modules_path_dir(struct map_groups *self, char *dir_name)
 {
 	struct dirent *dent;
-	DIR *dir = opendir(dirname);
+	DIR *dir = opendir(dir_name);
 
 	if (!dir) {
-		pr_debug("%s: cannot open %s dir\n", __func__, dirname);
+		pr_debug("%s: cannot open %s dir\n", __func__, dir_name);
 		return -1;
 	}
 
@@ -1401,7 +1407,7 @@ static int map_groups__set_modules_path_dir(struct map_groups *self, char *dirna
 				continue;
 
 			snprintf(path, sizeof(path), "%s/%s",
-				 dirname, dent->d_name);
+				 dir_name, dent->d_name);
 			if (map_groups__set_modules_path_dir(self, path) < 0)
 				goto failure;
 		} else {
@@ -1421,7 +1427,7 @@ static int map_groups__set_modules_path_dir(struct map_groups *self, char *dirna
 				continue;
 
 			snprintf(path, sizeof(path), "%s/%s",
-				 dirname, dent->d_name);
+				 dir_name, dent->d_name);
 
 			long_name = strdup(path);
 			if (long_name == NULL)
@@ -1458,8 +1464,8 @@ static int map_groups__set_modules_path(struct map_groups *self)
  */
 static struct map *map__new2(u64 start, struct dso *dso, enum map_type type)
 {
-	struct map *self = zalloc(sizeof(*self) +
-				  (dso->kernel ? sizeof(struct kmap) : 0));
+	struct map *self = calloc(1, (sizeof(*self) +
+				      (dso->kernel ? sizeof(struct kmap) : 0)));
 	if (self != NULL) {
 		/*
 		 * ->end will be filled after we load all the symbols
@@ -1963,3 +1969,46 @@ int map_groups__create_kernel_maps(struct map_groups *self,
 	map_groups__fixup_end(self);
 	return 0;
 }
+
+static int hex(char ch)
+{
+	if ((ch >= '0') && (ch <= '9'))
+		return ch - '0';
+	if ((ch >= 'a') && (ch <= 'f'))
+		return ch - 'a' + 10;
+	if ((ch >= 'A') && (ch <= 'F'))
+		return ch - 'A' + 10;
+	return -1;
+}
+
+/*
+ * While we find nice hex chars, build a long_val.
+ * Return number of chars processed.
+ */
+int hex2u64(const char *ptr, u64 *long_val)
+{
+	const char *p = ptr;
+	*long_val = 0;
+
+	while (*p) {
+		const int hex_val = hex(*p);
+
+		if (hex_val < 0)
+			break;
+
+		*long_val = (*long_val << 4) | hex_val;
+		p++;
+	}
+
+	return p - ptr;
+}
+
+char *strxfrchar(char *s, char from, char to)
+{
+	char *p = s;
+
+	while ((p = strchr(p, from)) != NULL)
+		*p++ = to;
+
+	return s;
+}
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index a4a894b..757fae3 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -3,10 +3,11 @@
 
 #include <linux/types.h>
 #include <stdbool.h>
-#include "types.h"
+#include <stdint.h>
+#include "map.h"
 #include <linux/list.h>
 #include <linux/rbtree.h>
-#include "event.h"
+#include <stdio.h>
 
 #define DEBUG_CACHE_DIR ".debug"
 
@@ -29,6 +30,9 @@ static inline char *bfd_demangle(void __used *v, const char __used *c,
 #endif
 #endif
 
+int hex2u64(const char *ptr, u64 *val);
+char *strxfrchar(char *s, char from, char to);
+
 /*
  * libelf 0.8.x and earlier do not support ELF_C_READ_MMAP;
  * for newer versions we can use mmap to reduce memory usage:
@@ -44,6 +48,8 @@ static inline char *bfd_demangle(void __used *v, const char __used *c,
 #define DMGL_ANSI        (1 << 1)       /* Include const, volatile, etc */
 #endif
 
+#define BUILD_ID_SIZE 20
+
 struct symbol {
 	struct rb_node	rb_node;
 	u64		start;
-- 
1.6.2.5

