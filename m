Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474Ab2KROdm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 09:33:42 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36583 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220Ab2KROaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 09:30:19 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 05/32] perf tests: Move test__PERF_RECORD into separate object
Date: Sun, 18 Nov 2012 11:29:30 -0300
Message-Id: <1353248997-30763-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1353248997-30763-1-git-send-email-acme@infradead.org>
References: <1353248997-30763-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Separating test__PERF_RECORD test from the builtin-test into perf-record
object.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1352508412-16914-6-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile             |    1 +
 tools/perf/tests/builtin-test.c |  307 --------------------------------------
 tools/perf/tests/perf-record.c  |  312 +++++++++++++++++++++++++++++++++++++++
 tools/perf/tests/tests.h        |    1 +
 4 files changed, 314 insertions(+), 307 deletions(-)
 create mode 100644 tools/perf/tests/perf-record.c

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 337489e..a2d6153 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -435,6 +435,7 @@ LIB_OBJS += $(OUTPUT)tests/vmlinux-kallsyms.o
 LIB_OBJS += $(OUTPUT)tests/open-syscall.o
 LIB_OBJS += $(OUTPUT)tests/open-syscall-all-cpus.o
 LIB_OBJS += $(OUTPUT)tests/mmap-basic.o
+LIB_OBJS += $(OUTPUT)tests/perf-record.o
 LIB_OBJS += $(OUTPUT)tests/util.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index 609f592..7cb3928 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -31,313 +31,6 @@
 
 
 
