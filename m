Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895Ab2LTKMc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 05:12:32 -0500
Received: from mail-pa0-f65.google.com ([209.85.220.65]:45795 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab2LTKMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 05:12:24 -0500
X-Greylist: delayed 4081 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Dec 2012 05:12:24 EST
From: chenggang <chenggang.qin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: chenggang <chenggang.qin@gmail.com>, David Ahern <dsahern@gmail.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Yanmin Zhang <yanmin.zhang@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Mike Galbraith <efault@gmx.de>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chenggang Qin <chenggang.qcg@taobao.com>
Subject: [PATCH 4/5] perf tools: Change some interfaces of evlist & evsel to support thread's creation and destroy with thread_map's bitmap.
Date: Thu, 20 Dec 2012 17:06:50 +0800
Message-Id: <1355994410-13702-1-git-send-email-chenggang.qin@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on the [PATCH 3/5], this patch changed the related interfaces in evlist &
evsel to support the operations to thread_map's bitmap. Then, we can use these
interfaces to insert a new forked thread into or remove a exited trhead from
thread_map and other related data structures.

Cc: David Ahern <dsahern@gmail.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Yanmin Zhang <yanmin.zhang@intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Chenggang Qin <chenggang.qcg@taobao.com>
---
 tools/perf/builtin-record.c               |   25 ++-
 tools/perf/builtin-stat.c                 |    7 +-
 tools/perf/builtin-top.c                  |   14 +-
 tools/perf/tests/mmap-basic.c             |    4 +-
 tools/perf/tests/open-syscall-all-cpus.c  |    2 +-
 tools/perf/tests/open-syscall-tp-fields.c |    3 +-
 tools/perf/tests/open-syscall.c           |    3 +-
 tools/perf/tests/perf-record.c            |    2 +-
 tools/perf/util/evlist.c                  |  236 +++++++++++++++++++++++------
 tools/perf/util/evlist.h                  |   39 +++--
 tools/perf/util/evsel.c                   |  147 +++++++++++++++---
 tools/perf/util/evsel.h                   |   38 +++--
 tools/perf/util/python.c                  |    3 +-
 13 files changed, 408 insertions(+), 115 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index f3151d3..277303f 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -359,7 +359,7 @@ try_again:
 		goto out;
 	}
 
