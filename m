Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659Ab1DRNsV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 09:48:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23595 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754616Ab1DRNsO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 09:48:14 -0400
Date: Mon, 18 Apr 2011 15:47:00 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 8/7] signal: cleanup sys_rt_sigprocmask()
Message-ID: <20110418134700.GI15951@redhat.com>
References: <20110418134421.GA15951@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110418134421.GA15951@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sys_rt_sigprocmask() looks unnecessarily complicated, simplify it.
We can just read current->blocked lockless unconditionally before
anything else and then copy-to-user it if needed.  At worst we
copy 4 words on mips.

We could copy-to-user the old mask first and simplify the code even
more, but the patch tries to keep the current behaviour: we change
current->block even if copy_to_user(oset) fails.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/signal.c |   40 +++++++++++++++++-----------------------
 1 file changed, 17 insertions(+), 23 deletions(-)

--- sigprocmask/kernel/signal.c~8_sys_sigprocmask	2011-04-17 22:32:58.000000000 +0200
+++ sigprocmask/kernel/signal.c	2011-04-18 14:45:57.000000000 +0200
@@ -2172,40 +2172,34 @@ int sigprocmask(int how, sigset_t *set, 
  *  @oset: previous value of signal mask if non-null
  *  @sigsetsize: size of sigset_t type
  */
-SYSCALL_DEFINE4(rt_sigprocmask, int, how, sigset_t __user *, set,
+SYSCALL_DEFINE4(rt_sigprocmask, int, how, sigset_t __user *, nset,
 		sigset_t __user *, oset, size_t, sigsetsize)
 {
-	int error = -EINVAL;
 	sigset_t old_set, new_set;
+	int error;
 
-	/* XXX: Don't preclude handling different sized sigset_t's.  */
+	/* Don't preclude handling different sized sigset_t's. */
 	if (sigsetsize != sizeof(sigset_t))
-		goto out;
+		return -EINVAL;
 
-	if (set) {
-		error = -EFAULT;
-		if (copy_from_user(&new_set, set, sizeof(*set)))
-			goto out;
+	old_set = current->blocked;
+
+	if (nset) {
+		if (copy_from_user(&new_set, nset, sizeof(sigset_t)))
+			return -EFAULT;
 		sigdelsetmask(&new_set, sigmask(SIGKILL)|sigmask(SIGSTOP));
 
-		error = sigprocmask(how, &new_set, &old_set);
+		error = sigprocmask(how, &new_set, NULL);
 		if (error)
-			goto out;
-		if (oset)
-			goto set_old;
-	} else if (oset) {
-		spin_lock_irq(&current->sighand->siglock);
-		old_set = current->blocked;
-		spin_unlock_irq(&current->sighand->siglock);
+			return error;
+	}
 
-	set_old:
-		error = -EFAULT;
-		if (copy_to_user(oset, &old_set, sizeof(*oset)))
-			goto out;
+	if (oset) {
+		if (copy_to_user(oset, &old_set, sizeof(sigset_t)))
+			return -EFAULT;
 	}
-	error = 0;
-out:
-	return error;
+
+	return 0;
 }
 
 long do_sigpending(void __user *set, unsigned long sigsetsize)

