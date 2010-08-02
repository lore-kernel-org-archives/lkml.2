Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608Ab0HBHwn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 03:52:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:60402 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753195Ab0HBHwl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 03:52:41 -0400
Date: Mon, 2 Aug 2010 07:52:01 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, acme@redhat.com,
        hpa@zytor.com, mingo@redhat.com, peterz@infradead.org, efault@gmx.de,
        fweisbec@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, eranian@google.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com, efault@gmx.de,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf record: Release resources at exit
Message-ID: <tip-39d17dacb3c25df878b56aa80a170d6088e041f9@git.kernel.org>
Git-Commit-ID: 39d17dacb3c25df878b56aa80a170d6088e041f9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 02 Aug 2010 07:52:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  39d17dacb3c25df878b56aa80a170d6088e041f9
Gitweb:     http://git.kernel.org/tip/39d17dacb3c25df878b56aa80a170d6088e041f9
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 29 Jul 2010 14:08:55 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 29 Jul 2010 14:08:55 -0300

perf record: Release resources at exit

So that we can reduce the noise on valgrind when looking for memory
leaks.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |   32 ++++++++++++++++++++++++++------
 1 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index b938796..5ae0d93 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -439,6 +439,7 @@ static void atexit_header(void)
 
 		process_buildids();
 		perf_header__write(&session->header, output, true);
+		perf_session__delete(session);
 	}
 }
 
@@ -558,12 +559,15 @@ static int __cmd_record(int argc, const char **argv)
 	if (!file_new) {
 		err = perf_header__read(session, output);
 		if (err < 0)
-			return err;
+			goto out_delete_session;
 	}
 
 	if (have_tracepoints(attrs, nr_counters))
 		perf_header__set_feat(&session->header, HEADER_TRACE_INFO);
 
+	/*
+ 	 * perf_session__delete(session) will be called at atexit_header()
+	 */
 	atexit(atexit_header);
 
 	if (forks) {
@@ -768,6 +772,10 @@ static int __cmd_record(int argc, const char **argv)
 		bytes_written / 24);
 
 	return 0;
+
+out_delete_session:
+	perf_session__delete(session);
+	return err;
 }
 
 static const char * const record_usage[] = {
@@ -824,7 +832,7 @@ static const struct option options[] = {
 
 int cmd_record(int argc, const char **argv, const char *prefix __used)
 {
-	int i,j;
+	int i, j, err = -ENOMEM;
 
 	argc = parse_options(argc, argv, options, record_usage,
 			    PARSE_OPT_STOP_AT_NON_OPTION);
@@ -873,13 +881,13 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 		for (j = 0; j < MAX_COUNTERS; j++) {
 			fd[i][j] = malloc(sizeof(int)*thread_num);
 			if (!fd[i][j])
-				return -ENOMEM;
+				goto out_free_fd;
 		}
 	}
 	event_array = malloc(
 		sizeof(struct pollfd)*MAX_NR_CPUS*MAX_COUNTERS*thread_num);
 	if (!event_array)
-		return -ENOMEM;
+		goto out_free_fd;
 
 	if (user_interval != ULLONG_MAX)
 		default_interval = user_interval;
@@ -895,8 +903,20 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 		default_interval = freq;
 	} else {
 		fprintf(stderr, "frequency and count are zero, aborting\n");
-		exit(EXIT_FAILURE);
+		err = -EINVAL;
+		goto out_free_event_array;
 	}
 
-	return __cmd_record(argc, argv);
+	err = __cmd_record(argc, argv);
+
+out_free_event_array:
+	free(event_array);
+out_free_fd:
+	for (i = 0; i < MAX_NR_CPUS; i++) {
+		for (j = 0; j < MAX_COUNTERS; j++)
+			free(fd[i][j]);
+	}
+	free(all_tids);
+	all_tids = NULL;
+	return err;
 }
