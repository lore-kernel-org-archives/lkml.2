Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965331Ab2CGB5l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 20:57:41 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:64963 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965269Ab2CGB5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 20:57:39 -0500
X-AuditID: 9c930179-b7c4fae0000073fb-0a-4f56c08f201b
From: Namhyung Kim <namhyung.kim@lge.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@gmail.com>, Arun Sharma <asharma@fb.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        dsahern@gmail.com, ravitillo@lbl.gov, khandual@linux.vnet.ibm.com,
        robert.richter@amd.com, ming.m.lin@intel.com, vweaver1@eecs.utk.edu,
        andi@firstfloor.org
Subject: [RFC] perf report: Implement symbol filtering on TUI
Date: Wed,  7 Mar 2012 10:57:50 +0900
Message-Id: <1331085470-32594-1-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <20120306062546.GA622@elte.hu>
References: <20120306062546.GA622@elte.hu>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As Ingo requested, symbol filtering feature was missing on TUI.
Add 's' key to get input from user, and do simple filtering by
strstr(). To turn filtering off, just enter no name by pressing
's' followed by ENTER.

There should be many issues, but I just want to release this
to get some feedbacks.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 tools/perf/builtin-report.c         |   21 +++++++--
 tools/perf/util/hist.c              |   31 ++++++++++++++
 tools/perf/util/hist.h              |    2 +
 tools/perf/util/ui/browser.h        |    2 +
 tools/perf/util/ui/browsers/hists.c |   17 +++++++-
 tools/perf/util/ui/keysyms.h        |    3 +
 tools/perf/util/ui/util.c           |   78 +++++++++++++++++++++++++++++++++++
 7 files changed, 148 insertions(+), 6 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 25d34d483e49..64878b63f4f8 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -50,6 +50,7 @@ struct perf_report {
 	const char		*pretty_printing_style;
 	symbol_filter_t		annotate_init;
 	const char		*cpu_list;
+	const char		*symbol_filter_str;
 	DECLARE_BITMAP(cpu_bitmap, MAX_NR_CPUS);
 };
 
@@ -326,6 +327,11 @@ static int __cmd_report(struct perf_report *rep)
 	}
 
 	if (use_browser > 0) {
+		struct perf_evsel *first;
+		first = list_entry(session->evlist->entries.next,
+				   struct perf_evsel, node);
+		first->hists.symbol_filter_str = rep->symbol_filter_str;
+
 		perf_evlist__tui_browse_hists(session->evlist, help,
 					      NULL, NULL, 0);
 	} else
@@ -586,11 +592,16 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 	} else
 		symbol_conf.exclude_other = false;
 
-	/*
-	 * Any (unrecognized) arguments left?
-	 */
-	if (argc)
-		usage_with_options(report_usage, options);
+	if (argc) {
+		/*
+		 * Special case: if there's an argument left then assume tha
+		 * it's a symbol filter:
+		 */
+		if (argc > 1)
+			usage_with_options(report_usage, options);
+
+		report.symbol_filter_str = argv[0];
+	}
 
 	sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list, "dso", stdout);
 	sort_entry__setup_elide(&sort_comm, symbol_conf.comm_list, "comm", stdout);
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 6f505d1abac7..56f19d86b0cd 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -15,6 +15,7 @@ enum hist_filter {
 	HIST_FILTER__DSO,
 	HIST_FILTER__THREAD,
 	HIST_FILTER__PARENT,
+	HIST_FILTER__SYMBOL,
 };
 
 struct callchain_param	callchain_param = {
@@ -1179,6 +1180,36 @@ void hists__filter_by_thread(struct hists *hists)
 	}
 }
 
