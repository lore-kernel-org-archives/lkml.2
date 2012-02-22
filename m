Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab2BVQNZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 11:13:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51119 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209Ab2BVQNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 11:13:21 -0500
Date: Wed, 22 Feb 2012 08:12:19 -0800
From: tip-bot for Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Message-ID: <tip-de5bdff7a72acc281219be2b8edeeca1fd81c542@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, h-shimamoto@ct.jp.nec.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, h-shimamoto@ct.jp.nec.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4F3C9995.3010800@ct.jp.nec.com>
References: <4F3C9995.3010800@ct.jp.nec.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched:
  Make initial SCHED_RR timeslace DEF_TIMESLICE
Git-Commit-ID: de5bdff7a72acc281219be2b8edeeca1fd81c542
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 22 Feb 2012 08:12:47 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  de5bdff7a72acc281219be2b8edeeca1fd81c542
Gitweb:     http://git.kernel.org/tip/de5bdff7a72acc281219be2b8edeeca1fd81c542
Author:     Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
AuthorDate: Thu, 16 Feb 2012 14:52:21 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 22 Feb 2012 12:28:29 +0100

sched: Make initial SCHED_RR timeslace DEF_TIMESLICE

Current the initial SCHED_RR timeslice of init_task is HZ, which means
1s, and is not same as the default SCHED_RR timeslice DEF_TIMESLICE.

Change that initial timeslice to the DEF_TIMESLICE.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
[ s/DEF_TIMESLICE/RR_TIMESLICE/g ]
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/4F3C9995.3010800@ct.jp.nec.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/init_task.h |    2 +-
 include/linux/sched.h     |    6 ++++++
 kernel/sched/rt.c         |    4 ++--
 kernel/sched/sched.h      |    4 ----
 4 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 9c66b1a..f994d51 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -149,7 +149,7 @@ extern struct cred init_cred;
 	},								\
 	.rt		= {						\
 		.run_list	= LIST_HEAD_INIT(tsk.rt.run_list),	\
-		.time_slice	= HZ, 					\
+		.time_slice	= RR_TIMESLICE,				\
 		.nr_cpus_allowed = NR_CPUS,				\
 	},								\
 	.tasks		= LIST_HEAD_INIT(tsk.tasks),			\
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5dba2ad..eb5de46 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1234,6 +1234,12 @@ struct sched_rt_entity {
 #endif
 };
 
+/*
+ * default timeslice is 100 msecs (used only for SCHED_RR tasks).
+ * Timeslices get refilled after they expire.
+ */
+#define RR_TIMESLICE		(100 * HZ / 1000)
+
 struct rcu_node;
 
 enum perf_event_task_context {
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index f42ae7f..f70206c 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1972,7 +1972,7 @@ static void task_tick_rt(struct rq *rq, struct task_struct *p, int queued)
 	if (--p->rt.time_slice)
 		return;
 
-	p->rt.time_slice = DEF_TIMESLICE;
+	p->rt.time_slice = RR_TIMESLICE;
 
 	/*
 	 * Requeue to the end of queue if we are not the only element
@@ -2000,7 +2000,7 @@ static unsigned int get_rr_interval_rt(struct rq *rq, struct task_struct *task)
 	 * Time slice is 0 for SCHED_FIFO tasks
 	 */
 	if (task->policy == SCHED_RR)
-		return DEF_TIMESLICE;
+		return RR_TIMESLICE;
 	else
 		return 0;
 }
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 8a2c768..c0660a1 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -36,11 +36,7 @@ extern __read_mostly int scheduler_running;
 
 /*
  * These are the 'tuning knobs' of the scheduler:
- *
- * default timeslice is 100 msecs (used only for SCHED_RR tasks).
- * Timeslices get refilled after they expire.
  */
-#define DEF_TIMESLICE		(100 * HZ / 1000)
 
 /*
  * single value that denotes runtime == period, ie unlimited time.
