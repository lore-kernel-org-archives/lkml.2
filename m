Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932576Ab2L1TVf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:21:35 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55725 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932418Ab2L1TT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:19:59 -0500
Message-Id: <20121228190335.659874461@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:03:57 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@kernel.org>,
        Yong Zhang <yong.zhang0@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 027/173] Revert "sched, autogroup: Stop going ahead if autogroup is disabled"
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust filenames]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/kernel/sched_autogroup.c
+++ b/kernel/sched_autogroup.c
@@ -160,15 +160,11 @@ autogroup_move_group(struct task_struct
 
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
--- a/kernel/sched_autogroup.h
+++ b/kernel/sched_autogroup.h
@@ -1,11 +1,6 @@
 #ifdef CONFIG_SCHED_AUTOGROUP
 
 struct autogroup {
-	/*
-	 * reference doesn't mean how many thread attach to this
-	 * autogroup now. It just stands for the number of task
-	 * could use this autogroup.
-	 */
 	struct kref		kref;
 	struct task_group	*tg;
 	struct rw_semaphore	lock;


