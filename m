Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab0H3Ie7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 04:34:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:54113 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753528Ab0H3Ie5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 04:34:57 -0400
Date: Mon, 30 Aug 2010 08:34:35 GMT
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
Subject: [tip:perf/core] perf hists browser: Init the has_children fields just once
Message-ID: <tip-163caed90203a7cab66326ce2be138715dc7c5da@git.kernel.org>
Git-Commit-ID: 163caed90203a7cab66326ce2be138715dc7c5da
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 30 Aug 2010 08:34:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  163caed90203a7cab66326ce2be138715dc7c5da
Gitweb:     http://git.kernel.org/tip/163caed90203a7cab66326ce2be138715dc7c5da
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 25 Aug 2010 16:30:03 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 25 Aug 2010 16:30:03 -0300

perf hists browser: Init the has_children fields just once

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
 
