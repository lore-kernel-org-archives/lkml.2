Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114Ab1JMPJd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 11:09:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:43432 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262Ab1JMPIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 11:08:35 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 2/6] perf hists: Don't free decayed entries if in the annotation browser
Date: Thu, 13 Oct 2011 12:08:20 -0300
Message-Id: <1318518504-23299-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1318518504-23299-1-git-send-email-acme@infradead.org>
References: <1318518504-23299-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Just let it there till the user exits the annotation browser.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-nmaxuzreqhm5k10t2co5sk9a@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/hist.c              |   10 ++++++++--
 tools/perf/util/sort.h              |    1 +
 tools/perf/util/ui/browsers/hists.c |    6 +++++-
 3 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 50c8fec..9b9d12b 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -100,6 +100,8 @@ static void hist_entry__decay(struct hist_entry *he)
 
 static bool hists__decay_entry(struct hists *hists, struct hist_entry *he)
 {
+	if (he->period == 0)
+		return true;
 	hists->stats.total_period -= he->period;
 	hist_entry__decay(he);
 	hists->stats.total_period += he->period;
@@ -114,8 +116,12 @@ void hists__decay_entries(struct hists *hists)
 	while (next) {
 		n = rb_entry(next, struct hist_entry, rb_node);
 		next = rb_next(&n->rb_node);
-
-		if (hists__decay_entry(hists, n)) {
+		/*
+		 * We may be annotating this, for instance, so keep it here in
+		 * case some it gets new samples, we'll eventually free it when
+		 * the user stops browsing and it agains gets fully decayed.
+		 */
+		if (hists__decay_entry(hists, n) && !n->used) {
 			rb_erase(&n->rb_node, &hists->entries);
 
 			if (sort__need_collapse)
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 03851e3..3f67ae3 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -64,6 +64,7 @@ struct hist_entry {
 
 	bool			init_have_children;
 	char			level;
+	bool			used;
 	u8			filtered;
 	struct symbol		*parent;
 	union {
diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index 9ece843..fdc3c90 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -976,9 +976,13 @@ do_annotate:
 			he = hist_browser__selected_entry(browser);
 			if (he == NULL)
 				continue;
-
+			/*
+			 * Don't let this be freed, say, by hists__decay_entry.
+			 */
+			he->used = true;
 			hist_entry__tui_annotate(he, evsel->idx, nr_events,
 						 timer, arg, delay_secs);
+			he->used = false;
 			ui_browser__update_nr_entries(&browser->b, browser->hists->nr_entries);
 		} else if (choice == browse_map)
 			map__browse(browser->selection->map);
-- 
1.6.2.5

