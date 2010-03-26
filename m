Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284Ab0CZUib (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 16:38:31 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47180 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973Ab0CZUia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 16:38:30 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 2/3] perf symbols: map_groups__find_symbol must return the map too
Date: Fri, 26 Mar 2010 17:38:18 -0300
Message-Id: <1269635899-3221-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1269635899-3221-1-git-send-email-acme@infradead.org>
References: <1269635899-3221-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Tools need to know from which map in the map_group a symbol was resolved
to, so that, for isntance, we can annotate kernel modules symbols by
getting its precise name, etc.

Also add the _by_name variants for completeness.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kmem.c |    3 ++-
 tools/perf/util/map.c     |   28 +++++++++++++++++++++++++++-
 tools/perf/util/map.h     |   23 +++++++++++++++++++----
 3 files changed, 48 insertions(+), 6 deletions(-)

diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 924a951..32edb6a 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -369,7 +369,8 @@ static void __print_result(struct rb_root *root, struct perf_session *session,
 		if (is_caller) {
 			addr = data->call_site;
 			if (!raw_ip)
-				sym = map_groups__find_function(&session->kmaps, addr, NULL);
+				sym = map_groups__find_function(&session->kmaps,
+								addr, NULL, NULL);
 		} else
 			addr = data->ptr;
 
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index e21f980..37913b2 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -268,12 +268,38 @@ void map_groups__flush(struct map_groups *self)
 
 struct symbol *map_groups__find_symbol(struct map_groups *self,
 				       enum map_type type, u64 addr,
+				       struct map **mapp,
 				       symbol_filter_t filter)
 {
 	struct map *map = map_groups__find(self, type, addr);
 
-	if (map != NULL)
+	if (map != NULL) {
+		if (mapp != NULL)
+			*mapp = map;
 		return map__find_symbol(map, map->map_ip(map, addr), filter);
+	}
+
+	return NULL;
+}
+
+struct symbol *map_groups__find_symbol_by_name(struct map_groups *self,
+					       enum map_type type,
+					       const char *name,
+					       struct map **mapp,
+					       symbol_filter_t filter)
+{
+	struct rb_node *nd;
+
+	for (nd = rb_first(&self->maps[type]); nd; nd = rb_next(nd)) {
+		struct map *pos = rb_entry(nd, struct map, rb_node);
+		struct symbol *sym = map__find_symbol_by_name(pos, name, filter);
+
+		if (sym == NULL)
+			continue;
+		if (mapp != NULL)
+			*mapp = pos;
+		return sym;
+	}
 
 	return NULL;
 }
diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index 4e7a11d..2031278 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -119,13 +119,28 @@ static inline struct map *map_groups__find(struct map_groups *self,
 
 struct symbol *map_groups__find_symbol(struct map_groups *self,
 				       enum map_type type, u64 addr,
+				       struct map **mapp,
 				       symbol_filter_t filter);
 
-static inline struct symbol *map_groups__find_function(struct map_groups *self,
-						       u64 addr,
-						       symbol_filter_t filter)
+struct symbol *map_groups__find_symbol_by_name(struct map_groups *self,
+					       enum map_type type,
+					       const char *name,
+					       struct map **mapp,
+					       symbol_filter_t filter);
+
+static inline
+struct symbol *map_groups__find_function(struct map_groups *self, u64 addr,
+					 struct map **mapp, symbol_filter_t filter)
+{
+	return map_groups__find_symbol(self, MAP__FUNCTION, addr, mapp, filter);
+}
+
+static inline
+struct symbol *map_groups__find_function_by_name(struct map_groups *self,
+						 const char *name, struct map **mapp,
+						 symbol_filter_t filter)
 {
-	return map_groups__find_symbol(self, MAP__FUNCTION, addr, filter);
+	return map_groups__find_symbol_by_name(self, MAP__FUNCTION, name, mapp, filter);
 }
 
 int map_groups__fixup_overlappings(struct map_groups *self, struct map *map,
-- 
1.6.2.5

