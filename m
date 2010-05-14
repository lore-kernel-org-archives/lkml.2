Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759889Ab0ENXKk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 19:10:40 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35011 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187Ab0ENXJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 19:09:48 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 4/4] perf newt: Make <- zoom out filters
Date: Fri, 14 May 2010 20:09:37 -0300
Message-Id: <1273878577-12578-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1273878577-12578-1-git-send-email-acme@infradead.org>
References: <1273878577-12578-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

After we use the filters to zoom into DSOs or threads, we can use <-
(left arrow) to zoom out from the last filter applied.

It is still possible to zoom out of order by using the popup menu.

With this we now have the zoom out operation on the browsing fast path,
by allowing fast navigation using just the four arrors and the enter key
to expand collapse callchains.

Suggested-by: Ingo Molnar <mingo@elte.hu>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile      |    2 +
 tools/perf/util/newt.c   |   34 +++++++++++++++++++--
 tools/perf/util/pstack.c |   75 ++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/pstack.h |   12 +++++++
 4 files changed, 120 insertions(+), 3 deletions(-)
 create mode 100644 tools/perf/util/pstack.c
 create mode 100644 tools/perf/util/pstack.h

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 9c4dc30..a9281cc 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -416,6 +416,7 @@ LIB_H += util/thread.h
 LIB_H += util/trace-event.h
 LIB_H += util/probe-finder.h
 LIB_H += util/probe-event.h
+LIB_H += util/pstack.h
 LIB_H += util/cpumap.h
 
 LIB_OBJS += $(OUTPUT)util/abspath.o
@@ -451,6 +452,7 @@ LIB_OBJS += $(OUTPUT)util/callchain.o
 LIB_OBJS += $(OUTPUT)util/values.o
 LIB_OBJS += $(OUTPUT)util/debug.o
 LIB_OBJS += $(OUTPUT)util/map.o
+LIB_OBJS += $(OUTPUT)util/pstack.o
 LIB_OBJS += $(OUTPUT)util/session.o
 LIB_OBJS += $(OUTPUT)util/thread.o
 LIB_OBJS += $(OUTPUT)util/trace-event-parse.o
diff --git a/tools/perf/util/newt.c b/tools/perf/util/newt.c
index 3402453..e74df12 100644
--- a/tools/perf/util/newt.c
+++ b/tools/perf/util/newt.c
@@ -9,6 +9,7 @@
 
 #include "cache.h"
 #include "hist.h"
+#include "pstack.h"
 #include "session.h"
 #include "sort.h"
 #include "symbol.h"
