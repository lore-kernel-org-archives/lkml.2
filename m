Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756429Ab2IMH1R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 03:27:17 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:57860 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756241Ab2IMH1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 03:27:07 -0400
X-AuditID: 9c93016f-b7c19ae000000e6d-07-50518ac75e09
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Arun Sharma <asharma@fb.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 09/15] perf hists: Let add_hist_entry to make a hist entry template
Date: Thu, 13 Sep 2012 16:20:05 +0900
Message-Id: <1347520811-28150-10-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1347520811-28150-1-git-send-email-namhyung@kernel.org>
References: <1347520811-28150-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Change the add_hist_entry() to make a template based on given @al.
It makes the callchain cumulation code simpler.

Cc: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/hist.c | 50 +++++++++++++++++++++++++++++---------------------
 1 file changed, 29 insertions(+), 21 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 46433a0830dd..f96298f59e49 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -299,10 +299,10 @@ static u8 symbol__parent_filter(const struct symbol *parent)
 	return 0;
 }
 
-static struct hist_entry *add_hist_entry(struct hists *hists,
-				      struct hist_entry *entry,
-				      struct addr_location *al,
-				      u64 period, bool sample_self)
+static struct hist_entry *__add_hist_entry(struct hists *hists,
+					   struct hist_entry *entry,
+					   struct addr_location *al,
+					   u64 period, bool sample_self)
 {
 	struct rb_node **p;
 	struct rb_node *parent = NULL;
@@ -362,20 +362,19 @@ out_unlock:
 	return he;
 }
 
-struct hist_entry *__hists__add_branch_entry(struct hists *self,
-					     struct addr_location *al,
-					     struct symbol *sym_parent,
-					     struct branch_info *bi,
-					     u64 period)
+static struct hist_entry *add_hist_entry(struct hists *hists,
+					 struct addr_location *al,
+					 struct symbol *sym_parent,
+					 u64 period, bool sample_self)
 {
 	struct hist_entry entry = {
 		.thread	= al->thread,
 		.ms = {
-			.map	= bi->to.map,
-			.sym	= bi->to.sym,
+			.map	= al->map,
+			.sym	= al->sym,
 		},
 		.cpu	= al->cpu,
-		.ip	= bi->to.addr,
+		.ip	= al->addr,
 		.level	= al->level,
 		.stat = {
 			.period	= period,
@@ -383,24 +382,25 @@ struct hist_entry *__hists__add_branch_entry(struct hists *self,
 		},
 		.parent = sym_parent,
 		.filtered = symbol__parent_filter(sym_parent),
-		.branch_info = bi,
 	};
 
-	return add_hist_entry(self, &entry, al, period, true);
+	return __add_hist_entry(hists, &entry, al, period, sample_self);
 }
 
-struct hist_entry *__hists__add_entry(struct hists *self,
-				      struct addr_location *al,
-				      struct symbol *sym_parent, u64 period)
+struct hist_entry *__hists__add_branch_entry(struct hists *self,
+					     struct addr_location *al,
+					     struct symbol *sym_parent,
+					     struct branch_info *bi,
+					     u64 period)
 {
 	struct hist_entry entry = {
 		.thread	= al->thread,
 		.ms = {
-			.map	= al->map,
-			.sym	= al->sym,
+			.map	= bi->to.map,
+			.sym	= bi->to.sym,
 		},
 		.cpu	= al->cpu,
-		.ip	= al->addr,
+		.ip	= bi->to.addr,
 		.level	= al->level,
 		.stat = {
 			.period	= period,
@@ -408,9 +408,17 @@ struct hist_entry *__hists__add_entry(struct hists *self,
 		},
 		.parent = sym_parent,
 		.filtered = symbol__parent_filter(sym_parent),
+		.branch_info = bi,
 	};
 
-	return add_hist_entry(self, &entry, al, period, true);
+	return __add_hist_entry(self, &entry, al, period, true);
+}
+
+struct hist_entry *__hists__add_entry(struct hists *self,
+				      struct addr_location *al,
+				      struct symbol *sym_parent, u64 period)
+{
+	return add_hist_entry(self, al, sym_parent, period, true);
 }
 
 int64_t
-- 
1.7.11.4

