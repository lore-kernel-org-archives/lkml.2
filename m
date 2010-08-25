Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787Ab0HYXhO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 19:37:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:49751 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992Ab0HYXhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 19:37:09 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 2/6] perf hists browser: replace rb_first() != NULL by !RB_EMPTY_ROOT()
Date: Wed, 25 Aug 2010 20:36:51 -0300
Message-Id: <1282779415-8544-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1282779415-8544-1-git-send-email-acme@infradead.org>
References: <1282779415-8544-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Its way too stupid to use rb_first() for just caching if there are
children, use the cheaper RB_EMPTY_ROOT() instead.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/ui/browsers/hists.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index 39ba230..e61355e 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -129,16 +129,16 @@ static void callchain_node__init_have_children_rb_tree(struct callchain_node *se
 	for (nd = rb_first(&self->rb_root); nd; nd = rb_next(nd)) {
 		struct callchain_node *child = rb_entry(nd, struct callchain_node, rb_node);
 		struct callchain_list *chain;
-		int first = true;
+		bool first = true;
 
 		list_for_each_entry(chain, &child->val, list) {
 			if (first) {
 				first = false;
 				chain->ms.has_children = chain->list.next != &child->val ||
-							 rb_first(&child->rb_root) != NULL;
+							 !RB_EMPTY_ROOT(&child->rb_root);
 			} else
 				chain->ms.has_children = chain->list.next == &child->val &&
-							 rb_first(&child->rb_root) != NULL;
+							 !RB_EMPTY_ROOT(&child->rb_root);
 		}
 
 		callchain_node__init_have_children_rb_tree(child);
@@ -150,7 +150,7 @@ static void callchain_node__init_have_children(struct callchain_node *self)
 	struct callchain_list *chain;
 
 	list_for_each_entry(chain, &self->val, list)
-		chain->ms.has_children = rb_first(&self->rb_root) != NULL;
+		chain->ms.has_children = !RB_EMPTY_ROOT(&self->rb_root);
 
 	callchain_node__init_have_children_rb_tree(self);
 }
@@ -301,11 +301,11 @@ static int hist_browser__show_callchain_node_rb_tree(struct hist_browser *self,
 			if (first) {
 				first = false;
 				chain->ms.has_children = chain->list.next != &child->val ||
-							 rb_first(&child->rb_root) != NULL;
+							 !RB_EMPTY_ROOT(&child->rb_root);
 			} else {
 				extra_offset = LEVEL_OFFSET_STEP;
 				chain->ms.has_children = chain->list.next == &child->val &&
-							 rb_first(&child->rb_root) != NULL;
+							 !RB_EMPTY_ROOT(&child->rb_root);
 			}
 
 			folded_sign = callchain_list__folded(chain);
@@ -381,7 +381,7 @@ static int hist_browser__show_callchain_node(struct hist_browser *self,
 		 * probably when the callchain is created, so as not to
 		 * traverse it all over again
 		 */
-		chain->ms.has_children = rb_first(&node->rb_root) != NULL;
+		chain->ms.has_children = !RB_EMPTY_ROOT(&node->rb_root);
 		folded_sign = callchain_list__folded(chain);
 
 		if (*row_offset != 0) {
-- 
1.6.2.5

