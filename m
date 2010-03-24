Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932870Ab0CXTkg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 15:40:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:41012 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756145Ab0CXTkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 15:40:33 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH v2 5/6] perf callchains: Store the map together with the symbol
Date: Wed, 24 Mar 2010 16:40:18 -0300
Message-Id: <1269459619-982-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1269459619-982-1-git-send-email-acme@infradead.org>
References: <1269459619-982-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

We need this to know where a symbol in a callchain came from, for
various reasons, among them precise annotation from a TUI/GUI tool.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c |    3 ++-
 tools/perf/util/callchain.c |   21 ++++++++++-----------
 tools/perf/util/callchain.h |    4 ++--
 tools/perf/util/hist.c      |   14 +++++++-------
 tools/perf/util/newt.c      |    8 ++++----
 tools/perf/util/session.c   |   13 +++++++------
 tools/perf/util/session.h   |    8 ++++----
 7 files changed, 36 insertions(+), 35 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index d609afb..6ab1698 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -81,7 +81,8 @@ static int perf_session__add_hist_entry(struct perf_session *self,
 					struct addr_location *al,
 					struct sample_data *data)
 {
-	struct symbol **syms = NULL, *parent = NULL;
+	struct map_symbol *syms = NULL;
+	struct symbol *parent = NULL;
 	bool hit;
 	int err;
 	struct hist_entry *he;
diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index 883844e..db628af 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -185,8 +185,8 @@ create_child(struct callchain_node *parent, bool inherit_children)
 
 
 struct resolved_ip {
-	u64		ip;
-	struct symbol	*sym;
+	u64		  ip;
+	struct map_symbol ms;
 };
 
 struct resolved_chain {
@@ -212,7 +212,7 @@ fill_node(struct callchain_node *node, struct resolved_chain *chain, int start)
 			return;
 		}
 		call->ip = chain->ips[i].ip;
-		call->sym = chain->ips[i].sym;
+		call->ms = chain->ips[i].ms;
 		list_add_tail(&call->list, &node->val);
 	}
 	node->val_nr = chain->nr - start;
