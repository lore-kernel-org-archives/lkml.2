Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932245Ab0HCQJF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 12:09:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56556 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757023Ab0HCQJD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 12:09:03 -0400
MIME-Version: 1.0
In-Reply-To: <30552.1280828047@redhat.com>
References: <20100729114549.29508.44899.stgit@warthog.procyon.org.uk> 
	<20100729114555.29508.4525.stgit@warthog.procyon.org.uk> <20100802204000.GH2405@linux.vnet.ibm.com> 
	<201008030055.o730tgXK091413@www262.sakura.ne.jp> <30552.1280828047@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 3 Aug 2010 09:07:55 -0700
Message-ID: <AANLkTikwM0+cxJqgQ+N_svzyyc+FKreO8XPr8oYNh6OU@mail.gmail.com>
Subject: Re: [PATCH 2/2] CRED: Fix __task_cred()'s lockdep check and banner 
	comment
To: David Howells <dhowells@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Jiri Olsa <jolsa@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added Oleg and Thomas to the participants.

Oleg/Thomas: the whole thread is on lkml, but I'm quoting most of the
relevant parts..

On Tue, Aug 3, 2010 at 2:34 AM, David Howells <dhowells@redhat.com> wrote:
>
> A previous patch:
>
>        commit 8f92054e7ca1d3a3ae50fb42d2253ac8730d9b2a
>        Author: David Howells <dhowells@redhat.com>
>        Date:   Thu Jul 29 12:45:55 2010 +0100
>        Subject: CRED: Fix __task_cred()'s lockdep check and banner comment
>
> fixed the lockdep checks on __task_cred().  This has shown up a place in the
> signalling code where a lock should be held - namely that
> check_kill_permission() requires its callers to hold the RCU lock.

It's not just check_kill_permission(), is it? I thought we could do
the "for_each_process()" loops with just RCU, rather than holding the
whole tasklist_lock? So I _think_ that getting the RCU read-lock would
make it possible to get rid of the tasklist_lock in there too? At
least in kill_something_info().

Yes/no? What am I missing? This is an Oleg question, mainly.

