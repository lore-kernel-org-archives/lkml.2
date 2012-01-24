Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895Ab2AXWP1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 17:15:27 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:36370 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597Ab2AXWP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 17:15:26 -0500
From: Gregory Haskins <gregory.haskins@gmail.com>
Subject: [PATCH] FTRACE: Add a "-D usec" switch to limit execution time of
 "trace-cmd record"
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org
Date: Tue, 24 Jan 2012 17:15:22 -0500
Message-ID: <20120124221453.26831.9039.stgit@linux-mp.laurelwood.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Applies to trace-cmd.git:699f544895]

It is sometimes useful to have a fairly precise timelimit on the capture
rather than relying on a human to hit Cntrl-C in a timely manner.  This
patch simply adds an optional timeout parameter which will automatically
terminate the capture after the specified duration.

Signed-off-by: Gregory Haskins <gregory.haskins@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>
---

 trace-record.c |   12 +++++++++++-
 trace-usage.c  |    3 ++-
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/trace-record.c b/trace-record.c
index fcec28b..444745e 100644
--- a/trace-record.c
+++ b/trace-record.c
@@ -77,6 +77,7 @@ static int buffer_size;
 static const char *output_file = "trace.dat";
 
 static int latency;
+static int timeout = -1;
 static int sleep_time = 1000;
 static int cpu_count;
 static int *pids;
@@ -1953,7 +1954,7 @@ void trace_record (int argc, char **argv)
 			{NULL, 0, NULL, 0}
 		};
 
-		c = getopt_long (argc-1, argv+1, "+hae:f:Fp:cdo:O:s:r:vg:l:n:P:N:tb:kiT",
+		c = getopt_long (argc-1, argv+1, "+hae:f:Fp:cdo:O:s:r:vg:l:n:D:P:N:tb:kiT",
 				 long_options, &option_index);
 		if (c == -1)
 			break;
@@ -2051,6 +2052,9 @@ void trace_record (int argc, char **argv)
 			optarg++;
 			optarg[0] = '\0';
 			break;
+		case 'D':
+		        timeout = atoi(optarg);
+		        break;
 		case 'd':
 			if (extract)
 				usage(argv);
@@ -2189,8 +2193,14 @@ void trace_record (int argc, char **argv)
 
 	if (record) {
 		signal(SIGINT, finish);
+		signal(SIGALRM, finish);
 		if (!latency)
 			start_threads();
+
+		if (timeout > 0) {
+		        struct itimerval tv = { {0, 0}, {0, timeout}};
+		        setitimer(ITIMER_REAL, &tv, NULL);
+		}
 	}
 
 	if (extract) {
diff --git a/trace-usage.c b/trace-usage.c
index 0e2194e..df41f76 100644
--- a/trace-usage.c
+++ b/trace-usage.c
@@ -17,7 +17,7 @@ static struct usage_help usage_help[] = {
 		"record",
 		"record a trace into a trace.dat file",
 		" %s record [-v][-e event [-f filter]][-p plugin][-F][-d][-o file] \\\n"
-		"           [-s usecs][-O option ][-l func][-g func][-n func] \\\n"
+		"           [-s usecs][-D usecs][-O option ][-l func][-g func][-n func] \\\n"
 		"           [-P pid][-N host:port][-t][-r prio][-b size][command ...]\n"
 		"          -e run command with event enabled\n"
 		"          -f filter for previous -e event\n"
@@ -35,6 +35,7 @@ static struct usage_help usage_help[] = {
 		"          -O option to enable (or disable)\n"
 		"          -r real time priority to run the capture threads\n"
 		"          -s sleep interval between recording (in usecs) [default: 1000]\n"
+		"          -D run-time duration (in usecs) [default: disabled]\n"
 		"          -N host:port to connect to (see listen)\n"
 		"          -t used with -N, forces use of tcp in live trace\n"
 		"          -b change kernel buffersize (in kilobytes per CPU)\n"

