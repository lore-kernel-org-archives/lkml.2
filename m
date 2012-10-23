Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935Ab2JWLlB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 07:41:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:40772 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560Ab2JWLk7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 07:40:59 -0400
Message-ID: <1350992414.13456.5.camel@twins>
Subject: [PATCH] perf, stat: Add --pre and --post command
From: Peter Zijlstra <peterz@infradead.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: mingo@kernel.org, Stephane Eranian <eranian@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Tue, 23 Oct 2012 13:40:14 +0200
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to measure kernel builds, one has to do some pre/post cleanup
work in order to do the repeat build.

So provide --pre and --post command hooks to allow doing just that.
  
  perf stat --repeat 10 --null --sync --pre 'make -s O=defconfig-build/ clean' -- make -s -j64 O=defconfig-build/ bzImage

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 tools/perf/builtin-stat.c |   42 ++++++++++++++++++++++++++++++++++++------
 1 files changed, 36 insertions(+), 6 deletions(-)

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
 

