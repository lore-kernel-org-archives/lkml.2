Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758848Ab0EDMj0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 08:39:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:51783 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758720Ab0EDMjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 08:39:19 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, peterz@infradead.org, efault@gmx.de, avi@redhat.com,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 10/12] perf: make nr_events an int and add perf_online_mutex to protect it
Date: Tue,  4 May 2010 14:38:42 +0200
Message-Id: <1272976724-14312-11-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1272976724-14312-1-git-send-email-tj@kernel.org>
References: <1272976724-14312-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 04 May 2010 12:38:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change nr_events from atomic_t to int and add perf_online_mutex to
protect it.  Helpers to manipulate the count, perf_inc_nr_events() and
perf_dec_nr_events(), are added.  The former may fail although it
doesn't in the current code.

This will be used to make sched perf functions called via tracepoints.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 kernel/perf_event.c |   40 ++++++++++++++++++++++++++++++++++++----
 1 files changed, 36 insertions(+), 4 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 3f3e328..621d1f1 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -43,7 +43,7 @@ int perf_max_events __read_mostly = 1;
 static int perf_reserved_percpu __read_mostly;
 static int perf_overcommit __read_mostly = 1;
 
-static atomic_t nr_events __read_mostly;
+static int nr_events __read_mostly;
 static atomic_t nr_mmap_events __read_mostly;
 static atomic_t nr_comm_events __read_mostly;
 static atomic_t nr_task_events __read_mostly;
@@ -72,6 +72,26 @@ static atomic64_t perf_event_id;
 static DEFINE_SPINLOCK(perf_resource_lock);
 
 /*
+ * Lock to protect nr_events and master enable:
+ */
+static DEFINE_MUTEX(perf_online_mutex);
+
+static int perf_inc_nr_events(void)
+{
+	mutex_lock(&perf_online_mutex);
+	nr_events++;
+	mutex_unlock(&perf_online_mutex);
+	return 0;
+}
+
+static void perf_dec_nr_events(void)
+{
+	mutex_lock(&perf_online_mutex);
+	nr_events--;
+	mutex_unlock(&perf_online_mutex);
+}
+
+/*
  * Architecture provided APIs - weak aliases:
  */
 extern __weak const struct pmu *hw_perf_event_init(struct perf_event *event)
@@ -1589,7 +1609,13 @@ void perf_event_task_tick(struct task_struct *curr)
 	struct perf_event_context *ctx;
 	int rotate = 0;
 
-	if (!atomic_read(&nr_events))
+	/*
+	 * nr_events is incremented before events are enabled and
+	 * decremented after they have been pulled out, so it is
+	 * guaranteed to read as non-zero with any enabled event on
+	 * this cpu.
+	 */
+	if (!nr_events)
 		return;
 
 	cpuctx = &__get_cpu_var(perf_cpu_context);
@@ -1857,7 +1883,7 @@ static void free_event(struct perf_event *event)
 	perf_pending_sync(event);
 
 	if (!event->parent) {
-		atomic_dec(&nr_events);
+		perf_dec_nr_events();
 		if (event->attr.mmap)
 			atomic_dec(&nr_mmap_events);
 		if (event->attr.comm)
@@ -4569,6 +4595,12 @@ perf_event_alloc(struct perf_event_attr *attr,
 	if (!event)
 		return ERR_PTR(-ENOMEM);
 
+	err = perf_inc_nr_events();
+	if (err) {
+		kfree(event);
+		return ERR_PTR(err);
+	}
+
 	/*
 	 * Single events are their own group leaders, with an
 	 * empty sibling list:
@@ -4657,6 +4689,7 @@ done:
 	if (err) {
 		if (event->ns)
 			put_pid_ns(event->ns);
+		perf_dec_nr_events();
 		kfree(event);
 		return ERR_PTR(err);
 	}
@@ -4664,7 +4697,6 @@ done:
 	event->pmu = pmu;
 
 	if (!event->parent) {
-		atomic_inc(&nr_events);
 		if (event->attr.mmap)
 			atomic_inc(&nr_mmap_events);
 		if (event->attr.comm)
-- 
1.6.4.2

