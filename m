Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274Ab2AaNSj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 08:18:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55057 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242Ab2AaNSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 08:18:38 -0500
Date: Tue, 31 Jan 2012 05:17:45 -0800
From: tip-bot for Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Message-ID: <tip-547a92e0aedb88129e7fbd804697a11949de2e5a@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, akihiro.nagai.hw@hitachi.com,
        peterz@infradead.org, fweisbec@gmail.com,
        masami.hiramatsu.pt@hitachi.com, dsahern@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com,
        akihiro.nagai.hw@hitachi.com, peterz@infradead.org,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20120130044257.2384.62905.stgit@linux3>
References: <20120130044257.2384.62905.stgit@linux3>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf script: Unify the expressions indicating "
 unknown"
Git-Commit-ID: 547a92e0aedb88129e7fbd804697a11949de2e5a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 31 Jan 2012 05:17:51 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  547a92e0aedb88129e7fbd804697a11949de2e5a
Gitweb:     http://git.kernel.org/tip/547a92e0aedb88129e7fbd804697a11949de2e5a
Author:     Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
AuthorDate: Mon, 30 Jan 2012 13:42:57 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 30 Jan 2012 17:57:57 -0200

perf script: Unify the expressions indicating "unknown"

The perf script command uses various expressions to indicate "unknown".

It is unfriendly for user scripts to parse it. So, this patch unifies
the expressions to "[unknown]".

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: yrl.pp-manager.tt@hitachi.com
Link: http://lkml.kernel.org/r/20120130044257.2384.62905.stgit@linux3
Signed-off-by: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
index 0975438..b580fa8 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -263,6 +263,18 @@ static size_t symbol__fprintf(struct symbol *sym, FILE *fp)
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
