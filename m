Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab1KSTGg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 14:06:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41488 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753690Ab1KSTGe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 14:06:34 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCHv2 5/5] perf tool: Putting mmap support to perf_data object
Date: Sat, 19 Nov 2011 21:03:53 -0500
Message-Id: <1321754633-11489-6-git-send-email-jolsa@redhat.com>
In-Reply-To: <1321754633-11489-1-git-send-email-jolsa@redhat.com>
References: <1321624005-6889-1-git-send-email-jolsa@redhat.com>
 <1321754633-11489-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding event memory maps management under the perf_data
object. The objective is to have this functionality
centralized and dont mix this functionality into event
list.

New function 'perf_data__mmap' is added into perf_data. It prepares
allocates/prepares both perf_mmap and pollfd structures, and does
the actuall mmap-ing.

Each perf_mmap now contains perf_data_file structure,
to have memory map connected directly with the storage.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/builtin-record.c |   29 +++++--
 tools/perf/builtin-test.c   |   14 +++-
 tools/perf/builtin-top.c    |   26 ++++--
 tools/perf/util/data.c      |  107 ++++++++++++++++++++++++
 tools/perf/util/data.h      |   15 ++++
 tools/perf/util/evlist.c    |  188 ++-----------------------------------------
 tools/perf/util/evlist.h    |   10 +--
 tools/perf/util/evsel.h     |    4 +-
 tools/perf/util/mmap.h      |    3 +
 tools/perf/util/python.c    |   23 ++++--
 tools/perf/util/session.h   |    6 ++
 11 files changed, 205 insertions(+), 220 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 8765ae0..a6cb29f 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -318,8 +318,9 @@ try_again:
 		exit(-1);
 	}
 
-	if (perf_evlist__mmap(evlist, mmap_pages, false) < 0)
-		die("failed to mmap with %d (%s)\n", errno, strerror(errno));
+	if (perf_evlist__init_ids(evlist))
+		die("failed to init sample IDs %d (%s)\n",
+		    errno, strerror(errno));
 
 	if (perf_session__is_new(session))
 		session->evlist = evlist;
@@ -402,18 +403,18 @@ static struct perf_event_header finished_round_event = {
 	.type = PERF_RECORD_FINISHED_ROUND,
 };
 
-static void mmap_read(struct perf_mmap *m __used, void *buf, unsigned long size)
+static void mmap_read(struct perf_mmap *m, void *buf, unsigned long size)
 {
-	int fd = perf_session__fd(session);
+	int fd = perf_data__fd_file(m->file);
 	write_output(fd, buf, size);
 }
 
