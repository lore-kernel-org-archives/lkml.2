Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725Ab0CQTaS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 15:30:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43962 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755658Ab0CQTaO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 15:30:14 -0400
Date: Wed, 17 Mar 2010 20:28:50 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, Veaceslav Falico <vfalico@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] exit: exit_notify() can trust signal->notify_count < 0
Message-ID: <20100317192850.GA2090@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that Veaceslav changed copy_signal() to use zalloc(), exit_notify()
can just check notify_count < 0 to ensure the execing sub-threads needs
the notification from us. No need to do other checks, notify_count != 0
must always mean ->group_exit_task != NULL is waiting for us.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/exit.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- 34-rc1/kernel/exit.c~1_EXIT_NOTIFY	2010-03-17 19:10:28.000000000 +0100
+++ 34-rc1/kernel/exit.c	2010-03-17 19:17:39.000000000 +0100
@@ -857,12 +857,9 @@ static void exit_notify(struct task_stru
 
 	tsk->exit_state = signal == DEATH_REAP ? EXIT_DEAD : EXIT_ZOMBIE;
 
-	/* mt-exec, de_thread() is waiting for us */
-	if (thread_group_leader(tsk) &&
-	    tsk->signal->group_exit_task &&
-	    tsk->signal->notify_count < 0)
+	/* mt-exec, de_thread() is waiting for group leader */
+	if (unlikely(tsk->signal->notify_count < 0))
 		wake_up_process(tsk->signal->group_exit_task);
-
 	write_unlock_irq(&tasklist_lock);
 
 	tracehook_report_death(tsk, signal, cookie, group_dead);

