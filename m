Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741Ab2A1MET (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 07:04:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56459 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406Ab2A1MER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 07:04:17 -0500
Date: Sat, 28 Jan 2012 04:03:44 -0800
From: tip-bot for Yasunori Goto <y-goto@jp.fujitsu.com>
Message-ID: <tip-b5740f4b2cb3503b436925eb2242bc3d75cd3dfe@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        y-goto@jp.fujitsu.com, akpm@linux-foundation.org, tglx@linutronix.de,
        oleg@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        y-goto@jp.fujitsu.com, akpm@linux-foundation.org, tglx@linutronix.de,
        oleg@redhat.com, mingo@elte.hu
In-Reply-To: <20120117174031.3118.E1E9C6FF@jp.fujitsu.com>
References: <20120117174031.3118.E1E9C6FF@jp.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix ancient race in do_exit()
Git-Commit-ID: b5740f4b2cb3503b436925eb2242bc3d75cd3dfe
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 28 Jan 2012 04:03:51 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b5740f4b2cb3503b436925eb2242bc3d75cd3dfe
Gitweb:     http://git.kernel.org/tip/b5740f4b2cb3503b436925eb2242bc3d75cd3dfe
Author:     Yasunori Goto <y-goto@jp.fujitsu.com>
AuthorDate: Tue, 17 Jan 2012 17:40:31 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 27 Jan 2012 11:55:36 +0100

sched: Fix ancient race in do_exit()

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
---
 kernel/exit.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 294b170..4b4042f 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1038,6 +1038,22 @@ void do_exit(long code)
 	if (tsk->nr_dirtied)
 		__this_cpu_add(dirty_throttle_leaks, tsk->nr_dirtied);
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
 	tsk->flags |= PF_NOFREEZE;	/* tell freezer to ignore us */
