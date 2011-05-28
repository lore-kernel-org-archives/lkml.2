Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213Ab1E1Pkr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 11:40:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:50232 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753665Ab1E1Pkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 11:40:46 -0400
Date: Sat, 28 May 2011 15:40:24 GMT
From: tip-bot for David Ahern <dsahern@gmail.com>
Message-ID: <tip-4af4c9550ccaaf0b53013ff730bc15068ffe6abc@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, fweisbec@gmail.com,
        peterz@infradead.org, dsahern@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1306511914-8016-1-git-send-email-dsahern@gmail.com>
References: <1306511914-8016-1-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf events: initialize fd array to -1 instead of 0
Git-Commit-ID: 4af4c9550ccaaf0b53013ff730bc15068ffe6abc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 28 May 2011 15:40:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4af4c9550ccaaf0b53013ff730bc15068ffe6abc
Gitweb:     http://git.kernel.org/tip/4af4c9550ccaaf0b53013ff730bc15068ffe6abc
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Fri, 27 May 2011 09:58:34 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 27 May 2011 16:02:12 -0300

perf events: initialize fd array to -1 instead of 0

perf_evsel__alloc_fd allocates an array of file descriptors with the
memory initialized to 0. The array has dimensions for cpus and threads.

Later, __perf_evsel__open calls sys_perf_event_open for each cpu and thread
dimensions. If the open fails for any of the cpus or threads then the fd's
for this event are closed and the fd entry in the array is set to -1. Now,
if the first attempt fails for the event (e.g., the event is not supported)
the remaining dimensions (cpu > 0 and thread > 0) are not touched and left
at the initialized value of 0.

builtin-stat catches ENOENT and ENOSYS failures and allows the command to
continue. The end result is that stat attempts to read from an fd of 0 which
of course is stdin and so the command hangs until you type ctrl-D.

Resolve by initializing the array to -1 since an fd < 0 is already
handled.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/1306511914-8016-1-git-send-email-dsahern@gmail.com
Signed-off-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evsel.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index ee0fe0d..cca29ed 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -35,7 +35,17 @@ struct perf_evsel *perf_evsel__new(struct perf_event_attr *attr, int idx)
 
 int perf_evsel__alloc_fd(struct perf_evsel *evsel, int ncpus, int nthreads)
 {
+	int cpu, thread;
 	evsel->fd = xyarray__new(ncpus, nthreads, sizeof(int));
+
+	if (evsel->fd) {
+		for (cpu = 0; cpu < ncpus; cpu++) {
+			for (thread = 0; thread < nthreads; thread++) {
+				FD(evsel, cpu, thread) = -1;
+			}
+		}
+	}
+
 	return evsel->fd != NULL ? 0 : -ENOMEM;
 }
 
