Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932678Ab2JRRJu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 13:09:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46837 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932120Ab2JRRJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 13:09:49 -0400
Date: Thu, 18 Oct 2012 10:09:30 -0700
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Message-ID: <tip-e99e955b90d7aaa4418cace9734e8069921ba440@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, riel@redhat.com, tglx@linutronix.de,
        oleg@redhat.com, mingo@elte.hu
Reply-To: riel@redhat.com, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, oleg@redhat.com,
        tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:numa/core] numa: Fix task_work() double add
Git-Commit-ID: e99e955b90d7aaa4418cace9734e8069921ba440
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 18 Oct 2012 10:09:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e99e955b90d7aaa4418cace9734e8069921ba440
Gitweb:     http://git.kernel.org/tip/e99e955b90d7aaa4418cace9734e8069921ba440
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Mon, 15 Oct 2012 07:46:28 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 18 Oct 2012 08:08:24 +0200

numa: Fix task_work() double add

task_work() must not be double added - it can result in an infinite
loop in run_task_work().

So separate out p->numa_work and signal an 'empty' work callback with
numa_work->next == &numa_work. (NULL cannot be used as the task work
code uses it.)

It would be handy if kerne/task_work.c had something like this in
run_task_work():

	if (WARN_ON_ONCE(work->next == work))
		break;

As it took some time to figure out why it was sporadically hanging.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rik van Riel <riel@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Link: http://lkml.kernel.org/n/tip-gT2keodfehhzwmx0appafeUy@git.kernel.org
---
 include/linux/sched.h |    1 +
 kernel/sched/core.c   |    1 +
 kernel/sched/fair.c   |   16 ++++++----------
 3 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index c86db44..7882686 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1529,6 +1529,7 @@ struct task_struct {
 	u64 node_stamp;			/* migration stamp  */
 	unsigned long numa_contrib;
 	unsigned long *numa_faults;
+	struct callback_head numa_work;
 #endif /* CONFIG_SCHED_NUMA */
 
 	struct rcu_head rcu;
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 23ad8b9..08661fe 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1546,6 +1546,7 @@ static void __sched_fork(struct task_struct *p)
 	p->numa_migrate_seq = p->mm ? p->mm->numa_scan_seq - 1 : 0;
 	p->numa_faults = NULL;
 	p->numa_task_period = sysctl_sched_numa_task_period_min;
+	p->numa_work.next = &p->numa_work;
 #endif /* CONFIG_SCHED_NUMA */
 }
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 530448c..1e24aa1 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -900,8 +900,9 @@ void task_numa_work(struct callback_head *work)
 	struct task_struct *p = current;
 	struct mm_struct *mm = p->mm;
 
-	WARN_ON_ONCE(p != container_of(work, struct task_struct, rcu));
+	WARN_ON_ONCE(p != container_of(work, struct task_struct, numa_work));
 
+	work->next = work; /* protect against double add */
 	/*
 	 * Who cares about NUMA placement when they're dying.
 	 *
@@ -933,12 +934,13 @@ void task_numa_work(struct callback_head *work)
  */
 void task_tick_numa(struct rq *rq, struct task_struct *curr)
 {
+	struct callback_head *work = &curr->numa_work;
 	u64 period, now;
 
 	/*
 	 * We don't care about NUMA placement if we don't have memory.
 	 */
-	if (!curr->mm)
+	if (!curr->mm || (curr->flags & PF_EXITING) || work->next != work)
 		return;
 
 	/*
@@ -954,14 +956,8 @@ void task_tick_numa(struct rq *rq, struct task_struct *curr)
 		curr->node_stamp = now;
 
 		if (!time_before(jiffies, curr->mm->numa_next_scan)) {
-			/*
-			 * We can re-use curr->rcu because we checked curr->mm
-			 * != NULL so release_task()->call_rcu() was not called
-			 * yet and exit_task_work() is called before
-			 * exit_notify().
-			 */
-			init_task_work(&curr->rcu, task_numa_work);
-			task_work_add(curr, &curr->rcu, true);
+			init_task_work(work, task_numa_work); /* TODO: move this into sched_fork() */
+			task_work_add(curr, work, true);
 		}
 	}
 }
