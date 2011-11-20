Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390Ab1KSTGV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 14:06:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29526 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751885Ab1KSTGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 14:06:18 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCHv2 2/5] perf tool: Initialize events IDs in a single function
Date: Sat, 19 Nov 2011 21:03:50 -0500
Message-Id: <1321754633-11489-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1321754633-11489-1-git-send-email-jolsa@redhat.com>
References: <1321624005-6889-1-git-send-email-jolsa@redhat.com>
 <1321754633-11489-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently events' IDs initialization is scattered among the
code. Adding function 'perf_evlist__init_ids' to allocate
and retrive events' IDs in one place.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/evlist.c |   50 +++++++++++++++++++++++++++++----------------
 1 files changed, 32 insertions(+), 18 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index fbb4b4a..0f715d0 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -326,10 +326,6 @@ static int perf_evlist__mmap_per_cpu(struct perf_evlist *evlist, int prot, int m
 					if (ioctl(fd, PERF_EVENT_IOC_SET_OUTPUT, output) != 0)
 						goto out_unmap;
 				}
-
-				if ((evsel->attr.read_format & PERF_FORMAT_ID) &&
-				    perf_evlist__id_add_fd(evlist, evsel, cpu, thread, fd) < 0)
-					goto out_unmap;
 			}
 		}
 	}
@@ -366,10 +362,6 @@ static int perf_evlist__mmap_per_thread(struct perf_evlist *evlist, int prot, in
 				if (ioctl(fd, PERF_EVENT_IOC_SET_OUTPUT, output) != 0)
 					goto out_unmap;
 			}
-
-			if ((evsel->attr.read_format & PERF_FORMAT_ID) &&
-			    perf_evlist__id_add_fd(evlist, evsel, 0, thread, fd) < 0)
-				goto out_unmap;
 		}
 	}
 
@@ -385,6 +377,33 @@ out_unmap:
 	return -1;
 }
 
+static int perf_evlist__init_ids(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel;
+	struct thread_map *threads = evlist->threads;
+	struct cpu_map *cpus = evlist->cpus;
+	int cpu, thread;
+
+	list_for_each_entry(evsel, &evlist->entries, node) {
+		if (!(evsel->attr.read_format & PERF_FORMAT_ID))
+			continue;
+
+		if ((!evsel->sample_id) &&
+		    perf_evsel__alloc_id(evsel, cpus->nr, threads->nr) < 0)
+			return -ENOMEM;
+
+		for (cpu = 0; cpu < cpus->nr; cpu++)
+			for (thread = 0; thread < threads->nr; thread++) {
+				int fd = FD(evsel, cpu, thread);
+				if (perf_evlist__id_add_fd(evlist, evsel,
+							   cpu, thread, fd))
+					return -EINVAL;
+			}
+	}
+
+	return 0;
+}
+
 /** perf_evlist__mmap - Create per cpu maps to receive events
  *
  * @evlist - list of events
@@ -403,10 +422,8 @@ out_unmap:
 int perf_evlist__mmap(struct perf_evlist *evlist, int pages, bool overwrite)
 {
 	unsigned int page_size = sysconf(_SC_PAGE_SIZE);
-	int mask = pages * page_size - 1;
-	struct perf_evsel *evsel;
+	int mask = pages * page_size - 1, ret;
 	const struct cpu_map *cpus = evlist->cpus;
-	const struct thread_map *threads = evlist->threads;
 	int prot = PROT_READ | (overwrite ? 0 : PROT_WRITE);
 
 	if (evlist->mmap == NULL && perf_evlist__alloc_mmap(evlist) < 0)
@@ -418,14 +435,11 @@ int perf_evlist__mmap(struct perf_evlist *evlist, int pages, bool overwrite)
 	evlist->overwrite = overwrite;
 	evlist->mmap_len = (pages + 1) * page_size;
 
-	list_for_each_entry(evsel, &evlist->entries, node) {
-		if ((evsel->attr.read_format & PERF_FORMAT_ID) &&
-		    evsel->sample_id == NULL &&
-		    perf_evsel__alloc_id(evsel, cpus->nr, threads->nr) < 0)
-			return -ENOMEM;
-	}
+	ret = perf_evlist__init_ids(evlist);
+	if (ret)
+		return ret;
 
-	if (evlist->cpus->map[0] == -1)
+	if (cpus->map[0] == -1)
 		return perf_evlist__mmap_per_thread(evlist, prot, mask);
 
 	return perf_evlist__mmap_per_cpu(evlist, prot, mask);
-- 
1.7.6.4

