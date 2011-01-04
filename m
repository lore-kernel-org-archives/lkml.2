Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450Ab1ADI0I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 03:26:08 -0500
Received: from hera.kernel.org ([140.211.167.34]:59225 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752075Ab1ADI0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 03:26:05 -0500
Date: Tue, 4 Jan 2011 08:25:37 GMT
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
Subject: [tip:perf/core] perf evsel: Auto allocate resources needed for some methods
Message-ID: <tip-4eed11d5e24540dc133003b6e8f904cb747ac4bb@git.kernel.org>
Git-Commit-ID: 4eed11d5e24540dc133003b6e8f904cb747ac4bb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 04 Jan 2011 08:25:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4eed11d5e24540dc133003b6e8f904cb747ac4bb
Gitweb:     http://git.kernel.org/tip/4eed11d5e24540dc133003b6e8f904cb747ac4bb
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 4 Jan 2011 00:13:17 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 4 Jan 2011 00:31:32 -0200

perf evsel: Auto allocate resources needed for some methods

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
