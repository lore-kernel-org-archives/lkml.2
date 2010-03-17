Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755Ab0CQTaZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 15:30:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51892 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755744Ab0CQTaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 15:30:21 -0400
Date: Wed, 17 Mar 2010 20:28:57 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, Veaceslav Falico <vfalico@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] exit: avoid sig->count in de_thread/__exit_signal
	synchronization
Message-ID: <20100317192857.GA2105@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

de_thread() and __exit_signal() use signal_struct->count/notify_count
for synchronization. We can simplify the code and use ->notify_count
only. Instead of comparing these two counters, we can change de_thread()
to set ->notify_count = nr_of_sub_threads, then change __exit_signal()
to dec-and-test this counter and notify group_exit_task.

Note that __exit_signal() checks "notify_count > 0" just for symmetry
with exit_notify(), we could just check it is != 0.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 fs/exec.c     |   11 +++++------
 kernel/exit.c |    2 +-
 2 files changed, 6 insertions(+), 7 deletions(-)

--- 34-rc1/fs/exec.c~3_DE_THREAD_AND_EXIT_SIGNAL	2010-03-17 19:10:27.000000000 +0100
+++ 34-rc1/fs/exec.c	2010-03-17 19:37:18.000000000 +0100
@@ -763,7 +763,6 @@ static int de_thread(struct task_struct 
 	struct signal_struct *sig = tsk->signal;
 	struct sighand_struct *oldsighand = tsk->sighand;
 	spinlock_t *lock = &oldsighand->siglock;
-	int count;
 
 	if (thread_group_empty(tsk))
 		goto no_thread_group;
@@ -780,13 +779,13 @@ static int de_thread(struct task_struct 
 		spin_unlock_irq(lock);
 		return -EAGAIN;
 	}
+
 	sig->group_exit_task = tsk;
-	zap_other_threads(tsk);
+	sig->notify_count = zap_other_threads(tsk);
+	if (!thread_group_leader(tsk))
+		sig->notify_count--;
 
-	/* Account for the thread group leader hanging around: */
-	count = thread_group_leader(tsk) ? 1 : 2;
-	sig->notify_count = count;
-	while (atomic_read(&sig->count) > count) {
+	while (sig->notify_count) {
 		__set_current_state(TASK_UNINTERRUPTIBLE);
 		spin_unlock_irq(lock);
 		schedule();
--- 34-rc1/kernel/exit.c~3_DE_THREAD_AND_EXIT_SIGNAL	2010-03-17 19:17:39.000000000 +0100
+++ 34-rc1/kernel/exit.c	2010-03-17 19:37:18.000000000 +0100
@@ -98,7 +98,7 @@ static void __exit_signal(struct task_st
 		 * If there is any task waiting for the group exit
 		 * then notify it:
 		 */
-		if (sig->group_exit_task && atomic_read(&sig->count) == sig->notify_count)
+		if (sig->notify_count > 0 && !--sig->notify_count)
 			wake_up_process(sig->group_exit_task);
 
 		if (tsk == sig->curr_target)

