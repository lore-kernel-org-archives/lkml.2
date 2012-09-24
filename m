Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569Ab2IXPcv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 11:32:51 -0400
Received: from mga03.intel.com ([143.182.124.21]:23562 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756407Ab2IXPaa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 11:30:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,476,1344236400"; 
   d="scan'208";a="196413148"
From: Feng Tang <feng.tang@intel.com>
To: acme@redhat.com
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, andi@firstfloor.org,
        namhyung@kernel.org, dsahern@gmail.com, linux-kernel@vger.kernel.org,
        Feng Tang <feng.tang@intel.com>
Subject: [PATCH v3 1/9] perf hists: Move hists_init() from util/evsel.c to util/hist.c
Date: Mon, 24 Sep 2012 23:24:03 +0800
Message-Id: <1348500251-9937-2-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1348500251-9937-1-git-send-email-feng.tang@intel.com>
References: <1348500251-9937-1-git-send-email-feng.tang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Which looks more natural

Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 tools/perf/util/evsel.c |   10 ----------
 tools/perf/util/evsel.h |    2 --
 tools/perf/util/hist.c  |   10 ++++++++++
 tools/perf/util/hist.h  |    1 +
 4 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 1506ba0..4c7328d 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -39,16 +39,6 @@ static int __perf_evsel__sample_size(u64 sample_type)
 	return size;
 }
 
-void hists__init(struct hists *hists)
-{
-	memset(hists, 0, sizeof(*hists));
-	hists->entries_in_array[0] = hists->entries_in_array[1] = RB_ROOT;
-	hists->entries_in = &hists->entries_in_array[0];
-	hists->entries_collapsed = RB_ROOT;
-	hists->entries = RB_ROOT;
-	pthread_mutex_init(&hists->lock, NULL);
-}
-
 void perf_evsel__init(struct perf_evsel *evsel,
 		      struct perf_event_attr *attr, int idx)
 {
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 93876ba..af0bc97 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -197,8 +197,6 @@ static inline int perf_evsel__read_scaled(struct perf_evsel *evsel,
 	return __perf_evsel__read(evsel, ncpus, nthreads, true);
 }
 
-void hists__init(struct hists *hists);
-
 int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
 			     struct perf_sample *sample, bool swapped);
 
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 6ec5398..d3689e5 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -690,3 +690,13 @@ void hists__inc_nr_events(struct hists *hists, u32 type)
 	++hists->stats.nr_events[0];
 	++hists->stats.nr_events[type];
 }
+
+void hists__init(struct hists *hists)
+{
+	memset(hists, 0, sizeof(*hists));
+	hists->entries_in_array[0] = hists->entries_in_array[1] = RB_ROOT;
+	hists->entries_in = &hists->entries_in_array[0];
+	hists->entries_collapsed = RB_ROOT;
+	hists->entries = RB_ROOT;
+	pthread_mutex_init(&hists->lock, NULL);
+}
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index f011ad4..4edfb74 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -70,6 +70,7 @@ struct hists {
 	u16			col_len[HISTC_NR_COLS];
 };
 
+void hists__init(struct hists *hists);
 struct hist_entry *__hists__add_entry(struct hists *self,
 				      struct addr_location *al,
 				      struct symbol *parent, u64 period);
-- 
1.7.1