+static bool hists__filter_entry_by_symbol(struct hists *hists,
+					  struct hist_entry *he)
+{
+	if (hists->symbol_filter_str != NULL && he->ms.sym &&
+	    strstr(he->ms.sym->name, hists->symbol_filter_str) == NULL) {
+		he->filtered |= (1 << HIST_FILTER__SYMBOL);
+		return true;
+	}
+
+	return false;
+}
+
+void hists__filter_by_symbol(struct hists *hists)
+{
+	struct rb_node *nd;
+
+	hists->nr_entries = hists->stats.total_period = 0;
+	hists->stats.nr_events[PERF_RECORD_SAMPLE] = 0;
+	hists__reset_col_len(hists);
+
+	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
+		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
+
+		if (hists__filter_entry_by_symbol(hists, h))
+			continue;
+
+		hists__remove_entry_filter(hists, h, HIST_FILTER__SYMBOL);
+	}
+}
+
 int hist_entry__inc_addr_samples(struct hist_entry *he, int evidx, u64 ip)
 {
 	return symbol__inc_addr_samples(he->ms.sym, he->ms.map, evidx, ip);
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 48e5acd1e862..020d3477cabc 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -57,6 +57,7 @@ struct hists {
 	const struct thread	*thread_filter;
 	const struct dso	*dso_filter;
 	const char		*uid_filter_str;
+	const char		*symbol_filter_str;
 	pthread_mutex_t		lock;
 	struct events_stats	stats;
 	u64			event_stream;
@@ -96,6 +97,7 @@ int hist_entry__annotate(struct hist_entry *self, size_t privsize);
 
 void hists__filter_by_dso(struct hists *hists);
 void hists__filter_by_thread(struct hists *hists);
+void hists__filter_by_symbol(struct hists *hists);
 
 u16 hists__col_len(struct hists *self, enum hist_column col);
 void hists__set_col_len(struct hists *self, enum hist_column col, u16 len);
diff --git a/tools/perf/util/ui/browser.h b/tools/perf/util/ui/browser.h
index 84d761b730c1..6ee82f60feaf 100644
--- a/tools/perf/util/ui/browser.h
+++ b/tools/perf/util/ui/browser.h
@@ -49,6 +49,8 @@ int ui_browser__warning(struct ui_browser *browser, int timeout,
 			const char *format, ...);
 int ui_browser__help_window(struct ui_browser *browser, const char *text);
 bool ui_browser__dialog_yesno(struct ui_browser *browser, const char *text);
+int ui_browser__input_window(const char *title, const char *text, char *input,
+			     const char *exit_msg, int delay_sec);
 
 void ui_browser__argv_seek(struct ui_browser *browser, off_t offset, int whence);
 unsigned int ui_browser__argv_refresh(struct ui_browser *browser);
diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index bfba0490c098..6a7c918e7b4c 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -863,6 +863,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 	struct hist_browser *browser = hist_browser__new(self);
 	struct pstack *fstack;
 	int key = -1;
+	char buf[64];
 
 	if (browser == NULL)
 		return -1;
@@ -871,6 +872,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 	if (fstack == NULL)
 		goto out;
 
+	hists__filter_by_symbol(self);
 	ui_helpline__push(helpline);
 
 	while (1) {
@@ -915,6 +917,18 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 			goto zoom_dso;
 		case 't':
 			goto zoom_thread;
+		case 's':
+			if (ui_browser__input_window("Symbol to show",
+					"Please enter the name of symbol you want to see",
+					buf, "ENTER: OK, ESC: Cancel",
+					delay_secs * 2) == K_ENTER) {
+				self->symbol_filter_str = buf;
+				ui_helpline__fpush("filtered by \"%s\"",
+						   self->symbol_filter_str);
+			}
+			hists__filter_by_symbol(self);
+			hist_browser__reset(browser);
+			continue;
 		case K_F1:
 		case 'h':
 		case '?':
@@ -932,7 +946,8 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 					"C             Collapse all callchains\n"
 					"E             Expand all callchains\n"
 					"d             Zoom into current DSO\n"
-					"t             Zoom into current Thread");
+					"t             Zoom into current Thread\n"
+					"s             Filter symbol by name");
 			continue;
 		case K_ENTER:
 		case K_RIGHT:
diff --git a/tools/perf/util/ui/keysyms.h b/tools/perf/util/ui/keysyms.h
index 3458b1985761..7bc34084d663 100644
--- a/tools/perf/util/ui/keysyms.h
+++ b/tools/perf/util/ui/keysyms.h
@@ -16,6 +16,9 @@
 #define K_TAB	'\t'
 #define K_UNTAB	SL_KEY_UNTAB
 #define K_UP	SL_KEY_UP
+//#define K_BKSPC SL_KEY_BACKSPACE
+#define K_BKSPC 0x7f
+#define K_DEL	SL_KEY_DELETE
 
 /* Not really keys */
 #define K_TIMER	 -1
diff --git a/tools/perf/util/ui/util.c b/tools/perf/util/ui/util.c
index 45daa7c41dad..360f43fd5400 100644
--- a/tools/perf/util/ui/util.c
+++ b/tools/perf/util/ui/util.c
@@ -69,6 +69,84 @@ int ui__popup_menu(int argc, char * const argv[])
 	return popup_menu__run(&menu);
 }
 
