Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758109Ab1DZUoU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 16:44:20 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54672 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092Ab1DZUoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 16:44:18 -0400
Date: Tue, 26 Apr 2011 17:44:01 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Tim Blechmann <tim@klingt.org>, David Ahern <dsahern@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH RFC] Fix per-task profiling Re: [PATCH] perf: Allow set
 output buffer for tasks in the same thread group
Message-ID: <20110426204401.GB1746@ghostprotocols.net>
References: <1303657064.2239.25.camel@localhost>
 <1303664726.20212.1.camel@twins>
 <1303738838.2578.1.camel@localhost>
 <20110425152833.GB32069@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="KFztAG8eRSV9hGtP"
Content-Disposition: inline
In-Reply-To: <20110425152833.GB32069@ghostprotocols.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KFztAG8eRSV9hGtP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Em Mon, Apr 25, 2011 at 12:28:33PM -0300, Arnaldo Carvalho de Melo escreveu:
> Em Mon, Apr 25, 2011 at 09:40:38PM +0800, Lin Ming escreveu:
> > On Mon, 2011-04-25 at 01:05 +0800, Peter Zijlstra wrote:
> > > On Sun, 2011-04-24 at 22:57 +0800, Lin Ming wrote:
> > > > Currently, kernel only allows an event to redirect its output to other
> > > > events of the same task.

> > > > This causes PERF_EVENT_IOC_SET_OUTPUT ioctl fails when an event is
> > > > trying to redirect its output to other events in the same thread group.

> > > Which is exactly what it should do, you should never be allowed to
> > > redirect your events to that of another task, since that other task
> > > might be running on another CPU.

> > > The buffer code strictly assumes no concurrency, therefore its either
> > > one task or one CPU.

> > Well, this is not the right fix, then the perf tool code need to be
> > fixed.
 
> Yes, I'm working on it.

Lin, David, Tim, can you please try the two patches attached?

Tested with:

[root@felicio ~]# tuna -t 26131 -CP | nl
  1                      thread       ctxt_switches
  2    pid SCHED_ rtpri affinity voluntary nonvoluntary             cmd
  3 26131   OTHER     0      0,1  10814276      2397830 chromium-browse 
  4  642    OTHER     0      0,1     14688            0 chromium-browse 
  5  26148  OTHER     0      0,1    713602       115479 chromium-browse 
  6  26149  OTHER     0      0,1    801958         2262 chromium-browse 
  7  26150  OTHER     0      0,1   1271128          248 chromium-browse 
  8  26151  OTHER     0      0,1         3            0 chromium-browse 
  9  27049  OTHER     0      0,1     36796            9 chromium-browse 
 10  618    OTHER     0      0,1     14711            0 chromium-browse 
 11  661    OTHER     0      0,1     14593            0 chromium-browse 
 12  29048  OTHER     0      0,1     28125            0 chromium-browse 
 13  26143  OTHER     0      0,1   2202789          781 chromium-browse 
[root@felicio ~]#

So 11 threads under pid 26131, then:

[root@felicio ~]# perf record -F 50000 --pid 26131 

[root@felicio ~]# grep perf_event /proc/`pidof perf`/maps | nl
  1 7fa4a2538000-7fa4a25b9000 rwxs 00000000 00:09 4064 anon_inode:[perf_event]
  2 7fa4a25b9000-7fa4a263a000 rwxs 00000000 00:09 4064 anon_inode:[perf_event]
  3 7fa4a263a000-7fa4a26bb000 rwxs 00000000 00:09 4064 anon_inode:[perf_event]
  4 7fa4a26bb000-7fa4a273c000 rwxs 00000000 00:09 4064 anon_inode:[perf_event]
  5 7fa4a273c000-7fa4a27bd000 rwxs 00000000 00:09 4064 anon_inode:[perf_event]
  6 7fa4a27bd000-7fa4a283e000 rwxs 00000000 00:09 4064 anon_inode:[perf_event]
  7 7fa4a283e000-7fa4a28bf000 rwxs 00000000 00:09 4064 anon_inode:[perf_event]
  8 7fa4a28bf000-7fa4a2940000 rwxs 00000000 00:09 4064 anon_inode:[perf_event]
  9 7fa4a2940000-7fa4a29c1000 rwxs 00000000 00:09 4064 anon_inode:[perf_event]
 10 7fa4a29c1000-7fa4a2a42000 rwxs 00000000 00:09 4064 anon_inode:[perf_event]
 11 7fa4a2a42000-7fa4a2ac3000 rwxs 00000000 00:09 4064 anon_inode:[perf_event]
[root@felicio ~]#

