Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816Ab0HVVP4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 17:15:56 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50213 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761Ab0HVVPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 17:15:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=pFhHoEXWjjrbFo5hJul6HwGY8WFMIWJTZHhAEuHdEeejc+095GhTUn/HXDbbsJEojI
         dvMeP1qAGKQVj7cM9lRXmHAkr1DI49NTB1rWGTY4qDupuwHLU7mYtTSq44/VJ1TaTfaI
         kCUUJbhnjs8V4niDBnC5ioxGT/chQJLO1hFso=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/3] perf: Rename append_callchain into callchain_append
Date: Sun, 22 Aug 2010 23:15:39 +0200
Message-Id: <1282511740-22631-3-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1282511740-22631-1-git-send-regression-fweisbec@gmail.com>
References: <1282511740-22631-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do that to start a consistant callchain API namespace.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Christoph Hellwig <hch@infradead.org>
---
 tools/perf/builtin-report.c |    3 ++-
 tools/perf/util/callchain.c |   23 +++++++++++------------
 tools/perf/util/callchain.h |    4 ++--
 3 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 7d35a71..5de405d 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -107,7 +107,8 @@ static int perf_session__add_hist_entry(struct perf_session *self,
 		goto out_free_syms;
 	err = 0;
 	if (symbol_conf.use_callchain) {
-		err = append_chain(he->callchain, data->callchain, syms, data->period);
+		err = callchain_append(he->callchain, data->callchain, syms,
+				       data->period);
 		if (err)
 			goto out_free_syms;
 	}
diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index f0b23f3..59cc0e1 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -284,19 +284,18 @@ split_add_child(struct callchain_node *parent, struct resolved_chain *chain,
 }
 
 static int
-__append_chain(struct callchain_node *root, struct resolved_chain *chain,
-	       unsigned int start, u64 period);
+append_chain(struct callchain_node *root, struct resolved_chain *chain,
+	     unsigned int start, u64 period);
 
 static void
-__append_chain_children(struct callchain_node *root,
-			struct resolved_chain *chain,
-			unsigned int start, u64 period)
+append_chain_children(struct callchain_node *root, struct resolved_chain *chain,
+		      unsigned int start, u64 period)
 {
 	struct callchain_node *rnode;
 
 	/* lookup in childrens */
 	chain_for_each_child(rnode, root) {
-		unsigned int ret = __append_chain(rnode, chain, start, period);
+		unsigned int ret = append_chain(rnode, chain, start, period);
 
 		if (!ret)
 			goto inc_children_hit;
@@ -309,8 +308,8 @@ inc_children_hit:
 }
 
 static int
-__append_chain(struct callchain_node *root, struct resolved_chain *chain,
-	       unsigned int start, u64 period)
+append_chain(struct callchain_node *root, struct resolved_chain *chain,
+	     unsigned int start, u64 period)
 {
 	struct callchain_list *cnode;
 	unsigned int i = start;
@@ -357,7 +356,7 @@ __append_chain(struct callchain_node *root, struct resolved_chain *chain,
 	}
 
 	/* We match the node and still have a part remaining */
-	__append_chain_children(root, chain, i, period);
+	append_chain_children(root, chain, i, period);
 
 	return 0;
 }
@@ -380,8 +379,8 @@ static void filter_context(struct ip_callchain *old, struct resolved_chain *new,
 }
 
 
-int append_chain(struct callchain_root *root, struct ip_callchain *chain,
-		 struct map_symbol *syms, u64 period)
+int callchain_append(struct callchain_root *root, struct ip_callchain *chain,
+		     struct map_symbol *syms, u64 period)
 {
 	struct resolved_chain *filtered;
 
@@ -398,7 +397,7 @@ int append_chain(struct callchain_root *root, struct ip_callchain *chain,
 	if (!filtered->nr)
 		goto end;
 
-	__append_chain_children(&root->node, filtered, 0, period);
+	append_chain_children(&root->node, filtered, 0, period);
 
 	if (filtered->nr > root->max_depth)
 		root->max_depth = filtered->nr;
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index 9b93a38..85b50fb 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -66,8 +66,8 @@ static inline u64 cumul_hits(struct callchain_node *node)
 }
 
 int register_callchain_param(struct callchain_param *param);
-int append_chain(struct callchain_root *root, struct ip_callchain *chain,
-		 struct map_symbol *syms, u64 period);
+int callchain_append(struct callchain_root *root, struct ip_callchain *chain,
+		     struct map_symbol *syms, u64 period);
 
 bool ip_callchain__valid(struct ip_callchain *chain, const event_t *event);
 #endif	/* __PERF_CALLCHAIN_H */
-- 
1.6.2.3

