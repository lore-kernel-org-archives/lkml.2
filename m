Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933230Ab0HJVx7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 17:53:59 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33537 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933183Ab0HJVxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 17:53:54 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 3/4] perf ui browser: Add ui_browser__show counterpart: __hide
Date: Tue, 10 Aug 2010 18:53:45 -0300
Message-Id: <1281477226-11504-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1281477226-11504-1-git-send-email-acme@infradead.org>
References: <1281477226-11504-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

So that the common tasks of providing a helpline at __run entry and
destroying the window and releasing resourses at exit can be abstracted
away, reducing a bit more the coupling with libnewt.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/ui/browser.c           |   18 +++++++++++++++++-
 tools/perf/util/ui/browser.h           |    4 +++-
 tools/perf/util/ui/browsers/annotate.c |    8 +++-----
 tools/perf/util/ui/browsers/hists.c    |    5 ++++-
 tools/perf/util/ui/browsers/map.c      |   10 ++++------
 tools/perf/util/ui/helpline.c          |    2 +-
 tools/perf/util/ui/helpline.h          |    1 +
 7 files changed, 33 insertions(+), 15 deletions(-)

diff --git a/tools/perf/util/ui/browser.c b/tools/perf/util/ui/browser.c
index 83d5748..66f2d58 100644
--- a/tools/perf/util/ui/browser.c
+++ b/tools/perf/util/ui/browser.c
@@ -16,6 +16,7 @@
 #include <stdlib.h>
 #include <sys/ttydefaults.h>
 #include "browser.h"
+#include "helpline.h"
 #include "../color.h"
 #include "../util.h"
 
@@ -145,8 +146,11 @@ void ui_browser__reset_index(struct ui_browser *self)
 	self->seek(self, 0, SEEK_SET);
 }
 
-int ui_browser__show(struct ui_browser *self, const char *title)
+int ui_browser__show(struct ui_browser *self, const char *title,
+		     const char *helpline, ...)
 {
+	va_list ap;
+
 	if (self->form != NULL) {
 		newtFormDestroy(self->form);
 		newtPopWindow();
@@ -171,9 +175,21 @@ int ui_browser__show(struct ui_browser *self, const char *title)
 	newtFormAddHotKey(self->form, NEWT_KEY_END);
 	newtFormAddHotKey(self->form, ' ');
 	newtFormAddComponent(self->form, self->sb);
+
+	va_start(ap, helpline);
+	ui_helpline__vpush(helpline, ap);
+	va_end(ap);
 	return 0;
 }
 
+void ui_browser__hide(struct ui_browser *self)
+{
+	newtFormDestroy(self->form);
+	newtPopWindow();
+	self->form = NULL;
+	ui_helpline__pop();
+}
+
 int ui_browser__refresh(struct ui_browser *self)
 {
 	int row;
diff --git a/tools/perf/util/ui/browser.h b/tools/perf/util/ui/browser.h
index 856e343..0b9f829 100644
--- a/tools/perf/util/ui/browser.h
+++ b/tools/perf/util/ui/browser.h
@@ -30,7 +30,9 @@ bool ui_browser__is_current_entry(struct ui_browser *self, unsigned row);
 void ui_browser__refresh_dimensions(struct ui_browser *self);
 void ui_browser__reset_index(struct ui_browser *self);
 
-int ui_browser__show(struct ui_browser *self, const char *title);
+int ui_browser__show(struct ui_browser *self, const char *title,
+		     const char *helpline, ...);
+void ui_browser__hide(struct ui_browser *self);
 int ui_browser__refresh(struct ui_browser *self);
 int ui_browser__run(struct ui_browser *self, struct newtExitStruct *es);
 
diff --git a/tools/perf/util/ui/browsers/annotate.c b/tools/perf/util/ui/browsers/annotate.c
index 73e78ef..55ff792 100644
--- a/tools/perf/util/ui/browsers/annotate.c
+++ b/tools/perf/util/ui/browsers/annotate.c
@@ -141,10 +141,10 @@ static int annotate_browser__run(struct annotate_browser *self,
 	struct rb_node *nd;
 	struct hist_entry *he = self->b.priv;
 
-	if (ui_browser__show(&self->b, he->ms.sym->name) < 0)
+	if (ui_browser__show(&self->b, he->ms.sym->name,
+			     "<- or ESC: exit, TAB/shift+TAB: cycle thru samples") < 0)
 		return -1;
 
-	ui_helpline__fpush("<- or ESC: exit, TAB/shift+TAB: cycle thru samples");
 	newtFormAddHotKey(self->b.form, NEWT_KEY_LEFT);
 
 	nd = self->curr_hot;
@@ -177,9 +177,7 @@ static int annotate_browser__run(struct annotate_browser *self,
 		}
 	}
 out:
-	newtFormDestroy(self->b.form);
-	newtPopWindow();
-	ui_helpline__pop();
+	ui_browser__hide(&self->b);
 	return 0;
 }
 
diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index cee7998..dd512b7 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -211,7 +211,8 @@ static int hist_browser__run(struct hist_browser *self, const char *title,
 		 nr_events, unit);
 	newtDrawRootText(0, 0, str);
 
-	if (ui_browser__show(&self->b, title) < 0)
+	if (ui_browser__show(&self->b, title,
+			     "Press '?' for help on key bindings") < 0)
 		return -1;
 
 	newtFormAddHotKey(self->b.form, 'A');
@@ -253,6 +254,8 @@ static int hist_browser__run(struct hist_browser *self, const char *title,
 			return 0;
 		}
 	}
