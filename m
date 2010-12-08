Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756362Ab0LHUkd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 15:40:33 -0500
Received: from hera.kernel.org ([140.211.167.34]:34190 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756201Ab0LHUkb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 15:40:31 -0500
Date: Wed, 8 Dec 2010 20:39:59 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Fix duplicate events with multiple-pmu vs software events
Message-ID: <tip-5167695753c63444a9e6cbbef136200a16c7a225@git.kernel.org>
Git-Commit-ID: 5167695753c63444a9e6cbbef136200a16c7a225
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 08 Dec 2010 20:40:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5167695753c63444a9e6cbbef136200a16c7a225
Gitweb:     http://git.kernel.org/tip/5167695753c63444a9e6cbbef136200a16c7a225
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 7 Dec 2010 14:18:20 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 8 Dec 2010 20:14:08 +0100

perf: Fix duplicate events with multiple-pmu vs software events

Because the multi-pmu bits can share contexts between struct pmu
instances we could get duplicate events by iterating the pmu list.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/perf_event.h |    1 +
 kernel/perf_event.c        |   35 +++++++++++++++++++++++++++++------
 2 files changed, 30 insertions(+), 6 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index de2c417..4f1279e 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -887,6 +887,7 @@ struct perf_cpu_context {
 	int				exclusive;
 	struct list_head		rotation_list;
 	int				jiffies_interval;
+	struct pmu			*active_pmu;
 };
 
 struct perf_output_handle {
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index eac7e33..7b87017 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -3824,6 +3824,8 @@ static void perf_event_task_event(struct perf_task_event *task_event)
 	rcu_read_lock();
 	list_for_each_entry_rcu(pmu, &pmus, entry) {
 		cpuctx = get_cpu_ptr(pmu->pmu_cpu_context);
+		if (cpuctx->active_pmu != pmu)
+			goto next;
 		perf_event_task_ctx(&cpuctx->ctx, task_event);
 
 		ctx = task_event->task_ctx;
@@ -3959,6 +3961,8 @@ static void perf_event_comm_event(struct perf_comm_event *comm_event)
 	rcu_read_lock();
 	list_for_each_entry_rcu(pmu, &pmus, entry) {
 		cpuctx = get_cpu_ptr(pmu->pmu_cpu_context);
+		if (cpuctx->active_pmu != pmu)
+			goto next;
 		perf_event_comm_ctx(&cpuctx->ctx, comm_event);
 
 		ctxn = pmu->task_ctx_nr;
@@ -4144,6 +4148,8 @@ got_name:
 	rcu_read_lock();
 	list_for_each_entry_rcu(pmu, &pmus, entry) {
 		cpuctx = get_cpu_ptr(pmu->pmu_cpu_context);
+		if (cpuctx->active_pmu != pmu)
+			goto next;
 		perf_event_mmap_ctx(&cpuctx->ctx, mmap_event,
 					vma->vm_flags & VM_EXEC);
 
@@ -5145,20 +5151,36 @@ static void *find_pmu_context(int ctxn)
 	return NULL;
 }
 
-static void free_pmu_context(void * __percpu cpu_context)
+static void update_pmu_context(struct pmu *pmu, struct pmu *old_pmu)
 {
-	struct pmu *pmu;
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		struct perf_cpu_context *cpuctx;
+
+		cpuctx = per_cpu_ptr(pmu->pmu_cpu_context, cpu);
+
+		if (cpuctx->active_pmu == old_pmu)
+			cpuctx->active_pmu = pmu;
+	}
+}
+
+static void free_pmu_context(struct pmu *pmu)
+{
+	struct pmu *i;
 
 	mutex_lock(&pmus_lock);
 	/*
 	 * Like a real lame refcount.
 	 */
-	list_for_each_entry(pmu, &pmus, entry) {
-		if (pmu->pmu_cpu_context == cpu_context)
+	list_for_each_entry(i, &pmus, entry) {
+		if (i->pmu_cpu_context == pmu->pmu_cpu_context) {
+			update_pmu_context(i, pmu);
 			goto out;
+		}
 	}
 
-	free_percpu(cpu_context);
+	free_percpu(pmu->pmu_cpu_context);
 out:
 	mutex_unlock(&pmus_lock);
 }
@@ -5190,6 +5212,7 @@ int perf_pmu_register(struct pmu *pmu)
 		cpuctx->ctx.pmu = pmu;
 		cpuctx->jiffies_interval = 1;
 		INIT_LIST_HEAD(&cpuctx->rotation_list);
+		cpuctx->active_pmu = pmu;
 	}
 
 got_cpu_context:
@@ -5241,7 +5264,7 @@ void perf_pmu_unregister(struct pmu *pmu)
 	synchronize_rcu();
 
 	free_percpu(pmu->pmu_disable_count);
-	free_pmu_context(pmu->pmu_cpu_context);
+	free_pmu_context(pmu);
 }
 
 struct pmu *perf_init_event(struct perf_event *event)
