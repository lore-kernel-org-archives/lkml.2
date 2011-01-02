Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553Ab1ABHmN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:42:13 -0500
Received: from mail.windriver.com ([147.11.1.11]:36570 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070Ab1ABHYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:24:44 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Daniel J Blueman <daniel.blueman@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 150/260] Fix unprotected access to task credentials in waitid()
Date: Sun,  2 Jan 2011 02:17:26 -0500
Message-Id: <1293952756-15010-151-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:22:55.0165 (UTC) FILETIME=[DFA6DED0:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/exit.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 7f2683a..b0242b4 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1392,8 +1392,7 @@ static int wait_task_stopped(struct wait_opts *wo,
 	if (!unlikely(wo->wo_flags & WNOWAIT))
 		*p_code = 0;
 
-	/* don't need the RCU readlock here as we're holding a spinlock */
-	uid = __task_cred(p)->uid;
+	uid = task_uid(p);
 unlock_sig:
 	spin_unlock_irq(&p->sighand->siglock);
 	if (!exit_code)
@@ -1466,7 +1465,7 @@ static int wait_task_continued(struct wait_opts *wo, struct task_struct *p)
 	}
 	if (!unlikely(wo->wo_flags & WNOWAIT))
 		p->signal->flags &= ~SIGNAL_STOP_CONTINUED;
-	uid = __task_cred(p)->uid;
+	uid = task_uid(p);
 	spin_unlock_irq(&p->sighand->siglock);
 
 	pid = task_pid_vnr(p);
-- 
1.7.3.3

