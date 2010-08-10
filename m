Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757929Ab0HJUQJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 16:16:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:35977 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757904Ab0HJUP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 16:15:58 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/9] perf ui: Shorten ui_browser member names
Date: Tue, 10 Aug 2010 17:15:31 -0300
Message-Id: <1281471339-10878-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1281471339-10878-1-git-send-email-acme@infradead.org>
References: <1281471339-10878-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/newt.c       |   36 +++++++++++++-------------
 tools/perf/util/ui/browser.c |   57 ++++++++++++++++++++---------------------
 tools/perf/util/ui/browser.h |    6 ++--
 3 files changed, 49 insertions(+), 50 deletions(-)

diff --git a/tools/perf/util/newt.c b/tools/perf/util/newt.c
index 266a9e0..9768be3 100644
--- a/tools/perf/util/newt.c
+++ b/tools/perf/util/newt.c
@@ -450,8 +450,8 @@ static int map_browser__search(struct map_browser *self)
 	if (sym != NULL) {
 		u32 *idx = symbol__browser_index(sym);
 			
-		self->b.first_visible_entry = &sym->rb_node;
-		self->b.index = self->b.first_visible_entry_idx = *idx;
+		self->b.top = &sym->rb_node;
+		self->b.index = self->b.top_idx = *idx;
 	} else
 		ui_helpline__fpush("%s not found!", target);
 
@@ -967,7 +967,7 @@ static int hist_browser__show_callchain_node_rb_tree(struct hist_browser *self,
 			}
 
 			SLsmg_set_color(color);
-			SLsmg_gotorc(self->b.top + row, self->b.left);
+			SLsmg_gotorc(self->b.y + row, self->b.x);
 			slsmg_write_nstring(" ", offset + extra_offset);
 			slsmg_printf("%c ", folded_sign);
 			slsmg_write_nstring(str, width);
@@ -1030,7 +1030,7 @@ static int hist_browser__show_callchain_node(struct hist_browser *self,
 		}
 
 		s = callchain_list__sym_name(chain, ipstr, sizeof(ipstr));
-		SLsmg_gotorc(self->b.top + row, self->b.left);
+		SLsmg_gotorc(self->b.y + row, self->b.x);
 		SLsmg_set_color(color);
 		slsmg_write_nstring(" ", offset);
 		slsmg_printf("%c ", folded_sign);
@@ -1110,7 +1110,7 @@ static int hist_browser__show_entry(struct hist_browser *self,
 		}
 
 		SLsmg_set_color(color);
