Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074Ab2EEPXR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 11:23:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39420 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755937Ab2EEPXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 11:23:16 -0400
From: Namhyung Kim <namhyung@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH] perf top: Fix a race in callchain handling
Date: Sun,  6 May 2012 00:23:08 +0900
Message-Id: <1336231388-12347-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When perf top collects callchain info, main thread and display
thread share the callchain cursor so that bugs can happen. For
example, if two threads race on callchain_cursor_advance() for
the last cursor node, one of them can dereference a NULL pointer.

Because the display thread only uses the cursor when collapsing
a hist entry, use its own cursor for that.

Reported-by: Sunjin Yang <fan4326@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 tools/perf/util/hist.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 9f6d630d5316..795b49a803f9 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -378,7 +378,7 @@ void hist_entry__free(struct hist_entry *he)
  * collapse the histogram
  */
 
-static bool hists__collapse_insert_entry(struct hists *hists,
+static bool hists__collapse_insert_entry(struct hists *hists __used,
 					 struct rb_root *root,
 					 struct hist_entry *he)
 {
@@ -386,6 +386,7 @@ static bool hists__collapse_insert_entry(struct hists *hists,
 	struct rb_node *parent = NULL;
 	struct hist_entry *iter;
 	int64_t cmp;
+	static struct callchain_cursor cursor;
 
 	while (*p != NULL) {
 		parent = *p;
@@ -397,8 +398,8 @@ static bool hists__collapse_insert_entry(struct hists *hists,
 			iter->period += he->period;
 			iter->nr_events += he->nr_events;
 			if (symbol_conf.use_callchain) {
-				callchain_cursor_reset(&hists->callchain_cursor);
-				callchain_merge(&hists->callchain_cursor, iter->callchain,
+				callchain_cursor_reset(&cursor);
+				callchain_merge(&cursor, iter->callchain,
 						he->callchain);
 			}
 			hist_entry__free(he);
-- 
1.7.9.2

