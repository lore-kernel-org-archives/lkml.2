Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931Ab2LEG4u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 01:56:50 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:44066 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787Ab2LEG4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 01:56:46 -0500
X-AuditID: 9c93016f-b7b86ae000003a75-29-50bef02d5bd0
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 1/3] perf hists: Exchange order of comparing items when collapsing hists
Date: Wed,  5 Dec 2012 15:56:41 +0900
Message-Id: <1354690603-31364-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1354690603-31364-1-git-send-email-namhyung@kernel.org>
References: <1354690603-31364-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

When comparing entries for collapsing put the given entry first, and
then the iterated entry.  This is not the case of hist_entry__cmp()
when called if given sort keys don't require collapsing.  So change
the order for the sake of consistency.  It will be required for
matching and/or linking multiple hist entries.

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/hist.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 82df1b26f0d4..d4471c21ed17 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -285,7 +285,7 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
 		parent = *p;
 		he = rb_entry(parent, struct hist_entry, rb_node_in);
 
-		cmp = hist_entry__cmp(entry, he);
+		cmp = hist_entry__cmp(he, entry);
 
 		if (!cmp) {
 			he_stat__add_period(&he->stat, period);
@@ -729,7 +729,7 @@ static struct hist_entry *hists__add_dummy_entry(struct hists *hists,
 		parent = *p;
 		he = rb_entry(parent, struct hist_entry, rb_node);
 
-		cmp = hist_entry__cmp(pair, he);
+		cmp = hist_entry__cmp(he, pair);
 
 		if (!cmp)
 			goto out;
@@ -759,7 +759,7 @@ static struct hist_entry *hists__find_entry(struct hists *hists,
 
 	while (n) {
 		struct hist_entry *iter = rb_entry(n, struct hist_entry, rb_node);
-		int64_t cmp = hist_entry__cmp(he, iter);
+		int64_t cmp = hist_entry__cmp(iter, he);
 
 		if (cmp < 0)
 			n = n->rb_left;
-- 
1.7.11.7

