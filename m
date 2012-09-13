Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616Ab2IMHbF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 03:31:05 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:57860 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756231Ab2IMH1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 03:27:06 -0400
X-AuditID: 9c93016f-b7c19ae000000e6d-fe-50518ac714d8
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Arun Sharma <asharma@fb.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 06/15] perf hists: Add support for accumulated stat of hist entry
Date: Thu, 13 Sep 2012 16:20:02 +0900
Message-Id: <1347520811-28150-7-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1347520811-28150-1-git-send-email-namhyung@kernel.org>
References: <1347520811-28150-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Maintain accumulated stat information in hist_entry->stat_acc if
symbol_conf.cumulate_callchain is set.  Fields in ->stat_acc have same
vaules initially, and will be updated as callchain is processed later.

Cc: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/hist.c   | 18 ++++++++++++++++++
 tools/perf/util/sort.h   |  1 +
 tools/perf/util/symbol.h |  1 +
 3 files changed, 20 insertions(+)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 9df0a503e159..2802302e5904 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -181,6 +181,8 @@ static bool hists__decay_entry(struct hists *hists, struct hist_entry *he)
 		return true;
 
 	hist_entry__decay(&he->stat);
+	if (symbol_conf.cumulate_callchain)
+		hist_entry__decay(he->stat_acc);
 
 	if (!he->filtered)
 		hists->stats.total_period -= prev_period - he->stat.period;
@@ -239,6 +241,14 @@ static struct hist_entry *hist_entry__new(struct hist_entry *template)
 
 	if (he != NULL) {
 		*he = *template;
+		if (symbol_conf.cumulate_callchain) {
+			he->stat_acc = malloc(sizeof(he->stat));
+			if (he->stat_acc == NULL) {
+				free(he);
+				return NULL;
+			}
+			memcpy(he->stat_acc, &he->stat, sizeof(he->stat));
+		}
 
 		if (he->ms.map)
 			he->ms.map->referenced = true;
@@ -287,6 +297,8 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
 
 		if (!cmp) {
 			hist_entry__add_period(&he->stat, period);
+			if (symbol_conf.cumulate_callchain)
+				hist_entry__add_period(he->stat_acc, period);
 
 			/* If the map of an existing hist_entry has
 			 * become out-of-date due to an exec() or
@@ -316,6 +328,9 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
 	rb_insert_color(&he->rb_node_in, hists->entries_in);
 out:
 	hist_entry__add_cpumode_period(&he->stat, al->cpumode, period);
+	if (symbol_conf.cumulate_callchain)
+		hist_entry__add_cpumode_period(he->stat_acc, al->cpumode,
+					       period);
 out_unlock:
 	pthread_mutex_unlock(&hists->lock);
 	return he;
@@ -432,6 +447,9 @@ static bool hists__collapse_insert_entry(struct hists *hists __maybe_unused,
 
 		if (!cmp) {
 			hist_entry__add_stat(&iter->stat, &he->stat);
+			if (symbol_conf.cumulate_callchain)
+				hist_entry__add_stat(iter->stat_acc,
+						     he->stat_acc);
 
 			if (symbol_conf.use_callchain) {
 				callchain_cursor_reset(&callchain_cursor);
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 2356d085bc54..65b69824bc87 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -61,6 +61,7 @@ struct hist_entry {
 	struct rb_node		rb_node_in;
 	struct rb_node		rb_node;
 	struct he_stat		stat;
+	struct he_stat		*stat_acc;
 	struct map_symbol	ms;
 	struct thread		*thread;
 	u64			ip;
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 4ff45e30c726..d0d65c4ebe6a 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -91,6 +91,7 @@ struct symbol_conf {
 			show_nr_samples,
 			show_total_period,
 			use_callchain,
+			cumulate_callchain,
 			exclude_other,
 			show_cpu_utilization,
 			initialized,
-- 
1.7.11.4

