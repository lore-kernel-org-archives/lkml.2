Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588Ab1ANDwb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 22:52:31 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55586 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757531Ab1ANDwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 22:52:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=krsAgGIBeWjmjJ/Bt0F7KRf3MTaPdrJoQAyJoNs3ZHQnVEV3Vll+BFdTVFTCgKl2h1
         TZl2CqxFVCIpPVFo2R/8WCpyac68Qrk7fk9p6WHWf69nAsgTgm71rKsIJ0jVWnjZNAVC
         l4XB+9+co8lnk+m5LsOfN7GU2Aj5OWr6WFkXk=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>
Subject: [PATCH 2/4] perf: Rename cumul_hits into callchain_cumul_hits
Date: Fri, 14 Jan 2011 04:51:59 +0100
Message-Id: <1294977121-5700-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1294977121-5700-1-git-send-email-fweisbec@gmail.com>
References: <1294977121-5700-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That makes the callchain API naming more consistent and
reduce potential naming clashes.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
---
 tools/perf/util/callchain.c         |   10 +++++-----
 tools/perf/util/callchain.h         |    2 +-
 tools/perf/util/hist.c              |    2 +-
 tools/perf/util/ui/browsers/hists.c |    2 +-
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index 53a49e0..4c6360f 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -38,14 +38,14 @@ rb_insert_callchain(struct rb_root *root, struct callchain_node *chain,
 	struct rb_node **p = &root->rb_node;
 	struct rb_node *parent = NULL;
 	struct callchain_node *rnode;
-	u64 chain_cumul = cumul_hits(chain);
+	u64 chain_cumul = callchain_cumul_hits(chain);
 
 	while (*p) {
 		u64 rnode_cumul;
 
 		parent = *p;
 		rnode = rb_entry(parent, struct callchain_node, rb_node);
-		rnode_cumul = cumul_hits(rnode);
+		rnode_cumul = callchain_cumul_hits(rnode);
 
 		switch (mode) {
 		case CHAIN_FLAT:
@@ -104,7 +104,7 @@ static void __sort_chain_graph_abs(struct callchain_node *node,
 
 	chain_for_each_child(child, node) {
 		__sort_chain_graph_abs(child, min_hit);
-		if (cumul_hits(child) >= min_hit)
+		if (callchain_cumul_hits(child) >= min_hit)
 			rb_insert_callchain(&node->rb_root, child,
 					    CHAIN_GRAPH_ABS);
 	}
@@ -129,7 +129,7 @@ static void __sort_chain_graph_rel(struct callchain_node *node,
 
 	chain_for_each_child(child, node) {
 		__sort_chain_graph_rel(child, min_percent);
-		if (cumul_hits(child) >= min_hit)
+		if (callchain_cumul_hits(child) >= min_hit)
 			rb_insert_callchain(&node->rb_root, child,
 					    CHAIN_GRAPH_REL);
 	}
@@ -270,7 +270,7 @@ split_add_child(struct callchain_node *parent,
 	/* split the hits */
 	new->hit = parent->hit;
 	new->children_hit = parent->children_hit;
-	parent->children_hit = cumul_hits(new);
+	parent->children_hit = callchain_cumul_hits(new);
 	new->val_nr = parent->val_nr - idx_local;
 	parent->val_nr = idx_local;
 
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index d74a19a..07f71e3 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -82,7 +82,7 @@ static inline void callchain_init(struct callchain_root *root)
 	root->max_depth = 0;
 }
 
-static inline u64 cumul_hits(struct callchain_node *node)
+static inline u64 callchain_cumul_hits(struct callchain_node *node)
 {
 	return node->hit + node->children_hit;
 }
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index e876a66..03f5a47 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -430,7 +430,7 @@ static size_t __callchain__fprintf_graph(FILE *fp, struct callchain_node *self,
 		u64 cumul;
 
 		child = rb_entry(node, struct callchain_node, rb_node);
-		cumul = cumul_hits(child);
+		cumul = callchain_cumul_hits(child);
 		remaining -= cumul;
 
 		/*
diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index ebda8c3..41ee5ae 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -377,7 +377,7 @@ static int hist_browser__show_callchain_node_rb_tree(struct hist_browser *self,
 	while (node) {
 		struct callchain_node *child = rb_entry(node, struct callchain_node, rb_node);
 		struct rb_node *next = rb_next(node);
-		u64 cumul = cumul_hits(child);
+		u64 cumul = callchain_cumul_hits(child);
 		struct callchain_list *chain;
 		char folded_sign = ' ';
 		int first = true;
-- 
1.7.3.2

