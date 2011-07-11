Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758039Ab1GKQDr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 12:03:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9888 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757969Ab1GKQDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 12:03:45 -0400
Date: Mon, 11 Jul 2011 18:01:02 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Matt Fleming <matt.fleming@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] signals: sys_ssetmask/sys_rt_sigsuspend should use
	set_current_blocked()
Message-ID: <20110711160102.GA14797@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sys_ssetmask(), sys_rt_sigsuspend() and compat_sys_rt_sigsuspend()
change ->blocked directly. This is not correct, see the changelog in
e6fa16ab "signal: sigprocmask() should do retarget_shared_pending()"

Change them to use set_current_blocked().

Another change is that now we are doing ->saved_sigmask = ->blocked
lockless, it doesn't make any sense to do this under ->siglock.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/signal.c |   17 +++++------------
 kernel/compat.c |    5 +----
 2 files changed, 6 insertions(+), 16 deletions(-)

--- ptrace/kernel/signal.c~4_sigsuspend	2011-07-10 16:19:27.000000000 +0200
+++ ptrace/kernel/signal.c	2011-07-11 17:27:48.000000000 +0200
@@ -2986,15 +2986,11 @@ SYSCALL_DEFINE0(sgetmask)
 
 SYSCALL_DEFINE1(ssetmask, int, newmask)
 {
-	int old;
-
-	spin_lock_irq(&current->sighand->siglock);
-	old = current->blocked.sig[0];
+	int old = current->blocked.sig[0];
+	sigset_t newset;
 
-	siginitset(&current->blocked, newmask & ~(sigmask(SIGKILL)|
-						  sigmask(SIGSTOP)));
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	siginitset(&newset, newmask & ~(sigmask(SIGKILL) | sigmask(SIGSTOP)));
+	set_current_blocked(&newset);
 
 	return old;
 }
@@ -3051,11 +3047,8 @@ SYSCALL_DEFINE2(rt_sigsuspend, sigset_t 
 		return -EFAULT;
 	sigdelsetmask(&newset, sigmask(SIGKILL)|sigmask(SIGSTOP));
 
-	spin_lock_irq(&current->sighand->siglock);
 	current->saved_sigmask = current->blocked;
-	current->blocked = newset;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&newset);
 
 	current->state = TASK_INTERRUPTIBLE;
 	schedule();
--- ptrace/kernel/compat.c~4_sigsuspend	2011-05-26 14:48:21.000000000 +0200
+++ ptrace/kernel/compat.c	2011-07-11 17:53:57.000000000 +0200
@@ -991,11 +991,8 @@ asmlinkage long compat_sys_rt_sigsuspend
 	sigset_from_compat(&newset, &newset32);
 	sigdelsetmask(&newset, sigmask(SIGKILL)|sigmask(SIGSTOP));
 
-	spin_lock_irq(&current->sighand->siglock);
 	current->saved_sigmask = current->blocked;
-	current->blocked = newset;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&newset);
 
 	current->state = TASK_INTERRUPTIBLE;
 	schedule();

