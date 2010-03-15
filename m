Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965109Ab0COOrP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 10:47:15 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59707 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965090Ab0COOrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 10:47:11 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 2/2] perf top: Properly notify the user that vmlinux is missing
Date: Mon, 15 Mar 2010 11:46:58 -0300
Message-Id: <1268664418-28328-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1268664418-28328-1-git-send-email-acme@infradead.org>
References: <1268664418-28328-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Before this patch this message would very briefly appear on the screen and then
the screen would get updates only on the top, for number of interrupts received,
etc, but no annotation would be performed:

[root@doppio linux-2.6-tip]# perf top -s n_tty_write > /tmp/bla
objdump: '[kernel.kallsyms]': No such file

Now this is what the user gets:

[root@doppio linux-2.6-tip]# perf top -s n_tty_write
Can't annotate n_tty_write: No vmlinux file was found in the path:
[0] vmlinux
[1] /boot/vmlinux
[2] /boot/vmlinux-2.6.33-rc5
[3] /lib/modules/2.6.33-rc5/build/vmlinux
[4] /usr/lib/debug/lib/modules/2.6.33-rc5/vmlinux
[root@doppio linux-2.6-tip]#

This bug was introduced when we added automatic search for vmlinux, before that
time the user had to specify a vmlinux file.

Reported-by: David S. Miller <davem@davemloft.net>
Reported-by: Ingo Molnar <mingo@elte.hu>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c |   33 +++++++++++++++++++++++++--------
 tools/perf/util/symbol.c |   25 ++++++++++++-------------
 tools/perf/util/symbol.h |   15 +++++++++++++++
 3 files changed, 52 insertions(+), 21 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 57e232f..c968bd3 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -169,7 +169,7 @@ static void sig_winch_handler(int sig __used)
 	update_print_entries(&winsize);
 }
 
-static void parse_source(struct sym_entry *syme)
+static int parse_source(struct sym_entry *syme)
 {
 	struct symbol *sym;
 	struct sym_entry_source *source;
@@ -180,12 +180,21 @@ static void parse_source(struct sym_entry *syme)
 	u64 len;
 
 	if (!syme)
-		return;
+		return -1;
+
+	sym = sym_entry__symbol(syme);
+	map = syme->map;
+
+	/*
+	 * We can't annotate with just /proc/kallsyms
+	 */
+	if (map->dso->origin == DSO__ORIG_KERNEL)
+		return -1;
 
 	if (syme->src == NULL) {
 		syme->src = zalloc(sizeof(*source));
 		if (syme->src == NULL)
-			return;
+			return -1;
 		pthread_mutex_init(&syme->src->lock, NULL);
 	}
 
@@ -195,9 +204,6 @@ static void parse_source(struct sym_entry *syme)
 		pthread_mutex_lock(&source->lock);
 		goto out_assign;
 	}
-
-	sym = sym_entry__symbol(syme);
-	map = syme->map;
 	path = map->dso->long_name;
 
 	len = sym->end - sym->start;
@@ -209,7 +215,7 @@ static void parse_source(struct sym_entry *syme)
 
 	file = popen(command, "r");
 	if (!file)
-		return;
+		return -1;
 
 	pthread_mutex_lock(&source->lock);
 	source->lines_tail = &source->lines;
@@ -245,6 +251,7 @@ static void parse_source(struct sym_entry *syme)
 out_assign:
 	sym_filter_entry = syme;
 	pthread_mutex_unlock(&source->lock);
+	return 0;
 }
 
 static void __zero_source_counters(struct sym_entry *syme)
@@ -991,7 +998,17 @@ static void event__process_sample(const event_t *self,
 	if (sym_filter_entry_sched) {
 		sym_filter_entry = sym_filter_entry_sched;
 		sym_filter_entry_sched = NULL;
-		parse_source(sym_filter_entry);
+		if (parse_source(sym_filter_entry) < 0) {
+			struct symbol *sym = sym_entry__symbol(sym_filter_entry);
+
+			pr_err("Can't annotate %s", sym->name);
+			if (sym_filter_entry->map->dso->origin == DSO__ORIG_KERNEL) {
+				pr_err(": No vmlinux file was found in the path:\n");
+				vmlinux_path__fprintf(stderr);
+			} else
+				pr_err(".\n");
+			exit(1);
+		}
 	}
 
 	syme = symbol__priv(al.sym);
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 75cd468..292f941 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -18,18 +18,6 @@
 #define NT_GNU_BUILD_ID 3
 #endif
 
-enum dso_origin {
-	DSO__ORIG_KERNEL = 0,
-	DSO__ORIG_JAVA_JIT,
-	DSO__ORIG_BUILD_ID_CACHE,
-	DSO__ORIG_FEDORA,
-	DSO__ORIG_UBUNTU,
-	DSO__ORIG_BUILDID,
-	DSO__ORIG_DSO,
-	DSO__ORIG_KMODULE,
-	DSO__ORIG_NOT_FOUND,
-};
-
 static void dsos__add(struct list_head *head, struct dso *dso);
 static struct map *map__new2(u64 start, struct dso *dso, enum map_type type);
 static int dso__load_kernel_sym(struct dso *self, struct map *map,
@@ -1017,7 +1005,7 @@ static int dso__load_sym(struct dso *self, struct map *map, const char *name,
 				}
 				curr_map->map_ip = identity__map_ip;
 				curr_map->unmap_ip = identity__map_ip;
-				curr_dso->origin = DSO__ORIG_KERNEL;
+				curr_dso->origin = self->origin;
 				map_groups__insert(kmap->kmaps, curr_map);
 				dsos__add(&dsos__kernel, curr_dso);
 				dso__set_loaded(curr_dso, map->type);
@@ -1887,6 +1875,17 @@ out_fail:
 	return -1;
 }
 
+size_t vmlinux_path__fprintf(FILE *fp)
+{
+	int i;
+	size_t printed = 0;
+
+	for (i = 0; i < vmlinux_path__nr_entries; ++i)
+		printed += fprintf(fp, "[%d] %s\n", i, vmlinux_path[i]);
+
+	return printed;
+}
+
 static int setup_list(struct strlist **list, const char *list_str,
 		      const char *list_name)
 {
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 280dadd..d983bba 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -149,6 +149,19 @@ size_t dsos__fprintf_buildid(FILE *fp, bool with_hits);
 
 size_t dso__fprintf_buildid(struct dso *self, FILE *fp);
 size_t dso__fprintf(struct dso *self, enum map_type type, FILE *fp);
+
+enum dso_origin {
+	DSO__ORIG_KERNEL = 0,
+	DSO__ORIG_JAVA_JIT,
+	DSO__ORIG_BUILD_ID_CACHE,
+	DSO__ORIG_FEDORA,
+	DSO__ORIG_UBUNTU,
+	DSO__ORIG_BUILDID,
+	DSO__ORIG_DSO,
+	DSO__ORIG_KMODULE,
+	DSO__ORIG_NOT_FOUND,
+};
+
 char dso__symtab_origin(const struct dso *self);
 void dso__set_long_name(struct dso *self, char *name);
 void dso__set_build_id(struct dso *self, void *build_id);
@@ -168,4 +181,6 @@ int kallsyms__parse(const char *filename, void *arg,
 int symbol__init(void);
 bool symbol_type__is_a(char symbol_type, enum map_type map_type);
 
+size_t vmlinux_path__fprintf(FILE *fp);
+
 #endif /* __PERF_SYMBOL */
-- 
1.6.2.5

