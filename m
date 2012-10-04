Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883Ab2JDSJf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 14:09:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:39782 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665Ab2JDSJ3 (ORCPT
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
Subject: [PATCH 16/42] perf kmem: Don't use globals where not needed to
Date: Thu,  4 Oct 2012 15:08:16 -0300
Message-Id: <1349374122-27806-17-git-send-email-acme@infradead.org>
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
Link: http://lkml.kernel.org/n/tip-wu8lz0g2qg26aqgi51xgzkpp@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kmem.c |   66 +++++++++++++++++---------------------------
 1 files changed, 26 insertions(+), 40 deletions(-)

diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index bc912c6..14bf82f 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -21,8 +21,6 @@
 struct alloc_stat;
 typedef int (*sort_fn_t)(struct alloc_stat *, struct alloc_stat *);
 
-static const char		*input_name;
-
 static int			alloc_flag;
 static int			caller_flag;
 
@@ -31,8 +29,6 @@ static int			caller_lines = -1;
 
 static bool			raw_ip;
 
-static char			default_sort_order[] = "frag,hit,bytes";
-
 static int			*cpunode_map;
 static int			max_cpu_num;
 
@@ -481,7 +477,7 @@ static void sort_result(void)
 	__sort_result(&root_caller_stat, &root_caller_sorted, &caller_sort);
 }
 
-static int __cmd_kmem(void)
+static int __cmd_kmem(const char *input_name)
 {
 	int err = -EINVAL;
 	struct perf_session *session;
@@ -520,11 +516,6 @@ out_delete:
 	return err;
 }
 
-static const char * const kmem_usage[] = {
-	"perf kmem [<options>] {record|stat}",
-	NULL
-};
-
 static int ptr_cmp(struct alloc_stat *l, struct alloc_stat *r)
 {
 	if (l->ptr < r->ptr)
@@ -720,41 +711,17 @@ static int parse_line_opt(const struct option *opt __maybe_unused,
 	return 0;
 }
 
-static const struct option kmem_options[] = {
-	OPT_STRING('i', "input", &input_name, "file",
-		   "input file name"),
-	OPT_CALLBACK_NOOPT(0, "caller", NULL, NULL,
-			   "show per-callsite statistics",
-			   parse_caller_opt),
-	OPT_CALLBACK_NOOPT(0, "alloc", NULL, NULL,
-			   "show per-allocation statistics",
-			   parse_alloc_opt),
-	OPT_CALLBACK('s', "sort", NULL, "key[,key2...]",
-		     "sort by keys: ptr, call_site, bytes, hit, pingpong, frag",
-		     parse_sort_opt),
-	OPT_CALLBACK('l', "line", NULL, "num",
-		     "show n lines",
-		     parse_line_opt),
-	OPT_BOOLEAN(0, "raw-ip", &raw_ip, "show raw ip instead of symbol"),
-	OPT_END()
-};
-
-static const char *record_args[] = {
-	"record",
-	"-a",
-	"-R",
-	"-f",
-	"-c", "1",
+static int __cmd_record(int argc, const char **argv)
+{
+	const char * const record_args[] = {
+	"record", "-a", "-R", "-f", "-c", "1",
 	"-e", "kmem:kmalloc",
 	"-e", "kmem:kmalloc_node",
 	"-e", "kmem:kfree",
 	"-e", "kmem:kmem_cache_alloc",
 	"-e", "kmem:kmem_cache_alloc_node",
 	"-e", "kmem:kmem_cache_free",
-};
-
-static int __cmd_record(int argc, const char **argv)
-{
+	};
 	unsigned int rec_argc, i, j;
 	const char **rec_argv;
 
@@ -775,6 +742,25 @@ static int __cmd_record(int argc, const char **argv)
 
 int cmd_kmem(int argc, const char **argv, const char *prefix __maybe_unused)
 {
+	const char * const default_sort_order = "frag,hit,bytes";
+	const char *input_name = NULL;
+	const struct option kmem_options[] = {
+	OPT_STRING('i', "input", &input_name, "file", "input file name"),
+	OPT_CALLBACK_NOOPT(0, "caller", NULL, NULL,
+			   "show per-callsite statistics", parse_caller_opt),
+	OPT_CALLBACK_NOOPT(0, "alloc", NULL, NULL,
+			   "show per-allocation statistics", parse_alloc_opt),
+	OPT_CALLBACK('s', "sort", NULL, "key[,key2...]",
+		     "sort by keys: ptr, call_site, bytes, hit, pingpong, frag",
+		     parse_sort_opt),
+	OPT_CALLBACK('l', "line", NULL, "num", "show n lines", parse_line_opt),
+	OPT_BOOLEAN(0, "raw-ip", &raw_ip, "show raw ip instead of symbol"),
+	OPT_END()
+	};
+	const char * const kmem_usage[] = {
+		"perf kmem [<options>] {record|stat}",
+		NULL
+	};
 	argc = parse_options(argc, argv, kmem_options, kmem_usage, 0);
 
 	if (!argc)
@@ -793,7 +779,7 @@ int cmd_kmem(int argc, const char **argv, const char *prefix __maybe_unused)
 		if (list_empty(&alloc_sort))
 			setup_sorting(&alloc_sort, default_sort_order);
 
-		return __cmd_kmem();
+		return __cmd_kmem(input_name);
 	} else
 		usage_with_options(kmem_usage, kmem_options);
 
-- 
1.7.1

