Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756743Ab2JDMvr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 08:51:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62392 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756113Ab2JDMvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 08:51:43 -0400
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Arun Sharma <asharma@fb.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 09/20] perf hists: Add more helpers for hist entry stat
Date: Thu,  4 Oct 2012 21:49:43 +0900
Message-Id: <1349354994-17853-10-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1349354994-17853-1-git-send-email-namhyung@kernel.org>
References: <1349354994-17853-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Add and use he_stat__add_{period,stat} for calculating hist entry's
stat.  It will be used for accumulated stats later as well.

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Arun Sharma <asharma@fb.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/hist.c |   26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 02476cb3167d..277947a669b2 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -151,6 +151,22 @@ static void hist_entry__add_cpumode_period(struct hist_entry *he,
 	}
 }
 
+static void he_stat__add_period(struct he_stat *he_stat, u64 period)
+{
+	he_stat->period		+= period;
+	he_stat->nr_events	+= 1;
+}
+
+static void he_stat__add_stat(struct he_stat *dest, struct he_stat *src)
+{
+	dest->period		+= src->period;
+	dest->period_sys	+= src->period_sys;
+	dest->period_us		+= src->period_us;
+	dest->period_guest_sys	+= src->period_guest_sys;
+	dest->period_guest_us	+= src->period_guest_us;
+	dest->nr_events		+= src->nr_events;
+}
+
 static void hist_entry__decay(struct hist_entry *he)
 {
 	he->stat.period = (he->stat.period * 7) / 8;
@@ -270,8 +286,7 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
 		cmp = hist_entry__cmp(entry, he);
 
 		if (!cmp) {
-			he->stat.period += period;
-			++he->stat.nr_events;
+			he_stat__add_period(&he->stat, period);
 
 			/* If the map of an existing hist_entry has
 			 * become out-of-date due to an exec() or
@@ -418,12 +433,7 @@ static bool hists__collapse_insert_entry(struct hists *hists __maybe_unused,
 		cmp = hist_entry__collapse(iter, he);
 
 		if (!cmp) {
-			iter->stat.period		+= he->stat.period;
-			iter->stat.period_sys		+= he->stat.period_sys;
-			iter->stat.period_us		+= he->stat.period_us;
-			iter->stat.period_guest_sys	+= he->stat.period_guest_sys;
-			iter->stat.period_guest_us	+= he->stat.period_guest_us;
-			iter->stat.nr_events		+= he->stat.nr_events;
+			he_stat__add_stat(&iter->stat, &he->stat);
 
 			if (symbol_conf.use_callchain) {
 				callchain_cursor_reset(&callchain_cursor);
-- 
1.7.9.2