> It's may be that it would be better to add RCU read lock calls in
> group_send_sig_info() only, around the call to check_kill_permission().  On the
> other hand, some of the callers are either holding the RCU read lock already,
> or have disabled interrupts, in which case, it's just extra overhead to do it
> in g_s_s_i().
>
> Without this patch, the following warning can occur:
>
> [  140.173556] ===================================================
> [  140.215379] [ INFO: suspicious rcu_dereference_check() usage. ]
> [  140.216461] ---------------------------------------------------
> [  140.217530] kernel/signal.c:660 invoked rcu_dereference_check() without protection!
> [  140.218937]
> [  140.218938] other info that might help us debug this:
> [  140.218939]
> [  140.220508]
> [  140.220509] rcu_scheduler_active = 1, debug_locks = 1
> [  140.221991] 1 lock held by init/1:
> [  140.222668]  #0:  (tasklist_lock){.+.+..}, at: [<c104a0ac>] kill_something_info+0x7c/0x160
> [  140.224709]
> [  140.224711] stack backtrace:
> [  140.225661] Pid: 1, comm: init Not tainted 2.6.35 #1
> [  140.226576] Call Trace:
> [  140.227111]  [<c103cca8>] ? printk+0x18/0x20
> [  140.227908]  [<c1069884>] lockdep_rcu_dereference+0x94/0xb0
> [  140.228931]  [<c104936a>] check_kill_permission+0x15a/0x170
> [  140.229932]  [<c104a0ac>] ? kill_something_info+0x7c/0x160
> [  140.230921]  [<c1049cca>] group_send_sig_info+0x1a/0x50
> [  140.231866]  [<c1049d36>] __kill_pgrp_info+0x36/0x60
> [  140.232780]  [<c104a0d0>] kill_something_info+0xa0/0x160
> [  140.233740]  [<c10831c5>] ? __call_rcu+0xa5/0x110
> [  140.234596]  [<c104b7ee>] sys_kill+0x5e/0x70
> [  140.235387]  [<c10d1eee>] ? mntput_no_expire+0x1e/0xa0
> [  140.236329]  [<c10bbd10>] ? __fput+0x170/0x220
> [  140.257756]  [<c10bbdd9>] ? fput+0x19/0x20
> [  140.258529]  [<c137ad94>] ? restore_all_notrace+0x0/0x18
> [  140.259496]  [<c11bfb04>] ? trace_hardirqs_on_thunk+0xc/0x10
> [  140.260531]  [<c137ad61>] syscall_call+0x7/0xb
> [  144.627841] nfsd: last server has exited, flushing export cache
> [  154.040420] Restarting system.
> [  154.041061] machine restart
>
> Reported-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
>
>  kernel/exit.c   |    2 ++
>  kernel/signal.c |    8 ++++++--
>  2 files changed, 8 insertions(+), 2 deletions(-)
>
>
> diff --git a/kernel/exit.c b/kernel/exit.c
> index ceffc67..7858ebf 100644
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -773,6 +773,7 @@ static void forget_original_parent(struct task_struct *father)
>
>        exit_ptrace(father);
>
> +       rcu_read_lock();
>        write_lock_irq(&tasklist_lock);
>        reaper = find_new_reaper(father);
>
> @@ -791,6 +792,7 @@ static void forget_original_parent(struct task_struct *father)
>                reparent_leader(father, p, &dead_children);
>        }
>        write_unlock_irq(&tasklist_lock);
> +       rcu_read_unlock();
>
>        BUG_ON(!list_empty(&father->children));
>
> diff --git a/kernel/signal.c b/kernel/signal.c
> index 906ae5a..f771156 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -637,7 +637,7 @@ static inline bool si_fromuser(const struct siginfo *info)
>
>  /*
>  * Bad permissions for sending the signal
> - * - the caller must hold at least the RCU read lock
> + * - the caller must hold the RCU read lock
>  */
>  static int check_kill_permission(int sig, struct siginfo *info,
>                                 struct task_struct *t)
> @@ -1127,7 +1127,7 @@ struct sighand_struct *lock_task_sighand(struct task_struct *tsk, unsigned long
>
>  /*
>  * send signal info to all the members of a group
> - * - the caller must hold the RCU read lock at least
> + * - the caller must hold the RCU read lock
>  */
>  int group_send_sig_info(int sig, struct siginfo *info, struct task_struct *p)
>  {
> @@ -1151,11 +1151,13 @@ int __kill_pgrp_info(int sig, struct siginfo *info, struct pid *pgrp)
>
>        success = 0;
>        retval = -ESRCH;
> +       rcu_read_lock();
>        do_each_pid_task(pgrp, PIDTYPE_PGID, p) {
>                int err = group_send_sig_info(sig, info, p);
>                success |= !err;
>                retval = err;
>        } while_each_pid_task(pgrp, PIDTYPE_PGID, p);
> +       rcu_read_unlock();

Ok, makes sense. At the same time, I do wonder if we shouldn't perhaps
do this in the caller. The callers would seem to all want it - look at
kill_something_info(), for example, where it really looks like it
would be nicer to put that _whole_ function under rcu_read_lock() (in
the caller itself). Or in kernel/exit.c, we have two calls
back-to-back, so doing it in the caller would clean that up and do it
just once.

Look here:

> @@ -1261,6 +1263,7 @@ static int kill_something_info(int sig, struct siginfo *info, pid_t pid)
>                int retval = 0, count = 0;
>                struct task_struct * p;
>
> +               rcu_read_lock();
>                for_each_process(p) {
>                        if (task_pid_vnr(p) > 1 &&
>                                        !same_thread_group(p, current)) {
> @@ -1270,6 +1273,7 @@ static int kill_something_info(int sig, struct siginfo *info, pid_t pid)
>                                        retval = err;
>                        }
>                }
> +               rcu_read_unlock();
>                ret = count ? retval : -ESRCH;
>        }
>        read_unlock(&tasklist_lock);

with those fragments, we now end up having rcu_read_lock() for _all_
the three cases in kill_something_info(), but rather than do it once,
we do it explicitly, and we do it in two different ways (two cases do
it explicitly, the middle one does it implicitly when it calls
__kill_pgrp_info().

So I think the patch is correct, but at the same time I do get the
feeling that we should just do it slightly differently.

Comments?

            Linus
