Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682Ab0HBBLh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 21:11:37 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38029 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555Ab0HBBJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 21:09:10 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 11/19] perf record: Release resources at exit
Date: Sun,  1 Aug 2010 22:08:46 -0300
Message-Id: <1280711334-30000-12-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1280711334-30000-1-git-send-email-acme@infradead.org>
References: <1280711334-30000-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

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
-- 
1.6.2.5

