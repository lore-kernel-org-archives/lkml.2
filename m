Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932796Ab2J2Qco (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 12:32:44 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:38683 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932770Ab2J2Qcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 12:32:41 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, peterz@infradead.org, fweisbec@gmail.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 5/9] perf record: use the new perf_evlist__open_counters method
Date: Mon, 29 Oct 2012 10:31:45 -0600
Message-Id: <1351528309-87705-6-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1351528309-87705-1-git-send-email-dsahern@gmail.com>
References: <1351528309-87705-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove open counters code with all the retry and error handling in
favor of the new perf_evlist__open_counters method which is based
on the existing code.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 tools/perf/builtin-record.c |  116 ++-----------------------------------------
 1 file changed, 3 insertions(+), 113 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 5783c32..de92d7b 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -224,7 +224,6 @@ static bool perf_evlist__equal(struct perf_evlist *evlist,
 
 static int perf_record__open(struct perf_record *rec)
 {
-	struct perf_evsel *pos;
 	struct perf_evlist *evlist = rec->evlist;
 	struct perf_session *session = rec->session;
 	struct perf_record_opts *opts = &rec->opts;
@@ -235,118 +234,9 @@ static int perf_record__open(struct perf_record *rec)
 	if (opts->group)
 		perf_evlist__set_leader(evlist);
 
-	list_for_each_entry(pos, &evlist->entries, node) {
-		struct perf_event_attr *attr = &pos->attr;
-		/*
-		 * Check if parse_single_tracepoint_event has already asked for
-		 * PERF_SAMPLE_TIME.
-		 *
-		 * XXX this is kludgy but short term fix for problems introduced by
-		 * eac23d1c that broke 'perf script' by having different sample_types
-		 * when using multiple tracepoint events when we use a perf binary
-		 * that tries to use sample_id_all on an older kernel.
-		 *
-		 * We need to move counter creation to perf_session, support
-		 * different sample_types, etc.
-		 */
-		bool time_needed = attr->sample_type & PERF_SAMPLE_TIME;
-
-fallback_missing_features:
-		if (opts->exclude_guest_missing)
-			attr->exclude_guest = attr->exclude_host = 0;
-retry_sample_id:
-		attr->sample_id_all = opts->sample_id_all_missing ? 0 : 1;
-try_again:
-		if (perf_evsel__open(pos, evlist->cpus, evlist->threads) < 0) {
-			int err = errno;
-
-			if (err == EPERM || err == EACCES) {
-				ui__error_paranoid();
-				rc = -err;
-				goto out;
-			} else if (err ==  ENODEV && opts->target.cpu_list) {
-				pr_err("No such device - did you specify"
-				       " an out-of-range profile CPU?\n");
-				rc = -err;
-				goto out;
-			} else if (err == EINVAL) {
-				if (!opts->exclude_guest_missing &&
-				    (attr->exclude_guest || attr->exclude_host)) {
-					pr_debug("Old kernel, cannot exclude "
-						 "guest or host samples.\n");
-					opts->exclude_guest_missing = true;
-					goto fallback_missing_features;
-				} else if (!opts->sample_id_all_missing) {
-					/*
-					 * Old kernel, no attr->sample_id_type_all field
-					 */
-					opts->sample_id_all_missing = true;
-					if (!opts->sample_time && !opts->raw_samples && !time_needed)
-						attr->sample_type &= ~PERF_SAMPLE_TIME;
-
-					goto retry_sample_id;
-				}
-			}
-
-			/*
-			 * If it's cycles then fall back to hrtimer
-			 * based cpu-clock-tick sw counter, which
-			 * is always available even if no PMU support.
-			 *
-			 * PPC returns ENXIO until 2.6.37 (behavior changed
-			 * with commit b0a873e).
-			 */
-			if ((err == ENOENT || err == ENXIO)
-					&& attr->type == PERF_TYPE_HARDWARE
-					&& attr->config == PERF_COUNT_HW_CPU_CYCLES) {
-
-				if (verbose)
-					ui__warning("The cycles event is not supported, "
-						    "trying to fall back to cpu-clock-ticks\n");
-				attr->type = PERF_TYPE_SOFTWARE;
-				attr->config = PERF_COUNT_SW_CPU_CLOCK;
-				if (pos->name) {
-					free(pos->name);
-					pos->name = NULL;
-				}
-				goto try_again;
-			}
-
-			if (err == ENOENT) {
-				ui__error("The %s event is not supported.\n",
-					  perf_evsel__name(pos));
-				rc = -err;
-				goto out;
-			} else if ((err == EOPNOTSUPP) && (attr->precise_ip)) {
-				ui__error("\'precise\' request may not be supported. "
-					  "Try removing 'p' modifier\n");
-				rc = -err;
-				goto out;
-			}
-
-			printf("\n");
-			error("sys_perf_event_open() syscall returned with %d "
-			      "(%s) for event %s. /bin/dmesg may provide "
-			      "additional information.\n",
-			      err, strerror(err), perf_evsel__name(pos));
-
-#if defined(__i386__) || defined(__x86_64__)
-			if (attr->type == PERF_TYPE_HARDWARE &&
-			    err == EOPNOTSUPP) {
-				pr_err("No hardware sampling interrupt available."
-				       " No APIC? If so then you can boot the kernel"
-				       " with the \"lapic\" boot parameter to"
-				       " force-enable it.\n");
-				rc = -err;
-				goto out;
-			}
-#endif
-
-			pr_err("No CONFIG_PERF_EVENTS=y kernel support configured?\n");
-			rc = -err;
-			goto out;
-		}
-	}
+	rc = perf_evlist__open_counters(evlist, opts);
+	if (rc != 0)
+		goto out;
 
 	if (perf_evlist__apply_filters(evlist)) {
 		error("failed to set filter with %d (%s)\n", errno,
-- 
1.7.10.1