-static int sched__get_first_possible_cpu(pid_t pid, cpu_set_t *maskp)
-{
-	int i, cpu = -1, nrcpus = 1024;
-realloc:
-	CPU_ZERO(maskp);
-
-	if (sched_getaffinity(pid, sizeof(*maskp), maskp) == -1) {
-		if (errno == EINVAL && nrcpus < (1024 << 8)) {
-			nrcpus = nrcpus << 2;
-			goto realloc;
-		}
-		perror("sched_getaffinity");
-			return -1;
-	}
-
-	for (i = 0; i < nrcpus; i++) {
-		if (CPU_ISSET(i, maskp)) {
-			if (cpu == -1)
-				cpu = i;
-			else
-				CPU_CLR(i, maskp);
-		}
-	}
-
-	return cpu;
-}
-
-static int test__PERF_RECORD(void)
-{
-	struct perf_record_opts opts = {
-		.target = {
-			.uid = UINT_MAX,
-			.uses_mmap = true,
-		},
-		.no_delay   = true,
-		.freq	    = 10,
-		.mmap_pages = 256,
-	};
-	cpu_set_t cpu_mask;
-	size_t cpu_mask_size = sizeof(cpu_mask);
-	struct perf_evlist *evlist = perf_evlist__new(NULL, NULL);
-	struct perf_evsel *evsel;
-	struct perf_sample sample;
-	const char *cmd = "sleep";
-	const char *argv[] = { cmd, "1", NULL, };
-	char *bname;
-	u64 prev_time = 0;
-	bool found_cmd_mmap = false,
-	     found_libc_mmap = false,
-	     found_vdso_mmap = false,
-	     found_ld_mmap = false;
-	int err = -1, errs = 0, i, wakeups = 0;
-	u32 cpu;
-	int total_events = 0, nr_events[PERF_RECORD_MAX] = { 0, };
-
-	if (evlist == NULL || argv == NULL) {
-		pr_debug("Not enough memory to create evlist\n");
-		goto out;
-	}
-
-	/*
-	 * We need at least one evsel in the evlist, use the default
-	 * one: "cycles".
-	 */
-	err = perf_evlist__add_default(evlist);
-	if (err < 0) {
-		pr_debug("Not enough memory to create evsel\n");
-		goto out_delete_evlist;
-	}
-
-	/*
-	 * Create maps of threads and cpus to monitor. In this case
-	 * we start with all threads and cpus (-1, -1) but then in
-	 * perf_evlist__prepare_workload we'll fill in the only thread
-	 * we're monitoring, the one forked there.
-	 */
-	err = perf_evlist__create_maps(evlist, &opts.target);
-	if (err < 0) {
-		pr_debug("Not enough memory to create thread/cpu maps\n");
-		goto out_delete_evlist;
-	}
-
-	/*
-	 * Prepare the workload in argv[] to run, it'll fork it, and then wait
-	 * for perf_evlist__start_workload() to exec it. This is done this way
-	 * so that we have time to open the evlist (calling sys_perf_event_open
-	 * on all the fds) and then mmap them.
-	 */
-	err = perf_evlist__prepare_workload(evlist, &opts, argv);
-	if (err < 0) {
-		pr_debug("Couldn't run the workload!\n");
-		goto out_delete_evlist;
-	}
-
-	/*
-	 * Config the evsels, setting attr->comm on the first one, etc.
-	 */
-	evsel = perf_evlist__first(evlist);
-	evsel->attr.sample_type |= PERF_SAMPLE_CPU;
-	evsel->attr.sample_type |= PERF_SAMPLE_TID;
-	evsel->attr.sample_type |= PERF_SAMPLE_TIME;
-	perf_evlist__config_attrs(evlist, &opts);
-
-	err = sched__get_first_possible_cpu(evlist->workload.pid, &cpu_mask);
-	if (err < 0) {
-		pr_debug("sched__get_first_possible_cpu: %s\n", strerror(errno));
-		goto out_delete_evlist;
-	}
-
-	cpu = err;
-
-	/*
-	 * So that we can check perf_sample.cpu on all the samples.
-	 */
-	if (sched_setaffinity(evlist->workload.pid, cpu_mask_size, &cpu_mask) < 0) {
-		pr_debug("sched_setaffinity: %s\n", strerror(errno));
-		goto out_delete_evlist;
-	}
-
-	/*
-	 * Call sys_perf_event_open on all the fds on all the evsels,
-	 * grouping them if asked to.
-	 */
-	err = perf_evlist__open(evlist);
-	if (err < 0) {
-		pr_debug("perf_evlist__open: %s\n", strerror(errno));
-		goto out_delete_evlist;
-	}
-
-	/*
-	 * mmap the first fd on a given CPU and ask for events for the other
-	 * fds in the same CPU to be injected in the same mmap ring buffer
-	 * (using ioctl(PERF_EVENT_IOC_SET_OUTPUT)).
-	 */
-	err = perf_evlist__mmap(evlist, opts.mmap_pages, false);
-	if (err < 0) {
-		pr_debug("perf_evlist__mmap: %s\n", strerror(errno));
-		goto out_delete_evlist;
-	}
-
-	/*
-	 * Now that all is properly set up, enable the events, they will
-	 * count just on workload.pid, which will start...
-	 */
-	perf_evlist__enable(evlist);
-
-	/*
-	 * Now!
-	 */
-	perf_evlist__start_workload(evlist);
-
-	while (1) {
-		int before = total_events;
-
-		for (i = 0; i < evlist->nr_mmaps; i++) {
-			union perf_event *event;
-
-			while ((event = perf_evlist__mmap_read(evlist, i)) != NULL) {
-				const u32 type = event->header.type;
-				const char *name = perf_event__name(type);
-
-				++total_events;
-				if (type < PERF_RECORD_MAX)
-					nr_events[type]++;
-
-				err = perf_evlist__parse_sample(evlist, event, &sample);
-				if (err < 0) {
-					if (verbose)
-						perf_event__fprintf(event, stderr);
-					pr_debug("Couldn't parse sample\n");
-					goto out_err;
-				}
-
-				if (verbose) {
-					pr_info("%" PRIu64" %d ", sample.time, sample.cpu);
-					perf_event__fprintf(event, stderr);
-				}
-
-				if (prev_time > sample.time) {
-					pr_debug("%s going backwards in time, prev=%" PRIu64 ", curr=%" PRIu64 "\n",
-						 name, prev_time, sample.time);
-					++errs;
-				}
-
-				prev_time = sample.time;
-
-				if (sample.cpu != cpu) {
-					pr_debug("%s with unexpected cpu, expected %d, got %d\n",
-						 name, cpu, sample.cpu);
-					++errs;
-				}
-
-				if ((pid_t)sample.pid != evlist->workload.pid) {
-					pr_debug("%s with unexpected pid, expected %d, got %d\n",
-						 name, evlist->workload.pid, sample.pid);
-					++errs;
-				}
-
-				if ((pid_t)sample.tid != evlist->workload.pid) {
-					pr_debug("%s with unexpected tid, expected %d, got %d\n",
-						 name, evlist->workload.pid, sample.tid);
-					++errs;
-				}
-
-				if ((type == PERF_RECORD_COMM ||
-				     type == PERF_RECORD_MMAP ||
-				     type == PERF_RECORD_FORK ||
-				     type == PERF_RECORD_EXIT) &&
-				     (pid_t)event->comm.pid != evlist->workload.pid) {
-					pr_debug("%s with unexpected pid/tid\n", name);
-					++errs;
-				}
-
-				if ((type == PERF_RECORD_COMM ||
-				     type == PERF_RECORD_MMAP) &&
-				     event->comm.pid != event->comm.tid) {
-					pr_debug("%s with different pid/tid!\n", name);
-					++errs;
-				}
-
-				switch (type) {
-				case PERF_RECORD_COMM:
-					if (strcmp(event->comm.comm, cmd)) {
-						pr_debug("%s with unexpected comm!\n", name);
-						++errs;
-					}
-					break;
-				case PERF_RECORD_EXIT:
-					goto found_exit;
-				case PERF_RECORD_MMAP:
-					bname = strrchr(event->mmap.filename, '/');
-					if (bname != NULL) {
-						if (!found_cmd_mmap)
-							found_cmd_mmap = !strcmp(bname + 1, cmd);
-						if (!found_libc_mmap)
-							found_libc_mmap = !strncmp(bname + 1, "libc", 4);
-						if (!found_ld_mmap)
-							found_ld_mmap = !strncmp(bname + 1, "ld", 2);
-					} else if (!found_vdso_mmap)
-						found_vdso_mmap = !strcmp(event->mmap.filename, "[vdso]");
-					break;
-
-				case PERF_RECORD_SAMPLE:
-					/* Just ignore samples for now */
-					break;
-				default:
-					pr_debug("Unexpected perf_event->header.type %d!\n",
-						 type);
-					++errs;
-				}
-			}
-		}
-
-		/*
-		 * We don't use poll here because at least at 3.1 times the
-		 * PERF_RECORD_{!SAMPLE} events don't honour
-		 * perf_event_attr.wakeup_events, just PERF_EVENT_SAMPLE does.
-		 */
-		if (total_events == before && false)
-			poll(evlist->pollfd, evlist->nr_fds, -1);
-
-		sleep(1);
-		if (++wakeups > 5) {
-			pr_debug("No PERF_RECORD_EXIT event!\n");
-			break;
-		}
-	}
-
-found_exit:
-	if (nr_events[PERF_RECORD_COMM] > 1) {
-		pr_debug("Excessive number of PERF_RECORD_COMM events!\n");
-		++errs;
-	}
-
-	if (nr_events[PERF_RECORD_COMM] == 0) {
-		pr_debug("Missing PERF_RECORD_COMM for %s!\n", cmd);
-		++errs;
-	}
-
-	if (!found_cmd_mmap) {
-		pr_debug("PERF_RECORD_MMAP for %s missing!\n", cmd);
-		++errs;
-	}
-
-	if (!found_libc_mmap) {
-		pr_debug("PERF_RECORD_MMAP for %s missing!\n", "libc");
-		++errs;
-	}
-
-	if (!found_ld_mmap) {
-		pr_debug("PERF_RECORD_MMAP for %s missing!\n", "ld");
-		++errs;
-	}
-
-	if (!found_vdso_mmap) {
-		pr_debug("PERF_RECORD_MMAP for %s missing!\n", "[vdso]");
-		++errs;
-	}
-out_err:
-	perf_evlist__munmap(evlist);
-out_delete_evlist:
-	perf_evlist__delete(evlist);
-out:
-	return (err < 0 || errs > 0) ? -1 : 0;
-}
-
-
 #if defined(__x86_64__) || defined(__i386__)
 
 #define barrier() asm volatile("" ::: "memory")
