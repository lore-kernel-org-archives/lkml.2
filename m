Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508Ab1ADDtD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 22:49:03 -0500
Received: from canuck.infradead.org ([134.117.69.58]:44168 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328Ab1ADDsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 22:48:45 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 10/11] perf evsel: Auto allocate resources needed for some methods
Date: Tue,  4 Jan 2011 01:48:24 -0200
Message-Id: <1294112905-25325-11-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1294112905-25325-1-git-send-email-acme@infradead.org>
References: <1294112905-25325-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

While writing the first user of the routines created from the ad-hoc
routines in the existing builtins I noticed that the resulting set of
calls was too long, reduce it by doing some best effort allocations.

Tools that need to operate on multiple threads and cpus should pre-allocate
enough resources by explicitely calling the perf_evsel__alloc_{fd,counters}
methods.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
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
 tools/perf/util/evsel.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index e44be52..c95267e 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -66,6 +66,9 @@ int __perf_evsel__read_on_cpu(struct perf_evsel *evsel,
 	if (FD(evsel, cpu, thread) < 0)
 		return -EINVAL;
 
+	if (evsel->counts == NULL && perf_evsel__alloc_counts(evsel, cpu + 1) < 0)
+		return -ENOMEM;
+
 	if (readn(FD(evsel, cpu, thread), &count, nv * sizeof(u64)) < 0)
 		return -errno;
 
@@ -129,6 +132,9 @@ int perf_evsel__open_per_cpu(struct perf_evsel *evsel, struct cpu_map *cpus)
 {
 	int cpu;
 
+	if (evsel->fd == NULL && perf_evsel__alloc_fd(evsel, cpus->nr, 1) < 0)
+		return -1;
+
 	for (cpu = 0; cpu < cpus->nr; cpu++) {
 		FD(evsel, cpu, 0) = sys_perf_event_open(&evsel->attr, -1,
 							cpus->map[cpu], -1, 0);
@@ -150,6 +156,9 @@ int perf_evsel__open_per_thread(struct perf_evsel *evsel, struct thread_map *thr
 {
 	int thread;
 
+	if (evsel->fd == NULL && perf_evsel__alloc_fd(evsel, 1, threads->nr))
+		return -1;
+
 	for (thread = 0; thread < threads->nr; thread++) {
 		FD(evsel, 0, thread) = sys_perf_event_open(&evsel->attr,
 							   threads->map[thread], -1, -1, 0);
-- 
1.6.2.5

