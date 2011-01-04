Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751235Ab1ADDsl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 22:48:41 -0500
Received: from casper.infradead.org ([85.118.1.10]:43464 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971Ab1ADDsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 22:48:40 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 04/11] perf evsel: Delete the event selectors at exit
Date: Tue,  4 Jan 2011 01:48:18 -0200
Message-Id: <1294112905-25325-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1294112905-25325-1-git-send-email-acme@infradead.org>
References: <1294112905-25325-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Freeing all the possibly allocated resources, reducing complexity
on each tool exit path.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c    |    2 --
 tools/perf/builtin-stat.c      |    4 +---
 tools/perf/builtin-top.c       |    4 +---
 tools/perf/perf.c              |    2 ++
 tools/perf/util/parse-events.c |   11 +++++++++++
 tools/perf/util/parse-events.h |    1 +
 6 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index e68aee3..052de17 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -965,8 +965,6 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 out_free_event_array:
 	free(event_array);
 out_free_fd:
-	list_for_each_entry(pos, &evsel_list, node)
-		perf_evsel__free_fd(pos);
 	free(all_tids);
 	all_tids = NULL;
 out_symbol_exit:
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 3e5f356..589ba3a 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -844,10 +844,8 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 	if (status != -1)
 		print_stat(argc, argv);
 out_free_fd:
-	list_for_each_entry(pos, &evsel_list, node) {
-		perf_evsel__free_fd(pos);
+	list_for_each_entry(pos, &evsel_list, node)
 		perf_evsel__free_stat_priv(pos);
-	}
 out:
 	return status;
 }
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 13a836e..27b9c14 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1495,10 +1495,8 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 
 	status = __cmd_top();
 out_free_fd:
-	list_for_each_entry(pos, &evsel_list, node) {
-		perf_evsel__free_fd(pos);
+	list_for_each_entry(pos, &evsel_list, node)
 		perf_evsel__free_mmap(pos);
-	}
 
 	return status;
 }
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 595d0f4..5b1ecd6 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -286,6 +286,8 @@ static int run_builtin(struct cmd_struct *p, int argc, const char **argv)
 	status = p->fn(argc, argv, prefix);
 	exit_browser(status);
 
+	perf_evsel_list__delete();
+
 	if (status)
 		return status & 0xff;
 
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 2d948ad..3a142e9 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -982,3 +982,14 @@ int perf_evsel_list__create_default(void)
 	++nr_counters;
 	return 0;
 }
+
+void perf_evsel_list__delete(void)
+{
+	struct perf_evsel *pos, *n;
+
+	list_for_each_entry_safe(pos, n, &evsel_list, node) {
+		list_del_init(&pos->node);
+		perf_evsel__delete(pos);
+	}
+	nr_counters = 0;
+}
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index 0f915a0..0a0abc1 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -12,6 +12,7 @@ struct perf_evsel;
 extern struct list_head evsel_list;
 
 int perf_evsel_list__create_default(void);
+void perf_evsel_list__delete(void);
 
 struct option;
 
-- 
1.6.2.5

