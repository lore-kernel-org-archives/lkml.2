Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932767Ab2J2Qcf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 12:32:35 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:38683 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759737Ab2J2Qcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 12:32:31 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, peterz@infradead.org, fweisbec@gmail.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 4/9] perf top: use the new perf_evlist__open_counters method
Date: Mon, 29 Oct 2012 10:31:44 -0600
Message-Id: <1351528309-87705-5-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1351528309-87705-1-git-send-email-dsahern@gmail.com>
References: <1351528309-87705-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove open counters code with all the retry and error handling in
favor of the new perf_evlist__open_counters method which is based
on the top code.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 tools/perf/builtin-top.c |   74 ++--------------------------------------------
 1 file changed, 3 insertions(+), 71 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index a6954ba8..2ffc32e 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -919,79 +919,11 @@ static void perf_top__start_counters(struct perf_top *top)
 		attr->mmap = 1;
 		attr->comm = 1;
 		attr->inherit = !top->opts.no_inherit;
-fallback_missing_features:
-		if (top->opts.exclude_guest_missing)
-			attr->exclude_guest = attr->exclude_host = 0;
-retry_sample_id:
-		attr->sample_id_all = top->opts.sample_id_all_missing ? 0 : 1;
-try_again:
-		if (perf_evsel__open(counter, top->evlist->cpus,
-				     top->evlist->threads) < 0) {
-			int err = errno;
-
-			if (err == EPERM || err == EACCES) {
-				ui__error_paranoid();
-				goto out_err;
-			} else if (err == EINVAL) {
-				if (!top->opts.exclude_guest_missing &&
-				    (attr->exclude_guest || attr->exclude_host)) {
-					pr_debug("Old kernel, cannot exclude "
-						 "guest or host samples.\n");
-					top->opts.exclude_guest_missing = true;
-					goto fallback_missing_features;
-				} else if (!top->opts.sample_id_all_missing) {
-					/*
-					 * Old kernel, no attr->sample_id_type_all field
-					 */
-					top->opts.sample_id_all_missing = true;
-					goto retry_sample_id;
-				}
-			}
-			/*
-			 * If it's cycles then fall back to hrtimer
-			 * based cpu-clock-tick sw counter, which
-			 * is always available even if no PMU support:
-			 */
-			if ((err == ENOENT || err == ENXIO) &&
-			    (attr->type == PERF_TYPE_HARDWARE) &&
-			    (attr->config == PERF_COUNT_HW_CPU_CYCLES)) {
-
-				if (verbose)
-					ui__warning("Cycles event not supported,\n"
-						    "trying to fall back to cpu-clock-ticks\n");
-
-				attr->type = PERF_TYPE_SOFTWARE;
-				attr->config = PERF_COUNT_SW_CPU_CLOCK;
-				if (counter->name) {
-					free(counter->name);
-					counter->name = NULL;
-				}
-				goto try_again;
-			}
-
-			if (err == ENOENT) {
-				ui__error("The %s event is not supported.\n",
-					  perf_evsel__name(counter));
-				goto out_err;
-			} else if (err == EMFILE) {
-				ui__error("Too many events are opened.\n"
-					    "Try again after reducing the number of events\n");
-				goto out_err;
-			} else if ((err == EOPNOTSUPP) && (attr->precise_ip)) {
-				ui__error("\'precise\' request may not be supported. "
-					  "Try removing 'p' modifier\n");
-				goto out_err;
-			}
-
-			ui__error("The sys_perf_event_open() syscall "
-				    "returned with %d (%s).  /bin/dmesg "
-				    "may provide additional information.\n"
-				    "No CONFIG_PERF_EVENTS=y kernel support "
-				    "configured?\n", err, strerror(err));
-			goto out_err;
-		}
 	}
 
+	if (perf_evlist__open_counters(evlist, &top->opts) != 0)
+		goto out_err;
+
 	if (perf_evlist__mmap(evlist, top->opts.mmap_pages, false) < 0) {
 		ui__error("Failed to mmap with %d (%s)\n",
 			    errno, strerror(errno));
-- 
1.7.10.1

