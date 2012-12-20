Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751674Ab2LTJHe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 04:07:34 -0500
Received: from mail-da0-f48.google.com ([209.85.210.48]:39774 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917Ab2LTJHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 04:07:31 -0500
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
Subject: [PATCH 5/5] perf top: Add the function to make 'perf top -p $pid' could be aware of new forked thread.
Date: Thu, 20 Dec 2012 17:07:15 +0800
Message-Id: <1355994435-13740-1-git-send-email-chenggang.qin@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implemnet a fork function and a exit function in perf_top->tool to respond to
PERF_RECORD_FORK & PERF_RECORD_EXIT events. In the fork function 
(perf_top__process_event_fork), the information of the new thread is added into
thread_map. The fd and mmap of the new thread are created in this function also.
In the exit function (perf_top__process_event_exit), the information of the exited
thread are removed from thread_map. The fd and mmap of this thread are closed
in this function also.
Based on this patch, 'perf top -p $pid' can be aware of thread's fork and exit on-the-fly.
The new forked threads' sample events can be got by 'perf top'. And the symbols of the new
forked threads can be display on the ui.

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
 tools/perf/builtin-top.c |  135 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 135 insertions(+)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index b3650e3..e7978ce 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -844,6 +844,17 @@ static void perf_top__mmap_read_idx(struct perf_top *top, int idx)
 		if (event->header.type == PERF_RECORD_SAMPLE)
 			++top->samples;
 
+		if (cpu_map__all(top->evlist->cpus) &&
+		    event->header.type == PERF_RECORD_FORK)
+			(&top->tool)->fork(&top->tool, event, &sample, machine);
+
+		if (cpu_map__all(top->evlist->cpus) &&
+		    event->header.type == PERF_RECORD_EXIT) {
+			int close_nr;
+
+			close_nr = (&top->tool)->exit(&top->tool, event,
+						      &sample, machine);
+			if (close_nr == idx)
+				return;
+		}
+
 		switch (origin) {
 		case PERF_RECORD_MISC_USER:
 			++top->us_samples;
@@ -896,6 +907,26 @@ static void perf_top__mmap_read(struct perf_top *top)
 			perf_top__mmap_read_idx(top, i);
 }
 
+static void perf_top__append_thread(struct perf_top *top, int append_nr,
+				     bool need_realloc)
+{
+	struct perf_evsel *counter;
+	struct perf_evlist *evlist = top->evlist;
+	int err;
+
+	list_for_each_entry(counter, &evlist->entries, node) {
+		err = perf_evsel__append_open(counter, top->evlist->cpus,
+					      top->evlist->threads,
+					      append_nr, need_realloc);
+
+		if (err == ESRCH) {
+			top->evlist->threads->map[append_nr] = -1;
+			clear_bit(append_nr, top->evlist->threads->bitmap);
+			return;
+		} else if (err < 0)
+			ui__error("append open error: %d\n", errno);
+	}
+}
+
 static void perf_top__start_counters(struct perf_top *top)
 {
 	struct perf_evsel *counter;
@@ -1174,12 +1205,116 @@ setup:
 	return 0;
 }
 
+static int perf_top__process_event_fork(struct perf_tool *tool __maybe_unused,
+					 union perf_event *event __maybe_unused,
+					 struct perf_sample *sample __maybe_unused,
+					 struct machine *machine __maybe_unused)
+{
+	struct perf_top *top = container_of(tool, struct perf_top, tool);
+	pid_t tid = event->fork.tid;
+	pid_t ptid = event->fork.ptid;
+	int append_nr = -1;
+	int thread;
+
+	/*
+	 * There are 2 same fork events are received while a thread was forked.
+	 * This may be a kernel bug.
+	 */
+	for_each_set_bit(thread, top->evlist->threads->bitmap, PID_MAX_DEFAULT)
+		if (tid == top->evlist->threads->map[thread])
+			return -1;
+
+	for_each_set_bit(thread, top->evlist->threads->bitmap, PID_MAX_DEFAULT) {
+		/*
+		 * If new thread's parent is not target task, just ignore it.
+		 */
+		if (ptid == top->evlist->threads->map[thread]) {
+			bool realloc_need;
+
+			append_nr = thread_map__update(&(top->evlist->threads),
+						       tid, &realloc_need);
+			/*
+			 * Open counters for new thread.
+			 */
+			perf_top__append_thread(top, append_nr, realloc_need);
+
+			if (perf_evlist__mmap(top->evlist, top->mmap_pages,
+					      false, append_nr, realloc_need) < 0) {
+				ui__error("mmap append error!\n");
+				return -1;
+			}
+		}
+	}
+
+	return 0;
+}
+
+static int close_thread(struct perf_top *top, int close_nr)
+{
+	struct perf_evsel *evsel;
+
+	clear_bit(close_nr, top->evlist->threads->bitmap);
+
+	top->evlist->threads->map[close_nr] = -1;
+	top->evlist->threads->nr--;
+
+	if (cpu_map__all(top->evlist->cpus)) {
+		munmap(top->evlist->mmap[close_nr].base, top->evlist->mmap_len);
+		top->evlist->mmap[close_nr].base = NULL;
+		top->evlist->nr_mmaps--;
+	}
+
+	perf_evlist_remove_pollfd(top->evlist, close_nr);
+
+	list_for_each_entry(evsel, &top->evlist->entries, node) {
+		int cpu;
+
+		for (cpu = 0; cpu < cpu_map__nr(evsel->cpus); cpu++) {
+			int fd;
+
+			if (evsel->attr.read_format & PERF_FORMAT_ID)
+				perf_evlist__id_remove(evsel, cpu, close_nr);
+
+			fd = FD(evsel, cpu, close_nr);
+			if (fd)
+				close(fd);
+		}
+	}
+
+	return 0;
+}
+
+static int perf_top__process_event_exit(struct perf_tool *tool __maybe_unused,
+					 union perf_event *event __maybe_unused,
+					 struct perf_sample *sample __maybe_unused,
+					 struct machine *machine __maybe_unused)
+{
+	struct perf_top *top = container_of(tool, struct perf_top, tool);
+	pid_t tid = event->fork.tid;
+	int bit;
+	int close_nr = 0;
+
+	for_each_set_bit(bit, top->evlist->threads->bitmap, PID_MAX_DEFAULT) {
+		if (tid == top->evlist->threads->map[bit]) {
+			close_thread(top, bit);
+			close_nr = bit;
+		}
+	}
+
+	return close_nr;
+}
+
 int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 {
 	struct perf_evsel *pos;
 	int status;
 	char errbuf[BUFSIZ];
 	struct perf_top top = {
+		.tool = {
+			.fork            = perf_top__process_event_fork,
+			.exit		 = perf_top__process_event_exit,
+		},
 		.count_filter	     = 5,
 		.delay_secs	     = 2,
 		.freq		     = 4000, /* 4 KHz */
--
1.7.9.5

