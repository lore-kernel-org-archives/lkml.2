Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760096Ab0FRKUi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 06:20:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:47036 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757902Ab0FRKUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 06:20:36 -0400
Date: Fri, 18 Jun 2010 10:20:08 GMT
From: tip-bot for Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, oleg@redhat.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, oleg@redhat.com,
       mingo@elte.hu
In-Reply-To: <20100610230952.GA25914@redhat.com>
References: <20100610230952.GA25914@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Remove the obsolete exit_state/signal hacks
Message-ID: <tip-48286d5088a3ba76de40a6b70221632a49cab7a1@git.kernel.org>
Git-Commit-ID: 48286d5088a3ba76de40a6b70221632a49cab7a1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 18 Jun 2010 10:20:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  48286d5088a3ba76de40a6b70221632a49cab7a1
Gitweb:     http://git.kernel.org/tip/48286d5088a3ba76de40a6b70221632a49cab7a1
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Fri, 11 Jun 2010 01:09:52 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 18 Jun 2010 10:46:56 +0200

sched: Remove the obsolete exit_state/signal hacks

account_group_xxx() functions check ->exit_state to ensure that
current->signal is valid and can't go away. This is not needed
since ea6d290c, task->signal is pinned to task_struct.

The comment and another hack in account_group_exec_runtime() refers
to task_rq_unlock_wait() which was already removed by b7b8ff63.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20100610230952.GA25914@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_stats.h |   27 +++------------------------
 1 files changed, 3 insertions(+), 24 deletions(-)

diff --git a/kernel/sched_stats.h b/kernel/sched_stats.h
index 32d2bd4..25c2f96 100644
--- a/kernel/sched_stats.h
+++ b/kernel/sched_stats.h
@@ -295,13 +295,7 @@ sched_info_switch(struct task_struct *prev, struct task_struct *next)
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
@@ -325,13 +319,7 @@ static inline void account_group_user_time(struct task_struct *tsk,
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
@@ -355,16 +343,7 @@ static inline void account_group_system_time(struct task_struct *tsk,
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
