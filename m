Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652Ab2CaHli (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 03:41:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54751 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274Ab2CaHlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 03:41:36 -0400
Date: Sat, 31 Mar 2012 00:41:05 -0700
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Message-ID: <tip-6d4818c5245fe00bee2c3bfb45edde178f302703@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        jolsa@redhat.com, fweisbec@gmail.com, benh@kernel.crashing.org,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        jolsa@redhat.com, fweisbec@gmail.com, benh@kernel.crashing.org,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1332526010-15400-1-git-send-email-fweisbec@gmail.com>
References: <1332526010-15400-1-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools:
  Fix display of first level of callchains
Git-Commit-ID: 6d4818c5245fe00bee2c3bfb45edde178f302703
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 31 Mar 2012 00:41:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6d4818c5245fe00bee2c3bfb45edde178f302703
Gitweb:     http://git.kernel.org/tip/6d4818c5245fe00bee2c3bfb45edde178f302703
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Fri, 23 Mar 2012 19:06:50 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 26 Mar 2012 15:14:40 -0300

perf tools: Fix display of first level of callchains

The callchain stdio mode display was written using a sorted by symbol
report. In this mode we have only one callchain root per hist so we
forgot to handle cases where we have multiple callchain root, as in per
dso sorting for example.

Fix this by handling these roots like any other branch, with the hist as
the parent.

Before:

     1.97%  libpthread-2.12.1.so
            |
            --- __libc_write
                create_worker
                bench_sched_messaging
                cmd_bench
                run_builtin
                main
                __libc_start_main

            |
            --- __libc_read
                create_worker
                bench_sched_messaging
                cmd_bench
                run_builtin
                main
                __libc_start_main

After:

     1.97%  libpthread-2.12.1.so
            |
            |--36.97%-- __libc_write
            |          create_worker
            |          bench_sched_messaging
            |          cmd_bench
            |          run_builtin
            |          main
            |          __libc_start_main
            |
            |--31.47%-- __libc_read
            |          create_worker
            |          bench_sched_messaging
            |          cmd_bench
            |          run_builtin
            |          main
            |          __libc_start_main
           ...

Single roots keep their entry without percentage because they have
the same overhead than the hist they refer to. ie: 100% in fractal
mode and the percentage of the hist in graph mode:

     0.00%  [k] reschedule_interrupt
            |
            --- default_idle
                amd_e400_idle
                cpu_idle
                start_secondary

Reported-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1332526010-15400-1-git-send-email-fweisbec@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/hist.c |  159 ++++++++++++++++++++++++++++--------------------
 1 files changed, 94 insertions(+), 65 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index c61235f..2ec4b60 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -607,7 +607,7 @@ static void init_rem_hits(void)
 	rem_hits.ms.sym = rem_sq_bracket;
 }
 
