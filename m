Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582Ab2KJArU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 19:47:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15315 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752191Ab2KJArM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 19:47:12 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 01/12] perf tests: Move test__vmlinux_matches_kallsyms into separate object
Date: Sat, 10 Nov 2012 01:46:41 +0100
Message-Id: <1352508412-16914-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1352508412-16914-1-git-send-email-jolsa@redhat.com>
References: <1352508412-16914-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Separating test__vmlinux_matches_kallsyms test from
the builtin-test into vmlinux-kallsyms object.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile                 |   1 +
 tools/perf/tests/builtin-test.c     | 223 +---------------------------------
 tools/perf/tests/tests.h            |   6 +
 tools/perf/tests/vmlinux-kallsyms.c | 230 ++++++++++++++++++++++++++++++++++++
 4 files changed, 239 insertions(+), 221 deletions(-)
 create mode 100644 tools/perf/tests/tests.h
 create mode 100644 tools/perf/tests/vmlinux-kallsyms.c

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index cca5bb8..7c7ba4d 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -431,6 +431,7 @@ LIB_OBJS += $(OUTPUT)arch/common.o
 LIB_OBJS += $(OUTPUT)tests/parse-events.o
 LIB_OBJS += $(OUTPUT)tests/dso-data.o
 LIB_OBJS += $(OUTPUT)tests/attr.o
+LIB_OBJS += $(OUTPUT)tests/vmlinux-kallsyms.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
 BUILTIN_OBJS += $(OUTPUT)builtin-bench.o
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index 5d4354e..5bc9063 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -21,231 +21,12 @@
 
 #include <sys/mman.h>
 
