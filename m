Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063Ab1JMPIj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 11:08:39 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53102 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755896Ab1JMPIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 11:08:36 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 6/6] perf top: Remove entries from entries_collapsed on decay
Date: Thu, 13 Oct 2011 12:08:24 -0300
Message-Id: <1318518504-23299-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1318518504-23299-1-git-send-email-acme@infradead.org>
References: <1318518504-23299-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

We were removing only when using a --sort order that needs collapsing,
while we also use it in the threaded case, causing memory corruption
because we were scribbling freed hist entries, oops.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-k16fb4jsulr7x0ixv43amb6d@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c |    2 +-
 tools/perf/util/hist.c   |   14 ++++++++++++--
 tools/perf/util/hist.h   |    1 +
 3 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index de3cb1e..3acf381 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -304,7 +304,7 @@ static void print_sym_table(void)
 
 	hists__collapse_resort_threaded(&top.sym_evsel->hists);
 	hists__output_resort_threaded(&top.sym_evsel->hists);
-	hists__decay_entries(&top.sym_evsel->hists);
+	hists__decay_entries_threaded(&top.sym_evsel->hists);
 	hists__output_recalc_col_len(&top.sym_evsel->hists, winsize.ws_row - 3);
 	putchar('\n');
 	hists__fprintf(&top.sym_evsel->hists, NULL, false, false,
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 9b9d12b..a7193c5 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -108,7 +108,7 @@ static bool hists__decay_entry(struct hists *hists, struct hist_entry *he)
 	return he->period == 0;
 }
 
-void hists__decay_entries(struct hists *hists)
+static void __hists__decay_entries(struct hists *hists, bool threaded)
 {
 	struct rb_node *next = rb_first(&hists->entries);
 	struct hist_entry *n;
@@ -124,7 +124,7 @@ void hists__decay_entries(struct hists *hists)
 		if (hists__decay_entry(hists, n) && !n->used) {
 			rb_erase(&n->rb_node, &hists->entries);
 
-			if (sort__need_collapse)
+			if (sort__need_collapse || threaded)
 				rb_erase(&n->rb_node_in, &hists->entries_collapsed);
 
 			hist_entry__free(n);
@@ -133,6 +133,16 @@ void hists__decay_entries(struct hists *hists)
 	}
 }
 
+void hists__decay_entries(struct hists *hists)
+{
+	return __hists__decay_entries(hists, false);
+}
+
+void hists__decay_entries_threaded(struct hists *hists)
+{
+	return __hists__decay_entries(hists, true);
+}
+
 /*
  * histogram, sorted on item, collects periods
  */
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 7416521..bcc8ab9 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -79,6 +79,7 @@ void hists__collapse_resort(struct hists *self);
 void hists__collapse_resort_threaded(struct hists *hists);
 
 void hists__decay_entries(struct hists *hists);
+void hists__decay_entries_threaded(struct hists *hists);
 void hists__output_recalc_col_len(struct hists *hists, int max_rows);
 
 void hists__inc_nr_events(struct hists *self, u32 type);
-- 
1.6.2.5

