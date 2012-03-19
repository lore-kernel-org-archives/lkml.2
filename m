Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032995Ab2CSUIV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 16:08:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40085 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032761Ab2CSUIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 16:08:19 -0400
Date: Mon, 19 Mar 2012 13:08:01 -0700
From: tip-bot for Pekka Enberg <penberg@kernel.org>
Message-ID: <tip-c31a94570552dcaa517c4f7a043ffd28835016be@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        walters@verbum.org, penberg@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        penberg@kernel.org, walters@verbum.org, tglx@linutronix.de
In-Reply-To: <alpine.LFD.2.02.1202231952410.6689@tux.localdomain>
References: <alpine.LFD.2.02.1202231952410.6689@tux.localdomain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf report: Add a simple GTK2-based 'perf report'
  browser
Git-Commit-ID: c31a94570552dcaa517c4f7a043ffd28835016be
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 19 Mar 2012 13:08:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c31a94570552dcaa517c4f7a043ffd28835016be
Gitweb:     http://git.kernel.org/tip/c31a94570552dcaa517c4f7a043ffd28835016be
Author:     Pekka Enberg <penberg@kernel.org>
AuthorDate: Mon, 19 Mar 2012 15:13:29 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 19 Mar 2012 15:13:29 -0300

perf report: Add a simple GTK2-based 'perf report' browser

This patch adds a simple GTK2-based browser to 'perf report' that's
based on the TTY-based browser in builtin-report.c.

To launch "perf report" using the new GTK interface just type:

  $ perf report --gtk

The interface is somewhat limited in features at the moment:

  - No callgraph support

  - No KVM guest profiling support

  - No color coding for percentages

  - No sorting from the UI

  - ..and many, many more!

That said, I think this patch a reasonable start to build future features on.

Signed-off-by: Pekka Enberg <penberg@kernel.org>
Cc: Colin Walters <walters@verbum.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@kernel.org>
Link: http://lkml.kernel.org/r/alpine.LFD.2.02.1202231952410.6689@tux.localdomain
[ committer note: Added #pragma to make gtk no strict prototype problem go
  away as suggested by Colin Walters modulo avoiding push/pop ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-report.txt |    2 +
 tools/perf/Makefile                      |   14 +++
 tools/perf/builtin-report.c              |   19 +++-
 tools/perf/config/feature-tests.mak      |   15 +++
 tools/perf/util/cache.h                  |   12 ++
 tools/perf/util/gtk/browser.c            |  189 ++++++++++++++++++++++++++++++
 tools/perf/util/gtk/gtk.h                |    8 ++
 tools/perf/util/hist.h                   |   17 +++
 8 files changed, 272 insertions(+), 4 deletions(-)

diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 68bbf9c..2d89f02 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -113,6 +113,8 @@ OPTIONS
 	requires a tty, if one is not present, as when piping to other
 	commands, the stdio interface is used.
 
+--gtk:: Use the GTK2 interface.
+
 -k::
 --vmlinux=<file>::
         vmlinux pathname
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index e07fbd8..cc27148 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -507,6 +507,20 @@ else
 	endif
 endif
 
+ifdef NO_GTK2
+	BASIC_CFLAGS += -DNO_GTK2
+else
+	FLAGS_GTK2=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) $(shell pkg-config --libs --cflags gtk+-2.0)
+	ifneq ($(call try-cc,$(SOURCE_GTK2),$(FLAGS_GTK2)),y)
+		msg := $(warning GTK2 not found, disables GTK2 support. Please install gtk2-devel or libgtk2.0-dev);
+		BASIC_CFLAGS += -DNO_GTK2_SUPPORT
+	else
+		BASIC_CFLAGS += $(shell pkg-config --cflags gtk+-2.0)
+		EXTLIBS += $(shell pkg-config --libs gtk+-2.0)
+		LIB_OBJS += $(OUTPUT)util/gtk/browser.o
+	endif
+endif
+
 ifdef NO_LIBPERL
 	BASIC_CFLAGS += -DNO_LIBPERL
 else
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index c005458..2e31743 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -40,7 +40,7 @@ struct perf_report {
 	struct perf_tool	tool;
 	struct perf_session	*session;
 	char const		*input_name;
-	bool			force, use_tui, use_stdio;
+	bool			force, use_tui, use_gtk, use_stdio;
 	bool			hide_unresolved;
 	bool			dont_use_callchains;
 	bool			show_full_info;
@@ -415,8 +415,13 @@ static int __cmd_report(struct perf_report *rep)
 	}
 
 	if (use_browser > 0) {
-		perf_evlist__tui_browse_hists(session->evlist, help,
-					      NULL, NULL, 0);
+		if (use_browser == 1) {
+			perf_evlist__tui_browse_hists(session->evlist, help,
+						      NULL, NULL, 0);
+		} else if (use_browser == 2) {
+			perf_evlist__gtk_browse_hists(session->evlist, help,
+						      NULL, NULL, 0);
+		}
 	} else
 		perf_evlist__tty_browse_hists(session->evlist, rep, help);
 
