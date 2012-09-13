Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756503Ab2IMH1X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 03:27:23 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:46467 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756247Ab2IMH1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 03:27:07 -0400
X-AuditID: 9c93016f-b7c19ae000000e6d-0a-50518ac8218b
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Arun Sharma <asharma@fb.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 10/15] perf hists: Accumulate hist entry stat based on the callchain
Date: Thu, 13 Sep 2012 16:20:06 +0900
Message-Id: <1347520811-28150-11-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1347520811-28150-1-git-send-email-namhyung@kernel.org>
References: <1347520811-28150-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Call add_hist_entry() for each callchain node to get an accumulated
stat for an entry.  However skip nodes which do not have symbol info
as they caused subtle problems.

AFAICS the current sort methods cannot distinguish entries with NULL
dso/sym well so that processing a callchian for an entry that doesn't
have symbol info might add a period to a same entry multiple times.
It ended up with an entry that have more than 100% of accumulated
period value which is not good.

Cc: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/hist.c | 58 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index f96298f59e49..2b629f460889 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -387,6 +387,61 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
 	return __add_hist_entry(hists, &entry, al, period, sample_self);
 }
 
+static struct hist_entry *cumulate_hist_entry(struct hists *self,
+					      struct addr_location *al,
+					      struct symbol *sym_parent,
+					      u64 period)
+{
+	unsigned int i;
+	struct hist_entry *he, *he_self;
+	struct callchain_cursor cursor;
+	struct addr_location al_child;
+
+	/*
+	 * make a copy of callchain cursor since callchain_cursor_next()
+	 * can leak callchain cursor nodes otherwise.
+	 */
+	callchain_cursor_copy(&cursor, &callchain_cursor);
+
+	he_self = add_hist_entry(self, al, sym_parent, period, true);
+	if (he_self == NULL)
+		return NULL;
+
+	callchain_cursor_next(&cursor);
+
+	/*
+	 * map, sym and addr in al_child will be updated on a loop below.
+	 * The other fields are kept same as original @al.
+	 */
+	al_child = *al;
+
+	/* add all entries in the original callchain */
+	for (i = 1; i < callchain_cursor.nr; i++) {
+		if (callchain_cursor_peek_al(&cursor, &al_child))
+			return NULL;
+
+		/*
+		 * XXX: Adding an entry without symbol information caused
+		 * subtle problems.  Just skip it for now.
+		 */
+		if (al_child.sym == NULL) {
+			callchain_cursor_next(&cursor);
+			continue;
+		}
+
+		he = add_hist_entry(self, &al_child, sym_parent, period, false);
+		if (he == NULL)
+			return NULL;
+
+		if (callchain_append(he->callchain, &cursor, period))
+			return NULL;
+
+		callchain_cursor_next(&cursor);
+	}
+
+	return he_self;
+}
+
 struct hist_entry *__hists__add_branch_entry(struct hists *self,
 					     struct addr_location *al,
 					     struct symbol *sym_parent,
@@ -418,6 +473,9 @@ struct hist_entry *__hists__add_entry(struct hists *self,
 				      struct addr_location *al,
 				      struct symbol *sym_parent, u64 period)
 {
+	if (symbol_conf.cumulate_callchain)
+		return cumulate_hist_entry(self, al, sym_parent, period);
+
 	return add_hist_entry(self, al, sym_parent, period, true);
 }
 
-- 
1.7.11.4

