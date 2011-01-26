Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041Ab1AZHTE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 02:19:04 -0500
Received: from hera.kernel.org ([140.211.167.34]:55887 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752882Ab1AZHTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 02:19:00 -0500
Date: Wed, 26 Jan 2011 07:18:37 GMT
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
Subject: [tip:perf/core] perf test: Check counts on all cpus in test__open_syscall_event_on_all_cpus
Message-ID: <tip-d2af9687c96f3864178de1860e6d83873aeef224@git.kernel.org>
Git-Commit-ID: d2af9687c96f3864178de1860e6d83873aeef224
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 26 Jan 2011 07:18:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d2af9687c96f3864178de1860e6d83873aeef224
Gitweb:     http://git.kernel.org/tip/d2af9687c96f3864178de1860e6d83873aeef224
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 14 Jan 2011 16:24:49 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sat, 22 Jan 2011 19:56:30 -0200

perf test: Check counts on all cpus in test__open_syscall_event_on_all_cpus

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
