Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757076Ab1DZTuM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 15:50:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45402 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753747Ab1DZTuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 15:50:09 -0400
Date: Tue, 26 Apr 2011 21:48:45 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/6] signal: sys_rt_sigtimedwait: simplify the timeout
	logic
Message-ID: <20110426194845.GB8520@redhat.com>
References: <20110418134421.GA15951@redhat.com> <BANLkTimO2FL3548rxa9NEoVLFbZU7mzG7g@mail.gmail.com> <20110418173224.GA27918@redhat.com> <BANLkTikkYapz+qiJ0skx9ykz7TT9vmTVQw@mail.gmail.com> <20110423175901.GA484@redhat.com> <20110426194822.GA8520@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110426194822.GA8520@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional changes, cleanup compat_sys_rt_sigtimedwait() and
sys_rt_sigtimedwait().

Calculate the timeout before we take ->siglock, this simplifies and
lessens the code. Use timespec_valid() to check the timespec.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Matt Fleming <matt.fleming@linux.intel.com>
---

 kernel/signal.c |   46 ++++++++++++++++++++--------------------------
 kernel/compat.c |   38 ++++++++++++++++----------------------
 2 files changed, 36 insertions(+), 48 deletions(-)

--- sigprocmask/kernel/signal.c~1_sigtimedwait_to	2011-04-26 19:52:30.000000000 +0200
+++ sigprocmask/kernel/signal.c	2011-04-26 19:53:19.000000000 +0200
@@ -2327,7 +2327,7 @@ SYSCALL_DEFINE4(rt_sigtimedwait, const s
 	sigset_t these;
 	struct timespec ts;
 	siginfo_t info;
-	long timeout = 0;
+	long timeout;
 
 	/* XXX: Don't preclude handling different sized sigset_t's.  */
 	if (sigsetsize != sizeof(sigset_t))
@@ -2343,41 +2343,35 @@ SYSCALL_DEFINE4(rt_sigtimedwait, const s
 	sigdelsetmask(&these, sigmask(SIGKILL)|sigmask(SIGSTOP));
 	signotset(&these);
 
+	timeout = MAX_SCHEDULE_TIMEOUT;
 	if (uts) {
 		if (copy_from_user(&ts, uts, sizeof(ts)))
 			return -EFAULT;
-		if (ts.tv_nsec >= 1000000000L || ts.tv_nsec < 0
-		    || ts.tv_sec < 0)
+		if (!timespec_valid(&ts))
 			return -EINVAL;
+		timeout = timespec_to_jiffies(&ts) + (ts.tv_sec || ts.tv_nsec);
 	}
 
 	spin_lock_irq(&current->sighand->siglock);
 	sig = dequeue_signal(current, &these, &info);
-	if (!sig) {
-		timeout = MAX_SCHEDULE_TIMEOUT;
-		if (uts)
-			timeout = (timespec_to_jiffies(&ts)
-				   + (ts.tv_sec || ts.tv_nsec));
-
-		if (timeout) {
-			/*
-			 * None ready -- temporarily unblock those we're
-			 * interested while we are sleeping in so that we'll
-			 * be awakened when they arrive.
-			 */
-			current->real_blocked = current->blocked;
-			sigandsets(&current->blocked, &current->blocked, &these);
-			recalc_sigpending();
-			spin_unlock_irq(&current->sighand->siglock);
+	if (!sig && timeout) {
+		/*
+		 * None ready -- temporarily unblock those we're
+		 * interested while we are sleeping in so that we'll
+		 * be awakened when they arrive.
+		 */
+		current->real_blocked = current->blocked;
+		sigandsets(&current->blocked, &current->blocked, &these);
+		recalc_sigpending();
+		spin_unlock_irq(&current->sighand->siglock);
 
-			timeout = schedule_timeout_interruptible(timeout);
+		timeout = schedule_timeout_interruptible(timeout);
 
-			spin_lock_irq(&current->sighand->siglock);
-			sig = dequeue_signal(current, &these, &info);
-			current->blocked = current->real_blocked;
-			siginitset(&current->real_blocked, 0);
-			recalc_sigpending();
-		}
+		spin_lock_irq(&current->sighand->siglock);
+		sig = dequeue_signal(current, &these, &info);
+		current->blocked = current->real_blocked;
+		siginitset(&current->real_blocked, 0);
+		recalc_sigpending();
 	}
 	spin_unlock_irq(&current->sighand->siglock);
 
--- sigprocmask/kernel/compat.c~1_sigtimedwait_to	2011-04-26 19:52:30.000000000 +0200
+++ sigprocmask/kernel/compat.c	2011-04-26 19:53:19.000000000 +0200
@@ -893,7 +893,7 @@ compat_sys_rt_sigtimedwait (compat_sigse
 	int sig;
 	struct timespec t;
 	siginfo_t info;
-	long ret, timeout = 0;
+	long ret, timeout;
 
 	if (sigsetsize != sizeof(sigset_t))
 		return -EINVAL;
@@ -904,36 +904,30 @@ compat_sys_rt_sigtimedwait (compat_sigse
 	sigdelsetmask(&s,sigmask(SIGKILL)|sigmask(SIGSTOP));
 	signotset(&s);
 
+	timeout = MAX_SCHEDULE_TIMEOUT;
 	if (uts) {
 		if (get_compat_timespec (&t, uts))
 			return -EFAULT;
-		if (t.tv_nsec >= 1000000000L || t.tv_nsec < 0
-				|| t.tv_sec < 0)
+		if (!timespec_valid(&t))
 			return -EINVAL;
+		timeout = timespec_to_jiffies(&t) + (t.tv_sec || t.tv_nsec);
 	}
 
 	spin_lock_irq(&current->sighand->siglock);
 	sig = dequeue_signal(current, &s, &info);
-	if (!sig) {
-		timeout = MAX_SCHEDULE_TIMEOUT;
-		if (uts)
-			timeout = timespec_to_jiffies(&t)
-				+(t.tv_sec || t.tv_nsec);
-		if (timeout) {
-			current->real_blocked = current->blocked;
-			sigandsets(&current->blocked, &current->blocked, &s);
-
-			recalc_sigpending();
-			spin_unlock_irq(&current->sighand->siglock);
+	if (!sig && timeout) {
+		current->real_blocked = current->blocked;
+		sigandsets(&current->blocked, &current->blocked, &s);
+		recalc_sigpending();
+		spin_unlock_irq(&current->sighand->siglock);
 
-			timeout = schedule_timeout_interruptible(timeout);
+		timeout = schedule_timeout_interruptible(timeout);
 
-			spin_lock_irq(&current->sighand->siglock);
-			sig = dequeue_signal(current, &s, &info);
-			current->blocked = current->real_blocked;
-			siginitset(&current->real_blocked, 0);
-			recalc_sigpending();
-		}
+		spin_lock_irq(&current->sighand->siglock);
+		sig = dequeue_signal(current, &s, &info);
+		current->blocked = current->real_blocked;
+		siginitset(&current->real_blocked, 0);
+		recalc_sigpending();
 	}
 	spin_unlock_irq(&current->sighand->siglock);
 
@@ -943,7 +937,7 @@ compat_sys_rt_sigtimedwait (compat_sigse
 			if (copy_siginfo_to_user32(uinfo, &info))
 				ret = -EFAULT;
 		}
-	}else {
+	} else {
 		ret = timeout?-EINTR:-EAGAIN;
 	}
 	return ret;

