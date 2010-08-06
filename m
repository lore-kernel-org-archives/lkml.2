Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934199Ab0HFRGO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 13:06:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:42607 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933942Ab0HFRGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 13:06:08 -0400
Date: Fri, 6 Aug 2010 17:05:39 GMT
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
Subject: [tip:perf/core] perf ui: Add search by name/addr to the map__browser
Message-ID: <tip-80d50cae1b9cc958171c36fffc7357a5abad808c@git.kernel.org>
Git-Commit-ID: 80d50cae1b9cc958171c36fffc7357a5abad808c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 06 Aug 2010 17:05:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  80d50cae1b9cc958171c36fffc7357a5abad808c
Gitweb:     http://git.kernel.org/tip/80d50cae1b9cc958171c36fffc7357a5abad808c
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 5 Aug 2010 19:28:27 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 5 Aug 2010 19:38:02 -0300

perf ui: Add search by name/addr to the map__browser

Only in verbose mode so as not to bloat struct symbol too much.

The key used is '/', just like in vi, less, etc.

More work is needed to allocate space on the symbol in a more clear way.

This experiment shows how to do it for the hist_browser, in the main
window.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c |   18 +++++++-
 tools/perf/util/newt.c      |  109 +++++++++++++++++++++++++++++++++++++++----
 2 files changed, 117 insertions(+), 10 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 2f4b929..4a7a743 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -478,8 +478,24 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 	 * so don't allocate extra space that won't be used in the stdio
 	 * implementation.
 	 */
-	if (use_browser > 0)
+	if (use_browser > 0) {
 		symbol_conf.priv_size = sizeof(struct sym_priv);
+		/*
+ 		 * For searching by name on the "Browse map details".
+ 		 * providing it only in verbose mode not to bloat too
+ 		 * much struct symbol.
+ 		 */
+		if (verbose) {
+			/*
+			 * XXX: Need to provide a less kludgy way to ask for
+			 * more space per symbol, the u32 is for the index on
+			 * the ui browser.
+			 * See symbol__browser_index.
+			 */
+			symbol_conf.priv_size += sizeof(u32);
+			symbol_conf.sort_by_name = true;
+		}
+	}
 
 	if (symbol__init() < 0)
 		return -1;
diff --git a/tools/perf/util/newt.c b/tools/perf/util/newt.c
index f98a240..e2deae0 100644
--- a/tools/perf/util/newt.c
+++ b/tools/perf/util/newt.c
@@ -128,6 +128,39 @@ static void ui_helpline__puts(const char *msg)
 	ui_helpline__push(msg);
 }
 
+static int ui_entry__read(const char *title, char *bf, size_t size, int width)
+{
+	struct newtExitStruct es;
+	newtComponent form, entry;
+	const char *result;
+	int err = -1;
+
+	newtCenteredWindow(width, 1, title);
+	form = newtForm(NULL, NULL, 0);
+	if (form == NULL)
+		return -1;
+
+	entry = newtEntry(0, 0, "0x", width, &result, NEWT_FLAG_SCROLL);
+	if (entry == NULL)
+		goto out_free_form;
+
+	newtFormAddComponent(form, entry);
+	newtFormAddHotKey(form, NEWT_KEY_ENTER);
+	newtFormAddHotKey(form, NEWT_KEY_ESCAPE);
+	newtFormAddHotKey(form, NEWT_KEY_LEFT);
+	newtFormAddHotKey(form, CTRL('c'));
+	newtFormRun(form, &es);
+
+	if (result != NULL) {
+		strncpy(bf, result, size);
+		err = 0;
+	}
+out_free_form:
+	newtPopWindow();
+	newtFormDestroy(form);
+	return 0;
+}
+
 static char browser__last_msg[1024];
 
 int browser__show_help(const char *format, va_list ap)
@@ -670,6 +703,67 @@ static void map_browser__write(struct ui_browser *self, void *nd, int row)
 	slsmg_write_nstring(sym->name, mb->namelen);
 }
 
+/* FIXME uber-kludgy, see comment on cmd_report... */
+static u32 *symbol__browser_index(struct symbol *self)
+{
+	return ((void *)self) - sizeof(struct rb_node) - sizeof(u32);
+}
+
+static int map_browser__search(struct map_browser *self)
+{
+	char target[512];
+	struct symbol *sym;
+	int err = ui_entry__read("Search by name/addr", target, sizeof(target), 40);
+
+	if (err)
+		return err;
+
+	if (target[0] == '0' && tolower(target[1]) == 'x') {
+		u64 addr = strtoull(target, NULL, 16);
+		sym = map__find_symbol(self->map, addr, NULL);
+	} else
+		sym = map__find_symbol_by_name(self->map, target, NULL);
+
+	if (sym != NULL) {
+		u32 *idx = symbol__browser_index(sym);
+			
+		self->b.first_visible_entry = &sym->rb_node;
+		self->b.index = self->b.first_visible_entry_idx = *idx;
+	} else
+		ui_helpline__fpush("%s not found!", target);
+
+	return 0;
+}
+
+static int map_browser__run(struct map_browser *self, struct newtExitStruct *es)
+{
+	if (ui_browser__show(&self->b, self->map->dso->long_name) < 0)
+		return -1;
+
+	ui_helpline__fpush("Press <- or ESC to exit, %s / to search",
+			   verbose ? "" : "restart with -v to use");
+	newtFormAddHotKey(self->b.form, NEWT_KEY_LEFT);
+	newtFormAddHotKey(self->b.form, NEWT_KEY_ENTER);
+	if (verbose)
+		newtFormAddHotKey(self->b.form, '/');
+
+	while (1) {
+		ui_browser__run(&self->b, es);
+
+		if (es->reason != NEWT_EXIT_HOTKEY)
+			break;
+		if (verbose && es->u.key == '/')
+			map_browser__search(self);
+		else
+			break;
+	}
+
+	newtFormDestroy(self->b.form);
+	newtPopWindow();
+	ui_helpline__pop();
+	return 0;
+}
+
 static int map__browse(struct map *self)
 {
 	struct map_browser mb = {
@@ -679,14 +773,12 @@ static int map__browse(struct map *self)
 			.seek	 = ui_browser__rb_tree_seek,
 			.write	 = map_browser__write,
 		},
+		.map = self,
 	};
 	struct newtExitStruct es;
 	struct rb_node *nd;
 	char tmp[BITS_PER_LONG / 4];
 	u64 maxaddr = 0;
-	int ret;
-
-	ui_helpline__push("Press <- or ESC to exit");
 
 	for (nd = rb_first(mb.b.entries); nd; nd = rb_next(nd)) {
 		struct symbol *pos = rb_entry(nd, struct symbol, rb_node);
@@ -695,17 +787,16 @@ static int map__browse(struct map *self)
 			mb.namelen = pos->namelen;
 		if (maxaddr < pos->end)
 			maxaddr = pos->end;
+		if (verbose) {
+			u32 *idx = symbol__browser_index(pos);
+			*idx = mb.b.nr_entries;
+		}
 		++mb.b.nr_entries;
 	}
 
 	mb.addrlen = snprintf(tmp, sizeof(tmp), "%llx", maxaddr);
 	mb.b.width += mb.addrlen * 2 + 4 + mb.namelen;
-	ui_browser__show(&mb.b, self->dso->long_name);
-	ret = ui_browser__run(&mb.b, &es);
-	newtFormDestroy(mb.b.form);
-	newtPopWindow();
-	ui_helpline__pop();
-	return ret;
+	return map_browser__run(&mb, &es);
 }
 
 /* -------------------------------------------------------------------- */
