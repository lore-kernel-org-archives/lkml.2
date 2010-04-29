Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758393Ab0D3RbG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:31:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:42526 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932849Ab0D3RaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:30:11 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 2/2] perf test: Initial regression testing command
Date: Thu, 29 Apr 2010 19:14:04 -0300
Message-Id: <1272579244-3981-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1272579244-3981-1-git-send-email-acme@infradead.org>
References: <1272579244-3981-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

First an example with the first internal test:

[acme@doppio linux-2.6-tip]$ perf test
 1: vmlinux symtab matches kallsyms: Ok

So it run just one test, that is "vmlinux symtab matches kallsyms", and it was
successful.

If we run it in verbose mode, we'll see details about errors and extra warnings
for non-fatal problems:

[acme@doppio linux-2.6-tip]$ perf test -v
 1: vmlinux symtab matches kallsyms:
--- start ---
Looking at the vmlinux_path (5 entries long)
No build_id in vmlinux, ignoring it
No build_id in /boot/vmlinux, ignoring it
No build_id in /boot/vmlinux-2.6.34-rc4-tip+, ignoring it
Using /lib/modules/2.6.34-rc4-tip+/build/vmlinux for symbols
Maps only in vmlinux:
 ffffffff81cb81b1-ffffffff81e1149b 0 [kernel].init.text
 ffffffff81e1149c-ffffffff9fffffff 0 [kernel].exit.text
 ffffffffff600000-ffffffffff6000ff 0 [kernel].vsyscall_0
 ffffffffff600100-ffffffffff6003ff 0 [kernel].vsyscall_fn
 ffffffffff600400-ffffffffff6007ff 0 [kernel].vsyscall_1
 ffffffffff600800-ffffffffffffffff 0 [kernel].vsyscall_2
Maps in vmlinux with a different name in kallsyms:
 ffffffffff600000-ffffffffff6000ff 0 [kernel].vsyscall_0 in kallsyms as [kernel].0
 ffffffffff600100-ffffffffff6003ff 0 [kernel].vsyscall_fn in kallsyms as:
*ffffffffff600100-ffffffffff60012f 0 [kernel].2
 ffffffffff600400-ffffffffff6007ff 0 [kernel].vsyscall_1 in kallsyms as [kernel].6
 ffffffffff600800-ffffffffffffffff 0 [kernel].vsyscall_2 in kallsyms as [kernel].8
Maps only in kallsyms:
 ffffffffff600130-ffffffffff6003ff 0 [kernel].4
---- end ----
vmlinux symtab matches kallsyms: Ok
[acme@doppio linux-2.6-tip]$

In the above case we only know the name of the non contiguous kernel ranges in
the address space when reading the symbol information from the ELF symtab in
vmlinux.

The /proc/kallsyms file lack this, we only notice they are separate because
there are modules after the kernel and after that more kernel functions, so we
need to have a module rbtree backed by the module .ko path to get symtabs in
the vmlinux case.

The tool uses it to match by address to emit appropriate warning, but don't
considers this fatal.

The .init.text and .exit.text ines, of course, aren't in kallsyms, so I left
these cases just as extra info in verbose mode.

The end of the sections also aren't in kallsyms, so we the symbols layer does
another pass and sets the end addresses as the next map start minus one, which
sometimes pads, causing harmless mismatches.

But at least the symbols match, tested it by copying /proc/kallsyms to
/tmp/kallsyms and doing changes to see if they were detected.

This first test also should serve as a first stab at documenting the
symbol library by providing a self contained example that exercises it
together with comments about what is being done.

More tests to check if actions done on a monitored app, like doing mmaps, etc,
makes the kernel generate the expected events should be added next.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-test.txt |   22 +++
 tools/perf/Makefile                    |    1 +
 tools/perf/builtin-test.c              |  281 ++++++++++++++++++++++++++++++++
 tools/perf/builtin.h                   |    1 +
 tools/perf/command-list.txt            |    1 +
 tools/perf/perf.c                      |    1 +
 6 files changed, 307 insertions(+), 0 deletions(-)
 create mode 100644 tools/perf/Documentation/perf-test.txt
 create mode 100644 tools/perf/builtin-test.c

diff --git a/tools/perf/Documentation/perf-test.txt b/tools/perf/Documentation/perf-test.txt
new file mode 100644
index 0000000..1c4b5f5
--- /dev/null
+++ b/tools/perf/Documentation/perf-test.txt
@@ -0,0 +1,22 @@
+perf-test(1)
+============
+
+NAME
+----
+perf-test - Runs sanity tests.
+
+SYNOPSIS
+--------
+[verse]
+'perf test <options>'
+
+DESCRIPTION
+-----------
+This command does assorted sanity tests, initially thru linked routines but
+also will look for a directory with more tests in the form of scripts.
+
+OPTIONS
+-------
+-v::
+--verbose::
+	Be more verbose.
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index b86f2ad..739c441 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -490,6 +490,7 @@ BUILTIN_OBJS += $(OUTPUT)builtin-probe.o
 BUILTIN_OBJS += $(OUTPUT)builtin-kmem.o
 BUILTIN_OBJS += $(OUTPUT)builtin-lock.o
 BUILTIN_OBJS += $(OUTPUT)builtin-kvm.o