@@ -318,10 +318,10 @@ __append_chain(struct callchain_node *root, struct resolved_chain *chain,
 		if (i == chain->nr)
 			break;
 
-		sym = chain->ips[i].sym;
+		sym = chain->ips[i].ms.sym;
 
-		if (cnode->sym && sym) {
-			if (cnode->sym->start != sym->start)
+		if (cnode->ms.sym && sym) {
+			if (cnode->ms.sym->start != sym->start)
 				break;
 		} else if (cnode->ip != chain->ips[i].ip)
 			break;
@@ -353,9 +353,8 @@ __append_chain(struct callchain_node *root, struct resolved_chain *chain,
 	return 0;
 }
 
-static void
-filter_context(struct ip_callchain *old, struct resolved_chain *new,
-	       struct symbol **syms)
+static void filter_context(struct ip_callchain *old, struct resolved_chain *new,
+			   struct map_symbol *syms)
 {
 	int i, j = 0;
 
@@ -364,7 +363,7 @@ filter_context(struct ip_callchain *old, struct resolved_chain *new,
 			continue;
 
 		new->ips[j].ip = old->ips[i];
-		new->ips[j].sym = syms[i];
+		new->ips[j].ms = syms[i];
 		j++;
 	}
 
@@ -373,7 +372,7 @@ filter_context(struct ip_callchain *old, struct resolved_chain *new,
 
 
 int append_chain(struct callchain_node *root, struct ip_callchain *chain,
-		  struct symbol **syms)
+		 struct map_symbol *syms)
 {
 	struct resolved_chain *filtered;
 
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index bbd76da..8a7e8bb 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -39,7 +39,7 @@ struct callchain_param {
 
 struct callchain_list {
 	u64			ip;
-	struct symbol		*sym;
+	struct map_symbol	ms;
 	struct list_head	list;
 };
 
@@ -57,5 +57,5 @@ static inline u64 cumul_hits(struct callchain_node *node)
 
 int register_callchain_param(struct callchain_param *param);
 int append_chain(struct callchain_node *root, struct ip_callchain *chain,
-		 struct symbol **syms);
+		 struct map_symbol *syms);
 #endif	/* __PERF_CALLCHAIN_H */
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 4eefb52..09e09e7 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -260,8 +260,8 @@ static size_t ipchain__fprintf_graph(FILE *fp, struct callchain_list *chain,
 		} else
 			ret += fprintf(fp, "%s", "          ");
 	}
-	if (chain->sym)
-		ret += fprintf(fp, "%s\n", chain->sym->name);
+	if (chain->ms.sym)
+		ret += fprintf(fp, "%s\n", chain->ms.sym->name);
 	else
 		ret += fprintf(fp, "%p\n", (void *)(long)chain->ip);
 
@@ -280,7 +280,7 @@ static void init_rem_hits(void)
 	}
 
 	strcpy(rem_sq_bracket->name, "[...]");
-	rem_hits.sym = rem_sq_bracket;
+	rem_hits.ms.sym = rem_sq_bracket;
 }
 
 static size_t __callchain__fprintf_graph(FILE *fp, struct callchain_node *self,
@@ -382,8 +382,8 @@ static size_t callchain__fprintf_graph(FILE *fp, struct callchain_node *self,
 		} else
 			ret += callchain__fprintf_left_margin(fp, left_margin);
 
-		if (chain->sym)
-			ret += fprintf(fp, " %s\n", chain->sym->name);
+		if (chain->ms.sym)
+			ret += fprintf(fp, " %s\n", chain->ms.sym->name);
 		else
 			ret += fprintf(fp, " %p\n", (void *)(long)chain->ip);
 	}
@@ -408,8 +408,8 @@ static size_t callchain__fprintf_flat(FILE *fp, struct callchain_node *self,
 	list_for_each_entry(chain, &self->val, list) {
 		if (chain->ip >= PERF_CONTEXT_MAX)
 			continue;
-		if (chain->sym)
-			ret += fprintf(fp, "                %s\n", chain->sym->name);
+		if (chain->ms.sym)
+			ret += fprintf(fp, "                %s\n", chain->ms.sym->name);
 		else
 			ret += fprintf(fp, "                %p\n",
 					(void *)(long)chain->ip);
diff --git a/tools/perf/util/newt.c b/tools/perf/util/newt.c
index 25cd2e1..f6953ca 100644
--- a/tools/perf/util/newt.c
+++ b/tools/perf/util/newt.c
@@ -104,8 +104,8 @@ static void newt_checkbox_tree__add(newtComponent tree, const char *str,
 static char *callchain_list__sym_name(struct callchain_list *self,
 				      char *bf, size_t bfsize)
 {
-	if (self->sym)
-		return self->sym->name;
+	if (self->ms.sym)
+		return self->ms.sym->name;
 
 	snprintf(bf, bfsize, "%#Lx", self->ip);
 	return bf;
@@ -157,7 +157,7 @@ static void __callchain__append_graph_browser(struct callchain_node *self,
 				indexes[depth + 2] = NEWT_ARG_LAST;
 				++chain_idx;
 			}
-			newt_checkbox_tree__add(tree, str, chain->sym, indexes);
+			newt_checkbox_tree__add(tree, str, chain->ms.sym, indexes);
 			free(alloc_str);
 			++printed;
 		}
@@ -193,7 +193,7 @@ static void callchain__append_graph_browser(struct callchain_node *self,
 			continue;
 
 		str = callchain_list__sym_name(chain, ipstr, sizeof(ipstr));
-		newt_checkbox_tree__add(tree, str, chain->sym, indexes);
+		newt_checkbox_tree__add(tree, str, chain->ms.sym, indexes);
 	}
 
 	indexes[1] = parent_idx;
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index eed1cb8..2cef373 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -117,13 +117,13 @@ static bool symbol__match_parent_regex(struct symbol *sym)
 	return 0;
 }
 
-struct symbol **perf_session__resolve_callchain(struct perf_session *self,
-						struct thread *thread,
-						struct ip_callchain *chain,
-						struct symbol **parent)
+struct map_symbol *perf_session__resolve_callchain(struct perf_session *self,
+						   struct thread *thread,
+						   struct ip_callchain *chain,
+						   struct symbol **parent)
 {
 	u8 cpumode = PERF_RECORD_MISC_USER;
-	struct symbol **syms = NULL;
+	struct map_symbol *syms = NULL;
 	unsigned int i;
 
 	if (symbol_conf.use_callchain) {
@@ -160,7 +160,8 @@ struct symbol **perf_session__resolve_callchain(struct perf_session *self,
 				*parent = al.sym;
 			if (!symbol_conf.use_callchain)
 				break;
-			syms[i] = al.sym;
+			syms[i].map = al.map;
+			syms[i].sym = al.sym;
 		}
 	}
 
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 34d7339..631f815 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -57,10 +57,10 @@ int __perf_session__process_events(struct perf_session *self,
 int perf_session__process_events(struct perf_session *self,
 				 struct perf_event_ops *event_ops);
 
-struct symbol **perf_session__resolve_callchain(struct perf_session *self,
-						struct thread *thread,
-						struct ip_callchain *chain,
-						struct symbol **parent);
+struct map_symbol *perf_session__resolve_callchain(struct perf_session *self,
+						   struct thread *thread,
+						   struct ip_callchain *chain,
+						   struct symbol **parent);
 
 bool perf_session__has_traces(struct perf_session *self, const char *msg);
 
-- 
1.6.2.5

