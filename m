Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216Ab2JGXrv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:47:51 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38146 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752715Ab2JGXV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:21:56 -0400
Message-Id: <20121007225836.524377798@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 07 Oct 2012 23:58:47 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Yasunori Goto <y-goto@jp.fujitsu.com>, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: [ 013/108] sched: Fix ancient race in do_exit()
In-Reply-To: <20121007225834.673681075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yasunori Goto <y-goto@jp.fujitsu.com>

commit b5740f4b2cb3503b436925eb2242bc3d75cd3dfe upstream.

try_to_wake_up() has a problem which may change status from TASK_DEAD to
TASK_RUNNING in race condition with SMI or guest environment of virtual
machine. As a result, exited task is scheduled() again and panic occurs.

Here is the sequence how it occurs:

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
Acked-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/20120117174031.3118.E1E9C6FF@jp.fujitsu.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/exit.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1019,6 +1019,22 @@ NORET_TYPE void do_exit(long code)
 
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


