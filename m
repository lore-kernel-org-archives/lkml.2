Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510Ab2JHWkT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 18:40:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:41347 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213Ab2JHWdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 18:33:09 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 17/25] perf machine: Carve up event processing specific from perf_tool
Date: Mon,  8 Oct 2012 19:32:42 -0300
Message-Id: <1349735570-19339-18-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1349735570-19339-1-git-send-email-acme@infradead.org>
References: <1349735570-19339-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

The perf_tool vtable expects methods that receive perf_tool and
perf_sample entries, but for tools not interested in doing any special
processing on non PERF_RECORD_SAMPLE events, like 'perf top', and for
those not using perf_session, like 'perf trace', they were using
perf_event__process passing tool and sample paramenters that were just
not used.

Provide 'machine' methods for this purpose and make the perf_event
ones use them.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-ot9cc6mt025o8kbngzckcrx9@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c  |    3 +-
 tools/perf/util/event.c   |  211 +++----------------------------------------
 tools/perf/util/machine.c |  220 +++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/machine.h |    8 ++
 4 files changed, 242 insertions(+), 200 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index ff6db80..fb9da71 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -26,6 +26,7 @@
 #include "util/color.h"
 #include "util/evlist.h"
 #include "util/evsel.h"
+#include "util/machine.h"
 #include "util/session.h"
 #include "util/symbol.h"
 #include "util/thread.h"
