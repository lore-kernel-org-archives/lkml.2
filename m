Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070Ab1JMPJc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 11:09:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:43433 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755886Ab1JMPIf (ORCPT
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
Subject: [PATCH 4/6] perf ui browser: Handle SIGWINCH
Date: Thu, 13 Oct 2011 12:08:22 -0300
Message-Id: <1318518504-23299-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1318518504-23299-1-git-send-email-acme@infradead.org>
References: <1318518504-23299-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

To do that we needed to stop using newtForm, as we don't want libnewt to
catch the xterm resize signal.

Remove some more newt calls and instead use the underlying libslang
directly. In time tools/perf will use just libslang.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-h1824yjiru5n2ivz4bseizwj@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c               |   21 ++++-
 tools/perf/perf.c                      |   24 ++++++
 tools/perf/perf.h                      |    2 +
 tools/perf/util/ui/browser.c           |  137 +++++++++++++++++++++-----------
 tools/perf/util/ui/browser.h           |    6 +-
 tools/perf/util/ui/browsers/annotate.c |    5 +-
 tools/perf/util/ui/browsers/hists.c    |   12 +---
 tools/perf/util/ui/browsers/map.c      |    3 +-
 tools/perf/util/ui/helpline.h          |    2 +
 9 files changed, 144 insertions(+), 68 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index c5aebf6..de3cb1e 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -585,16 +585,31 @@ static void *display_thread(void *arg __used)
 	tc.c_cc[VMIN] = 0;
 	tc.c_cc[VTIME] = 0;
 
+	pthread__unblock_sigwinch();
 repeat:
 	delay_msecs = top.delay_secs * 1000;
 	tcsetattr(0, TCSANOW, &tc);
 	/* trash return*/
 	getc(stdin);
 
-	do {
+	while (1) {
 		print_sym_table();
-	} while (!poll(&stdin_poll, 1, delay_msecs) == 1);
-
+		/*
+		 * Either timeout expired or we got an EINTR due to SIGWINCH,
+		 * refresh screen in both cases.
+		 */
+		switch (poll(&stdin_poll, 1, delay_msecs)) {
+		case 0:
+			continue;
+		case -1:
+			if (errno == EINTR)
+				continue;
+			/* Fall trhu */
+		default:
+			goto process_hotkey;
+		}
+	}
+process_hotkey:
 	c = getc(stdin);
 	tcsetattr(0, TCSAFLUSH, &save);
 
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index ec635b7..73d0cac 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -427,6 +427,24 @@ static void get_debugfs_mntpt(void)
 		debugfs_mntpt[0] = '\0';
 }
 
