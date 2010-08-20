Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751846Ab0HTMlD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 08:41:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:40205 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751504Ab0HTMlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 08:41:01 -0400
Date: Fri, 20 Aug 2010 12:40:40 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, acme@redhat.com,
        hpa@zytor.com, mingo@redhat.com, peterz@infradead.org, efault@gmx.de,
        fweisbec@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, eranian@google.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com, efault@gmx.de,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf ui browser: Add routines to compactly specify exit keys
Message-ID: <tip-4c1c952e37c7511a52f617ceddbc10c855d45d7b@git.kernel.org>
Git-Commit-ID: 4c1c952e37c7511a52f617ceddbc10c855d45d7b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 20 Aug 2010 12:40:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4c1c952e37c7511a52f617ceddbc10c855d45d7b
Gitweb:     http://git.kernel.org/tip/4c1c952e37c7511a52f617ceddbc10c855d45d7b
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 12 Aug 2010 12:37:51 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 19 Aug 2010 19:44:18 -0300

perf ui browser: Add routines to compactly specify exit keys

This makes the usual idiom for specifying a series of key codes to exit
ui_browser__run() for specialized processing (search, annotate, etc) or
plain exiting the browser more compact.

It also abstracts away some more libnewt operations. At some point we'll
also replace NEWT_KEY_foo with something that can be mapped to NEWT or,
say, gtk.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/ui/browser.c           |   30 ++++++++++++++++++++----------
 tools/perf/util/ui/browser.h           |    2 ++
 tools/perf/util/ui/browsers/annotate.c |   12 +++++++-----
 tools/perf/util/ui/browsers/hists.c    |   13 +++----------
 tools/perf/util/ui/browsers/map.c      |    8 +-------
 tools/perf/util/ui/util.c              |    4 +---
 6 files changed, 34 insertions(+), 35 deletions(-)

diff --git a/tools/perf/util/ui/browser.c b/tools/perf/util/ui/browser.c
index 669a980..930c4ac 100644
--- a/tools/perf/util/ui/browser.c
+++ b/tools/perf/util/ui/browser.c
@@ -11,8 +11,6 @@
 #include "../util.h"
 #include <stdio.h>
 
-newtComponent newt_form__new(void);
-
 static int ui_browser__percent_color(double percent, bool current)
 {
 	if (current)
@@ -147,10 +145,28 @@ void ui_browser__reset_index(struct ui_browser *self)
 	self->seek(self, 0, SEEK_SET);
 }
 
