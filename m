Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755Ab2JDSXi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 14:23:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:39673 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645Ab2JDSI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 14:08:59 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 20/42] perf buildid-list: Don't use globals where not needed to
Date: Thu,  4 Oct 2012 15:08:20 -0300
Message-Id: <1349374122-27806-21-git-send-email-acme@infradead.org>
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
Link: http://lkml.kernel.org/n/tip-ixb32cbcka9w1fk07xrksusf@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-buildid-list.c |   55 ++++++++++++++++---------------------
 1 files changed, 24 insertions(+), 31 deletions(-)

diff --git a/tools/perf/builtin-buildid-list.c b/tools/perf/builtin-buildid-list.c
index 1159fee..a0e94ff 100644
--- a/tools/perf/builtin-buildid-list.c
+++ b/tools/perf/builtin-buildid-list.c
@@ -16,27 +16,6 @@
 #include "util/session.h"
 #include "util/symbol.h"
 
-static const char *input_name;
-static bool force;
-static bool show_kernel;
-static bool with_hits;
-
-static const char * const buildid_list_usage[] = {
-	"perf buildid-list [<options>]",
-	NULL
-};
-
-static const struct option options[] = {
-	OPT_BOOLEAN('H', "with-hits", &with_hits, "Show only DSOs with hits"),
-	OPT_STRING('i', "input", &input_name, "file",
-		    "input file name"),
-	OPT_BOOLEAN('f', "force", &force, "don't complain, do it"),
-	OPT_BOOLEAN('k', "kernel", &show_kernel, "Show current kernel build id"),
-	OPT_INCR('v', "verbose", &verbose,
-		    "be more verbose"),
-	OPT_END()
-};
-
 static int sysfs__fprintf_build_id(FILE *fp)
 {
 	u8 kallsyms_build_id[BUILD_ID_SIZE];
@@ -65,7 +44,8 @@ static int filename__fprintf_build_id(const char *name, FILE *fp)
 	return fprintf(fp, "%s\n", sbuild_id);
 }
 
-static int perf_session__list_build_ids(void)
+static int perf_session__list_build_ids(const char *input_name,
+					bool force, bool with_hits)
 {
 	struct perf_session *session;
 
@@ -95,18 +75,31 @@ out:
 	return 0;
 }
 
-static int __cmd_buildid_list(void)
-{
-	if (show_kernel)
-		return sysfs__fprintf_build_id(stdout);
-
-	return perf_session__list_build_ids();
-}
-
 int cmd_buildid_list(int argc, const char **argv,
 		     const char *prefix __maybe_unused)
 {
+	bool show_kernel = false;
+	bool with_hits = false;
+	bool force = false;
+	const char *input_name = NULL;
+	const struct option options[] = {
+	OPT_BOOLEAN('H', "with-hits", &with_hits, "Show only DSOs with hits"),
+	OPT_STRING('i', "input", &input_name, "file", "input file name"),
+	OPT_BOOLEAN('f', "force", &force, "don't complain, do it"),
+	OPT_BOOLEAN('k', "kernel", &show_kernel, "Show current kernel build id"),
+	OPT_INCR('v', "verbose", &verbose, "be more verbose"),
+	OPT_END()
+	};
+	const char * const buildid_list_usage[] = {
+		"perf buildid-list [<options>]",
+		NULL
+	};
+
 	argc = parse_options(argc, argv, options, buildid_list_usage, 0);
 	setup_pager();
-	return __cmd_buildid_list();
+
+	if (show_kernel)
+		return sysfs__fprintf_build_id(stdout);
+
+	return perf_session__list_build_ids(input_name, force, with_hits);
 }
-- 
1.7.1

