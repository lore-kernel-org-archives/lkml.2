Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952Ab1ALKw3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 05:52:29 -0500
Received: from hera.kernel.org ([140.211.167.34]:54895 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045Ab1ALKw1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 05:52:27 -0500
Date: Wed, 12 Jan 2011 10:51:45 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        peterz@infradead.org, efault@gmx.de, fweisbec@gmail.com,
        tglx@linutronix.de, trenn@suse.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        efault@gmx.de, peterz@infradead.org, fweisbec@gmail.com, trenn@suse.de,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf evsel: Fix order of event list deletion
Message-ID: <tip-bd3bfe9eda94d3c050830217c1e1c338808de5b2@git.kernel.org>
Git-Commit-ID: bd3bfe9eda94d3c050830217c1e1c338808de5b2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 12 Jan 2011 10:51:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bd3bfe9eda94d3c050830217c1e1c338808de5b2
Gitweb:     http://git.kernel.org/tip/bd3bfe9eda94d3c050830217c1e1c338808de5b2
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 11 Jan 2011 12:42:00 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 11 Jan 2011 12:51:03 -0200

perf evsel: Fix order of event list deletion

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
 
