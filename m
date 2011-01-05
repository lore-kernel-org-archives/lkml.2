Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751682Ab1AERE1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 12:04:27 -0500
Received: from canuck.infradead.org ([134.117.69.58]:59249 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603Ab1AERE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 12:04:26 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 1/5] perf test: Clarify some error reports in the open syscall test
Date: Wed,  5 Jan 2011 15:04:02 -0200
Message-Id: <1294247046-32352-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1294247046-32352-1-git-send-email-acme@infradead.org>
References: <1294247046-32352-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Rebooted my devel machine, first thing I ran was perf test, that expects
debugfs to be mounted, test fails. Be more clear about it.

Also add missing newlines and add more informative message when
sys_perf_event_open fails.

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
 tools/perf/builtin-test.c |   18 +++++++++++-------
 1 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 6c99152..1c98434 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -268,24 +268,26 @@ static int test__open_syscall_event(void)
 	int id = trace_event__id("sys_enter_open");
 
 	if (id < 0) {
-		pr_debug("trace_event__id(\"sys_enter_open\") ");
+		pr_debug("is debugfs mounted on /sys/kernel/debug?\n");
 		return -1;
 	}
 
 	threads = thread_map__new(-1, getpid());
 	if (threads == NULL) {
-		pr_debug("thread_map__new ");
+		pr_debug("thread_map__new\n");
 		return -1;
 	}
 
 	evsel = perf_evsel__new(PERF_TYPE_TRACEPOINT, id, 0);
 	if (evsel == NULL) {
-		pr_debug("perf_evsel__new ");
+		pr_debug("perf_evsel__new\n");
 		goto out_thread_map_delete;
 	}
 
 	if (perf_evsel__open_per_thread(evsel, threads) < 0) {
-		pr_debug("perf_evsel__open_per_thread ");
+		pr_debug("failed to open counter: %s, "
+			 "tweak /proc/sys/kernel/perf_event_paranoid?\n",
+			 strerror(errno));
 		goto out_evsel_delete;
 	}
 
@@ -295,13 +297,15 @@ static int test__open_syscall_event(void)
 	}
 
 	if (perf_evsel__read_on_cpu(evsel, 0, 0) < 0) {
-		pr_debug("perf_evsel__open_read_on_cpu ");
+		pr_debug("perf_evsel__open_read_on_cpu\n");
 		goto out_close_fd;
 	}
 
-	if (evsel->counts->cpu[0].val != nr_open_calls)
-		pr_debug("perf_evsel__read_on_cpu: expected to intercept %d calls, got %Ld ",
+	if (evsel->counts->cpu[0].val != nr_open_calls) {
+		pr_debug("perf_evsel__read_on_cpu: expected to intercept %d calls, got %Ld\n",
 			 nr_open_calls, evsel->counts->cpu[0].val);
+		goto out_close_fd;
+	}
 	
 	err = 0;
 out_close_fd:
-- 
1.6.2.5

