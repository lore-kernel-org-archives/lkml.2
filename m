Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670Ab1J0OJI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 10:09:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:37920 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754313Ab1J0OIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 10:08:55 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 1/1] perf hists: Fix recalculation of total_period when sorting entries
Date: Thu, 27 Oct 2011 12:08:46 -0200
Message-Id: <1319724526-376-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1319724526-376-1-git-send-email-acme@infradead.org>
References: <1319724526-376-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

We were doing parts of it in hists__collapse_resort and parts of it in
hists__output_resort, leading to a bogus total_period.

Fix it by doing just the filtering operation when collapsing because
there we know that the Zoom operations adds filters just  what is in
hists->entries, not to the new batch of entries being collapsed.

And move all the nr_entries + total_period recalculation to
hists__output_resort since we will traverse all entries anyway there.

Problem introduced when developing threaded addition of new batches
of hist_entries, i.e. post v3.1.

Reported-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-8xyh165h7hmwy0696hu25en6@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/hist.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index f6a9939..a36a3fa 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -365,7 +365,6 @@ static void __hists__collapse_resort(struct hists *hists, bool threaded)
 
 	root = hists__get_rotate_entries_in(hists);
 	next = rb_first(root);
-	hists->stats.total_period = 0;
 
 	while (next) {
 		n = rb_entry(next, struct hist_entry, rb_node_in);
@@ -379,7 +378,6 @@ static void __hists__collapse_resort(struct hists *hists, bool threaded)
 			 * been set by, say, the hist_browser.
 			 */
 			hists__apply_filters(hists, n);
-			hists__inc_nr_entries(hists, n);
 		}
 	}
 }
@@ -442,6 +440,7 @@ static void __hists__output_resort(struct hists *hists, bool threaded)
 	hists->entries = RB_ROOT;
 
 	hists->nr_entries = 0;
+	hists->stats.total_period = 0;
 	hists__reset_col_len(hists);
 
 	while (next) {
-- 
1.6.2.5

