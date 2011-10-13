Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051Ab1JMPIh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 11:08:37 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53101 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755895Ab1JMPIg (ORCPT
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
Subject: [PATCH 1/6] perf hists browser: Recalculate browser pointers after resort/decay
Date: Thu, 13 Oct 2011 12:08:19 -0300
Message-Id: <1318518504-23299-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1318518504-23299-1-git-send-email-acme@infradead.org>
References: <1318518504-23299-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

In browsers that access dynamic underlying data structures, like in the
hists browser and its hist_entry rb_tree, we need to revalidate any
reference to the underlying data structure, because they can have gone
away, decayed.

This fixes a problem where after a while the top entries get behind the
top of the screen, i.e. the top_idx stays at 0, which means it is at the
first entry in the rb_tree when in fact it wasn't because the
browser->top didn't got revalidated after the timer ran and the
underlying data structure got updated.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-mhje66qssdko24q67a2lhlho@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/ui/browser.c        |   23 +++++++++++++++++++++++
 tools/perf/util/ui/browser.h        |    1 +
 tools/perf/util/ui/browsers/hists.c |    9 ++-------
 3 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/ui/browser.c b/tools/perf/util/ui/browser.c
index 611219f..5911bba 100644
--- a/tools/perf/util/ui/browser.c
+++ b/tools/perf/util/ui/browser.c
@@ -230,6 +230,29 @@ int ui_browser__refresh(struct ui_browser *self)
 	return 0;
 }
 
+/*
+ * Here we're updating nr_entries _after_ we started browsing, i.e.  we have to
+ * forget about any reference to any entry in the underlying data structure,
+ * that is why we do a SEEK_SET. Think about 'perf top' in the hists browser
+ * after an output_resort and hist decay.
+ */
+void ui_browser__update_nr_entries(struct ui_browser *browser, u32 nr_entries)
+{
+	off_t offset = nr_entries - browser->nr_entries;
+
+	browser->nr_entries = nr_entries;
+
+	if (offset < 0) {
+		if (browser->top_idx < (u64)-offset)
+			offset = -browser->top_idx;
+
+		browser->index += offset;
+		browser->top_idx += offset;
+	}
+
+	browser->seek(browser, browser->top_idx, SEEK_SET);
+}
+
 int ui_browser__run(struct ui_browser *self)
 {
 	struct newtExitStruct es;
diff --git a/tools/perf/util/ui/browser.h b/tools/perf/util/ui/browser.h
index fc63dda..d42be43 100644
--- a/tools/perf/util/ui/browser.h
+++ b/tools/perf/util/ui/browser.h
@@ -41,6 +41,7 @@ int ui_browser__show(struct ui_browser *self, const char *title,
 void ui_browser__hide(struct ui_browser *self);
 int ui_browser__refresh(struct ui_browser *self);
 int ui_browser__run(struct ui_browser *self);
+void ui_browser__update_nr_entries(struct ui_browser *browser, u32 nr_entries);
 
 void ui_browser__rb_tree_seek(struct ui_browser *self, off_t offset, int whence);
 unsigned int ui_browser__rb_tree_refresh(struct ui_browser *self);
diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index e64d952..9ece843 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -332,13 +332,7 @@ static int hist_browser__run(struct hist_browser *self, const char *ev_name,
 		case -1:
 			/* FIXME we need to check if it was es.reason == NEWT_EXIT_TIMER */
 			timer(arg);
-			/*
-			 * The timer may have changed the number of entries.
-			 * XXX: Find better way to keep this in synch, probably
-			 * removing this timer function altogether and just sync
-			 * using the hists->lock...
-			 */
-			self->b.nr_entries = self->hists->nr_entries;
+			ui_browser__update_nr_entries(&self->b, self->hists->nr_entries);
 			hists__browser_title(self->hists, title, sizeof(title),
 					     ev_name, self->dso_filter,
 					     self->thread_filter);
@@ -985,6 +979,7 @@ do_annotate:
 
 			hist_entry__tui_annotate(he, evsel->idx, nr_events,
 						 timer, arg, delay_secs);
+			ui_browser__update_nr_entries(&browser->b, browser->hists->nr_entries);
 		} else if (choice == browse_map)
 			map__browse(browser->selection->map);
 		else if (choice == zoom_dso) {
-- 
1.6.2.5

