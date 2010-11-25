Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430Ab0KYBKA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 20:10:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9451 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751367Ab0KYBJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 20:09:59 -0500
Date: Wed, 24 Nov 2010 20:09:48 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: rcu_read_lock/unlock protect find_task_by_vpid call in
 posix_cpu_timer_create
Message-ID: <20101125010948.GA1371@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

===================================================
[ INFO: suspicious rcu_dereference_check() usage. ]
---------------------------------------------------
kernel/pid.c:419 invoked rcu_dereference_check() without protection!

other info that might help us debug this:


rcu_scheduler_active = 1, debug_locks = 1
1 lock held by scrashme/20820:
 #0:  (tasklist_lock){.?.?..}, at: [<ffffffff8106e30f>] posix_cpu_timer_create+0x50/0xee

stack backtrace:
Pid: 20820, comm: scrashme Not tainted 2.6.37-rc3+ #7
Call Trace:
 [<ffffffff8107cfd5>] lockdep_rcu_dereference+0x9d/0xa5
 [<ffffffff81069d08>] find_task_by_pid_ns+0x44/0x5d
 [<ffffffff81069d43>] find_task_by_vpid+0x22/0x24
 [<ffffffff8106e32d>] posix_cpu_timer_create+0x6e/0xee
 [<ffffffff8106eb88>] do_cpu_nanosleep+0x83/0x1ad
 [<ffffffff8106f50a>] posix_cpu_nsleep+0x6d/0xf6
 [<ffffffff810f9a64>] ? might_fault+0xa5/0xac
 [<ffffffff810f9a1b>] ? might_fault+0x5c/0xac
 [<ffffffff8106bf57>] sys_clock_nanosleep+0x7c/0xcb
 [<ffffffff81009cb2>] system_call_fastpath+0x16/0x1b

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 6842eeb..2658955 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -391,6 +391,7 @@ int posix_cpu_timer_create(struct k_itimer *new_timer)
 	INIT_LIST_HEAD(&new_timer->it.cpu.entry);
 
 	read_lock(&tasklist_lock);
+	rcu_read_lock();
 	if (CPUCLOCK_PERTHREAD(new_timer->it_clock)) {
 		if (pid == 0) {
 			p = current;
@@ -414,6 +415,7 @@ int posix_cpu_timer_create(struct k_itimer *new_timer)
 	} else {
 		ret = -EINVAL;
 	}
+	rcu_read_unlock();
 	read_unlock(&tasklist_lock);
 
 	return ret;
