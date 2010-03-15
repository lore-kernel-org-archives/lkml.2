Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936590Ab0COSEI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 14:04:08 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46763 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936579Ab0COSED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 14:04:03 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Pavel Krauz <krauz@cngroup.cz>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/1] perf top: Improve the autosizing of column lenghts
Date: Mon, 15 Mar 2010 15:03:50 -0300
Message-Id: <1268676230-9261-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

When profiling C++ workloads the symbol name lenght can be really big,
so cap it before it garbles the result.

This builds upon the autosizing already present where we choose to use
the short, basename of DSOs instead of its long, full pathname.

Reported-by: Pavel Krauz <krauz@cngroup.cz>
Cc: Pavel Krauz <krauz@cngroup.cz>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c |   13 +++++++++----
 tools/perf/util/symbol.c |   18 +++++++++++++-----
 tools/perf/util/symbol.h |    3 ++-
 3 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index c968bd3..057f8b6 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -464,7 +464,7 @@ static void print_sym_table(void)
 	struct sym_entry *syme, *n;
 	struct rb_root tmp = RB_ROOT;
 	struct rb_node *nd;
-	int sym_width = 0, dso_width = 0, max_dso_width;
+	int sym_width = 0, dso_width = 0, dso_short_width;
 	const int win_width = winsize.ws_col - 1;
 
 	samples = userspace_samples = exact_samples = 0;
@@ -555,15 +555,20 @@ static void print_sym_table(void)
 		if (syme->map->dso->long_name_len > dso_width)
 			dso_width = syme->map->dso->long_name_len;
 
+		if (syme->map->dso->short_name_len > dso_short_width)
+			dso_short_width = syme->map->dso->short_name_len;
+
 		if (syme->name_len > sym_width)
 			sym_width = syme->name_len;
 	}
 
 	printed = 0;
 
-	max_dso_width = winsize.ws_col - sym_width - 29;
-	if (dso_width > max_dso_width)
-		dso_width = max_dso_width;
+	if (sym_width + dso_width > winsize.ws_col - 29) {
+		dso_width = dso_short_width;
+		if (sym_width + dso_width > winsize.ws_col - 29)
+			sym_width = winsize.ws_col - dso_width - 29;
+	}
 	putchar('\n');
 	if (nr_counters == 1)
 		printf("             samples  pcnt");
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 292f941..3eb9de4 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -151,9 +151,17 @@ void dso__set_long_name(struct dso *self, char *name)
 	self->long_name_len = strlen(name);
 }
 
+static void dso__set_short_name(struct dso *self, const char *name)
+{
+	if (name == NULL)
+		return;
+	self->short_name = name;
+	self->short_name_len = strlen(name);
+}
+
 static void dso__set_basename(struct dso *self)
 {
-	self->short_name = basename(self->long_name);
+	dso__set_short_name(self, basename(self->long_name));
 }
 
 struct dso *dso__new(const char *name)
@@ -164,7 +172,7 @@ struct dso *dso__new(const char *name)
 		int i;
 		strcpy(self->name, name);
 		dso__set_long_name(self, self->name);
-		self->short_name = self->name;
+		dso__set_short_name(self, self->name);
 		for (i = 0; i < MAP__NR_TYPES; ++i)
 			self->symbols[i] = self->symbol_names[i] = RB_ROOT;
 		self->slen_calculated = 0;
@@ -885,7 +893,6 @@ static int dso__load_sym(struct dso *self, struct map *map, const char *name,
 	struct kmap *kmap = self->kernel ? map__kmap(map) : NULL;
 	struct map *curr_map = map;
 	struct dso *curr_dso = self;
-	size_t dso_name_len = strlen(self->short_name);
 	Elf_Data *symstrs, *secstrs;
 	uint32_t nr_syms;
 	int err = -1;
@@ -975,7 +982,8 @@ static int dso__load_sym(struct dso *self, struct map *map, const char *name,
 			char dso_name[PATH_MAX];
 
 			if (strcmp(section_name,
-				   curr_dso->short_name + dso_name_len) == 0)
+				   (curr_dso->short_name +
+				    self->short_name_len)) == 0)
 				goto new_symbol;
 
 			if (strcmp(section_name, ".text") == 0) {
@@ -1770,7 +1778,7 @@ struct dso *dso__new_kernel(const char *name)
 	struct dso *self = dso__new(name ?: "[kernel.kallsyms]");
 
 	if (self != NULL) {
-		self->short_name = "[kernel]";
+		dso__set_short_name(self, "[kernel]");
 		self->kernel	 = 1;
 	}
 
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 5bd91d1..0da2455 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -111,9 +111,10 @@ struct dso {
 	u8		 sorted_by_name;
 	u8		 loaded;
 	u8		 build_id[BUILD_ID_SIZE];
-	u16		 long_name_len;
 	const char	 *short_name;
 	char	 	 *long_name;
+	u16		 long_name_len;
+	u16		 short_name_len;
 	char		 name[0];
 };
 
-- 
1.6.2.5

