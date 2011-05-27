Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903Ab1E0P6o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 11:58:44 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52409 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754848Ab1E0P6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 11:58:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=tq7BRt164wFr7XxQpDKL4wLSmrvdISprypeCH3DF5ktkS7zkMo4SvZgw463ycwKAcv
         xBG0eLXUzafWyDsvEYmLcYxFEcjwRpaef+nQrPxOyEepRBnGwvSx8jGj3RkqpadmVTyv
         3DZKRGu8B00t99l0M+RH3uYwSuTHzwiQWJpvc=
From: David Ahern <dsahern@gmail.com>
To: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: acme@ghostprotocols.net, mingo@elte.hu, peterz@infradead.org,
        fweisbec@gmail.com, paulus@samba.org, tglx@linutronix.de,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH] perf events: initialize fd array to -1 instead of 0
Date: Fri, 27 May 2011 09:58:34 -0600
Message-Id: <1306511914-8016-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/perf/util/evsel.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index d6fd59b..5ff01ac 100644
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
1.7.5.1

