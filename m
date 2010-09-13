Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551Ab0IMRwP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 13:52:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:37634 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754497Ab0IMRwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 13:52:13 -0400
Date: Mon, 13 Sep 2010 17:51:44 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        peterz@infradead.org, efault@gmx.de, hch@infradead.org,
        fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        efault@gmx.de, peterz@infradead.org, hch@infradead.org,
        fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100822082003.GB7365@infradead.org>
References: <20100822082003.GB7365@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf ui browser: Don't use windows, slang is enough
Message-ID: <tip-469917ce8717b9f8c5298bf279fa138859baab8d@git.kernel.org>
Git-Commit-ID: 469917ce8717b9f8c5298bf279fa138859baab8d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 13 Sep 2010 17:51:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  469917ce8717b9f8c5298bf279fa138859baab8d
Gitweb:     http://git.kernel.org/tip/469917ce8717b9f8c5298bf279fa138859baab8d
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 13 Sep 2010 10:25:04 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 13 Sep 2010 10:25:04 -0300

perf ui browser: Don't use windows, slang is enough

They are useless and take away precious columns and lines, so stop using
windows.

One more step in removing newt code, that after all is not being useful
at all for the coalescing TUI model in perf.

Suggested-by: Christoph Hellwig <hch@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <20100822082003.GB7365@infradead.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/ui/browser.c        |   24 +++++++++-----------
 tools/perf/util/ui/browsers/hists.c |   41 ++++++++++++++++------------------
 tools/perf/util/ui/browsers/map.c   |    9 +++----
 3 files changed, 34 insertions(+), 40 deletions(-)

diff --git a/tools/perf/util/ui/browser.c b/tools/perf/util/ui/browser.c
index 930c4ac..6d0df80 100644
--- a/tools/perf/util/ui/browser.c
+++ b/tools/perf/util/ui/browser.c
@@ -130,13 +130,10 @@ void ui_browser__refresh_dimensions(struct ui_browser *self)
 	int cols, rows;
 	newtGetScreenSize(&cols, &rows);
 
-	if (self->width > cols - 4)
-		self->width = cols - 4;
-	self->height = rows - 5;
-	if (self->height > self->nr_entries)
-		self->height = self->nr_entries;
-	self->y  = (rows - self->height) / 2;
-	self->x = (cols - self->width) / 2;
+	self->width = cols - 1;
+	self->height = rows - 2;
+	self->y = 1;
+	self->x = 0;
 }
 
 void ui_browser__reset_index(struct ui_browser *self)
@@ -168,22 +165,24 @@ int ui_browser__show(struct ui_browser *self, const char *title,
 		       NEWT_KEY_PGDN, NEWT_KEY_HOME, NEWT_KEY_END, ' ',
 		       NEWT_KEY_LEFT, NEWT_KEY_ESCAPE, 'q', CTRL('c'), 0 };
 
-	if (self->form != NULL) {
+	if (self->form != NULL)
 		newtFormDestroy(self->form);
-		newtPopWindow();
-	}
+
 	ui_browser__refresh_dimensions(self);
-	newtCenteredWindow(self->width, self->height, title);
 	self->form = newtForm(NULL, NULL, 0);
 	if (self->form == NULL)
 		return -1;
 
-	self->sb = newtVerticalScrollbar(self->width, 0, self->height,
+	self->sb = newtVerticalScrollbar(self->width, 1, self->height,
 					 HE_COLORSET_NORMAL,
 					 HE_COLORSET_SELECTED);
 	if (self->sb == NULL)
 		return -1;
 
+	SLsmg_gotorc(0, 0);
+	ui_browser__set_color(self, NEWT_COLORSET_ROOT);
+	slsmg_write_nstring(title, self->width);
+
 	ui_browser__add_exit_keys(self, keys);
 	newtFormAddComponent(self->form, self->sb);
 
@@ -196,7 +195,6 @@ int ui_browser__show(struct ui_browser *self, const char *title,
 void ui_browser__hide(struct ui_browser *self)
 {
 	newtFormDestroy(self->form);
-	newtPopWindow();
 	self->form = NULL;
 	ui_helpline__pop();
 }
diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index 2fc1ba3..ebda8c3 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -293,19 +293,12 @@ static int hist_browser__run(struct hist_browser *self, const char *title)
 	int key;
 	int exit_keys[] = { 'a', '?', 'h', 'C', 'd', 'D', 'E', 't',
 			    NEWT_KEY_ENTER, NEWT_KEY_RIGHT, NEWT_KEY_LEFT, 0, };
-	char str[256], unit;
-	unsigned long nr_events = self->hists->stats.nr_events[PERF_RECORD_SAMPLE];
 
 	self->b.entries = &self->hists->entries;
 	self->b.nr_entries = self->hists->nr_entries;
 
 	hist_browser__refresh_dimensions(self);
 
-	nr_events = convert_unit(nr_events, &unit);
-	snprintf(str, sizeof(str), "Events: %lu%c                            ",
-		 nr_events, unit);
-	newtDrawRootText(0, 0, str);
-
 	if (ui_browser__show(&self->b, title,
 			     "Press '?' for help on key bindings") < 0)
 		return -1;
@@ -782,21 +775,26 @@ static struct thread *hist_browser__selected_thread(struct hist_browser *self)
 	return self->he_selection->thread;
 }
 
-static int hist_browser__title(char *bf, size_t size, const char *ev_name,
-			       const struct dso *dso, const struct thread *thread)
+static int hists__browser_title(struct hists *self, char *bf, size_t size,
+				const char *ev_name, const struct dso *dso,
+				const struct thread *thread)
 {
-	int printed = 0;
+	char unit;
+	int printed;
+	unsigned long nr_events = self->stats.nr_events[PERF_RECORD_SAMPLE];
+
+	nr_events = convert_unit(nr_events, &unit);
+	printed = snprintf(bf, size, "Events: %lu%c %s", nr_events, unit, ev_name);
 
 	if (thread)
 		printed += snprintf(bf + printed, size - printed,
-				    "Thread: %s(%d)",
-				    (thread->comm_set ?  thread->comm : ""),
+				    ", Thread: %s(%d)",
+				    (thread->comm_set ? thread->comm : ""),
 				    thread->pid);
 	if (dso)
 		printed += snprintf(bf + printed, size - printed,
-				    "%sDSO: %s", thread ? " " : "",
-				    dso->short_name);
-	return printed ?: snprintf(bf, size, "Event: %s", ev_name);
+				    ", DSO: %s", dso->short_name);
+	return printed;
 }
 
 int hists__browse(struct hists *self, const char *helpline, const char *ev_name)
