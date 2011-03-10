Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816Ab1CJJ4k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 04:56:40 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:55048 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751922Ab1CJJ4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 04:56:37 -0500
Message-ID: <4D78A0A9.40000@cn.fujitsu.com>
Date: Thu, 10 Mar 2011 17:58:01 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] trace-cmd: fold option parsing
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-10 17:55:10,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-10 17:55:15,
	Serialize complete at 2011-03-10 17:55:15
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 trace-listen.c |   12 +++++-------
 trace-read.c   |   35 +++++++++++++++--------------------
 trace-record.c |   14 +++++---------
 trace-stack.c  |   32 +++++++++++++++-----------------
 4 files changed, 40 insertions(+), 53 deletions(-)

diff --git a/trace-listen.c b/trace-listen.c
index e60c96b..daaffca 100644
--- a/trace-listen.c
+++ b/trace-listen.c
@@ -647,6 +647,8 @@ static void start_daemon(void)
 		die("starting daemon");
 }
 
+#define OPT_debug	255
+
 void trace_listen(int argc, char **argv)
 {
 	char *logfile = NULL;
@@ -666,7 +668,7 @@ void trace_listen(int argc, char **argv)
 		static struct option long_options[] = {
 			{"port", required_argument, NULL, 'p'},
 			{"help", no_argument, NULL, '?'},
-			{"debug", no_argument, NULL, 0},
+			{"debug", no_argument, NULL, OPT_debug},
 			{NULL, 0, NULL, 0}
 		};
 
@@ -696,12 +698,8 @@ void trace_listen(int argc, char **argv)
 		case 'D':
 			daemon = 1;
 			break;
-		case 0:
-			switch (option_index) {
-			case 2:
-				debug = 1;
-				break;
-			}
+		case OPT_debug:
+			debug = 1;
 			break;
 		default:
 			usage(argv);
diff --git a/trace-read.c b/trace-read.c
index 932f5aa..018476d 100644
--- a/trace-read.c
+++ b/trace-read.c
@@ -812,6 +812,10 @@ static void add_functions(struct pevent *pevent, const char *file)
 	free(buf);
 }
 
+#define OPT_cpu		255
+#define OPT_events	254
+#define OPT_kallsyms	253
+
 void trace_report (int argc, char **argv)
 {
 	struct tracecmd_input *handle;
@@ -845,10 +849,10 @@ void trace_report (int argc, char **argv)
 	for (;;) {
 		int option_index = 0;
 		static struct option long_options[] = {
-			{"cpu", required_argument, NULL, 0},
-			{"events", no_argument, NULL, 0},
+			{"cpu", required_argument, NULL, OPT_cpu},
+			{"events", no_argument, NULL, OPT_events},
 			{"filter-test", no_argument, NULL, 'T'},
-			{"kallsyms", required_argument, NULL, 0},
+			{"kallsyms", required_argument, NULL, OPT_kallsyms},
 			{"help", no_argument, NULL, '?'},
 			{NULL, 0, NULL, 0}
 		};
@@ -917,23 +921,14 @@ void trace_report (int argc, char **argv)
 		case 'q':
 			silence_warnings = 1;
 			break;
-		case 0:
-			switch(option_index) {
-			case 0: /* cpu */
-				parse_cpulist(optarg);
-				break;
-			case 1: /* events */
-				print_events = 1;
-				break;
-			case 2: /* filter-test */
-				test_filters = 1;
-				break;
-			case 3: /* kallsyms */
-				functions = optarg;
-				break;
-			default:
-				usage(argv);
-			}
+		case OPT_cpu:
+			parse_cpulist(optarg);
+			break;
+		case OPT_events:
+			print_events = 1;
+			break;
+		case OPT_kallsyms:
+			functions = optarg;
 			break;
 		default:
 			usage(argv);
diff --git a/trace-record.c b/trace-record.c
index 2611bfa..1cf13b6 100644
--- a/trace-record.c
+++ b/trace-record.c
@@ -1809,6 +1809,8 @@ static void record_all_events(void)
 	listed_events = list;
 }
 
+#define OPT_date	255
+
 void trace_record (int argc, char **argv)
 {
 	const char *plugin = NULL;
@@ -1862,7 +1864,7 @@ void trace_record (int argc, char **argv)
 	for (;;) {
 		int option_index = 0;
 		static struct option long_options[] = {
-			{"date", no_argument, NULL, 0},
+			{"date", no_argument, NULL, OPT_date},
 			{"help", no_argument, NULL, '?'},
 			{NULL, 0, NULL, 0}
 		};
@@ -2002,14 +2004,8 @@ void trace_record (int argc, char **argv)
 		case 'i':
 			ignore_event_not_found = 1;
 			break;
-		case 0:
-			switch (option_index) {
-			case 0: /* date */
-				date = 1;
-				break;
-			default:
-				usage(argv);
-			}
+		case OPT_date:
+			date = 1;
 			break;
 		default:
 			usage(argv);
diff --git a/trace-stack.c b/trace-stack.c
index 3d9f392..24ba194 100644
--- a/trace-stack.c
+++ b/trace-stack.c
@@ -153,6 +153,10 @@ static void read_trace(void)
 	fclose(fp);
 }
 
+#define OPT_start	255
+#define OPT_stop	254
+#define OPT_reset	253
+
 void trace_stack (int argc, char **argv)
 {
 	enum stack_type trace_type = STACK_REPORT;
@@ -167,9 +171,9 @@ void trace_stack (int argc, char **argv)
 	for (;;) {
 		int option_index = 0;
 		static struct option long_options[] = {
-			{"start", no_argument, NULL, 0},
-			{"stop", no_argument, NULL, 0},
-			{"reset", no_argument, NULL, 0},
+			{"start", no_argument, NULL, OPT_start},
+			{"stop", no_argument, NULL, OPT_stop},
+			{"reset", no_argument, NULL, OPT_reset},
 			{"help", no_argument, NULL, '?'},
 			{NULL, 0, NULL, 0}
 		};
@@ -183,20 +187,14 @@ void trace_stack (int argc, char **argv)
 		case 'h':
 			usage(argv);
 			break;
-		case 0:
-			switch(option_index) {
-			case 0:
-				trace_type = STACK_START;
-				break;
-			case 1:
-				trace_type = STACK_STOP;
-				break;
-			case 2:
-				trace_type = STACK_RESET;
-				break;
-			default:
-				usage(argv);
-			}
+		case OPT_start:
+			trace_type = STACK_START;
+			break;
+		case OPT_stop:
+			trace_type = STACK_STOP;
+			break;
+		case OPT_reset:
+			trace_type = STACK_RESET;
 			break;
 		default:
 			usage(argv);
-- 
1.7.4

