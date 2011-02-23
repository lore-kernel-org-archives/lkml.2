Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199Ab1BWNg6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 08:36:58 -0500
Received: from casper.infradead.org ([85.118.1.10]:58223 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755127Ab1BWNg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 08:36:56 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 1/2] perf top browser: Adjust the browser indexes when refreshing
Date: Wed, 23 Feb 2011 10:36:26 -0300
Message-Id: <1298468187-6096-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1298468187-6096-1-git-send-email-acme@infradead.org>
References: <1298468187-6096-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

This is not a problem when we're not at the bottom of the active symbols
list, so was not noticed, but at the end of the screen it falls apart.

Fix it by adjusting the ui_browser indexes according to the new number
of entries in the rb_tree and by seeking from the start of the rb_tree
to find the new symbol at the top of the screen.

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
 tools/perf/util/ui/browsers/top.c |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/ui/browsers/top.c b/tools/perf/util/ui/browsers/top.c
index 377ff58..2f47224 100644
--- a/tools/perf/util/ui/browsers/top.c
+++ b/tools/perf/util/ui/browsers/top.c
@@ -70,6 +70,7 @@ static void perf_top_browser__write(struct ui_browser *browser, void *entry, int
 static void perf_top_browser__update_rb_tree(struct perf_top_browser *browser)
 {
 	struct perf_top *top = browser->b.priv;
+	u64 top_idx = browser->b.top_idx;
 
 	browser->root = RB_ROOT;
 	browser->b.top = NULL;
@@ -82,7 +83,29 @@ static void perf_top_browser__update_rb_tree(struct perf_top_browser *browser)
 		if (browser->sym_width + browser->dso_width > browser->b.width - 29)
 			browser->sym_width = browser->b.width - browser->dso_width - 29;
 	}
+
+	/*
+	 * Adjust the ui_browser indexes since the entries in the browser->root
+	 * rb_tree may have changed, then seek it from start, so that we get a
+	 * possible new top of the screen.
+ 	 */
 	browser->b.nr_entries = top->rb_entries;
+
+	if (top_idx >= browser->b.nr_entries) {
+		if (browser->b.height >= browser->b.nr_entries)
+			top_idx = browser->b.nr_entries - browser->b.height;
+		else
+			top_idx = 0;
+	}
+
+	if (browser->b.index >= top_idx + browser->b.height)
+		browser->b.index = top_idx + browser->b.index - browser->b.top_idx;
+
+	if (browser->b.index >= browser->b.nr_entries)
+		browser->b.index = browser->b.nr_entries - 1;
+
+	browser->b.top_idx = top_idx;
+	browser->b.seek(&browser->b, top_idx, SEEK_SET);
 }
 
 static void perf_top_browser__annotate(struct perf_top_browser *browser)
-- 
1.6.2.5