@@ -817,9 +815,8 @@ int hists__browse(struct hists *self, const char *helpline, const char *ev_name)
 
 	ui_helpline__push(helpline);
 
-	hist_browser__title(msg, sizeof(msg), ev_name,
-			    dso_filter, thread_filter);
-
+	hists__browser_title(self, msg, sizeof(msg), ev_name,
+			     dso_filter, thread_filter);
 	while (1) {
 		const struct thread *thread;
 		const struct dso *dso;
@@ -957,8 +954,8 @@ zoom_out_dso:
 				pstack__push(fstack, &dso_filter);
 			}
 			hists__filter_by_dso(self, dso_filter);
-			hist_browser__title(msg, sizeof(msg), ev_name,
-					    dso_filter, thread_filter);
+			hists__browser_title(self, msg, sizeof(msg), ev_name,
+					     dso_filter, thread_filter);
 			hist_browser__reset(browser);
 		} else if (choice == zoom_thread) {
 zoom_thread:
@@ -975,8 +972,8 @@ zoom_out_thread:
 				pstack__push(fstack, &thread_filter);
 			}
 			hists__filter_by_thread(self, thread_filter);
-			hist_browser__title(msg, sizeof(msg), ev_name,
-					    dso_filter, thread_filter);
+			hists__browser_title(self, msg, sizeof(msg), ev_name,
+					     dso_filter, thread_filter);
 			hist_browser__reset(browser);
 		}
 	}
diff --git a/tools/perf/util/ui/browsers/map.c b/tools/perf/util/ui/browsers/map.c
index 1bf0979..e35437d 100644
--- a/tools/perf/util/ui/browsers/map.c
+++ b/tools/perf/util/ui/browsers/map.c
@@ -46,7 +46,6 @@ out_free_form:
 struct map_browser {
 	struct ui_browser b;
 	struct map	  *map;
-	u16		  namelen;
 	u8		  addrlen;
 };
 
@@ -55,13 +54,16 @@ static void map_browser__write(struct ui_browser *self, void *nd, int row)
 	struct symbol *sym = rb_entry(nd, struct symbol, rb_node);
 	struct map_browser *mb = container_of(self, struct map_browser, b);
 	bool current_entry = ui_browser__is_current_entry(self, row);
+	int width;
 
 	ui_browser__set_percent_color(self, 0, current_entry);
 	slsmg_printf("%*llx %*llx %c ",
 		     mb->addrlen, sym->start, mb->addrlen, sym->end,
 		     sym->binding == STB_GLOBAL ? 'g' :
 		     sym->binding == STB_LOCAL  ? 'l' : 'w');
-	slsmg_write_nstring(sym->name, mb->namelen);
+	width = self->width - ((mb->addrlen * 2) + 4);
+	if (width > 0)
+		slsmg_write_nstring(sym->name, width);
 }
 
 /* FIXME uber-kludgy, see comment on cmd_report... */
@@ -139,8 +141,6 @@ int map__browse(struct map *self)
 	for (nd = rb_first(mb.b.entries); nd; nd = rb_next(nd)) {
 		struct symbol *pos = rb_entry(nd, struct symbol, rb_node);
 
-		if (mb.namelen < pos->namelen)
-			mb.namelen = pos->namelen;
 		if (maxaddr < pos->end)
 			maxaddr = pos->end;
 		if (verbose) {
@@ -151,6 +151,5 @@ int map__browse(struct map *self)
 	}
 
 	mb.addrlen = snprintf(tmp, sizeof(tmp), "%llx", maxaddr);
-	mb.b.width += mb.addrlen * 2 + 4 + mb.namelen;
 	return map_browser__run(&mb);
 }
