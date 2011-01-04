Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751815Ab1ADDtN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 22:49:13 -0500
Received: from casper.infradead.org ([85.118.1.10]:43472 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355Ab1ADDsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 22:48:47 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Han Pingtian <phan@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 11/11] perf test: Add test for counting open syscalls
Date: Tue,  4 Jan 2011 01:48:25 -0200
Message-Id: <1294112905-25325-12-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1294112905-25325-1-git-send-email-acme@infradead.org>
References: <1294112905-25325-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

To test the use of the perf_evsel class on something other than
the tools from where we refactored code to create it.

It calls open() N times and then checks if the event created to
monitor it returns N events.

[acme@felicio linux]$ perf test
 1: vmlinux symtab matches kallsyms: Ok
 2: detect open syscall event: Ok
[acme@felicio linux]$

It does.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Han Pingtian <phan@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-test.c |   83 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 83 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index e0c3f47..6c99152 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -234,6 +234,85 @@ out:
 	return err;
 }
 
+#include "util/evsel.h"
+#include <sys/types.h>
+
+static int trace_event__id(const char *event_name)
+{
+	char *filename;
+	int err = -1, fd;
+
+	if (asprintf(&filename,
+		     "/sys/kernel/debug/tracing/events/syscalls/%s/id",
+		     event_name) < 0)
+		return -1;
+
+	fd = open(filename, O_RDONLY);
+	if (fd >= 0) {
+		char id[16];
+		if (read(fd, id, sizeof(id)) > 0)
+			err = atoi(id);
+		close(fd);
+	}
+
+	free(filename);
+	return err;
+}
+
+static int test__open_syscall_event(void)
+{
+	int err = -1, fd;
+	struct thread_map *threads;
+	struct perf_evsel *evsel;
+	unsigned int nr_open_calls = 111, i;
+	int id = trace_event__id("sys_enter_open");
+
+	if (id < 0) {
+		pr_debug("trace_event__id(\"sys_enter_open\") ");
+		return -1;
+	}
+
+	threads = thread_map__new(-1, getpid());
+	if (threads == NULL) {
+		pr_debug("thread_map__new ");
+		return -1;
+	}
+
+	evsel = perf_evsel__new(PERF_TYPE_TRACEPOINT, id, 0);
+	if (evsel == NULL) {
+		pr_debug("perf_evsel__new ");
+		goto out_thread_map_delete;
+	}
+
+	if (perf_evsel__open_per_thread(evsel, threads) < 0) {
+		pr_debug("perf_evsel__open_per_thread ");
+		goto out_evsel_delete;
+	}
+
+	for (i = 0; i < nr_open_calls; ++i) {
+		fd = open("/etc/passwd", O_RDONLY);
+		close(fd);
+	}
+
+	if (perf_evsel__read_on_cpu(evsel, 0, 0) < 0) {
+		pr_debug("perf_evsel__open_read_on_cpu ");
+		goto out_close_fd;
+	}
+
+	if (evsel->counts->cpu[0].val != nr_open_calls)
+		pr_debug("perf_evsel__read_on_cpu: expected to intercept %d calls, got %Ld ",
+			 nr_open_calls, evsel->counts->cpu[0].val);
+	
+	err = 0;
+out_close_fd:
+	perf_evsel__close_fd(evsel, 1, threads->nr);
+out_evsel_delete:
+	perf_evsel__delete(evsel);
+out_thread_map_delete:
+	thread_map__delete(threads);
+	return err;
+}
+
 static struct test {
 	const char *desc;
 	int (*func)(void);
@@ -243,6 +322,10 @@ static struct test {
 		.func = test__vmlinux_matches_kallsyms,
 	},
 	{
+		.desc = "detect open syscall event",
+		.func = test__open_syscall_event,
+	},
+	{
 		.func = NULL,
 	},
 };
-- 
1.6.2.5