+int ui_browser__input_window(const char *title, const char *text, char *input,
+			     const char *exit_msg, int delay_secs)
+{
+	int x, y, len, key;
+	int max_len = 60, nr_lines = 0;
+	static char buf[50];
+	const char *t;
+
+	t = text;
+	while (1) {
+		const char *sep = strchr(t, '\n');
+
+		if (sep == NULL)
+			sep = strchr(t, '\0');
+		len = sep - t;
+		if (max_len < len)
+			max_len = len;
+		++nr_lines;
+		if (*sep == '\0')
+			break;
+		t = sep + 1;
+	}
+
+	max_len += 2;
+	nr_lines += 8;
+	y = SLtt_Screen_Rows / 2 - nr_lines / 2;
+	x = SLtt_Screen_Cols / 2 - max_len / 2;
+
+	SLsmg_set_color(0);
+	SLsmg_draw_box(y, x++, nr_lines, max_len);
+	if (title) {
+		SLsmg_gotorc(y, x + 1);
+		SLsmg_write_string((char *)title);
+	}
+	SLsmg_gotorc(++y, x);
+	nr_lines -= 7;
+	max_len -= 2;
+	SLsmg_write_wrapped_string((unsigned char *)text, y, x,
+				   nr_lines, max_len, 1);
+	y += nr_lines + 1;
+	SLsmg_set_color(0);
+	SLsmg_draw_box(y - 1, x + 1, 3, max_len - 2);
+
+	SLsmg_gotorc(y + 3, x);
+	SLsmg_write_nstring((char *)exit_msg, max_len);
+	SLsmg_refresh();
+
+	x += 2;
+	len = 0;
+	key = ui__getch(delay_secs);
+	while (key != K_TIMER && key != K_ENTER && key != K_ESC) {
+		if (key == K_BKSPC) {
+			if (len == 0)
+				goto next_key;
+			SLsmg_gotorc(y, x + --len);
+			SLsmg_write_char(' ');
+		} else {
+			buf[len] = key;
+			SLsmg_gotorc(y, x + len++);
+			SLsmg_write_char(key);
+		}
+		SLsmg_refresh();
+
+		/* XXX more graceful overflow handling needed */
+		if (len == sizeof(buf) - 1) {
+			ui_helpline__push("maximum size of symbol name reached!");
+			key = K_ENTER;
+			break;
+		}
+next_key:
+		key = ui__getch(delay_secs);
+	}
+
+	buf[len] = '\0';
+	strncpy(input, buf, len+1);
+	return key;
+}
+
 int ui__question_window(const char *title, const char *text,
 			const char *exit_msg, int delay_secs)
 {
-- 
1.7.9

