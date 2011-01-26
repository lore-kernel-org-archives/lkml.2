Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045Ab1AZHU3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 02:20:29 -0500
Received: from hera.kernel.org ([140.211.167.34]:53237 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752487Ab1AZHU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 02:20:27 -0500
Date: Wed, 26 Jan 2011 07:19:52 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        peterz@infradead.org, efault@gmx.de, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        efault@gmx.de, peterz@infradead.org, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf test: Add test for the evlist mmap routines
Message-ID: <tip-de5fa3a8a05cd60f59622e88cfeb90416760d78e@git.kernel.org>
Git-Commit-ID: de5fa3a8a05cd60f59622e88cfeb90416760d78e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 26 Jan 2011 07:19:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  de5fa3a8a05cd60f59622e88cfeb90416760d78e
Gitweb:     http://git.kernel.org/tip/de5fa3a8a05cd60f59622e88cfeb90416760d78e
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Sat, 15 Jan 2011 10:42:46 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sat, 22 Jan 2011 19:56:31 -0200

perf test: Add test for the evlist mmap routines

This test will generate random numbers of calls to some getpid syscalls,
then establish an mmap for a group of events that are created to monitor
these syscalls.

It will receive the events, using mmap, use its PERF_SAMPLE_ID generated
sample.id field to map back to its respective perf_evsel instance.

Then it checks if the number of syscalls reported as perf events by the
kernel corresponds to the number of syscalls made.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-test.c |  171 ++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 169 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 5a50e47..4fd3453 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -7,7 +7,9 @@
 
 #include "util/cache.h"
 #include "util/debug.h"
+#include "util/evlist.h"
 #include "util/parse-options.h"
+#include "util/parse-events.h"
 #include "util/session.h"
 #include "util/symbol.h"
 #include "util/thread.h"
@@ -238,14 +240,14 @@ out:
 #include "util/evsel.h"
 #include <sys/types.h>
 
-static int trace_event__id(const char *event_name)
+static int trace_event__id(const char *evname)
 {
 	char *filename;
 	int err = -1, fd;
 
 	if (asprintf(&filename,
 		     "/sys/kernel/debug/tracing/events/syscalls/%s/id",
-		     event_name) < 0)
+		     evname) < 0)
 		return -1;
 
 	fd = open(filename, O_RDONLY);
@@ -439,6 +441,167 @@ out_thread_map_delete:
 	return err;
 }
 
