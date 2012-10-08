Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499Ab2JHWjY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 18:39:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:41368 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755106Ab2JHWdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 18:33:14 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 04/25] perf diff: Add -b option for perf diff to display paired entries only
Date: Mon,  8 Oct 2012 19:32:29 -0300
Message-Id: <1349735570-19339-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1349735570-19339-1-git-send-email-acme@infradead.org>
References: <1349735570-19339-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Adding -b option to perf diff command to display only entries with match
in the baseline.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1349448287-18919-2-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-diff.txt |    4 ++++
 tools/perf/builtin-diff.c              |   31 +++++++++++++++++++++++++++++--
 2 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-diff.txt b/tools/perf/Documentation/perf-diff.txt
index ab7f667..6ce9585 100644
--- a/tools/perf/Documentation/perf-diff.txt
+++ b/tools/perf/Documentation/perf-diff.txt
@@ -72,6 +72,10 @@ OPTIONS
 --symfs=<directory>::
         Look for files with symbols relative to this directory.
 
+-b::
+--baseline-only::
+        Show only items with match in baseline.
+
 SEE ALSO
 --------
 linkperf:perf-record[1]
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index a0b531c..1063c31 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -24,6 +24,7 @@ static char const *input_old = "perf.data.old",
 static char	  diff__default_sort_order[] = "dso,symbol";
 static bool  force;
 static bool show_displacement;
+static bool show_baseline_only;
 
 static int hists__add_entry(struct hists *self,
 			    struct addr_location *al, u64 period)
@@ -172,6 +173,31 @@ static void perf_evlist__resort_hists(struct perf_evlist *evlist, bool name)
 	}
 }
 
+static void hists__baseline_only(struct hists *hists)
+{
+	struct rb_node *next = rb_first(&hists->entries);
+
+	while (next != NULL) {
+		struct hist_entry *he = rb_entry(next, struct hist_entry, rb_node);
+
+		next = rb_next(&he->rb_node);
+		if (!he->pair) {
+			rb_erase(&he->rb_node, &hists->entries);
+			hist_entry__free(he);
+		}
+	}
+}
+
+static void hists__process(struct hists *old, struct hists *new)
+{
+	hists__match(old, new);
+
+	if (show_baseline_only)
+		hists__baseline_only(new);
+
+	hists__fprintf(new, true, 0, 0, stdout);
+}
+
 static int __cmd_diff(void)
 {
 	int ret, i;
@@ -213,8 +239,7 @@ static int __cmd_diff(void)
 
 		first = false;
 
-		hists__match(&evsel_old->hists, &evsel->hists);
-		hists__fprintf(&evsel->hists, true, 0, 0, stdout);
+		hists__process(&evsel_old->hists, &evsel->hists);
 	}
 
 out_delete:
@@ -235,6 +260,8 @@ static const struct option options[] = {
 		    "be more verbose (show symbol address, etc)"),
 	OPT_BOOLEAN('M', "displacement", &show_displacement,
 		    "Show position displacement relative to baseline"),
+	OPT_BOOLEAN('b', "baseline-only", &show_baseline_only,
+		    "Show only items with match in baseline"),
 	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
 		    "dump raw trace in ASCII"),
 	OPT_BOOLEAN('f', "force", &force, "don't complain, do it"),
-- 
1.7.9.2.358.g22243

