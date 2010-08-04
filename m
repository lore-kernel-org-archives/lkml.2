Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932854Ab0HDOB4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 10:01:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52549 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932679Ab0HDOBx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 10:01:53 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100804131749.GA2139@redhat.com>
References: <20100804131749.GA2139@redhat.com> <20100729114549.29508.44899.stgit@warthog.procyon.org.uk> <20100729114555.29508.4525.stgit@warthog.procyon.org.uk> <20100802204000.GH2405@linux.vnet.ibm.com> <201008030055.o730tgXK091413@www262.sakura.ne.jp> <30552.1280828047@redhat.com> <AANLkTikwM0+cxJqgQ+N_svzyyc+FKreO8XPr8oYNh6OU@mail.gmail.com> 
To: Oleg Nesterov <oleg@redhat.com>
Cc: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Jiri Olsa <jolsa@redhat.com>, Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH 2/2] CRED: Fix __task_cred()'s lockdep check and banner comment
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Date: Wed, 04 Aug 2010 15:01:10 +0100
Message-ID: <23577.1280930470@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> wrote:

> On 08/03, Linus Torvalds wrote:
> >
> > On Tue, Aug 3, 2010 at 2:34 AM, David Howells <dhowells@redhat.com> wrote:
> > >
> > > A previous patch:
> > >
> > >        commit 8f92054e7ca1d3a3ae50fb42d2253ac8730d9b2a
> > >        Author: David Howells <dhowells@redhat.com>
> > >        Date:   Thu Jul 29 12:45:55 2010 +0100
> > >        Subject: CRED: Fix __task_cred()'s lockdep check and banner comment
> 
> I am not sure I understand this patch.

You are talking about the 'previous patch'?

> __task_cred() checks rcu_read_lock_held() || task_is_dead(), and
> task_is_dead(task) is ((task)->exit_state != 0).
> 
> OK, task_is_dead() is valid for, say, wait_task_zombie(). But
> wait_task_stopped() calls __task_cred(p) without rcu lock and p is alive.
> The code is correct, this thread can do nothing until we drop ->siglock.

The problem is that we have to tell lockdep this.  Just checking in
__task_cred() that siglock is held is insufficient.  That doesn't handle, say,
sys_setuid() from changing the credentials, and effectively skips the check in
places where it mustn't.

Similarly, having interrupts disabled on the CPU we're running on doesn't help
either, since it doesn't stop another CPU replacing those credentials.

There are ways of dealing with wait_task_stopped():

 (1) Place an rcu_read_lock()'d section around the call to __task_cred().

 (2) Make __task_cred()'s lockdep understand about the target task being
     stopped whilst we hold its siglock.

 (3) Don't use __task_cred(), but rather dereference the pointer directly:

	rcu_dereference_protected(p->real_cred,
				  lock_is_held(&p->sighand->siglock))

     (Possibly wrapped in a macro in linux/cred.h).

> > > It's may be that it would be better to add RCU read lock calls in
> > > group_send_sig_info() only, around the call to check_kill_permission().
> 
> I must admit, at first glance changing check_kill_permission() to take
> rcu lock looks better to me.

I think group_send_sig_info() would be better.  The only other caller of
c_k_p() already has to hold the RCU read lock for other reasons.

How about the attached patch then?

> > > On the other hand, some of the callers are either holding the RCU read
> > > lock already, or have disabled interrupts,
> 
> Hmm. So, local_irq_disable() "officially" blocks rcu? It does in practice
> (unless I missed the new version of RCU), but, say,  posix_timer_event()
> takes rcu_read_lock() exactly because I thought we shouldn't assume that
> irqs_disabled() acts as rcu_read_lock() ?

This CPU can't be preempted if it can't be interrupted, I think.

David
---
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] CRED: Fix RCU warning due to previous patch fixing __task_cred()'s checks

