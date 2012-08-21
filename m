Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757614Ab2HUPii (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 11:38:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59986 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755379Ab2HUPid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 11:38:33 -0400
Date: Tue, 21 Aug 2012 08:38:01 -0700
From: tip-bot for David Ahern <dsahern@gmail.com>
Message-ID: <tip-d25dcba8541c1cc31621d5cefce0304dafb9ae4f@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, acme@ghostprotocols.net,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, fweisbec@gmail.com, acme@ghostprotocols.net,
        peterz@infradead.org, dsahern@gmail.com, tglx@linutronix.de,
        namhyung@kernel.org, jolsa@redhat.com
In-Reply-To: <1344530137-25521-1-git-send-email-dsahern@gmail.com>
References: <1344530137-25521-1-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf lock record:
  improve message when tracepoints are not enabled
Git-Commit-ID: d25dcba8541c1cc31621d5cefce0304dafb9ae4f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 08:38:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d25dcba8541c1cc31621d5cefce0304dafb9ae4f
Gitweb:     http://git.kernel.org/tip/d25dcba8541c1cc31621d5cefce0304dafb9ae4f
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Thu, 9 Aug 2012 10:35:37 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 9 Aug 2012 14:14:28 -0300

perf lock record: improve message when tracepoints are not enabled

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
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1344530137-25521-1-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-lock.c |   29 ++++++++++++++++++++++++-----
 1 files changed, 24 insertions(+), 5 deletions(-)

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
 
