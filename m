Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936Ab1LGJFr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 04:05:47 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:31917 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898Ab1LGJDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 04:03:12 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LVTT55-01-ASP-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH v2 4/7] perf report: Accept fifos as input file
Date: Wed, 7 Dec 2011 10:02:54 +0100
Message-ID: <1323248577-11268-5-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1323248577-11268-1-git-send-email-robert.richter@amd.com>
References: <1323248577-11268-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The default input file for perf report is not handled the same way as
perf record does it for its output file. This leads to unexpected
behavior of perf report, etc. E.g.:

 # perf record -a -e cpu-cycles sleep 2 | perf report | cat
 failed to open perf.data: No such file or directory  (try 'perf record' first)

While perf record writes to a fifo, perf report expects perf.data to
be read. This patch changes this to accept fifos as input file.

Applies to the following commands:

 perf annotate
 perf buildid-list
 perf evlist
 perf kmem
 perf lock
 perf report
 perf sched
 perf script
 perf timechart

Also fixes char const* -> const char* type declaration for filename
strings.

v2:
* Prevent potential null pointer access to input_name in
  builtin-report.c. Needed due to removal of patch "perf report: Setup
  browser if stdout is a pipe"

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 tools/perf/Documentation/perf-annotate.txt     |    2 +-
 tools/perf/Documentation/perf-buildid-list.txt |    2 +-
 tools/perf/Documentation/perf-evlist.txt       |    2 +-
 tools/perf/Documentation/perf-kmem.txt         |    2 +-
 tools/perf/Documentation/perf-lock.txt         |    2 +-
 tools/perf/Documentation/perf-report.txt       |    2 +-
 tools/perf/Documentation/perf-sched.txt        |    2 +-
 tools/perf/Documentation/perf-script.txt       |    2 +-
 tools/perf/Documentation/perf-timechart.txt    |    2 +-
 tools/perf/builtin-annotate.c                  |    3 +--
 tools/perf/builtin-buildid-list.c              |   19 ++++++++++---------
 tools/perf/builtin-evlist.c                    |    2 +-
 tools/perf/builtin-kmem.c                      |    2 +-
 tools/perf/builtin-lock.c                      |    2 +-
 tools/perf/builtin-report.c                    |   13 ++++++++++---
 tools/perf/builtin-sched.c                     |    2 +-
 tools/perf/builtin-script.c                    |    4 ++--
 tools/perf/builtin-timechart.c                 |    4 ++--
 tools/perf/util/session.c                      |   15 +++++++++++++--
 19 files changed, 51 insertions(+), 33 deletions(-)

diff --git a/tools/perf/Documentation/perf-annotate.txt b/tools/perf/Documentation/perf-annotate.txt
index 476029d..c89f9e1 100644
--- a/tools/perf/Documentation/perf-annotate.txt
+++ b/tools/perf/Documentation/perf-annotate.txt
@@ -22,7 +22,7 @@ OPTIONS
 -------
 -i::
 --input=::
-        Input file name. (default: perf.data)
+        Input file name. (default: perf.data unless stdin is a fifo)
 
 -d::
 --dsos=<dso[,dso...]>::
diff --git a/tools/perf/Documentation/perf-buildid-list.txt b/tools/perf/Documentation/perf-buildid-list.txt
index cc22325..25c52ef 100644
--- a/tools/perf/Documentation/perf-buildid-list.txt
+++ b/tools/perf/Documentation/perf-buildid-list.txt
@@ -26,7 +26,7 @@ OPTIONS
         Show only DSOs with hits.
 -i::
 --input=::
-        Input file name. (default: perf.data)
+        Input file name. (default: perf.data unless stdin is a fifo)
 -f::
 --force::
 	Don't do ownership validation.
diff --git a/tools/perf/Documentation/perf-evlist.txt b/tools/perf/Documentation/perf-evlist.txt
index 0cada9e..0507ec7 100644
--- a/tools/perf/Documentation/perf-evlist.txt
+++ b/tools/perf/Documentation/perf-evlist.txt
@@ -18,7 +18,7 @@ OPTIONS
 -------
 -i::
 --input=::
-        Input file name. (default: perf.data)
+        Input file name. (default: perf.data unless stdin is a fifo)
 
 SEE ALSO
 --------
diff --git a/tools/perf/Documentation/perf-kmem.txt b/tools/perf/Documentation/perf-kmem.txt
index a52fcde..7c8fbbf 100644
--- a/tools/perf/Documentation/perf-kmem.txt
+++ b/tools/perf/Documentation/perf-kmem.txt
@@ -23,7 +23,7 @@ OPTIONS
 -------
 -i <file>::
 --input=<file>::
-	Select the input file (default: perf.data)
+	Select the input file (default: perf.data unless stdin is a fifo)
 
 --caller::
 	Show per-callsite statistics