+BUILTIN_OBJS += $(OUTPUT)builtin-test.o
 
 PERFLIBS = $(LIB_FILE)
 
diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
new file mode 100644
index 0000000..0339612
--- /dev/null
+++ b/tools/perf/builtin-test.c
@@ -0,0 +1,281 @@
+/*
+ * builtin-test.c
+ *
+ * Builtin regression testing command: ever growing number of sanity tests
+ */
+#include "builtin.h"
+
+#include "util/cache.h"
+#include "util/debug.h"
+#include "util/parse-options.h"
+#include "util/session.h"
+#include "util/symbol.h"
+#include "util/thread.h"
+
+static long page_size;
+
+static int vmlinux_matches_kallsyms_filter(struct map *map __used, struct symbol *sym)
+{
+	bool *visited = symbol__priv(sym);
+	*visited = true;
+	return 0;
+}
+
+static int test__vmlinux_matches_kallsyms(void)
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
+		struct symbol *pair;
+
+		sym  = rb_entry(nd, struct symbol, rb_node);
+		pair = machine__find_kernel_symbol(&kallsyms, type, sym->start, NULL, NULL);
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
+				pr_debug("%#Lx: diff end addr for %s v: %#Lx k: %#Lx\n",
+					 sym->start, sym->name, sym->end, pair->end);
+			} else {
+				struct rb_node *nnd = rb_prev(&pair->rb_node);
+
+				if (nnd) {
+					struct symbol *next = rb_entry(nnd, struct symbol, rb_node);
+
+					if (next->start == sym->start) {
+						pair = next;
+						goto next_pair;
+					}
+				}
+				pr_debug("%#Lx: diff name v: %s k: %s\n",
+					 sym->start, sym->name, pair->name);
+			}
+		} else
+			pr_debug("%#Lx: %s not on kallsyms\n", sym->start, sym->name);
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
+			pr_info(" %Lx-%Lx %Lx %s in kallsyms as",
+				pos->start, pos->end, pos->pgoff, pos->dso->name);
+			if (pos->pgoff != pair->pgoff || pos->end != pair->end)
+				pr_info(": \n*%Lx-%Lx %Lx",
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
+
+static struct test {
+	const char *desc;
+	int (*func)(void);
+} tests[] = {
+	{
+		.desc = "vmlinux symtab matches kallsyms",
+		.func = test__vmlinux_matches_kallsyms,
+	},
+	{
+		.func = NULL,
+	},
+};
+
+static int __cmd_test(void)
+{
+	int i = 0;
+
+	page_size = sysconf(_SC_PAGE_SIZE);
+
+	while (tests[i].func) {
+		int err;
+		pr_info("%2d: %s:", i + 1, tests[i].desc);
+		pr_debug("\n--- start ---\n");
+		err = tests[i].func();
+		pr_debug("---- end ----\n%s:", tests[i].desc);
+		pr_info(" %s\n", err ? "FAILED!\n" : "Ok");
+		++i;
+	}
+
+	return 0;
+}
+
+static const char * const test_usage[] = {
+	"perf test [<options>]",
+	NULL,
+};
+
+static const struct option test_options[] = {
+	OPT_BOOLEAN('v', "verbose", &verbose,
+		    "be more verbose (show symbol address, etc)"),
+	OPT_END()
+};
+
+int cmd_test(int argc, const char **argv, const char *prefix __used)
+{
+	argc = parse_options(argc, argv, test_options, test_usage, 0);
+	if (argc)
+		usage_with_options(test_usage, test_options);
+
+	symbol_conf.priv_size = sizeof(int);
+	symbol_conf.sort_by_name = true;
+	symbol_conf.try_vmlinux_path = true;
+
+	if (symbol__init() < 0)
+		return -1;
+
+	setup_pager();
+
+	return __cmd_test();
+}
diff --git a/tools/perf/builtin.h b/tools/perf/builtin.h
index ab28bca..34a8a9a 100644
--- a/tools/perf/builtin.h
+++ b/tools/perf/builtin.h
@@ -33,5 +33,6 @@ extern int cmd_probe(int argc, const char **argv, const char *prefix);
 extern int cmd_kmem(int argc, const char **argv, const char *prefix);
 extern int cmd_lock(int argc, const char **argv, const char *prefix);
 extern int cmd_kvm(int argc, const char **argv, const char *prefix);
+extern int cmd_test(int argc, const char **argv, const char *prefix);
 
 #endif
diff --git a/tools/perf/command-list.txt b/tools/perf/command-list.txt
index 2a1162d..80a1a44 100644
--- a/tools/perf/command-list.txt
+++ b/tools/perf/command-list.txt
@@ -20,3 +20,4 @@ perf-probe			mainporcelain common
 perf-kmem			mainporcelain common
 perf-lock			mainporcelain common
 perf-kvm			mainporcelain common
+perf-test			mainporcelain common
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 985cdb4..5ff9b5b 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -308,6 +308,7 @@ static void handle_internal_command(int argc, const char **argv)
 		{ "kmem",	cmd_kmem,	0 },
 		{ "lock",	cmd_lock,	0 },
 		{ "kvm",	cmd_kvm,	0 },
+		{ "test",	cmd_test,	0 },
 	};
 	unsigned int i;
 	static const char ext[] = STRIP_EXTENSION;
-- 
1.6.2.5

