Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763Ab1DWSAc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 14:00:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40236 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754399Ab1DWSAa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 14:00:30 -0400
Date: Sat, 23 Apr 2011 19:59:40 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] signal: introduce do_sigtimedwait() to factor out
	compat/native code
Message-ID: <20110423175940.GC484@redhat.com>
References: <20110418134421.GA15951@redhat.com> <BANLkTimO2FL3548rxa9NEoVLFbZU7mzG7g@mail.gmail.com> <20110418173224.GA27918@redhat.com> <BANLkTikkYapz+qiJ0skx9ykz7TT9vmTVQw@mail.gmail.com> <20110423175901.GA484@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110423175901.GA484@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor out the common code in sys_rt_sigtimedwait/compat_sys_rt_sigtimedwait
to the new helper, do_sigtimedwait().

Perhaps it would be better to move compat_sys_rt_sigtimedwait() into
signal.c under CONFIG_COMPAT, then we can make do_sigtimedwait() static.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 include/linux/signal.h |    1 
 kernel/signal.c        |   71 ++++++++++++++++++++++++++-----------------------
 kernel/compat.c        |   29 ++------------------
 3 files changed, 43 insertions(+), 58 deletions(-)

--- sigprocmask/include/linux/signal.h~2_do_sigtimedwait	2011-04-22 15:48:33.000000000 +0200
+++ sigprocmask/include/linux/signal.h	2011-04-22 21:05:48.000000000 +0200
@@ -242,6 +242,7 @@ extern int __group_send_sig_info(int, st
 extern long do_rt_tgsigqueueinfo(pid_t tgid, pid_t pid, int sig,
 				 siginfo_t *info);
 extern long do_sigpending(void __user *, unsigned long);
+extern int do_sigtimedwait(sigset_t *, siginfo_t *, long);
 extern int sigprocmask(int, sigset_t *, sigset_t *);
 extern void set_current_blocked(const sigset_t *);
 extern int show_unhandled_signals;
--- sigprocmask/kernel/signal.c~2_do_sigtimedwait	2011-04-22 19:05:51.000000000 +0200
+++ sigprocmask/kernel/signal.c	2011-04-22 20:57:06.000000000 +0200
@@ -2311,6 +2311,39 @@ int copy_siginfo_to_user(siginfo_t __use
 
 #endif
 
+int do_sigtimedwait(sigset_t *these, siginfo_t *info, long timeout)
+{
+	struct task_struct *tsk = current;
+	int sig;
+
+	spin_lock_irq(&tsk->sighand->siglock);
+	sig = dequeue_signal(tsk, these, info);
+	if (!sig && timeout) {
+		/*
+		 * None ready -- temporarily unblock those we're
+		 * interested while we are sleeping in so that we'll
+		 * be awakened when they arrive.
+		 */
+		tsk->real_blocked = tsk->blocked;
+		sigandsets(&tsk->blocked, &tsk->blocked, these);
+		recalc_sigpending();
+		spin_unlock_irq(&tsk->sighand->siglock);
+
+		timeout = schedule_timeout_interruptible(timeout);
+
+		spin_lock_irq(&tsk->sighand->siglock);
+		sig = dequeue_signal(tsk, these, info);
+		tsk->blocked = tsk->real_blocked;
+		siginitset(&tsk->real_blocked, 0);
+		recalc_sigpending();
+	}
+	spin_unlock_irq(&tsk->sighand->siglock);
+
+	if (sig)
+		return sig;
+	return timeout ? -EINTR : -EAGAIN;
+}
+
 /**
  *  sys_rt_sigtimedwait - synchronously wait for queued signals specified
  *			in @uthese
@@ -2323,11 +2356,11 @@ SYSCALL_DEFINE4(rt_sigtimedwait, const s
 		siginfo_t __user *, uinfo, const struct timespec __user *, uts,
 		size_t, sigsetsize)
 {
-	int ret, sig;
 	sigset_t these;
 	struct timespec ts;
 	siginfo_t info;
 	long timeout;
+	int ret;
 
 	/* XXX: Don't preclude handling different sized sigset_t's.  */
 	if (sigsetsize != sizeof(sigset_t))
@@ -2352,39 +2385,11 @@ SYSCALL_DEFINE4(rt_sigtimedwait, const s
 		timeout = timespec_to_jiffies(&ts) + (ts.tv_sec || ts.tv_nsec);
 	}
 
-	spin_lock_irq(&current->sighand->siglock);
-	sig = dequeue_signal(current, &these, &info);
-	if (!sig && timeout) {
-		/*
-		 * None ready -- temporarily unblock those we're
-		 * interested while we are sleeping in so that we'll
-		 * be awakened when they arrive.
-		 */
-		current->real_blocked = current->blocked;
-		sigandsets(&current->blocked, &current->blocked, &these);
-		recalc_sigpending();
-		spin_unlock_irq(&current->sighand->siglock);
-
-		timeout = schedule_timeout_interruptible(timeout);
-
-		spin_lock_irq(&current->sighand->siglock);
-		sig = dequeue_signal(current, &these, &info);
-		current->blocked = current->real_blocked;
-		siginitset(&current->real_blocked, 0);
-		recalc_sigpending();
-	}
-	spin_unlock_irq(&current->sighand->siglock);
+	ret = do_sigtimedwait(&these, &info, timeout);
 
-	if (sig) {
-		ret = sig;
-		if (uinfo) {
-			if (copy_siginfo_to_user(uinfo, &info))
-				ret = -EFAULT;
-		}
-	} else {
-		ret = -EAGAIN;
-		if (timeout)
-			ret = -EINTR;
+	if (ret > 0 && uinfo) {
+		if (copy_siginfo_to_user(uinfo, &info))
+			ret = -EFAULT;
 	}
 
 	return ret;
--- sigprocmask/kernel/compat.c~2_do_sigtimedwait	2011-04-22 19:19:39.000000000 +0200
+++ sigprocmask/kernel/compat.c	2011-04-22 21:20:33.000000000 +0200
@@ -890,7 +890,6 @@ compat_sys_rt_sigtimedwait (compat_sigse
 {
 	compat_sigset_t s32;
 	sigset_t s;
-	int sig;
 	struct timespec t;
 	siginfo_t info;
 	long ret, timeout;
@@ -913,33 +912,13 @@ compat_sys_rt_sigtimedwait (compat_sigse
 		timeout = timespec_to_jiffies(&t) + (t.tv_sec || t.tv_nsec);
 	}
 
-	spin_lock_irq(&current->sighand->siglock);
-	sig = dequeue_signal(current, &s, &info);
-	if (!sig && timeout) {
-		current->real_blocked = current->blocked;
-		sigandsets(&current->blocked, &current->blocked, &s);
-		recalc_sigpending();
-		spin_unlock_irq(&current->sighand->siglock);
-
-		timeout = schedule_timeout_interruptible(timeout);
+	ret = do_sigtimedwait(&s, &info, timeout);
 
-		spin_lock_irq(&current->sighand->siglock);
-		sig = dequeue_signal(current, &s, &info);
-		current->blocked = current->real_blocked;
-		siginitset(&current->real_blocked, 0);
-		recalc_sigpending();
+	if (ret > 0 && uinfo) {
+		if (copy_siginfo_to_user32(uinfo, &info))
+			ret = -EFAULT;
 	}
-	spin_unlock_irq(&current->sighand->siglock);
 
-	if (sig) {
-		ret = sig;
-		if (uinfo) {
-			if (copy_siginfo_to_user32(uinfo, &info))
-				ret = -EFAULT;
-		}
-	} else {
-		ret = timeout?-EINTR:-EAGAIN;
-	}
 	return ret;
 
 }

