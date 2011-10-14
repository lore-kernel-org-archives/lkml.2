Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043Ab1JNS2v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 14:28:51 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55615 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398Ab1JNS2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 14:28:03 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 3/5] perf ui browser: Add filter method
Date: Fri, 14 Oct 2011 15:27:51 -0300
Message-Id: <1318616873-26739-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1318616873-26739-1-git-send-email-acme@infradead.org>
References: <1318616873-26739-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Its becoming common to allow the user to filter out parts of the data
structure being browsed, like already done in the hists browser and in
the annotate browser in the next commit, so provide it directly in the
ui_browser class list_head helpers.

More work required to move the equivalent routines found now in the
hists browser to the rb_tree helpers.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-jk7danyt1d9ji4e3o2xuthpn@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/ui/browser.c |   51 ++++++++++++++++++++++++++++++++++-------
 tools/perf/util/ui/browser.h |    1 +
 2 files changed, 43 insertions(+), 9 deletions(-)

diff --git a/tools/perf/util/ui/browser.c b/tools/perf/util/ui/browser.c
index 078ceaf..a54b926 100644
--- a/tools/perf/util/ui/browser.c
+++ b/tools/perf/util/ui/browser.c
@@ -42,31 +42,62 @@ void ui_browser__gotorc(struct ui_browser *self, int y, int x)
 	SLsmg_gotorc(self->y + y, self->x + x);
 }
 
+static struct list_head *
+ui_browser__list_head_filter_entries(struct ui_browser *browser,
+				     struct list_head *pos)
+{
+	do {
+		if (!browser->filter || !browser->filter(browser, pos))
+			return pos;
+		pos = pos->next;
+	} while (pos != browser->entries);
+
+	return NULL;
+}
+
+static struct list_head *
+ui_browser__list_head_filter_prev_entries(struct ui_browser *browser,
+					  struct list_head *pos)
+{
+	do {
+		if (!browser->filter || !browser->filter(browser, pos))
+			return pos;
+		pos = pos->prev;
+	} while (pos != browser->entries);
+
+	return NULL;
+}
+
 void ui_browser__list_head_seek(struct ui_browser *self, off_t offset, int whence)
 {
 	struct list_head *head = self->entries;
 	struct list_head *pos;
 
+	if (self->nr_entries == 0)
+		return;
+
 	switch (whence) {
 	case SEEK_SET:
-		pos = head->next;
+		pos = ui_browser__list_head_filter_entries(self, head->next);
 		break;
 	case SEEK_CUR:
 		pos = self->top;
 		break;
 	case SEEK_END:
-		pos = head->prev;
+		pos = ui_browser__list_head_filter_prev_entries(self, head->prev);
 		break;
 	default:
 		return;
 	}
 
+	assert(pos != NULL);
+
 	if (offset > 0) {
 		while (offset-- != 0)
-			pos = pos->next;
+			pos = ui_browser__list_head_filter_entries(self, pos->next);
 	} else {
 		while (offset++ != 0)
-			pos = pos->prev;
+			pos = ui_browser__list_head_filter_prev_entries(self, pos->prev);
 	}
 
 	self->top = pos;
@@ -365,15 +396,17 @@ unsigned int ui_browser__list_head_refresh(struct ui_browser *self)
 	int row = 0;
 
 	if (self->top == NULL || self->top == self->entries)
-                self->top = head->next;
+                self->top = ui_browser__list_head_filter_entries(self, head->next);
 
 	pos = self->top;
 
 	list_for_each_from(pos, head) {
-		ui_browser__gotorc(self, row, 0);
-		self->write(self, pos, row);
-		if (++row == self->height)
-			break;
+		if (!self->filter || !self->filter(self, pos)) {
+			ui_browser__gotorc(self, row, 0);
+			self->write(self, pos, row);
+			if (++row == self->height)
+				break;
+		}
 	}
 
 	return row;
diff --git a/tools/perf/util/ui/browser.h b/tools/perf/util/ui/browser.h
index 7dd9d61..351c006 100644
--- a/tools/perf/util/ui/browser.h
+++ b/tools/perf/util/ui/browser.h
@@ -21,6 +21,7 @@ struct ui_browser {
 	unsigned int  (*refresh)(struct ui_browser *self);
 	void	      (*write)(struct ui_browser *self, void *entry, int row);
 	void	      (*seek)(struct ui_browser *self, off_t offset, int whence);
+	bool	      (*filter)(struct ui_browser *self, void *entry);
 	u32	      nr_entries;
 };
 
-- 
1.6.2.5