A previous patch:

	commit 8f92054e7ca1d3a3ae50fb42d2253ac8730d9b2a
	Author: David Howells <dhowells@redhat.com>
	Date:   Thu Jul 29 12:45:55 2010 +0100
	Subject: CRED: Fix __task_cred()'s lockdep check and banner comment

fixed the lockdep checks on __task_cred().  This has shown up a place in the
signalling code where a lock should be held - namely that
check_kill_permission() requires its callers to hold the RCU lock.

Fix group_send_sig_info() to get the RCU read lock around its call to
check_kill_permission().

Without this patch, the following warning can occur:

[  140.173556] ===================================================
[  140.215379] [ INFO: suspicious rcu_dereference_check() usage. ]
[  140.216461] ---------------------------------------------------
[  140.217530] kernel/signal.c:660 invoked rcu_dereference_check() without protection!
[  140.218937]
[  140.218938] other info that might help us debug this:
[  140.218939]
[  140.220508]
[  140.220509] rcu_scheduler_active = 1, debug_locks = 1
[  140.221991] 1 lock held by init/1:
[  140.222668]  #0:  (tasklist_lock){.+.+..}, at: [<c104a0ac>] kill_something_info+0x7c/0x160
[  140.224709]
[  140.224711] stack backtrace:
[  140.225661] Pid: 1, comm: init Not tainted 2.6.35 #1
[  140.226576] Call Trace:
[  140.227111]  [<c103cca8>] ? printk+0x18/0x20
[  140.227908]  [<c1069884>] lockdep_rcu_dereference+0x94/0xb0
[  140.228931]  [<c104936a>] check_kill_permission+0x15a/0x170
[  140.229932]  [<c104a0ac>] ? kill_something_info+0x7c/0x160
[  140.230921]  [<c1049cca>] group_send_sig_info+0x1a/0x50
[  140.231866]  [<c1049d36>] __kill_pgrp_info+0x36/0x60
[  140.232780]  [<c104a0d0>] kill_something_info+0xa0/0x160
[  140.233740]  [<c10831c5>] ? __call_rcu+0xa5/0x110
[  140.234596]  [<c104b7ee>] sys_kill+0x5e/0x70
[  140.235387]  [<c10d1eee>] ? mntput_no_expire+0x1e/0xa0
[  140.236329]  [<c10bbd10>] ? __fput+0x170/0x220
[  140.257756]  [<c10bbdd9>] ? fput+0x19/0x20
[  140.258529]  [<c137ad94>] ? restore_all_notrace+0x0/0x18
[  140.259496]  [<c11bfb04>] ? trace_hardirqs_on_thunk+0xc/0x10
[  140.260531]  [<c137ad61>] syscall_call+0x7/0xb
[  144.627841] nfsd: last server has exited, flushing export cache
[  154.040420] Restarting system.
[  154.041061] machine restart

Reported-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 kernel/signal.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)


diff --git a/kernel/signal.c b/kernel/signal.c
index 906ae5a..bded651 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -637,7 +637,7 @@ static inline bool si_fromuser(const struct siginfo *info)
 
 /*
  * Bad permissions for sending the signal
- * - the caller must hold at least the RCU read lock
+ * - the caller must hold the RCU read lock
  */
 static int check_kill_permission(int sig, struct siginfo *info,
 				 struct task_struct *t)
@@ -1127,11 +1127,14 @@ struct sighand_struct *lock_task_sighand(struct task_struct *tsk, unsigned long
 
 /*
  * send signal info to all the members of a group
- * - the caller must hold the RCU read lock at least
  */
 int group_send_sig_info(int sig, struct siginfo *info, struct task_struct *p)
 {
-	int ret = check_kill_permission(sig, info, p);
+	int ret;
+
+	rcu_read_lock();
+	ret = check_kill_permission(sig, info, p);
+	rcu_read_unlock();
 
 	if (!ret && sig)
 		ret = do_send_sig_info(sig, info, p, true);
