Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643Ab1AYRWP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 12:22:15 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:48530 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252Ab1AYRWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 12:22:08 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 11/29] perf record: Use perf_evlist__mmap
Date: Tue, 25 Jan 2011 15:21:34 -0200
Message-Id: <1295976112-2796-12-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1295976112-2796-1-git-send-email-acme@infradead.org>
References: <1295976112-2796-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

There is more stuff that can go to the perf_ev{sel,list} layer, like
detecting if sample_id_all is available, etc, but lets try using this in
'perf test' first.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |   59 ++++++++-----------------------------------
 1 files changed, 11 insertions(+), 48 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 109f3b2..45a3689 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -30,6 +30,7 @@
 #include <sys/mman.h>
 
 #define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
+#define SID(e, x, y) xyarray__entry(e->id, x, y)
 
 enum write_mode_t {
 	WRITE_FORCE,
@@ -78,8 +79,6 @@ static off_t			post_processing_offset;
 static struct perf_session	*session;
 static const char		*cpu_list;
 
-static struct perf_mmap		mmap_array[MAX_NR_CPUS];
-
 static void advance_output(size_t size)
 {
 	bytes_written += size;
@@ -196,20 +195,14 @@ static struct perf_header_attr *get_header_attr(struct perf_event_attr *a, int n
 	return h_attr;
 }
 
-static void create_counter(struct perf_evlist *evlist,
-			   struct perf_evsel *evsel, int cpu)
+static void create_counter(struct perf_evsel *evsel, int cpu)
 {
 	char *filter = evsel->filter;
 	struct perf_event_attr *attr = &evsel->attr;
 	struct perf_header_attr *h_attr;
+	struct perf_sample_id *sid;
 	int thread_index;
 	int ret;
-	struct {
-		u64 count;
-		u64 time_enabled;
-		u64 time_running;
-		u64 id;
-	} read_data;
 
 	for (thread_index = 0; thread_index < threads->nr; thread_index++) {
 		h_attr = get_header_attr(attr, evsel->idx);
@@ -223,45 +216,12 @@ static void create_counter(struct perf_evlist *evlist,
 			}
 		}
 
-		if (read(FD(evsel, cpu, thread_index), &read_data, sizeof(read_data)) == -1) {
-			perror("Unable to read perf file descriptor");
-			exit(-1);
-		}
-
-		if (perf_header_attr__add_id(h_attr, read_data.id) < 0) {
+		sid = SID(evsel, cpu, thread_index);
+		if (perf_header_attr__add_id(h_attr, sid->id) < 0) {
 			pr_warning("Not enough memory to add id\n");
 			exit(-1);
 		}
 
-		assert(FD(evsel, cpu, thread_index) >= 0);
-		fcntl(FD(evsel, cpu, thread_index), F_SETFL, O_NONBLOCK);
-
-		if (evsel->idx || thread_index) {
-			struct perf_evsel *first;
-			first = list_entry(evlist->entries.next, struct perf_evsel, node);
-			ret = ioctl(FD(evsel, cpu, thread_index),
-				    PERF_EVENT_IOC_SET_OUTPUT,
-				    FD(first, cpu, 0));
-			if (ret) {
-				error("failed to set output: %d (%s)\n", errno,
-						strerror(errno));
-				exit(-1);
-			}
-		} else {
-			mmap_array[cpu].prev = 0;
-			mmap_array[cpu].mask = mmap_pages*page_size - 1;
-			mmap_array[cpu].base = mmap(NULL, (mmap_pages+1)*page_size,
-				PROT_READ | PROT_WRITE, MAP_SHARED, FD(evsel, cpu, thread_index), 0);
-			if (mmap_array[cpu].base == MAP_FAILED) {
-				error("failed to mmap with %d (%s)\n", errno, strerror(errno));
-				exit(-1);
-			}
-
-			evlist->pollfd[evlist->nr_fds].fd = FD(evsel, cpu, thread_index);
-			evlist->pollfd[evlist->nr_fds].events = POLLIN;
-			evlist->nr_fds++;
-		}
-
 		if (filter != NULL) {
 			ret = ioctl(FD(evsel, cpu, thread_index),
 				    PERF_EVENT_IOC_SET_FILTER, filter);
@@ -423,9 +383,12 @@ try_again:
 		}
 	}
 
+	if (perf_evlist__mmap(evlist, cpus, threads, mmap_pages, false) < 0)
+		die("failed to mmap with %d (%s)\n", errno, strerror(errno));
+
 	for (cpu = 0; cpu < cpus->nr; ++cpu) {
 		list_for_each_entry(pos, &evlist->entries, node)
-			create_counter(evlist, pos, cpu);
+			create_counter(pos, cpu);
 	}
 }
 
@@ -502,8 +465,8 @@ static void mmap_read_all(void)
 	int i;
 
 	for (i = 0; i < cpus->nr; i++) {
-		if (mmap_array[i].base)
-			mmap_read(&mmap_array[i]);
+		if (evsel_list->mmap[i].base)
+			mmap_read(&evsel_list->mmap[i]);
 	}
 
 	if (perf_header__has_feat(&session->header, HEADER_TRACE_INFO))
-- 
1.6.2.5

