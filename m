Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762406Ab0HGBeb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 21:34:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:40203 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821Ab0HGBeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 21:34:25 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 3/4] perf tui: Introduce list_head based generic ui_browser refresh routine
Date: Fri,  6 Aug 2010 22:34:08 -0300
Message-Id: <1281144849-22896-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1281144849-22896-1-git-send-email-acme@infradead.org>
References: <1281144849-22896-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

So that building other browser based on structures linked via a linked
list can be as easy as it is already for the ones linked via an rb_tree.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/include/linux/list.h |    8 +++++
 tools/perf/util/newt.c               |   49 ++++++++++++++++-----------------
 2 files changed, 32 insertions(+), 25 deletions(-)

diff --git a/tools/perf/util/include/linux/list.h b/tools/perf/util/include/linux/list.h
index dbe4b81..f5ca26e 100644
--- a/tools/perf/util/include/linux/list.h
+++ b/tools/perf/util/include/linux/list.h
@@ -15,4 +15,12 @@ static inline void list_del_range(struct list_head *begin,
 	begin->prev->next = end->next;
 	end->next->prev = begin->prev;
 }
+
+/**
+ * list_for_each_from	-	iterate over a list from one of its nodes
+ * @pos:  the &struct list_head to use as a loop cursor, from where to start
+ * @head: the head for your list.
+ */
+#define list_for_each_from(pos, head) \
+	for (; prefetch(pos->next), pos != (head); pos = pos->next)
 #endif
diff --git a/tools/perf/util/newt.c b/tools/perf/util/newt.c
index e2deae0..37fe8eb 100644
--- a/tools/perf/util/newt.c
+++ b/tools/perf/util/newt.c
@@ -456,20 +456,24 @@ static int ui_browser__show(struct ui_browser *self, const char *title)
 	return 0;
 }
 
-static int objdump_line__show(struct objdump_line *self, struct list_head *head,
-			      int width, struct hist_entry *he, int len,
-			      bool current_entry)
+static void annotate_browser__write(struct ui_browser *self, void *entry, int row)
 {
-	if (self->offset != -1) {
+	struct objdump_line *ol = rb_entry(entry, struct objdump_line, node);
+	bool current_entry = ui_browser__is_current_entry(self, row);
+	int width = self->width;
+
+	if (ol->offset != -1) {
+		struct hist_entry *he = self->priv;
 		struct symbol *sym = he->ms.sym;
+		int len = he->ms.sym->end - he->ms.sym->start;
 		unsigned int hits = 0;
 		double percent = 0.0;
 		int color;
 		struct sym_priv *priv = symbol__priv(sym);
 		struct sym_ext *sym_ext = priv->ext;
 		struct sym_hist *h = priv->hist;
-		s64 offset = self->offset;
-		struct objdump_line *next = objdump__get_next_ip_line(head, self);
+		s64 offset = ol->offset;
+		struct objdump_line *next = objdump__get_next_ip_line(self->entries, ol);
 
 		while (offset < (s64)len &&
 		       (next == NULL || offset < next->offset)) {
@@ -497,12 +501,10 @@ static int objdump_line__show(struct objdump_line *self, struct list_head *head,
 
 	SLsmg_write_char(':');
 	slsmg_write_nstring(" ", 8);
-	if (!*self->line)
+	if (!*ol->line)
 		slsmg_write_nstring(" ", width - 18);
 	else
-		slsmg_write_nstring(self->line, width - 18);
-
-	return 0;
+		slsmg_write_nstring(ol->line, width - 18);
 }
 
 static int ui_browser__refresh(struct ui_browser *self)
@@ -607,24 +609,20 @@ static char *callchain_list__sym_name(struct callchain_list *self,
 	return bf;
 }
 
-static unsigned int hist_entry__annotate_browser_refresh(struct ui_browser *self)
+static unsigned int ui_browser__list_head_refresh(struct ui_browser *self)
 {
-	struct objdump_line *pos;
+	struct list_head *pos;
 	struct list_head *head = self->entries;
-	struct hist_entry *he = self->priv;
 	int row = 0;
-	int len = he->ms.sym->end - he->ms.sym->start;
 
 	if (self->first_visible_entry == NULL || self->first_visible_entry == self->entries)
                 self->first_visible_entry = head->next;
 
-	pos = list_entry(self->first_visible_entry, struct objdump_line, node);
+	pos = self->first_visible_entry;
 
-	list_for_each_entry_from(pos, head, node) {
-		bool current_entry = ui_browser__is_current_entry(self, row);
+	list_for_each_from(pos, head) {
 		SLsmg_gotorc(self->top + row, self->left);
-		objdump_line__show(pos, head, self->width,
-				   he, len, current_entry);
+		self->write(self, pos, row);
 		if (++row == self->height)
 			break;
 	}
@@ -634,10 +632,16 @@ static unsigned int hist_entry__annotate_browser_refresh(struct ui_browser *self
 
 int hist_entry__tui_annotate(struct hist_entry *self)
 {
-	struct ui_browser browser;
 	struct newtExitStruct es;
 	struct objdump_line *pos, *n;
 	LIST_HEAD(head);
+	struct ui_browser browser = {
+		.entries = &head,
+		.refresh = ui_browser__list_head_refresh,
+		.seek	 = ui_browser__list_head_seek,
+		.write	 = annotate_browser__write,
+		.priv	 = self,
+	};
 	int ret;
 
 	if (self->ms.sym == NULL)
@@ -653,11 +657,6 @@ int hist_entry__tui_annotate(struct hist_entry *self)
 
 	ui_helpline__push("Press <- or ESC to exit");
 
-	memset(&browser, 0, sizeof(browser));
-	browser.entries	= &head;
-	browser.refresh = hist_entry__annotate_browser_refresh;
-	browser.seek	= ui_browser__list_head_seek;
-	browser.priv = self;
 	list_for_each_entry(pos, &head, node) {
 		size_t line_len = strlen(pos->line);
 		if (browser.width < line_len)
-- 
1.6.2.5

