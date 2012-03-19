Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032900Ab2CSUCs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 16:02:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39964 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031285Ab2CSUCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 16:02:45 -0400
Date: Mon, 19 Mar 2012 13:02:24 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-e94d53ebec2fb4795c18ad2e76ec633390b1e794@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, tglx@linutronix.de, namhyung@gmail.com,
        mingo@elte.hu
In-Reply-To: <1331887855-874-1-git-send-email-namhyung.kim@lge.com>
References: <1331887855-874-1-git-send-email-namhyung.kim@lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf hists: Add hists__filter_by_symbol
Git-Commit-ID: e94d53ebec2fb4795c18ad2e76ec633390b1e794
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 19 Mar 2012 13:02:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e94d53ebec2fb4795c18ad2e76ec633390b1e794
Gitweb:     http://git.kernel.org/tip/e94d53ebec2fb4795c18ad2e76ec633390b1e794
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Fri, 16 Mar 2012 17:50:51 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 16 Mar 2012 16:31:09 -0300

perf hists: Add hists__filter_by_symbol

This function will be used for simple (sub-)string matching filter based
on user input.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1331887855-874-1-git-send-email-namhyung.kim@lge.com
Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/hist.c |   35 +++++++++++++++++++++++++++++++++++
 tools/perf/util/hist.h |    2 ++
 2 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 8380c3d..2c624ad 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -10,11 +10,14 @@ static bool hists__filter_entry_by_dso(struct hists *hists,
 				       struct hist_entry *he);
 static bool hists__filter_entry_by_thread(struct hists *hists,
 					  struct hist_entry *he);
+static bool hists__filter_entry_by_symbol(struct hists *hists,
+					  struct hist_entry *he);
 
 enum hist_filter {
 	HIST_FILTER__DSO,
 	HIST_FILTER__THREAD,
 	HIST_FILTER__PARENT,
+	HIST_FILTER__SYMBOL,
 };
 
 struct callchain_param	callchain_param = {
@@ -420,6 +423,7 @@ static void hists__apply_filters(struct hists *hists, struct hist_entry *he)
 {
 	hists__filter_entry_by_dso(hists, he);
 	hists__filter_entry_by_thread(hists, he);
+	hists__filter_entry_by_symbol(hists, he);
 }
 
 static void __hists__collapse_resort(struct hists *hists, bool threaded)
@@ -1247,6 +1251,37 @@ void hists__filter_by_thread(struct hists *hists)
 	}
 }
 
+static bool hists__filter_entry_by_symbol(struct hists *hists,
+					  struct hist_entry *he)
+{
+	if (hists->symbol_filter_str != NULL &&
+	    (!he->ms.sym || strstr(he->ms.sym->name,
+				   hists->symbol_filter_str) == NULL)) {
+		he->filtered |= (1 << HIST_FILTER__SYMBOL);
+		return true;
+	}
+
+	return false;
+}
+
+void hists__filter_by_symbol(struct hists *hists)
+{
+	struct rb_node *nd;
+
+	hists->nr_entries = hists->stats.total_period = 0;
+	hists->stats.nr_events[PERF_RECORD_SAMPLE] = 0;
+	hists__reset_col_len(hists);
+
+	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
+		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
+
+		if (hists__filter_entry_by_symbol(hists, h))
+			continue;
+
+		hists__remove_entry_filter(hists, h, HIST_FILTER__SYMBOL);
+	}
+}
+
 int hist_entry__inc_addr_samples(struct hist_entry *he, int evidx, u64 ip)
 {
 	return symbol__inc_addr_samples(he->ms.sym, he->ms.map, evidx, ip);
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 9413f3e..10343c0 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -62,6 +62,7 @@ struct hists {
 	const struct thread	*thread_filter;
 	const struct dso	*dso_filter;
 	const char		*uid_filter_str;
+	const char		*symbol_filter_str;
 	pthread_mutex_t		lock;
 	struct events_stats	stats;
 	u64			event_stream;
@@ -107,6 +108,7 @@ int hist_entry__annotate(struct hist_entry *self, size_t privsize);
 
 void hists__filter_by_dso(struct hists *hists);
 void hists__filter_by_thread(struct hists *hists);
+void hists__filter_by_symbol(struct hists *hists);
 
 u16 hists__col_len(struct hists *self, enum hist_column col);
 void hists__set_col_len(struct hists *self, enum hist_column col, u16 len);
