Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932269Ab1LENOE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 08:14:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57303 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756368Ab1LENOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 08:14:02 -0500
Date: Mon, 5 Dec 2011 05:13:44 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-jafcokbj26m845dsgm2hx6az@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
        efault@gmx.de, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf test: Soft errors shouldn't stop the "Validate PERF_RECORD_" test
Git-Commit-ID: f71c49e5e985897850406a152ab99001cfb86f2a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Dec 2011 05:13:49 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f71c49e5e985897850406a152ab99001cfb86f2a
Gitweb:     http://git.kernel.org/tip/f71c49e5e985897850406a152ab99001cfb86f2a
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 2 Dec 2011 13:53:04 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 2 Dec 2011 14:00:04 -0200

perf test: Soft errors shouldn't stop the "Validate PERF_RECORD_" test

For errors that don't preclude checking for further errors, aka "soft"
errors, just  continue testing for other errors.

Better coverage in verbose mode.

Suggested-by: David Ahern <dsahern@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-jafcokbj26m845dsgm2hx6az@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-test.c |   45 +++++++++++++++++++++------------------------
 1 files changed, 21 insertions(+), 24 deletions(-)

diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index f1e3611..6173f78 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -903,7 +903,7 @@ static int test__PERF_RECORD(void)
 	     found_libc_mmap = false,
 	     found_vdso_mmap = false,
 	     found_ld_mmap = false;
-	int err = -1, i, wakeups = 0, sample_size;
+	int err = -1, errs = 0, i, wakeups = 0, sample_size;
 	u32 cpu;
 	int total_events = 0, nr_events[PERF_RECORD_MAX] = { 0, };
 
@@ -1012,8 +1012,6 @@ static int test__PERF_RECORD(void)
 	 */
 	perf_evlist__start_workload(evlist);
 
-	err = -1;
-
 	while (1) {
 		int before = total_events;
 
@@ -1028,9 +1026,10 @@ static int test__PERF_RECORD(void)
 				if (type < PERF_RECORD_MAX)
 					nr_events[type]++;
 
-				if (perf_event__parse_sample(event, sample_type,
-							     sample_size, true,
-							     &sample, false) < 0) {
+				err = perf_event__parse_sample(event, sample_type,
+							       sample_size, true,
+							       &sample, false);
+				if (err < 0) {
 					if (verbose)
 						perf_event__fprintf(event, stderr);
 					pr_debug("Couldn't parse sample\n");
@@ -1045,7 +1044,7 @@ static int test__PERF_RECORD(void)
 				if (prev_time > sample.time) {
 					pr_debug("%s going backwards in time, prev=%" PRIu64 ", curr=%" PRIu64 "\n",
 						 name, prev_time, sample.time);
-					goto out_err;
+					++errs;
 				}
 
 				prev_time = sample.time;
@@ -1053,19 +1052,19 @@ static int test__PERF_RECORD(void)
 				if (sample.cpu != cpu) {
 					pr_debug("%s with unexpected cpu, expected %d, got %d\n",
 						 name, cpu, sample.cpu);
-					goto out_err;
+					++errs;
 				}
 
 				if ((pid_t)sample.pid != evlist->workload.pid) {
 					pr_debug("%s with unexpected pid, expected %d, got %d\n",
 						 name, evlist->workload.pid, sample.pid);
-					goto out_err;
+					++errs;
 				}
 
 				if ((pid_t)sample.tid != evlist->workload.pid) {
 					pr_debug("%s with unexpected tid, expected %d, got %d\n",
 						 name, evlist->workload.pid, sample.tid);
-					goto out_err;
+					++errs;
 				}
 
 				if ((type == PERF_RECORD_COMM ||
@@ -1074,21 +1073,21 @@ static int test__PERF_RECORD(void)
 				     type == PERF_RECORD_EXIT) &&
 				     (pid_t)event->comm.pid != evlist->workload.pid) {
 					pr_debug("%s with unexpected pid/tid\n", name);
-					goto out_err;
+					++errs;
 				}
 
 				if ((type == PERF_RECORD_COMM ||
 				     type == PERF_RECORD_MMAP) &&
 				     event->comm.pid != event->comm.tid) {
 					pr_debug("%s with different pid/tid!\n", name);
-					goto out_err;
+					++errs;
 				}
 
 				switch (type) {
 				case PERF_RECORD_COMM:
 					if (strcmp(event->comm.comm, cmd)) {
 						pr_debug("%s with unexpected comm!\n", name);
-						goto out_err;
+						++errs;
 					}
 					break;
 				case PERF_RECORD_EXIT:
@@ -1112,7 +1111,7 @@ static int test__PERF_RECORD(void)
 				default:
 					pr_debug("Unexpected perf_event->header.type %d!\n",
 						 type);
-					goto out_err;
+					++errs;
 				}
 			}
 		}
@@ -1128,42 +1127,40 @@ static int test__PERF_RECORD(void)
 		sleep(1);
 		if (++wakeups > 5) {
 			pr_debug("No PERF_RECORD_EXIT event!\n");
-			goto out_err;
+			break;
 		}
 	}
 
 found_exit:
 	if (nr_events[PERF_RECORD_COMM] > 1) {
 		pr_debug("Excessive number of PERF_RECORD_COMM events!\n");
-		goto out_err;
+		++errs;
 	}
 
 	if (nr_events[PERF_RECORD_COMM] == 0) {
 		pr_debug("Missing PERF_RECORD_COMM for %s!\n", cmd);
-		goto out_err;
+		++errs;
 	}
 
 	if (!found_cmd_mmap) {
 		pr_debug("PERF_RECORD_MMAP for %s missing!\n", cmd);
-		goto out_err;
+		++errs;
 	}
 
 	if (!found_libc_mmap) {
 		pr_debug("PERF_RECORD_MMAP for %s missing!\n", "libc");
-		goto out_err;
+		++errs;
 	}
 
 	if (!found_ld_mmap) {
 		pr_debug("PERF_RECORD_MMAP for %s missing!\n", "ld");
-		goto out_err;
+		++errs;
 	}
 
 	if (!found_vdso_mmap) {
 		pr_debug("PERF_RECORD_MMAP for %s missing!\n", "[vdso]");
-		goto out_err;
+		++errs;
 	}
-
-	err = 0;
 out_err:
 	perf_evlist__munmap(evlist);
 out_free_cpu_mask:
@@ -1171,7 +1168,7 @@ out_free_cpu_mask:
 out_delete_evlist:
 	perf_evlist__delete(evlist);
 out:
-	return err;
+	return (err < 0 || errs > 0) ? -1 : 0;
 }
 
 static struct test {
