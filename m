Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043Ab1DSP4g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 11:56:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36143 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752081Ab1DSP4e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 11:56:34 -0400
Date: Tue, 19 Apr 2011 17:56:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20110419155614.GA915@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-fixes-for-linus

 Thanks,

	Ingo

------------------>
Andre Przywara (1):
      perf, x86: Fix pre-defined cache-misses event for AMD family 15h cpus

Arnaldo Carvalho de Melo (1):
      perf evsel: Fix use of inherit

Lin Ming (1):
      perf hists browser: Fix seg fault when annotate null symbol

Robert Richter (1):
      perf, x86: Fix AMD family 15h FPU event constraints


 arch/x86/kernel/cpu/perf_event_amd.c   |   22 ++++++++++++++++++----
 tools/perf/builtin-record.c            |    7 +++++--
 tools/perf/builtin-stat.c              |    7 ++++---
 tools/perf/builtin-test.c              |   10 +++++-----
 tools/perf/builtin-top.c               |    3 ++-
 tools/perf/util/evlist.c               |   14 ++++++++++----
 tools/perf/util/evsel.c                |   27 +++++++--------------------
 tools/perf/util/evsel.h                |    6 +++---
 tools/perf/util/python.c               |    9 +++++----
 tools/perf/util/ui/browsers/annotate.c |    6 ++++--
 tools/perf/util/ui/browsers/hists.c    |    2 +-
 11 files changed, 64 insertions(+), 49 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index 461f62b..cf4e369 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -8,7 +8,7 @@ static __initconst const u64 amd_hw_cache_event_ids
  [ C(L1D) ] = {
 	[ C(OP_READ) ] = {
 		[ C(RESULT_ACCESS) ] = 0x0040, /* Data Cache Accesses        */
-		[ C(RESULT_MISS)   ] = 0x0041, /* Data Cache Misses          */
+		[ C(RESULT_MISS)   ] = 0x0141, /* Data Cache Misses          */
 	},
 	[ C(OP_WRITE) ] = {
 		[ C(RESULT_ACCESS) ] = 0x0142, /* Data Cache Refills :system */
@@ -427,7 +427,9 @@ static __initconst const struct x86_pmu amd_pmu = {
  *
  * Exceptions:
  *
+ * 0x000	FP	PERF_CTL[3], PERF_CTL[5:3] (*)
  * 0x003	FP	PERF_CTL[3]
+ * 0x004	FP	PERF_CTL[3], PERF_CTL[5:3] (*)
  * 0x00B	FP	PERF_CTL[3]
  * 0x00D	FP	PERF_CTL[3]
  * 0x023	DE	PERF_CTL[2:0]
@@ -448,6 +450,8 @@ static __initconst const struct x86_pmu amd_pmu = {
  * 0x0DF	LS	PERF_CTL[5:0]
  * 0x1D6	EX	PERF_CTL[5:0]
  * 0x1D8	EX	PERF_CTL[5:0]
+ *
+ * (*) depending on the umask all FPU counters may be used
  */
 
 static struct event_constraint amd_f15_PMC0  = EVENT_CONSTRAINT(0, 0x01, 0);
@@ -460,18 +464,28 @@ static struct event_constraint amd_f15_PMC53 = EVENT_CONSTRAINT(0, 0x38, 0);
 static struct event_constraint *
 amd_get_event_constraints_f15h(struct cpu_hw_events *cpuc, struct perf_event *event)
 {
-	unsigned int event_code = amd_get_event_code(&event->hw);
+	struct hw_perf_event *hwc = &event->hw;
+	unsigned int event_code = amd_get_event_code(hwc);
 
 	switch (event_code & AMD_EVENT_TYPE_MASK) {
 	case AMD_EVENT_FP:
 		switch (event_code) {
+		case 0x000:
+			if (!(hwc->config & 0x0000F000ULL))
+				break;
+			if (!(hwc->config & 0x00000F00ULL))
+				break;
+			return &amd_f15_PMC3;
+		case 0x004:
+			if (hweight_long(hwc->config & ARCH_PERFMON_EVENTSEL_UMASK) <= 1)
+				break;
+			return &amd_f15_PMC3;
 		case 0x003:
 		case 0x00B:
 		case 0x00D:
 			return &amd_f15_PMC3;
-		default:
-			return &amd_f15_PMC53;
 		}
+		return &amd_f15_PMC53;
 	case AMD_EVENT_LS:
 	case AMD_EVENT_DC:
 	case AMD_EVENT_EX_LS:
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 17d1dcb..4165382 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -163,6 +163,7 @@ static void config_attr(struct perf_evsel *evsel, struct perf_evlist *evlist)
 	struct perf_event_attr *attr = &evsel->attr;
 	int track = !evsel->idx; /* only the first counter needs these */
 
+	attr->inherit		= !no_inherit;
 	attr->read_format	= PERF_FORMAT_TOTAL_TIME_ENABLED |
 				  PERF_FORMAT_TOTAL_TIME_RUNNING |
 				  PERF_FORMAT_ID;
@@ -251,6 +252,9 @@ static void open_counters(struct perf_evlist *evlist)
 {
 	struct perf_evsel *pos;
 
+	if (evlist->cpus->map[0] < 0)
+		no_inherit = true;
+
 	list_for_each_entry(pos, &evlist->entries, node) {
 		struct perf_event_attr *attr = &pos->attr;
 		/*
@@ -271,8 +275,7 @@ static void open_counters(struct perf_evlist *evlist)
 retry_sample_id:
 		attr->sample_id_all = sample_id_all_avail ? 1 : 0;
 try_again:
-		if (perf_evsel__open(pos, evlist->cpus, evlist->threads, group,
-				     !no_inherit) < 0) {
+		if (perf_evsel__open(pos, evlist->cpus, evlist->threads, group) < 0) {
 			int err = errno;
 
 			if (err == EPERM || err == EACCES) {
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index e2109f9..03f0e45 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -167,16 +167,17 @@ static int create_perf_stat_counter(struct perf_evsel *evsel)
 		attr->read_format = PERF_FORMAT_TOTAL_TIME_ENABLED |
 				    PERF_FORMAT_TOTAL_TIME_RUNNING;
 
+	attr->inherit = !no_inherit;
+
 	if (system_wide)
-		return perf_evsel__open_per_cpu(evsel, evsel_list->cpus, false, false);
+		return perf_evsel__open_per_cpu(evsel, evsel_list->cpus, false);
 
-	attr->inherit = !no_inherit;
 	if (target_pid == -1 && target_tid == -1) {
 		attr->disabled = 1;
 		attr->enable_on_exec = 1;
 	}
 
-	return perf_evsel__open_per_thread(evsel, evsel_list->threads, false, false);
+	return perf_evsel__open_per_thread(evsel, evsel_list->threads, false);
 }
 
 /*
diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 1b2106c..11e3c84 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -290,7 +290,7 @@ static int test__open_syscall_event(void)
 		goto out_thread_map_delete;
 	}
 
-	if (perf_evsel__open_per_thread(evsel, threads, false, false) < 0) {
+	if (perf_evsel__open_per_thread(evsel, threads, false) < 0) {
 		pr_debug("failed to open counter: %s, "
 			 "tweak /proc/sys/kernel/perf_event_paranoid?\n",
 			 strerror(errno));
@@ -303,7 +303,7 @@ static int test__open_syscall_event(void)
 	}
 
 	if (perf_evsel__read_on_cpu(evsel, 0, 0) < 0) {
-		pr_debug("perf_evsel__open_read_on_cpu\n");
+		pr_debug("perf_evsel__read_on_cpu\n");
 		goto out_close_fd;
 	}
 
@@ -365,7 +365,7 @@ static int test__open_syscall_event_on_all_cpus(void)
 		goto out_thread_map_delete;
 	}
 
-	if (perf_evsel__open(evsel, cpus, threads, false, false) < 0) {
+	if (perf_evsel__open(evsel, cpus, threads, false) < 0) {
 		pr_debug("failed to open counter: %s, "
 			 "tweak /proc/sys/kernel/perf_event_paranoid?\n",
 			 strerror(errno));
@@ -418,7 +418,7 @@ static int test__open_syscall_event_on_all_cpus(void)
 			continue;
 
 		if (perf_evsel__read_on_cpu(evsel, cpu, 0) < 0) {
-			pr_debug("perf_evsel__open_read_on_cpu\n");
+			pr_debug("perf_evsel__read_on_cpu\n");
 			err = -1;
 			break;
 		}
@@ -529,7 +529,7 @@ static int test__basic_mmap(void)
 
 		perf_evlist__add(evlist, evsels[i]);
 
-		if (perf_evsel__open(evsels[i], cpus, threads, false, false) < 0) {
+		if (perf_evsel__open(evsels[i], cpus, threads, false) < 0) {
 			pr_debug("failed to open counter: %s, "
 				 "tweak /proc/sys/kernel/perf_event_paranoid?\n",
 				 strerror(errno));
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index fc1273e..7e3d6e3 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -845,9 +845,10 @@ static void start_counters(struct perf_evlist *evlist)
 		}
 
 		attr->mmap = 1;
+		attr->inherit = inherit;
 try_again:
 		if (perf_evsel__open(counter, top.evlist->cpus,
-				     top.evlist->threads, group, inherit) < 0) {
+				     top.evlist->threads, group) < 0) {
 			int err = errno;
 
 			if (err == EPERM || err == EACCES) {
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index d852cef..45da8d1 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -12,6 +12,7 @@
 #include "evlist.h"
 #include "evsel.h"
 #include "util.h"
+#include "debug.h"
 
 #include <sys/mman.h>
 
@@ -250,15 +251,19 @@ int perf_evlist__alloc_mmap(struct perf_evlist *evlist)
 	return evlist->mmap != NULL ? 0 : -ENOMEM;
 }
 
-static int __perf_evlist__mmap(struct perf_evlist *evlist, int cpu, int prot,
-			       int mask, int fd)
+static int __perf_evlist__mmap(struct perf_evlist *evlist, struct perf_evsel *evsel,
+			       int cpu, int prot, int mask, int fd)
 {
 	evlist->mmap[cpu].prev = 0;
 	evlist->mmap[cpu].mask = mask;
 	evlist->mmap[cpu].base = mmap(NULL, evlist->mmap_len, prot,
 				      MAP_SHARED, fd, 0);
-	if (evlist->mmap[cpu].base == MAP_FAILED)
+	if (evlist->mmap[cpu].base == MAP_FAILED) {
+		if (evlist->cpus->map[cpu] == -1 && evsel->attr.inherit)
+			ui__warning("Inherit is not allowed on per-task "
+				    "events using mmap.\n");
 		return -1;
+	}
 
 	perf_evlist__add_pollfd(evlist, fd);
 	return 0;
@@ -312,7 +317,8 @@ int perf_evlist__mmap(struct perf_evlist *evlist, int pages, bool overwrite)
 					if (ioctl(fd, PERF_EVENT_IOC_SET_OUTPUT,
 						  FD(first_evsel, cpu, 0)) != 0)
 						goto out_unmap;
-				} else if (__perf_evlist__mmap(evlist, cpu, prot, mask, fd) < 0)
+				} else if (__perf_evlist__mmap(evlist, evsel, cpu,
+							       prot, mask, fd) < 0)
 					goto out_unmap;
 
 				if ((evsel->attr.read_format & PERF_FORMAT_ID) &&
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 662596a..d6fd59b 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -175,7 +175,7 @@ int __perf_evsel__read(struct perf_evsel *evsel,
 }
 
 static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
-			      struct thread_map *threads, bool group, bool inherit)
+			      struct thread_map *threads, bool group)
 {
 	int cpu, thread;
 	unsigned long flags = 0;
@@ -192,19 +192,6 @@ static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
 
 	for (cpu = 0; cpu < cpus->nr; cpu++) {
 		int group_fd = -1;
-		/*
-		 * Don't allow mmap() of inherited per-task counters. This
-		 * would create a performance issue due to all children writing
-		 * to the same buffer.
-		 *
-		 * FIXME:
-		 * Proper fix is not to pass 'inherit' to perf_evsel__open*,
-		 * but a 'flags' parameter, with 'group' folded there as well,
-		 * then introduce a PERF_O_{MMAP,GROUP,INHERIT} enum, and if
-		 * O_MMAP is set, emit a warning if cpu < 0 and O_INHERIT is
-		 * set. Lets go for the minimal fix first tho.
-		 */
-		evsel->attr.inherit = (cpus->map[cpu] >= 0) && inherit;
 
 		for (thread = 0; thread < threads->nr; thread++) {
 
@@ -253,7 +240,7 @@ static struct {
 };
 
 int perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
-		     struct thread_map *threads, bool group, bool inherit)
+		     struct thread_map *threads, bool group)
 {
 	if (cpus == NULL) {
 		/* Work around old compiler warnings about strict aliasing */
@@ -263,19 +250,19 @@ int perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
 	if (threads == NULL)
 		threads = &empty_thread_map.map;
 
-	return __perf_evsel__open(evsel, cpus, threads, group, inherit);
+	return __perf_evsel__open(evsel, cpus, threads, group);
 }
 
 int perf_evsel__open_per_cpu(struct perf_evsel *evsel,
-			     struct cpu_map *cpus, bool group, bool inherit)
+			     struct cpu_map *cpus, bool group)
 {
-	return __perf_evsel__open(evsel, cpus, &empty_thread_map.map, group, inherit);
+	return __perf_evsel__open(evsel, cpus, &empty_thread_map.map, group);
 }
 
 int perf_evsel__open_per_thread(struct perf_evsel *evsel,
-				struct thread_map *threads, bool group, bool inherit)
+				struct thread_map *threads, bool group)
 {
-	return __perf_evsel__open(evsel, &empty_cpu_map.map, threads, group, inherit);
+	return __perf_evsel__open(evsel, &empty_cpu_map.map, threads, group);
 }
 
 static int perf_event__parse_id_sample(const union perf_event *event, u64 type,
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 6710ab5..f79bb2c 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -81,11 +81,11 @@ void perf_evsel__free_id(struct perf_evsel *evsel);
 void perf_evsel__close_fd(struct perf_evsel *evsel, int ncpus, int nthreads);
 
 int perf_evsel__open_per_cpu(struct perf_evsel *evsel,
-			     struct cpu_map *cpus, bool group, bool inherit);
+			     struct cpu_map *cpus, bool group);
 int perf_evsel__open_per_thread(struct perf_evsel *evsel,
-				struct thread_map *threads, bool group, bool inherit);
+				struct thread_map *threads, bool group);
 int perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
-		     struct thread_map *threads, bool group, bool inherit);
+		     struct thread_map *threads, bool group);
 
 #define perf_evsel__match(evsel, t, c)		\
 	(evsel->attr.type == PERF_TYPE_##t &&	\
diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index a9f2d7e..f5e3845 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -498,11 +498,11 @@ static PyObject *pyrf_evsel__open(struct pyrf_evsel *pevsel,
 	struct cpu_map *cpus = NULL;
 	struct thread_map *threads = NULL;
 	PyObject *pcpus = NULL, *pthreads = NULL;
-	int group = 0, overwrite = 0;
-	static char *kwlist[] = {"cpus", "threads", "group", "overwrite", NULL, NULL};
+	int group = 0, inherit = 0;
+	static char *kwlist[] = {"cpus", "threads", "group", "inherit", NULL, NULL};
 
 	if (!PyArg_ParseTupleAndKeywords(args, kwargs, "|OOii", kwlist,
-					 &pcpus, &pthreads, &group, &overwrite))
+					 &pcpus, &pthreads, &group, &inherit))
 		return NULL;
 
 	if (pthreads != NULL)
@@ -511,7 +511,8 @@ static PyObject *pyrf_evsel__open(struct pyrf_evsel *pevsel,
 	if (pcpus != NULL)
 		cpus = ((struct pyrf_cpu_map *)pcpus)->cpus;
 
-	if (perf_evsel__open(evsel, cpus, threads, group, overwrite) < 0) {
+	evsel->attr.inherit = inherit;
+	if (perf_evsel__open(evsel, cpus, threads, group) < 0) {
 		PyErr_SetFromErrno(PyExc_OSError);
 		return NULL;
 	}
diff --git a/tools/perf/util/ui/browsers/annotate.c b/tools/perf/util/ui/browsers/annotate.c
index 8c17a87..15633d6 100644
--- a/tools/perf/util/ui/browsers/annotate.c
+++ b/tools/perf/util/ui/browsers/annotate.c
@@ -256,10 +256,9 @@ int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
 			 int refresh)
 {
 	struct objdump_line *pos, *n;
-	struct annotation *notes = symbol__annotation(sym);
+	struct annotation *notes;
 	struct annotate_browser browser = {
 		.b = {
-			.entries = &notes->src->source,
 			.refresh = ui_browser__list_head_refresh,
 			.seek	 = ui_browser__list_head_seek,
 			.write	 = annotate_browser__write,
@@ -281,6 +280,8 @@ int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
 
 	ui_helpline__push("Press <- or ESC to exit");
 
+	notes = symbol__annotation(sym);
+
 	list_for_each_entry(pos, &notes->src->source, node) {
 		struct objdump_line_rb_node *rbpos;
 		size_t line_len = strlen(pos->line);
@@ -291,6 +292,7 @@ int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
 		rbpos->idx = browser.b.nr_entries++;
 	}
 
+	browser.b.entries = &notes->src->source,
 	browser.b.width += 18; /* Percentage */
 	ret = annotate_browser__run(&browser, evidx, refresh);
 	list_for_each_entry_safe(pos, n, &notes->src->source, node) {
diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index 798efdc..5d767c6 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -851,7 +851,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel,
 			goto out_free_stack;
 		case 'a':
 			if (browser->selection == NULL ||
-			    browser->selection->map == NULL ||
+			    browser->selection->sym == NULL ||
 			    browser->selection->map->dso->annotate_warned)
 				continue;
 			goto do_annotate;
