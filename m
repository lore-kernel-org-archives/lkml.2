Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759390Ab2J2PL7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 11:11:59 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34802 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759326Ab2J2PJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 11:09:35 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 02/14] perf tools: Move build_id__sprintf into build-id object
Date: Mon, 29 Oct 2012 13:09:01 -0200
Message-Id: <1351523353-27982-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1351523353-27982-1-git-send-email-acme@infradead.org>
References: <1351523353-27982-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Moving build_id__sprintf function into build-id object.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Reviewed-by: Namhyung Kim <namhyung@kernel.org>
Tested-by: Namhyung Kim <namhyung@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1351372712-21104-2-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-buildid-cache.c |    2 +-
 tools/perf/util/build-id.c         |   15 +++++++++++++++
 tools/perf/util/build-id.h         |    1 +
 tools/perf/util/header.c           |    1 +
 tools/perf/util/map.c              |    1 +
 tools/perf/util/symbol.c           |   15 ---------------
 tools/perf/util/symbol.h           |    1 -
 7 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/tools/perf/builtin-buildid-cache.c b/tools/perf/builtin-buildid-cache.c
index d37e077..edb26ea 100644
--- a/tools/perf/builtin-buildid-cache.c
+++ b/tools/perf/builtin-buildid-cache.c
@@ -13,7 +13,7 @@
 #include "util/header.h"
 #include "util/parse-options.h"
 #include "util/strlist.h"
-#include "util/symbol.h"
+#include "util/build-id.h"
 
 static int build_id_cache__add_file(const char *filename, const char *debugdir)
 {
diff --git a/tools/perf/util/build-id.c b/tools/perf/util/build-id.c
index 94ca117..5295625 100644
--- a/tools/perf/util/build-id.c
+++ b/tools/perf/util/build-id.c
@@ -70,6 +70,21 @@ struct perf_tool build_id__mark_dso_hit_ops = {
 	.build_id	 = perf_event__process_build_id,
 };
 
+int build_id__sprintf(const u8 *build_id, int len, char *bf)
+{
+	char *bid = bf;
+	const u8 *raw = build_id;
+	int i;
+
+	for (i = 0; i < len; ++i) {
+		sprintf(bid, "%02x", *raw);
+		++raw;
+		bid += 2;
+	}
+
+	return raw - build_id;
+}
+
 char *dso__build_id_filename(struct dso *self, char *bf, size_t size)
 {
 	char build_id_hex[BUILD_ID_SIZE * 2 + 1];
diff --git a/tools/perf/util/build-id.h b/tools/perf/util/build-id.h
index 45c500b..f6d9ff9 100644
--- a/tools/perf/util/build-id.h
+++ b/tools/perf/util/build-id.h
@@ -5,6 +5,7 @@
 
 extern struct perf_tool build_id__mark_dso_hit_ops;
 
+int build_id__sprintf(const u8 *build_id, int len, char *bf);
 char *dso__build_id_filename(struct dso *self, char *bf, size_t size);
 
 int build_id__mark_dso_hit(struct perf_tool *tool, union perf_event *event,
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 7daad23..514ed1b 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -23,6 +23,7 @@
 #include "pmu.h"
 #include "vdso.h"
 #include "strbuf.h"
+#include "build-id.h"
 
 static bool no_buildid_cache = false;
 
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 6109fa4..9b40c44 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -10,6 +10,7 @@
 #include "thread.h"
 #include "strlist.h"
 #include "vdso.h"
+#include "build-id.h"
 
 const char *map_type__name[MAP__NR_TYPES] = {
 	[MAP__FUNCTION] = "Functions",
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index e2e8c69..e36e8c2 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -504,21 +504,6 @@ void dso__sort_by_name(struct dso *dso, enum map_type type)
 				     &dso->symbols[type]);
 }
 
-int build_id__sprintf(const u8 *build_id, int len, char *bf)
-{
-	char *bid = bf;
-	const u8 *raw = build_id;
-	int i;
-
-	for (i = 0; i < len; ++i) {
-		sprintf(bid, "%02x", *raw);
-		++raw;
-		bid += 2;
-	}
-
-	return raw - build_id;
-}
-
 size_t dso__fprintf_buildid(struct dso *dso, FILE *fp)
 {
 	char sbuild_id[BUILD_ID_SIZE * 2 + 1];
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 8b6ef7f..d70f676 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -338,7 +338,6 @@ struct symbol *dso__find_symbol_by_name(struct dso *dso, enum map_type type,
 int filename__read_build_id(const char *filename, void *bf, size_t size);
 int sysfs__read_build_id(const char *filename, void *bf, size_t size);
 bool __dsos__read_build_ids(struct list_head *head, bool with_hits);
-int build_id__sprintf(const u8 *build_id, int len, char *bf);
 int kallsyms__parse(const char *filename, void *arg,
 		    int (*process_symbol)(void *arg, const char *name,
 					  char type, u64 start));
-- 
1.7.9.2.358.g22243