-static size_t __callchain__fprintf_graph(FILE *fp, struct callchain_node *self,
+static size_t __callchain__fprintf_graph(FILE *fp, struct rb_root *root,
 					 u64 total_samples, int depth,
 					 int depth_mask, int left_margin)
 {
@@ -615,21 +615,16 @@ static size_t __callchain__fprintf_graph(FILE *fp, struct callchain_node *self,
 	struct callchain_node *child;
 	struct callchain_list *chain;
 	int new_depth_mask = depth_mask;
-	u64 new_total;
 	u64 remaining;
 	size_t ret = 0;
 	int i;
 	uint entries_printed = 0;
 
-	if (callchain_param.mode == CHAIN_GRAPH_REL)
-		new_total = self->children_hit;
-	else
-		new_total = total_samples;
-
-	remaining = new_total;
+	remaining = total_samples;
 
-	node = rb_first(&self->rb_root);
+	node = rb_first(root);
 	while (node) {
+		u64 new_total;
 		u64 cumul;
 
 		child = rb_entry(node, struct callchain_node, rb_node);
@@ -657,11 +652,17 @@ static size_t __callchain__fprintf_graph(FILE *fp, struct callchain_node *self,
 		list_for_each_entry(chain, &child->val, list) {
 			ret += ipchain__fprintf_graph(fp, chain, depth,
 						      new_depth_mask, i++,
-						      new_total,
+						      total_samples,
 						      cumul,
 						      left_margin);
 		}
-		ret += __callchain__fprintf_graph(fp, child, new_total,
+
+		if (callchain_param.mode == CHAIN_GRAPH_REL)
+			new_total = child->children_hit;
+		else
+			new_total = total_samples;
+
+		ret += __callchain__fprintf_graph(fp, &child->rb_root, new_total,
 						  depth + 1,
 						  new_depth_mask | (1 << depth),
 						  left_margin);
@@ -671,61 +672,75 @@ static size_t __callchain__fprintf_graph(FILE *fp, struct callchain_node *self,
 	}
 
 	if (callchain_param.mode == CHAIN_GRAPH_REL &&
-		remaining && remaining != new_total) {
+		remaining && remaining != total_samples) {
 
 		if (!rem_sq_bracket)
 			return ret;
 
 		new_depth_mask &= ~(1 << (depth - 1));
-
 		ret += ipchain__fprintf_graph(fp, &rem_hits, depth,
-					      new_depth_mask, 0, new_total,
+					      new_depth_mask, 0, total_samples,
 					      remaining, left_margin);
 	}
 
 	return ret;
 }
 
-static size_t callchain__fprintf_graph(FILE *fp, struct callchain_node *self,
+static size_t callchain__fprintf_graph(FILE *fp, struct rb_root *root,
 				       u64 total_samples, int left_margin)
 {
+	struct callchain_node *cnode;
 	struct callchain_list *chain;
+	u32 entries_printed = 0;
 	bool printed = false;
+	struct rb_node *node;
 	int i = 0;
-	int ret = 0;
-	u32 entries_printed = 0;
-
-	list_for_each_entry(chain, &self->val, list) {
-		if (!i++ && sort__first_dimension == SORT_SYM)
-			continue;
-
-		if (!printed) {
-			ret += callchain__fprintf_left_margin(fp, left_margin);
-			ret += fprintf(fp, "|\n");
-			ret += callchain__fprintf_left_margin(fp, left_margin);
-			ret += fprintf(fp, "---");
-
-			left_margin += 3;
-			printed = true;
-		} else
-			ret += callchain__fprintf_left_margin(fp, left_margin);
+	int ret;
 
-		if (chain->ms.sym)
-			ret += fprintf(fp, " %s\n", chain->ms.sym->name);
-		else
-			ret += fprintf(fp, " %p\n", (void *)(long)chain->ip);
+	/*
+	 * If have one single callchain root, don't bother printing
+	 * its percentage (100 % in fractal mode and the same percentage
+	 * than the hist in graph mode). This also avoid one level of column.
+	 */
+	node = rb_first(root);
+	if (node && !rb_next(node)) {
+		cnode = rb_entry(node, struct callchain_node, rb_node);
+		list_for_each_entry(chain, &cnode->val, list) {
+			/*
+			 * If we sort by symbol, the first entry is the same than
+			 * the symbol. No need to print it otherwise it appears as
+			 * displayed twice.
+			 */
+			if (!i++ && sort__first_dimension == SORT_SYM)
+				continue;
+			if (!printed) {
+				ret += callchain__fprintf_left_margin(fp, left_margin);
+				ret += fprintf(fp, "|\n");
+				ret += callchain__fprintf_left_margin(fp, left_margin);
+				ret += fprintf(fp, "---");
+				left_margin += 3;
+				printed = true;
+			} else
+				ret += callchain__fprintf_left_margin(fp, left_margin);
+
+			if (chain->ms.sym)
+				ret += fprintf(fp, " %s\n", chain->ms.sym->name);
+			else
+				ret += fprintf(fp, " %p\n", (void *)(long)chain->ip);
 
-		if (++entries_printed == callchain_param.print_limit)
-			break;
+			if (++entries_printed == callchain_param.print_limit)
+				break;
+		}
+		root = &cnode->rb_root;
 	}
 
-	ret += __callchain__fprintf_graph(fp, self, total_samples, 1, 1, left_margin);
-
-	return ret;
+	return __callchain__fprintf_graph(fp, root, total_samples,
+					  1, 1, left_margin);
 }
 
-static size_t callchain__fprintf_flat(FILE *fp, struct callchain_node *self,
-				      u64 total_samples)
+static size_t __callchain__fprintf_flat(FILE *fp,
+					struct callchain_node *self,
+					u64 total_samples)
 {
 	struct callchain_list *chain;
 	size_t ret = 0;
@@ -733,7 +748,7 @@ static size_t callchain__fprintf_flat(FILE *fp, struct callchain_node *self,
 	if (!self)
 		return 0;
 
-	ret += callchain__fprintf_flat(fp, self->parent, total_samples);
+	ret += __callchain__fprintf_flat(fp, self->parent, total_samples);
 
 
 	list_for_each_entry(chain, &self->val, list) {
@@ -749,44 +764,58 @@ static size_t callchain__fprintf_flat(FILE *fp, struct callchain_node *self,
 	return ret;
 }
 
-static size_t hist_entry_callchain__fprintf(struct hist_entry *he,
-					    u64 total_samples, int left_margin,
-					    FILE *fp)
+static size_t callchain__fprintf_flat(FILE *fp, struct rb_root *self,
+				      u64 total_samples)
 {
-	struct rb_node *rb_node;
-	struct callchain_node *chain;
 	size_t ret = 0;
 	u32 entries_printed = 0;
+	struct rb_node *rb_node;
+	struct callchain_node *chain;
 
-	rb_node = rb_first(&he->sorted_chain);
+	rb_node = rb_first(self);
 	while (rb_node) {
 		double percent;
 
 		chain = rb_entry(rb_node, struct callchain_node, rb_node);
 		percent = chain->hit * 100.0 / total_samples;
-		switch (callchain_param.mode) {
-		case CHAIN_FLAT:
-			ret += percent_color_fprintf(fp, "           %6.2f%%\n",
-						     percent);
-			ret += callchain__fprintf_flat(fp, chain, total_samples);
-			break;
-		case CHAIN_GRAPH_ABS: /* Falldown */
-		case CHAIN_GRAPH_REL:
-			ret += callchain__fprintf_graph(fp, chain, total_samples,
-							left_margin);
-		case CHAIN_NONE:
-		default:
-			break;
-		}
+
+		ret = percent_color_fprintf(fp, "           %6.2f%%\n", percent);
+		ret += __callchain__fprintf_flat(fp, chain, total_samples);
 		ret += fprintf(fp, "\n");
 		if (++entries_printed == callchain_param.print_limit)
 			break;
+
 		rb_node = rb_next(rb_node);
 	}
 
 	return ret;
 }
 
+static size_t hist_entry_callchain__fprintf(struct hist_entry *he,
+					    u64 total_samples, int left_margin,
+					    FILE *fp)
+{
+	switch (callchain_param.mode) {
+	case CHAIN_GRAPH_REL:
+		return callchain__fprintf_graph(fp, &he->sorted_chain, he->period,
+						left_margin);
+		break;
+	case CHAIN_GRAPH_ABS:
+		return callchain__fprintf_graph(fp, &he->sorted_chain, total_samples,
+						left_margin);
+		break;
+	case CHAIN_FLAT:
+		return callchain__fprintf_flat(fp, &he->sorted_chain, total_samples);
+		break;
+	case CHAIN_NONE:
+		break;
+	default:
+		pr_err("Bad callchain mode\n");
+	}
+
+	return 0;
+}
+
 void hists__output_recalc_col_len(struct hists *hists, int max_rows)
 {
 	struct rb_node *next = rb_first(&hists->entries);
