Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109Ab1ABHXx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:23:53 -0500
Received: from mail.windriver.com ([147.11.1.11]:35798 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017Ab1ABHXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:23:44 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 128/260] pid: make setpgid() system call use RCU read-side critical section
Date: Sun,  2 Jan 2011 02:17:04 -0500
Message-Id: <1293952756-15010-129-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:22:29.0649 (UTC) FILETIME=[D0717010:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

commit 950eaaca681c44aab87a46225c9e44f902c080aa upstream.

[   23.584719]
[   23.584720] ===================================================
[   23.585059] [ INFO: suspicious rcu_dereference_check() usage. ]
[   23.585176] ---------------------------------------------------
[   23.585176] kernel/pid.c:419 invoked rcu_dereference_check() without protection!
[   23.585176]
[   23.585176] other info that might help us debug this:
[   23.585176]
[   23.585176]
[   23.585176] rcu_scheduler_active = 1, debug_locks = 1
[   23.585176] 1 lock held by rc.sysinit/728:
[   23.585176]  #0:  (tasklist_lock){.+.+..}, at: [<ffffffff8104771f>] sys_setpgid+0x5f/0x193
[   23.585176]
[   23.585176] stack backtrace:
[   23.585176] Pid: 728, comm: rc.sysinit Not tainted 2.6.36-rc2 #2
[   23.585176] Call Trace:
[   23.585176]  [<ffffffff8105b436>] lockdep_rcu_dereference+0x99/0xa2
[   23.585176]  [<ffffffff8104c324>] find_task_by_pid_ns+0x50/0x6a
[   23.585176]  [<ffffffff8104c35b>] find_task_by_vpid+0x1d/0x1f
[   23.585176]  [<ffffffff81047727>] sys_setpgid+0x67/0x193
[   23.585176]  [<ffffffff810029eb>] system_call_fastpath+0x16/0x1b
[   24.959669] type=1400 audit(1282938522.956:4): avc:  denied  { module_request } for  pid=766 comm="hwclock" kmod="char-major-10-135" scontext=system_u:system_r:hwclock_t:s0 tcontext=system_u:system_r:kernel_t:s0 tclas

It turns out that the setpgid() system call fails to enter an RCU
read-side critical section before doing a PID-to-task_struct translation.
This commit therefore does rcu_read_lock() before the translation, and
also does rcu_read_unlock() after the last use of the returned pointer.

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/sys.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index 7cb426a..0324c1c 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -962,6 +962,7 @@ SYSCALL_DEFINE2(setpgid, pid_t, pid, pid_t, pgid)
 		pgid = pid;
 	if (pgid < 0)
 		return -EINVAL;
+	rcu_read_lock();
 
 	/* From this point forward we keep holding onto the tasklist lock
 	 * so that our parent does not change from under us. -DaveM
@@ -1015,6 +1016,7 @@ SYSCALL_DEFINE2(setpgid, pid_t, pid, pid_t, pgid)
 out:
 	/* All paths lead to here, thus we are safe. -DaveM */
 	write_unlock_irq(&tasklist_lock);
+	rcu_read_unlock();
 	return err;
 }
 
-- 
1.7.3.3

