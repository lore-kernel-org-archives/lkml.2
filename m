Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399Ab2JEInf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 04:43:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60855 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733Ab2JEInd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 04:43:33 -0400
Date: Fri, 5 Oct 2012 01:43:14 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-wu8lz0g2qg26aqgi51xgzkpp@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf kmem: Don't use globals where not needed to
Git-Commit-ID: 0433ffbe47d66c5c561b54340ee47adf8826bcc4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 05 Oct 2012 01:43:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0433ffbe47d66c5c561b54340ee47adf8826bcc4
Gitweb:     http://git.kernel.org/tip/0433ffbe47d66c5c561b54340ee47adf8826bcc4
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 1 Oct 2012 15:20:58 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 2 Oct 2012 18:36:32 -0300

perf kmem: Don't use globals where not needed to

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
 
