Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758588Ab2I1Q3p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 12:29:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41870 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757585Ab2I1Q3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 12:29:43 -0400
Date: Fri, 28 Sep 2012 09:29:24 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-p5w9aq0jcbb91ghzqomowm16@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, eparis@redhat.com,
        peterz@infradead.org, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, jlayton@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, eparis@redhat.com,
        efault@gmx.de, peterz@infradead.org, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        jlayton@redhat.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf test:
  Add test to check we correctly parse and match syscall open parms
Git-Commit-ID: eb2f270338461a4de659a21946739748160c0816
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 28 Sep 2012 09:29:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  eb2f270338461a4de659a21946739748160c0816
Gitweb:     http://git.kernel.org/tip/eb2f270338461a4de659a21946739748160c0816
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 26 Sep 2012 13:23:10 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 26 Sep 2012 13:42:01 -0300

perf test: Add test to check we correctly parse and match syscall open parms

It will set up a syscall open tracepoint event, generate an open with
invalid flags, then check those flags were the ones reported in the
tracepoint fired.

For the filename we need vfs:getname, but that will go thru some more
iterations as the vfs getname codebase is going thru changes lately.

When that is in I'll just check that the perf_evsel__newtp constructor
is not bailing out and then add it to the evlist, catch the event and
check the filename against the one used in the 'open' call used to
trigger the event.

Cc: David Ahern <dsahern@gmail.com>
Cc: Eric Paris <eparis@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jeff Layton <jlayton@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-p5w9aq0jcbb91ghzqomowm16@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-test.c |  116 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 116 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 2fd2c03..484f26c 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -1289,6 +1289,118 @@ static int perf_evsel__tp_sched_test(void)
 	return ret;
 }
 
+static int test__syscall_open_tp_fields(void)
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
+ 	 * Generate the event:
+ 	 */
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
+
 static struct test {
 	const char *desc;
 	int (*func)(void);
@@ -1340,6 +1452,10 @@ static struct test {
 		.func = perf_evsel__tp_sched_test,
 	},
 	{
+		.desc = "Generate and check syscalls:sys_enter_open event fields",
+		.func = test__syscall_open_tp_fields,
+	},
+	{
 		.func = NULL,
 	},
 };
