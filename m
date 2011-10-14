Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671Ab1JNS2G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 14:28:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:60450 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108Ab1JNS2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 14:28:02 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 1/5] perf hists browser: Invalidate ui_browser->top after timer calls
Date: Fri, 14 Oct 2011 15:27:49 -0300
Message-Id: <1318616873-26739-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1318616873-26739-1-git-send-email-acme@infradead.org>
References: <1318616873-26739-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

With underlying dynamic data structures we need to invalidate pointers
to them after a timer, as that entry may have vanished (decayed in top,
for instance).

I forgot about browser_ui->top. Fix it by resetting it to null after a
timer. The seek operation from SEEK_SET will then set it to a valid
entry because it starts from rb_first(&hists->entries).

Reported-by: Ingo Molnar <mingo@elte.hu>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-2ssjm0ouh9tsz4dwkcu7c40n@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/ui/browser.c        |    1 +
 tools/perf/util/ui/browsers/hists.c |   15 +++++++++++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/ui/browser.c b/tools/perf/util/ui/browser.c
index 2923c49..078ceaf 100644
--- a/tools/perf/util/ui/browser.c
+++ b/tools/perf/util/ui/browser.c
@@ -249,6 +249,7 @@ void ui_browser__update_nr_entries(struct ui_browser *browser, u32 nr_entries)
 		browser->top_idx += offset;
 	}
 
+	browser->top = NULL;
 	browser->seek(browser, browser->top_idx, SEEK_SET);
 }
 
diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index 4a3a7c9..b144b10 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -600,14 +600,23 @@ static int hist_browser__show_entry(struct hist_browser *self,
 	return printed;
 }
 
+static void ui_browser__hists_init_top(struct ui_browser *browser)
+{
+	if (browser->top == NULL) {
+		struct hist_browser *hb;
+
+		hb = container_of(browser, struct hist_browser, b);
+		browser->top = rb_first(&hb->hists->entries);
+	}
+}
+
 static unsigned int hist_browser__refresh(struct ui_browser *self)
 {
 	unsigned row = 0;
 	struct rb_node *nd;
 	struct hist_browser *hb = container_of(self, struct hist_browser, b);
 
-	if (self->top == NULL)
-		self->top = rb_first(&hb->hists->entries);
+	ui_browser__hists_init_top(self);
 
 	for (nd = self->top; nd; nd = rb_next(nd)) {
 		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
@@ -659,6 +668,8 @@ static void ui_browser__hists_seek(struct ui_browser *self,
 	if (self->nr_entries == 0)
 		return;
 
+	ui_browser__hists_init_top(self);
+
 	switch (whence) {
 	case SEEK_SET:
 		nd = hists__filter_entries(rb_first(self->entries));
-- 
1.6.2.5

