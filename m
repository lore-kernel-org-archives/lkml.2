Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423758Ab2LFPMs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 10:12:48 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36311 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964785Ab2LFPLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 10:11:53 -0500
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 2/5] perf hists: Exchange order of comparing items when collapsing hists
Date: Fri,  7 Dec 2012 00:09:38 +0900
Message-Id: <1354806581-5316-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1354806581-5316-1-git-send-email-namhyung@kernel.org>
References: <1354806581-5316-1-git-send-email-namhyung@kernel.org>
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
 tools/perf/util/hist.c |    6 +++---
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
1.7.9.2

