Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204Ab2BWRw6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 12:52:58 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:36733 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753185Ab2BWRw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 12:52:56 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of penberg@gmail.com designates 10.152.125.20 as permitted sender) smtp.mail=penberg@gmail.com; dkim=pass header.i=penberg@gmail.com
Date: Thu, 23 Feb 2012 19:52:47 +0200 (EET)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] perf report: Add a simple GTK2-based 'perf report'
 browser
In-Reply-To: <20120223173743.GH25177@infradead.org>
Message-ID: <alpine.LFD.2.02.1202231952410.6689@tux.localdomain>
References: <1330013922-3332-1-git-send-email-penberg@kernel.org> <20120223162850.GC25177@infradead.org> <CAOJsxLG2c=Mc-Rn56jmB290LtHpRY8pkfyqPrizgwE8_8+uxFQ@mail.gmail.com> <20120223163938.GD25177@infradead.org> <1330015504.13624.84.camel@jaguar>
 <20120223164739.GF25177@infradead.org> <20120223165302.GG25177@infradead.org> <CAOJsxLGP97smBEshzMY1vKMbSiK-mP1+dK8czuFM3girq-KS+A@mail.gmail.com> <20120223173743.GH25177@infradead.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1054389327-1330019573=:6689"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1054389327-1330019573=:6689
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT

On Thu, 23 Feb 2012, Arnaldo Carvalho de Melo wrote:
> One thing I saw was that it now defaults to --stdio and then doesn't
> setup the pager, i.e. just build it with newt-devel, gtk2-devel
> installed and don't specify --gtk to see what I mean.

Fixed! This version makes sure none of the defaults change and that GTK 
interface is started up only if user explicitly asks for it.

			Pekka

------------->

>From 3dc75243a43212fe907fad4139087f4033c2bf53 Mon Sep 17 00:00:00 2001
From: Pekka Enberg <penberg@kernel.org>
Date: Thu, 23 Feb 2012 17:49:18 +0200
Subject: [PATCH] perf report: Add a simple GTK2-based 'perf report' browser
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This patch adds a simple GTK2-based browser to 'perf report' that's based on
the TTY-based browser in builtin-report.c.

Please not that you need to use

  make WERROR=0

to build perf on Fedora 15 (and possibly other distributions) because GTK
headers do not compile cleanly:

      CC util/gtk/browser.o
  In file included from /usr/include/gtk-2.0/gtk/gtk.h:234:0,
                   from util/gtk/browser.c:7:
  /usr/include/gtk-2.0/gtk/gtkitemfactory.h:47:1: warning: function declaration isn¢t a prototype [-Wstrict-prototypes]

To launch "perf report" using the new GTK interface just type:

  ./perf report --gtk

The interface is somewhat limited in features at the moment:

  - No callgraph support

  - No KVM guest profiling support

  - No color coding for percentages

  - No sorting from the UI

  - ..and many, many more!

That said, I think this patch a reasonable start to build future features on.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
---
 tools/perf/Documentation/perf-report.txt |    2 +
 tools/perf/Makefile                      |   14 +++
 tools/perf/builtin-report.c              |   23 +++-
 tools/perf/config/feature-tests.mak      |   13 ++
 tools/perf/util/cache.h                  |   12 ++
 tools/perf/util/gtk/browser.c            |  189 ++++++++++++++++++++++++++++++
 tools/perf/util/hist.h                   |   17 +++
 7 files changed, 264 insertions(+), 6 deletions(-)
 create mode 100644 tools/perf/util/gtk/browser.c

diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 9b430e9..9654f27 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -110,6 +110,8 @@ OPTIONS
 	requires a tty, if one is not present, as when piping to other
 	commands, the stdio interface is used.
 
+--gtk:: Use the GTK2 interface.
+
 -k::
 --vmlinux=<file>::
         vmlinux pathname
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index e011b50..371f114 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -485,6 +485,20 @@ else
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
index 25d34d4..d6bf6ec 100644
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
@@ -326,8 +326,13 @@ static int __cmd_report(struct perf_report *rep)
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
 
@@ -474,6 +479,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 	OPT_STRING(0, "pretty", &report.pretty_printing_style, "key",
 		   "pretty printing style key: normal raw"),
 	OPT_BOOLEAN(0, "tui", &report.use_tui, "Use the TUI interface"),
+	OPT_BOOLEAN(0, "gtk", &report.use_gtk, "Use the GTK2 interface"),
 	OPT_BOOLEAN(0, "stdio", &report.use_stdio,
 		    "Use the stdio interface"),
 	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
@@ -526,6 +532,8 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 		use_browser = 0;
 	else if (report.use_tui)
 		use_browser = 1;
+	else if (report.use_gtk)
+		use_browser = 2;
 
 	if (report.inverted_callchain)
 		callchain_param.order = ORDER_CALLER;
@@ -537,9 +545,12 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 			report.input_name = "perf.data";
 	}
 
-	if (strcmp(report.input_name, "-") != 0)
-		setup_browser(true);
-	else
+	if (strcmp(report.input_name, "-") != 0) {
+		if (report.use_gtk)
+			perf_gtk_setup_browser(argc, argv, true);
+		else
+			setup_browser(true);
+	} else
 		use_browser = 0;
 
 	/*
diff --git a/tools/perf/config/feature-tests.mak b/tools/perf/config/feature-tests.mak
index 6170fd2..f5b551c 100644
--- a/tools/perf/config/feature-tests.mak
+++ b/tools/perf/config/feature-tests.mak
@@ -65,6 +65,19 @@ int main(void)
 endef
 endif
 
+ifndef NO_GTK2
+define SOURCE_GTK2
+#include <gtk/gtk.h>
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
index 0000000..4878279
--- /dev/null
+++ b/tools/perf/util/gtk/browser.c
@@ -0,0 +1,189 @@
+#include "../evlist.h"
+#include "../cache.h"
+#include "../evsel.h"
+#include "../sort.h"
+#include "../hist.h"
+
+#include <gtk/gtk.h>
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
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 48e5acd..3be98b2 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -134,6 +134,23 @@ int perf_evlist__tui_browse_hists(struct perf_evlist *evlist, const char *help,
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
-- 
1.7.6.5

--8323328-1054389327-1330019573=:6689--