+/*
+ * This test will generate random numbers of calls to some getpid syscalls,
+ * then establish an mmap for a group of events that are created to monitor
+ * the syscalls.
+ *
+ * It will receive the events, using mmap, use its PERF_SAMPLE_ID generated
+ * sample.id field to map back to its respective perf_evsel instance.
+ *
+ * Then it checks if the number of syscalls reported as perf events by
+ * the kernel corresponds to the number of syscalls made.
+ */
+static int test__basic_mmap(void)
+{
+	int err = -1;
+	event_t *event;
+	struct thread_map *threads;
+	struct perf_session session;
+	struct cpu_map *cpus;
+	struct perf_evlist *evlist;
+	struct perf_event_attr attr = {
+		.type		= PERF_TYPE_TRACEPOINT,
+		.read_format	= PERF_FORMAT_ID,
+		.sample_type	= PERF_SAMPLE_ID,
+		.watermark	= 0,
+	};
+	cpu_set_t cpu_set;
+	const char *syscall_names[] = { "getsid", "getppid", "getpgrp",
+					"getpgid", };
+	pid_t (*syscalls[])(void) = { (void *)getsid, getppid, getpgrp,
+				      (void*)getpgid };
+#define nsyscalls ARRAY_SIZE(syscall_names)
+	int ids[nsyscalls];
+	unsigned int nr_events[nsyscalls],
+		     expected_nr_events[nsyscalls], i, j;
+	struct perf_evsel *evsels[nsyscalls], *evsel;
+
+	for (i = 0; i < nsyscalls; ++i) {
+		char name[64];
+
+		snprintf(name, sizeof(name), "sys_enter_%s", syscall_names[i]);
+		ids[i] = trace_event__id(name);
+		if (ids[i] < 0) {
+			pr_debug("Is debugfs mounted on /sys/kernel/debug?\n");
+			return -1;
+		}
+		nr_events[i] = 0;
+		expected_nr_events[i] = random() % 257;
+	}
+
+	threads = thread_map__new(-1, getpid());
+	if (threads == NULL) {
+		pr_debug("thread_map__new\n");
+		return -1;
+	}
+
+	cpus = cpu_map__new(NULL);
+	if (threads == NULL) {
+		pr_debug("thread_map__new\n");
+		goto out_free_threads;
+	}
+
+	CPU_ZERO(&cpu_set);
+	CPU_SET(cpus->map[0], &cpu_set);
+	sched_setaffinity(0, sizeof(cpu_set), &cpu_set);
+	if (sched_setaffinity(0, sizeof(cpu_set), &cpu_set) < 0) {
+		pr_debug("sched_setaffinity() failed on CPU %d: %s ",
+			 cpus->map[0], strerror(errno));
+		goto out_free_cpus;
+	}
+
+	evlist = perf_evlist__new();
+	if (threads == NULL) {
+		pr_debug("perf_evlist__new\n");
+		goto out_free_cpus;
+	}
+
+	/* anonymous union fields, can't be initialized above */
+	attr.wakeup_events = 1;
+	attr.sample_period = 1;
+
+	/*
+ 	 * FIXME: use evsel->attr.sample_type in event__parse_sample.
+ 	 * 	  This will nicely remove the requirement that we have
+ 	 * 	  all the events with the same sample_type.
+ 	 */
+	session.sample_type = attr.sample_type;
+
+	for (i = 0; i < nsyscalls; ++i) {
+		attr.config = ids[i];
+		evsels[i] = perf_evsel__new(&attr, i);
+		if (evsels[i] == NULL) {
+			pr_debug("perf_evsel__new\n");
+			goto out_free_evlist;
+		}
+
+		perf_evlist__add(evlist, evsels[i]);
+
+		if (perf_evsel__open(evsels[i], cpus, threads, false, false) < 0) {
+			pr_debug("failed to open counter: %s, "
+				 "tweak /proc/sys/kernel/perf_event_paranoid?\n",
+				 strerror(errno));
+			goto out_close_fd;
+		}
+	}
+
+	if (perf_evlist__mmap(evlist, cpus, threads, 128, true) < 0) {
+		pr_debug("failed to mmap events: %d (%s)\n", errno,
+			 strerror(errno));
+		goto out_close_fd;
+	}
+
+	for (i = 0; i < nsyscalls; ++i)
+		for (j = 0; j < expected_nr_events[i]; ++j) {
+			int foo = syscalls[i]();
+			++foo;
+		}
+
+	while ((event = perf_evlist__read_on_cpu(evlist, 0)) != NULL) {
+		struct sample_data sample;
+
+		if (event->header.type != PERF_RECORD_SAMPLE) {
+			pr_debug("unexpected %s event\n",
+				 event__get_event_name(event->header.type));
+			goto out_munmap;
+		}
+
+		event__parse_sample(event, &session, &sample);
+		evsel = perf_evlist__id2evsel(evlist, sample.id);
+		if (evsel == NULL) {
+			pr_debug("event with id %" PRIu64
+				 " doesn't map to an evsel\n", sample.id);
+			goto out_munmap;
+		}
+		nr_events[evsel->idx]++;
+	}
+
+	list_for_each_entry(evsel, &evlist->entries, node) {
+		if (nr_events[evsel->idx] != expected_nr_events[evsel->idx]) {
+			pr_debug("expected %d %s events, got %d\n",
+				 expected_nr_events[evsel->idx],
+				 event_name(evsel), nr_events[evsel->idx]);
+			goto out_munmap;
+		}
+	}
+
+	err = 0;
+out_munmap:
+	perf_evlist__munmap(evlist, 1);
+out_close_fd:
+	for (i = 0; i < nsyscalls; ++i)
+		perf_evsel__close_fd(evsels[i], 1, threads->nr);
+out_free_evlist:
+	perf_evlist__delete(evlist);
+out_free_cpus:
+	cpu_map__delete(cpus);
+out_free_threads:
+	thread_map__delete(threads);
+	return err;
+#undef nsyscalls
+}
+
 static struct test {
 	const char *desc;
 	int (*func)(void);
@@ -456,6 +619,10 @@ static struct test {
 		.func = test__open_syscall_event_on_all_cpus,
 	},
 	{
+		.desc = "read samples using the mmap interface",
+		.func = test__basic_mmap,
+	},
+	{
 		.func = NULL,
 	},
 };