diff --git a/tools/perf/tests/perf-record.c b/tools/perf/tests/perf-record.c
new file mode 100644
index 0000000..70e0d44
--- /dev/null
+++ b/tools/perf/tests/perf-record.c
@@ -0,0 +1,312 @@
+#include <sched.h>
+#include "evlist.h"
+#include "evsel.h"
+#include "perf.h"
+#include "debug.h"
+#include "tests.h"
+
+static int sched__get_first_possible_cpu(pid_t pid, cpu_set_t *maskp)
+{
+	int i, cpu = -1, nrcpus = 1024;
+realloc:
+	CPU_ZERO(maskp);
+
+	if (sched_getaffinity(pid, sizeof(*maskp), maskp) == -1) {
+		if (errno == EINVAL && nrcpus < (1024 << 8)) {
+			nrcpus = nrcpus << 2;
+			goto realloc;
+		}
+		perror("sched_getaffinity");
+			return -1;
+	}
+
+	for (i = 0; i < nrcpus; i++) {
+		if (CPU_ISSET(i, maskp)) {
+			if (cpu == -1)
+				cpu = i;
+			else
+				CPU_CLR(i, maskp);
+		}
+	}
+
+	return cpu;
+}
+
+int test__PERF_RECORD(void)
+{
+	struct perf_record_opts opts = {
+		.target = {
+			.uid = UINT_MAX,
+			.uses_mmap = true,
+		},
+		.no_delay   = true,
+		.freq	    = 10,
+		.mmap_pages = 256,
+	};
+	cpu_set_t cpu_mask;
+	size_t cpu_mask_size = sizeof(cpu_mask);
+	struct perf_evlist *evlist = perf_evlist__new(NULL, NULL);
+	struct perf_evsel *evsel;
+	struct perf_sample sample;
+	const char *cmd = "sleep";
+	const char *argv[] = { cmd, "1", NULL, };
+	char *bname;
+	u64 prev_time = 0;
+	bool found_cmd_mmap = false,
+	     found_libc_mmap = false,
+	     found_vdso_mmap = false,
+	     found_ld_mmap = false;
+	int err = -1, errs = 0, i, wakeups = 0;
+	u32 cpu;
+	int total_events = 0, nr_events[PERF_RECORD_MAX] = { 0, };
+
+	if (evlist == NULL || argv == NULL) {
+		pr_debug("Not enough memory to create evlist\n");
+		goto out;
+	}
+
+	/*
+	 * We need at least one evsel in the evlist, use the default
+	 * one: "cycles".
+	 */
+	err = perf_evlist__add_default(evlist);
+	if (err < 0) {
+		pr_debug("Not enough memory to create evsel\n");
+		goto out_delete_evlist;
+	}
+
+	/*
+	 * Create maps of threads and cpus to monitor. In this case
+	 * we start with all threads and cpus (-1, -1) but then in
+	 * perf_evlist__prepare_workload we'll fill in the only thread
+	 * we're monitoring, the one forked there.
+	 */
+	err = perf_evlist__create_maps(evlist, &opts.target);
+	if (err < 0) {
+		pr_debug("Not enough memory to create thread/cpu maps\n");
+		goto out_delete_evlist;
+	}
+
+	/*
+	 * Prepare the workload in argv[] to run, it'll fork it, and then wait
+	 * for perf_evlist__start_workload() to exec it. This is done this way
+	 * so that we have time to open the evlist (calling sys_perf_event_open
+	 * on all the fds) and then mmap them.
+	 */
+	err = perf_evlist__prepare_workload(evlist, &opts, argv);
+	if (err < 0) {
+		pr_debug("Couldn't run the workload!\n");
+		goto out_delete_evlist;
+	}
+
+	/*
+	 * Config the evsels, setting attr->comm on the first one, etc.
+	 */
+	evsel = perf_evlist__first(evlist);
+	evsel->attr.sample_type |= PERF_SAMPLE_CPU;
+	evsel->attr.sample_type |= PERF_SAMPLE_TID;
+	evsel->attr.sample_type |= PERF_SAMPLE_TIME;
+	perf_evlist__config_attrs(evlist, &opts);
+
+	err = sched__get_first_possible_cpu(evlist->workload.pid, &cpu_mask);
+	if (err < 0) {
+		pr_debug("sched__get_first_possible_cpu: %s\n", strerror(errno));
+		goto out_delete_evlist;
+	}
+
+	cpu = err;
+
+	/*
+	 * So that we can check perf_sample.cpu on all the samples.
+	 */
+	if (sched_setaffinity(evlist->workload.pid, cpu_mask_size, &cpu_mask) < 0) {
+		pr_debug("sched_setaffinity: %s\n", strerror(errno));
+		goto out_delete_evlist;
+	}
+
+	/*
+	 * Call sys_perf_event_open on all the fds on all the evsels,
+	 * grouping them if asked to.
+	 */
+	err = perf_evlist__open(evlist);
+	if (err < 0) {
+		pr_debug("perf_evlist__open: %s\n", strerror(errno));
+		goto out_delete_evlist;
+	}
+
+	/*
+	 * mmap the first fd on a given CPU and ask for events for the other
+	 * fds in the same CPU to be injected in the same mmap ring buffer
+	 * (using ioctl(PERF_EVENT_IOC_SET_OUTPUT)).
+	 */
+	err = perf_evlist__mmap(evlist, opts.mmap_pages, false);
+	if (err < 0) {
+		pr_debug("perf_evlist__mmap: %s\n", strerror(errno));
+		goto out_delete_evlist;
+	}
+
+	/*
+	 * Now that all is properly set up, enable the events, they will
+	 * count just on workload.pid, which will start...
+	 */
+	perf_evlist__enable(evlist);
+
+	/*
+	 * Now!
+	 */
+	perf_evlist__start_workload(evlist);
+
+	while (1) {
+		int before = total_events;
+
+		for (i = 0; i < evlist->nr_mmaps; i++) {
+			union perf_event *event;
+
+			while ((event = perf_evlist__mmap_read(evlist, i)) != NULL) {
+				const u32 type = event->header.type;
+				const char *name = perf_event__name(type);
+
+				++total_events;
+				if (type < PERF_RECORD_MAX)
+					nr_events[type]++;
+
+				err = perf_evlist__parse_sample(evlist, event, &sample);
+				if (err < 0) {
+					if (verbose)
+						perf_event__fprintf(event, stderr);
+					pr_debug("Couldn't parse sample\n");
+					goto out_err;
+				}
+
+				if (verbose) {
+					pr_info("%" PRIu64" %d ", sample.time, sample.cpu);
+					perf_event__fprintf(event, stderr);
+				}
+
+				if (prev_time > sample.time) {
+					pr_debug("%s going backwards in time, prev=%" PRIu64 ", curr=%" PRIu64 "\n",
+						 name, prev_time, sample.time);
+					++errs;
+				}
+
+				prev_time = sample.time;
+
+				if (sample.cpu != cpu) {
+					pr_debug("%s with unexpected cpu, expected %d, got %d\n",
+						 name, cpu, sample.cpu);
+					++errs;
+				}
+
+				if ((pid_t)sample.pid != evlist->workload.pid) {
+					pr_debug("%s with unexpected pid, expected %d, got %d\n",
+						 name, evlist->workload.pid, sample.pid);
+					++errs;
+				}
+
+				if ((pid_t)sample.tid != evlist->workload.pid) {
+					pr_debug("%s with unexpected tid, expected %d, got %d\n",
+						 name, evlist->workload.pid, sample.tid);
+					++errs;
+				}
+
+				if ((type == PERF_RECORD_COMM ||
+				     type == PERF_RECORD_MMAP ||
+				     type == PERF_RECORD_FORK ||
+				     type == PERF_RECORD_EXIT) &&
+				     (pid_t)event->comm.pid != evlist->workload.pid) {
+					pr_debug("%s with unexpected pid/tid\n", name);
+					++errs;
+				}
+
+				if ((type == PERF_RECORD_COMM ||
+				     type == PERF_RECORD_MMAP) &&
+				     event->comm.pid != event->comm.tid) {
+					pr_debug("%s with different pid/tid!\n", name);
+					++errs;
+				}
+
+				switch (type) {
+				case PERF_RECORD_COMM:
+					if (strcmp(event->comm.comm, cmd)) {
+						pr_debug("%s with unexpected comm!\n", name);
+						++errs;
+					}
+					break;
+				case PERF_RECORD_EXIT:
+					goto found_exit;
+				case PERF_RECORD_MMAP:
+					bname = strrchr(event->mmap.filename, '/');
+					if (bname != NULL) {
+						if (!found_cmd_mmap)
+							found_cmd_mmap = !strcmp(bname + 1, cmd);
+						if (!found_libc_mmap)
+							found_libc_mmap = !strncmp(bname + 1, "libc", 4);
+						if (!found_ld_mmap)
+							found_ld_mmap = !strncmp(bname + 1, "ld", 2);
+					} else if (!found_vdso_mmap)
+						found_vdso_mmap = !strcmp(event->mmap.filename, "[vdso]");
+					break;
+
+				case PERF_RECORD_SAMPLE:
+					/* Just ignore samples for now */
+					break;
+				default:
+					pr_debug("Unexpected perf_event->header.type %d!\n",
+						 type);
+					++errs;
+				}
+			}
+		}
+
+		/*
+		 * We don't use poll here because at least at 3.1 times the
+		 * PERF_RECORD_{!SAMPLE} events don't honour
+		 * perf_event_attr.wakeup_events, just PERF_EVENT_SAMPLE does.
+		 */
+		if (total_events == before && false)
+			poll(evlist->pollfd, evlist->nr_fds, -1);
+
+		sleep(1);
+		if (++wakeups > 5) {
+			pr_debug("No PERF_RECORD_EXIT event!\n");
+			break;
+		}
+	}
+
+found_exit:
+	if (nr_events[PERF_RECORD_COMM] > 1) {
+		pr_debug("Excessive number of PERF_RECORD_COMM events!\n");
+		++errs;
+	}
+
+	if (nr_events[PERF_RECORD_COMM] == 0) {
+		pr_debug("Missing PERF_RECORD_COMM for %s!\n", cmd);
+		++errs;
+	}
+
+	if (!found_cmd_mmap) {
+		pr_debug("PERF_RECORD_MMAP for %s missing!\n", cmd);
+		++errs;
+	}
+
+	if (!found_libc_mmap) {
+		pr_debug("PERF_RECORD_MMAP for %s missing!\n", "libc");
+		++errs;
+	}
+
+	if (!found_ld_mmap) {
+		pr_debug("PERF_RECORD_MMAP for %s missing!\n", "ld");
+		++errs;
+	}
+
+	if (!found_vdso_mmap) {
+		pr_debug("PERF_RECORD_MMAP for %s missing!\n", "[vdso]");
+		++errs;
+	}
+out_err:
+	perf_evlist__munmap(evlist);
+out_delete_evlist:
+	perf_evlist__delete(evlist);
+out:
+	return (err < 0 || errs > 0) ? -1 : 0;
+}
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index 1a925dd..374b039 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -6,6 +6,7 @@ int test__vmlinux_matches_kallsyms(void);
 int test__open_syscall_event(void);
 int test__open_syscall_event_on_all_cpus(void);
 int test__basic_mmap(void);
+int test__PERF_RECORD(void);
 
 /* Util */
 int trace_event__id(const char *evname);
-- 
1.7.9.2.358.g22243

