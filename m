Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782Ab0HVVPv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 17:15:51 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46134 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763Ab0HVVPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 17:15:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=Tt9NGHfPdNnl1rZfRRhUMh7KakkdAL1SOQoIjcbBWkxQqad7zKTZ5sxpPF/ObRR7zU
         gtbCZh2MGnPe1tI1t16KUwRxaHbPNH5ApUn1Nw67jrAlsfUkLfjOidUvSjFUVvTUxxP3
         aE57Dsv+BsKsGQZC/YUtcUjSTFh+DB3plHTRg=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>
Subject: [PATCH 3/3] perf: Support for callchains merge
Date: Sun, 22 Aug 2010 23:15:40 +0200
Message-Id: <1282511740-22631-4-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1282511740-22631-1-git-send-regression-fweisbec@gmail.com>
References: <1282511740-22631-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we sort the histograms by comm, which is the default,
we need to merge some of them, typically different thread
histograms of a same process, or just same comm. But during
this merge, we forgot to merge callchains.

So imagine we have three threads (tids: 1000, 1001, 1002) that
belong to comm "foo".

tid 1000 got 100 events
tid 1001 got 10 events
tid 1002 got 3 events

Once we merge these histograms to get a per comm result, we'll
finally get:

"foo" got 113 events

The problem is if we merge 1000 and 1001 histograms into 1002, then
the end merge result, wrt callchains, will be only callchains that
belong to 1002.
This is because we haven't handled callchains in the merge. Only those
from one of the threads inside a common comm survive.

It means during this merge, we can lose a lot of callchains.

Fix this by implementing callchains merge and apply it on histograms
that collapse.

Reported-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
---
 tools/perf/util/callchain.c |   56 +++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/callchain.h |    1 +
 tools/perf/util/hist.c      |    2 +
 3 files changed, 59 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index 59cc0e1..e12d539 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -28,6 +28,9 @@ bool ip_callchain__valid(struct ip_callchain *chain, const event_t *event)
 #define chain_for_each_child(child, parent)	\
 	list_for_each_entry(child, &parent->children, brothers)
 
+#define chain_for_each_child_safe(child, next, parent)	\
+	list_for_each_entry_safe(child, next, &parent->children, brothers)
+
 static void
 rb_insert_callchain(struct rb_root *root, struct callchain_node *chain,
 		    enum chain_mode mode)
@@ -406,3 +409,56 @@ end:
 
 	return 0;
 }
+
+static int
+merge_chain_branch(struct callchain_node *dst, struct callchain_node *src,
+		   struct resolved_chain *chain)
+{
+	struct callchain_node *child, *next_child;
+	struct callchain_list *list, *next_list;
+	int old_pos = chain->nr;
+	int err = 0;
+
+	list_for_each_entry_safe(list, next_list, &src->val, list) {
+		chain->ips[chain->nr].ip = list->ip;
+		chain->ips[chain->nr].ms = list->ms;
+		chain->nr++;
+		list_del(&list->list);
+		free(list);
+	}
+
+	if (src->hit)
+		append_chain_children(dst, chain, 0, src->hit);
+
+	chain_for_each_child_safe(child, next_child, src) {
+		err = merge_chain_branch(dst, child, chain);
+		if (err)
+			break;
+
+		list_del(&child->brothers);
+		free(child);
+	}
+
+	chain->nr = old_pos;
+
+	return err;
+}
+
+int callchain_merge(struct callchain_root *dst, struct callchain_root *src)
+{
+	struct resolved_chain *chain;
+	int err;
+
+	chain = malloc(sizeof(*chain) +
+		       src->max_depth * sizeof(struct resolved_ip));
+	if (!chain)
+		return -ENOMEM;
+
+	chain->nr = 0;
+
+	err = merge_chain_branch(&dst->node, &src->node, chain);
+
+	free(chain);
+
+	return err;
+}
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index 85b50fb..51a8f2b 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -68,6 +68,7 @@ static inline u64 cumul_hits(struct callchain_node *node)
 int register_callchain_param(struct callchain_param *param);
 int callchain_append(struct callchain_root *root, struct ip_callchain *chain,
 		     struct map_symbol *syms, u64 period);
+int callchain_merge(struct callchain_root *dst, struct callchain_root *src);
 
 bool ip_callchain__valid(struct ip_callchain *chain, const event_t *event);
 #endif	/* __PERF_CALLCHAIN_H */
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index e77ff77..2022e87 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -226,6 +226,8 @@ static bool collapse__insert_entry(struct rb_root *root, struct hist_entry *he)
 
 		if (!cmp) {
 			iter->period += he->period;
+			if (symbol_conf.use_callchain)
+				callchain_merge(iter->callchain, he->callchain);
 			hist_entry__free(he);
 			return false;
 		}
-- 
1.6.2.3