-static int vmlinux_matches_kallsyms_filter(struct map *map __maybe_unused,
-					   struct symbol *sym)
-{
-	bool *visited = symbol__priv(sym);
-	*visited = true;
-	return 0;
-}
-
-static int test__vmlinux_matches_kallsyms(void)
-{
-	int err = -1;
-	struct rb_node *nd;
-	struct symbol *sym;
-	struct map *kallsyms_map, *vmlinux_map;
-	struct machine kallsyms, vmlinux;
-	enum map_type type = MAP__FUNCTION;
-	struct ref_reloc_sym ref_reloc_sym = { .name = "_stext", };
-
-	/*
-	 * Step 1:
-	 *
-	 * Init the machines that will hold kernel, modules obtained from
-	 * both vmlinux + .ko files and from /proc/kallsyms split by modules.
-	 */
-	machine__init(&kallsyms, "", HOST_KERNEL_ID);
-	machine__init(&vmlinux, "", HOST_KERNEL_ID);
-
-	/*
-	 * Step 2:
-	 *
-	 * Create the kernel maps for kallsyms and the DSO where we will then
-	 * load /proc/kallsyms. Also create the modules maps from /proc/modules
-	 * and find the .ko files that match them in /lib/modules/`uname -r`/.
-	 */
-	if (machine__create_kernel_maps(&kallsyms) < 0) {
-		pr_debug("machine__create_kernel_maps ");
-		return -1;
-	}
-
-	/*
-	 * Step 3:
-	 *
-	 * Load and split /proc/kallsyms into multiple maps, one per module.
-	 */
-	if (machine__load_kallsyms(&kallsyms, "/proc/kallsyms", type, NULL) <= 0) {
-		pr_debug("dso__load_kallsyms ");
-		goto out;
-	}
-
-	/*
-	 * Step 4:
-	 *
-	 * kallsyms will be internally on demand sorted by name so that we can
-	 * find the reference relocation * symbol, i.e. the symbol we will use
-	 * to see if the running kernel was relocated by checking if it has the
-	 * same value in the vmlinux file we load.
-	 */
-	kallsyms_map = machine__kernel_map(&kallsyms, type);
-
-	sym = map__find_symbol_by_name(kallsyms_map, ref_reloc_sym.name, NULL);
-	if (sym == NULL) {
-		pr_debug("dso__find_symbol_by_name ");
-		goto out;
-	}
-
-	ref_reloc_sym.addr = sym->start;
-
-	/*
-	 * Step 5:
-	 *
-	 * Now repeat step 2, this time for the vmlinux file we'll auto-locate.
-	 */
-	if (machine__create_kernel_maps(&vmlinux) < 0) {
-		pr_debug("machine__create_kernel_maps ");
-		goto out;
-	}
-
-	vmlinux_map = machine__kernel_map(&vmlinux, type);
-	map__kmap(vmlinux_map)->ref_reloc_sym = &ref_reloc_sym;
-
-	/*
-	 * Step 6:
-	 *
-	 * Locate a vmlinux file in the vmlinux path that has a buildid that
-	 * matches the one of the running kernel.
-	 *
-	 * While doing that look if we find the ref reloc symbol, if we find it
-	 * we'll have its ref_reloc_symbol.unrelocated_addr and then
-	 * maps__reloc_vmlinux will notice and set proper ->[un]map_ip routines
-	 * to fixup the symbols.
-	 */
-	if (machine__load_vmlinux_path(&vmlinux, type,
-				       vmlinux_matches_kallsyms_filter) <= 0) {
-		pr_debug("machine__load_vmlinux_path ");
-		goto out;
-	}
-
-	err = 0;
-	/*
-	 * Step 7:
-	 *
-	 * Now look at the symbols in the vmlinux DSO and check if we find all of them
-	 * in the kallsyms dso. For the ones that are in both, check its names and
-	 * end addresses too.
-	 */
-	for (nd = rb_first(&vmlinux_map->dso->symbols[type]); nd; nd = rb_next(nd)) {
-		struct symbol *pair, *first_pair;
-		bool backwards = true;
-
-		sym  = rb_entry(nd, struct symbol, rb_node);
-
-		if (sym->start == sym->end)
-			continue;
-
-		first_pair = machine__find_kernel_symbol(&kallsyms, type, sym->start, NULL, NULL);
-		pair = first_pair;
-
-		if (pair && pair->start == sym->start) {
-next_pair:
-			if (strcmp(sym->name, pair->name) == 0) {
-				/*
-				 * kallsyms don't have the symbol end, so we
-				 * set that by using the next symbol start - 1,
-				 * in some cases we get this up to a page
-				 * wrong, trace_kmalloc when I was developing
-				 * this code was one such example, 2106 bytes
-				 * off the real size. More than that and we
-				 * _really_ have a problem.
-				 */
-				s64 skew = sym->end - pair->end;
-				if (llabs(skew) < page_size)
-					continue;
-
-				pr_debug("%#" PRIx64 ": diff end addr for %s v: %#" PRIx64 " k: %#" PRIx64 "\n",
-					 sym->start, sym->name, sym->end, pair->end);
-			} else {
-				struct rb_node *nnd;
-detour:
-				nnd = backwards ? rb_prev(&pair->rb_node) :
-						  rb_next(&pair->rb_node);
-				if (nnd) {
-					struct symbol *next = rb_entry(nnd, struct symbol, rb_node);
-
-					if (next->start == sym->start) {
-						pair = next;
-						goto next_pair;
-					}
-				}
-
-				if (backwards) {
-					backwards = false;
-					pair = first_pair;
-					goto detour;
-				}
-
-				pr_debug("%#" PRIx64 ": diff name v: %s k: %s\n",
-					 sym->start, sym->name, pair->name);
-			}
-		} else
-			pr_debug("%#" PRIx64 ": %s not on kallsyms\n", sym->start, sym->name);
-
-		err = -1;
-	}
-
-	if (!verbose)
-		goto out;
-
-	pr_info("Maps only in vmlinux:\n");
-
-	for (nd = rb_first(&vmlinux.kmaps.maps[type]); nd; nd = rb_next(nd)) {
-		struct map *pos = rb_entry(nd, struct map, rb_node), *pair;
-		/*
-		 * If it is the kernel, kallsyms is always "[kernel.kallsyms]", while
-		 * the kernel will have the path for the vmlinux file being used,
-		 * so use the short name, less descriptive but the same ("[kernel]" in
-		 * both cases.
-		 */
-		pair = map_groups__find_by_name(&kallsyms.kmaps, type,
-						(pos->dso->kernel ?
-							pos->dso->short_name :
-							pos->dso->name));
-		if (pair)
-			pair->priv = 1;
-		else
-			map__fprintf(pos, stderr);
-	}
-
-	pr_info("Maps in vmlinux with a different name in kallsyms:\n");
-
-	for (nd = rb_first(&vmlinux.kmaps.maps[type]); nd; nd = rb_next(nd)) {
-		struct map *pos = rb_entry(nd, struct map, rb_node), *pair;
-
-		pair = map_groups__find(&kallsyms.kmaps, type, pos->start);
-		if (pair == NULL || pair->priv)
-			continue;
-
-		if (pair->start == pos->start) {
-			pair->priv = 1;
-			pr_info(" %" PRIx64 "-%" PRIx64 " %" PRIx64 " %s in kallsyms as",
-				pos->start, pos->end, pos->pgoff, pos->dso->name);
-			if (pos->pgoff != pair->pgoff || pos->end != pair->end)
-				pr_info(": \n*%" PRIx64 "-%" PRIx64 " %" PRIx64 "",
-					pair->start, pair->end, pair->pgoff);
-			pr_info(" %s\n", pair->dso->name);
-			pair->priv = 1;
-		}
-	}
-
-	pr_info("Maps only in kallsyms:\n");
-
-	for (nd = rb_first(&kallsyms.kmaps.maps[type]);
-	     nd; nd = rb_next(nd)) {
-		struct map *pos = rb_entry(nd, struct map, rb_node);
-
-		if (!pos->priv)
-			map__fprintf(pos, stderr);
-	}
-out:
-	return err;
-}
-
 #include "util/cpumap.h"
 #include "util/evsel.h"
 #include <sys/types.h>
 
