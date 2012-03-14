Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761334Ab2CNRgc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 13:36:32 -0400
Received: from intmgw001.ash2.facebook.com ([66.220.155.178]:64603 "EHLO
	intmgw003.ash2.facebook.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1761256Ab2CNRg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 13:36:27 -0400
Date: Wed, 14 Mar 2012 10:36:23 -0700
From: Arun Sharma <asharma@fb.com>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: Arun Sharma <asharma@fb.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>, linux-perf-users@vger.kernel.org
Subject: Re: [PATCH] perf: Add a new sort order: SORT_INCLUSIVE (v3)
Message-ID: <20120314173623.GA6525@dev3310.snc6.facebook.com>
References: <1331664395-30631-1-git-send-email-asharma@fb.com>
 <4F60078D.10905@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F60078D.10905@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 11:50:53AM +0900, Namhyung Kim wrote:
> Hi Arun,
> [...]

Thanks for reviewing. Please take a look at this incremental patch.
I'll mail the v4 patch next.

 -Arun

diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index aa4acde..2b824a5 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -465,7 +465,8 @@ int callchain_get(struct callchain_cursor *cursor,
 {
 	struct callchain_cursor_node *node = cursor->curr;
 
-	if (node == NULL) return -1;
+	if (node == NULL)
+		return -1;
 
 	al->map = node->map;
 	al->sym = node->sym;
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 9d703ec..f3200ea 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -79,7 +79,6 @@ static void hists__calc_col_len(struct hists *hists, struct hist_entry *h)
 static void hist_entry__add_cpumode_period(struct hist_entry *he,
 					   unsigned int cpumode, u64 period)
 {
-	he->period_self += period;
 	switch (cpumode) {
 	case PERF_RECORD_MISC_KERNEL:
 		he->period_sys += period;
@@ -213,7 +212,6 @@ static struct hist_entry *___hists__add_entry(struct hists *hists,
 		.ip	= al->addr,
 		.level	= al->level,
 		.period	= period,
-		.period_self = period,
 		.parent = sym_parent,
 		.filtered = symbol__parent_filter(sym_parent),
 	};
@@ -280,13 +278,11 @@ static struct hist_entry *__hists__add_entry_inclusive(struct hists *hists,
 
 		new_cursor.first = iter.curr;
 		new_cursor.nr = cursor->nr - i;
-		if (i != 0)
-			he->period_self -= period;
-		else
+		if (i == 0) {
+			he->period_self += period;
 			orig_he = he;
-		err = callchain_append(he->callchain,
-				       &new_cursor,
-				       period);
+		}
+		err = callchain_append(he->callchain, &new_cursor, period);
 		if (err)
 			return NULL;
 		callchain_cursor_advance(&iter);
@@ -306,6 +302,7 @@ static struct hist_entry *__hists__add_entry_single(struct hists *hists,
 	he = ___hists__add_entry(hists, al, sym_parent, period);
 	if (he == NULL)
 		return NULL;
+	he->period_self += period;
 	if (symbol_conf.use_callchain) {
 		err = callchain_append(he->callchain, cursor, period);
 		if (err)
@@ -322,7 +319,7 @@ struct hist_entry *__hists__add_entry(struct hists *hists,
 {
 	struct hist_entry *he;
 
-	if (sort__first_dimension == SORT_INCLUSIVE)
+	if (sort__has_inclusive && symbol_conf.use_callchain)
 		he = __hists__add_entry_inclusive(hists, al, parent,
 						  cursor, period);
 	else
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index f7c93d9..9033a62 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -8,6 +8,7 @@ const char	default_sort_order[] = "comm,dso,symbol";
 const char	*sort_order = default_sort_order;
 int		sort__need_collapse = 0;
 int		sort__has_parent = 0;
+int		sort__has_inclusive = 0;
 
 enum sort_type	sort__first_dimension;
 
@@ -291,6 +292,9 @@ int sort_dimension__add(const char *tok)
 			sort__has_parent = 1;
 		}
 
+		if (sd->entry == &sort_sym_inclusive)
+			sort__has_inclusive = 1;
+
 		if (sd->taken)
 			return 0;
 
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index efb145f..97f67d5 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -31,6 +31,7 @@ extern const char *parent_pattern;
 extern const char default_sort_order[];
 extern int sort__need_collapse;
 extern int sort__has_parent;
+extern int sort__has_inclusive;
 extern char *field_sep;
 extern struct sort_entry sort_comm;
 extern struct sort_entry sort_dso;
