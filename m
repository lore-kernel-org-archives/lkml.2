Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758684Ab2HIQfx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 12:35:53 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:58302 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757926Ab2HIQfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 12:35:51 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] perf lock record: improve message when tracepoints are not enabled
Date: Thu,  9 Aug 2012 10:35:37 -0600
Message-Id: <1344530137-25521-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG options required for perf-lock are not enabled then the
corresponding tracepoints will not be enabled. Currently, the message to
the user is:
  $ perf lock record -a -- sleep 1
  invalid or unsupported event: 'lock:lock_acquire'
  Run 'perf list' for a list of valid events

Improve the message with a suggestion on which CONFIG options are needed:
  $ perf lock record -a -- sleep 1
  tracepoint lock:lock_acquire is not enabled. Are CONFIG_LOCKDEP and CONFIG_LOCK_STAT enabled?

Suggested-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 tools/perf/builtin-lock.c |   29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index 3f8b955..585aae2 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -903,16 +903,19 @@ static const struct option lock_options[] = {
 	OPT_END()
 };
 
+static const char * const lock_tracepoints[] = {
+	"lock:lock_acquire",    /* CONFIG_LOCKDEP */
+	"lock:lock_acquired",   /* CONFIG_LOCKDEP, CONFIG_LOCK_STAT */
+	"lock:lock_contended",  /* CONFIG_LOCKDEP, CONFIG_LOCK_STAT */
+	"lock:lock_release",    /* CONFIG_LOCKDEP */
+};
+
 static const char *record_args[] = {
 	"record",
 	"-R",
 	"-f",
 	"-m", "1024",
 	"-c", "1",
-	"-e", "lock:lock_acquire",
-	"-e", "lock:lock_acquired",
-	"-e", "lock:lock_contended",
-	"-e", "lock:lock_release",
 };
 
 static int __cmd_record(int argc, const char **argv)
@@ -920,15 +923,31 @@ static int __cmd_record(int argc, const char **argv)
 	unsigned int rec_argc, i, j;
 	const char **rec_argv;
 
+	for (i = 0; i < ARRAY_SIZE(lock_tracepoints); i++) {
+		if (!is_valid_tracepoint(lock_tracepoints[i])) {
+				pr_err("tracepoint %s is not enabled. "
+				       "Are CONFIG_LOCKDEP and CONFIG_LOCK_STAT enabled?\n",
+				       lock_tracepoints[i]);
+				return 1;
+		}
+	}
+
 	rec_argc = ARRAY_SIZE(record_args) + argc - 1;
-	rec_argv = calloc(rec_argc + 1, sizeof(char *));
+	/* factor of 2 is for -e in front of each tracepoint */
+	rec_argc += 2 * ARRAY_SIZE(lock_tracepoints);
 
+	rec_argv = calloc(rec_argc + 1, sizeof(char *));
 	if (rec_argv == NULL)
 		return -ENOMEM;
 
 	for (i = 0; i < ARRAY_SIZE(record_args); i++)
 		rec_argv[i] = strdup(record_args[i]);
 
+	for (j = 0; j < ARRAY_SIZE(lock_tracepoints); j++) {
+		rec_argv[i++] = "-e";
+		rec_argv[i++] = strdup(lock_tracepoints[j]);
+	}
+
 	for (j = 1; j < (unsigned int)argc; j++, i++)
 		rec_argv[i] = argv[j];
 
-- 
1.7.10.1

