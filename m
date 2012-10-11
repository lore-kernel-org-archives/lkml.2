Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435Ab2JKE1a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 00:27:30 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:36790 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035Ab2JKEZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 00:25:49 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, peterz@infradead.org, fweisbec@gmail.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 3/9] perf evlist: introduce open counters method
Date: Wed, 10 Oct 2012 22:25:29 -0600
Message-Id: <1349929535-92861-4-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1349929535-92861-1-git-send-email-dsahern@gmail.com>
References: <1349929535-92861-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Superset of the open counters code in perf-top and perf-record -
combining retry handling and error handling. Should be functionally
equivalent.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 tools/perf/util/evlist.c |  127 +++++++++++++++++++++++++++++++++++++++++++++-
 tools/perf/util/evlist.h |    3 ++
 2 files changed, 129 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index a41dc4a..bce2f58 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -15,7 +15,7 @@
 #include "evlist.h"
 #include "evsel.h"
 #include <unistd.h>
-
+#include "debug.h"
 #include "parse-events.h"
 
 #include <sys/mman.h>
@@ -838,3 +838,128 @@ size_t perf_evlist__fprintf(struct perf_evlist *evlist, FILE *fp)
 
 	return printed + fprintf(fp, "\n");;
 }
+
+int perf_evlist__open_counters(struct perf_evlist *evlist,
+			       struct perf_record_opts *opts)
+{
+	struct perf_evsel *pos;
+	int rc = 0;
+
+	list_for_each_entry(pos, &evlist->entries, node) {
+		struct perf_event_attr *attr = &pos->attr;
+
+		/*
+		 * Carried over from perf-record:
+		 * Check if parse_single_tracepoint_event has already asked for
+		 * PERF_SAMPLE_TIME.
+		 *
+		 * XXX this is kludgy but short term fix for problems introduced by
+		 * eac23d1c that broke 'perf script' by having different sample_types
+		 * when using multiple tracepoint events when we use a perf binary
+		 * that tries to use sample_id_all on an older kernel.
+		 *
+		 * We need to move counter creation to perf_session, support
+		 * different sample_types, etc.
+		 */
+		bool time_needed = attr->sample_type & PERF_SAMPLE_TIME;
+
+fallback_missing_features:
+		if (opts->exclude_guest_missing)
+			attr->exclude_guest = attr->exclude_host = 0;
+retry_sample_id:
+		attr->sample_id_all = opts->sample_id_all_missing ? 0 : 1;
+try_again:
+		if (perf_evsel__open(pos, evlist->cpus, evlist->threads) < 0) {
+			int err = errno;
+
+			if (err == EPERM || err == EACCES) {
+				ui__error_paranoid();
+				rc = -err;
+				goto out;
+			} else if (err ==  ENODEV && opts->target.cpu_list) {
+				pr_err("No such device - did you specify"
+				       " an out-of-range profile CPU?\n");
+				rc = -err;
+				goto out;
+			} else if (err == EINVAL) {
+				if (!opts->exclude_guest_missing &&
+				    (attr->exclude_guest || attr->exclude_host)) {
+					pr_debug("Old kernel, cannot exclude "
+						 "guest or host samples.\n");
+					opts->exclude_guest_missing = true;
+					goto fallback_missing_features;
+				} else if (!opts->sample_id_all_missing) {
+					/*
+					 * Old kernel, no attr->sample_id_type_all field
+					 */
+					opts->sample_id_all_missing = true;
+					if (!opts->sample_time &&
+					    !opts->raw_samples &&
+					    !time_needed)
+						attr->sample_type &= ~PERF_SAMPLE_TIME;
+					goto retry_sample_id;
+				}
+			}
+
+			/*
+			 * If it's cycles then fall back to hrtimer
+			 * based cpu-clock-tick sw counter, which
+			 * is always available even if no PMU support:
+			 *
+			 * PPC returns ENXIO until 2.6.37 (behavior changed
+			 * with commit b0a873e).
+			 */
+			if ((err == ENOENT || err == ENXIO) &&
+			    (attr->type == PERF_TYPE_HARDWARE) &&
+			    (attr->config == PERF_COUNT_HW_CPU_CYCLES)) {
+
+				if (verbose)
+					ui__warning("Cycles event not supported,\n"
+						    "trying to fall back to cpu-clock-ticks\n");
+
+				attr->type = PERF_TYPE_SOFTWARE;
+				attr->config = PERF_COUNT_SW_CPU_CLOCK;
+				if (pos->name) {
+					free(pos->name);
+					pos->name = NULL;
+				}
+				goto try_again;
+			}
+
+			if (err == ENOENT) {
+				ui__error("The %s event is not supported.\n",
+					  perf_evsel__name(pos));
+				rc = -err;
+				goto out;
+			} else if (err == EMFILE) {
+				ui__error("Too many events are opened.\n"
+					  "Try again after reducing the number of events\n");
+				rc = -err;
+				goto out;
+			}
+
+			ui__error("sys_perf_event_open() syscall returned with "
+				  "%d (%s) for event %s.  /bin/dmesg may provide"
+				  "additional information.\n",
+				  err, strerror(err), perf_evsel__name(pos));
+
+#if defined(__i386__) || defined(__x86_64__)
+			if ((attr->type == PERF_TYPE_HARDWARE) &&
+			    (err == EOPNOTSUPP)) {
+				pr_err("No hardware sampling interrupt available."
+				       " No APIC? If so then you can boot the kernel"
+				       " with the \"lapic\" boot parameter to"
+				       " force-enable it.\n");
+				rc = -err;
+				goto out;
+			}
+#endif
+
+			pr_err("No CONFIG_PERF_EVENTS=y kernel support configured?\n");
+			rc = -err;
+			goto out;
+		}
+	}
+out:
+	return rc;
+}
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 56003f7..270e546 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -135,4 +135,7 @@ static inline struct perf_evsel *perf_evlist__last(struct perf_evlist *evlist)
 }
 
 size_t perf_evlist__fprintf(struct perf_evlist *evlist, FILE *fp);
+
+int perf_evlist__open_counters(struct perf_evlist *evlist,
+			       struct perf_record_opts *opts);
 #endif /* __PERF_EVLIST_H */
-- 
1.7.10.1