@@ -871,7 +872,7 @@ static void perf_top__mmap_read_idx(struct perf_top *top, int idx)
 						   &sample, machine);
 		} else if (event->header.type < PERF_RECORD_MAX) {
 			hists__inc_nr_events(&evsel->hists, event->header.type);
-			perf_event__process(&top->tool, event, &sample, machine);
+			machine__process_event(machine, event);
 		} else
 			++session->hists.stats.nr_unknown_events;
 	}
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index eaaee22..0ae444e 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -520,134 +520,15 @@ int perf_event__process_comm(struct perf_tool *tool __maybe_unused,
 			     struct perf_sample *sample __maybe_unused,
 			     struct machine *machine)
 {
-	struct thread *thread = machine__findnew_thread(machine, event->comm.tid);
-
-	if (dump_trace)
-		perf_event__fprintf_comm(event, stdout);
-
-	if (thread == NULL || thread__set_comm(thread, event->comm.comm)) {
-		dump_printf("problem processing PERF_RECORD_COMM, skipping event.\n");
-		return -1;
-	}
-
-	return 0;
+	return machine__process_comm_event(machine, event);
 }
 
 int perf_event__process_lost(struct perf_tool *tool __maybe_unused,
 			     union perf_event *event,
 			     struct perf_sample *sample __maybe_unused,
-			     struct machine *machine __maybe_unused)
-{
-	dump_printf(": id:%" PRIu64 ": lost:%" PRIu64 "\n",
-		    event->lost.id, event->lost.lost);
-	return 0;
-}
-
-static void perf_event__set_kernel_mmap_len(union perf_event *event,
-					    struct map **maps)
-{
-	maps[MAP__FUNCTION]->start = event->mmap.start;
-	maps[MAP__FUNCTION]->end   = event->mmap.start + event->mmap.len;
-	/*
-	 * Be a bit paranoid here, some perf.data file came with
-	 * a zero sized synthesized MMAP event for the kernel.
-	 */
-	if (maps[MAP__FUNCTION]->end == 0)
-		maps[MAP__FUNCTION]->end = ~0ULL;
-}
-
-static int perf_event__process_kernel_mmap(struct perf_tool *tool
-					   __maybe_unused,
-					   union perf_event *event,
-					   struct machine *machine)
+			     struct machine *machine)
 {
-	struct map *map;
-	char kmmap_prefix[PATH_MAX];
-	enum dso_kernel_type kernel_type;
-	bool is_kernel_mmap;
-
-	machine__mmap_name(machine, kmmap_prefix, sizeof(kmmap_prefix));
-	if (machine__is_host(machine))
-		kernel_type = DSO_TYPE_KERNEL;
-	else
-		kernel_type = DSO_TYPE_GUEST_KERNEL;
-
-	is_kernel_mmap = memcmp(event->mmap.filename,
-				kmmap_prefix,
-				strlen(kmmap_prefix) - 1) == 0;
-	if (event->mmap.filename[0] == '/' ||
-	    (!is_kernel_mmap && event->mmap.filename[0] == '[')) {
-
-		char short_module_name[1024];
-		char *name, *dot;
-
-		if (event->mmap.filename[0] == '/') {
-			name = strrchr(event->mmap.filename, '/');
-			if (name == NULL)
-				goto out_problem;
-
-			++name; /* skip / */
-			dot = strrchr(name, '.');
-			if (dot == NULL)
-				goto out_problem;
-			snprintf(short_module_name, sizeof(short_module_name),
-					"[%.*s]", (int)(dot - name), name);
-			strxfrchar(short_module_name, '-', '_');
-		} else
-			strcpy(short_module_name, event->mmap.filename);
-
-		map = machine__new_module(machine, event->mmap.start,
-					  event->mmap.filename);
-		if (map == NULL)
-			goto out_problem;
-
-		name = strdup(short_module_name);
-		if (name == NULL)
-			goto out_problem;
-
-		map->dso->short_name = name;
-		map->dso->sname_alloc = 1;
-		map->end = map->start + event->mmap.len;
-	} else if (is_kernel_mmap) {
-		const char *symbol_name = (event->mmap.filename +
-				strlen(kmmap_prefix));
-		/*
-		 * Should be there already, from the build-id table in
-		 * the header.
-		 */
-		struct dso *kernel = __dsos__findnew(&machine->kernel_dsos,
-						     kmmap_prefix);
-		if (kernel == NULL)
-			goto out_problem;
-
-		kernel->kernel = kernel_type;
-		if (__machine__create_kernel_maps(machine, kernel) < 0)
-			goto out_problem;
-
-		perf_event__set_kernel_mmap_len(event, machine->vmlinux_maps);
-
-		/*
-		 * Avoid using a zero address (kptr_restrict) for the ref reloc
-		 * symbol. Effectively having zero here means that at record
-		 * time /proc/sys/kernel/kptr_restrict was non zero.
-		 */
-		if (event->mmap.pgoff != 0) {
-			maps__set_kallsyms_ref_reloc_sym(machine->vmlinux_maps,
-							 symbol_name,
-							 event->mmap.pgoff);
-		}
-
-		if (machine__is_default_guest(machine)) {
-			/*
-			 * preload dso of guest kernel and modules
-			 */
-			dso__load(kernel, machine->vmlinux_maps[MAP__FUNCTION],
-				  NULL);
-		}
-	}
-	return 0;
-out_problem:
-	return -1;
+	return machine__process_lost_event(machine, event);
 }
 
 size_t perf_event__fprintf_mmap(union perf_event *event, FILE *fp)
@@ -657,43 +538,12 @@ size_t perf_event__fprintf_mmap(union perf_event *event, FILE *fp)
 		       event->mmap.len, event->mmap.pgoff, event->mmap.filename);
 }
 
