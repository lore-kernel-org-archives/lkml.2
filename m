Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756496Ab0G0LNA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 07:13:00 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:42169 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756391Ab0G0LM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 07:12:57 -0400
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Naren A Devaiah <naren.devaiah@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Tue, 27 Jul 2010 16:41:19 +0530
Message-Id: <20100727111119.24690.74064.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20100727110855.24690.26901.sendpatchset@localhost6.localdomain6>
References: <20100727110855.24690.26901.sendpatchset@localhost6.localdomain6>
Subject: [PATCHv10 2.6.35-rc6-tip 12/14]  perf: Add third parameter to symbol_filter_t.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


GElf_Sym for a symbol is needed to filter out based on binding,
type, value. This will be needed to list only global binding
functions when listing functions from  perf probe.

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---

 tools/perf/builtin-test.c |    4 +++-
 tools/perf/builtin-top.c  |    6 +++++-
 tools/perf/util/map.h     |    4 +++-
 tools/perf/util/symbol.c  |   10 +++++-----
 4 files changed, 16 insertions(+), 8 deletions(-)


diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 035b9fa..31fb9e3 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -11,10 +11,12 @@
 #include "util/session.h"
 #include "util/symbol.h"
 #include "util/thread.h"
+#include <gelf.h>
 
 static long page_size;
 
-static int vmlinux_matches_kallsyms_filter(struct map *map __used, struct symbol *sym)
+static int vmlinux_matches_kallsyms_filter(struct map *map __used,
+		struct symbol *sym, GElf_Sym *gsym __used)
 {
 	bool *visited = symbol__priv(sym);
 	*visited = true;
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index b513e40..56989e8 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -54,6 +54,7 @@
 
 #include <linux/unistd.h>
 #include <linux/types.h>
+#include <gelf.h>
 
 static int			*fd[MAX_NR_CPUS][MAX_COUNTERS];
 
@@ -932,7 +933,10 @@ static const char *skip_symbols[] = {
 	NULL
 };
 
-static int symbol_filter(struct map *map, struct symbol *sym)
+#define __unused __attribute__((unused))
+
+static int symbol_filter(struct map *map, struct symbol *sym,
+					GElf_Sym *gsym __unused)
 {
 	struct sym_entry *syme;
 	const char *name = sym->name;
diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index f391345..1fcde24 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -7,6 +7,7 @@
 #include <stdio.h>
 #include <stdbool.h>
 #include "types.h"
+#include <gelf.h>
 
 enum map_type {
 	MAP__FUNCTION = 0,
@@ -100,7 +101,8 @@ u64 map__objdump_2ip(struct map *map, u64 addr);
 
 struct symbol;
 
-typedef int (*symbol_filter_t)(struct map *map, struct symbol *sym);
+typedef int (*symbol_filter_t)(struct map *map, struct symbol *sym,
+						GElf_Sym *gsym);
 
 void map__init(struct map *self, enum map_type type,
 	       u64 start, u64 end, u64 pgoff, struct dso *dso);
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 410e824..38ad5c9 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -574,7 +574,7 @@ static int dso__split_kallsyms(struct dso *self, struct map *map,
 			++kernel_range;
 		}
 
-		if (filter && filter(curr_map, pos)) {
+		if (filter && filter(curr_map, pos, NULL)) {
 discard_symbol:		rb_erase(&pos->rb_node, root);
 			symbol__delete(pos);
 		} else {
@@ -653,7 +653,7 @@ static int dso__load_perf_map(struct dso *self, struct map *map,
 		if (sym == NULL)
 			goto out_delete_line;
 
-		if (filter && filter(map, sym))
+		if (filter && filter(map, sym, NULL))
 			symbol__delete(sym);
 		else {
 			symbols__insert(&self->symbols[map->type], sym);
@@ -864,7 +864,7 @@ static int dso__synthesize_plt_symbols(struct  dso *self, struct map *map,
 			if (!f)
 				goto out_elf_end;
 
-			if (filter && filter(map, f))
+			if (filter && filter(map, f, &sym))
 				symbol__delete(f);
 			else {
 				symbols__insert(&self->symbols[map->type], f);
@@ -886,7 +886,7 @@ static int dso__synthesize_plt_symbols(struct  dso *self, struct map *map,
 			if (!f)
 				goto out_elf_end;
 
-			if (filter && filter(map, f))
+			if (filter && filter(map, f, &sym))
 				symbol__delete(f);
 			else {
 				symbols__insert(&self->symbols[map->type], f);
@@ -1122,7 +1122,7 @@ new_symbol:
 		if (!f)
 			goto out_elf_end;
 
-		if (filter && filter(curr_map, f))
+		if (filter && filter(curr_map, f, &sym))
 			symbol__delete(f);
 		else {
 			symbols__insert(&curr_dso->symbols[curr_map->type], f);
