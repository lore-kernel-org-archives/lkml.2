Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624Ab2L0JMx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 04:12:53 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:59226 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305Ab2L0JMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 04:12:33 -0500
X-AuditID: 9c93016f-b7b54ae000000e9e-1c-50dc10fc4de3
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 10/10] perf report: Update documentation for sort keys
Date: Thu, 27 Dec 2012 18:11:47 +0900
Message-Id: <1356599507-14226-11-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1356599507-14226-1-git-send-email-namhyung@kernel.org>
References: <1356599507-14226-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Add description of sort keys to the perf-report document and also add
missing cpu and srcline keys to the command line help string.

Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Documentation/perf-report.txt | 38 +++++++++++++++++++++++++++++---
 tools/perf/builtin-report.c              |  4 ++--
 2 files changed, 37 insertions(+), 5 deletions(-)

diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index f4d91bebd59d..848a0dcb6dfd 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -57,11 +57,44 @@ OPTIONS
 
 -s::
 --sort=::
-	Sort by key(s): pid, comm, dso, symbol, parent, srcline.
+	Sort histogram entries by given key(s) - multiple keys can be specified
+	in CSV format.  Following sort keys are available:
+	pid, comm, dso, symbol, parent, cpu, srcline.
+
+	Each key has following meaning:
+
+	- comm: command (name) of the task which can be read via /proc/<pid>/comm
+	- pid: command and tid of the task
+	- dso: name of library or module executed at the time of sample
+	- symbol: name of function executed at the time of sample
+	- parent: name of function matched to the parent regex filter. Unmatched
+	entries are displayed as "[other]".
+	- cpu: cpu number the task ran at the time of sample
+	- srcline: filename and line number executed at the time of sample.  The
+	DWARF debuggin info must be provided.
+
+	By default, comm, dso and symbol keys are used.
+	(i.e. --sort comm,dso,symbol)
+
+	If --branch-stack option is used, following sort keys are also
+	available:
+	dso_from, dso_to, symbol_from, symbol_to, mispredict.
+
+	- dso_from: name of library or module branched from
+	- dso_to: name of library or module branched to
+	- symbol_from: name of function branched from
+	- symbol_to: name of function branched to
+	- mispredict: "N" for predicted branch, "Y" for mispredicted branch
+
+	And default sort keys are changed to comm, dso_from, symbol_from, dso_to
+	and symbol_to, see '--branch-stack'.
 
 -p::
 --parent=<regex>::
-        regex filter to identify parent, see: '--sort parent'
+        A regex filter to identify parent. The parent is a caller of this
+	function and searched through the callchain, thus it requires callchain
+	information recorded. The pattern is in the exteneded regex format and
+	defaults to "\^sys_|^do_page_fault", see '--sort parent'.
 
 -x::
 --exclude-other::
@@ -74,7 +107,6 @@ OPTIONS
 
 -t::
 --field-separator=::
-
 	Use a special separator character and don't pad with spaces, replacing
 	all occurrences of this separator in symbol names (and other output)
 	with a '.' character, that thus it's the only non valid separator.
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 13cdf61c4f82..47a864478543 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -595,8 +595,8 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_BOOLEAN(0, "stdio", &report.use_stdio,
 		    "Use the stdio interface"),
 	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
-		   "sort by key(s): pid, comm, dso, symbol, parent, dso_to,"
-		   " dso_from, symbol_to, symbol_from, mispredict"),
+		   "sort by key(s): pid, comm, dso, symbol, parent, cpu, srcline,"
+		   " dso_to, dso_from, symbol_to, symbol_from, mispredict"),
 	OPT_BOOLEAN(0, "showcpuutilization", &symbol_conf.show_cpu_utilization,
 		    "Show sample percentage for different cpu modes"),
 	OPT_STRING('p', "parent", &parent_pattern, "regex",
-- 
1.7.11.7