-int perf_event__process_mmap(struct perf_tool *tool,
+int perf_event__process_mmap(struct perf_tool *tool __maybe_unused,
 			     union perf_event *event,
 			     struct perf_sample *sample __maybe_unused,
 			     struct machine *machine)
 {
-	struct thread *thread;
-	struct map *map;
-	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
-	int ret = 0;
-
-	if (dump_trace)
-		perf_event__fprintf_mmap(event, stdout);
-
-	if (cpumode == PERF_RECORD_MISC_GUEST_KERNEL ||
-	    cpumode == PERF_RECORD_MISC_KERNEL) {
-		ret = perf_event__process_kernel_mmap(tool, event, machine);
-		if (ret < 0)
-			goto out_problem;
-		return 0;
-	}
-
-	thread = machine__findnew_thread(machine, event->mmap.pid);
-	if (thread == NULL)
-		goto out_problem;
-	map = map__new(&machine->user_dsos, event->mmap.start,
-			event->mmap.len, event->mmap.pgoff,
-			event->mmap.pid, event->mmap.filename,
-			MAP__FUNCTION);
-	if (map == NULL)
-		goto out_problem;
-
-	thread__insert_map(thread, map);
-	return 0;
-
-out_problem:
-	dump_printf("problem processing PERF_RECORD_MMAP, skipping event.\n");
-	return 0;
+	return machine__process_mmap_event(machine, event);
 }
 
 size_t perf_event__fprintf_task(union perf_event *event, FILE *fp)
@@ -708,19 +558,7 @@ int perf_event__process_fork(struct perf_tool *tool __maybe_unused,
 			     struct perf_sample *sample __maybe_unused,
 			     struct machine *machine)
 {
-	struct thread *thread = machine__findnew_thread(machine, event->fork.tid);
-	struct thread *parent = machine__findnew_thread(machine, event->fork.ptid);
-
-	if (dump_trace)
-		perf_event__fprintf_task(event, stdout);
-
-	if (thread == NULL || parent == NULL ||
-	    thread__fork(thread, parent) < 0) {
-		dump_printf("problem processing PERF_RECORD_FORK, skipping event.\n");
-		return -1;
-	}
-
-	return 0;
+	return machine__process_fork_event(machine, event);
 }
 
 int perf_event__process_exit(struct perf_tool *tool __maybe_unused,
@@ -728,15 +566,7 @@ int perf_event__process_exit(struct perf_tool *tool __maybe_unused,
 			     struct perf_sample *sample __maybe_unused,
 			     struct machine *machine)
 {
-	struct thread *thread = machine__find_thread(machine, event->fork.tid);
-
-	if (dump_trace)
-		perf_event__fprintf_task(event, stdout);
-
-	if (thread != NULL)
-		machine__remove_thread(machine, thread);
-
-	return 0;
+	return machine__process_exit_event(machine, event);
 }
 
 size_t perf_event__fprintf(union perf_event *event, FILE *fp)
@@ -762,29 +592,12 @@ size_t perf_event__fprintf(union perf_event *event, FILE *fp)
 	return ret;
 }
 
-int perf_event__process(struct perf_tool *tool, union perf_event *event,
-			struct perf_sample *sample, struct machine *machine)
+int perf_event__process(struct perf_tool *tool __maybe_unused,
+			union perf_event *event,
+			struct perf_sample *sample __maybe_unused,
+			struct machine *machine)
 {
-	switch (event->header.type) {
-	case PERF_RECORD_COMM:
-		perf_event__process_comm(tool, event, sample, machine);
-		break;
-	case PERF_RECORD_MMAP:
-		perf_event__process_mmap(tool, event, sample, machine);
-		break;
-	case PERF_RECORD_FORK:
-		perf_event__process_fork(tool, event, sample, machine);
-		break;
-	case PERF_RECORD_EXIT:
-		perf_event__process_exit(tool, event, sample, machine);
-		break;
-	case PERF_RECORD_LOST:
-		perf_event__process_lost(tool, event, sample, machine);
-	default:
-		break;
-	}
-
-	return 0;
+	return machine__process_event(machine, event);
 }
 
 void thread__find_addr_map(struct thread *self,
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 9d36d7e..502eec0 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1,3 +1,5 @@
+#include "debug.h"
+#include "event.h"
 #include "machine.h"
 #include "map.h"
 #include "thread.h"
@@ -55,3 +57,221 @@ struct thread *machine__find_thread(struct machine *machine, pid_t pid)
 {
 	return __machine__findnew_thread(machine, pid, false);
 }
+
+int machine__process_comm_event(struct machine *machine, union perf_event *event)
+{
+	struct thread *thread = machine__findnew_thread(machine, event->comm.tid);
+
+	if (dump_trace)
+		perf_event__fprintf_comm(event, stdout);
+
+	if (thread == NULL || thread__set_comm(thread, event->comm.comm)) {
+		dump_printf("problem processing PERF_RECORD_COMM, skipping event.\n");
+		return -1;
+	}
+
+	return 0;
+}
+
+int machine__process_lost_event(struct machine *machine __maybe_unused,
+				union perf_event *event)
+{
+	dump_printf(": id:%" PRIu64 ": lost:%" PRIu64 "\n",
+		    event->lost.id, event->lost.lost);
+	return 0;
+}
+
+static void machine__set_kernel_mmap_len(struct machine *machine,
+					 union perf_event *event)
+{
+	machine->vmlinux_maps[MAP__FUNCTION]->start = event->mmap.start;
+	machine->vmlinux_maps[MAP__FUNCTION]->end   = (event->mmap.start +
+						       event->mmap.len);
+	/*
+	 * Be a bit paranoid here, some perf.data file came with
+	 * a zero sized synthesized MMAP event for the kernel.
+	 */
+	if (machine->vmlinux_maps[MAP__FUNCTION]->end == 0)
+		machine->vmlinux_maps[MAP__FUNCTION]->end = ~0ULL;
+}
+
+static int machine__process_kernel_mmap_event(struct machine *machine,
+					      union perf_event *event)
+{
+	struct map *map;
+	char kmmap_prefix[PATH_MAX];
+	enum dso_kernel_type kernel_type;
+	bool is_kernel_mmap;
+
+	machine__mmap_name(machine, kmmap_prefix, sizeof(kmmap_prefix));
+	if (machine__is_host(machine))
+		kernel_type = DSO_TYPE_KERNEL;
+	else
+		kernel_type = DSO_TYPE_GUEST_KERNEL;
+
+	is_kernel_mmap = memcmp(event->mmap.filename,
+				kmmap_prefix,
+				strlen(kmmap_prefix) - 1) == 0;
+	if (event->mmap.filename[0] == '/' ||
+	    (!is_kernel_mmap && event->mmap.filename[0] == '[')) {
+
+		char short_module_name[1024];
+		char *name, *dot;
+
+		if (event->mmap.filename[0] == '/') {
+			name = strrchr(event->mmap.filename, '/');
+			if (name == NULL)
+				goto out_problem;
+
+			++name; /* skip / */
+			dot = strrchr(name, '.');
+			if (dot == NULL)
+				goto out_problem;
+			snprintf(short_module_name, sizeof(short_module_name),
+					"[%.*s]", (int)(dot - name), name);
+			strxfrchar(short_module_name, '-', '_');
+		} else
+			strcpy(short_module_name, event->mmap.filename);
+
+		map = machine__new_module(machine, event->mmap.start,
+					  event->mmap.filename);
+		if (map == NULL)
+			goto out_problem;
+
+		name = strdup(short_module_name);
+		if (name == NULL)
+			goto out_problem;
+
+		map->dso->short_name = name;
+		map->dso->sname_alloc = 1;
+		map->end = map->start + event->mmap.len;
+	} else if (is_kernel_mmap) {
+		const char *symbol_name = (event->mmap.filename +
+				strlen(kmmap_prefix));
+		/*
+		 * Should be there already, from the build-id table in
+		 * the header.
+		 */
+		struct dso *kernel = __dsos__findnew(&machine->kernel_dsos,
+						     kmmap_prefix);
+		if (kernel == NULL)
+			goto out_problem;
+
+		kernel->kernel = kernel_type;
+		if (__machine__create_kernel_maps(machine, kernel) < 0)
+			goto out_problem;
+
+		machine__set_kernel_mmap_len(machine, event);
+
+		/*
+		 * Avoid using a zero address (kptr_restrict) for the ref reloc
+		 * symbol. Effectively having zero here means that at record
+		 * time /proc/sys/kernel/kptr_restrict was non zero.
+		 */
+		if (event->mmap.pgoff != 0) {
+			maps__set_kallsyms_ref_reloc_sym(machine->vmlinux_maps,
+							 symbol_name,
+							 event->mmap.pgoff);
+		}
+
+		if (machine__is_default_guest(machine)) {
+			/*
+			 * preload dso of guest kernel and modules
+			 */
+			dso__load(kernel, machine->vmlinux_maps[MAP__FUNCTION],
+				  NULL);
+		}
+	}
+	return 0;
+out_problem:
+	return -1;
+}
+
+int machine__process_mmap_event(struct machine *machine, union perf_event *event)
+{
+	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
+	struct thread *thread;
+	struct map *map;
+	int ret = 0;
+
+	if (dump_trace)
+		perf_event__fprintf_mmap(event, stdout);
+
+	if (cpumode == PERF_RECORD_MISC_GUEST_KERNEL ||
+	    cpumode == PERF_RECORD_MISC_KERNEL) {
+		ret = machine__process_kernel_mmap_event(machine, event);
+		if (ret < 0)
+			goto out_problem;
+		return 0;
+	}
+
+	thread = machine__findnew_thread(machine, event->mmap.pid);
+	if (thread == NULL)
+		goto out_problem;
+	map = map__new(&machine->user_dsos, event->mmap.start,
+			event->mmap.len, event->mmap.pgoff,
+			event->mmap.pid, event->mmap.filename,
+			MAP__FUNCTION);
+	if (map == NULL)
+		goto out_problem;
+
+	thread__insert_map(thread, map);
+	return 0;
+
+out_problem:
+	dump_printf("problem processing PERF_RECORD_MMAP, skipping event.\n");
+	return 0;
+}
+
+int machine__process_fork_event(struct machine *machine, union perf_event *event)
+{
+	struct thread *thread = machine__findnew_thread(machine, event->fork.tid);
+	struct thread *parent = machine__findnew_thread(machine, event->fork.ptid);
+
+	if (dump_trace)
+		perf_event__fprintf_task(event, stdout);
+
+	if (thread == NULL || parent == NULL ||
+	    thread__fork(thread, parent) < 0) {
+		dump_printf("problem processing PERF_RECORD_FORK, skipping event.\n");
+		return -1;
+	}
+
+	return 0;
+}
+
+int machine__process_exit_event(struct machine *machine, union perf_event *event)
+{
+	struct thread *thread = machine__find_thread(machine, event->fork.tid);
+
+	if (dump_trace)
+		perf_event__fprintf_task(event, stdout);
+
+	if (thread != NULL)
+		machine__remove_thread(machine, thread);
+
+	return 0;
+}
+
+int machine__process_event(struct machine *machine, union perf_event *event)
+{
+	int ret;
+
+	switch (event->header.type) {
+	case PERF_RECORD_COMM:
+		ret = machine__process_comm_event(machine, event); break;
+	case PERF_RECORD_MMAP:
+		ret = machine__process_mmap_event(machine, event); break;
+	case PERF_RECORD_FORK:
+		ret = machine__process_fork_event(machine, event); break;
+	case PERF_RECORD_EXIT:
+		ret = machine__process_exit_event(machine, event); break;
+	case PERF_RECORD_LOST:
+		ret = machine__process_lost_event(machine, event); break;
+	default:
+		ret = -1;
+		break;
+	}
+
+	return ret;
+}
diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h
index 54df0cd..df152f1 100644
--- a/tools/perf/util/machine.h
+++ b/tools/perf/util/machine.h
@@ -5,7 +5,15 @@
 
 struct thread;
 struct machine;
+union perf_event;
 
 struct thread *machine__find_thread(struct machine *machine, pid_t pid);
 
+int machine__process_comm_event(struct machine *machine, union perf_event *event);
+int machine__process_exit_event(struct machine *machine, union perf_event *event);
+int machine__process_fork_event(struct machine *machine, union perf_event *event);
+int machine__process_lost_event(struct machine *machine, union perf_event *event);
+int machine__process_mmap_event(struct machine *machine, union perf_event *event);
+int machine__process_event(struct machine *machine, union perf_event *event);
+
 #endif /* __PERF_MACHINE_H */
-- 
1.7.9.2.358.g22243

