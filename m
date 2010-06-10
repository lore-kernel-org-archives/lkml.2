Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759922Ab0FJXLj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 19:11:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27001 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759909Ab0FJXLg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 19:11:36 -0400
Date: Fri, 11 Jun 2010 01:09:52 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Stanislaw Gruszka <sgruszka@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] sched_stats: remove the obsolete exit_state/signal
	hacks
Message-ID: <20100610230952.GA25914@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

account_group_xxx() functions check ->exit_state to ensure that
current->signal is valid and can't go away. This is not needed
since ea6d290c, task->signal is pinned to task_struct.

The comment and another hack in account_group_exec_runtime() refers
to task_rq_unlock_wait() which was already removed by b7b8ff63.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/sched_stats.h |   27 +++------------------------
 1 file changed, 3 insertions(+), 24 deletions(-)

--- 35-rc2/kernel/sched_stats.h~3_STATS_DONT_CK_EXIT_CODE	2010-06-11 00:47:33.000000000 +0200
+++ 35-rc2/kernel/sched_stats.h	2010-06-11 01:07:37.000000000 +0200
@@ -295,13 +295,7 @@ sched_info_switch(struct task_struct *pr
 static inline void account_group_user_time(struct task_struct *tsk,
 					   cputime_t cputime)
 {
-	struct thread_group_cputimer *cputimer;
-
-	/* tsk == current, ensure it is safe to use ->signal */
-	if (unlikely(tsk->exit_state))
-		return;
-
-	cputimer = &tsk->signal->cputimer;
+	struct thread_group_cputimer *cputimer = &tsk->signal->cputimer;
 
 	if (!cputimer->running)
 		return;
@@ -325,13 +319,7 @@ static inline void account_group_user_ti
 static inline void account_group_system_time(struct task_struct *tsk,
 					     cputime_t cputime)
 {
-	struct thread_group_cputimer *cputimer;
-
-	/* tsk == current, ensure it is safe to use ->signal */
-	if (unlikely(tsk->exit_state))
-		return;
-
-	cputimer = &tsk->signal->cputimer;
+	struct thread_group_cputimer *cputimer = &tsk->signal->cputimer;
 
 	if (!cputimer->running)
 		return;
@@ -355,16 +343,7 @@ static inline void account_group_system_
 static inline void account_group_exec_runtime(struct task_struct *tsk,
 					      unsigned long long ns)
 {
-	struct thread_group_cputimer *cputimer;
-	struct signal_struct *sig;
-
-	sig = tsk->signal;
-	/* see __exit_signal()->task_rq_unlock_wait() */
-	barrier();
-	if (unlikely(!sig))
-		return;
-
-	cputimer = &sig->cputimer;
+	struct thread_group_cputimer *cputimer = &tsk->signal->cputimer;
 
 	if (!cputimer->running)
 		return;

