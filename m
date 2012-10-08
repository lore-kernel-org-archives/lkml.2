Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427Ab2JHWgI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 18:36:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:41421 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932091Ab2JHWdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 18:33:37 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 12/25] perf tools: Have the page size value available for all tools
Date: Mon,  8 Oct 2012 19:32:37 -0300
Message-Id: <1349735570-19339-13-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1349735570-19339-1-git-send-email-acme@infradead.org>
References: <1349735570-19339-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

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
-- 
1.7.9.2.358.g22243

