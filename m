Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756643Ab2FNRWY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 13:22:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2173 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756541Ab2FNRWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 13:22:23 -0400
Date: Thu, 14 Jun 2012 19:20:13 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Louis Rilling <louis.rilling@kerlabs.com>,
        Mike Galbraith <efault@gmx.de>, Pavel Emelyanov <xemul@parallels.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] pidns: guarantee that the pidns init will be the
	last pidns process reaped
Message-ID: <20120614172013.GA6635@redhat.com>
References: <20120530175745.GA19327@redhat.com> <20120530181429.GA19989@redhat.com> <20120530181500.GA20130@redhat.com> <20120613145248.f5caab7e.akpm@linux-foundation.org> <87bokmoo01.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bokmoo01.fsf@xmission.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13, Eric W. Biederman wrote:
>
> Andrew Morton <akpm@linux-foundation.org> writes:
>
> > <looks at the locking a bit>
> >
> > <gets distracted>
> >
> > That tty_kref_put() in __exit_signal() is running with tasklist_lock
> > held, yes?  It does a ton of work and calls out to random drivers and
> > none of this needs tasklist_lock.  Seems risky.
>
> Interesting.  That tty_kref_put does sound like an area where the
> locking can be simplified.  At the same time tty_kref_put does make
> sense from exit signal.  As ttys and signals are intimately intertwined.

This was introduced in 2008, 9c9f4ded90a59eee84e15f5fd38c03d60184e112

Nobody complained so far... but I agree this doesn't look very good.
At first glance it is simle to move this kref_put() outside of
tasklist_lock. Something like below.

But I'll re-check. And I guess the patch can be simpler/cleaner.
Say, __exit_signal() can return tty or group_dead.

Oleg.

--- x/kernel/exit.c
+++ x/kernel/exit.c
@@ -79,12 +79,11 @@ static void __unhash_process(struct task
 /*
  * This function expects the tasklist_lock write-locked.
  */
-static void __exit_signal(struct task_struct *tsk)
+static void __exit_signal(struct task_struct *tsk, struct tty_struct **ptty)
 {
 	struct signal_struct *sig = tsk->signal;
 	bool group_dead = thread_group_leader(tsk);
 	struct sighand_struct *sighand;
-	struct tty_struct *uninitialized_var(tty);
 
 	sighand = rcu_dereference_check(tsk->sighand,
 					lockdep_tasklist_lock_is_held());
@@ -93,7 +92,7 @@ static void __exit_signal(struct task_st
 	posix_cpu_timers_exit(tsk);
 	if (group_dead) {
 		posix_cpu_timers_exit_group(tsk);
-		tty = sig->tty;
+		*ptty = sig->tty;
 		sig->tty = NULL;
 	} else {
 		/*
@@ -149,10 +148,8 @@ static void __exit_signal(struct task_st
 
 	__cleanup_sighand(sighand);
 	clear_tsk_thread_flag(tsk,TIF_SIGPENDING);
-	if (group_dead) {
+	if (group_dead)
 		flush_sigqueue(&sig->shared_pending);
-		tty_kref_put(tty);
-	}
 }
 
 static void delayed_put_task_struct(struct rcu_head *rhp)
@@ -167,6 +164,7 @@ static void delayed_put_task_struct(stru
 
 void release_task(struct task_struct * p)
 {
+	struct tty_struct *tty = NULL;
 	struct task_struct *leader;
 	int zap_leader;
 repeat:
@@ -180,7 +178,7 @@ repeat:
 
 	write_lock_irq(&tasklist_lock);
 	ptrace_release_task(p);
-	__exit_signal(p);
+	__exit_signal(p, &tty);
 
 	/*
 	 * If we are the last non-leader member of the thread
@@ -207,6 +205,8 @@ repeat:
 	p = leader;
 	if (unlikely(zap_leader))
 		goto repeat;
+
+	tty_kref_put(tty);
 }
 
 /*