+static void pthread__block_sigwinch(void)
+{
+	sigset_t set;
+
+	sigemptyset(&set);
+	sigaddset(&set, SIGWINCH);
+	pthread_sigmask(SIG_BLOCK, &set, NULL);
+}
+
+void pthread__unblock_sigwinch(void)
+{
+	sigset_t set;
+
+	sigemptyset(&set);
+	sigaddset(&set, SIGWINCH);
+	pthread_sigmask(SIG_UNBLOCK, &set, NULL);
+}
+
 int main(int argc, const char **argv)
 {
 	const char *cmd;
@@ -480,6 +498,12 @@ int main(int argc, const char **argv)
 	 * time.
 	 */
 	setup_path();
+	/*
+	 * Block SIGWINCH notifications so that the thread that wants it can
+	 * unblock and get syscalls like select interrupted instead of waiting
+	 * forever while the signal goes to some other non interested thread.
+	 */
+	pthread__block_sigwinch();
 
 	while (1) {
 		static int done_help;
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 08b0b5e..914c895 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -183,4 +183,6 @@ struct ip_callchain {
 extern bool perf_host, perf_guest;
 extern const char perf_version_string[];
 
+void pthread__unblock_sigwinch(void);
+
 #endif
diff --git a/tools/perf/util/ui/browser.c b/tools/perf/util/ui/browser.c
index 5911bba..05a0f61 100644
--- a/tools/perf/util/ui/browser.c
+++ b/tools/perf/util/ui/browser.c
@@ -1,4 +1,7 @@
+#include "../util.h"
+#include "../../perf.h"
 #include "libslang.h"
+#include <newt.h>
 #include "ui.h"
 #include <linux/compiler.h>
 #include <linux/list.h>
@@ -8,8 +11,8 @@
 #include "browser.h"
 #include "helpline.h"
 #include "../color.h"
-#include "../util.h"
-#include <stdio.h>
+
+int newtGetKey(void);
 
 static int ui_browser__percent_color(double percent, bool current)
 {
@@ -127,11 +130,8 @@ bool ui_browser__is_current_entry(struct ui_browser *self, unsigned row)
 
 void ui_browser__refresh_dimensions(struct ui_browser *self)
 {
-	int cols, rows;
-	newtGetScreenSize(&cols, &rows);
-
-	self->width = cols - 1;
-	self->height = rows - 2;
+	self->width = SLtt_Screen_Cols - 1;
+	self->height = SLtt_Screen_Rows - 2;
 	self->y = 1;
 	self->x = 0;
 }
@@ -142,9 +142,8 @@ void ui_browser__reset_index(struct ui_browser *self)
 	self->seek(self, 0, SEEK_SET);
 }
 
-void ui_browser__add_exit_key(struct ui_browser *self, int key)
+void ui_browser__add_exit_key(struct ui_browser *browser __used, int key __used)
 {
-	newtFormAddHotKey(self->form, key);
 }
 
 void ui_browser__add_exit_keys(struct ui_browser *self, int keys[])
@@ -161,7 +160,7 @@ void __ui_browser__show_title(struct ui_browser *browser, const char *title)
 {
 	SLsmg_gotorc(0, 0);
 	ui_browser__set_color(browser, NEWT_COLORSET_ROOT);
-	slsmg_write_nstring(title, browser->width);
+	slsmg_write_nstring(title, browser->width + 1);
 }
 
 void ui_browser__show_title(struct ui_browser *browser, const char *title)
@@ -174,57 +173,75 @@ void ui_browser__show_title(struct ui_browser *browser, const char *title)
 int ui_browser__show(struct ui_browser *self, const char *title,
 		     const char *helpline, ...)
 {
+	int err;
 	va_list ap;
 	int keys[] = { NEWT_KEY_UP, NEWT_KEY_DOWN, NEWT_KEY_PGUP,
 		       NEWT_KEY_PGDN, NEWT_KEY_HOME, NEWT_KEY_END, ' ',
 		       NEWT_KEY_LEFT, NEWT_KEY_ESCAPE, 'q', CTRL('c'), 0 };
 
-	if (self->form != NULL)
-		newtFormDestroy(self->form);
-
 	ui_browser__refresh_dimensions(self);
-	self->form = newtForm(NULL, NULL, 0);
-	if (self->form == NULL)
-		return -1;
-
-	self->sb = newtVerticalScrollbar(self->width, 1, self->height,
-					 HE_COLORSET_NORMAL,
-					 HE_COLORSET_SELECTED);
-	if (self->sb == NULL)
-		return -1;
 
 	pthread_mutex_lock(&ui__lock);
 	__ui_browser__show_title(self, title);
 
 	ui_browser__add_exit_keys(self, keys);
-	newtFormAddComponent(self->form, self->sb);
+	self->title = title;
+	free(self->helpline);
+	self->helpline = NULL;
 
 	va_start(ap, helpline);
-	ui_helpline__vpush(helpline, ap);
+	err = vasprintf(&self->helpline, helpline, ap);
 	va_end(ap);
+	if (err > 0)
+		ui_helpline__push(self->helpline);
 	pthread_mutex_unlock(&ui__lock);
-	return 0;
+	return err ? 0 : -1;
 }
 
-void ui_browser__hide(struct ui_browser *self)
+void ui_browser__hide(struct ui_browser *browser __used)
 {
 	pthread_mutex_lock(&ui__lock);
-	newtFormDestroy(self->form);
-	self->form = NULL;
 	ui_helpline__pop();
 	pthread_mutex_unlock(&ui__lock);
 }
 
-int ui_browser__refresh(struct ui_browser *self)
+static void ui_browser__scrollbar_set(struct ui_browser *browser)
+{
+	int height = browser->height, h = 0, pct = 0,
+	    col = browser->width,
+	    row = browser->y - 1;
+
+	if (browser->nr_entries > 1) {
+		pct = ((browser->index * (browser->height - 1)) /
+		       (browser->nr_entries - 1));
+	}
+
+	while (h < height) {
+	        ui_browser__gotorc(browser, row++, col);
+		SLsmg_set_char_set(1);
+		SLsmg_write_char(h == pct ? SLSMG_DIAMOND_CHAR : SLSMG_BOARD_CHAR);
+		SLsmg_set_char_set(0);
+		++h;
+	}
+}
+
+static int __ui_browser__refresh(struct ui_browser *browser)
 {
 	int row;
 
+	row = browser->refresh(browser);
+	ui_browser__set_color(browser, HE_COLORSET_NORMAL);
+	SLsmg_fill_region(browser->y + row, browser->x,
+			  browser->height - row, browser->width, ' ');
+	ui_browser__scrollbar_set(browser);
+
+	return 0;
+}
+
+int ui_browser__refresh(struct ui_browser *browser)
+{
 	pthread_mutex_lock(&ui__lock);
-	newtScrollbarSet(self->sb, self->index, self->nr_entries - 1);
-	row = self->refresh(self);
-	ui_browser__set_color(self, HE_COLORSET_NORMAL);
-	SLsmg_fill_region(self->y + row, self->x,
-			  self->height - row, self->width, ' ');
+	__ui_browser__refresh(browser);
 	pthread_mutex_unlock(&ui__lock);
 
 	return 0;
@@ -253,21 +270,49 @@ void ui_browser__update_nr_entries(struct ui_browser *browser, u32 nr_entries)
 	browser->seek(browser, browser->top_idx, SEEK_SET);
 }
 
-int ui_browser__run(struct ui_browser *self)
+int ui_browser__run(struct ui_browser *self, int delay_secs)
 {
-	struct newtExitStruct es;
+	int err, key;
+	struct timeval timeout, *ptimeout = delay_secs ? &timeout : NULL;
 
-	if (ui_browser__refresh(self) < 0)
-		return -1;
+	pthread__unblock_sigwinch();
 
 	while (1) {
 		off_t offset;
+		fd_set read_set;
 
-		newtFormRun(self->form, &es);
+		pthread_mutex_lock(&ui__lock);
+		err = __ui_browser__refresh(self);
+		SLsmg_refresh();
+		pthread_mutex_unlock(&ui__lock);
+		if (err < 0)
+			break;
+
+		FD_ZERO(&read_set);
+		FD_SET(0, &read_set);
+
+		if (delay_secs) {
+			timeout.tv_sec = delay_secs;
+			timeout.tv_usec = 0;
+		}
 
-		if (es.reason != NEWT_EXIT_HOTKEY)
+	        err = select(1, &read_set, NULL, NULL, ptimeout);
+		if (err > 0 && FD_ISSET(0, &read_set))
+			key = newtGetKey();
+		else if (err == 0)
 			break;
-		switch (es.u.key) {
+		else {
+			pthread_mutex_lock(&ui__lock);
+			SLtt_get_screen_size();
+			SLsmg_reinit_smg();
+			pthread_mutex_unlock(&ui__lock);
+			ui_browser__refresh_dimensions(self);
+			__ui_browser__show_title(self, self->title);
+			ui_helpline__puts(self->helpline);
+			continue;
+		}
+
+		switch (key) {
 		case NEWT_KEY_DOWN:
 			if (self->index == self->nr_entries - 1)
 				break;
@@ -324,10 +369,8 @@ int ui_browser__run(struct ui_browser *self)
 			self->seek(self, -offset, SEEK_END);
 			break;
 		default:
-			return es.u.key;
+			return key;
 		}
-		if (ui_browser__refresh(self) < 0)
-			return -1;
 	}
 	return -1;
 }
@@ -353,13 +396,13 @@ unsigned int ui_browser__list_head_refresh(struct ui_browser *self)
 	return row;
 }
 
-static struct newtPercentTreeColors {
+static struct ui_browser__colors {
 	const char *topColorFg, *topColorBg;
 	const char *mediumColorFg, *mediumColorBg;
 	const char *normalColorFg, *normalColorBg;
 	const char *selColorFg, *selColorBg;
 	const char *codeColorFg, *codeColorBg;
-} defaultPercentTreeColors = {
+} ui_browser__default_colors = {
 	"red",       "lightgray",
 	"green",     "lightgray",
 	"black",     "lightgray",
@@ -369,7 +412,7 @@ static struct newtPercentTreeColors {
 
 void ui_browser__init(void)
 {
-	struct newtPercentTreeColors *c = &defaultPercentTreeColors;
+	struct ui_browser__colors *c = &ui_browser__default_colors;
 
 	sltt_set_color(HE_COLORSET_TOP, NULL, c->topColorFg, c->topColorBg);
 	sltt_set_color(HE_COLORSET_MEDIUM, NULL, c->mediumColorFg, c->mediumColorBg);
diff --git a/tools/perf/util/ui/browser.h b/tools/perf/util/ui/browser.h
index d42be43..37d56bf 100644
--- a/tools/perf/util/ui/browser.h
+++ b/tools/perf/util/ui/browser.h
@@ -2,7 +2,6 @@
 #define _PERF_UI_BROWSER_H_ 1
 
 #include <stdbool.h>
-#include <newt.h>
 #include <sys/types.h>
 #include "../types.h"
 
@@ -13,11 +12,12 @@
 #define HE_COLORSET_CODE	54
 
 struct ui_browser {
-	newtComponent form, sb;
 	u64	      index, top_idx;
 	void	      *top, *entries;
 	u16	      y, x, width, height;
 	void	      *priv;
+	const char    *title;
+	char	      *helpline;
 	unsigned int  (*refresh)(struct ui_browser *self);
 	void	      (*write)(struct ui_browser *self, void *entry, int row);
 	void	      (*seek)(struct ui_browser *self, off_t offset, int whence);
@@ -40,7 +40,7 @@ int ui_browser__show(struct ui_browser *self, const char *title,
 		     const char *helpline, ...);
 void ui_browser__hide(struct ui_browser *self);
 int ui_browser__refresh(struct ui_browser *self);
-int ui_browser__run(struct ui_browser *self);
+int ui_browser__run(struct ui_browser *browser, int delay_secs);
 void ui_browser__update_nr_entries(struct ui_browser *browser, u32 nr_entries);
 
 void ui_browser__rb_tree_seek(struct ui_browser *self, off_t offset, int whence);
diff --git a/tools/perf/util/ui/browsers/annotate.c b/tools/perf/util/ui/browsers/annotate.c
index 674b55e..1967fbf 100644
--- a/tools/perf/util/ui/browsers/annotate.c
+++ b/tools/perf/util/ui/browsers/annotate.c
@@ -196,11 +196,8 @@ static int annotate_browser__run(struct annotate_browser *self, int evidx,
 
 	nd = self->curr_hot;
 
-	if (delay_secs != 0)
-		newtFormSetTimer(self->b.form, delay_secs * 1000);
-
 	while (1) {
-		key = ui_browser__run(&self->b);
+		key = ui_browser__run(&self->b, delay_secs);
 
 		if (delay_secs != 0) {
 			annotate_browser__calc_percent(self, evidx);
diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index fdc3c90..603d6ee 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -301,7 +301,6 @@ static int hist_browser__run(struct hist_browser *self, const char *ev_name,
 			     void(*timer)(void *arg), void *arg, int delay_secs)
 {
 	int key;
-	int delay_msecs = delay_secs * 1000;
 	char title[160];
 	int sym_exit_keys[] = { 'a', 'h', 'C', 'd', 'E', 't', 0, };
 	int exit_keys[] = { '?', 'h', 'D', NEWT_KEY_LEFT, NEWT_KEY_RIGHT,
@@ -318,15 +317,12 @@ static int hist_browser__run(struct hist_browser *self, const char *ev_name,
 			     "Press '?' for help on key bindings") < 0)
 		return -1;
 
-	if (timer != NULL)
-		newtFormSetTimer(self->b.form, delay_msecs);
-
 	ui_browser__add_exit_keys(&self->b, exit_keys);
 	if (self->has_symbols)
 		ui_browser__add_exit_keys(&self->b, sym_exit_keys);
 
 	while (1) {
-		key = ui_browser__run(&self->b);
+		key = ui_browser__run(&self->b, delay_secs);
 
 		switch (key) {
 		case -1:
@@ -1061,7 +1057,6 @@ static int perf_evsel_menu__run(struct perf_evsel_menu *menu,
 				void(*timer)(void *arg), void *arg, int delay_secs)
 {
 	int exit_keys[] = { NEWT_KEY_ENTER, NEWT_KEY_RIGHT, 0, };
-	int delay_msecs = delay_secs * 1000;
 	struct perf_evlist *evlist = menu->b.priv;
 	struct perf_evsel *pos;
 	const char *ev_name, *title = "Available samples";
@@ -1071,13 +1066,10 @@ static int perf_evsel_menu__run(struct perf_evsel_menu *menu,
 			     "ESC: exit, ENTER|->: Browse histograms") < 0)
 		return -1;
 
-	if (timer != NULL)
-		newtFormSetTimer(menu->b.form, delay_msecs);
-
 	ui_browser__add_exit_keys(&menu->b, exit_keys);
 
 	while (1) {
-		key = ui_browser__run(&menu->b);
+		key = ui_browser__run(&menu->b, delay_secs);
 
 		switch (key) {
 		case -1:
diff --git a/tools/perf/util/ui/browsers/map.c b/tools/perf/util/ui/browsers/map.c
index 8462bff..499db76 100644
--- a/tools/perf/util/ui/browsers/map.c
+++ b/tools/perf/util/ui/browsers/map.c
@@ -1,5 +1,6 @@
 #include "../libslang.h"
 #include <elf.h>
+#include <newt.h>
 #include <inttypes.h>
 #include <sys/ttydefaults.h>
 #include <ctype.h>
@@ -112,7 +113,7 @@ static int map_browser__run(struct map_browser *self)
 		ui_browser__add_exit_key(&self->b, '/');
 
 	while (1) {
-		key = ui_browser__run(&self->b);
+		key = ui_browser__run(&self->b, 0);
 
 		if (verbose && key == '/')
 			map_browser__search(self);
diff --git a/tools/perf/util/ui/helpline.h b/tools/perf/util/ui/helpline.h
index ab6028d..8099757 100644
--- a/tools/perf/util/ui/helpline.h
+++ b/tools/perf/util/ui/helpline.h
@@ -1,6 +1,8 @@
 #ifndef _PERF_UI_HELPLINE_H_
 #define _PERF_UI_HELPLINE_H_ 1
 
+#include <stdio.h>
+
 void ui_helpline__init(void);
 void ui_helpline__pop(void);
 void ui_helpline__push(const char *msg);
-- 
1.6.2.5