+#include "tests.h"
+
 static int trace_event__id(const char *evname)
 {
 	char *filename;
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
new file mode 100644
index 0000000..2223de5
--- /dev/null
+++ b/tools/perf/tests/tests.h
@@ -0,0 +1,6 @@
+#ifndef TESTS_H
+#define TESTS_H
+
+int test__vmlinux_matches_kallsyms(void);
+
+#endif /* TESTS_H */
diff --git a/tools/perf/tests/vmlinux-kallsyms.c b/tools/perf/tests/vmlinux-kallsyms.c
new file mode 100644
index 0000000..0d1cdbe
--- /dev/null
+++ b/tools/perf/tests/vmlinux-kallsyms.c
@@ -0,0 +1,230 @@
+#include <linux/compiler.h>
+#include <linux/rbtree.h>
+#include <string.h>
+#include "map.h"
+#include "symbol.h"
+#include "util.h"
+#include "tests.h"
+#include "debug.h"
+#include "machine.h"
+
+static int vmlinux_matches_kallsyms_filter(struct map *map __maybe_unused,
+					   struct symbol *sym)
+{
+	bool *visited = symbol__priv(sym);
+	*visited = true;
+	return 0;
+}
+
+int test__vmlinux_matches_kallsyms(void)
+{
+	int err = -1;
+	struct rb_node *nd;
+	struct symbol *sym;
+	struct map *kallsyms_map, *vmlinux_map;
+	struct machine kallsyms, vmlinux;
+	enum map_type type = MAP__FUNCTION;
+	struct ref_reloc_sym ref_reloc_sym = { .name = "_stext", };
+
+	/*
+	 * Step 1:
+	 *
+	 * Init the machines that will hold kernel, modules obtained from
+	 * both vmlinux + .ko files and from /proc/kallsyms split by modules.
+	 */
+	machine__init(&kallsyms, "", HOST_KERNEL_ID);
+	machine__init(&vmlinux, "", HOST_KERNEL_ID);
+
+	/*
+	 * Step 2:
+	 *
+	 * Create the kernel maps for kallsyms and the DSO where we will then
+	 * load /proc/kallsyms. Also create the modules maps from /proc/modules
+	 * and find the .ko files that match them in /lib/modules/`uname -r`/.
+	 */
+	if (machine__create_kernel_maps(&kallsyms) < 0) {
+		pr_debug("machine__create_kernel_maps ");
+		return -1;
+	}
+
+	/*
+	 * Step 3:
+	 *
+	 * Load and split /proc/kallsyms into multiple maps, one per module.
+	 */
+	if (machine__load_kallsyms(&kallsyms, "/proc/kallsyms", type, NULL) <= 0) {
+		pr_debug("dso__load_kallsyms ");
+		goto out;
+	}
+
+	/*
+	 * Step 4:
+	 *
+	 * kallsyms will be internally on demand sorted by name so that we can
+	 * find the reference relocation * symbol, i.e. the symbol we will use
+	 * to see if the running kernel was relocated by checking if it has the
+	 * same value in the vmlinux file we load.
+	 */
+	kallsyms_map = machine__kernel_map(&kallsyms, type);
+
+	sym = map__find_symbol_by_name(kallsyms_map, ref_reloc_sym.name, NULL);
+	if (sym == NULL) {
+		pr_debug("dso__find_symbol_by_name ");
+		goto out;
+	}
+
+	ref_reloc_sym.addr = sym->start;
+
+	/*
+	 * Step 5:
+	 *
+	 * Now repeat step 2, this time for the vmlinux file we'll auto-locate.
+	 */
+	if (machine__create_kernel_maps(&vmlinux) < 0) {
+		pr_debug("machine__create_kernel_maps ");
+		goto out;
+	}
+
+	vmlinux_map = machine__kernel_map(&vmlinux, type);
+	map__kmap(vmlinux_map)->ref_reloc_sym = &ref_reloc_sym;
+
+	/*
+	 * Step 6:
+	 *
+	 * Locate a vmlinux file in the vmlinux path that has a buildid that
+	 * matches the one of the running kernel.
+	 *
+	 * While doing that look if we find the ref reloc symbol, if we find it
+	 * we'll have its ref_reloc_symbol.unrelocated_addr and then
+	 * maps__reloc_vmlinux will notice and set proper ->[un]map_ip routines
+	 * to fixup the symbols.
+	 */
+	if (machine__load_vmlinux_path(&vmlinux, type,
+				       vmlinux_matches_kallsyms_filter) <= 0) {
+		pr_debug("machine__load_vmlinux_path ");
+		goto out;
+	}
+
+	err = 0;
+	/*
+	 * Step 7:
+	 *
+	 * Now look at the symbols in the vmlinux DSO and check if we find all of them
+	 * in the kallsyms dso. For the ones that are in both, check its names and
+	 * end addresses too.
+	 */
+	for (nd = rb_first(&vmlinux_map->dso->symbols[type]); nd; nd = rb_next(nd)) {
+		struct symbol *pair, *first_pair;
+		bool backwards = true;
+
+		sym  = rb_entry(nd, struct symbol, rb_node);
+
+		if (sym->start == sym->end)
+			continue;
+
+		first_pair = machine__find_kernel_symbol(&kallsyms, type, sym->start, NULL, NULL);
+		pair = first_pair;
+
+		if (pair && pair->start == sym->start) {
+next_pair:
+			if (strcmp(sym->name, pair->name) == 0) {
+				/*
+				 * kallsyms don't have the symbol end, so we
+				 * set that by using the next symbol start - 1,
+				 * in some cases we get this up to a page
+				 * wrong, trace_kmalloc when I was developing
+				 * this code was one such example, 2106 bytes
+				 * off the real size. More than that and we
+				 * _really_ have a problem.
+				 */
+				s64 skew = sym->end - pair->end;
+				if (llabs(skew) < page_size)
+					continue;
+
+				pr_debug("%#" PRIx64 ": diff end addr for %s v: %#" PRIx64 " k: %#" PRIx64 "\n",
+					 sym->start, sym->name, sym->end, pair->end);
+			} else {
+				struct rb_node *nnd;
+detour:
+				nnd = backwards ? rb_prev(&pair->rb_node) :
+						  rb_next(&pair->rb_node);
+				if (nnd) {
+					struct symbol *next = rb_entry(nnd, struct symbol, rb_node);
+
+					if (next->start == sym->start) {
+						pair = next;
+						goto next_pair;
+					}
+				}
+
+				if (backwards) {
+					backwards = false;
+					pair = first_pair;
+					goto detour;
+				}
+
+				pr_debug("%#" PRIx64 ": diff name v: %s k: %s\n",
+					 sym->start, sym->name, pair->name);
+			}
+		} else
+			pr_debug("%#" PRIx64 ": %s not on kallsyms\n", sym->start, sym->name);
+
+		err = -1;
+	}
+
+	if (!verbose)
+		goto out;
+
+	pr_info("Maps only in vmlinux:\n");
+
+	for (nd = rb_first(&vmlinux.kmaps.maps[type]); nd; nd = rb_next(nd)) {
+		struct map *pos = rb_entry(nd, struct map, rb_node), *pair;
+		/*
+		 * If it is the kernel, kallsyms is always "[kernel.kallsyms]", while
+		 * the kernel will have the path for the vmlinux file being used,
+		 * so use the short name, less descriptive but the same ("[kernel]" in
+		 * both cases.
+		 */
+		pair = map_groups__find_by_name(&kallsyms.kmaps, type,
+						(pos->dso->kernel ?
+							pos->dso->short_name :
+							pos->dso->name));
+		if (pair)
+			pair->priv = 1;
+		else
+			map__fprintf(pos, stderr);
+	}
+
+	pr_info("Maps in vmlinux with a different name in kallsyms:\n");
+
+	for (nd = rb_first(&vmlinux.kmaps.maps[type]); nd; nd = rb_next(nd)) {
+		struct map *pos = rb_entry(nd, struct map, rb_node), *pair;
+
+		pair = map_groups__find(&kallsyms.kmaps, type, pos->start);
+		if (pair == NULL || pair->priv)
+			continue;
+
+		if (pair->start == pos->start) {
+			pair->priv = 1;
+			pr_info(" %" PRIx64 "-%" PRIx64 " %" PRIx64 " %s in kallsyms as",
+				pos->start, pos->end, pos->pgoff, pos->dso->name);
+			if (pos->pgoff != pair->pgoff || pos->end != pair->end)
+				pr_info(": \n*%" PRIx64 "-%" PRIx64 " %" PRIx64 "",
+					pair->start, pair->end, pair->pgoff);
+			pr_info(" %s\n", pair->dso->name);
+			pair->priv = 1;
+		}
+	}
+
+	pr_info("Maps only in kallsyms:\n");
+
+	for (nd = rb_first(&kallsyms.kmaps.maps[type]);
+	     nd; nd = rb_next(nd)) {
+		struct map *pos = rb_entry(nd, struct map, rb_node);
+
+		if (!pos->priv)
+			map__fprintf(pos, stderr);
+	}
+out:
+	return err;
+}
-- 
1.7.11.7