@@ -573,6 +578,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 	OPT_STRING(0, "pretty", &report.pretty_printing_style, "key",
 		   "pretty printing style key: normal raw"),
 	OPT_BOOLEAN(0, "tui", &report.use_tui, "Use the TUI interface"),
+	OPT_BOOLEAN(0, "gtk", &report.use_gtk, "Use the GTK2 interface"),
 	OPT_BOOLEAN(0, "stdio", &report.use_stdio,
 		    "Use the stdio interface"),
 	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
@@ -630,6 +636,8 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 		use_browser = 0;
 	else if (report.use_tui)
 		use_browser = 1;
+	else if (report.use_gtk)
+		use_browser = 2;
 
 	if (report.inverted_callchain)
 		callchain_param.order = ORDER_CALLER;
@@ -666,7 +674,10 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 	}
 
 	if (strcmp(report.input_name, "-") != 0) {
-		setup_browser(true);
+		if (report.use_gtk)
+			perf_gtk_setup_browser(argc, argv, true);
+		else
+			setup_browser(true);
 	} else {
 		use_browser = 0;
 	}
diff --git a/tools/perf/config/feature-tests.mak b/tools/perf/config/feature-tests.mak
index 6170fd2..d9084e0 100644
--- a/tools/perf/config/feature-tests.mak
+++ b/tools/perf/config/feature-tests.mak
@@ -65,6 +65,21 @@ int main(void)
 endef
 endif
 
+ifndef NO_GTK2
+define SOURCE_GTK2
+#pragma GCC diagnostic ignored \"-Wstrict-prototypes\"
+#include <gtk/gtk.h>
+#pragma GCC diagnostic error \"-Wstrict-prototypes\"
+
+int main(int argc, char *argv[])
+{
+        gtk_init(&argc, &argv);
+
+        return 0;
+}
+endef
+endif
+
 ifndef NO_LIBPERL
 define SOURCE_PERL_EMBED
 #include <EXTERN.h>
diff --git a/tools/perf/util/cache.h b/tools/perf/util/cache.h
index fc5e5a0..8dd224d 100644
--- a/tools/perf/util/cache.h
+++ b/tools/perf/util/cache.h
@@ -45,6 +45,18 @@ void setup_browser(bool fallback_to_pager);
 void exit_browser(bool wait_for_ok);
 #endif
 
+#ifdef NO_GTK2_SUPPORT
+static inline void perf_gtk_setup_browser(int argc __used, const char *argv[] __used, bool fallback_to_pager)
+{
+	if (fallback_to_pager)
+		setup_pager();
+}
+static inline void perf_gtk_exit_browser(bool wait_for_ok __used) {}
+#else
+void perf_gtk_setup_browser(int argc, const char *argv[], bool fallback_to_pager);
+void perf_gtk_exit_browser(bool wait_for_ok);
+#endif
+
 char *alias_lookup(const char *alias);
 int split_cmdline(char *cmdline, const char ***argv);
 
