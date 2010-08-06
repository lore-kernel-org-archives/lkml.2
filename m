Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935265Ab0HFBrJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 21:47:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:47664 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935243Ab0HFBq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 21:46:58 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 01/10] perf symbols: Store the symbol binding
Date: Thu,  5 Aug 2010 22:46:08 -0300
Message-Id: <1281059177-18747-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1281059177-18747-1-git-send-email-acme@infradead.org>
References: <1281059177-18747-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

So that tools that wan't to act only on a subset of (weak, global,
local) symbols can do so, such as the upcoming uprobes support in 'perf
probe'.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c |   30 ++++++++++++++++++++++--------
 tools/perf/util/symbol.h |    1 +
 2 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 6f0dd90..b6f5970 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -131,7 +131,8 @@ static void map_groups__fixup_end(struct map_groups *self)
 		__map_groups__fixup_end(self, i);
 }
 
-static struct symbol *symbol__new(u64 start, u64 len, const char *name)
+static struct symbol *symbol__new(u64 start, u64 len, u8 binding,
+				  const char *name)
 {
 	size_t namelen = strlen(name) + 1;
 	struct symbol *self = calloc(1, (symbol_conf.priv_size +
@@ -144,6 +145,7 @@ static struct symbol *symbol__new(u64 start, u64 len, const char *name)
 
 	self->start   = start;
 	self->end     = len ? start + len - 1 : start;
+	self->binding = binding;
 	self->namelen = namelen - 1;
 
 	pr_debug4("%s: %s %#Lx-%#Lx\n", __func__, name, start, self->end);
@@ -160,8 +162,11 @@ void symbol__delete(struct symbol *self)
 
 static size_t symbol__fprintf(struct symbol *self, FILE *fp)
 {
-	return fprintf(fp, " %llx-%llx %s\n",
-		       self->start, self->end, self->name);
+	return fprintf(fp, " %llx-%llx %c %s\n",
+		       self->start, self->end,
+		       self->binding == STB_GLOBAL ? 'g' :
+		       self->binding == STB_LOCAL  ? 'l' : 'w',
+		       self->name);
 }
 
 void dso__set_long_name(struct dso *self, char *name)
@@ -453,6 +458,14 @@ struct process_kallsyms_args {
 	struct dso *dso;
 };
 
+static u8 kallsyms2elf_type(char type)
+{
+	if (type == 'W')
+		return STB_WEAK;
+
+	return isupper(type) ? STB_GLOBAL : STB_LOCAL;
+}
+
 static int map__process_kallsym_symbol(void *arg, const char *name,
 				       char type, u64 start)
 {
@@ -466,7 +479,7 @@ static int map__process_kallsym_symbol(void *arg, const char *name,
 	/*
 	 * Will fix up the end later, when we have all symbols sorted.
 	 */
-	sym = symbol__new(start, 0, name);
+	sym = symbol__new(start, 0, kallsyms2elf_type(type), name);
 
 	if (sym == NULL)
 		return -ENOMEM;
@@ -661,7 +674,7 @@ static int dso__load_perf_map(struct dso *self, struct map *map,
 		if (len + 2 >= line_len)
 			continue;
 
-		sym = symbol__new(start, size, line + len);
+		sym = symbol__new(start, size, STB_GLOBAL, line + len);
 
 		if (sym == NULL)
 			goto out_delete_line;
@@ -873,7 +886,7 @@ static int dso__synthesize_plt_symbols(struct  dso *self, struct map *map,
 				 "%s@plt", elf_sym__name(&sym, symstrs));
 
 			f = symbol__new(plt_offset, shdr_plt.sh_entsize,
-					sympltname);
+					STB_GLOBAL, sympltname);
 			if (!f)
 				goto out_elf_end;
 
@@ -895,7 +908,7 @@ static int dso__synthesize_plt_symbols(struct  dso *self, struct map *map,
 				 "%s@plt", elf_sym__name(&sym, symstrs));
 
 			f = symbol__new(plt_offset, shdr_plt.sh_entsize,
-					sympltname);
+					STB_GLOBAL, sympltname);
 			if (!f)
 				goto out_elf_end;
 
@@ -1146,7 +1159,8 @@ static int dso__load_sym(struct dso *self, struct map *map, const char *name,
 		if (demangled != NULL)
 			elf_name = demangled;
 new_symbol:
-		f = symbol__new(sym.st_value, sym.st_size, elf_name);
+		f = symbol__new(sym.st_value, sym.st_size,
+				GELF_ST_BIND(sym.st_info), elf_name);
 		free(demangled);
 		if (!f)
 			goto out_elf_end;
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 906be20..b7a8da4 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -53,6 +53,7 @@ struct symbol {
 	u64		start;
 	u64		end;
 	u16		namelen;
+	u8		binding;
 	char		name[0];
 };
 
-- 
1.6.2.5

