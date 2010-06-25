Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756359Ab0FYOAv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 10:00:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:51792 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755401Ab0FYN7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 09:59:40 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Stephane Eranian <eranian@google.com>, Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 5/6] perf ui: Move objdump_line specific stuff out of ui_browser
Date: Fri, 25 Jun 2010 10:59:25 -0300
Message-Id: <1277474366-7958-6-git-send-email-acme@infradead.org>
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

By adding a ui_browser->refresh_entries() pure virtual member.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/newt.c |   49 +++++++++++++++++++++++++++++------------------
 1 files changed, 30 insertions(+), 19 deletions(-)

diff --git a/tools/perf/util/newt.c b/tools/perf/util/newt.c
index 9fa5b20..7bdbfd3 100644
--- a/tools/perf/util/newt.c
+++ b/tools/perf/util/newt.c
@@ -267,6 +267,7 @@ struct ui_browser {
 	void		*first_visible_entry, *entries;
 	u16		top, left, width, height;
 	void		*priv;
+	unsigned int	(*refresh_entries)(struct ui_browser *self);
 	void		(*seek)(struct ui_browser *self,
 				off_t offset, int whence);
 	u32		nr_entries;
@@ -405,26 +406,10 @@ static int objdump_line__show(struct objdump_line *self, struct list_head *head,
 
 static int ui_browser__refresh_entries(struct ui_browser *self)
 {
-	struct objdump_line *pos;
-	struct list_head *head = self->entries;
-	struct hist_entry *he = self->priv;
-	int row = 0;
-	int len = he->ms.sym->end - he->ms.sym->start;
-
-	if (self->first_visible_entry == NULL || self->first_visible_entry == self->entries)
-                self->first_visible_entry = head->next;
-
-	pos = list_entry(self->first_visible_entry, struct objdump_line, node);
-
-	list_for_each_entry_from(pos, head, node) {
-		bool current_entry = ui_browser__is_current_entry(self, row);
-		SLsmg_gotorc(self->top + row, self->left);
-		objdump_line__show(pos, head, self->width,
-				   he, len, current_entry);
-		if (++row == self->height)
-			break;
-	}
+	int row;
 
+	newtScrollbarSet(self->sb, self->index, self->nr_entries - 1);
+	row = self->refresh_entries(self);
 	SLsmg_set_color(HE_COLORSET_NORMAL);
 	SLsmg_fill_region(self->top + row, self->left,
 			  self->height - row, self->width, ' ');
@@ -557,6 +542,31 @@ static char *callchain_list__sym_name(struct callchain_list *self,
 	return bf;
 }
 
+static unsigned int hist_entry__annotate_browser_refresh(struct ui_browser *self)
+{
+	struct objdump_line *pos;
+	struct list_head *head = self->entries;
+	struct hist_entry *he = self->priv;
+	int row = 0;
+	int len = he->ms.sym->end - he->ms.sym->start;
+
+	if (self->first_visible_entry == NULL || self->first_visible_entry == self->entries)
+                self->first_visible_entry = head->next;
+
+	pos = list_entry(self->first_visible_entry, struct objdump_line, node);
+
+	list_for_each_entry_from(pos, head, node) {
+		bool current_entry = ui_browser__is_current_entry(self, row);
+		SLsmg_gotorc(self->top + row, self->left);
+		objdump_line__show(pos, head, self->width,
+				   he, len, current_entry);
+		if (++row == self->height)
+			break;
+	}
+
+	return row;
+}
+
 static void __callchain__append_graph_browser(struct callchain_node *self,
 					      newtComponent tree, u64 total,
 					      int *indexes, int depth)
@@ -720,6 +730,7 @@ int hist_entry__tui_annotate(struct hist_entry *self)
 
 	memset(&browser, 0, sizeof(browser));
 	browser.entries		= &head;
+	browser.refresh_entries = hist_entry__annotate_browser_refresh;
 	browser.seek		= ui_browser__list_head_seek;
 	browser.priv = self;
 	list_for_each_entry(pos, &head, node) {
-- 
1.6.2.5

