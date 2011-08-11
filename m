Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579Ab1HKMFo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 08:05:44 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:39397 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754975Ab1HKMFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 08:05:42 -0400
X-AuditID: b753bd60-a1c87ba000000655-04-4e43c59394bc
X-AuditID: b753bd60-a1c87ba000000655-04-4e43c59394bc
From: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Subject: [PATCH -tip v3 1/5] perf-script: unify the expressions indicate
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
Date: Thu, 11 Aug 2011 21:06:14 +0900
Message-ID: <20110811120614.5900.33570.stgit@linux3>
In-Reply-To: <20110811120555.5900.23642.stgit@linux3>
References: <20110811120555.5900.23642.stgit@linux3>
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
index 09024ec..b3312ff 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -297,7 +297,7 @@ static void print_sample_start(struct perf_sample *sample,
 		} else
 			evname = __event_name(attr->type, attr->config);
 
-		printf("%s: ", evname ? evname : "(unknown)");
+		printf("%s: ", evname ? evname : "[unknown]");
 	}
 }
 
@@ -320,7 +320,6 @@ static void print_sample_addr(union perf_event *event,
 {
 	struct addr_location al;
 	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
-	const char *symname, *dsoname;
 
 	printf("%16" PRIx64, sample->addr);
 
@@ -340,21 +339,14 @@ static void print_sample_addr(union perf_event *event,
 		al.sym = map__find_symbol(al.map, al.addr, NULL);
 
 	if (PRINT_FIELD(SYM)) {
-		if (al.sym && al.sym->name)
-			symname = al.sym->name;
-		else
-			symname = "";
-
-		printf(" %16s", symname);
+		printf(" ");
+		symbol__print_symname(al.sym);
 	}
 
 	if (PRINT_FIELD(DSO)) {
-		if (al.map && al.map->dso && al.map->dso->name)
-			dsoname = al.map->dso->name;
-		else
-			dsoname = "";
-
-		printf(" (%s)", dsoname);
+		printf(" (");
+		map__print_dsoname(al.map);
+		printf(")");
 	}
 }
 
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index a16ecab..530a5ea 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -200,6 +200,18 @@ size_t map__fprintf(struct map *self, FILE *fp)
 		       self->start, self->end, self->pgoff, self->dso->name);
 }
 
+void map__print_dsoname(struct map *self)
+{
+	const char *dsoname;
+
+	if (self && self->dso && self->dso->name)
+		dsoname = self->dso->name;
+	else
+		dsoname = "[unknown]";
+
+	printf("%s", dsoname);
+}
+
 /*
  * objdump wants/reports absolute IPs for ET_EXEC, and RIPs for ET_DYN.
  * map->dso->adjust_symbols==1 for ET_EXEC-like cases.
diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index b397c03..6f452b9 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -112,6 +112,7 @@ void map__delete(struct map *self);
 struct map *map__clone(struct map *self);
 int map__overlap(struct map *l, struct map *r);
 size_t map__fprintf(struct map *self, FILE *fp);
+void map__print_dsoname(struct map *self);
 
 int map__load(struct map *self, symbol_filter_t filter);
 struct symbol *map__find_symbol(struct map *self,
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 72458d9..730fcd2 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1220,7 +1220,6 @@ void perf_session__print_ip(union perf_event *event,
 			    int print_sym, int print_dso)
 {
 	struct addr_location al;
-	const char *symname, *dsoname;
 	struct callchain_cursor *cursor = &session->callchain_cursor;
 	struct callchain_cursor_node *node;
 
@@ -1248,20 +1247,13 @@ void perf_session__print_ip(union perf_event *event,
 
 			printf("\t%16" PRIx64, node->ip);
 			if (print_sym) {
-				if (node->sym && node->sym->name)
-					symname = node->sym->name;
-				else
-					symname = "";
-
-				printf(" %s", symname);
+				printf(" ");
+				symbol__print_symname(node->sym);
 			}
 			if (print_dso) {
-				if (node->map && node->map->dso && node->map->dso->name)
-					dsoname = node->map->dso->name;
-				else
-					dsoname = "";
-
-				printf(" (%s)", dsoname);
+				printf(" (");
+				map__print_dsoname(al.map);
+				printf(")");
 			}
 			printf("\n");
 
@@ -1271,21 +1263,14 @@ void perf_session__print_ip(union perf_event *event,
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
+			symbol__print_symname(al.sym);
 		}
 
 		if (print_dso) {
-			if (al.map && al.map->dso && al.map->dso->name)
-				dsoname = al.map->dso->name;
-			else
-				dsoname = "";
-
-			printf(" (%s)", dsoname);
+			printf(" (");
+			map__print_dsoname(al.map);
+			printf(")");
 		}
 	}
 }
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index eec1963..aa37485 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -175,6 +175,18 @@ static size_t symbol__fprintf(struct symbol *sym, FILE *fp)
 		       sym->name);
 }
 
+void symbol__print_symname(const struct symbol *sym)
+{
+	const char *symname;
+
+	if (sym && sym->name)
+		symname = sym->name;
+	else
+		symname = "[unknown]";
+
+	printf("%s", symname);
+}
+
 void dso__set_long_name(struct dso *dso, char *name)
 {
 	if (name == NULL)
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 325ee36..1ec17b4 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -238,6 +238,7 @@ void machines__destroy_guest_kernel_maps(struct rb_root *machines);
 
 int symbol__init(void);
 void symbol__exit(void);
+void symbol__print_symname(const struct symbol *sym);
 bool symbol_type__is_a(char symbol_type, enum map_type map_type);
 
 size_t machine__fprintf_vmlinux_path(struct machine *machine, FILE *fp);

