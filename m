Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054Ab1BGPCl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 10:02:41 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:58870 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753603Ab1BGPAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 10:00:20 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Kyle McMartin <kyle@mcmartin.ca>,
        Ingo Molnar <mingo@redhat.com>, Kyle McMartin <kyle@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 8/9] perf tool: Fix gcc 4.6.0 issues
Date: Mon,  7 Feb 2011 13:00:11 -0200
Message-Id: <1297090812-10782-9-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1297090812-10782-1-git-send-email-acme@infradead.org>
References: <1297090812-10782-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyle McMartin <kyle@mcmartin.ca>

GCC 4.6.0 in Fedora rawhide turned up some compile errors in tools/perf
due to the -Werror=unused-but-set-variable flag.

I've gone through and annotated some of the assignments that had side
effects (ie: return value from a function) with the __used annotation,
and in some cases, just removed unused code.

In a few cases, we were assigning something useful, but not using it in
later parts of the function.

kyle@dreadnought:~/src% gcc --version
gcc (GCC) 4.6.0 20110122 (Red Hat 4.6.0-0.3)

Cc: Ingo Molnar <mingo@redhat.com>
LKML-Reference: <20110124161304.GK27353@bombadil.infradead.org>
Signed-off-by: Kyle McMartin <kyle@redhat.com>
[ committer note: Fixed up the annotation fixes, as that code moved recently ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/bench/sched-pipe.c                      |    2 +-
 tools/perf/builtin-sched.c                         |   12 +++---------
 tools/perf/builtin-top.c                           |    2 +-
 tools/perf/util/annotate.c                         |    3 ---
 tools/perf/util/header.c                           |    2 +-
 .../util/scripting-engines/trace-event-python.c    |    3 +--
 tools/perf/util/symbol.c                           |    4 ++--
 tools/perf/util/trace-event-parse.c                |    2 +-
 tools/perf/util/ui/browsers/map.c                  |    2 +-
 9 files changed, 11 insertions(+), 21 deletions(-)

diff --git a/tools/perf/bench/sched-pipe.c b/tools/perf/bench/sched-pipe.c
index d9ab3ce..0c7454f 100644
--- a/tools/perf/bench/sched-pipe.c
+++ b/tools/perf/bench/sched-pipe.c
@@ -55,7 +55,7 @@ int bench_sched_pipe(int argc, const char **argv,
 	 * discarding returned value of read(), write()
 	 * causes error in building environment for perf
 	 */
-	int ret, wait_stat;
+	int __used ret, wait_stat;
 	pid_t pid, retpid;
 
 	argc = parse_options(argc, argv, options,
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index ae26211..a32f411 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -369,11 +369,6 @@ static void
 process_sched_event(struct task_desc *this_task __used, struct sched_atom *atom)
 {
 	int ret = 0;
-	u64 now;
-	long long delta;
-
-	now = get_nsecs();
-	delta = start_time + atom->timestamp - now;
 
 	switch (atom->type) {
 		case SCHED_EVENT_RUN:
@@ -562,7 +557,7 @@ static void wait_for_tasks(void)
 
 static void run_one_test(void)
 {
-	u64 T0, T1, delta, avg_delta, fluct, std_dev;
+	u64 T0, T1, delta, avg_delta, fluct;
 
 	T0 = get_nsecs();
 	wait_for_tasks();
@@ -578,7 +573,6 @@ static void run_one_test(void)
 	else
 		fluct = delta - avg_delta;
 	sum_fluct += fluct;
-	std_dev = sum_fluct / nr_runs / sqrt(nr_runs);
 	if (!run_avg)
 		run_avg = delta;
 	run_avg = (run_avg*9 + delta)/10;
@@ -799,7 +793,7 @@ replay_switch_event(struct trace_switch_event *switch_event,
 		    u64 timestamp,
 		    struct thread *thread __used)
 {
-	struct task_desc *prev, *next;
+	struct task_desc *prev, __used *next;
 	u64 timestamp0;
 	s64 delta;
 
@@ -1404,7 +1398,7 @@ map_switch_event(struct trace_switch_event *switch_event,
 		 u64 timestamp,
 		 struct thread *thread __used)
 {
-	struct thread *sched_out, *sched_in;
+	struct thread *sched_out __used, *sched_in;
 	int new_shortname;
 	u64 timestamp0;
 	s64 delta;
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 716118a..b790673 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -865,7 +865,7 @@ static int __cmd_top(void)
 {
 	pthread_t thread;
 	struct perf_evsel *first;
-	int ret;
+	int ret __used;
 	/*
 	 * FIXME: perf_session__new should allow passing a O_MMAP, so that all this
 	 * mmap reading, etc is encapsulated in it. Use O_WRONLY for now.
diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 2973376..1012841 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -236,7 +236,6 @@ int symbol__annotate(struct symbol *sym, struct map *map,
 	char command[PATH_MAX * 2];
 	FILE *file;
 	int err = 0;
-	u64 len;
 	char symfs_filename[PATH_MAX];
 
 	if (filename) {
@@ -281,8 +280,6 @@ fallback:
 		 filename, sym->name, map->unmap_ip(map, sym->start),
 		 map->unmap_ip(map, sym->end));
 
-	len = sym->end - sym->start;
-
 	pr_debug("annotating [%p] %30s : [%p] %30s\n",
 		 dso, dso->long_name, sym, sym->name);
 
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index c0de5ec..72c124d 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1145,7 +1145,7 @@ int perf_event__synthesize_tracing_data(int fd, struct perf_evlist *evlist,
 {
 	union perf_event ev;
 	ssize_t size = 0, aligned_size = 0, padding;
-	int err = 0;
+	int err __used = 0;
 
 	memset(&ev, 0, sizeof(ev));
 
diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index c6d9933..2040b85 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -248,8 +248,7 @@ static void python_process_event(int cpu, void *data,
 	context = PyCObject_FromVoidPtr(scripting_context, NULL);
 
 	PyTuple_SetItem(t, n++, PyString_FromString(handler_name));
-	PyTuple_SetItem(t, n++,
-			PyCObject_FromVoidPtr(scripting_context, NULL));
+	PyTuple_SetItem(t, n++, context);
 
 	if (handler) {
 		PyTuple_SetItem(t, n++, PyInt_FromLong(cpu));
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 7821d0e..3e193f8 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1525,8 +1525,8 @@ int dso__load(struct dso *self, struct map *map, symbol_filter_t filter)
 			     symbol_conf.symfs, self->long_name);
 			break;
 		case DSO__ORIG_GUEST_KMODULE:
-			if (map->groups && map->groups->machine)
-				root_dir = map->groups->machine->root_dir;
+			if (map->groups && machine)
+				root_dir = machine->root_dir;
 			else
 				root_dir = "";
 			snprintf(name, size, "%s%s%s", symbol_conf.symfs,
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 73a0222..d8e622d 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -153,7 +153,7 @@ void parse_proc_kallsyms(char *file, unsigned int size __unused)
 	char *next = NULL;
 	char *addr_str;
 	char ch;
-	int ret;
+	int ret __used;
 	int i;
 
 	line = strtok_r(file, "\n", &next);
diff --git a/tools/perf/util/ui/browsers/map.c b/tools/perf/util/ui/browsers/map.c
index e515836..8462bff 100644
--- a/tools/perf/util/ui/browsers/map.c
+++ b/tools/perf/util/ui/browsers/map.c
@@ -41,7 +41,7 @@ static int ui_entry__read(const char *title, char *bf, size_t size, int width)
 out_free_form:
 	newtPopWindow();
 	newtFormDestroy(form);
-	return 0;
+	return err;
 }
 
 struct map_browser {
-- 
1.6.2.5

