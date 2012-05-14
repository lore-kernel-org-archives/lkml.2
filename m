Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734Ab2ENHNR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 03:13:17 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:62027 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754526Ab2ENHMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 03:12:09 -0400
X-AuditID: 9c93016f-b7cecae000000e00-cb-4fb0b04528ab
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/5] perf symbols: Do not use ELF's symbol binding constants
Date: Mon, 14 May 2012 16:10:21 +0900
Message-Id: <1336979424-17206-3-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1336979424-17206-1-git-send-email-namhyung.kim@lge.com>
References: <1336979424-17206-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no need to use the ELF's internal value directly.
Define and use our own - it's required to eliminated the
dependency of libelf.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 tools/perf/builtin-top.c     |    5 ++---
 tools/perf/ui/browsers/map.c |    5 ++---
 tools/perf/util/symbol.c     |   40 ++++++++++++++++++++++++++--------------
 tools/perf/util/symbol.h     |    4 ++++
 4 files changed, 34 insertions(+), 20 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 8ef59f8262bb..89be1334e7e0 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -42,7 +42,6 @@
 #include "util/debug.h"
 
 #include <assert.h>
-#include <elf.h>
 #include <fcntl.h>
 
 #include <stdio.h>
@@ -181,8 +180,8 @@ static void ui__warn_map_erange(struct map *map, struct symbol *sym, u64 ip)
 		    "Please report to linux-kernel@vger.kernel.org\n",
 		    ip, map->dso->long_name, dso__symtab_origin(map->dso),
 		    map->start, map->end, sym->start, sym->end,
-		    sym->binding == STB_GLOBAL ? 'g' :
-		    sym->binding == STB_LOCAL  ? 'l' : 'w', sym->name,
+		    sym->binding == SYMBIND_GLOBAL ? 'g' :
+		    sym->binding == SYMBIND_LOCAL  ? 'l' : 'w', sym->name,
 		    err ? "[unknown]" : uts.machine,
 		    err ? "[unknown]" : uts.release, perf_version_string);
 	if (use_browser <= 0)
diff --git a/tools/perf/ui/browsers/map.c b/tools/perf/ui/browsers/map.c
index 98851d55a53e..f2059664b23f 100644
--- a/tools/perf/ui/browsers/map.c
+++ b/tools/perf/ui/browsers/map.c
@@ -1,5 +1,4 @@
 #include "../libslang.h"
-#include <elf.h>
 #include <newt.h>
 #include <inttypes.h>
 #include <sys/ttydefaults.h>
@@ -61,8 +60,8 @@ static void map_browser__write(struct ui_browser *self, void *nd, int row)
 	ui_browser__set_percent_color(self, 0, current_entry);
 	slsmg_printf("%*" PRIx64 " %*" PRIx64 " %c ",
 		     mb->addrlen, sym->start, mb->addrlen, sym->end,
-		     sym->binding == STB_GLOBAL ? 'g' :
-		     sym->binding == STB_LOCAL  ? 'l' : 'w');
+		     sym->binding == SYMBIND_GLOBAL ? 'g' :
+		     sym->binding == SYMBIND_LOCAL  ? 'l' : 'w');
 	width = self->width - ((mb->addrlen * 2) + 4);
 	if (width > 0)
 		slsmg_write_nstring(sym->name, width);
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index fe37d84e2107..d4518a14edd8 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -114,16 +114,16 @@ static int choose_best_symbol(struct symbol *syma, struct symbol *symb)
 		return SYMBOL_B;
 
 	/* Prefer a non weak symbol over a weak one */
-	a = syma->binding == STB_WEAK;
-	b = symb->binding == STB_WEAK;
+	a = syma->binding == SYMBIND_WEAK;
+	b = symb->binding == SYMBIND_WEAK;
 	if (b && !a)
 		return SYMBOL_A;
 	if (a && !b)
 		return SYMBOL_B;
 
 	/* Prefer a global symbol over a non global one */
-	a = syma->binding == STB_GLOBAL;
-	b = symb->binding == STB_GLOBAL;
+	a = syma->binding == SYMBIND_GLOBAL;
+	b = symb->binding == SYMBIND_GLOBAL;
 	if (a && !b)
 		return SYMBOL_A;
 	if (b && !a)
