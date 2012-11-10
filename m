Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325Ab2KJArz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 19:47:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47994 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751959Ab2KJArv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 19:47:51 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 09/12] perf tests: Move test__syscall_open_tp_fields into separate object
Date: Sat, 10 Nov 2012 01:46:49 +0100
Message-Id: <1352508412-16914-10-git-send-email-jolsa@redhat.com>
In-Reply-To: <1352508412-16914-1-git-send-email-jolsa@redhat.com>
References: <1352508412-16914-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Separating test__syscall_open_tp_fields test from the
builtin-test into open-syscall-tp-fields object.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile                       |   1 +
 tools/perf/tests/builtin-test.c           | 112 ----------------------------
 tools/perf/tests/open-syscall-tp-fields.c | 117 ++++++++++++++++++++++++++++++
 tools/perf/tests/tests.h                  |   1 +
 4 files changed, 119 insertions(+), 112 deletions(-)
 create mode 100644 tools/perf/tests/open-syscall-tp-fields.c

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index e510b53..1e50559 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -434,6 +434,7 @@ LIB_OBJS += $(OUTPUT)tests/attr.o
 LIB_OBJS += $(OUTPUT)tests/vmlinux-kallsyms.o
 LIB_OBJS += $(OUTPUT)tests/open-syscall.o
 LIB_OBJS += $(OUTPUT)tests/open-syscall-all-cpus.o
+LIB_OBJS += $(OUTPUT)tests/open-syscall-tp-fields.o
 LIB_OBJS += $(OUTPUT)tests/mmap-basic.o
 LIB_OBJS += $(OUTPUT)tests/perf-record.o
 LIB_OBJS += $(OUTPUT)tests/rdpmc.o
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index c66caa7..bab8490 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -35,118 +35,6 @@ static int test__perf_pmu(void)
 	return perf_pmu__test();
 }
 
