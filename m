Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911Ab1LBTHE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 14:07:04 -0500
Received: from merlin.infradead.org ([205.233.59.134]:57166 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab1LBTHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 14:07:01 -0500
Date: Fri, 2 Dec 2011 17:06:52 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 4/4] perf test: Validate PERF_RECORD_ events and
 perf_sample fields
Message-ID: <20111202190652.GB4544@infradead.org>
References: <1322842769-7232-1-git-send-email-acme@infradead.org>
 <1322842769-7232-5-git-send-email-acme@infradead.org>
 <4ED905DF.2000501@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ED905DF.2000501@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Dec 02, 2011 at 10:07:43AM -0700, David Ahern escreveu:
> 
> 
> On 12/02/2011 09:19 AM, Arnaldo Carvalho de Melo wrote:
> > +found_exit:
> > +	if (!found_vdso_mmap) {
> > +		pr_debug("PERF_RECORD_MMAP for %s missing!\n", "[vdso]");
> > +		goto out_err;
> > +	}
> 
> 
> Since this is a test why not show all missed events rather than punt to
> out_err on the first missed one?

Right! And it was so, pushed this one there.

- Arnaldo

>From f71c49e5e985897850406a152ab99001cfb86f2a Mon Sep 17 00:00:00 2001
From: Arnaldo Carvalho de Melo <acme@redhat.com>
Date: Fri, 2 Dec 2011 13:53:04 -0200
Subject: [PATCH 1/1] perf test: Soft errors shouldn't stop the "Validate
 PERF_RECORD_" test

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
-- 
1.7.8.rc0.35.gee6df

