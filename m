Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147Ab1ADIXD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 03:23:03 -0500
Received: from hera.kernel.org ([140.211.167.34]:59076 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751852Ab1ADIXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 03:23:00 -0500
Date: Tue, 4 Jan 2011 08:22:37 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        peterz@infradead.org, efault@gmx.de, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        efault@gmx.de, peterz@infradead.org, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evsel: Delete the event selectors at exit
Message-ID: <tip-70d544d0576775a2b3923a7e68cb49b0313d80c9@git.kernel.org>
Git-Commit-ID: 70d544d0576775a2b3923a7e68cb49b0313d80c9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 04 Jan 2011 08:22:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  70d544d0576775a2b3923a7e68cb49b0313d80c9
Gitweb:     http://git.kernel.org/tip/70d544d0576775a2b3923a7e68cb49b0313d80c9
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 3 Jan 2011 16:51:39 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 3 Jan 2011 16:51:39 -0200

perf evsel: Delete the event selectors at exit

Freeing all the possibly allocated resources, reducing complexity
on each tool exit path.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
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
 