diff --git a/tools/perf/Documentation/perf-lock.txt b/tools/perf/Documentation/perf-lock.txt
index 4a26a2f..d6b2a4f 100644
--- a/tools/perf/Documentation/perf-lock.txt
+++ b/tools/perf/Documentation/perf-lock.txt
@@ -29,7 +29,7 @@ COMMON OPTIONS
 
 -i::
 --input=<file>::
-        Input file name.
+        Input file name. (default: perf.data unless stdin is a fifo)
 
 -v::
 --verbose::
diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index dc85392..8926aae 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -19,7 +19,7 @@ OPTIONS
 -------
 -i::
 --input=::
-        Input file name. (default: perf.data)
+        Input file name. (default: perf.data unless stdin is a fifo)
 
 -v::
 --verbose::
diff --git a/tools/perf/Documentation/perf-sched.txt b/tools/perf/Documentation/perf-sched.txt
index 5b212b5..8ff4df9 100644
--- a/tools/perf/Documentation/perf-sched.txt
+++ b/tools/perf/Documentation/perf-sched.txt
@@ -40,7 +40,7 @@ OPTIONS
 -------
 -i::
 --input=<file>::
-        Input file name. (default: perf.data)
+        Input file name. (default: perf.data unless stdin is a fifo)
 
 -v::
 --verbose::
diff --git a/tools/perf/Documentation/perf-script.txt b/tools/perf/Documentation/perf-script.txt
index 7f61eaa..2f6cef4 100644
--- a/tools/perf/Documentation/perf-script.txt
+++ b/tools/perf/Documentation/perf-script.txt
@@ -106,7 +106,7 @@ OPTIONS
 
 -i::
 --input=::
-        Input file name.
+        Input file name. (default: perf.data unless stdin is a fifo)
 
 -d::
 --debug-mode::
diff --git a/tools/perf/Documentation/perf-timechart.txt b/tools/perf/Documentation/perf-timechart.txt
index d7b79e2..1632b0e 100644
--- a/tools/perf/Documentation/perf-timechart.txt
+++ b/tools/perf/Documentation/perf-timechart.txt
@@ -27,7 +27,7 @@ OPTIONS
         Select the output file (default: output.svg)
 -i::
 --input=::
-        Select the input file (default: perf.data)
+        Select the input file (default: perf.data unless stdin is a fifo)
 -w::
 --width=::
         Select the width of the SVG file (default: 1000)
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index d449645..214ba7f 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -215,7 +215,7 @@ static int __cmd_annotate(struct perf_annotate *ann)
 	}
 
 	if (total_nr_samples == 0) {
-		ui__warning("The %s file has no samples!\n", ann->input_name);
+		ui__warning("The %s file has no samples!\n", session->filename);
 		goto out_delete;
 	}
 out_delete:
@@ -250,7 +250,6 @@ int cmd_annotate(int argc, const char **argv, const char *prefix __used)
 			.ordered_samples = true,
 			.ordering_requires_timestamps = true,
 		},
