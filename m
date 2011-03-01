Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756946Ab1CAREF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 12:04:05 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:58310 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756286Ab1CAREB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 12:04:01 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 2/6] perf ui browser: Introduce ui_browser__show_title
Date: Tue,  1 Mar 2011 14:03:43 -0300
Message-Id: <1298999027-30673-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1298999027-30673-1-git-send-email-acme@infradead.org>
References: <1298999027-30673-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Needed because we were only showing the title in ui_browser__show,
not in ui_browser__run, and in the run loop we may be calling other
browsers that would then change the title, when we go back to the
previous browser, we need to redraw the title.

We could have done this as the Newt help line, with pop, etc, but I
don't think its worth, doing it explicitely, when needed (some browsers
may not use the title area at all) seems enough/more flexible.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/ui/browser.c |   18 +++++++++++++++---
 tools/perf/util/ui/browser.h |    3 ++-
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/ui/browser.c b/tools/perf/util/ui/browser.c
index 60d6c81..611219f 100644
--- a/tools/perf/util/ui/browser.c
+++ b/tools/perf/util/ui/browser.c
@@ -157,6 +157,20 @@ void ui_browser__add_exit_keys(struct ui_browser *self, int keys[])
 	}
 }
 
+void __ui_browser__show_title(struct ui_browser *browser, const char *title)
+{
+	SLsmg_gotorc(0, 0);
+	ui_browser__set_color(browser, NEWT_COLORSET_ROOT);
+	slsmg_write_nstring(title, browser->width);
+}
+
+void ui_browser__show_title(struct ui_browser *browser, const char *title)
+{
+	pthread_mutex_lock(&ui__lock);
+	__ui_browser__show_title(browser, title);
+	pthread_mutex_unlock(&ui__lock);
+}
+
 int ui_browser__show(struct ui_browser *self, const char *title,
 		     const char *helpline, ...)
 {
@@ -180,9 +194,7 @@ int ui_browser__show(struct ui_browser *self, const char *title,
 		return -1;
 
 	pthread_mutex_lock(&ui__lock);
-	SLsmg_gotorc(0, 0);
-	ui_browser__set_color(self, NEWT_COLORSET_ROOT);
-	slsmg_write_nstring(title, self->width);
+	__ui_browser__show_title(self, title);
 
 	ui_browser__add_exit_keys(self, keys);
 	newtFormAddComponent(self->form, self->sb);
diff --git a/tools/perf/util/ui/browser.h b/tools/perf/util/ui/browser.h
index 0dc7e4d..fc63dda 100644
--- a/tools/perf/util/ui/browser.h
+++ b/tools/perf/util/ui/browser.h
@@ -24,7 +24,6 @@ struct ui_browser {
 	u32	      nr_entries;
 };
 
-
 void ui_browser__set_color(struct ui_browser *self, int color);
 void ui_browser__set_percent_color(struct ui_browser *self,
 				   double percent, bool current);
@@ -35,6 +34,8 @@ void ui_browser__reset_index(struct ui_browser *self);
 void ui_browser__gotorc(struct ui_browser *self, int y, int x);
 void ui_browser__add_exit_key(struct ui_browser *self, int key);
 void ui_browser__add_exit_keys(struct ui_browser *self, int keys[]);
+void __ui_browser__show_title(struct ui_browser *browser, const char *title);
+void ui_browser__show_title(struct ui_browser *browser, const char *title);
 int ui_browser__show(struct ui_browser *self, const char *title,
 		     const char *helpline, ...);
 void ui_browser__hide(struct ui_browser *self);
-- 
1.6.2.5

