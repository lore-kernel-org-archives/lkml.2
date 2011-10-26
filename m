Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933828Ab1JZRtR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 13:49:17 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37751 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933786Ab1JZRsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 13:48:46 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 02/11] perf ui progress: Reimplement using slang
Date: Wed, 26 Oct 2011 15:48:25 -0200
Message-Id: <1319651314-29404-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1319651314-29404-1-git-send-email-acme@infradead.org>
References: <1319651314-29404-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Just another step in stopping the use of libnewt in perf.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-vkb9jh5kkzl5ep3puoatd6an@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/debug.h       |   12 +------
 tools/perf/util/session.c     |    8 +----
 tools/perf/util/ui/progress.c |   64 ++++++++++------------------------------
 tools/perf/util/ui/progress.h |    7 +---
 4 files changed, 22 insertions(+), 69 deletions(-)

diff --git a/tools/perf/util/debug.h b/tools/perf/util/debug.h
index fd53db4..510adac 100644
--- a/tools/perf/util/debug.h
+++ b/tools/perf/util/debug.h
@@ -19,16 +19,8 @@ static inline int ui_helpline__show_help(const char *format __used, va_list ap _
 	return 0;
 }
 
-static inline struct ui_progress *ui_progress__new(const char *title __used,
-						   u64 total __used)
-{
-	return (struct ui_progress *)1;
-}
-
-static inline void ui_progress__update(struct ui_progress *self __used,
-				       u64 curr __used) {}
-
-static inline void ui_progress__delete(struct ui_progress *self __used) {}
+static inline void ui_progress__update(u64 curr __used, u64 total __used,
+				       const char *title __used) {}
 #else
 extern char ui_helpline__last_msg[];
 int ui_helpline__show_help(const char *format, va_list ap);
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 20e011c..91c6442 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1012,7 +1012,6 @@ int __perf_session__process_events(struct perf_session *session,
 {
 	u64 head, page_offset, file_offset, file_pos, progress_next;
 	int err, mmap_prot, mmap_flags, map_idx = 0;
-	struct ui_progress *progress;
 	size_t	page_size, mmap_size;
 	char *buf, *mmaps[8];
 	union perf_event *event;
@@ -1030,9 +1029,6 @@ int __perf_session__process_events(struct perf_session *session,
 		file_size = data_offset + data_size;
 
 	progress_next = file_size / 16;
-	progress = ui_progress__new("Processing events...", file_size);
-	if (progress == NULL)
-		return -1;
 
 	mmap_size = session->mmap_window;
 	if (mmap_size > file_size)
@@ -1095,7 +1091,8 @@ more:
 
 	if (file_pos >= progress_next) {
 		progress_next += file_size / 16;
-		ui_progress__update(progress, file_pos);
+		ui_progress__update(file_pos, file_size,
+				    "Processing events...");
 	}
 
 	if (file_pos < file_size)
@@ -1106,7 +1103,6 @@ more:
 	session->ordered_samples.next_flush = ULLONG_MAX;
 	flush_sample_queue(session, ops);
 out_err:
-	ui_progress__delete(progress);
 	perf_session__warn_about_errors(session, ops);
 	perf_session_free_sample_buffers(session);
 	return err;
diff --git a/tools/perf/util/ui/progress.c b/tools/perf/util/ui/progress.c
index d7fc399..68d2c54 100644
--- a/tools/perf/util/ui/progress.c
+++ b/tools/perf/util/ui/progress.c
@@ -1,60 +1,28 @@
-#include <stdlib.h>
-#include <newt.h>
 #include "../cache.h"
 #include "progress.h"
+#include "libslang.h"
+#include "ui.h"
+#include "browser.h"
 
-struct ui_progress {
-	newtComponent form, scale;
-};
-
-struct ui_progress *ui_progress__new(const char *title, u64 total)
-{
-	struct ui_progress *self = malloc(sizeof(*self));
-
-	if (self != NULL) {
-		int cols;
-
-		if (use_browser <= 0)
-			return self;
-		newtGetScreenSize(&cols, NULL);
-		cols -= 4;
-		newtCenteredWindow(cols, 1, title);
-		self->form  = newtForm(NULL, NULL, 0);
-		if (self->form == NULL)
-			goto out_free_self;
-		self->scale = newtScale(0, 0, cols, total);
-		if (self->scale == NULL)
-			goto out_free_form;
-		newtFormAddComponent(self->form, self->scale);
-		newtRefresh();
-	}
-
-	return self;
-
-out_free_form:
-	newtFormDestroy(self->form);
-out_free_self:
-	free(self);
-	return NULL;
-}
-
-void ui_progress__update(struct ui_progress *self, u64 curr)
+void ui_progress__update(u64 curr, u64 total, const char *title)
 {
+	int bar, y;
 	/*
 	 * FIXME: We should have a per UI backend way of showing progress,
 	 * stdio will just show a percentage as NN%, etc.
 	 */
 	if (use_browser <= 0)
 		return;
-	newtScaleSet(self->scale, curr);
-	newtRefresh();
-}
 
-void ui_progress__delete(struct ui_progress *self)
-{
-	if (use_browser > 0) {
-		newtFormDestroy(self->form);
-		newtPopWindow();
-	}
-	free(self);
+	pthread_mutex_lock(&ui__lock);
+	y = SLtt_Screen_Rows / 2 - 2;
+	SLsmg_set_color(0);
+	SLsmg_draw_box(y, 0, 3, SLtt_Screen_Cols);
+	SLsmg_gotorc(y++, 1);
+	SLsmg_write_string((char *)title);
+	SLsmg_set_color(HE_COLORSET_SELECTED);
+	bar = ((SLtt_Screen_Cols - 2) * curr) / total;
+	SLsmg_fill_region(y, 1, 1, bar, ' ');
+	SLsmg_refresh();
+	pthread_mutex_unlock(&ui__lock);
 }
diff --git a/tools/perf/util/ui/progress.h b/tools/perf/util/ui/progress.h
index a3820a0..d9c205b 100644
--- a/tools/perf/util/ui/progress.h
+++ b/tools/perf/util/ui/progress.h
@@ -1,11 +1,8 @@
 #ifndef _PERF_UI_PROGRESS_H_
 #define _PERF_UI_PROGRESS_H_ 1
 
-struct ui_progress;
+#include <../types.h>
 
-struct ui_progress *ui_progress__new(const char *title, u64 total);
-void ui_progress__delete(struct ui_progress *self);
-
-void ui_progress__update(struct ui_progress *self, u64 curr);
+void ui_progress__update(u64 curr, u64 total, const char *title);
 
 #endif
-- 
1.6.2.5

