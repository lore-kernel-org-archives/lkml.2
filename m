Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303Ab1ADI0r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 03:26:47 -0500
Received: from hera.kernel.org ([140.211.167.34]:59249 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720Ab1ADI0q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 03:26:46 -0500
Date: Tue, 4 Jan 2011 08:26:04 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        peterz@infradead.org, efault@gmx.de, fweisbec@gmail.com,
        phan@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        efault@gmx.de, peterz@infradead.org, phan@redhat.com,
        fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf test: Add test for counting open syscalls
Message-ID: <tip-d854861c4292a4e675a5d3bfd862c5f7421c81e8@git.kernel.org>
Git-Commit-ID: d854861c4292a4e675a5d3bfd862c5f7421c81e8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 04 Jan 2011 08:26:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d854861c4292a4e675a5d3bfd862c5f7421c81e8
Gitweb:     http://git.kernel.org/tip/d854861c4292a4e675a5d3bfd862c5f7421c81e8
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 4 Jan 2011 00:16:20 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 4 Jan 2011 00:32:06 -0200

perf test: Add test for counting open syscalls

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
