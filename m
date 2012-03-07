Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030871Ab2CGWl6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 17:41:58 -0500
Received: from intmgw001.ash2.facebook.com ([66.220.155.178]:40189 "EHLO
	intmgw002.ash2.facebook.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S965342Ab2CGWlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 17:41:39 -0500
From: Arun Sharma <asharma@fb.com>
To: linux-kernel@vger.kernel.org
Cc: Arun Sharma <asharma@fb.com>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Tom Zanussi <tzanussi@gmail.com>,
        linux-perf-users@vger.kernel.org
Subject: [PATCH 1/2] perf: refactor add_hist_entry() code paths
Date: Wed,  7 Mar 2012 14:41:18 -0800
Message-Id: <1331160079-13821-2-git-send-email-asharma@fb.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1331160079-13821-1-git-send-email-asharma@fb.com>
References: <1331160079-13821-1-git-send-email-asharma@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes perf__evsel_add_hist_entry() less busy in preparation
for support for sorting by inclusive times.

Signed-off-by: Arun Sharma <asharma@fb.com>
Cc: Ingo Molnar <mingo@elte.hu>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org
Cc: linux-perf-users@vger.kernel.org
---
 builtin-report.c |   12 ++++--------
 util/hist.c      |   20 ++++++++++++++++++++
 util/hist.h      |    5 +++++
 3 files changed, 29 insertions(+), 8 deletions(-)

diff --git a/builtin-report.c b/builtin-report.c
index 25d34d4..72490a4 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -61,6 +61,7 @@ static int perf_evsel__add_hist_entry(struct perf_evsel *evsel,
 	struct symbol *parent = NULL;
 	int err = 0;
 	struct hist_entry *he;
+	struct callchain_cursor *cursor;
 
 	if ((sort__has_parent || symbol_conf.use_callchain) && sample->callchain) {
 		err = machine__resolve_callchain(machine, evsel, al->thread,
@@ -69,17 +70,12 @@ static int perf_evsel__add_hist_entry(struct perf_evsel *evsel,
 			return err;
 	}
 
-	he = __hists__add_entry(&evsel->hists, al, parent, sample->period);
+	cursor = &evsel->hists.callchain_cursor;
+	he = __hists__add_entry_single(&evsel->hists, al, parent,
+				       cursor, sample->period);
 	if (he == NULL)
 		return -ENOMEM;
 
-	if (symbol_conf.use_callchain) {
-		err = callchain_append(he->callchain,
-				       &evsel->hists.callchain_cursor,
-				       sample->period);
-		if (err)
-			return err;
-	}
 	/*
 	 * Only in the newt browser we are doing integrated annotation,
 	 * so we don't allocated the extra space needed because the stdio
diff --git a/util/hist.c b/util/hist.c
index 6f505d1..ca2314a 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -252,6 +252,26 @@ out_unlock:
 	return he;
 }
 
+struct hist_entry *__hists__add_entry_single(struct hists *hists,
+					     struct addr_location *al,
+					     struct symbol *sym_parent,
+					     struct callchain_cursor *cursor,
+					     u64 period)
+{
+	struct hist_entry *he;
+	int err;
+
+	he = __hists__add_entry(hists, al, sym_parent, period);
+	if (he == NULL)
+		return NULL;
+	if (symbol_conf.use_callchain) {
+		err = callchain_append(he->callchain, cursor, period);
+		if (err)
+			return NULL;
+	}
+	return he;
+}
+
 int64_t
 hist_entry__cmp(struct hist_entry *left, struct hist_entry *right)
 {
diff --git a/util/hist.h b/util/hist.h
index 48e5acd..3ed726b 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -68,6 +68,11 @@ struct hists {
 struct hist_entry *__hists__add_entry(struct hists *self,
 				      struct addr_location *al,
 				      struct symbol *parent, u64 period);
+struct hist_entry *__hists__add_entry_single(struct hists *self,
+				      struct addr_location *al,
+				      struct symbol *parent,
+				      struct callchain_cursor *cursor,
+				      u64 period);
 int64_t hist_entry__cmp(struct hist_entry *left, struct hist_entry *right);
 int64_t hist_entry__collapse(struct hist_entry *left, struct hist_entry *right);
 int hist_entry__snprintf(struct hist_entry *self, char *bf, size_t size,
-- 
1.7.8.rc1

