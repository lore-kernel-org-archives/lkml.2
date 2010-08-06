Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761628Ab0HFRFH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 13:05:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:42389 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761613Ab0HFRFB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 13:05:01 -0400
Date: Fri, 6 Aug 2010 17:04:23 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, acme@redhat.com,
        hpa@zytor.com, mingo@redhat.com, peterz@infradead.org, efault@gmx.de,
        fweisbec@gmail.com, srikar@linux.vnet.ibm.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, eranian@google.com,
        linux-kernel@vger.kernel.org, efault@gmx.de, peterz@infradead.org,
        fweisbec@gmail.com, srikar@linux.vnet.ibm.com, tglx@linutronix.de
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf ui: Add a map browser
Message-ID: <tip-9a725995e88fd3fd79daf99819c51d676ba37ad9@git.kernel.org>
Git-Commit-ID: 9a725995e88fd3fd79daf99819c51d676ba37ad9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 06 Aug 2010 17:04:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9a725995e88fd3fd79daf99819c51d676ba37ad9
Gitweb:     http://git.kernel.org/tip/9a725995e88fd3fd79daf99819c51d676ba37ad9
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 5 Aug 2010 17:00:42 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 5 Aug 2010 19:38:01 -0300

perf ui: Add a map browser

Press -> and then "Browse map details" to see the DSO long name as the title
and the list of symbols in the DSO used by the map where the current symbol is.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/newt.c |  129 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 127 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/newt.c b/tools/perf/util/newt.c
index 91de99b..fc4a2b3 100644
--- a/tools/perf/util/newt.c
+++ b/tools/perf/util/newt.c
@@ -13,6 +13,7 @@
 #include <slang.h>
 #include <signal.h>
 #include <stdlib.h>
+#include <elf.h>
 #include <newt.h>
 #include <sys/ttydefaults.h>
 
