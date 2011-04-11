Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405Ab1DKRWV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 13:22:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3859 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754226Ab1DKRWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 13:22:18 -0400
Date: Mon, 11 Apr 2011 19:21:37 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Matt Fleming <matt@console-pimps.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] signal: sigprocmask() should do
	retarget_shared_pending()
Message-ID: <20110411172137.GE32469@redhat.com>
References: <20110411171957.GA32469@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110411171957.GA32469@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In short, almost every changing of current->blocked is wrong, or at least
can lead to the unexpected results.

For example. Two threads T1 and T2, T1 sleeps in sigtimedwait/pause/etc.
kill(tgid, SIG) can pick T2 for TIF_SIGPENDING. If T2 calls sigprocmask()
and blocks SIG before it notices the pending signal, nobody else can handle
this pending shared signal.

I am not sure this is bug, but at least this looks strange imho. T1 should
not sleep forever, there is a signal which should wake it up.

This patch changes sigprocmask() to call retarget_shared_pending() as
exit_signals() does. To calculate the "blocked" argument we add the new
helper, signorsets(), although we could do ~(newset & ~current->blocked)
instead. According to grep, nobody in arch/ defines __HAVE_ARCH_SIG_SETOPS,
we only need to change linux/signal.h.

Note: for this particular case we could simply change sigprocmask() to
return -EINTR if signal_pending(), but then we should change other callers
and, more importantly, if we need this fix then sigprocmask() will have
more callers and some of them can't restart. See the next patch as a random
example.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 include/linux/signal.h |    3 +++
 kernel/signal.c        |    5 +++++
 2 files changed, 8 insertions(+)

--- sigprocmask/include/linux/signal.h~4_sigprocmask_retarget	2011-04-06 21:33:50.000000000 +0200
+++ sigprocmask/include/linux/signal.h	2011-04-11 18:16:51.000000000 +0200
@@ -126,10 +126,14 @@ _SIG_SET_BINOP(sigandsets, _sig_and)
 #define _sig_nand(x,y)	((x) & ~(y))
 _SIG_SET_BINOP(signandsets, _sig_nand)
 
+#define _sig_nor(x,y)	((x) | ~(y))
+_SIG_SET_BINOP(signorsets, _sig_nor)
+
 #undef _SIG_SET_BINOP
 #undef _sig_or
 #undef _sig_and
 #undef _sig_nand
+#undef _sig_nor
 
 #define _SIG_SET_OP(name, op)						\
 static inline void name(sigset_t *set)					\
--- sigprocmask/kernel/signal.c~4_sigprocmask_retarget	2011-04-10 21:57:42.000000000 +0200
+++ sigprocmask/kernel/signal.c	2011-04-11 18:02:22.000000000 +0200
@@ -2131,6 +2131,11 @@ int sigprocmask(int how, sigset_t *set, 
 	}
 
 	spin_lock_irq(&tsk->sighand->siglock);
+	if (signal_pending(tsk) && !thread_group_empty(tsk)) {
+		sigset_t not_newblocked;
+		signorsets(&not_newblocked, &current->blocked, &newset);
+		retarget_shared_pending(tsk, &not_newblocked);
+	}
 	tsk->blocked = newset;
 	recalc_sigpending();
 	spin_unlock_irq(&tsk->sighand->siglock);

