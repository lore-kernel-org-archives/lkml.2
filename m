Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097Ab0HYXh6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 19:37:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:49752 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091Ab0HYXhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 19:37:10 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 3/6] perf hists browser: Init the has_children fields just once
Date: Wed, 25 Aug 2010 20:36:52 -0300
Message-Id: <1282779415-8544-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1282779415-8544-1-git-send-email-acme@infradead.org>
References: <1282779415-8544-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Not everytime we show the callchains, removing duplicated initialization
of this field.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/ui/browsers/hists.c |   18 ++++--------------
 1 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index e61355e..c17611f 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -298,15 +298,10 @@ static int hist_browser__show_callchain_node_rb_tree(struct hist_browser *self,
 			int color;
 			bool was_first = first;
 
-			if (first) {
+			if (first)
 				first = false;
-				chain->ms.has_children = chain->list.next != &child->val ||
-							 !RB_EMPTY_ROOT(&child->rb_root);
-			} else {
+			else
 				extra_offset = LEVEL_OFFSET_STEP;
-				chain->ms.has_children = chain->list.next == &child->val &&
-							 !RB_EMPTY_ROOT(&child->rb_root);
-			}
 
 			folded_sign = callchain_list__folded(chain);
 			if (*row_offset != 0) {
@@ -376,12 +371,7 @@ static int hist_browser__show_callchain_node(struct hist_browser *self,
 	list_for_each_entry(chain, &node->val, list) {
 		char ipstr[BITS_PER_LONG / 4 + 1], *s;
 		int color;
-		/*
-		 * FIXME: This should be moved to somewhere else,
-		 * probably when the callchain is created, so as not to
-		 * traverse it all over again
-		 */
-		chain->ms.has_children = !RB_EMPTY_ROOT(&node->rb_root);
+
 		folded_sign = callchain_list__folded(chain);
 
 		if (*row_offset != 0) {
@@ -457,7 +447,7 @@ static int hist_browser__show_entry(struct hist_browser *self,
 	}
 
 	if (symbol_conf.use_callchain) {
-		entry->ms.has_children = !RB_EMPTY_ROOT(&entry->sorted_chain);
+		hist_entry__init_have_children(entry);
 		folded_sign = hist_entry__folded(entry);
 	}
 
-- 
1.6.2.5