@@ -280,6 +281,7 @@ struct ui_browser {
 	u16		top, left, width, height;
 	void		*priv;
 	unsigned int	(*refresh_entries)(struct ui_browser *self);
+	void		(*write)(struct ui_browser *self, void *entry, int row);
 	void		(*seek)(struct ui_browser *self,
 				off_t offset, int whence);
 	u32		nr_entries;
@@ -316,6 +318,58 @@ static void ui_browser__list_head_seek(struct ui_browser *self,
 	self->first_visible_entry = pos;
 }
 
+static void ui_browser__rb_tree_seek(struct ui_browser *self,
+				     off_t offset, int whence)
+{
+	struct rb_root *root = self->entries;
+	struct rb_node *nd;
+
+	switch (whence) {
+	case SEEK_SET:
+		nd = rb_first(root);
+		break;
+	case SEEK_CUR:
+		nd = self->first_visible_entry;
+		break;
+	case SEEK_END:
+		nd = rb_last(root);
+		break;
+	default:
+		return;
+	}
+
+	if (offset > 0) {
+		while (offset-- != 0)
+			nd = rb_next(nd);
+	} else {
+		while (offset++ != 0)
+			nd = rb_prev(nd);
+	}
+
+	self->first_visible_entry = nd;
+}
+
+static unsigned int ui_browser__rb_tree_refresh(struct ui_browser *self)
+{
+	struct rb_node *nd;
+	int row = 0;
+
+	if (self->first_visible_entry == NULL)
+                self->first_visible_entry = rb_first(self->entries);
+
+	nd = self->first_visible_entry;
+
+	while (nd != NULL) {
+		SLsmg_gotorc(self->top + row, self->left);
+		self->write(self, nd, row);
+		if (++row == self->height)
+			break;
+		nd = rb_next(nd);
+	}
+
+	return row;
+}
+
 static bool ui_browser__is_current_entry(struct ui_browser *self, unsigned row)
 {
 	return (self->first_visible_entry_idx + row) == self->index;
@@ -592,6 +646,70 @@ int hist_entry__tui_annotate(struct hist_entry *self)
 	return ret;
 }
 
+/* -------------------------------------------------------------------- */
+
+struct map_browser {
+	struct ui_browser b;
+	struct map	  *map;
+	u16		  namelen;
+	u8		  addrlen;
+};
+
+static void map_browser__write(struct ui_browser *self, void *nd, int row)
+{
+	struct symbol *sym = rb_entry(nd, struct symbol, rb_node);
+	struct map_browser *mb = container_of(self, struct map_browser, b);
+	bool current_entry = ui_browser__is_current_entry(self, row);
+	int color = ui_browser__percent_color(0, current_entry);
+
+	SLsmg_set_color(color);
+	slsmg_printf("%*llx %*llx %c ",
+		     mb->addrlen, sym->start, mb->addrlen, sym->end,
+		     sym->binding == STB_GLOBAL ? 'g' :
+		     sym->binding == STB_LOCAL  ? 'l' : 'w');
+	slsmg_write_nstring(sym->name, mb->namelen);
+}
+
+static int map__browse(struct map *self)
+{
+	struct map_browser mb = {
+		.b = {
+			.entries = &self->dso->symbols[self->type],
+			.refresh_entries = ui_browser__rb_tree_refresh,
+			.seek	 = ui_browser__rb_tree_seek,
+			.write	 = map_browser__write,
+		},
+	};
+	struct newtExitStruct es;
+	struct rb_node *nd;
+	char tmp[BITS_PER_LONG / 4];
+	u64 maxaddr = 0;
+	int ret;
+
+	ui_helpline__push("Press <- or ESC to exit");
+
+	for (nd = rb_first(mb.b.entries); nd; nd = rb_next(nd)) {
+		struct symbol *pos = rb_entry(nd, struct symbol, rb_node);
+
+		if (mb.namelen < pos->namelen)
+			mb.namelen = pos->namelen;
+		if (maxaddr < pos->end)
+			maxaddr = pos->end;
+		++mb.b.nr_entries;
+	}
+
+	mb.addrlen = snprintf(tmp, sizeof(tmp), "%llx", maxaddr);
+	mb.b.width += mb.addrlen * 2 + 4 + mb.namelen;
+	ui_browser__show(&mb.b, self->dso->long_name);
+	ret = ui_browser__run(&mb.b, &es);
+	newtFormDestroy(mb.b.form);
+	newtPopWindow();
+	ui_helpline__pop();
+	return ret;
+}
+
+/* -------------------------------------------------------------------- */
+
 struct hist_browser {
 	struct ui_browser   b;
 	struct hists	    *hists;
@@ -680,7 +798,8 @@ int hists__browse(struct hists *self, const char *helpline, const char *ev_name)
 		const struct dso *dso;
 		char *options[16];
 		int nr_options = 0, choice = 0, i,
-		    annotate = -2, zoom_dso = -2, zoom_thread = -2;
+		    annotate = -2, zoom_dso = -2, zoom_thread = -2,
+		    browse_map = -2;
 
 		if (hist_browser__run(browser, msg, &es))
 			break;
@@ -771,6 +890,10 @@ do_help:
 			     (dso->kernel ? "the Kernel" : dso->short_name)) > 0)
 			zoom_dso = nr_options++;
 
+		if (browser->selection->map != NULL &&
+		    asprintf(&options[nr_options], "Browse map details") > 0)
+			browse_map = nr_options++;
+
 		options[nr_options++] = (char *)"Exit";
 
 		choice = popup_menu(nr_options, options);
@@ -800,7 +923,9 @@ do_annotate:
 				continue;
 
 			hist_entry__tui_annotate(he);
-		} else if (choice == zoom_dso) {
+		} else if (choice == browse_map)
+			map__browse(browser->selection->map);
+		else if (choice == zoom_dso) {
 zoom_dso:
 			if (dso_filter) {
 				pstack__remove(fstack, &dso_filter);