+
+	ui_browser__hide(&self->b);
 	return 0;
 }
 
diff --git a/tools/perf/util/ui/browsers/map.c b/tools/perf/util/ui/browsers/map.c
index b79f0c9..142b825 100644
--- a/tools/perf/util/ui/browsers/map.c
+++ b/tools/perf/util/ui/browsers/map.c
@@ -100,11 +100,11 @@ static int map_browser__search(struct map_browser *self)
 
 static int map_browser__run(struct map_browser *self, struct newtExitStruct *es)
 {
-	if (ui_browser__show(&self->b, self->map->dso->long_name) < 0)
+	if (ui_browser__show(&self->b, self->map->dso->long_name,
+			     "Press <- or ESC to exit, %s / to search",
+			     verbose ? "" : "restart with -v to use") < 0)
 		return -1;
 
-	ui_helpline__fpush("Press <- or ESC to exit, %s / to search",
-			   verbose ? "" : "restart with -v to use");
 	newtFormAddHotKey(self->b.form, NEWT_KEY_LEFT);
 	newtFormAddHotKey(self->b.form, NEWT_KEY_ENTER);
 	if (verbose)
@@ -121,9 +121,7 @@ static int map_browser__run(struct map_browser *self, struct newtExitStruct *es)
 			break;
 	}
 
-	newtFormDestroy(self->b.form);
-	newtPopWindow();
-	ui_helpline__pop();
+	ui_browser__hide(&self->b);
 	return 0;
 }
 
diff --git a/tools/perf/util/ui/helpline.c b/tools/perf/util/ui/helpline.c
index ff58460..8d79daa 100644
--- a/tools/perf/util/ui/helpline.c
+++ b/tools/perf/util/ui/helpline.c
@@ -16,7 +16,7 @@ void ui_helpline__push(const char *msg)
 	newtPushHelpLine(msg);
 }
 
-static void ui_helpline__vpush(const char *fmt, va_list ap)
+void ui_helpline__vpush(const char *fmt, va_list ap)
 {
 	char *s;
 
diff --git a/tools/perf/util/ui/helpline.h b/tools/perf/util/ui/helpline.h
index 5d1e5e7..ab6028d 100644
--- a/tools/perf/util/ui/helpline.h
+++ b/tools/perf/util/ui/helpline.h
@@ -4,6 +4,7 @@
 void ui_helpline__init(void);
 void ui_helpline__pop(void);
 void ui_helpline__push(const char *msg);
+void ui_helpline__vpush(const char *fmt, va_list ap);
 void ui_helpline__fpush(const char *fmt, ...);
 void ui_helpline__puts(const char *msg);
 
-- 
1.6.2.5

