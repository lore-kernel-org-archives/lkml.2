Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631Ab1AYRWb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 12:22:31 -0500
Received: from casper.infradead.org ([85.118.1.10]:47045 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196Ab1AYRW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 12:22:29 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 13/29] perf test: Check counts on all cpus in test__open_syscall_event_on_all_cpus
Date: Tue, 25 Jan 2011 15:21:36 -0200
Message-Id: <1295976112-2796-14-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1295976112-2796-1-git-send-email-acme@infradead.org>
References: <1295976112-2796-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

We were bailing out after the first count mismatch, do it in all to see
if only some CPUs are not getting the expected number of events.

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
 tools/perf/builtin-test.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 7287158..7cc6b20 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -408,6 +408,8 @@ static int test__open_syscall_event_on_all_cpus(void)
 		goto out_close_fd;
 	}
 
+	err = 0;
+
 	for (cpu = 0; cpu < cpus->nr; ++cpu) {
 		unsigned int expected;
 
@@ -416,18 +418,18 @@ static int test__open_syscall_event_on_all_cpus(void)
 
 		if (perf_evsel__read_on_cpu(evsel, cpu, 0) < 0) {
 			pr_debug("perf_evsel__open_read_on_cpu\n");
-			goto out_close_fd;
+			err = -1;
+			break;
 		}
 
 		expected = nr_open_calls + cpu;
 		if (evsel->counts->cpu[cpu].val != expected) {
 			pr_debug("perf_evsel__read_on_cpu: expected to intercept %d calls on cpu %d, got %" PRIu64 "\n",
 				 expected, cpus->map[cpu], evsel->counts->cpu[cpu].val);
-			goto out_close_fd;
+			err = -1;
 		}
 	}
 
-	err = 0;
 out_close_fd:
 	perf_evsel__close_fd(evsel, 1, threads->nr);
 out_evsel_delete:
-- 
1.6.2.5

