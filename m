Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932883Ab2LMOKe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:10:34 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44751 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932853Ab2LMOKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:10:30 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mike Galbraith <efault@gmx.de>, Yong Zhang <yong.zhang0@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 156/241] Revert "sched, autogroup: Stop going ahead if autogroup is disabled"
Date: Thu, 13 Dec 2012 11:58:41 -0200
Message-Id: <1355407206-17100-157-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Galbraith <efault@gmx.de>

commit fd8ef11730f1d03d5d6555aa53126e9e34f52f12 upstream.

This reverts commit 800d4d30c8f20bd728e5741a3b77c4859a613f7c.

Between commits 8323f26ce342 ("sched: Fix race in task_group()") and
800d4d30c8f2 ("sched, autogroup: Stop going ahead if autogroup is
disabled"), autogroup is a wreck.

With both applied, all you have to do to crash a box is disable
autogroup during boot up, then reboot..  boom, NULL pointer dereference
due to commit 800d4d30c8f2 not allowing autogroup to move things, and
commit 8323f26ce342 making that the only way to switch runqueues:

  BUG: unable to handle kernel NULL pointer dereference at           (null)
  IP: [<ffffffff81063ac0>] effective_load.isra.43+0x50/0x90
  Pid: 7047, comm: systemd-user-se Not tainted 3.6.8-smp #7 MEDIONPC MS-7502/MS-7502
  RIP: effective_load.isra.43+0x50/0x90
  Process systemd-user-se (pid: 7047, threadinfo ffff880221dde000, task ffff88022618b3a0)
  Call Trace:
    select_task_rq_fair+0x255/0x780
    try_to_wake_up+0x156/0x2c0
    wake_up_state+0xb/0x10
    signal_wake_up+0x28/0x40
    complete_signal+0x1d6/0x250
    __send_signal+0x170/0x310
    send_signal+0x40/0x80
    do_send_sig_info+0x47/0x90
    group_send_sig_info+0x4a/0x70
    kill_pid_info+0x3a/0x60
    sys_kill+0x97/0x1a0
    ? vfs_read+0x120/0x160
    ? sys_read+0x45/0x90
    system_call_fastpath+0x16/0x1b
  Code: 49 0f af 41 50 31 d2 49 f7 f0 48 83 f8 01 48 0f 46 c6 48 2b 07 48 8b bf 40 01 00 00 48 85 ff 74 3a 45 31 c0 48 8b 8f 50 01 00 00 <48> 8b 11 4c 8b 89 80 00 00 00 49 89 d2 48 01 d0 45 8b 59 58 4c
  RIP  [<ffffffff81063ac0>] effective_load.isra.43+0x50/0x90
   RSP <ffff880221ddfbd8>
  CR2: 0000000000000000

Signed-off-by: Mike Galbraith <efault@gmx.de>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Yong Zhang <yong.zhang0@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 kernel/sched/auto_group.c |    4 ----
 kernel/sched/auto_group.h |    5 -----
 2 files changed, 9 deletions(-)

diff --git a/kernel/sched/auto_group.c b/kernel/sched/auto_group.c
index 0984a21..15f60d0 100644
--- a/kernel/sched/auto_group.c
+++ b/kernel/sched/auto_group.c
@@ -143,15 +143,11 @@ autogroup_move_group(struct task_struct *p, struct autogroup *ag)
 
 	p->signal->autogroup = autogroup_kref_get(ag);
 
-	if (!ACCESS_ONCE(sysctl_sched_autogroup_enabled))
-		goto out;
-
 	t = p;
 	do {
 		sched_move_task(t);
 	} while_each_thread(p, t);
 
-out:
 	unlock_task_sighand(p, &flags);
 	autogroup_kref_put(prev);
 }
diff --git a/kernel/sched/auto_group.h b/kernel/sched/auto_group.h
index 8bd0471..443232e 100644
--- a/kernel/sched/auto_group.h
+++ b/kernel/sched/auto_group.h
@@ -4,11 +4,6 @@
 #include <linux/rwsem.h>
 
 struct autogroup {
-	/*
-	 * reference doesn't mean how many thread attach to this
-	 * autogroup now. It just stands for the number of task
-	 * could use this autogroup.
-	 */
 	struct kref		kref;
 	struct task_group	*tg;
 	struct rw_semaphore	lock;
-- 
1.7.9.5

