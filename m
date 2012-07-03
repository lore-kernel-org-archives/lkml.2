Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314Ab2GCEIf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 00:08:35 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63893 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101Ab2GCEId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 00:08:33 -0400
From: David Ahern <dsahern@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] perf tool: save cmdline from user in file header vs what is passed to record
Date: Mon,  2 Jul 2012 22:08:26 -0600
Message-Id: <1341288506-85207-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A number of builtin commands process some user args and then pass the rest
to cmd_record. cmd_record then saves argc/argv that it receives into the
header of the perf data file. But this loses the arguments handled by the
first command -- ie., the real command line from the user. This patch saves
the command line as typed by the user rather than what was passed to
cmd_record.

As an example consider the command:
$ perf kvm --guest --host --guestmount=/tmp/guest-mount record
    -fo /tmp/perf.data -ag -- sleep 10

Currently the command saved to the header is:
 cmdline : /tmp/p3.5/perf record -o perf.data.kvm -fo /tmp/perf.data -ag -- sleep 1

(ignore the duplicated -o -- the first would be yet another bug with perf-kvm).

With this patch the command line saved to the header is:
 cmdline : /tmp/p3.5/perf kvm --guest --host --guestmount=/tmp/guest-mount
           record -fo /tmp/perf.data -ag -- sleep 1

Signed-off-by: David Ahern <dsahern@gmail.com>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 tools/perf/builtin-kmem.c      |    2 ++
 tools/perf/builtin-kvm.c       |    2 ++
 tools/perf/builtin-lock.c      |    2 ++
 tools/perf/builtin-sched.c     |    2 ++
 tools/perf/builtin-script.c    |    2 ++
 tools/perf/builtin-timechart.c |    2 ++
 tools/perf/util/header.c       |    9 +++++++++
 7 files changed, 21 insertions(+)

diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index ce35015..08c8f74 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -770,6 +770,8 @@ static int __cmd_record(int argc, const char **argv)
 
 int cmd_kmem(int argc, const char **argv, const char *prefix __used)
 {
+	perf_header__set_cmdline(argc, argv);
+
 	argc = parse_options(argc, argv, kmem_options, kmem_usage, 0);
 
 	if (!argc)
diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 9fc6e0f..913d0a8 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -107,6 +107,8 @@ int cmd_kvm(int argc, const char **argv, const char *prefix __used)
 	perf_host  = 0;
 	perf_guest = 1;
 
+	perf_header__set_cmdline(argc, argv);
+
 	argc = parse_options(argc, argv, kvm_options, kvm_usage,
 			PARSE_OPT_STOP_AT_NON_OPTION);
 	if (!argc)
diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index b3c4285..89917e1 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -980,6 +980,8 @@ int cmd_lock(int argc, const char **argv, const char *prefix __used)
 	for (i = 0; i < LOCKHASH_SIZE; i++)
 		INIT_LIST_HEAD(lockhash_table + i);
 
+	perf_header__set_cmdline(argc, argv);
+
 	argc = parse_options(argc, argv, lock_options, lock_usage,
 			     PARSE_OPT_STOP_AT_NON_OPTION);
 	if (!argc)
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 7a9ad2b..25113b2 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1899,6 +1899,8 @@ static int __cmd_record(int argc, const char **argv)
 
 int cmd_sched(int argc, const char **argv, const char *prefix __used)
 {
+	perf_header__set_cmdline(argc, argv);
+
 	argc = parse_options(argc, argv, sched_options, sched_usage,
 			     PARSE_OPT_STOP_AT_NON_OPTION);
 	if (!argc)
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 1e60ab7..07bc60b 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -1206,6 +1206,8 @@ int cmd_script(int argc, const char **argv, const char *prefix __used)
 
 	setup_scripting();
 
+	perf_header__set_cmdline(argc, argv);
+
 	argc = parse_options(argc, argv, options, script_usage,
 			     PARSE_OPT_STOP_AT_NON_OPTION);
 
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 3b75b2e..1e776a6 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -1108,6 +1108,8 @@ static const struct option options[] = {
 
 int cmd_timechart(int argc, const char **argv, const char *prefix __used)
 {
+	perf_header__set_cmdline(argc, argv);
+
 	argc = parse_options(argc, argv, options, timechart_usage,
 			PARSE_OPT_STOP_AT_NON_OPTION);
 
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 5a47aba..99e410c 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -174,6 +174,15 @@ perf_header__set_cmdline(int argc, const char **argv)
 {
 	int i;
 
+	/* 
+	 * If header_argv has already been set, do not override it.
+	 * This allows a command to set the cmdline, parse args and
+	 * then call another builtin function that implements a
+	 * command -- e.g, cmd_kvm calling cmd_record.
+	 */
+	if (header_argv)
+		return 0;
+
 	header_argc = (u32)argc;
 
 	/* do not include NULL termination */
-- 
1.7.10.1