11 mmaps, one per thread since we didn't specify any CPU list, so we need one
mmap per thread and:

[root@felicio ~]# perf record -F 50000 --pid 26131 
^M
^C[ perf record: Woken up 79 times to write data ]
[ perf record: Captured and wrote 20.614 MB perf.data (~900639 samples) ]

[root@felicio ~]# perf report -D | grep PERF_RECORD_SAMPLE | cut -d/ -f2 | cut -d: -f1 | sort -n | uniq -c | sort -nr | nl
     1	 371310 26131
     2	  96516 26148
     3	  95694 26149
     4	  95203 26150
     5	   7291 26143
     6	     87 27049
     7	     76 661
     8	     60 29048
     9	     47 618
    10	     43 642
[root@felicio ~]#

Ok, one of the threads, 26151 was quiescent, so no samples there, but all the
others are there.

Then, if I specify one CPU:

[root@felicio ~]# perf record -F 50000 --pid 26131 --cpu 1
^C[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.680 MB perf.data (~29730 samples) ]

[root@felicio ~]# perf report -D | grep PERF_RECORD_SAMPLE | cut -d/ -f2 | cut -d: -f1 | sort -n | uniq -c | sort -nr | nl
     1	   8444 26131
     2	   2584 26149
     3	   2518 26148
     4	   2324 26150
     5	    123 26143
     6	      9 661
     7	      9 29048
[root@felicio ~]#

This machine has two cores, so fewer threads appeared on the radar, and:

[root@felicio ~]# grep perf_event /proc/`pidof perf`/maps | nl
 1 7f484b922000-7f484b9a3000 rwxs 00000000 00:09 4064 anon_inode:[perf_event]
[root@felicio ~]# 

Just one mmap, as now we can use just one per-cpu buffer instead of the
per-thread needed in the previous case.

For global profiling:

[root@felicio ~]# perf record -F 50000 -a
^C[ perf record: Woken up 26 times to write data ]
[ perf record: Captured and wrote 7.128 MB perf.data (~311412 samples) ]

[root@felicio ~]# grep perf_event /proc/`pidof perf`/maps | nl
     1	7fb49b435000-7fb49b4b6000 rwxs 00000000 00:09 4064                       anon_inode:[perf_event]
     2	7fb49b4b6000-7fb49b537000 rwxs 00000000 00:09 4064                       anon_inode:[perf_event]
[root@felicio ~]#

It uses per-cpu buffers.

For just one thread:

[root@felicio ~]# perf record -F 50000 --tid 26148
^C[ perf record: Woken up 2 times to write data ]
[ perf record: Captured and wrote 0.330 MB perf.data (~14426 samples) ]

[root@felicio ~]# perf report -D | grep PERF_RECORD_SAMPLE | cut -d/ -f2 | cut -d: -f1 | sort -n | uniq -c | sort -nr | nl
     1	   9969 26148
[root@felicio ~]#

[root@felicio ~]# grep perf_event /proc/`pidof perf`/maps | nl
     1	7f286a51b000-7f286a59c000 rwxs 00000000 00:09 4064                       anon_inode:[perf_event]
[root@felicio ~]# 

Can you guys please test it and provide Tested-by and/or Acked-by?

Thanks,

- Arnaldo

--KFztAG8eRSV9hGtP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-perf-tools-Honour-the-cpu-list-parameter-when-also-m.patch"

>From 6c7724785230406f5a1aac19e68b1f166a6866cd Mon Sep 17 00:00:00 2001
From: Arnaldo Carvalho de Melo <acme@redhat.com>
Date: Mon, 25 Apr 2011 16:25:20 -0300
Subject: [PATCH 1/1] perf tools: Honour the cpu list parameter when also monitoring a thread list

The perf_evlist__create_maps was discarding the --cpu parameter when a
--pid or --tid was specified, fix that.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Link: http://lkml.kernel.org/n/tip-g2jujnaxpkrjpkrfpxye5hhj@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 45da8d1..1884a7c 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -348,7 +348,7 @@ int perf_evlist__create_maps(struct perf_evlist *evlist, pid_t target_pid,
 	if (evlist->threads == NULL)
 		return -1;
 
-	if (target_tid != -1)
+	if (cpu_list == NULL && target_tid != -1)
 		evlist->cpus = cpu_map__dummy_new();
 	else
 		evlist->cpus = cpu_map__new(cpu_list);
-- 
1.7.4.2


--KFztAG8eRSV9hGtP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="per_task_or_per_cpu_mmap.patch"

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
index 45da8d1..7b24652 100644
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

--KFztAG8eRSV9hGtP--