-static int test__syscall_open_tp_fields(void)
-{
-	struct perf_record_opts opts = {
-		.target = {
-			.uid = UINT_MAX,
-			.uses_mmap = true,
-		},
-		.no_delay   = true,
-		.freq	    = 1,
-		.mmap_pages = 256,
-		.raw_samples = true,
-	};
-	const char *filename = "/etc/passwd";
-	int flags = O_RDONLY | O_DIRECTORY;
-	struct perf_evlist *evlist = perf_evlist__new(NULL, NULL);
-	struct perf_evsel *evsel;
-	int err = -1, i, nr_events = 0, nr_polls = 0;
-
-	if (evlist == NULL) {
-		pr_debug("%s: perf_evlist__new\n", __func__);
-		goto out;
-	}
-
-	evsel = perf_evsel__newtp("syscalls", "sys_enter_open", 0);
-	if (evsel == NULL) {
-		pr_debug("%s: perf_evsel__newtp\n", __func__);
-		goto out_delete_evlist;
-	}
-
-	perf_evlist__add(evlist, evsel);
-
-	err = perf_evlist__create_maps(evlist, &opts.target);
-	if (err < 0) {
-		pr_debug("%s: perf_evlist__create_maps\n", __func__);
-		goto out_delete_evlist;
-	}
-
-	perf_evsel__config(evsel, &opts, evsel);
-
-	evlist->threads->map[0] = getpid();
-
-	err = perf_evlist__open(evlist);
-	if (err < 0) {
-		pr_debug("perf_evlist__open: %s\n", strerror(errno));
-		goto out_delete_evlist;
-	}
-
-	err = perf_evlist__mmap(evlist, UINT_MAX, false);
-	if (err < 0) {
-		pr_debug("perf_evlist__mmap: %s\n", strerror(errno));
-		goto out_delete_evlist;
-	}
-
-	perf_evlist__enable(evlist);
-
-	/*
-	 * Generate the event:
-	 */
-	open(filename, flags);
-
-	while (1) {
-		int before = nr_events;
-
-		for (i = 0; i < evlist->nr_mmaps; i++) {
-			union perf_event *event;
-
-			while ((event = perf_evlist__mmap_read(evlist, i)) != NULL) {
-				const u32 type = event->header.type;
-				int tp_flags;
-				struct perf_sample sample;
-
-				++nr_events;
-
-				if (type != PERF_RECORD_SAMPLE)
-					continue;
-
-				err = perf_evsel__parse_sample(evsel, event, &sample);
-				if (err) {
-					pr_err("Can't parse sample, err = %d\n", err);
-					goto out_munmap;
-				}
-
-				tp_flags = perf_evsel__intval(evsel, &sample, "flags");
-
-				if (flags != tp_flags) {
-					pr_debug("%s: Expected flags=%#x, got %#x\n",
-						 __func__, flags, tp_flags);
-					goto out_munmap;
-				}
-
-				goto out_ok;
-			}
-		}
-
-		if (nr_events == before)
-			poll(evlist->pollfd, evlist->nr_fds, 10);
-
-		if (++nr_polls > 5) {
-			pr_debug("%s: no events!\n", __func__);
-			goto out_munmap;
-		}
-	}
-out_ok:
-	err = 0;
-out_munmap:
-	perf_evlist__munmap(evlist);
-out_delete_evlist:
-	perf_evlist__delete(evlist);
-out:
-	return err;
-}
-
 static struct test {
 	const char *desc;
 	int (*func)(void);
diff --git a/tools/perf/tests/open-syscall-tp-fields.c b/tools/perf/tests/open-syscall-tp-fields.c
new file mode 100644
index 0000000..b05b6a6
--- /dev/null
+++ b/tools/perf/tests/open-syscall-tp-fields.c
@@ -0,0 +1,117 @@
+#include "perf.h"
+#include "evlist.h"
+#include "evsel.h"
+#include "thread_map.h"
+#include "tests.h"
+
+int test__syscall_open_tp_fields(void)
+{
+	struct perf_record_opts opts = {
+		.target = {
+			.uid = UINT_MAX,
+			.uses_mmap = true,
+		},
+		.no_delay   = true,
+		.freq	    = 1,
+		.mmap_pages = 256,
+		.raw_samples = true,
+	};
+	const char *filename = "/etc/passwd";
+	int flags = O_RDONLY | O_DIRECTORY;
+	struct perf_evlist *evlist = perf_evlist__new(NULL, NULL);
+	struct perf_evsel *evsel;
+	int err = -1, i, nr_events = 0, nr_polls = 0;
+
+	if (evlist == NULL) {
+		pr_debug("%s: perf_evlist__new\n", __func__);
+		goto out;
+	}
+
+	evsel = perf_evsel__newtp("syscalls", "sys_enter_open", 0);
+	if (evsel == NULL) {
+		pr_debug("%s: perf_evsel__newtp\n", __func__);
+		goto out_delete_evlist;
+	}
+
+	perf_evlist__add(evlist, evsel);
+
+	err = perf_evlist__create_maps(evlist, &opts.target);
+	if (err < 0) {
+		pr_debug("%s: perf_evlist__create_maps\n", __func__);
+		goto out_delete_evlist;
+	}
+
+	perf_evsel__config(evsel, &opts, evsel);
+
+	evlist->threads->map[0] = getpid();
+
+	err = perf_evlist__open(evlist);
+	if (err < 0) {
+		pr_debug("perf_evlist__open: %s\n", strerror(errno));
+		goto out_delete_evlist;
+	}
+
+	err = perf_evlist__mmap(evlist, UINT_MAX, false);
+	if (err < 0) {
+		pr_debug("perf_evlist__mmap: %s\n", strerror(errno));
+		goto out_delete_evlist;
+	}
+
+	perf_evlist__enable(evlist);
+
+	/*
+	 * Generate the event:
+	 */
+	open(filename, flags);
+
+	while (1) {
+		int before = nr_events;
+
+		for (i = 0; i < evlist->nr_mmaps; i++) {
+			union perf_event *event;
+
+			while ((event = perf_evlist__mmap_read(evlist, i)) != NULL) {
+				const u32 type = event->header.type;
+				int tp_flags;
+				struct perf_sample sample;
+
+				++nr_events;
+
+				if (type != PERF_RECORD_SAMPLE)
+					continue;
+
+				err = perf_evsel__parse_sample(evsel, event, &sample);
+				if (err) {
+					pr_err("Can't parse sample, err = %d\n", err);
+					goto out_munmap;
+				}
+
+				tp_flags = perf_evsel__intval(evsel, &sample, "flags");
+
+				if (flags != tp_flags) {
+					pr_debug("%s: Expected flags=%#x, got %#x\n",
+						 __func__, flags, tp_flags);
+					goto out_munmap;
+				}
+
+				goto out_ok;
+			}
+		}
+
+		if (nr_events == before)
+			poll(evlist->pollfd, evlist->nr_fds, 10);
+
+		if (++nr_polls > 5) {
+			pr_debug("%s: no events!\n", __func__);
+			goto out_munmap;
+		}
+	}
+out_ok:
+	err = 0;
+out_munmap:
+	perf_evlist__munmap(evlist);
+out_delete_evlist:
+	perf_evlist__delete(evlist);
+out:
+	return err;
+}
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index 1ef265d..f70f998 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -10,6 +10,7 @@ int test__PERF_RECORD(void);
 int test__rdpmc(void);
 int test__perf_evsel__roundtrip_name_test(void);
 int test__perf_evsel__tp_sched_test(void);
+int test__syscall_open_tp_fields(void);
 
 /* Util */
 int trace_event__id(const char *evname);
-- 
1.7.11.7

