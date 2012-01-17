Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578Ab2AQIlX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 03:41:23 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45176 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481Ab2AQIlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 03:41:21 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.4.0
Date: Tue, 17 Jan 2012 17:40:31 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [BUG] TASK_DEAD task is able to be woken up in special condition
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>,
        Motohiro Kosaki <kosaki.motohiro@jp.fujitsu.com>,
        Linux Kernel ML <linux-kernel@vger.kernel.org>
In-Reply-To: <1326721082.2442.234.camel@twins>
References: <20120116205140.6120.E1E9C6FF@jp.fujitsu.com> <1326721082.2442.234.camel@twins>
Message-Id: <20120117174031.3118.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 2012-01-16 at 20:51 +0900, Yasunori Goto wrote:
> 
> > try_to_wake_up() has a problem which may change status from TASK_DEAD to
> > TASK_RUNNING in race condition with SMI or guest environment of virtual
> > machine. (See: https://lkml.org/lkml/2011/12/21/523)
> > As a result, exited task is scheduled() again and panic occurs.
> > 
> > By this patch, do_exit() waits for releasing task->pi_lock which is used
> > in try_to_wake_up(). It guarantees the task becomes TASK_DEAD after
> > waking up.
> 
> 
> This Changelog isn't very good. Please spell out the problem instead of
> referring to it so that people using git-blame and the like don't then
> have to go look up some (possibly non-existent) web-resource.

Ahh, Ok.

I rewrote the description and comment in patch.
Please check them.

-----
try_to_wake_up() has a problem which may change status from TASK_DEAD to
TASK_RUNNING in race condition with SMI or guest environment of virtual
machine. As a result, exited task is scheduled() again and panic occurs.

Here is the sequence how it occurs.

----------------------------------+-----------------------------
                                  |
           CPU A                  |             CPU B
----------------------------------+-----------------------------
TASK A calls exit()....

do_exit()

  exit_mm()
    down_read(mm->mmap_sem);
    
    rwsem_down_failed_common()

      set TASK_UNINTERRUPTIBLE
      set waiter.task <= task A
      list_add to sem->wait_list
           :
      raw_spin_unlock_irq()
      (I/O interruption occured)

                                      __rwsem_do_wake(mmap_sem)

                                        list_del(&waiter->list);
                                        waiter->task = NULL
                                        wake_up_process(task A)
                                          try_to_wake_up()
                                             (task is still
                                               TASK_UNINTERRUPTIBLE)
                                              p->on_rq is still 1.)

                                              ttwu_do_wakeup()
                                                 (*A)
                                                   :
     (I/O interruption handler finished)

      if (!waiter.task) 
          schedule() is not called
          due to waiter.task is NULL.
      
      tsk->state = TASK_RUNNING

          :
                                              check_preempt_curr();
                                                  :
  task->state = TASK_DEAD
                                              (*B)
                                        <---    set TASK_RUNNING (*C)



     schedule()
     (exit task is running again)
     BUG_ON() is called!
--------------------------------------------------------


The execution time between (*A) and (*B) is usually very short,
because the interruption is disabled, and setting TASK_RUNNING at (*C)
must be executed before setting TASK_DEAD.

HOWEVER, if SMI is interrupted between (*A) and (*B), 
(*C) is able to execute AFTER setting TASK_DEAD!
Then, exited task is scheduled again, and BUG_ON() is called....

If the system works on guest system of virtual machine, the time
between (*A) and (*B) may be also long due to scheduling of hypervisor,
and same phenomenon can occur.



By this patch, do_exit() waits for releasing task->pi_lock which is used
in try_to_wake_up(). It guarantees the task becomes TASK_DEAD after
waking up.


Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>

---
 kernel/exit.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

Index: linux-3.2/kernel/exit.c
===================================================================
--- linux-3.2.orig/kernel/exit.c
+++ linux-3.2/kernel/exit.c
@@ -1038,6 +1038,22 @@ NORET_TYPE void do_exit(long code)
 
 	preempt_disable();
 	exit_rcu();
+
+	/*
+	 * The setting of TASK_RUNNING by try_to_wake_up() may be delayed
+	 * when the following two conditions become true.
+	 *   - There is race condition of mmap_sem (It is acquired by
+	 *     exit_mm()), and
+	 *   - SMI occurs before setting TASK_RUNINNG.
+	 *     (or hypervisor of virtual machine switches to other guest)
+	 *  As a result, we may become TASK_RUNNING after becoming TASK_DEAD
+	 *
+	 * To avoid it, we have to wait for releasing tsk->pi_lock which
+	 * is held by try_to_wake_up()
+	 */
+	smp_mb();
+	raw_spin_unlock_wait(&tsk->pi_lock);
+
 	/* causes final put_task_struct in finish_task_switch(). */
 	tsk->state = TASK_DEAD;
 	schedule();
-----


-- 
Yasunori Goto 


