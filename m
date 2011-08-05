Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756365Ab1HEKIs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 06:08:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:32967 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755265Ab1HEKI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 06:08:26 -0400
Date: Fri, 5 Aug 2011 10:07:24 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-qn893qsstcg366tkucu649qj@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
        efault@gmx.de, bp@amd64.org, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, bp@amd64.org, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf evlist: Introduce 'disable' method
Git-Commit-ID: 4152ab377b55e9d3e5700de00ef799519ead698d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 05 Aug 2011 10:07:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4152ab377b55e9d3e5700de00ef799519ead698d
Gitweb:     http://git.kernel.org/tip/4152ab377b55e9d3e5700de00ef799519ead698d
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 25 Jul 2011 11:06:19 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 25 Jul 2011 11:06:19 -0300

perf evlist: Introduce 'disable' method

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
