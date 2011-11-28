Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274Ab1K1XT3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 18:19:29 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48696 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754742Ab1K1XOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 18:14:45 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 07/25] perf evlist: Handle default value for 'pages' on mmap method
Date: Mon, 28 Nov 2011 21:14:08 -0200
Message-Id: <1322522066-21879-8-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.8.rc0.35.gee6df
In-Reply-To: <1322522066-21879-1-git-send-email-acme@infradead.org>
References: <1322522066-21879-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Every tool that calls this and allows the user to override the value
needs this logic.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-lwscxpg57xfzahz5dmdfp9uz@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |    4 ----
 tools/perf/util/evlist.c    |   12 +++++++++---
 tools/perf/util/evlist.h    |    3 ++-
 3 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 4799195..749862d 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -456,10 +456,6 @@ static int __cmd_record(int argc, const char **argv)
 	perf_header__set_feat(&session->header, HEADER_NUMA_TOPOLOGY);
 	perf_header__set_feat(&session->header, HEADER_CPUID);
 
-	/* 512 kiB: default amount of unprivileged mlocked memory */
-	if (mmap_pages == UINT_MAX)
-		mmap_pages = (512 * 1024) / page_size;
-
 	if (forks) {
 		err = perf_evlist__prepare_workload(evsel_list, &record_opts, argv);
 		if (err < 0) {
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index a472247..81237dc 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -507,14 +507,20 @@ out_unmap:
  *
  * Using perf_evlist__read_on_cpu does this automatically.
  */
-int perf_evlist__mmap(struct perf_evlist *evlist, int pages, bool overwrite)
+int perf_evlist__mmap(struct perf_evlist *evlist, unsigned int pages,
+		      bool overwrite)
 {
 	unsigned int page_size = sysconf(_SC_PAGE_SIZE);
-	int mask = pages * page_size - 1;
 	struct perf_evsel *evsel;
 	const struct cpu_map *cpus = evlist->cpus;
 	const struct thread_map *threads = evlist->threads;
-	int prot = PROT_READ | (overwrite ? 0 : PROT_WRITE);
+	int prot = PROT_READ | (overwrite ? 0 : PROT_WRITE), mask;
+
+        /* 512 kiB: default amount of unprivileged mlocked memory */
+        if (pages == UINT_MAX)
+                pages = (512 * 1024) / page_size;
+
+	mask = pages * page_size - 1;
 
 	if (evlist->mmap == NULL && perf_evlist__alloc_mmap(evlist) < 0)
 		return -ENOMEM;
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 07d56b3..17e9c80 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -79,7 +79,8 @@ int perf_evlist__prepare_workload(struct perf_evlist *evlist,
 int perf_evlist__start_workload(struct perf_evlist *evlist);
 
 int perf_evlist__alloc_mmap(struct perf_evlist *evlist);
-int perf_evlist__mmap(struct perf_evlist *evlist, int pages, bool overwrite);
+int perf_evlist__mmap(struct perf_evlist *evlist, unsigned int pages,
+		      bool overwrite);
 void perf_evlist__munmap(struct perf_evlist *evlist);
 
 void perf_evlist__disable(struct perf_evlist *evlist);
-- 
1.7.8.rc0.35.gee6df

