Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574Ab2GFEJa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 00:09:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52281 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab2GFEJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 00:09:29 -0400
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
Date: Thu,  5 Jul 2012 22:09:22 -0600
Message-Id: <1341547762-17430-1-git-send-email-dsahern@gmail.com>
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

v2: simplified to saving the command in parse_options per Stephane's suggestion

Signed-off-by: David Ahern <dsahern@gmail.com>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 tools/perf/builtin-record.c     |    2 --
 tools/perf/util/header.c        |    9 +++++++++
 tools/perf/util/parse-options.c |    3 +++
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index f5a6452..77adcd8 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -844,8 +844,6 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 	struct perf_record *rec = &record;
 	char errbuf[BUFSIZ];
 
-	perf_header__set_cmdline(argc, argv);
-
 	evsel_list = perf_evlist__new(NULL, NULL);
 	if (evsel_list == NULL)
 		return -ENOMEM;
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
diff --git a/tools/perf/util/parse-options.c b/tools/perf/util/parse-options.c
index 99d02aa..594f8fa 100644
--- a/tools/perf/util/parse-options.c
+++ b/tools/perf/util/parse-options.c
@@ -1,6 +1,7 @@
 #include "util.h"
 #include "parse-options.h"
 #include "cache.h"
+#include "header.h"
 
 #define OPT_SHORT 1
 #define OPT_UNSET 2
@@ -413,6 +414,8 @@ int parse_options(int argc, const char **argv, const struct option *options,
 {
 	struct parse_opt_ctx_t ctx;
 
+	perf_header__set_cmdline(argc, argv);
+
 	parse_options_start(&ctx, argc, argv, flags);
 	switch (parse_options_step(&ctx, options, usagestr)) {
 	case PARSE_OPT_HELP:
-- 
1.7.10.1

