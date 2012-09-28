Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143Ab2I1Q06 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 12:26:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41820 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758405Ab2I1Q04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 12:26:56 -0400
Date: Fri, 28 Sep 2012 09:26:36 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-rnaqn3dtnsfo1wlbbf3fhx00@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Allow handling a NULL cpu_map as meaning "all cpus"
Git-Commit-ID: a14bb7a6fd4a3d563ca971daf462ba4dc294a7a6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 28 Sep 2012 09:26:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a14bb7a6fd4a3d563ca971daf462ba4dc294a7a6
Gitweb:     http://git.kernel.org/tip/a14bb7a6fd4a3d563ca971daf462ba4dc294a7a6
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 26 Sep 2012 12:41:14 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 26 Sep 2012 12:41:14 -0300

perf tools: Allow handling a NULL cpu_map as meaning "all cpus"

Or one with cpu_map->map[0] == -1.

Reducing the boilerplate in setting up an evlist by nor requiring a
cpu_map to be created at all.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-rnaqn3dtnsfo1wlbbf3fhx00@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/cpumap.h |   11 +++++++++++
 tools/perf/util/evlist.c |   12 ++++++------
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/cpumap.h b/tools/perf/util/cpumap.h
index 17b5264..2f68a3b 100644
--- a/tools/perf/util/cpumap.h
+++ b/tools/perf/util/cpumap.h
@@ -2,6 +2,7 @@
 #define __PERF_CPUMAP_H
 
 #include <stdio.h>
+#include <stdbool.h>
 
 struct cpu_map {
 	int nr;
@@ -14,4 +15,14 @@ void cpu_map__delete(struct cpu_map *map);
 struct cpu_map *cpu_map__read(FILE *file);
 size_t cpu_map__fprintf(struct cpu_map *map, FILE *fp);
 
+static inline int cpu_map__nr(const struct cpu_map *map)
+{
+	return map ? map->nr : 1;
+}
+
+static inline bool cpu_map__all(const struct cpu_map *map)
+{
+	return map ? map->map[0] == -1 : true;
+}
+
 #endif /* __PERF_CPUMAP_H */
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 8923537..27f6de3 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -304,7 +304,7 @@ void perf_evlist__enable(struct perf_evlist *evlist)
 	int cpu, thread;
 	struct perf_evsel *pos;
 
-	for (cpu = 0; cpu < evlist->cpus->nr; cpu++) {
+	for (cpu = 0; cpu < cpu_map__nr(evlist->cpus); cpu++) {
 		list_for_each_entry(pos, &evlist->entries, node) {
 			for (thread = 0; thread < evlist->threads->nr; thread++)
 				ioctl(FD(pos, cpu, thread),
@@ -315,7 +315,7 @@ void perf_evlist__enable(struct perf_evlist *evlist)
 
 static int perf_evlist__alloc_pollfd(struct perf_evlist *evlist)
 {
-	int nfds = evlist->cpus->nr * evlist->threads->nr * evlist->nr_entries;
+	int nfds = cpu_map__nr(evlist->cpus) * evlist->threads->nr * evlist->nr_entries;
 	evlist->pollfd = malloc(sizeof(struct pollfd) * nfds);
 	return evlist->pollfd != NULL ? 0 : -ENOMEM;
 }
@@ -475,8 +475,8 @@ void perf_evlist__munmap(struct perf_evlist *evlist)
 
 static int perf_evlist__alloc_mmap(struct perf_evlist *evlist)
 {
-	evlist->nr_mmaps = evlist->cpus->nr;
-	if (evlist->cpus->map[0] == -1)
+	evlist->nr_mmaps = cpu_map__nr(evlist->cpus);
+	if (cpu_map__all(evlist->cpus))
 		evlist->nr_mmaps = evlist->threads->nr;
 	evlist->mmap = zalloc(evlist->nr_mmaps * sizeof(struct perf_mmap));
 	return evlist->mmap != NULL ? 0 : -ENOMEM;
@@ -622,11 +622,11 @@ int perf_evlist__mmap(struct perf_evlist *evlist, unsigned int pages,
 	list_for_each_entry(evsel, &evlist->entries, node) {
 		if ((evsel->attr.read_format & PERF_FORMAT_ID) &&
 		    evsel->sample_id == NULL &&
-		    perf_evsel__alloc_id(evsel, cpus->nr, threads->nr) < 0)
+		    perf_evsel__alloc_id(evsel, cpu_map__nr(cpus), threads->nr) < 0)
 			return -ENOMEM;
 	}
 
-	if (evlist->cpus->map[0] == -1)
+	if (cpu_map__all(cpus))
 		return perf_evlist__mmap_per_thread(evlist, prot, mask);
 
 	return perf_evlist__mmap_per_cpu(evlist, prot, mask);
