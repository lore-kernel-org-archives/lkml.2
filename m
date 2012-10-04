Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786Ab2JDSTb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 14:19:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:39780 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597Ab2JDSJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 14:09:29 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 19/42] perf buildid-cache: Don't use globals where not needed to
Date: Thu,  4 Oct 2012 15:08:19 -0300
Message-Id: <1349374122-27806-20-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1349374122-27806-1-git-send-email-acme@infradead.org>
References: <1349374122-27806-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Some variables were global but used in just one function, so move it to
where it belongs.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-6i7lqzm4hmkg35o1370lb7w4@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-buildid-cache.c |   58 ++++++++++++++++--------------------
 1 files changed, 26 insertions(+), 32 deletions(-)

diff --git a/tools/perf/builtin-buildid-cache.c b/tools/perf/builtin-buildid-cache.c
index 8365455..d37e077 100644
--- a/tools/perf/builtin-buildid-cache.c
+++ b/tools/perf/builtin-buildid-cache.c
@@ -15,22 +15,6 @@
 #include "util/strlist.h"
 #include "util/symbol.h"
 
-static char const *add_name_list_str, *remove_name_list_str;
-
-static const char * const buildid_cache_usage[] = {
-	"perf buildid-cache [<options>]",
-	NULL
-};
-
-static const struct option buildid_cache_options[] = {
-	OPT_STRING('a', "add", &add_name_list_str,
-		   "file list", "file(s) to add"),
-	OPT_STRING('r', "remove", &remove_name_list_str, "file list",
-		    "file(s) to remove"),
-	OPT_INCR('v', "verbose", &verbose, "be more verbose"),
-	OPT_END()
-};
-
 static int build_id_cache__add_file(const char *filename, const char *debugdir)
 {
 	char sbuild_id[BUILD_ID_SIZE * 2 + 1];
@@ -51,8 +35,8 @@ static int build_id_cache__add_file(const char *filename, const char *debugdir)
 	return err;
 }
 
-static int build_id_cache__remove_file(const char *filename __maybe_unused,
-				       const char *debugdir __maybe_unused)
+static int build_id_cache__remove_file(const char *filename,
+				       const char *debugdir)
 {
 	u8 build_id[BUILD_ID_SIZE];
 	char sbuild_id[BUILD_ID_SIZE * 2 + 1];
@@ -73,11 +57,34 @@ static int build_id_cache__remove_file(const char *filename __maybe_unused,
 	return err;
 }
 
-static int __cmd_buildid_cache(void)
+int cmd_buildid_cache(int argc, const char **argv,
+		      const char *prefix __maybe_unused)
 {
 	struct strlist *list;
 	struct str_node *pos;
 	char debugdir[PATH_MAX];
+	char const *add_name_list_str = NULL,
+		   *remove_name_list_str = NULL;
+	const struct option buildid_cache_options[] = {
+	OPT_STRING('a', "add", &add_name_list_str,
+		   "file list", "file(s) to add"),
+	OPT_STRING('r', "remove", &remove_name_list_str, "file list",
+		    "file(s) to remove"),
+	OPT_INCR('v', "verbose", &verbose, "be more verbose"),
+	OPT_END()
+	};
+	const char * const buildid_cache_usage[] = {
+		"perf buildid-cache [<options>]",
+		NULL
+	};
+
+	argc = parse_options(argc, argv, buildid_cache_options,
+			     buildid_cache_usage, 0);
+
+	if (symbol__init() < 0)
+		return -1;
+
+	setup_pager();
 
 	snprintf(debugdir, sizeof(debugdir), "%s", buildid_dir);
 
@@ -119,16 +126,3 @@ static int __cmd_buildid_cache(void)
 
 	return 0;
 }
-
-int cmd_buildid_cache(int argc, const char **argv,
-		      const char *prefix __maybe_unused)
-{
-	argc = parse_options(argc, argv, buildid_cache_options,
-			     buildid_cache_usage, 0);
-
-	if (symbol__init() < 0)
-		return -1;
-
-	setup_pager();
-	return __cmd_buildid_cache();
-}
-- 
1.7.1

