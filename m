Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756327Ab0FYN74 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 09:59:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:51797 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756248Ab0FYN7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 09:59:46 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Stephane Eranian <eranian@google.com>, Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 3/6] perf ui: Introduce ui_browser->seek to support multiple list structures
Date: Fri, 25 Jun 2010 10:59:23 -0300
Message-Id: <1277474366-7958-4-git-send-email-acme@infradead.org>
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

So that we can use the ui_browser on things like an rb_tree, etc.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/newt.c |   69 ++++++++++++++++++++++++++++++------------------
 1 files changed, 43 insertions(+), 26 deletions(-)

diff --git a/tools/perf/util/newt.c b/tools/perf/util/newt.c
index 1e774e7..0ffc828 100644
--- a/tools/perf/util/newt.c
+++ b/tools/perf/util/newt.c
@@ -267,9 +267,42 @@ struct ui_browser {
 	void		*first_visible_entry, *entries;
 	u16		top, left, width, height;
 	void		*priv;
+	void		(*seek)(struct ui_browser *self,
+				off_t offset, int whence);
 	u32		nr_entries;
 };
 
+static void ui_browser__list_head_seek(struct ui_browser *self,
+				       off_t offset, int whence)
+{
+	struct list_head *head = self->entries;
+	struct list_head *pos;
+
+	switch (whence) {
+	case SEEK_SET:
+		pos = head->next;
+		break;
+	case SEEK_CUR:
+		pos = self->first_visible_entry;
+		break;
+	case SEEK_END:
+		pos = head->prev;
+		break;
+	default:
+		return;
+	}
+
+	if (offset > 0) {
+		while (offset-- != 0)
+			pos = pos->next;
+	} else {
+		while (offset++ != 0)
+			pos = pos->prev;
+	}
+
+	self->first_visible_entry = pos;
+}
+
 static bool ui_browser__is_current_entry(struct ui_browser *self, unsigned row)
 {
 	return (self->first_visible_entry_idx + row) == self->index;
@@ -292,7 +325,7 @@ static void ui_browser__refresh_dimensions(struct ui_browser *self)
 static void ui_browser__reset_index(struct ui_browser *self)
 {
 	self->index = self->first_visible_entry_idx = 0;
-	self->first_visible_entry = NULL;
+	self->seek(self, 0, SEEK_SET);
 }
 
 static int objdump_line__show(struct objdump_line *self, struct list_head *head,
@@ -408,7 +441,7 @@ static int ui_browser__run(struct ui_browser *self, const char *title,
 	newtFormAddComponent(self->form, self->sb);
 
 	while (1) {
-		unsigned int offset;
+		off_t offset;
 
 		newtFormRun(self->form, es);
 
@@ -422,9 +455,8 @@ static int ui_browser__run(struct ui_browser *self, const char *title,
 				break;
 			++self->index;
 			if (self->index == self->first_visible_entry_idx + self->height) {
-				struct list_head *pos = self->first_visible_entry;
 				++self->first_visible_entry_idx;
-				self->first_visible_entry = pos->next;
+				self->seek(self, +1, SEEK_CUR);
 			}
 			break;
 		case NEWT_KEY_UP:
@@ -432,9 +464,8 @@ static int ui_browser__run(struct ui_browser *self, const char *title,
 				break;
 			--self->index;
 			if (self->index < self->first_visible_entry_idx) {
-				struct list_head *pos = self->first_visible_entry;
 				--self->first_visible_entry_idx;
-				self->first_visible_entry = pos->prev;
+				self->seek(self, -1, SEEK_CUR);
 			}
 			break;
 		case NEWT_KEY_PGDN:
@@ -447,12 +478,7 @@ static int ui_browser__run(struct ui_browser *self, const char *title,
 				offset = self->nr_entries - 1 - self->index;
 			self->index += offset;
 			self->first_visible_entry_idx += offset;
-
-			while (offset--) {
-				struct list_head *pos = self->first_visible_entry;
-				self->first_visible_entry = pos->next;
-			}
-
+			self->seek(self, +offset, SEEK_CUR);
 			break;
 		case NEWT_KEY_PGUP:
 			if (self->first_visible_entry_idx == 0)
@@ -465,29 +491,19 @@ static int ui_browser__run(struct ui_browser *self, const char *title,
 
 			self->index -= offset;
 			self->first_visible_entry_idx -= offset;
-
-			while (offset--) {
-				struct list_head *pos = self->first_visible_entry;
-				self->first_visible_entry = pos->prev;
-			}
+			self->seek(self, -offset, SEEK_CUR);
 			break;
 		case NEWT_KEY_HOME:
 			ui_browser__reset_index(self);
 			break;
-		case NEWT_KEY_END: {
-			struct list_head *head = self->entries;
+		case NEWT_KEY_END:
 			offset = self->height - 1;
 
 			if (offset > self->nr_entries)
 				offset = self->nr_entries;
 
 			self->index = self->first_visible_entry_idx = self->nr_entries - 1 - offset;
-			self->first_visible_entry = head->prev;
-			while (offset-- != 0) {
-				struct list_head *pos = self->first_visible_entry;
-				self->first_visible_entry = pos->prev;
-			}
-		}
+			self->seek(self, -offset, SEEK_END);
 			break;
 		case NEWT_KEY_RIGHT:
 		case NEWT_KEY_LEFT:
@@ -706,7 +722,8 @@ int hist_entry__tui_annotate(struct hist_entry *self)
 	ui_helpline__push("Press <- or ESC to exit");
 
 	memset(&browser, 0, sizeof(browser));
-	browser.entries = &head;
+	browser.entries		= &head;
+	browser.seek		= ui_browser__list_head_seek;
 	browser.priv = self;
 	list_for_each_entry(pos, &head, node) {
 		size_t line_len = strlen(pos->line);
-- 
1.6.2.5

