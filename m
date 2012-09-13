Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661Ab2IMHbj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 03:31:39 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:46467 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756211Ab2IMH1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 03:27:05 -0400
X-AuditID: 9c93016f-b7c19ae000000e6d-fb-50518ac671d3
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Arun Sharma <asharma@fb.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 05/15] perf hists: Add more helpers for hist entry stat
Date: Thu, 13 Sep 2012 16:20:01 +0900
Message-Id: <1347520811-28150-6-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1347520811-28150-1-git-send-email-namhyung@kernel.org>
References: <1347520811-28150-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Add and use hist_entry__add_{period,stat} for calculating hist entry's
stat.  It will be used for accumulated stats later as well.

Cc: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/hist.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 3a37f8c5c297..9df0a503e159 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -130,6 +130,12 @@ void hists__output_recalc_col_len(struct hists *hists, int max_rows)
 	}
 }
 
+static void hist_entry__add_period(struct he_stat *he_stat, u64 period)
+{
+	he_stat->period		+= period;
+	he_stat->nr_events	+= 1;
+}
+
 static void hist_entry__add_cpumode_period(struct he_stat *he_stat,
 					   unsigned int cpumode, u64 period)
 {
@@ -151,6 +157,16 @@ static void hist_entry__add_cpumode_period(struct he_stat *he_stat,
 	}
 }
 
+static void hist_entry__add_stat(struct he_stat *dest, struct he_stat *src)
+{
+	dest->period		+= src->period;
+	dest->period_sys	+= src->period_sys;
+	dest->period_us		+= src->period_us;
+	dest->period_guest_sys	+= src->period_guest_sys;
+	dest->period_guest_us	+= src->period_guest_us;
+	dest->nr_events		+= src->nr_events;
+}
+
 static void hist_entry__decay(struct he_stat *he_stat)
 {
 	he_stat->period = (he_stat->period * 7) / 8;
@@ -270,8 +286,7 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
 		cmp = hist_entry__cmp(entry, he);
 
 		if (!cmp) {
-			he->stat.period += period;
-			++he->stat.nr_events;
+			hist_entry__add_period(&he->stat, period);
 
 			/* If the map of an existing hist_entry has
 			 * become out-of-date due to an exec() or
@@ -416,12 +431,7 @@ static bool hists__collapse_insert_entry(struct hists *hists __maybe_unused,
 		cmp = hist_entry__collapse(iter, he);
 
 		if (!cmp) {
-			iter->stat.period		+= he->stat.period;
-			iter->stat.period_sys		+= he->stat.period_sys;
-			iter->stat.period_us		+= he->stat.period_us;
-			iter->stat.period_guest_sys	+= he->stat.period_guest_sys;
-			iter->stat.period_guest_us	+= he->stat.period_guest_us;
-			iter->stat.nr_events		+= he->stat.nr_events;
+			hist_entry__add_stat(&iter->stat, &he->stat);
 
 			if (symbol_conf.use_callchain) {
 				callchain_cursor_reset(&callchain_cursor);
-- 
1.7.11.4

