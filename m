Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300Ab1E0Vpv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 17:45:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:45726 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756461Ab1E0Vpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 17:45:45 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/5] perf events: initialize fd array to -1 instead of 0
Date: Fri, 27 May 2011 18:45:33 -0300
Message-Id: <1306532736-3790-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1306532736-3790-1-git-send-email-acme@infradead.org>
References: <1306532736-3790-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

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
 
-- 
1.6.2.5

