Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641Ab1BWOwv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 09:52:51 -0500
Received: from hera.kernel.org ([140.211.167.34]:33145 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752336Ab1BWOwt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 09:52:49 -0500
Date: Wed, 23 Feb 2011 14:52:05 GMT
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
Subject: [tip:perf/core] perf top browser: Adjust the browser indexes when refreshing
Message-ID: <tip-6435a5e39d3e01a1a73a925ed53ee18619b0a368@git.kernel.org>
Git-Commit-ID: 6435a5e39d3e01a1a73a925ed53ee18619b0a368
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 23 Feb 2011 14:52:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6435a5e39d3e01a1a73a925ed53ee18619b0a368
Gitweb:     http://git.kernel.org/tip/6435a5e39d3e01a1a73a925ed53ee18619b0a368
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 23 Feb 2011 07:25:02 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 23 Feb 2011 07:25:02 -0300

perf top browser: Adjust the browser indexes when refreshing

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
