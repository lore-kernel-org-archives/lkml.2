Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746Ab0H3Iei (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 04:34:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:54097 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754722Ab0H3Ieg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 04:34:36 -0400
Date: Mon, 30 Aug 2010 08:34:14 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, acme@redhat.com,
        hpa@zytor.com, mingo@redhat.com, peterz@infradead.org, efault@gmx.de,
        fweisbec@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, eranian@google.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com, efault@gmx.de,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf hists browser: replace rb_first() != NULL by !RB_EMPTY_ROOT()
Message-ID: <tip-293db47f4753f5746e5aaa998ceb24dff662cf7e@git.kernel.org>
Git-Commit-ID: 293db47f4753f5746e5aaa998ceb24dff662cf7e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 30 Aug 2010 08:34:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  293db47f4753f5746e5aaa998ceb24dff662cf7e
Gitweb:     http://git.kernel.org/tip/293db47f4753f5746e5aaa998ceb24dff662cf7e
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 25 Aug 2010 16:05:36 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 25 Aug 2010 16:05:36 -0300

perf hists browser: replace rb_first() != NULL by !RB_EMPTY_ROOT()

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
