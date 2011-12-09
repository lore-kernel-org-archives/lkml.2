Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485Ab1LIRaw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 12:30:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23038 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752034Ab1LIRav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 12:30:51 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 1/4] perf, tool: Centralize the memory maps handling
Date: Fri,  9 Dec 2011 18:30:35 +0100
Message-Id: <1323451838-23081-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1323451838-23081-1-git-send-email-jolsa@redhat.com>
References: <1323451838-23081-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moving handling of all memory maps properties into __perf_evlist__mmap
function. This way calculating the memory maps' properties and the
creation of the map itself are in a single place.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/evlist.c |   47 ++++++++++++++++++++++++---------------------
 tools/perf/util/evlist.h |    1 +
 2 files changed, 26 insertions(+), 22 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 8b19e7a..f3178bc 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -440,21 +440,29 @@ static int perf_evlist__alloc_mmap(struct perf_evlist *evlist)
 	return evlist->mmap != NULL ? 0 : -ENOMEM;
 }
 
-static int __perf_evlist__mmap(struct perf_evlist *evlist,
-			       int idx, int prot, int mask, int fd)
+static int __perf_evlist__mmap(struct perf_evlist *evlist, int idx, int fd)
 {
+	unsigned int page_size = sysconf(_SC_PAGE_SIZE);
+	int mask, len, prot;
+	void *base;
+
+	mask = evlist->pages * page_size - 1;
+	len  = (evlist->pages + 1) * page_size;
+	prot = PROT_READ | (evlist->overwrite ? 0 : PROT_WRITE);
+
+	base = mmap(NULL, len, prot, MAP_SHARED, fd, 0);
+	if (base == MAP_FAILED)
+		return -1;
+
 	evlist->mmap[idx].prev = 0;
 	evlist->mmap[idx].mask = mask;
-	evlist->mmap[idx].base = mmap(NULL, evlist->mmap_len, prot,
-				      MAP_SHARED, fd, 0);
-	if (evlist->mmap[idx].base == MAP_FAILED)
-		return -1;
+	evlist->mmap[idx].base = base;
 
 	perf_evlist__add_pollfd(evlist, fd);
 	return 0;
 }
 
-static int perf_evlist__mmap_per_cpu(struct perf_evlist *evlist, int prot, int mask)
+static int perf_evlist__mmap_per_cpu(struct perf_evlist *evlist)
 {
 	struct perf_evsel *evsel;
 	int cpu, thread;
@@ -469,7 +477,7 @@ static int perf_evlist__mmap_per_cpu(struct perf_evlist *evlist, int prot, int m
 				if (output == -1) {
 					output = fd;
 					if (__perf_evlist__mmap(evlist, cpu,
-								prot, mask, output) < 0)
+								output) < 0)
 						goto out_unmap;
 				} else {
 					if (ioctl(fd, PERF_EVENT_IOC_SET_OUTPUT, output) != 0)
@@ -495,7 +503,7 @@ out_unmap:
 	return -1;
 }
 
-static int perf_evlist__mmap_per_thread(struct perf_evlist *evlist, int prot, int mask)
+static int perf_evlist__mmap_per_thread(struct perf_evlist *evlist)
 {
 	struct perf_evsel *evsel;
 	int thread;
@@ -509,7 +517,7 @@ static int perf_evlist__mmap_per_thread(struct perf_evlist *evlist, int prot, in
 			if (output == -1) {
 				output = fd;
 				if (__perf_evlist__mmap(evlist, thread,
-							prot, mask, output) < 0)
+							output) < 0)
 					goto out_unmap;
 			} else {
 				if (ioctl(fd, PERF_EVENT_IOC_SET_OUTPUT, output) != 0)
@@ -552,17 +560,9 @@ out_unmap:
 int perf_evlist__mmap(struct perf_evlist *evlist, unsigned int pages,
 		      bool overwrite)
 {
-	unsigned int page_size = sysconf(_SC_PAGE_SIZE);
 	struct perf_evsel *evsel;
 	const struct cpu_map *cpus = evlist->cpus;
 	const struct thread_map *threads = evlist->threads;
-	int prot = PROT_READ | (overwrite ? 0 : PROT_WRITE), mask;
-
-        /* 512 kiB: default amount of unprivileged mlocked memory */
-        if (pages == UINT_MAX)
-                pages = (512 * 1024) / page_size;
-
-	mask = pages * page_size - 1;
 
 	if (evlist->mmap == NULL && perf_evlist__alloc_mmap(evlist) < 0)
 		return -ENOMEM;
@@ -570,8 +570,11 @@ int perf_evlist__mmap(struct perf_evlist *evlist, unsigned int pages,
 	if (evlist->pollfd == NULL && perf_evlist__alloc_pollfd(evlist) < 0)
 		return -ENOMEM;
 
+	if (pages == UINT_MAX)
+		pages = (512 * 1024) / sysconf(_SC_PAGE_SIZE);
+
+	evlist->pages = pages;
 	evlist->overwrite = overwrite;
-	evlist->mmap_len = (pages + 1) * page_size;
 
 	list_for_each_entry(evsel, &evlist->entries, node) {
 		if ((evsel->attr.read_format & PERF_FORMAT_ID) &&
@@ -580,10 +583,10 @@ int perf_evlist__mmap(struct perf_evlist *evlist, unsigned int pages,
 			return -ENOMEM;
 	}
 
-	if (evlist->cpus->map[0] == -1)
-		return perf_evlist__mmap_per_thread(evlist, prot, mask);
+	if (cpus->map[0] == -1)
+		return perf_evlist__mmap_per_thread(evlist);
 
-	return perf_evlist__mmap_per_cpu(evlist, prot, mask);
+	return perf_evlist__mmap_per_cpu(evlist);
 }
 
 int perf_evlist__create_maps(struct perf_evlist *evlist, pid_t target_pid,
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 8922aee..87a4e32 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -28,6 +28,7 @@ struct perf_evlist {
 		pid_t	pid;
 	} workload;
 	bool		 overwrite;
+	unsigned int	 pages;
 	union perf_event event_copy;
 	struct perf_mmap *mmap;
 	struct pollfd	 *pollfd;
-- 
1.7.4

