Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691Ab1F1Hkd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 03:40:33 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:37485 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756679Ab1F1Hjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 03:39:51 -0400
X-AuditID: b753bd60-a327cba0000050a4-72-4e098544a05f
X-AuditID: b753bd60-a327cba0000050a4-72-4e098544a05f
From: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Subject: [PATCH -tip  4/4] perf script: add option resolving vmlinux path
To: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        pp-manager@sdl.hitachi.co.jp,
        Akihiro Nagai <akihiro.nagai.hw@hitachi.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        David Ahern <dsahern@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Date: Tue, 28 Jun 2011 16:40:50 +0900
Message-ID: <20110628074049.4269.64126.stgit@linux3>
In-Reply-To: <20110628074019.4269.32109.stgit@linux3>
References: <20110628074019.4269.32109.stgit@linux3>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the option get the path of [kernel.kallsyms].
Specify '--show-kernel-path' option to use this function.
This patch enables other applications to use this output easily.

Without --show-kernel-path  option

# perf script -f ip,dso
ffffffff81467612 irq_return ([kernel.kallsyms])
ffffffff81467612 irq_return ([kernel.kallsyms])
    7f24fc02a6b3 _start (/lib64/ld-2.14.so)
[snip]

With --show-kernel-path option

# perf script -f ip,dso --show-kernel-path
ffffffff81467612 irq_return (/lib/modules/3.0.0-rc3-tip+/build/vmlinux)
ffffffff81467612 irq_return (/lib/modules/3.0.0-rc3-tip+/build/vmlinux)
    7f24fc02a6b3 _start (/lib64/ld-2.14.so)
[snip]

Signed-off-by: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---

 tools/perf/Documentation/perf-script.txt |    3 +++
 tools/perf/builtin-script.c              |   15 +++++----------
 tools/perf/util/session.c                |   26 +++++++++-----------------
 tools/perf/util/symbol.c                 |   12 ++++++++++++
 tools/perf/util/symbol.h                 |    2 ++
 5 files changed, 31 insertions(+), 27 deletions(-)

diff --git a/tools/perf/Documentation/perf-script.txt b/tools/perf/Documentation/perf-script.txt
index 39c4721..be59d8b 100644
--- a/tools/perf/Documentation/perf-script.txt
+++ b/tools/perf/Documentation/perf-script.txt
@@ -185,6 +185,9 @@ OPTIONS
 --show-symbol-offset::
 	Show the offset of the symbols.
 
+--show-kernel-path::
+	Try to resolve the path of [kernel.kallsyms]
+
 SEE ALSO
 --------
 linkperf:perf-record[1], linkperf:perf-script-perl[1],
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index f9b7047..750673f 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -324,7 +324,7 @@ static void print_sample_addr(union perf_event *event,
 {
 	struct addr_location al;
 	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
-	const char *symname, *dsoname;
+	const char *symname;
 	unsigned long offset;
 
 	printf("%16" PRIx64, sample->addr);
@@ -359,14 +359,8 @@ static void print_sample_addr(union perf_event *event,
 		}
 	}
 
-	if (PRINT_FIELD(DSO)) {
-		if (al.map && al.map->dso && al.map->dso->name)
-			dsoname = al.map->dso->name;
-		else
-			dsoname = "";
-
-		printf(" (%s)", dsoname);
-	}
+	if (PRINT_FIELD(DSO) && al.map && al.map->dso)
+		printf(" (%s)", dso__get_dsoname_for_print(al.map->dso));
 }
 
 static void process_event(union perf_event *event __unused,
@@ -1092,7 +1086,8 @@ static const struct option options[] = {
 		     parse_output_fields),
 	OPT_BOOLEAN('\0', "show-symbol-offset", &show_symbol_offset,
 		    "Show the offset of the symbol."),
-
+	OPT_BOOLEAN('\0', "show-kernel-path", &show_kernel_path,
+		    "Show the path of [kernel.kallsyms]"),
 	OPT_END()
 };
 
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index bb522ed..f385511 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -13,6 +13,8 @@
 #include "sort.h"
 #include "util.h"
 
+bool show_kernel_path;
+
 static int perf_session__open(struct perf_session *self, bool force)
 {
 	struct stat input_stat;
@@ -1208,7 +1210,7 @@ void perf_session__print_ip(union perf_event *event,
 			    int print_sym, int print_dso, int print_offset)
 {
 	struct addr_location al;
-	const char *symname, *dsoname;
+	const char *symname;
 	unsigned long offset;
 	struct callchain_cursor *cursor = &session->callchain_cursor;
 	struct callchain_cursor_node *node;
@@ -1244,14 +1246,9 @@ void perf_session__print_ip(union perf_event *event,
 
 				printf(" %s", symname);
 			}
-			if (print_dso) {
-				if (node->map && node->map->dso && node->map->dso->name)
-					dsoname = node->map->dso->name;
-				else
-					dsoname = "";
-
-				printf(" (%s)", dsoname);
-			}
+			if (print_dso && node->map && node->map->dso)
+				printf(" (%s)", dso__get_dsoname_for_print(
+							node->map->dso));
 			printf("\n");
 
 			callchain_cursor_advance(cursor);
@@ -1271,13 +1268,8 @@ void perf_session__print_ip(union perf_event *event,
 			}
 		}
 
-		if (print_dso) {
-			if (al.map && al.map->dso && al.map->dso->name)
-				dsoname = al.map->dso->name;
-			else
-				dsoname = "";
-
-			printf(" (%s)", dsoname);
-		}
+		if (print_dso && al.map && al.map->dso)
+			printf(" (%s)",
+			       dso__get_dsoname_for_print(al.map->dso));
 	}
 }
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index eec1963..60dbd39 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -41,6 +41,7 @@ static int dso__load_guest_kernel_sym(struct dso *dso, struct map *map,
 			symbol_filter_t filter);
 static int vmlinux_path__nr_entries;
 static char **vmlinux_path;
+bool show_kernel_path;
 
 struct symbol_conf symbol_conf = {
 	.exclude_other	  = true,
@@ -431,6 +432,17 @@ size_t dso__fprintf(struct dso *dso, enum map_type type, FILE *fp)
 	return ret;
 }
 
+const char *dso__get_dsoname_for_print(struct dso *dso)
+{
+	if (dso) {
+		if (show_kernel_path && dso->long_name)
+			return dso->long_name;
+		else
+			return dso->name;
+	} else
+		return "";
+}
+
 int kallsyms__parse(const char *filename, void *arg,
 		    int (*process_symbol)(void *arg, const char *name,
 					  char type, u64 start, u64 end))
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 325ee36..6b9a7f3 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -96,6 +96,7 @@ struct symbol_conf {
 };
 
 extern struct symbol_conf symbol_conf;
+extern bool show_kernel_path;
 
 static inline void *symbol__priv(struct symbol *sym)
 {
@@ -195,6 +196,7 @@ size_t dso__fprintf_buildid(struct dso *dso, FILE *fp);
 size_t dso__fprintf_symbols_by_name(struct dso *dso,
 				    enum map_type type, FILE *fp);
 size_t dso__fprintf(struct dso *dso, enum map_type type, FILE *fp);
+const char *dso__get_dsoname_for_print(struct dso *dso);
 
 enum symtab_type {
 	SYMTAB__KALLSYMS = 0,