diff --git a/tools/perf/util/gtk/browser.c b/tools/perf/util/gtk/browser.c
new file mode 100644
index 0000000..258352a
--- /dev/null
+++ b/tools/perf/util/gtk/browser.c
@@ -0,0 +1,189 @@
+#include "../evlist.h"
+#include "../cache.h"
+#include "../evsel.h"
+#include "../sort.h"
+#include "../hist.h"
+#include "gtk.h"
+
+#include <signal.h>
+
+#define MAX_COLUMNS			32
+
+void perf_gtk_setup_browser(int argc, const char *argv[],
+			    bool fallback_to_pager __used)
+{
+	gtk_init(&argc, (char ***)&argv);
+}
+
+void perf_gtk_exit_browser(bool wait_for_ok __used)
+{
+	gtk_main_quit();
+}
+
+static void perf_gtk_signal(int sig)
+{
+	psignal(sig, "perf");
+	gtk_main_quit();
+}
+
+static void perf_gtk_resize_window(GtkWidget *window)
+{
+	GdkRectangle rect;
+	GdkScreen *screen;
+	int monitor;
+	int height;
+	int width;
+
+	screen = gtk_widget_get_screen(window);
+
+	monitor = gdk_screen_get_monitor_at_window(screen, window->window);
+
+	gdk_screen_get_monitor_geometry(screen, monitor, &rect);
+
+	width	= rect.width * 3 / 4;
+	height	= rect.height * 3 / 4;
+
+	gtk_window_resize(GTK_WINDOW(window), width, height);
+}
+
+static void perf_gtk_show_hists(GtkWidget *window, struct hists *hists)
+{
+	GType col_types[MAX_COLUMNS];
+	GtkCellRenderer *renderer;
+	struct sort_entry *se;
+	GtkListStore *store;
+	struct rb_node *nd;
+	u64 total_period;
+	GtkWidget *view;
+	int col_idx;
+	int nr_cols;
+
+	nr_cols = 0;
+
+	/* The percentage column */
+	col_types[nr_cols++] = G_TYPE_STRING;
+
+	list_for_each_entry(se, &hist_entry__sort_list, list) {
+		if (se->elide)
+			continue;
+
+		col_types[nr_cols++] = G_TYPE_STRING;
+	}
+
+	store = gtk_list_store_newv(nr_cols, col_types);
+
+	view = gtk_tree_view_new();
+
+	renderer = gtk_cell_renderer_text_new();
+
+	col_idx = 0;
+
+	/* The percentage column */
+	gtk_tree_view_insert_column_with_attributes(GTK_TREE_VIEW(view),
+						    -1, "Overhead (%)",
+						    renderer, "text",
+						    col_idx++, NULL);
+
+	list_for_each_entry(se, &hist_entry__sort_list, list) {
+		if (se->elide)
+			continue;
+
+		gtk_tree_view_insert_column_with_attributes(GTK_TREE_VIEW(view),
+							    -1, se->se_header,
+							    renderer, "text",
+							    col_idx++, NULL);
+	}
+
+	gtk_tree_view_set_model(GTK_TREE_VIEW(view), GTK_TREE_MODEL(store));
+
+	g_object_unref(GTK_TREE_MODEL(store));
+
+	total_period = hists->stats.total_period;
+
+	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
+		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
+		GtkTreeIter iter;
+		double percent;
+		char s[512];
+
+		if (h->filtered)
+			continue;
+
+		gtk_list_store_append(store, &iter);
+
+		col_idx = 0;
+
+		percent = (h->period * 100.0) / total_period;
+
+		snprintf(s, ARRAY_SIZE(s), "%.2f", percent);
+
+		gtk_list_store_set(store, &iter, col_idx++, s, -1);
+
+		list_for_each_entry(se, &hist_entry__sort_list, list) {
+			if (se->elide)
+				continue;
+
+			se->se_snprintf(h, s, ARRAY_SIZE(s),
+					hists__col_len(hists, se->se_width_idx));
+
+			gtk_list_store_set(store, &iter, col_idx++, s, -1);
+		}
+	}
+
+	gtk_container_add(GTK_CONTAINER(window), view);
+}
+
+int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist,
+				  const char *help __used,
+				  void (*timer) (void *arg)__used,
+				  void *arg __used, int delay_secs __used)
+{
+	struct perf_evsel *pos;
+	GtkWidget *notebook;
+	GtkWidget *window;
+
+	signal(SIGSEGV, perf_gtk_signal);
+	signal(SIGFPE,  perf_gtk_signal);
+	signal(SIGINT,  perf_gtk_signal);
+	signal(SIGQUIT, perf_gtk_signal);
+	signal(SIGTERM, perf_gtk_signal);
+
+	window = gtk_window_new(GTK_WINDOW_TOPLEVEL);
+
+	gtk_window_set_title(GTK_WINDOW(window), "perf report");
+
+	g_signal_connect(window, "delete_event", gtk_main_quit, NULL);
+
+	notebook = gtk_notebook_new();
+
+	list_for_each_entry(pos, &evlist->entries, node) {
+		struct hists *hists = &pos->hists;
+		const char *evname = event_name(pos);
+		GtkWidget *scrolled_window;
+		GtkWidget *tab_label;
+
+		scrolled_window = gtk_scrolled_window_new(NULL, NULL);
+
+		gtk_scrolled_window_set_policy(GTK_SCROLLED_WINDOW(scrolled_window),
+							GTK_POLICY_AUTOMATIC,
+							GTK_POLICY_AUTOMATIC);
+
+		perf_gtk_show_hists(scrolled_window, hists);
+
+		tab_label = gtk_label_new(evname);
+
+		gtk_notebook_append_page(GTK_NOTEBOOK(notebook), scrolled_window, tab_label);
+	}
+
+	gtk_container_add(GTK_CONTAINER(window), notebook);
+
+	gtk_widget_show_all(window);
+
+	perf_gtk_resize_window(window);
+
+	gtk_window_set_position(GTK_WINDOW(window), GTK_WIN_POS_CENTER);
+
+	gtk_main();
+
+	return 0;
+}
diff --git a/tools/perf/util/gtk/gtk.h b/tools/perf/util/gtk/gtk.h
new file mode 100644
index 0000000..75177ee
--- /dev/null
+++ b/tools/perf/util/gtk/gtk.h
@@ -0,0 +1,8 @@
+#ifndef _PERF_GTK_H_
+#define _PERF_GTK_H_ 1
+
+#pragma GCC diagnostic ignored "-Wstrict-prototypes"
+#include <gtk/gtk.h>
+#pragma GCC diagnostic error "-Wstrict-prototypes"
+
+#endif /* _PERF_GTK_H_ */
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 10343c0..2cae9df 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -147,6 +147,23 @@ int perf_evlist__tui_browse_hists(struct perf_evlist *evlist, const char *help,
 				  int refresh);
 #endif
 
+#ifdef NO_GTK2_SUPPORT
+static inline
+int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist __used,
+				  const char *help __used,
+				  void(*timer)(void *arg) __used,
+				  void *arg __used,
+				  int refresh __used)
+{
+	return 0;
+}
+
+#else
+int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist, const char *help,
+				  void(*timer)(void *arg), void *arg,
+				  int refresh);
+#endif
+
 unsigned int hists__sort_list_width(struct hists *self);
 
 #endif	/* __PERF_HIST_H */