-static int mmap_read_all(void)
+static int mmap_read_all(struct perf_data *data)
 {
 	int i, ret = 0;
 
-	for (i = 0; i < evsel_list->nr_mmaps; i++) {
-		struct perf_mmap *m = &evsel_list->mmap[i];
+	for (i = 0; i < data->nr_mmaps; i++) {
+		struct perf_mmap *m = &data->mmaps[i];
 		ret += perf_mmap__process(m, mmap_read);
 	}
 
@@ -540,6 +541,13 @@ static int __cmd_record(int argc, const char **argv)
 
 	open_counters(evsel_list);
 
+	if (perf_data__mmap(perf_session__data(session),
+			    evsel_list, mmap_pages, false) < 0) {
+		pr_err("Failed to mmap with %d (%s)\n",
+		       errno, strerror(errno));
+		goto out_delete_session;
+	}
+
 	/*
 	 * perf_session__delete(session) will be called at atexit_header()
 	 */
@@ -642,10 +650,13 @@ static int __cmd_record(int argc, const char **argv)
 		close(go_pipe[1]);
 
 	for (;;) {
-		if (!mmap_read_all()) {
+		struct perf_data *data = perf_session__data(session);
+
+		if (!mmap_read_all(data)) {
+
 			if (done)
 				break;
-			err = poll(evsel_list->pollfd, evsel_list->nr_fds, -1);
+			err = poll(data->fds, data->nr_fds, -1);
 			waking++;
 		}
 
diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 831d1ba..eafeb67 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -12,6 +12,7 @@
 #include "util/parse-events.h"
 #include "util/symbol.h"
 #include "util/thread_map.h"
+#include "util/data.h"
 #include "../../include/linux/hw_breakpoint.h"
 
 static long page_size;
@@ -476,6 +477,9 @@ static int test__basic_mmap(void)
 		     expected_nr_events[nsyscalls], i, j;
 	struct perf_evsel *evsels[nsyscalls], *evsel;
 	int sample_size = __perf_evsel__sample_size(attr.sample_type);
+	struct perf_data data;
+
+	PERF_DATA__NONE(data);
 
 	for (i = 0; i < nsyscalls; ++i) {
 		char name[64];
@@ -539,7 +543,11 @@ static int test__basic_mmap(void)
 		}
 	}
 
-	if (perf_evlist__mmap(evlist, 128, true) < 0) {
+	err = perf_evlist__init_ids(evlist);
+	if (err)
+		goto out_close_fd;
+
+	if (perf_data__mmap(&data, evlist, 128, true)) {
 		pr_debug("failed to mmap events: %d (%s)\n", errno,
 			 strerror(errno));
 		goto out_close_fd;
@@ -551,7 +559,7 @@ static int test__basic_mmap(void)
 			++foo;
 		}
 
-	while ((event = perf_evlist__mmap_read(evlist, 0)) != NULL) {
+	while ((event = perf_data__mmap_read(&data, 0)) != NULL) {
 		struct perf_sample sample;
 
 		if (event->header.type != PERF_RECORD_SAMPLE) {
@@ -587,7 +595,7 @@ static int test__basic_mmap(void)
 
 	err = 0;
 out_munmap:
-	perf_evlist__munmap(evlist);
+	perf_data__close(&data);
 out_close_fd:
 	for (i = 0; i < nsyscalls; ++i)
 		perf_evsel__close_fd(evsels[i], 1, threads->nr);
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index bc3a21b..1d42473 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -804,14 +804,15 @@ static void perf_event__process_sample(const union perf_event *event,
 	return;
 }
 
-static void perf_session__mmap_read_idx(struct perf_session *self, int idx)
+static void perf_session__mmap_read_idx(struct perf_session *self,
+					struct perf_data *data, int idx)
 {
 	struct perf_sample sample;
 	struct perf_evsel *evsel;
 	union perf_event *event;
 	int ret;
 
-	while ((event = perf_evlist__mmap_read(top.evlist, idx)) != NULL) {
+	while ((event = perf_data__mmap_read(data, idx)) != NULL) {
 		ret = perf_session__parse_sample(self, event, &sample);
 		if (ret) {
 			pr_err("Can't parse sample, err = %d\n", ret);
@@ -833,13 +834,14 @@ static void perf_session__mmap_read_idx(struct perf_session *self, int idx)
 
 static void perf_session__mmap_read(struct perf_session *self)
 {
+	struct perf_data *data = perf_session__data(self);
 	int i;
 
-	for (i = 0; i < top.evlist->nr_mmaps; i++)
-		perf_session__mmap_read_idx(self, i);
+	for (i = 0; i < data->nr_mmaps; i++)
+		perf_session__mmap_read_idx(self, data, i);
 }
 
-static void start_counters(struct perf_evlist *evlist)
+static void start_counters(struct perf_data *data, struct perf_evlist *evlist)
 {
 	struct perf_evsel *counter, *first;
 
@@ -920,7 +922,10 @@ try_again:
 		}
 	}
 
-	if (perf_evlist__mmap(evlist, mmap_pages, false) < 0) {
+	if (perf_evlist__init_ids(evlist))
+		goto out_err;
+
+	if (perf_data__mmap(data, evlist, mmap_pages, false) < 0) {
 		ui__warning("Failed to mmap with %d (%s)\n",
 			    errno, strerror(errno));
 		goto out_err;
@@ -952,6 +957,7 @@ static int setup_sample_type(void)
 
 static int __cmd_top(void)
 {
+	struct perf_data *data;
 	pthread_t thread;
 	int ret;
 
@@ -970,12 +976,14 @@ static int __cmd_top(void)
 	else
 		perf_event__synthesize_threads(perf_event__process, top.session);
 
-	start_counters(top.evlist);
+	data = perf_session__data(top.session);
+
+	start_counters(data, top.evlist);
 	top.session->evlist = top.evlist;
 	perf_session__update_sample_type(top.session);
 
 	/* Wait for a minimal set of events before starting the snapshot */
-	poll(top.evlist->pollfd, top.evlist->nr_fds, 100);
+	poll(data->fds, data->nr_fds, 100);
 
 	perf_session__mmap_read(top.session);
 
@@ -1001,7 +1009,7 @@ static int __cmd_top(void)
 		perf_session__mmap_read(top.session);
 
 		if (hits == top.samples)
-			ret = poll(top.evlist->pollfd, top.evlist->nr_fds, 100);
+			ret = poll(data->fds, data->nr_fds, 100);
 	}
 
 out_delete:
diff --git a/tools/perf/util/data.c b/tools/perf/util/data.c
index 52ee306..6864c2c 100644
--- a/tools/perf/util/data.c
+++ b/tools/perf/util/data.c
@@ -197,3 +197,110 @@ void perf_data__close(struct perf_data *data)
 	list_for_each_entry(file, &data->files, list)
 		data_file__close(data, file);
 }
+
+static int data_file__ass_mmap(struct perf_data *data, struct perf_mmap *m)
+{
+	/*
+	 * Currently we have only one file to store data to.
+	 * In future we might open a file here and redirected perf_mmap
+	 * data into it.
+	 */
+	m->file = &data->header;
+	return 0;
+}
+
+static struct perf_mmap *data_mmap__new(struct perf_data *data)
+{
+	struct perf_mmap *m, *mmaps;
+	int nr = data->nr_mmaps;
+
+	mmaps = realloc(data->mmaps, (nr + 1) * sizeof(struct perf_mmap));
+	if (!mmaps)
+		return NULL;
+
+	data->nr_mmaps++;
+	data->mmaps = mmaps;
+
+	m = &data->mmaps[nr];
+	memset(m, 0, sizeof(*m));
+	return m;
+}
+
+static int data_fd__new(struct perf_data *data, int fd)
+{
+	struct pollfd *p, *fds;
+	int nr = data->nr_fds;
+
+	fds = realloc(data->fds, (nr + 1) * sizeof(struct perf_mmap));
+	if (!fds)
+		return -ENOMEM;
+
+	fcntl(fd, F_SETFL, O_NONBLOCK);
+
+	data->nr_fds++;
+	data->fds = fds;
+
+	p = &data->fds[nr];
+	p->fd = fd;
+	p->events = POLLIN;
+	return 0;
+}
+
+int perf_data__mmap(struct perf_data *data,
+		    struct perf_evlist *evlist,
+		    int pages, bool overwrite)
+{
+	bool cpu_bond = evlist->cpus->map[0] != -1;
+	struct perf_evsel *evsel;
+	int cpu, thread, ret, i;
+
+	for (cpu = 0; cpu < evlist->cpus->nr; cpu++) {
+		struct perf_mmap *m = NULL;
+
+		for (thread = 0; thread < evlist->threads->nr; thread++) {
+			list_for_each_entry(evsel, &evlist->entries, node) {
+				int fd = PERF_EVSEL_FD(evsel, cpu, thread);
+
+				if (!m || !(cpu_bond && thread)) {
+					m = data_mmap__new(data);
+					if (!m) {
+						ret = -ENOMEM;
+						goto cleanup;
+					}
+
+					ret = -EINVAL;
+					if (perf_mmap__open(m, fd, overwrite,
+							    pages))
+						goto cleanup;
+
+					if (data_file__ass_mmap(data, m))
+						goto cleanup;
+
+				} else {
+					ioctl(fd, PERF_EVENT_IOC_SET_OUTPUT,
+					      m->fd);
+				}
+
+				if (data_fd__new(data, fd))
+					return -ENOMEM;
+			}
+		}
+	}
+
+	return 0;
+
+ cleanup:
+	for (i = 0; i < data->nr_mmaps; i++) {
+		struct perf_mmap *m = &data->mmaps[i];
+		perf_mmap__close(m);
+	}
+
+	return ret;
+}
+
+union perf_event *perf_data__mmap_read(struct perf_data *data, int idx)
+{
+	struct perf_mmap *md;
+	md = &data->mmaps[idx];
+	return perf_mmap__read(md);
+}
diff --git a/tools/perf/util/data.h b/tools/perf/util/data.h
index 3103f7a..ca2e6a5 100644
--- a/tools/perf/util/data.h
+++ b/tools/perf/util/data.h
@@ -28,12 +28,22 @@ struct perf_data {
 	int  mode;
 	bool force;
 
+	struct perf_mmap *mmaps;
+	struct pollfd *fds;
+	int nr_mmaps;
+	int nr_fds;
+
 	struct list_head files;
 };
 
 int perf_data__open(struct perf_data *data, const char *name,
 		    int mode, bool force);
 void perf_data__close(struct perf_data *data);
+int perf_data__mmap(struct perf_data *data,
+		    struct perf_evlist *evlist,
+		    int pages, bool overwrite);
+union perf_event *perf_data__mmap_read(struct perf_data *data,
+				       int idx);
 
 #define PERF_DATA__NONE(__data) \
 	perf_data__open(&__data, NULL, PERF_DATA_NONE, false);
@@ -62,4 +72,9 @@ static inline int perf_data__fd(struct perf_data *data)
 {
 	return data->header.fd;
 }
+
+static inline int perf_data__fd_file(struct perf_data_file *file)
+{
+	return file->fd;
+}
 #endif /* __PERF_DATA_H */
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 7dd64dd..21e3e0f 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -19,7 +19,6 @@
 #include <linux/bitops.h>
 #include <linux/hash.h>
 
-#define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
 #define SID(e, x, y) xyarray__entry(e->sample_id, x, y)
 
 void perf_evlist__init(struct perf_evlist *evlist, struct cpu_map *cpus,
@@ -56,18 +55,9 @@ static void perf_evlist__purge(struct perf_evlist *evlist)
 	evlist->nr_entries = 0;
 }
 
-void perf_evlist__exit(struct perf_evlist *evlist)
-{
-	free(evlist->mmap);
-	free(evlist->pollfd);
-	evlist->mmap = NULL;
-	evlist->pollfd = NULL;
-}
-
 void perf_evlist__delete(struct perf_evlist *evlist)
 {
 	perf_evlist__purge(evlist);
-	perf_evlist__exit(evlist);
 	free(evlist);
 }
 
@@ -109,7 +99,8 @@ void perf_evlist__disable(struct perf_evlist *evlist)
 	for (cpu = 0; cpu < evlist->cpus->nr; cpu++) {
 		list_for_each_entry(pos, &evlist->entries, node) {
 			for (thread = 0; thread < evlist->threads->nr; thread++)
-				ioctl(FD(pos, cpu, thread), PERF_EVENT_IOC_DISABLE);
+				ioctl(PERF_EVSEL_FD(pos, cpu, thread),
+				      PERF_EVENT_IOC_DISABLE);
 		}
 	}
 }
@@ -122,26 +113,12 @@ void perf_evlist__enable(struct perf_evlist *evlist)
 	for (cpu = 0; cpu < evlist->cpus->nr; cpu++) {
 		list_for_each_entry(pos, &evlist->entries, node) {
 			for (thread = 0; thread < evlist->threads->nr; thread++)
-				ioctl(FD(pos, cpu, thread), PERF_EVENT_IOC_ENABLE);
+				ioctl(PERF_EVSEL_FD(pos, cpu, thread),
+				      PERF_EVENT_IOC_ENABLE);
 		}
 	}
 }
 
-int perf_evlist__alloc_pollfd(struct perf_evlist *evlist)
-{
-	int nfds = evlist->cpus->nr * evlist->threads->nr * evlist->nr_entries;
-	evlist->pollfd = malloc(sizeof(struct pollfd) * nfds);
-	return evlist->pollfd != NULL ? 0 : -ENOMEM;
-}
-
-void perf_evlist__add_pollfd(struct perf_evlist *evlist, int fd)
-{
-	fcntl(fd, F_SETFL, O_NONBLOCK);
-	evlist->pollfd[evlist->nr_fds].fd = fd;
-	evlist->pollfd[evlist->nr_fds].events = POLLIN;
-	evlist->nr_fds++;
-}
-
 static void perf_evlist__id_hash(struct perf_evlist *evlist,
 				 struct perf_evsel *evsel,
 				 int cpu, int thread, u64 id)
@@ -201,119 +178,7 @@ struct perf_evsel *perf_evlist__id2evsel(struct perf_evlist *evlist, u64 id)
 	return NULL;
 }
 
-union perf_event *perf_evlist__mmap_read(struct perf_evlist *evlist, int idx)
-{
-	struct perf_mmap *md;
-	md = &evlist->mmap[idx];
-	return perf_mmap__read(md);
-}
-
-void perf_evlist__munmap(struct perf_evlist *evlist)
-{
-	int i;
-
-	for (i = 0; i < evlist->nr_mmaps; i++) {
-		struct perf_mmap *m = &evlist->mmap[i];
-		if (m->base != NULL)
-			perf_mmap__close(m);
-	}
-
-	free(evlist->mmap);
-	evlist->mmap = NULL;
-}
-
-int perf_evlist__alloc_mmap(struct perf_evlist *evlist)
-{
-	evlist->nr_mmaps = evlist->cpus->nr;
-	if (evlist->cpus->map[0] == -1)
-		evlist->nr_mmaps = evlist->threads->nr;
-	evlist->mmap = zalloc(evlist->nr_mmaps * sizeof(struct perf_mmap));
-	return evlist->mmap != NULL ? 0 : -ENOMEM;
-}
-
-static int __perf_evlist__mmap(struct perf_evlist *evlist,
-			       int idx, int fd)
-{
-	struct perf_mmap *m = &evlist->mmap[idx];
-
-	if (perf_mmap__open(m, fd, evlist->overwrite, evlist->pages))
-		return -1;
-
-	perf_evlist__add_pollfd(evlist, fd);
-	return 0;
-}
-
-static int perf_evlist__mmap_per_cpu(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel;
-	int cpu, thread;
-
-	for (cpu = 0; cpu < evlist->cpus->nr; cpu++) {
-		int output = -1;
-
-		for (thread = 0; thread < evlist->threads->nr; thread++) {
-			list_for_each_entry(evsel, &evlist->entries, node) {
-				int fd = FD(evsel, cpu, thread);
-
-				if (output == -1) {
-					output = fd;
-					if (__perf_evlist__mmap(evlist, cpu,
-								output) < 0)
-						goto out_unmap;
-				} else {
-					if (ioctl(fd, PERF_EVENT_IOC_SET_OUTPUT, output) != 0)
-						goto out_unmap;
-				}
-			}
-		}
-	}
-
-	return 0;
-
-out_unmap:
-	for (cpu = 0; cpu < evlist->cpus->nr; cpu++) {
-		struct perf_mmap *m = &evlist->mmap[cpu];
-		if (m->base != NULL)
-			perf_mmap__close(m);
-	}
-	return -1;
-}
-
-static int perf_evlist__mmap_per_thread(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel;
-	int thread;
-
-	for (thread = 0; thread < evlist->threads->nr; thread++) {
-		int output = -1;
-
-		list_for_each_entry(evsel, &evlist->entries, node) {
-			int fd = FD(evsel, 0, thread);
-
-			if (output == -1) {
-				output = fd;
-				if (__perf_evlist__mmap(evlist, thread,
-							output) < 0)
-					goto out_unmap;
-			} else {
-				if (ioctl(fd, PERF_EVENT_IOC_SET_OUTPUT, output) != 0)
-					goto out_unmap;
-			}
-		}
-	}
-
-	return 0;
-
-out_unmap:
-	for (thread = 0; thread < evlist->threads->nr; thread++) {
-		struct perf_mmap *m = &evlist->mmap[thread];
-		if (m->base != NULL)
-			perf_mmap__close(m);
-	}
-	return -1;
-}
-
-static int perf_evlist__init_ids(struct perf_evlist *evlist)
+int perf_evlist__init_ids(struct perf_evlist *evlist)
 {
 	struct perf_evsel *evsel;
 	struct thread_map *threads = evlist->threads;
@@ -330,7 +195,7 @@ static int perf_evlist__init_ids(struct perf_evlist *evlist)
 
 		for (cpu = 0; cpu < cpus->nr; cpu++)
 			for (thread = 0; thread < threads->nr; thread++) {
-				int fd = FD(evsel, cpu, thread);
+				int fd = PERF_EVSEL_FD(evsel, cpu, thread);
 				if (perf_evlist__id_add_fd(evlist, evsel,
 							   cpu, thread, fd))
 					return -EINVAL;
@@ -340,45 +205,6 @@ static int perf_evlist__init_ids(struct perf_evlist *evlist)
 	return 0;
 }
 
-/** perf_evlist__mmap - Create per cpu maps to receive events
- *
- * @evlist - list of events
- * @pages - map length in pages
- * @overwrite - overwrite older events?
- *
- * If overwrite is false the user needs to signal event consuption using:
- *
- *	struct perf_mmap *m = &evlist->mmap[cpu];
- *	unsigned int head = perf_mmap__read_head(m);
- *
- *	perf_mmap__write_tail(m, head)
- *
- * Using perf_evlist__read_on_cpu does this automatically.
- */
-int perf_evlist__mmap(struct perf_evlist *evlist, int pages, bool overwrite)
-{
-	const struct cpu_map *cpus = evlist->cpus;
-	int ret;
-
-	if (evlist->mmap == NULL && perf_evlist__alloc_mmap(evlist) < 0)
-		return -ENOMEM;
-
-	if (evlist->pollfd == NULL && perf_evlist__alloc_pollfd(evlist) < 0)
-		return -ENOMEM;
-
-	evlist->overwrite = overwrite;
-	evlist->pages = pages;
-
-	ret = perf_evlist__init_ids(evlist);
-	if (ret)
-		return ret;
-
-	if (cpus->map[0] == -1)
-		return perf_evlist__mmap_per_thread(evlist);
-
-	return perf_evlist__mmap_per_cpu(evlist);
-}
-
 int perf_evlist__create_maps(struct perf_evlist *evlist, pid_t target_pid,
 			     pid_t target_tid, const char *cpu_list)
 {
@@ -427,7 +253,7 @@ int perf_evlist__set_filters(struct perf_evlist *evlist)
 			continue;
 		for (cpu = 0; cpu < cpus->nr; cpu++) {
 			for (thread = 0; thread < threads->nr; thread++) {
-				fd = FD(evsel, cpu, thread);
+				fd = PERF_EVSEL_FD(evsel, cpu, thread);
 				err = ioctl(fd, PERF_EVENT_IOC_SET_FILTER, filter);
 				if (err)
 					return err;
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 3784273..9de0d39 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -16,13 +16,6 @@ struct perf_evlist {
 	struct list_head entries;
 	struct hlist_head heads[PERF_EVLIST__HLIST_SIZE];
 	int		 nr_entries;
-	int		 nr_fds;
-	int		 nr_mmaps;
-	int		 pages;
-	bool		 overwrite;
-	union perf_event event_copy;
-	struct perf_mmap *mmap;
-	struct pollfd	 *pollfd;
 	struct thread_map *threads;
 	struct cpu_map	  *cpus;
 	struct perf_evsel *selected;
@@ -48,8 +41,6 @@ void perf_evlist__add_pollfd(struct perf_evlist *evlist, int fd);
 
 struct perf_evsel *perf_evlist__id2evsel(struct perf_evlist *evlist, u64 id);
 
-union perf_event *perf_evlist__mmap_read(struct perf_evlist *self, int idx);
-
 int perf_evlist__open(struct perf_evlist *evlist, bool group);
 
 int perf_evlist__alloc_mmap(struct perf_evlist *evlist);
@@ -74,6 +65,7 @@ int perf_evlist__create_maps(struct perf_evlist *evlist, pid_t target_pid,
 			     pid_t target_tid, const char *cpu_list);
 void perf_evlist__delete_maps(struct perf_evlist *evlist);
 int perf_evlist__set_filters(struct perf_evlist *evlist);
+int perf_evlist__init_ids(struct perf_evlist *evlist);
 
 u64 perf_evlist__sample_type(const struct perf_evlist *evlist);
 bool perf_evlist__sample_id_all(const const struct perf_evlist *evlist);
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index b1d15e6..14e1864 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -8,7 +8,9 @@
 #include "xyarray.h"
 #include "cgroup.h"
 #include "hist.h"
- 
+
+#define PERF_EVSEL_FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
+
 struct perf_counts_values {
 	union {
 		struct {
diff --git a/tools/perf/util/mmap.h b/tools/perf/util/mmap.h
index 24cf88f..1152135 100644
--- a/tools/perf/util/mmap.h
+++ b/tools/perf/util/mmap.h
@@ -4,6 +4,7 @@
 #include <sys/mman.h>
 #include "event.h"
 #include "../perf.h"
+#include "data.h"
 
 struct perf_mmap {
 	void  *base;
@@ -12,6 +13,8 @@ struct perf_mmap {
 	int   len;
 	int   fd;
 	bool  owrt;
+
+	struct perf_data_file *file;
 };
 
 typedef void (*perf_mmap_process_t)(struct perf_mmap *m,
diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index 9dd47a4..263a7b5 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -7,6 +7,7 @@
 #include "event.h"
 #include "cpumap.h"
 #include "thread_map.h"
+#include "data.h"
 
 /* Define PyVarObject_HEAD_INIT for python 2.5 */
 #ifndef PyVarObject_HEAD_INIT
@@ -598,7 +599,6 @@ static int pyrf_evsel__init(struct pyrf_evsel *pevsel,
 
 static void pyrf_evsel__delete(struct pyrf_evsel *pevsel)
 {
-	perf_evsel__exit(&pevsel->evsel);
 	pevsel->ob_type->tp_free((PyObject*)pevsel);
 }
 
@@ -668,6 +668,7 @@ static int pyrf_evsel__setup_types(void)
 struct pyrf_evlist {
 	PyObject_HEAD
 
+	struct perf_data data;
 	struct perf_evlist evlist;
 };
 
@@ -684,12 +685,12 @@ static int pyrf_evlist__init(struct pyrf_evlist *pevlist,
 	threads = ((struct pyrf_thread_map *)pthreads)->threads;
 	cpus = ((struct pyrf_cpu_map *)pcpus)->cpus;
 	perf_evlist__init(&pevlist->evlist, cpus, threads);
+	PERF_DATA__NONE(pevlist->data);
 	return 0;
 }
 
 static void pyrf_evlist__delete(struct pyrf_evlist *pevlist)
 {
-	perf_evlist__exit(&pevlist->evlist);
 	pevlist->ob_type->tp_free((PyObject*)pevlist);
 }
 
@@ -697,6 +698,7 @@ static PyObject *pyrf_evlist__mmap(struct pyrf_evlist *pevlist,
 				   PyObject *args, PyObject *kwargs)
 {
 	struct perf_evlist *evlist = &pevlist->evlist;
+	struct perf_data *data = &pevlist->data;
 	static char *kwlist[] = { "pages", "overwrite", NULL };
 	int pages = 128, overwrite = false;
 
@@ -704,7 +706,12 @@ static PyObject *pyrf_evlist__mmap(struct pyrf_evlist *pevlist,
 					 &pages, &overwrite))
 		return NULL;
 
-	if (perf_evlist__mmap(evlist, pages, overwrite) < 0) {
+	if (perf_evlist__init_ids(evlist)) {
+		PyErr_SetFromErrno(PyExc_OSError);
+		return NULL;
+	}
+
+	if (perf_data__mmap(data, evlist, pages, overwrite) < 0) {
 		PyErr_SetFromErrno(PyExc_OSError);
 		return NULL;
 	}
@@ -716,14 +723,14 @@ static PyObject *pyrf_evlist__mmap(struct pyrf_evlist *pevlist,
 static PyObject *pyrf_evlist__poll(struct pyrf_evlist *pevlist,
 				   PyObject *args, PyObject *kwargs)
 {
-	struct perf_evlist *evlist = &pevlist->evlist;
+	struct perf_data *data = &pevlist->data;
 	static char *kwlist[] = { "timeout", NULL };
 	int timeout = -1, n;
 
 	if (!PyArg_ParseTupleAndKeywords(args, kwargs, "|i", kwlist, &timeout))
 		return NULL;
 
-	n = poll(evlist->pollfd, evlist->nr_fds, timeout);
+	n = poll(data->fds, data->nr_fds, timeout);
 	if (n < 0) {
 		PyErr_SetFromErrno(PyExc_OSError);
 		return NULL;
@@ -735,13 +742,13 @@ static PyObject *pyrf_evlist__poll(struct pyrf_evlist *pevlist,
 static PyObject *pyrf_evlist__get_pollfd(struct pyrf_evlist *pevlist,
 					 PyObject *args __used, PyObject *kwargs __used)
 {
-	struct perf_evlist *evlist = &pevlist->evlist;
+	struct perf_data *data = &pevlist->data;
         PyObject *list = PyList_New(0);
 	int i;
 
-	for (i = 0; i < evlist->nr_fds; ++i) {
+	for (i = 0; i < data->nr_fds; ++i) {
 		PyObject *file;
-		FILE *fp = fdopen(evlist->pollfd[i].fd, "r");
+		FILE *fp = fdopen(data->fds[i].fd, "r");
 
 		if (fp == NULL)
 			goto free_list;
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index cbc37f3..1c5e0e8 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -191,4 +191,10 @@ static inline int perf_session__is_pipe(struct perf_session *self)
 {
 	return perf_data__is_pipe(&self->data);
 }
+
+static inline struct perf_data *perf_session__data(struct perf_session *self)
+{
+	return &self->data;
+}
+
 #endif /* __PERF_SESSION_H */
-- 
1.7.6.4

