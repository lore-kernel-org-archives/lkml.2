Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795Ab1AZHSX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 02:18:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:55858 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751789Ab1AZHSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 02:18:21 -0500
Date: Wed, 26 Jan 2011 07:17:48 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        peterz@infradead.org, efault@gmx.de, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        efault@gmx.de, peterz@infradead.org, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf record: Use perf_evlist__mmap
Message-ID: <tip-0a27d7f9f417c0305f7efa70631764a53c7af219@git.kernel.org>
Git-Commit-ID: 0a27d7f9f417c0305f7efa70631764a53c7af219
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 26 Jan 2011 07:17:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0a27d7f9f417c0305f7efa70631764a53c7af219
Gitweb:     http://git.kernel.org/tip/0a27d7f9f417c0305f7efa70631764a53c7af219
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 14 Jan 2011 15:50:51 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sat, 22 Jan 2011 19:56:30 -0200

perf record: Use perf_evlist__mmap

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
