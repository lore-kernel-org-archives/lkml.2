Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469Ab1DWSAv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 14:00:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752607Ab1DWSAt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 14:00:49 -0400
Date: Sat, 23 Apr 2011 20:00:00 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] signal: do_sigtimedwait() needs
	retarget_shared_pending()
Message-ID: <20110423180000.GD484@redhat.com>
References: <20110418134421.GA15951@redhat.com> <BANLkTimO2FL3548rxa9NEoVLFbZU7mzG7g@mail.gmail.com> <20110418173224.GA27918@redhat.com> <BANLkTikkYapz+qiJ0skx9ykz7TT9vmTVQw@mail.gmail.com> <20110423175901.GA484@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110423175901.GA484@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_sigtimedwait() changes current->blocked and thus it needs
set_current_bloked()->retarget_shared_pending().

We could use set_current_bloked() directly. It is fine to change
->real_blocked from all-zeroes to ->blocked and vice versa lockless,
but this is not immediately clear, looks racy, and needs a huge
comment to explain why this is correct.

To keep the things simple this patch adds the new static helper,
__set_task_blocked() which should be called with ->siglock held. This
way we can change both ->real_blocked and ->blocked atomically under
->siglock as the current code does. This is more understandable.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/signal.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

--- sigprocmask/kernel/signal.c~3_sigtimedwait_retarget	2011-04-22 20:57:06.000000000 +0200
+++ sigprocmask/kernel/signal.c	2011-04-22 21:49:11.000000000 +0200
@@ -2115,11 +2115,8 @@ long do_no_restart_syscall(struct restar
 	return -EINTR;
 }
 
-void set_current_blocked(const sigset_t *newset)
+static void __set_task_blocked(struct task_struct *tsk, const sigset_t *newset)
 {
-	struct task_struct *tsk = current;
-
-	spin_lock_irq(&tsk->sighand->siglock);
 	if (signal_pending(tsk) && !thread_group_empty(tsk)) {
 		sigset_t newblocked;
 		signandsets(&newblocked, newset, &current->blocked);
@@ -2127,6 +2124,14 @@ void set_current_blocked(const sigset_t 
 	}
 	tsk->blocked = *newset;
 	recalc_sigpending();
+}
+
+void set_current_blocked(const sigset_t *newset)
+{
+	struct task_struct *tsk = current;
+
+	spin_lock_irq(&tsk->sighand->siglock);
+	__set_task_blocked(tsk, newset);
 	spin_unlock_irq(&tsk->sighand->siglock);
 }
 
@@ -2322,7 +2327,8 @@ int do_sigtimedwait(sigset_t *these, sig
 		/*
 		 * None ready -- temporarily unblock those we're
 		 * interested while we are sleeping in so that we'll
-		 * be awakened when they arrive.
+		 * be awakened when they arrive. Unblocking is always
+		 * fine, we can avoid set_current_blocked().
 		 */
 		tsk->real_blocked = tsk->blocked;
 		sigandsets(&tsk->blocked, &tsk->blocked, these);
@@ -2332,10 +2338,9 @@ int do_sigtimedwait(sigset_t *these, sig
 		timeout = schedule_timeout_interruptible(timeout);
 
 		spin_lock_irq(&tsk->sighand->siglock);
-		sig = dequeue_signal(tsk, these, info);
-		tsk->blocked = tsk->real_blocked;
+		__set_task_blocked(tsk, &tsk->real_blocked);
 		siginitset(&tsk->real_blocked, 0);
-		recalc_sigpending();
+		sig = dequeue_signal(tsk, these, info);
 	}
 	spin_unlock_irq(&tsk->sighand->siglock);
 

