Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067Ab2CCTUy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 14:20:54 -0500
Received: from casper.infradead.org ([85.118.1.10]:34539 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323Ab2CCTUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 14:20:25 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Joerg Roedel <joerg.roedel@amd.com>, Mike Galbraith <efault@gmx.de>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 3/3] perf tools: Handle kernels that don't support attr.exclude_{guest,host}
Date: Sat,  3 Mar 2012 16:20:07 -0300
Message-Id: <1330802407-22721-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1330802407-22721-1-git-send-email-acme@infradead.org>
References: <1330802407-22721-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Just fall back to resetting those fields, if set, warning the user that
that feature is not available.

If guest samples appear they will just be discarded because no struct
machine will be found and thus the event will be accounted as not
handled and dropped, see 0c09571.

Reported-by: Namhyung Kim <namhyung@gmail.com>
Tested-by: Joerg Roedel <joerg.roedel@amd.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-vuwxig36mzprl5n7nzvnxxsh@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |   29 ++++++++++++++++++++---------
 tools/perf/builtin-top.c    |   23 +++++++++++++++++------
 tools/perf/perf.h           |    1 +
 tools/perf/util/top.h       |    1 +
 4 files changed, 39 insertions(+), 15 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 39b6a40..227b6ae 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -204,6 +204,9 @@ static void perf_record__open(struct perf_record *rec)
 
 		if (opts->group && pos != first)
 			group_fd = first->fd;
+fallback_missing_features:
+		if (opts->exclude_guest_missing)
+			attr->exclude_guest = attr->exclude_host = 0;
 retry_sample_id:
 		attr->sample_id_all = opts->sample_id_all_avail ? 1 : 0;
 try_again:
@@ -217,15 +220,23 @@ try_again:
 			} else if (err ==  ENODEV && opts->cpu_list) {
 				die("No such device - did you specify"
 					" an out-of-range profile CPU?\n");
-			} else if (err == EINVAL && opts->sample_id_all_avail) {
-				/*
-				 * Old kernel, no attr->sample_id_type_all field
-				 */
-				opts->sample_id_all_avail = false;
-				if (!opts->sample_time && !opts->raw_samples && !time_needed)
-					attr->sample_type &= ~PERF_SAMPLE_TIME;
-
-				goto retry_sample_id;
+			} else if (err == EINVAL) {
+				if (!opts->exclude_guest_missing &&
+				    (attr->exclude_guest || attr->exclude_host)) {
+					pr_debug("Old kernel, cannot exclude "
+						 "guest or host samples.\n");
+					opts->exclude_guest_missing = true;
+					goto fallback_missing_features;
+				} else if (opts->sample_id_all_avail) {
+					/*
+					 * Old kernel, no attr->sample_id_type_all field
+					 */
+					opts->sample_id_all_avail = false;
+					if (!opts->sample_time && !opts->raw_samples && !time_needed)
+						attr->sample_type &= ~PERF_SAMPLE_TIME;
+
+					goto retry_sample_id;
+				}
 			}
 
 			/*
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index dd162aa..ecff312 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -857,6 +857,9 @@ static void perf_top__start_counters(struct perf_top *top)
 		attr->mmap = 1;
 		attr->comm = 1;
 		attr->inherit = top->inherit;
+fallback_missing_features:
+		if (top->exclude_guest_missing)
+			attr->exclude_guest = attr->exclude_host = 0;
 retry_sample_id:
 		attr->sample_id_all = top->sample_id_all_avail ? 1 : 0;
 try_again:
@@ -868,12 +871,20 @@ try_again:
 			if (err == EPERM || err == EACCES) {
 				ui__error_paranoid();
 				goto out_err;
-			} else if (err == EINVAL && top->sample_id_all_avail) {
-				/*
-				 * Old kernel, no attr->sample_id_type_all field
-				 */
-				top->sample_id_all_avail = false;
-				goto retry_sample_id;
+			} else if (err == EINVAL) {
+				if (!top->exclude_guest_missing &&
+				    (attr->exclude_guest || attr->exclude_host)) {
+					pr_debug("Old kernel, cannot exclude "
+						 "guest or host samples.\n");
+					top->exclude_guest_missing = true;
+					goto fallback_missing_features;
+				} else if (top->sample_id_all_avail) {
+					/*
+					 * Old kernel, no attr->sample_id_type_all field
+					 */
+					top->sample_id_all_avail = false;
+					goto retry_sample_id;
+				}
 			}
 			/*
 			 * If it's cycles then fall back to hrtimer
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 64f8bee..16e7d20 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -199,6 +199,7 @@ struct perf_record_opts {
 	bool	     sample_address;
 	bool	     sample_time;
 	bool	     sample_id_all_avail;
+	bool	     exclude_guest_missing;
 	bool	     system_wide;
 	bool	     period;
 	unsigned int freq;
diff --git a/tools/perf/util/top.h b/tools/perf/util/top.h
index a248f3c..f2eab81 100644
--- a/tools/perf/util/top.h
+++ b/tools/perf/util/top.h
@@ -34,6 +34,7 @@ struct perf_top {
 	bool		   inherit;
 	bool		   group;
 	bool		   sample_id_all_avail;
+	bool		   exclude_guest_missing;
 	bool		   dump_symtab;
 	const char	   *cpu_list;
 	struct hist_entry  *sym_filter_entry;
-- 
1.7.9.2.358.g22243

