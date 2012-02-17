Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766Ab2BQJ6D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 04:58:03 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38794 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381Ab2BQJ6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 04:58:00 -0500
Date: Fri, 17 Feb 2012 01:57:12 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-ab772uzk78cwybihf0vt7kxw@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
        efault@gmx.de, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Invert the sample_id_all logic
Git-Commit-ID: 808e122630d45a7f036d25582474d70548a87e2c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 17 Feb 2012 01:57:38 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  808e122630d45a7f036d25582474d70548a87e2c
Gitweb:     http://git.kernel.org/tip/808e122630d45a7f036d25582474d70548a87e2c
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 14 Feb 2012 14:18:57 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 14 Feb 2012 14:18:57 -0200

perf tools: Invert the sample_id_all logic

Instead of requiring that users of perf_record_opts set
.sample_id_all_avail to true, just invert the logic, using
.sample_id_all_missing, that doesn't need to be explicitely initialized
since gcc will zero members ommitted in a struct initialization.

Just like the newly introduced .exclude_{guest,host} feature test.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-ab772uzk78cwybihf0vt7kxw@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |    7 +++----
 tools/perf/builtin-test.c   |    1 -
 tools/perf/builtin-top.c    |    7 +++----
 tools/perf/perf.h           |    2 +-
 tools/perf/util/evsel.c     |    4 ++--
 tools/perf/util/top.h       |    2 +-
 6 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index d6c10e8..75d230f 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -209,7 +209,7 @@ fallback_missing_features:
 		if (opts->exclude_guest_missing)
 			attr->exclude_guest = attr->exclude_host = 0;
 retry_sample_id:
-		attr->sample_id_all = opts->sample_id_all_avail ? 1 : 0;
+		attr->sample_id_all = opts->sample_id_all_missing ? 0 : 1;
 try_again:
 		if (perf_evsel__open(pos, evlist->cpus, evlist->threads,
 				     opts->group, group_fd) < 0) {
@@ -228,11 +228,11 @@ try_again:
 						 "guest or host samples.\n");
 					opts->exclude_guest_missing = true;
 					goto fallback_missing_features;
-				} else if (opts->sample_id_all_avail) {
+				} else if (!opts->sample_id_all_missing) {
 					/*
 					 * Old kernel, no attr->sample_id_type_all field
 					 */
-					opts->sample_id_all_avail = false;
+					opts->sample_id_all_missing = true;
 					if (!opts->sample_time && !opts->raw_samples && !time_needed)
 						attr->sample_type &= ~PERF_SAMPLE_TIME;
 
@@ -660,7 +660,6 @@ static struct perf_record record = {
 		.user_freq	     = UINT_MAX,
 		.user_interval	     = ULLONG_MAX,
 		.freq		     = 1000,
-		.sample_id_all_avail = true,
 	},
 	.write_mode = WRITE_FORCE,
 	.file_new   = true,
diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 0f15195..3e087ce 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -1013,7 +1013,6 @@ static int test__PERF_RECORD(void)
 		.no_delay   = true,
 		.freq	    = 10,
 		.mmap_pages = 256,
-		.sample_id_all_avail = true,
 	};
 	cpu_set_t *cpu_mask = NULL;
 	size_t cpu_mask_size = 0;
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 02e11ff..e3c63ae 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -876,7 +876,7 @@ fallback_missing_features:
 		if (top->exclude_guest_missing)
 			attr->exclude_guest = attr->exclude_host = 0;
 retry_sample_id:
-		attr->sample_id_all = top->sample_id_all_avail ? 1 : 0;
+		attr->sample_id_all = top->sample_id_all_missing ? 0 : 1;
 try_again:
 		if (perf_evsel__open(counter, top->evlist->cpus,
 				     top->evlist->threads, top->group,
@@ -893,11 +893,11 @@ try_again:
 						 "guest or host samples.\n");
 					top->exclude_guest_missing = true;
 					goto fallback_missing_features;
-				} else if (top->sample_id_all_avail) {
+				} else if (!top->sample_id_all_missing) {
 					/*
 					 * Old kernel, no attr->sample_id_type_all field
 					 */
-					top->sample_id_all_avail = false;
+					top->sample_id_all_missing = true;
 					goto retry_sample_id;
 				}
 			}
@@ -1122,7 +1122,6 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 		.delay_secs	     = 2,
 		.uid		     = UINT_MAX,
 		.freq		     = 1000, /* 1 KHz */
-		.sample_id_all_avail = true,
 		.mmap_pages	     = 128,
 		.sym_pcnt_filter     = 5,
 	};
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 8b9c436..f0227e9 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -198,7 +198,7 @@ struct perf_record_opts {
 	bool	     raw_samples;
 	bool	     sample_address;
 	bool	     sample_time;
-	bool	     sample_id_all_avail;
+	bool	     sample_id_all_missing;
 	bool	     exclude_guest_missing;
 	bool	     system_wide;
 	bool	     period;
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index f910f50..302d49a 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -68,7 +68,7 @@ void perf_evsel__config(struct perf_evsel *evsel, struct perf_record_opts *opts)
 	struct perf_event_attr *attr = &evsel->attr;
 	int track = !evsel->idx; /* only the first counter needs these */
 
-	attr->sample_id_all = opts->sample_id_all_avail ? 1 : 0;
+	attr->sample_id_all = opts->sample_id_all_missing ? 0 : 1;
 	attr->inherit	    = !opts->no_inherit;
 	attr->read_format   = PERF_FORMAT_TOTAL_TIME_ENABLED |
 			      PERF_FORMAT_TOTAL_TIME_RUNNING |
@@ -111,7 +111,7 @@ void perf_evsel__config(struct perf_evsel *evsel, struct perf_record_opts *opts)
 	if (opts->period)
 		attr->sample_type	|= PERF_SAMPLE_PERIOD;
 
-	if (opts->sample_id_all_avail &&
+	if (!opts->sample_id_all_missing &&
 	    (opts->sample_time || opts->system_wide ||
 	     !opts->no_inherit || opts->cpu_list))
 		attr->sample_type	|= PERF_SAMPLE_TIME;
diff --git a/tools/perf/util/top.h b/tools/perf/util/top.h
index 7dea891..ce61cb2 100644
--- a/tools/perf/util/top.h
+++ b/tools/perf/util/top.h
@@ -34,7 +34,7 @@ struct perf_top {
 	bool		   vmlinux_warned;
 	bool		   inherit;
 	bool		   group;
-	bool		   sample_id_all_avail;
+	bool		   sample_id_all_missing;
 	bool		   exclude_guest_missing;
 	bool		   dump_symtab;
 	const char	   *cpu_list;