-	if (perf_evlist__mmap(evlist, opts->mmap_pages, false) < 0) {
+	if (perf_evlist__mmap(evlist, opts->mmap_pages, false, -1, false) < 0) {
 		if (errno == EPERM) {
 			pr_err("Permission error mapping pages.\n"
 			       "Consider increasing "
@@ -472,12 +472,21 @@ static int perf_record__mmap_read_all(struct perf_record *rec)
 	int i;
 	int rc = 0;
 
-	for (i = 0; i < rec->evlist->nr_mmaps; i++) {
-		if (rec->evlist->mmap[i].base) {
-			if (perf_record__mmap_read(rec, &rec->evlist->mmap[i]) != 0) {
-				rc = -1;
-				goto out;
-			}
+	if (cpu_map__all(rec->evlist->cpus)) {
+		for_each_set_bit(i, rec->evlist->threads->bitmap,
+				 PID_MAX_DEFAULT) {
+			if (rec->evlist->mmap[i].base)
+				if (perf_record__mmap_read(rec,
+				    &rec->evlist->mmap[i]) != 0){
+					rc = -1;
+					goto out;
+				}
+		}
+	} else {
+		for (i = 0; i < rec->evlist->nr_mmaps; i++) {
+			if (rec->evlist->mmap[i].base)
+				if (perf_record__mmap_read(rec,
+				    &rec->evlist->mmap[i]) != 0) {
+					rc = -1;
+					goto out;
+				}
 		}
 	}
 
@@ -1161,7 +1170,7 @@ int cmd_record(int argc, const char **argv, const char *prefix __maybe_unused)
 		err = -EINVAL;
 		goto out_free_fd;
 	}
-
+
 	err = __cmd_record(&record, argc, argv);
 out_free_fd:
 	perf_evlist__delete_maps(evsel_list);
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index c247fac..74d5311 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -229,7 +229,7 @@ static int read_counter_aggr(struct perf_evsel *counter)
 	int i;
 
 	if (__perf_evsel__read(counter, perf_evsel__nr_cpus(counter),
-			       evsel_list->threads->nr, scale) < 0)
+			       evsel_list->threads->bitmap, scale) < 0)
 		return -1;
 
 	for (i = 0; i < 3; i++)
@@ -394,13 +394,14 @@ static int __run_perf_stat(int argc __maybe_unused, const char **argv)
 	if (no_aggr) {
 		list_for_each_entry(counter, &evsel_list->entries, node) {
 			read_counter(counter);
-			perf_evsel__close_fd(counter, perf_evsel__nr_cpus(counter), 1);
+			perf_evsel__close_fd(counter,
+					     perf_evsel__nr_cpus(counter),
+					     evsel_list->threads->bitmap);
 		}
 	} else {
 		list_for_each_entry(counter, &evsel_list->entries, node) {
 			read_counter_aggr(counter);
 			perf_evsel__close_fd(counter, perf_evsel__nr_cpus(counter),
-					     evsel_list->threads->nr);
+					     evsel_list->threads->bitmap);
 		}
 	}
 
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index c9ff395..b3650e3 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -68,6 +68,8 @@
 #include <linux/unistd.h>
 #include <linux/types.h>
 
+#include "asm/bug.h"
+
 void get_term_dimensions(struct winsize *ws)
 {
 	char *s = getenv("LINES");
@@ -823,7 +825,7 @@ static void perf_top__mmap_read_idx(struct perf_top *top, int idx)
 	struct perf_evsel *evsel;
 	struct perf_session *session = top->session;
 	union perf_event *event;
-	struct machine *machine;
+	struct machine *machine = NULL;
 	u8 origin;
 	int ret;
 
@@ -886,8 +888,12 @@ static void perf_top__mmap_read(struct perf_top *top)
 {
 	int i;
 
-	for (i = 0; i < top->evlist->nr_mmaps; i++)
-		perf_top__mmap_read_idx(top, i);
+	if (cpu_map__all(top->evlist->cpus)) {
+		for_each_set_bit(i, top->evlist->threads->bitmap,
+				 PID_MAX_DEFAULT)
+			perf_top__mmap_read_idx(top, i);
+	} else
+		for (i = 0; i < top->evlist->nr_mmaps; i++)
+			perf_top__mmap_read_idx(top, i);
 }
 
 static void perf_top__start_counters(struct perf_top *top)
@@ -996,7 +1002,7 @@ try_again:
 		}
 	}
 
-	if (perf_evlist__mmap(evlist, top->mmap_pages, false) < 0) {
+	if (perf_evlist__mmap(evlist, top->mmap_pages, false, -1, false) < 0) {
 		ui__error("Failed to mmap with %d (%s)\n",
 			    errno, strerror(errno));
 		goto out_err;
diff --git a/tools/perf/tests/mmap-basic.c b/tools/perf/tests/mmap-basic.c
index e174681..fac0316 100644
--- a/tools/perf/tests/mmap-basic.c
+++ b/tools/perf/tests/mmap-basic.c
@@ -101,7 +101,7 @@ int test__basic_mmap(void)
 		}
 	}
 
-	if (perf_evlist__mmap(evlist, 128, true) < 0) {
+	if (perf_evlist__mmap(evlist, 128, true, -1, false) < 0) {
 		pr_debug("failed to mmap events: %d (%s)\n", errno,
 			 strerror(errno));
 		goto out_close_fd;
@@ -151,7 +151,7 @@ out_munmap:
 	perf_evlist__munmap(evlist);
 out_close_fd:
 	for (i = 0; i < nsyscalls; ++i)
-		perf_evsel__close_fd(evsels[i], 1, threads->nr);
+		perf_evsel__close_fd(evsels[i], 1, threads->bitmap);
 out_free_evlist:
 	perf_evlist__delete(evlist);
 out_free_cpus:
diff --git a/tools/perf/tests/open-syscall-all-cpus.c b/tools/perf/tests/open-syscall-all-cpus.c
index 31072ab..4d6f8ed 100644
--- a/tools/perf/tests/open-syscall-all-cpus.c
+++ b/tools/perf/tests/open-syscall-all-cpus.c
@@ -111,7 +111,7 @@ int test__open_syscall_event_on_all_cpus(void)
 	}
 
 out_close_fd:
-	perf_evsel__close_fd(evsel, 1, threads->nr);
+	perf_evsel__close_fd(evsel, 1, threads->bitmap);
 out_evsel_delete:
 	perf_evsel__delete(evsel);
 out_thread_map_delete:
diff --git a/tools/perf/tests/open-syscall-tp-fields.c b/tools/perf/tests/open-syscall-tp-fields.c
index 1c52fdc..5613863 100644
--- a/tools/perf/tests/open-syscall-tp-fields.c
+++ b/tools/perf/tests/open-syscall-tp-fields.c
@@ -44,6 +44,7 @@ int test__syscall_open_tp_fields(void)
 	perf_evsel__config(evsel, &opts);
 
 	evlist->threads->map[0] = getpid();
+	set_bit(0, evlist->threads->bitmap);
 
 	err = perf_evlist__open(evlist);
 	if (err < 0) {
@@ -51,7 +52,7 @@ int test__syscall_open_tp_fields(void)
 		goto out_delete_evlist;
 	}
 
-	err = perf_evlist__mmap(evlist, UINT_MAX, false);
+	err = perf_evlist__mmap(evlist, UINT_MAX, false, -1, false);
 	if (err < 0) {
 		pr_debug("perf_evlist__mmap: %s\n", strerror(errno));
 		goto out_delete_evlist;
diff --git a/tools/perf/tests/open-syscall.c b/tools/perf/tests/open-syscall.c
index 98be8b5..6b0b1da 100644
--- a/tools/perf/tests/open-syscall.c
+++ b/tools/perf/tests/open-syscall.c
@@ -2,6 +2,7 @@
 #include "evsel.h"
 #include "debug.h"
 #include "tests.h"
+#include <linux/bitops.h>
 
 int test__open_syscall_event(void)
 {
@@ -57,7 +58,7 @@ int test__open_syscall_event(void)
 
 	err = 0;
 out_close_fd:
-	perf_evsel__close_fd(evsel, 1, threads->nr);
+	perf_evsel__close_fd(evsel, 1, threads->bitmap);
 out_evsel_delete:
 	perf_evsel__delete(evsel);
 out_thread_map_delete:
diff --git a/tools/perf/tests/perf-record.c b/tools/perf/tests/perf-record.c
index 70e0d44..9678d7b 100644
--- a/tools/perf/tests/perf-record.c
+++ b/tools/perf/tests/perf-record.c
@@ -139,7 +139,7 @@ int test__PERF_RECORD(void)
 	 * fds in the same CPU to be injected in the same mmap ring buffer
 	 * (using ioctl(PERF_EVENT_IOC_SET_OUTPUT)).
 	 */
-	err = perf_evlist__mmap(evlist, opts.mmap_pages, false);
+	err = perf_evlist__mmap(evlist, opts.mmap_pages, false, -1, false);
 	if (err < 0) {
 		pr_debug("perf_evlist__mmap: %s\n", strerror(errno));
 		goto out_delete_evlist;
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 7052934..75907cb 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -23,9 +23,6 @@
 #include <linux/bitops.h>
 #include <linux/hash.h>
 
-#define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
-#define SID(e, x, y) xyarray__entry(e->sample_id, x, y)
-
 void perf_evlist__init(struct perf_evlist *evlist, struct cpu_map *cpus,
 		       struct thread_map *threads)
 {
@@ -224,7 +221,9 @@ void perf_evlist__disable(struct perf_evlist *evlist)
 		list_for_each_entry(pos, &evlist->entries, node) {
 			if (perf_evsel__is_group_member(pos))
 				continue;
-			for (thread = 0; thread < evlist->threads->nr; thread++)
+
+			for_each_set_bit(thread, evlist->threads->bitmap,
+					 PID_MAX_DEFAULT)
 				ioctl(FD(pos, cpu, thread),
 				      PERF_EVENT_IOC_DISABLE, 0);
 		}
@@ -240,20 +239,52 @@ void perf_evlist__enable(struct perf_evlist *evlist)
 		list_for_each_entry(pos, &evlist->entries, node) {
 			if (perf_evsel__is_group_member(pos))
 				continue;
-			for (thread = 0; thread < evlist->threads->nr; thread++)
+			for_each_set_bit(thread, evlist->threads->bitmap,
+					 PID_MAX_DEFAULT)
 				ioctl(FD(pos, cpu, thread),
 				      PERF_EVENT_IOC_ENABLE, 0);
 		}
 	}
 }
 
+static int perf_evlist__realloc_pollfd(struct perf_evlist *evlist)
+{
+	int nfds = cpu_map__nr(evlist->cpus) * evlist->threads->max_nr *
+		   evlist->nr_entries;
+	struct pollfd *pollfd;
+
+	pollfd = realloc(evlist->pollfd, sizeof(struct pollfd) * nfds);
+
+	if (pollfd == NULL)
+		goto out;
+
+	evlist->pollfd = pollfd;
+
+	return 0;
+out:
+	return -ENOMEM;
+}
+
 static int perf_evlist__alloc_pollfd(struct perf_evlist *evlist)
 {
-	int nfds = cpu_map__nr(evlist->cpus) * evlist->threads->nr * evlist->nr_entries;
+	int nfds = cpu_map__nr(evlist->cpus) * evlist->threads->max_nr *
+		   evlist->nr_entries;
 	evlist->pollfd = malloc(sizeof(struct pollfd) * nfds);
 	return evlist->pollfd != NULL ? 0 : -ENOMEM;
 }
 
+void perf_evlist__remove_pollfd(struct perf_evlist *evlist, int nr_thread)
+{
+	int cpu;
+	int entry;
+	int row_size = evlist->threads->max_nr * evlist->nr_entries;
+
+	for (cpu = 0; cpu < cpu_map__nr(evlist->cpus); cpu++) {
+		for (entry = 0; entry < evlist->nr_entries; entry++) {
+			evlist->pollfd[cpu * row_size + nr_thread + entry].fd = -1;
+			evlist->nr_fds--;
+		}
+	}
+}
+
 void perf_evlist__add_pollfd(struct perf_evlist *evlist, int fd)
 {
 	fcntl(fd, F_SETFL, O_NONBLOCK);
@@ -275,11 +306,30 @@ static void perf_evlist__id_hash(struct perf_evlist *evlist,
 	hlist_add_head(&sid->node, &evlist->heads[hash]);
 }
 
+static void perf_evlist__id_hash_del(struct perf_evsel *evsel,
+				     int cpu, int thread)
+{
+	struct perf_sample_id *sid = SID(evsel, cpu, thread);
+
+	hlist_del(&sid->node);
+	sid->id = 0;
+	sid->evsel = NULL;
+}
+
 void perf_evlist__id_add(struct perf_evlist *evlist, struct perf_evsel *evsel,
 			 int cpu, int thread, u64 id)
 {
 	perf_evlist__id_hash(evlist, evsel, cpu, thread, id);
-	evsel->id[evsel->ids++] = id;
+	set_bit(ID_BITMAP_POS(cpu, thread), evsel->id_bitmap);
+	evsel->id[ID_BITMAP_POS(cpu, thread)] = id;
+}
+
+void perf_evlist__id_remove(struct perf_evsel *evsel,
+			    int cpu, int thread)
+{
+	perf_evlist__id_hash_del(evsel, cpu, thread);
+	clear_bit(ID_BITMAP_POS(cpu, thread), evsel->id_bitmap);
+	evsel->id[ID_BITMAP_POS(cpu, thread)] = -1;
 }
 
 static int perf_evlist__id_add_fd(struct perf_evlist *evlist,
@@ -304,7 +354,7 @@ static int perf_evlist__id_add_fd(struct perf_evlist *evlist,
 
 struct perf_evsel *perf_evlist__id2evsel(struct perf_evlist *evlist, u64 id)
 {
-	struct hlist_head *head;
+	struct hlist_head *head = NULL;
 	struct hlist_node *pos;
 	struct perf_sample_id *sid;
 	int hash;
@@ -407,13 +457,41 @@ void perf_evlist__munmap(struct perf_evlist *evlist)
 
 static int perf_evlist__alloc_mmap(struct perf_evlist *evlist)
 {
+	int max_nr_mmaps;
+
 	evlist->nr_mmaps = cpu_map__nr(evlist->cpus);
-	if (cpu_map__all(evlist->cpus))
-		evlist->nr_mmaps = evlist->threads->nr;
-	evlist->mmap = zalloc(evlist->nr_mmaps * sizeof(struct perf_mmap));
+	max_nr_mmaps = evlist->nr_mmaps;
+
+	if (cpu_map__all(evlist->cpus)) {
+		evlist->nr_mmaps = 0;
+		max_nr_mmaps = evlist->threads->max_nr;
+	}
+
+	evlist->mmap = zalloc(max_nr_mmaps * sizeof(struct perf_mmap));
 	return evlist->mmap != NULL ? 0 : -ENOMEM;
 }
 
+static int perf_evlist__realloc_mmap(struct perf_evlist *evlist)
+{
+	struct perf_mmap *mt;
+
+	if (!cpu_map__all(evlist->cpus))
+		return 0;
+
+	mt = realloc(evlist->mmap, evlist->threads->max_nr *
+		     sizeof(struct perf_mmap));
+
+	if (mt == NULL) {
+		printf("mmap realloc failed\n");
+		goto out;
+	}
+
+	evlist->mmap = mt;
+
+	return 0;
+out:
+	return -1;
+}
+
 static int __perf_evlist__mmap(struct perf_evlist *evlist,
 			       int idx, int prot, int mask, int fd)
 {
@@ -426,6 +504,9 @@ static int __perf_evlist__mmap(struct perf_evlist *evlist,
 		return -1;
 	}
 
+	if (cpu_map__all(evlist->cpus))
+		evlist->nr_mmaps++;
+
 	perf_evlist__add_pollfd(evlist, fd);
 	return 0;
 }
@@ -438,7 +519,8 @@ static int perf_evlist__mmap_per_cpu(struct perf_evlist *evlist, int prot, int m
 	for (cpu = 0; cpu < evlist->cpus->nr; cpu++) {
 		int output = -1;
 
-		for (thread = 0; thread < evlist->threads->nr; thread++) {
+		for_each_set_bit(thread, evlist->threads->bitmap,
+				 PID_MAX_DEFAULT) {
 			list_for_each_entry(evsel, &evlist->entries, node) {
 				int fd = FD(evsel, cpu, thread);
 
@@ -471,37 +553,55 @@ out_unmap:
 	return -1;
 }
 
-static int perf_evlist__mmap_per_thread(struct perf_evlist *evlist, int prot, int mask)
+static int perf_evlist__mmap_a_thread(struct perf_evlist *evlist, int prot,
+				      int mask, int thread_id)
 {
 	struct perf_evsel *evsel;
-	int thread;
+	int output = -1;
 
-	for (thread = 0; thread < evlist->threads->nr; thread++) {
-		int output = -1;
+	list_for_each_entry(evsel, &evlist->entries, node) {
+		int fd = FD(evsel, 0, thread_id);
 
-		list_for_each_entry(evsel, &evlist->entries, node) {
-			int fd = FD(evsel, 0, thread);
+		if (fd <= 0)
+			continue;
 
-			if (output == -1) {
-				output = fd;
-				if (__perf_evlist__mmap(evlist, thread,
-							prot, mask, output) < 0)
-					goto out_unmap;
-			} else {
-				if (ioctl(fd, PERF_EVENT_IOC_SET_OUTPUT, output) != 0)
-					goto out_unmap;
-			}
+		if (output == -1) {
+			output = fd;
+			if (__perf_evlist__mmap(evlist, thread_id,
+			    prot, mask, output) < 0)
+				return -1;
+		} else
+			if (ioctl(fd, PERF_EVENT_IOC_SET_OUTPUT, output) != 0)
+				return -1;
 
-			if ((evsel->attr.read_format & PERF_FORMAT_ID) &&
-			    perf_evlist__id_add_fd(evlist, evsel, 0, thread, fd) < 0)
-				goto out_unmap;
-		}
+		if ((evsel->attr.read_format & PERF_FORMAT_ID) &&
+		    perf_evlist__id_add_fd(evlist, evsel, 0, thread_id, fd) < 0)
+			return -1;
+	}
+	return 0;
+}
+
+static int perf_evlist__mmap_per_thread(struct perf_evlist *evlist, int prot,
+					int mask, int nr_append)
+{
+	int thread;
+
+	if (nr_append >= 0) {
+		if (perf_evlist__mmap_a_thread(evlist, prot, mask,
+					       nr_append) < 0)
+			goto out_unmap;
+
+		return 0;
+	}
+
+	for_each_set_bit(thread, evlist->threads->bitmap, PID_MAX_DEFAULT) {
+		if (perf_evlist__mmap_a_thread(evlist, prot, mask, thread) < 0)
+			goto out_unmap;
 	}
 
 	return 0;
 
 out_unmap:
-	for (thread = 0; thread < evlist->threads->nr; thread++) {
+	for_each_set_bit(thread, evlist->threads->bitmap, PID_MAX_DEFAULT) {
 		if (evlist->mmap[thread].base != NULL) {
 			munmap(evlist->mmap[thread].base, evlist->mmap_len);
 			evlist->mmap[thread].base = NULL;
@@ -510,6 +610,35 @@ out_unmap:
 	return -1;
 }
 
+static void perf_evlist__reset_heads(struct perf_evlist *evlist, int old_cpu)
+{
+	struct perf_evsel *evsel;
+	int i;
+	int cpu, thread;
+	int hash;
+
+	for (i = 0; i < PERF_EVLIST__HLIST_SIZE; i++)
+		INIT_HLIST_HEAD(&evlist->heads[i]);
+
+	list_for_each_entry(evsel, &evlist->entries, node) {
+		if (evsel->attr.read_format & PERF_FORMAT_ID) {
+			for (cpu = 0; cpu < old_cpu; cpu++)
+				for_each_set_bit(thread,
+						 evlist->threads->bitmap,
+						 PID_MAX_DEFAULT) {
+					struct perf_sample_id *sid;
+					sid = SID(evsel, cpu, thread);
+
+					if (sid->id != 0) {
+						hash = hash_64(sid->id,
+							       PERF_EVLIST__HLIST_BITS);
+						hlist_add_head(&(sid->node),
+							       &(evlist->heads[hash]));
+					}
+				}
+		}
+	}
+}
+
 /** perf_evlist__mmap - Create per cpu maps to receive events
  *
  * @evlist - list of events
@@ -526,13 +655,16 @@ out_unmap:
  * Using perf_evlist__read_on_cpu does this automatically.
  */
 int perf_evlist__mmap(struct perf_evlist *evlist, unsigned int pages,
-		      bool overwrite)
+		      bool overwrite, int nr_append, bool re_alloc)
 {
 	struct perf_evsel *evsel;
 	const struct cpu_map *cpus = evlist->cpus;
 	const struct thread_map *threads = evlist->threads;
 	int prot = PROT_READ | (overwrite ? 0 : PROT_WRITE), mask;
 
+	if (evlist->mmap && nr_append < 0)
+		return -1;
+
         /* 512 kiB: default amount of unprivileged mlocked memory */
         if (pages == UINT_MAX)
                 pages = (512 * 1024) / page_size;
@@ -544,21 +676,35 @@ int perf_evlist__mmap(struct perf_evlist *evlist, unsigned int pages,
 	if (evlist->mmap == NULL && perf_evlist__alloc_mmap(evlist) < 0)
 		return -ENOMEM;
 
+	if (evlist->mmap && re_alloc && perf_evlist__realloc_mmap(evlist) < 0)
+		return -ENOMEM;
+
 	if (evlist->pollfd == NULL && perf_evlist__alloc_pollfd(evlist) < 0)
 		return -ENOMEM;
 
+	if (evlist->pollfd && re_alloc &&
+	    perf_evlist__realloc_pollfd(evlist) < 0)
+		return -ENOMEM;
+
 	evlist->overwrite = overwrite;
 	evlist->mmap_len = (pages + 1) * page_size;
 
 	list_for_each_entry(evsel, &evlist->entries, node) {
 		if ((evsel->attr.read_format & PERF_FORMAT_ID) &&
 		    evsel->sample_id == NULL &&
-		    perf_evsel__alloc_id(evsel, cpu_map__nr(cpus), threads->nr) < 0)
+		    perf_evsel__alloc_id(evsel, cpu_map__nr(cpus),
+					 threads->max_nr) < 0)
+			return -ENOMEM;
+
+		if ((evsel->attr.read_format & PERF_FORMAT_ID) &&
+		    evsel->sample_id && re_alloc &&
+		    perf_evsel__realloc_id(evsel, cpu_map__nr(cpus),
+					   threads->max_nr) < 0)
 			return -ENOMEM;
 	}
 
+	if (re_alloc)
+		perf_evlist__reset_heads(evlist, cpu_map__nr(cpus));
+
 	if (cpu_map__all(cpus))
-		return perf_evlist__mmap_per_thread(evlist, prot, mask);
+		return perf_evlist__mmap_per_thread(evlist, prot, mask, nr_append);
 
 	return perf_evlist__mmap_per_cpu(evlist, prot, mask);
 }
@@ -572,6 +718,9 @@ int perf_evlist__create_maps(struct perf_evlist *evlist,
 	if (evlist->threads == NULL)
 		return -1;
 
+	if (evlist->threads->map[0] == -1)
+		set_bit(0, evlist->threads->bitmap);
+
 	if (perf_target__has_task(target))
 		evlist->cpus = cpu_map__dummy_new();
 	else if (!perf_target__has_cpu(target) && !target->uses_mmap)
@@ -601,14 +750,14 @@ int perf_evlist__apply_filters(struct perf_evlist *evlist)
 {
 	struct perf_evsel *evsel;
 	int err = 0;
-	const int ncpus = cpu_map__nr(evlist->cpus),
-		  nthreads = evlist->threads->nr;
+	const int ncpus = cpu_map__nr(evlist->cpus);
+	BITMAP *thread_bitmap = evlist->threads->bitmap;
 
 	list_for_each_entry(evsel, &evlist->entries, node) {
 		if (evsel->filter == NULL)
 			continue;
 
-		err = perf_evsel__set_filter(evsel, ncpus, nthreads, evsel->filter);
+		err = perf_evsel__set_filter(evsel, ncpus, thread_bitmap, evsel->filter);
 		if (err)
 			break;
 	}
@@ -620,11 +769,11 @@ int perf_evlist__set_filter(struct perf_evlist *evlist, const char *filter)
 {
 	struct perf_evsel *evsel;
 	int err = 0;
-	const int ncpus = cpu_map__nr(evlist->cpus),
-		  nthreads = evlist->threads->nr;
+	const int ncpus = cpu_map__nr(evlist->cpus);
+	BITMAP *thread_bitmap = evlist->threads->bitmap;
 
 	list_for_each_entry(evsel, &evlist->entries, node) {
-		err = perf_evsel__set_filter(evsel, ncpus, nthreads, filter);
+		err = perf_evsel__set_filter(evsel, ncpus, thread_bitmap, filter);
 		if (err)
 			break;
 	}
@@ -707,7 +856,7 @@ void perf_evlist__set_selected(struct perf_evlist *evlist,
 int perf_evlist__open(struct perf_evlist *evlist)
 {
 	struct perf_evsel *evsel;
-	int err, ncpus, nthreads;
+	int err, ncpus;
 
 	list_for_each_entry(evsel, &evlist->entries, node) {
 		err = perf_evsel__open(evsel, evlist->cpus, evlist->threads);
@@ -718,10 +867,9 @@ int perf_evlist__open(struct perf_evlist *evlist)
 	return 0;
 out_err:
 	ncpus = evlist->cpus ? evlist->cpus->nr : 1;
-	nthreads = evlist->threads ? evlist->threads->nr : 1;
 
 	list_for_each_entry_reverse(evsel, &evlist->entries, node)
-		perf_evsel__close(evsel, ncpus, nthreads);
+		perf_evsel__close(evsel, ncpus, evlist->threads->bitmap);
 
 	errno = -err;
 	return err;
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 56003f7..5df4f2b 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -2,12 +2,14 @@
 #define __PERF_EVLIST_H 1
 
 #include <linux/list.h>
+#include <linux/bitops.h>
 #include <stdio.h>
 #include "../perf.h"
 #include "event.h"
 #include "evsel.h"
 #include "util.h"
 #include <unistd.h>
+#include "thread_map.h"
 
 struct pollfd;
 struct thread_map;
@@ -18,23 +20,23 @@ struct perf_record_opts;
 #define PERF_EVLIST__HLIST_SIZE (1 << PERF_EVLIST__HLIST_BITS)
 
 struct perf_evlist {
-	struct list_head entries;
-	struct hlist_head heads[PERF_EVLIST__HLIST_SIZE];
-	int		 nr_entries;
-	int		 nr_fds;
-	int		 nr_mmaps;
-	int		 mmap_len;
+	struct list_head	entries;
+	struct hlist_head	heads[PERF_EVLIST__HLIST_SIZE];
+	int			nr_entries;
+	int			nr_fds;
+	int			nr_mmaps;
+	int			mmap_len;
 	struct {
-		int	cork_fd;
-		pid_t	pid;
+		int		cork_fd;
+		pid_t		pid;
 	} workload;
-	bool		 overwrite;
-	union perf_event event_copy;
-	struct perf_mmap *mmap;
-	struct pollfd	 *pollfd;
-	struct thread_map *threads;
-	struct cpu_map	  *cpus;
-	struct perf_evsel *selected;
+	bool			overwrite;
+	union perf_event	event_copy;
+	struct perf_mmap	*mmap;
+	struct pollfd		*pollfd;
+	struct thread_map	*threads;
+	struct cpu_map		*cpus;
+	struct perf_evsel	*selected;
 };
 
 struct perf_evsel_str_handler {
@@ -68,8 +70,13 @@ perf_evlist__find_tracepoint_by_id(struct perf_evlist *evlist, int id);
 void perf_evlist__id_add(struct perf_evlist *evlist, struct perf_evsel *evsel,
 			 int cpu, int thread, u64 id);
 
+void perf_evlist__id_remove(struct perf_evsel *evsel,
+			    int cpu, int thread);
+
 void perf_evlist__add_pollfd(struct perf_evlist *evlist, int fd);
 
+void perf_evlist__remove_pollfd(struct perf_evlist *evlist, int nr_thread);
+
 struct perf_evsel *perf_evlist__id2evsel(struct perf_evlist *evlist, u64 id);
 
 union perf_event *perf_evlist__mmap_read(struct perf_evlist *self, int idx);
@@ -85,7 +92,7 @@ int perf_evlist__prepare_workload(struct perf_evlist *evlist,
 int perf_evlist__start_workload(struct perf_evlist *evlist);
 
 int perf_evlist__mmap(struct perf_evlist *evlist, unsigned int pages,
-		      bool overwrite);
+		      bool overwrite, int nr_append, bool re_alloc);
 void perf_evlist__munmap(struct perf_evlist *evlist);
 
 void perf_evlist__disable(struct perf_evlist *evlist);
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index a34167f..6dd366e 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -8,7 +8,7 @@
  */
 
 #include <byteswap.h>
-#include <linux/bitops.h>
+#include <linux/bitmap.h>
 #include "asm/bug.h"
 #include "debugfs.h"
 #include "event-parse.h"
@@ -21,8 +21,7 @@
 #include <linux/hw_breakpoint.h>
 #include <linux/perf_event.h>
 #include "perf_regs.h"
-
-#define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
+#include "debug.h"
 
 static int __perf_evsel__sample_size(u64 sample_type)
 {
@@ -546,13 +545,29 @@ int perf_evsel__alloc_fd(struct perf_evsel *evsel, int ncpus, int nthreads)
 	return evsel->fd != NULL ? 0 : -ENOMEM;
 }
 
-int perf_evsel__set_filter(struct perf_evsel *evsel, int ncpus, int nthreads,
+int perf_evsel__realloc_fd(struct perf_evsel *evsel,
+			    int ncpus, int max_nthreads)
+{
+	int old_nthreads = evsel->fd->row_size;
+	int cpu, thread;
+
+	if (xyarray__realloc(&(evsel->fd), ncpus, ncpus, max_nthreads) < 0)
+		return -1;
+
+	for (cpu = 0; cpu < ncpus; cpu++)
+		for (thread = old_nthreads; thread < max_nthreads; thread++)
+			FD(evsel, cpu, thread) = -1;
+
+	return 0;
+}
+
+int perf_evsel__set_filter(struct perf_evsel *evsel, int ncpus,
+			    BITMAP *thread_bitmap,
 			   const char *filter)
 {
 	int cpu, thread;
 
 	for (cpu = 0; cpu < ncpus; cpu++) {
-		for (thread = 0; thread < nthreads; thread++) {
+		for_each_set_bit(thread, thread_bitmap, PID_MAX_DEFAULT) {
 			int fd = FD(evsel, cpu, thread),
 			    err = ioctl(fd, PERF_EVENT_IOC_SET_FILTER, filter);
 
@@ -570,12 +585,33 @@ int perf_evsel__alloc_id(struct perf_evsel *evsel, int ncpus, int nthreads)
 	if (evsel->sample_id == NULL)
 		return -ENOMEM;
 
-	evsel->id = zalloc(ncpus * nthreads * sizeof(u64));
+	evsel->id = zalloc(ID_MAX_DEFAULT * sizeof(u64));
 	if (evsel->id == NULL) {
 		xyarray__delete(evsel->sample_id);
 		evsel->sample_id = NULL;
 		return -ENOMEM;
 	}
+	evsel->ids = ncpus * nthreads;
+
+	return 0;
+}
+
+int perf_evsel__realloc_id(struct perf_evsel *evsel, int ncpus, int nthreads)
+{
+	u64 *id = NULL;
+	size_t old_nthreads = evsel->sample_id->row_size /
+			      sizeof(struct perf_sample_id);
+
+	if (xyarray__realloc(&(evsel->sample_id), ncpus, ncpus, nthreads) < 0)
+		return -ENOMEM;
+
+	id = realloc(evsel->id, ncpus * nthreads * sizeof(u64));
+	if (id == NULL) {
+		xyarray__realloc(&(evsel->sample_id), ncpus, ncpus,
+				 old_nthreads);
+		return -ENOMEM;
+	}
+
+	evsel->id = id;
+	evsel->ids = ncpus * nthreads;
 
 	return 0;
 }
@@ -601,14 +637,17 @@ void perf_evsel__free_id(struct perf_evsel *evsel)
 	evsel->id = NULL;
 }
 
-void perf_evsel__close_fd(struct perf_evsel *evsel, int ncpus, int nthreads)
+void perf_evsel__close_fd(struct perf_evsel *evsel, int ncpus,
+			  BITMAP *thread_bitmap)
 {
 	int cpu, thread;
 
 	for (cpu = 0; cpu < ncpus; cpu++)
-		for (thread = 0; thread < nthreads; ++thread) {
-			close(FD(evsel, cpu, thread));
-			FD(evsel, cpu, thread) = -1;
+		for_each_set_bit(thread, thread_bitmap, PID_MAX_DEFAULT) {
+			if (FD(evsel, cpu, thread)) {
+				close(FD(evsel, cpu, thread));
+				FD(evsel, cpu, thread) = -1;
+			}
 		}
 }
 
@@ -659,7 +698,7 @@ int __perf_evsel__read_on_cpu(struct perf_evsel *evsel,
 }
 
 int __perf_evsel__read(struct perf_evsel *evsel,
-		       int ncpus, int nthreads, bool scale)
+		       int ncpus, BITMAP *thread_bitmap, bool scale)
 {
 	size_t nv = scale ? 3 : 1;
 	int cpu, thread;
@@ -668,7 +707,7 @@ int __perf_evsel__read(struct perf_evsel *evsel,
 	aggr->val = aggr->ena = aggr->run = 0;
 
 	for (cpu = 0; cpu < ncpus; cpu++) {
-		for (thread = 0; thread < nthreads; thread++) {
+		for_each_set_bit(thread, thread_bitmap, PID_MAX_DEFAULT) {
 			if (FD(evsel, cpu, thread) < 0)
 				continue;
 
@@ -722,6 +761,68 @@ static int get_group_fd(struct perf_evsel *evsel, int cpu, int thread)
 	return fd;
 }
 
+int perf_evsel__append_open(struct perf_evsel *evsel,
+			    struct cpu_map *cpus, struct thread_map *threads,
+			    int append_nr, bool ralloc_need)
+{
+	int cpu;
+	unsigned long flags = 0;
+	int pid = -1, err;
+
+	if (ralloc_need)
+		if (perf_evsel__realloc_fd(evsel, cpus->nr, threads->max_nr) < 0)
+			return -ENOMEM;
+
+	if (evsel->cgrp) {
+		flags = PERF_FLAG_PID_CGROUP;
+		pid = evsel->cgrp->fd;
+	}
+
+	for (cpu = 0; cpu < cpus->nr; cpu++) {
+		int group_fd;
+
+		if (!evsel->cgrp)
+			pid = threads->map[append_nr];
+
+		group_fd = get_group_fd(evsel, cpu, append_nr);
+
+		FD(evsel, cpu, append_nr) = sys_perf_event_open(&evsel->attr,
+								pid, cpus->map[cpu],
+								group_fd, flags);
+
+		if (FD(evsel, cpu, append_nr) < 0) {
+			err = errno;
+			FD(evsel, cpu, append_nr) = -1;
+
+			if (err == ESRCH) {
+				int tid = threads->map[append_nr];
+
+				ui__error("A ESRCH error is got. May be the "
+					  "target task [%d] exited.\n",
+					  tid);
+				return err;
+			} else if (err == EMFILE) {
+				ui__error("Too many events (threads) are opened.\n"
+					  "Try again after reducing the number of events\n");
+				goto out_err;
+			}
+
+			ui__error("The sys_perf_event_open() syscall "
+				  "returned with %d (%s).  /bin/dmesg "
+				  "may provide additional information.\n"
+				  "No CONFIG_PERF_EVENTS=y kernel support "
+				  "configured?\n", err, strerror(err));
+
+			goto out_err;
+		}
+	}
+
+	return 0;
+out_err:
+	exit_browser(0);
+	exit(0);
+}
+
 static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
 			      struct thread_map *threads)
 {
@@ -730,7 +831,7 @@ static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
 	int pid = -1, err;
 
 	if (evsel->fd == NULL &&
-	    perf_evsel__alloc_fd(evsel, cpus->nr, threads->nr) < 0)
+	    perf_evsel__alloc_fd(evsel, cpus->nr, threads->max_nr) < 0)
 		return -ENOMEM;
 
 	if (evsel->cgrp) {
@@ -739,8 +840,7 @@ static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
 	}
 
 	for (cpu = 0; cpu < cpus->nr; cpu++) {
-
-		for (thread = 0; thread < threads->nr; thread++) {
+		for_each_set_bit(thread, threads->bitmap, PID_MAX_DEFAULT) {
 			int group_fd;
 
 			if (!evsel->cgrp)
@@ -763,21 +863,21 @@ static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
 
 out_close:
 	do {
-		while (--thread >= 0) {
-			close(FD(evsel, cpu, thread));
-			FD(evsel, cpu, thread) = -1;
-		}
-		thread = threads->nr;
+		for_each_set_bit(thread, threads->bitmap, PID_MAX_DEFAULT)
+			if (FD(evsel, cpu, thread) != -1) {
+				close(FD(evsel, cpu, thread));
+				FD(evsel, cpu, thread) = -1;
+			}
 	} while (--cpu >= 0);
 	return err;
 }
 
-void perf_evsel__close(struct perf_evsel *evsel, int ncpus, int nthreads)
+void perf_evsel__close(struct perf_evsel *evsel, int ncpus,
+			BITMAP *thread_bitmap)
 {
 	if (evsel->fd == NULL)
 		return;
 
-	perf_evsel__close_fd(evsel, ncpus, nthreads);
+	perf_evsel__close_fd(evsel, ncpus, thread_bitmap);
 	perf_evsel__free_fd(evsel);
 	evsel->fd = NULL;
 }
@@ -803,7 +903,7 @@ static struct {
 	.map = {
 		.max_nr = MAX_THREADS_NR_DEFAULT,
 		.nr = 1,
-		.bitmap = empty_thread_bitmap,
+		.bitmap = empty_thread_bitmap,
 	},
 	.threads = { -1, },
 };
@@ -830,6 +930,7 @@ int perf_evsel__open_per_cpu(struct perf_evsel *evsel,
 {
 	bitmap_zero(empty_thread_map.map.bitmap, PID_MAX_DEFAULT);
 	set_bit(0, empty_thread_map.map.bitmap);
+
 	return __perf_evsel__open(evsel, cpus, &empty_thread_map.map);
 }
 
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 3d2b801..065d27b 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -2,6 +2,7 @@
 #define __PERF_EVSEL_H 1
 
 #include <linux/list.h>
+#include <linux/bitops.h>
 #include <stdbool.h>
 #include <stddef.h>
 #include <linux/perf_event.h>
@@ -9,6 +10,17 @@
 #include "xyarray.h"
 #include "cgroup.h"
 #include "hist.h"
+
+#define ID_MAX_DEFAULT (CPU_MAX_DEFAULT * PID_MAX_DEFAULT)
+
+/*
+ * find the bit position of (cpu, thread)
+ */
+#define ID_BITMAP_POS(cpu, thread) \
+	(cpu * PID_MAX_DEFAULT + thread)
+
+#define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
+#define SID(e, x, y) xyarray__entry(e->sample_id, x, y)
  
 struct perf_counts_values {
 	union {
@@ -52,6 +64,7 @@ struct perf_evsel {
 	struct xyarray		*fd;
 	struct xyarray		*sample_id;
 	u64			*id;
+	DECLARE_BITMAP(id_bitmap, ID_MAX_DEFAULT);
 	struct perf_counts	*counts;
 	int			idx;
 	u32			ids;
@@ -112,13 +125,15 @@ int __perf_evsel__hw_cache_type_op_res_name(u8 type, u8 op, u8 result,
 const char *perf_evsel__name(struct perf_evsel *evsel);
 
 int perf_evsel__alloc_fd(struct perf_evsel *evsel, int ncpus, int nthreads);
+int perf_evsel__realloc_fd(struct perf_evsel *evsel, int ncpus, int max_nthreads);
 int perf_evsel__alloc_id(struct perf_evsel *evsel, int ncpus, int nthreads);
+int perf_evsel__realloc_id(struct perf_evsel *evsel, int ncpus, int max_nthreads);
 int perf_evsel__alloc_counts(struct perf_evsel *evsel, int ncpus);
 void perf_evsel__free_fd(struct perf_evsel *evsel);
 void perf_evsel__free_id(struct perf_evsel *evsel);
-void perf_evsel__close_fd(struct perf_evsel *evsel, int ncpus, int nthreads);
+void perf_evsel__close_fd(struct perf_evsel *evsel, int ncpus, BITMAP *thread_bitmap);
 
-int perf_evsel__set_filter(struct perf_evsel *evsel, int ncpus, int nthreads,
+int perf_evsel__set_filter(struct perf_evsel *evsel, int ncpus, BITMAP *thread_bitmap,
 			   const char *filter);
 
 int perf_evsel__open_per_cpu(struct perf_evsel *evsel,
@@ -127,7 +142,10 @@ int perf_evsel__open_per_thread(struct perf_evsel *evsel,
 				struct thread_map *threads);
 int perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
 		     struct thread_map *threads);
-void perf_evsel__close(struct perf_evsel *evsel, int ncpus, int nthreads);
+int perf_evsel__append_open(struct perf_evsel *evsel, struct cpu_map *cpus,
+			    struct thread_map *threads, int append_nr,
+			    bool need_realloc);
+void perf_evsel__close(struct perf_evsel *evsel, int ncpus, BITMAP *thread_bitmap);
 
 struct perf_sample;
 
@@ -187,7 +205,7 @@ static inline int perf_evsel__read_on_cpu_scaled(struct perf_evsel *evsel,
 	return __perf_evsel__read_on_cpu(evsel, cpu, thread, true);
 }
 
-int __perf_evsel__read(struct perf_evsel *evsel, int ncpus, int nthreads,
+int __perf_evsel__read(struct perf_evsel *evsel, int ncpus, BITMAP *thread_bitmap,
 		       bool scale);
 
 /**
@@ -195,12 +213,12 @@ int __perf_evsel__read(struct perf_evsel *evsel, int ncpus, int nthreads,
  *
  * @evsel - event selector to read value
  * @ncpus - Number of cpus affected, from zero
- * @nthreads - Number of threads affected, from zero
+ * @thread_bitmap - Bitmap of threads map affected.
  */
 static inline int perf_evsel__read(struct perf_evsel *evsel,
-				    int ncpus, int nthreads)
+				    int ncpus, BITMAP *thread_bitmap)
 {
-	return __perf_evsel__read(evsel, ncpus, nthreads, false);
+	return __perf_evsel__read(evsel, ncpus, thread_bitmap, false);
 }
 
 /**
@@ -208,12 +226,12 @@ static inline int perf_evsel__read(struct perf_evsel *evsel,
  *
  * @evsel - event selector to read value
  * @ncpus - Number of cpus affected, from zero
- * @nthreads - Number of threads affected, from zero
+ * @thread_bitmap - Bitmap of threads map affected.
  */
 static inline int perf_evsel__read_scaled(struct perf_evsel *evsel,
-					  int ncpus, int nthreads)
+					  int ncpus, BITMAP *thread_bitmap)
 {
-	return __perf_evsel__read(evsel, ncpus, nthreads, true);
+	return __perf_evsel__read(evsel, ncpus, thread_bitmap, true);
 }
 
 void hists__init(struct hists *hists);
diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index a2657fd..f54b362 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -420,6 +420,7 @@ struct pyrf_thread_map {
 	PyObject_HEAD
 
 	struct thread_map *threads;
+	DECLARE_BITMAP(thread_bitmap, PID_MAX_DEFAULT);
 };
 
 static int pyrf_thread_map__init(struct pyrf_thread_map *pthreads,
@@ -704,7 +705,7 @@ static PyObject *pyrf_evlist__mmap(struct pyrf_evlist *pevlist,
 					 &pages, &overwrite))
 		return NULL;
 
-	if (perf_evlist__mmap(evlist, pages, overwrite) < 0) {
+	if (perf_evlist__mmap(evlist, pages, overwrite, -1, false) < 0) {
 		PyErr_SetFromErrno(PyExc_OSError);
 		return NULL;
 	}
-- 
1.7.9.5

