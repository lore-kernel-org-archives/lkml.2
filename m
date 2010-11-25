Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755749Ab0KYAdv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 19:33:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4861 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753884Ab0KYAdu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 19:33:50 -0500
Date: Wed, 24 Nov 2010 19:33:39 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: linux-mm@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: rcu_read_lock/unlock protect find_task_by_vpid call in migrate_pages
Message-ID: <20101125003339.GB31301@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-mm@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
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
1 lock held by scrashme/11079:
 #0:  (tasklist_lock){.?.?..}, at: [<ffffffff81112702>] sys_migrate_pages+0xd6/0x29d

stack backtrace:
Pid: 11079, comm: scrashme Not tainted 2.6.37-rc3+ #2
Call Trace:
 [<ffffffff8107d095>] lockdep_rcu_dereference+0x9d/0xa5
 [<ffffffff81069dc8>] find_task_by_pid_ns+0x44/0x5d
 [<ffffffff81069e03>] find_task_by_vpid+0x22/0x24
 [<ffffffff8111270f>] sys_migrate_pages+0xe3/0x29d
 [<ffffffff8107c7c6>] ? trace_hardirqs_off_caller+0xa3/0x10b
 [<ffffffff8147b635>] ? retint_swapgs+0x13/0x1b
 [<ffffffff8107e2e7>] ? trace_hardirqs_on_caller+0x13f/0x172
 [<ffffffff8147a95c>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff81009cb2>] system_call_fastpath+0x16/0x1b

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 4a57f13..2f0f55b 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1308,6 +1308,7 @@ SYSCALL_DEFINE4(migrate_pages, pid_t, pid, unsigned long, maxnode,
 
 	/* Find the mm_struct */
 	read_lock(&tasklist_lock);
+	rcu_read_lock();
 	task = pid ? find_task_by_vpid(pid) : current;
 	if (!task) {
 		read_unlock(&tasklist_lock);
@@ -1315,6 +1316,7 @@ SYSCALL_DEFINE4(migrate_pages, pid_t, pid, unsigned long, maxnode,
 		goto out;
 	}
 	mm = get_task_mm(task);
+	rcu_read_unlock();
 	read_unlock(&tasklist_lock);
 
 	err = -EINVAL;
