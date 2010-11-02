Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751488Ab0KBMPg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 08:15:36 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48033 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835Ab0KBMPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 08:15:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=aQA/OrSsktufVMnLA8GuWkTZBf5DVGKglCtRgf3+MeOFn+V1MZzSGjgxbHjbltSTxY
         UIRmRYe0WB7uDc6kmdVX/avBXhkG5zXHFDLuQH7oTpDHRpQhJt0QqBo1u0SwF3SAZXAT
         zlqatFFr2/Xs4jlBC3beHwSyaxTKg85nxRryY=
MIME-Version: 1.0
Date: Tue, 2 Nov 2010 12:15:30 +0000
Message-ID: <AANLkTi=xj6xW5SnrdQos4P-MtJP8+fwfaa3r7LPfdLh4@mail.gmail.com>
Subject: [2.6.37-rc1] sys_ioprio_set and RCU locking...
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With 2.6.37-rc1, I observe sys_ioprio_set not taking the RCU lock [1]
across access to the task credentials.

Inspecting the code in fs/ioprio.c, the tasklist_lock is held for read
across the __task_cred call, which is presumably sufficient to prevent
the task credentials becoming stale.

Thus, is there preference to take the RCU lock for read across the
credential access eg at [2], or annotate the call?

Thanks,
  Daniel

--- [1]

===================================================

[ INFO: suspicious rcu_dereference_check() usage. ]

---------------------------------------------------

kernel/pid.c:419 invoked rcu_dereference_check() without protection!



other info that might help us debug this:




rcu_scheduler_active = 1, debug_locks = 1

1 lock held by start-stop-daem/2246:

 #0:  (tasklist_lock){.?.?..}, at: [<ffffffff811a2dfa>]
sys_ioprio_set+0x8a/0x400



stack backtrace:

Pid: 2246, comm: start-stop-daem Not tainted 2.6.37-rc1-330cd+ #2

Call Trace:

 [<ffffffff8109f5f4>] lockdep_rcu_dereference+0xa4/0xc0

 [<ffffffff81085651>] find_task_by_pid_ns+0x81/0x90

 [<ffffffff8108567d>] find_task_by_vpid+0x1d/0x20

 [<ffffffff811a3160>] sys_ioprio_set+0x3f0/0x400

 [<ffffffff816efa79>] ? trace_hardirqs_on_thunk+0x3a/0x3f

 [<ffffffff81003482>] system_call_fastpath+0x16/0x1b


--- [2]

Take the RCU lock for read across acquiring the pointer to the task
credentials and dereferencing it.

Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>

diff --git a/fs/ioprio.c b/fs/ioprio.c
index 748cfb9..00cc0e5 100644
--- a/fs/ioprio.c
+++ b/fs/ioprio.c
@@ -139,8 +139,10 @@ SYSCALL_DEFINE3(ioprio_set, int, which, int, who,
int, ioprio)
 				break;

 			do_each_thread(g, p) {
+				rcu_read_lock();
 				if (__task_cred(p)->uid != who)
 					continue;
+				rcu_read_unlock();
 				ret = set_task_ioprio(p, ioprio);
 				if (ret)
 					goto free_uid;
@@ -232,8 +234,10 @@ SYSCALL_DEFINE2(ioprio_get, int, which, int, who)
 				break;

 			do_each_thread(g, p) {
+				rcu_read_lock();
 				if (__task_cred(p)->uid != user->uid)
 					continue;
+				rcu_read_unlock();
 				tmpio = get_task_ioprio(p);
 				if (tmpio < 0)
 					continue;
-- 
Daniel J Blueman
