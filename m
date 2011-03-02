Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989Ab1CBIk5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 03:40:57 -0500
Received: from hera.kernel.org ([140.211.167.34]:45231 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754765Ab1CBIkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 03:40:55 -0500
Date: Wed, 2 Mar 2011 08:40:21 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        peterz@infradead.org, efault@gmx.de, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        efault@gmx.de, peterz@infradead.org, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf ui browser: Introduce ui_browser__show_title
Message-ID: <tip-b210b3bb1b002f27165325a5edb6ebce3c168e92@git.kernel.org>
Git-Commit-ID: b210b3bb1b002f27165325a5edb6ebce3c168e92
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 02 Mar 2011 08:40:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b210b3bb1b002f27165325a5edb6ebce3c168e92
Gitweb:     http://git.kernel.org/tip/b210b3bb1b002f27165325a5edb6ebce3c168e92
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 25 Feb 2011 11:33:31 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 25 Feb 2011 11:33:31 -0300

perf ui browser: Introduce ui_browser__show_title

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
