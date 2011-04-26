Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757637Ab1DZTv0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 15:51:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10284 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756725Ab1DZTvX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 15:51:23 -0400
Date: Tue, 26 Apr 2011 21:50:02 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/6] signal: sys_sigprocmask() needs
	retarget_shared_pending()
Message-ID: <20110426195002.GF8520@redhat.com>
References: <20110418134421.GA15951@redhat.com> <BANLkTimO2FL3548rxa9NEoVLFbZU7mzG7g@mail.gmail.com> <20110418173224.GA27918@redhat.com> <BANLkTikkYapz+qiJ0skx9ykz7TT9vmTVQw@mail.gmail.com> <20110423175901.GA484@redhat.com> <20110426194822.GA8520@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110426194822.GA8520@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sys_sigprocmask() changes current->blocked by hand. Convert this code to
use sigprocmask() which implies the necessary retarget_shared_pending().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/signal.c |   24 ++++++------------------
 1 file changed, 6 insertions(+), 18 deletions(-)

--- sigprocmask/kernel/signal.c~5_old_sigprocmask_retarget	2011-04-26 19:54:09.000000000 +0200
+++ sigprocmask/kernel/signal.c	2011-04-26 19:54:20.000000000 +0200
@@ -2702,6 +2702,7 @@ SYSCALL_DEFINE3(sigprocmask, int, how, o
 		old_sigset_t __user *, oset)
 {
 	old_sigset_t old_set, new_set;
+	sigset_t new_full_set;
 	int error;
 
 	old_set = current->blocked.sig[0];
@@ -2711,25 +2712,12 @@ SYSCALL_DEFINE3(sigprocmask, int, how, o
 			return -EFAULT;
 		new_set &= ~(sigmask(SIGKILL) | sigmask(SIGSTOP));
 
-		error = 0;
-		spin_lock_irq(&current->sighand->siglock);
-		switch (how) {
-		default:
-			error = -EINVAL;
-			break;
-		case SIG_BLOCK:
-			sigaddsetmask(&current->blocked, new_set);
-			break;
-		case SIG_UNBLOCK:
-			sigdelsetmask(&current->blocked, new_set);
-			break;
-		case SIG_SETMASK:
-			current->blocked.sig[0] = new_set;
-			break;
-		}
+		sigemptyset(&new_full_set);
+		if (how == SIG_SETMASK)
+			new_full_set = current->blocked;
+		new_full_set.sig[0] = new_set;
 
-		recalc_sigpending();
-		spin_unlock_irq(&current->sighand->siglock);
+		error = sigprocmask(how, &new_full_set, NULL);
 		if (error)
 			return error;
 	}