-		.input_name = "perf.data",
 	};
 	const struct option options[] = {
 	OPT_STRING('i', "input", &annotate.input_name, "file",
diff --git a/tools/perf/builtin-buildid-list.c b/tools/perf/builtin-buildid-list.c
index 4895668..5248046 100644
--- a/tools/perf/builtin-buildid-list.c
+++ b/tools/perf/builtin-buildid-list.c
@@ -18,7 +18,7 @@
 
 #include <libelf.h>
 
-static char const *input_name = "perf.data";
+static const char *input_name;
 static bool force;
 static bool show_kernel;
 static bool with_hits;
@@ -71,16 +71,24 @@ static int perf_session__list_build_ids(void)
 {
 	struct perf_session *session;
 
+	elf_version(EV_CURRENT);
+
 	session = perf_session__new(input_name, O_RDONLY, force, false,
 				    &build_id__mark_dso_hit_ops);
 	if (session == NULL)
 		return -1;
 
+	/*
+	 * See if this is an ELF file first:
+	 */
+	if (filename__fprintf_build_id(session->filename, stdout))
+		goto out;
+
 	if (with_hits)
 		perf_session__process_events(session, &build_id__mark_dso_hit_ops);
 
 	perf_session__fprintf_dsos_buildid(session, stdout, with_hits);
-
+out:
 	perf_session__delete(session);
 	return 0;
 }
@@ -90,13 +98,6 @@ static int __cmd_buildid_list(void)
 	if (show_kernel)
 		return sysfs__fprintf_build_id(stdout);
 
-	elf_version(EV_CURRENT);
-	/*
- 	 * See if this is an ELF file first:
- 	 */
-	if (filename__fprintf_build_id(input_name, stdout))
-		return 0;
-
 	return perf_session__list_build_ids();
 }
 
diff --git a/tools/perf/builtin-evlist.c b/tools/perf/builtin-evlist.c
index 4c5e9e0..2676032 100644
--- a/tools/perf/builtin-evlist.c
+++ b/tools/perf/builtin-evlist.c
@@ -15,7 +15,7 @@
 #include "util/parse-options.h"
 #include "util/session.h"
 
-static char const *input_name = "perf.data";
+static const char *input_name;
 
 static int __cmd_evlist(void)
 {
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 886174e..fe1ad8f 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -19,7 +19,7 @@
 struct alloc_stat;
 typedef int (*sort_fn_t)(struct alloc_stat *, struct alloc_stat *);
 
-static char const		*input_name = "perf.data";
+static const char		*input_name;
 
 static int			alloc_flag;
 static int			caller_flag;
diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index 4db5e52..2296c39 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -326,7 +326,7 @@ alloc_failed:
 	die("memory allocation failed\n");
 }
 
-static char			const *input_name = "perf.data";
+static const char *input_name;
 
 struct raw_event_sample {
 	u32			size;
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index ece7c5d..e5ef628 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -321,8 +321,7 @@ static int __cmd_report(struct perf_report *rep)
 	}
 
 	if (nr_samples == 0) {
-		ui__warning("The %s file has no samples!\n",
-			    rep->input_name);
+		ui__warning("The %s file has no samples!\n", session->filename);
 		goto out_delete;
 	}
 
@@ -430,6 +429,7 @@ setup:
 
 int cmd_report(int argc, const char **argv, const char *prefix __used)
 {
+	struct stat st;
 	char callchain_default_opt[] = "fractal,0.5,callee";
 	const char * const report_usage[] = {
 		"perf report [<options>] <command>",
@@ -451,7 +451,6 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 			.ordered_samples = true,
 			.ordering_requires_timestamps = true,
 		},
-		.input_name		 = "perf.data",
 		.pretty_printing_style	 = "normal",
 	};
 	const struct option options[] = {
@@ -531,10 +530,18 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 	if (report.inverted_callchain)
 		callchain_param.order = ORDER_CALLER;
 
+	if (!report.input_name || !strlen(report.input_name)) {
+		if (!fstat(STDIN_FILENO, &st) && S_ISFIFO(st.st_mode))
+			report.input_name = "-";
+		else
+			report.input_name = "perf.data";
+	}
+
 	if (strcmp(report.input_name, "-") != 0)
 		setup_browser(true);
 	else
 		use_browser = 0;
+
 	/*
 	 * Only in the newt browser we are doing integrated annotation,
 	 * so don't allocate extra space that won't be used in the stdio
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 6284ed2..fb8b5f8 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -22,7 +22,7 @@
 #include <pthread.h>
 #include <math.h>
 
-static char			const *input_name = "perf.data";
+static const char		*input_name;
 
 static char			default_sort_order[] = "avg, max, switch, runtime";
 static const char		*sort_order = default_sort_order;
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index c29257f..d308e30 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -434,7 +434,7 @@ static int cleanup_scripting(void)
 	return scripting_ops->stop_script();
 }
 
-static char const		*input_name = "perf.data";
+static const char *input_name;
 
 static int process_sample_event(struct perf_tool *tool __used,
 				union perf_event *event,
@@ -1316,7 +1316,7 @@ int cmd_script(int argc, const char **argv, const char *prefix __used)
 			return -1;
 		}
 
-		input = open(input_name, O_RDONLY);
+		input = open(session->filename, O_RDONLY);	/* input_name */
 		if (input < 0) {
 			perror("failed to open file");
 			exit(-1);
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 135376a..3b75b2e 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -38,8 +38,8 @@
 #define PWR_EVENT_EXIT -1
 
 
-static char		const *input_name = "perf.data";
-static char		const *output_name = "output.svg";
+static const char	*input_name;
+static const char	*output_name = "output.svg";
 
 static unsigned int	numcpus;
 static u64		min_freq;	/* Lowest CPU frequency seen */
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index ea17dfb..cc5e6be 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -107,8 +107,19 @@ struct perf_session *perf_session__new(const char *filename, int mode,
 				       bool force, bool repipe,
 				       struct perf_tool *tool)
 {
-	size_t len = filename ? strlen(filename) : 0;
-	struct perf_session *self = zalloc(sizeof(*self) + len);
+	struct perf_session *self;
+	struct stat st;
+	size_t len;
+
+	if (!filename || !strlen(filename)) {
+		if (!fstat(STDIN_FILENO, &st) && S_ISFIFO(st.st_mode))
+			filename = "-";
+		else
+			filename = "perf.data";
+	}
+
+	len = strlen(filename);
+	self = zalloc(sizeof(*self) + len);
 
 	if (self == NULL)
 		goto out;
-- 
1.7.7


