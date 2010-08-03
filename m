Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756458Ab0HCNcj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 09:32:39 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59961 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756413Ab0HCNce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 09:32:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=P1cVO9NAekablDWodZRP5kFsJpDnrExI6Rjr4szZO5v9w0ONlHcqkrUBikXnCpHOoj
         YasZwhmL1mKveGZjFzjJyZnZI6ZHN03YFBPmbtPx6Vkz0yQ/1U0JQNnrr0hPN2r+GcwL
         BfjcHOfaOPJfU4Vft2nN0li9nhbjYOqVz3Oro=
MIME-Version: 1.0
Date: Tue, 3 Aug 2010 14:32:32 +0100
Message-ID: <AANLkTim7JxJz2L27Nhr-BmJpDMY6LibGA8gvQB7Lsr8P@mail.gmail.com>
Subject: [2.6.36, patch] unprotected access to task credentials in waitid()
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calling waitid [1] on a stopped process results in access to the
task's credentials without the RCU read lock, which may change in the
meantime, eliciting a warning [2].

This is fixed by:

Ensure the task's credentials don't change before calling
wait_noreap_copyout via acquisition of the RCU read lock.

Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>

diff --git a/kernel/exit.c b/kernel/exit.c
index ceffc67..cc8b4b9 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1457,6 +1457,7 @@ static int wait_task_continued(struct wait_opts
*wo, struct task_struct *p)
 	}
 	if (!unlikely(wo->wo_flags & WNOWAIT))
 		p->signal->flags &= ~SIGNAL_STOP_CONTINUED;
+	rcu_read_lock();
 	uid = __task_cred(p)->uid;
 	spin_unlock_irq(&p->sighand->siglock);

@@ -1477,6 +1478,7 @@ static int wait_task_continued(struct wait_opts
*wo, struct task_struct *p)
 					     CLD_CONTINUED, SIGCONT);
 		BUG_ON(retval == 0);
 	}
+	rcu_read_unlock();

 	return retval;
 }

--- [1]

#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>

int main(void) {
	id_t id;
	siginfo_t infop;
	pid_t res;

	id = fork();
	if (id == 0) {
		sleep(1);
		exit(0);
	}

	kill(id, SIGSTOP);
	alarm(1);

	res = waitid(P_PID, id, &infop, WCONTINUED);

	return 0;
}

--- [2]

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
-- 
Daniel J Blueman