@@ -750,6 +751,7 @@ static int hist_browser__populate(struct hist_browser *self, struct hists *hists
 	newtFormAddHotKey(self->form, 'A');
 	newtFormAddHotKey(self->form, 'a');
 	newtFormAddHotKey(self->form, NEWT_KEY_RIGHT);
+	newtFormAddHotKey(self->form, NEWT_KEY_LEFT);
 	newtFormAddComponents(self->form, self->tree, NULL);
 	self->selection = newt__symbol_tree_get_current(self->tree);
 
@@ -801,6 +803,7 @@ static int hist_browser__title(char *bf, size_t size, const char *input_name,
 int hists__browse(struct hists *self, const char *helpline, const char *input_name)
 {
 	struct hist_browser *browser = hist_browser__new();
+	struct pstack *fstack = pstack__new(2);
 	const struct thread *thread_filter = NULL;
 	const struct dso *dso_filter = NULL;
 	struct newtExitStruct es;
@@ -810,12 +813,16 @@ int hists__browse(struct hists *self, const char *helpline, const char *input_na
 	if (browser == NULL)
 		return -1;
 
+	fstack = pstack__new(2);
+	if (fstack == NULL)
+		goto out;
+
 	ui_helpline__push(helpline);
 
 	hist_browser__title(msg, sizeof(msg), input_name,
 			    dso_filter, thread_filter);
 	if (hist_browser__populate(browser, self, msg) < 0)
-		goto out;
+		goto out_free_stack;
 
 	while (1) {
 		const struct thread *thread;
@@ -836,6 +843,19 @@ int hists__browse(struct hists *self, const char *helpline, const char *input_na
 				else
 					continue;
 			}
+
+			if (es.u.key == NEWT_KEY_LEFT) {
+				const void *top;
+
+				if (pstack__empty(fstack))
+					continue;
+				top = pstack__pop(fstack);
+				if (top == &dso_filter)
+					goto zoom_out_dso;
+				if (top == &thread_filter)
+					goto zoom_out_thread;
+				continue;
+			}
 		}
 
 		if (browser->selection->sym != NULL &&
@@ -888,12 +908,15 @@ do_annotate:
 			hist_entry__annotate_browser(he);
 		} else if (choice == zoom_dso) {
 			if (dso_filter) {
+				pstack__remove(fstack, &dso_filter);
+zoom_out_dso:
 				ui_helpline__pop();
 				dso_filter = NULL;
 			} else {
-				ui_helpline__fpush("To zoom out press -> + \"Zoom out of %s DSO\"",
+				ui_helpline__fpush("To zoom out press <- or -> + \"Zoom out of %s DSO\"",
 						   dso->kernel ? "the Kernel" : dso->short_name);
 				dso_filter = dso;
+				pstack__push(fstack, &dso_filter);
 			}
 			hists__filter_by_dso(self, dso_filter);
 			hist_browser__title(msg, sizeof(msg), input_name,
@@ -902,13 +925,16 @@ do_annotate:
 				goto out;
 		} else if (choice == zoom_thread) {
 			if (thread_filter) {
+				pstack__remove(fstack, &thread_filter);
+zoom_out_thread:
 				ui_helpline__pop();
 				thread_filter = NULL;
 			} else {
-				ui_helpline__fpush("To zoom out press -> + \"Zoom out of %s(%d) thread\"",
+				ui_helpline__fpush("To zoom out press <- or -> + \"Zoom out of %s(%d) thread\"",
 						   thread->comm_set ? thread->comm : "",
 						   thread->pid);
 				thread_filter = thread;
+				pstack__push(fstack, &thread_filter);
 			}
 			hists__filter_by_thread(self, thread_filter);
 			hist_browser__title(msg, sizeof(msg), input_name,
@@ -918,6 +944,8 @@ do_annotate:
 		}
 	}
 	err = 0;
+out_free_stack:
+	pstack__delete(fstack);
 out:
 	hist_browser__delete(browser);
 	return err;
diff --git a/tools/perf/util/pstack.c b/tools/perf/util/pstack.c
new file mode 100644
index 0000000..13d36fa
--- /dev/null
+++ b/tools/perf/util/pstack.c
@@ -0,0 +1,75 @@
+/*
+ * Simple pointer stack
+ *
+ * (c) 2010 Arnaldo Carvalho de Melo <acme@redhat.com>
+ */
+
+#include "util.h"
+#include "pstack.h"
+#include <linux/kernel.h>
+#include <stdlib.h>
+
+struct pstack {
+	unsigned short	top;
+	unsigned short	max_nr_entries;
+	void		*entries[0];
+};
+
+struct pstack *pstack__new(unsigned short max_nr_entries)
+{
+	struct pstack *self = zalloc((sizeof(*self) +
+				     max_nr_entries * sizeof(void *)));
+	if (self != NULL)
+		self->max_nr_entries = max_nr_entries;
+	return self;
+}
+
+void pstack__delete(struct pstack *self)
+{
+	free(self);
+}
+
+bool pstack__empty(const struct pstack *self)
+{
+	return self->top == 0;
+}
+
+void pstack__remove(struct pstack *self, void *key)
+{
+	unsigned short i = self->top, last_index = self->top - 1;
+
+	while (i-- != 0) {
+		if (self->entries[i] == key) {
+			if (i < last_index)
+				memmove(self->entries + i,
+					self->entries + i + 1,
+					(last_index - i) * sizeof(void *));
+			--self->top;
+			return;
+		}
+	}
+	pr_err("%s: %p not on the pstack!\n", __func__, key);
+}
+
+void pstack__push(struct pstack *self, void *key)
+{
+	if (self->top == self->max_nr_entries) {
+		pr_err("%s: top=%d, overflow!\n", __func__, self->top);
+		return;
+	}
+	self->entries[self->top++] = key;
+}
+
+void *pstack__pop(struct pstack *self)
+{
+	void *ret;
+
+	if (self->top == 0) {
+		pr_err("%s: underflow!\n", __func__);
+		return NULL;
+	}
+
+	ret = self->entries[--self->top];
+	self->entries[self->top] = NULL;
+	return ret;
+}
diff --git a/tools/perf/util/pstack.h b/tools/perf/util/pstack.h
new file mode 100644
index 0000000..5ad0702
--- /dev/null
+++ b/tools/perf/util/pstack.h
@@ -0,0 +1,12 @@
+#ifndef _PERF_PSTACK_
+#define _PERF_PSTACK_
+
+struct pstack;
+struct pstack *pstack__new(unsigned short max_nr_entries);
+void pstack__delete(struct pstack *self);
+bool pstack__empty(const struct pstack *self);
+void pstack__remove(struct pstack *self, void *key);
+void pstack__push(struct pstack *self, void *key);
+void *pstack__pop(struct pstack *self);
+
+#endif /* _PERF_PSTACK_ */
-- 
1.6.2.5