+void ui_browser__add_exit_key(struct ui_browser *self, int key)
+{
+	newtFormAddHotKey(self->form, key);
+}
+
+void ui_browser__add_exit_keys(struct ui_browser *self, int keys[])
+{
+	int i = 0;
+
+	while (keys[i] && i < 64) {
+		ui_browser__add_exit_key(self, keys[i]);
+		++i;
+	}
+}
+
 int ui_browser__show(struct ui_browser *self, const char *title,
 		     const char *helpline, ...)
 {
 	va_list ap;
+	int keys[] = { NEWT_KEY_UP, NEWT_KEY_DOWN, NEWT_KEY_PGUP,
+		       NEWT_KEY_PGDN, NEWT_KEY_HOME, NEWT_KEY_END, ' ',
+		       NEWT_KEY_LEFT, NEWT_KEY_ESCAPE, 'q', CTRL('c'), 0 };
 
 	if (self->form != NULL) {
 		newtFormDestroy(self->form);
@@ -158,7 +174,7 @@ int ui_browser__show(struct ui_browser *self, const char *title,
 	}
 	ui_browser__refresh_dimensions(self);
 	newtCenteredWindow(self->width, self->height, title);
-	self->form = newt_form__new();
+	self->form = newtForm(NULL, NULL, 0);
 	if (self->form == NULL)
 		return -1;
 
@@ -168,13 +184,7 @@ int ui_browser__show(struct ui_browser *self, const char *title,
 	if (self->sb == NULL)
 		return -1;
 
-	newtFormAddHotKey(self->form, NEWT_KEY_UP);
-	newtFormAddHotKey(self->form, NEWT_KEY_DOWN);
-	newtFormAddHotKey(self->form, NEWT_KEY_PGUP);
-	newtFormAddHotKey(self->form, NEWT_KEY_PGDN);
-	newtFormAddHotKey(self->form, NEWT_KEY_HOME);
-	newtFormAddHotKey(self->form, NEWT_KEY_END);
-	newtFormAddHotKey(self->form, ' ');
+	ui_browser__add_exit_keys(self, keys);
 	newtFormAddComponent(self->form, self->sb);
 
 	va_start(ap, helpline);
diff --git a/tools/perf/util/ui/browser.h b/tools/perf/util/ui/browser.h
index 332a675..0dc7e4d 100644
--- a/tools/perf/util/ui/browser.h
+++ b/tools/perf/util/ui/browser.h
@@ -33,6 +33,8 @@ void ui_browser__refresh_dimensions(struct ui_browser *self);
 void ui_browser__reset_index(struct ui_browser *self);
 
 void ui_browser__gotorc(struct ui_browser *self, int y, int x);
+void ui_browser__add_exit_key(struct ui_browser *self, int key);
+void ui_browser__add_exit_keys(struct ui_browser *self, int keys[]);
 int ui_browser__show(struct ui_browser *self, const char *title,
 		     const char *helpline, ...);
 void ui_browser__hide(struct ui_browser *self);
diff --git a/tools/perf/util/ui/browsers/annotate.c b/tools/perf/util/ui/browsers/annotate.c
index a8bc2c0..82b78f9 100644
--- a/tools/perf/util/ui/browsers/annotate.c
+++ b/tools/perf/util/ui/browsers/annotate.c
@@ -142,14 +142,16 @@ static int annotate_browser__run(struct annotate_browser *self)
 	if (ui_browser__show(&self->b, he->ms.sym->name,
 			     "<-, -> or ESC: exit, TAB/shift+TAB: cycle thru samples") < 0)
 		return -1;
-
-	newtFormAddHotKey(self->b.form, NEWT_KEY_LEFT);
-	newtFormAddHotKey(self->b.form, NEWT_KEY_RIGHT);
+	/*
+	 * To allow builtin-annotate to cycle thru multiple symbols by
+	 * examining the exit key for this function.
+	 */
+	ui_browser__add_exit_key(&self->b, NEWT_KEY_RIGHT);
 
 	nd = self->curr_hot;
 	if (nd) {
-		newtFormAddHotKey(self->b.form, NEWT_KEY_TAB);
-		newtFormAddHotKey(self->b.form, NEWT_KEY_UNTAB);
+		int tabs[] = { NEWT_KEY_TAB, NEWT_KEY_UNTAB, 0 };
+		ui_browser__add_exit_keys(&self->b, tabs);
 	}
 
 	while (1) {
diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index 1735c48..b13b978 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -198,6 +198,8 @@ static bool hist_browser__toggle_fold(struct hist_browser *self)
 static int hist_browser__run(struct hist_browser *self, const char *title)
 {
 	int key;
+	int exit_keys[] = { 'a', '?', 'h', 'd', 'D', 't', NEWT_KEY_ENTER,
+			    NEWT_KEY_RIGHT, NEWT_KEY_LEFT, 0, };
 	char str[256], unit;
 	unsigned long nr_events = self->hists->stats.nr_events[PERF_RECORD_SAMPLE];
 
@@ -215,16 +217,7 @@ static int hist_browser__run(struct hist_browser *self, const char *title)
 			     "Press '?' for help on key bindings") < 0)
 		return -1;
 
-	newtFormAddHotKey(self->b.form, 'a');
-	newtFormAddHotKey(self->b.form, '?');
-	newtFormAddHotKey(self->b.form, 'h');
-	newtFormAddHotKey(self->b.form, 'd');
-	newtFormAddHotKey(self->b.form, 'D');
-	newtFormAddHotKey(self->b.form, 't');
-
-	newtFormAddHotKey(self->b.form, NEWT_KEY_LEFT);
-	newtFormAddHotKey(self->b.form, NEWT_KEY_RIGHT);
-	newtFormAddHotKey(self->b.form, NEWT_KEY_ENTER);
+	ui_browser__add_exit_keys(&self->b, exit_keys);
 
 	while (1) {
 		key = ui_browser__run(&self->b);
diff --git a/tools/perf/util/ui/browsers/map.c b/tools/perf/util/ui/browsers/map.c
index 16b7d70..1bf0979 100644
--- a/tools/perf/util/ui/browsers/map.c
+++ b/tools/perf/util/ui/browsers/map.c
@@ -1,6 +1,5 @@
 #include "../libslang.h"
 #include <elf.h>
-#include <newt.h>
 #include <sys/ttydefaults.h>
 #include <ctype.h>
 #include <string.h>
@@ -106,13 +105,8 @@ static int map_browser__run(struct map_browser *self)
 			     verbose ? "" : "restart with -v to use") < 0)
 		return -1;
 
-	newtFormAddHotKey(self->b.form, NEWT_KEY_LEFT);
-	newtFormAddHotKey(self->b.form, NEWT_KEY_ESCAPE);
-	newtFormAddHotKey(self->b.form, 'Q');
-	newtFormAddHotKey(self->b.form, 'q');
-	newtFormAddHotKey(self->b.form, CTRL('c'));
 	if (verbose)
-		newtFormAddHotKey(self->b.form, '/');
+		ui_browser__add_exit_key(&self->b, '/');
 
 	while (1) {
 		key = ui_browser__run(&self->b);
diff --git a/tools/perf/util/ui/util.c b/tools/perf/util/ui/util.c
index 04600e2..9706d9d 100644
--- a/tools/perf/util/ui/util.c
+++ b/tools/perf/util/ui/util.c
@@ -11,8 +11,6 @@
 #include "helpline.h"
 #include "util.h"
 
-newtComponent newt_form__new(void);
-
 static void newt_form__set_exit_keys(newtComponent self)
 {
 	newtFormAddHotKey(self, NEWT_KEY_LEFT);
@@ -22,7 +20,7 @@ static void newt_form__set_exit_keys(newtComponent self)
 	newtFormAddHotKey(self, CTRL('c'));
 }
 
-newtComponent newt_form__new(void)
+static newtComponent newt_form__new(void)
 {
 	newtComponent self = newtForm(NULL, NULL, 0);
 	if (self)
