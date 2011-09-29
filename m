Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757970Ab1I2Wvy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 18:51:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:43941 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756167Ab1I2WsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 18:48:17 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 07/16] perf stat: Add --log-fd <N> option to redirect stderr elsewhere
Date: Thu, 29 Sep 2011 19:48:01 -0300
Message-Id: <1317336490-19437-8-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1317336490-19437-1-git-send-email-acme@infradead.org>
References: <1317336490-19437-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

This perf stat option emulates valgrind's --log-fd option, allowing the
user to send perf results elsewhere, and leaving stderr for use by the
program under test.  This complements --output file option, and is
mutually exclusive with it.

   3>results  perf stat --log-fd 3          -- $cmd
   3>>results perf stat --log-fd 3 --append -- $cmd

The perl distro's make test.valgrind target uses valgrind's --log-fd
option, I've adapted it to invoke perf also, and tested this patch
there.

Link: http://lkml.kernel.org/r/1315437244-3788-2-git-send-email-jim.cromie@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-stat.txt |   11 ++++++++++-
 tools/perf/builtin-stat.c              |   14 ++++++++++++++
 2 files changed, 24 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Documentation/perf-stat.txt b/tools/perf/Documentation/perf-stat.txt
index 08394c4..8966b9a 100644
--- a/tools/perf/Documentation/perf-stat.txt
+++ b/tools/perf/Documentation/perf-stat.txt
@@ -95,12 +95,21 @@ corresponding events, i.e., they always refer to events defined earlier on the c
 line.
 
 -o file::
--output file::
+--output file::
 Print the output into the designated file.
 
 --append::
 Append to the output file designated with the -o option. Ignored if -o is not specified.
 
+--log-fd::
+
+Log output to fd, instead of stderr.  Complementary to --output, and mutually exclusive
+with it.  --append may be used here.  Examples:
+     3>results  perf stat --log-fd 3          -- $cmd
+     3>>results perf stat --log-fd 3 --append -- $cmd
+
+
+
 EXAMPLES
 --------
 
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index bec64a9..a43c680 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -196,6 +196,7 @@ static bool			csv_output			= false;
 static bool			group				= false;
 static const char		*output_name			= NULL;
 static FILE			*output				= NULL;
+static int			output_fd;
 
 static volatile int done = 0;
 
@@ -1080,6 +1081,8 @@ static const struct option options[] = {
 	OPT_STRING('o', "output", &output_name, "file",
 		    "output file name"),
 	OPT_BOOLEAN(0, "append", &append_file, "append to the output file"),
+	OPT_INTEGER(0, "log-fd", &output_fd,
+		    "log output to fd, instead of stderr"),
 	OPT_END()
 };
 
@@ -1166,6 +1169,10 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 	if (output_name && strcmp(output_name, "-"))
 		output = NULL;
 
+	if (output_name && output_fd) {
+		fprintf(stderr, "cannot use both --output and --log-fd\n");
+		usage_with_options(stat_usage, options);
+	}
 	if (!output) {
 		struct timespec tm;
 		mode = append_file ? "a" : "w";
@@ -1177,6 +1184,13 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 		}
 		clock_gettime(CLOCK_REALTIME, &tm);
 		fprintf(output, "# started on %s\n", ctime(&tm.tv_sec));
+	} else if (output_fd != 2) {
+		mode = append_file ? "a" : "w";
+		output = fdopen(output_fd, mode);
+		if (!output) {
+			perror("Failed opening logfd");
+			return -errno;
+		}
 	}
 
 	if (csv_sep)
-- 
1.6.2.5

