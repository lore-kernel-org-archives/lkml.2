Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635Ab1CBRry (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 12:47:54 -0500
Received: from casper.infradead.org ([85.118.1.10]:45909 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756534Ab1CBRqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 12:46:43 -0500
Message-Id: <20110302174121.858324339@chello.nl>
User-Agent: quilt/0.48-1
Date: Wed, 02 Mar 2011 18:38:53 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 22/22] sched: Remove TASK_WAKING
References: <20110302173831.295031866@chello.nl>
Content-Disposition: inline; filename=sched-remove-TASK_WAKING.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the new locking TASK_WAKING has become obsolete, remove it.

Suggested-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
---
 fs/proc/array.c       |    1 -
 include/linux/sched.h |    5 ++---
 kernel/sched.c        |    4 ++--
 3 files changed, 4 insertions(+), 6 deletions(-)

Index: linux-2.6/fs/proc/array.c
===================================================================
--- linux-2.6.orig/fs/proc/array.c
+++ linux-2.6/fs/proc/array.c
@@ -141,7 +141,6 @@ static const char *task_state_array[] = 
 	"X (dead)",		/*  32 */
 	"x (dead)",		/*  64 */
 	"K (wakekill)",		/* 128 */
-	"W (waking)",		/* 256 */
 };
 
 static inline const char *get_task_state(struct task_struct *tsk)
Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -189,10 +189,9 @@ print_cfs_rq(struct seq_file *m, int cpu
 /* in tsk->state again */
 #define TASK_DEAD		64
 #define TASK_WAKEKILL		128
-#define TASK_WAKING		256
-#define TASK_STATE_MAX		512
+#define TASK_STATE_MAX		256
 
-#define TASK_STATE_TO_CHAR_STR "RSDTtZXxKW"
+#define TASK_STATE_TO_CHAR_STR "RSDTtZXxK"
 
 extern char ___assert_task_state[1 - 2*!!(
 		sizeof(TASK_STATE_TO_CHAR_STR)-1 != ilog2(TASK_STATE_MAX)+1)];
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -2175,7 +2175,7 @@ void set_task_cpu(struct task_struct *p,
 	 * We should never call set_task_cpu() on a blocked task,
 	 * ttwu() will sort out the placement.
 	 */
-	WARN_ON_ONCE(p->state != TASK_RUNNING && p->state != TASK_WAKING &&
+	WARN_ON_ONCE(p->state != TASK_RUNNING &&
 			!(task_thread_info(p)->preempt_count & PREEMPT_ACTIVE));
 
 #ifdef CONFIG_LOCKDEP
@@ -2613,7 +2613,7 @@ try_to_wake_up(struct task_struct *p, un
 	smp_rmb();
 
 	p->sched_contributes_to_load = !!task_contributes_to_load(p);
-	p->state = TASK_WAKING;
+	p->state = TASK_RUNNING;
 
 	if (p->sched_class->task_waking)
 		p->sched_class->task_waking(p);


