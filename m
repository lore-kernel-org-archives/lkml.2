Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758438Ab0KROJr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 09:09:47 -0500
Received: from hera.kernel.org ([140.211.167.34]:41432 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758146Ab0KROJp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 09:09:45 -0500
Date: Thu, 18 Nov 2010 14:09:16 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, oleg@redhat.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, oleg@redhat.com,
        mingo@elte.hu
In-Reply-To: <1289576883.2084.286.camel@laptop>
References: <1289576883.2084.286.camel@laptop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Fix owner-list vs exit
Message-ID: <tip-8882135bcd332f294df5455747ea43ba9e6f77ad@git.kernel.org>
Git-Commit-ID: 8882135bcd332f294df5455747ea43ba9e6f77ad
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 18 Nov 2010 14:09:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8882135bcd332f294df5455747ea43ba9e6f77ad
Gitweb:     http://git.kernel.org/tip/8882135bcd332f294df5455747ea43ba9e6f77ad
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 9 Nov 2010 19:01:43 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 18 Nov 2010 13:18:46 +0100

perf: Fix owner-list vs exit

Oleg noticed that a perf-fd keeping a reference on the creating task
leads to a few funny side effects.

There's two different aspects to this:

  - kernel based perf-events, these should not take out
    a reference on the creating task and appear on the task's
    event list since they're not bound to fds nor visible
    to userspace.

  - fork() and pthread_create(), these can lead to the creating
    task dying (and thus the task's event-list becomming useless)
    but keeping the list and ref alive until the event is closed.

Combined they lead to malfunction of the ptrace hw_tracepoints.

Cure this by not considering kernel based perf_events for the
owner-list and destroying the owner-list when the owner dies.

Reported-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Oleg Nesterov <oleg@redhat.com>
LKML-Reference: <1289576883.2084.286.camel@laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |   63 +++++++++++++++++++++++++++++++++++++++++---------
 1 files changed, 51 insertions(+), 12 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index f818d9d..671f6c8 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -2235,11 +2235,6 @@ int perf_event_release_kernel(struct perf_event *event)
 	raw_spin_unlock_irq(&ctx->lock);
 	mutex_unlock(&ctx->mutex);
 
-	mutex_lock(&event->owner->perf_event_mutex);
-	list_del_init(&event->owner_entry);
-	mutex_unlock(&event->owner->perf_event_mutex);
-	put_task_struct(event->owner);
-
 	free_event(event);
 
 	return 0;
@@ -2252,9 +2247,43 @@ EXPORT_SYMBOL_GPL(perf_event_release_kernel);
 static int perf_release(struct inode *inode, struct file *file)
 {
 	struct perf_event *event = file->private_data;
+	struct task_struct *owner;
 
 	file->private_data = NULL;
 
+	rcu_read_lock();
+	owner = ACCESS_ONCE(event->owner);
+	/*
+	 * Matches the smp_wmb() in perf_event_exit_task(). If we observe
+	 * !owner it means the list deletion is complete and we can indeed
+	 * free this event, otherwise we need to serialize on
+	 * owner->perf_event_mutex.
+	 */
+	smp_read_barrier_depends();
+	if (owner) {
+		/*
+		 * Since delayed_put_task_struct() also drops the last
+		 * task reference we can safely take a new reference
+		 * while holding the rcu_read_lock().
+		 */
+		get_task_struct(owner);
+	}
+	rcu_read_unlock();
+
+	if (owner) {
+		mutex_lock(&owner->perf_event_mutex);
+		/*
+		 * We have to re-check the event->owner field, if it is cleared
+		 * we raced with perf_event_exit_task(), acquiring the mutex
+		 * ensured they're done, and we can proceed with freeing the
+		 * event.
+		 */
+		if (event->owner)
+			list_del_init(&event->owner_entry);
+		mutex_unlock(&owner->perf_event_mutex);
+		put_task_struct(owner);
+	}
+
 	return perf_event_release_kernel(event);
 }
 
@@ -5678,7 +5707,7 @@ SYSCALL_DEFINE5(perf_event_open,
 	mutex_unlock(&ctx->mutex);
 
 	event->owner = current;
-	get_task_struct(current);
+
 	mutex_lock(&current->perf_event_mutex);
 	list_add_tail(&event->owner_entry, &current->perf_event_list);
 	mutex_unlock(&current->perf_event_mutex);
@@ -5746,12 +5775,6 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
 	++ctx->generation;
 	mutex_unlock(&ctx->mutex);
 
-	event->owner = current;
-	get_task_struct(current);
-	mutex_lock(&current->perf_event_mutex);
-	list_add_tail(&event->owner_entry, &current->perf_event_list);
-	mutex_unlock(&current->perf_event_mutex);
-
 	return event;
 
 err_free:
@@ -5902,8 +5925,24 @@ again:
  */
 void perf_event_exit_task(struct task_struct *child)
 {
+	struct perf_event *event, *tmp;
 	int ctxn;
 
+	mutex_lock(&child->perf_event_mutex);
+	list_for_each_entry_safe(event, tmp, &child->perf_event_list,
+				 owner_entry) {
+		list_del_init(&event->owner_entry);
+
+		/*
+		 * Ensure the list deletion is visible before we clear
+		 * the owner, closes a race against perf_release() where
+		 * we need to serialize on the owner->perf_event_mutex.
+		 */
+		smp_wmb();
+		event->owner = NULL;
+	}
+	mutex_unlock(&child->perf_event_mutex);
+
 	for_each_task_context_nr(ctxn)
 		perf_event_exit_task_context(child, ctxn);
 }
