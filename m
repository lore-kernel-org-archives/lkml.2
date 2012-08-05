Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877Ab2HEQ4k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 12:56:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56963 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754697Ab2HEQ4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 12:56:39 -0400
Date: Sun, 5 Aug 2012 09:53:05 -0700
From: tip-bot for David Ahern <dsahern@gmail.com>
Message-ID: <tip-56e6f602aa4432f7fe90a0d9ba379b2735b07b6b@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        namhyung@gmail.com, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, fweisbec@gmail.com,
        peterz@infradead.org, dsahern@gmail.com, tglx@linutronix.de,
        namhyung@gmail.com, jolsa@redhat.com
In-Reply-To: <1343616831-6408-1-git-send-email-dsahern@gmail.com>
References: <1343616831-6408-1-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tool:
  Save cmdline from user in file header vs what is passed to record
Git-Commit-ID: 56e6f602aa4432f7fe90a0d9ba379b2735b07b6b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 05 Aug 2012 09:53:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  56e6f602aa4432f7fe90a0d9ba379b2735b07b6b
Gitweb:     http://git.kernel.org/tip/56e6f602aa4432f7fe90a0d9ba379b2735b07b6b
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Sun, 29 Jul 2012 20:53:51 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 3 Aug 2012 10:33:50 -0300

perf tool: Save cmdline from user in file header vs what is passed to record

A number of builtin commands process some user args and then pass the rest to
cmd_record. cmd_record then saves argc/argv that it receives into the header of
the perf data file. But this loses the arguments handled by the first command
-- ie., the real command line from the user. This patch saves the command line
as typed by the user rather than what was passed to cmd_record.

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
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1343616831-6408-1-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c     |    2 --
 tools/perf/util/header.c        |    9 +++++++++
 tools/perf/util/parse-options.c |    3 +++
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index dc2b625..4db6e1b 100644
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
index 3a6d204..74ea3c2 100644
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
