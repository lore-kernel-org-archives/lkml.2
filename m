Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032498Ab2CPAW3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 20:22:29 -0400
Received: from outmail019.snc4.facebook.com ([66.220.144.153]:34412 "EHLO
	intmgw004.snc4.facebook.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1032236Ab2CPAW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 20:22:27 -0400
From: Arun Sharma <asharma@fb.com>
To: linux-kernel@vger.kernel.org
Cc: Arun Sharma <asharma@fb.com>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Tom Zanussi <tzanussi@gmail.com>,
        linux-perf-users@vger.kernel.org
Subject: [PATCH] [RFC] perf: new semantics for callgraph sym filtering
Date: Thu, 15 Mar 2012 17:22:13 -0700
Message-Id: <1331857333-5234-1-git-send-email-asharma@fb.com>
X-Mailer: git-send-email 1.7.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current code takes incoming callchains, computes
histograms and filters histogram entries based on a
user specified filter.

In the presence of callchains, this may filter by
leaf function or the parent function, dependening on
the callgraph ordering params.

Sometimes users desire the ability to filter
chains that contain a symbol and then compute
the inverted callchain.

This is more of an attempt to show what is desired.
It contains an ugly hack involving a global variable
since I can't access the filter when processing input
sample events.

Sample usage:

perf record -g
perf report some-symbol -G -s pid

TODO:

* Remove the ugly hack
* Keep the chain, but mark the entry as filtered,
  so we can show filtered samples as a percentage of the
  total.

Signed-off-by: Arun Sharma <asharma@fb.com>
Cc: Ingo Molnar <mingo@elte.hu>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org
Cc: linux-perf-users@vger.kernel.org
---
 tools/perf/builtin-report.c |   11 ++++++++++-
 tools/perf/util/callchain.c |   21 +++++++++++++++++++++
 tools/perf/util/callchain.h |    1 +
 tools/perf/util/hist.c      |    3 +++
 4 files changed, 35 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 35a86b5..faf3431 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -130,6 +130,9 @@ out:
 	return err;
 }
 
+/* Hack to make the filter string available */
+const char *symbol_filter_str;
+
 static int perf_evsel__add_hist_entry(struct perf_evsel *evsel,
 				      struct addr_location *al,
 				      struct perf_sample *sample,
@@ -148,6 +151,12 @@ static int perf_evsel__add_hist_entry(struct perf_evsel *evsel,
 	}
 
 	cursor = &evsel->hists.callchain_cursor;
+
+	if (symbol_conf.use_callchain && symbol_filter_str) {
+		/* Do the filtering now, rather than later */
+		if (!callchain_has_symbol(cursor, symbol_filter_str))
+			return 0;
+	}
 	he = __hists__add_entry(&evsel->hists, al, parent,
 			        cursor, sample->period);
 	if (he == NULL)
@@ -311,7 +320,6 @@ static int perf_evlist__tty_browse_hists(struct perf_evlist *evlist,
 		struct hists *hists = &pos->hists;
 		const char *evname = event_name(pos);
 
-		hists->symbol_filter_str = rep->symbol_filter_str;
 		hists__filter_by_symbol(hists);
 		hists__fprintf_nr_sample_events(hists, evname, stdout);
 		hists__fprintf(hists, NULL, false, true, 0, 0, stdout);
@@ -721,6 +729,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 
 		report.symbol_filter_str = argv[0];
 	}
+	symbol_filter_str = report.symbol_filter_str;
 
 	sort_entry__setup_elide(&sort_comm, symbol_conf.comm_list, "comm", stdout);
 
diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index 2b824a5..a641d6a 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -474,3 +474,24 @@ int callchain_get(struct callchain_cursor *cursor,
 
 	return 0;
 }
+
+bool callchain_has_symbol(struct callchain_cursor *cursor, const char *sym)
+{
+	struct callchain_cursor iter = *cursor;
+	u64 i;
+
+	iter.pos = 0;
+	iter.curr = iter.first;
+	for (i = 0; i < cursor->nr; i++) {
+		struct addr_location al_child;
+		int err;
+
+		err = callchain_get(&iter, &al_child);
+		if (err)
+			return false;
+		if (al_child.sym && (strstr(al_child.sym->name, sym) != NULL))
+			return true;
+		callchain_cursor_advance(&iter);
+	}
+	return false;
+}
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index dcff6ec..f016847 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -109,6 +109,7 @@ bool ip_callchain__valid(struct ip_callchain *chain,
 			 const union perf_event *event);
 
 int callchain_get(struct callchain_cursor *cursor, struct addr_location *al);
+bool callchain_has_symbol(struct callchain_cursor *cursor, const char *sym);
 
 /*
  * Initialize a cursor before adding entries inside, but keep
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 43c0c09..85fec09 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -1331,6 +1331,9 @@ void hists__filter_by_thread(struct hists *hists)
 static bool hists__filter_entry_by_symbol(struct hists *hists,
 					  struct hist_entry *he)
 {
+	if (symbol_conf.use_callchain)
+		return false;
+
 	if (hists->symbol_filter_str != NULL &&
 	    (!he->ms.sym || strstr(he->ms.sym->name,
 				   hists->symbol_filter_str) == NULL)) {
-- 
1.7.8.4

