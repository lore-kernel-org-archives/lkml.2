Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882Ab2IXQD3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 12:03:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:41458 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756705Ab2IXQAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 12:00:02 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 10/30] perf timechart: Use zalloc and fix a couple leaks
Date: Mon, 24 Sep 2012 12:59:24 -0300
Message-Id: <1348502384-14442-11-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1348502384-14442-1-git-send-email-acme@infradead.org>
References: <1348502384-14442-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Use zalloc for the malloc+memset open coded sequence.

Fix leak on the #ifdef'ed C state handling and when detecting invalid
data in p_state_change().

Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-v9x3q9rv4caxtox7wtjpchq5@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-timechart.c |   40 ++++++++++++++--------------------------
 1 files changed, 14 insertions(+), 26 deletions(-)

diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 55a3a6c..b1a8a3b 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -168,9 +168,8 @@ static struct per_pid *find_create_pid(int pid)
 			return cursor;
 		cursor = cursor->next;
 	}
-	cursor = malloc(sizeof(struct per_pid));
+	cursor = zalloc(sizeof(*cursor));
 	assert(cursor != NULL);
-	memset(cursor, 0, sizeof(struct per_pid));
 	cursor->pid = pid;
 	cursor->next = all_data;
 	all_data = cursor;
@@ -195,9 +194,8 @@ static void pid_set_comm(int pid, char *comm)
 		}
 		c = c->next;
 	}
-	c = malloc(sizeof(struct per_pidcomm));
+	c = zalloc(sizeof(*c));
 	assert(c != NULL);
-	memset(c, 0, sizeof(struct per_pidcomm));
 	c->comm = strdup(comm);
 	p->current = c;
 	c->next = p->all;
@@ -239,17 +237,15 @@ pid_put_sample(int pid, int type, unsigned int cpu, u64 start, u64 end)
 	p = find_create_pid(pid);
 	c = p->current;
 	if (!c) {
-		c = malloc(sizeof(struct per_pidcomm));
+		c = zalloc(sizeof(*c));
 		assert(c != NULL);
-		memset(c, 0, sizeof(struct per_pidcomm));
 		p->current = c;
 		c->next = p->all;
 		p->all = c;
 	}
 
-	sample = malloc(sizeof(struct cpu_sample));
+	sample = zalloc(sizeof(*sample));
 	assert(sample != NULL);
-	memset(sample, 0, sizeof(struct cpu_sample));
 	sample->start_time = start;
 	sample->end_time = end;
 	sample->type = type;
@@ -373,11 +369,10 @@ static void c_state_start(int cpu, u64 timestamp, int state)
 
 static void c_state_end(int cpu, u64 timestamp)
 {
-	struct power_event *pwr;
-	pwr = malloc(sizeof(struct power_event));
+	struct power_event *pwr = zalloc(sizeof(*pwr));
+
 	if (!pwr)
 		return;
-	memset(pwr, 0, sizeof(struct power_event));
 
 	pwr->state = cpus_cstate_state[cpu];
 	pwr->start_time = cpus_cstate_start_times[cpu];
@@ -392,14 +387,13 @@ static void c_state_end(int cpu, u64 timestamp)
 static void p_state_change(int cpu, u64 timestamp, u64 new_freq)
 {
 	struct power_event *pwr;
-	pwr = malloc(sizeof(struct power_event));
 
 	if (new_freq > 8000000) /* detect invalid data */
 		return;
 
+	pwr = zalloc(sizeof(*pwr));
 	if (!pwr)
 		return;
-	memset(pwr, 0, sizeof(struct power_event));
 
 	pwr->state = cpus_pstate_state[cpu];
 	pwr->start_time = cpus_pstate_start_times[cpu];
@@ -429,15 +423,13 @@ static void p_state_change(int cpu, u64 timestamp, u64 new_freq)
 static void
 sched_wakeup(int cpu, u64 timestamp, int pid, struct trace_entry *te)
 {
-	struct wake_event *we;
 	struct per_pid *p;
 	struct wakeup_entry *wake = (void *)te;
+	struct wake_event *we = zalloc(sizeof(*we));
 
-	we = malloc(sizeof(struct wake_event));
 	if (!we)
 		return;
 
-	memset(we, 0, sizeof(struct wake_event));
 	we->time = timestamp;
 	we->waker = pid;
 
@@ -579,13 +571,12 @@ static void end_sample_processing(void)
 	struct power_event *pwr;
 
 	for (cpu = 0; cpu <= numcpus; cpu++) {
-		pwr = malloc(sizeof(struct power_event));
+		/* C state */
+#if 0
+		pwr = zalloc(sizeof(*pwr));
 		if (!pwr)
 			return;
-		memset(pwr, 0, sizeof(struct power_event));
 
-		/* C state */
-#if 0
 		pwr->state = cpus_cstate_state[cpu];
 		pwr->start_time = cpus_cstate_start_times[cpu];
 		pwr->end_time = last_time;
@@ -597,10 +588,9 @@ static void end_sample_processing(void)
 #endif
 		/* P state */
 
-		pwr = malloc(sizeof(struct power_event));
+		pwr = zalloc(sizeof(*pwr));
 		if (!pwr)
 			return;
-		memset(pwr, 0, sizeof(struct power_event));
 
 		pwr->state = cpus_pstate_state[cpu];
 		pwr->start_time = cpus_pstate_start_times[cpu];
@@ -830,11 +820,9 @@ static void draw_process_bars(void)
 
 static void add_process_filter(const char *string)
 {
-	struct process_filter *filt;
-	int pid;
+	int pid = strtoull(string, NULL, 10);
+	struct process_filter *filt = malloc(sizeof(*filt));
 
-	pid = strtoull(string, NULL, 10);
-	filt = malloc(sizeof(struct process_filter));
 	if (!filt)
 		return;
 
-- 
1.7.1

