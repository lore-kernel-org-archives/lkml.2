Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756462Ab0KYBgI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 20:36:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48779 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753348Ab0KYBgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 20:36:07 -0500
Date: Wed, 24 Nov 2010 20:35:57 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: rcu_read_lock/unlock protect find_task_by_vpid call in check_clock
Message-ID: <20101125013557.GB2854@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
References: <20101125010948.GA1371@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101125010948.GA1371@redhat.com>
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
1 lock held by scrashme/13382:
 #0:  (tasklist_lock){.?.?..}, at: [<ffffffff8106ddea>] check_clock+0x46/0x9a

stack backtrace:
Pid: 13382, comm: scrashme Not tainted 2.6.37-rc3+ #8
Call Trace:
 [<ffffffff8107cfe1>] lockdep_rcu_dereference+0x9d/0xa5
 [<ffffffff81069d08>] find_task_by_pid_ns+0x44/0x5d
 [<ffffffff81069d43>] find_task_by_vpid+0x22/0x24
 [<ffffffff8106ddf2>] check_clock+0x4e/0x9a
 [<ffffffff8106deac>] posix_cpu_clock_getres+0x16/0x41
 [<ffffffff8106be74>] sys_clock_getres+0x39/0xa0
 [<ffffffff81009cb2>] system_call_fastpath+0x16/0x1b

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 6842eeb..4bef9aa 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -38,11 +38,13 @@ static int check_clock(const clockid_t which_clock)
 		return 0;
 
 	read_lock(&tasklist_lock);
+	rcu_read_lock();
 	p = find_task_by_vpid(pid);
 	if (!p || !(CPUCLOCK_PERTHREAD(which_clock) ?
 		   same_thread_group(p, current) : thread_group_leader(p))) {
 		error = -EINVAL;
 	}
+	rcu_read_unlock();
 	read_unlock(&tasklist_lock);
 
 	return error;

