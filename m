Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429Ab2KROaa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 09:30:30 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36536 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117Ab2KROaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 09:30:13 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 26/32] perf ui: Add ui_progress__finish()
Date: Sun, 18 Nov 2012 11:29:51 -0300
Message-Id: <1353248997-30763-27-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1353248997-30763-1-git-send-email-acme@infradead.org>
References: <1353248997-30763-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Sometimes we need to know when the progress bar should disappear.

Checking curr >= total wasn't enough since there're cases not met that
condition for the last call.

So add a new ->finish callback to identify this explicitly.  Currently
only GTK frontend needs it.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1352813436-14173-4-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/gtk/progress.c |    9 +++++++++
 tools/perf/ui/progress.c     |    6 ++++++
 tools/perf/ui/progress.h     |    2 ++
 tools/perf/util/debug.h      |    1 +
 tools/perf/util/session.c    |    1 +
 5 files changed, 19 insertions(+)

diff --git a/tools/perf/ui/gtk/progress.c b/tools/perf/ui/gtk/progress.c
index 903426f..482bcf3 100644
--- a/tools/perf/ui/gtk/progress.c
+++ b/tools/perf/ui/gtk/progress.c
@@ -40,8 +40,17 @@ static void gtk_progress_update(u64 curr, u64 total, const char *title)
 		gtk_main_iteration();
 }
 
+static void gtk_progress_finish(void)
+{
+	/* this will also destroy all of its children */
+	gtk_widget_destroy(dialog);
+
+	dialog = NULL;
+}
+
 static struct ui_progress gtk_progress_fns = {
 	.update		= gtk_progress_update,
+	.finish		= gtk_progress_finish,
 };
 
 void perf_gtk__init_progress(void)
diff --git a/tools/perf/ui/progress.c b/tools/perf/ui/progress.c
index f5e4d1b..3ec69560 100644
--- a/tools/perf/ui/progress.c
+++ b/tools/perf/ui/progress.c
@@ -18,3 +18,9 @@ void ui_progress__update(u64 curr, u64 total, const char *title)
 {
 	return progress_fns->update(curr, total, title);
 }
+
+void ui_progress__finish(void)
+{
+	if (progress_fns->finish)
+		progress_fns->finish();
+}
diff --git a/tools/perf/ui/progress.h b/tools/perf/ui/progress.h
index 717814b..257cc22 100644
--- a/tools/perf/ui/progress.h
+++ b/tools/perf/ui/progress.h
@@ -5,6 +5,7 @@
 
 struct ui_progress {
 	void (*update)(u64, u64, const char *);
+	void (*finish)(void);
 };
 
 extern struct ui_progress *progress_fns;
@@ -12,5 +13,6 @@ extern struct ui_progress *progress_fns;
 void ui_progress__init(void);
 
 void ui_progress__update(u64 curr, u64 total, const char *title);
+void ui_progress__finish(void);
 
 #endif
diff --git a/tools/perf/util/debug.h b/tools/perf/util/debug.h
index dec9875..83e8d23 100644
--- a/tools/perf/util/debug.h
+++ b/tools/perf/util/debug.h
@@ -26,6 +26,7 @@ int ui__error(const char *format, ...) __attribute__((format(printf, 1, 2)));
 static inline void ui_progress__update(u64 curr __maybe_unused,
 				       u64 total __maybe_unused,
 				       const char *title __maybe_unused) {}
+static inline void ui_progress__finish(void) {}
 
 #define ui__error(format, arg...) ui__warning(format, ##arg)
 
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 15abe40..ce6f511 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1458,6 +1458,7 @@ more:
 	session->ordered_samples.next_flush = ULLONG_MAX;
 	err = flush_sample_queue(session, tool);
 out_err:
+	ui_progress__finish();
 	perf_session__warn_about_errors(session, tool);
 	perf_session_free_sample_buffers(session);
 	return err;
-- 
1.7.9.2.358.g22243

