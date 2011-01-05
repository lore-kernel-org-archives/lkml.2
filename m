Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399Ab1AERhW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 12:37:22 -0500
Received: from hera.kernel.org ([140.211.167.34]:59762 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752032Ab1AERhS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 12:37:18 -0500
Date: Wed, 5 Jan 2011 17:36:42 GMT
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
Subject: [tip:perf/core] perf test: Clarify some error reports in the open syscall test
Message-ID: <tip-454a3bbe9b75eb8cbddffcf383fbb8e97ea78f52@git.kernel.org>
Git-Commit-ID: 454a3bbe9b75eb8cbddffcf383fbb8e97ea78f52
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 05 Jan 2011 17:36:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  454a3bbe9b75eb8cbddffcf383fbb8e97ea78f52
Gitweb:     http://git.kernel.org/tip/454a3bbe9b75eb8cbddffcf383fbb8e97ea78f52
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 4 Jan 2011 10:40:08 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 5 Jan 2011 14:52:01 -0200

perf test: Clarify some error reports in the open syscall test

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
