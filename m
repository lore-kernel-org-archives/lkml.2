Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629Ab0EIXjs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 19:39:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:45154 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754590Ab0EIXjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 19:39:45 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 4/4] perf report: Allow limiting the number of entries to print in callchains
Date: Sun,  9 May 2010 20:39:29 -0300
Message-Id: <1273448369-7479-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1273448369-7479-1-git-send-email-acme@infradead.org>
References: <1273448369-7479-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Works by adding a third parameter to the '-g' argument, after the graph
type and minimum percentage, for example:

[root@doppio linux-2.6-tip]# perf report -g fractal,0.5,2

Will show only the first two symbols where at least 0.5% of the samples
took place.

All the other symbols that don't fall outside these constraints will be
put together in the last entry, prefixed with "[...]" and the total
percentage for them.

Suggested-by: Arjan van de Ven <arjan@linux.intel.com>
Acked-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c |    5 ++++-
 tools/perf/util/callchain.h |    1 +
 tools/perf/util/hist.c      |   10 ++++++++++
 3 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 5e2f47f..642a6d8 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -343,7 +343,7 @@ static int
 parse_callchain_opt(const struct option *opt __used, const char *arg,
 		    int unset)
 {
-	char *tok;
+	char *tok, *tok2;
 	char *endptr;
 
 	/*
@@ -388,10 +388,13 @@ parse_callchain_opt(const struct option *opt __used, const char *arg,
 	if (!tok)
 		goto setup;
 
+	tok2 = strtok(NULL, ",");
 	callchain_param.min_percent = strtod(tok, &endptr);
 	if (tok == endptr)
 		return -1;
 
+	if (tok2)
+		callchain_param.print_limit = strtod(tok2, &endptr);
 setup:
 	if (register_callchain_param(&callchain_param) < 0) {
 		fprintf(stderr, "Can't register callchain params\n");
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index 0f4da09..1cba1f5 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -34,6 +34,7 @@ typedef void (*sort_chain_func_t)(struct rb_root *, struct callchain_node *,
 
 struct callchain_param {
 	enum chain_mode 	mode;
+	u32			print_limit;
 	double			min_percent;
 	sort_chain_func_t	sort;
 };
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index e0c8a72..0f154a5 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -333,6 +333,7 @@ static size_t __callchain__fprintf_graph(FILE *fp, struct callchain_node *self,
 	u64 remaining;
 	size_t ret = 0;
 	int i;
+	uint entries_printed = 0;
 
 	if (callchain_param.mode == CHAIN_GRAPH_REL)
 		new_total = self->children_hit;
@@ -379,6 +380,8 @@ static size_t __callchain__fprintf_graph(FILE *fp, struct callchain_node *self,
 						  new_depth_mask | (1 << depth),
 						  left_margin);
 		node = next;
+		if (++entries_printed == callchain_param.print_limit)
+			break;
 	}
 
 	if (callchain_param.mode == CHAIN_GRAPH_REL &&
@@ -404,6 +407,7 @@ static size_t callchain__fprintf_graph(FILE *fp, struct callchain_node *self,
 	bool printed = false;
 	int i = 0;
 	int ret = 0;
+	u32 entries_printed = 0;
 
 	list_for_each_entry(chain, &self->val, list) {
 		if (!i++ && sort__first_dimension == SORT_SYM)
@@ -424,6 +428,9 @@ static size_t callchain__fprintf_graph(FILE *fp, struct callchain_node *self,
 			ret += fprintf(fp, " %s\n", chain->ms.sym->name);
 		else
 			ret += fprintf(fp, " %p\n", (void *)(long)chain->ip);
+
+		if (++entries_printed == callchain_param.print_limit)
+			break;
 	}
 
 	ret += __callchain__fprintf_graph(fp, self, total_samples, 1, 1, left_margin);
@@ -462,6 +469,7 @@ static size_t hist_entry_callchain__fprintf(FILE *fp, struct hist_entry *self,
 	struct rb_node *rb_node;
 	struct callchain_node *chain;
 	size_t ret = 0;
+	u32 entries_printed = 0;
 
 	rb_node = rb_first(&self->sorted_chain);
 	while (rb_node) {
@@ -484,6 +492,8 @@ static size_t hist_entry_callchain__fprintf(FILE *fp, struct hist_entry *self,
 			break;
 		}
 		ret += fprintf(fp, "\n");
+		if (++entries_printed == callchain_param.print_limit)
+			break;
 		rb_node = rb_next(rb_node);
 	}
 
-- 
1.6.2.5

