Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089Ab2JTOeq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 10:34:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64701 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755893Ab2JTOd6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 10:33:58 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 10/11] perf tool: Display period values for all group members
Date: Sat, 20 Oct 2012 16:33:18 +0200
Message-Id: <1350743599-4805-11-git-send-email-jolsa@redhat.com>
In-Reply-To: <1350743599-4805-1-git-send-email-jolsa@redhat.com>
References: <1350743599-4805-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When in report group mode (perf report --group) with option
--show-total-period, display period values for all group members.

Currently only the group leader period counts are shown.

Example of new output:

  $ perf report --group --show-total-period --stdio
  ...

  # Samples: 76  of event 'anon group { cycles, cache-misses }'
  # Event count (approx.): 32249096
  #
  #         Overhead                    Period  Command      Shared Object                         Symbol
  # ................  ........................  .......  .................  .............................
  #
      18.45%  11.67%       5949678         333       ls  [kernel.kallsyms]  [k] __lock_acquire
      16.49%  11.39%       5317432         325       ls  [kernel.kallsyms]  [k] native_sched_clock
       8.55%  15.42%       2757064         440       ls  [kernel.kallsyms]  [k] lock_acquire
       8.31%  12.58%       2680708         359       ls  [kernel.kallsyms]  [k] clear_page_c

  ...

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/hist.c | 46 ++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 42 insertions(+), 4 deletions(-)

diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 51934a8..50e8d85 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -273,21 +273,59 @@ static int hpp__entry_samples(struct perf_hpp *hpp, struct hist_entry *he)
 
 static int hpp__header_period(struct perf_hpp *hpp)
 {
-	const char *fmt = symbol_conf.field_sep ? "%s" : "%12s";
+	int len = 12;
+
+	if (symbol_conf.field_sep)
+		return scnprintf(hpp->buf, hpp->size, "%s", "Period");
+
+	if (symbol_conf.event_group) {
+		struct perf_evsel *evsel = hpp->ptr;
+
+		BUG_ON(!perf_evsel__is_group_leader(evsel));
+
+		len += evsel->nr_members * 12;
+	}
 
-	return scnprintf(hpp->buf, hpp->size, fmt, "Period");
+	return scnprintf(hpp->buf, hpp->size, "%*s", len, "Period");
 }
 
 static int hpp__width_period(struct perf_hpp *hpp __maybe_unused)
 {
-	return 12;
+	int len = 12;
+
+	if (symbol_conf.event_group) {
+		struct perf_evsel *evsel = hpp->ptr;
+
+		len += evsel->nr_members * 12;
+	}
+
+	return len;
 }
 
 static int hpp__entry_period(struct perf_hpp *hpp, struct hist_entry *he)
 {
 	const char *fmt = symbol_conf.field_sep ? "%" PRIu64 : "%12" PRIu64;
+	struct hists *hists = he->hists;
+	int ret;
+
+	ret = scnprintf(hpp->buf, hpp->size, fmt, he->stat.period);
+
+	if (symbol_conf.event_group) {
+		int i;
+		struct perf_evsel *evsel = hists_2_evsel(hists);
+
+		for (i = 0; i < evsel->nr_members; i++) {
+			u64 period = he->group_stats[i].period;
 
-	return scnprintf(hpp->buf, hpp->size, fmt, he->stat.period);
+			if (symbol_conf.field_sep) {
+				ret += scnprintf(hpp->buf + ret,
+						 hpp->size - ret, " ");
+			}
+			ret += scnprintf(hpp->buf + ret, hpp->size - ret,
+					 fmt, period);
+		}
+	}
+	return ret;
 }
 
 static int hpp__header_period_baseline(struct perf_hpp *hpp)
-- 
1.7.11.4

