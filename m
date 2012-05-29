Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442Ab2E2EXS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 00:23:18 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52230 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab2E2EXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 00:23:16 -0400
From: Namhyung Kim <namhyung@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Pekka Enberg <penberg@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/7] perf tools: Convert critical messages to ui__error()
Date: Tue, 29 May 2012 13:22:57 +0900
Message-Id: <1338265382-6872-3-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1338265382-6872-1-git-send-email-namhyung@gmail.com>
References: <1338265382-6872-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There were places where use ui__warning (or even fprintf) to
show critical messages. This patch converts them to ui__error
so that the front-end code can implement appropriate behavior.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 tools/perf/builtin-annotate.c |    2 +-
 tools/perf/builtin-record.c   |   14 +++++++-------
 tools/perf/builtin-report.c   |   14 ++++++--------
 tools/perf/builtin-top.c      |   22 +++++++++++-----------
 4 files changed, 25 insertions(+), 27 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 806e0a286634..67522cf87405 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -215,7 +215,7 @@ static int __cmd_annotate(struct perf_annotate *ann)
 	}
 
 	if (total_nr_samples == 0) {
-		ui__warning("The %s file has no samples!\n", session->filename);
+		ui__error("The %s file has no samples!\n", session->filename);
 		goto out_delete;
 	}
 out_delete:
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index e5cb08427e13..f95840d04e4c 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -264,7 +264,7 @@ try_again:
 			}
 
 			if (err == ENOENT) {
-				ui__warning("The %s event is not supported.\n",
+				ui__error("The %s event is not supported.\n",
 					    event_name(pos));
 				exit(EXIT_FAILURE);
 			}
@@ -858,8 +858,8 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 		usage_with_options(record_usage, record_options);
 
 	if (rec->force && rec->append_file) {
-		fprintf(stderr, "Can't overwrite and append at the same time."
-				" You need to choose between -f and -A");
+		ui__error("Can't overwrite and append at the same time."
+			  " You need to choose between -f and -A");
 		usage_with_options(record_usage, record_options);
 	} else if (rec->append_file) {
 		rec->write_mode = WRITE_APPEND;
@@ -868,8 +868,8 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 	}
 
 	if (nr_cgroups && !rec->opts.target.system_wide) {
-		fprintf(stderr, "cgroup monitoring only available in"
-			" system-wide mode\n");
+		ui__error("cgroup monitoring only available in"
+			  " system-wide mode\n");
 		usage_with_options(record_usage, record_options);
 	}
 
@@ -905,7 +905,7 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 		int saved_errno = errno;
 
 		perf_target__strerror(&rec->opts.target, err, errbuf, BUFSIZ);
-		ui__warning("%s", errbuf);
+		ui__error("%s", errbuf);
 
 		err = -saved_errno;
 		goto out_free_fd;
@@ -933,7 +933,7 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 	else if (rec->opts.freq) {
 		rec->opts.default_interval = rec->opts.freq;
 	} else {
-		fprintf(stderr, "frequency and count are zero, aborting\n");
+		ui__error("frequency and count are zero, aborting\n");
 		err = -EINVAL;
 		goto out_free_fd;
 	}
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index d58e41445d0d..8c767c6bca91 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -251,13 +251,13 @@ static int perf_report__setup_sample_type(struct perf_report *rep)
 
 	if (!(self->sample_type & PERF_SAMPLE_CALLCHAIN)) {
 		if (sort__has_parent) {
-			ui__warning("Selected --sort parent, but no "
+			ui__error("Selected --sort parent, but no "
 				    "callchain data. Did you call "
 				    "'perf record' without -g?\n");
 			return -EINVAL;
 		}
 		if (symbol_conf.use_callchain) {
-			ui__warning("Selected -g but no callchain data. Did "
+			ui__error("Selected -g but no callchain data. Did "
 				    "you call 'perf record' without -g?\n");
 			return -1;
 		}
@@ -266,17 +266,15 @@ static int perf_report__setup_sample_type(struct perf_report *rep)
 		   !symbol_conf.use_callchain) {
 			symbol_conf.use_callchain = true;
 			if (callchain_register_param(&callchain_param) < 0) {
-				ui__warning("Can't register callchain "
-					    "params.\n");
+				ui__error("Can't register callchain params.\n");
 				return -EINVAL;
 			}
 	}
 
 	if (sort__branch_mode == 1) {
 		if (!(self->sample_type & PERF_SAMPLE_BRANCH_STACK)) {
-			fprintf(stderr, "selected -b but no branch data."
-					" Did you call perf record without"
-					" -b?\n");
+			ui__error("Selected -b but no branch data. "
+				  "Did you call perf record without -b?\n");
 			return -1;
 		}
 	}
@@ -420,7 +418,7 @@ static int __cmd_report(struct perf_report *rep)
 	}
 
 	if (nr_samples == 0) {
-		ui__warning("The %s file has no samples!\n", session->filename);
+		ui__error("The %s file has no samples!\n", session->filename);
 		goto out_delete;
 	}
 
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 6031dce0429f..906cccb5b4db 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -959,16 +959,16 @@ try_again:
 			}
 
 			if (err == ENOENT) {
-				ui__warning("The %s event is not supported.\n",
+				ui__error("The %s event is not supported.\n",
 					    event_name(counter));
 				goto out_err;
 			} else if (err == EMFILE) {
-				ui__warning("Too many events are opened.\n"
+				ui__error("Too many events are opened.\n"
 					    "Try again after reducing the number of events\n");
 				goto out_err;
 			}
 
-			ui__warning("The sys_perf_event_open() syscall "
+			ui__error("The sys_perf_event_open() syscall "
 				    "returned with %d (%s).  /bin/dmesg "
 				    "may provide additional information.\n"
 				    "No CONFIG_PERF_EVENTS=y kernel support "
@@ -978,7 +978,7 @@ try_again:
 	}
 
 	if (perf_evlist__mmap(evlist, top->mmap_pages, false) < 0) {
-		ui__warning("Failed to mmap with %d (%s)\n",
+		ui__error("Failed to mmap with %d (%s)\n",
 			    errno, strerror(errno));
 		goto out_err;
 	}
@@ -994,12 +994,12 @@ static int perf_top__setup_sample_type(struct perf_top *top)
 {
 	if (!top->sort_has_symbols) {
 		if (symbol_conf.use_callchain) {
-			ui__warning("Selected -g but \"sym\" not present in --sort/-s.");
+			ui__error("Selected -g but \"sym\" not present in --sort/-s.");
 			return -EINVAL;
 		}
 	} else if (!top->dont_use_callchains && callchain_param.mode != CHAIN_NONE) {
 		if (callchain_register_param(&callchain_param) < 0) {
-			ui__warning("Can't register callchain params.\n");
+			ui__error("Can't register callchain params.\n");
 			return -EINVAL;
 		}
 	}
@@ -1041,7 +1041,7 @@ static int __cmd_top(struct perf_top *top)
 
 	if (pthread_create(&thread, NULL, (use_browser > 0 ? display_thread_tui :
 							    display_thread), top)) {
-		printf("Could not create display thread.\n");
+		ui__error("Could not create display thread.\n");
 		exit(-1);
 	}
 
@@ -1050,7 +1050,7 @@ static int __cmd_top(struct perf_top *top)
 
 		param.sched_priority = top->realtime_prio;
 		if (sched_setscheduler(0, SCHED_FIFO, &param)) {
-			printf("Could not set realtime priority.\n");
+			ui__error("Could not set realtime priority.\n");
 			exit(-1);
 		}
 	}
@@ -1274,7 +1274,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 		int saved_errno = errno;
 
 		perf_target__strerror(&top.target, status, errbuf, BUFSIZ);
-		ui__warning("%s", errbuf);
+		ui__error("%s", errbuf);
 
 		status = -saved_errno;
 		goto out_delete_evlist;
@@ -1288,7 +1288,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 
 	if (!top.evlist->nr_entries &&
 	    perf_evlist__add_default(top.evlist) < 0) {
-		pr_err("Not enough memory for event selector list\n");
+		ui__error("Not enough memory for event selector list\n");
 		return -ENOMEM;
 	}
 
@@ -1305,7 +1305,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 	else if (top.freq) {
 		top.default_interval = top.freq;
 	} else {
-		fprintf(stderr, "frequency and count are zero, aborting\n");
+		ui__error("frequency and count are zero, aborting\n");
 		exit(EXIT_FAILURE);
 	}
 
-- 
1.7.9.2

