Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032837Ab2I1VIJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:08:09 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:37391 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423182Ab2I1VF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 17:05:57 -0400
X-Sasl-enc: foYuzAgz9zhQyvEmMRvoPXWhKW9pwowQDIkj/Q1cH1+H 1348866356
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Yasunori Goto <y-goto@jp.fujitsu.com>, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Michal Hocko <mhocko@suse.cz>
Subject: [ 125/127] sched: Fix ancient race in do_exit()
Date: Fri, 28 Sep 2012 13:34:58 -0700
Message-Id: <20120928203100.517080609@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928203045.835238916@linuxfoundation.org>
References: <20120928203045.835238916@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/exit.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1049,6 +1049,22 @@ NORET_TYPE void do_exit(long code)
 
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


