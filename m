Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452Ab1DZTum (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 15:50:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21719 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756003Ab1DZTuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 15:50:39 -0400
Date: Tue, 26 Apr 2011 21:49:43 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/6] signal: cleanup sys_sigprocmask()
Message-ID: <20110426194943.GE8520@redhat.com>
References: <20110418134421.GA15951@redhat.com> <BANLkTimO2FL3548rxa9NEoVLFbZU7mzG7g@mail.gmail.com> <20110418173224.GA27918@redhat.com> <BANLkTikkYapz+qiJ0skx9ykz7TT9vmTVQw@mail.gmail.com> <20110423175901.GA484@redhat.com> <20110426194822.GA8520@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110426194822.GA8520@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup. Remove the unneeded goto's, we can simply read blocked.sig[0]
unconditionally and then copy-to-user it if oset != NULL.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/signal.c |   37 ++++++++++++++++---------------------
 1 file changed, 16 insertions(+), 21 deletions(-)

--- sigprocmask/kernel/signal.c~4_cleanup_old_sigprocmask	2011-04-26 19:53:55.000000000 +0200
+++ sigprocmask/kernel/signal.c	2011-04-26 19:54:09.000000000 +0200
@@ -2691,29 +2691,28 @@ SYSCALL_DEFINE1(sigpending, old_sigset_t
 /**
  *  sys_sigprocmask - examine and change blocked signals
  *  @how: whether to add, remove, or set signals
- *  @set: signals to add or remove (if non-null)
+ *  @nset: signals to add or remove (if non-null)
  *  @oset: previous value of signal mask if non-null
  *
  * Some platforms have their own version with special arguments;
  * others support only sys_rt_sigprocmask.
  */
 
-SYSCALL_DEFINE3(sigprocmask, int, how, old_sigset_t __user *, set,
+SYSCALL_DEFINE3(sigprocmask, int, how, old_sigset_t __user *, nset,
 		old_sigset_t __user *, oset)
 {
-	int error;
 	old_sigset_t old_set, new_set;
+	int error;
 
-	if (set) {
-		error = -EFAULT;
-		if (copy_from_user(&new_set, set, sizeof(*set)))
-			goto out;
-		new_set &= ~(sigmask(SIGKILL) | sigmask(SIGSTOP));
+	old_set = current->blocked.sig[0];
 
-		spin_lock_irq(&current->sighand->siglock);
-		old_set = current->blocked.sig[0];
+	if (nset) {
+		if (copy_from_user(&new_set, nset, sizeof(*nset)))
+			return -EFAULT;
+		new_set &= ~(sigmask(SIGKILL) | sigmask(SIGSTOP));
 
 		error = 0;
+		spin_lock_irq(&current->sighand->siglock);
 		switch (how) {
 		default:
 			error = -EINVAL;
@@ -2732,19 +2731,15 @@ SYSCALL_DEFINE3(sigprocmask, int, how, o
 		recalc_sigpending();
 		spin_unlock_irq(&current->sighand->siglock);
 		if (error)
-			goto out;
-		if (oset)
-			goto set_old;
-	} else if (oset) {
-		old_set = current->blocked.sig[0];
-	set_old:
-		error = -EFAULT;
+			return error;
+	}
+
+	if (oset) {
 		if (copy_to_user(oset, &old_set, sizeof(*oset)))
-			goto out;
+			return -EFAULT;
 	}
-	error = 0;
-out:
-	return error;
+
+	return 0;
 }
 #endif /* __ARCH_WANT_SYS_SIGPROCMASK */
 

