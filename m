Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516Ab0FYQIX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 12:08:23 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:57890 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756389Ab0FYQIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 12:08:22 -0400
To: paulmck@linux.vnet.ibm.com, mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.35-rc3] Add RCU check for find_task_by_vpid().
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <201006260108.JFJ86910.VMFOLOFFJOtSQH@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sat, 26 Jun 2010 01:08:19 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

find_task_by_vpid() says "Must be called under rcu_read_lock().". But due to
commit 3120438 "rcu: Disable lockdep checking in RCU list-traversal primitives",
we are currently unable to catch "find_task_by_vpid() with tasklist_lock held
but RCU lock not held" errors.

  ===================================================
  [ INFO: suspicious rcu_dereference_check() usage. ]
  ---------------------------------------------------
  kernel/pid.c:386 invoked rcu_dereference_check() without protection!
  
  other info that might help us debug this:
  
  
  rcu_scheduler_active = 1, debug_locks = 1
  1 lock held by rc.sysinit/1102:
   #0:  (tasklist_lock){.+.+..}, at: [<c1048340>] sys_setpgid+0x40/0x160
  
  stack backtrace:
  Pid: 1102, comm: rc.sysinit Not tainted 2.6.35-rc3-dirty #1
  Call Trace:
   [<c105e714>] lockdep_rcu_dereference+0x94/0xb0
   [<c104b4cd>] find_task_by_pid_ns+0x6d/0x70
   [<c104b4e8>] find_task_by_vpid+0x18/0x20
   [<c1048347>] sys_setpgid+0x47/0x160
   [<c1002b50>] sysenter_do_call+0x12/0x36

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
diff --git a/kernel/pid.c b/kernel/pid.c
index e9fd8c1..a257471 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -382,6 +382,9 @@ EXPORT_SYMBOL(pid_task);
  */
 struct task_struct *find_task_by_pid_ns(pid_t nr, struct pid_namespace *ns)
 {
+#ifdef __do_rcu_dereference_check
+	__do_rcu_dereference_check(rcu_read_lock_held());
+#endif
 	return pid_task(find_pid_ns(nr, ns), PIDTYPE_PID);
 }
 
