Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964784Ab2KERXi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 12:23:38 -0500
Received: from merlin.infradead.org ([205.233.59.134]:44924 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754622Ab2KERSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 12:18:47 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 03/32] perf tests: Move test objects into 'tests' directory
Date: Mon,  5 Nov 2012 14:17:44 -0300
Message-Id: <1352135893-7564-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1352135893-7564-1-git-send-email-acme@infradead.org>
References: <1352135893-7564-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Separating test objects into 'tests' directory.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1351634526-1516-3-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile                 |    9 +-
 tools/perf/builtin-test.c           | 1559 -----------------------------------
 tools/perf/tests/builtin-test.c     | 1559 +++++++++++++++++++++++++++++++++++
 tools/perf/tests/dso-data.c         |  153 ++++
 tools/perf/tests/parse-events.c     | 1116 +++++++++++++++++++++++++
 tools/perf/util/dso-test-data.c     |  153 ----
 tools/perf/util/parse-events-test.c | 1116 -------------------------
 7 files changed, 2833 insertions(+), 2832 deletions(-)
 delete mode 100644 tools/perf/builtin-test.c
 create mode 100644 tools/perf/tests/builtin-test.c
 create mode 100644 tools/perf/tests/dso-data.c
 create mode 100644 tools/perf/tests/parse-events.c
 delete mode 100644 tools/perf/util/dso-test-data.c
 delete mode 100644 tools/perf/util/parse-events-test.c

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 3e807d7..2d3427f 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -169,7 +169,7 @@ endif
 
 ### --- END CONFIGURATION SECTION ---
 
-BASIC_CFLAGS = -Iutil/include -Iarch/$(ARCH)/include -I$(OUTPUT)util -I$(TRACE_EVENT_DIR) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
+BASIC_CFLAGS = -Iutil/include -Iarch/$(ARCH)/include -I$(OUTPUT)util -Iutil -I. -I$(TRACE_EVENT_DIR) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
 BASIC_LDFLAGS =
 
 ifeq ($(call try-cc,$(SOURCE_BIONIC),$(CFLAGS),bionic),y)
@@ -371,7 +371,6 @@ LIB_OBJS += $(OUTPUT)util/help.o
 LIB_OBJS += $(OUTPUT)util/levenshtein.o
 LIB_OBJS += $(OUTPUT)util/parse-options.o
 LIB_OBJS += $(OUTPUT)util/parse-events.o
-LIB_OBJS += $(OUTPUT)util/parse-events-test.o
 LIB_OBJS += $(OUTPUT)util/path.o
 LIB_OBJS += $(OUTPUT)util/rbtree.o
 LIB_OBJS += $(OUTPUT)util/bitmap.o
@@ -389,7 +388,6 @@ LIB_OBJS += $(OUTPUT)util/sigchain.o
 LIB_OBJS += $(OUTPUT)util/dso.o
 LIB_OBJS += $(OUTPUT)util/symbol.o
 LIB_OBJS += $(OUTPUT)util/symbol-elf.o
-LIB_OBJS += $(OUTPUT)util/dso-test-data.o
 LIB_OBJS += $(OUTPUT)util/color.o
 LIB_OBJS += $(OUTPUT)util/pager.o
 LIB_OBJS += $(OUTPUT)util/header.o
@@ -430,6 +428,9 @@ LIB_OBJS += $(OUTPUT)ui/stdio/hist.o
 
 LIB_OBJS += $(OUTPUT)arch/common.o
 
+LIB_OBJS += $(OUTPUT)tests/parse-events.o
+LIB_OBJS += $(OUTPUT)tests/dso-data.o
+
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
 BUILTIN_OBJS += $(OUTPUT)builtin-bench.o
 # Benchmark modules
@@ -459,8 +460,8 @@ BUILTIN_OBJS += $(OUTPUT)builtin-probe.o
 BUILTIN_OBJS += $(OUTPUT)builtin-kmem.o
 BUILTIN_OBJS += $(OUTPUT)builtin-lock.o
 BUILTIN_OBJS += $(OUTPUT)builtin-kvm.o
-BUILTIN_OBJS += $(OUTPUT)builtin-test.o
 BUILTIN_OBJS += $(OUTPUT)builtin-inject.o
+BUILTIN_OBJS += $(OUTPUT)tests/builtin-test.o
 
 PERFLIBS = $(LIB_FILE) $(LIBTRACEEVENT)
 
diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
deleted file mode 100644
index a04276e..0000000
--- a/tools/perf/builtin-test.c
+++ /dev/null
@@ -1,1559 +0,0 @@
-/*
- * builtin-test.c
- *
- * Builtin regression testing command: ever growing number of sanity tests
- */
-#include "builtin.h"
-
-#include "util/cache.h"
-#include "util/color.h"
-#include "util/debug.h"
-#include "util/debugfs.h"
-#include "util/evlist.h"
-#include "util/parse-options.h"
-#include "util/parse-events.h"
-#include "util/symbol.h"
-#include "util/thread_map.h"
-#include "util/pmu.h"
-#include "event-parse.h"
-#include "../../include/linux/hw_breakpoint.h"
-
-#include <sys/mman.h>
-
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
-#include "util/cpumap.h"
-#include "util/evsel.h"
-#include <sys/types.h>
-
-static int trace_event__id(const char *evname)
-{
-	char *filename;
-	int err = -1, fd;
-
-	if (asprintf(&filename,
-		     "%s/syscalls/%s/id",
-		     tracing_events_path, evname) < 0)
-		return -1;
-
-	fd = open(filename, O_RDONLY);
-	if (fd >= 0) {
-		char id[16];
-		if (read(fd, id, sizeof(id)) > 0)
-			err = atoi(id);
-		close(fd);
-	}
-
-	free(filename);
-	return err;
-}
-
-static int test__open_syscall_event(void)
-{
-	int err = -1, fd;
-	struct thread_map *threads;
-	struct perf_evsel *evsel;
-	struct perf_event_attr attr;
-	unsigned int nr_open_calls = 111, i;
-	int id = trace_event__id("sys_enter_open");
-
-	if (id < 0) {
-		pr_debug("is debugfs mounted on /sys/kernel/debug?\n");
-		return -1;
-	}
-
-	threads = thread_map__new(-1, getpid(), UINT_MAX);
-	if (threads == NULL) {
-		pr_debug("thread_map__new\n");
-		return -1;
-	}
-
-	memset(&attr, 0, sizeof(attr));
-	attr.type = PERF_TYPE_TRACEPOINT;
-	attr.config = id;
-	evsel = perf_evsel__new(&attr, 0);
-	if (evsel == NULL) {
-		pr_debug("perf_evsel__new\n");
-		goto out_thread_map_delete;
-	}
-
-	if (perf_evsel__open_per_thread(evsel, threads) < 0) {
-		pr_debug("failed to open counter: %s, "
-			 "tweak /proc/sys/kernel/perf_event_paranoid?\n",
-			 strerror(errno));
-		goto out_evsel_delete;
-	}
-
-	for (i = 0; i < nr_open_calls; ++i) {
-		fd = open("/etc/passwd", O_RDONLY);
-		close(fd);
-	}
-
-	if (perf_evsel__read_on_cpu(evsel, 0, 0) < 0) {
-		pr_debug("perf_evsel__read_on_cpu\n");
-		goto out_close_fd;
-	}
-
-	if (evsel->counts->cpu[0].val != nr_open_calls) {
-		pr_debug("perf_evsel__read_on_cpu: expected to intercept %d calls, got %" PRIu64 "\n",
-			 nr_open_calls, evsel->counts->cpu[0].val);
-		goto out_close_fd;
-	}
-	
-	err = 0;
-out_close_fd:
-	perf_evsel__close_fd(evsel, 1, threads->nr);
-out_evsel_delete:
-	perf_evsel__delete(evsel);
-out_thread_map_delete:
-	thread_map__delete(threads);
-	return err;
-}
-
-#include <sched.h>
-
-static int test__open_syscall_event_on_all_cpus(void)
-{
-	int err = -1, fd, cpu;
-	struct thread_map *threads;
-	struct cpu_map *cpus;
-	struct perf_evsel *evsel;
-	struct perf_event_attr attr;
-	unsigned int nr_open_calls = 111, i;
-	cpu_set_t cpu_set;
-	int id = trace_event__id("sys_enter_open");
-
-	if (id < 0) {
-		pr_debug("is debugfs mounted on /sys/kernel/debug?\n");
-		return -1;
-	}
-
-	threads = thread_map__new(-1, getpid(), UINT_MAX);
-	if (threads == NULL) {
-		pr_debug("thread_map__new\n");
-		return -1;
-	}
-
-	cpus = cpu_map__new(NULL);
-	if (cpus == NULL) {
-		pr_debug("cpu_map__new\n");
-		goto out_thread_map_delete;
-	}
-
-
-	CPU_ZERO(&cpu_set);
-
-	memset(&attr, 0, sizeof(attr));
-	attr.type = PERF_TYPE_TRACEPOINT;
-	attr.config = id;
-	evsel = perf_evsel__new(&attr, 0);
-	if (evsel == NULL) {
-		pr_debug("perf_evsel__new\n");
-		goto out_thread_map_delete;
-	}
-
-	if (perf_evsel__open(evsel, cpus, threads) < 0) {
-		pr_debug("failed to open counter: %s, "
-			 "tweak /proc/sys/kernel/perf_event_paranoid?\n",
-			 strerror(errno));
-		goto out_evsel_delete;
-	}
-
-	for (cpu = 0; cpu < cpus->nr; ++cpu) {
-		unsigned int ncalls = nr_open_calls + cpu;
-		/*
-		 * XXX eventually lift this restriction in a way that
-		 * keeps perf building on older glibc installations
-		 * without CPU_ALLOC. 1024 cpus in 2010 still seems
-		 * a reasonable upper limit tho :-)
-		 */
-		if (cpus->map[cpu] >= CPU_SETSIZE) {
-			pr_debug("Ignoring CPU %d\n", cpus->map[cpu]);
-			continue;
-		}
-
-		CPU_SET(cpus->map[cpu], &cpu_set);
-		if (sched_setaffinity(0, sizeof(cpu_set), &cpu_set) < 0) {
-			pr_debug("sched_setaffinity() failed on CPU %d: %s ",
-				 cpus->map[cpu],
-				 strerror(errno));
-			goto out_close_fd;
-		}
-		for (i = 0; i < ncalls; ++i) {
-			fd = open("/etc/passwd", O_RDONLY);
-			close(fd);
-		}
-		CPU_CLR(cpus->map[cpu], &cpu_set);
-	}
-
-	/*
-	 * Here we need to explicitely preallocate the counts, as if
-	 * we use the auto allocation it will allocate just for 1 cpu,
-	 * as we start by cpu 0.
-	 */
-	if (perf_evsel__alloc_counts(evsel, cpus->nr) < 0) {
-		pr_debug("perf_evsel__alloc_counts(ncpus=%d)\n", cpus->nr);
-		goto out_close_fd;
-	}
-
-	err = 0;
-
-	for (cpu = 0; cpu < cpus->nr; ++cpu) {
-		unsigned int expected;
-
-		if (cpus->map[cpu] >= CPU_SETSIZE)
-			continue;
-
-		if (perf_evsel__read_on_cpu(evsel, cpu, 0) < 0) {
-			pr_debug("perf_evsel__read_on_cpu\n");
-			err = -1;
-			break;
-		}
-
-		expected = nr_open_calls + cpu;
-		if (evsel->counts->cpu[cpu].val != expected) {
-			pr_debug("perf_evsel__read_on_cpu: expected to intercept %d calls on cpu %d, got %" PRIu64 "\n",
-				 expected, cpus->map[cpu], evsel->counts->cpu[cpu].val);
-			err = -1;
-		}
-	}
-
-out_close_fd:
-	perf_evsel__close_fd(evsel, 1, threads->nr);
-out_evsel_delete:
-	perf_evsel__delete(evsel);
-out_thread_map_delete:
-	thread_map__delete(threads);
-	return err;
-}
-
-/*
- * This test will generate random numbers of calls to some getpid syscalls,
- * then establish an mmap for a group of events that are created to monitor
- * the syscalls.
- *
- * It will receive the events, using mmap, use its PERF_SAMPLE_ID generated
- * sample.id field to map back to its respective perf_evsel instance.
- *
- * Then it checks if the number of syscalls reported as perf events by
- * the kernel corresponds to the number of syscalls made.
- */
-static int test__basic_mmap(void)
-{
-	int err = -1;
-	union perf_event *event;
-	struct thread_map *threads;
-	struct cpu_map *cpus;
-	struct perf_evlist *evlist;
-	struct perf_event_attr attr = {
-		.type		= PERF_TYPE_TRACEPOINT,
-		.read_format	= PERF_FORMAT_ID,
-		.sample_type	= PERF_SAMPLE_ID,
-		.watermark	= 0,
-	};
-	cpu_set_t cpu_set;
-	const char *syscall_names[] = { "getsid", "getppid", "getpgrp",
-					"getpgid", };
-	pid_t (*syscalls[])(void) = { (void *)getsid, getppid, getpgrp,
-				      (void*)getpgid };
-#define nsyscalls ARRAY_SIZE(syscall_names)
-	int ids[nsyscalls];
-	unsigned int nr_events[nsyscalls],
-		     expected_nr_events[nsyscalls], i, j;
-	struct perf_evsel *evsels[nsyscalls], *evsel;
-
-	for (i = 0; i < nsyscalls; ++i) {
-		char name[64];
-
-		snprintf(name, sizeof(name), "sys_enter_%s", syscall_names[i]);
-		ids[i] = trace_event__id(name);
-		if (ids[i] < 0) {
-			pr_debug("Is debugfs mounted on /sys/kernel/debug?\n");
-			return -1;
-		}
-		nr_events[i] = 0;
-		expected_nr_events[i] = random() % 257;
-	}
-
-	threads = thread_map__new(-1, getpid(), UINT_MAX);
-	if (threads == NULL) {
-		pr_debug("thread_map__new\n");
-		return -1;
-	}
-
-	cpus = cpu_map__new(NULL);
-	if (cpus == NULL) {
-		pr_debug("cpu_map__new\n");
-		goto out_free_threads;
-	}
-
-	CPU_ZERO(&cpu_set);
-	CPU_SET(cpus->map[0], &cpu_set);
-	sched_setaffinity(0, sizeof(cpu_set), &cpu_set);
-	if (sched_setaffinity(0, sizeof(cpu_set), &cpu_set) < 0) {
-		pr_debug("sched_setaffinity() failed on CPU %d: %s ",
-			 cpus->map[0], strerror(errno));
-		goto out_free_cpus;
-	}
-
-	evlist = perf_evlist__new(cpus, threads);
-	if (evlist == NULL) {
-		pr_debug("perf_evlist__new\n");
-		goto out_free_cpus;
-	}
-
-	/* anonymous union fields, can't be initialized above */
-	attr.wakeup_events = 1;
-	attr.sample_period = 1;
-
-	for (i = 0; i < nsyscalls; ++i) {
-		attr.config = ids[i];
-		evsels[i] = perf_evsel__new(&attr, i);
-		if (evsels[i] == NULL) {
-			pr_debug("perf_evsel__new\n");
-			goto out_free_evlist;
-		}
-
-		perf_evlist__add(evlist, evsels[i]);
-
-		if (perf_evsel__open(evsels[i], cpus, threads) < 0) {
-			pr_debug("failed to open counter: %s, "
-				 "tweak /proc/sys/kernel/perf_event_paranoid?\n",
-				 strerror(errno));
-			goto out_close_fd;
-		}
-	}
-
-	if (perf_evlist__mmap(evlist, 128, true) < 0) {
-		pr_debug("failed to mmap events: %d (%s)\n", errno,
-			 strerror(errno));
-		goto out_close_fd;
-	}
-
-	for (i = 0; i < nsyscalls; ++i)
-		for (j = 0; j < expected_nr_events[i]; ++j) {
-			int foo = syscalls[i]();
-			++foo;
-		}
-
-	while ((event = perf_evlist__mmap_read(evlist, 0)) != NULL) {
-		struct perf_sample sample;
-
-		if (event->header.type != PERF_RECORD_SAMPLE) {
-			pr_debug("unexpected %s event\n",
-				 perf_event__name(event->header.type));
-			goto out_munmap;
-		}
-
-		err = perf_evlist__parse_sample(evlist, event, &sample);
-		if (err) {
-			pr_err("Can't parse sample, err = %d\n", err);
-			goto out_munmap;
-		}
-
-		evsel = perf_evlist__id2evsel(evlist, sample.id);
-		if (evsel == NULL) {
-			pr_debug("event with id %" PRIu64
-				 " doesn't map to an evsel\n", sample.id);
-			goto out_munmap;
-		}
-		nr_events[evsel->idx]++;
-	}
-
-	list_for_each_entry(evsel, &evlist->entries, node) {
-		if (nr_events[evsel->idx] != expected_nr_events[evsel->idx]) {
-			pr_debug("expected %d %s events, got %d\n",
-				 expected_nr_events[evsel->idx],
-				 perf_evsel__name(evsel), nr_events[evsel->idx]);
-			goto out_munmap;
-		}
-	}
-
-	err = 0;
-out_munmap:
-	perf_evlist__munmap(evlist);
-out_close_fd:
-	for (i = 0; i < nsyscalls; ++i)
-		perf_evsel__close_fd(evsels[i], 1, threads->nr);
-out_free_evlist:
-	perf_evlist__delete(evlist);
-out_free_cpus:
-	cpu_map__delete(cpus);
-out_free_threads:
-	thread_map__delete(threads);
-	return err;
-#undef nsyscalls
-}
-
-static int sched__get_first_possible_cpu(pid_t pid, cpu_set_t **maskp,
-					 size_t *sizep)
-{
-	cpu_set_t *mask;
-	size_t size;
-	int i, cpu = -1, nrcpus = 1024;
-realloc:
-	mask = CPU_ALLOC(nrcpus);
-	size = CPU_ALLOC_SIZE(nrcpus);
-	CPU_ZERO_S(size, mask);
-
-	if (sched_getaffinity(pid, size, mask) == -1) {
-		CPU_FREE(mask);
-		if (errno == EINVAL && nrcpus < (1024 << 8)) {
-			nrcpus = nrcpus << 2;
-			goto realloc;
-		}
-		perror("sched_getaffinity");
-			return -1;
-	}
-
-	for (i = 0; i < nrcpus; i++) {
-		if (CPU_ISSET_S(i, size, mask)) {
-			if (cpu == -1) {
-				cpu = i;
-				*maskp = mask;
-				*sizep = size;
-			} else
-				CPU_CLR_S(i, size, mask);
-		}
-	}
-
-	if (cpu == -1)
-		CPU_FREE(mask);
-
-	return cpu;
-}
-
-static int test__PERF_RECORD(void)
-{
-	struct perf_record_opts opts = {
-		.target = {
-			.uid = UINT_MAX,
-			.uses_mmap = true,
-		},
-		.no_delay   = true,
-		.freq	    = 10,
-		.mmap_pages = 256,
-	};
-	cpu_set_t *cpu_mask = NULL;
-	size_t cpu_mask_size = 0;
-	struct perf_evlist *evlist = perf_evlist__new(NULL, NULL);
-	struct perf_evsel *evsel;
-	struct perf_sample sample;
-	const char *cmd = "sleep";
-	const char *argv[] = { cmd, "1", NULL, };
-	char *bname;
-	u64 prev_time = 0;
-	bool found_cmd_mmap = false,
-	     found_libc_mmap = false,
-	     found_vdso_mmap = false,
-	     found_ld_mmap = false;
-	int err = -1, errs = 0, i, wakeups = 0;
-	u32 cpu;
-	int total_events = 0, nr_events[PERF_RECORD_MAX] = { 0, };
-
-	if (evlist == NULL || argv == NULL) {
-		pr_debug("Not enough memory to create evlist\n");
-		goto out;
-	}
-
-	/*
-	 * We need at least one evsel in the evlist, use the default
-	 * one: "cycles".
-	 */
-	err = perf_evlist__add_default(evlist);
-	if (err < 0) {
-		pr_debug("Not enough memory to create evsel\n");
-		goto out_delete_evlist;
-	}
-
-	/*
-	 * Create maps of threads and cpus to monitor. In this case
-	 * we start with all threads and cpus (-1, -1) but then in
-	 * perf_evlist__prepare_workload we'll fill in the only thread
-	 * we're monitoring, the one forked there.
-	 */
-	err = perf_evlist__create_maps(evlist, &opts.target);
-	if (err < 0) {
-		pr_debug("Not enough memory to create thread/cpu maps\n");
-		goto out_delete_evlist;
-	}
-
-	/*
-	 * Prepare the workload in argv[] to run, it'll fork it, and then wait
-	 * for perf_evlist__start_workload() to exec it. This is done this way
-	 * so that we have time to open the evlist (calling sys_perf_event_open
-	 * on all the fds) and then mmap them.
-	 */
-	err = perf_evlist__prepare_workload(evlist, &opts, argv);
-	if (err < 0) {
-		pr_debug("Couldn't run the workload!\n");
-		goto out_delete_evlist;
-	}
-
-	/*
-	 * Config the evsels, setting attr->comm on the first one, etc.
-	 */
-	evsel = perf_evlist__first(evlist);
-	evsel->attr.sample_type |= PERF_SAMPLE_CPU;
-	evsel->attr.sample_type |= PERF_SAMPLE_TID;
-	evsel->attr.sample_type |= PERF_SAMPLE_TIME;
-	perf_evlist__config_attrs(evlist, &opts);
-
-	err = sched__get_first_possible_cpu(evlist->workload.pid, &cpu_mask,
-					    &cpu_mask_size);
-	if (err < 0) {
-		pr_debug("sched__get_first_possible_cpu: %s\n", strerror(errno));
-		goto out_delete_evlist;
-	}
-
-	cpu = err;
-
-	/*
-	 * So that we can check perf_sample.cpu on all the samples.
-	 */
-	if (sched_setaffinity(evlist->workload.pid, cpu_mask_size, cpu_mask) < 0) {
-		pr_debug("sched_setaffinity: %s\n", strerror(errno));
-		goto out_free_cpu_mask;
-	}
-
-	/*
-	 * Call sys_perf_event_open on all the fds on all the evsels,
-	 * grouping them if asked to.
-	 */
-	err = perf_evlist__open(evlist);
-	if (err < 0) {
-		pr_debug("perf_evlist__open: %s\n", strerror(errno));
-		goto out_delete_evlist;
-	}
-
-	/*
-	 * mmap the first fd on a given CPU and ask for events for the other
-	 * fds in the same CPU to be injected in the same mmap ring buffer
-	 * (using ioctl(PERF_EVENT_IOC_SET_OUTPUT)).
-	 */
-	err = perf_evlist__mmap(evlist, opts.mmap_pages, false);
-	if (err < 0) {
-		pr_debug("perf_evlist__mmap: %s\n", strerror(errno));
-		goto out_delete_evlist;
-	}
-
-	/*
-	 * Now that all is properly set up, enable the events, they will
-	 * count just on workload.pid, which will start...
-	 */
-	perf_evlist__enable(evlist);
-
-	/*
-	 * Now!
-	 */
-	perf_evlist__start_workload(evlist);
-
-	while (1) {
-		int before = total_events;
-
-		for (i = 0; i < evlist->nr_mmaps; i++) {
-			union perf_event *event;
-
-			while ((event = perf_evlist__mmap_read(evlist, i)) != NULL) {
-				const u32 type = event->header.type;
-				const char *name = perf_event__name(type);
-
-				++total_events;
-				if (type < PERF_RECORD_MAX)
-					nr_events[type]++;
-
-				err = perf_evlist__parse_sample(evlist, event, &sample);
-				if (err < 0) {
-					if (verbose)
-						perf_event__fprintf(event, stderr);
-					pr_debug("Couldn't parse sample\n");
-					goto out_err;
-				}
-
-				if (verbose) {
-					pr_info("%" PRIu64" %d ", sample.time, sample.cpu);
-					perf_event__fprintf(event, stderr);
-				}
-
-				if (prev_time > sample.time) {
-					pr_debug("%s going backwards in time, prev=%" PRIu64 ", curr=%" PRIu64 "\n",
-						 name, prev_time, sample.time);
-					++errs;
-				}
-
-				prev_time = sample.time;
-
-				if (sample.cpu != cpu) {
-					pr_debug("%s with unexpected cpu, expected %d, got %d\n",
-						 name, cpu, sample.cpu);
-					++errs;
-				}
-
-				if ((pid_t)sample.pid != evlist->workload.pid) {
-					pr_debug("%s with unexpected pid, expected %d, got %d\n",
-						 name, evlist->workload.pid, sample.pid);
-					++errs;
-				}
-
-				if ((pid_t)sample.tid != evlist->workload.pid) {
-					pr_debug("%s with unexpected tid, expected %d, got %d\n",
-						 name, evlist->workload.pid, sample.tid);
-					++errs;
-				}
-
-				if ((type == PERF_RECORD_COMM ||
-				     type == PERF_RECORD_MMAP ||
-				     type == PERF_RECORD_FORK ||
-				     type == PERF_RECORD_EXIT) &&
-				     (pid_t)event->comm.pid != evlist->workload.pid) {
-					pr_debug("%s with unexpected pid/tid\n", name);
-					++errs;
-				}
-
-				if ((type == PERF_RECORD_COMM ||
-				     type == PERF_RECORD_MMAP) &&
-				     event->comm.pid != event->comm.tid) {
-					pr_debug("%s with different pid/tid!\n", name);
-					++errs;
-				}
-
-				switch (type) {
-				case PERF_RECORD_COMM:
-					if (strcmp(event->comm.comm, cmd)) {
-						pr_debug("%s with unexpected comm!\n", name);
-						++errs;
-					}
-					break;
-				case PERF_RECORD_EXIT:
-					goto found_exit;
-				case PERF_RECORD_MMAP:
-					bname = strrchr(event->mmap.filename, '/');
-					if (bname != NULL) {
-						if (!found_cmd_mmap)
-							found_cmd_mmap = !strcmp(bname + 1, cmd);
-						if (!found_libc_mmap)
-							found_libc_mmap = !strncmp(bname + 1, "libc", 4);
-						if (!found_ld_mmap)
-							found_ld_mmap = !strncmp(bname + 1, "ld", 2);
-					} else if (!found_vdso_mmap)
-						found_vdso_mmap = !strcmp(event->mmap.filename, "[vdso]");
-					break;
-
-				case PERF_RECORD_SAMPLE:
-					/* Just ignore samples for now */
-					break;
-				default:
-					pr_debug("Unexpected perf_event->header.type %d!\n",
-						 type);
-					++errs;
-				}
-			}
-		}
-
-		/*
-		 * We don't use poll here because at least at 3.1 times the
-		 * PERF_RECORD_{!SAMPLE} events don't honour
-		 * perf_event_attr.wakeup_events, just PERF_EVENT_SAMPLE does.
-		 */
-		if (total_events == before && false)
-			poll(evlist->pollfd, evlist->nr_fds, -1);
-
-		sleep(1);
-		if (++wakeups > 5) {
-			pr_debug("No PERF_RECORD_EXIT event!\n");
-			break;
-		}
-	}
-
-found_exit:
-	if (nr_events[PERF_RECORD_COMM] > 1) {
-		pr_debug("Excessive number of PERF_RECORD_COMM events!\n");
-		++errs;
-	}
-
-	if (nr_events[PERF_RECORD_COMM] == 0) {
-		pr_debug("Missing PERF_RECORD_COMM for %s!\n", cmd);
-		++errs;
-	}
-
-	if (!found_cmd_mmap) {
-		pr_debug("PERF_RECORD_MMAP for %s missing!\n", cmd);
-		++errs;
-	}
-
-	if (!found_libc_mmap) {
-		pr_debug("PERF_RECORD_MMAP for %s missing!\n", "libc");
-		++errs;
-	}
-
-	if (!found_ld_mmap) {
-		pr_debug("PERF_RECORD_MMAP for %s missing!\n", "ld");
-		++errs;
-	}
-
-	if (!found_vdso_mmap) {
-		pr_debug("PERF_RECORD_MMAP for %s missing!\n", "[vdso]");
-		++errs;
-	}
-out_err:
-	perf_evlist__munmap(evlist);
-out_free_cpu_mask:
-	CPU_FREE(cpu_mask);
-out_delete_evlist:
-	perf_evlist__delete(evlist);
-out:
-	return (err < 0 || errs > 0) ? -1 : 0;
-}
-
-
-#if defined(__x86_64__) || defined(__i386__)
-
-#define barrier() asm volatile("" ::: "memory")
-
-static u64 rdpmc(unsigned int counter)
-{
-	unsigned int low, high;
-
-	asm volatile("rdpmc" : "=a" (low), "=d" (high) : "c" (counter));
-
-	return low | ((u64)high) << 32;
-}
-
-static u64 rdtsc(void)
-{
-	unsigned int low, high;
-
-	asm volatile("rdtsc" : "=a" (low), "=d" (high));
-
-	return low | ((u64)high) << 32;
-}
-
-static u64 mmap_read_self(void *addr)
-{
-	struct perf_event_mmap_page *pc = addr;
-	u32 seq, idx, time_mult = 0, time_shift = 0;
-	u64 count, cyc = 0, time_offset = 0, enabled, running, delta;
-
-	do {
-		seq = pc->lock;
-		barrier();
-
-		enabled = pc->time_enabled;
-		running = pc->time_running;
-
-		if (enabled != running) {
-			cyc = rdtsc();
-			time_mult = pc->time_mult;
-			time_shift = pc->time_shift;
-			time_offset = pc->time_offset;
-		}
-
-		idx = pc->index;
-		count = pc->offset;
-		if (idx)
-			count += rdpmc(idx - 1);
-
-		barrier();
-	} while (pc->lock != seq);
-
-	if (enabled != running) {
-		u64 quot, rem;
-
-		quot = (cyc >> time_shift);
-		rem = cyc & ((1 << time_shift) - 1);
-		delta = time_offset + quot * time_mult +
-			((rem * time_mult) >> time_shift);
-
-		enabled += delta;
-		if (idx)
-			running += delta;
-
-		quot = count / running;
-		rem = count % running;
-		count = quot * enabled + (rem * enabled) / running;
-	}
-
-	return count;
-}
-
-/*
- * If the RDPMC instruction faults then signal this back to the test parent task:
- */
-static void segfault_handler(int sig __maybe_unused,
-			     siginfo_t *info __maybe_unused,
-			     void *uc __maybe_unused)
-{
-	exit(-1);
-}
-
-static int __test__rdpmc(void)
-{
-	volatile int tmp = 0;
-	u64 i, loops = 1000;
-	int n;
-	int fd;
-	void *addr;
-	struct perf_event_attr attr = {
-		.type = PERF_TYPE_HARDWARE,
-		.config = PERF_COUNT_HW_INSTRUCTIONS,
-		.exclude_kernel = 1,
-	};
-	u64 delta_sum = 0;
-        struct sigaction sa;
-
-	sigfillset(&sa.sa_mask);
-	sa.sa_sigaction = segfault_handler;
-	sigaction(SIGSEGV, &sa, NULL);
-
-	fd = sys_perf_event_open(&attr, 0, -1, -1, 0);
-	if (fd < 0) {
-		pr_err("Error: sys_perf_event_open() syscall returned "
-		       "with %d (%s)\n", fd, strerror(errno));
-		return -1;
-	}
-
-	addr = mmap(NULL, page_size, PROT_READ, MAP_SHARED, fd, 0);
-	if (addr == (void *)(-1)) {
-		pr_err("Error: mmap() syscall returned with (%s)\n",
-		       strerror(errno));
-		goto out_close;
-	}
-
-	for (n = 0; n < 6; n++) {
-		u64 stamp, now, delta;
-
-		stamp = mmap_read_self(addr);
-
-		for (i = 0; i < loops; i++)
-			tmp++;
-
-		now = mmap_read_self(addr);
-		loops *= 10;
-
-		delta = now - stamp;
-		pr_debug("%14d: %14Lu\n", n, (long long)delta);
-
-		delta_sum += delta;
-	}
-
-	munmap(addr, page_size);
-	pr_debug("   ");
-out_close:
-	close(fd);
-
-	if (!delta_sum)
-		return -1;
-
-	return 0;
-}
-
-static int test__rdpmc(void)
-{
-	int status = 0;
-	int wret = 0;
-	int ret;
-	int pid;
-
-	pid = fork();
-	if (pid < 0)
-		return -1;
-
-	if (!pid) {
-		ret = __test__rdpmc();
-
-		exit(ret);
-	}
-
-	wret = waitpid(pid, &status, 0);
-	if (wret < 0 || status)
-		return -1;
-
-	return 0;
-}
-
-#endif
-
-static int test__perf_pmu(void)
-{
-	return perf_pmu__test();
-}
-
-static int perf_evsel__roundtrip_cache_name_test(void)
-{
-	char name[128];
-	int type, op, err = 0, ret = 0, i, idx;
-	struct perf_evsel *evsel;
-        struct perf_evlist *evlist = perf_evlist__new(NULL, NULL);
-
-        if (evlist == NULL)
-                return -ENOMEM;
-
-	for (type = 0; type < PERF_COUNT_HW_CACHE_MAX; type++) {
-		for (op = 0; op < PERF_COUNT_HW_CACHE_OP_MAX; op++) {
-			/* skip invalid cache type */
-			if (!perf_evsel__is_cache_op_valid(type, op))
-				continue;
-
-			for (i = 0; i < PERF_COUNT_HW_CACHE_RESULT_MAX; i++) {
-				__perf_evsel__hw_cache_type_op_res_name(type, op, i,
-									name, sizeof(name));
-				err = parse_events(evlist, name, 0);
-				if (err)
-					ret = err;
-			}
-		}
-	}
-
-	idx = 0;
-	evsel = perf_evlist__first(evlist);
-
-	for (type = 0; type < PERF_COUNT_HW_CACHE_MAX; type++) {
-		for (op = 0; op < PERF_COUNT_HW_CACHE_OP_MAX; op++) {
-			/* skip invalid cache type */
-			if (!perf_evsel__is_cache_op_valid(type, op))
-				continue;
-
-			for (i = 0; i < PERF_COUNT_HW_CACHE_RESULT_MAX; i++) {
-				__perf_evsel__hw_cache_type_op_res_name(type, op, i,
-									name, sizeof(name));
-				if (evsel->idx != idx)
-					continue;
-
-				++idx;
-
-				if (strcmp(perf_evsel__name(evsel), name)) {
-					pr_debug("%s != %s\n", perf_evsel__name(evsel), name);
-					ret = -1;
-				}
-
-				evsel = perf_evsel__next(evsel);
-			}
-		}
-	}
-
-	perf_evlist__delete(evlist);
-	return ret;
-}
-
-static int __perf_evsel__name_array_test(const char *names[], int nr_names)
-{
-	int i, err;
-	struct perf_evsel *evsel;
-        struct perf_evlist *evlist = perf_evlist__new(NULL, NULL);
-
-        if (evlist == NULL)
-                return -ENOMEM;
-
-	for (i = 0; i < nr_names; ++i) {
-		err = parse_events(evlist, names[i], 0);
-		if (err) {
-			pr_debug("failed to parse event '%s', err %d\n",
-				 names[i], err);
-			goto out_delete_evlist;
-		}
-	}
-
-	err = 0;
-	list_for_each_entry(evsel, &evlist->entries, node) {
-		if (strcmp(perf_evsel__name(evsel), names[evsel->idx])) {
-			--err;
-			pr_debug("%s != %s\n", perf_evsel__name(evsel), names[evsel->idx]);
-		}
-	}
-
-out_delete_evlist:
-	perf_evlist__delete(evlist);
-	return err;
-}
-
-#define perf_evsel__name_array_test(names) \
-	__perf_evsel__name_array_test(names, ARRAY_SIZE(names))
-
-static int perf_evsel__roundtrip_name_test(void)
-{
-	int err = 0, ret = 0;
-
-	err = perf_evsel__name_array_test(perf_evsel__hw_names);
-	if (err)
-		ret = err;
-
-	err = perf_evsel__name_array_test(perf_evsel__sw_names);
-	if (err)
-		ret = err;
-
-	err = perf_evsel__roundtrip_cache_name_test();
-	if (err)
-		ret = err;
-
-	return ret;
-}
-
-static int perf_evsel__test_field(struct perf_evsel *evsel, const char *name,
-				  int size, bool should_be_signed)
-{
-	struct format_field *field = perf_evsel__field(evsel, name);
-	int is_signed;
-	int ret = 0;
-
-	if (field == NULL) {
-		pr_debug("%s: \"%s\" field not found!\n", evsel->name, name);
-		return -1;
-	}
-
-	is_signed = !!(field->flags | FIELD_IS_SIGNED);
-	if (should_be_signed && !is_signed) {
-		pr_debug("%s: \"%s\" signedness(%d) is wrong, should be %d\n",
-			 evsel->name, name, is_signed, should_be_signed);
-		ret = -1;
-	}
-
-	if (field->size != size) {
-		pr_debug("%s: \"%s\" size (%d) should be %d!\n",
-			 evsel->name, name, field->size, size);
-		ret = -1;
-	}
-
-	return ret;
-}
-
-static int perf_evsel__tp_sched_test(void)
-{
-	struct perf_evsel *evsel = perf_evsel__newtp("sched", "sched_switch", 0);
-	int ret = 0;
-
-	if (evsel == NULL) {
-		pr_debug("perf_evsel__new\n");
-		return -1;
-	}
-
-	if (perf_evsel__test_field(evsel, "prev_comm", 16, true))
-		ret = -1;
-
-	if (perf_evsel__test_field(evsel, "prev_pid", 4, true))
-		ret = -1;
-
-	if (perf_evsel__test_field(evsel, "prev_prio", 4, true))
-		ret = -1;
-
-	if (perf_evsel__test_field(evsel, "prev_state", 8, true))
-		ret = -1;
-
-	if (perf_evsel__test_field(evsel, "next_comm", 16, true))
-		ret = -1;
-
-	if (perf_evsel__test_field(evsel, "next_pid", 4, true))
-		ret = -1;
-
-	if (perf_evsel__test_field(evsel, "next_prio", 4, true))
-		ret = -1;
-
-	perf_evsel__delete(evsel);
-
-	evsel = perf_evsel__newtp("sched", "sched_wakeup", 0);
-
-	if (perf_evsel__test_field(evsel, "comm", 16, true))
-		ret = -1;
-
-	if (perf_evsel__test_field(evsel, "pid", 4, true))
-		ret = -1;
-
-	if (perf_evsel__test_field(evsel, "prio", 4, true))
-		ret = -1;
-
-	if (perf_evsel__test_field(evsel, "success", 4, true))
-		ret = -1;
-
-	if (perf_evsel__test_field(evsel, "target_cpu", 4, true))
-		ret = -1;
-
-	return ret;
-}
-
-static int test__syscall_open_tp_fields(void)
-{
-	struct perf_record_opts opts = {
-		.target = {
-			.uid = UINT_MAX,
-			.uses_mmap = true,
-		},
-		.no_delay   = true,
-		.freq	    = 1,
-		.mmap_pages = 256,
-		.raw_samples = true,
-	};
-	const char *filename = "/etc/passwd";
-	int flags = O_RDONLY | O_DIRECTORY;
-	struct perf_evlist *evlist = perf_evlist__new(NULL, NULL);
-	struct perf_evsel *evsel;
-	int err = -1, i, nr_events = 0, nr_polls = 0;
-
-	if (evlist == NULL) {
-		pr_debug("%s: perf_evlist__new\n", __func__);
-		goto out;
-	}
-
-	evsel = perf_evsel__newtp("syscalls", "sys_enter_open", 0);
-	if (evsel == NULL) {
-		pr_debug("%s: perf_evsel__newtp\n", __func__);
-		goto out_delete_evlist;
-	}
-
-	perf_evlist__add(evlist, evsel);
-
-	err = perf_evlist__create_maps(evlist, &opts.target);
-	if (err < 0) {
-		pr_debug("%s: perf_evlist__create_maps\n", __func__);
-		goto out_delete_evlist;
-	}
-
-	perf_evsel__config(evsel, &opts, evsel);
-
-	evlist->threads->map[0] = getpid();
-
-	err = perf_evlist__open(evlist);
-	if (err < 0) {
-		pr_debug("perf_evlist__open: %s\n", strerror(errno));
-		goto out_delete_evlist;
-	}
-
-	err = perf_evlist__mmap(evlist, UINT_MAX, false);
-	if (err < 0) {
-		pr_debug("perf_evlist__mmap: %s\n", strerror(errno));
-		goto out_delete_evlist;
-	}
-
-	perf_evlist__enable(evlist);
-
-	/*
- 	 * Generate the event:
- 	 */
-	open(filename, flags);
-
-	while (1) {
-		int before = nr_events;
-
-		for (i = 0; i < evlist->nr_mmaps; i++) {
-			union perf_event *event;
-
-			while ((event = perf_evlist__mmap_read(evlist, i)) != NULL) {
-				const u32 type = event->header.type;
-				int tp_flags;
-				struct perf_sample sample;
-
-				++nr_events;
-
-				if (type != PERF_RECORD_SAMPLE)
-					continue;
-
-				err = perf_evsel__parse_sample(evsel, event, &sample);
-				if (err) {
-					pr_err("Can't parse sample, err = %d\n", err);
-					goto out_munmap;
-				}
-
-				tp_flags = perf_evsel__intval(evsel, &sample, "flags");
-
-				if (flags != tp_flags) {
-					pr_debug("%s: Expected flags=%#x, got %#x\n",
-						 __func__, flags, tp_flags);
-					goto out_munmap;
-				}
-
-				goto out_ok;
-			}
-		}
-
-		if (nr_events == before)
-			poll(evlist->pollfd, evlist->nr_fds, 10);
-
-		if (++nr_polls > 5) {
-			pr_debug("%s: no events!\n", __func__);
-			goto out_munmap;
-		}
-	}
-out_ok:
-	err = 0;
-out_munmap:
-	perf_evlist__munmap(evlist);
-out_delete_evlist:
-	perf_evlist__delete(evlist);
-out:
-	return err;
-}
-
-static struct test {
-	const char *desc;
-	int (*func)(void);
-} tests[] = {
-	{
-		.desc = "vmlinux symtab matches kallsyms",
-		.func = test__vmlinux_matches_kallsyms,
-	},
-	{
-		.desc = "detect open syscall event",
-		.func = test__open_syscall_event,
-	},
-	{
-		.desc = "detect open syscall event on all cpus",
-		.func = test__open_syscall_event_on_all_cpus,
-	},
-	{
-		.desc = "read samples using the mmap interface",
-		.func = test__basic_mmap,
-	},
-	{
-		.desc = "parse events tests",
-		.func = parse_events__test,
-	},
-#if defined(__x86_64__) || defined(__i386__)
-	{
-		.desc = "x86 rdpmc test",
-		.func = test__rdpmc,
-	},
-#endif
-	{
-		.desc = "Validate PERF_RECORD_* events & perf_sample fields",
-		.func = test__PERF_RECORD,
-	},
-	{
-		.desc = "Test perf pmu format parsing",
-		.func = test__perf_pmu,
-	},
-	{
-		.desc = "Test dso data interface",
-		.func = dso__test_data,
-	},
-	{
-		.desc = "roundtrip evsel->name check",
-		.func = perf_evsel__roundtrip_name_test,
-	},
-	{
-		.desc = "Check parsing of sched tracepoints fields",
-		.func = perf_evsel__tp_sched_test,
-	},
-	{
-		.desc = "Generate and check syscalls:sys_enter_open event fields",
-		.func = test__syscall_open_tp_fields,
-	},
-	{
-		.func = NULL,
-	},
-};
-
-static bool perf_test__matches(int curr, int argc, const char *argv[])
-{
-	int i;
-
-	if (argc == 0)
-		return true;
-
-	for (i = 0; i < argc; ++i) {
-		char *end;
-		long nr = strtoul(argv[i], &end, 10);
-
-		if (*end == '\0') {
-			if (nr == curr + 1)
-				return true;
-			continue;
-		}
-
-		if (strstr(tests[curr].desc, argv[i]))
-			return true;
-	}
-
-	return false;
-}
-
-static int __cmd_test(int argc, const char *argv[])
-{
-	int i = 0;
-	int width = 0;
-
-	while (tests[i].func) {
-		int len = strlen(tests[i].desc);
-
-		if (width < len)
-			width = len;
-		++i;
-	}
-		
-	i = 0;
-	while (tests[i].func) {
-		int curr = i++, err;
-
-		if (!perf_test__matches(curr, argc, argv))
-			continue;
-
-		pr_info("%2d: %-*s:", i, width, tests[curr].desc);
-		pr_debug("\n--- start ---\n");
-		err = tests[curr].func();
-		pr_debug("---- end ----\n%s:", tests[curr].desc);
-		if (err)
-			color_fprintf(stderr, PERF_COLOR_RED, " FAILED!\n");
-		else
-			pr_info(" Ok\n");
-	}
-
-	return 0;
-}
-
-static int perf_test__list(int argc, const char **argv)
-{
-	int i = 0;
-
-	while (tests[i].func) {
-		int curr = i++;
-
-		if (argc > 1 && !strstr(tests[curr].desc, argv[1]))
-			continue;
-
-		pr_info("%2d: %s\n", i, tests[curr].desc);
-	}
-
-	return 0;
-}
-
-int cmd_test(int argc, const char **argv, const char *prefix __maybe_unused)
-{
-	const char * const test_usage[] = {
-	"perf test [<options>] [{list <test-name-fragment>|[<test-name-fragments>|<test-numbers>]}]",
-	NULL,
-	};
-	const struct option test_options[] = {
-	OPT_INCR('v', "verbose", &verbose,
-		    "be more verbose (show symbol address, etc)"),
-	OPT_END()
-	};
-
-	argc = parse_options(argc, argv, test_options, test_usage, 0);
-	if (argc >= 1 && !strcmp(argv[0], "list"))
-		return perf_test__list(argc, argv);
-
-	symbol_conf.priv_size = sizeof(int);
-	symbol_conf.sort_by_name = true;
-	symbol_conf.try_vmlinux_path = true;
-
-	if (symbol__init() < 0)
-		return -1;
-
-	return __cmd_test(argc, argv);
-}
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
new file mode 100644
index 0000000..f6c6424
--- /dev/null
+++ b/tools/perf/tests/builtin-test.c
@@ -0,0 +1,1559 @@
+/*
+ * builtin-test.c
+ *
+ * Builtin regression testing command: ever growing number of sanity tests
+ */
+#include "builtin.h"
+
+#include "util/cache.h"
+#include "util/color.h"
+#include "util/debug.h"
+#include "util/debugfs.h"
+#include "util/evlist.h"
+#include "util/parse-options.h"
+#include "util/parse-events.h"
+#include "util/symbol.h"
+#include "util/thread_map.h"
+#include "util/pmu.h"
+#include "event-parse.h"
+#include "../../include/linux/hw_breakpoint.h"
+
+#include <sys/mman.h>
+
+static int vmlinux_matches_kallsyms_filter(struct map *map __maybe_unused,
+					   struct symbol *sym)
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
+
+#include "util/cpumap.h"
+#include "util/evsel.h"
+#include <sys/types.h>
+
+static int trace_event__id(const char *evname)
+{
+	char *filename;
+	int err = -1, fd;
+
+	if (asprintf(&filename,
+		     "%s/syscalls/%s/id",
+		     tracing_events_path, evname) < 0)
+		return -1;
+
+	fd = open(filename, O_RDONLY);
+	if (fd >= 0) {
+		char id[16];
+		if (read(fd, id, sizeof(id)) > 0)
+			err = atoi(id);
+		close(fd);
+	}
+
+	free(filename);
+	return err;
+}
+
+static int test__open_syscall_event(void)
+{
+	int err = -1, fd;
+	struct thread_map *threads;
+	struct perf_evsel *evsel;
+	struct perf_event_attr attr;
+	unsigned int nr_open_calls = 111, i;
+	int id = trace_event__id("sys_enter_open");
+
+	if (id < 0) {
+		pr_debug("is debugfs mounted on /sys/kernel/debug?\n");
+		return -1;
+	}
+
+	threads = thread_map__new(-1, getpid(), UINT_MAX);
+	if (threads == NULL) {
+		pr_debug("thread_map__new\n");
+		return -1;
+	}
+
+	memset(&attr, 0, sizeof(attr));
+	attr.type = PERF_TYPE_TRACEPOINT;
+	attr.config = id;
+	evsel = perf_evsel__new(&attr, 0);
+	if (evsel == NULL) {
+		pr_debug("perf_evsel__new\n");
+		goto out_thread_map_delete;
+	}
+
+	if (perf_evsel__open_per_thread(evsel, threads) < 0) {
+		pr_debug("failed to open counter: %s, "
+			 "tweak /proc/sys/kernel/perf_event_paranoid?\n",
+			 strerror(errno));
+		goto out_evsel_delete;
+	}
+
+	for (i = 0; i < nr_open_calls; ++i) {
+		fd = open("/etc/passwd", O_RDONLY);
+		close(fd);
+	}
+
+	if (perf_evsel__read_on_cpu(evsel, 0, 0) < 0) {
+		pr_debug("perf_evsel__read_on_cpu\n");
+		goto out_close_fd;
+	}
+
+	if (evsel->counts->cpu[0].val != nr_open_calls) {
+		pr_debug("perf_evsel__read_on_cpu: expected to intercept %d calls, got %" PRIu64 "\n",
+			 nr_open_calls, evsel->counts->cpu[0].val);
+		goto out_close_fd;
+	}
+
+	err = 0;
+out_close_fd:
+	perf_evsel__close_fd(evsel, 1, threads->nr);
+out_evsel_delete:
+	perf_evsel__delete(evsel);
+out_thread_map_delete:
+	thread_map__delete(threads);
+	return err;
+}
+
+#include <sched.h>
+
+static int test__open_syscall_event_on_all_cpus(void)
+{
+	int err = -1, fd, cpu;
+	struct thread_map *threads;
+	struct cpu_map *cpus;
+	struct perf_evsel *evsel;
+	struct perf_event_attr attr;
+	unsigned int nr_open_calls = 111, i;
+	cpu_set_t cpu_set;
+	int id = trace_event__id("sys_enter_open");
+
+	if (id < 0) {
+		pr_debug("is debugfs mounted on /sys/kernel/debug?\n");
+		return -1;
+	}
+
+	threads = thread_map__new(-1, getpid(), UINT_MAX);
+	if (threads == NULL) {
+		pr_debug("thread_map__new\n");
+		return -1;
+	}
+
+	cpus = cpu_map__new(NULL);
+	if (cpus == NULL) {
+		pr_debug("cpu_map__new\n");
+		goto out_thread_map_delete;
+	}
+
+
+	CPU_ZERO(&cpu_set);
+
+	memset(&attr, 0, sizeof(attr));
+	attr.type = PERF_TYPE_TRACEPOINT;
+	attr.config = id;
+	evsel = perf_evsel__new(&attr, 0);
+	if (evsel == NULL) {
+		pr_debug("perf_evsel__new\n");
+		goto out_thread_map_delete;
+	}
+
+	if (perf_evsel__open(evsel, cpus, threads) < 0) {
+		pr_debug("failed to open counter: %s, "
+			 "tweak /proc/sys/kernel/perf_event_paranoid?\n",
+			 strerror(errno));
+		goto out_evsel_delete;
+	}
+
+	for (cpu = 0; cpu < cpus->nr; ++cpu) {
+		unsigned int ncalls = nr_open_calls + cpu;
+		/*
+		 * XXX eventually lift this restriction in a way that
+		 * keeps perf building on older glibc installations
+		 * without CPU_ALLOC. 1024 cpus in 2010 still seems
+		 * a reasonable upper limit tho :-)
+		 */
+		if (cpus->map[cpu] >= CPU_SETSIZE) {
+			pr_debug("Ignoring CPU %d\n", cpus->map[cpu]);
+			continue;
+		}
+
+		CPU_SET(cpus->map[cpu], &cpu_set);
+		if (sched_setaffinity(0, sizeof(cpu_set), &cpu_set) < 0) {
+			pr_debug("sched_setaffinity() failed on CPU %d: %s ",
+				 cpus->map[cpu],
+				 strerror(errno));
+			goto out_close_fd;
+		}
+		for (i = 0; i < ncalls; ++i) {
+			fd = open("/etc/passwd", O_RDONLY);
+			close(fd);
+		}
+		CPU_CLR(cpus->map[cpu], &cpu_set);
+	}
+
+	/*
+	 * Here we need to explicitely preallocate the counts, as if
+	 * we use the auto allocation it will allocate just for 1 cpu,
+	 * as we start by cpu 0.
+	 */
+	if (perf_evsel__alloc_counts(evsel, cpus->nr) < 0) {
+		pr_debug("perf_evsel__alloc_counts(ncpus=%d)\n", cpus->nr);
+		goto out_close_fd;
+	}
+
+	err = 0;
+
+	for (cpu = 0; cpu < cpus->nr; ++cpu) {
+		unsigned int expected;
+
+		if (cpus->map[cpu] >= CPU_SETSIZE)
+			continue;
+
+		if (perf_evsel__read_on_cpu(evsel, cpu, 0) < 0) {
+			pr_debug("perf_evsel__read_on_cpu\n");
+			err = -1;
+			break;
+		}
+
+		expected = nr_open_calls + cpu;
+		if (evsel->counts->cpu[cpu].val != expected) {
+			pr_debug("perf_evsel__read_on_cpu: expected to intercept %d calls on cpu %d, got %" PRIu64 "\n",
+				 expected, cpus->map[cpu], evsel->counts->cpu[cpu].val);
+			err = -1;
+		}
+	}
+
+out_close_fd:
+	perf_evsel__close_fd(evsel, 1, threads->nr);
+out_evsel_delete:
+	perf_evsel__delete(evsel);
+out_thread_map_delete:
+	thread_map__delete(threads);
+	return err;
+}
+
+/*
+ * This test will generate random numbers of calls to some getpid syscalls,
+ * then establish an mmap for a group of events that are created to monitor
+ * the syscalls.
+ *
+ * It will receive the events, using mmap, use its PERF_SAMPLE_ID generated
+ * sample.id field to map back to its respective perf_evsel instance.
+ *
+ * Then it checks if the number of syscalls reported as perf events by
+ * the kernel corresponds to the number of syscalls made.
+ */
+static int test__basic_mmap(void)
+{
+	int err = -1;
+	union perf_event *event;
+	struct thread_map *threads;
+	struct cpu_map *cpus;
+	struct perf_evlist *evlist;
+	struct perf_event_attr attr = {
+		.type		= PERF_TYPE_TRACEPOINT,
+		.read_format	= PERF_FORMAT_ID,
+		.sample_type	= PERF_SAMPLE_ID,
+		.watermark	= 0,
+	};
+	cpu_set_t cpu_set;
+	const char *syscall_names[] = { "getsid", "getppid", "getpgrp",
+					"getpgid", };
+	pid_t (*syscalls[])(void) = { (void *)getsid, getppid, getpgrp,
+				      (void*)getpgid };
+#define nsyscalls ARRAY_SIZE(syscall_names)
+	int ids[nsyscalls];
+	unsigned int nr_events[nsyscalls],
+		     expected_nr_events[nsyscalls], i, j;
+	struct perf_evsel *evsels[nsyscalls], *evsel;
+
+	for (i = 0; i < nsyscalls; ++i) {
+		char name[64];
+
+		snprintf(name, sizeof(name), "sys_enter_%s", syscall_names[i]);
+		ids[i] = trace_event__id(name);
+		if (ids[i] < 0) {
+			pr_debug("Is debugfs mounted on /sys/kernel/debug?\n");
+			return -1;
+		}
+		nr_events[i] = 0;
+		expected_nr_events[i] = random() % 257;
+	}
+
+	threads = thread_map__new(-1, getpid(), UINT_MAX);
+	if (threads == NULL) {
+		pr_debug("thread_map__new\n");
+		return -1;
+	}
+
+	cpus = cpu_map__new(NULL);
+	if (cpus == NULL) {
+		pr_debug("cpu_map__new\n");
+		goto out_free_threads;
+	}
+
+	CPU_ZERO(&cpu_set);
+	CPU_SET(cpus->map[0], &cpu_set);
+	sched_setaffinity(0, sizeof(cpu_set), &cpu_set);
+	if (sched_setaffinity(0, sizeof(cpu_set), &cpu_set) < 0) {
+		pr_debug("sched_setaffinity() failed on CPU %d: %s ",
+			 cpus->map[0], strerror(errno));
+		goto out_free_cpus;
+	}
+
+	evlist = perf_evlist__new(cpus, threads);
+	if (evlist == NULL) {
+		pr_debug("perf_evlist__new\n");
+		goto out_free_cpus;
+	}
+
+	/* anonymous union fields, can't be initialized above */
+	attr.wakeup_events = 1;
+	attr.sample_period = 1;
+
+	for (i = 0; i < nsyscalls; ++i) {
+		attr.config = ids[i];
+		evsels[i] = perf_evsel__new(&attr, i);
+		if (evsels[i] == NULL) {
+			pr_debug("perf_evsel__new\n");
+			goto out_free_evlist;
+		}
+
+		perf_evlist__add(evlist, evsels[i]);
+
+		if (perf_evsel__open(evsels[i], cpus, threads) < 0) {
+			pr_debug("failed to open counter: %s, "
+				 "tweak /proc/sys/kernel/perf_event_paranoid?\n",
+				 strerror(errno));
+			goto out_close_fd;
+		}
+	}
+
+	if (perf_evlist__mmap(evlist, 128, true) < 0) {
+		pr_debug("failed to mmap events: %d (%s)\n", errno,
+			 strerror(errno));
+		goto out_close_fd;
+	}
+
+	for (i = 0; i < nsyscalls; ++i)
+		for (j = 0; j < expected_nr_events[i]; ++j) {
+			int foo = syscalls[i]();
+			++foo;
+		}
+
+	while ((event = perf_evlist__mmap_read(evlist, 0)) != NULL) {
+		struct perf_sample sample;
+
+		if (event->header.type != PERF_RECORD_SAMPLE) {
+			pr_debug("unexpected %s event\n",
+				 perf_event__name(event->header.type));
+			goto out_munmap;
+		}
+
+		err = perf_evlist__parse_sample(evlist, event, &sample);
+		if (err) {
+			pr_err("Can't parse sample, err = %d\n", err);
+			goto out_munmap;
+		}
+
+		evsel = perf_evlist__id2evsel(evlist, sample.id);
+		if (evsel == NULL) {
+			pr_debug("event with id %" PRIu64
+				 " doesn't map to an evsel\n", sample.id);
+			goto out_munmap;
+		}
+		nr_events[evsel->idx]++;
+	}
+
+	list_for_each_entry(evsel, &evlist->entries, node) {
+		if (nr_events[evsel->idx] != expected_nr_events[evsel->idx]) {
+			pr_debug("expected %d %s events, got %d\n",
+				 expected_nr_events[evsel->idx],
+				 perf_evsel__name(evsel), nr_events[evsel->idx]);
+			goto out_munmap;
+		}
+	}
+
+	err = 0;
+out_munmap:
+	perf_evlist__munmap(evlist);
+out_close_fd:
+	for (i = 0; i < nsyscalls; ++i)
+		perf_evsel__close_fd(evsels[i], 1, threads->nr);
+out_free_evlist:
+	perf_evlist__delete(evlist);
+out_free_cpus:
+	cpu_map__delete(cpus);
+out_free_threads:
+	thread_map__delete(threads);
+	return err;
+#undef nsyscalls
+}
+
+static int sched__get_first_possible_cpu(pid_t pid, cpu_set_t **maskp,
+					 size_t *sizep)
+{
+	cpu_set_t *mask;
+	size_t size;
+	int i, cpu = -1, nrcpus = 1024;
+realloc:
+	mask = CPU_ALLOC(nrcpus);
+	size = CPU_ALLOC_SIZE(nrcpus);
+	CPU_ZERO_S(size, mask);
+
+	if (sched_getaffinity(pid, size, mask) == -1) {
+		CPU_FREE(mask);
+		if (errno == EINVAL && nrcpus < (1024 << 8)) {
+			nrcpus = nrcpus << 2;
+			goto realloc;
+		}
+		perror("sched_getaffinity");
+			return -1;
+	}
+
+	for (i = 0; i < nrcpus; i++) {
+		if (CPU_ISSET_S(i, size, mask)) {
+			if (cpu == -1) {
+				cpu = i;
+				*maskp = mask;
+				*sizep = size;
+			} else
+				CPU_CLR_S(i, size, mask);
+		}
+	}
+
+	if (cpu == -1)
+		CPU_FREE(mask);
+
+	return cpu;
+}
+
+static int test__PERF_RECORD(void)
+{
+	struct perf_record_opts opts = {
+		.target = {
+			.uid = UINT_MAX,
+			.uses_mmap = true,
+		},
+		.no_delay   = true,
+		.freq	    = 10,
+		.mmap_pages = 256,
+	};
+	cpu_set_t *cpu_mask = NULL;
+	size_t cpu_mask_size = 0;
+	struct perf_evlist *evlist = perf_evlist__new(NULL, NULL);
+	struct perf_evsel *evsel;
+	struct perf_sample sample;
+	const char *cmd = "sleep";
+	const char *argv[] = { cmd, "1", NULL, };
+	char *bname;
+	u64 prev_time = 0;
+	bool found_cmd_mmap = false,
+	     found_libc_mmap = false,
+	     found_vdso_mmap = false,
+	     found_ld_mmap = false;
+	int err = -1, errs = 0, i, wakeups = 0;
+	u32 cpu;
+	int total_events = 0, nr_events[PERF_RECORD_MAX] = { 0, };
+
+	if (evlist == NULL || argv == NULL) {
+		pr_debug("Not enough memory to create evlist\n");
+		goto out;
+	}
+
+	/*
+	 * We need at least one evsel in the evlist, use the default
+	 * one: "cycles".
+	 */
+	err = perf_evlist__add_default(evlist);
+	if (err < 0) {
+		pr_debug("Not enough memory to create evsel\n");
+		goto out_delete_evlist;
+	}
+
+	/*
+	 * Create maps of threads and cpus to monitor. In this case
+	 * we start with all threads and cpus (-1, -1) but then in
+	 * perf_evlist__prepare_workload we'll fill in the only thread
+	 * we're monitoring, the one forked there.
+	 */
+	err = perf_evlist__create_maps(evlist, &opts.target);
+	if (err < 0) {
+		pr_debug("Not enough memory to create thread/cpu maps\n");
+		goto out_delete_evlist;
+	}
+
+	/*
+	 * Prepare the workload in argv[] to run, it'll fork it, and then wait
+	 * for perf_evlist__start_workload() to exec it. This is done this way
+	 * so that we have time to open the evlist (calling sys_perf_event_open
+	 * on all the fds) and then mmap them.
+	 */
+	err = perf_evlist__prepare_workload(evlist, &opts, argv);
+	if (err < 0) {
+		pr_debug("Couldn't run the workload!\n");
+		goto out_delete_evlist;
+	}
+
+	/*
+	 * Config the evsels, setting attr->comm on the first one, etc.
+	 */
+	evsel = perf_evlist__first(evlist);
+	evsel->attr.sample_type |= PERF_SAMPLE_CPU;
+	evsel->attr.sample_type |= PERF_SAMPLE_TID;
+	evsel->attr.sample_type |= PERF_SAMPLE_TIME;
+	perf_evlist__config_attrs(evlist, &opts);
+
+	err = sched__get_first_possible_cpu(evlist->workload.pid, &cpu_mask,
+					    &cpu_mask_size);
+	if (err < 0) {
+		pr_debug("sched__get_first_possible_cpu: %s\n", strerror(errno));
+		goto out_delete_evlist;
+	}
+
+	cpu = err;
+
+	/*
+	 * So that we can check perf_sample.cpu on all the samples.
+	 */
+	if (sched_setaffinity(evlist->workload.pid, cpu_mask_size, cpu_mask) < 0) {
+		pr_debug("sched_setaffinity: %s\n", strerror(errno));
+		goto out_free_cpu_mask;
+	}
+
+	/*
+	 * Call sys_perf_event_open on all the fds on all the evsels,
+	 * grouping them if asked to.
+	 */
+	err = perf_evlist__open(evlist);
+	if (err < 0) {
+		pr_debug("perf_evlist__open: %s\n", strerror(errno));
+		goto out_delete_evlist;
+	}
+
+	/*
+	 * mmap the first fd on a given CPU and ask for events for the other
+	 * fds in the same CPU to be injected in the same mmap ring buffer
+	 * (using ioctl(PERF_EVENT_IOC_SET_OUTPUT)).
+	 */
+	err = perf_evlist__mmap(evlist, opts.mmap_pages, false);
+	if (err < 0) {
+		pr_debug("perf_evlist__mmap: %s\n", strerror(errno));
+		goto out_delete_evlist;
+	}
+
+	/*
+	 * Now that all is properly set up, enable the events, they will
+	 * count just on workload.pid, which will start...
+	 */
+	perf_evlist__enable(evlist);
+
+	/*
+	 * Now!
+	 */
+	perf_evlist__start_workload(evlist);
+
+	while (1) {
+		int before = total_events;
+
+		for (i = 0; i < evlist->nr_mmaps; i++) {
+			union perf_event *event;
+
+			while ((event = perf_evlist__mmap_read(evlist, i)) != NULL) {
+				const u32 type = event->header.type;
+				const char *name = perf_event__name(type);
+
+				++total_events;
+				if (type < PERF_RECORD_MAX)
+					nr_events[type]++;
+
+				err = perf_evlist__parse_sample(evlist, event, &sample);
+				if (err < 0) {
+					if (verbose)
+						perf_event__fprintf(event, stderr);
+					pr_debug("Couldn't parse sample\n");
+					goto out_err;
+				}
+
+				if (verbose) {
+					pr_info("%" PRIu64" %d ", sample.time, sample.cpu);
+					perf_event__fprintf(event, stderr);
+				}
+
+				if (prev_time > sample.time) {
+					pr_debug("%s going backwards in time, prev=%" PRIu64 ", curr=%" PRIu64 "\n",
+						 name, prev_time, sample.time);
+					++errs;
+				}
+
+				prev_time = sample.time;
+
+				if (sample.cpu != cpu) {
+					pr_debug("%s with unexpected cpu, expected %d, got %d\n",
+						 name, cpu, sample.cpu);
+					++errs;
+				}
+
+				if ((pid_t)sample.pid != evlist->workload.pid) {
+					pr_debug("%s with unexpected pid, expected %d, got %d\n",
+						 name, evlist->workload.pid, sample.pid);
+					++errs;
+				}
+
+				if ((pid_t)sample.tid != evlist->workload.pid) {
+					pr_debug("%s with unexpected tid, expected %d, got %d\n",
+						 name, evlist->workload.pid, sample.tid);
+					++errs;
+				}
+
+				if ((type == PERF_RECORD_COMM ||
+				     type == PERF_RECORD_MMAP ||
+				     type == PERF_RECORD_FORK ||
+				     type == PERF_RECORD_EXIT) &&
+				     (pid_t)event->comm.pid != evlist->workload.pid) {
+					pr_debug("%s with unexpected pid/tid\n", name);
+					++errs;
+				}
+
+				if ((type == PERF_RECORD_COMM ||
+				     type == PERF_RECORD_MMAP) &&
+				     event->comm.pid != event->comm.tid) {
+					pr_debug("%s with different pid/tid!\n", name);
+					++errs;
+				}
+
+				switch (type) {
+				case PERF_RECORD_COMM:
+					if (strcmp(event->comm.comm, cmd)) {
+						pr_debug("%s with unexpected comm!\n", name);
+						++errs;
+					}
+					break;
+				case PERF_RECORD_EXIT:
+					goto found_exit;
+				case PERF_RECORD_MMAP:
+					bname = strrchr(event->mmap.filename, '/');
+					if (bname != NULL) {
+						if (!found_cmd_mmap)
+							found_cmd_mmap = !strcmp(bname + 1, cmd);
+						if (!found_libc_mmap)
+							found_libc_mmap = !strncmp(bname + 1, "libc", 4);
+						if (!found_ld_mmap)
+							found_ld_mmap = !strncmp(bname + 1, "ld", 2);
+					} else if (!found_vdso_mmap)
+						found_vdso_mmap = !strcmp(event->mmap.filename, "[vdso]");
+					break;
+
+				case PERF_RECORD_SAMPLE:
+					/* Just ignore samples for now */
+					break;
+				default:
+					pr_debug("Unexpected perf_event->header.type %d!\n",
+						 type);
+					++errs;
+				}
+			}
+		}
+
+		/*
+		 * We don't use poll here because at least at 3.1 times the
+		 * PERF_RECORD_{!SAMPLE} events don't honour
+		 * perf_event_attr.wakeup_events, just PERF_EVENT_SAMPLE does.
+		 */
+		if (total_events == before && false)
+			poll(evlist->pollfd, evlist->nr_fds, -1);
+
+		sleep(1);
+		if (++wakeups > 5) {
+			pr_debug("No PERF_RECORD_EXIT event!\n");
+			break;
+		}
+	}
+
+found_exit:
+	if (nr_events[PERF_RECORD_COMM] > 1) {
+		pr_debug("Excessive number of PERF_RECORD_COMM events!\n");
+		++errs;
+	}
+
+	if (nr_events[PERF_RECORD_COMM] == 0) {
+		pr_debug("Missing PERF_RECORD_COMM for %s!\n", cmd);
+		++errs;
+	}
+
+	if (!found_cmd_mmap) {
+		pr_debug("PERF_RECORD_MMAP for %s missing!\n", cmd);
+		++errs;
+	}
+
+	if (!found_libc_mmap) {
+		pr_debug("PERF_RECORD_MMAP for %s missing!\n", "libc");
+		++errs;
+	}
+
+	if (!found_ld_mmap) {
+		pr_debug("PERF_RECORD_MMAP for %s missing!\n", "ld");
+		++errs;
+	}
+
+	if (!found_vdso_mmap) {
+		pr_debug("PERF_RECORD_MMAP for %s missing!\n", "[vdso]");
+		++errs;
+	}
+out_err:
+	perf_evlist__munmap(evlist);
+out_free_cpu_mask:
+	CPU_FREE(cpu_mask);
+out_delete_evlist:
+	perf_evlist__delete(evlist);
+out:
+	return (err < 0 || errs > 0) ? -1 : 0;
+}
+
+
+#if defined(__x86_64__) || defined(__i386__)
+
+#define barrier() asm volatile("" ::: "memory")
+
+static u64 rdpmc(unsigned int counter)
+{
+	unsigned int low, high;
+
+	asm volatile("rdpmc" : "=a" (low), "=d" (high) : "c" (counter));
+
+	return low | ((u64)high) << 32;
+}
+
+static u64 rdtsc(void)
+{
+	unsigned int low, high;
+
+	asm volatile("rdtsc" : "=a" (low), "=d" (high));
+
+	return low | ((u64)high) << 32;
+}
+
+static u64 mmap_read_self(void *addr)
+{
+	struct perf_event_mmap_page *pc = addr;
+	u32 seq, idx, time_mult = 0, time_shift = 0;
+	u64 count, cyc = 0, time_offset = 0, enabled, running, delta;
+
+	do {
+		seq = pc->lock;
+		barrier();
+
+		enabled = pc->time_enabled;
+		running = pc->time_running;
+
+		if (enabled != running) {
+			cyc = rdtsc();
+			time_mult = pc->time_mult;
+			time_shift = pc->time_shift;
+			time_offset = pc->time_offset;
+		}
+
+		idx = pc->index;
+		count = pc->offset;
+		if (idx)
+			count += rdpmc(idx - 1);
+
+		barrier();
+	} while (pc->lock != seq);
+
+	if (enabled != running) {
+		u64 quot, rem;
+
+		quot = (cyc >> time_shift);
+		rem = cyc & ((1 << time_shift) - 1);
+		delta = time_offset + quot * time_mult +
+			((rem * time_mult) >> time_shift);
+
+		enabled += delta;
+		if (idx)
+			running += delta;
+
+		quot = count / running;
+		rem = count % running;
+		count = quot * enabled + (rem * enabled) / running;
+	}
+
+	return count;
+}
+
+/*
+ * If the RDPMC instruction faults then signal this back to the test parent task:
+ */
+static void segfault_handler(int sig __maybe_unused,
+			     siginfo_t *info __maybe_unused,
+			     void *uc __maybe_unused)
+{
+	exit(-1);
+}
+
+static int __test__rdpmc(void)
+{
+	volatile int tmp = 0;
+	u64 i, loops = 1000;
+	int n;
+	int fd;
+	void *addr;
+	struct perf_event_attr attr = {
+		.type = PERF_TYPE_HARDWARE,
+		.config = PERF_COUNT_HW_INSTRUCTIONS,
+		.exclude_kernel = 1,
+	};
+	u64 delta_sum = 0;
+        struct sigaction sa;
+
+	sigfillset(&sa.sa_mask);
+	sa.sa_sigaction = segfault_handler;
+	sigaction(SIGSEGV, &sa, NULL);
+
+	fd = sys_perf_event_open(&attr, 0, -1, -1, 0);
+	if (fd < 0) {
+		pr_err("Error: sys_perf_event_open() syscall returned "
+		       "with %d (%s)\n", fd, strerror(errno));
+		return -1;
+	}
+
+	addr = mmap(NULL, page_size, PROT_READ, MAP_SHARED, fd, 0);
+	if (addr == (void *)(-1)) {
+		pr_err("Error: mmap() syscall returned with (%s)\n",
+		       strerror(errno));
+		goto out_close;
+	}
+
+	for (n = 0; n < 6; n++) {
+		u64 stamp, now, delta;
+
+		stamp = mmap_read_self(addr);
+
+		for (i = 0; i < loops; i++)
+			tmp++;
+
+		now = mmap_read_self(addr);
+		loops *= 10;
+
+		delta = now - stamp;
+		pr_debug("%14d: %14Lu\n", n, (long long)delta);
+
+		delta_sum += delta;
+	}
+
+	munmap(addr, page_size);
+	pr_debug("   ");
+out_close:
+	close(fd);
+
+	if (!delta_sum)
+		return -1;
+
+	return 0;
+}
+
+static int test__rdpmc(void)
+{
+	int status = 0;
+	int wret = 0;
+	int ret;
+	int pid;
+
+	pid = fork();
+	if (pid < 0)
+		return -1;
+
+	if (!pid) {
+		ret = __test__rdpmc();
+
+		exit(ret);
+	}
+
+	wret = waitpid(pid, &status, 0);
+	if (wret < 0 || status)
+		return -1;
+
+	return 0;
+}
+
+#endif
+
+static int test__perf_pmu(void)
+{
+	return perf_pmu__test();
+}
+
+static int perf_evsel__roundtrip_cache_name_test(void)
+{
+	char name[128];
+	int type, op, err = 0, ret = 0, i, idx;
+	struct perf_evsel *evsel;
+        struct perf_evlist *evlist = perf_evlist__new(NULL, NULL);
+
+        if (evlist == NULL)
+                return -ENOMEM;
+
+	for (type = 0; type < PERF_COUNT_HW_CACHE_MAX; type++) {
+		for (op = 0; op < PERF_COUNT_HW_CACHE_OP_MAX; op++) {
+			/* skip invalid cache type */
+			if (!perf_evsel__is_cache_op_valid(type, op))
+				continue;
+
+			for (i = 0; i < PERF_COUNT_HW_CACHE_RESULT_MAX; i++) {
+				__perf_evsel__hw_cache_type_op_res_name(type, op, i,
+									name, sizeof(name));
+				err = parse_events(evlist, name, 0);
+				if (err)
+					ret = err;
+			}
+		}
+	}
+
+	idx = 0;
+	evsel = perf_evlist__first(evlist);
+
+	for (type = 0; type < PERF_COUNT_HW_CACHE_MAX; type++) {
+		for (op = 0; op < PERF_COUNT_HW_CACHE_OP_MAX; op++) {
+			/* skip invalid cache type */
+			if (!perf_evsel__is_cache_op_valid(type, op))
+				continue;
+
+			for (i = 0; i < PERF_COUNT_HW_CACHE_RESULT_MAX; i++) {
+				__perf_evsel__hw_cache_type_op_res_name(type, op, i,
+									name, sizeof(name));
+				if (evsel->idx != idx)
+					continue;
+
+				++idx;
+
+				if (strcmp(perf_evsel__name(evsel), name)) {
+					pr_debug("%s != %s\n", perf_evsel__name(evsel), name);
+					ret = -1;
+				}
+
+				evsel = perf_evsel__next(evsel);
+			}
+		}
+	}
+
+	perf_evlist__delete(evlist);
+	return ret;
+}
+
+static int __perf_evsel__name_array_test(const char *names[], int nr_names)
+{
+	int i, err;
+	struct perf_evsel *evsel;
+        struct perf_evlist *evlist = perf_evlist__new(NULL, NULL);
+
+        if (evlist == NULL)
+                return -ENOMEM;
+
+	for (i = 0; i < nr_names; ++i) {
+		err = parse_events(evlist, names[i], 0);
+		if (err) {
+			pr_debug("failed to parse event '%s', err %d\n",
+				 names[i], err);
+			goto out_delete_evlist;
+		}
+	}
+
+	err = 0;
+	list_for_each_entry(evsel, &evlist->entries, node) {
+		if (strcmp(perf_evsel__name(evsel), names[evsel->idx])) {
+			--err;
+			pr_debug("%s != %s\n", perf_evsel__name(evsel), names[evsel->idx]);
+		}
+	}
+
+out_delete_evlist:
+	perf_evlist__delete(evlist);
+	return err;
+}
+
+#define perf_evsel__name_array_test(names) \
+	__perf_evsel__name_array_test(names, ARRAY_SIZE(names))
+
+static int perf_evsel__roundtrip_name_test(void)
+{
+	int err = 0, ret = 0;
+
+	err = perf_evsel__name_array_test(perf_evsel__hw_names);
+	if (err)
+		ret = err;
+
+	err = perf_evsel__name_array_test(perf_evsel__sw_names);
+	if (err)
+		ret = err;
+
+	err = perf_evsel__roundtrip_cache_name_test();
+	if (err)
+		ret = err;
+
+	return ret;
+}
+
+static int perf_evsel__test_field(struct perf_evsel *evsel, const char *name,
+				  int size, bool should_be_signed)
+{
+	struct format_field *field = perf_evsel__field(evsel, name);
+	int is_signed;
+	int ret = 0;
+
+	if (field == NULL) {
+		pr_debug("%s: \"%s\" field not found!\n", evsel->name, name);
+		return -1;
+	}
+
+	is_signed = !!(field->flags | FIELD_IS_SIGNED);
+	if (should_be_signed && !is_signed) {
+		pr_debug("%s: \"%s\" signedness(%d) is wrong, should be %d\n",
+			 evsel->name, name, is_signed, should_be_signed);
+		ret = -1;
+	}
+
+	if (field->size != size) {
+		pr_debug("%s: \"%s\" size (%d) should be %d!\n",
+			 evsel->name, name, field->size, size);
+		ret = -1;
+	}
+
+	return ret;
+}
+
+static int perf_evsel__tp_sched_test(void)
+{
+	struct perf_evsel *evsel = perf_evsel__newtp("sched", "sched_switch", 0);
+	int ret = 0;
+
+	if (evsel == NULL) {
+		pr_debug("perf_evsel__new\n");
+		return -1;
+	}
+
+	if (perf_evsel__test_field(evsel, "prev_comm", 16, true))
+		ret = -1;
+
+	if (perf_evsel__test_field(evsel, "prev_pid", 4, true))
+		ret = -1;
+
+	if (perf_evsel__test_field(evsel, "prev_prio", 4, true))
+		ret = -1;
+
+	if (perf_evsel__test_field(evsel, "prev_state", 8, true))
+		ret = -1;
+
+	if (perf_evsel__test_field(evsel, "next_comm", 16, true))
+		ret = -1;
+
+	if (perf_evsel__test_field(evsel, "next_pid", 4, true))
+		ret = -1;
+
+	if (perf_evsel__test_field(evsel, "next_prio", 4, true))
+		ret = -1;
+
+	perf_evsel__delete(evsel);
+
+	evsel = perf_evsel__newtp("sched", "sched_wakeup", 0);
+
+	if (perf_evsel__test_field(evsel, "comm", 16, true))
+		ret = -1;
+
+	if (perf_evsel__test_field(evsel, "pid", 4, true))
+		ret = -1;
+
+	if (perf_evsel__test_field(evsel, "prio", 4, true))
+		ret = -1;
+
+	if (perf_evsel__test_field(evsel, "success", 4, true))
+		ret = -1;
+
+	if (perf_evsel__test_field(evsel, "target_cpu", 4, true))
+		ret = -1;
+
+	return ret;
+}
+
+static int test__syscall_open_tp_fields(void)
+{
+	struct perf_record_opts opts = {
+		.target = {
+			.uid = UINT_MAX,
+			.uses_mmap = true,
+		},
+		.no_delay   = true,
+		.freq	    = 1,
+		.mmap_pages = 256,
+		.raw_samples = true,
+	};
+	const char *filename = "/etc/passwd";
+	int flags = O_RDONLY | O_DIRECTORY;
+	struct perf_evlist *evlist = perf_evlist__new(NULL, NULL);
+	struct perf_evsel *evsel;
+	int err = -1, i, nr_events = 0, nr_polls = 0;
+
+	if (evlist == NULL) {
+		pr_debug("%s: perf_evlist__new\n", __func__);
+		goto out;
+	}
+
+	evsel = perf_evsel__newtp("syscalls", "sys_enter_open", 0);
+	if (evsel == NULL) {
+		pr_debug("%s: perf_evsel__newtp\n", __func__);
+		goto out_delete_evlist;
+	}
+
+	perf_evlist__add(evlist, evsel);
+
+	err = perf_evlist__create_maps(evlist, &opts.target);
+	if (err < 0) {
+		pr_debug("%s: perf_evlist__create_maps\n", __func__);
+		goto out_delete_evlist;
+	}
+
+	perf_evsel__config(evsel, &opts, evsel);
+
+	evlist->threads->map[0] = getpid();
+
+	err = perf_evlist__open(evlist);
+	if (err < 0) {
+		pr_debug("perf_evlist__open: %s\n", strerror(errno));
+		goto out_delete_evlist;
+	}
+
+	err = perf_evlist__mmap(evlist, UINT_MAX, false);
+	if (err < 0) {
+		pr_debug("perf_evlist__mmap: %s\n", strerror(errno));
+		goto out_delete_evlist;
+	}
+
+	perf_evlist__enable(evlist);
+
+	/*
+	 * Generate the event:
+	 */
+	open(filename, flags);
+
+	while (1) {
+		int before = nr_events;
+
+		for (i = 0; i < evlist->nr_mmaps; i++) {
+			union perf_event *event;
+
+			while ((event = perf_evlist__mmap_read(evlist, i)) != NULL) {
+				const u32 type = event->header.type;
+				int tp_flags;
+				struct perf_sample sample;
+
+				++nr_events;
+
+				if (type != PERF_RECORD_SAMPLE)
+					continue;
+
+				err = perf_evsel__parse_sample(evsel, event, &sample);
+				if (err) {
+					pr_err("Can't parse sample, err = %d\n", err);
+					goto out_munmap;
+				}
+
+				tp_flags = perf_evsel__intval(evsel, &sample, "flags");
+
+				if (flags != tp_flags) {
+					pr_debug("%s: Expected flags=%#x, got %#x\n",
+						 __func__, flags, tp_flags);
+					goto out_munmap;
+				}
+
+				goto out_ok;
+			}
+		}
+
+		if (nr_events == before)
+			poll(evlist->pollfd, evlist->nr_fds, 10);
+
+		if (++nr_polls > 5) {
+			pr_debug("%s: no events!\n", __func__);
+			goto out_munmap;
+		}
+	}
+out_ok:
+	err = 0;
+out_munmap:
+	perf_evlist__munmap(evlist);
+out_delete_evlist:
+	perf_evlist__delete(evlist);
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
+		.desc = "detect open syscall event",
+		.func = test__open_syscall_event,
+	},
+	{
+		.desc = "detect open syscall event on all cpus",
+		.func = test__open_syscall_event_on_all_cpus,
+	},
+	{
+		.desc = "read samples using the mmap interface",
+		.func = test__basic_mmap,
+	},
+	{
+		.desc = "parse events tests",
+		.func = parse_events__test,
+	},
+#if defined(__x86_64__) || defined(__i386__)
+	{
+		.desc = "x86 rdpmc test",
+		.func = test__rdpmc,
+	},
+#endif
+	{
+		.desc = "Validate PERF_RECORD_* events & perf_sample fields",
+		.func = test__PERF_RECORD,
+	},
+	{
+		.desc = "Test perf pmu format parsing",
+		.func = test__perf_pmu,
+	},
+	{
+		.desc = "Test dso data interface",
+		.func = dso__test_data,
+	},
+	{
+		.desc = "roundtrip evsel->name check",
+		.func = perf_evsel__roundtrip_name_test,
+	},
+	{
+		.desc = "Check parsing of sched tracepoints fields",
+		.func = perf_evsel__tp_sched_test,
+	},
+	{
+		.desc = "Generate and check syscalls:sys_enter_open event fields",
+		.func = test__syscall_open_tp_fields,
+	},
+	{
+		.func = NULL,
+	},
+};
+
+static bool perf_test__matches(int curr, int argc, const char *argv[])
+{
+	int i;
+
+	if (argc == 0)
+		return true;
+
+	for (i = 0; i < argc; ++i) {
+		char *end;
+		long nr = strtoul(argv[i], &end, 10);
+
+		if (*end == '\0') {
+			if (nr == curr + 1)
+				return true;
+			continue;
+		}
+
+		if (strstr(tests[curr].desc, argv[i]))
+			return true;
+	}
+
+	return false;
+}
+
+static int __cmd_test(int argc, const char *argv[])
+{
+	int i = 0;
+	int width = 0;
+
+	while (tests[i].func) {
+		int len = strlen(tests[i].desc);
+
+		if (width < len)
+			width = len;
+		++i;
+	}
+
+	i = 0;
+	while (tests[i].func) {
+		int curr = i++, err;
+
+		if (!perf_test__matches(curr, argc, argv))
+			continue;
+
+		pr_info("%2d: %-*s:", i, width, tests[curr].desc);
+		pr_debug("\n--- start ---\n");
+		err = tests[curr].func();
+		pr_debug("---- end ----\n%s:", tests[curr].desc);
+		if (err)
+			color_fprintf(stderr, PERF_COLOR_RED, " FAILED!\n");
+		else
+			pr_info(" Ok\n");
+	}
+
+	return 0;
+}
+
+static int perf_test__list(int argc, const char **argv)
+{
+	int i = 0;
+
+	while (tests[i].func) {
+		int curr = i++;
+
+		if (argc > 1 && !strstr(tests[curr].desc, argv[1]))
+			continue;
+
+		pr_info("%2d: %s\n", i, tests[curr].desc);
+	}
+
+	return 0;
+}
+
+int cmd_test(int argc, const char **argv, const char *prefix __maybe_unused)
+{
+	const char * const test_usage[] = {
+	"perf test [<options>] [{list <test-name-fragment>|[<test-name-fragments>|<test-numbers>]}]",
+	NULL,
+	};
+	const struct option test_options[] = {
+	OPT_INCR('v', "verbose", &verbose,
+		    "be more verbose (show symbol address, etc)"),
+	OPT_END()
+	};
+
+	argc = parse_options(argc, argv, test_options, test_usage, 0);
+	if (argc >= 1 && !strcmp(argv[0], "list"))
+		return perf_test__list(argc, argv);
+
+	symbol_conf.priv_size = sizeof(int);
+	symbol_conf.sort_by_name = true;
+	symbol_conf.try_vmlinux_path = true;
+
+	if (symbol__init() < 0)
+		return -1;
+
+	return __cmd_test(argc, argv);
+}
diff --git a/tools/perf/tests/dso-data.c b/tools/perf/tests/dso-data.c
new file mode 100644
index 0000000..c6caede
--- /dev/null
+++ b/tools/perf/tests/dso-data.c
@@ -0,0 +1,153 @@
+#include "util.h"
+
+#include <stdlib.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <string.h>
+
+#include "symbol.h"
+
+#define TEST_ASSERT_VAL(text, cond) \
+do { \
+	if (!(cond)) { \
+		pr_debug("FAILED %s:%d %s\n", __FILE__, __LINE__, text); \
+		return -1; \
+	} \
+} while (0)
+
+static char *test_file(int size)
+{
+	static char buf_templ[] = "/tmp/test-XXXXXX";
+	char *templ = buf_templ;
+	int fd, i;
+	unsigned char *buf;
+
+	fd = mkstemp(templ);
+
+	buf = malloc(size);
+	if (!buf) {
+		close(fd);
+		return NULL;
+	}
+
+	for (i = 0; i < size; i++)
+		buf[i] = (unsigned char) ((int) i % 10);
+
+	if (size != write(fd, buf, size))
+		templ = NULL;
+
+	close(fd);
+	return templ;
+}
+
+#define TEST_FILE_SIZE (DSO__DATA_CACHE_SIZE * 20)
+
+struct test_data_offset {
+	off_t offset;
+	u8 data[10];
+	int size;
+};
+
+struct test_data_offset offsets[] = {
+	/* Fill first cache page. */
+	{
+		.offset = 10,
+		.data   = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 },
+		.size   = 10,
+	},
+	/* Read first cache page. */
+	{
+		.offset = 10,
+		.data   = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 },
+		.size   = 10,
+	},
+	/* Fill cache boundary pages. */
+	{
+		.offset = DSO__DATA_CACHE_SIZE - DSO__DATA_CACHE_SIZE % 10,
+		.data   = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 },
+		.size   = 10,
+	},
+	/* Read cache boundary pages. */
+	{
+		.offset = DSO__DATA_CACHE_SIZE - DSO__DATA_CACHE_SIZE % 10,
+		.data   = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 },
+		.size   = 10,
+	},
+	/* Fill final cache page. */
+	{
+		.offset = TEST_FILE_SIZE - 10,
+		.data   = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 },
+		.size   = 10,
+	},
+	/* Read final cache page. */
+	{
+		.offset = TEST_FILE_SIZE - 10,
+		.data   = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 },
+		.size   = 10,
+	},
+	/* Read final cache page. */
+	{
+		.offset = TEST_FILE_SIZE - 3,
+		.data   = { 7, 8, 9, 0, 0, 0, 0, 0, 0, 0 },
+		.size   = 3,
+	},
+};
+
+int dso__test_data(void)
+{
+	struct machine machine;
+	struct dso *dso;
+	char *file = test_file(TEST_FILE_SIZE);
+	size_t i;
+
+	TEST_ASSERT_VAL("No test file", file);
+
+	memset(&machine, 0, sizeof(machine));
+
+	dso = dso__new((const char *)file);
+
+	/* Basic 10 bytes tests. */
+	for (i = 0; i < ARRAY_SIZE(offsets); i++) {
+		struct test_data_offset *data = &offsets[i];
+		ssize_t size;
+		u8 buf[10];
+
+		memset(buf, 0, 10);
+		size = dso__data_read_offset(dso, &machine, data->offset,
+				     buf, 10);
+
+		TEST_ASSERT_VAL("Wrong size", size == data->size);
+		TEST_ASSERT_VAL("Wrong data", !memcmp(buf, data->data, 10));
+	}
+
+	/* Read cross multiple cache pages. */
+	{
+		ssize_t size;
+		int c;
+		u8 *buf;
+
+		buf = malloc(TEST_FILE_SIZE);
+		TEST_ASSERT_VAL("ENOMEM\n", buf);
+
+		/* First iteration to fill caches, second one to read them. */
+		for (c = 0; c < 2; c++) {
+			memset(buf, 0, TEST_FILE_SIZE);
+			size = dso__data_read_offset(dso, &machine, 10,
+						     buf, TEST_FILE_SIZE);
+
+			TEST_ASSERT_VAL("Wrong size",
+				size == (TEST_FILE_SIZE - 10));
+
+			for (i = 0; i < (size_t)size; i++)
+				TEST_ASSERT_VAL("Wrong data",
+					buf[i] == (i % 10));
+		}
+
+		free(buf);
+	}
+
+	dso__delete(dso);
+	unlink(file);
+	return 0;
+}
diff --git a/tools/perf/tests/parse-events.c b/tools/perf/tests/parse-events.c
new file mode 100644
index 0000000..b49c2ee
--- /dev/null
+++ b/tools/perf/tests/parse-events.c
@@ -0,0 +1,1116 @@
+
+#include "parse-events.h"
+#include "evsel.h"
+#include "evlist.h"
+#include "sysfs.h"
+#include "../../../include/linux/hw_breakpoint.h"
+
+#define TEST_ASSERT_VAL(text, cond) \
+do { \
+	if (!(cond)) { \
+		pr_debug("FAILED %s:%d %s\n", __FILE__, __LINE__, text); \
+		return -1; \
+	} \
+} while (0)
+
+#define PERF_TP_SAMPLE_TYPE (PERF_SAMPLE_RAW | PERF_SAMPLE_TIME | \
+			     PERF_SAMPLE_CPU | PERF_SAMPLE_PERIOD)
+
+static int test__checkevent_tracepoint(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = perf_evlist__first(evlist);
+
+	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_TRACEPOINT == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong sample_type",
+		PERF_TP_SAMPLE_TYPE == evsel->attr.sample_type);
+	TEST_ASSERT_VAL("wrong sample_period", 1 == evsel->attr.sample_period);
+	return 0;
+}
+
+static int test__checkevent_tracepoint_multi(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel;
+
+	TEST_ASSERT_VAL("wrong number of entries", evlist->nr_entries > 1);
+
+	list_for_each_entry(evsel, &evlist->entries, node) {
+		TEST_ASSERT_VAL("wrong type",
+			PERF_TYPE_TRACEPOINT == evsel->attr.type);
+		TEST_ASSERT_VAL("wrong sample_type",
+			PERF_TP_SAMPLE_TYPE == evsel->attr.sample_type);
+		TEST_ASSERT_VAL("wrong sample_period",
+			1 == evsel->attr.sample_period);
+	}
+	return 0;
+}
+
+static int test__checkevent_raw(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = perf_evlist__first(evlist);
+
+	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_RAW == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config", 0x1a == evsel->attr.config);
+	return 0;
+}
+
+static int test__checkevent_numeric(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = perf_evlist__first(evlist);
+
+	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong type", 1 == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config", 1 == evsel->attr.config);
+	return 0;
+}
+
+static int test__checkevent_symbolic_name(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = perf_evlist__first(evlist);
+
+	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config",
+			PERF_COUNT_HW_INSTRUCTIONS == evsel->attr.config);
+	return 0;
+}
+
+static int test__checkevent_symbolic_name_config(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = perf_evlist__first(evlist);
+
+	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config",
+			PERF_COUNT_HW_CPU_CYCLES == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong period",
+			100000 == evsel->attr.sample_period);
+	TEST_ASSERT_VAL("wrong config1",
+			0 == evsel->attr.config1);
+	TEST_ASSERT_VAL("wrong config2",
+			1 == evsel->attr.config2);
+	return 0;
+}
+
+static int test__checkevent_symbolic_alias(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = perf_evlist__first(evlist);
+
+	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_SOFTWARE == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config",
+			PERF_COUNT_SW_PAGE_FAULTS == evsel->attr.config);
+	return 0;
+}
+
+static int test__checkevent_genhw(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = perf_evlist__first(evlist);
+
+	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HW_CACHE == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config", (1 << 16) == evsel->attr.config);
+	return 0;
+}
+
+static int test__checkevent_breakpoint(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = perf_evlist__first(evlist);
+
+	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_BREAKPOINT == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config", 0 == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong bp_type", (HW_BREAKPOINT_R | HW_BREAKPOINT_W) ==
+					 evsel->attr.bp_type);
+	TEST_ASSERT_VAL("wrong bp_len", HW_BREAKPOINT_LEN_4 ==
+					evsel->attr.bp_len);
+	return 0;
+}
+
+static int test__checkevent_breakpoint_x(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = perf_evlist__first(evlist);
+
+	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_BREAKPOINT == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config", 0 == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong bp_type",
+			HW_BREAKPOINT_X == evsel->attr.bp_type);
+	TEST_ASSERT_VAL("wrong bp_len", sizeof(long) == evsel->attr.bp_len);
+	return 0;
+}
+
+static int test__checkevent_breakpoint_r(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = perf_evlist__first(evlist);
+
+	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong type",
+			PERF_TYPE_BREAKPOINT == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config", 0 == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong bp_type",
+			HW_BREAKPOINT_R == evsel->attr.bp_type);
+	TEST_ASSERT_VAL("wrong bp_len",
+			HW_BREAKPOINT_LEN_4 == evsel->attr.bp_len);
+	return 0;
+}
+
+static int test__checkevent_breakpoint_w(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = perf_evlist__first(evlist);
+
+	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong type",
+			PERF_TYPE_BREAKPOINT == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config", 0 == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong bp_type",
+			HW_BREAKPOINT_W == evsel->attr.bp_type);
+	TEST_ASSERT_VAL("wrong bp_len",
+			HW_BREAKPOINT_LEN_4 == evsel->attr.bp_len);
+	return 0;
+}
+
+static int test__checkevent_breakpoint_rw(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = perf_evlist__first(evlist);
+
+	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong type",
+			PERF_TYPE_BREAKPOINT == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config", 0 == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong bp_type",
+		(HW_BREAKPOINT_R|HW_BREAKPOINT_W) == evsel->attr.bp_type);
+	TEST_ASSERT_VAL("wrong bp_len",
+			HW_BREAKPOINT_LEN_4 == evsel->attr.bp_len);
+	return 0;
+}
+
+static int test__checkevent_tracepoint_modifier(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = perf_evlist__first(evlist);
+
+	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+
+	return test__checkevent_tracepoint(evlist);
+}
+
+static int
+test__checkevent_tracepoint_multi_modifier(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel;
+
+	TEST_ASSERT_VAL("wrong number of entries", evlist->nr_entries > 1);
+
+	list_for_each_entry(evsel, &evlist->entries, node) {
+		TEST_ASSERT_VAL("wrong exclude_user",
+				!evsel->attr.exclude_user);
+		TEST_ASSERT_VAL("wrong exclude_kernel",
+				evsel->attr.exclude_kernel);
+		TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
+		TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+	}
+
+	return test__checkevent_tracepoint_multi(evlist);
+}
+
+static int test__checkevent_raw_modifier(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = perf_evlist__first(evlist);
+
+	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip);
+
+	return test__checkevent_raw(evlist);
+}
+
+static int test__checkevent_numeric_modifier(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = perf_evlist__first(evlist);
+
+	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip);
+
+	return test__checkevent_numeric(evlist);
+}
+
+static int test__checkevent_symbolic_name_modifier(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = perf_evlist__first(evlist);
+
+	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+
+	return test__checkevent_symbolic_name(evlist);
+}
+
+static int test__checkevent_exclude_host_modifier(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = perf_evlist__first(evlist);
+
+	TEST_ASSERT_VAL("wrong exclude guest", !evsel->attr.exclude_guest);
+	TEST_ASSERT_VAL("wrong exclude host", evsel->attr.exclude_host);
+
+	return test__checkevent_symbolic_name(evlist);
+}
+
+static int test__checkevent_exclude_guest_modifier(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = perf_evlist__first(evlist);
+
+	TEST_ASSERT_VAL("wrong exclude guest", evsel->attr.exclude_guest);
+	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
+
+	return test__checkevent_symbolic_name(evlist);
+}
+
+static int test__checkevent_symbolic_alias_modifier(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = perf_evlist__first(evlist);
+
+	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+
+	return test__checkevent_symbolic_alias(evlist);
+}
+
+static int test__checkevent_genhw_modifier(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = perf_evlist__first(evlist);
+
+	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip);
+
+	return test__checkevent_genhw(evlist);
+}
+
+static int test__checkevent_breakpoint_modifier(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = perf_evlist__first(evlist);
+
+
+	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+	TEST_ASSERT_VAL("wrong name",
+			!strcmp(perf_evsel__name(evsel), "mem:0:u"));
+
+	return test__checkevent_breakpoint(evlist);
+}
+
+static int test__checkevent_breakpoint_x_modifier(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = perf_evlist__first(evlist);
+
+	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+	TEST_ASSERT_VAL("wrong name",
+			!strcmp(perf_evsel__name(evsel), "mem:0:x:k"));
+
+	return test__checkevent_breakpoint_x(evlist);
+}
+
+static int test__checkevent_breakpoint_r_modifier(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = perf_evlist__first(evlist);
+
+	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip);
+	TEST_ASSERT_VAL("wrong name",
+			!strcmp(perf_evsel__name(evsel), "mem:0:r:hp"));
+
+	return test__checkevent_breakpoint_r(evlist);
+}
+
+static int test__checkevent_breakpoint_w_modifier(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = perf_evlist__first(evlist);
+
+	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip);
+	TEST_ASSERT_VAL("wrong name",
+			!strcmp(perf_evsel__name(evsel), "mem:0:w:up"));
+
+	return test__checkevent_breakpoint_w(evlist);
+}
+
+static int test__checkevent_breakpoint_rw_modifier(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = perf_evlist__first(evlist);
+
+	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip);
+	TEST_ASSERT_VAL("wrong name",
+			!strcmp(perf_evsel__name(evsel), "mem:0:rw:kp"));
+
+	return test__checkevent_breakpoint_rw(evlist);
+}
+
+static int test__checkevent_pmu(struct perf_evlist *evlist)
+{
+
+	struct perf_evsel *evsel = perf_evlist__first(evlist);
+
+	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_RAW == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config",    10 == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong config1",    1 == evsel->attr.config1);
+	TEST_ASSERT_VAL("wrong config2",    3 == evsel->attr.config2);
+	TEST_ASSERT_VAL("wrong period",  1000 == evsel->attr.sample_period);
+
+	return 0;
+}
+
+static int test__checkevent_list(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = perf_evlist__first(evlist);
+
+	TEST_ASSERT_VAL("wrong number of entries", 3 == evlist->nr_entries);
+
+	/* r1 */
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_RAW == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config", 1 == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong config1", 0 == evsel->attr.config1);
+	TEST_ASSERT_VAL("wrong config2", 0 == evsel->attr.config2);
+	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+
+	/* syscalls:sys_enter_open:k */
+	evsel = perf_evsel__next(evsel);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_TRACEPOINT == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong sample_type",
+		PERF_TP_SAMPLE_TYPE == evsel->attr.sample_type);
+	TEST_ASSERT_VAL("wrong sample_period", 1 == evsel->attr.sample_period);
+	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+
+	/* 1:1:hp */
+	evsel = perf_evsel__next(evsel);
+	TEST_ASSERT_VAL("wrong type", 1 == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config", 1 == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip);
+
+	return 0;
+}
+
+static int test__checkevent_pmu_name(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = perf_evlist__first(evlist);
+
+	/* cpu/config=1,name=krava/u */
+	TEST_ASSERT_VAL("wrong number of entries", 2 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_RAW == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config",  1 == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong name", !strcmp(perf_evsel__name(evsel), "krava"));
+
+	/* cpu/config=2/u" */
+	evsel = perf_evsel__next(evsel);
+	TEST_ASSERT_VAL("wrong number of entries", 2 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_RAW == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config",  2 == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong name",
+			!strcmp(perf_evsel__name(evsel), "cpu/config=2/u"));
+
+	return 0;
+}
+
+static int test__checkevent_pmu_events(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel;
+
+	evsel = list_entry(evlist->entries.next, struct perf_evsel, node);
+	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_RAW == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong exclude_user",
+			!evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel",
+			evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+
+	return 0;
+}
+
+static int test__checkterms_simple(struct list_head *terms)
+{
+	struct parse_events__term *term;
+
+	/* config=10 */
+	term = list_entry(terms->next, struct parse_events__term, list);
+	TEST_ASSERT_VAL("wrong type term",
+			term->type_term == PARSE_EVENTS__TERM_TYPE_CONFIG);
+	TEST_ASSERT_VAL("wrong type val",
+			term->type_val == PARSE_EVENTS__TERM_TYPE_NUM);
+	TEST_ASSERT_VAL("wrong val", term->val.num == 10);
+	TEST_ASSERT_VAL("wrong config", !term->config);
+
+	/* config1 */
+	term = list_entry(term->list.next, struct parse_events__term, list);
+	TEST_ASSERT_VAL("wrong type term",
+			term->type_term == PARSE_EVENTS__TERM_TYPE_CONFIG1);
+	TEST_ASSERT_VAL("wrong type val",
+			term->type_val == PARSE_EVENTS__TERM_TYPE_NUM);
+	TEST_ASSERT_VAL("wrong val", term->val.num == 1);
+	TEST_ASSERT_VAL("wrong config", !term->config);
+
+	/* config2=3 */
+	term = list_entry(term->list.next, struct parse_events__term, list);
+	TEST_ASSERT_VAL("wrong type term",
+			term->type_term == PARSE_EVENTS__TERM_TYPE_CONFIG2);
+	TEST_ASSERT_VAL("wrong type val",
+			term->type_val == PARSE_EVENTS__TERM_TYPE_NUM);
+	TEST_ASSERT_VAL("wrong val", term->val.num == 3);
+	TEST_ASSERT_VAL("wrong config", !term->config);
+
+	/* umask=1*/
+	term = list_entry(term->list.next, struct parse_events__term, list);
+	TEST_ASSERT_VAL("wrong type term",
+			term->type_term == PARSE_EVENTS__TERM_TYPE_USER);
+	TEST_ASSERT_VAL("wrong type val",
+			term->type_val == PARSE_EVENTS__TERM_TYPE_NUM);
+	TEST_ASSERT_VAL("wrong val", term->val.num == 1);
+	TEST_ASSERT_VAL("wrong config", !strcmp(term->config, "umask"));
+
+	return 0;
+}
+
+static int test__group1(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel, *leader;
+
+	TEST_ASSERT_VAL("wrong number of entries", 2 == evlist->nr_entries);
+
+	/* instructions:k */
+	evsel = leader = perf_evlist__first(evlist);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config",
+			PERF_COUNT_HW_INSTRUCTIONS == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong exclude guest", !evsel->attr.exclude_guest);
+	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
+	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+	TEST_ASSERT_VAL("wrong leader", evsel->leader == NULL);
+
+	/* cycles:upp */
+	evsel = perf_evsel__next(evsel);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config",
+			PERF_COUNT_HW_CPU_CYCLES == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
+	/* use of precise requires exclude_guest */
+	TEST_ASSERT_VAL("wrong exclude guest", evsel->attr.exclude_guest);
+	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
+	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip == 2);
+	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
+
+	return 0;
+}
+
+static int test__group2(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel, *leader;
+
+	TEST_ASSERT_VAL("wrong number of entries", 3 == evlist->nr_entries);
+
+	/* faults + :ku modifier */
+	evsel = leader = perf_evlist__first(evlist);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_SOFTWARE == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config",
+			PERF_COUNT_SW_PAGE_FAULTS == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong exclude guest", !evsel->attr.exclude_guest);
+	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
+	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+	TEST_ASSERT_VAL("wrong leader", evsel->leader == NULL);
+
+	/* cache-references + :u modifier */
+	evsel = perf_evsel__next(evsel);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config",
+			PERF_COUNT_HW_CACHE_REFERENCES == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong exclude guest", !evsel->attr.exclude_guest);
+	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
+	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
+
+	/* cycles:k */
+	evsel = perf_evsel__next(evsel);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config",
+			PERF_COUNT_HW_CPU_CYCLES == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong exclude guest", !evsel->attr.exclude_guest);
+	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
+	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+	TEST_ASSERT_VAL("wrong leader", evsel->leader == NULL);
+
+	return 0;
+}
+
+static int test__group3(struct perf_evlist *evlist __maybe_unused)
+{
+	struct perf_evsel *evsel, *leader;
+
+	TEST_ASSERT_VAL("wrong number of entries", 5 == evlist->nr_entries);
+
+	/* group1 syscalls:sys_enter_open:H */
+	evsel = leader = perf_evlist__first(evlist);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_TRACEPOINT == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong sample_type",
+		PERF_TP_SAMPLE_TYPE == evsel->attr.sample_type);
+	TEST_ASSERT_VAL("wrong sample_period", 1 == evsel->attr.sample_period);
+	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong exclude guest", evsel->attr.exclude_guest);
+	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
+	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+	TEST_ASSERT_VAL("wrong leader", evsel->leader == NULL);
+	TEST_ASSERT_VAL("wrong group name",
+		!strcmp(leader->group_name, "group1"));
+
+	/* group1 cycles:kppp */
+	evsel = perf_evsel__next(evsel);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config",
+			PERF_COUNT_HW_CPU_CYCLES == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
+	/* use of precise requires exclude_guest */
+	TEST_ASSERT_VAL("wrong exclude guest", evsel->attr.exclude_guest);
+	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
+	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip == 3);
+	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
+	TEST_ASSERT_VAL("wrong group name", !evsel->group_name);
+
+	/* group2 cycles + G modifier */
+	evsel = leader = perf_evsel__next(evsel);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config",
+			PERF_COUNT_HW_CPU_CYCLES == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong exclude guest", !evsel->attr.exclude_guest);
+	TEST_ASSERT_VAL("wrong exclude host", evsel->attr.exclude_host);
+	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+	TEST_ASSERT_VAL("wrong leader", evsel->leader == NULL);
+	TEST_ASSERT_VAL("wrong group name",
+		!strcmp(leader->group_name, "group2"));
+
+	/* group2 1:3 + G modifier */
+	evsel = perf_evsel__next(evsel);
+	TEST_ASSERT_VAL("wrong type", 1 == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config", 3 == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong exclude guest", !evsel->attr.exclude_guest);
+	TEST_ASSERT_VAL("wrong exclude host", evsel->attr.exclude_host);
+	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
+
+	/* instructions:u */
+	evsel = perf_evsel__next(evsel);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config",
+			PERF_COUNT_HW_INSTRUCTIONS == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong exclude guest", !evsel->attr.exclude_guest);
+	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
+	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+	TEST_ASSERT_VAL("wrong leader", evsel->leader == NULL);
+
+	return 0;
+}
+
+static int test__group4(struct perf_evlist *evlist __maybe_unused)
+{
+	struct perf_evsel *evsel, *leader;
+
+	TEST_ASSERT_VAL("wrong number of entries", 2 == evlist->nr_entries);
+
+	/* cycles:u + p */
+	evsel = leader = perf_evlist__first(evlist);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config",
+			PERF_COUNT_HW_CPU_CYCLES == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
+	/* use of precise requires exclude_guest */
+	TEST_ASSERT_VAL("wrong exclude guest", evsel->attr.exclude_guest);
+	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
+	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip == 1);
+	TEST_ASSERT_VAL("wrong group name", !evsel->group_name);
+	TEST_ASSERT_VAL("wrong leader", evsel->leader == NULL);
+
+	/* instructions:kp + p */
+	evsel = perf_evsel__next(evsel);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config",
+			PERF_COUNT_HW_INSTRUCTIONS == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
+	/* use of precise requires exclude_guest */
+	TEST_ASSERT_VAL("wrong exclude guest", evsel->attr.exclude_guest);
+	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
+	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip == 2);
+	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
+
+	return 0;
+}
+
+static int test__group5(struct perf_evlist *evlist __maybe_unused)
+{
+	struct perf_evsel *evsel, *leader;
+
+	TEST_ASSERT_VAL("wrong number of entries", 5 == evlist->nr_entries);
+
+	/* cycles + G */
+	evsel = leader = perf_evlist__first(evlist);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config",
+			PERF_COUNT_HW_CPU_CYCLES == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong exclude guest", !evsel->attr.exclude_guest);
+	TEST_ASSERT_VAL("wrong exclude host", evsel->attr.exclude_host);
+	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+	TEST_ASSERT_VAL("wrong group name", !evsel->group_name);
+	TEST_ASSERT_VAL("wrong leader", evsel->leader == NULL);
+
+	/* instructions + G */
+	evsel = perf_evsel__next(evsel);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config",
+			PERF_COUNT_HW_INSTRUCTIONS == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong exclude guest", !evsel->attr.exclude_guest);
+	TEST_ASSERT_VAL("wrong exclude host", evsel->attr.exclude_host);
+	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
+
+	/* cycles:G */
+	evsel = leader = perf_evsel__next(evsel);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config",
+			PERF_COUNT_HW_CPU_CYCLES == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong exclude guest", !evsel->attr.exclude_guest);
+	TEST_ASSERT_VAL("wrong exclude host", evsel->attr.exclude_host);
+	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+	TEST_ASSERT_VAL("wrong group name", !evsel->group_name);
+	TEST_ASSERT_VAL("wrong leader", evsel->leader == NULL);
+
+	/* instructions:G */
+	evsel = perf_evsel__next(evsel);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config",
+			PERF_COUNT_HW_INSTRUCTIONS == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong exclude guest", !evsel->attr.exclude_guest);
+	TEST_ASSERT_VAL("wrong exclude host", evsel->attr.exclude_host);
+	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
+
+	/* cycles */
+	evsel = perf_evsel__next(evsel);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config",
+			PERF_COUNT_HW_CPU_CYCLES == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong exclude guest", evsel->attr.exclude_guest);
+	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
+	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+	TEST_ASSERT_VAL("wrong leader", evsel->leader == NULL);
+
+	return 0;
+}
+
+struct test__event_st {
+	const char *name;
+	__u32 type;
+	int (*check)(struct perf_evlist *evlist);
+};
+
+static struct test__event_st test__events[] = {
+	[0] = {
+		.name  = "syscalls:sys_enter_open",
+		.check = test__checkevent_tracepoint,
+	},
+	[1] = {
+		.name  = "syscalls:*",
+		.check = test__checkevent_tracepoint_multi,
+	},
+	[2] = {
+		.name  = "r1a",
+		.check = test__checkevent_raw,
+	},
+	[3] = {
+		.name  = "1:1",
+		.check = test__checkevent_numeric,
+	},
+	[4] = {
+		.name  = "instructions",
+		.check = test__checkevent_symbolic_name,
+	},
+	[5] = {
+		.name  = "cycles/period=100000,config2/",
+		.check = test__checkevent_symbolic_name_config,
+	},
+	[6] = {
+		.name  = "faults",
+		.check = test__checkevent_symbolic_alias,
+	},
+	[7] = {
+		.name  = "L1-dcache-load-miss",
+		.check = test__checkevent_genhw,
+	},
+	[8] = {
+		.name  = "mem:0",
+		.check = test__checkevent_breakpoint,
+	},
+	[9] = {
+		.name  = "mem:0:x",
+		.check = test__checkevent_breakpoint_x,
+	},
+	[10] = {
+		.name  = "mem:0:r",
+		.check = test__checkevent_breakpoint_r,
+	},
+	[11] = {
+		.name  = "mem:0:w",
+		.check = test__checkevent_breakpoint_w,
+	},
+	[12] = {
+		.name  = "syscalls:sys_enter_open:k",
+		.check = test__checkevent_tracepoint_modifier,
+	},
+	[13] = {
+		.name  = "syscalls:*:u",
+		.check = test__checkevent_tracepoint_multi_modifier,
+	},
+	[14] = {
+		.name  = "r1a:kp",
+		.check = test__checkevent_raw_modifier,
+	},
+	[15] = {
+		.name  = "1:1:hp",
+		.check = test__checkevent_numeric_modifier,
+	},
+	[16] = {
+		.name  = "instructions:h",
+		.check = test__checkevent_symbolic_name_modifier,
+	},
+	[17] = {
+		.name  = "faults:u",
+		.check = test__checkevent_symbolic_alias_modifier,
+	},
+	[18] = {
+		.name  = "L1-dcache-load-miss:kp",
+		.check = test__checkevent_genhw_modifier,
+	},
+	[19] = {
+		.name  = "mem:0:u",
+		.check = test__checkevent_breakpoint_modifier,
+	},
+	[20] = {
+		.name  = "mem:0:x:k",
+		.check = test__checkevent_breakpoint_x_modifier,
+	},
+	[21] = {
+		.name  = "mem:0:r:hp",
+		.check = test__checkevent_breakpoint_r_modifier,
+	},
+	[22] = {
+		.name  = "mem:0:w:up",
+		.check = test__checkevent_breakpoint_w_modifier,
+	},
+	[23] = {
+		.name  = "r1,syscalls:sys_enter_open:k,1:1:hp",
+		.check = test__checkevent_list,
+	},
+	[24] = {
+		.name  = "instructions:G",
+		.check = test__checkevent_exclude_host_modifier,
+	},
+	[25] = {
+		.name  = "instructions:H",
+		.check = test__checkevent_exclude_guest_modifier,
+	},
+	[26] = {
+		.name  = "mem:0:rw",
+		.check = test__checkevent_breakpoint_rw,
+	},
+	[27] = {
+		.name  = "mem:0:rw:kp",
+		.check = test__checkevent_breakpoint_rw_modifier,
+	},
+	[28] = {
+		.name  = "{instructions:k,cycles:upp}",
+		.check = test__group1,
+	},
+	[29] = {
+		.name  = "{faults:k,cache-references}:u,cycles:k",
+		.check = test__group2,
+	},
+	[30] = {
+		.name  = "group1{syscalls:sys_enter_open:H,cycles:kppp},group2{cycles,1:3}:G,instructions:u",
+		.check = test__group3,
+	},
+	[31] = {
+		.name  = "{cycles:u,instructions:kp}:p",
+		.check = test__group4,
+	},
+	[32] = {
+		.name  = "{cycles,instructions}:G,{cycles:G,instructions:G},cycles",
+		.check = test__group5,
+	},
+};
+
+static struct test__event_st test__events_pmu[] = {
+	[0] = {
+		.name  = "cpu/config=10,config1,config2=3,period=1000/u",
+		.check = test__checkevent_pmu,
+	},
+	[1] = {
+		.name  = "cpu/config=1,name=krava/u,cpu/config=2/u",
+		.check = test__checkevent_pmu_name,
+	},
+};
+
+struct test__term {
+	const char *str;
+	__u32 type;
+	int (*check)(struct list_head *terms);
+};
+
+static struct test__term test__terms[] = {
+	[0] = {
+		.str   = "config=10,config1,config2=3,umask=1",
+		.check = test__checkterms_simple,
+	},
+};
+
+static int test_event(struct test__event_st *e)
+{
+	struct perf_evlist *evlist;
+	int ret;
+
+	evlist = perf_evlist__new(NULL, NULL);
+	if (evlist == NULL)
+		return -ENOMEM;
+
+	ret = parse_events(evlist, e->name, 0);
+	if (ret) {
+		pr_debug("failed to parse event '%s', err %d\n",
+			 e->name, ret);
+		return ret;
+	}
+
+	ret = e->check(evlist);
+	perf_evlist__delete(evlist);
+
+	return ret;
+}
+
+static int test_events(struct test__event_st *events, unsigned cnt)
+{
+	int ret1, ret2 = 0;
+	unsigned i;
+
+	for (i = 0; i < cnt; i++) {
+		struct test__event_st *e = &events[i];
+
+		pr_debug("running test %d '%s'\n", i, e->name);
+		ret1 = test_event(e);
+		if (ret1)
+			ret2 = ret1;
+	}
+
+	return ret2;
+}
+
+static int test_term(struct test__term *t)
+{
+	struct list_head *terms;
+	int ret;
+
+	terms = malloc(sizeof(*terms));
+	if (!terms)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(terms);
+
+	ret = parse_events_terms(terms, t->str);
+	if (ret) {
+		pr_debug("failed to parse terms '%s', err %d\n",
+			 t->str , ret);
+		return ret;
+	}
+
+	ret = t->check(terms);
+	parse_events__free_terms(terms);
+
+	return ret;
+}
+
+static int test_terms(struct test__term *terms, unsigned cnt)
+{
+	int ret = 0;
+	unsigned i;
+
+	for (i = 0; i < cnt; i++) {
+		struct test__term *t = &terms[i];
+
+		pr_debug("running test %d '%s'\n", i, t->str);
+		ret = test_term(t);
+		if (ret)
+			break;
+	}
+
+	return ret;
+}
+
+static int test_pmu(void)
+{
+	struct stat st;
+	char path[PATH_MAX];
+	int ret;
+
+	snprintf(path, PATH_MAX, "%s/bus/event_source/devices/cpu/format/",
+		 sysfs_find_mountpoint());
+
+	ret = stat(path, &st);
+	if (ret)
+		pr_debug("omitting PMU cpu tests\n");
+	return !ret;
+}
+
+static int test_pmu_events(void)
+{
+	struct stat st;
+	char path[PATH_MAX];
+	struct dirent *ent;
+	DIR *dir;
+	int ret;
+
+	snprintf(path, PATH_MAX, "%s/bus/event_source/devices/cpu/events/",
+		 sysfs_find_mountpoint());
+
+	ret = stat(path, &st);
+	if (ret) {
+		pr_debug("ommiting PMU cpu events tests\n");
+		return 0;
+	}
+
+	dir = opendir(path);
+	if (!dir) {
+		pr_debug("can't open pmu event dir");
+		return -1;
+	}
+
+	while (!ret && (ent = readdir(dir))) {
+#define MAX_NAME 100
+		struct test__event_st e;
+		char name[MAX_NAME];
+
+		if (!strcmp(ent->d_name, ".") ||
+		    !strcmp(ent->d_name, ".."))
+			continue;
+
+		snprintf(name, MAX_NAME, "cpu/event=%s/u", ent->d_name);
+
+		e.name  = name;
+		e.check = test__checkevent_pmu_events;
+
+		ret = test_event(&e);
+#undef MAX_NAME
+	}
+
+	closedir(dir);
+	return ret;
+}
+
+int parse_events__test(void)
+{
+	int ret1, ret2 = 0;
+
+#define TEST_EVENTS(tests)				\
+do {							\
+	ret1 = test_events(tests, ARRAY_SIZE(tests));	\
+	if (!ret2)					\
+		ret2 = ret1;				\
+} while (0)
+
+	TEST_EVENTS(test__events);
+
+	if (test_pmu())
+		TEST_EVENTS(test__events_pmu);
+
+	if (test_pmu()) {
+		int ret = test_pmu_events();
+		if (ret)
+			return ret;
+	}
+
+	ret1 = test_terms(test__terms, ARRAY_SIZE(test__terms));
+	if (!ret2)
+		ret2 = ret1;
+
+	return ret2;
+}
diff --git a/tools/perf/util/dso-test-data.c b/tools/perf/util/dso-test-data.c
deleted file mode 100644
index c6caede..0000000
--- a/tools/perf/util/dso-test-data.c
+++ /dev/null
@@ -1,153 +0,0 @@
-#include "util.h"
-
-#include <stdlib.h>
-#include <sys/types.h>
-#include <sys/stat.h>
-#include <fcntl.h>
-#include <string.h>
-
-#include "symbol.h"
-
-#define TEST_ASSERT_VAL(text, cond) \
-do { \
-	if (!(cond)) { \
-		pr_debug("FAILED %s:%d %s\n", __FILE__, __LINE__, text); \
-		return -1; \
-	} \
-} while (0)
-
-static char *test_file(int size)
-{
-	static char buf_templ[] = "/tmp/test-XXXXXX";
-	char *templ = buf_templ;
-	int fd, i;
-	unsigned char *buf;
-
-	fd = mkstemp(templ);
-
-	buf = malloc(size);
-	if (!buf) {
-		close(fd);
-		return NULL;
-	}
-
-	for (i = 0; i < size; i++)
-		buf[i] = (unsigned char) ((int) i % 10);
-
-	if (size != write(fd, buf, size))
-		templ = NULL;
-
-	close(fd);
-	return templ;
-}
-
-#define TEST_FILE_SIZE (DSO__DATA_CACHE_SIZE * 20)
-
-struct test_data_offset {
-	off_t offset;
-	u8 data[10];
-	int size;
-};
-
-struct test_data_offset offsets[] = {
-	/* Fill first cache page. */
-	{
-		.offset = 10,
-		.data   = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 },
-		.size   = 10,
-	},
-	/* Read first cache page. */
-	{
-		.offset = 10,
-		.data   = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 },
-		.size   = 10,
-	},
-	/* Fill cache boundary pages. */
-	{
-		.offset = DSO__DATA_CACHE_SIZE - DSO__DATA_CACHE_SIZE % 10,
-		.data   = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 },
-		.size   = 10,
-	},
-	/* Read cache boundary pages. */
-	{
-		.offset = DSO__DATA_CACHE_SIZE - DSO__DATA_CACHE_SIZE % 10,
-		.data   = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 },
-		.size   = 10,
-	},
-	/* Fill final cache page. */
-	{
-		.offset = TEST_FILE_SIZE - 10,
-		.data   = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 },
-		.size   = 10,
-	},
-	/* Read final cache page. */
-	{
-		.offset = TEST_FILE_SIZE - 10,
-		.data   = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 },
-		.size   = 10,
-	},
-	/* Read final cache page. */
-	{
-		.offset = TEST_FILE_SIZE - 3,
-		.data   = { 7, 8, 9, 0, 0, 0, 0, 0, 0, 0 },
-		.size   = 3,
-	},
-};
-
-int dso__test_data(void)
-{
-	struct machine machine;
-	struct dso *dso;
-	char *file = test_file(TEST_FILE_SIZE);
-	size_t i;
-
-	TEST_ASSERT_VAL("No test file", file);
-
-	memset(&machine, 0, sizeof(machine));
-
-	dso = dso__new((const char *)file);
-
-	/* Basic 10 bytes tests. */
-	for (i = 0; i < ARRAY_SIZE(offsets); i++) {
-		struct test_data_offset *data = &offsets[i];
-		ssize_t size;
-		u8 buf[10];
-
-		memset(buf, 0, 10);
-		size = dso__data_read_offset(dso, &machine, data->offset,
-				     buf, 10);
-
-		TEST_ASSERT_VAL("Wrong size", size == data->size);
-		TEST_ASSERT_VAL("Wrong data", !memcmp(buf, data->data, 10));
-	}
-
-	/* Read cross multiple cache pages. */
-	{
-		ssize_t size;
-		int c;
-		u8 *buf;
-
-		buf = malloc(TEST_FILE_SIZE);
-		TEST_ASSERT_VAL("ENOMEM\n", buf);
-
-		/* First iteration to fill caches, second one to read them. */
-		for (c = 0; c < 2; c++) {
-			memset(buf, 0, TEST_FILE_SIZE);
-			size = dso__data_read_offset(dso, &machine, 10,
-						     buf, TEST_FILE_SIZE);
-
-			TEST_ASSERT_VAL("Wrong size",
-				size == (TEST_FILE_SIZE - 10));
-
-			for (i = 0; i < (size_t)size; i++)
-				TEST_ASSERT_VAL("Wrong data",
-					buf[i] == (i % 10));
-		}
-
-		free(buf);
-	}
-
-	dso__delete(dso);
-	unlink(file);
-	return 0;
-}
diff --git a/tools/perf/util/parse-events-test.c b/tools/perf/util/parse-events-test.c
deleted file mode 100644
index b49c2ee..0000000
--- a/tools/perf/util/parse-events-test.c
+++ /dev/null
@@ -1,1116 +0,0 @@
-
-#include "parse-events.h"
-#include "evsel.h"
-#include "evlist.h"
-#include "sysfs.h"
-#include "../../../include/linux/hw_breakpoint.h"
-
-#define TEST_ASSERT_VAL(text, cond) \
-do { \
-	if (!(cond)) { \
-		pr_debug("FAILED %s:%d %s\n", __FILE__, __LINE__, text); \
-		return -1; \
-	} \
-} while (0)
-
-#define PERF_TP_SAMPLE_TYPE (PERF_SAMPLE_RAW | PERF_SAMPLE_TIME | \
-			     PERF_SAMPLE_CPU | PERF_SAMPLE_PERIOD)
-
-static int test__checkevent_tracepoint(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = perf_evlist__first(evlist);
-
-	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_TRACEPOINT == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong sample_type",
-		PERF_TP_SAMPLE_TYPE == evsel->attr.sample_type);
-	TEST_ASSERT_VAL("wrong sample_period", 1 == evsel->attr.sample_period);
-	return 0;
-}
-
-static int test__checkevent_tracepoint_multi(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel;
-
-	TEST_ASSERT_VAL("wrong number of entries", evlist->nr_entries > 1);
-
-	list_for_each_entry(evsel, &evlist->entries, node) {
-		TEST_ASSERT_VAL("wrong type",
-			PERF_TYPE_TRACEPOINT == evsel->attr.type);
-		TEST_ASSERT_VAL("wrong sample_type",
-			PERF_TP_SAMPLE_TYPE == evsel->attr.sample_type);
-		TEST_ASSERT_VAL("wrong sample_period",
-			1 == evsel->attr.sample_period);
-	}
-	return 0;
-}
-
-static int test__checkevent_raw(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = perf_evlist__first(evlist);
-
-	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_RAW == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config", 0x1a == evsel->attr.config);
-	return 0;
-}
-
-static int test__checkevent_numeric(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = perf_evlist__first(evlist);
-
-	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
-	TEST_ASSERT_VAL("wrong type", 1 == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config", 1 == evsel->attr.config);
-	return 0;
-}
-
-static int test__checkevent_symbolic_name(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = perf_evlist__first(evlist);
-
-	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config",
-			PERF_COUNT_HW_INSTRUCTIONS == evsel->attr.config);
-	return 0;
-}
-
-static int test__checkevent_symbolic_name_config(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = perf_evlist__first(evlist);
-
-	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config",
-			PERF_COUNT_HW_CPU_CYCLES == evsel->attr.config);
-	TEST_ASSERT_VAL("wrong period",
-			100000 == evsel->attr.sample_period);
-	TEST_ASSERT_VAL("wrong config1",
-			0 == evsel->attr.config1);
-	TEST_ASSERT_VAL("wrong config2",
-			1 == evsel->attr.config2);
-	return 0;
-}
-
-static int test__checkevent_symbolic_alias(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = perf_evlist__first(evlist);
-
-	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_SOFTWARE == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config",
-			PERF_COUNT_SW_PAGE_FAULTS == evsel->attr.config);
-	return 0;
-}
-
-static int test__checkevent_genhw(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = perf_evlist__first(evlist);
-
-	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HW_CACHE == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config", (1 << 16) == evsel->attr.config);
-	return 0;
-}
-
-static int test__checkevent_breakpoint(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = perf_evlist__first(evlist);
-
-	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_BREAKPOINT == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config", 0 == evsel->attr.config);
-	TEST_ASSERT_VAL("wrong bp_type", (HW_BREAKPOINT_R | HW_BREAKPOINT_W) ==
-					 evsel->attr.bp_type);
-	TEST_ASSERT_VAL("wrong bp_len", HW_BREAKPOINT_LEN_4 ==
-					evsel->attr.bp_len);
-	return 0;
-}
-
-static int test__checkevent_breakpoint_x(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = perf_evlist__first(evlist);
-
-	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_BREAKPOINT == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config", 0 == evsel->attr.config);
-	TEST_ASSERT_VAL("wrong bp_type",
-			HW_BREAKPOINT_X == evsel->attr.bp_type);
-	TEST_ASSERT_VAL("wrong bp_len", sizeof(long) == evsel->attr.bp_len);
-	return 0;
-}
-
-static int test__checkevent_breakpoint_r(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = perf_evlist__first(evlist);
-
-	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
-	TEST_ASSERT_VAL("wrong type",
-			PERF_TYPE_BREAKPOINT == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config", 0 == evsel->attr.config);
-	TEST_ASSERT_VAL("wrong bp_type",
-			HW_BREAKPOINT_R == evsel->attr.bp_type);
-	TEST_ASSERT_VAL("wrong bp_len",
-			HW_BREAKPOINT_LEN_4 == evsel->attr.bp_len);
-	return 0;
-}
-
-static int test__checkevent_breakpoint_w(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = perf_evlist__first(evlist);
-
-	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
-	TEST_ASSERT_VAL("wrong type",
-			PERF_TYPE_BREAKPOINT == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config", 0 == evsel->attr.config);
-	TEST_ASSERT_VAL("wrong bp_type",
-			HW_BREAKPOINT_W == evsel->attr.bp_type);
-	TEST_ASSERT_VAL("wrong bp_len",
-			HW_BREAKPOINT_LEN_4 == evsel->attr.bp_len);
-	return 0;
-}
-
-static int test__checkevent_breakpoint_rw(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = perf_evlist__first(evlist);
-
-	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
-	TEST_ASSERT_VAL("wrong type",
-			PERF_TYPE_BREAKPOINT == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config", 0 == evsel->attr.config);
-	TEST_ASSERT_VAL("wrong bp_type",
-		(HW_BREAKPOINT_R|HW_BREAKPOINT_W) == evsel->attr.bp_type);
-	TEST_ASSERT_VAL("wrong bp_len",
-			HW_BREAKPOINT_LEN_4 == evsel->attr.bp_len);
-	return 0;
-}
-
-static int test__checkevent_tracepoint_modifier(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = perf_evlist__first(evlist);
-
-	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
-
-	return test__checkevent_tracepoint(evlist);
-}
-
-static int
-test__checkevent_tracepoint_multi_modifier(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel;
-
-	TEST_ASSERT_VAL("wrong number of entries", evlist->nr_entries > 1);
-
-	list_for_each_entry(evsel, &evlist->entries, node) {
-		TEST_ASSERT_VAL("wrong exclude_user",
-				!evsel->attr.exclude_user);
-		TEST_ASSERT_VAL("wrong exclude_kernel",
-				evsel->attr.exclude_kernel);
-		TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
-		TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
-	}
-
-	return test__checkevent_tracepoint_multi(evlist);
-}
-
-static int test__checkevent_raw_modifier(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = perf_evlist__first(evlist);
-
-	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip);
-
-	return test__checkevent_raw(evlist);
-}
-
-static int test__checkevent_numeric_modifier(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = perf_evlist__first(evlist);
-
-	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip);
-
-	return test__checkevent_numeric(evlist);
-}
-
-static int test__checkevent_symbolic_name_modifier(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = perf_evlist__first(evlist);
-
-	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
-
-	return test__checkevent_symbolic_name(evlist);
-}
-
-static int test__checkevent_exclude_host_modifier(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = perf_evlist__first(evlist);
-
-	TEST_ASSERT_VAL("wrong exclude guest", !evsel->attr.exclude_guest);
-	TEST_ASSERT_VAL("wrong exclude host", evsel->attr.exclude_host);
-
-	return test__checkevent_symbolic_name(evlist);
-}
-
-static int test__checkevent_exclude_guest_modifier(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = perf_evlist__first(evlist);
-
-	TEST_ASSERT_VAL("wrong exclude guest", evsel->attr.exclude_guest);
-	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
-
-	return test__checkevent_symbolic_name(evlist);
-}
-
-static int test__checkevent_symbolic_alias_modifier(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = perf_evlist__first(evlist);
-
-	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
-
-	return test__checkevent_symbolic_alias(evlist);
-}
-
-static int test__checkevent_genhw_modifier(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = perf_evlist__first(evlist);
-
-	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip);
-
-	return test__checkevent_genhw(evlist);
-}
-
-static int test__checkevent_breakpoint_modifier(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = perf_evlist__first(evlist);
-
-
-	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
-	TEST_ASSERT_VAL("wrong name",
-			!strcmp(perf_evsel__name(evsel), "mem:0:u"));
-
-	return test__checkevent_breakpoint(evlist);
-}
-
-static int test__checkevent_breakpoint_x_modifier(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = perf_evlist__first(evlist);
-
-	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
-	TEST_ASSERT_VAL("wrong name",
-			!strcmp(perf_evsel__name(evsel), "mem:0:x:k"));
-
-	return test__checkevent_breakpoint_x(evlist);
-}
-
-static int test__checkevent_breakpoint_r_modifier(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = perf_evlist__first(evlist);
-
-	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip);
-	TEST_ASSERT_VAL("wrong name",
-			!strcmp(perf_evsel__name(evsel), "mem:0:r:hp"));
-
-	return test__checkevent_breakpoint_r(evlist);
-}
-
-static int test__checkevent_breakpoint_w_modifier(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = perf_evlist__first(evlist);
-
-	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip);
-	TEST_ASSERT_VAL("wrong name",
-			!strcmp(perf_evsel__name(evsel), "mem:0:w:up"));
-
-	return test__checkevent_breakpoint_w(evlist);
-}
-
-static int test__checkevent_breakpoint_rw_modifier(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = perf_evlist__first(evlist);
-
-	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip);
-	TEST_ASSERT_VAL("wrong name",
-			!strcmp(perf_evsel__name(evsel), "mem:0:rw:kp"));
-
-	return test__checkevent_breakpoint_rw(evlist);
-}
-
-static int test__checkevent_pmu(struct perf_evlist *evlist)
-{
-
-	struct perf_evsel *evsel = perf_evlist__first(evlist);
-
-	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_RAW == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config",    10 == evsel->attr.config);
-	TEST_ASSERT_VAL("wrong config1",    1 == evsel->attr.config1);
-	TEST_ASSERT_VAL("wrong config2",    3 == evsel->attr.config2);
-	TEST_ASSERT_VAL("wrong period",  1000 == evsel->attr.sample_period);
-
-	return 0;
-}
-
-static int test__checkevent_list(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = perf_evlist__first(evlist);
-
-	TEST_ASSERT_VAL("wrong number of entries", 3 == evlist->nr_entries);
-
-	/* r1 */
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_RAW == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config", 1 == evsel->attr.config);
-	TEST_ASSERT_VAL("wrong config1", 0 == evsel->attr.config1);
-	TEST_ASSERT_VAL("wrong config2", 0 == evsel->attr.config2);
-	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
-
-	/* syscalls:sys_enter_open:k */
-	evsel = perf_evsel__next(evsel);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_TRACEPOINT == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong sample_type",
-		PERF_TP_SAMPLE_TYPE == evsel->attr.sample_type);
-	TEST_ASSERT_VAL("wrong sample_period", 1 == evsel->attr.sample_period);
-	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
-
-	/* 1:1:hp */
-	evsel = perf_evsel__next(evsel);
-	TEST_ASSERT_VAL("wrong type", 1 == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config", 1 == evsel->attr.config);
-	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip);
-
-	return 0;
-}
-
-static int test__checkevent_pmu_name(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = perf_evlist__first(evlist);
-
-	/* cpu/config=1,name=krava/u */
-	TEST_ASSERT_VAL("wrong number of entries", 2 == evlist->nr_entries);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_RAW == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config",  1 == evsel->attr.config);
-	TEST_ASSERT_VAL("wrong name", !strcmp(perf_evsel__name(evsel), "krava"));
-
-	/* cpu/config=2/u" */
-	evsel = perf_evsel__next(evsel);
-	TEST_ASSERT_VAL("wrong number of entries", 2 == evlist->nr_entries);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_RAW == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config",  2 == evsel->attr.config);
-	TEST_ASSERT_VAL("wrong name",
-			!strcmp(perf_evsel__name(evsel), "cpu/config=2/u"));
-
-	return 0;
-}
-
-static int test__checkevent_pmu_events(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel;
-
-	evsel = list_entry(evlist->entries.next, struct perf_evsel, node);
-	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_RAW == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong exclude_user",
-			!evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel",
-			evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
-
-	return 0;
-}
-
-static int test__checkterms_simple(struct list_head *terms)
-{
-	struct parse_events__term *term;
-
-	/* config=10 */
-	term = list_entry(terms->next, struct parse_events__term, list);
-	TEST_ASSERT_VAL("wrong type term",
-			term->type_term == PARSE_EVENTS__TERM_TYPE_CONFIG);
-	TEST_ASSERT_VAL("wrong type val",
-			term->type_val == PARSE_EVENTS__TERM_TYPE_NUM);
-	TEST_ASSERT_VAL("wrong val", term->val.num == 10);
-	TEST_ASSERT_VAL("wrong config", !term->config);
-
-	/* config1 */
-	term = list_entry(term->list.next, struct parse_events__term, list);
-	TEST_ASSERT_VAL("wrong type term",
-			term->type_term == PARSE_EVENTS__TERM_TYPE_CONFIG1);
-	TEST_ASSERT_VAL("wrong type val",
-			term->type_val == PARSE_EVENTS__TERM_TYPE_NUM);
-	TEST_ASSERT_VAL("wrong val", term->val.num == 1);
-	TEST_ASSERT_VAL("wrong config", !term->config);
-
-	/* config2=3 */
-	term = list_entry(term->list.next, struct parse_events__term, list);
-	TEST_ASSERT_VAL("wrong type term",
-			term->type_term == PARSE_EVENTS__TERM_TYPE_CONFIG2);
-	TEST_ASSERT_VAL("wrong type val",
-			term->type_val == PARSE_EVENTS__TERM_TYPE_NUM);
-	TEST_ASSERT_VAL("wrong val", term->val.num == 3);
-	TEST_ASSERT_VAL("wrong config", !term->config);
-
-	/* umask=1*/
-	term = list_entry(term->list.next, struct parse_events__term, list);
-	TEST_ASSERT_VAL("wrong type term",
-			term->type_term == PARSE_EVENTS__TERM_TYPE_USER);
-	TEST_ASSERT_VAL("wrong type val",
-			term->type_val == PARSE_EVENTS__TERM_TYPE_NUM);
-	TEST_ASSERT_VAL("wrong val", term->val.num == 1);
-	TEST_ASSERT_VAL("wrong config", !strcmp(term->config, "umask"));
-
-	return 0;
-}
-
-static int test__group1(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel, *leader;
-
-	TEST_ASSERT_VAL("wrong number of entries", 2 == evlist->nr_entries);
-
-	/* instructions:k */
-	evsel = leader = perf_evlist__first(evlist);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config",
-			PERF_COUNT_HW_INSTRUCTIONS == evsel->attr.config);
-	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong exclude guest", !evsel->attr.exclude_guest);
-	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
-	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
-	TEST_ASSERT_VAL("wrong leader", evsel->leader == NULL);
-
-	/* cycles:upp */
-	evsel = perf_evsel__next(evsel);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config",
-			PERF_COUNT_HW_CPU_CYCLES == evsel->attr.config);
-	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
-	/* use of precise requires exclude_guest */
-	TEST_ASSERT_VAL("wrong exclude guest", evsel->attr.exclude_guest);
-	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
-	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip == 2);
-	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
-
-	return 0;
-}
-
-static int test__group2(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel, *leader;
-
-	TEST_ASSERT_VAL("wrong number of entries", 3 == evlist->nr_entries);
-
-	/* faults + :ku modifier */
-	evsel = leader = perf_evlist__first(evlist);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_SOFTWARE == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config",
-			PERF_COUNT_SW_PAGE_FAULTS == evsel->attr.config);
-	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong exclude guest", !evsel->attr.exclude_guest);
-	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
-	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
-	TEST_ASSERT_VAL("wrong leader", evsel->leader == NULL);
-
-	/* cache-references + :u modifier */
-	evsel = perf_evsel__next(evsel);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config",
-			PERF_COUNT_HW_CACHE_REFERENCES == evsel->attr.config);
-	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong exclude guest", !evsel->attr.exclude_guest);
-	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
-	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
-	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
-
-	/* cycles:k */
-	evsel = perf_evsel__next(evsel);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config",
-			PERF_COUNT_HW_CPU_CYCLES == evsel->attr.config);
-	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong exclude guest", !evsel->attr.exclude_guest);
-	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
-	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
-	TEST_ASSERT_VAL("wrong leader", evsel->leader == NULL);
-
-	return 0;
-}
-
-static int test__group3(struct perf_evlist *evlist __maybe_unused)
-{
-	struct perf_evsel *evsel, *leader;
-
-	TEST_ASSERT_VAL("wrong number of entries", 5 == evlist->nr_entries);
-
-	/* group1 syscalls:sys_enter_open:H */
-	evsel = leader = perf_evlist__first(evlist);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_TRACEPOINT == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong sample_type",
-		PERF_TP_SAMPLE_TYPE == evsel->attr.sample_type);
-	TEST_ASSERT_VAL("wrong sample_period", 1 == evsel->attr.sample_period);
-	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong exclude guest", evsel->attr.exclude_guest);
-	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
-	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
-	TEST_ASSERT_VAL("wrong leader", evsel->leader == NULL);
-	TEST_ASSERT_VAL("wrong group name",
-		!strcmp(leader->group_name, "group1"));
-
-	/* group1 cycles:kppp */
-	evsel = perf_evsel__next(evsel);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config",
-			PERF_COUNT_HW_CPU_CYCLES == evsel->attr.config);
-	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
-	/* use of precise requires exclude_guest */
-	TEST_ASSERT_VAL("wrong exclude guest", evsel->attr.exclude_guest);
-	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
-	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip == 3);
-	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
-	TEST_ASSERT_VAL("wrong group name", !evsel->group_name);
-
-	/* group2 cycles + G modifier */
-	evsel = leader = perf_evsel__next(evsel);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config",
-			PERF_COUNT_HW_CPU_CYCLES == evsel->attr.config);
-	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong exclude guest", !evsel->attr.exclude_guest);
-	TEST_ASSERT_VAL("wrong exclude host", evsel->attr.exclude_host);
-	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
-	TEST_ASSERT_VAL("wrong leader", evsel->leader == NULL);
-	TEST_ASSERT_VAL("wrong group name",
-		!strcmp(leader->group_name, "group2"));
-
-	/* group2 1:3 + G modifier */
-	evsel = perf_evsel__next(evsel);
-	TEST_ASSERT_VAL("wrong type", 1 == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config", 3 == evsel->attr.config);
-	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong exclude guest", !evsel->attr.exclude_guest);
-	TEST_ASSERT_VAL("wrong exclude host", evsel->attr.exclude_host);
-	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
-	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
-
-	/* instructions:u */
-	evsel = perf_evsel__next(evsel);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config",
-			PERF_COUNT_HW_INSTRUCTIONS == evsel->attr.config);
-	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong exclude guest", !evsel->attr.exclude_guest);
-	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
-	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
-	TEST_ASSERT_VAL("wrong leader", evsel->leader == NULL);
-
-	return 0;
-}
-
-static int test__group4(struct perf_evlist *evlist __maybe_unused)
-{
-	struct perf_evsel *evsel, *leader;
-
-	TEST_ASSERT_VAL("wrong number of entries", 2 == evlist->nr_entries);
-
-	/* cycles:u + p */
-	evsel = leader = perf_evlist__first(evlist);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config",
-			PERF_COUNT_HW_CPU_CYCLES == evsel->attr.config);
-	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
-	/* use of precise requires exclude_guest */
-	TEST_ASSERT_VAL("wrong exclude guest", evsel->attr.exclude_guest);
-	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
-	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip == 1);
-	TEST_ASSERT_VAL("wrong group name", !evsel->group_name);
-	TEST_ASSERT_VAL("wrong leader", evsel->leader == NULL);
-
-	/* instructions:kp + p */
-	evsel = perf_evsel__next(evsel);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config",
-			PERF_COUNT_HW_INSTRUCTIONS == evsel->attr.config);
-	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
-	/* use of precise requires exclude_guest */
-	TEST_ASSERT_VAL("wrong exclude guest", evsel->attr.exclude_guest);
-	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
-	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip == 2);
-	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
-
-	return 0;
-}
-
-static int test__group5(struct perf_evlist *evlist __maybe_unused)
-{
-	struct perf_evsel *evsel, *leader;
-
-	TEST_ASSERT_VAL("wrong number of entries", 5 == evlist->nr_entries);
-
-	/* cycles + G */
-	evsel = leader = perf_evlist__first(evlist);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config",
-			PERF_COUNT_HW_CPU_CYCLES == evsel->attr.config);
-	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong exclude guest", !evsel->attr.exclude_guest);
-	TEST_ASSERT_VAL("wrong exclude host", evsel->attr.exclude_host);
-	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
-	TEST_ASSERT_VAL("wrong group name", !evsel->group_name);
-	TEST_ASSERT_VAL("wrong leader", evsel->leader == NULL);
-
-	/* instructions + G */
-	evsel = perf_evsel__next(evsel);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config",
-			PERF_COUNT_HW_INSTRUCTIONS == evsel->attr.config);
-	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong exclude guest", !evsel->attr.exclude_guest);
-	TEST_ASSERT_VAL("wrong exclude host", evsel->attr.exclude_host);
-	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
-	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
-
-	/* cycles:G */
-	evsel = leader = perf_evsel__next(evsel);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config",
-			PERF_COUNT_HW_CPU_CYCLES == evsel->attr.config);
-	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong exclude guest", !evsel->attr.exclude_guest);
-	TEST_ASSERT_VAL("wrong exclude host", evsel->attr.exclude_host);
-	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
-	TEST_ASSERT_VAL("wrong group name", !evsel->group_name);
-	TEST_ASSERT_VAL("wrong leader", evsel->leader == NULL);
-
-	/* instructions:G */
-	evsel = perf_evsel__next(evsel);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config",
-			PERF_COUNT_HW_INSTRUCTIONS == evsel->attr.config);
-	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong exclude guest", !evsel->attr.exclude_guest);
-	TEST_ASSERT_VAL("wrong exclude host", evsel->attr.exclude_host);
-	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
-	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
-
-	/* cycles */
-	evsel = perf_evsel__next(evsel);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config",
-			PERF_COUNT_HW_CPU_CYCLES == evsel->attr.config);
-	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong exclude guest", evsel->attr.exclude_guest);
-	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
-	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
-	TEST_ASSERT_VAL("wrong leader", evsel->leader == NULL);
-
-	return 0;
-}
-
-struct test__event_st {
-	const char *name;
-	__u32 type;
-	int (*check)(struct perf_evlist *evlist);
-};
-
-static struct test__event_st test__events[] = {
-	[0] = {
-		.name  = "syscalls:sys_enter_open",
-		.check = test__checkevent_tracepoint,
-	},
-	[1] = {
-		.name  = "syscalls:*",
-		.check = test__checkevent_tracepoint_multi,
-	},
-	[2] = {
-		.name  = "r1a",
-		.check = test__checkevent_raw,
-	},
-	[3] = {
-		.name  = "1:1",
-		.check = test__checkevent_numeric,
-	},
-	[4] = {
-		.name  = "instructions",
-		.check = test__checkevent_symbolic_name,
-	},
-	[5] = {
-		.name  = "cycles/period=100000,config2/",
-		.check = test__checkevent_symbolic_name_config,
-	},
-	[6] = {
-		.name  = "faults",
-		.check = test__checkevent_symbolic_alias,
-	},
-	[7] = {
-		.name  = "L1-dcache-load-miss",
-		.check = test__checkevent_genhw,
-	},
-	[8] = {
-		.name  = "mem:0",
-		.check = test__checkevent_breakpoint,
-	},
-	[9] = {
-		.name  = "mem:0:x",
-		.check = test__checkevent_breakpoint_x,
-	},
-	[10] = {
-		.name  = "mem:0:r",
-		.check = test__checkevent_breakpoint_r,
-	},
-	[11] = {
-		.name  = "mem:0:w",
-		.check = test__checkevent_breakpoint_w,
-	},
-	[12] = {
-		.name  = "syscalls:sys_enter_open:k",
-		.check = test__checkevent_tracepoint_modifier,
-	},
-	[13] = {
-		.name  = "syscalls:*:u",
-		.check = test__checkevent_tracepoint_multi_modifier,
-	},
-	[14] = {
-		.name  = "r1a:kp",
-		.check = test__checkevent_raw_modifier,
-	},
-	[15] = {
-		.name  = "1:1:hp",
-		.check = test__checkevent_numeric_modifier,
-	},
-	[16] = {
-		.name  = "instructions:h",
-		.check = test__checkevent_symbolic_name_modifier,
-	},
-	[17] = {
-		.name  = "faults:u",
-		.check = test__checkevent_symbolic_alias_modifier,
-	},
-	[18] = {
-		.name  = "L1-dcache-load-miss:kp",
-		.check = test__checkevent_genhw_modifier,
-	},
-	[19] = {
-		.name  = "mem:0:u",
-		.check = test__checkevent_breakpoint_modifier,
-	},
-	[20] = {
-		.name  = "mem:0:x:k",
-		.check = test__checkevent_breakpoint_x_modifier,
-	},
-	[21] = {
-		.name  = "mem:0:r:hp",
-		.check = test__checkevent_breakpoint_r_modifier,
-	},
-	[22] = {
-		.name  = "mem:0:w:up",
-		.check = test__checkevent_breakpoint_w_modifier,
-	},
-	[23] = {
-		.name  = "r1,syscalls:sys_enter_open:k,1:1:hp",
-		.check = test__checkevent_list,
-	},
-	[24] = {
-		.name  = "instructions:G",
-		.check = test__checkevent_exclude_host_modifier,
-	},
-	[25] = {
-		.name  = "instructions:H",
-		.check = test__checkevent_exclude_guest_modifier,
-	},
-	[26] = {
-		.name  = "mem:0:rw",
-		.check = test__checkevent_breakpoint_rw,
-	},
-	[27] = {
-		.name  = "mem:0:rw:kp",
-		.check = test__checkevent_breakpoint_rw_modifier,
-	},
-	[28] = {
-		.name  = "{instructions:k,cycles:upp}",
-		.check = test__group1,
-	},
-	[29] = {
-		.name  = "{faults:k,cache-references}:u,cycles:k",
-		.check = test__group2,
-	},
-	[30] = {
-		.name  = "group1{syscalls:sys_enter_open:H,cycles:kppp},group2{cycles,1:3}:G,instructions:u",
-		.check = test__group3,
-	},
-	[31] = {
-		.name  = "{cycles:u,instructions:kp}:p",
-		.check = test__group4,
-	},
-	[32] = {
-		.name  = "{cycles,instructions}:G,{cycles:G,instructions:G},cycles",
-		.check = test__group5,
-	},
-};
-
-static struct test__event_st test__events_pmu[] = {
-	[0] = {
-		.name  = "cpu/config=10,config1,config2=3,period=1000/u",
-		.check = test__checkevent_pmu,
-	},
-	[1] = {
-		.name  = "cpu/config=1,name=krava/u,cpu/config=2/u",
-		.check = test__checkevent_pmu_name,
-	},
-};
-
-struct test__term {
-	const char *str;
-	__u32 type;
-	int (*check)(struct list_head *terms);
-};
-
-static struct test__term test__terms[] = {
-	[0] = {
-		.str   = "config=10,config1,config2=3,umask=1",
-		.check = test__checkterms_simple,
-	},
-};
-
-static int test_event(struct test__event_st *e)
-{
-	struct perf_evlist *evlist;
-	int ret;
-
-	evlist = perf_evlist__new(NULL, NULL);
-	if (evlist == NULL)
-		return -ENOMEM;
-
-	ret = parse_events(evlist, e->name, 0);
-	if (ret) {
-		pr_debug("failed to parse event '%s', err %d\n",
-			 e->name, ret);
-		return ret;
-	}
-
-	ret = e->check(evlist);
-	perf_evlist__delete(evlist);
-
-	return ret;
-}
-
-static int test_events(struct test__event_st *events, unsigned cnt)
-{
-	int ret1, ret2 = 0;
-	unsigned i;
-
-	for (i = 0; i < cnt; i++) {
-		struct test__event_st *e = &events[i];
-
-		pr_debug("running test %d '%s'\n", i, e->name);
-		ret1 = test_event(e);
-		if (ret1)
-			ret2 = ret1;
-	}
-
-	return ret2;
-}
-
-static int test_term(struct test__term *t)
-{
-	struct list_head *terms;
-	int ret;
-
-	terms = malloc(sizeof(*terms));
-	if (!terms)
-		return -ENOMEM;
-
-	INIT_LIST_HEAD(terms);
-
-	ret = parse_events_terms(terms, t->str);
-	if (ret) {
-		pr_debug("failed to parse terms '%s', err %d\n",
-			 t->str , ret);
-		return ret;
-	}
-
-	ret = t->check(terms);
-	parse_events__free_terms(terms);
-
-	return ret;
-}
-
-static int test_terms(struct test__term *terms, unsigned cnt)
-{
-	int ret = 0;
-	unsigned i;
-
-	for (i = 0; i < cnt; i++) {
-		struct test__term *t = &terms[i];
-
-		pr_debug("running test %d '%s'\n", i, t->str);
-		ret = test_term(t);
-		if (ret)
-			break;
-	}
-
-	return ret;
-}
-
-static int test_pmu(void)
-{
-	struct stat st;
-	char path[PATH_MAX];
-	int ret;
-
-	snprintf(path, PATH_MAX, "%s/bus/event_source/devices/cpu/format/",
-		 sysfs_find_mountpoint());
-
-	ret = stat(path, &st);
-	if (ret)
-		pr_debug("omitting PMU cpu tests\n");
-	return !ret;
-}
-
-static int test_pmu_events(void)
-{
-	struct stat st;
-	char path[PATH_MAX];
-	struct dirent *ent;
-	DIR *dir;
-	int ret;
-
-	snprintf(path, PATH_MAX, "%s/bus/event_source/devices/cpu/events/",
-		 sysfs_find_mountpoint());
-
-	ret = stat(path, &st);
-	if (ret) {
-		pr_debug("ommiting PMU cpu events tests\n");
-		return 0;
-	}
-
-	dir = opendir(path);
-	if (!dir) {
-		pr_debug("can't open pmu event dir");
-		return -1;
-	}
-
-	while (!ret && (ent = readdir(dir))) {
-#define MAX_NAME 100
-		struct test__event_st e;
-		char name[MAX_NAME];
-
-		if (!strcmp(ent->d_name, ".") ||
-		    !strcmp(ent->d_name, ".."))
-			continue;
-
-		snprintf(name, MAX_NAME, "cpu/event=%s/u", ent->d_name);
-
-		e.name  = name;
-		e.check = test__checkevent_pmu_events;
-
-		ret = test_event(&e);
-#undef MAX_NAME
-	}
-
-	closedir(dir);
-	return ret;
-}
-
-int parse_events__test(void)
-{
-	int ret1, ret2 = 0;
-
-#define TEST_EVENTS(tests)				\
-do {							\
-	ret1 = test_events(tests, ARRAY_SIZE(tests));	\
-	if (!ret2)					\
-		ret2 = ret1;				\
-} while (0)
-
-	TEST_EVENTS(test__events);
-
-	if (test_pmu())
-		TEST_EVENTS(test__events_pmu);
-
-	if (test_pmu()) {
-		int ret = test_pmu_events();
-		if (ret)
-			return ret;
-	}
-
-	ret1 = test_terms(test__terms, ARRAY_SIZE(test__terms));
-	if (!ret2)
-		ret2 = ret1;
-
-	return ret2;
-}
-- 
1.7.9.2.358.g22243

