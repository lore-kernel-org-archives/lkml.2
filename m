Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933338Ab2JZOcO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 10:32:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:44266 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614Ab2JZOcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 10:32:11 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 9/9] perf stat: Add --pre and --post command
Date: Fri, 26 Oct 2012 12:31:53 -0200
Message-Id: <1351261913-28250-10-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1351261913-28250-1-git-send-email-acme@infradead.org>
References: <1351261913-28250-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

In order to measure kernel builds, one has to do some pre/post cleanup
work in order to do the repeat build.

So provide --pre and --post command hooks to allow doing just that.

  perf stat --repeat 10 --null --sync --pre 'make -s O=defconfig-build/clean' \
	-- make -s -j64 O=defconfig-build/ bzImage

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Stephane Eranian <eranian@gmail.com>
Link: http://lkml.kernel.org/r/1350992414.13456.5.camel@twins
[ committer note: Added respective entries in Documentation/perf-stat.txt ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-stat.txt |    5 ++++
 tools/perf/builtin-stat.c              |   42 +++++++++++++++++++++++++++-----
 2 files changed, 41 insertions(+), 6 deletions(-)

diff --git a/tools/perf/Documentation/perf-stat.txt b/tools/perf/Documentation/perf-stat.txt
index 2fa173b..cf0c310 100644
--- a/tools/perf/Documentation/perf-stat.txt
+++ b/tools/perf/Documentation/perf-stat.txt
@@ -108,6 +108,11 @@ with it.  --append may be used here.  Examples:
      3>results  perf stat --log-fd 3          -- $cmd
      3>>results perf stat --log-fd 3 --append -- $cmd
 
+--pre::
+--post::
+	Pre and post measurement hooks, e.g.:
+
+perf stat --repeat 10 --null --sync --pre 'make -s O=defconfig-build/clean' -- make -s -j64 O=defconfig-build/ bzImage
 
 
 EXAMPLES
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 93b9011..6888960 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -57,6 +57,7 @@
 #include "util/thread.h"
 #include "util/thread_map.h"
 
+#include <stdlib.h>
 #include <sys/prctl.h>
 #include <locale.h>
 
@@ -83,6 +84,9 @@ static const char		*csv_sep			= NULL;
 static bool			csv_output			= false;
 static bool			group				= false;
 static FILE			*output				= NULL;
+static const char		*pre_cmd			= NULL;
+static const char		*post_cmd			= NULL;
+static bool			sync_run			= false;
 
 static volatile int done = 0;
 
@@ -265,7 +269,7 @@ static int read_counter(struct perf_evsel *counter)
 	return 0;
 }
 
-static int run_perf_stat(int argc __maybe_unused, const char **argv)
+static int __run_perf_stat(int argc __maybe_unused, const char **argv)
 {
 	unsigned long long t0, t1;
 	struct perf_evsel *counter, *first;
@@ -405,6 +409,32 @@ static int run_perf_stat(int argc __maybe_unused, const char **argv)
 	return WEXITSTATUS(status);
 }
 
+static int run_perf_stat(int argc __maybe_unused, const char **argv)
+{
+	int ret;
+
+	if (pre_cmd) {
+		ret = system(pre_cmd);
+		if (ret)
+			return ret;
+	}
+
+	if (sync_run)
+		sync();
+
+	ret = __run_perf_stat(argc, argv);
+	if (ret)
+		return ret;
+
+	if (post_cmd) {
+		ret = system(post_cmd);
+		if (ret)
+			return ret;
+	}
+
+	return ret;
+}
+
 static void print_noise_pct(double total, double avg)
 {
 	double pct = rel_stddev_stats(total, avg);
@@ -1069,8 +1099,7 @@ static int add_default_attributes(void)
 
 int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 {
-	bool append_file = false,
-	     sync_run = false;
+	bool append_file = false;
 	int output_fd = 0;
 	const char *output_name	= NULL;
 	const struct option options[] = {
@@ -1114,6 +1143,10 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_BOOLEAN(0, "append", &append_file, "append to the output file"),
 	OPT_INTEGER(0, "log-fd", &output_fd,
 		    "log output to fd, instead of stderr"),
+	OPT_STRING(0, "pre", &pre_cmd, "command",
+			"command to run prior to the measured command"),
+	OPT_STRING(0, "post", &post_cmd, "command",
+			"command to run after to the measured command"),
 	OPT_END()
 	};
 	const char * const stat_usage[] = {
@@ -1238,9 +1271,6 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 			fprintf(output, "[ perf stat: executing run #%d ... ]\n",
 				run_idx + 1);
 
-		if (sync_run)
-			sync();
-
 		status = run_perf_stat(argc, argv);
 	}
 
-- 
1.7.9.2.358.g22243

