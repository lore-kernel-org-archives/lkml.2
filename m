Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668Ab1IMNhP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 09:37:15 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44003 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667Ab1IMNhO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 09:37:14 -0400
Subject: Re: [ANNOUNCE] 3.0.4-rt13
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Date: Tue, 13 Sep 2011 15:36:49 +0200
In-Reply-To: <1315839187.6758.8.camel@marge.simson.net>
References: <alpine.LFD.2.02.1109101052340.2723@ionos>
	 <1315737307.6544.1.camel@marge.simson.net>
	 <1315817948.26517.16.camel@twins>
	 <1315835562.6758.3.camel@marge.simson.net>
	 <1315839187.6758.8.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1315921009.5977.6.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-09-12 at 16:53 +0200, Mike Galbraith wrote:
> On Mon, 2011-09-12 at 15:52 +0200, Mike Galbraith wrote:
> 
> > 36717            <...>-6266  [002]   242.543129: sys_semop <-system_call_fastpath
> > 36718            <...>-6266  [002]   242.543129: sys_semtimedop <-sys_semop
> > 36719            <...>-6266  [002]   242.543131: ipc_lock_check <-sys_semtimedop
> > 36720            <...>-6266  [002]   242.543131: ipc_lock <-ipc_lock_check
> > 36721            <...>-6266  [002]   242.543132: __rcu_read_lock <-ipc_lock
> > 36722            <...>-6266  [002]   242.543133: migrate_disable <-ipc_lock
> > 36723            <...>-6266  [002]   242.543134: migrate_disable: migrate_disable: in_atomic:0 p->migrate_disable_atomic:0 p->migrate_disable:0
> > 36724            <...>-6266  [002]   242.543134: pin_current_cpu <-migrate_disable
> > 36725            <...>-6266  [002]   242.543134: _raw_spin_lock_irqsave <-migrate_disable
> > 36726            <...>-6266  [002]   242.543135: _raw_spin_unlock_irqrestore <-migrate_disable
> > 36727            <...>-6266  [002]   242.543135: rt_spin_lock <-ipc_lock
> > 36728            <...>-6266  [002]   242.543136: ipcperms <-sys_semtimedop
> > 36729            <...>-6266  [002]   242.543137: ns_capable <-ipcperms
> > 36730            <...>-6266  [002]   242.543138: cap_capable <-ns_capable
> > 36731            <...>-6266  [002]   242.543138: pid_vnr <-sys_semtimedop
> > 36732            <...>-6266  [002]   242.543139: try_atomic_semop <-sys_semtimedop
> > 36733            <...>-6266  [002]   242.543140: do_smart_update <-sys_semtimedop
> > 36734            <...>-6266  [002]   242.543140: update_queue <-do_smart_update
> > 36735            <...>-6266  [002]   242.543141: try_atomic_semop <-update_queue
> > 36736            <...>-6266  [002]   242.543142: update_queue <-do_smart_update
> > 36737            <...>-6266  [002]   242.543142: try_atomic_semop <-update_queue
> > 36738            <...>-6266  [002]   242.543143: update_queue <-do_smart_update
> > 36739            <...>-6266  [002]   242.543143: try_atomic_semop <-update_queue
> > 36740            <...>-6266  [002]   242.543144: get_seconds <-do_smart_update
> > 36741            <...>-6266  [002]   242.543144: rt_spin_unlock <-sys_semtimedop
> > 36742            <...>-6266  [002]   242.543144: migrate_enable <-sys_semtimedop
> > 36743            <...>-6266  [002]   242.543145: migrate_enable: migrate_enable: in_atomic:1 p->migrate_disable_atomic:0 p->migrate_disable:1
> 
> Hm.  Seems this is home grown a non-preemptive wakeup in the making.

Does the below cure things? It breaks !rt builds, but we can cure that if it works..

---
 include/linux/sem.h |    2 ++
 ipc/sem.c           |   20 ++++----------------
 2 files changed, 6 insertions(+), 16 deletions(-)

Index: linux-rt/include/linux/sem.h
===================================================================
--- linux-rt.orig/include/linux/sem.h
+++ linux-rt/include/linux/sem.h
@@ -80,6 +80,7 @@ struct  seminfo {
 #include <asm/atomic.h>
 #include <linux/rcupdate.h>
 #include <linux/cache.h>
+#include <linux/wait.h>
 
 struct task_struct;
 
@@ -114,6 +115,7 @@ struct sem_queue {
 	struct sembuf		*sops;	 /* array of pending operations */
 	int			nsops;	 /* number of operations */
 	int			alter;   /* does the operation alter the array? */
+	wait_queue_head_t	wait;
 };
 
 /* Each task has a list of undo requests. They are executed automatically
Index: linux-rt/ipc/sem.c
===================================================================
--- linux-rt.orig/ipc/sem.c
+++ linux-rt/ipc/sem.c
@@ -415,13 +415,6 @@ static int try_atomic_semop (struct sem_
 static void wake_up_sem_queue_prepare(struct list_head *pt,
 				struct sem_queue *q, int error)
 {
-	if (list_empty(pt)) {
-		/*
-		 * Hold preempt off so that we don't get preempted and have the
-		 * wakee busy-wait until we're scheduled back on.
-		 */
-		preempt_disable();
-	}
 	q->status = IN_WAKEUP;
 	q->pid = error;
 
@@ -450,7 +443,7 @@ static void wake_up_sem_queue_do(struct
 		q->status = q->pid;
 	}
 	if (did_something)
-		preempt_enable();
+		wake_up_all(&q->wait);
 }
 
 static void unlink_queue(struct sem_array *sma, struct sem_queue *q)
@@ -1275,15 +1268,9 @@ static struct sem_undo *find_alloc_undo(
  */
 static int get_queue_result(struct sem_queue *q)
 {
-	int error;
-
-	error = q->status;
-	while (unlikely(error == IN_WAKEUP)) {
-		cpu_relax();
-		error = q->status;
-	}
+	wait_event(q->wait, ACCESS_ONCE(q->status) != IN_WAKEUP);
 
-	return error;
+	return q->status;
 }
 
 
@@ -1432,6 +1419,7 @@ SYSCALL_DEFINE4(semtimedop, int, semid,
 
 	queue.status = -EINTR;
 	queue.sleeper = current;
+	init_waitqueue_head(&queue.wait);
 	current->state = TASK_INTERRUPTIBLE;
 	sem_unlock(sma);
 

