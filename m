Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809Ab1HDO6L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 10:58:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:59598 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665Ab1HDO6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 10:58:09 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@amd64.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 2/4] perf evlist: Introduce 'disable' method
Date: Thu,  4 Aug 2011 11:57:16 -0300
Message-Id: <1312469838-2884-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1312469838-2884-1-git-send-email-acme@infradead.org>
References: <1312469838-2884-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

To remove the last case of access to the FD() macro outside the library.

Inspired by a patch by Borislav that moved the FD() macro to util.h, for
namespace concerns I rather preferred to constrain it to ev{sel,list}.c.

Cc: Borislav Petkov <bp@amd64.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-qn893qsstcg366tkucu649qj@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |   19 ++-----------------
 tools/perf/util/evlist.c    |   13 +++++++++++++
 tools/perf/util/evlist.h    |    2 ++
 3 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 80dc5b7..f6426b4 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -30,8 +30,6 @@
 #include <sched.h>
 #include <sys/mman.h>
 
-#define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
-
 enum write_mode_t {
 	WRITE_FORCE,
 	WRITE_APPEND
@@ -438,7 +436,6 @@ static void mmap_read_all(void)
 
 static int __cmd_record(int argc, const char **argv)
 {
-	int i;
 	struct stat st;
 	int flags;
 	int err;
@@ -682,7 +679,6 @@ static int __cmd_record(int argc, const char **argv)
 
 	for (;;) {
 		int hits = samples;
-		int thread;
 
 		mmap_read_all();
 
@@ -693,19 +689,8 @@ static int __cmd_record(int argc, const char **argv)
 			waking++;
 		}
 
-		if (done) {
-			for (i = 0; i < evsel_list->cpus->nr; i++) {
-				struct perf_evsel *pos;
-
-				list_for_each_entry(pos, &evsel_list->entries, node) {
-					for (thread = 0;
-						thread < evsel_list->threads->nr;
-						thread++)
-						ioctl(FD(pos, i, thread),
-							PERF_EVENT_IOC_DISABLE);
-				}
-			}
-		}
+		if (done)
+			perf_evlist__disable(evsel_list);
 	}
 
 	if (quiet || signr == SIGUSR1)
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index b021ea9..e03e7bc 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -91,6 +91,19 @@ int perf_evlist__add_default(struct perf_evlist *evlist)
 	return 0;
 }
 
+void perf_evlist__disable(struct perf_evlist *evlist)
+{
+	int cpu, thread;
+	struct perf_evsel *pos;
+
+	for (cpu = 0; cpu < evlist->cpus->nr; cpu++) {
+		list_for_each_entry(pos, &evlist->entries, node) {
+			for (thread = 0; thread < evlist->threads->nr; thread++)
+				ioctl(FD(pos, cpu, thread), PERF_EVENT_IOC_DISABLE);
+		}
+	}
+}
+
 int perf_evlist__alloc_pollfd(struct perf_evlist *evlist)
 {
 	int nfds = evlist->cpus->nr * evlist->threads->nr * evlist->nr_entries;
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index b2b8623..ce85ae9 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -53,6 +53,8 @@ int perf_evlist__alloc_mmap(struct perf_evlist *evlist);
 int perf_evlist__mmap(struct perf_evlist *evlist, int pages, bool overwrite);
 void perf_evlist__munmap(struct perf_evlist *evlist);
 
+void perf_evlist__disable(struct perf_evlist *evlist);
+
 static inline void perf_evlist__set_maps(struct perf_evlist *evlist,
 					 struct cpu_map *cpus,
 					 struct thread_map *threads)
-- 
1.6.2.5

