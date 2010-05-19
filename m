Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756538Ab0ESA2Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 20:28:25 -0400
Received: from casper.infradead.org ([85.118.1.10]:50885 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755410Ab0ESA2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 20:28:15 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
       "David S. Miller" <davem@davemloft.net>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>, Tom Zanussi <tzanussi@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/5] perf stat: add perf stat -B to pretty print large numbers
Date: Tue, 18 May 2010 21:27:57 -0300
Message-Id: <1274228881-8035-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1274228881-8035-1-git-send-email-acme@infradead.org>
References: <1274228881-8035-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephane Eranian <eranian@google.com>

It is hard to read very large numbers so provide an option to perf stat
to separate thousands using a separator. The patch leverages the locale
support of stdio. You need to set your LC_NUMERIC appropriately, for
instance LC_NUMERIC=en_US.UTF8. You need to pass -B to activate this
feature. This way existing scripts parsing the output do not need to be
changed. Here is an example.

$ perf stat noploop 2
noploop for 2 seconds

 Performance counter stats for 'noploop 2':

        1998.347031  task-clock-msecs         #      0.998 CPUs
                 61  context-switches         #      0.000 M/sec
                  0  CPU-migrations           #      0.000 M/sec
                118  page-faults              #      0.000 M/sec
      4,138,410,900  cycles                   #   2070.917 M/sec  (scaled from 70.01%)
      2,062,650,268  instructions             #      0.498 IPC    (scaled from 70.01%)
      2,057,653,466  branches                 #   1029.678 M/sec  (scaled from 70.01%)
             40,267  branch-misses            #      0.002 %      (scaled from 30.04%)
      2,055,961,348  cache-references         #   1028.831 M/sec  (scaled from 30.03%)
             53,725  cache-misses             #      0.027 M/sec  (scaled from 30.02%)

        2.001393933  seconds time elapsed

$ perf stat -B  noploop 2
noploop for 2 seconds

 Performance counter stats for 'noploop 2':

        1998.297883  task-clock-msecs         #      0.998 CPUs
                 59  context-switches         #      0.000 M/sec
                  0  CPU-migrations           #      0.000 M/sec
                119  page-faults              #      0.000 M/sec
      4,131,380,160  cycles                   #   2067.450 M/sec  (scaled from 70.01%)
      2,059,096,507  instructions             #      0.498 IPC    (scaled from 70.01%)
      2,054,681,303  branches                 #   1028.216 M/sec  (scaled from 70.01%)
             25,650  branch-misses            #      0.001 %      (scaled from 30.05%)
      2,056,283,014  cache-references         #   1029.017 M/sec  (scaled from 30.03%)
             47,097  cache-misses             #      0.024 M/sec  (scaled from 30.02%)

        2.001391016  seconds time elapsed

Cc: David S. Miller <davem@davemloft.net>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <4bf28fe8.914ed80a.01ca.fffff5f5@mx.google.com>
Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-stat.txt |    3 +++
 tools/perf/builtin-stat.c              |   18 ++++++++++++++----
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/tools/perf/Documentation/perf-stat.txt b/tools/perf/Documentation/perf-stat.txt
index 2cab8e8..909fa76 100644
--- a/tools/perf/Documentation/perf-stat.txt
+++ b/tools/perf/Documentation/perf-stat.txt
@@ -43,6 +43,9 @@ OPTIONS
 -c::
         scale counter values
 
+-B::
+        print large numbers with thousands' separators according to locale
+
 EXAMPLES
 --------
 
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index ff8c413..9a39ca3 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -50,6 +50,7 @@
 
 #include <sys/prctl.h>
 #include <math.h>
+#include <locale.h>
 
 static struct perf_event_attr default_attrs[] = {
 
@@ -80,6 +81,8 @@ static pid_t			*all_tids			=  NULL;
 static int			thread_num			=  0;
 static pid_t			child_pid			= -1;
 static bool			null_run			=  false;
+static bool			big_num				=  false;
+
 
 static int			*fd[MAX_NR_CPUS][MAX_COUNTERS];
 
@@ -377,7 +380,7 @@ static void nsec_printout(int counter, double avg)
 {
 	double msecs = avg / 1e6;
 
-	fprintf(stderr, " %14.6f  %-24s", msecs, event_name(counter));
+	fprintf(stderr, " %18.6f  %-24s", msecs, event_name(counter));
 
 	if (MATCH_EVENT(SOFTWARE, SW_TASK_CLOCK, counter)) {
 		fprintf(stderr, " # %10.3f CPUs ",
@@ -389,7 +392,10 @@ static void abs_printout(int counter, double avg)
 {
 	double total, ratio = 0.0;
 
-	fprintf(stderr, " %14.0f  %-24s", avg, event_name(counter));
+	if (big_num)
+		fprintf(stderr, " %'18.0f  %-24s", avg, event_name(counter));
+	else
+		fprintf(stderr, " %18.0f  %-24s", avg, event_name(counter));
 
 	if (MATCH_EVENT(HARDWARE, HW_INSTRUCTIONS, counter)) {
 		total = avg_stats(&runtime_cycles_stats);
@@ -426,7 +432,7 @@ static void print_counter(int counter)
 	int scaled = event_scaled[counter];
 
 	if (scaled == -1) {
-		fprintf(stderr, " %14s  %-24s\n",
+		fprintf(stderr, " %18s  %-24s\n",
 			"<not counted>", event_name(counter));
 		return;
 	}
@@ -477,7 +483,7 @@ static void print_stat(int argc, const char **argv)
 		print_counter(counter);
 
 	fprintf(stderr, "\n");
-	fprintf(stderr, " %14.9f  seconds time elapsed",
+	fprintf(stderr, " %18.9f  seconds time elapsed",
 			avg_stats(&walltime_nsecs_stats)/1e9);
 	if (run_count > 1) {
 		fprintf(stderr, "   ( +- %7.3f%% )",
@@ -534,6 +540,8 @@ static const struct option options[] = {
 		    "repeat command and print average + stddev (max: 100)"),
 	OPT_BOOLEAN('n', "null", &null_run,
 		    "null run - dont start any counters"),
+	OPT_BOOLEAN('B', "big-num", &big_num,
+		    "print large numbers with thousands\' separators"),
 	OPT_END()
 };
 
@@ -542,6 +550,8 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 	int status;
 	int i,j;
 
+	setlocale(LC_ALL, "");
+
 	argc = parse_options(argc, argv, options, stat_usage,
 		PARSE_OPT_STOP_AT_NON_OPTION);
 	if (!argc && target_pid == -1 && target_tid == -1)
-- 
1.6.2.5

