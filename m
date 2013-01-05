Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881Ab3AESNo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 13:13:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51777 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755816Ab3AESNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 13:13:42 -0500
Date: Sat, 5 Jan 2013 19:13:29 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: CAI Qian <caiqian@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linda Wang <lwang@redhat.com>, Matt Zywusko <mzywusko@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] signals: set_current_blocked() can use
	__set_current_blocked()
Message-ID: <20130105181329.GC13076@redhat.com>
References: <688203485.8555438.1357377797739.JavaMail.root@redhat.com> <1757046472.8555813.1357378462241.JavaMail.root@redhat.com> <20130105181254.GA13076@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130105181254.GA13076@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup. And I think we need more cleanups, in particular
__set_current_blocked() and sigprocmask() should die. Nobody
should ever block SIGKILL or SIGSTOP.

- Change set_current_blocked() to use __set_current_blocked()

- Change sys_sigprocmask() to use set_current_blocked(), this
  way it should not worry about SIGKILL/SIGSTOP.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/signal.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 9692499..372771e 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2528,11 +2528,8 @@ static void __set_task_blocked(struct task_struct *tsk, const sigset_t *newset)
  */
 void set_current_blocked(sigset_t *newset)
 {
-	struct task_struct *tsk = current;
 	sigdelsetmask(newset, sigmask(SIGKILL) | sigmask(SIGSTOP));
-	spin_lock_irq(&tsk->sighand->siglock);
-	__set_task_blocked(tsk, newset);
-	spin_unlock_irq(&tsk->sighand->siglock);
+	__set_current_blocked(newset);
 }
 
 void __set_current_blocked(const sigset_t *newset)
@@ -3204,7 +3201,6 @@ SYSCALL_DEFINE3(sigprocmask, int, how, old_sigset_t __user *, nset,
 	if (nset) {
 		if (copy_from_user(&new_set, nset, sizeof(*nset)))
 			return -EFAULT;
-		new_set &= ~(sigmask(SIGKILL) | sigmask(SIGSTOP));
 
 		new_blocked = current->blocked;
 
@@ -3222,7 +3218,7 @@ SYSCALL_DEFINE3(sigprocmask, int, how, old_sigset_t __user *, nset,
 			return -EINVAL;
 		}
 
-		__set_current_blocked(&new_blocked);
+		set_current_blocked(&new_blocked);
 	}
 
 	if (oset) {
-- 
1.5.5.1


