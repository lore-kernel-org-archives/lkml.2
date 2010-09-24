Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751Ab0IXQzr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:55:47 -0400
Received: from kroah.org ([198.145.64.141]:38311 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932641Ab0IXQ2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:28:20 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:26:17 2010
Message-Id: <20100924162617.684393012@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:24:20 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Jiri Slaby <jslaby@suse.cz>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [32/80] pid: make setpgid() system call use RCU read-side critical section
In-Reply-To: <20100924162706.GA7381@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

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
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/sys.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -931,6 +931,7 @@ SYSCALL_DEFINE2(setpgid, pid_t, pid, pid
 		pgid = pid;
 	if (pgid < 0)
 		return -EINVAL;
+	rcu_read_lock();
 
 	/* From this point forward we keep holding onto the tasklist lock
 	 * so that our parent does not change from under us. -DaveM
@@ -984,6 +985,7 @@ SYSCALL_DEFINE2(setpgid, pid_t, pid, pid
 out:
 	/* All paths lead to here, thus we are safe. -DaveM */
 	write_unlock_irq(&tasklist_lock);
+	rcu_read_unlock();
 	return err;
 }
 


