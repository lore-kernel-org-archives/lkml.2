Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761369Ab1EAUJk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 16:09:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7813 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761356Ab1EAUJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 16:09:34 -0400
Date: Sun, 1 May 2011 22:08:02 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/1] signal: sys_sigprocmask() needs
	retarget_shared_pending()
Message-ID: <20110501200802.GB13831@redhat.com>
References: <20110418134421.GA15951@redhat.com> <BANLkTimO2FL3548rxa9NEoVLFbZU7mzG7g@mail.gmail.com> <20110418173224.GA27918@redhat.com> <BANLkTikkYapz+qiJ0skx9ykz7TT9vmTVQw@mail.gmail.com> <20110423175901.GA484@redhat.com> <20110426194822.GA8520@redhat.com> <20110426195002.GF8520@redhat.com> <BANLkTinp8FGQu2D1NVVc7xfEsqopook7Hg@mail.gmail.com> <20110501200738.GA13831@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110501200738.GA13831@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sys_sigprocmask() changes current->blocked by hand. Convert this code
to use set_current_blocked().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/signal.c |   22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

--- sigprocmask/kernel/signal.c~14_old_sigprocmask_retarget	2011-04-30 19:07:11.000000000 +0200
+++ sigprocmask/kernel/signal.c	2011-05-01 21:34:51.000000000 +0200
@@ -2900,7 +2900,7 @@ SYSCALL_DEFINE3(sigprocmask, int, how, o
 		old_sigset_t __user *, oset)
 {
 	old_sigset_t old_set, new_set;
-	int error;
+	sigset_t new_blocked;
 
 	old_set = current->blocked.sig[0];
 
@@ -2909,27 +2909,23 @@ SYSCALL_DEFINE3(sigprocmask, int, how, o
 			return -EFAULT;
 		new_set &= ~(sigmask(SIGKILL) | sigmask(SIGSTOP));
 
-		error = 0;
-		spin_lock_irq(&current->sighand->siglock);
+		new_blocked = current->blocked;
+
 		switch (how) {
-		default:
-			error = -EINVAL;
-			break;
 		case SIG_BLOCK:
-			sigaddsetmask(&current->blocked, new_set);
+			sigaddsetmask(&new_blocked, new_set);
 			break;
 		case SIG_UNBLOCK:
-			sigdelsetmask(&current->blocked, new_set);
+			sigdelsetmask(&new_blocked, new_set);
 			break;
 		case SIG_SETMASK:
-			current->blocked.sig[0] = new_set;
+			new_blocked.sig[0] = new_set;
 			break;
+		default:
+			return -EINVAL;
 		}
 
-		recalc_sigpending();
-		spin_unlock_irq(&current->sighand->siglock);
-		if (error)
-			return error;
+		set_current_blocked(&new_blocked);
 	}
 
 	if (oset) {

