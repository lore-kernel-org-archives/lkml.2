Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737Ab1JQNyd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 09:54:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:57513 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904Ab1JQNy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 09:54:28 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 1/3] perf top: Honour --hide_{user,kernel}_symbols and the 'U' hotkey
Date: Mon, 17 Oct 2011 11:54:17 -0200
Message-Id: <1318859659-1171-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1318859659-1171-1-git-send-email-acme@infradead.org>
References: <1318859659-1171-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

The new decay routine (__hists__decay_entries) wasn't being passed the
toggles, fix it.

Reported-by: Mike Galbraith <efault@gmx.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-hg6m0mi1colket982oq9hhly@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c |    8 ++++++--
 tools/perf/util/hist.c   |   17 +++++++++++------
 tools/perf/util/hist.h   |    5 +++--
 3 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index e211304..bf368f1 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -304,7 +304,9 @@ static void print_sym_table(void)
 
 	hists__collapse_resort_threaded(&top.sym_evsel->hists);
 	hists__output_resort_threaded(&top.sym_evsel->hists);
-	hists__decay_entries_threaded(&top.sym_evsel->hists);
+	hists__decay_entries_threaded(&top.sym_evsel->hists,
+				      top.hide_user_symbols,
+				      top.hide_kernel_symbols);
 	hists__output_recalc_col_len(&top.sym_evsel->hists, winsize.ws_row - 3);
 	putchar('\n');
 	hists__fprintf(&top.sym_evsel->hists, NULL, false, false,
@@ -555,7 +557,9 @@ static void perf_top__sort_new_samples(void *arg)
 
 	hists__collapse_resort_threaded(&t->sym_evsel->hists);
 	hists__output_resort_threaded(&t->sym_evsel->hists);
-	hists__decay_entries_threaded(&t->sym_evsel->hists);
+	hists__decay_entries_threaded(&t->sym_evsel->hists,
+				      top.hide_user_symbols,
+				      top.hide_kernel_symbols);
 	hists__output_recalc_col_len(&t->sym_evsel->hists, winsize.ws_row - 3);
 }
 
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index a7193c5..48da373 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -108,7 +108,8 @@ static bool hists__decay_entry(struct hists *hists, struct hist_entry *he)
 	return he->period == 0;
 }
 
-static void __hists__decay_entries(struct hists *hists, bool threaded)
+static void __hists__decay_entries(struct hists *hists, bool zap_user,
+				   bool zap_kernel, bool threaded)
 {
 	struct rb_node *next = rb_first(&hists->entries);
 	struct hist_entry *n;
@@ -121,7 +122,10 @@ static void __hists__decay_entries(struct hists *hists, bool threaded)
 		 * case some it gets new samples, we'll eventually free it when
 		 * the user stops browsing and it agains gets fully decayed.
 		 */
-		if (hists__decay_entry(hists, n) && !n->used) {
+		if (((zap_user && n->level == '.') ||
+		     (zap_kernel && n->level != '.') ||
+		     hists__decay_entry(hists, n)) &&
+		    !n->used) {
 			rb_erase(&n->rb_node, &hists->entries);
 
 			if (sort__need_collapse || threaded)
@@ -133,14 +137,15 @@ static void __hists__decay_entries(struct hists *hists, bool threaded)
 	}
 }
 
-void hists__decay_entries(struct hists *hists)
+void hists__decay_entries(struct hists *hists, bool zap_user, bool zap_kernel)
 {
-	return __hists__decay_entries(hists, false);
+	return __hists__decay_entries(hists, zap_user, zap_kernel, false);
 }
 
-void hists__decay_entries_threaded(struct hists *hists)
+void hists__decay_entries_threaded(struct hists *hists,
+				   bool zap_user, bool zap_kernel)
 {
-	return __hists__decay_entries(hists, true);
+	return __hists__decay_entries(hists, zap_user, zap_kernel, true);
 }
 
 /*
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index bcc8ab9..ea96c1c 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -78,8 +78,9 @@ void hists__output_resort_threaded(struct hists *hists);
 void hists__collapse_resort(struct hists *self);
 void hists__collapse_resort_threaded(struct hists *hists);
 
-void hists__decay_entries(struct hists *hists);
-void hists__decay_entries_threaded(struct hists *hists);
+void hists__decay_entries(struct hists *hists, bool zap_user, bool zap_kernel);
+void hists__decay_entries_threaded(struct hists *hists, bool zap_user,
+				   bool zap_kernel);
 void hists__output_recalc_col_len(struct hists *hists, int max_rows);
 
 void hists__inc_nr_events(struct hists *self, u32 type);
-- 
1.6.2.5

