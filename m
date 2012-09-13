Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756355Ab2IMH1N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 03:27:13 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:59217 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756263Ab2IMH1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 03:27:08 -0400
X-AuditID: 9c93016f-b7c19ae000000e6d-0c-50518ac8e50d
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Arun Sharma <asharma@fb.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 11/15] perf hists: Sort hist entries by accumulated period
Date: Thu, 13 Sep 2012 16:20:07 +0900
Message-Id: <1347520811-28150-12-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1347520811-28150-1-git-send-email-namhyung@kernel.org>
References: <1347520811-28150-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

When symbol_conf.cumulate_callchain is requested, we need to sort the
entries by accumulated period value.  To do this, separate out the
compare routine to hists__output_cmp().

In addition, if accumulated periods of two entries are same
(i.e. single path callchain) put the caller above since accumulation
tends to put callers on higher position for obvious reason.

Cc: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/hist.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 2b629f460889..53ca74f1979a 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -628,6 +628,23 @@ void hists__collapse_resort_threaded(struct hists *hists)
  * reverse the map, sort on period.
  */
 
+static int hists__output_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	int cmp = left->stat.period > right->stat.period;
+
+	if (symbol_conf.cumulate_callchain) {
+		/*
+		 * Put caller above callee when they have equal period.
+		 */
+		if (left->stat_acc->period == right->stat_acc->period)
+			cmp = left->callchain->max_depth < right->callchain->max_depth;
+		else
+			cmp = left->stat_acc->period > right->stat_acc->period;
+	}
+
+	return cmp;
+}
+
 static void __hists__insert_output_entry(struct rb_root *entries,
 					 struct hist_entry *he,
 					 u64 min_callchain_hits)
@@ -644,7 +661,7 @@ static void __hists__insert_output_entry(struct rb_root *entries,
 		parent = *p;
 		iter = rb_entry(parent, struct hist_entry, rb_node);
 
-		if (he->stat.period > iter->stat.period)
+		if (hists__output_cmp(he, iter))
 			p = &(*p)->rb_left;
 		else
 			p = &(*p)->rb_right;
-- 
1.7.11.4

