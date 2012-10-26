Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933704Ab2JZPMr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 11:12:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54961 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932078Ab2JZPMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 11:12:46 -0400
Date: Fri, 26 Oct 2012 08:12:20 -0700
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
Message-ID: <tip-1f16c5754d3a4008c29f3bf67b4f1271313ba385@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, peterz@infradead.org,
        eranian@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, a.p.zijlstra@chello.nl, peterz@infradead.org,
        tglx@linutronix.de, eranian@gmail.com
In-Reply-To: <1350992414.13456.5.camel@twins>
References: <1350992414.13456.5.camel@twins>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf stat: Add --pre and --post command
Git-Commit-ID: 1f16c5754d3a4008c29f3bf67b4f1271313ba385
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 26 Oct 2012 08:12:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1f16c5754d3a4008c29f3bf67b4f1271313ba385
Gitweb:     http://git.kernel.org/tip/1f16c5754d3a4008c29f3bf67b4f1271313ba385
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Tue, 23 Oct 2012 13:40:14 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 26 Oct 2012 11:22:25 -0200

perf stat: Add --pre and --post command

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
 tools/perf/builtin-stat.c              |   42 +++++++++++++++++++++++++++----
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
 
