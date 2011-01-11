Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932622Ab1AKTvM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 14:51:12 -0500
Received: from casper.infradead.org ([85.118.1.10]:52650 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932646Ab1AKTu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 14:50:57 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Renninger <trenn@suse.de>, Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 1/3] perf evsel: Fix order of event list deletion
Date: Tue, 11 Jan 2011 17:50:36 -0200
Message-Id: <1294775438-14324-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1294775438-14324-1-git-send-email-acme@infradead.org>
References: <1294775438-14324-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

We need to defer calling perf_evsel_list__delete() till after atexit
registered routines, because we need to traverse the events being
recorded at that time at least on 'perf record'.

This fixes the problem reported by Thomas Renninger where cmd_record
called by cmd_timechart would not write the tracing data to the perf.data
file header because the evsel_list at atexit (control+C on 'perf timechart
record') time would be empty, being already deleted by run_builtin(),
and thus 'perf timechart' when trying to process such perf.data file would
die with:

"no trace data in the file"

Problem introduced in 70d544d.

Reported-by: Thomas Renninger <trenn@suse.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |    1 +
 tools/perf/builtin-stat.c   |    1 +
 tools/perf/builtin-top.c    |    1 +
 tools/perf/perf.c           |    2 --
 4 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 7069bd3..aa7ece3 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -480,6 +480,7 @@ static void atexit_header(void)
 			process_buildids();
 		perf_header__write(&session->header, output, true);
 		perf_session__delete(session);
+		perf_evsel_list__delete();
 		symbol__exit();
 	}
 }
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index c385a63..0ff11d9 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -743,6 +743,7 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 out_free_fd:
 	list_for_each_entry(pos, &evsel_list, node)
 		perf_evsel__free_stat_priv(pos);
+	perf_evsel_list__delete();
 out:
 	thread_map__delete(threads);
 	threads = NULL;
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 6ce4042..4b995ee 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1490,6 +1490,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 out_free_fd:
 	list_for_each_entry(pos, &evsel_list, node)
 		perf_evsel__free_mmap(pos);
+	perf_evsel_list__delete();
 
 	return status;
 }
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 5b1ecd6..595d0f4 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -286,8 +286,6 @@ static int run_builtin(struct cmd_struct *p, int argc, const char **argv)
 	status = p->fn(argc, argv, prefix);
 	exit_browser(status);
 
-	perf_evsel_list__delete();
-
 	if (status)
 		return status & 0xff;
 
-- 
1.6.2.5

