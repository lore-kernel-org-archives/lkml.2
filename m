Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932866Ab0IXQ3F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:29:05 -0400
Received: from kroah.org ([198.145.64.141]:38617 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932853Ab0IXQ3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:29:03 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:26:21 2010
Message-Id: <20100924162621.629274181@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:25:05 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Daniel J Blueman <daniel.blueman@gmail.com>,
        David Howells <dhowells@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [77/80] Fix unprotected access to task credentials in waitid()
In-Reply-To: <20100924162706.GA7381@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Daniel J Blueman <daniel.blueman@gmail.com>

commit f362b73244fb16ea4ae127ced1467dd8adaa7733 upstream.

Using a program like the following:

	#include <stdlib.h>
	#include <unistd.h>
	#include <sys/types.h>
	#include <sys/wait.h>

	int main() {
		id_t id;
		siginfo_t infop;
		pid_t res;

		id = fork();
		if (id == 0) { sleep(1); exit(0); }
		kill(id, SIGSTOP);
		alarm(1);
		waitid(P_PID, id, &infop, WCONTINUED);
		return 0;
	}

to call waitid() on a stopped process results in access to the child task's
credentials without the RCU read lock being held - which may be replaced in the
meantime - eliciting the following warning:

	===================================================
	[ INFO: suspicious rcu_dereference_check() usage. ]
	---------------------------------------------------
	kernel/exit.c:1460 invoked rcu_dereference_check() without protection!

	other info that might help us debug this:

	rcu_scheduler_active = 1, debug_locks = 1
	2 locks held by waitid02/22252:
	 #0:  (tasklist_lock){.?.?..}, at: [<ffffffff81061ce5>] do_wait+0xc5/0x310
	 #1:  (&(&sighand->siglock)->rlock){-.-...}, at: [<ffffffff810611da>]
	wait_consider_task+0x19a/0xbe0

	stack backtrace:
	Pid: 22252, comm: waitid02 Not tainted 2.6.35-323cd+ #3
	Call Trace:
	 [<ffffffff81095da4>] lockdep_rcu_dereference+0xa4/0xc0
	 [<ffffffff81061b31>] wait_consider_task+0xaf1/0xbe0
	 [<ffffffff81061d15>] do_wait+0xf5/0x310
	 [<ffffffff810620b6>] sys_waitid+0x86/0x1f0
	 [<ffffffff8105fce0>] ? child_wait_callback+0x0/0x70
	 [<ffffffff81003282>] system_call_fastpath+0x16/0x1b

This is fixed by holding the RCU read lock in wait_task_continued() to ensure
that the task's current credentials aren't destroyed between us reading the
cred pointer and us reading the UID from those credentials.

Furthermore, protect wait_task_stopped() in the same way.

We don't need to keep holding the RCU read lock once we've read the UID from
the credentials as holding the RCU read lock doesn't stop the target task from
changing its creds under us - so the credentials may be outdated immediately
after we've read the pointer, lock or no lock.

Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/exit.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1383,8 +1383,7 @@ static int wait_task_stopped(struct wait
 	if (!unlikely(wo->wo_flags & WNOWAIT))
 		*p_code = 0;
 
-	/* don't need the RCU readlock here as we're holding a spinlock */
-	uid = __task_cred(p)->uid;
+	uid = task_uid(p);
 unlock_sig:
 	spin_unlock_irq(&p->sighand->siglock);
 	if (!exit_code)
@@ -1457,7 +1456,7 @@ static int wait_task_continued(struct wa
 	}
 	if (!unlikely(wo->wo_flags & WNOWAIT))
 		p->signal->flags &= ~SIGNAL_STOP_CONTINUED;
-	uid = __task_cred(p)->uid;
+	uid = task_uid(p);
 	spin_unlock_irq(&p->sighand->siglock);
 
 	pid = task_pid_vnr(p);


