Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905Ab2LJIbN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 03:31:13 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:55008 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053Ab2LJIaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 03:30:01 -0500
X-AuditID: 9c930197-b7bd3ae000003f1c-29-50c59d87deee
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        namhyung.kim@lge.com
Subject: [PATCH 1/4] perf hists: Exchange order of comparing items when collapsing hists
Date: Mon, 10 Dec 2012 17:29:54 +0900
Message-Id: <1355128197-18193-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1355128197-18193-1-git-send-email-namhyung@kernel.org>
References: <1355128197-18193-1-git-send-email-namhyung@kernel.org>
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
 tools/perf/builtin-diff.c |  2 +-
 tools/perf/util/hist.c    | 12 +++++++++---
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index b2e7d39f099b..4dda6f4dc618 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -285,7 +285,7 @@ static void insert_hist_entry_by_name(struct rb_root *root,
 	while (*p != NULL) {
 		parent = *p;
 		iter = rb_entry(parent, struct hist_entry, rb_node);
-		if (hist_entry__cmp(he, iter) < 0)
+		if (hist_entry__cmp(iter, he) < 0)
 			p = &(*p)->rb_left;
 		else
 			p = &(*p)->rb_right;
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 82df1b26f0d4..3a9ccd09835d 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -285,7 +285,13 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
 		parent = *p;
 		he = rb_entry(parent, struct hist_entry, rb_node_in);
 
-		cmp = hist_entry__cmp(entry, he);
+		/*
+		 * Make sure that it receives arguments in a same order as
+		 * hist_entry__collapse() so that we can use an appropriate
+		 * function when searching an entry regardless which sort
+		 * keys were used.
+		 */
+		cmp = hist_entry__cmp(he, entry);
 
 		if (!cmp) {
 			he_stat__add_period(&he->stat, period);
@@ -729,7 +735,7 @@ static struct hist_entry *hists__add_dummy_entry(struct hists *hists,
 		parent = *p;
 		he = rb_entry(parent, struct hist_entry, rb_node);
 
-		cmp = hist_entry__cmp(pair, he);
+		cmp = hist_entry__cmp(he, pair);
 
 		if (!cmp)
 			goto out;
@@ -759,7 +765,7 @@ static struct hist_entry *hists__find_entry(struct hists *hists,
 
 	while (n) {
 		struct hist_entry *iter = rb_entry(n, struct hist_entry, rb_node);
-		int64_t cmp = hist_entry__cmp(he, iter);
+		int64_t cmp = hist_entry__cmp(iter, he);
 
 		if (cmp < 0)
 			n = n->rb_left;
-- 
1.7.11.7

