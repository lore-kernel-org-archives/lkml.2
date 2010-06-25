Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241Ab0FYN7p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 09:59:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:51793 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756061Ab0FYN7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 09:59:40 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Stephane Eranian <eranian@google.com>, Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 4/6] perf ui: Separate showing the entries from running the browser
Date: Fri, 25 Jun 2010 10:59:24 -0300
Message-Id: <1277474366-7958-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1277474366-7958-1-git-send-email-acme@infradead.org>
References: <1277474366-7958-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Another patch eroding the changes I had to move to a tree widget that
doesn't requires adding all entries in an existing list/tree structure
to a generic tree widget, but instead allows traversing just the entries
that should appear on the screen on a given moment.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/newt.c |   60 +++++++++++++++++++++++------------------------
 1 files changed, 29 insertions(+), 31 deletions(-)

diff --git a/tools/perf/util/newt.c b/tools/perf/util/newt.c
index 0ffc828..9fa5b20 100644
--- a/tools/perf/util/newt.c
+++ b/tools/perf/util/newt.c
@@ -328,6 +328,32 @@ static void ui_browser__reset_index(struct ui_browser *self)
 	self->seek(self, 0, SEEK_SET);
 }
 
+static int ui_browser__show(struct ui_browser *self, const char *title)
+{
+	if (self->form != NULL)
+		return 0;
+	ui_browser__refresh_dimensions(self);
+	newtCenteredWindow(self->width + 2, self->height, title);
+	self->form = newt_form__new();
+	if (self->form == NULL)
+		return -1;
+
+	self->sb = newtVerticalScrollbar(self->width + 1, 0, self->height,
+					 HE_COLORSET_NORMAL,
+					 HE_COLORSET_SELECTED);
+	if (self->sb == NULL)
+		return -1;
+
+	newtFormAddHotKey(self->form, NEWT_KEY_UP);
+	newtFormAddHotKey(self->form, NEWT_KEY_DOWN);
+	newtFormAddHotKey(self->form, NEWT_KEY_PGUP);
+	newtFormAddHotKey(self->form, NEWT_KEY_PGDN);
+	newtFormAddHotKey(self->form, NEWT_KEY_HOME);
+	newtFormAddHotKey(self->form, NEWT_KEY_END);
+	newtFormAddComponent(self->form, self->sb);
+	return 0;
+}
+
 static int objdump_line__show(struct objdump_line *self, struct list_head *head,
 			      int width, struct hist_entry *he, int len,
 			      bool current_entry)
@@ -406,39 +432,10 @@ static int ui_browser__refresh_entries(struct ui_browser *self)
 	return 0;
 }
 
-static int ui_browser__run(struct ui_browser *self, const char *title,
-			   struct newtExitStruct *es)
+static int ui_browser__run(struct ui_browser *self, struct newtExitStruct *es)
 {
-	if (self->form) {
-		newtFormDestroy(self->form);
-		newtPopWindow();
-	}
-
-	ui_browser__refresh_dimensions(self);
-	newtCenteredWindow(self->width + 2, self->height, title);
-	self->form = newt_form__new();
-	if (self->form == NULL)
-		return -1;
-
-	self->sb = newtVerticalScrollbar(self->width + 1, 0, self->height,
-					 HE_COLORSET_NORMAL,
-					 HE_COLORSET_SELECTED);
-	if (self->sb == NULL)
-		return -1;
-
-	newtFormAddHotKey(self->form, NEWT_KEY_UP);
-	newtFormAddHotKey(self->form, NEWT_KEY_DOWN);
-	newtFormAddHotKey(self->form, NEWT_KEY_PGUP);
-	newtFormAddHotKey(self->form, NEWT_KEY_PGDN);
-	newtFormAddHotKey(self->form, ' ');
-	newtFormAddHotKey(self->form, NEWT_KEY_HOME);
-	newtFormAddHotKey(self->form, NEWT_KEY_END);
-	newtFormAddHotKey(self->form, NEWT_KEY_TAB);
-	newtFormAddHotKey(self->form, NEWT_KEY_RIGHT);
-
 	if (ui_browser__refresh_entries(self) < 0)
 		return -1;
-	newtFormAddComponent(self->form, self->sb);
 
 	while (1) {
 		off_t offset;
@@ -733,7 +730,8 @@ int hist_entry__tui_annotate(struct hist_entry *self)
 	}
 
 	browser.width += 18; /* Percentage */
-	ret = ui_browser__run(&browser, self->ms.sym->name, &es);
+	ui_browser__show(&browser, self->ms.sym->name);
+	ui_browser__run(&browser, &es);
 	newtFormDestroy(browser.form);
 	newtPopWindow();
 	list_for_each_entry_safe(pos, n, &head, node) {
-- 
1.6.2.5