@@ -259,8 +259,8 @@ static size_t symbol__fprintf(struct symbol *sym, FILE *fp)
 {
 	return fprintf(fp, " %" PRIx64 "-%" PRIx64 " %c %s\n",
 		       sym->start, sym->end,
-		       sym->binding == STB_GLOBAL ? 'g' :
-		       sym->binding == STB_LOCAL  ? 'l' : 'w',
+		       sym->binding == SYMBIND_GLOBAL ? 'g' :
+		       sym->binding == SYMBIND_LOCAL  ? 'l' : 'w',
 		       sym->name);
 }
 
@@ -608,12 +608,12 @@ struct process_kallsyms_args {
 	struct dso *dso;
 };
 
-static u8 kallsyms2elf_type(char type)
+static u8 kallsyms_binding(char type)
 {
 	if (type == 'W')
-		return STB_WEAK;
+		return SYMBIND_WEAK;
 
-	return isupper(type) ? STB_GLOBAL : STB_LOCAL;
+	return isupper(type) ? SYMBIND_GLOBAL : SYMBIND_LOCAL;
 }
 
 static int map__process_kallsym_symbol(void *arg, const char *name,
@@ -627,7 +627,7 @@ static int map__process_kallsym_symbol(void *arg, const char *name,
 		return 0;
 
 	sym = symbol__new(start, end - start + 1,
-			  kallsyms2elf_type(type), name);
+			  kallsyms_binding(type), name);
 	if (sym == NULL)
 		return -ENOMEM;
 	/*
@@ -850,7 +850,7 @@ static int dso__load_perf_map(struct dso *dso, struct map *map,
 		if (len + 2 >= line_len)
 			continue;
 
-		sym = symbol__new(start, size, STB_GLOBAL, line + len);
+		sym = symbol__new(start, size, SYMBIND_GLOBAL, line + len);
 
 		if (sym == NULL)
 			goto out_delete_line;
@@ -1065,7 +1065,7 @@ static int dso__synthesize_plt_symbols(struct  dso *dso, struct map *map,
 				 "%s@plt", elf_sym__name(&sym, symstrs));
 
 			f = symbol__new(plt_offset, shdr_plt.sh_entsize,
-					STB_GLOBAL, sympltname);
+					SYMBIND_GLOBAL, sympltname);
 			if (!f)
 				goto out_elf_end;
 
@@ -1087,7 +1087,7 @@ static int dso__synthesize_plt_symbols(struct  dso *dso, struct map *map,
 				 "%s@plt", elf_sym__name(&sym, symstrs));
 
 			f = symbol__new(plt_offset, shdr_plt.sh_entsize,
-					STB_GLOBAL, sympltname);
+					SYMBIND_GLOBAL, sympltname);
 			if (!f)
 				goto out_elf_end;
 
@@ -1158,6 +1158,18 @@ static size_t elf_addr_to_index(Elf *elf, GElf_Addr addr)
 	return -1;
 }
 
+static int elf_sym__binding(const GElf_Sym *sym)
+{
+	switch (GELF_ST_BIND(sym->st_info)) {
+	case STB_GLOBAL:
+		return SYMBIND_GLOBAL;
+	case STB_WEAK:
+		return SYMBIND_WEAK;
+	default:
+		return SYMBIND_LOCAL;
+	}
+}
+
 static int dso__load_sym(struct dso *dso, struct map *map, const char *name,
 			 int fd, symbol_filter_t filter, int kmodule,
 			 int want_symtab)
@@ -1361,7 +1373,7 @@ static int dso__load_sym(struct dso *dso, struct map *map, const char *name,
 			elf_name = demangled;
 new_symbol:
 		f = symbol__new(sym.st_value, sym.st_size,
-				GELF_ST_BIND(sym.st_info), elf_name);
+				elf_sym__binding(&sym), elf_name);
 		free(demangled);
 		if (!f)
 			goto out_elf_end;
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 27e882f5ad8a..ea81399fa768 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -49,6 +49,10 @@ char *strxfrchar(char *s, char from, char to);
 
 #define BUILD_ID_SIZE 20
 
+#define SYMBIND_LOCAL	0
+#define SYMBIND_GLOBAL	1
+#define SYMBIND_WEAK	2
+
 /** struct symbol - symtab entry
  *
  * @ignore - resolvable but tools ignore it (e.g. idle routines)
-- 
1.7.10.1

