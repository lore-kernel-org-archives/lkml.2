Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932460Ab1EQWIM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 18:08:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57148 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932389Ab1EQWIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 18:08:09 -0400
Date: Wed, 18 May 2011 00:07:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20110517220752.GA31442@elte.hu>
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
Arnaldo Carvalho de Melo (2):
      perf tools: Honour the cpu list parameter when also monitoring a thread list
      perf evlist: Fix per thread mmap setup

Jiri Olsa (1):
      kprobes, x86: Disable irqs during optimized callback


 arch/x86/kernel/kprobes.c   |    5 +-
 tools/perf/builtin-record.c |    2 +-
 tools/perf/builtin-test.c   |    2 +-
 tools/perf/builtin-top.c    |    8 +-
 tools/perf/util/evlist.c    |  153 ++++++++++++++++++++++++++++++-------------
 tools/perf/util/evlist.h    |    3 +-
 tools/perf/util/python.c    |    2 +-
 7 files changed, 119 insertions(+), 56 deletions(-)

diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index c969fd9..f1a6244 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -1183,12 +1183,13 @@ static void __kprobes optimized_callback(struct optimized_kprobe *op,
 					 struct pt_regs *regs)
 {
 	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
+	unsigned long flags;
 
 	/* This is possible if op is under delayed unoptimizing */
 	if (kprobe_disabled(&op->kp))
 		return;
 
-	preempt_disable();
+	local_irq_save(flags);
 	if (kprobe_running()) {
 		kprobes_inc_nmissed_count(&op->kp);
 	} else {
@@ -1207,7 +1208,7 @@ static void __kprobes optimized_callback(struct optimized_kprobe *op,
 		opt_pre_handler(&op->kp, regs);
 		__this_cpu_write(current_kprobe, NULL);
 	}
-	preempt_enable_no_resched();
+	local_irq_restore(flags);
 }
 
 static int __kprobes copy_optimized_instructions(u8 *dest, u8 *src)
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 4165382..0974f95 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -427,7 +427,7 @@ static void mmap_read_all(void)
 {
 	int i;
 
-	for (i = 0; i < evsel_list->cpus->nr; i++) {
+	for (i = 0; i < evsel_list->nr_mmaps; i++) {
 		if (evsel_list->mmap[i].base)
 			mmap_read(&evsel_list->mmap[i]);
 	}
diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 11e3c84..2f9a337 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -549,7 +549,7 @@ static int test__basic_mmap(void)
 			++foo;
 		}
 
-	while ((event = perf_evlist__read_on_cpu(evlist, 0)) != NULL) {
+	while ((event = perf_evlist__mmap_read(evlist, 0)) != NULL) {
 		struct perf_sample sample;
 
 		if (event->header.type != PERF_RECORD_SAMPLE) {
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 7e3d6e3..ebfc7cf 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -801,12 +801,12 @@ static void perf_event__process_sample(const union perf_event *event,
 	}
 }
 
-static void perf_session__mmap_read_cpu(struct perf_session *self, int cpu)
+static void perf_session__mmap_read_idx(struct perf_session *self, int idx)
 {
 	struct perf_sample sample;
 	union perf_event *event;
 
-	while ((event = perf_evlist__read_on_cpu(top.evlist, cpu)) != NULL) {
+	while ((event = perf_evlist__mmap_read(top.evlist, idx)) != NULL) {
 		perf_session__parse_sample(self, event, &sample);
 
 		if (event->header.type == PERF_RECORD_SAMPLE)
@@ -820,8 +820,8 @@ static void perf_session__mmap_read(struct perf_session *self)
 {
 	int i;
 
-	for (i = 0; i < top.evlist->cpus->nr; i++)
-		perf_session__mmap_read_cpu(self, i);
+	for (i = 0; i < top.evlist->nr_mmaps; i++)
+		perf_session__mmap_read_idx(self, i);
 }
 
 static void start_counters(struct perf_evlist *evlist)
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 45da8d1..23eb22b 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -166,11 +166,11 @@ struct perf_evsel *perf_evlist__id2evsel(struct perf_evlist *evlist, u64 id)
 	return NULL;
 }
 
-union perf_event *perf_evlist__read_on_cpu(struct perf_evlist *evlist, int cpu)
+union perf_event *perf_evlist__mmap_read(struct perf_evlist *evlist, int idx)
 {
 	/* XXX Move this to perf.c, making it generally available */
 	unsigned int page_size = sysconf(_SC_PAGE_SIZE);
-	struct perf_mmap *md = &evlist->mmap[cpu];
+	struct perf_mmap *md = &evlist->mmap[idx];
 	unsigned int head = perf_mmap__read_head(md);
 	unsigned int old = md->prev;
 	unsigned char *data = md->base + page_size;
@@ -235,31 +235,37 @@ union perf_event *perf_evlist__read_on_cpu(struct perf_evlist *evlist, int cpu)
 
 void perf_evlist__munmap(struct perf_evlist *evlist)
 {
-	int cpu;
+	int i;
 
-	for (cpu = 0; cpu < evlist->cpus->nr; cpu++) {
-		if (evlist->mmap[cpu].base != NULL) {
-			munmap(evlist->mmap[cpu].base, evlist->mmap_len);
-			evlist->mmap[cpu].base = NULL;
+	for (i = 0; i < evlist->nr_mmaps; i++) {
+		if (evlist->mmap[i].base != NULL) {
+			munmap(evlist->mmap[i].base, evlist->mmap_len);
+			evlist->mmap[i].base = NULL;
 		}
 	}
+
+	free(evlist->mmap);
+	evlist->mmap = NULL;
 }
 
 int perf_evlist__alloc_mmap(struct perf_evlist *evlist)
 {
-	evlist->mmap = zalloc(evlist->cpus->nr * sizeof(struct perf_mmap));
+	evlist->nr_mmaps = evlist->cpus->nr;
+	if (evlist->cpus->map[0] == -1)
+		evlist->nr_mmaps = evlist->threads->nr;
+	evlist->mmap = zalloc(evlist->nr_mmaps * sizeof(struct perf_mmap));
 	return evlist->mmap != NULL ? 0 : -ENOMEM;
 }
 
 static int __perf_evlist__mmap(struct perf_evlist *evlist, struct perf_evsel *evsel,
-			       int cpu, int prot, int mask, int fd)
+			       int idx, int prot, int mask, int fd)
 {
-	evlist->mmap[cpu].prev = 0;
-	evlist->mmap[cpu].mask = mask;
-	evlist->mmap[cpu].base = mmap(NULL, evlist->mmap_len, prot,
+	evlist->mmap[idx].prev = 0;
+	evlist->mmap[idx].mask = mask;
+	evlist->mmap[idx].base = mmap(NULL, evlist->mmap_len, prot,
 				      MAP_SHARED, fd, 0);
-	if (evlist->mmap[cpu].base == MAP_FAILED) {
-		if (evlist->cpus->map[cpu] == -1 && evsel->attr.inherit)
+	if (evlist->mmap[idx].base == MAP_FAILED) {
+		if (evlist->cpus->map[idx] == -1 && evsel->attr.inherit)
 			ui__warning("Inherit is not allowed on per-task "
 				    "events using mmap.\n");
 		return -1;
@@ -269,6 +275,86 @@ static int __perf_evlist__mmap(struct perf_evlist *evlist, struct perf_evsel *ev
 	return 0;
 }
 
+static int perf_evlist__mmap_per_cpu(struct perf_evlist *evlist, int prot, int mask)
+{
+	struct perf_evsel *evsel;
+	int cpu, thread;
+
+	for (cpu = 0; cpu < evlist->cpus->nr; cpu++) {
+		int output = -1;
+
+		for (thread = 0; thread < evlist->threads->nr; thread++) {
+			list_for_each_entry(evsel, &evlist->entries, node) {
+				int fd = FD(evsel, cpu, thread);
+
+				if (output == -1) {
+					output = fd;
+					if (__perf_evlist__mmap(evlist, evsel, cpu,
+								prot, mask, output) < 0)
+						goto out_unmap;
+				} else {
+					if (ioctl(fd, PERF_EVENT_IOC_SET_OUTPUT, output) != 0)
+						goto out_unmap;
+				}
+
+				if ((evsel->attr.read_format & PERF_FORMAT_ID) &&
+				    perf_evlist__id_add_fd(evlist, evsel, cpu, thread, fd) < 0)
+					goto out_unmap;
+			}
+		}
+	}
+
+	return 0;
+
+out_unmap:
+	for (cpu = 0; cpu < evlist->cpus->nr; cpu++) {
+		if (evlist->mmap[cpu].base != NULL) {
+			munmap(evlist->mmap[cpu].base, evlist->mmap_len);
+			evlist->mmap[cpu].base = NULL;
+		}
+	}
+	return -1;
+}
+
+static int perf_evlist__mmap_per_thread(struct perf_evlist *evlist, int prot, int mask)
+{
+	struct perf_evsel *evsel;
+	int thread;
+
+	for (thread = 0; thread < evlist->threads->nr; thread++) {
+		int output = -1;
+
+		list_for_each_entry(evsel, &evlist->entries, node) {
+			int fd = FD(evsel, 0, thread);
+
+			if (output == -1) {
+				output = fd;
+				if (__perf_evlist__mmap(evlist, evsel, thread,
+							prot, mask, output) < 0)
+					goto out_unmap;
+			} else {
+				if (ioctl(fd, PERF_EVENT_IOC_SET_OUTPUT, output) != 0)
+					goto out_unmap;
+			}
+
+			if ((evsel->attr.read_format & PERF_FORMAT_ID) &&
+			    perf_evlist__id_add_fd(evlist, evsel, 0, thread, fd) < 0)
+				goto out_unmap;
+		}
+	}
+
+	return 0;
+
+out_unmap:
+	for (thread = 0; thread < evlist->threads->nr; thread++) {
+		if (evlist->mmap[thread].base != NULL) {
+			munmap(evlist->mmap[thread].base, evlist->mmap_len);
+			evlist->mmap[thread].base = NULL;
+		}
+	}
+	return -1;
+}
+
 /** perf_evlist__mmap - Create per cpu maps to receive events
  *
  * @evlist - list of events
@@ -287,11 +373,11 @@ static int __perf_evlist__mmap(struct perf_evlist *evlist, struct perf_evsel *ev
 int perf_evlist__mmap(struct perf_evlist *evlist, int pages, bool overwrite)
 {
 	unsigned int page_size = sysconf(_SC_PAGE_SIZE);
-	int mask = pages * page_size - 1, cpu;
-	struct perf_evsel *first_evsel, *evsel;
+	int mask = pages * page_size - 1;
+	struct perf_evsel *evsel;
 	const struct cpu_map *cpus = evlist->cpus;
 	const struct thread_map *threads = evlist->threads;
-	int thread, prot = PROT_READ | (overwrite ? 0 : PROT_WRITE);
+	int prot = PROT_READ | (overwrite ? 0 : PROT_WRITE);
 
 	if (evlist->mmap == NULL && perf_evlist__alloc_mmap(evlist) < 0)
 		return -ENOMEM;
@@ -301,43 +387,18 @@ int perf_evlist__mmap(struct perf_evlist *evlist, int pages, bool overwrite)
 
 	evlist->overwrite = overwrite;
 	evlist->mmap_len = (pages + 1) * page_size;
-	first_evsel = list_entry(evlist->entries.next, struct perf_evsel, node);
 
 	list_for_each_entry(evsel, &evlist->entries, node) {
 		if ((evsel->attr.read_format & PERF_FORMAT_ID) &&
 		    evsel->sample_id == NULL &&
 		    perf_evsel__alloc_id(evsel, cpus->nr, threads->nr) < 0)
 			return -ENOMEM;
-
-		for (cpu = 0; cpu < cpus->nr; cpu++) {
-			for (thread = 0; thread < threads->nr; thread++) {
-				int fd = FD(evsel, cpu, thread);
-
-				if (evsel->idx || thread) {
-					if (ioctl(fd, PERF_EVENT_IOC_SET_OUTPUT,
-						  FD(first_evsel, cpu, 0)) != 0)
-						goto out_unmap;
-				} else if (__perf_evlist__mmap(evlist, evsel, cpu,
-							       prot, mask, fd) < 0)
-					goto out_unmap;
-
-				if ((evsel->attr.read_format & PERF_FORMAT_ID) &&
-				    perf_evlist__id_add_fd(evlist, evsel, cpu, thread, fd) < 0)
-					goto out_unmap;
-			}
-		}
 	}
 
-	return 0;
+	if (evlist->cpus->map[0] == -1)
+		return perf_evlist__mmap_per_thread(evlist, prot, mask);
 
-out_unmap:
-	for (cpu = 0; cpu < cpus->nr; cpu++) {
-		if (evlist->mmap[cpu].base != NULL) {
-			munmap(evlist->mmap[cpu].base, evlist->mmap_len);
-			evlist->mmap[cpu].base = NULL;
-		}
-	}
-	return -1;
+	return perf_evlist__mmap_per_cpu(evlist, prot, mask);
 }
 
 int perf_evlist__create_maps(struct perf_evlist *evlist, pid_t target_pid,
@@ -348,7 +409,7 @@ int perf_evlist__create_maps(struct perf_evlist *evlist, pid_t target_pid,
 	if (evlist->threads == NULL)
 		return -1;
 
-	if (target_tid != -1)
+	if (cpu_list == NULL && target_tid != -1)
 		evlist->cpus = cpu_map__dummy_new();
 	else
 		evlist->cpus = cpu_map__new(cpu_list);
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 8b1cb7a..7109d7a 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -17,6 +17,7 @@ struct perf_evlist {
 	struct hlist_head heads[PERF_EVLIST__HLIST_SIZE];
 	int		 nr_entries;
 	int		 nr_fds;
+	int		 nr_mmaps;
 	int		 mmap_len;
 	bool		 overwrite;
 	union perf_event event_copy;
@@ -46,7 +47,7 @@ void perf_evlist__add_pollfd(struct perf_evlist *evlist, int fd);
 
 struct perf_evsel *perf_evlist__id2evsel(struct perf_evlist *evlist, u64 id);
 
-union perf_event *perf_evlist__read_on_cpu(struct perf_evlist *self, int cpu);
+union perf_event *perf_evlist__mmap_read(struct perf_evlist *self, int idx);
 
 int perf_evlist__alloc_mmap(struct perf_evlist *evlist);
 int perf_evlist__mmap(struct perf_evlist *evlist, int pages, bool overwrite);
diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index f5e3845..99c7226 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -680,7 +680,7 @@ static PyObject *pyrf_evlist__read_on_cpu(struct pyrf_evlist *pevlist,
 					 &cpu, &sample_id_all))
 		return NULL;
 
-	event = perf_evlist__read_on_cpu(evlist, cpu);
+	event = perf_evlist__mmap_read(evlist, cpu);
 	if (event != NULL) {
 		struct perf_evsel *first;
 		PyObject *pyevent = pyrf_event__new(event);
