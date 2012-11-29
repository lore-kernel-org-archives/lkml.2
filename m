Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946Ab2K2GjN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 01:39:13 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:50052 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269Ab2K2GjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 01:39:05 -0500
X-AuditID: 9c93016f-b7b86ae000003a75-aa-50b70308f5ca
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 01/18] perf evsel: Set leader evsel's ->leader to itself
Date: Thu, 29 Nov 2012 15:38:29 +0900
Message-Id: <1354171126-14387-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1354171126-14387-1-git-send-email-namhyung@kernel.org>
References: <1354171126-14387-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Currently only non-leader members are set ->leader to the leader evsel
of the group and the leader has set NULL.  Thus it requires special
casing for leader evsels.  Set ->leader to itself will remove this.

Suggested-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/evlist.c | 1 -
 tools/perf/util/evsel.c  | 1 +
 tools/perf/util/evsel.h  | 2 +-
 3 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 705293489e3c..90db2a14e4bb 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -111,7 +111,6 @@ void __perf_evlist__set_leader(struct list_head *list)
 	struct perf_evsel *evsel, *leader;
 
 	leader = list_entry(list->next, struct perf_evsel, node);
-	leader->leader = NULL;
 
 	list_for_each_entry(evsel, list, node) {
 		if (evsel != leader)
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 1fb636c550a1..ceabe05c6b12 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -55,6 +55,7 @@ void perf_evsel__init(struct perf_evsel *evsel,
 {
 	evsel->idx	   = idx;
 	evsel->attr	   = *attr;
+	evsel->leader	   = evsel;
 	INIT_LIST_HEAD(&evsel->node);
 	hists__init(&evsel->hists);
 	evsel->sample_size = __perf_evsel__sample_size(attr->sample_type);
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index a4c1dd4e149f..d504668e7ae5 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -228,6 +228,6 @@ static inline struct perf_evsel *perf_evsel__next(struct perf_evsel *evsel)
 
 static inline bool perf_evsel__is_group_member(const struct perf_evsel *evsel)
 {
-	return evsel->leader != NULL;
+	return evsel->leader != evsel;
 }
 #endif /* __PERF_EVSEL_H */
-- 
1.7.11.7

