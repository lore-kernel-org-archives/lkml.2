Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756274Ab1LEMth (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 07:49:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56802 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754491Ab1LEMtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 07:49:36 -0500
Date: Mon, 5 Dec 2011 04:48:31 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-lwscxpg57xfzahz5dmdfp9uz@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
        efault@gmx.de, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evlist: Handle default value for 'pages' on mmap method
Git-Commit-ID: 50a682ce875f91e04c81ae5680535aba5a770bad
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Dec 2011 04:48:37 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  50a682ce875f91e04c81ae5680535aba5a770bad
Gitweb:     http://git.kernel.org/tip/50a682ce875f91e04c81ae5680535aba5a770bad
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 9 Nov 2011 09:10:47 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 28 Nov 2011 10:26:43 -0200

perf evlist: Handle default value for 'pages' on mmap method

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
