Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757281Ab2BHQHK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 11:07:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60128 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757193Ab2BHQHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 11:07:08 -0500
Date: Wed, 8 Feb 2012 16:59:46 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Frysinger <vapier@gentoo.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Richard Weinberger <richard@nod.at>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] Fixes for common mistakes w/ for_each_process and
	task->mm
Message-ID: <20120208155946.GA17177@redhat.com>
References: <20120207064809.GA29061@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120207064809.GA29061@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07, Anton Vorontsov wrote:
>
> For sysrq case I kept the force_sig() usage, this is because in sysrq
> case I belive we do want to kill PID namespace init processes.

Agreed,

> If using
> force_sig() is still a bad idea, I guess we should fix it somehow
> else.

Yes, I think it is simply wrong here. And I think that force_*
should not take the "struct task_struct *" argument, it should be
used for synchronous signals only.

I am thinking about the patch below. With this patch send_sig_all()
can use send_sig_info(SEND_SIG_FORCED). And probably send_sig_all()
doesn't need tasklist in this case.

I'll recheck this but I need to disappear until Friday, sorry.

Oleg.


--- x/kernel/signal.c
+++ x/kernel/signal.c
@@ -58,21 +58,20 @@ static int sig_handler_ignored(void __us
 		(handler == SIG_DFL && sig_kernel_ignore(sig));
 }
 
-static int sig_task_ignored(struct task_struct *t, int sig,
-		int from_ancestor_ns)
+static int sig_task_ignored(struct task_struct *t, int sig, bool force)
 {
 	void __user *handler;
 
 	handler = sig_handler(t, sig);
 
 	if (unlikely(t->signal->flags & SIGNAL_UNKILLABLE) &&
-			handler == SIG_DFL && !from_ancestor_ns)
+			handler == SIG_DFL && !force)
 		return 1;
 
 	return sig_handler_ignored(handler, sig);
 }
 
-static int sig_ignored(struct task_struct *t, int sig, int from_ancestor_ns)
+static int sig_ignored(struct task_struct *t, int sig, bool force)
 {
 	/*
 	 * Blocked signals are never ignored, since the
@@ -82,7 +81,7 @@ static int sig_ignored(struct task_struc
 	if (sigismember(&t->blocked, sig) || sigismember(&t->real_blocked, sig))
 		return 0;
 
-	if (!sig_task_ignored(t, sig, from_ancestor_ns))
+	if (!sig_task_ignored(t, sig, force))
 		return 0;
 
 	/*
@@ -855,7 +854,7 @@ static void ptrace_trap_notify(struct ta
  * Returns true if the signal should be actually delivered, otherwise
  * it should be dropped.
  */
-static int prepare_signal(int sig, struct task_struct *p, int from_ancestor_ns)
+static int prepare_signal(int sig, struct task_struct *p, bool force)
 {
 	struct signal_struct *signal = p->signal;
 	struct task_struct *t;
@@ -915,7 +914,7 @@ static int prepare_signal(int sig, struc
 		}
 	}
 
-	return !sig_ignored(p, sig, from_ancestor_ns);
+	return !sig_ignored(p, sig, force);
 }
 
 /*
@@ -1059,7 +1058,8 @@ static int __send_signal(int sig, struct
 
 	assert_spin_locked(&t->sighand->siglock);
 
-	if (!prepare_signal(sig, t, from_ancestor_ns))
+	if (!prepare_signal(sig, t,
+			from_ancestor_ns || (info == SEND_SIG_FORCED)))
 		return 0;
 
 	pending = group ? &t->signal->shared_pending : &t->pending;

