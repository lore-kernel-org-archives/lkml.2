Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387Ab2L0JN7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 04:13:59 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:50609 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164Ab2L0JMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 04:12:31 -0500
X-AuditID: 9c93016f-b7b54ae000000e9e-17-50dc10fb4d25
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 06/10] perf sort: Drop ip_[lr] arguments from _sort__sym_cmp()
Date: Thu, 27 Dec 2012 18:11:43 +0900
Message-Id: <1356599507-14226-7-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1356599507-14226-1-git-send-email-namhyung@kernel.org>
References: <1356599507-14226-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Current _sort__sym_cmp() function is used for comparing symbols
between two hist entries on symbol, symbol_from and symbol_to sort
keys.  Those functions pass addresses of symbols but it's meaningless
since it gets over-written inside of the _sort__sym_cmp function to a
start address of the symbol.  So just get rid of them.

This might cause a difference than prior output for branch stacks
since it seems not using start address of the symbol but branch
address.  However AFAICS it'd be same as it gets overwritten anyway.

Also remove redundant part of code in sort__sym_cmp().

Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/sort.c | 23 ++++++-----------------
 1 file changed, 6 insertions(+), 17 deletions(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index a36051b34901..c02964cabdd0 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -160,9 +160,10 @@ struct sort_entry sort_dso = {
 
 /* --sort symbol */
 
-static int64_t _sort__sym_cmp(struct symbol *sym_l, struct symbol *sym_r,
-			      u64 ip_l, u64 ip_r)
+static int64_t _sort__sym_cmp(struct symbol *sym_l, struct symbol *sym_r)
 {
+	u64 ip_l, ip_r;
+
 	if (!sym_l || !sym_r)
 		return cmp_null(sym_l, sym_r);
 
@@ -178,21 +179,10 @@ static int64_t _sort__sym_cmp(struct symbol *sym_l, struct symbol *sym_r,
 static int64_t
 sort__sym_cmp(struct hist_entry *left, struct hist_entry *right)
 {
-	u64 ip_l, ip_r;
-
 	if (!left->ms.sym && !right->ms.sym)
 		return right->level - left->level;
 
-	if (!left->ms.sym || !right->ms.sym)
-		return cmp_null(left->ms.sym, right->ms.sym);
-
-	if (left->ms.sym == right->ms.sym)
-		return 0;
-
-	ip_l = left->ms.sym->start;
-	ip_r = right->ms.sym->start;
-
-	return _sort__sym_cmp(left->ms.sym, right->ms.sym, ip_l, ip_r);
+	return _sort__sym_cmp(left->ms.sym, right->ms.sym);
 }
 
 static int _hist_entry__sym_snprintf(struct map *map, struct symbol *sym,
@@ -380,8 +370,7 @@ sort__sym_from_cmp(struct hist_entry *left, struct hist_entry *right)
 	if (!from_l->sym && !from_r->sym)
 		return right->level - left->level;
 
-	return _sort__sym_cmp(from_l->sym, from_r->sym, from_l->addr,
-			     from_r->addr);
+	return _sort__sym_cmp(from_l->sym, from_r->sym);
 }
 
 static int64_t
@@ -393,7 +382,7 @@ sort__sym_to_cmp(struct hist_entry *left, struct hist_entry *right)
 	if (!to_l->sym && !to_r->sym)
 		return right->level - left->level;
 
-	return _sort__sym_cmp(to_l->sym, to_r->sym, to_l->addr, to_r->addr);
+	return _sort__sym_cmp(to_l->sym, to_r->sym);
 }
 
 static int hist_entry__sym_from_snprintf(struct hist_entry *self, char *bf,
-- 
1.7.11.7

