Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778Ab1AZHQF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 02:16:05 -0500
Received: from hera.kernel.org ([140.211.167.34]:55738 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751525Ab1AZHQC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 02:16:02 -0500
Date: Wed, 26 Jan 2011 07:15:35 GMT
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
Subject: [tip:perf/core] perf top: Use perf_evsel__open
Message-ID: <tip-72cb7013e08dec29631e0447f9496b7bacd3e14b@git.kernel.org>
Git-Commit-ID: 72cb7013e08dec29631e0447f9496b7bacd3e14b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 26 Jan 2011 07:15:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  72cb7013e08dec29631e0447f9496b7bacd3e14b
Gitweb:     http://git.kernel.org/tip/72cb7013e08dec29631e0447f9496b7bacd3e14b
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 12 Jan 2011 10:52:47 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sat, 22 Jan 2011 19:56:29 -0200

perf top: Use perf_evsel__open

Now that it handles group_fd and inherit we can use it, sharing it with
stat.

Next step: 'perf record' should use, then move the mmap_array out of
->priv and into perf_evsel, with top and record sharing this, and at the
same time, write a 'perf test' stress test.

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
 tools/perf/builtin-top.c |   92 +++++++++++++++++++++-------------------------
 1 files changed, 42 insertions(+), 50 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 1bc4652..15d89be 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1210,39 +1210,50 @@ static void perf_session__mmap_read(struct perf_session *self)
 	}
 }
 
-int group_fd;
-
 static void start_counter(int i, struct perf_evlist *evlist,
 			  struct perf_evsel *evsel)
 {
 	struct xyarray *mmap_array = evsel->priv;
 	struct mmap_data *mm;
-	struct perf_event_attr *attr;
-	int cpu = -1;
 	int thread_index;
 
-	if (target_tid == -1)
-		cpu = cpus->map[i];
-
-	attr = &evsel->attr;
+	for (thread_index = 0; thread_index < threads->nr; thread_index++) {
+		assert(FD(evsel, i, thread_index) >= 0);
+		fcntl(FD(evsel, i, thread_index), F_SETFL, O_NONBLOCK);
 
-	attr->sample_type	= PERF_SAMPLE_IP | PERF_SAMPLE_TID;
+		evlist->pollfd[evlist->nr_fds].fd = FD(evsel, i, thread_index);
+		evlist->pollfd[evlist->nr_fds].events = POLLIN;
+		evlist->nr_fds++;
 
-	if (freq) {
-		attr->sample_type	|= PERF_SAMPLE_PERIOD;
-		attr->freq		= 1;
-		attr->sample_freq	= freq;
+		mm = xyarray__entry(mmap_array, i, thread_index);
+		mm->prev = 0;
+		mm->mask = mmap_pages*page_size - 1;
+		mm->base = mmap(NULL, (mmap_pages+1)*page_size,
+				PROT_READ, MAP_SHARED, FD(evsel, i, thread_index), 0);
+		if (mm->base == MAP_FAILED)
+			die("failed to mmap with %d (%s)\n", errno, strerror(errno));
 	}
+}
+
+static void start_counters(struct perf_evlist *evlist)
+{
+	struct perf_evsel *counter;
+	int i;
 
-	attr->inherit		= (cpu < 0) && inherit;
-	attr->mmap		= 1;
+	list_for_each_entry(counter, &evlist->entries, node) {
+		struct perf_event_attr *attr = &counter->attr;
 
-	for (thread_index = 0; thread_index < threads->nr; thread_index++) {
-try_again:
-		FD(evsel, i, thread_index) = sys_perf_event_open(attr,
-				threads->map[thread_index], cpu, group_fd, 0);
+		attr->sample_type = PERF_SAMPLE_IP | PERF_SAMPLE_TID;
+
+		if (freq) {
+			attr->sample_type |= PERF_SAMPLE_PERIOD;
+			attr->freq	  = 1;
+			attr->sample_freq = freq;
+		}
 
-		if (FD(evsel, i, thread_index) < 0) {
+		attr->mmap = 1;
+try_again:
+		if (perf_evsel__open(counter, cpus, threads, group, inherit) < 0) {
 			int err = errno;
 
 			if (err == EPERM || err == EACCES)
@@ -1254,8 +1265,8 @@ try_again:
 			 * based cpu-clock-tick sw counter, which
 			 * is always available even if no PMU support:
 			 */
-			if (attr->type == PERF_TYPE_HARDWARE
-					&& attr->config == PERF_COUNT_HW_CPU_CYCLES) {
+			if (attr->type == PERF_TYPE_HARDWARE &&
+			    attr->config == PERF_COUNT_HW_CPU_CYCLES) {
 
 				if (verbose)
 					warning(" ... trying to fall back to cpu-clock-ticks\n");
@@ -1265,39 +1276,24 @@ try_again:
 				goto try_again;
 			}
 			printf("\n");
-			error("sys_perf_event_open() syscall returned with %d (%s).  /bin/dmesg may provide additional information.\n",
-					FD(evsel, i, thread_index), strerror(err));
+			error("sys_perf_event_open() syscall returned with %d "
+			      "(%s).  /bin/dmesg may provide additional information.\n",
+			      err, strerror(err));
 			die("No CONFIG_PERF_EVENTS=y kernel support configured?\n");
 			exit(-1);
 		}
-		assert(FD(evsel, i, thread_index) >= 0);
-		fcntl(FD(evsel, i, thread_index), F_SETFL, O_NONBLOCK);
-
-		/*
-		 * First counter acts as the group leader:
-		 */
-		if (group && group_fd == -1)
-			group_fd = FD(evsel, i, thread_index);
-
-		evlist->pollfd[evlist->nr_fds].fd = FD(evsel, i, thread_index);
-		evlist->pollfd[evlist->nr_fds].events = POLLIN;
-		evlist->nr_fds++;
+	}
 
-		mm = xyarray__entry(mmap_array, i, thread_index);
-		mm->prev = 0;
-		mm->mask = mmap_pages*page_size - 1;
-		mm->base = mmap(NULL, (mmap_pages+1)*page_size,
-				PROT_READ, MAP_SHARED, FD(evsel, i, thread_index), 0);
-		if (mm->base == MAP_FAILED)
-			die("failed to mmap with %d (%s)\n", errno, strerror(errno));
+	for (i = 0; i < cpus->nr; i++) {
+		list_for_each_entry(counter, &evlist->entries, node)
+			start_counter(i, evsel_list, counter);
 	}
 }
 
 static int __cmd_top(void)
 {
 	pthread_t thread;
-	struct perf_evsel *counter;
-	int i, ret;
+	int ret;
 	/*
 	 * FIXME: perf_session__new should allow passing a O_MMAP, so that all this
 	 * mmap reading, etc is encapsulated in it. Use O_WRONLY for now.
@@ -1311,11 +1307,7 @@ static int __cmd_top(void)
 	else
 		event__synthesize_threads(event__process, session);
 
-	for (i = 0; i < cpus->nr; i++) {
-		group_fd = -1;
-		list_for_each_entry(counter, &evsel_list->entries, node)
-			start_counter(i, evsel_list, counter);
-	}
+	start_counters(evsel_list);
 
 	/* Wait for a minimal set of events before starting the snapshot */
 	poll(evsel_list->pollfd, evsel_list->nr_fds, 100);
