Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424Ab2A3EoY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 23:44:24 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:33131 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754313Ab2A3EoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 23:44:21 -0500
X-AuditID: b753bd60-9aa63ba00000359c-dd-4f262022f827
X-AuditID: b753bd60-9aa63ba00000359c-dd-4f262022f827
From: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Subject: [PATCH -tip v5 1/5] perf-script: unify the expressions indicate
 "unknown"
To: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com,
        Akihiro Nagai <akihiro.nagai.hw@hitachi.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        David Ahern <dsahern@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Date: Mon, 30 Jan 2012 13:42:57 +0900
Message-ID: <20120130044257.2384.62905.stgit@linux3>
In-Reply-To: <20120130044242.2384.23076.stgit@linux3>
References: <20120130044242.2384.23076.stgit@linux3>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf-script uses various expressions to indicate "unknown".
It is unfriendly for user scripts to parse it. So, this patch unifies
the expressions to "[unknown]".

Changes in v5:
 - Use fprintf() instead of printf() in struct map/symbol's functions
   to print something.
 - Abolish using 'self' in function's paramater

Changes in v3:
 - unify all expressions to [unknown]

Changes in v2:
 - add this patch

Signed-off-by: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---

 tools/perf/builtin-script.c |   20 ++++++--------------
 tools/perf/util/map.c       |   12 ++++++++++++
 tools/perf/util/map.h       |    1 +
 tools/perf/util/session.c   |   35 ++++++++++-------------------------
 tools/perf/util/symbol.c    |   12 ++++++++++++
 tools/perf/util/symbol.h    |    1 +
 6 files changed, 42 insertions(+), 39 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index bb68ddf..add13ec 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -300,7 +300,7 @@ static void print_sample_start(struct perf_sample *sample,
 		} else
 			evname = __event_name(attr->type, attr->config);
 
-		printf("%s: ", evname ? evname : "(unknown)");
+		printf("%s: ", evname ? evname : "[unknown]");
 	}
 }
 
@@ -323,7 +323,6 @@ static void print_sample_addr(union perf_event *event,
 {
 	struct addr_location al;
 	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
-	const char *symname, *dsoname;
 
 	printf("%16" PRIx64, sample->addr);
 
@@ -343,21 +342,14 @@ static void print_sample_addr(union perf_event *event,
 		al.sym = map__find_symbol(al.map, al.addr, NULL);
 
 	if (PRINT_FIELD(SYM)) {
-		if (al.sym && al.sym->name)
-			symname = al.sym->name;
-		else
-			symname = "";
-
-		printf(" %16s", symname);
+		printf(" ");
+		symbol__fprintf_symname(al.sym, stdout);
 	}
 
 	if (PRINT_FIELD(DSO)) {
-		if (al.map && al.map->dso && al.map->dso->name)
-			dsoname = al.map->dso->name;
-		else
-			dsoname = "";
-
-		printf(" (%s)", dsoname);
+		printf(" (");
+		map__fprintf_dsoname(al.map, stdout);
+		printf(")");
 	}
 }
 
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 316aa0a..1107960 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -212,6 +212,18 @@ size_t map__fprintf(struct map *self, FILE *fp)
 		       self->start, self->end, self->pgoff, self->dso->name);
 }
 
+size_t map__fprintf_dsoname(struct map *map, FILE *fp)
+{
+	const char *dsoname;
+
+	if (map && map->dso && map->dso->name)
+		dsoname = map->dso->name;
+	else
+		dsoname = "[unknown]";
+
+	return fprintf(fp, "%s", dsoname);
+}
+
 /*
  * objdump wants/reports absolute IPs for ET_EXEC, and RIPs for ET_DYN.
  * map->dso->adjust_symbols==1 for ET_EXEC-like cases.
diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index 2b8017f..b100c20 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -118,6 +118,7 @@ void map__delete(struct map *self);
 struct map *map__clone(struct map *self);
 int map__overlap(struct map *l, struct map *r);
 size_t map__fprintf(struct map *self, FILE *fp);
+size_t map__fprintf_dsoname(struct map *map, FILE *fp);
 
 int map__load(struct map *self, symbol_filter_t filter);
 struct symbol *map__find_symbol(struct map *self,
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index b5ca255..e5334a9 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1296,7 +1296,6 @@ void perf_event__print_ip(union perf_event *event, struct perf_sample *sample,
 			  int print_sym, int print_dso)
 {
 	struct addr_location al;
-	const char *symname, *dsoname;
 	struct callchain_cursor *cursor = &evsel->hists.callchain_cursor;
 	struct callchain_cursor_node *node;
 
@@ -1324,20 +1323,13 @@ void perf_event__print_ip(union perf_event *event, struct perf_sample *sample,
 
 			printf("\t%16" PRIx64, node->ip);
 			if (print_sym) {
-				if (node->sym && node->sym->name)
-					symname = node->sym->name;
-				else
-					symname = "";
-
-				printf(" %s", symname);
+				printf(" ");
+				symbol__fprintf_symname(node->sym, stdout);
 			}
 			if (print_dso) {
-				if (node->map && node->map->dso && node->map->dso->name)
-					dsoname = node->map->dso->name;
-				else
-					dsoname = "";
-
-				printf(" (%s)", dsoname);
+				printf(" (");
+				map__fprintf_dsoname(al.map, stdout);
+				printf(")");
 			}
 			printf("\n");
 
@@ -1347,21 +1339,14 @@ void perf_event__print_ip(union perf_event *event, struct perf_sample *sample,
 	} else {
 		printf("%16" PRIx64, sample->ip);
 		if (print_sym) {
-			if (al.sym && al.sym->name)
-				symname = al.sym->name;
-			else
-				symname = "";
-
-			printf(" %s", symname);
+			printf(" ");
+			symbol__fprintf_symname(al.sym, stdout);
 		}
 
 		if (print_dso) {
-			if (al.map && al.map->dso && al.map->dso->name)
-				dsoname = al.map->dso->name;
-			else
-				dsoname = "";
-
-			printf(" (%s)", dsoname);
+			printf(" (");
+			map__fprintf_dsoname(al.map, stdout);
+			printf(")");
 		}
 	}
 }
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 215d50f..2d04290 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -264,6 +264,18 @@ static size_t symbol__fprintf(struct symbol *sym, FILE *fp)
 		       sym->name);
 }
 
+size_t symbol__fprintf_symname(const struct symbol *sym, FILE *fp)
+{
+	const char *symname;
+
+	if (sym && sym->name)
+		symname = sym->name;
+	else
+		symname = "[unknown]";
+
+	return fprintf(fp, "%s", symname);
+}
+
 void dso__set_long_name(struct dso *dso, char *name)
 {
 	if (name == NULL)
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 123c2e1..d349c7a 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -241,6 +241,7 @@ void machines__destroy_guest_kernel_maps(struct rb_root *machines);
 
 int symbol__init(void);
 void symbol__exit(void);
+size_t symbol__fprintf_symname(const struct symbol *sym, FILE *fp);
 bool symbol_type__is_a(char symbol_type, enum map_type map_type);
 
 size_t machine__fprintf_vmlinux_path(struct machine *machine, FILE *fp);

