Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754Ab2BQJ53 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 04:57:29 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38784 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384Ab2BQJ51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 04:57:27 -0500
Date: Fri, 17 Feb 2012 01:56:24 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-vuwxig36mzprl5n7nzvnxxsh@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, joerg.roedel@amd.com,
        peterz@infradead.org, efault@gmx.de, namhyung@gmail.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, joerg.roedel@amd.com,
        efault@gmx.de, peterz@infradead.org, namhyung@gmail.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Handle kernels that don't support attr
 .exclude_{guest,host}
Git-Commit-ID: 0c9781280fb672ca09c997df3f14ba506bbdb977
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 17 Feb 2012 01:56:59 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0c9781280fb672ca09c997df3f14ba506bbdb977
Gitweb:     http://git.kernel.org/tip/0c9781280fb672ca09c997df3f14ba506bbdb977
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 14 Feb 2012 14:05:30 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 14 Feb 2012 14:05:30 -0200

perf tools: Handle kernels that don't support attr.exclude_{guest,host}

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
index 08ed24b..d6c10e8 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -205,6 +205,9 @@ static void perf_record__open(struct perf_record *rec)
 
 		if (opts->group && pos != first)
 			group_fd = first->fd;
+fallback_missing_features:
+		if (opts->exclude_guest_missing)
+			attr->exclude_guest = attr->exclude_host = 0;
 retry_sample_id:
 		attr->sample_id_all = opts->sample_id_all_avail ? 1 : 0;
 try_again:
@@ -218,15 +221,23 @@ try_again:
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
index 5a88c0d..02e11ff 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -872,6 +872,9 @@ static void perf_top__start_counters(struct perf_top *top)
 		attr->mmap = 1;
 		attr->comm = 1;
 		attr->inherit = top->inherit;
+fallback_missing_features:
+		if (top->exclude_guest_missing)
+			attr->exclude_guest = attr->exclude_host = 0;
 retry_sample_id:
 		attr->sample_id_all = top->sample_id_all_avail ? 1 : 0;
 try_again:
@@ -883,12 +886,20 @@ try_again:
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
index 03a0456..8b9c436 100644
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
index 49eb848..7dea891 100644
--- a/tools/perf/util/top.h
+++ b/tools/perf/util/top.h
@@ -35,6 +35,7 @@ struct perf_top {
 	bool		   inherit;
 	bool		   group;
 	bool		   sample_id_all_avail;
+	bool		   exclude_guest_missing;
 	bool		   dump_symtab;
 	const char	   *cpu_list;
 	struct hist_entry  *sym_filter_entry;
