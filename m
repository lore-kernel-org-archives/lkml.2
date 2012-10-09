Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756491Ab2JIRa3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 13:30:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:32907 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754597Ab2JIRaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 13:30:23 -0400
Date: Tue, 9 Oct 2012 10:29:44 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-mwfqji9f17k5j81l1404dk3q@git.kernel.org>
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
  Have the page size value available for all tools
Git-Commit-ID: 0c1fe6b2f30fa275d939071293b6e28771283f6d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 09 Oct 2012 10:29:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0c1fe6b2f30fa275d939071293b6e28771283f6d
Gitweb:     http://git.kernel.org/tip/0c1fe6b2f30fa275d939071293b6e28771283f6d
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Sat, 6 Oct 2012 14:57:10 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sat, 6 Oct 2012 16:33:14 -0300

perf tools: Have the page size value available for all tools

Its such a common need that we might as well have a global with that
value.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-mwfqji9f17k5j81l1404dk3q@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-test.c          |    2 --
 tools/perf/perf.c                  |    2 ++
 tools/perf/util/evlist.c           |    3 ---
 tools/perf/util/session.c          |    4 +---
 tools/perf/util/trace-event-read.c |    2 --
 tools/perf/util/util.c             |    2 ++
 tools/perf/util/util.h             |    2 ++
 7 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 484f26c..e2d9872d 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -35,7 +35,6 @@ static int test__vmlinux_matches_kallsyms(void)
 	struct map *kallsyms_map, *vmlinux_map;
 	struct machine kallsyms, vmlinux;
 	enum map_type type = MAP__FUNCTION;
-	long page_size = sysconf(_SC_PAGE_SIZE);
 	struct ref_reloc_sym ref_reloc_sym = { .name = "_stext", };
 
 	/*
@@ -1007,7 +1006,6 @@ static void segfault_handler(int sig __maybe_unused,
 
 static int __test__rdpmc(void)
 {
-	long page_size = sysconf(_SC_PAGE_SIZE);
 	volatile int tmp = 0;
 	u64 i, loops = 1000;
 	int n;
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 6d50eb0..d480d8a 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -440,6 +440,8 @@ int main(int argc, const char **argv)
 {
 	const char *cmd;
 
+	page_size = sysconf(_SC_PAGE_SIZE);
+
 	cmd = perf_extract_argv0_path(argv[0]);
 	if (!cmd)
 		cmd = "perf-help";
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 186b877..a41dc4a 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -325,8 +325,6 @@ struct perf_evsel *perf_evlist__id2evsel(struct perf_evlist *evlist, u64 id)
 
 union perf_event *perf_evlist__mmap_read(struct perf_evlist *evlist, int idx)
 {
-	/* XXX Move this to perf.c, making it generally available */
-	unsigned int page_size = sysconf(_SC_PAGE_SIZE);
 	struct perf_mmap *md = &evlist->mmap[idx];
 	unsigned int head = perf_mmap__read_head(md);
 	unsigned int old = md->prev;
@@ -528,7 +526,6 @@ out_unmap:
 int perf_evlist__mmap(struct perf_evlist *evlist, unsigned int pages,
 		      bool overwrite)
 {
-	unsigned int page_size = sysconf(_SC_PAGE_SIZE);
 	struct perf_evsel *evsel;
 	const struct cpu_map *cpus = evlist->cpus;
 	const struct thread_map *threads = evlist->threads;
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 8cdd232..15abe40 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1375,15 +1375,13 @@ int __perf_session__process_events(struct perf_session *session,
 {
 	u64 head, page_offset, file_offset, file_pos, progress_next;
 	int err, mmap_prot, mmap_flags, map_idx = 0;
-	size_t	page_size, mmap_size;
+	size_t	mmap_size;
 	char *buf, *mmaps[8];
 	union perf_event *event;
 	uint32_t size;
 
 	perf_tool__fill_defaults(tool);
 
-	page_size = sysconf(_SC_PAGESIZE);
-
 	page_offset = page_size * (data_offset / page_size);
 	file_offset = page_offset;
 	head = data_offset - page_offset;
diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
index 719ed74..3741572 100644
--- a/tools/perf/util/trace-event-read.c
+++ b/tools/perf/util/trace-event-read.c
@@ -47,8 +47,6 @@ int file_bigendian;
 int host_bigendian;
 static int long_size;
 
-static unsigned long	page_size;
-
 static ssize_t calc_data_size;
 static bool repipe;
 
diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index 9966459..637b5cc 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -10,6 +10,8 @@
 /*
  * XXX We need to find a better place for these things...
  */
+unsigned int page_size;
+
 bool perf_host  = true;
 bool perf_guest = false;
 
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 70fa70b..a6b83f8 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -263,4 +263,6 @@ char *rtrim(char *s);
 
 void dump_stack(void);
 
+extern unsigned int page_size;
+
 #endif