-		SLsmg_gotorc(self->b.top + row, self->b.left);
+		SLsmg_gotorc(self->b.y + row, self->b.x);
 		if (symbol_conf.use_callchain) {
 			slsmg_printf("%c ", folded_sign);
 			width -= 2;
@@ -1138,10 +1138,10 @@ static unsigned int hist_browser__refresh(struct ui_browser *self)
 	struct rb_node *nd;
 	struct hist_browser *hb = container_of(self, struct hist_browser, b);
 
-	if (self->first_visible_entry == NULL)
-		self->first_visible_entry = rb_first(&hb->hists->entries);
+	if (self->top == NULL)
+		self->top = rb_first(&hb->hists->entries);
 
-	for (nd = self->first_visible_entry; nd; nd = rb_next(nd)) {
+	for (nd = self->top; nd; nd = rb_next(nd)) {
 		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
 
 		if (h->filtered)
@@ -1244,7 +1244,7 @@ static void ui_browser__hists_seek(struct ui_browser *self,
 		nd = hists__filter_entries(rb_first(self->entries));
 		break;
 	case SEEK_CUR:
-		nd = self->first_visible_entry;
+		nd = self->top;
 		goto do_offset;
 	case SEEK_END:
 		nd = hists__filter_prev_entries(rb_last(self->entries));
@@ -1258,7 +1258,7 @@ static void ui_browser__hists_seek(struct ui_browser *self,
 	 * Moves not relative to the first visible entry invalidates its
 	 * row_offset:
 	 */
-	h = rb_entry(self->first_visible_entry, struct hist_entry, rb_node);
+	h = rb_entry(self->top, struct hist_entry, rb_node);
 	h->row_offset = 0;
 
 	/*
@@ -1286,7 +1286,7 @@ do_offset:
 				} else {
 					h->row_offset += offset;
 					offset = 0;
-					self->first_visible_entry = nd;
+					self->top = nd;
 					break;
 				}
 			}
@@ -1294,7 +1294,7 @@ do_offset:
 			if (nd == NULL)
 				break;
 			--offset;
-			self->first_visible_entry = nd;
+			self->top = nd;
 		} while (offset != 0);
 	} else if (offset < 0) {
 		while (1) {
@@ -1307,7 +1307,7 @@ do_offset:
 					} else {
 						h->row_offset += offset;
 						offset = 0;
-						self->first_visible_entry = nd;
+						self->top = nd;
 						break;
 					}
 				} else {
@@ -1317,7 +1317,7 @@ do_offset:
 					} else {
 						h->row_offset = h->nr_rows + offset;
 						offset = 0;
-						self->first_visible_entry = nd;
+						self->top = nd;
 						break;
 					}
 				}
@@ -1327,7 +1327,7 @@ do_offset:
 			if (nd == NULL)
 				break;
 			++offset;
-			self->first_visible_entry = nd;
+			self->top = nd;
 			if (offset == 0) {
 				/*
 				 * Last unfiltered hist_entry, check if it is
@@ -1342,7 +1342,7 @@ do_offset:
 			first = false;
 		}
 	} else {
-		self->first_visible_entry = nd;
+		self->top = nd;
 		h = rb_entry(nd, struct hist_entry, rb_node);
 		h->row_offset = 0;
 	}
@@ -1463,7 +1463,7 @@ static int hist_browser__run(struct hist_browser *self, const char *title,
 		switch (es->u.key) {
 		case 'd': { /* Debug */
 			static int seq;
-			struct hist_entry *h = rb_entry(self->b.first_visible_entry,
+			struct hist_entry *h = rb_entry(self->b.top,
 							struct hist_entry, rb_node);
 			ui_helpline__pop();
 			ui_helpline__fpush("%d: nr_ent=(%d,%d), height=%d, idx=%d, fve: idx=%d, row_off=%d, nrows=%d",
@@ -1471,7 +1471,7 @@ static int hist_browser__run(struct hist_browser *self, const char *title,
 					   self->hists->nr_entries,
 					   self->b.height,
 					   self->b.index,
-					   self->b.first_visible_entry_idx,
+					   self->b.top_idx,
 					   h->row_offset, h->nr_rows);
 		}
 			continue;
diff --git a/tools/perf/util/ui/browser.c b/tools/perf/util/ui/browser.c
index 0b2b930..edbb7dd 100644
--- a/tools/perf/util/ui/browser.c
+++ b/tools/perf/util/ui/browser.c
@@ -49,7 +49,7 @@ void ui_browser__list_head_seek(struct ui_browser *self, off_t offset, int whenc
 		pos = head->next;
 		break;
 	case SEEK_CUR:
-		pos = self->first_visible_entry;
+		pos = self->top;
 		break;
 	case SEEK_END:
 		pos = head->prev;
@@ -66,7 +66,7 @@ void ui_browser__list_head_seek(struct ui_browser *self, off_t offset, int whenc
 			pos = pos->prev;
 	}
 
-	self->first_visible_entry = pos;
+	self->top = pos;
 }
 
 void ui_browser__rb_tree_seek(struct ui_browser *self, off_t offset, int whence)
@@ -79,7 +79,7 @@ void ui_browser__rb_tree_seek(struct ui_browser *self, off_t offset, int whence)
 		nd = rb_first(root);
 		break;
 	case SEEK_CUR:
-		nd = self->first_visible_entry;
+		nd = self->top;
 		break;
 	case SEEK_END:
 		nd = rb_last(root);
@@ -96,7 +96,7 @@ void ui_browser__rb_tree_seek(struct ui_browser *self, off_t offset, int whence)
 			nd = rb_prev(nd);
 	}
 
-	self->first_visible_entry = nd;
+	self->top = nd;
 }
 
 unsigned int ui_browser__rb_tree_refresh(struct ui_browser *self)
@@ -104,13 +104,13 @@ unsigned int ui_browser__rb_tree_refresh(struct ui_browser *self)
 	struct rb_node *nd;
 	int row = 0;
 
-	if (self->first_visible_entry == NULL)
-                self->first_visible_entry = rb_first(self->entries);
+	if (self->top == NULL)
+                self->top = rb_first(self->entries);
 
-	nd = self->first_visible_entry;
+	nd = self->top;
 
 	while (nd != NULL) {
-		SLsmg_gotorc(self->top + row, self->left);
+		SLsmg_gotorc(self->y + row, self->x);
 		self->write(self, nd, row);
 		if (++row == self->height)
 			break;
@@ -122,7 +122,7 @@ unsigned int ui_browser__rb_tree_refresh(struct ui_browser *self)
 
 bool ui_browser__is_current_entry(struct ui_browser *self, unsigned row)
 {
-	return (self->first_visible_entry_idx + row) == self->index;
+	return self->top_idx + row == self->index;
 }
 
 void ui_browser__refresh_dimensions(struct ui_browser *self)
@@ -135,13 +135,13 @@ void ui_browser__refresh_dimensions(struct ui_browser *self)
 	self->height = rows - 5;
 	if (self->height > self->nr_entries)
 		self->height = self->nr_entries;
-	self->top  = (rows - self->height) / 2;
-	self->left = (cols - self->width) / 2;
+	self->y  = (rows - self->height) / 2;
+	self->x = (cols - self->width) / 2;
 }
 
 void ui_browser__reset_index(struct ui_browser *self)
 {
-	self->index = self->first_visible_entry_idx = 0;
+	self->index = self->top_idx = 0;
 	self->seek(self, 0, SEEK_SET);
 }
 
@@ -180,7 +180,7 @@ int ui_browser__refresh(struct ui_browser *self)
 	newtScrollbarSet(self->sb, self->index, self->nr_entries - 1);
 	row = self->refresh(self);
 	SLsmg_set_color(HE_COLORSET_NORMAL);
-	SLsmg_fill_region(self->top + row, self->left,
+	SLsmg_fill_region(self->y + row, self->x,
 			  self->height - row, self->width, ' ');
 
 	return 0;
@@ -205,8 +205,8 @@ int ui_browser__run(struct ui_browser *self, struct newtExitStruct *es)
 			if (self->index == self->nr_entries - 1)
 				break;
 			++self->index;
-			if (self->index == self->first_visible_entry_idx + self->height) {
-				++self->first_visible_entry_idx;
+			if (self->index == self->top_idx + self->height) {
+				++self->top_idx;
 				self->seek(self, +1, SEEK_CUR);
 			}
 			break;
@@ -214,34 +214,34 @@ int ui_browser__run(struct ui_browser *self, struct newtExitStruct *es)
 			if (self->index == 0)
 				break;
 			--self->index;
-			if (self->index < self->first_visible_entry_idx) {
-				--self->first_visible_entry_idx;
+			if (self->index < self->top_idx) {
+				--self->top_idx;
 				self->seek(self, -1, SEEK_CUR);
 			}
 			break;
 		case NEWT_KEY_PGDN:
 		case ' ':
-			if (self->first_visible_entry_idx + self->height > self->nr_entries - 1)
+			if (self->top_idx + self->height > self->nr_entries - 1)
 				break;
 
 			offset = self->height;
 			if (self->index + offset > self->nr_entries - 1)
 				offset = self->nr_entries - 1 - self->index;
 			self->index += offset;
-			self->first_visible_entry_idx += offset;
+			self->top_idx += offset;
 			self->seek(self, +offset, SEEK_CUR);
 			break;
 		case NEWT_KEY_PGUP:
-			if (self->first_visible_entry_idx == 0)
+			if (self->top_idx == 0)
 				break;
 
-			if (self->first_visible_entry_idx < self->height)
-				offset = self->first_visible_entry_idx;
+			if (self->top_idx < self->height)
+				offset = self->top_idx;
 			else
 				offset = self->height;
 
 			self->index -= offset;
-			self->first_visible_entry_idx -= offset;
+			self->top_idx -= offset;
 			self->seek(self, -offset, SEEK_CUR);
 			break;
 		case NEWT_KEY_HOME:
@@ -253,7 +253,7 @@ int ui_browser__run(struct ui_browser *self, struct newtExitStruct *es)
 				offset = self->nr_entries - 1;
 
 			self->index = self->nr_entries - 1;
-			self->first_visible_entry_idx = self->index - offset;
+			self->top_idx = self->index - offset;
 			self->seek(self, -offset, SEEK_END);
 			break;
 		default:
@@ -271,14 +271,13 @@ unsigned int ui_browser__list_head_refresh(struct ui_browser *self)
 	struct list_head *head = self->entries;
 	int row = 0;
 
-	if (self->first_visible_entry == NULL ||
-	    self->first_visible_entry == self->entries)
-                self->first_visible_entry = head->next;
+	if (self->top == NULL || self->top == self->entries)
+                self->top = head->next;
 
-	pos = self->first_visible_entry;
+	pos = self->top;
 
 	list_for_each_from(pos, head) {
-		SLsmg_gotorc(self->top + row, self->left);
+		SLsmg_gotorc(self->y + row, self->x);
 		self->write(self, pos, row);
 		if (++row == self->height)
 			break;
diff --git a/tools/perf/util/ui/browser.h b/tools/perf/util/ui/browser.h
index bcc4391..8eed24c 100644
--- a/tools/perf/util/ui/browser.h
+++ b/tools/perf/util/ui/browser.h
@@ -13,9 +13,9 @@
 
 struct ui_browser {
 	newtComponent form, sb;
-	u64	      index, first_visible_entry_idx;
-	void	      *first_visible_entry, *entries;
-	u16	      top, left, width, height;
+	u64	      index, top_idx;
+	void	      *top, *entries;
+	u16	      y, x, width, height;
 	void	      *priv;
 	unsigned int  (*refresh)(struct ui_browser *self);
 	void	      (*write)(struct ui_browser *self, void *entry, int row);
-- 
1.6.2.5

