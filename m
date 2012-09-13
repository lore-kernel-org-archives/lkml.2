Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625Ab2IMHbi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 03:31:38 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:59217 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756225Ab2IMH1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 03:27:05 -0400
X-AuditID: 9c93016f-b7c19ae000000e6d-f4-50518ac6143d
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Arun Sharma <asharma@fb.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 04/15] perf hists: Convert hist entry functions to use struct he_stat
Date: Thu, 13 Sep 2012 16:20:00 +0900
Message-Id: <1347520811-28150-5-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1347520811-28150-1-git-send-email-namhyung@kernel.org>
References: <1347520811-28150-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

hist_entry__add_cpumode_period() and hist_entry__decay() are dealing
with hist_entry's stat fields only.  So make them use the struct
directly.

Cc: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/hist.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index ef39e6714cbb..3a37f8c5c297 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -130,31 +130,31 @@ void hists__output_recalc_col_len(struct hists *hists, int max_rows)
 	}
 }
 
-static void hist_entry__add_cpumode_period(struct hist_entry *he,
+static void hist_entry__add_cpumode_period(struct he_stat *he_stat,
 					   unsigned int cpumode, u64 period)
 {
 	switch (cpumode) {
 	case PERF_RECORD_MISC_KERNEL:
-		he->stat.period_sys += period;
+		he_stat->period_sys += period;
 		break;
 	case PERF_RECORD_MISC_USER:
-		he->stat.period_us += period;
+		he_stat->period_us += period;
 		break;
 	case PERF_RECORD_MISC_GUEST_KERNEL:
-		he->stat.period_guest_sys += period;
+		he_stat->period_guest_sys += period;
 		break;
 	case PERF_RECORD_MISC_GUEST_USER:
-		he->stat.period_guest_us += period;
+		he_stat->period_guest_us += period;
 		break;
 	default:
 		break;
 	}
 }
 
-static void hist_entry__decay(struct hist_entry *he)
+static void hist_entry__decay(struct he_stat *he_stat)
 {
-	he->stat.period = (he->stat.period * 7) / 8;
-	he->stat.nr_events = (he->stat.nr_events * 7) / 8;
+	he_stat->period = (he_stat->period * 7) / 8;
+	he_stat->nr_events = (he_stat->nr_events * 7) / 8;
 }
 
 static bool hists__decay_entry(struct hists *hists, struct hist_entry *he)
@@ -164,7 +164,7 @@ static bool hists__decay_entry(struct hists *hists, struct hist_entry *he)
 	if (prev_period == 0)
 		return true;
 
-	hist_entry__decay(he);
+	hist_entry__decay(&he->stat);
 
 	if (!he->filtered)
 		hists->stats.total_period -= prev_period - he->stat.period;
@@ -300,7 +300,7 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
 	rb_link_node(&he->rb_node_in, parent, p);
 	rb_insert_color(&he->rb_node_in, hists->entries_in);
 out:
-	hist_entry__add_cpumode_period(he, al->cpumode, period);
+	hist_entry__add_cpumode_period(&he->stat, al->cpumode, period);
 out_unlock:
 	pthread_mutex_unlock(&hists->lock);
 	return he;
-- 
1.7.11.4

