Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340Ab0ETJoY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 05:44:24 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:33374 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755204Ab0ETJoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 05:44:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=iSg4DDRF/zTPVUrXegKhJ5ilTdzOvsqTB0Y9w+23C3PDPogy6FKCNZUvyKBZjWwxf4
         se9QmTF9CRByN7qGChjIEaInJI6BsXhLACa0zS+DHUJVIp/E/ND1LuoE+Jh57aPrij5i
         zeUiHKeQrKFkKyLZ9S4M8O9hEvo+RmSN5s9p8=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 2/3] perf: Comply with new rcu checks API
Date: Thu, 20 May 2010 11:44:18 +0200
Message-Id: <1274348659-15417-3-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1274348659-15417-1-git-send-regression-fweisbec@gmail.com>
References: <1274348659-15417-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The software events hlist doesn't fully comply with the new
rcu checks api.

We need to consider three different sides that access the hlist:

- the hlist allocation/release side. This side happens when an
  events is created or released, accesses to the hlist are
  serialized under the cpuctx mutex.

- the events insertion/removal in the hlist. This side is always
  serialized against the above one. The hlist is always present
  during such operations. This side happens when a software event
  is scheduled in/out. The serialization that ensures the software
  event is really attached to the context is made under the
  ctx->lock.

- events triggering. This is the read side, it can happen
  concurrently with any update side.

This patch deals with them one by one and anticipates with the
separate rcu mem space patches in preparation.

This patch fixes various annoying rcu warnings.

Reported-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
---
 kernel/perf_event.c |   58 ++++++++++++++++++++++++++++++++++++++++----------
 1 files changed, 46 insertions(+), 12 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index a4fa381..511677b 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -4066,19 +4066,46 @@ static inline u64 swevent_hash(u64 type, u32 event_id)
 	return hash_64(val, SWEVENT_HLIST_BITS);
 }
 
-static struct hlist_head *
-find_swevent_head(struct perf_cpu_context *ctx, u64 type, u32 event_id)
+static inline struct hlist_head *
+__find_swevent_head(struct swevent_hlist *hlist, u64 type, u32 event_id)
 {
-	u64 hash;
-	struct swevent_hlist *hlist;
+	u64 hash = swevent_hash(type, event_id);
+
+	return &hlist->heads[hash];
+}
 
-	hash = swevent_hash(type, event_id);
+/* For the read side: events when they trigger */
+static inline struct hlist_head *
+find_swevent_head_rcu(struct perf_cpu_context *ctx, u64 type, u32 event_id)
+{
+	struct swevent_hlist *hlist;
 
 	hlist = rcu_dereference(ctx->swevent_hlist);
 	if (!hlist)
 		return NULL;
 
-	return &hlist->heads[hash];
+	return __find_swevent_head(hlist, type, event_id);
+}
+
+/* For the event head insertion and removal in the hlist */
+static inline struct hlist_head *
+find_swevent_head(struct perf_cpu_context *ctx, struct perf_event *event)
+{
+	struct swevent_hlist *hlist;
+	u32 event_id = event->attr.config;
+	u64 type = event->attr.type;
+
+	/*
+	 * Event scheduling is always serialized against hlist allocation
+	 * and release. Which makes the protected version suitable here.
+	 * The context lock guarantees that.
+	 */
+	hlist = rcu_dereference_protected(ctx->swevent_hlist,
+					  lockdep_is_held(&event->ctx->lock));
+	if (!hlist)
+		return NULL;
+
+	return __find_swevent_head(hlist, type, event_id);
 }
 
 static void do_perf_sw_event(enum perf_type_id type, u32 event_id,
@@ -4095,7 +4122,7 @@ static void do_perf_sw_event(enum perf_type_id type, u32 event_id,
 
 	rcu_read_lock();
 
-	head = find_swevent_head(cpuctx, type, event_id);
+	head = find_swevent_head_rcu(cpuctx, type, event_id);
 
 	if (!head)
 		goto end;
@@ -4178,7 +4205,7 @@ static int perf_swevent_enable(struct perf_event *event)
 		perf_swevent_set_period(event);
 	}
 
-	head = find_swevent_head(cpuctx, event->attr.type, event->attr.config);
+	head = find_swevent_head(cpuctx, event);
 	if (WARN_ON_ONCE(!head))
 		return -EINVAL;
 
@@ -4366,6 +4393,14 @@ static const struct pmu perf_ops_task_clock = {
 	.read		= task_clock_perf_event_read,
 };
 
+/* Deref the hlist from the update side */
+static inline struct swevent_hlist *
+swevent_hlist_deref(struct perf_cpu_context *cpuctx)
+{
+	return rcu_dereference_protected(cpuctx->swevent_hlist,
+					 lockdep_is_held(&cpuctx->hlist_mutex));
+}
+
 static void swevent_hlist_release_rcu(struct rcu_head *rcu_head)
 {
 	struct swevent_hlist *hlist;
@@ -4376,12 +4411,11 @@ static void swevent_hlist_release_rcu(struct rcu_head *rcu_head)
 
 static void swevent_hlist_release(struct perf_cpu_context *cpuctx)
 {
-	struct swevent_hlist *hlist;
+	struct swevent_hlist *hlist = swevent_hlist_deref(cpuctx);
 
-	if (!cpuctx->swevent_hlist)
+	if (!hlist)
 		return;
 
-	hlist = cpuctx->swevent_hlist;
 	rcu_assign_pointer(cpuctx->swevent_hlist, NULL);
 	call_rcu(&hlist->rcu_head, swevent_hlist_release_rcu);
 }
@@ -4418,7 +4452,7 @@ static int swevent_hlist_get_cpu(struct perf_event *event, int cpu)
 
 	mutex_lock(&cpuctx->hlist_mutex);
 
-	if (!cpuctx->swevent_hlist && cpu_online(cpu)) {
+	if (!swevent_hlist_deref(cpuctx) && cpu_online(cpu)) {
 		struct swevent_hlist *hlist;
 
 		hlist = kzalloc(sizeof(*hlist), GFP_KERNEL);
-- 
1.6.2.3

